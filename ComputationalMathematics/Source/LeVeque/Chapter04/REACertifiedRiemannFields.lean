/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleTranslation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainLocalReference

/-!
# Certified local Riemann fields for REA

The fields supplied to the bilateral chain are the actual certified solutions
of each ordered adjacent-cell Riemann problem, shifted to its physical face.
Their initial trace and rectangle conservation come from the solver certificate.
-/

namespace NumStability

/-- The certified Riemann solution for the ordered states on either side of
face `j`, translated from its local origin to that face. -/
noncomputable def leveque04_reaCertifiedLocalField
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (j : ℤ) : ℝ → ℝ → Fin m → ℝ :=
  fun x t =>
    (method.solve (adjacentCellRiemannProblem law states j) (hdomain j)).solution
      (x - interface j) t

/-- In local face coordinates, the field has the solver's ordered Riemann
initial trace. -/
theorem leveque04_reaCertifiedLocalField_initialRiemannData
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (j : ℤ) :
    IsRiemannData
      (fun x => leveque04_reaCertifiedLocalField method states hdomain interface j
        (x + interface j) 0)
      (states (j - 1)) (states j) := by
  simpa only [leveque04_reaCertifiedLocalField, adjacentCellRiemannProblem,
    add_sub_cancel_right] using
    (method.solve (adjacentCellRiemannProblem law states j) (hdomain j)).solves.1

/-- Each physically shifted local field conserves the same nonlinear
physical flux on any requested rectangle. -/
theorem leveque04_reaCertifiedLocalField_rectangleReferenceOn
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (j : ℤ) (left right horizon : ℝ) :
    LocalConservationLaw.RectangleReferenceOn
      (leveque04_reaCertifiedLocalField method states hdomain interface j)
      law.physicalFlux left right horizon := by
  have h :=
    (method.solve (adjacentCellRiemannProblem law states j) (hdomain j)).solves.2
  exact IsRectangleConservationLawSolution.rectangleReferenceOn _ _
    (IsRectangleConservationLawSolution.spatialShift _ _ h (interface j))
    left right horizon

/-- Uniform finite-speed exterior cones make the certified bilateral field
pointwise finitely assembled; no separate finite-tail premise is needed. -/
theorem leveque04_reaCertifiedLocalField_pointwiseFinite
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (origin width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width - bound * time →
        leveque04_reaCertifiedLocalField method states hdomain interface j x time =
          states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + bound * time < x →
        leveque04_reaCertifiedLocalField method states hdomain interface j x time =
          states (j + 1)) :
    ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface j x time)
        radius := by
  exact riemannChain_pointwise_finite_of_uniform_cones states
    (leveque04_reaCertifiedLocalField method states hdomain interface)
    origin width bound horizon hwidth hbound hhorizon hleft hright

/-- Under explicit finite-window, front and noninteraction conditions, the
bilateral assembly of certified adjacent Riemann solutions inherits physical
rectangle conservation. -/
theorem leveque04_reaCertifiedBilateral_rectangleReferenceOn
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (leftSpeed rightSpeed : ℤ → ℝ)
    (origin width bound horizon left right : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hbox : left ≤ right)
    (hfinite : ∀ x time, time ∈ Set.Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface j x time)
        radius)
    (hspeeds : ∀ j, -bound ≤ leftSpeed j ∧
      leftSpeed j ≤ rightSpeed j ∧ rightSpeed j ≤ bound)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time →
        leveque04_reaCertifiedLocalField method states hdomain interface j x time =
          states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x →
        leveque04_reaCertifiedLocalField method states hdomain interface j x time =
          states (j + 1)) :
    LocalConservationLaw.RectangleReferenceOn
      (bilateralRiemannChainEvolution states
        (leveque04_reaCertifiedLocalField method states hdomain interface)
        horizon hfinite)
      law.physicalFlux left right horizon := by
  exact bilateralRiemannChain_rectangleReferenceOn_of_affine_fronts
    states (leveque04_reaCertifiedLocalField method states hdomain interface)
    leftSpeed rightSpeed origin width bound horizon left right law.physicalFlux
    hwidth hbound hhorizon hbox hfinite hspeeds hinteraction
    (fun j => leveque04_reaCertifiedLocalField_rectangleReferenceOn
      method states hdomain interface j left right horizon)
    hleft hright

end NumStability
