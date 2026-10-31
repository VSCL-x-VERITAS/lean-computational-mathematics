import ComputationalMathematics.Source.Vershynin.Chapter04.SBMLooplessCorrections.Contract

/-!
# Vershynin Chapter 4, corrected community-eigenvector consequence
-/

namespace NumStability.HDP.Contract

/-- Corrected consequence of Equation (4.17) for the inherited loopless
stochastic-block model: subtracting `pI` changes the signal eigenvalue but not
the community eigenvector.  Its coefficients all have the same magnitude,
while their signs identify the two communities. -/
theorem hdp_04_sbm_eigenvector_sign_correction {k : ℕ}
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p)
    (i : NumStability.HDP.Graph.StochasticBlock.Vertex k) :
    (looplessExpectedAdjacency k θ.p θ.q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.communitySign k) =
      (((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
        NumStability.HDP.Graph.StochasticBlock.communitySign k) ∧
      (0 < NumStability.HDP.Graph.StochasticBlock.communitySign k i ↔ i.1 = 0) ∧
      (NumStability.HDP.Graph.StochasticBlock.communitySign k i < 0 ↔ i.1 = 1) ∧
      |NumStability.HDP.Graph.StochasticBlock.communitySign k i| = 1 := by
  refine ⟨?_, NumStability.HDP.Graph.StochasticBlock.communitySign_pos_iff k i, ?_,
    NumStability.HDP.Graph.StochasticBlock.abs_communitySign k i⟩
  · have _ := hpq
    rw [looplessExpectedAdjacency_eq_displayed_sub_diagonal,
      Matrix.sub_mulVec,
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency_mulVec_communitySign]
    simp [Matrix.smul_mulVec]
    module
  by_cases h : i.1 = 0
  · simp [NumStability.HDP.Graph.StochasticBlock.communitySign, h]
  · have hone : i.1 = 1 := by
      rcases Nat.le_one_iff_eq_zero_or_eq_one.mp (Nat.le_of_lt_succ i.1.isLt) with hz | ho
      · exact (h (Fin.ext hz)).elim
      · exact Fin.ext ho
    simp [NumStability.HDP.Graph.StochasticBlock.communitySign, hone]

end NumStability.HDP.Contract
