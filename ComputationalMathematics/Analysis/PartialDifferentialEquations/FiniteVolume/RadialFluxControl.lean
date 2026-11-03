/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Normed.Group.Basic
import Mathlib.Topology.MetricSpace.Pseudo.Constructions

/-!
# Quantitative control of a numerical flux near diagonal states

A common radial bound on a prescribed state set gives its diagonal value and
an explicit modulus of convergence relative to the product of that set.
The state set need not be open, bounded or nonempty.
-/

open Filter
open scoped Topology

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E]
  {states : Set E} {physicalFlux : E → E} {numericalFlux : E → E → E}
  {coefficient : ℝ}

/-- A radial bound fixes the numerical flux at each admitted diagonal state. -/
theorem radialFluxBound_consistent
    (hbound : ∀ reference ∈ states, ∀ left ∈ states, ∀ right ∈ states,
      ‖numericalFlux left right - physicalFlux reference‖ ≤
        coefficient * max ‖right - reference‖ ‖left - reference‖)
    {reference : E} (hreference : reference ∈ states) :
    numericalFlux reference reference = physicalFlux reference := by
  have hzero : ‖numericalFlux reference reference - physicalFlux reference‖ ≤ 0 := by
    simpa using hbound reference hreference reference hreference reference hreference
  exact sub_eq_zero.mp (norm_eq_zero.mp (le_antisymm hzero (norm_nonneg _)))

/-- The same coefficient supplies one positive modulus at every admitted state,
including when the coefficient is zero. -/
theorem radialFluxBound_modulus (hcoefficient : 0 ≤ coefficient)
    (hbound : ∀ reference ∈ states, ∀ left ∈ states, ∀ right ∈ states,
      ‖numericalFlux left right - physicalFlux reference‖ ≤
        coefficient * max ‖right - reference‖ ‖left - reference‖)
    {reference : E} (hreference : reference ∈ states)
    {ε : ℝ} (hε : 0 < ε) :
    0 < ε / (coefficient + 1) ∧
      ∀ left ∈ states, ∀ right ∈ states,
        ‖left - reference‖ < ε / (coefficient + 1) →
        ‖right - reference‖ < ε / (coefficient + 1) →
        ‖numericalFlux left right - physicalFlux reference‖ < ε := by
  have hdenominator : 0 < coefficient + 1 := add_pos_of_nonneg_of_pos hcoefficient zero_lt_one
  refine ⟨div_pos hε hdenominator, ?_⟩
  intro left hleft right hright hl hr
  have hmax_nonneg : 0 ≤ max ‖right - reference‖ ‖left - reference‖ :=
    (norm_nonneg _).trans (le_max_left _ _)
  calc
    ‖numericalFlux left right - physicalFlux reference‖ ≤
        coefficient * max ‖right - reference‖ ‖left - reference‖ :=
      hbound reference hreference left hleft right hright
    _ ≤ (coefficient + 1) * max ‖right - reference‖ ‖left - reference‖ :=
      mul_le_mul_of_nonneg_right (le_add_of_nonneg_right zero_le_one) hmax_nonneg
    _ = max ‖right - reference‖ ‖left - reference‖ * (coefficient + 1) := mul_comm _ _
    _ < ε := (lt_div_iff₀ hdenominator).mp (max_lt hr hl)

/-- A radial bound gives the actual paired limit within the prescribed state set. -/
theorem radialFluxBound_tendsto (hcoefficient : 0 ≤ coefficient)
    (hbound : ∀ reference ∈ states, ∀ left ∈ states, ∀ right ∈ states,
      ‖numericalFlux left right - physicalFlux reference‖ ≤
        coefficient * max ‖right - reference‖ ‖left - reference‖)
    {reference : E} (hreference : reference ∈ states) :
    Tendsto (fun p : E × E => numericalFlux p.1 p.2)
      (𝓝[states ×ˢ states] (reference, reference)) (𝓝 (physicalFlux reference)) := by
  apply Metric.tendsto_nhdsWithin_nhds.mpr
  intro ε hε
  obtain ⟨hδ, hcontrol⟩ := radialFluxBound_modulus hcoefficient hbound hreference hε
  refine ⟨ε / (coefficient + 1), hδ, ?_⟩
  intro p hp hdistance
  have hpair : max ‖p.1 - reference‖ ‖p.2 - reference‖ < ε / (coefficient + 1) := by
    simpa only [Prod.dist_eq, dist_eq_norm] using hdistance
  rw [dist_eq_norm]
  exact hcontrol p.1 hp.1 p.2 hp.2 (max_lt_iff.mp hpair).1 (max_lt_iff.mp hpair).2

end NumStability
