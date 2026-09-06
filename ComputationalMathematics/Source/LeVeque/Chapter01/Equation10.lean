/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw

/-!
# LeVeque Chapter 1, Equation (1.10)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 4 (raw PDF page 26), equation (1.10).
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- Equation (1.10), with Bochner integrability recorded explicitly. -/
abbrev leveque01Equation10IntegralConservation
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) : Prop :=
  IsIntegralConservationLawSolution q flux

/-- An integral-law solution has the printed endpoint-flux derivative on
every oriented interval. -/
theorem leveque01_equation10_fluxBalance
    {m : ℕ} {q : ℝ → ℝ → (Fin m → ℝ)}
    {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hsolution : leveque01Equation10IntegralConservation q flux)
    (x₁ x₂ t : ℝ) :
    IntervalIntegrable (fun x => q x t) volume x₁ x₂ ∧
      HasDerivAt (fun τ => ∫ x in x₁..x₂, q x τ)
        (flux (q x₁ t) - flux (q x₂ t)) t :=
  hsolution x₁ x₂ t

end NumStability
