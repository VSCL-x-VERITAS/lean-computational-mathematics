/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CharacteristicCoordinates
import Mathlib.Analysis.Calculus.ContDiff.Operations

/-!
# Singularities in initial characteristic components

Printed page 52/raw PDF page 74. Failure of regularity of the initial vector
state must occur in at least one characteristic coordinate, since the fixed
change of eigenbasis coordinates is invertible.
-/

namespace NumStability

/-- If the initial state fails to be `C^n` at a point, at least one initial
characteristic component fails at the same point and order. -/
theorem leveque03_initialSingularity_component
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (initialState : ℝ → (Fin m → ℝ)) (x₀ : ℝ) (n : WithTop ℕ∞)
    (hsing : ¬ ContDiffAt ℝ n initialState x₀) :
    ∃ p, ¬ ContDiffAt ℝ n
      (fun x => leveque03_initialCharacteristicVariables eigenbasis initialState x p) x₀ := by
  by_contra hnone
  push_neg at hnone
  have hcoords : ContDiffAt ℝ n
      (fun x => leveque03_initialCharacteristicVariables eigenbasis initialState x) x₀ :=
    contDiffAt_pi.mpr hnone
  have hfun : (fun x => leveque03_initialCharacteristicVariables eigenbasis initialState x) =
      (fun x => eigenbasis.equivFun (initialState x)) := by
    funext x
    exact leveque03_characteristicCoordinates eigenbasis (initialState x)
  rw [hfun] at hcoords
  exact hsing ((eigenbasis.equivFun.toContinuousLinearEquiv.comp_contDiffAt_iff).mp hcoords)

end NumStability
