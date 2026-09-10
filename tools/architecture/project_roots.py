#!/usr/bin/env python3
"""Exact production roots shared by current architecture source scanners."""

from __future__ import annotations

import tempfile
from pathlib import Path


PRODUCTION_ROOTS = ("ComputationalMathematics",)


def is_production_module(name: str) -> bool:
    return any(name == root or name.startswith(root + ".") for root in PRODUCTION_ROOTS)


def is_production_path(path: str) -> bool:
    return any(path == root + ".lean" or path.startswith(root + "/") for root in PRODUCTION_ROOTS)


def production_paths(root: Path) -> list[Path]:
    paths: list[Path] = []
    for name in PRODUCTION_ROOTS:
        entry = root / (name + ".lean")
        if entry.is_file():
            paths.append(entry)
        directory = root / name
        if directory.is_dir():
            paths.extend(directory.rglob("*.lean"))
    return sorted(paths, key=lambda path: path.relative_to(root).as_posix())


def self_test() -> list[str]:
    failures: list[str] = []
    for name in PRODUCTION_ROOTS:
        if not is_production_module(name) or not is_production_module(name + ".Leaf"):
            failures.append(f"production root or leaf not recognized: {name}")
        if not is_production_path(name + ".lean") or not is_production_path(name + "/Leaf.lean"):
            failures.append(f"production root or leaf path not recognized: {name}")
        if is_production_module(name + "Test.Leaf") or is_production_path(name + "Test/Leaf.lean"):
            failures.append(f"production root matching escaped its component boundary: {name}")
    with tempfile.TemporaryDirectory() as temporary:
        root = Path(temporary)
        expected: set[str] = set()
        # NumStabilityTest and ComputationalMathematicsExtra are the neighbours a
        # prefix match must not swallow: the test root and a longer name sharing
        # the production prefix. NumStability is included as a negative case even
        # though release 0.2.0 removed that tree, so a reintroduced forwarding
        # root cannot silently rejoin the production set.
        for name in (*PRODUCTION_ROOTS, "NumStability", "NumStabilityTest", "ComputationalMathematicsExtra"):
            (root / name).mkdir()
            for relative in (name + ".lean", name + "/Leaf.lean"):
                (root / relative).write_text("/-! Root discovery fixture. -/\n", encoding="utf-8")
                if name in PRODUCTION_ROOTS:
                    expected.add(relative)
        actual = {path.relative_to(root).as_posix() for path in production_paths(root)}
        if actual != expected:
            failures.append(f"source discovery differs: {actual ^ expected}")
    return failures


if __name__ == "__main__":
    problems = self_test()
    for problem in problems:
        print(f"error: {problem}")
    if not problems:
        print("production-root self-test passed: both roots, leaves, and component boundaries")
    raise SystemExit(bool(problems))
