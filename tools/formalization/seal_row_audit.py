#!/usr/bin/env python3
"""Seal one gate row's semantic-equivalence audit into the four gate artifacts.

The faithfulness kit produces judgments. The chapter gate consumes a specific
four-artifact envelope. Nothing in the workflow package joins the two, so every
row closure otherwise means hand-assembling four JSON files, twelve binding
fields apiece, and four SHA-256 digests, with two ordering traps that silently
invalidate the result. This tool is that join.

The envelope is not invented here. It is the one
`books/candidates/leveque-finite-volume/module/scripts/gate_regression.py`
builds at `make_fixture`, and the hashing is `gate.py`'s own `canonical_sha256`
and `row_artifact_bindings`, imported rather than reimplemented so the two can
never drift.

Two ordering traps this tool exists to avoid:

  * `row_subject_sha256` hashes the whole row minus only the ten artifact
    fields. Editing `status`, `next_foundation`, `open_reason` or any other
    prose after the artifacts are written silently invalidates all four. So the
    row is brought to its final form first, and only then are bindings computed.
  * `lean_worktree_sha256` is recomputed live from the working tree on every
    gate check. Any Lean edit after sealing invalidates the artifacts. Run this
    last, against a frozen tree.

The judgments themselves come from `--verdict`, a JSON file written by the audit
roles. This tool never invents a decision: it refuses a verdict whose
classification disagrees with its own two implication directions, and it refuses
`faithful-stronger` without the applicability audit and nonvacuity witness the
gate requires.

Usage:
  python tools/formalization/seal_row_audit.py --gate GATE --row ROW_ID \
      --verdict VERDICT.json [--evidence-root artifacts/sealed] [--apply]
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from pathlib import Path

CLASSIFICATION = {
    ("yes", "yes"): "faithful-equivalent",
    ("yes", "no"): "faithful-stronger",
    ("no", "yes"): "not-faithful-weaker",
    ("no", "no"): "not-faithful-different",
}
CHECKS = (
    ("source-contract", None),
    ("blind", "blind_pass"),
    ("direct", "direct_pass"),
    ("round-trip", "round_trip_pass"),
)


def load_gate_module(module_root: Path):
    spec = importlib.util.spec_from_file_location(
        "leveque_gate", module_root / "scripts" / "gate.py"
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def json_bytes(value) -> bytes:
    """Byte form gate_regression.py uses for every artifact."""
    return (
        json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False)
        + "\n"
    ).encode("utf-8")


def validate(verdict: dict) -> list[str]:
    problems: list[str] = []
    left = verdict.get("lean_implies_source")
    right = verdict.get("source_implies_lean")
    if left not in {"yes", "no"} or right not in {"yes", "no"}:
        problems.append("lean_implies_source and source_implies_lean must be yes or no")
        return problems
    expected = CLASSIFICATION[(left, right)]
    if verdict.get("classification") != expected:
        problems.append(
            f"classification {verdict.get('classification')!r} contradicts the two "
            f"implication directions, which give {expected!r}"
        )
    if expected in {"not-faithful-weaker", "not-faithful-different"}:
        problems.append(
            f"{expected} cannot be sealed as PROVED; it is a DISCREPANCY row and needs "
            "a formal witness and a separately named corrected result"
        )
    if expected == "faithful-stronger":
        for name in ("applicability_audit", "nonvacuity_witness"):
            if not str(verdict.get(name, "")).strip():
                problems.append(f"{name} is required for faithful-stronger closure")
    for check, field in CHECKS:
        if field is None:
            continue
        key = check.replace("-", "_")
        if verdict.get(f"{key}_decision") not in {"PASS", "FAIL"}:
            problems.append(f"{key}_decision must be PASS or FAIL")
        if not str(verdict.get(f"{key}_analysis", "")).strip():
            problems.append(f"{key}_analysis is required and must be substantive")
    contract = verdict.get("contract")
    if not isinstance(contract, dict) or set(contract) != {
        "statement", "assumptions", "quantifiers"
    }:
        problems.append("contract must have exactly statement, assumptions, quantifiers")
    return problems


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--gate", required=True)
    parser.add_argument("--row", required=True)
    parser.add_argument("--verdict", required=True)
    parser.add_argument("--module-root", default=None)
    parser.add_argument("--evidence-root", default="artifacts/sealed")
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()

    gate_path = Path(args.gate).resolve()
    module_root = (
        Path(args.module_root)
        if args.module_root
        else Path(
            r"C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS"
            r"\formalization-collaboration-v5.0.1\books\candidates"
            r"\leveque-finite-volume\module"
        )
    )
    gate_module = load_gate_module(module_root)

    verdict = json.loads(Path(args.verdict).read_text(encoding="utf-8"))
    problems = validate(verdict)
    if problems:
        for problem in problems:
            print(f"  REFUSED: {problem}")
        return 1

    gate = json.loads(gate_path.read_text(encoding="utf-8"))
    chapter = gate["chapter"]
    rows = {row["id"]: row for row in gate["rows"]}
    row = rows.get(args.row)
    if row is None:
        print(f"  REFUSED: no such row: {args.row}")
        return 1
    if not row.get("lean_declarations"):
        print("  REFUSED: the row carries no Lean declarations to audit")
        return 1

    contract = verdict["contract"]
    contract_hash = gate_module.canonical_sha256(contract)

    # Bring the row to its FINAL form before any binding is computed: the row
    # subject hash covers everything except the ten artifact fields.
    row["status"] = "PROVED"
    row["contract_hash"] = contract_hash
    row["classification"] = verdict["classification"]
    row["lean_implies_source"] = verdict["lean_implies_source"]
    row["source_implies_lean"] = verdict["source_implies_lean"]
    for check, field in CHECKS:
        if field:
            row[field] = verdict[f"{check.replace('-', '_')}_decision"]
    if verdict["classification"] == "faithful-stronger":
        row["applicability_audit"] = verdict["applicability_audit"]
        row["nonvacuity_witness"] = verdict["nonvacuity_witness"]
    # Fields that belong only to an open row.
    for stale in ("current_target", "open_reason", "next_foundation"):
        row.pop(stale, None)

    bindings = gate_module.row_artifact_bindings(row, chapter,
                                                 gate_module.current_context(gate_path, chapter))
    common = {
        "contract_hash": contract_hash,
        "classification": row["classification"],
        "lean_implies_source": row["lean_implies_source"],
        "source_implies_lean": row["source_implies_lean"],
    }
    row_root = f"{args.evidence_root.rstrip('/')}/{args.row}"
    written: list[tuple[str, int]] = []

    for check, field in CHECKS:
        if check == "source-contract":
            body = {
                "schema_version": 1,
                "check": check,
                "bindings": bindings,
                "procedure": verdict.get(
                    "source_contract_procedure",
                    "Transcribe the printed claim at the row's locator and normalise it "
                    "into the structured contract of statement, assumptions and "
                    "quantifiers without adding or dropping content.",
                ),
                "exit_code": 0,
                "payload": {
                    "contract_hash": contract_hash,
                    "source_label": row["source_label"],
                    "printed_page": row["printed_page"],
                    "pdf_page": row["pdf_page"],
                    "contract": contract,
                },
            }
            path_field, hash_field = "source_contract_artifact", "source_contract_sha256"
        else:
            key = check.replace("-", "_")
            body = {
                "schema_version": 1,
                "check": check,
                "bindings": bindings,
                "procedure": verdict.get(
                    f"{key}_procedure",
                    f"Run the independent {check} semantic role against isolated inputs "
                    "and record its judgment without revision.",
                ),
                "exit_code": 0,
                "payload": {**common, "decision": row[field],
                            "analysis": verdict[f"{key}_analysis"]},
            }
            path_field, hash_field = f"{key}_artifact", f"{key}_sha256"

        relative = f"{row_root}/{check}.json"
        target = gate_path.parent / relative
        payload = json_bytes(body)
        if args.apply:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(payload)
        row[path_field] = relative
        row[hash_field] = hashlib.sha256(payload).hexdigest()
        written.append((relative, len(payload)))

    closed = sum(
        1 for r in gate["rows"]
        if gate_module.text(r, "status").upper() in gate_module.CLOSED_LEAN_STATUSES
    )
    semantic = gate["verification_loops"]["semantic_equivalence"]
    semantic["rows_requiring_check"] = closed
    for name, check in (("blind_recorded", "blind"), ("direct_recorded", "direct"),
                        ("round_trip_recorded", "round-trip")):
        semantic[name] = sum(
            1 for r in gate["rows"]
            if gate_module.text(r, "status").upper() in gate_module.CLOSED_LEAN_STATUSES
            and gate_module.text(r, f"{check.replace('-', '_')}_pass").upper() == "PASS"
        )
    semantic["unresolved_adjudications"] = sum(
        1 for r in gate["rows"]
        if gate_module.text(r, "adjudication_status").lower() not in ("", "resolved")
    )

    if args.apply:
        gate_path.write_bytes(
            (json.dumps(gate, indent=1, ensure_ascii=False) + "\n").encode("utf-8")
        )

    print(f"  row            {args.row} -> PROVED")
    print(f"  classification {row['classification']}")
    print(f"  contract_hash  {contract_hash}")
    for relative, size in written:
        print(f"  artifact       {relative} ({size} bytes)")
    print(f"  semantic_equivalence {json.dumps(semantic, sort_keys=True)}")
    print("APPLIED" if args.apply else "DRY RUN (pass --apply to write)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
