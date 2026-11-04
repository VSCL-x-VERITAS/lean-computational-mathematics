/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Topology.Instances.Real.Lemmas

/-!
# Intrinsic bounds on actual Burgers shocks and local rarefaction patches

These predicates refer only to the spatial traces and local values of a field.
They use no wave labels, initial faces, minimizing representation or correctness
callback. Constant-state characteristic velocities are not measured: shocks
have strictly distinct downward traces, and fan patches have slope `1 / t`.
-/

namespace NumStability.Burgers

open Set Filter
open scoped Topology

/-- Actual left and right spatial limits at the same physical point and time. -/
def SpatialTracePair (U : ℝ → ℝ → ℝ) (x t left right : ℝ) : Prop :=
  Tendsto (fun y => U y t) (𝓝[<] x) (𝓝 left) ∧
    Tendsto (fun y => U y t) (𝓝[>] x) (𝓝 right)

/-- A genuine local affine rarefaction patch at the unrestarted physical time. -/
def LocalRarefactionPatch (U : ℝ → ℝ → ℝ) (x t : ℝ) : Prop :=
  ∃ ε : ℝ, 0 < ε ∧ ∃ center : ℝ,
    ∀ y ∈ Ioo (x - ε) (x + ε), U y t = (y - center) / t

/-- Bounds every actual downward shock trace speed and every actual local fan
value at all positive times through the horizon, including its endpoint. -/
def IntrinsicWaveBound (U : ℝ → ℝ → ℝ) (horizon bound : ℝ) : Prop :=
  0 ≤ bound ∧ ∀ t ∈ Ioc (0 : ℝ) horizon,
    (∀ x left right : ℝ, SpatialTracePair U x t left right → right < left →
      |(left + right) / 2| ≤ bound) ∧
    (∀ x : ℝ, LocalRarefactionPatch U x t → |U x t| ≤ bound)

/-- One-sided traces are unique; field representatives at the jump itself
need not equal either trace in this intrinsic statement. -/
theorem SpatialTracePair.unique {U : ℝ → ℝ → ℝ} {x t l r l' r' : ℝ}
    (h : SpatialTracePair U x t l r) (h' : SpatialTracePair U x t l' r') :
    l = l' ∧ r = r' :=
  ⟨tendsto_nhds_unique h.1 h'.1, tendsto_nhds_unique h.2 h'.2⟩

end NumStability.Burgers
