/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannWedges

/-!
# The eigenvector direction of a linear Riemann wave jump

Equation (3.21), printed page 53/raw PDF page 75. The source calls a wave jump
an eigenvector because it is a scalar multiple of a right eigenvector. This
module also distinguishes the zero-strength case, where the jump is zero and
the conventional nonzero-eigenvector wording requires a qualification.
-/

namespace NumStability

/-- The strength of the pth Riemann wave is its right-minus-left
characteristic coefficient. -/
noncomputable def leveque03_waveStrength
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) (p : Fin m) : ℝ :=
  leveque03_characteristicVariables eigenbasis right p -
    leveque03_characteristicVariables eigenbasis left p

/-- Equation (3.21): the jump is `αᵖ rᵖ` and satisfies the corresponding
eigenvalue equation. If `αᵖ` is nonzero, so is the jump. -/
theorem leveque03_waveJumpEigenvector
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      speeds p • eigenbasis p)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right)
    (p : Fin m) (XL TL XR TR : ℝ)
    (hoffL : ∀ j, XL - speeds j * TL ≠ 0)
    (hoffR : ∀ j, XR - speeds j * TR ≠ 0)
    (hleft : XL - speeds p * TL < 0)
    (hright : 0 < XR - speeds p * TR)
    (hsame : ∀ j, j ≠ p →
      ((0 < XL - speeds j * TL) ↔ (0 < XR - speeds j * TR))) :
    (leveque03_initialDataSolution eigenbasis speeds initialState XR TR -
        leveque03_initialDataSolution eigenbasis speeds initialState XL TL =
        leveque03_waveStrength eigenbasis left right p • eigenbasis p) ∧
      coefficient.mulVec
        (leveque03_initialDataSolution eigenbasis speeds initialState XR TR -
          leveque03_initialDataSolution eigenbasis speeds initialState XL TL) =
        speeds p •
          (leveque03_initialDataSolution eigenbasis speeds initialState XR TR -
            leveque03_initialDataSolution eigenbasis speeds initialState XL TL) ∧
      (leveque03_waveStrength eigenbasis left right p ≠ 0 →
        leveque03_initialDataSolution eigenbasis speeds initialState XR TR -
          leveque03_initialDataSolution eigenbasis speeds initialState XL TL ≠ 0) := by
  have hjump :
      leveque03_initialDataSolution eigenbasis speeds initialState XR TR -
        leveque03_initialDataSolution eigenbasis speeds initialState XL TL =
        leveque03_waveStrength eigenbasis left right p • eigenbasis p := by
    simpa only [leveque03_waveStrength] using
      leveque03_singleWaveJump eigenbasis speeds initialState left right hdata
        p XL TL XR TR hoffL hoffR hleft hright hsame
  refine ⟨hjump, ?_, ?_⟩
  · rw [hjump, Matrix.mulVec_smul, heigen]
    exact smul_comm _ _ _
  · intro hα
    rw [hjump]
    exact smul_ne_zero hα (eigenbasis.ne_zero p)

end NumStability
