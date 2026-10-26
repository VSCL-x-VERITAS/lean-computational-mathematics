/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsSmoothTime
import ComputationalMathematics.Analysis.Calculus.FluxSecantTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivativeContinuous

/-!
# Scalar conservation-law cell-average time slope

Continuous boundary flux traces make the exact cell-average time
derivative equal the normalized physical-flux difference. Smooth flux
then bounds its defect relative to a linearization at the cell average.
-/

namespace NumStability

/-- The exact scalar cell average has a pointwise time derivative given
by the boundary physical-flux difference. -/
theorem leveque04_scalarCellAverage_hasDerivAt_time
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux : ℝ → ℝ)
    (a b t : ℝ)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hcont : Continuous (fun τ => flux (q a τ 0) - flux (q b τ 0))) :
    HasDerivAt
      (fun τ => (oneDimensionalCellAverage (fun x => q x τ) a b) 0)
      ((flux (q a t 0) - flux (q b t 0)) / (b - a)) t := by
  have hcontVec : Continuous
      (fun τ => (fun k : Fin 1 => flux (q a τ 0)) -
        (fun k : Fin 1 => flux (q b τ 0))) := by
    apply continuous_pi
    intro k
    fin_cases k
    simpa using hcont
  have hderiv := hq.hasDerivAt_cellAverage_of_continuous_flux
    a b t hcontVec
  have hcoord := (hasDerivAt_pi.mp hderiv) 0
  convert hcoord using 1 <;>
    simp only [Pi.smul_apply, Pi.sub_apply, smul_eq_mul,
      div_eq_mul_inv, mul_comm]

/-- The exact mass-balance slope differs from flux linearization at the
cell average by a width-order term when both face states are nearby. -/
theorem leveque04_scalarCellAverage_pdeSlopeDefect
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux flux' : ℝ → ℝ)
    (a b t K S : ℝ)
    (hwidth : 0 < b - a) (hK : 0 ≤ K) (hS : 0 ≤ S)
    (hflux : ∀ y, HasDerivAt flux (flux' y) y)
    (hLip : ∀ y z, |flux' y - flux' z| ≤ K * |y - z|)
    (hleft : |q a t 0 -
      (oneDimensionalCellAverage (fun x => q x t) a b) 0| ≤
        S * (b - a))
    (hright : |q b t 0 -
      (oneDimensionalCellAverage (fun x => q x t) a b) 0| ≤
        S * (b - a)) :
    |(flux (q a t 0) - flux (q b t 0)) / (b - a) +
      flux' ((oneDimensionalCellAverage (fun x => q x t) a b) 0) *
        ((q b t 0 - q a t 0) / (b - a))| ≤
      (2 * (K * S ^ 2)) * (b - a) := by
  have h := fluxSecantTaylorError_le flux flux' K S (b - a)
    ((oneDimensionalCellAverage (fun x => q x t) a b) 0)
    (q a t 0) (q b t 0) hK hS hwidth hflux hLip hleft hright
  have hid :
      (flux (q a t 0) - flux (q b t 0)) / (b - a) +
        flux' ((oneDimensionalCellAverage (fun x => q x t) a b) 0) *
          ((q b t 0 - q a t 0) / (b - a)) =
      -((flux (q b t 0) - flux (q a t 0)) / (b - a) -
        flux' ((oneDimensionalCellAverage (fun x => q x t) a b) 0) *
          ((q b t 0 - q a t 0) / (b - a))) := by ring
  rw [hid, abs_neg]
  exact h

end NumStability
