/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicPowerSlopeCorrectionTarget

/-!
# LeVeque Chapter 2: IsentropicPowerSlopeCorrection

Proof of the corrected sign condition for a power-law pressure slope.
-/

namespace NumStability.Leveque02Tracer

/-- Exact parameter condition and formal counterexample for the power-law slope. -/
theorem isentropicPowerSlopeCorrection : isentropicPowerSlopeCorrectionTarget := by
  constructor
  · intro coefficient exponent
    constructor
    · intro h
      obtain ⟨slope, hslope, hpositive⟩ := h 1 one_pos
      have hformula : HasDerivAt (fun density : ℝ => coefficient * density ^ exponent)
          (coefficient * exponent) 1 := by
        convert (Real.hasDerivAt_rpow_const (Or.inl one_ne_zero)).const_mul coefficient using 1; simp
      have : slope = coefficient * exponent := hslope.unique hformula
      simpa [this] using hpositive
    · intro hproduct density hdensity
      refine ⟨coefficient * (exponent * density ^ (exponent - 1)), ?_, ?_⟩
      · exact (Real.hasDerivAt_rpow_const (Or.inl (ne_of_gt hdensity))).const_mul coefficient
      · rw [← mul_assoc]
        exact mul_pos hproduct (Real.rpow_pos_of_pos hdensity _)
  · intro h
    obtain ⟨slope, hslope, hpositive⟩ := h 1 one_pos
    have hzero : HasDerivAt (fun density : ℝ => (0 : ℝ) * density ^ (2 : ℝ)) 0 1 := by
      simpa using (hasDerivAt_const (1 : ℝ) (0 : ℝ))
    have : slope = 0 := hslope.unique hzero
    exact (lt_irrefl 0) (this ▸ hpositive)


/-- The corrected coefficient condition for a positive power-law pressure slope. -/
theorem isentropicPowerSlope_iff (coefficient exponent : ℝ) :
    positivePressureSlope (fun density : ℝ => coefficient * density ^ exponent) ↔
      0 < coefficient * exponent :=
  isentropicPowerSlopeCorrection.1 coefficient exponent

/-- Zero coefficient refutes the printed unqualified strict-positivity claim. -/
theorem isentropicPowerSlope_zeroCounterexample :
    ¬ positivePressureSlope (fun density : ℝ => (0 : ℝ) * density ^ (2 : ℝ)) :=
  isentropicPowerSlopeCorrection.2
end NumStability.Leveque02Tracer
