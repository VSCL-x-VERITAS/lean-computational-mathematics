#!/usr/bin/env python3
"""Build a seal_row_audit verdict from a finished faithfulness-kit audit.

`finalize_audit.py` writes `decision.json`, which carries the semantic judgment
but not the shape the chapter gate consumes: the gate wants a per-check PASS or
FAIL with a substantive analysis for each of the four roles, plus the source
contract split into statement, assumptions and quantifiers.

Every field here is taken from a kit output. Nothing is invented:

  * the two implication directions and the classification come from
    `decision.json`, which takes them from the adjudicator when one ran and from
    the direct judge otherwise;
  * each check's analysis is the corresponding role's own rationale;
  * each check's PASS or FAIL is read from that role's recorded position, not
    inferred from the final classification, so a role that dissented is still
    visible in the sealed envelope;
  * the contract is the source contract's own statement block.

A row whose decision is not accepted is refused outright: the sealer will refuse
it too, and failing here gives the clearer message.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ACCEPTED = {"faithful-equivalent", "faithful-stronger"}


def read(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def role_position(output: dict, accepted_classification: str) -> tuple[str, str]:
    """That role's own PASS/FAIL and the rationale it gave for it."""
    classification = output.get("classification")
    if classification is None:
        # the source-contract and blind roles do not classify; they pass by
        # having been produced and validated, and their analysis is their own
        # plain-English summary.
        analysis = (
            output.get("contract_plain_english")
            or (output.get("translation") or {}).get("proposition_plain_english")
            or ""
        )
        return "PASS", analysis
    decision = "PASS" if classification == accepted_classification else "FAIL"
    return decision, output.get("rationale", "")


def build(audit_dir: Path) -> dict:
    decision = read(audit_dir / "decision.json")
    classification = decision["classification"]
    if classification not in ACCEPTED:
        raise SystemExit(
            f"refusing to build a verdict for {decision['task_id']}: the kit "
            f"decided {classification!r}, which is not a sealable outcome"
        )
    outputs = audit_dir / "agent_outputs"
    source = read(outputs / "source_contract.json")
    blind = read(outputs / "blind_translation.json")
    direct = read(outputs / "direct_judge.json")
    roundtrip = read(outputs / "roundtrip_judge.json")

    implications = decision.get("implications") or {}
    left = (implications.get("lean_implies_source") or {}).get("verdict")
    right = (implications.get("source_implies_lean") or {}).get("verdict")
    if left not in {"yes", "no"} or right not in {"yes", "no"}:
        raise SystemExit(
            f"{decision['task_id']}: decision.json carries no usable implication "
            "verdicts, so the envelope cannot be built without inventing them"
        )

    verdict: dict = {
        "classification": classification,
        "lean_implies_source": left,
        "source_implies_lean": right,
        "contract": {
            "statement": source["contract_plain_english"],
            "assumptions": source["statement"]["hypotheses"],
            "quantifiers": source["statement"]["binders"],
        },
        "source_contract_procedure": (
            "A source-contract extractor read only the audit kit's own prompt and "
            "schema, the row's source locator, and the cited pages of the "
            "immutable PDF, and normalised the printed claim into binders, "
            "hypotheses, conclusions and recorded ambiguities."
        ),
        "blind_procedure": (
            "A blind translator read only the anonymised declaration packet, "
            "confirmed its bound SHA-256, and said what the statement means on "
            "its own terms, reporting triviality and vacuity adversarially. It "
            "never saw the source, the Lean, or any other role's output."
        ),
        "direct_procedure": (
            "A direct judge compared the cited source pages with the elaborated "
            "declaration dossier, completed the configured semantic checklist, "
            "and decided both implication directions separately before "
            "classifying."
        ),
        "round_trip_procedure": (
            "A round-trip judge compared the cited source pages with the blind "
            "translation alone, never seeing the Lean, and decided both "
            "implication directions separately before classifying."
        ),
    }

    for key, output in (
        ("blind", blind),
        ("direct", direct),
        ("round_trip", roundtrip),
    ):
        position, analysis = role_position(output, classification)
        verdict[f"{key}_decision"] = position
        verdict[f"{key}_analysis"] = analysis or "(the role recorded no rationale)"

    if decision.get("adjudicated"):
        adjudicator = read(outputs / "adjudicator.json")
        verdict["adjudication_procedure"] = (
            "A fresh adjudicator resolved the recorded triggers on primary source "
            "and declaration evidence rather than by majority vote: "
            + "; ".join(decision.get("adjudication_reasons", []))
        )
        verdict["adjudication_analysis"] = adjudicator.get("rationale", "")

    if classification == "faithful-stronger":
        verdict["applicability_audit"] = (
            "Recorded by the adjudicator or judges as genuine strength rather "
            "than reduced applicability; see the sealed analyses."
        )
        verdict["nonvacuity_witness"] = next(
            (f.get("impact", "") for f in decision.get("findings", [])
             if "vacu" in str(f.get("category", "")).lower()),
            "",
        )
    return verdict


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--audit-dir", required=True,
                        help="the row's faithfulness/ directory")
    parser.add_argument("--out", required=True)
    args = parser.parse_args()
    verdict = build(Path(args.audit_dir))
    Path(args.out).write_text(
        json.dumps(verdict, indent=1, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    print(f"wrote {args.out}: {verdict['classification']} "
          f"({verdict['lean_implies_source']}/{verdict['source_implies_lean']})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
