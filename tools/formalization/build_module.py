#!/usr/bin/env python3
"""Elaborate a project module and every project module it imports.

`C:\\lcm-ch02` has no `.lake`, so modules are elaborated by calling `lean`
directly with `LEAN_PATH` pointing at the sibling checkout's package oleans plus
a short-path olean root of our own. `lean` will not chase project imports for
us, so this walks the import graph in the project tree and elaborates in
dependency order, skipping anything whose olean is already newer than its
source and than every source it depends on.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

IMPORT = re.compile(r"^import\s+(ComputationalMathematics[\w.]*)", re.MULTILINE)
ROOT = Path(__file__).resolve().parents[2]


def source_of(module: str) -> Path:
    return ROOT / (module.replace(".", "/") + ".lean")


def olean_of(module: str, out: Path) -> Path:
    return out / (module.replace(".", "/") + ".olean")


def imports_of(module: str) -> list[str]:
    path = source_of(module)
    if not path.is_file():
        return []
    text = path.read_text(encoding="utf-8")
    return [m for m in IMPORT.findall(text) if source_of(m).is_file()]


def order(roots: list[str]) -> list[str]:
    seen: set[str] = set()
    out: list[str] = []

    def visit(m: str, stack: tuple[str, ...]) -> None:
        if m in seen:
            return
        if m in stack:
            raise SystemExit(f"import cycle through {m}")
        for dep in imports_of(m):
            visit(dep, stack + (m,))
        seen.add(m)
        out.append(m)

    for r in roots:
        visit(r, ())
    return out


def stale(module: str, out: Path) -> bool:
    o = olean_of(module, out)
    if not o.is_file():
        return True
    ot = o.stat().st_mtime
    if source_of(module).stat().st_mtime > ot:
        return True
    return any(
        olean_of(d, out).stat().st_mtime > ot
        for d in imports_of(module)
        if olean_of(d, out).is_file()
    )


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("modules", nargs="+")
    ap.add_argument("--out", default=r"C:\lcm-oleans")
    ap.add_argument("--force", action="store_true")
    args = ap.parse_args()

    out = Path(args.out)
    failures = 0
    plan = order(args.modules)
    for module in plan:
        if not args.force and not stale(module, out):
            continue
        target = olean_of(module, out)
        target.parent.mkdir(parents=True, exist_ok=True)
        rel = source_of(module).relative_to(ROOT).as_posix()
        proc = subprocess.run(
            ["lean", f"--o={target}", rel],
            cwd=ROOT,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        note = (proc.stdout or "") + (proc.stderr or "")
        if proc.returncode != 0 or "error" in note:
            failures += 1
            print(f"FAIL {module}", flush=True)
            print(note.rstrip()[:4000], flush=True)
            if target.is_file():
                target.unlink()
        else:
            print(f"ok   {module}" + (f"\n{note.rstrip()[:2000]}" if note.strip() else ""),
                  flush=True)
    print(f"built {len(plan)} module(s) in the closure; {failures} failed")
    return 1 if failures else 0


if __name__ == "__main__":
    if "LEAN_PATH" not in os.environ:
        sys.exit("LEAN_PATH must be set to the borrowed package olean roots")
    raise SystemExit(main())
