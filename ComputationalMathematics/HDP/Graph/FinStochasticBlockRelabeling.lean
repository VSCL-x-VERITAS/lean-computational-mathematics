import ComputationalMathematics.HDP.Graph.FinStochasticBlock
import Mathlib.Data.Sym.Basic
import Mathlib.Data.Sym.Sym2.Order
import Mathlib.MeasureTheory.Constructions.Pi

/-!
# Relabeling the finite loopless stochastic-block law

A supplied vertex equivalence transports unordered edge coordinates, including
zero-probability diagonal coordinates. If it preserves community labels, the
coordinate permutation preserves the exact Bernoulli product law and commutes
with adjacency decoding and reindexing the expected matrix. No vertex order,
positive dimension, balance or eigenvector choice is assumed.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Graph.FinStochasticBlock

private def unorderedRelabel {n m : ℕ} (e : Fin n ≃ Fin m) : Sym2 (Fin n) ≃ Sym2 (Fin m) :=
  (Sym2.equivSym (Fin n)).trans
    ((Sym.equivCongr (n := 2) e).trans (Sym2.equivSym (Fin m)).symm)

private theorem unorderedRelabel_mk {n m : ℕ} (e : Fin n ≃ Fin m) (i j : Fin n) :
    unorderedRelabel e s(i, j) = s(e i, e j) := by
  rfl

/-- Relabel unordered upper-triangular coordinates, retaining the diagonal. -/
def upperPairEquiv {n m : ℕ} (e : Fin n ≃ Fin m) : UpperPair n ≃ UpperPair m :=
  (Sym2.sortEquiv (α := Fin n)).symm.trans
    ((unorderedRelabel e).trans (Sym2.sortEquiv (α := Fin m)))

private theorem upperPairEquiv_sort {n m : ℕ} (e : Fin n ≃ Fin m) (i j : Fin n) :
    upperPairEquiv e (Sym2.sortEquiv s(i, j)) = Sym2.sortEquiv s(e i, e j) := by
  simp only [upperPairEquiv, Equiv.trans_apply, Equiv.symm_apply_apply, unorderedRelabel_mk]

/-- The corresponding measurable permutation of all edge coordinates. -/
def sampleRelabel {n m : ℕ} (e : Fin n ≃ Fin m) :
    (UpperPair n → Bool) ≃ᵐ (UpperPair m → Bool) :=
  MeasurableEquiv.piCongrLeft (fun _ : UpperPair m => Bool) (upperPairEquiv e)

private theorem upperProbability_upperPairEquiv {n m : ℕ}
    (c : Fin n → Fin 2) (d : Fin m → Fin 2) (e : Fin n ≃ Fin m)
    (hc : ∀ i, d (e i) = c i) (θ : StochasticBlock.Parameters) (a : UpperPair n) :
    upperProbability d θ (upperPairEquiv e a) = upperProbability c θ a := by
  obtain ⟨⟨i, j⟩, hij⟩ := a
  have ha : (⟨(i, j), hij⟩ : UpperPair n) = Sym2.sortEquiv s(i, j) := by
    apply Subtype.ext
    simp [Sym2.sortEquiv, hij]
  rw [ha, upperPairEquiv_sort]
  by_cases he : e i ≤ e j
  · simp [upperProbability, Sym2.sortEquiv, he, hij, hc, e.injective.eq_iff]
  · have hrev : e j ≤ e i := le_of_not_ge he
    simp [upperProbability, Sym2.sortEquiv, hrev, hij, hc, e.injective.eq_iff, eq_comm]

/-- Community-preserving vertex relabeling transports the exact product law. -/
theorem measure_map_sampleRelabel {n m : ℕ}
    (c : Fin n → Fin 2) (d : Fin m → Fin 2) (e : Fin n ≃ Fin m)
    (hc : ∀ i, d (e i) = c i) (θ : StochasticBlock.Parameters) :
    (measure c θ).map (sampleRelabel e) = measure d θ := by
  have hμ : (fun a : UpperPair n =>
      (PMF.bernoulli (upperProbability d θ (upperPairEquiv e a))
        (upperProbability_le_one d θ (upperPairEquiv e a))).toMeasure) =
      (fun a : UpperPair n =>
        (PMF.bernoulli (upperProbability c θ a)
          (upperProbability_le_one c θ a)).toMeasure) := by
    funext a
    congr 2
    exact upperProbability_upperPairEquiv c d e hc θ a
  unfold measure sampleRelabel
  rw [← hμ]
  exact Measure.pi_map_piCongrLeft (upperPairEquiv e)
    (fun a : UpperPair m => (PMF.bernoulli (upperProbability d θ a)
      (upperProbability_le_one d θ a)).toMeasure)

private theorem adjacency_sort {n : ℕ} (ω : UpperPair n → Bool) (i j : Fin n) :
    adjacency ω i j = if i = j then 0 else cond (ω (Sym2.sortEquiv s(i, j))) 1 0 := by
  by_cases hij : i ≤ j
  · simp [adjacency, Sym2.sortEquiv, hij]
  · have hji : j ≤ i := le_of_not_ge hij
    have hne : i ≠ j := fun h => hij (h.le)
    simp [adjacency, Sym2.sortEquiv, hij, hji, hne]

/-- Relabeling samples and vertices commutes with loopless adjacency decoding. -/
theorem adjacency_sampleRelabel {n m : ℕ} (e : Fin n ≃ Fin m) (ω : UpperPair n → Bool) :
    Matrix.reindex e e (adjacency ω) = adjacency (sampleRelabel e ω) := by
  apply Matrix.ext
  intro i j
  obtain ⟨i, rfl⟩ := e.surjective i
  obtain ⟨j, rfl⟩ := e.surjective j
  simp only [Matrix.reindex_apply, Matrix.submatrix_apply, Equiv.symm_apply_apply, adjacency_sort, e.injective.eq_iff]
  rw [← upperPairEquiv_sort]
  simp only [sampleRelabel, MeasurableEquiv.piCongrLeft_apply_apply]

/-- Community-preserving reindexing transports the loopless expected matrix. -/
theorem expectedAdjacency_reindex {n m : ℕ}
    (c : Fin n → Fin 2) (d : Fin m → Fin 2) (e : Fin n ≃ Fin m)
    (hc : ∀ i, d (e i) = c i) (p q : ℝ) :
    Matrix.reindex e e (expectedAdjacency c p q) = expectedAdjacency d p q := by
  apply Matrix.ext
  intro i j
  obtain ⟨i, rfl⟩ := e.surjective i
  obtain ⟨j, rfl⟩ := e.surjective j
  simp [Matrix.reindex_apply, expectedAdjacency, hc, e.injective.eq_iff]

end NumStability.HDP.Graph.FinStochasticBlock
