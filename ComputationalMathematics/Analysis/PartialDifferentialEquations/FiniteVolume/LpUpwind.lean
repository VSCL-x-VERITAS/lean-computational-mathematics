/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Normed.Lp.Reindex
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointDefectAccumulation

/-!
# Signed upwind averaging on infinite grids

For any real normed-space values and `1 ≤ p ≤ ∞`, the signed Courant number
selects the upstream neighbor. Its absolute value is the averaging weight.
The CFL bound makes this operator contractive, including on perturbations.
-/

namespace NumStability

noncomputable section

/-- The upstream index translation selected by a signed Courant number. -/
def upwindIndexEquiv (courant : ℝ) : ℤ ≃ ℤ :=
  Equiv.addRight (if 0 ≤ courant then (-1 : ℤ) else 1)

/-- Signed upwind averaging as a continuous linear map on `ℓᵖ`. -/
def lpUpwindStep {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] (courant : ℝ) :
    lp (fun _ : ℤ => E) p →L[ℝ] lp (fun _ : ℤ => E) p :=
  lpReindexAverage (upwindIndexEquiv courant) |courant|

/-- Pointwise form of the signed upstream average. -/
@[simp] theorem lpUpwindStep_apply {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] (courant : ℝ)
    (u : lp (fun _ : ℤ => E) p) (i : ℤ) :
    lpUpwindStep courant u i =
      (1 - |courant|) • u i +
        |courant| • u (i + if 0 ≤ courant then (-1 : ℤ) else 1) := rfl

/-- The CFL bound gives norm contraction for every supported exponent. -/
theorem lpUpwindStep_norm_le {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] {courant : ℝ} (hcfl : |courant| ≤ 1)
    (u : lp (fun _ : ℤ => E) p) :
    ‖lpUpwindStep courant u‖ ≤ ‖u‖ :=
  lpReindexAverage_norm_le (upwindIndexEquiv courant) (abs_nonneg _) hcfl u

/-- A signed upwind step cannot amplify grid perturbations under CFL. -/
theorem lpUpwindStep_norm_sub_le {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] {courant : ℝ} (hcfl : |courant| ≤ 1)
    (u v : lp (fun _ : ℤ => E) p) :
    ‖lpUpwindStep courant u - lpUpwindStep courant v‖ ≤ ‖u - v‖ :=
  lpReindexAverage_norm_sub_le (upwindIndexEquiv courant) (abs_nonneg _) hcfl u v

/-- Global sequence-norm error propagation, without a pointwise maximum
norm restriction. The reference defect and initial error are independent. -/
theorem lpUpwindStep_iterate_error {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] {courant : ℝ} (hcfl : |courant| ≤ 1)
    (initial : lp (fun _ : ℤ => E) p) (reference : ℕ → lp (fun _ : ℤ => E) p)
    (steps : ℕ) (initialError error : ℝ)
    (hinitial : ‖initial - reference 0‖ ≤ initialError)
    (hdefect : ∀ k < steps,
      ‖lpUpwindStep courant (reference k) - reference (k + 1)‖ ≤ error) :
    ‖(lpUpwindStep courant)^[steps] initial - reference steps‖ ≤
      initialError + (steps : ℝ) * error :=
  iterate_error_le_of_nonexpansive_of_initial_error (lpUpwindStep courant)
    (lpUpwindStep_norm_sub_le hcfl) initial reference steps initialError error hinitial hdefect

end
end NumStability
