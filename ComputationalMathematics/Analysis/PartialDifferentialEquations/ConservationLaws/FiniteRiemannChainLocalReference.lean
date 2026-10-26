/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainFrontGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainRectangleAE

/-!
# Free-front local conservation of a finite Riemann chain

Nonstrict cone CFL constructs local nonlinear conservation from individual profiles without prescribing any wave-front representatives.
-/

open MeasureTheory
namespace NumStability

/-- The nonstrict cone CFL constructs local nonlinear conservation from
individual Riemann profiles, without prescribing any wave-front values. -/
theorem finiteRiemannChain_rectangleReferenceOn_of_uniform_cones_free_fronts
    {m : ℕ} (states : ℕ → Fin m → ℝ) (fields : ℕ → ℝ → ℝ → Fin m → ℝ)
    (count : ℕ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (left right width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hcfl : 2 * bound * horizon ≤ width)
    (hfields : ∀ j < count, LocalConservationLaw.RectangleReferenceOn
      (fields j) flux left right horizon)
    (hleft : ∀ j < count, ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon,
      x < (j : ℝ) * width - bound * t → fields j x t = states j)
    (hright : ∀ j < count, ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon,
      (j : ℝ) * width + bound * t < x → fields j x t = states (j + 1)) :
    LocalConservationLaw.RectangleReferenceOn
      (fun x t => finiteRiemannChainAssembly states (fun j => fields j x t) count)
      flux left right horizon := by
  apply finiteRiemannChain_rectangleReferenceOn_of_flux_eq_ae_time states fields count
    flux left right horizon hhorizon hfields
  intro x hx
  have hpattern := isOrderedFiniteRiemannChain_of_uniform_cones_ae_time states fields count
    width bound horizon x hwidth hbound hcfl
    (fun j hj τ hτ => hleft j hj x hx τ hτ)
    (fun j hj τ hτ => hright j hj x hx τ hτ)
  filter_upwards [hpattern] with τ hp hτ
  rcases hp hτ with ⟨k, hk, hbefore, hafter⟩ | ⟨k, hk, hbefore, hafter⟩
  · exact finiteRiemannChainAssembly_map_eq_of_state flux states (fun j => fields j x τ)
      count k hk hbefore hafter
  · exact finiteRiemannChainAssembly_map_eq_of_profile flux states (fun j => fields j x τ)
      count k hk hbefore hafter

end NumStability
