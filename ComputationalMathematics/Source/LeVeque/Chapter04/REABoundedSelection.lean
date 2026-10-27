/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REABoundedBilateralEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChainFrontSelection

/-!
# Selecting the actual bilateral REA field

Adjacent noninteraction at the closed step gives separated fronts at every
earlier time. Inside each open fan, the actual constructed field equals its
local Riemann profile; in each open gap, it equals the reconstructed state.
Values on wave fronts are free, including where fronts first meet.
-/

namespace NumStability

/-- The actual REA field selects the local Riemann profile inside its open fan. -/
theorem leveque04_reaBoundedEvolution_eq_profile
    {E : Type*} [AddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width bound step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hstep : 0 ≤ step)
    (hspeeds : ∀ j, -bound ≤ leftSpeed j ∧ leftSpeed j ≤ rightSpeed j ∧ rightSpeed j ≤ bound)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * step)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1))
    (cell : ℤ) (x time : ℝ) (htime : time ∈ Set.Icc 0 step)
    (hx : x ∈ Set.Ioo (origin + (cell : ℝ) * width + leftSpeed cell * time) (origin + (cell : ℝ) * width + rightSpeed cell * time)) :
    leveque04_reaBoundedEvolution states fields leftSpeed rightSpeed origin width bound step
      hwidth hbound hstep hspeeds hinteraction hleft hright x time = fields cell x time := by
  have horder : ∀ j : ℤ, origin + (j : ℝ) * width + leftSpeed j * time ≤
      origin + (j : ℝ) * width + rightSpeed j * time := by
    intro j
    have := mul_le_mul_of_nonneg_right (hspeeds j).2.1 htime.1
    linarith
  have hseparate : ∀ j : ℤ, origin + (j : ℝ) * width + rightSpeed j * time ≤
      origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * time := by
    intro j
    apply affine_front_gap_on_closed_interval _ _ _ _ step time _ (hinteraction j) htime
    have hj : (j : ℝ) < ((j + 1 : ℤ) : ℝ) := by exact_mod_cast (show j < j + 1 by omega)
    nlinarith
  unfold leveque04_reaBoundedEvolution
  simp only [bilateralRiemannChainEvolution, dif_pos htime]
  exact bilateralRiemannChainAssembly_eq_profile_of_ordered_fronts states
    (fun j => fields j x time) _
    (fun j => origin + (j : ℝ) * width + leftSpeed j * time)
    (fun j => origin + (j : ℝ) * width + rightSpeed j * time)
    horder hseparate x (fun j => hleft j x time htime)
    (fun j => hright j x time htime) cell hx

/-- The actual REA field selects the reconstructed state in an open inter-fan gap. -/
theorem leveque04_reaBoundedEvolution_eq_state
    {E : Type*} [AddCommGroup E] (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width bound step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hstep : 0 ≤ step)
    (hspeeds : ∀ j, -bound ≤ leftSpeed j ∧ leftSpeed j ≤ rightSpeed j ∧ rightSpeed j ≤ bound)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * step)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1))
    (cell : ℤ) (x time : ℝ) (htime : time ∈ Set.Icc 0 step)
    (hx : x ∈ Set.Ioo (origin + ((cell - 1 : ℤ) : ℝ) * width + rightSpeed (cell - 1) * time) (origin + (cell : ℝ) * width + leftSpeed cell * time)) :
    leveque04_reaBoundedEvolution states fields leftSpeed rightSpeed origin width bound step
      hwidth hbound hstep hspeeds hinteraction hleft hright x time = states cell := by
  have horder : ∀ j : ℤ, origin + (j : ℝ) * width + leftSpeed j * time ≤
      origin + (j : ℝ) * width + rightSpeed j * time := by
    intro j
    have := mul_le_mul_of_nonneg_right (hspeeds j).2.1 htime.1
    linarith
  have hseparate : ∀ j : ℤ, origin + (j : ℝ) * width + rightSpeed j * time ≤
      origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * time := by
    intro j
    apply affine_front_gap_on_closed_interval _ _ _ _ step time _ (hinteraction j) htime
    have hj : (j : ℝ) < ((j + 1 : ℤ) : ℝ) := by exact_mod_cast (show j < j + 1 by omega)
    nlinarith
  unfold leveque04_reaBoundedEvolution
  simp only [bilateralRiemannChainEvolution, dif_pos htime]
  exact bilateralRiemannChainAssembly_eq_state_of_ordered_fronts states
    (fun j => fields j x time) _
    (fun j => origin + (j : ℝ) * width + leftSpeed j * time)
    (fun j => origin + (j : ℝ) * width + rightSpeed j * time)
    horder hseparate x (fun j => hleft j x time htime)
    (fun j => hright j x time htime) cell hx

end NumStability
