/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CharacteristicCoordinates

/-!
# Left eigenvectors and characteristic variables

The rows of the inverse right-eigenvector matrix on printed page 49/raw PDF
page 71 act as left eigenvectors of the coefficient matrix.
-/

namespace NumStability

/-- The pth row of the inverse right-eigenvector matrix. -/
noncomputable def leveque03_leftEigenvector
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (p : Fin m) : Fin m → ℝ :=
  (((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis)⁻¹) p

/-- The pth inverse-matrix row is a left eigenvector: its action after `A`
equals multiplication by the matching eigenvalue. -/
theorem leveque03_leftEigenvector_action
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (p : Fin m) (v : Fin m → ℝ) :
    (leveque03_leftEigenvector eigenbasis p) ⬝ᵥ
        (coefficient.mulVec v) =
      eigenvalues p *
        ((leveque03_leftEigenvector eigenbasis p) ⬝ᵥ v) := by
  change (((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis)⁻¹).mulVec
      (coefficient.mulVec v) p =
    eigenvalues p *
      (((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis)⁻¹).mulVec v p
  rw [leveque03_characteristicCoordinates eigenbasis (coefficient.mulVec v),
    leveque03_characteristicCoordinates eigenbasis v]
  exact congrFun
    (eigenbasis_coordinates_mulVec coefficient eigenbasis eigenvalues heigen v) p

/-- Equation (3.7): the pth characteristic variable is the pth left
eigenvector applied to the state. -/
theorem leveque03_characteristicVariable_leftEigenvector
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ)) (p : Fin m) (x t : ℝ) :
    leveque03_characteristicVariables eigenbasis (q x t) p =
      (leveque03_leftEigenvector eigenbasis p) ⬝ᵥ (q x t) := by
  rfl

end NumStability
