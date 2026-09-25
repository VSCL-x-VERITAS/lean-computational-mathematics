/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicSpecificVolumePressureTarget

/-!
# Isentropic pressure in positive specific volume
-/

namespace NumStability.Leveque02Tracer

/-- The existing positive-density power law becomes the reciprocal-volume
power law by the real-power inverse identity. -/
theorem isentropicSpecificVolumePressure : isentropicSpecificVolumePressureTarget := by
  intro coefficient exponent particlePosition eulerianDensity label time hpositive
  constructor
  · simp only [lagrangianSpecificVolume, one_div]
    exact inv_pos.mpr hpositive
  · simp only [isentropicPressureLaw, lagrangianSpecificVolume, one_div,
      Real.rpow_neg_eq_inv_rpow, inv_inv]

end NumStability.Leveque02Tracer
