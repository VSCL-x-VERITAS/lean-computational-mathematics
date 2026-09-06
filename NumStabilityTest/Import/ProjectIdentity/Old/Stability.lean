import NumStability.Analysis.Stability

/-! Project identity migration: old import API regression. -/

#check NumStability.isBackwardStable
#check NumStability.isNumericallyStable
#check NumStability.mixedForwardBackward_of_backward

open NumStability

example (fp : FPModel) (f alg : ℝ → ℝ) (cBack cForw : ℝ)
    (hback : isBackwardStable fp f alg cBack) (hforw : 0 ≤ cForw) :
    isNumericallyStable fp f alg cBack cForw := by
  intro a
  exact mixedForwardBackward_of_backward f a (alg a) (cBack * fp.u)
    (cForw * fp.u) (hback a) (mul_nonneg hforw fp.u_nonneg)
