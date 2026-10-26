/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection

/-!
# Spatial derivative of the physical time-averaged face flux

The exact time-averaged physical face flux is differentiated in the
spatial face coordinate by reusing the library's local parameterized
interval-integral derivative theorem.
-/

namespace NumStability

open MeasureTheory Set

/-- On a local space-time rectangle, the spatial derivative of the
exact time-averaged physical face flux is the time average of its
spatial derivative. -/
theorem leveque04_richtmyer_physicalFluxTimeAverage_hasDerivAt
    (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ)
    (physicalSlope : ℝ → ℝ → ℝ)
    (left right face timeStep : ℝ)
    (htime : 0 < timeStep) (hface : face ∈ Ioo left right)
    (hfluxCont : ContinuousOn
      (Function.uncurry (fun x τ => flux (q x τ)))
      (Icc left right ×ˢ Icc 0 timeStep))
    (hslopeCont : ContinuousOn
      (Function.uncurry physicalSlope)
      (Icc left right ×ˢ Icc 0 timeStep))
    (hspatial : ∀ x ∈ Ioo left right, ∀ τ ∈ Icc 0 timeStep,
      HasDerivAt (fun y => flux (q y τ)) (physicalSlope x τ) x) :
    HasDerivAt
      (fun x => oneDimensionalCellAverage
        (fun τ => flux (q x τ)) 0 timeStep)
      (oneDimensionalCellAverage
        (fun τ => physicalSlope face τ) 0 timeStep)
      face := by
  have h := LocalLinearAdvection.local_integral_hasDerivAt
    (fun x τ => flux (q x τ)) physicalSlope
    (a := 0) (b := timeStep) (c := left) (d := right) (t := face)
    htime.le hface hfluxCont hslopeCont hspatial
  have hscaled := h.const_mul timeStep⁻¹
  simpa only [oneDimensionalCellAverage, sub_zero, smul_eq_mul,
    mul_comm] using hscaled

/-- Global continuity and spatial differentiability supply the local
rectangle hypotheses at every face coordinate, so the spatial
derivative of the physical time-averaged flux is its time-averaged
spatial derivative everywhere. -/
theorem leveque04_richtmyer_physicalFluxTimeAverage_hasDerivAt_global
    (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ)
    (physicalSlope : ℝ → ℝ → ℝ)
    (timeStep : ℝ) (htime : 0 < timeStep)
    (hfluxCont : Continuous
      (Function.uncurry (fun x τ => flux (q x τ))))
    (hslopeCont : Continuous (Function.uncurry physicalSlope))
    (hspatial : ∀ x, ∀ τ ∈ Icc 0 timeStep,
      HasDerivAt (fun y => flux (q y τ)) (physicalSlope x τ) x) :
    ∀ face, HasDerivAt
      (fun x => oneDimensionalCellAverage
        (fun τ => flux (q x τ)) 0 timeStep)
      (oneDimensionalCellAverage
        (fun τ => physicalSlope face τ) 0 timeStep)
      face := by
  intro face
  apply leveque04_richtmyer_physicalFluxTimeAverage_hasDerivAt
    q flux physicalSlope (face - 1) (face + 1) face timeStep htime
  · simp only [mem_Ioo]
    constructor <;> linarith
  · exact hfluxCont.continuousOn
  · exact hslopeCont.continuousOn
  · intro x _ τ hτ
    exact hspatial x τ hτ

end NumStability
