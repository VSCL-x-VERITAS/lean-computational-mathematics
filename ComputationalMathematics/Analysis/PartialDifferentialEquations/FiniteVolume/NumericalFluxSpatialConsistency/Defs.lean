/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Analysis.Calculus.ContDiff.Defs

/-!
# Uniform numerical-flux spatial consistency: definitions

Proof-free definitions for consistent C2 physical/numerical fluxes, spatial
reference budgets and the normalized vector-valued cell-mean estimate.
-/

namespace NumStability.NumericalFluxSpatialConsistency

/-- Vector states with the existing finite-function norm. -/
abbrev State (d : ℕ) := Fin d → ℝ

/-- Uniform-grid cell means, using `oneDimensionalCellAverage`. -/
noncomputable def cellMean {d : ℕ} (q : ℝ → ℝ → State d)
    (h b t : ℝ) (j : ℤ) : State d :=
  NumStability.oneDimensionalCellAverage (fun x => q x t)
    (b + (j : ℝ) * h) (b + ((j + 1 : ℤ) : ℝ) * h)

/-- Consistent C2 fluxes and uniform derivative budgets on a compact convex state set. -/
def FluxHypotheses (d : ℕ) (K V : Set (State d))
    (f : State d → State d) (g : (State d × State d) → State d)
    (G1 G2 : ℝ) : Prop :=
  0 < d ∧ K.Nonempty ∧ IsCompact K ∧ Convex ℝ K ∧ IsOpen V ∧ K ⊆ V ∧
  ContDiffOn ℝ 2 f V ∧ ContDiffOn ℝ 2 g (V ×ˢ V) ∧
  (∀ z ∈ V, g (z, z) = f z) ∧ 0 ≤ G1 ∧ 0 ≤ G2 ∧
  (∀ z ∈ K ×ˢ K, ‖fderiv ℝ g z‖ ≤ G1 ∧
    ‖fderiv ℝ (fderiv ℝ g) z‖ ≤ G2)

/-- Uniform spatial C2 reference budgets on a fixed slab; no evolution equation is assumed. -/
def ReferenceHypotheses {d : ℕ} (K : Set (State d))
    (H Q1 Q2 : ℝ) (q : ℝ → ℝ → State d) : Prop :=
  ∀ t ∈ Set.Icc 0 H,
    ContDiff ℝ 2 (fun x => q x t) ∧
    (∀ x, q x t ∈ K ∧ ‖deriv (fun y => q y t) x‖ ≤ Q1 ∧
      ‖deriv (deriv (fun y => q y t)) x‖ ≤ Q2)

/-- The uniform spatial flux-divergence estimate with its explicit constant. -/
def SpatialEstimate : Prop :=
  ∀ (d : ℕ) (K V : Set (State d))
    (f : State d → State d) (g : (State d × State d) → State d)
    (G1 G2 Q1 Q2 H : ℝ),
    FluxHypotheses d K V f g G1 G2 →
    0 ≤ H → 0 ≤ Q1 → 0 ≤ Q2 →
    ∀ q : ℝ → ℝ → State d, ReferenceHypotheses K H Q1 Q2 q →
    ∀ h : ℝ, 0 < h → h ≤ 1 → ∀ (b : ℝ) (j : ℤ) (t : ℝ),
    t ∈ Set.Icc 0 H →
    IntervalIntegrable (fun x => q x t) MeasureTheory.volume
      (b + (j : ℝ) * h) (b + ((j + 1 : ℤ) : ℝ) * h) ∧
    cellMean q h b t j ∈ K ∧
    ‖h⁻¹ • (g (cellMean q h b t j, cellMean q h b t (j + 1)) -
        g (cellMean q h b t (j - 1), cellMean q h b t j)) -
      h⁻¹ • (f (q (b + ((j + 1 : ℤ) : ℝ) * h) t) -
        f (q (b + (j : ℝ) * h) t))‖ ≤
      (G2 * Q1 ^ 2 + G1 * Q2) * h

end NumStability.NumericalFluxSpatialConsistency
