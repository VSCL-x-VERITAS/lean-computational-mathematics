import Mathlib.Probability.Distributions.Gaussian.HasGaussianLaw.Independence

/-!
# Independence and covariance for finite Gaussian families

This module packages the source-independent equivalence between mutual
independence and pairwise zero covariance for a finite jointly Gaussian family.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.Gaussian

/-- A finite jointly Gaussian real family is mutually independent exactly when
its distinct coordinates have zero covariance. -/
theorem iIndepFun_iff_covariance_eq_zero_of_hasGaussianLaw
    {Ω : Type*} [MeasurableSpace Ω] {ι : Type*} [Finite ι]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hX : HasGaussianLaw (fun ω i => X i ω) μ) :
    iIndepFun X μ ↔ ∀ i j, i ≠ j → cov[X i, X j; μ] = 0 := by
  constructor
  · intro hIndep i j hij
    exact (hIndep.indepFun hij).covariance_eq_zero
      (hX.eval i).memLp_two (hX.eval j).memLp_two
  · exact hX.iIndepFun_of_covariance_eq_zero

end NumStability.HDP.Vector.Gaussian
