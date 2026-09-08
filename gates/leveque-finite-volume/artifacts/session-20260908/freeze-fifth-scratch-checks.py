"""Hash and summarize exact successful scratch checks observed in this session.

This parser is not a Lean runner or a source-faithfulness validator. The exit
statuses below were separately observed from completed native tool sessions.
"""
import hashlib
import json
from pathlib import Path
import re

session = Path(__file__).resolve().parent
groups = [
    ("variable-coefficient-local-flux-candidate.lean", "variable-coefficient-local-flux-output.txt", [
        "RepresentsScalarTransportFlux.position_independent", "RepresentsScalarTransportFlux.state_derivative",
        "RepresentsScalarTransportFlux.coefficient_eq", "exists_positive_smooth_hyperbolic_transport_without_local_flux"]),
    ("flux-jacobian-classification-candidate.lean", "flux-jacobian-classification-output.txt", [
        "hyperbolicConservationLaw_isHyperbolicFluxAt", "isHyperbolicFluxAt_iff_independent_real_eigenvectors",
        "isHyperbolicFluxOn_iff_independent_real_eigenvectors"]),
    ("riemann-initial-configuration-candidate.lean", "riemann-initial-configuration-output.txt", [
        "isRiemannInitialValueSolution_iff", "isRiemannInitialValueSolution_iff_exists_origin",
        "isRiemannData_prod_iff", "riemannData_prod"]),
    ("source-term-necessity-candidate.lean", "source-term-necessity-output.txt", [
        "integral_any_source_eq_massDefect", "uniform_unit_production_nonvacuity",
        "integral_internalProduction_eq_massDefect", "balanceLaw_source_eq_zero_of_conservationLaw",
        "nonconservation_requires_nonzero_source"]),
]

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

checks = []
for source, output, names in groups:
    source_path, output_path = session / source, session / output
    text = output_path.read_text(encoding="utf-8-sig")
    assert not re.search(r"\b(error|warning|sorryAx)\b", text), output
    matches = re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", text)
    expected = {"NumStability.Chapter01Scratch." + name for name in names}
    assert len(matches) == len(expected) and {name for name, _ in matches} == expected
    axioms = {name: [a.strip() for a in body.split(",") if a.strip()] for name, body in matches}
    assert all(set(values) <= {"propext", "Classical.choice", "Quot.sound"} for values in axioms.values())
    checks.append(dict(source=source, source_sha256=digest(source_path), output=output,
        output_sha256=digest(output_path), observed_native_exit_code=0,
        command="lake env lean gates/leveque-finite-volume/artifacts/session-20260908/" + source,
        axioms=axioms))
receipt = dict(schema="leveque-scratch-check-summary-1", gate_closure=False,
    source_faithfulness_audit=False, exit_code_provenance="Completed native exec sessions in this conversation",
    source_unit_sha256="b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5",
    checks=checks, parser_sha256=digest(Path(__file__)))
payload = (json.dumps(receipt, ensure_ascii=False, indent=2, sort_keys=True) + "\n").encode()
destination = session / "fifth-scratch-checks.json"
if destination.exists():
    assert destination.read_bytes() == payload
else:
    destination.write_bytes(payload)
print(json.dumps(dict(status="PASS", checks=len(checks), theorem_checks=sum(len(x[2]) for x in groups),
    receipt_sha256=digest(destination))))
