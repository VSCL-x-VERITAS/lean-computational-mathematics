"""Validate and freeze only this directory's finished scratch check evidence."""
import hashlib
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[4]
ALLOWED = {"propext", "Classical.choice", "Quot.sound"}
BURGERS = [
    "characteristic_value", "characteristic_collision_impossible",
    "neg_sin_smooth_bounded", "neg_sin_no_classical_solution_to_pi_div_two",
    "hasDerivAt_burgersFlux", "burgersFlux_not_linear",
    "isClassicalBurgersOn_iff_conservationLaw",
]
STEP = [
    "movingStep_rectangle", "stepMass_nonpositive", "stepMass_unitInterval",
    "stepMass_not_differentiableAt_zero",
    "movingStep_rectangle_without_classical_mass_derivative",
    "timeShiftedStep_rectangle", "timeShiftedStep_no_classical_mass_derivative",
]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def item(source, output, names, include_prelude=False):
    src, out = HERE / source, HERE / output
    text = out.read_text(encoding="utf-8-sig")
    assert not re.search(r"\b(error|warning|sorryAx)\b", text), output
    expected = {"NumStability.ShockFoundation." + n for n in names}
    if include_prelude:
        expected.add("NumStability.Chapter01Scratch.travelingWave_isRectangleConservationLawSolution")
    rows = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", text)
    assert {n for n, _ in rows} == expected
    assert len(rows) == len(expected)
    axioms = {n: [a.strip() for a in body.split(",")] for n, body in rows}
    assert all(set(a) <= ALLOWED for a in axioms.values())
    source_text = src.read_text(encoding="utf-8")
    # These two reviewed scratch files have no nested block comments or strings.
    source_code = re.sub(r"/-.*?-/", "", source_text, flags=re.DOTALL)
    source_code = re.sub(r"--[^\n]*", "", source_code)
    assert not re.search(r"\b(sorry|admit|axiom)\b", source_code)
    return {
        "source": source, "source_sha256": sha(src),
        "command": "lake env lean " + src.relative_to(REPO).as_posix(),
        "working_directory": str(REPO),
        "observed_final_exit_code": 0,
        "output": output, "output_sha256": sha(out),
        "axioms": axioms,
    }


receipt = {
    "schema": "leveque-ch01-scratch-verification-1",
    "source_pdf_sha256": "b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5",
    "gate_row_closure": False,
    "source_faithfulness_audit": False,
    "observed_exit_code_provenance": "Native exec session completion results in the coordinator/subagent conversation; outputs checked here.",
    "checks": [item("candidate.lean", "fifth-elaboration.txt", BURGERS),
               item("moving-step-candidate.lean", "moving-step-third-elaboration.txt", STEP, True)],
    "report_sha256": sha(HERE / "reuse-and-scope.md"),
    "reuse_searches_sha256": sha(HERE / "reuse-searches.txt"),
    "verifier_sha256": sha(Path(__file__)),
}
target = HERE / "final-verification.json"
target.write_text(json.dumps(receipt, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
print(json.dumps({"status": "PASS", "receipt": str(target), "sha256": sha(target),
                  "checks": len(receipt["checks"]), "theorems": 15}, indent=2))
