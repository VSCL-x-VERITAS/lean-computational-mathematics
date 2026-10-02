import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-!
# Threshold used in sub-Gaussian matrix norm bounds
-/

noncomputable section

namespace NumStability.HDP.Matrix

/-- The threshold used when the fixed-vector tail bound is union-bounded over
quarter-nets of the two unit spheres. -/
def subGaussianNormThreshold (C K : ℝ) (n m : ℕ) (t : ℝ) : ℝ :=
  C * K * (Real.sqrt n + Real.sqrt m + t)

end NumStability.HDP.Matrix
