/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity

/-!
# The scalar advection Riemann example

Printed page 52/raw PDF page 74. The scalar coefficient has eigenvalue equal
to the advection speed and unit eigenvector. The translated Riemann data have
left and right states separated by a jump traveling at that speed. The source
does not prescribe the value on the jump ray, so it remains a parameter.
-/

open MeasureTheory

namespace NumStability

/-- In the one-component system, the unit vector is an eigenvector of the
scalar coefficient matrix with eigenvalue equal to its entry. -/
theorem leveque03_scalarAdvection_eigenpair (speed : ℝ) :
    Matrix.mulVec (fun _ _ : Fin 1 => speed) (fun _ => (1 : ℝ)) =
      speed • (fun _ : Fin 1 => (1 : ℝ)) := by
  ext i
  fin_cases i
  simp [Matrix.mulVec, dotProduct]

/-- The scalar Riemann profile translated at the advection speed. Its value
on the moving jump is the explicit free origin value. -/
noncomputable def leveque03_scalarRiemannSolution
    (speed left valueAtOrigin right : ℝ) : ℝ → ℝ → ℝ :=
  travelingWave (riemannData left valueAtOrigin right) speed

/-- The time-zero profile has exactly the two strict half-line states. -/
theorem leveque03_scalarRiemann_initial
    (speed left valueAtOrigin right : ℝ) :
    IsRiemannData
      (fun x => leveque03_scalarRiemannSolution speed left valueAtOrigin right x 0)
      left right := by
  simpa only [leveque03_scalarRiemannSolution, travelingWave_zero] using
    (riemannData_isRiemannData left valueAtOrigin right)

/-- The solution has the left state strictly left of the moving jump. -/
theorem leveque03_scalarRiemann_left
    (speed left valueAtOrigin right x t : ℝ) (hx : x < speed * t) :
    leveque03_scalarRiemannSolution speed left valueAtOrigin right x t = left := by
  have hneg : x - speed * t < 0 := sub_neg.mpr hx
  simp [leveque03_scalarRiemannSolution, travelingWave, riemannData, hneg]

/-- The solution has the right state strictly right of the moving jump. -/
theorem leveque03_scalarRiemann_right
    (speed left valueAtOrigin right x t : ℝ) (hx : speed * t < x) :
    leveque03_scalarRiemannSolution speed left valueAtOrigin right x t = right := by
  have hpos : 0 < x - speed * t := sub_pos.mpr hx
  have hnotLeft : ¬ x - speed * t < 0 := not_lt_of_ge hpos.le
  simp [leveque03_scalarRiemannSolution, travelingWave, riemannData, hpos, hnotLeft]

/-- The moving step satisfies scalar advection in integral conservation form,
including when the two states differ. -/
theorem leveque03_scalarRiemann_rectangle
    (speed left valueAtOrigin right : ℝ) :
    IsRectangleConservationLawSolution
      (leveque03_scalarRiemannSolution speed left valueAtOrigin right)
      (fun state => speed * state) := by
  simpa only [leveque03_scalarRiemannSolution, smul_eq_mul] using
    travelingWave_isRectangleConservationLawSolution
      (riemannData left valueAtOrigin right)
      (riemannData_intervalIntegrable left valueAtOrigin right) speed

/-- Distinct states make the moving ray an actual discontinuity, regardless
of the freely chosen point value on that ray. -/
theorem leveque03_scalarRiemann_jump
    (speed left valueAtOrigin right : ℝ) (hne : left ≠ right) (t : ℝ) :
    ¬ ContinuousAt
      (fun x => leveque03_scalarRiemannSolution speed left valueAtOrigin right x t)
      (speed * t) := by
  intro hc
  have hc' : ContinuousAt
      (fun x => leveque03_scalarRiemannSolution speed left valueAtOrigin right x t)
      ((0 : ℝ) + speed * t) := by simpa using hc
  have hprofile : ContinuousAt (riemannData left valueAtOrigin right) 0 := by
    simpa only [Function.comp_def, leveque03_scalarRiemannSolution,
      travelingWave, add_sub_cancel_right] using
      hc'.comp (x := 0) (f := fun z : ℝ => z + speed * t)
        (continuousAt_id.add_const (speed * t))
  exact (riemannData_isRiemannData left valueAtOrigin right).not_continuousAt_zero
    hne hprofile

end NumStability
