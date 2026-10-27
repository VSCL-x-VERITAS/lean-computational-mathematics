/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw
import ComputationalMathematics.Source.LeVeque.Chapter04.Cell

/-!
# LeVeque Chapter 4, equation (4.2): statement target

The source specializes the integral conservation law to an ordered grid cell.
Equation (4.2) is on printed page 65 and uses the open cell defined on page 64.
-/

open MeasureTheory

namespace NumStability

/-- Proposed proof-free statement for the cellwise integral balance in (4.2). -/
def leveque04_equation02_target
    {m : ℕ} (interface : ℤ → ℝ)
    (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (i : ℤ) (t : ℝ) : Prop :=
  interface (i - 1) < interface i →
    IsIntegralConservationLawSolution q flux →
      HasDerivAt (fun τ => ∫ x in leveque04_cell interface i, q x τ)
        (flux (q (interface (i - 1)) t) - flux (q (interface i) t)) t

end NumStability
