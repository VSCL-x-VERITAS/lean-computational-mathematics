import ComputationalMathematics.HDP.Scalar.SubGaussian.Basic
import Mathlib.Data.Matrix.Basic

/-!
# Zero intrinsic scale in a finite family
Ordinary source-neutral compositions of the existing intrinsic maximum and
scalar zero-gauge characterization. No source quotient convention is selected.
-/

noncomputable section

open MeasureTheory
open scoped Classical ENNReal

namespace NumStability.HDP.Scalar.SubGaussian

open NumStability.HDP.Scalar.SubGaussian

/-- The maximum intrinsic scale of a nonempty finite family vanishes exactly when
every entry vanishes almost surely. Finite gauges exclude infinity, whose
`ENNReal.toReal` is also zero. -/
theorem psiTwoNormMax_eq_zero_iff_entries_ae_zero
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : ι → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i))
    (hFinite : ∀ i, PsiTwoNorm μ (X i) < ∞) :
    psiTwoNormMax μ X = 0 ↔
      ∀ i, X i =ᵐ[μ] (fun _ : Ω ↦ (0 : ℝ)) := by
  constructor
  · intro hMax i
    have hReal : (PsiTwoNorm μ (X i)).toReal = 0 :=
      le_antisymm ((psiTwoNorm_toReal_le_max i).trans_eq hMax)
        ENNReal.toReal_nonneg
    have hNorm : PsiTwoNorm μ (X i) = 0 :=
      ((ENNReal.toReal_eq_zero_iff _).mp hReal).resolve_right
        (ne_of_lt (hFinite i))
    exact (psiTwoGauge_eq_zero_iff_ae_eq_zero (hMeas i)).mp hNorm
  · intro hZero
    have hNorm : ∀ i, (PsiTwoNorm μ (X i)).toReal = 0 := by
      intro i
      have hGauge := (psiTwoGauge_eq_zero_iff_ae_eq_zero (hMeas i)).mpr (hZero i)
      change (PsiTwoGauge μ (X i)).toReal = 0
      rw [hGauge, ENNReal.toReal_zero]
    apply le_antisymm ?_ psiTwoNormMax_nonneg
    unfold psiTwoNormMax
    apply Finset.sup'_le
    intro i _hi
    exact le_of_eq (hNorm i)

/-- Zero maximum intrinsic scale is equivalent to all entries vanishing on one
common almost-sure set. The finite-gauge and nonempty-family guards are retained. -/
theorem psiTwoNormMax_eq_zero_iff_simultaneous_ae_zero
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : ι → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i))
    (hFinite : ∀ i, PsiTwoNorm μ (X i) < ∞) :
    psiTwoNormMax μ X = 0 ↔ ∀ᵐ ω ∂μ, ∀ i, X i ω = 0 := by
  rw [psiTwoNormMax_eq_zero_iff_entries_ae_zero hMeas hFinite, ae_all_iff]
  rfl

/-- For a nonempty finite family of measurable entries with finite gauges and
zero maximum scale, the closed one-sided event has probability one for `u ≤ 0`
and zero otherwise. In particular, equality at the zero threshold is included. -/
theorem measure_one_sided_family_event_of_psiTwoNormMax_eq_zero
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : ι → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i))
    (hFinite : ∀ i, PsiTwoNorm μ (X i) < ∞)
    (hMax : psiTwoNormMax μ X = 0) (u : ℝ) :
    μ {ω | ∃ i, u ≤ X i ω} = if u ≤ 0 then 1 else 0 := by
  have hAll := (psiTwoNormMax_eq_zero_iff_simultaneous_ae_zero hMeas hFinite).mp hMax
  by_cases hu : u ≤ 0
  · have hEvent : {ω | ∃ i, u ≤ X i ω} =ᵐ[μ] Set.univ := by
      filter_upwards [hAll] with ω hω
      apply propext
      change (∃ i, u ≤ X i ω) ↔ True
      simp [hω, hu]
    rw [measure_congr hEvent]
    simp [hu]
  · have hEvent : {ω | ∃ i, u ≤ X i ω} =ᵐ[μ] (∅ : Set Ω) := by
      filter_upwards [hAll] with ω hω
      apply propext
      change (∃ i, u ≤ X i ω) ↔ False
      simp [hω, hu]
    rw [measure_congr hEvent]
    simp [hu]

/-- A measurable finite-gauge matrix family has zero maximum entry scale exactly
when the whole matrix is zero almost surely. Both row and column index types
remain nonempty; no empty-maximum convention is selected. -/
theorem psiTwoNormMax_eq_zero_iff_matrix_ae_zero
    {m n : ℕ} [Nonempty (Fin m)] [Nonempty (Fin n)]
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {A : Ω → Matrix (Fin m) (Fin n) ℝ}
    (hMeas : ∀ ij : Fin m × Fin n, Measurable (fun ω ↦ A ω ij.1 ij.2))
    (hFinite : ∀ ij : Fin m × Fin n,
      PsiTwoNorm μ (fun ω ↦ A ω ij.1 ij.2) < ∞) :
    psiTwoNormMax μ (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2) = 0 ↔
      A =ᵐ[μ] (fun _ ↦ (0 : Matrix (Fin m) (Fin n) ℝ)) := by
  rw [psiTwoNormMax_eq_zero_iff_simultaneous_ae_zero hMeas hFinite]
  constructor
  · intro hAll
    filter_upwards [hAll] with ω hω
    ext i j
    exact hω (i, j)
  · intro hAll
    filter_upwards [hAll] with ω hω
    intro ij
    simp [hω]

/-- The zero family on `Fin 1` realizes zero maximum intrinsic scale, with
probability one at threshold zero and probability zero at threshold one. -/
theorem psiTwoNormMax_zero_family_event
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    psiTwoNormMax μ (fun _ : Fin 1 ↦ fun _ : Ω ↦ (0 : ℝ)) = 0 ∧
      μ {_ω : Ω | ∃ _i : Fin 1, (0 : ℝ) ≤ 0} = 1 ∧
      μ {_ω : Ω | ∃ _i : Fin 1, (1 : ℝ) ≤ 0} = 0 := by
  have hMeas : ∀ _i : Fin 1, Measurable (fun _ : Ω ↦ (0 : ℝ)) :=
    fun _ ↦ measurable_const
  have hFinite : ∀ _i : Fin 1, PsiTwoNorm μ (fun _ : Ω ↦ (0 : ℝ)) < ∞ := by
    intro i
    simp [PsiTwoNorm, psiTwoGauge_zero]
  have hMax := (psiTwoNormMax_eq_zero_iff_entries_ae_zero hMeas hFinite).mpr
    (fun _ ↦ Filter.EventuallyEq.rfl)
  have hZero := measure_one_sided_family_event_of_psiTwoNormMax_eq_zero hMeas hFinite hMax 0
  have hOne := measure_one_sided_family_event_of_psiTwoNormMax_eq_zero hMeas hFinite hMax 1
  rw [if_pos le_rfl] at hZero
  rw [if_neg (by norm_num : ¬ (1 : ℝ) ≤ 0)] at hOne
  exact ⟨hMax, hZero, hOne⟩

end NumStability.HDP.Scalar.SubGaussian

