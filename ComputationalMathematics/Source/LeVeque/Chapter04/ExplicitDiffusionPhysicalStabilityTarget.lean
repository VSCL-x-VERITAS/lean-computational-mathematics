/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AffineFaceSampling
import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionFullStabilityTarget

/-!
# Quadratic refinement necessity for sampled physical conductivity

Proof-free target for the explicitly selected physical interpretation of the
source's diffusion stability statement. A fixed continuous conductivity is
positive somewhere and the actual face coefficients approximate it locally
uniformly. Finite grids must cover a positive patch with an interior margin.
This is a disclosed user-selected qualification, not uniquely printed intent.

The old all-pairs norms and constructed operators are reused without assuming
their unproved generic necessity target. The only primary conclusions are the
two eventual quadratic refinement bounds. Sample lower bounds and lattice
geometry are separate support, not hypotheses of the physical target.
-/

open Filter
open scoped Topology

namespace NumStability

/-- Necessary quadratic time-step refinement in every standard physical
discrete norm, for the actual whole-line and finite shared-flux methods.

The all-pairs stability criterion is the premise itself; no homogeneous
equivalence is asserted for arbitrary nonlinear finite ghost rules. No
stability guarantee is asserted for those ghost rules. Finite coverage is an
explicit sufficient geometric qualification, not a claim about a domain that
misses the positive physical region. Zero/mesh-vanishing conductivity remains
outside this nondegenerate interpretation. -/
def leveque04_explicitDiffusionPhysicalStability_target : Prop :=
  (∀ (p : ENNReal) [Fact (1 ≤ p)] (β : ℝ → ℝ)
      (horizon bound : ℝ) (timeStep width origin : ℕ → ℝ)
      (diffusivity : ℕ → ℤ → ℝ),
    Continuous β → (∃ x : ℝ, 0 < β x) →
    0 < horizon → 0 ≤ bound →
    (∀ j, 0 < width j) → (∀ j, 0 < timeStep j) →
    Tendsto width atTop (nhds 0) → Tendsto timeStep atTop (nhds 0) →
    LocallyUniformFaceSamples β
      (fun (j : ℕ) (k : ℤ) => origin j + (k : ℝ) * width j) diffusivity →
    (∀ᶠ j in atTop, IsExplicitDiffusionLpStableThrough p horizon bound
      (timeStep j) (width j) (diffusivity j)) →
    ∃ K : ℝ, 0 ≤ K ∧ ∃ cutoff : ℕ, ∀ j ≥ cutoff,
      timeStep j ≤ K * width j ^ 2) ∧
  (∀ (p : ENNReal) [Fact (1 ≤ p)] (β : ℝ → ℝ)
      (horizon bound : ℝ) (timeStep width origin : ℕ → ℝ)
      (cells : ℕ → ℕ) (diffusivity : ∀ j, Fin (cells j + 1) → ℝ)
      (leftGhost rightGhost : ∀ j, (Fin (cells j) → ℝ) → ℝ),
    Continuous β →
    (∃ x R : ℝ, 0 < β x ∧ 0 < R ∧ ∀ᶠ j in atTop,
      origin j ≤ x - R ∧ x + R ≤ origin j + (cells j : ℝ) * width j) →
    0 < horizon → 0 ≤ bound →
    (∀ j, 0 < width j) → (∀ j, 0 < timeStep j) →
    Tendsto width atTop (nhds 0) → Tendsto timeStep atTop (nhds 0) →
    LocallyUniformFaceSamples β
      (fun (j : ℕ) (k : Fin (cells j + 1)) => origin j + (k.val : ℝ) * width j) diffusivity →
    (∀ᶠ j in atTop, IsExplicitDiffusionFiniteLpStableThrough p horizon bound
      (timeStep j) (width j) (diffusivity j) (leftGhost j) (rightGhost j)) →
    ∃ K : ℝ, 0 ≤ K ∧ ∃ cutoff : ℕ, ∀ j ≥ cutoff,
      timeStep j ≤ K * width j ^ 2)

end NumStability
