import ComputationalMathematics.HDP.Vector.Isotropy
import Mathlib.Probability.Independence.Integration

/-!
# Isotropy from independent standardized coordinates

This module proves the source-independent bridge from mutually independent,
centered, unit-variance coordinates to finite-vector isotropy.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.Isotropy

/-- A finite random vector with independent zero-mean, unit-variance
coordinates is isotropic. -/
theorem isIsotropic_of_iIndepFun_mean_zero_variance_one
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ}
    (hLp : ∀ i, MemLp (X i) 2 μ)
    (hIndep : iIndepFun X μ)
    (hMean : ∀ i, ∫ ω, X i ω ∂μ = 0)
    (hVar : ∀ i, variance (X i) μ = 1) :
    IsIsotropic μ X := by
  apply (isIsotropic_iff_integral_mul μ X).2
  intro i j
  by_cases hij : i = j
  · subst j
    have hVariance := variance_eq_sub (hLp i)
    rw [hVar i, hMean i] at hVariance
    simpa [pow_two] using hVariance.symm
  · have hPair := hIndep.indepFun hij
    have hFactor := hPair.integral_fun_mul_eq_mul_integral
      ((hLp i).integrable (by norm_num)).1 ((hLp j).integrable (by norm_num)).1
    rw [hFactor, hMean i, hMean j, zero_mul]
    simp [hij]

end NumStability.HDP.Vector.Isotropy
