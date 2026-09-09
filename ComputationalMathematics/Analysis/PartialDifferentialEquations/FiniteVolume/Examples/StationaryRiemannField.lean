/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxMethod

/-!
# A stationary inexact Riemann field

Unit-speed transport admits a consistent method returning stationary Riemann
data. Unequal states show that this returned field is not rectangle-conserved;
its positive-time interface trace still agrees with the translated reference.
-/

open MeasureTheory

namespace NumStability.StationaryRiemannField

variable {m : ℕ}

/-- Unit-speed vector transport, with its hyperbolicity proof kept local. -/
noncomputable def transportLaw : OneDimensionalHyperbolicConservationLaw (Fin m) :=
  linearHyperbolicConservationLaw 1 (by
    refine ⟨fun _ => 1, Pi.basisFun ℝ (Fin m), ?_⟩
    intro p
    simp only [Matrix.one_mulVec, one_smul])

@[simp] theorem physicalFlux (state : Fin m → ℝ) : transportLaw.physicalFlux state = state := by
  simp [transportLaw, linearHyperbolicConservationLaw]

/-- An intentionally inexact stationary return of the ordered initial data. -/
noncomputable def stationary (left right : Fin m → ℝ) (x _t : ℝ) : Fin m → ℝ :=
  riemannData left left right x

theorem stationary_initial (left right : Fin m → ℝ) :
    IsRiemannData (fun x => stationary left right x 0) left right :=
  riemannData_isRiemannData left left right

theorem stationary_trace_integrable (left right : Fin m → ℝ) (s t : ℝ) :
    IntervalIntegrable (fun τ => transportLaw.physicalFlux (stationary left right 0 τ)) volume s t := by
  simp only [physicalFlux, stationary, riemannData_zero]
  exact intervalIntegrable_const

/-- All problems are admitted; the actual returned field provides the interface
information. Its upwind flux is consistent even though its field is inexact. -/
def StationaryResult (problem : HyperbolicRiemannProblem (transportLaw (m := m))) :=
  {field : ℝ → ℝ → (Fin m → ℝ) // field = stationary problem.leftState problem.rightState}

/-- The field-producing method for unit-speed transport that admits every problem and returns
the stationary field `stationary`. Its extracted information is the returned field's interface
state at time `1`, and its numerical flux is the physical flux of that state; consistency on
constant states holds even though the returned field is not rectangle-conserved. -/
noncomputable def method : RiemannFieldFluxMethod (transportLaw (m := m)) StationaryResult (Fin m → ℝ) where
  domain := fun _ => True
  solve := fun problem _ => ⟨stationary problem.leftState problem.rightState, rfl⟩
  field := fun result => result.val
  initial := fun result => by rw [result.property]; exact stationary_initial _ _
  trace_integrable := fun result s t => by
    rw [result.property]
    exact stationary_trace_integrable _ _ s t
  extract := fun result => result.val 0 1
  numericalFlux := transportLaw.physicalFlux
  constants_in_domain := fun _ => True.intro
  consistent := by intro state; simp [stationary]

/-- The exact reference with the same initial data translates at the physical speed. -/
noncomputable def reference (left right : Fin m → ℝ) : ℝ → ℝ → (Fin m → ℝ) :=
  travelingWave (riemannData left left right) 1

theorem reference_rectangle (left right : Fin m → ℝ) :
    IsRectangleConservationLawSolution (reference left right) transportLaw.physicalFlux := by
  have hflux : (transportLaw (m := m)).physicalFlux = fun state => state := funext physicalFlux
  rw [hflux]
  simpa [reference] using travelingWave_isRectangleConservationLawSolution
    (riemannData left left right) (riemannData_intervalIntegrable left left right) 1

theorem reference_initial (left right : Fin m → ℝ) :
    IsRiemannData (fun x => reference left right x 0) left right := by
  simpa [reference, travelingWave] using riemannData_isRiemannData left left right

/-- The stationary output is not a conserved field for unequal states. -/
theorem stationary_not_rectangle {left right : Fin m → ℝ} (hne : left ≠ right) :
    ¬ IsRectangleConservationLawSolution (stationary left right) transportLaw.physicalFlux := by
  intro h
  have hb := h.2.2 (-1) 1 0 1
  have hz : (0 : Fin m → ℝ) = left - right := by
    norm_num [stationary, riemannData, intervalIntegral.integral_const] at hb
    ext j
    have hj := congrFun hb j
    change (0 : ℝ) = (1 : ℝ) * left j - (1 : ℝ) * right j at hj
    simpa using hj
  exact hne (sub_eq_zero.mp hz.symm)

/-- No extraction error occurs at the interface for this deliberately inexact field. -/
theorem method_flux_eq_returned_trace
    (problem : HyperbolicRiemannProblem (transportLaw (m := m))) (t : ℝ) :
    (method (m := m)).numericalFlux
      (method.extract (problem := problem) (method.solve problem trivial)) =
      transportLaw.physicalFlux
        (method.field (problem := problem) (method.solve problem trivial) 0 t) := rfl

/-- At positive time its interface trace also agrees with the exact local reference.
This does not make the two space-time fields equal. -/
theorem stationary_trace_eq_reference (left right : Fin m → ℝ) {t : ℝ} (ht : 0 < t) :
    stationary left right 0 t = reference left right 0 t := by
  simp [stationary, reference, travelingWave, riemannData, neg_lt_zero.mpr ht]

/-- A uniform state error bound follows from the two possible states; no chosen
accuracy tolerance is assumed. For nonzero jumps this is still an inexact field. -/
theorem stationary_reference_error_le (left right : Fin m → ℝ) (x t : ℝ) :
    ‖stationary left right x t - reference left right x t‖ ≤ ‖left - right‖ := by
  unfold stationary reference travelingWave riemannData
  split_ifs <;> simp [norm_sub_rev]

theorem nonexact_instance : ∃ problem : HyperbolicRiemannProblem (transportLaw (m := 1)),
    (method (m := 1)).domain problem ∧
    ¬ IsRectangleConservationLawSolution
      (method.field (problem := problem) (method.solve problem trivial))
      transportLaw.physicalFlux := by
  refine ⟨⟨0, 1⟩, trivial, ?_⟩
  exact stationary_not_rectangle (by intro h; have := congrFun h (0 : Fin 1); norm_num at this)

end NumStability.StationaryRiemannField
