/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RiemannChainUniformWindow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannActiveFronts

/-!
# Bilateral assembly of linear Riemann fields

Finite characteristic spectra supply a uniform exterior-speed bound. Actual
Riemann profiles therefore have compatible finite windows on any closed
forward time interval, even when profiles overlap. Assembly uses the existing
bilateral telescoping construction.
-/

namespace NumStability

/-- Arbitrary linear Riemann cell data admit a finite assembly window at
every point of a closed forward interval. No noninteraction hypothesis is
needed for existence of the linear superposition. -/
theorem linearRiemannChain_finite
    {ι : Type*} [Fintype ι]
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (states : ℤ → ι → ℝ) (origin width horizon : ℝ)
    (hwidth : 0 < width) (hhorizon : 0 ≤ horizon) :
    ∀ x time, time ∈ Set.Icc 0 horizon → ∃ radius,
      IsRiemannChainWindow states
        (fun j => linearRiemannSolution basis speeds (states j) (states j)
          (states (j + 1)) (x - (origin + (j : ℝ) * width)) time) radius := by
  classical
  let bound := ∑ p, |speeds p|
  have hbound : 0 ≤ bound := Finset.sum_nonneg (fun _ _ => abs_nonneg _)
  have hspeeds (p : ι) : -bound ≤ speeds p ∧ speeds p ≤ bound := by
    have hsum : |speeds p| ≤ bound :=
      Finset.single_le_sum (fun q _ => abs_nonneg (speeds q)) (Finset.mem_univ p)
    exact abs_le.mp hsum
  apply riemannChain_pointwise_finite_of_uniform_cones states _
    origin width bound horizon hwidth hbound hhorizon
  · intro j x time ht hx
    apply linearRiemannSolution_left_of_active_front basis speeds
      (states j) (states (j + 1)) (-bound) _ time
      (fun p _ => (hspeeds p).1) ht.1
    linarith
  · intro j x time ht hx
    apply linearRiemannSolution_right_of_active_front basis speeds
      (states j) (states (j + 1)) bound _ time
      (fun p _ => (hspeeds p).2) ht.1
    linarith

/-- The actual bilateral linear Riemann assembly on a closed forward interval. -/
noncomputable def linearRiemannChainEvolution
    {ι : Type*} [Fintype ι]
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (states : ℤ → ι → ℝ) (origin width horizon : ℝ)
    (hwidth : 0 < width) (hhorizon : 0 ≤ horizon) : ℝ → ℝ → ι → ℝ :=
  bilateralRiemannChainEvolution states
    (fun j x time => linearRiemannSolution basis speeds (states j) (states j)
      (states (j + 1)) (x - (origin + (j : ℝ) * width)) time) horizon
    (linearRiemannChain_finite basis speeds states origin width horizon hwidth hhorizon)

end NumStability
