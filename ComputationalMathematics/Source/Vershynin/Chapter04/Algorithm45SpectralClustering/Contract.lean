import ComputationalMathematics.HDP.Graph.SpectralClustering
import ComputationalMathematics.Analysis.Eigenvalues.OrderedSpectrum
import Mathlib.Combinatorics.SimpleGraph.AdjMatrix

/-!
# Vershynin Chapter 4, graph spectral clustering algorithm
-/

noncomputable section

open Matrix Set

namespace NumStability.HDP.Contract

/-- Vershynin's graph spectral-clustering algorithm, with all three printed
steps visible in the contract: form the adjacency matrix of the input graph,
select a nonzero eigenvector at its second ordered eigenvalue, and partition
vertices by positive versus nonpositive coefficients. -/
theorem hdp_04_algorithm_4_5_spectral_clustering {n : ℕ}
    (G : SimpleGraph (Fin n)) [DecidableRel G.Adj] (hn : 1 < n) :
    ∃ (A : Matrix (Fin n) (Fin n) ℝ) (_hA : A.IsHermitian)
      (v : EuclideanSpace ℝ (Fin n))
      (first second : Set (Fin n)),
      A = G.adjMatrix ℝ ∧
      (∀ i j : Fin n, A i j = if G.Adj i j then 1 else 0) ∧
      (∀ i : Fin n, A i i = 0) ∧
      NumStability.HDP.Graph.SpectralClustering.IsSecondOrderedEigenvector
        A hn v ∧
      v ≠ 0 ∧
      first = {j | 0 < v j} ∧
      second = {j | v j ≤ 0} ∧
      first ∪ second = Set.univ ∧ Disjoint first second := by
  let A : Matrix (Fin n) (Fin n) ℝ := G.adjMatrix ℝ
  have hA : A.IsHermitian := by
    ext i j
    simp [A, Matrix.conjTranspose]
  let v := NumStability.HDP.Graph.SpectralClustering.secondEigenvector A hA hn
  let first : Set (Fin n) := {j | 0 < v j}
  let second : Set (Fin n) := {j | v j ≤ 0}
  refine ⟨A, hA, v, first, second, rfl, ?_, ?_,
    NumStability.HDP.Graph.SpectralClustering.secondEigenvector_completeOrderedCertificate
      A hA hn,
    ?_, rfl, rfl, ?_, ?_⟩
  · intro i j
    simp [A, SimpleGraph.adjMatrix_apply]
  · intro i
    simp [A]
  · intro hv
    have hvnorm :=
      (NumStability.HDP.Graph.SpectralClustering.secondEigenvector_spec A hA hn).1
    change ‖v‖ = 1 at hvnorm
    rw [hv, norm_zero] at hvnorm
    norm_num at hvnorm
  · ext j
    simp only [first, second, Set.mem_union, Set.mem_setOf_eq, Set.mem_univ,
      iff_true]
    exact lt_or_ge 0 (v j)
  · rw [Set.disjoint_left]
    intro j hjpos hjnonpos
    change 0 < v j at hjpos
    change v j ≤ 0 at hjnonpos
    exact (not_le_of_gt hjpos) hjnonpos

end NumStability.HDP.Contract
