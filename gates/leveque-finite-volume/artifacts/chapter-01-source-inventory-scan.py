"""Recheck the Chapter 1 inventory inputs used by the global gate evidence."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
GATE_PATH = ROOT / "gates" / "leveque-finite-volume" / "chapter-01.json"
CHECKER_PATH = Path(
    r"C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS"
    r"\formalization-collaboration\books\candidates\leveque-finite-volume"
    r"\module\scripts\gate.py"
)


def load_checker():
    spec = importlib.util.spec_from_file_location("leveque_gate", CHECKER_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load authoritative gate checker")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> int:
    checker = load_checker()
    gate = json.loads(GATE_PATH.read_text(encoding="utf-8"))
    context = checker.current_context(GATE_PATH, 1)
    rows = gate["rows"]
    row_ids = [row["id"] for row in rows]
    assert len(rows) == 47
    assert len(row_ids) == len(set(row_ids))
    assert context["printed_range"] == (1, 11)
    assert context["pdf_range"] == (23, 33)
    assert gate["source_unit_sha256"] == checker.PINNED_SOURCE_SHA256
    assert checker.authoritative_source_sha256() == checker.PINNED_SOURCE_SHA256
    assert all(1 <= row["printed_page"] <= 11 for row in rows)
    assert all(23 <= row["pdf_page"] <= 33 for row in rows)
    assert not checker.depends_on_defects({row["id"]: row for row in rows})
    print(
        "source inventory scan passed: 47 unique rows, printed pages 1-11, "
        "PDF pages 23-33, source hash and dependency graph verified"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
