/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.InnerProductSpace.DissipativeCrankNicolson
import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonDiffusion
import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionStability
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Combinatorics.SimpleGraph.LapMatrix
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4: the Crank–Nicolson energy step

The unconditional stability assertion after (4.13) rests on the dissipation
of the spatial diffusion operator. This identity isolates the time-stepping
argument without imposing a restriction on the time step. A separate spatial
summation-by-parts argument is needed for a particular grid and boundary
condition.
-/

namespace NumStability

open scoped InnerProductSpace
open Matrix

/-- A Crank–Nicolson step for a dissipative spatial operator contracts the
Hilbert norm for every nonnegative time step. -/
theorem leveque04_crankNicolson_dissipative_contracts
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (spatial : E →ₗ[ℝ] E) (before after : E) (timeStep : ℝ)
    (htime : 0 ≤ timeStep)
    (hdissipative : ∀ x, ⟪spatial x, x⟫_ℝ ≤ 0)
    (hstep : after - before =
      (timeStep / 2) • spatial (after + before)) :
    ‖after‖ ≤ ‖before‖  :=
  dissipative_crankNicolson_contracts spatial before after timeStep
    htime hdissipative hstep

/-- The two-cell periodic diffusion stencil, centered across the old and new
time levels. This is the constant-diffusivity form of (4.13). -/
def IsLeveque04PeriodicCrankNicolsonStep
    (ratio : ℝ) (before after : Fin 2 → ℝ) : Prop :=
  ∀ i, after i = before i + ratio / 2 *
    ((before (i - 1) - 2 * before i + before (i + 1)) +
      (after (i - 1) - 2 * after i + after (i + 1)))

/-- On the alternating two-cell mode, the implicit step has the exact
amplification factor `(1 - 2r)/(1 + 2r)`. -/
theorem leveque04_periodicCrankNicolson_alternating
    (ratio amplitude : ℝ) (hratio : 0 ≤ ratio) :
    IsLeveque04PeriodicCrankNicolsonStep ratio
      (leveque04_alternatingMode amplitude)
      (leveque04_alternatingMode
        ((1 - 2 * ratio) / (1 + 2 * ratio) * amplitude)) := by
  have hdenom : 1 + 2 * ratio ≠ 0 := by linarith
  intro i
  fin_cases i <;>
    norm_num [IsLeveque04PeriodicCrankNicolsonStep,
      leveque04_alternatingMode, Fin.add_def, Fin.sub_def] <;>
    field_simp <;> ring

/-- The alternating-mode amplification is bounded by one for every
nonnegative diffusion ratio, without a mesh time-step restriction. -/
theorem leveque04_periodicCrankNicolson_alternating_amplification
    (ratio : ℝ) (hratio : 0 ≤ ratio) :
    |(1 - 2 * ratio) / (1 + 2 * ratio)| ≤ 1 := by
  have hdenom : 0 < 1 + 2 * ratio := by linarith
  rw [abs_le]
  constructor
  · rw [le_div_iff₀ hdenom]
    linarith
  · rw [div_le_iff₀ hdenom]
    linarith

/-- A Crank–Nicolson diffusion step on a finite graph contracts the sum of
squared cell values. The graph Laplacian supplies the spatial dissipation,
so the time step has no upper bound. -/
theorem leveque04_crankNicolson_graph_energy
    {V : Type*} [Fintype V] [DecidableEq V]
    (graph : SimpleGraph V) [DecidableRel graph.Adj]
    (before after : V → ℝ) (timeStep : ℝ) (htime : 0 ≤ timeStep)
    (hstep : ∀ i, after i - before i = -(timeStep / 2) *
      ((graph.lapMatrix ℝ) *ᵥ (after + before)) i) :
    (∑ i, after i ^ 2) ≤ ∑ i, before i ^ 2 := by
  exact posSemidef_crankNicolson_sum_sq_le (graph.lapMatrix ℝ)
    (graph.posSemidef_lapMatrix ℝ) before after timeStep htime hstep

end NumStability
