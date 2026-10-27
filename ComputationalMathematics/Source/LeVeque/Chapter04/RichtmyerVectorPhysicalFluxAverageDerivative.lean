/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorFaceDerivativeBudget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection

/-!
# Spatial derivative of the vector physical time-averaged face flux

The library's vector-valued parameterized-integral theorem permits
spatial differentiation of the exact time-averaged physical flux.
-/

namespace NumStability

open MeasureTheory Set

theorem leveque04_richtmyer_vectorPhysicalFluxTimeAverage_hasDerivAt
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (physicalSlope : ℝ → ℝ → Fin m → ℝ)
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
  have hscaled := h.const_smul timeStep⁻¹
  simpa only [oneDimensionalCellAverage, sub_zero] using hscaled

theorem leveque04_richtmyer_vectorPhysicalFluxTimeAverage_hasDerivAt_global
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (physicalSlope : ℝ → ℝ → Fin m → ℝ)
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
  apply leveque04_richtmyer_vectorPhysicalFluxTimeAverage_hasDerivAt
    q flux physicalSlope (face - 1) (face + 1) face timeStep htime
  · simp only [mem_Ioo]
    constructor <;> linarith
  · exact hfluxCont.continuousOn
  · exact hslopeCont.continuousOn
  · intro x _ τ hτ
    exact hspatial x τ hτ

/-- The spatial derivative of the actual vector face-flux error is
the difference between its Jacobian-chain expression and the exact
time-averaged physical flux slope. -/
theorem leveque04_richtmyer_vectorExactAverageFaceError_hasDerivAt
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) → (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (physicalSlope : ℝ → ℝ → Fin m → ℝ)
    (timeStep width face : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hprofile : Continuous (fun x => q x 0))
    (hflux : ∀ z, HasFDerivAt flux (jacobian z) z)
    (hfluxCont : Continuous
      (Function.uncurry (fun x τ => flux (q x τ))))
    (hslopeCont : Continuous (Function.uncurry physicalSlope))
    (hspatial : ∀ x, ∀ τ ∈ Icc 0 timeStep,
      HasDerivAt (fun y => flux (q y τ)) (physicalSlope x τ) x) :
    let left := fun x => oneDimensionalCellAverage (fun y => q y 0)
      (x - width) x
    let right := fun x => oneDimensionalCellAverage (fun y => q y 0)
      x (x + width)
    let leftSlope := fun x => width⁻¹ • (q x 0 - q (x - width) 0)
    let rightSlope := fun x => width⁻¹ • (q (x + width) 0 - q x 0)
    HasDerivAt
      (fun x => leveque04_richtmyerFlux timeStep width flux
          (left x) (right x) -
        oneDimensionalCellAverage (fun τ => flux (q x τ)) 0 timeStep)
      (jacobian
          (leveque04_richtmyerPredictor timeStep width flux
            (left face) (right face))
          ((1 / 2 : ℝ) • (leftSlope face + rightSlope face) -
            (timeStep / (2 * width)) •
              (jacobian (right face) (rightSlope face) -
                jacobian (left face) (leftSlope face))) -
        oneDimensionalCellAverage
          (fun τ => physicalSlope face τ) 0 timeStep) face := by
  dsimp only
  exact (leveque04_richtmyer_vectorExactAverageFace_hasDerivAt
    (fun x => q x 0) flux jacobian timeStep width face
    hprofile hwidth hflux).sub
      (leveque04_richtmyer_vectorPhysicalFluxTimeAverage_hasDerivAt_global
        q flux physicalSlope timeStep htime hfluxCont hslopeCont hspatial face)

end NumStability
