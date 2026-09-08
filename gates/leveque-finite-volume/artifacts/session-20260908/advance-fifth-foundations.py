"""Advance open-row next foundations after checked scratch increments."""
import hashlib
import json
from pathlib import Path

session = Path(__file__).resolve().parent
path = session.parents[1] / "chapter-01.json"
data = path.read_bytes()
assert hashlib.sha256(data).hexdigest() == "4ae8edff8f25821ed35616b811f6c51d35b5e4d04b0e82fc7332c679d10044f1"
snapshot = session / "gate-before-fifth-foundations.json"
assert not snapshot.exists()
snapshot.write_bytes(data)
gate = json.loads(data)
next_steps = {
    "NONCONSERVATION-SOURCE-TERMS": "Specialize the checked arbitrary-source mass-budget identity to constant contaminant transport, consolidate its reusable owner, and audit the source wrapper. The explicit unit-production example supplies an applicability witness; mass change caused only by endpoint flux is excluded.",
    "VARIABLE-COEFFICIENT-NONCONSERVATION": "Place and independently audit the checked positive smooth coefficient 1+x^2 witness. Its actual spatial derivative tests rule out even explicitly spatial local fluxes for fixed density; preserve the distinction from changing density or using an integrating factor.",
    "FLUX-JACOBIAN-HYPERBOLICITY": "Place and audit the checked local/domain criterion for the actual Frechet derivative, reusing real-eigenbasis classification and the existing global hyperbolic-law structure. Decide the source's pointwise/domain packaging without adding strict hyperbolicity or well-posedness.",
    "LINEAR-RIEMANN-EIGENSOLUTION": "Place the checked finite-eigenmode construction with rectangle balance, exact free-origin initial data, and positive-time similarity. Independently resolve the source's weak/trace convention using the moving-step mass-derivative counterexample before certifying the wrapper.",
    "DISCONTINUITY-INTEGRAL-LAW": "Place the checked positive-time moving-step counterexample and the separate valid rectangle-balance result; obtain independent source/trace adjudication of the literal derivative in (1.10) at endpoint crossings. No source discrepancy or silent weak-law replacement is yet certified.",
    "NONLINEAR-SHOCK-FORMATION": "Finish rectangle balance for the explicit nonlinear Huber-flux continuation with smooth initial data -x and a checked positive-time jump. Then audit the complete solution and admissibility/source contract; the separate Burgers no-classical-continuation result remains only a prerequisite.",
    "MATERIAL-INTERFACE-RIEMANN-DATA": "Place and audit the checked product-profile equivalence and paired Riemann construction, preserving both free origin values. Reflection/transmission dynamics remain a separate source object.",
    "RIEMANN-INITIAL-VALUE-DEFINITION": "Audit the checked general equation-plus-two-state-data predicate and explicitly identify its hyperbolic-equation application. It retains an independently supplied evolution predicate without fixing a classical/weak convention or claiming solver existence.",
    "SECOND-ORDER-WAVE-HYPERBOLICITY": "Place and independently audit the checked principal-part discriminant classification for positive wave speed, including its positive material-constant specialization. The classification convention is a source-contract obligation, not an inferred well-posedness theorem.",
    "ONE-STEP-METHOD-DEFINITION": "Place and audit the checked current-state factorization characterization on finite histories, retaining arbitrary cell types and time-step dependence. Keep the mathematical dependence distinct from typography.",
}
for row in gate["rows"]:
    key = row["id"].removeprefix("LEV-CH01-")
    if key in next_steps:
        assert row["status"] == "READY"
        row["next_foundation"] = next_steps.pop(key)
assert not next_steps
path.write_text(json.dumps(gate, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
print(hashlib.sha256(path.read_bytes()).hexdigest())
