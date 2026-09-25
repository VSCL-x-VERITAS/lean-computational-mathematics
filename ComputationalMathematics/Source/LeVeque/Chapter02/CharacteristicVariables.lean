/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CharacteristicVariablesTarget

/-!
# The diagonal system in characteristic variables
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.74): the fixed real eigenbasis turns the original system into
the diagonal system for the actual characteristic-variable field `R⁻¹ q`. -/
theorem characteristicVariables : characteristicVariablesTarget := by
  intro m coefficient eigenvalues eigenbasis heigen
  let R : Matrix (Fin m) (Fin m) ℝ :=
    (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  let S : Matrix (Fin m) (Fin m) ℝ :=
    eigenbasis.toMatrix (Pi.basisFun ℝ (Fin m))
  have hSR : S * R = 1 := by
    simpa [S, R] using Module.Basis.toMatrix_mul_toMatrix_flip
      eigenbasis (Pi.basisFun ℝ (Fin m))
  have hInv : R⁻¹ = S := Matrix.inv_eq_left_inv hSR
  have hcoord (v : Fin m → ℝ) : (R⁻¹).mulVec v = eigenbasis.equivFun v := by
    have hrepr : R.mulVec (eigenbasis.equivFun v) = v := by
      simpa only [R, Module.Basis.equivFun_apply, Pi.basisFun_repr] using
        (Module.Basis.toMatrix_mulVec_repr eigenbasis
          (Pi.basisFun ℝ (Fin m)) v)
    have h := congrArg (fun z => (R⁻¹).mulVec z) hrepr
    simpa only [Matrix.mulVec_mulVec, hInv, hSR, Matrix.one_mulVec] using h.symm
  have hdiag (i : Fin m) :
      (Matrix.diagonal eigenvalues).mulVec ((Pi.basisFun ℝ (Fin m)) i) =
        eigenvalues i • (Pi.basisFun ℝ (Fin m)) i := by
    ext j
    simp only [Pi.basisFun_apply, Matrix.mulVec_diagonal, Pi.smul_apply, smul_eq_mul]
    by_cases h : i = j <;> simp [h, eq_comm]
  change ∀ (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ),
    NumStability.IsConstantCoefficientLinearSystemSolutionAt q coefficient x t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (fun ξ τ => (R⁻¹).mulVec (q ξ τ)) (Matrix.diagonal eigenvalues) x t
  intro q x t
  rw [NumStability.constantCoefficientSystem_iff_eigenbasisAdvection
    coefficient eigenbasis eigenvalues heigen]
  have h := NumStability.constantCoefficientSystem_iff_eigenbasisAdvection
    (Matrix.diagonal eigenvalues) (Pi.basisFun ℝ (Fin m))
    eigenvalues hdiag (fun ξ τ => (R⁻¹).mulVec (q ξ τ)) x t
  rw [h]
  simp only [Pi.basisFun_equivFun, LinearEquiv.refl_apply, hcoord]

end NumStability.Leveque02Tracer
