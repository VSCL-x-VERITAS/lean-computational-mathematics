/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.FiniteCellReconstruction
import ComputationalMathematics.Analysis.FiniteVolume.OpenClosureCover
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Notation.Indicator
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Convex.Measure
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.MeasureTheory.Measure.Restrict
import Mathlib.Topology.Closure

/-!
# Cell Reconstruction Target

Finite measurable-cell realization plus the finite open convex-cell
null-skeleton bridge. The final clause makes the owner-selected finite, disjoint, open convex
source-form applicability explicit. Full admissible-mesh encoding is not claimed.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

open scoped BigOperators
open MeasureTheory

namespace NumStability.Eymard.Chapter01

/-- Finite measurable-cell realization plus the finite open convex-cell
null-skeleton bridge. The final clause makes the owner-selected finite, disjoint, open convex
source-form applicability explicit. Full admissible-mesh encoding is not claimed. -/
def cellReconstructionTarget : Prop :=
  (∀ (d : ℕ), (d = 1 ∨ d = 2 ∨ d = 3) →
    ∀ (n : ℕ) (Ω : Set (EuclideanSpace ℝ (Fin d)))
      (K : Fin n → Set (EuclideanSpace ℝ (Fin d))),
      MeasurableSet Ω →
      (∀ i, MeasurableSet (K i) ∧ K i ⊆ Ω) →
      (∀ i j, i ≠ j → Disjoint (K i) (K j)) →
      ∀ U : Fin n → ℝ,
        (∀ i x,
          (x ∈ K i → (K i).indicator (fun _ => (1 : ℝ)) x = 1) ∧
          (x ∉ K i → (K i).indicator (fun _ => (1 : ℝ)) x = 0)) ∧
        (∀ i x, x ∈ K i → finiteCellReconstruction K U x = U i) ∧
        (∀ x, x ∉ finiteCellUnion K → finiteCellReconstruction K U x = 0) ∧
        (∀ g : EuclideanSpace ℝ (Fin d) → ℝ,
          (∀ x, x ∈ finiteCellUnion K →
            finiteCellSkeletonExtension K U g x = finiteCellReconstruction K U x) ∧
          (∀ x, x ∉ finiteCellUnion K → finiteCellSkeletonExtension K U g x = g x)) ∧
        (∀ u : EuclideanSpace ℝ (Fin d) → ℝ,
          (∀ i x, x ∈ K i → u x = U i) →
          (∀ x, x ∈ finiteCellUnion K → finiteCellReconstruction K U x = u x) ∧
          (volume (Ω \ finiteCellUnion K) = 0 →
            finiteCellReconstruction K U =ᵐ[volume.restrict Ω] u))) ∧
  (∀ (d : ℕ), (d = 1 ∨ d = 2 ∨ d = 3) →
    ∀ (n : ℕ) (Ω : Set (EuclideanSpace ℝ (Fin d)))
      (K : Fin n → Set (EuclideanSpace ℝ (Fin d))),
      NumStability.FiniteVolume.IsOpenClosureCover Ω (Set.range K) →
      (∀ i, Convex ℝ (K i)) →
      (∀ i, volume (frontier (K i)) = 0) ∧
      volume (Ω \ finiteCellUnion K) = 0) ∧
  (∀ (d : ℕ), (d = 2 ∨ d = 3) →
    ∀ (n : ℕ) (Ω : Set (EuclideanSpace ℝ (Fin d)))
      (K : Fin n → Set (EuclideanSpace ℝ (Fin d))),
      IsOpen Ω →
      (∀ i, IsOpen (K i) ∧ K i ⊆ Ω ∧ Convex ℝ (K i)) →
      (∀ i j, i ≠ j → Disjoint (K i) (K j)) →
      closure (finiteCellUnion K) = closure Ω →
      NumStability.FiniteVolume.IsOpenClosureCover Ω (Set.range K) ∧
      (∀ i, MeasurableSet (K i)) ∧
      (∀ i, volume (frontier (K i)) = 0) ∧
      volume (Ω \ finiteCellUnion K) = 0 ∧
      (∀ (U : Fin n → ℝ) (u : EuclideanSpace ℝ (Fin d) → ℝ),
        (∀ i x, x ∈ K i → u x = U i) →
        (∀ i x, x ∈ K i → finiteCellReconstruction K U x = U i) ∧
        finiteCellReconstruction K U =ᵐ[volume.restrict Ω] u))

end NumStability.Eymard.Chapter01
