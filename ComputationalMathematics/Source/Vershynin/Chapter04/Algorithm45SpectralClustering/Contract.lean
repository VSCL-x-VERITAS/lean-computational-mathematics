import ComputationalMathematics.HDP.Graph.SpectralClustering
import Mathlib.Combinatorics.SimpleGraph.AdjMatrix

/-!
# Vershynin Chapter 4, graph spectral clustering algorithm

An undirected loopless adjacency relation describes exactly a simple graph.
The full decreasing eigenbasis and the sign outputs are stated in coordinates.
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin's graph spectral-clustering algorithm: construct the adjacency
matrix, select the second vector in a complete decreasing eigenbasis, and put
strictly positive coordinates in the first community and all others in the
second. Symmetry and looplessness express the input graph domain; every
`SimpleGraph` supplies these fields, and conversely they construct one.
No eigengap or nonempty-community hypothesis is imposed. -/
theorem hdp_04_algorithm_4_5_spectral_clustering {n : ℕ}
    (adj : Fin n → Fin n → Prop) [DecidableRel adj]
    (hsym : ∀ i j, adj i j → adj j i) (hloop : ∀ i, ¬adj i i)
    (hn : 1 < n) :
    let A : Matrix (Fin n) (Fin n) ℝ := fun i j ↦ if adj i j then 1 else 0
    ∃ (eigenvalue : Fin n → ℝ) (b : Fin n → Fin n → ℝ)
      (first second : Set (Fin n)),
      (∀ i j, i.val ≤ j.val → eigenvalue j ≤ eigenvalue i) ∧
      (∀ i j, (∑ k, b i k * b j k) = if i = j then 1 else 0) ∧
      (∀ x : Fin n → ℝ, ∀ j, (∑ i, (∑ k, b i k * x k) * b i j) = x j) ∧
      (∀ i j, (∑ k, A j k * b i k) = eigenvalue i * b i j) ∧
      (∀ j, j ∈ first ↔ 0 < b ⟨1, hn⟩ j) ∧
      (∀ j, j ∈ second ↔ b ⟨1, hn⟩ j ≤ 0) := by
  let G : SimpleGraph (Fin n) :=
    { Adj := adj, symm := hsym, loopless := ⟨hloop⟩ }
  let A : Matrix (Fin n) (Fin n) ℝ := G.adjMatrix ℝ
  have hA : A.IsHermitian := by
    ext i j
    simp [A, Matrix.conjTranspose]
  let eigenvalue := NumStability.hermitianOrderedEigenvalue hA
  let B := NumStability.hermitianOrderedEigenbasis hA
  let b : Fin n → Fin n → ℝ := fun i ↦ WithLp.ofLp (B i)
  refine ⟨eigenvalue, b, {j | 0 < b ⟨1, hn⟩ j}, {j | b ⟨1, hn⟩ j ≤ 0},
    ?_, ?_, ?_, ?_, fun _ ↦ Iff.rfl, fun _ ↦ Iff.rfl⟩
  · intro i j hij
    exact NumStability.hermitianOrderedEigenvalue_antitone hA hij
  · intro i j
    have h := (orthonormal_iff_ite.mp B.orthonormal) i j
    simpa [b, PiLp.inner_apply, real_inner_eq_re_inner, RCLike.inner_apply, mul_comm] using h
  · intro x j
    have h := congrArg (fun y : EuclideanSpace ℝ (Fin n) ↦ y j)
      (B.sum_repr' (WithLp.toLp 2 x))
    simpa [b, PiLp.inner_apply, real_inner_eq_re_inner, RCLike.inner_apply, mul_comm] using h
  · intro i j
    have h := congrArg (fun y : EuclideanSpace ℝ (Fin n) ↦ y j)
      (NumStability.hermitianOrderedEigenbasis_apply hA i)
    simpa [A, G, B, b, eigenvalue, Matrix.toLpLin_apply, Matrix.mulVec, dotProduct,
      SimpleGraph.adjMatrix_apply] using h

end NumStability.HDP.Contract
