/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarUpwindUpdate
import ComputationalMathematics.Source.Eymard.Chapter01.PrintedUpwindSchemeTarget

/-!
# Upwind Stability Target

The owner-selected balanced signed-net-flux CFL maximum principle.
This transparent proposition includes the local convex-combination identity,
the interval implication, induction for a supplied update family, the actual
explicit recursion, and its canonical geometric realization. The assumptions
are on the actual discrete initial values.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

open MeasureTheory
open NumStability.FiniteVolume
open NumStability.FiniteVolume.Planar
open scoped BigOperators

/-- The owner-selected balanced signed-net-flux CFL maximum principle.
This transparent proposition includes the local convex-combination identity,
the interval implication, induction for a supplied update family, the actual
explicit recursion, and its canonical geometric realization. The assumptions
are on the actual discrete initial values. -/
def upwindStabilityTarget : Prop :=
  (∀ (Face : Type) [DecidableEq Face] (faces : Finset Face)
      (coefficient neighbourState : Face → ℝ) (mass step localState A B : ℝ),
    0 < mass → 0 < step →
    (∑ σ ∈ faces, coefficient σ) = 0 →
    step * (∑ σ ∈ faces, max (coefficient σ) 0) ≤ mass →
      (∀ σ ∈ faces,
        scalarUpwindFlux (coefficient σ) localState (neighbourState σ) =
          max (coefficient σ) 0 * localState -
            max (-coefficient σ) 0 * neighbourState σ) ∧
      0 ≤ upwindSelfWeight faces coefficient mass step ∧
      (∀ σ ∈ faces, 0 ≤ upwindInflowWeight (coefficient σ) mass step) ∧
      (upwindSelfWeight faces coefficient mass step +
        ∑ σ ∈ faces, upwindInflowWeight (coefficient σ) mass step) = 1 ∧
      (localState - (step / mass) *
        ∑ σ ∈ faces, scalarUpwindFlux (coefficient σ) localState (neighbourState σ)) =
          (1 - (step / mass) * ∑ σ ∈ faces, max (coefficient σ) 0) * localState +
            (step / mass) * ∑ σ ∈ faces, max (-coefficient σ) 0 * neighbourState σ ∧
      ((A ≤ localState ∧ localState ≤ B) →
      (∀ σ ∈ faces, A ≤ neighbourState σ ∧ neighbourState σ ≤ B) →
        A ≤ localState - (step / mass) *
          ∑ σ ∈ faces, scalarUpwindFlux (coefficient σ) localState (neighbourState σ) ∧
        localState - (step / mass) *
          (∑ σ ∈ faces, scalarUpwindFlux (coefficient σ) localState (neighbourState σ)) ≤ B)) ∧
  (∀ (Cell Face : Type) [DecidableEq Face]
      (faces : Cell → Finset Face) (neighbour : Cell → Face → Cell)
      (mass : Cell → ℝ) (step : ℝ) (coefficient : ℕ → Cell → Face → ℝ)
      (u : ℕ → Cell → ℝ) (A B : ℝ),
    (∀ K, 0 < mass K) → 0 < step →
    (∀ n K, (∑ σ ∈ faces K, coefficient n K σ) = 0) →
    (∀ n K, step * (∑ σ ∈ faces K, max (coefficient n K σ) 0) ≤ mass K) →
    (∀ n K, u (n + 1) K = signedUpwindStep faces neighbour mass step (coefficient n) (u n) K) →
    (∀ K, A ≤ u 0 K ∧ u 0 K ≤ B) →
      ∀ n K, A ≤ u n K ∧ u n K ≤ B) ∧
  (∀ (Cell Face : Type) [DecidableEq Face]
      (faces : Cell → Finset Face) (neighbour : Cell → Face → Cell)
      (mass : Cell → ℝ) (step : ℝ) (coefficient : ℕ → Cell → Face → ℝ)
      (initial : Cell → ℝ) (A B : ℝ),
    (∀ K, 0 < mass K) → 0 < step →
    (∀ n K, (∑ σ ∈ faces K, coefficient n K σ) = 0) →
    (∀ n K, step * (∑ σ ∈ faces K, max (coefficient n K σ) 0) ≤ mass K) →
    (∀ K, A ≤ initial K ∧ initial K ≤ B) →
      let u := signedUpwindTrajectory faces neighbour mass step coefficient initial
      (∀ K, u 0 K = initial K) ∧
      (∀ n K, u (n + 1) K = signedUpwindStep faces neighbour mass step (coefficient n) (u n) K) ∧
      (∀ n K, (mass K / step) * (u (n + 1) K - u n K) +
        ∑ σ ∈ faces K, scalarUpwindFlux (coefficient n K σ) (u n K) (u n (neighbour K σ)) = 0) ∧
      ∀ n K, A ≤ u n K ∧ u n K ≤ B) ∧
  (∀ (Cell Face : Type) [DecidableEq Face]
      (M : Mesh Cell Face) (v : SpatialVelocity) (step : PositiveStep)
      (initial : Cell → ℝ) (A B : ℝ),
    (∀ K, 0 < cellArea M K) →
    (∀ n K, (∑ σ ∈ M.faces K,
      integratedNormalVelocity v step n (M.segment σ) (M.normal K σ)) = 0) →
    (∀ n K, step.val * (∑ σ ∈ M.faces K,
      max (integratedNormalVelocity v step n (M.segment σ) (M.normal K σ)) 0) ≤ cellArea M K) →
    (∀ K, A ≤ initial K ∧ initial K ≤ B) →
      let u := planarUpwindTrajectory M v step initial
      (∀ K, u 0 K = initial K) ∧
      (∀ n K, u (n + 1) K = u n K - (step.val / cellArea M K) *
        ∑ σ ∈ M.faces K, upwindFlux M v step u n K σ) ∧
      (∀ n K, (cellArea M K / step.val) * (u (n + 1) K - u n K) +
        ∑ σ ∈ M.faces K, upwindFlux M v step u n K σ = 0) ∧
      ∀ n K, A ≤ u n K ∧ u n K ≤ B) ∧
  (∀ (Cell Face : Type) [DecidableEq Face]
      (M : Mesh Cell Face) (v : SpatialVelocity) (datum : TransportInitialDatum)
      (step : PositiveStep) (A B : ℝ),
    (∀ K, 0 < cellArea M K) →
    (∀ n K, (∑ σ ∈ M.faces K,
      integratedNormalVelocity v step n (M.segment σ) (M.normal K σ)) = 0) →
    (∀ n K, step.val * (∑ σ ∈ M.faces K,
      max (integratedNormalVelocity v step n (M.segment σ) (M.normal K σ)) 0) ≤ cellArea M K) →
    (∀ K, A ≤ (∫ x in (M.polygon K).region, datum.representative x) ∧
      (∫ x in (M.polygon K).region, datum.representative x) ≤ B) →
      let u := planarUpwindTrajectory M v step
        (fun K => ∫ x in (M.polygon K).region, datum.representative x)
      IsPrintedUpwindScheme M v datum step u ∧
      ∀ n K, A ≤ u n K ∧ u n K ≤ B)

end NumStability.Eymard.Chapter01
