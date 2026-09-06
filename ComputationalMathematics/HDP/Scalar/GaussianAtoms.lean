import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
# Gaussian atomlessness

Reusable singleton-mass consequences of the nondegenerate real Gaussian law.
Kept separate from the audited Gaussian-tail module so later atomlessness work
does not invalidate its completed source audits.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Scalar.GaussianAtoms

open NumStability.HDP.Scalar.LimitTheorems

/-- Every singleton has literal zero `ℝ≥0∞` mass under the standard-normal law. -/
theorem standardNormalLaw_singleton (x : ℝ) :
    standardNormalLaw {x} = 0 := by
  letI : NoAtoms (gaussianReal 0 1) :=
    noAtoms_gaussianReal (by norm_num : (1 : NNReal) ≠ 0)
  rw [standardNormalLaw, measure_singleton]

/-- Real-valued corollary of `standardNormalLaw_singleton`. -/
theorem standardNormalLaw_real_singleton (x : ℝ) :
    standardNormalLaw.real {x} = 0 := by
  rw [Measure.real_def, standardNormalLaw_singleton, ENNReal.toReal_zero]

end NumStability.HDP.Scalar.GaussianAtoms
