/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CharacteristicComponentEquationsTarget

/-!
# Independent scalar equations for characteristic components
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.75): the diagonal system for `w = R⁻¹ q` holds exactly when
each characteristic component satisfies its own advection equation. -/
theorem characteristicComponentEquations : characteristicComponentEquationsTarget := by
  intro m coefficient eigenvalues eigenbasis heigen
  let R : Matrix (Fin m) (Fin m) ℝ :=
    (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  have hdiag (i : Fin m) :
      (Matrix.diagonal eigenvalues).mulVec ((Pi.basisFun ℝ (Fin m)) i) =
        eigenvalues i • (Pi.basisFun ℝ (Fin m)) i := by
    ext j
    simp only [Pi.basisFun_apply, Matrix.mulVec_diagonal, Pi.smul_apply, smul_eq_mul]
    by_cases h : i = j <;> simp [h, eq_comm]
  change ∀ (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ),
    let w := fun ξ τ => (R⁻¹).mulVec (q ξ τ)
    NumStability.IsConstantCoefficientLinearSystemSolutionAt
        w (Matrix.diagonal eigenvalues) x t ↔
      ∀ p, NumStability.IsLinearAdvectionSolutionAt
        (fun ξ τ => w ξ τ p) (eigenvalues p) x t
  intro q x t
  let w : ℝ → ℝ → (Fin m → ℝ) := fun ξ τ => (R⁻¹).mulVec (q ξ τ)
  change NumStability.IsConstantCoefficientLinearSystemSolutionAt
      w (Matrix.diagonal eigenvalues) x t ↔
    ∀ p, NumStability.IsLinearAdvectionSolutionAt
      (fun ξ τ => w ξ τ p) (eigenvalues p) x t
  have h := NumStability.constantCoefficientSystem_iff_eigenbasisAdvection
    (Matrix.diagonal eigenvalues) (Pi.basisFun ℝ (Fin m))
    eigenvalues hdiag w x t
  simpa only [Pi.basisFun_equivFun, LinearEquiv.refl_apply] using h

end NumStability.Leveque02Tracer
