import ComputationalMathematics.HDP.Graph.MaxCut
import ComputationalMathematics.HDP.Optimization.SignQuadratic
import Mathlib.Combinatorics.SimpleGraph.AdjMatrix
import Mathlib.Combinatorics.SimpleGraph.DegreeSum

/-!
# Sign-vector formulas for finite graph cuts

This file connects bipartitions represented by vertex subsets with the
two-valued sign vectors and adjacency-matrix objective used in the maximum-cut
relaxation.
-/

namespace NumStability.HDP.Graph

open scoped BigOperators
open SimpleGraph

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- The sign vector associated with a bipartition represented by one side. -/
def partitionSign (S : Finset V) (v : V) : NumStability.HDP.Optimization.Sign :=
  if v ∈ S then .pos else .neg

omit [Fintype V] in
@[simp] theorem partitionSign_value (S : Finset V) (v : V) :
    (partitionSign S v).value = if v ∈ S then (1 : ℝ) else -1 := by
  by_cases hv : v ∈ S <;> simp [partitionSign, hv]

omit [Fintype V] in
theorem one_sub_partitionSign_mul (S : Finset V) (u v : V) :
    1 - (partitionSign S u).value * (partitionSign S v).value =
      if (u ∈ S) ≠ (v ∈ S) then (2 : ℝ) else 0 := by
  by_cases hu : u ∈ S <;> by_cases hv : v ∈ S <;>
    simp [partitionSign_value, hu, hv] <;> ring

/-- The subgraph consisting exactly of the edges crossing `S | Sᶜ`. -/
def crossingSubgraph (G : SimpleGraph V) (S : Finset V) : SimpleGraph V where
  Adj u v := G.Adj u v ∧ (u ∈ S) ≠ (v ∈ S)
  symm _ _ h := ⟨G.symm h.1, not_congr eq_comm |>.mp h.2⟩
  loopless := ⟨fun v h ↦ G.loopless.irrefl v h.1⟩

instance (G : SimpleGraph V) [DecidableRel G.Adj] (S : Finset V) :
    DecidableRel (crossingSubgraph G S).Adj := fun u v ↦ by
  change Decidable (G.Adj u v ∧ (u ∈ S) ≠ (v ∈ S))
  infer_instance

omit [Fintype V] [DecidableEq V] in
@[simp] theorem crossingSubgraph_adj (G : SimpleGraph V) (S : Finset V) (u v : V) :
    (crossingSubgraph G S).Adj u v ↔ G.Adj u v ∧ (u ∈ S) ≠ (v ∈ S) :=
  Iff.rfl

@[simp] theorem crossingSubgraph_card_edgeFinset (G : SimpleGraph V)
    [DecidableRel G.Adj] (S : Finset V) :
    (crossingSubgraph G S).edgeFinset.card = cutSize G S := by
  classical
  unfold cutSize
  congr 1
  ext e
  induction e using Sym2.ind with
  | _ u v => simp [EdgeCrosses]

omit [DecidableEq V] in
/-- The adjacency-matrix value of a sign labeling, normalized so that an edge
whose endpoints have opposite labels contributes one after double counting. -/
noncomputable def signCutValue (G : SimpleGraph V) [DecidableRel G.Adj]
    (x : V → NumStability.HDP.Optimization.Sign) : ℝ :=
  (1 / 4 : ℝ) *
    ∑ i, ∑ j, G.adjMatrix ℝ i j * (1 - (x i).value * (x j).value)

omit [DecidableEq V] in
/-- The sign cut value as one half of the ordered adjacency sum restricted to
pairs with opposite labels. -/
theorem signCutValue_eq_half_sum_opposite (G : SimpleGraph V) [DecidableRel G.Adj]
    (x : V → NumStability.HDP.Optimization.Sign) :
    signCutValue G x =
      (1 / 2 : ℝ) * ∑ i, ∑ j,
        if x i ≠ x j then G.adjMatrix ℝ i j else 0 := by
  rw [signCutValue]
  have hterm (i j : V) :
      G.adjMatrix ℝ i j * (1 - (x i).value * (x j).value) =
        2 * (if x i ≠ x j then G.adjMatrix ℝ i j else 0) := by
    cases x i <;> cases x j <;> simp [NumStability.HDP.Optimization.Sign.value] <;> ring
  simp_rw [hterm]
  calc
    (1 / 4 : ℝ) * ∑ i, ∑ j,
          2 * (if x i ≠ x j then G.adjMatrix ℝ i j else 0) =
        (1 / 4 : ℝ) * (2 * ∑ i, ∑ j,
          if x i ≠ x j then G.adjMatrix ℝ i j else 0) := by
      congr 1
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i hi
      rw [Finset.mul_sum]
    _ = (1 / 2 : ℝ) * ∑ i, ∑ j,
          if x i ≠ x j then G.adjMatrix ℝ i j else 0 := by
      ring

theorem sum_crossing_indicator (G : SimpleGraph V) [DecidableRel G.Adj]
    (S : Finset V) :
    (∑ i, ∑ j, if G.Adj i j ∧ (i ∈ S) ≠ (j ∈ S) then (1 : ℝ) else 0) =
      2 * (cutSize G S : ℝ) := by
  let H := crossingSubgraph G S
  have hsum :
      (∑ p : V × V, if H.Adj p.1 p.2 then (1 : ℝ) else 0) =
        ((Finset.univ.filter fun p : V × V ↦ H.Adj p.1 p.2).card : ℝ) := by
    simp
  rw [Fintype.sum_prod_type] at hsum
  rw [show (∑ i, ∑ j, if G.Adj i j ∧ (i ∈ S) ≠ (j ∈ S) then (1 : ℝ) else 0) =
      ∑ i, ∑ j, if H.Adj i j then (1 : ℝ) else 0 by rfl, hsum]
  rw [← Nat.cast_ofNat, ← Nat.cast_mul,
    ← SimpleGraph.two_mul_card_edgeFinset H,
    crossingSubgraph_card_edgeFinset]

theorem signCutValue_partitionSign (G : SimpleGraph V) [DecidableRel G.Adj]
    (S : Finset V) :
    signCutValue G (partitionSign S) = (cutSize G S : ℝ) := by
  rw [signCutValue]
  have hterm : ∀ i j : V,
      G.adjMatrix ℝ i j *
          (1 - (partitionSign S i).value * (partitionSign S j).value) =
        2 * (if G.Adj i j ∧ (i ∈ S) ≠ (j ∈ S) then (1 : ℝ) else 0) := by
    intro i j
    rw [G.adjMatrix_apply, one_sub_partitionSign_mul]
    by_cases hij : G.Adj i j <;> by_cases hcross : (i ∈ S) ≠ (j ∈ S) <;>
      simp [hij, hcross]
  simp_rw [hterm]
  have hfactor :
      (∑ i : V, ∑ j : V,
          2 * (if G.Adj i j ∧ (i ∈ S) ≠ (j ∈ S) then (1 : ℝ) else 0)) =
        2 * (∑ i : V, ∑ j : V,
          if G.Adj i j ∧ (i ∈ S) ≠ (j ∈ S) then (1 : ℝ) else 0) := by
    change
      Finset.univ.sum (fun i ↦ Finset.univ.sum (fun j ↦
          2 * (if G.Adj i j ∧ (i ∈ S) ≠ (j ∈ S) then (1 : ℝ) else 0))) =
        2 * Finset.univ.sum (fun i ↦ Finset.univ.sum (fun j ↦
          if G.Adj i j ∧ (i ∈ S) ≠ (j ∈ S) then (1 : ℝ) else 0))
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i hi
    exact (Finset.mul_sum Finset.univ
      (fun j ↦ if G.Adj i j ∧ (i ∈ S) ≠ (j ∈ S) then (1 : ℝ) else 0) 2).symm
  rw [hfactor, sum_crossing_indicator]
  ring

/-- The positive side of the bipartition encoded by a sign labeling. -/
def positiveVertices (x : V → NumStability.HDP.Optimization.Sign) : Finset V :=
  Finset.univ.filter fun v ↦ x v = .pos

@[simp] theorem partitionSign_positiveVertices
    (x : V → NumStability.HDP.Optimization.Sign) :
    partitionSign (positiveVertices x) = x := by
  funext v
  cases hx : x v <;> simp [partitionSign, positiveVertices, hx]

/-- The sign-vector formula counts exactly the edges crossing its encoded
bipartition. -/
theorem signCutValue_eq_cutSize_positiveVertices (G : SimpleGraph V)
    [DecidableRel G.Adj] (x : V → NumStability.HDP.Optimization.Sign) :
    signCutValue G x = (cutSize G (positiveVertices x) : ℝ) := by
  calc
    signCutValue G x = signCutValue G (partitionSign (positiveVertices x)) :=
      congrArg (signCutValue G) (partitionSign_positiveVertices x).symm
    _ = (cutSize G (positiveVertices x) : ℝ) :=
      signCutValue_partitionSign G (positiveVertices x)

theorem signCutValue_le_maxCut (G : SimpleGraph V) [DecidableRel G.Adj]
    (x : V → NumStability.HDP.Optimization.Sign) :
    signCutValue G x ≤ (maxCut G : ℝ) := by
  rw [signCutValue_eq_cutSize_positiveVertices]
  exact_mod_cast cutSize_le_maxCut G (positiveVertices x)

/-- A sign labeling attains the maximum cut. -/
theorem exists_signCutValue_eq_maxCut (G : SimpleGraph V) [DecidableRel G.Adj] :
    ∃ x : V → NumStability.HDP.Optimization.Sign,
      signCutValue G x = (maxCut G : ℝ) := by
  obtain ⟨S, hS⟩ := exists_cutSize_eq_maxCut G
  exact ⟨partitionSign S, (signCutValue_partitionSign G S).trans (congrArg Nat.cast hS)⟩

end NumStability.HDP.Graph
