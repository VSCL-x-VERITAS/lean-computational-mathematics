import ComputationalMathematics.Source.Vershynin.Chapter04.SBMEigenvectorSignCorrection.Contract

/-!
# Vershynin Chapter 4, coefficient-size discrepancy
-/

namespace NumStability.HDP.Contract

/-- The printed claim that the *sizes* of the coefficients of the second
population eigenvector identify the two communities is false.  Equation
(4.17)'s signed community vector has vertices in different communities whose
coefficients have exactly the same absolute value. -/
theorem hdp_04_sbm_eigenvector_coefficient_sizes_counterexample :
    ∃ (i j : NumStability.HDP.Graph.StochasticBlock.Vertex 1),
      i.1 ≠ j.1 ∧
        |NumStability.HDP.Graph.StochasticBlock.communitySign 1 i| =
          |NumStability.HDP.Graph.StochasticBlock.communitySign 1 j| := by
  refine ⟨((0 : Fin 2), (0 : Fin 1)), ((1 : Fin 2), (0 : Fin 1)), ?_, ?_⟩
  · norm_num
  · rw [NumStability.HDP.Graph.StochasticBlock.abs_communitySign,
      NumStability.HDP.Graph.StochasticBlock.abs_communitySign]

end NumStability.HDP.Contract
