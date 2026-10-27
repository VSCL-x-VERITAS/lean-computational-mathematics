/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannFigure33

/-!
# LeVeque Chapter 4, equation (4.38): linear Riemann wave jump

The decomposition is the Chapter 3 linear Riemann result applied to the
neighboring old cell states. No second eigenvector-wave construction is made.
-/

namespace NumStability

/-- Equation (4.38): the jump between right and left old cell states equals
both the characteristic eigenvector sum and the sum of Riemann wave vectors. -/
theorem leveque04_equation38
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) :
    right - left =
        ∑ p, leveque03_characteristicVariables eigenbasis (right - left) p •
          eigenbasis p ∧
      (∑ p, leveque03_characteristicVariables eigenbasis (right - left) p •
          eigenbasis p) =
        ∑ p, leveque03_riemannWave eigenbasis left right p := by
  have hcoords :
      (∑ p, leveque03_characteristicVariables eigenbasis (right - left) p •
        eigenbasis p) = right - left :=
    (leveque03_eigenvectorSuperposition eigenbasis
      (fun _ _ => right - left) 0 0).symm
  have hwaves := leveque03_sumRiemannWaves eigenbasis left right
  exact ⟨hcoords.symm, hcoords.trans hwaves.symm⟩

end NumStability
