/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation15CriterionTarget
import Mathlib.Data.Fintype.Card

/-!
# Eq. (4.15) on a prescribed state range

The state range is a parameter fixed before qualification of a numerical flux.
One coefficient controls all admitted reference and input states. No range is
chosen existentially to make a flux qualify, and no particular range is
attributed to the book. The unrestricted case is retained by taking `univ`.
For an arbitrary range the paired limit is relative to its product, with no
openness, boundedness, convexity, sign or compactness restriction.
-/

open Filter
open scoped Topology

namespace NumStability

/-- The literal uniform radial requirement on an already prescribed state range. -/
def leveque04_radialFluxClassOn {E : Type*} [NormedAddCommGroup E]
    (states : Set E) (physicalFlux : E → E) : Set (E → E → E) :=
  {numericalFlux | ∃ coefficient : ℝ, 0 ≤ coefficient ∧
    ∀ reference ∈ states, ∀ left ∈ states, ∀ right ∈ states,
      ‖numericalFlux left right - physicalFlux reference‖ ≤
        coefficient * max ‖right - reference‖ ‖left - reference‖}

/-- The fixed-domain criterion itself, genuine quantitative consequences and
actual qualifying/nonqualifying fluxes. Local variants are secondary mathematics,
not substituted for the primary uniform requirement on the prescribed range. -/
def Leveque04FluxDomainCriterionTarget : Prop :=
  (∀ (m : ℕ), 0 < m →
    ∀ (states : Set (Fin m → ℝ))
      (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
      (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ)),
      numericalFlux ∈ leveque04_radialFluxClassOn states physicalFlux ↔
        ∃ coefficient : ℝ, 0 ≤ coefficient ∧
          (∀ reference ∈ states, ∀ left ∈ states, ∀ right ∈ states,
            ‖numericalFlux left right - physicalFlux reference‖ ≤
              coefficient * max ‖right - reference‖ ‖left - reference‖) ∧
          (∀ reference ∈ states,
            numericalFlux reference reference = physicalFlux reference) ∧
          (∀ reference ∈ states, ∀ ε : ℝ, 0 < ε →
            0 < ε / (coefficient + 1) ∧
            ∀ left ∈ states, ∀ right ∈ states,
              ‖left - reference‖ < ε / (coefficient + 1) →
              ‖right - reference‖ < ε / (coefficient + 1) →
              ‖numericalFlux left right - physicalFlux reference‖ < ε) ∧
          (∀ reference ∈ states,
            Tendsto (fun p : (Fin m → ℝ) × (Fin m → ℝ) => numericalFlux p.1 p.2)
              (𝓝[states ×ˢ states] (reference, reference)) (𝓝 (physicalFlux reference)))) ∧
  (∀ (states : Set ℝ) (physicalFlux : ℝ → ℝ)
      (numericalFlux : ℝ → ℝ → ℝ),
      numericalFlux ∈ leveque04_radialFluxClassOn states physicalFlux ↔
        ∃ coefficient : ℝ, 0 ≤ coefficient ∧
          (∀ reference ∈ states, ∀ left ∈ states, ∀ right ∈ states,
            |numericalFlux left right - physicalFlux reference| ≤
              coefficient * max |right - reference| |left - reference|) ∧
          (∀ reference ∈ states,
            numericalFlux reference reference = physicalFlux reference) ∧
          (∀ reference ∈ states, ∀ ε : ℝ, 0 < ε →
            0 < ε / (coefficient + 1) ∧
            ∀ left ∈ states, ∀ right ∈ states,
              |left - reference| < ε / (coefficient + 1) →
              |right - reference| < ε / (coefficient + 1) →
              |numericalFlux left right - physicalFlux reference| < ε) ∧
          (∀ reference ∈ states,
            Tendsto (fun p : ℝ × ℝ => numericalFlux p.1 p.2)
              (𝓝[states ×ˢ states] (reference, reference)) (𝓝 (physicalFlux reference)))) ∧
  (∀ (m : ℕ), 0 < m →
    ∀ (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
      (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ)),
      (numericalFlux ∈ leveque04_radialFluxClassOn Set.univ physicalFlux ↔
        numericalFlux ∈ leveque04_uniformRadialFluxClass physicalFlux) ∧
      (numericalFlux ∈ leveque04_radialFluxClassOn Set.univ physicalFlux →
        IsLeveque04ConsistentFlux physicalFlux numericalFlux ∧
        ∀ reference : Fin m → ℝ,
          numericalFlux ∈ leveque04_radialFluxClassAt physicalFlux reference ∧
          IsLeveque04FluxLipschitzAt physicalFlux numericalFlux reference ∧
          ContinuousAt
            (fun p : (Fin m → ℝ) × (Fin m → ℝ) => numericalFlux p.1 p.2)
            (reference, reference))) ∧
  (∀ (m : ℕ), 0 < m →
    ∀ (states : Set (Fin m → ℝ))
      (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ)) (coefficient : ℝ),
      0 ≤ coefficient →
      (∀ left ∈ states, ∀ reference ∈ states,
        ‖physicalFlux left - physicalFlux reference‖ ≤
          coefficient * ‖left - reference‖) →
      (fun left _right => physicalFlux left) ∈
        leveque04_radialFluxClassOn states physicalFlux) ∧
  (∀ (m : ℕ), 0 < m → ∀ states : Set (Fin m → ℝ),
    (fun (left _right : Fin m → ℝ) => left) ∈
      leveque04_radialFluxClassOn states (fun state => state)) ∧
  (∀ (m : ℕ), 0 < m →
    ∀ (states : Set (Fin m → ℝ)) (constant : Fin m → ℝ),
      (fun (_left _right : Fin m → ℝ) => constant) ∈
        leveque04_radialFluxClassOn states (fun _state => constant)) ∧
  (∀ states : Set ℝ, states.Nonempty →
    (fun (_left _right : ℝ) => (1 : ℝ)) ∉
      leveque04_radialFluxClassOn states (fun _state : ℝ => 0)) ∧
  (IsLeveque04LocallyLipschitzFlux (fun state : ℝ => state ^ 2)
      (fun (left _right : ℝ) => left ^ 2) ∧
    (fun (left _right : ℝ) => left ^ 2) ∉
      leveque04_radialFluxClassAt (fun state : ℝ => state ^ 2) 0 ∧
    (fun (left _right : ℝ) => left ^ 2) ∉
      leveque04_radialFluxClassOn Set.univ (fun state : ℝ => state ^ 2))

end NumStability
