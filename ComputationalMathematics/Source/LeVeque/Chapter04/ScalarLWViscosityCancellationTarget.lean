/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ScalarLWViscosityCancellation

/-!
# A precise scalar supporting artificial-viscosity result

This proof-free target binds the actual Richtmyer, Fick, conservative and upwind
objects. It selects a concrete possibility supporting the original artificial-
viscosity remark, with one-step interval and monotonicity guarantees. Broader
nonlinear/system remedies, TVD/iteration enhancements and the qualitative
comparison "more effectively" remain separate source content.
-/

namespace NumStability

/-- Exact cancellation to upwind and actual one-step scalar nonoscillation
controls for every positive speed/width and Courant weight in `[0, 1]`. -/
def Leveque04ScalarLWViscosityCancellationTarget : Prop :=
  ∀ speed timeStep cellWidth : ℝ,
    0 < speed → 0 < cellWidth →
    0 ≤ speed * timeStep / cellWidth → speed * timeStep / cellWidth ≤ 1 →
      0 ≤ leveque04_scalarLWAddedViscosity speed timeStep cellWidth ∧
      (∀ left right : ℝ,
        leveque04_scalarLWFaceFlux speed timeStep cellWidth left right =
          speed * left + speed / 2 * (1 - speed * timeStep / cellWidth) *
            (right - left) ∧
        leveque04_scalarLWAddedDiffusiveFlux speed timeStep cellWidth left right =
          -(speed / 2) * (1 - speed * timeStep / cellWidth) * (right - left) ∧
        leveque04_scalarLWCorrectedFaceFlux speed timeStep cellWidth left right =
          speed * left) ∧
      (∀ (old : ℤ → ℝ) (i : ℤ),
        leveque04_scalarLWAddedDiffusiveFlux speed timeStep cellWidth
            (old (i - 1)) (old i) =
          leveque04_diffusionInterfaceFlux
            (fun _ : ℤ => leveque04_scalarLWAddedViscosity speed timeStep cellWidth)
            old cellWidth i ∧
        leveque04_scalarLWCorrectedInterfaceFlux speed timeStep cellWidth old i =
          leveque04_positiveUpwindInterfaceFlux speed old i ∧
        leveque04_scalarLWCorrectedStep speed timeStep cellWidth old i =
          leveque04_positiveUpwindStep timeStep cellWidth speed old i ∧
        leveque04_scalarLWCorrectedStep speed timeStep cellWidth old i =
          (speed * timeStep / cellWidth) * old (i - 1) +
            (1 - speed * timeStep / cellWidth) * old i) ∧
      (∀ (old : ℤ → ℝ) (lower upper : ℝ),
        (∀ i : ℤ, lower ≤ old i ∧ old i ≤ upper) →
        ∀ i : ℤ,
          lower ≤ leveque04_scalarLWCorrectedStep speed timeStep cellWidth old i ∧
            leveque04_scalarLWCorrectedStep speed timeStep cellWidth old i ≤ upper) ∧
      (∀ old : ℤ → ℝ,
        (∀ i : ℤ, old i ≤ old (i + 1)) →
        ∀ i : ℤ,
          leveque04_scalarLWCorrectedStep speed timeStep cellWidth old i ≤
            leveque04_scalarLWCorrectedStep speed timeStep cellWidth old (i + 1)) ∧
      (∀ old : ℤ → ℝ,
        (∀ i : ℤ, old (i + 1) ≤ old i) →
        ∀ i : ℤ,
          leveque04_scalarLWCorrectedStep speed timeStep cellWidth old (i + 1) ≤
            leveque04_scalarLWCorrectedStep speed timeStep cellWidth old i)

end NumStability
