import ComputationalMathematics.HDP.Scalar.SubGaussianDomination
import ComputationalMathematics.HDP.Vector.SubGaussian

/-!
# Domination for sub-Gaussian vectors

Scalar `ψ₂` domination is lifted to finite linear marginals.  The main
specialization says that multiplication by a measurable random radial factor
of absolute value at most one cannot increase the vector `ψ₂` norm.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Vector.SubGaussian

/-- Coordinatewise measurability implies measurability of every finite linear
marginal. -/
lemma measurable_linearMarginal
    {Omega : Type*} [MeasurableSpace Omega] {n : ℕ}
    {X : Fin n → Omega → ℝ} (hX : ∀ i, Measurable (X i))
    (u : Fin n → ℝ) :
    Measurable (NumStability.HDP.Vector.linearMarginal X u) := by
  unfold NumStability.HDP.Vector.linearMarginal
  fun_prop

/-- If every scalar marginal of `X` is pointwise dominated in absolute value
by the corresponding marginal of `Y`, then the vector `ψ₂` norm of `X`
is no larger. -/
theorem psiTwoNorm_le_of_marginal_abs_le
    {Omega : Type*} [MeasurableSpace Omega] {n : ℕ}
    {mu : Measure Omega} {X Y : Fin n → Omega → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hXY : ∀ u omega,
      |NumStability.HDP.Vector.linearMarginal X u omega| ≤
        |NumStability.HDP.Vector.linearMarginal Y u omega|) :
    PsiTwoNorm mu X ≤ PsiTwoNorm mu Y := by
  unfold PsiTwoNorm
  apply iSup_le
  intro u
  calc
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm mu
          (NumStability.HDP.Vector.linearMarginal X u.1) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm mu
          (NumStability.HDP.Vector.linearMarginal Y u.1) :=
      NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_le_of_abs_le
        (measurable_linearMarginal hX u.1) (hXY u.1)
    _ ≤ ⨆ v : UnitDirection n,
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm mu
            (NumStability.HDP.Vector.linearMarginal Y v.1) :=
      le_iSup (fun v : UnitDirection n ↦
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm mu
          (NumStability.HDP.Vector.linearMarginal Y v.1)) u

/-- Marginal absolute-value domination transports qualitative vector
sub-Gaussianity. -/
theorem isSubGaussian_of_marginal_abs_le
    {Omega : Type*} [MeasurableSpace Omega] {n : ℕ}
    {mu : Measure Omega} [IsProbabilityMeasure mu]
    {X Y : Fin n → Omega → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hXY : ∀ u omega,
      |NumStability.HDP.Vector.linearMarginal X u omega| ≤
        |NumStability.HDP.Vector.linearMarginal Y u omega|)
    (hYSubGaussian : IsSubGaussian mu Y) :
    IsSubGaussian mu X := by
  intro u
  exact NumStability.HDP.Scalar.SubGaussian.isSubGaussian_of_abs_le
    (measurable_linearMarginal hX u) (hXY u) (hYSubGaussian u)

/-- Multiply every coordinate of a random vector by the same random radial
factor. -/
def radialContraction {Omega : Type*} {n : ℕ}
    (r : Omega → ℝ) (Y : Fin n → Omega → ℝ) : Fin n → Omega → ℝ :=
  fun i omega ↦ r omega * Y i omega

@[simp]
lemma linearMarginal_radialContraction
    {Omega : Type*} {n : ℕ} (r : Omega → ℝ)
    (Y : Fin n → Omega → ℝ) (u : Fin n → ℝ) (omega : Omega) :
    NumStability.HDP.Vector.linearMarginal (radialContraction r Y) u omega =
      r omega * NumStability.HDP.Vector.linearMarginal Y u omega := by
  unfold NumStability.HDP.Vector.linearMarginal radialContraction
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- A measurable radial contraction cannot increase the vector `ψ₂`
norm. -/
theorem radialContraction_psiTwoNorm_le
    {Omega : Type*} [MeasurableSpace Omega] {n : ℕ}
    {mu : Measure Omega} {r : Omega → ℝ}
    {Y : Fin n → Omega → ℝ}
    (hr : Measurable r) (hY : ∀ i, Measurable (Y i))
    (hrBound : ∀ omega, |r omega| ≤ 1) :
    PsiTwoNorm mu (radialContraction r Y) ≤ PsiTwoNorm mu Y := by
  apply psiTwoNorm_le_of_marginal_abs_le
  · intro i
    exact hr.mul (hY i)
  · intro u omega
    rw [linearMarginal_radialContraction, abs_mul]
    exact mul_le_of_le_one_left (abs_nonneg _) (hrBound omega)

/-- A measurable radial contraction of a sub-Gaussian vector is
sub-Gaussian. -/
theorem radialContraction_isSubGaussian
    {Omega : Type*} [MeasurableSpace Omega] {n : ℕ}
    {mu : Measure Omega} [IsProbabilityMeasure mu]
    {r : Omega → ℝ} {Y : Fin n → Omega → ℝ}
    (hr : Measurable r) (hY : ∀ i, Measurable (Y i))
    (hrBound : ∀ omega, |r omega| ≤ 1)
    (hYSubGaussian : IsSubGaussian mu Y) :
    IsSubGaussian mu (radialContraction r Y) := by
  apply isSubGaussian_of_marginal_abs_le
    (X := radialContraction r Y) (Y := Y)
  · intro i
    exact hr.mul (hY i)
  · intro u omega
    rw [linearMarginal_radialContraction, abs_mul]
    exact mul_le_of_le_one_left (abs_nonneg _) (hrBound omega)
  · exact hYSubGaussian

/-- The vector `ψ₂` norm depends only on the joint vector law. -/
theorem psiTwoNorm_eq_of_hasLaw
    {Omega : Type*} [MeasurableSpace Omega] {n : ℕ}
    {mu : Measure Omega} {nu : Measure (Fin n → ℝ)}
    {X : Fin n → Omega → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : HasLaw (fun omega i ↦ X i omega) nu mu) :
    PsiTwoNorm mu X =
      PsiTwoNorm nu (fun i x ↦ x i) := by
  unfold PsiTwoNorm
  congr 1
  funext u
  let L : (Fin n → ℝ) → ℝ :=
    NumStability.HDP.Vector.linearMarginal (fun i x ↦ x i) u.1
  have hL : Measurable L := by
    dsimp [L]
    exact measurable_linearMarginal (fun i ↦ measurable_pi_apply i) u.1
  have hCanonicalLaw : HasLaw L (Measure.map L nu) nu :=
    ⟨hL.aemeasurable, rfl⟩
  have hSourceLaw : HasLaw
      (NumStability.HDP.Vector.linearMarginal X u.1)
      (Measure.map L nu) mu := by
    simpa [L, NumStability.HDP.Vector.linearMarginal, Function.comp_def] using
      hCanonicalLaw.comp hLaw
  exact NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_sameLaw
    (measurable_linearMarginal hX u.1) hL hSourceLaw hCanonicalLaw

end NumStability.HDP.Vector.SubGaussian
