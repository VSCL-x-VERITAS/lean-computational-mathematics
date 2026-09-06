import Mathlib.Analysis.SpecialFunctions.ExpDeriv

/-! Source-facing Chapter 2 contract for the numeric inequality `1 + x ≤ exp x`. -/

namespace NumStability.HDP.Contract

/-- The elementary exponential inequality used in the Bernoulli MGF estimate. -/
theorem hdp_02_hbody_h2_d3_hone_hplus_hx (x : ℝ) :
    1 + x ≤ Real.exp x := by
  simpa [add_comm] using Real.add_one_le_exp x

end NumStability.HDP.Contract
