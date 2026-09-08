"""Freeze this bounded qualification packet; no outside writes or audit execution."""
from pathlib import Path
import hashlib
import json
import re

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
ROOT = SESSION.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_text(encoding="utf-8-sig"))
write = lambda p, value: p.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
assert not (HERE / "inputs.json").exists()
source = SESSION / "source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf"
assert sha(source) == "b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5"
native = read(HERE / "native01-exit.json")
output = (HERE / "native01-output.txt").read_text(encoding="utf-8")
assert type(native["exit_code"]) is int and native["exit_code"] == 0
assert native["changed_inputs"] == [] and sha(HERE / "native01-output.txt") == native["output_sha256"]
assert not re.search(r"(?m)^.*\.lean:\d+:\d+: (?:error|warning):", output)
names = re.findall(r"^#print axioms (\S+)$", (HERE / "Checks.lean").read_text(encoding="utf-8"), re.M)
axioms = {}
for name in names:
    reports = re.findall(re.escape("'" + name + "' depends on axioms:") + r"\s*\[([^\]]*)\]", output)
    assert len(reports) == 1
    actual = sorted({v.strip() for v in reports[0].split(",") if v.strip()})
    assert set(actual) <= {"propext", "Classical.choice", "Quot.sound"}
    axioms[name] = actual
assert len(names) == 18
inputs = {Path(x["path"]): x["sha256"] for x in native["inputs"]}
for path, expected in inputs.items():
    assert sha(path) == expected
inputs[source] = sha(source)
for directory, filenames in {
    "FiniteVolume": ["CellAverage", "CellVolumeAverage", "RiemannInterface", "PhysicalFluxAverage", "FluxUpdateError", "FluxUpdateErrorBounds", "LinearRiemannSolution"],
    "LinearSystems": ["CharacteristicPropagation", "EigenbasisCoordinates"],
    "Transport": ["ClassicalCharacteristics"],
    "ConservationLaws": ["Rectangle", "TravelingWaveCharacterization"],
}.items():
    for name in filenames:
        p = ROOT / "ComputationalMathematics/Analysis/PartialDifferentialEquations" / directory / (name + ".lean")
        inputs[p] = sha(p)
for name in ["FiniteVolumeFluxUpdate", "EigenvalueWaveSpeeds"]:
    p = ROOT / "ComputationalMathematics/Source/LeVeque/Chapter01" / (name + ".lean")
    inputs[p] = sha(p)
for relative in ["Mathlib/MeasureTheory/Integral/Bochner/Basic.lean", "Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean"]:
    p = ROOT / ".lake/packages/mathlib" / relative
    inputs[p] = sha(p)
decisions = {}
for name in ["LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908", "LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908"]:
    base = SESSION / "audits" / name
    for relative in ["audit-task.json", "faithfulness/decision.json", "faithfulness/manifest.json", "faithfulness/inputs/source_locator.json"]:
        p = base / relative
        inputs[p] = sha(p)
    d = read(base / "faithfulness/decision.json")
    decisions[name] = {"accepted": d["accepted"], "classification": d["classification"], "decision_sha256": sha(base / "faithfulness/decision.json")}
    assert not d["accepted"]
capstone = read(SESSION / "fv-update-capstone-draft/final-receipt.json")
reused = []
for item in capstone["canonical_inputs"] + capstone["artifacts"]:
    p = ROOT / item["path"]
    assert sha(p) == item["sha256"]
    inputs[p] = item["sha256"]
    reused.append(item)
assert capstone["native_exit_code"] == 0 and capstone["source_acceptance"] is False
for relative in ["fv-update-capstone-draft/final-receipt.json", "real-measure-dependency/supplementary-declaration-dossier-v2.md", "real-measure-dependency/final-verification-v2.json", "current-thread-clarification-provenance-batch8.json", "prospective-source-choice-boundaries-batch10.json"]:
    p = SESSION / relative
    inputs[p] = sha(p)
assert sha(SESSION / "prospective-source-choice-boundaries-batch10.json") == "29454cddf004123bf48c1262d1cc55a7e5a88ed51fc85249c26f7ee2e426db7f"
for raw in (25, 27):
    p = ROOT.parent / "workflow-v5.0.1-local/chapter01-source-review" / f"page-{raw:03d}.png"
    inputs[p] = sha(p)
questions = read(SESSION / "current-thread-clarification-provenance-batch8.json")
selected = [x for x in questions["clarification_calls"] if x["call_id"] in {"call_6YQjDMqpCa41f93c3kdBhahI", "call_1UY4fVuKrjpIIQfhLdeuFoRH"}]
assert len(selected) == 2
contracts = []
for relative, declaration in [
    ("ComputationalMathematics/Source/LeVeque/Chapter01/EigenvaluePropagation.lean", "leveque01_eigenvalues_completeWavePropagation"),
    ("gates/leveque-finite-volume/artifacts/session-20260908/fv-update-capstone-draft/Candidate.lean", "finiteVolumeUpdate_capstone"),
    ("ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellVolumeAverage.lean", "cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage"),
    ("ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean", "eigenmodeTravelingWave_isRectangleSolution"),
    ("ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean", "finite_sum_isRectangleSolution"),
]:
    p = ROOT / relative
    data = p.read_text(encoding="utf-8")
    start = data.index("theorem " + declaration)
    end = data.index(" :=", start)
    contracts.append({"path": relative, "sha256": sha(p), "declaration": declaration,
                      "line": data[:start].count("\n") + 1, "header_without_proof": data[start:end]})
write(HERE / "contracts.json", {"kind": "proof-free-existing-contract-qualification", "source_acceptance": False, "contracts": contracts})
write(HERE / "inputs.json", {"schema_version": 1, "scope": "Exact inspected source/canonical/frozen evidence; no source adoption or exhaustion claim", "files": [{"path": str(p), "sha256": h} for p, h in sorted(inputs.items())], "historical_decisions": decisions,
    "question_status": "Q4 and Q7 remain unanswered by root instruction; no live conversation completeness asserted",
    "historical_projection_as_of_utc": questions["as_of_utc"], "selected_exact_question_records": selected,
    "chronology_warning": "Literal record timestamps exceed the historical projection cutoff; root also reported transcript/host clock discrepancy. Do not invent a future extraction or review time.",
    "source_pages_read": [23,24,25,26,27], "source_pages_viewed": [25,27],
    "reused_fv_receipt": {"native_exit_code": capstone["native_exit_code"], "native_elapsed_ms": capstone["native_elapsed_ms"], "native_output_sha256": capstone["native_output_sha256"], "verified_bound_entries": len(reused), "all_current_matches": True}})
write(HERE / "verification.json", {"kind": "prospective-qualification-only", "native_exit_code": native["exit_code"], "native_elapsed_ms": native["elapsed_ms"], "native_input_commit": native["input_commit"], "native_output_sha256": native["output_sha256"], "axioms": axioms, "checked_axiom_reports": 18, "changed_native_inputs": [], "source_acceptance": False, "gate_ledger_production_git_writes": [], "all_local_work_exhausted": "not asserted", "optional_weak_uniqueness": "Not imposed as a prerequisite for the current classical target.", "files": [{"path": p.name, "sha256": sha(p)} for p in sorted(HERE.iterdir()) if p.is_file() and p.name != "verification.json"]})
print(json.dumps({"verification_sha256": sha(HERE / "verification.json"), "inputs_sha256": sha(HERE / "inputs.json"), "qualification_sha256": sha(HERE / "QUALIFICATION.md"), "contracts_sha256": sha(HERE / "contracts.json"), "native_exit_code": 0, "checked_axiom_reports": 18}))
