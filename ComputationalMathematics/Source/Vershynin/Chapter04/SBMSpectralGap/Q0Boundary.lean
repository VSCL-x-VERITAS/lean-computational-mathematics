import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.Q0FinIndexedGap

/-!
# The zero cross-community probability boundary

For the actual loopless population spectrum, the first two ordered values
coincide when `q = 0`. This supplies a competing index at distance zero from
the second eigenvalue, including the singleton-community case.
-/

namespace NumStability.HDP.Contract

/-- The second ordered eigenvalue has a distinct indexed competitor at zero
distance when the cross-community edge probability is zero. -/
theorem hdp_04_sbm_q0_second_eigenvalue_zero_gap
    {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
    (hpq : θ.q < θ.p) (hq0 : θ.q = 0) :
    ∃ j : Fin (2 * k), j ≠ ⟨1, by omega⟩ ∧
      |NumStability.hermitianOrderedEigenvalue
          (BalancedFinSBM.population_hermitian k θ.p θ.q) ⟨1, by omega⟩ -
        NumStability.hermitianOrderedEigenvalue
          (BalancedFinSBM.population_hermitian k θ.p θ.q) j| = 0 := by
  let e0 : Fin (2 * k) := ⟨0, by omega⟩
  let e1 : Fin (2 * k) := ⟨1, by omega⟩
  have heq : NumStability.hermitianOrderedEigenvalue
        (BalancedFinSBM.population_hermitian k θ.p θ.q) e0 =
      NumStability.hermitianOrderedEigenvalue
        (BalancedFinSBM.population_hermitian k θ.p θ.q) e1 :=
    ordinary_q0_fin_ordered_top_eq_second_candidate hk θ hpq hq0
  refine ⟨e0, ?_, ?_⟩
  · simp [e0]
  · change |NumStability.hermitianOrderedEigenvalue
        (BalancedFinSBM.population_hermitian k θ.p θ.q) e1 -
      NumStability.hermitianOrderedEigenvalue
        (BalancedFinSBM.population_hermitian k θ.p θ.q) e0| = 0
    rw [← heq]
    simp

end NumStability.HDP.Contract
