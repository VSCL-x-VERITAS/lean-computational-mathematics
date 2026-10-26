/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.StationaryJump
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.SpatialConstancy
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ConstantTraceAverage

/-!
# LeVeque Chapter 4: constant states

The explicit constant field satisfies pointwise and rectangle conservation,
and its positive-time physical-flux average equals the flux at that state.
The interval theorems handle spatially constant classical and integral
conservation-law solutions. The integral wrappers use the original field and
its physical-flux trace; no uniqueness from constant initial data is asserted.
-/

namespace NumStability

variable {m : ℕ}

/-- The space-time field that realizes the source's selected constant state.
This constructs one stationary solution and makes no uniqueness claim. -/
def leveque04ConstantStateField (qbar : Fin m → ℝ) :
    ℝ → ℝ → Fin m → ℝ := fun _ _ => qbar

/-- The selected constant space-time field satisfies the pointwise conservation
residual for any physical flux. -/
theorem leveque04_constantStateField_solutionAt
    (qbar : Fin m → ℝ) (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (x t : ℝ) :
    IsConservationLawSolutionAt (leveque04ConstantStateField qbar) physicalFlux x t := by
  exact stationaryField_constantFlux_residual (fun _ => qbar) (physicalFlux qbar) x t

/-- The selected constant space-time field satisfies rectangle conservation.
The conclusion certifies existence of this stationary solution only. -/
theorem leveque04_constantStateField_rectangle
    (qbar : Fin m → ℝ) (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ)) :
    IsRectangleConservationLawSolution
      (leveque04ConstantStateField qbar) physicalFlux := by
  exact stationaryField_constantFlux_rectangle
    (fun _ => qbar)
    (fun _ _ => intervalIntegrable_const)
    physicalFlux (physicalFlux qbar) (fun _ => rfl)

/-- The positive-time average of physical flux along the selected constant trace
is the physical flux at that state. This is independent of numerical flux
consistency and asserts no persistence or uniqueness for other solutions. -/
theorem leveque04_constantState_physicalFluxAverage
    (qbar : Fin m → ℝ) (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    {timeStep : ℝ} (htime : 0 < timeStep) :
    IntervalIntegrable
        (fun τ => physicalFlux (leveque04ConstantStateField qbar 0 τ))
        MeasureTheory.volume 0 timeStep ∧
      oneDimensionalCellAverage
          (fun τ => physicalFlux (leveque04ConstantStateField qbar 0 τ))
          0 timeStep = physicalFlux qbar := by
  simpa only [leveque04ConstantStateField] using oneDimensionalCellAverage_map_of_constantTraceOn
    physicalFlux (fun _ => qbar) qbar 0 timeStep htime
    (fun _ _ => rfl)

/-- Spatial constancy of an exact integral-conservation solution implies
temporal constancy on the selected cell and closed time slab. -/
theorem leveque04_spatiallyConstant_integral_timeConstant
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right a b : ℝ) (hcell : left < right) (hab : a ≤ b)
    (hspatial : ∀ x t, x ∈ Set.Icc left right → t ∈ Set.Icc a b →
      q x t = q left t)
    (hsolution : IsRectangleConservationLawSolution q physicalFlux) :
    ∀ x t, x ∈ Set.Icc left right → t ∈ Set.Icc a b →
      q x t = q left a := by
  exact spatially_constant_integral_balance_time_constant_on_Icc q physicalFlux
    left right a b hcell hab hspatial (fun t _ => hsolution.2.2 left right a t)


/-- Equation (4.5) for the original trace of a spatially constant exact solution
reduces to the physical flux of its constant state. -/
theorem leveque04_spatiallyConstant_integral_physicalFluxAverage
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right a b : ℝ) (hcell : left < right) (hab : a ≤ b)
    (hspatial : ∀ x t, x ∈ Set.Icc left right → t ∈ Set.Icc a b →
      q x t = q left t)
    (hsolution : IsRectangleConservationLawSolution q physicalFlux)
    (x start finish : ℝ) (hx : x ∈ Set.Icc left right)
    (hstart : a ≤ start) (hfinish : finish ≤ b) (htime : start < finish) :
    IntervalIntegrable (fun τ => physicalFlux (q x τ)) MeasureTheory.volume start finish ∧
      oneDimensionalCellAverage (fun τ => physicalFlux (q x τ)) start finish =
        physicalFlux (q left a) := by
  exact spatially_constant_integral_balance_physicalFluxAverage_on_Icc q physicalFlux
    left right a b hcell hab hspatial (fun t _ => hsolution.2.2 left right a t)
    x start finish hx hstart hfinish htime

end NumStability
