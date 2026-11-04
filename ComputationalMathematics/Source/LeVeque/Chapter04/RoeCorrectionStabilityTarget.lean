/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RoeCharacteristicStability

/-!
# Qualified constant-linear Roe stability

The actual conservative step uses the centered flux with its absolute spectral
correction. The characteristic bound covers all pairs with bounded difference
and every iterate. The physical norm retains the fixed basis condition factor.
The separate sign inconsistency in the printed update is not identified with
this operator.
-/

namespace NumStability

/-- Actual flux-step correspondence and the complete qualified stability claim. -/
def Leveque04RoeCorrectionStabilityTarget : Prop :=
  ∀ (m : ℕ), 0 < m →
  ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ),
    (∀ p, coefficient.mulVec (basis p) = speeds p • basis p) →
    (∀ (ratio : ℝ) (old : ℤ → Fin m → ℝ) (i : ℤ),
      leveque04_linearRoeStep coefficient basis speeds ratio old i =
        leveque04_linearGodunovWaveStep basis speeds ratio old i) ∧
    (∀ (timeStep cellWidth B : ℝ),
      0 < timeStep → 0 < cellWidth → 0 ≤ B →
      (∀ p, |speeds p * (timeStep / cellWidth)| ≤ 1) →
      ∀ (P Q : ℤ → Fin m → ℝ),
      (∀ j p, |basis.equivFun (P j - Q j) p| ≤ B) →
      ∀ (n : ℕ) (i : ℤ) (p : Fin m),
        |basis.equivFun
          ((((leveque04_linearRoeStep coefficient basis speeds
                (timeStep / cellWidth))^[n] P) i) -
            (((leveque04_linearRoeStep coefficient basis speeds
                (timeStep / cellWidth))^[n] Q) i)) p| ≤ B) ∧
    (∀ (timeStep cellWidth B : ℝ),
      0 < timeStep → 0 < cellWidth → 0 ≤ B →
      (∀ p, |speeds p * (timeStep / cellWidth)| ≤ 1) →
      ∀ (P Q : ℤ → Fin m → ℝ),
      (∀ j, ‖P j - Q j‖ ≤ B) →
      ∀ (n : ℕ) (i : ℤ),
        ‖(((leveque04_linearRoeStep coefficient basis speeds
              (timeStep / cellWidth))^[n] P) i) -
          (((leveque04_linearRoeStep coefficient basis speeds
              (timeStep / cellWidth))^[n] Q) i)‖ ≤
          (‖basis.equivFun.toContinuousLinearEquiv.symm.toContinuousLinearMap‖ *
            ‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖) * B)

end NumStability
