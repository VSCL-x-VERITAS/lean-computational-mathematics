import ComputationalMathematics.HDP.Vector.SubGaussian
import ComputationalMathematics.HDP.Scalar.SubGaussianDomination

/-!
# Sub-Gaussian vectors from finitely many coordinates

This module lifts closure of the scalar `ψ₂` class under scalar multiplication
and finite sums to arbitrary finite linear marginals. No independence or
centering hypothesis is needed for qualitative sub-Gaussianity.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Vector.SubGaussian

/-- A finite random vector with sub-Gaussian coordinates is sub-Gaussian.
This is the reusable content of Exercise 3.4.3(1). -/
theorem coordinates_vectorSubGaussian
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ}
    (hSub : ∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) :
    IsSubGaussian μ X := by
  intro u
  apply (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite
    (μ := μ) (X := NumStability.HDP.Vector.linearMarginal X u)).2
  change NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
      (NumStability.HDP.Vector.linearMarginal X u) < ∞
  have hEach : ∀ i, (u i) • X i ∈
      NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule μ := by
    intro i
    apply (NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule μ).smul_mem
    exact ⟨(hSub i).1, by
      simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using
        (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite
          (μ := μ) (X := X i)).1 (hSub i)⟩
  have hSum : (∑ i, (u i) • X i) ∈
      NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule μ :=
    (NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule μ).sum_mem
      (fun i _ => hEach i)
  have hEq : (∑ i, (u i) • X i) =
      NumStability.HDP.Vector.linearMarginal X u := by
    funext ω
    simp only [NumStability.HDP.Vector.linearMarginal, Finset.sum_apply,
      Pi.smul_apply, smul_eq_mul]
    apply Finset.sum_congr rfl
    intro i _
    ring
  simpa only [hEq] using hSum.2

/-- A measurable finite-dimensional random vector with finite range is
sub-Gaussian.  No independence or centering assumption is needed. -/
theorem finiteRange_vectorSubGaussian
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i))
    (hRange : (Set.range (fun omega ↦ fun i ↦ X i omega)).Finite) :
    IsSubGaussian μ X := by
  apply coordinates_vectorSubGaussian
  intro i
  have hRangeCoord : (Set.range (X i)).Finite := by
    rw [show Set.range (X i) =
        (fun x : Fin n → ℝ ↦ x i) ''
          Set.range (fun omega ↦ fun j ↦ X j omega) by
      ext y
      constructor
      · rintro ⟨omega, rfl⟩
        exact ⟨fun j ↦ X j omega, ⟨omega, rfl⟩, rfl⟩
      · rintro ⟨x, ⟨omega, rfl⟩, rfl⟩
        exact ⟨omega, rfl⟩]
    exact hRange.image (fun x : Fin n → ℝ ↦ x i)
  have hAbsRange : (Set.range (fun omega ↦ |X i omega|)).Finite := by
    rw [show Set.range (fun omega ↦ |X i omega|) =
        abs '' Set.range (X i) by
      ext y
      constructor
      · rintro ⟨omega, rfl⟩
        exact ⟨X i omega, ⟨omega, rfl⟩, rfl⟩
      · rintro ⟨x, ⟨omega, rfl⟩, rfl⟩
        exact ⟨omega, rfl⟩]
    exact hRangeCoord.image abs
  obtain ⟨M, hM⟩ := (bddAbove_def.mp hAbsRange.bddAbove)
  apply NumStability.HDP.Scalar.SubGaussian.isSubGaussian_of_abs_le_const
    (hMeas i) (show 0 < |M| + 1 by positivity)
  intro omega
  have hUpper : |X i omega| ≤ M :=
    hM _ ⟨omega, rfl⟩
  nlinarith [le_abs_self M]

/-- A measurable finite-dimensional random vector whose law is concentrated on
a finite set is sub-Gaussian.  Unlike `finiteRange_vectorSubGaussian`, this
statement is invariant under modifications on a null set. -/
theorem finiteSupport_vectorSubGaussian
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i))
    (hSupport : ∃ S : Set (Fin n → ℝ), S.Finite ∧
      ∀ᵐ omega ∂μ, (fun i ↦ X i omega) ∈ S) :
    IsSubGaussian μ X := by
  rcases hSupport with ⟨S, hS, hXS⟩
  apply coordinates_vectorSubGaussian
  intro i
  have hAbsValues : ((fun x : Fin n → ℝ ↦ |x i|) '' S).Finite :=
    hS.image (fun x : Fin n → ℝ ↦ |x i|)
  obtain ⟨M, hM⟩ := bddAbove_def.mp hAbsValues.bddAbove
  apply NumStability.HDP.Scalar.SubGaussian.isSubGaussian_of_ae_abs_le_const
    (hMeas i) (show 0 < |M| + 1 by positivity)
  filter_upwards [hXS] with omega hOmega
  have hUpper : |X i omega| ≤ M :=
    hM _ ⟨fun j ↦ X j omega, hOmega, rfl⟩
  nlinarith [le_abs_self M]

/-- Every scalar `ψ₂` norm along a unit direction is bounded by the vector
`ψ₂` norm. -/
theorem scalarPsiTwoNorm_le_vectorPsiTwoNorm
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (u : Fin n → ℝ) (hu : NumStability.vecNorm2 u = 1) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (NumStability.HDP.Vector.linearMarginal X u) ≤
      PsiTwoNorm μ X := by
  unfold PsiTwoNorm
  exact le_iSup (fun v : UnitDirection n ↦
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
      (NumStability.HDP.Vector.linearMarginal X v.1)) ⟨u, hu⟩

/-- The vector obtained by repeating the same scalar random variable in every
coordinate. -/
def repeatedCoordinateVector (n : ℕ) : Fin n → ℝ → ℝ :=
  fun _ x ↦ x

/-- The equal-weight unit direction used to expose the repeated-coordinate
growth. -/
def repeatedCoordinateDirection (n : ℕ) : Fin n → ℝ :=
  fun _ ↦ (Real.sqrt n)⁻¹

lemma repeatedCoordinateDirection_unit {n : ℕ} (hn : 0 < n) :
    NumStability.vecNorm2 (repeatedCoordinateDirection n) = 1 := by
  unfold NumStability.vecNorm2 NumStability.vecNorm2Sq repeatedCoordinateDirection
  rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin]
  have hsqrt : Real.sqrt (n : ℝ) ≠ 0 :=
    ne_of_gt (Real.sqrt_pos.2 (by exact_mod_cast hn))
  have hnnonneg : 0 ≤ (n : ℝ) := by positivity
  rw [nsmul_eq_mul]
  rw [show (n : ℝ) * (Real.sqrt (n : ℝ))⁻¹ ^ 2 = 1 by
    rw [inv_pow]
    field_simp
    exact (Real.sq_sqrt hnnonneg).symm]
  simp

lemma repeatedCoordinate_linearMarginal {n : ℕ} (hn : 0 < n) :
    NumStability.HDP.Vector.linearMarginal
        (repeatedCoordinateVector n) (repeatedCoordinateDirection n) =
      fun x ↦ Real.sqrt n * x := by
  funext x
  unfold NumStability.HDP.Vector.linearMarginal repeatedCoordinateVector
    repeatedCoordinateDirection
  rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  have hsqrt : Real.sqrt (n : ℝ) ≠ 0 :=
    ne_of_gt (Real.sqrt_pos.2 (by exact_mod_cast hn))
  have hnnonneg : 0 ≤ (n : ℝ) := by positivity
  rw [show (n : ℝ) * (x * (Real.sqrt (n : ℝ))⁻¹) = Real.sqrt n * x by
    field_simp
    calc
      (n : ℝ) * x = (Real.sqrt (n : ℝ)) ^ 2 * x := by
        rw [Real.sq_sqrt hnnonneg]
      _ = x * (Real.sqrt (n : ℝ)) ^ 2 := by ring]

/-- Repeating a scalar variable in `n` coordinates amplifies its vector `ψ₂`
norm by at least `√n`. -/
theorem repeatedCoordinate_psiTwoNorm_gap {n : ℕ} (hn : 0 < n) :
    ENNReal.ofReal (Real.sqrt n) *
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw id ≤
      PsiTwoNorm NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
        (repeatedCoordinateVector n) := by
  calc
    ENNReal.ofReal (Real.sqrt n) *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
            NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw id =
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
          (fun x ↦ Real.sqrt n * x) := by
            symm
            simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
              abs_of_nonneg (Real.sqrt_nonneg (n : ℝ))] using
              (NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_smul_of_ne_zero
                (μ := NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw)
                (X := id) (c := Real.sqrt n)
                (ne_of_gt (Real.sqrt_pos.2 (by exact_mod_cast hn))))
    _ = NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
          (NumStability.HDP.Vector.linearMarginal
            (repeatedCoordinateVector n) (repeatedCoordinateDirection n)) := by
            rw [repeatedCoordinate_linearMarginal hn]
    _ ≤ PsiTwoNorm NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
          (repeatedCoordinateVector n) :=
        scalarPsiTwoNorm_le_vectorPsiTwoNorm _ (repeatedCoordinateDirection_unit hn)

/-- Repeating one Rademacher variable in every coordinate gives a family whose
coordinate `ψ₂` scales stay fixed while its vector `ψ₂` scale grows at least
like `√n`. This is the reusable counterexample behind Exercise 3.4.3(2). -/
theorem repeatedCoordinate_counterexample {n : ℕ} (hn : 0 < n) :
    (∀ i : Fin n,
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian
        NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
        (repeatedCoordinateVector n i)) ∧
    IsSubGaussian NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
      (repeatedCoordinateVector n) ∧
    (∀ i : Fin n,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
          (repeatedCoordinateVector n i) =
        ENNReal.ofReal (1 / Real.sqrt (Real.log 2))) ∧
    ENNReal.ofReal (Real.sqrt n) *
        ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) ≤
      PsiTwoNorm NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
        (repeatedCoordinateVector n) := by
  letI : IsProbabilityMeasure
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw :=
    NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw_probability
  have hScalar : NumStability.HDP.Scalar.SubGaussian.IsSubGaussian
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw id := by
    apply (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite).2
    rw [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoGauge_exact]
    exact ENNReal.ofReal_lt_top
  have hCoord : ∀ i : Fin n,
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian
        NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
        (repeatedCoordinateVector n i) := by
    intro i
    simpa [repeatedCoordinateVector] using hScalar
  refine ⟨hCoord, coordinates_vectorSubGaussian hCoord, ?_, ?_⟩
  · intro i
    simpa [repeatedCoordinateVector,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoGauge_exact
  · simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoGauge_exact] using
      repeatedCoordinate_psiTwoNorm_gap hn

end NumStability.HDP.Vector.SubGaussian
