"""Extract checked moving-step counterexample without duplicating rectangle lemmas."""
from pathlib import Path
import hashlib,json,re
SESSION=Path(__file__).resolve().parent
ROOT=SESSION.parents[3]
candidate=SESSION/"shock-foundation/moving-step-candidate.lean"
raw=candidate.read_text(encoding="utf-8")
body=raw[raw.index("namespace NumStability.ShockFoundation"):]
body=body.replace("NumStability.ShockFoundation","NumStability.MovingStep")
body=body.replace("open Chapter01Scratch Set Filter","open Set Filter")
body=re.sub(r"^#print axioms .*\n","",body,flags=re.M)
extra=r"""
/-- The spatial derivative required by the classical advection equation
cannot exist at the jump crossing, independently of its selected point value. -/
theorem timeShiftedStep_no_classical_advection_at_crossing (v τ : ℝ) :
    ¬ IsLinearAdvectionSolutionAt (timeShiftedStep v τ) 1 0 τ := by
  rintro ⟨qt, qx, _ht, hx, _hresidual⟩
  have hc : ContinuousAt (riemannData (0 : ℝ) v 1) 0 := by
    simpa only [timeShiftedStep, movingStep, travelingWave, sub_self, mul_zero, sub_zero]
      using hx.continuousAt
  exact (riemannData_isRiemannData (0 : ℝ) v 1).not_continuousAt_zero zero_ne_one hc

"""
body=body.replace("\nend\n\nend NumStability.MovingStep", "\n"+extra+"end\n\nend NumStability.MovingStep")
path=ROOT/"ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw/Examples/MovingStep.lean"
if path.exists():raise ValueError("existing owner")
imports=[
"ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution",
"ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData.Regularity",
"Mathlib.Analysis.Calculus.Deriv.Abs"]
text="/-\nSPDX-License-Identifier: MIT\n-/\n\n"+"\n".join("import "+i for i in imports)
text+="\n\n/-!\n# Moving steps and classical mass derivatives\n\nA translated unit step satisfies oriented rectangle conservation.\nWhen its jump crosses a cell endpoint, the cell mass has a corner, for every\nselected jump value. Time translation places the crossing at any chosen time.\n-/\n\nopen MeasureTheory\n\n"+body.strip()+"\n"
path.parent.mkdir(parents=True,exist_ok=True)
path.write_bytes(text.encode())
receipt=SESSION/"production-placement-moving-step.json"
receipt.write_text(json.dumps({"schema":1,"files":[{"path":path.relative_to(ROOT).as_posix(),"sha256":hashlib.sha256(text.encode()).hexdigest(),"candidate":candidate.relative_to(SESSION).as_posix(),"candidate_sha256":hashlib.sha256(candidate.read_bytes()).hexdigest()}],"verification":"pending focused build and exact checks"},indent=2)+"\n",encoding="utf-8")
print(path.relative_to(ROOT))

