import ComputationalMathematics.HDP.Vector.GaussianMixtureCanonical

/-!
# Retaining both latent labels in Gaussian-mixture failure events

The canonical iid label law gives the exact probability of each homogeneous
label event. Removing samples with a missing label costs at most their sum.
The failure set itself need not be measurable. This is ordinary mathematics;
no author convention or source discrepancy is selected.
-/

noncomputable section
open MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture
open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- The joint homogeneous-label probability uses the existing finite rectangle. -/
theorem canonicalLabels_singleSign_probability (m n : ℕ) (sign : ℝ)
    (hsign : sign = -1 ∨ sign = 1) :
    latentNoiseSampleMeasure m n {ω | ∀ i, canonicalLabel ω i = sign} =
      ((2 : ℝ≥0∞)⁻¹) ^ m := by
  have hmass : rademacherPMF.toMeasure ({sign} : Set ℝ) = (2 : ℝ≥0∞)⁻¹ := by
    rw [PMF.toMeasure_apply_singleton rademacherPMF sign (measurableSet_singleton _)]
    rcases hsign with rfl | rfl <;> simp [one_div]
  have hrectangle := latentNoiseSampleMeasure_finite_rectangle m n Finset.univ
    (fun _ ↦ ({sign} : Set ℝ)) (fun _ ↦ (Set.univ : Set (Fin n → ℝ)))
    (fun _ _ ↦ measurableSet_singleton _) (fun _ _ ↦ MeasurableSet.univ)
  simpa [canonicalLabel, hmass, Finset.prod_const] using hrectangle

/-- The ordinary probability spelling of the same finite joint event. -/
theorem canonicalLabels_singleSign_probabilityReal (m n : ℕ) (sign : ℝ)
    (hsign : sign = -1 ∨ sign = 1) :
    (latentNoiseSampleMeasure m n).real {ω | ∀ i, canonicalLabel ω i = sign} =
      ((2 : ℝ)⁻¹) ^ m := by
  rw [Measure.real_def, canonicalLabels_singleSign_probability m n sign hsign]
  simp

/-- At most two homogeneous events must be removed to retain both latent labels. -/
theorem canonicalLabels_missingSign_probabilityReal_le (m n : ℕ) :
    (latentNoiseSampleMeasure m n).real
      {ω | ¬ ((∃ i, canonicalLabel ω i = -1) ∧ (∃ i, canonicalLabel ω i = 1))} ≤
      2 * ((2 : ℝ)⁻¹) ^ m := by
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let missing : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ ((∃ i, canonicalLabel ω i = -1) ∧ (∃ i, canonicalLabel ω i = 1))}
  let neg : Set (Fin m → ℝ × (Fin n → ℝ)) := {ω | ∀ i, canonicalLabel ω i = -1}
  let pos : Set (Fin m → ℝ × (Fin n → ℝ)) := {ω | ∀ i, canonicalLabel ω i = 1}
  let invalid : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ ∀ i, canonicalLabel ω i = -1 ∨ canonicalLabel ω i = 1}
  have hinvalid : μ.real invalid = 0 := by
    have hzero : μ invalid = 0 := by
      rw [measure_eq_zero_iff_ae_notMem]
      filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
      exact not_not_intro hω
    rw [Measure.real_def, hzero]; simp
  have hsubset : missing ⊆ (neg ∪ pos) ∪ invalid := by
    intro ω hmissing
    by_cases hbinary : ∀ i, canonicalLabel ω i = -1 ∨ canonicalLabel ω i = 1
    · apply Or.inl
      by_cases hneg : ∃ i, canonicalLabel ω i = -1
      · apply Or.inl
        intro i
        rcases hbinary i with hi | hi
        · exact hi
        · exact False.elim (hmissing ⟨hneg, ⟨i, hi⟩⟩)
      · apply Or.inr
        intro i
        rcases hbinary i with hi | hi
        · exact False.elim (hneg ⟨i, hi⟩)
        · exact hi
    · exact Or.inr hbinary
  have hneg : μ.real neg = ((2 : ℝ)⁻¹) ^ m :=
    canonicalLabels_singleSign_probabilityReal m n (-1) (Or.inl rfl)
  have hpos : μ.real pos = ((2 : ℝ)⁻¹) ^ m :=
    canonicalLabels_singleSign_probabilityReal m n 1 (Or.inr rfl)
  calc
    μ.real missing ≤ μ.real ((neg ∪ pos) ∪ invalid) :=
      measureReal_mono hsubset (measure_ne_top _ _)
    _ ≤ μ.real (neg ∪ pos) + μ.real invalid := measureReal_union_le _ _
    _ ≤ (μ.real neg + μ.real pos) + μ.real invalid :=
      by have h := measureReal_union_le (μ := μ) neg pos; linarith
    _ = 2 * ((2 : ℝ)⁻¹) ^ m := by rw [hneg, hpos, hinvalid]; ring

/-- Any failure lower bound survives on samples containing both labels, with
only the explicit homogeneous-label probability charged. -/
theorem canonicalFailure_withBothLabels_probabilityReal_lower
    (m n : ℕ) (failure : Set (Fin m → ℝ × (Fin n → ℝ))) :
    (latentNoiseSampleMeasure m n).real failure - 2 * ((2 : ℝ)⁻¹) ^ m ≤
      (latentNoiseSampleMeasure m n).real
        {ω | ω ∈ failure ∧ (∃ i, canonicalLabel ω i = -1) ∧
          (∃ i, canonicalLabel ω i = 1)} := by
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let missing : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ ((∃ i, canonicalLabel ω i = -1) ∧ (∃ i, canonicalLabel ω i = 1))}
  have hmissing : μ.real missing ≤ 2 * ((2 : ℝ)⁻¹) ^ m :=
    canonicalLabels_missingSign_probabilityReal_le m n
  calc
    μ.real failure - 2 * ((2 : ℝ)⁻¹) ^ m ≤ μ.real failure - μ.real missing :=
      sub_le_sub_left hmissing _
    _ ≤ μ.real (failure \ missing) := le_measureReal_diff (measure_ne_top _ _)
    _ = _ := by
      congr 1
      ext ω
      simp only [Set.mem_diff, missing, Set.mem_setOf_eq, not_not]

end NumStability.HDP.Vector.GaussianMixture

