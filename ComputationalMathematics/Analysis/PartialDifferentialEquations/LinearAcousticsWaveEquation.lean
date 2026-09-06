/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# The pressure wave equation from linear acoustics

This module makes the second-derivative and mixed-partial assumptions explicit
when eliminating velocity from the first-order acoustics system.
-/

namespace NumStability

/-- Classical partial derivative in the time coordinate. -/
noncomputable def partialTimeDerivative
    (field : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  deriv (fun τ => field x τ) t

/-- Classical partial derivative in the space coordinate. -/
noncomputable def partialSpaceDerivative
    (field : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  deriv (fun ξ => field ξ t) x

/-- Differentiating the two global first-order acoustic equations and equating
the mixed derivatives gives the scalar second-order pressure wave equation. -/
theorem LinearAcousticsSolution.pressureSecondOrderWaveAt
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
    (x t ptt pxx uxt utx : ℝ)
    (hptt : HasDerivAt
      (fun τ => partialTimeDerivative system.pressure x τ) ptt t)
    (huxt : HasDerivAt
      (fun τ => partialSpaceDerivative system.velocity x τ) uxt t)
    (hutx : HasDerivAt
      (fun ξ => partialTimeDerivative system.velocity ξ t) utx x)
    (hpxx : HasDerivAt
      (fun ξ => partialSpaceDerivative system.pressure ξ t) pxx x)
    (hmixed : uxt = utx) :
    ptt = (bulkModulus / density) * pxx := by
  have hfirst (s : ℝ) :
      partialTimeDerivative system.pressure x s +
          bulkModulus * partialSpaceDerivative system.velocity x s = 0 := by
    rcases system.satisfies x s with
      ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
    simpa [partialTimeDerivative, partialSpaceDerivative,
      hpt.deriv, hux.deriv] using hpressure
  have hsecond (y : ℝ) :
      partialTimeDerivative system.velocity y t +
          density⁻¹ * partialSpaceDerivative system.pressure y t = 0 := by
    rcases system.satisfies y t with
      ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
    simpa [partialTimeDerivative, partialSpaceDerivative,
      hut.deriv, hpx.deriv] using hvelocity
  have hfirstDerivative : ptt + bulkModulus * uxt = 0 := by
    have hsum := hptt.add (huxt.const_mul bulkModulus)
    have hzero : HasDerivAt (fun _ : ℝ => 0)
        (ptt + bulkModulus * uxt) t :=
      hsum.congr_of_eventuallyEq
        (Filter.Eventually.of_forall fun s => (hfirst s).symm)
    exact hzero.unique (hasDerivAt_const t 0)
  have hsecondDerivative : utx * density + pxx = 0 := by
    have hsum := hutx.add (hpxx.const_mul density⁻¹)
    have hzero : HasDerivAt (fun _ : ℝ => 0)
        (utx + density⁻¹ * pxx) x :=
      hsum.congr_of_eventuallyEq
        (Filter.Eventually.of_forall fun y => (hsecond y).symm)
    have hraw : utx + density⁻¹ * pxx = 0 :=
      hzero.unique (hasDerivAt_const x 0)
    field_simp [system.density_ne_zero] at hraw
    simpa using hraw
  rw [hmixed] at hfirstDerivative
  field_simp [system.density_ne_zero]
  linear_combination
    density * hfirstDerivative - bulkModulus * hsecondDerivative

end NumStability
