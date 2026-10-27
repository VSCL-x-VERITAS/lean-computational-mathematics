/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleFluxShift

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

/-- A moving Riemann jump also solves a nonlinear conservation law
whose flux agrees with an affine flux on all three selected states. -/
theorem movingRiemannData_rectangle_of_affineFluxOnStates
    (left valueAtJump right : ι → ℝ)
    (speed : ℝ) (flux : (ι → ℝ) → (ι → ℝ))
    (offset : ι → ℝ)
    (hleft : flux left = speed • left + offset)
    (hjump : flux valueAtJump = speed • valueAtJump + offset)
    (hright : flux right = speed • right + offset) :
    IsRectangleConservationLawSolution
      (travelingWave (riemannData left valueAtJump right) speed)
      flux := by
  apply IsRectangleConservationLawSolution.of_flux_eq_add_const
    _ (fun state => speed • state) flux offset
    (travelingWave_isRectangleConservationLawSolution _
      (riemannData_intervalIntegrable left valueAtJump right) speed)
  intro x t
  unfold travelingWave riemannData
  split_ifs <;> simp [hleft, hjump, hright]

/-- Any locally integrable profile transported at one speed solves a
nonlinear conservation law when the flux is affine on that profile's
range. The profile may contain several jumps. -/
theorem travelingWave_rectangle_of_affineFluxOnRange
    (profile : ℝ → ι → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed : ℝ) (flux : (ι → ℝ) → (ι → ℝ))
    (offset : ι → ℝ)
    (hflux : ∀ x, flux (profile x) = speed • profile x + offset) :
    IsRectangleConservationLawSolution
      (travelingWave profile speed) flux := by
  apply IsRectangleConservationLawSolution.of_flux_eq_add_const
    _ (fun state => speed • state) flux offset
    (travelingWave_isRectangleConservationLawSolution
      profile hprofile speed)
  intro x t
  exact hflux (x - speed * t)

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
