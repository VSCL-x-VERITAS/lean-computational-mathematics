import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.TraceProbability
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.Gram
import ComputationalMathematics.Analysis.FiniteProbabilityOptionExpectation

/-!
# Total norm-squared row sampling with an explicit zero-input branch

Nonzero inputs use the literal independent norm-squared row sampler, lifted to
`some`. Zero inputs return `none` deterministically and have an explicit zero
sketch and Gram matrix. Thus the zero branch does not normalize a zero vector
of row weights. This convention also handles empty row or column dimensions.
-/

namespace NumStability

/-- Sum-of-squares denominator zero means that every matrix entry is zero. -/
theorem rowSqNormProbDen_eq_zero_iff {m n : ℕ} (A : Fin m → Fin n → ℝ) :
    rowSqNormProbDen A = 0 ↔ ∀ i j, A i j = 0 :=
  frobNormSqRect_eq_zero_iff A

/-- Total trace law: ordinary independent row sampling for positive weight,
and an explicit deterministic fallback when the input is zero. -/
noncomputable def totalRowSqNormTraceProbability {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) : FiniteProbability (Option (RowTrace m s)) :=
  if h : 0 < rowSqNormProbDen A then
    FiniteProbability.onSome (rowSqNormTraceProbability (steps := s) A h)
  else FiniteProbability.atNone

/-- The fallback outcome returns the zero sketch; ordinary outcomes return the
literal sampled/scaled row sketch. -/
noncomputable def totalRowSampleSketch {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (outcome : Option (RowTrace m s)) : Fin s → Fin n → ℝ :=
  outcome.elim (fun _ _ => 0) (rowSampleSketch s A)

/-- The fallback outcome returns the zero Gram matrix. -/
noncomputable def totalRowSampleGram {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (outcome : Option (RowTrace m s)) : Fin n → Fin n → ℝ :=
  outcome.elim (fun _ _ => 0) (rowSampleGram s A)

@[simp] theorem totalRowSampleSketch_none {m n s : ℕ} (A : Fin m → Fin n → ℝ) :
    totalRowSampleSketch (s := s) A none = fun _ _ => 0 := rfl

@[simp] theorem totalRowSampleSketch_some {m n s : ℕ} (A : Fin m → Fin n → ℝ)
    (samples : RowTrace m s) :
    totalRowSampleSketch A (some samples) = rowSampleSketch s A samples := rfl

@[simp] theorem totalRowSampleGram_none {m n s : ℕ} (A : Fin m → Fin n → ℝ) :
    totalRowSampleGram (s := s) A none = fun _ _ => 0 := rfl

@[simp] theorem totalRowSampleGram_some {m n s : ℕ} (A : Fin m → Fin n → ℝ)
    (samples : RowTrace m s) :
    totalRowSampleGram A (some samples) = rowSampleGram s A samples := rfl

/-- The total Gram observable is exactly the Gram matrix of the total sketch. -/
theorem totalRowSampleGram_eq_rowSketchGram {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (outcome : Option (RowTrace m s)) :
    totalRowSampleGram A outcome = rowSketchGram (totalRowSampleSketch A outcome) := by
  cases outcome with
  | none => ext j k; simp [rowSketchGram]
  | some samples => rfl

/-- On nonzero inputs the total law is the original iid law on `some` traces. -/
theorem totalRowSqNormTraceProbability_of_pos {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (h : 0 < rowSqNormProbDen A) :
    totalRowSqNormTraceProbability (s := s) A =
      FiniteProbability.onSome (rowSqNormTraceProbability (steps := s) A h) := by
  simp only [totalRowSqNormTraceProbability, dif_pos h]

/-- On zero inputs the total law is deterministic at `none`. -/
theorem totalRowSqNormTraceProbability_of_zero {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (h : rowSqNormProbDen A = 0) :
    totalRowSqNormTraceProbability (s := s) A = FiniteProbability.atNone := by
  simp [totalRowSqNormTraceProbability, h]

/-- The zero-input branch returns the explicit zero sketch with probability one. -/
theorem totalRowSqNormTraceProbability_eventProb_zero_sketch_of_zero {m n s : ℕ}
    (A : Fin m → Fin n → ℝ) (h : rowSqNormProbDen A = 0) :
    (totalRowSqNormTraceProbability (s := s) A).eventProb
      {outcome | totalRowSampleSketch A outcome = fun _ _ => 0} = 1 := by
  rw [totalRowSqNormTraceProbability_of_zero A h, FiniteProbability.eventProb_atNone]
  simp

end NumStability
