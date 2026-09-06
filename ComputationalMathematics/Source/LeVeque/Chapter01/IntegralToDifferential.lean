/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation08
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation10

/-!
# LeVeque Chapter 1, smooth integral-to-differential implication

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 4 (raw PDF page 26) through printed page 5 (raw PDF page 27).
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- Sufficient classical smoothness and differentiation under the integral
turn equation (1.10) into the pointwise equation (1.8). -/
theorem leveque01_integralLaw_impliesDifferentialLaw_of_smooth
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (qt fluxx : ℝ → (Fin m → ℝ)) (t : ℝ)
    (hintegralLaw : leveque01Equation10IntegralConservation q flux)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hfluxx : ∀ x,
      HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : ∀ a b, IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : ∀ a b, IntervalIntegrable fluxx volume a b)
    (hinterchange : ∀ a b,
      HasDerivAt (fun τ => ∫ x in a..b, q x τ)
        (∫ x in a..b, qt x) t)
    (hresidualContinuous : Continuous fun x => qt x + fluxx x) :
    ∀ x, leveque01_equation08_conservationLawAt q flux x t :=
  integralConservationLaw_implies_pointwise
    q flux qt fluxx t hintegralLaw hqt hfluxx hqtIntegrable
      hfluxxIntegrable hinterchange hresidualContinuous

end NumStability
