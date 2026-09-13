/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ThermalDiffusionComparisonTarget
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-!
# Thermal conduction and diffusion comparison

Unit capacity identifies energy and temperature. For varying capacity, the
product rule computes the energy gradient and characterizes agreement of the
two flux laws. A positive material example exhibits their possible difference.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- The unit-capacity identification and the variable-capacity distinction in Section 2.3. -/
theorem thermalDiffusionComparison : thermalDiffusionComparisonTarget := by
  refine ⟨?_, ?_, ?_⟩
  · intro temperature conductivity gradient productDerivative x t S T
      _hx _ht _hspace _htime hgradient _hproduct
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro ξ τ
      simp only [thermalEnergyDensity, one_mul]
    · simpa only [thermalEnergyDensity, one_mul] using hgradient
    · rfl
    · simp only [thermalEnergyDensity, one_mul]
  · intro temperature capacity conductivity capacityGradient temperatureGradient x t S
      _hx _hunique hcapacity htemperature
    constructor
    · simpa only [thermalEnergyDensity] using hcapacity.mul htemperature
    · simp only [fourierHeatFlux, fickFlux]
      constructor <;> intro h <;> nlinarith [h]
  · refine ⟨fun x => x + 2, fun _ _ => 1, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · norm_num
    · intro x hx
      linarith [hx.1]
    · intro x t
      norm_num
    · exact hasDerivAt_const 0 1
    · simpa only [thermalEnergyDensity, mul_one] using
        (hasDerivAt_id (0 : ℝ)).add_const 2
    · unfold fourierHeatFlux fickFlux
      intro h
      linarith

end NumStability.Leveque02Tracer
