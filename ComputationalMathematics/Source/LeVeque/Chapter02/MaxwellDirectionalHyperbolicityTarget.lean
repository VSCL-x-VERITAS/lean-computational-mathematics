/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDirectionalHyperbolicityModel
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity

/-!
# Proof-free target: all-direction Maxwell hyperbolicity

The full six-state symbol represents both transverse polarizations and two
longitudinal zero modes. Hyperbolicity here means a complete real eigenbasis
for every spatial direction. The constitutive coefficients are fixed positive
scalars, so the squared propagation speed is `1/(εμ)`.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.115) has its actual cross-product directional principal
symbol, and that six-dimensional matrix has a real eigenbasis in every
direction when both material coefficients are positive. -/
def maxwellDirectionalHyperbolicityTarget : Prop :=
  ∀ (permittivity permeability : ℝ),
    0 < permittivity → 0 < permeability →
    ∀ (direction : MaxwellVector),
      NumStability.IsRealHyperbolicMatrix
        (maxwellDirectionalMatrix permittivity permeability direction) ∧
      ∀ (state : MaxwellStateIndex → ℝ) (component : Fin 3),
        (maxwellDirectionalMatrix permittivity permeability direction).mulVec
          state (Sum.inl component) =
            -(1 / (permittivity * permeability)) *
              crossProduct direction (state ∘ Sum.inr) component ∧
        (maxwellDirectionalMatrix permittivity permeability direction).mulVec
          state (Sum.inr component) =
            crossProduct direction (state ∘ Sum.inl) component

end NumStability.Leveque02Tracer
