"""Apply the independently reviewed inventory disposition, without proof closure."""
import hashlib
import json
from pathlib import Path

session = Path(__file__).resolve().parent
gate_path = session.parents[1] / "chapter-01.json"
old_bytes = gate_path.read_bytes()
assert hashlib.sha256(old_bytes).hexdigest() == "58cb1a8b305034b2460ec04d496c8e932a5f0ad72edf5c1dc58ce36304cbc11e"
report = session / "independent-inventory-review-final.md"
assert hashlib.sha256(report.read_bytes()).hexdigest() == "d7511e5d60cff72ca6126d8ffecf969728cb75200ac59008d5076cbf8b940d78"
snapshot = session / "gate-before-independent-inventory-review.json"
assert not snapshot.exists()
snapshot.write_bytes(old_bytes)
gate = json.loads(old_bytes)
rows = {r["id"]: r for r in gate["rows"]}
prefix = "LEV-CH01-"

def ready(suffix, foundation, kind=None):
    row = rows[prefix + suffix]
    assert row["status"] in ("SKIPPED", "UNCLASSIFIED", "READY")
    row["status"] = "READY"
    row.pop("reason_code", None)
    row.pop("reason", None)
    row["next_foundation"] = foundation
    if kind:
        row["row_kind"] = kind

def skip(suffix, reason):
    row = rows[prefix + suffix]
    assert row["status"] == "UNCLASSIFIED"
    row.update(status="SKIPPED", reason_code="underspecified", reason=reason)
    row.pop("next_foundation", None)

def add(suffix, label, page, kind, dependencies, foundation):
    assert prefix + suffix not in rows
    gate["rows"].append(dict(id=prefix + suffix, source_label=label,
        printed_page=page, pdf_page=page + 22, row_kind=kind, status="READY",
        depends_on=[prefix + d for d in dependencies], source_proof="none",
        next_foundation=foundation))

ready("NONCONSERVATION-SOURCE-TERMS",
    "Place and audit the checked mass-budget defect/source-integral bridge, specialize to contaminant transport, and exhibit a nonzero internal-production example. A nonzero mass derivative alone is insufficient because endpoint transport must first be subtracted.", "proposition")
ready("VARIABLE-COEFFICIENT-NONCONSERVATION",
    "Strengthen the checked state-only flux obstruction with the positive smooth coefficient 1+x^2 and a calculus bridge from arbitrary smooth test fields. Preserve the density q, and resolve whether explicit spatial fluxes are included; do not claim absence of conservative reformulations after changing density.", "proposition")
skip("SHOCKS-AND-NONLINEARITY",
    "The physical slogan leaves formation versus prescribed discontinuity, the shock/admissibility class, coefficient regularity, initial/boundary data, solution concept, and time quantifiers unspecified. These affect truth conditions: linear Riemann data already permits jumps. Smoothness preservation for constant-coefficient evolution is only a specified subcase, not coverage of the unrestricted slogan.")
skip("TYPICAL-SECOND-ORDER-ACCURACY",
    "The qualified assertion fixes no method/reconstruction/limiter/time-integrator class, error norm, local versus global or spatial versus temporal order, data regularity, mesh/time relation, quantification of typical, or non-improvability bound for at best. An O(h^2) upper bound or one selected scheme does not establish this unspecified method-class claim.")
ready("FLUX-JACOBIAN-HYPERBOLICITY",
    "Define and audit the real complete-eigenbasis criterion for the actual flux Jacobian at each admissible state. Resolve pointwise versus stated-domain packaging; add neither strict hyperbolicity nor a well-posedness theorem.", "definition")
ready("NONLINEAR-SHOCK-FORMATION",
    "Extend the checked Burgers classical-breakdown prerequisite toward an explicit nonlinear conservation law with smooth initial data and an actual finite-time discontinuity in an admissible weak continuation. Gradient blow-up or absence of a global classical solution alone does not close this existential source claim.", "proposition")
ready("DISCONTINUITY-INTEGRAL-LAW",
    "Construct a moving-jump witness separating failure of classical spatial derivatives from valid time-integrated rectangle balance. Check the literal time derivative in (1.10) at endpoint crossings and obtain source/trace adjudication before choosing a faithful weak contract or certifying a discrepancy.")
rows[prefix + "DISCONTINUITY-INTEGRAL-LAW"]["depends_on"] = [
    prefix + "EQ-1.8-CONSERVATION-LAW", prefix + "EQ-1.10-INTEGRAL-CONSERVATION"]
add("HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING",
    "Every constant real hyperbolic system decouples in an eigenbasis into scalar advection equations, with reconstruction of the state", 3, "proposition",
    ["EQ-1.1-CONSTANT-LINEAR-SYSTEM", "HYPERBOLIC-MATRIX-DEFINITION", "EIGENBASIS-UNIQUE-DECOMPOSITION"],
    "Place and independently audit the checked arbitrary-field PDE equivalence under a fixed real eigenbasis and its reconstruction identity. Keep repeated eigenvalues admissible; a constructed eigenmode family alone is insufficient.")
add("MATERIAL-INTERFACE-RIEMANN-DATA",
    "A material-interface Riemann problem prescribes jumps in both medium and state at x=0", 8, "definition",
    ["EQ-1.11-RIEMANN-DATA", "RIEMANN-PROBLEM-DEFINITION"],
    "Define paired material/state Riemann data for arbitrary material and state types with a free origin value, then verify its left/right projections and audit the source correspondence separately from reflected/transmitted-wave dynamics.")
add("RIEMANN-PROBLEM-DEFINITION",
    "A Riemann problem consists of a hyperbolic equation together with piecewise constant two-state initial data", 5, "definition",
    ["EQ-1.11-RIEMANN-DATA"],
    "Represent an independently supplied hyperbolic equation/solution predicate together with the two-state initial-data condition. Preserve the unspecified origin value and avoid restricting this general definition to constant matrices.")
rows[prefix + "EQ-1.11-RIEMANN-DATA"]["depends_on"] = []
rows[prefix + "EQ-1.11-RIEMANN-DATA"]["next_foundation"] = (
    "Audit the two-state piecewise initial-data definition with a free origin value. The general equation-plus-data definition is separately tracked by RIEMANN-PROBLEM-DEFINITION.")
material = rows[prefix + "MATERIAL-INTERFACE-RIEMANN"]
material["source_label"] = "Material-interface Riemann dynamics decomposes reflected and transmitted waves into neighboring cells"
material["depends_on"] = [prefix + "MATERIAL-INTERFACE-RIEMANN-DATA", prefix + "HETEROGENEOUS-CELL-AVERAGING"]
material["reason"] = (
    "The reflected/transmitted-wave assertion omits the governing heterogeneous equations, interface conditions, wave families, and solver. The precise joint material/state initial-data construction is retained separately as MATERIAL-INTERFACE-RIEMANN-DATA; no wave-dynamics guarantee is inferred from that data definition.")
rows[prefix + "NONLINEAR-RIEMANN-CONSTRUCTION"]["reason"] = (
    "The broad exact-or-arbitrarily-accurate nonlinear construction claim fixes no system/domain, solver, error metric, admissibility class, existence hypotheses, or accuracy parameter. These missing truth conditions, rather than the later-chapter reference or a missing implementation, prevent a unique contract here.")
rows[prefix + "WAVE-PROPAGATION-FRAMEWORK"]["reason"] = (
    "The asserted framework correspondence fixes no fluctuation operators, numerical interface update, applicability conditions, or equality relating wave propagation to flux differencing. These missing operators and hypotheses prevent a checkable mathematical correspondence in this passage.")
for suffix, reason, coverage in [
    ("NOTATION-SOLUTION-VELOCITY", "Editorial choice of names for the solution and physical velocity; the equation roles are inventoried separately.", ["EQ-1.1-CONSTANT-LINEAR-SYSTEM", "EQ-1.2-ADVECTION", "EQ-1.5-LINEAR-ACOUSTICS"]),
    ("NOTATION-NUMERICAL-APPROXIMATION", "Editorial subscript/superscript convention for cell and time indices. Mathematical arrays, averaging and current-step dependence have separate inventory coverage.", ["FINITE-VOLUME-CELL-AVERAGE", "FINITE-VOLUME-FLUX-UPDATE", "ONE-STEP-METHOD-DEFINITION"]),
    ("NOTATION-VECTOR-COMPONENTS", "Editorial notation for components of the m-dimensional state and numerical array. Dimension and field shape are covered by the system and finite-volume definitions.", ["EQ-1.1-CONSTANT-LINEAR-SYSTEM", "FINITE-VOLUME-CELL-AVERAGE"]),
    ("NOTATION-EIGENPAIR-INDEX", "Editorial superscript convention for a finite eigenfamily; the mathematical eigenbasis content is separately inventoried.", ["HYPERBOLIC-MATRIX-DEFINITION", "EIGENBASIS-UNIQUE-DECOMPOSITION"]),
]:
    rows[prefix + suffix]["reason"] = reason
    rows[prefix + suffix]["depends_on"] = [prefix + d for d in coverage]

assert len(gate["rows"]) == len({r["id"] for r in gate["rows"]}) == 57
assert all(r["status"] != "UNCLASSIFIED" for r in gate["rows"])
assert [r for r in gate["rows"] if r["status"] in ("PROVED", "REUSED")] == [
    r for r in json.loads(old_bytes)["rows"] if r["status"] in ("PROVED", "REUSED")]
for name in gate["verification_evidence"]:
    gate["verification_evidence"][name] = dict(command="", artifact="", artifact_sha256="", exit_code=None, count=0)
gate_path.write_text(json.dumps(gate, indent=2, ensure_ascii=False) + "\n", encoding="utf-8", newline="\n")
print(hashlib.sha256(gate_path.read_bytes()).hexdigest())
