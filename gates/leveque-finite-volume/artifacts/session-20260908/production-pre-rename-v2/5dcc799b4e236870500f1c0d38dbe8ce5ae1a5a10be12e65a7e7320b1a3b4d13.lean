/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation10

/-!
# LeVeque Chapter 1, equation (1.10) correspondence

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 4 (raw PDF page 26). This is the classical rate formulation on every oriented interval, with explicit
integrability. Its use at discontinuities requires a separate interpretation audit.
-/

open MeasureTheory

namespace NumStability

/-- The classical rate formulation of (1.10), including every oriented
interval and explicit Bochner integrability. This is a correspondence theorem,
not a claim that discontinuous fields have a classical rate at every time. -/
theorem leveque01_equation10_integralConservation_iff
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) :
    leveque01Equation10IntegralConservation q flux ↔
      ∀ x₁ x₂ t,
        IntervalIntegrable (fun x => q x t) volume x₁ x₂ ∧
          HasDerivAt (fun τ => ∫ x in x₁..x₂, q x τ)
            (flux (q x₁ t) - flux (q x₂ t)) t :=
  Iff.rfl

end NumStability
