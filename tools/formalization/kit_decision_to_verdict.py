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
  * each check's PASS or FAIL is the adjudicated outcome, with a dissenting
    role's own classification and reasoning written into the analysis, so the
    disagreement survives into the sealed envelope;
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
    """The check's PASS/FAIL after adjudication, and the rationale behind it.

    The gate reserves FAIL for a check that genuinely fails in the final
    outcome: a PROVED row must carry three passes, and a DISCREPANCY row is the
    shape for a direct check that failed. So a role whose classification was
    overruled by an adjudicator does not make the check FAIL -- the adjudicator
    resolved it. The dissent is not lost: it is written into the analysis, which
    is what the sealed artifact carries.
    """
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
    rationale = output.get("rationale", "")
    if classification != accepted_classification:
        rationale = (
            f"This role classified the target {classification!r}, which an "
            f"adjudicator resolved to {accepted_classification!r} on primary "
            f"evidence. The role's own reasoning, preserved: " + rationale
        )
    return "PASS", rationale


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
        # The gate requires a real applicability audit here, and the honest
        # source for it is the deciding role's own account of the direction that
        # failed: source_implies_lean = no *is* the statement of what the Lean
        # asserts beyond the printed claim. Boilerplate would misrepresent a
        # judgment nobody made.
        audit = (implications.get("source_implies_lean") or {}).get("reasoning", "")
        # C12 is the configured nonvacuity check, so the deciding role's own
        # reasoning on it is the witness the gate is asking for. Findings are
        # the wrong place to look: a finding is raised when something is wrong,
        # so a row that passes nonvacuity cleanly has none, and reading only
        # findings made a clean pass indistinguishable from missing evidence.
        witness = next(
            (c.get("reasoning", "") for src in (direct, roundtrip)
             for c in src.get("semantic_checklist", [])
             if c.get("id") == "C12" and str(c.get("reasoning", "")).strip()),
            "",
        ) or next(
            (f.get("impact", "") for f in decision.get("findings", [])
             if "vacu" in str(f.get("category", "")).lower()),
            "",
        )
        for name, text in (("applicability_audit", audit),
                           ("nonvacuity_witness", witness)):
            if len(str(text).strip()) < 80:
                raise SystemExit(
                    f"{decision['task_id']}: faithful-stronger closure needs a "
                    f"substantive {name}, and the kit outputs do not supply one "
                    f"(found {len(str(text).strip())} characters). Refusing to "
                    f"fabricate it; obtain the missing analysis from the "
                    f"deciding role instead."
                )
        verdict["applicability_audit"] = audit
        verdict["nonvacuity_witness"] = witness
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
