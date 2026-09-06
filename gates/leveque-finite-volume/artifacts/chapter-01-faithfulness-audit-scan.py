"""Validate every completed Chapter 1 theorem audit named by the gate."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
GATE_PATH = ROOT / "gates" / "leveque-finite-volume" / "chapter-01.json"
VALIDATOR = ROOT / ".faithfulness-audit" / "scripts" / "validate_audit.py"


def main() -> int:
    gate = json.loads(GATE_PATH.read_text(encoding="utf-8"))
    rows = [
        row
        for row in gate["rows"]
        if row["status"] in {"PROVED", "REUSED", "DISCREPANCY"}
    ]
    tasks = [ROOT / row["faithfulness_task"] for row in rows]
    if len(tasks) != 24 or len(set(tasks)) != 24:
        raise AssertionError("expected 24 distinct completed Chapter 1 audits")

    for task in tasks:
        result = subprocess.run(
            [sys.executable, "-X", "utf8", str(VALIDATOR), str(task)],
            cwd=ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
        if result.returncode:
            raise AssertionError(f"{task}:\n{result.stdout}")
    print("faithfulness audit scan passed: 24 completed audits validated")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
