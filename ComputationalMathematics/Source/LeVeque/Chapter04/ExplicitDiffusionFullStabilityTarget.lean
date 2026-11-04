/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionStep
import Mathlib.Analysis.Normed.Lp.lpSpace
import Mathlib.Analysis.Normed.Lp.PiLp
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Tactic

/-!
# Standard-norm quadratic necessity for actual explicit diffusion

Proof-free target for necessary refinement under actual all-data stability.
The primary clauses are necessary refinement bounds. Sharp max-norm power
stability and contraction are separate existing mathematics.
-/

namespace NumStability

open WithLp

noncomputable section

/-- Physical grid weight. At infinity the displayed formula equals one. -/
def explicitDiffusionPhysicalWeight (p : ENNReal) (width : ℝ) : ℝ :=
  width ^ (1 / p.toReal)

/-- Actual whole-line iterates, with honest lp membership and all-data bounds.
No norm is assigned to a nonmember and no solver is supplied as an argument. -/
-- Preserve the source hypotheses and the existing public interface.
@[nolint unusedArguments]
def IsExplicitDiffusionLpStableThrough (p : ENNReal) [Fact (1 ≤ p)]
    (horizon bound timeStep width : ℝ) (diffusivity : ℤ → ℝ) : Prop :=
  ∀ before reference : lp (fun _ : ℤ => ℝ) p, ∀ n : ℕ,
    (n : ℝ) * timeStep ≤ horizon →
    let difference : ℤ → ℝ := fun i =>
      ((leveque04_explicitDiffusionStep timeStep width diffusivity)^[n]
        (before : ℤ → ℝ)) i -
      ((leveque04_explicitDiffusionStep timeStep width diffusivity)^[n]
        (reference : ℤ → ℝ)) i
    ∃ hmem : Memℓp difference p,
      explicitDiffusionPhysicalWeight p width *
          ‖(⟨difference, hmem⟩ : lp (fun _ : ℤ => ℝ) p)‖ ≤
        bound * (explicitDiffusionPhysicalWeight p width * ‖before - reference‖)

/-- Shared finite-grid interface flux computed from the actual Fick law.
Only the two exterior ghost values are boundary parameters. -/
def explicitDiffusionFiniteFaceFlux {cells : ℕ} (width : ℝ)
    (diffusivity : Fin (cells + 1) → ℝ)
    (leftGhost rightGhost : (Fin cells → ℝ) → ℝ)
    (before : Fin cells → ℝ) (face : Fin (cells + 1)) : ℝ :=
  let left := if h : face.val = 0 then leftGhost before
    else before ⟨face.val - 1, by have := face.isLt; omega⟩
  let right := if h : face.val < cells then before ⟨face.val, h⟩
    else rightGhost before
  Leveque02Tracer.fickFlux (diffusivity face) ((right - left) / width)

/-- The finite method is the existing conservative flux-difference update.
There is no arbitrary whole-update callback or assumed interior identity. -/
def explicitDiffusionFiniteStep {cells : ℕ} (timeStep width : ℝ)
    (diffusivity : Fin (cells + 1) → ℝ)
    (leftGhost rightGhost : (Fin cells → ℝ) → ℝ)
    (before : Fin cells → ℝ) (i : Fin cells) : ℝ :=
  conservativeFluxDifferenceUpdate (timeStep / width)
    (fun k => if h : k < cells then before ⟨k, h⟩ else 0)
    (fun k => if h : k < cells + 1 then
      explicitDiffusionFiniteFaceFlux width diffusivity leftGhost rightGhost before ⟨k, h⟩
      else 0) i.val

/-- A face on either side of an interior output row. -/
def explicitDiffusionFiniteWitnessFace {cells : ℕ}
    (diffusivity : Fin (cells + 1) → ℝ) (i : Fin cells) (right : Bool) : ℝ :=
  if right then diffusivity ⟨i.val + 1, Nat.succ_lt_succ i.isLt⟩
  else diffusivity ⟨i.val, Nat.lt_succ_of_lt i.isLt⟩

/-- Full finite-vector pair stability of the constructed boundary method.
Arbitrary boundary closures are not asserted stable. Their actual iterates
must satisfy this premise, and the necessary local estimate uses an interior
row with neighboring free active inputs. -/
-- Preserve the source hypotheses and the existing public interface.
@[nolint unusedArguments]
def IsExplicitDiffusionFiniteLpStableThrough (p : ENNReal) [Fact (1 ≤ p)]
    {cells : ℕ} (horizon bound timeStep width : ℝ)
    (diffusivity : Fin (cells + 1) → ℝ)
    (leftGhost rightGhost : (Fin cells → ℝ) → ℝ) : Prop :=
  ∀ before reference : Fin cells → ℝ, ∀ n : ℕ,
    (n : ℝ) * timeStep ≤ horizon →
      explicitDiffusionPhysicalWeight p width *
        ‖(toLp p
          (((explicitDiffusionFiniteStep timeStep width diffusivity leftGhost rightGhost)^[n]
            before) -
           ((explicitDiffusionFiniteStep timeStep width diffusivity leftGhost rightGhost)^[n]
            reference)) : PiLp p (fun _ : Fin cells => ℝ))‖ ≤
      bound * (explicitDiffusionPhysicalWeight p width *
        ‖(toLp p (before - reference) : PiLp p (fun _ : Fin cells => ℝ))‖)

/-- The primary source claim is only eventual quadratic refinement necessity,
for every standard norm and both constructed domain families. One-step exact
coefficient estimates, constant-case corollaries, zero identities and physical
weight facts and the explicit choice `K = (bound + 1) / lower` are reusable
proof support, not additional parent conclusions. Constant
4.12 is included by `diffusivity j i = coefficient`, `face j = 0` and
`lower = |coefficient|`; no separate stronger fixed-mesh claim is selected. -/
def leveque04_explicitDiffusionFullStability_target : Prop :=
  (∀ (p : ENNReal) [Fact (1 ≤ p)] (horizon bound lower : ℝ)
      (timeStep width : ℕ → ℝ) (diffusivity : ℕ → ℤ → ℝ)
      (face : ℕ → ℤ) (start : ℕ),
    0 < horizon → 0 ≤ bound → 0 < lower →
    (∀ j, 0 < width j) → (∀ j, 0 < timeStep j) →
    Filter.Tendsto width Filter.atTop (nhds 0) →
    Filter.Tendsto timeStep Filter.atTop (nhds 0) →
    (∀ j ≥ start, lower ≤ |diffusivity j (face j)|) →
    (∀ j ≥ start, IsExplicitDiffusionLpStableThrough p horizon bound
      (timeStep j) (width j) (diffusivity j)) →
    ∃ K : ℝ, 0 ≤ K ∧ ∃ cutoff : ℕ, ∀ j ≥ cutoff,
      timeStep j ≤ K * width j ^ 2) ∧
  (∀ (p : ENNReal) [Fact (1 ≤ p)] (horizon bound lower : ℝ)
      (timeStep width : ℕ → ℝ) (cells : ℕ → ℕ)
      (diffusivity : ∀ j, Fin (cells j + 1) → ℝ)
      (leftGhost rightGhost : ∀ j, (Fin (cells j) → ℝ) → ℝ)
      (i : ∀ j, Fin (cells j)) (right : ℕ → Bool) (start : ℕ),
    0 < horizon → 0 ≤ bound → 0 < lower →
    (∀ j, 0 < width j) → (∀ j, 0 < timeStep j) →
    Filter.Tendsto width Filter.atTop (nhds 0) →
    Filter.Tendsto timeStep Filter.atTop (nhds 0) →
    (∀ j ≥ start, 1 ≤ (i j).val ∧ (i j).val + 1 < cells j) →
    (∀ j ≥ start, lower ≤
      |explicitDiffusionFiniteWitnessFace (diffusivity j) (i j) (right j)|) →
    (∀ j ≥ start, IsExplicitDiffusionFiniteLpStableThrough p horizon bound
      (timeStep j) (width j) (diffusivity j) (leftGhost j) (rightGhost j)) →
    ∃ K : ℝ, 0 ≤ K ∧ ∃ cutoff : ℕ, ∀ j ≥ cutoff,
      timeStep j ≤ K * width j ^ 2)

end

end NumStability
