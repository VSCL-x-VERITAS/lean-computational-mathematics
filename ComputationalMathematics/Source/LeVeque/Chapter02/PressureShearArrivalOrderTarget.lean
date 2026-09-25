/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# LeVeque Chapter 2: arrival order of pressure and shear waves

The waves start together and traverse the same positive distance. This
conditional claim assumes the compressional speed exceeds the shear speed.
-/

namespace NumStability.Leveque02Tracer

/-- A faster P-wave launched with an S-wave reaches a distant observer first. -/
def pressureShearArrivalOrderTarget : Prop :=
  ∀ (compressionSpeed shearSpeed distance launchTime : ℝ),
    0 < distance → 0 < shearSpeed → shearSpeed < compressionSpeed →
      launchTime + distance / compressionSpeed <
        launchTime + distance / shearSpeed

end NumStability.Leveque02Tracer
