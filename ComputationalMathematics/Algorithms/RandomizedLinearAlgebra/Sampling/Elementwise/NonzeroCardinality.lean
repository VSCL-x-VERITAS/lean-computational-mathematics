import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.Elementwise.Core

/-! A trace of `s` single-entry updates has at most `s` nonzero entries. -/

namespace NumStability

open scoped BigOperators

/-- A zero-initialized entry sampler never creates an entry outside its sampled coordinates. -/
theorem elementwiseTraceSketch_eq_zero_of_not_mem_range
    {m n steps : ℕ} (s : ℕ) (A : Fin m → Fin n → ℝ)
    (samples : ElementwiseTrace m n steps) (i : Fin m) (j : Fin n)
    (h : (i, j) ∉ Set.range samples) :
    elementwiseTraceSketch s A (fun _ _ => 0) samples i j = 0 := by
  classical
  simp only [elementwiseTraceSketch, zero_add]
  apply Finset.sum_eq_zero
  intro t _
  have hhit : ¬ sampleHits samples t i j := by
    intro hh
    exact h ⟨t, Prod.ext hh.1 hh.2⟩
  simp [elementwiseTraceContribution, hhit]

/-- Repeated hits are accumulated: they do not count as additional nonzero coordinates. -/
theorem elementwiseTraceSketch_nonzero_card_le
    {m n steps : ℕ} (s : ℕ) (A : Fin m → Fin n → ℝ)
    (samples : ElementwiseTrace m n steps) :
    (Finset.univ.filter (fun ij : Fin m × Fin n =>
      elementwiseTraceSketch s A (fun _ _ => 0) samples ij.1 ij.2 ≠ 0)).card ≤ steps := by
  classical
  have hsub :
      Finset.univ.filter (fun ij : Fin m × Fin n =>
        elementwiseTraceSketch s A (fun _ _ => 0) samples ij.1 ij.2 ≠ 0) ⊆
      Finset.univ.image samples := by
    intro ij hij
    by_contra hnot
    have hrange : ij ∉ Set.range samples := by simpa using hnot
    exact (Finset.mem_filter.mp hij).2
      (elementwiseTraceSketch_eq_zero_of_not_mem_range s A samples ij.1 ij.2 hrange)
  exact (Finset.card_le_card hsub).trans (by simpa using Finset.card_image_le (s := Finset.univ) (f := samples))

end NumStability
