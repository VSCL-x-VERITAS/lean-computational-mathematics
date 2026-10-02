import ComputationalMathematics.HDP.Matrix.OperatorNorm

/-!
# Vershynin Chapter 4, Equation (4.25)
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.25), including the definition
`Rₘ = m⁻¹ ∑ ZᵢZᵢᵀ - I`.  The matrix `S` is characterized as the
positive-semidefinite square root of `Σ`; the empirical second moment is
formed from the rows of `Z`.  The conclusion exposes the full equality and
inequality chain rather than assuming its factorization. -/
theorem hdp_04_equation_4_25 {m n : ℕ} (hm : 0 < m)
    (Z : Matrix (Fin m) (Fin n) ℝ)
    (SigmaM Sigma S : Matrix (Fin n) (Fin n) ℝ)
    (hSpos : S.PosSemidef)
    (hSsq : S * S = Sigma)
    (hSigmaM : SigmaM =
      S * ((m : ℝ)⁻¹ • (Z.transpose * Z)) * S)
    (hSnorm : ‖NumStability.realMatrixContinuousLinearMap S‖ ^ 2 =
      ‖NumStability.realMatrixContinuousLinearMap Sigma‖) :
    let Rm : Matrix (Fin n) (Fin n) ℝ :=
      (m : ℝ)⁻¹ • (Z.transpose * Z) - 1
    SigmaM - Sigma = S * Rm * S ∧
      ‖NumStability.realMatrixContinuousLinearMap (SigmaM - Sigma)‖ =
        ‖NumStability.realMatrixContinuousLinearMap (S * Rm * S)‖ ∧
      ‖NumStability.realMatrixContinuousLinearMap (SigmaM - Sigma)‖ ≤
        ‖NumStability.realMatrixContinuousLinearMap Rm‖ *
          ‖NumStability.realMatrixContinuousLinearMap Sigma‖ := by
  dsimp
  let Rm : Matrix (Fin n) (Fin n) ℝ :=
    (m : ℝ)⁻¹ • (Z.transpose * Z) - 1
  have hfactor : SigmaM - Sigma = S * Rm * S := by
    rw [hSigmaM, ← hSsq]
    dsimp [Rm]
    noncomm_ring
  refine ⟨hfactor, congrArg (‖NumStability.realMatrixContinuousLinearMap ·‖) hfactor,
    ?_⟩
  rw [hfactor, ← hSnorm]
  exact NumStability.HDP.Matrix.realMatrixOperatorNorm_sandwich_le S Rm

end NumStability.HDP.Contract
