/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PSystemHyperbolicityTarget

/-!
# Proof-free target: Exercise 2.7

The generic lowercase p-system (2.108) permits an arbitrary real state. The
physical gas application restricts this statement to positive volume.
-/

namespace NumStability.Leveque02Tracer

/-- Negative actual pressure slope gives a full real eigenbasis for the
generic p-system flux Jacobian at each real state, with opposite nonzero wave
speeds. Applying this pointwise where `p′(V)<0` gives hyperbolicity there. -/
def exercise27Target : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (specificVolume pressureSlope : ℝ),
    HasDerivAt pressureLaw pressureSlope specificVolume →
    pressureSlope < 0 →
    let waveSpeed := Real.sqrt (-pressureSlope)
    let fluxJacobian : Matrix (Fin 2) (Fin 2) ℝ :=
      !![0, -1; pressureSlope, 0]
    0 < waveSpeed ∧ IsRealHyperbolicMatrix fluxJacobian

end NumStability.Leveque02Tracer
