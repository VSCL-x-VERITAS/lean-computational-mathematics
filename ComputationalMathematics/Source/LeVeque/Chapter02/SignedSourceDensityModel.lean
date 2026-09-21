/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SectionMassUnitsModel

/-!
# Signed source density

The local source density may depend on the current scalar state, position, and
time. Its value is signed: a negative value represents a sink. Integrability is
imposed by balance-law results that consume this local model, rather than by the
definition itself.
-/

namespace NumStability.Leveque02Tracer

/-- A signed local source density depending on tracer density, position, and
time. -/
structure SignedSourceDensity where
  value : LinearMassDensity → ℝ → ℝ → ℝ

/-- The source's convention that a negative local source-density value denotes
a sink. This definition does not classify zero or positive values. -/
def IsSinkAt (sourceDensity : SignedSourceDensity)
    (state : LinearMassDensity) (position time : ℝ) : Prop :=
  sourceDensity.value state position time < 0

end NumStability.Leveque02Tracer
