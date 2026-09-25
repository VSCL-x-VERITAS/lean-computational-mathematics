/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise27Target
import ComputationalMathematics.Source.LeVeque.Chapter02.PSystemHyperbolicity

/-!
# Exercise 2.7: generic p-system hyperbolicity

The existing p-system eigenbasis proof uses only the local negative slope in
its matrix calculation. An affine pressure law at positive volume transfers
that result to the same generic matrix at any real state.
-/

namespace NumStability.Leveque02Tracer

/-- The generic p-system is hyperbolic wherever its actual pressure slope is
negative, including signed states outside the physical gas domain. -/
theorem exercise27 : exercise27Target := by
  intro pressureLaw specificVolume pressureSlope _ hslope
  have hderiv :
      HasDerivAt (fun z : ℝ => pressureSlope * z) pressureSlope 1 := by
    simpa using (hasDerivAt_id (x := (1 : ℝ))).const_mul pressureSlope
  exact pSystemHyperbolicity
    (fun z : ℝ => pressureSlope * z) 1 pressureSlope
    (by norm_num) hderiv hslope

end NumStability.Leveque02Tracer
