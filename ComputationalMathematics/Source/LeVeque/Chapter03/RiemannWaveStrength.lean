/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannWaveJump
import ComputationalMathematics.Source.LeVeque.Chapter03.WaveSuperposition
import ComputationalMathematics.Source.LeVeque.Chapter03.LeftEigenvectors

/-!
# Strengths and wave vectors of the linear Riemann problem

Equations (3.23) and (3.24), printed page 54/raw PDF page 76. The strengths
are the inverse-eigenvector coordinates of the state jump; each wave vector
is the corresponding strength times its right eigenvector.
-/

namespace NumStability

/-- Equation (3.23) and its following component identities: the strengths
solve `R α = qᵣ - qₗ`, are obtained by `R⁻¹`, and are the left-eigenvector
actions and right-minus-left characteristic coordinates of the jump. -/
theorem leveque03_waveStrength_fromJump
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) :
    let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
    let alpha := leveque03_characteristicVariables eigenbasis (right - left)
    R.mulVec alpha = right - left ∧
      alpha = (R⁻¹).mulVec (right - left) ∧
      ∀ p, alpha p =
        (leveque03_leftEigenvector eigenbasis p) ⬝ᵥ (right - left) ∧
        alpha p = leveque03_waveStrength eigenbasis left right p := by
  dsimp only
  refine ⟨leveque03_reconstructState eigenbasis (right - left), rfl, ?_⟩
  intro p
  constructor
  · exact leveque03_characteristicVariable_leftEigenvector eigenbasis
      (fun _ _ => right - left) p 0 0
  · simp only [leveque03_waveStrength, leveque03_characteristicVariables,
      Matrix.mulVec_sub, Pi.sub_apply]

/-- Equation (3.24): the pth wave vector `Wᵖ = αᵖ rᵖ`. -/
noncomputable def leveque03_riemannWave
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) (p : Fin m) : Fin m → ℝ :=
  leveque03_waveStrength eigenbasis left right p • eigenbasis p

end NumStability
