"""Check every non-gate path bound into the Chapter 1 worktree fingerprint."""

from __future__ import annotations

import argparse
import importlib.util
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
GATE_PATH = ROOT / "gates" / "leveque-finite-volume" / "chapter-01.json"
LAYOUT_CHECKER = ROOT / "tools" / "architecture" / "check_layout.py"


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--gate-checker", type=Path, required=True)
    args = parser.parse_args()
    sys.path.insert(0, str(LAYOUT_CHECKER.parent))
    gate = load(args.gate_checker.expanduser().resolve(), "leveque_gate")
    layout = load(LAYOUT_CHECKER, "check_layout")
    changed = gate.current_context(GATE_PATH, 1)["lean_changed_paths"]

    failures = []
    for relative in changed:
        path = ROOT / relative
        if not path.exists():
            continue
        if not path.is_file() or path.is_symlink():
            failures.append(f"unsupported controlled path: {relative}")
            continue
        if path.suffix.lower() not in {".lean", ".py", ".json", ".md", ".txt", ""}:
            continue
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        if any(line.endswith((" ", "\t")) for line in text.splitlines()):
            failures.append(f"trailing whitespace: {relative}")
        if any(marker in text for marker in ("<<<<<<<", "=======", ">>>>>>>")):
            failures.append(f"conflict marker: {relative}")
        if path.suffix.lower() == ".lean" and layout.PLACEHOLDER_RE.search(
            layout.remove_lean_comments(text)
        ):
            failures.append(f"Lean placeholder: {relative}")

    diff = subprocess.run(
        [
            "git",
            "diff",
            "--check",
            gate.LEAN_BASELINE_COMMIT,
            "--",
            ".",
            ":(exclude)gates/**",
            ":(exclude)ledgers/**",
        ],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if diff.returncode:
        failures.append(diff.stdout.strip() or "git diff --check failed")
    if failures:
        raise AssertionError("\n".join(failures))
    print(f"hygiene scan passed: {len(changed)} exact changed paths, zero findings")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
