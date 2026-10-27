/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainInitialTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainFrontSelection
import ComputationalMathematics.Source.LeVeque.Chapter04.REACertifiedRiemannFields

/-!
# Initial trace of certified REA Riemann fields

The adjacent fields come from the actual solver certificate. Their translated
Riemann initial data provide the initial state and mass of the bilateral
assembly on each grid cell.
-/

namespace NumStability
open Set MeasureTheory

/-- The certified local field has the left reconstructed state on the left
of its physical interface at time zero. -/
theorem leveque04_reaCertifiedLocalField_initial_left
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (j : ℤ) (x : ℝ)
    (hx : x < interface j) :
    leveque04_reaCertifiedLocalField method states hdomain interface j x 0 =
      states (j - 1) := by
  have h := (leveque04_reaCertifiedLocalField_initialRiemannData
    method states hdomain interface j).1 (x - interface j) (by linarith)
  simpa only [sub_add_cancel] using h

/-- The certified local field has the right reconstructed state on the
right of its physical interface at time zero. -/
theorem leveque04_reaCertifiedLocalField_initial_right
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (j : ℤ) (x : ℝ)
    (hx : interface j < x) :
    leveque04_reaCertifiedLocalField method states hdomain interface j x 0 =
      states j := by
  have h := (leveque04_reaCertifiedLocalField_initialRiemannData
    method states hdomain interface j).2 (x - interface j) (by linarith)
  simpa only [sub_add_cancel] using h

/-- Exterior speed cones for the certified fields give finite bilateral
windows once face `j + 1` is aligned with generic chain face `j`. -/
theorem leveque04_reaCertifiedBilateral_pointwiseFinite
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (origin width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Icc 0 horizon →
      x < origin + (j : ℝ) * width - bound * time →
        leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
          states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Icc 0 horizon →
      origin + (j : ℝ) * width + bound * time < x →
        leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
          states (j + 1)) :
    ∀ x time, time ∈ Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time)
        radius := by
  exact riemannChain_pointwise_finite_of_uniform_cones states
    (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
    origin width bound horizon hwidth hbound hhorizon hleft hright

/-- The bilateral assembly of the selected adjacent Riemann solutions obeys
the physical rectangle balance, with the solver's face numbering aligned to
the generic chain. -/
theorem leveque04_reaCertifiedBilateral_shifted_rectangleReferenceOn
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (leftSpeed rightSpeed : ℤ → ℝ)
    (origin width bound horizon left right : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hbox : left ≤ right)
    (hfinite : ∀ x time, time ∈ Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time)
        radius)
    (hspeeds : ∀ j, -bound ≤ leftSpeed j ∧
      leftSpeed j ≤ rightSpeed j ∧ rightSpeed j ≤ bound)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time →
        leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
          states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x →
        leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
          states (j + 1)) :
    LocalConservationLaw.RectangleReferenceOn
      (bilateralRiemannChainEvolution states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
        horizon hfinite)
      law.physicalFlux left right horizon := by
  exact bilateralRiemannChain_rectangleReferenceOn_of_affine_fronts
    states (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
    leftSpeed rightSpeed origin width bound horizon left right law.physicalFlux
    hwidth hbound hhorizon hbox hfinite hspeeds hinteraction
    (fun j => leveque04_reaCertifiedLocalField_rectangleReferenceOn
      method states hdomain interface (j + 1) left right horizon)
    hleft hright

/-- Inside a separated fan, the constructed field is exactly the selected
adjacent Riemann solver profile at that physical face. -/
theorem leveque04_reaCertifiedBilateral_eq_local_of_ordered_fronts
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (horizon : ℝ)
    (hfinite : ∀ x time, time ∈ Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time)
        radius)
    (leftFront rightFront : ℤ → ℝ)
    (horder : ∀ j, leftFront j ≤ rightFront j)
    (hseparate : ∀ j, rightFront j ≤ leftFront (j + 1))
    (x time : ℝ) (htime : time ∈ Icc 0 horizon)
    (hleft : ∀ j, x < leftFront j →
      leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
        states j)
    (hright : ∀ j, rightFront j < x →
      leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
        states (j + 1))
    (cell : ℤ) (hx : x ∈ Ioo (leftFront cell) (rightFront cell)) :
    bilateralRiemannChainEvolution states
      (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
      horizon hfinite x time =
        leveque04_reaCertifiedLocalField method states hdomain interface (cell + 1) x time := by
  simp only [bilateralRiemannChainEvolution, dif_pos htime]
  exact bilateralRiemannChainAssembly_eq_profile_of_ordered_fronts
    states (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time)
    (hfinite x time htime) leftFront rightFront horder hseparate x hleft hright cell hx

/-- In a gap between adjacent fans, the same assembled field is the
reconstructed constant cell state. -/
theorem leveque04_reaCertifiedBilateral_eq_state_of_ordered_fronts
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (horizon : ℝ)
    (hfinite : ∀ x time, time ∈ Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time)
        radius)
    (leftFront rightFront : ℤ → ℝ)
    (horder : ∀ j, leftFront j ≤ rightFront j)
    (hseparate : ∀ j, rightFront j ≤ leftFront (j + 1))
    (x time : ℝ) (htime : time ∈ Icc 0 horizon)
    (hleft : ∀ j, x < leftFront j →
      leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
        states j)
    (hright : ∀ j, rightFront j < x →
      leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
        states (j + 1))
    (cell : ℤ) (hx : x ∈ Ioo (rightFront (cell - 1)) (leftFront cell)) :
    bilateralRiemannChainEvolution states
      (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
      horizon hfinite x time = states cell := by
  simp only [bilateralRiemannChainEvolution, dif_pos htime]
  exact bilateralRiemannChainAssembly_eq_state_of_ordered_fronts
    states (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time)
    (hfinite x time htime) leftFront rightFront horder hseparate x hleft hright cell hx

/-- The bilateral evolution assembled from certified adjacent Riemann
fields has the original reconstructed state inside every open grid cell. -/
theorem leveque04_reaCertifiedBilateral_initial_eq_cell_state
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (origin width horizon : ℝ)
    (hwidth : 0 < width) (hhorizon : 0 ≤ horizon)
    (hface : ∀ j, interface (j + 1) = origin + (j : ℝ) * width)
    (hfinite : ∀ x time, time ∈ Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time)
        radius)
    (cell : ℤ) (x : ℝ)
    (hx : x ∈ Ioo (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width)) :
    bilateralRiemannChainEvolution states
      (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
      horizon hfinite x 0 = states (cell + 1) := by
  have hl : ∀ (j : ℤ) (y : ℝ), y < origin + (j : ℝ) * width →
      leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) y 0 =
        states j := by
    intro j y hy
    simpa only [add_sub_cancel_right] using
      leveque04_reaCertifiedLocalField_initial_left
        method states hdomain interface (j + 1) y (by rw [hface]; exact hy)
  have hr : ∀ (j : ℤ) (y : ℝ), origin + (j : ℝ) * width < y →
      leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) y 0 =
        states (j + 1) := by
    intro j y hy
    exact leveque04_reaCertifiedLocalField_initial_right
      method states hdomain interface (j + 1) y (by rw [hface]; exact hy)
  exact bilateralRiemannChainEvolution_initial_eq_cell_state
    states (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
    origin width horizon hwidth hhorizon hfinite hl hr cell x hx

/-- Exact initial cell mass of the certified bilateral Riemann assembly. -/
theorem leveque04_reaCertifiedBilateral_initial_cell_integral
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (origin width horizon : ℝ)
    (hwidth : 0 < width) (hhorizon : 0 ≤ horizon)
    (hface : ∀ j, interface (j + 1) = origin + (j : ℝ) * width)
    (hfinite : ∀ x time, time ∈ Icc 0 horizon →
      ∃ radius, IsRiemannChainWindow states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time)
        radius)
    (cell : ℤ) :
    (∫ x in (origin + (cell : ℝ) * width)..
        (origin + ((cell + 1 : ℤ) : ℝ) * width),
      bilateralRiemannChainEvolution states
        (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
        horizon hfinite x 0) = width • states (cell + 1) := by
  have hl : ∀ (j : ℤ) (y : ℝ), y < origin + (j : ℝ) * width →
      leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) y 0 =
        states j := by
    intro j y hy
    simpa only [add_sub_cancel_right] using
      leveque04_reaCertifiedLocalField_initial_left
        method states hdomain interface (j + 1) y (by rw [hface]; exact hy)
  have hr : ∀ (j : ℤ) (y : ℝ), origin + (j : ℝ) * width < y →
      leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) y 0 =
        states (j + 1) := by
    intro j y hy
    exact leveque04_reaCertifiedLocalField_initial_right
      method states hdomain interface (j + 1) y (by rw [hface]; exact hy)
  exact bilateralRiemannChainEvolution_initial_cell_integral
    states (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
    origin width horizon hwidth hhorizon hfinite hl hr cell

end NumStability
