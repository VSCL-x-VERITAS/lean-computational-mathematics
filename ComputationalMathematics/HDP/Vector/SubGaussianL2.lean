import ComputationalMathematics.HDP.Vector.SubGaussian

/-!
# Sub-Gaussian marginals controlled by their `L²` norms

This module packages the dimension-free marginal condition used in covariance
estimation: every scalar linear marginal has `ψ₂` norm at most a fixed multiple
of its `L²` norm.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Vector.SubGaussian

/-- Every scalar linear marginal of `X` has `ψ₂` norm at most `K` times its
`L²` norm.  Both sides are extended nonnegative reals, so the definition also
makes sense before separate moment-finiteness hypotheses are supplied. -/
def SatisfiesPsiTwoL2Bound {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) (K : ℝ≥0) : Prop :=
  ∀ x : Fin n → ℝ,
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (NumStability.HDP.Vector.linearMarginal X x) ≤
      (K : ℝ≥0∞) * eLpNorm (NumStability.HDP.Vector.linearMarginal X x) 2 μ

theorem satisfiesPsiTwoL2Bound_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ} {K : ℝ≥0} :
    SatisfiesPsiTwoL2Bound μ X K ↔
      ∀ x : Fin n → ℝ,
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (NumStability.HDP.Vector.linearMarginal X x) ≤
          (K : ℝ≥0∞) * eLpNorm (NumStability.HDP.Vector.linearMarginal X x) 2 μ := by
  rfl

/-- Under unit `L²` norms for all unit marginals, the relative marginal bound
controls the vector `ψ₂` norm by `K`. -/
theorem psiTwoNorm_le_of_unit_marginal_l2
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ} {K : ℝ≥0}
    (hK : SatisfiesPsiTwoL2Bound μ X K)
    (hL2 : ∀ u : UnitDirection n,
      eLpNorm (NumStability.HDP.Vector.linearMarginal X u.1) 2 μ = 1) :
    PsiTwoNorm μ X ≤ (K : ℝ≥0∞) := by
  unfold PsiTwoNorm
  refine iSup_le fun u ↦ ?_
  simpa [hL2 u] using hK u.1

/-- Under the same normalized-marginal hypothesis, every coordinate has
scalar `ψ₂` norm at most `K`. -/
theorem coordinate_psiTwoNorm_le_of_unit_marginal_l2
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ} {K : ℝ≥0}
    (hK : SatisfiesPsiTwoL2Bound μ X K)
    (hL2 : ∀ u : UnitDirection n,
      eLpNorm (NumStability.HDP.Vector.linearMarginal X u.1) 2 μ = 1)
    (i : Fin n) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i) ≤ (K : ℝ≥0∞) := by
  let e : Fin n → ℝ := Pi.single i 1
  have he : NumStability.vecNorm2 e = 1 := by
    unfold NumStability.vecNorm2 NumStability.vecNorm2Sq e
    rw [Finset.sum_eq_single i]
    · norm_num
    · intro j _ hji
      simp [hji]
    · simp
  have hmarg : NumStability.HDP.Vector.linearMarginal X e = X i := by
    funext ω
    unfold NumStability.HDP.Vector.linearMarginal e
    rw [Finset.sum_eq_single i]
    · simp
    · intro j _ hji
      simp [hji]
    · simp
  have h := hK e
  have hL2e := hL2 ⟨e, he⟩
  rw [hmarg] at h hL2e
  rw [hL2e] at h
  simpa using h

end NumStability.HDP.Vector.SubGaussian
