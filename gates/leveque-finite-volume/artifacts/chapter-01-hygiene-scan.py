"""Check every non-gate path bound into the Chapter 1 worktree fingerprint."""

from __future__ import annotations

import importlib.util
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
GATE_PATH = ROOT / "gates" / "leveque-finite-volume" / "chapter-01.json"
GATE_CHECKER = Path(
    r"C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS"
    r"\formalization-collaboration\books\candidates\leveque-finite-volume"
    r"\module\scripts\gate.py"
)
LAYOUT_CHECKER = ROOT / "tools" / "architecture" / "check_layout.py"


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> int:
    sys.path.insert(0, str(LAYOUT_CHECKER.parent))
    gate = load(GATE_CHECKER, "leveque_gate")
    layout = load(LAYOUT_CHECKER, "check_layout")
    changed = gate.current_context(GATE_PATH, 1)["lean_changed_paths"]
    assert changed

    failures = []
    for relative in changed:
        path = ROOT / relative
        assert path.is_file()
        if path.suffix.lower() not in {".lean", ".py", ".json", ".md", ".txt", ""}:
            continue
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        if any(line.endswith((" ", "\t")) for line in text.splitlines()):
            failures.append(f"trailing whitespace: {relative}")
        if any(marker in text for marker in ("<<<<<<<", "=======", ">>>>>>>")):
            failures.append(f"conflict marker: {relative}")
        if path.suffix.lower() == ".lean" and layout.has_placeholder(text):
            failures.append(f"Lean placeholder: {relative}")

    diff = subprocess.run(
        [
            "git",
            "diff",
            "--check",
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
