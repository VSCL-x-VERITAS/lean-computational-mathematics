/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity

/-!
# Moving vector Riemann jumps

Unequal Riemann states produce a discontinuity along the whole moving jump.
Their interval integrability supplies rectangle conservation at every speed,
independently of the chosen representative at the jump.
-/

open MeasureTheory

namespace NumStability

variable {ι : Type*} [Fintype ι]

omit [Fintype ι] in
/-- Vector Riemann data with distinct states give actual discontinuities along
the entire moving jump, at every speed and every choice of the jump value. -/
theorem vectorStep_not_continuousAt_jump
    (left valueAtJump right : ι → ℝ) (hne : left ≠ right) (speed t : ℝ) :
    ¬ ContinuousAt (fun x => travelingWave (riemannData left valueAtJump right)
      speed x t) (speed * t) := by
  intro hc
  have hc' : ContinuousAt (fun x => travelingWave (riemannData left valueAtJump right)
      speed x t) ((0 : ℝ) + speed * t) := by simpa using hc
  have hprofile : ContinuousAt (riemannData left valueAtJump right) 0 := by
    simpa only [Function.comp_def, travelingWave, add_sub_cancel_right] using
      hc'.comp (x := 0) (f := fun z : ℝ => z + speed * t)
        (continuousAt_id.add_const (speed * t))
  exact (riemannData_isRiemannData left valueAtJump right).not_continuousAt_zero hne hprofile

/-- The moving vector jump is a conserved field, not an assumed balance
certificate: its rectangle law comes from integrable Riemann data. -/
theorem vectorStep_rectangle_and_discontinuity
    (left valueAtJump right : ι → ℝ) (hne : left ≠ right) (speed : ℝ) :
    IsRectangleConservationLawSolution
      (travelingWave (riemannData left valueAtJump right) speed)
      (fun state => speed • state) ∧
    ∀ t, ¬ ContinuousAt (fun x =>
      travelingWave (riemannData left valueAtJump right) speed x t) (speed * t) := by
  exact ⟨travelingWave_isRectangleConservationLawSolution _
    (riemannData_intervalIntegrable left valueAtJump right) speed,
    vectorStep_not_continuousAt_jump left valueAtJump right hne speed⟩

/-- A concrete finite-vector inhabitant shows the comparison premises are
jointly satisfiable, including a discontinuity at a strictly positive time. -/
theorem exists_discontinuous_rectangle_field :
    ∃ (q : ℝ → ℝ → Fin 1 → ℝ) (flux : (Fin 1 → ℝ) → Fin 1 → ℝ)
      (x t : ℝ),
      IsRectangleConservationLawSolution q flux ∧ 0 < t ∧
      ¬ ContinuousAt (fun ξ => q ξ t) x := by
  have hne : (0 : Fin 1 → ℝ) ≠ 1 := by
    intro h
    have hzero : (0 : ℝ) = 1 := congrFun h 0
    exact zero_ne_one hzero
  obtain ⟨hrectangle, hjump⟩ :=
    vectorStep_rectangle_and_discontinuity (0 : Fin 1 → ℝ) 0 1 hne 1
  exact ⟨_, _, 1, 1, hrectangle, by norm_num, by simpa using hjump 1⟩

end NumStability
