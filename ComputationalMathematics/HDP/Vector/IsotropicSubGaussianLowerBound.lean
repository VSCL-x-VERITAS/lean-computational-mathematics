import ComputationalMathematics.HDP.Scalar.SubGaussianMomentLowerBound
import ComputationalMathematics.HDP.Vector.Isotropy
import ComputationalMathematics.HDP.Vector.SubGaussianFinite
import ComputationalMathematics.HDP.Vector.Whitening

/-!
# A universal lower bound for isotropic vector ψ₂ norm

One coordinate of an isotropic vector has unit second moment. Its scalar
gauge is a lower bound for the vector gauge through a coordinate axis.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.SubGaussian

/-- A coordinate axis is a unit direction for the finite Euclidean norm. -/
private theorem coordinateAxis_unit {n : ℕ} (i : Fin n) :
    NumStability.vecNorm2 (Pi.single i 1 : Fin n → ℝ) = 1 := by
  unfold NumStability.vecNorm2 NumStability.vecNorm2Sq
  rw [Finset.sum_eq_single i]
  · norm_num
  · intro j _ hji
    simp [hji]
  · simp

/-- An isotropic random vector with a finite coordinate second moment has
vector `ψ₂` norm at least `1 / √(log 2)`. -/
theorem psiTwoNorm_ge_of_isotropic_coordinate
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {n : ℕ} {X : Fin n → Ω → ℝ}
    (hIso : NumStability.HDP.Vector.Isotropy.IsIsotropic μ X)
    (i : Fin n) (hSq : Integrable (fun ω => X i ω ^ 2) μ) :
    ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) ≤ PsiTwoNorm μ X := by
  have hScalar :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_ge_of_unit_secondMoment
      hSq (NumStability.HDP.Vector.Isotropy.integral_sq_coordinate hIso i)
  have hMarginal :
      NumStability.HDP.Vector.linearMarginal X (Pi.single i 1) = X i := by
    funext ω
    unfold NumStability.HDP.Vector.linearMarginal
    rw [Finset.sum_eq_single i]
    · simp
    · intro j _ hji
      simp [hji]
    · simp
  calc
    ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i) := hScalar
    _ = NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal X (Pi.single i 1)) := by
            rw [hMarginal]
    _ ≤ PsiTwoNorm μ X := scalarPsiTwoNorm_le_vectorPsiTwoNorm
      (Pi.single i 1) (coordinateAxis_unit i)

/-- In positive dimension, an isotropic vector cannot have `ψ₂` norm at most
one. This is the exact-gauge obstruction to extending a singular whitening
construction while retaining a supplied bound `K = 1`. -/
theorem one_lt_psiTwoNorm_of_isotropic_coordinate
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {n : ℕ} {X : Fin n → Ω → ℝ}
    (hIso : NumStability.HDP.Vector.Isotropy.IsIsotropic μ X)
    (i : Fin n) (hSq : Integrable (fun ω => X i ω ^ 2) μ) :
    (1 : ℝ≥0∞) < PsiTwoNorm μ X := by
  have hlogPos : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hlogLt : Real.log 2 < 1 := by
    have h := Real.log_lt_sub_one_of_pos
      (show (0 : ℝ) < 2 by norm_num) (show (2 : ℝ) ≠ 1 by norm_num)
    norm_num at h
    exact h
  have hsqrtPos : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hlogPos
  have hsqrtLt : Real.sqrt (Real.log 2) < 1 := by
    nlinarith [Real.sq_sqrt hlogPos.le]
  have hReal : (1 : ℝ) < 1 / Real.sqrt (Real.log 2) := by
    apply (lt_div_iff₀ hsqrtPos).2
    simpa using hsqrtLt
  have hScale : (1 : ℝ≥0∞) <
      ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) := by
    rw [← ENNReal.ofReal_one]
    exact (ENNReal.ofReal_lt_ofReal_iff (by positivity)).2 hReal
  exact lt_of_lt_of_le hScale (psiTwoNorm_ge_of_isotropic_coordinate hIso i hSq)

/-- In positive dimension, isotropy is incompatible with the relative
`ψ₂`/`L²` condition at the exact constant `K = 1`. The `MemLp` premise makes
the ordinary second moments used by isotropy finite. -/
theorem not_isotropic_relativePsiTwoL2Bound_one
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {n : ℕ} {X : Fin n → Ω → ℝ}
    (hLp : ∀ j, MemLp (X j) 2 μ)
    (hIso : NumStability.HDP.Vector.Isotropy.IsIsotropic μ X)
    (hK : SatisfiesPsiTwoL2Bound μ X 1) (i : Fin n) : False := by
  have hSq : Integrable (fun ω => X i ω ^ 2) μ :=
    (memLp_two_iff_integrable_sq (hLp i).aestronglyMeasurable).mp (hLp i)
  have hUpper : PsiTwoNorm μ X ≤ (1 : ℝ≥0∞) := by
    simpa using psiTwoNorm_le_of_unit_marginal_l2 hK
      (fun u => NumStability.HDP.Vector.Whitening.unit_marginal_eLpNorm_of_isotropy
        hLp hIso u)
  exact (not_lt_of_ge hUpper) (one_lt_psiTwoNorm_of_isotropic_coordinate hIso i hSq)

end NumStability.HDP.Vector.SubGaussian
