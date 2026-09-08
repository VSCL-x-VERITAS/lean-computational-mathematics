"""Create immutable v1 inputs for the checked new canonical source wrappers."""
from pathlib import Path
import hashlib,json
SESSION=Path(__file__).resolve().parent
ROOT=SESSION.parents[3]
SOURCE_SHA="b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5"
source=SESSION/"source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf"
assert hashlib.sha256(source.read_bytes()).hexdigest()==SOURCE_SHA
entries=[
("LEV-CH01-EQ-1.5-LINEAR-ACOUSTICS","Equation05Definition","leveque01_equation05_linearAcousticsAt_iff",
 "raw PDF page 24; printed Chapter 1 page 2","Equation (1.5) and the descriptions of pressure, particle velocity, bulk modulus and density."),
("LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION","Equation10Definition","leveque01_equation10_integralConservation_iff",
 "raw PDF page 26; printed Chapter 1 page 4","Equation (1.10) for any two points, together with the immediately following explanation of mass and endpoint flux."),
("LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY","SecondOrderHyperbolicity","leveque01_equation07_secondOrderHyperbolic",
 "raw PDF pages 24–25; printed Chapter 1 pages 2–3","The sound-speed definition after (1.6), equation (1.7), and the following sentence classifying it as hyperbolic under the standard second-order classification."),
("LEV-CH01-VARIABLE-COEFFICIENT-NONCONSERVATION","VariableCoefficientConservationForm","leveque01_exists_hyperbolic_variableCoefficient_without_localFlux",
 "raw PDF page 30; printed Chapter 1 page 8","The paragraph beginning: Hyperbolic equations with variable coefficients may not be in conservation form."),
("LEV-CH01-ONE-STEP-METHOD-DEFINITION","OneStepMethod","leveque01_oneStepMethod_iff_currentStateMap",
 "raw PDF page 32; printed Chapter 1 page 10","Section 1.7 notation paragraph explaining one-step methods: the solution at the next time level is determined entirely by data at the current time level."),
("LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING","EigenbasisDecoupling","leveque01_hyperbolicSystem_scalarWaveDecomposition",
 "raw PDF page 25; printed Chapter 1 page 3","The opening paragraph extending decomposition into scalar wave equations to hyperbolic systems, and the real independent eigenvector criterion and unique decomposition."),
("LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY","FluxJacobianHyperbolicity","leveque01_fluxJacobian_hyperbolicity_iff",
 "raw PDF page 25; printed Chapter 1 page 3","The hyperbolicity criterion for the flux Jacobian immediately after the quasilinear form (1.9), with the preceding real independent eigenvector criterion for A."),
("LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION","RiemannInitialConfiguration","leveque01_riemannInitialConfiguration_iff",
 "raw PDF page 27; printed Chapter 1 page 5","Section 1.2.1 defines a Riemann problem as a hyperbolic equation with special piecewise constant initial data, followed by (1.11)."),
("LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA","MaterialInterfaceRiemannData","leveque01_materialInterfaceRiemannData_iff",
 "raw PDF page 30; printed Chapter 1 page 8","The extension of Riemann initial data to a discontinuity in the medium at x=0 as well as a discontinuity in initial data; the subsequent wave dynamics is a separate claim."),
("LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION","LinearRiemannEigensolution","leveque01_linearRiemann_eigensolution",
 "raw PDF pages 27–28; printed Chapter 1 pages 5–6","Linear hyperbolic Riemann data is solved in terms of the eigenvalues and eigenvectors of A, with the surrounding similarity-solution and wave description."),
("LEV-CH01-RIEMANN-RAY-ZERO-VALUE","RiemannRayZero","leveque01_riemannRayZeroValue_iff",
 "raw PDF page 33; printed Chapter 1 page 11","The final paragraph defines the q-Riemann symbol as the value in the Riemann similarity solution along the ray x/t=0 for specified left and right data."),
("LEV-CH01-NONCONSERVATION-SOURCE-TERMS","NonconservationSourceTerms","leveque01_nonconservation_requires_sourceTerm",
 "raw PDF page 26; printed Chapter 1 page 4","The contaminant example after (1.10), linear advective flux, and the assertion that chemical reactions or other mass nonconservation require source terms."),
("LEV-CH01-NONLINEAR-SHOCK-FORMATION","NonlinearShockFormation","leveque01_nonlinear_shock_formation",
 "raw PDF pages 26–27; printed Chapter 1 pages 4–5","Section 1.1.2 asserts that nonlinear conservation laws can spontaneously develop discontinuities even from smooth initial data."),
]
records=[]
for row,leaf,decl,location,anchor in entries:
    task_id=row+"-PRODUCTION-20260908"
    target="ComputationalMathematics/Source/LeVeque/Chapter01/"+leaf+".lean"
    path=ROOT/target
    text=path.read_text(encoding="utf-8")
    assert "theorem "+decl in text
    taskdir=SESSION/"audits"/task_id
    task={
      "schema_version":"formalization-faithfulness-task-1","task_id":task_id,
      "target":{"path":target,"declaration":"NumStability."+decl},
      "source":{"path":source.relative_to(ROOT).as_posix(),"sha256":SOURCE_SHA,
                "version":"First published in printed format 2002 (PDF copyright 2004)",
                "locations":[{"location":location,"anchor":anchor}]},
      "audit_output":(taskdir/"faithfulness").relative_to(ROOT).as_posix(),
      "source_group":"leveque-chapter01-new-producers-20260908"}
    payload=(json.dumps(task,indent=2,ensure_ascii=False)+"\n").encode()
    out=taskdir/"audit-task.json"
    if out.exists(): assert out.read_bytes()==payload, "immutable task collision"
    else:
      out.parent.mkdir(parents=True,exist_ok=True)
      out.write_bytes(payload)
    records.append({"row":row,"task_id":task_id,"task":out.relative_to(ROOT).as_posix(),
                    "task_sha256":hashlib.sha256(payload).hexdigest(),
                    "target_sha256":hashlib.sha256(path.read_bytes()).hexdigest()})
receipt=SESSION/"new-producer-audit-inputs.json"
payload=(json.dumps({"schema":1,"tasks":records,"status":"inputs only; prepared validation and independent role outputs required"},indent=2)+"\n").encode()
if receipt.exists():assert receipt.read_bytes()==payload
else:receipt.write_bytes(payload)
print(json.dumps({"tasks":len(records),"task_ids":[r["task_id"] for r in records]},indent=2))

