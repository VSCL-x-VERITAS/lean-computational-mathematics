import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Maxima of countable sub-Gaussian families

This file develops reusable support for logarithmically weighted maxima of a
countable family of real random variables.  Independence is deliberately not
assumed: the first step is the countable union bound.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Scalar.SubGaussian

/-- The weight `sqrt (1 + log (i + 1))` for a zero-based encoding of the
one-based index in the logarithmically weighted maximum. -/
def logIndexWeight (i : ℕ) : ℝ :=
  Real.sqrt (1 + Real.log (i + 1 : ℝ))

lemma one_le_logIndexWeight (i : ℕ) : 1 ≤ logIndexWeight i := by
  rw [logIndexWeight, Real.one_le_sqrt]
  have hi : (1 : ℝ) ≤ (i : ℝ) + 1 := by
    have hi0 : (0 : ℝ) ≤ (i : ℝ) := by positivity
    linarith
  exact le_add_of_nonneg_right (Real.log_nonneg hi)

lemma logIndexWeight_pos (i : ℕ) : 0 < logIndexWeight i :=
  lt_of_lt_of_le zero_lt_one (one_le_logIndexWeight i)

/-- The event that one member of a countable family exceeds a logarithmically
weighted threshold. -/
def logWeightedAbsTailEvent {Ω : Type*} (X : ℕ → Ω → ℝ) (t : ℝ) : Set Ω :=
  {ω | ∃ i, t < |X i ω| / logIndexWeight i}

lemma logWeightedAbsTailEvent_eq_iUnion
    {Ω : Type*} (X : ℕ → Ω → ℝ) (t : ℝ) :
    logWeightedAbsTailEvent X t =
      ⋃ i, {ω | t * logIndexWeight i < |X i ω|} := by
  ext ω
  simp only [logWeightedAbsTailEvent, Set.mem_setOf_eq, Set.mem_iUnion]
  constructor
  · rintro ⟨i, hi⟩
    exact ⟨i, (lt_div_iff₀ (logIndexWeight_pos i)).mp hi⟩
  · rintro ⟨i, hi⟩
    exact ⟨i, (lt_div_iff₀ (logIndexWeight_pos i)).mpr hi⟩

/-- A countable union bound for the logarithmically weighted maximum event. -/
theorem measure_logWeightedAbsTailEvent_le_tsum
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (t : ℝ) :
    μ (logWeightedAbsTailEvent X t) ≤
      ∑' i, μ {ω | t * logIndexWeight i < |X i ω|} := by
  rw [logWeightedAbsTailEvent_eq_iUnion]
  exact measure_iUnion_le _

/-- The union bound with a user-supplied summable majorant for the individual
tail events. -/
theorem measure_logWeightedAbsTailEvent_le_tsum_of_le
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (t : ℝ) (q : ℕ → ENNReal)
    (hTail : ∀ i, μ {ω | t * logIndexWeight i < |X i ω|} ≤ q i) :
    μ (logWeightedAbsTailEvent X t) ≤ ∑' i, q i :=
  (measure_logWeightedAbsTailEvent_le_tsum μ X t).trans
    (ENNReal.tsum_le_tsum hTail)

end NumStability.HDP.Scalar.SubGaussian
