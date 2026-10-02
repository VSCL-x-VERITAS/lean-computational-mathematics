import ComputationalMathematics.Source.Vershynin.Chapter04.SBMLooplessCorrections.Contract

/-!
# Vershynin Chapter 4, full loopless correction to Equation (4.17)

This contract supplements the two shifted signal eigenpairs with the action on
the entire complementary subspace and explicitly identifies the matrix with
the entrywise expectation of the inherited loopless stochastic-block model.
-/

namespace NumStability.HDP.Contract

open Matrix MeasureTheory

private abbrev SBMVertex (k : ℕ) :=
  NumStability.HDP.Graph.StochasticBlock.Vertex k

private abbrev SBMEdge (k : ℕ) :=
  NumStability.HDP.Graph.StochasticBlock.Edge k

private theorem displayedExpectedAdjacency_mulVec_eq_zero_of_community_sums
    {k : ℕ} (p q : ℝ) (x : SBMVertex k → ℝ)
    (hx : ∀ c : Fin 2, ∑ a : Fin k, x (c, a) = 0) :
    (NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k p q).mulVec x = 0 := by
  funext i
  simp only [Matrix.mulVec, dotProduct,
    NumStability.HDP.Graph.StochasticBlock.expectedAdjacency]
  rw [Fintype.sum_prod_type, Fin.sum_univ_two]
  have hi : i.1 = 0 ∨ i.1 = 1 := by
    rcases Nat.le_one_iff_eq_zero_or_eq_one.mp
        (Nat.le_of_lt_succ i.1.isLt) with h | h
    · exact Or.inl (Fin.ext h)
    · exact Or.inr (Fin.ext h)
  rcases hi with hi | hi
  · simp only [hi, Fin.isValue, if_pos]
    rw [← Finset.mul_sum, ← Finset.mul_sum, hx 0, hx 1]
    simp
  · simp only [hi, Fin.isValue, if_pos]
    rw [← Finset.mul_sum, ← Finset.mul_sum, hx 0, hx 1]
    simp

/-- Complete correction of Equation (4.17) for the actual loopless
expectation.  The two signal eigenvalues are shifted by `-p`; every vector
whose coordinates sum to zero separately inside each community belongs to
the remaining `-p` eigenspace.  The first conjunct records that this matrix is
the entrywise expectation of the loopless random adjacency matrix. -/
theorem hdp_04_equation_4_17_loopless_full_corrected {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (∀ i j : SBMVertex k,
      ∫ ω, stochasticBlockAdjacency ω i j
          ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ =
        looplessExpectedAdjacency k θ.p θ.q i j) ∧
    (looplessExpectedAdjacency k θ.p θ.q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.allOnes k) =
      (((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) •
        NumStability.HDP.Graph.StochasticBlock.allOnes k) ∧
    (looplessExpectedAdjacency k θ.p θ.q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.communitySign k) =
      (((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
        NumStability.HDP.Graph.StochasticBlock.communitySign k) ∧
    (∀ x : SBMVertex k → ℝ,
      (∀ c : Fin 2, ∑ a : Fin k, x (c, a) = 0) →
      (looplessExpectedAdjacency k θ.p θ.q).mulVec x =
        (-(θ.p : ℝ)) • x) := by
  refine ⟨(hdp_04_expected_adjacency_decomposition_corrected hk θ hpq).1,
    (hdp_04_equation_4_17_corrected hk θ hpq).1,
    (hdp_04_equation_4_17_corrected hk θ hpq).2, ?_⟩
  intro x hx
  rw [looplessExpectedAdjacency_eq_displayed_sub_diagonal, Matrix.sub_mulVec,
    displayedExpectedAdjacency_mulVec_eq_zero_of_community_sums _ _ x hx]
  simp [Matrix.smul_mulVec]

end NumStability.HDP.Contract
