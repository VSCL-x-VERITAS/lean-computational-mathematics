import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SpectralGapChildren
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.BalancedMean

/-!
# Two-vertex obstruction to the unrestricted spectral gap equality

These source-model results support the separately specified analyst-derived
children of the printed stochastic-block claims.
-/

noncomputable section

set_option maxHeartbeats 1000000
set_option backward.isDefEq.respectTransparency false

open Matrix MeasureTheory
open NumStability.HDP.Graph

namespace NumStability.HDP.Contract.DiscrepancyChildren

/-- For p = 1 and q = 3/4, the actual two-vertex spectral separation is 3/2 while the displayed minimum is 1/4. -/
theorem spectral_gap_witness_child_proved : HDP04SBMSpectralGapWitnessChildTarget := by
  let θ : StochasticBlock.Parameters :=
    { p := 1, q := 3/4, hp := by norm_num,
      hq := by rw [← NNReal.coe_le_coe]; norm_num [NNReal.coe_div] }
  have hc : ∀ b : Fin 2, Fintype.card {i : Fin (2*1) // (id : Fin 2 → Fin 2) i = b} = 1 := by
    intro b; simp
  have ho := BalancedMean.balanced_mean_ordered (k := 1) (by decide) θ id hc (by norm_num [θ])
  dsimp only at ho
  have h0 : NumStability.hermitianOrderedEigenvalue (BalancedMean.mean_hermitian id θ.p θ.q) (0 : Fin 2) = 3/4 := by
    simpa [θ] using ho.1
  have h1 : NumStability.hermitianOrderedEigenvalue (BalancedMean.mean_hermitian id θ.p θ.q) (1 : Fin 2) = -(3/4 : ℝ) := by
    simpa [θ] using ho.2.1
  have hgap : ∀ j : Fin 2, j ≠ 1 →
      |NumStability.hermitianOrderedEigenvalue (BalancedMean.mean_hermitian id θ.p θ.q) 1 -
        NumStability.hermitianOrderedEigenvalue (BalancedMean.mean_hermitian id θ.p θ.q) j| = 3/2 := by
    intro j hj
    have hj0 : j = 0 := by fin_cases j <;> simp_all
    rw [hj0, h1, h0]; norm_num
  refine ⟨θ, rfl, by norm_num [θ], FinStochasticBlock.adjacency_expectation id θ,
    BalancedMean.mean_hermitian id θ.p θ.q, h0, h1, hgap, ?_, ?_⟩
  · norm_num [θ]
  · intro j hj
    rw [hgap j hj]
    norm_num [θ]

end NumStability.HDP.Contract.DiscrepancyChildren
