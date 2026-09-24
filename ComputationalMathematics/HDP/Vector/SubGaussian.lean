import ComputationalMathematics.HDP.Scalar.SubGaussian.Basic
import ComputationalMathematics.HDP.Vector.LinearMarginals

/-!
# Sub-Gaussian finite random vectors

This module packages the source-independent finite-dimensional definitions of
sub-Gaussianity through scalar linear marginals and of the associated `ψ₂`
norm through unit directions.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.SubGaussian

/-- Unit Euclidean directions in the coordinate model `Fin n → ℝ`. -/
def UnitDirection (n : ℕ) :=
  {u : Fin n → ℝ // NumStability.vecNorm2 u = 1}

/-- A finite real random vector is sub-Gaussian when every scalar linear
marginal is a sub-Gaussian random variable. -/
def IsSubGaussian {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Prop :=
  ∀ u : Fin n → ℝ,
    NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
      (NumStability.HDP.Vector.linearMarginal X u)

/-- The extended `ψ₂` norm of a finite random vector: the supremum of the
scalar `ψ₂` norms of its marginals over the Euclidean unit sphere. -/
noncomputable def PsiTwoNorm {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : ℝ≥0∞ :=
  ⨆ u : UnitDirection n,
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
      (NumStability.HDP.Vector.linearMarginal X u.1)

theorem isSubGaussian_iff {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ} :
    IsSubGaussian μ X ↔
      ∀ u : Fin n → ℝ,
        NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
          (NumStability.HDP.Vector.linearMarginal X u) := by
  rfl

theorem psiTwoNorm_eq_iSup {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ} :
    PsiTwoNorm μ X =
      ⨆ u : UnitDirection n,
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal X u.1) := by
  rfl

/-- A finite vector is sub-Gaussian as soon as its vector `ψ₂` norm is finite. -/
theorem isSubGaussian_of_psiTwoNorm_lt_top
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ}
    (hfinite : PsiTwoNorm μ X < ∞) :
    IsSubGaussian μ X := by
  intro u
  by_cases hrzero : NumStability.vecNorm2 u = 0
  · have huzero : u = 0 := by
      funext i
      exact (NumStability.vecNorm2_eq_zero_iff u).mp hrzero i
    have hmarg : NumStability.HDP.Vector.linearMarginal X u = 0 := by
      funext omega
      simp [NumStability.HDP.Vector.linearMarginal, huzero]
    apply (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite).2
    rw [hmarg, NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm]
    change NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
      (fun _ : Ω ↦ (0 : ℝ)) < ∞
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_zero]
    exact ENNReal.zero_lt_top
  · let r : ℝ := NumStability.vecNorm2 u
    have hr : 0 < r := lt_of_le_of_ne
      (NumStability.vecNorm2_nonneg u) (Ne.symm hrzero)
    let v : Fin n → ℝ := r⁻¹ • u
    have hv : NumStability.vecNorm2 v = 1 := by
      simpa [v, r] using
        (NumStability.vecNorm2_inv_smul_self_of_pos u hr)
    have hvle : NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal X v) ≤
        PsiTwoNorm μ X := by
      unfold PsiTwoNorm
      exact le_iSup
        (fun w : UnitDirection n ↦
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (NumStability.HDP.Vector.linearMarginal X w.1)) ⟨v, hv⟩
    have hvfinite : NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (NumStability.HDP.Vector.linearMarginal X v) < ∞ := hvle.trans_lt hfinite
    have hmarg : NumStability.HDP.Vector.linearMarginal X u =
        fun omega ↦ r * NumStability.HDP.Vector.linearMarginal X v omega := by
      funext omega
      unfold NumStability.HDP.Vector.linearMarginal
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      dsimp [v]
      field_simp [ne_of_gt hr]
    apply (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite).2
    rw [hmarg, NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
      NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_smul_of_ne_zero
        (ne_of_gt hr)]
    exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top (by
      simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using hvfinite)

end NumStability.HDP.Vector.SubGaussian
