import ComputationalMathematics.HDP.Matrix.OperatorNorm
import Mathlib.Analysis.CStarAlgebra.Matrix

/-!
# Vershynin Chapter 4, Equation (4.25)
-/

noncomputable section

namespace NumStability.HDP.Contract

open scoped Matrix.Norms.L2Operator

/-- Vershynin, Equation (4.25), including the definition
`Rₘ = m⁻¹ ∑ ZᵢZᵢᵀ - I`.  The matrix `S` is characterized as the
positive-semidefinite square root of `Σ`; the empirical second moment is
formed from the rows of `Z`.  The conclusion exposes the full equality and
inequality chain rather than assuming its factorization. The square-root norm
identity is derived from positive semidefiniteness using the matrix C*-identity.
The source has a positive sample size; this algebraic statement also admits
`m = 0` under Lean's totalized scalar inverse and the explicit `hSigmaM`
identity, without asserting a zero-sample statistical interpretation. -/
theorem hdp_04_equation_4_25 {m n : ℕ}
    (Z : Matrix (Fin m) (Fin n) ℝ)
    (SigmaM Sigma S : Matrix (Fin n) (Fin n) ℝ)
    (hSpos : S.PosSemidef)
    (hSsq : S * S = Sigma)
    (hSigmaM : SigmaM =
      S * ((m : ℝ)⁻¹ • (Z.transpose * Z)) * S) :
    let Rm : Matrix (Fin n) (Fin n) ℝ :=
      (m : ℝ)⁻¹ • (Z.transpose * Z) - 1
    SigmaM - Sigma = S * Rm * S ∧
      ‖NumStability.realMatrixContinuousLinearMap (SigmaM - Sigma)‖ =
        ‖NumStability.realMatrixContinuousLinearMap (S * Rm * S)‖ ∧
      ‖NumStability.realMatrixContinuousLinearMap (SigmaM - Sigma)‖ ≤
      ‖NumStability.realMatrixContinuousLinearMap Rm‖ *
          ‖NumStability.realMatrixContinuousLinearMap Sigma‖ := by
  have hSnorm : ‖NumStability.realMatrixContinuousLinearMap S‖ ^ 2 =
      ‖NumStability.realMatrixContinuousLinearMap Sigma‖ := by
    have h := Matrix.l2_opNorm_conjTranspose_mul_self S
    rw [hSpos.isHermitian.eq, hSsq] at h
    simpa [Matrix.l2_opNorm_def, NumStability.realMatrixContinuousLinearMap,
      pow_two] using h.symm
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
