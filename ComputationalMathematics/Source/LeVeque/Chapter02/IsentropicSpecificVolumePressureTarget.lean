/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicPressure
import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianParticleMapModel

/-!
# Proof-free target for the isentropic p(V) law on printed page 43

The same isentropic equation of state from equation (2.35) is expressed in
terms of positive Lagrangian specific volume `V = 1/ρ(X,t)`.
-/

namespace NumStability.Leveque02Tracer

/-- The positive-density isentropic law `κ̂ρ^γ` equals `κ̂V^(-γ)` at a
Lagrangian particle, where `V=1/ρ` is genuinely positive. -/
def isentropicSpecificVolumePressureTarget : Prop :=
  ∀ (coefficient exponent : ℝ)
    (particlePosition eulerianDensity : ℝ → ℝ → ℝ) (label time : ℝ),
    (hpositive : 0 < eulerianDensity (particlePosition label time) time) →
    0 < lagrangianSpecificVolume eulerianDensity particlePosition label time ∧
      isentropicPressureLaw coefficient exponent
        ⟨eulerianDensity (particlePosition label time) time, hpositive⟩ =
        coefficient *
          lagrangianSpecificVolume eulerianDensity particlePosition label time ^ (-exponent)

end NumStability.Leveque02Tracer
