import ComputationalMathematics.Source.Vershynin.Chapter04.SBMSpectralGap.Contract

/-!
# Two-vertex spectral-gap boundary witness

This analyst result specializes the existing complete expected-spectrum
certificate. It does not choose whether the book intended to exclude the
two-vertex boundary or repair its diagonal convention.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Graph.StochasticBlock

/-- For two singleton communities with `p=1,q=3/4`, every distance from the
second ordered population eigenvalue to a different eigenvalue is `3/2`.
The printed minimum formula gives `1/4`, and therefore is not this gap.
The all-entry ordinary-expectation identification is retained explicitly. -/
theorem hdp_04_sbm_singleton_actual_spectral_gap_obstruction :
    let θ : Parameters :=
      { p := 1, q := 3 / 4, hp := by norm_num, hq := by rw [← NNReal.coe_le_coe]; norm_num [NNReal.coe_div] }
    let P := NumStability.HDP.Graph.FinStochasticBlock.measure
      (BalancedFinSBM.community 1) θ
    let hD := BalancedFinSBM.population_hermitian 1 θ.p θ.q
    0 < θ.q ∧ θ.q < θ.p ∧
      (∀ i j : Fin 2,
        (∫ ω, NumStability.HDP.Graph.FinStochasticBlock.adjacency ω i j ∂P) =
          BalancedFinSBM.population 1 θ.p θ.q i j) ∧
      (∀ j : Fin 2, j ≠ ⟨1, by decide⟩ →
        |NumStability.hermitianOrderedEigenvalue hD ⟨1, by decide⟩ -
            NumStability.hermitianOrderedEigenvalue hD j| = 3 / 2) ∧
      min (((θ.p : ℝ) - θ.q) / 2) θ.q * (2 : ℝ) = 1 / 4 ∧
      (∀ j : Fin 2, j ≠ ⟨1, by decide⟩ →
        |NumStability.hermitianOrderedEigenvalue hD ⟨1, by decide⟩ -
            NumStability.hermitianOrderedEigenvalue hD j| ≠
          min (((θ.p : ℝ) - θ.q) / 2) θ.q * (2 : ℝ)) := by
  let θ : Parameters :=
    { p := 1, q := 3 / 4, hp := by norm_num, hq := by rw [← NNReal.coe_le_coe]; norm_num [NNReal.coe_div] }
  have hq : 0 < θ.q := by norm_num [θ]
  have hpq : θ.q < θ.p := by norm_num [θ]
  have h := hdp_04_sbm_spectral_gap (k := 1) (by decide) θ hq hpq
  dsimp only at h
  rcases h with ⟨hEA, _hAdj, _hOnes, _hSign, _hTop, _hSecond,
    _hLower, _hAttained, hSingleton⟩
  change 0 < θ.q ∧ θ.q < θ.p ∧ _
  refine ⟨hq, hpq, hEA, ?_, ?_, ?_⟩
  · intro j hj
    have hjgap := hSingleton rfl j hj
    norm_num [θ] at hjgap ⊢
    exact hjgap
  · norm_num [θ]
  · intro j hj hPrinted
    have hjgap := hSingleton rfl j hj
    norm_num [θ] at hjgap hPrinted
    linarith

end NumStability.HDP.Contract
