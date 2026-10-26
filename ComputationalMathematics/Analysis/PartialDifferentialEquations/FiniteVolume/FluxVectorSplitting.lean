/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Tactic.Abel

/-!
# Algebra of flux vector splitting on an integer cell line

A physical flux written as positive plus negative parts determines face
fluxes and directional fluctuations. Their identities are purely additive
and apply to any state space with a commutative group structure.
-/

namespace NumStability.FluxVectorSplitting

variable {E : Type*} [AddCommGroup E]

/-- Change in the positive flux part across the left face of cell `i`. -/
def positiveFluctuation (positive : ℤ → E) (i : ℤ) : E :=
  positive i - positive (i - 1)

/-- Change in the negative flux part across the left face of cell `i`. -/
def negativeFluctuation (negative : ℤ → E) (i : ℤ) : E :=
  negative i - negative (i - 1)

/-- The split numerical flux takes the positive part from the left cell and
the negative part from the right cell. -/
def faceFlux (positive negative : ℤ → E) (i : ℤ) : E :=
  positive (i - 1) + negative i

/-- The full physical-flux difference is the sum of the two directional
fluctuations. -/
theorem physicalFlux_difference
    (physical positive negative : ℤ → E)
    (hsplit : ∀ i, physical i = positive i + negative i) (i : ℤ) :
    physical i - physical (i - 1) =
      negativeFluctuation negative i + positiveFluctuation positive i := by
  rw [hsplit i, hsplit (i - 1)]
  unfold negativeFluctuation positiveFluctuation
  abel

/-- The same split face flux can be computed from either adjacent physical
flux and its outgoing directional fluctuation. -/
theorem faceFlux_eq_adjacent
    (physical positive negative : ℤ → E)
    (hsplit : ∀ i, physical i = positive i + negative i) (i : ℤ) :
    faceFlux positive negative i =
        physical i - positiveFluctuation positive i ∧
      faceFlux positive negative i =
        physical (i - 1) + negativeFluctuation negative i := by
  constructor
  · rw [hsplit i]
    unfold faceFlux positiveFluctuation
    abel
  · rw [hsplit (i - 1)]
    unfold faceFlux negativeFluctuation
    abel

end NumStability.FluxVectorSplitting
