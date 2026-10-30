import ComputationalMathematics.HDP.Matrix.NetUnionBound
import Mathlib.Data.Finset.Lattice.Fold

/-!
# Literal finite bilinear-maximum event

An ordinary representation bridge for nonempty finite families of actual
matrix bilinear forms. Reuse the existing finite-union probability producer;
no source-domain, zero-denominator or net-convention choice is made here.
-/

noncomputable section
open MeasureTheory Set
open scoped ENNReal

namespace NumStability.HDP.Matrix

/-- A closed threshold for the finite maximum is exactly the finite union of
closed thresholds for its actual matrix pairings. -/
theorem bilinear_maximum_event_eq_union
    {Ω : Type*} {m n : ℕ} (A : Ω → Matrix (Fin m) (Fin n) ℝ)
    (N : Finset (EuclideanSpace ℝ (Fin n)))
    (M : Finset (EuclideanSpace ℝ (Fin m)))
    (hN : N.Nonempty) (hM : M.Nonempty) (u : ℝ) :
    {ω | u ≤ (N ×ˢ M).sup' (hN.product hM)
      (fun xy ↦ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)} =
      ⋃ x ∈ N, ⋃ y ∈ M,
        {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} := by
  ext ω
  simp only [Set.mem_setOf_eq, Finset.le_sup'_iff, Finset.mem_product, Set.mem_iUnion]
  constructor
  · rintro ⟨⟨x, y⟩, ⟨hx, hy⟩, hxy⟩
    exact ⟨x, hx, y, hy, hxy⟩
  · rintro ⟨x, hx, y, hy, hxy⟩
    exact ⟨⟨x, y⟩, ⟨hx, hy⟩, hxy⟩

/-- Existing finite-union calculus, applied to the literal matrix maximum
instead of an arbitrary scalar-family placeholder. -/
theorem measure_bilinear_maximum_ge_le
    {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (μ : Measure Ω) (A : Ω → Matrix (Fin m) (Fin n) ℝ)
    (N : Finset (EuclideanSpace ℝ (Fin n)))
    (M : Finset (EuclideanSpace ℝ (Fin m)))
    (hN : N.Nonempty) (hM : M.Nonempty) (u : ℝ) (p : ℝ≥0∞)
    (hpair : ∀ x ∈ N, ∀ y ∈ M,
      μ {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤ p) :
    μ {ω | u ≤ (N ×ˢ M).sup' (hN.product hM)
      (fun xy ↦ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)} ≤
        (N.card * M.card) * p := by
  rw [bilinear_maximum_event_eq_union A N M hN hM u]
  exact NumStability.HDP.Probability.measure_biUnion_product_le
    μ N M (fun x y ↦ {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y}) p hpair

/-- Substitute the already selected quarter-net cardinality budgets, without
assuming the desired union-event estimate. -/
theorem measure_bilinear_maximum_ge_le_nine_pow
    {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (μ : Measure Ω) (A : Ω → Matrix (Fin m) (Fin n) ℝ)
    (N : Finset (EuclideanSpace ℝ (Fin n)))
    (M : Finset (EuclideanSpace ℝ (Fin m)))
    (hN : N.Nonempty) (hM : M.Nonempty)
    (hNcard : N.card ≤ 9 ^ n) (hMcard : M.card ≤ 9 ^ m)
    (u : ℝ) (p : ℝ≥0∞)
    (hpair : ∀ x ∈ N, ∀ y ∈ M,
      μ {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤ p) :
    μ {ω | u ≤ (N ×ˢ M).sup' (hN.product hM)
      (fun xy ↦ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)} ≤
        ((9 ^ (n + m) : ℕ) : ℝ≥0∞) * p := by
  refine (measure_bilinear_maximum_ge_le μ A N M hN hM u p hpair).trans ?_
  gcongr
  exact_mod_cast (calc
    N.card * M.card ≤ 9 ^ n * 9 ^ m := Nat.mul_le_mul hNcard hMcard
    _ = 9 ^ (n + m) := by rw [pow_add])

end NumStability.HDP.Matrix
