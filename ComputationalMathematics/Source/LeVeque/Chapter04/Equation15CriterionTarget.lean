/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.FluxLipschitzCondition
import Mathlib.Analysis.Normed.Group.Constructions

/-!
# Eq. (4.15): explicit radial flux criteria

The displayed requirement defines admissible fluxes; it is not automatic for
arbitrary numerical fluxes. We distinguish the unrestricted displayed bound
at a fixed reference, a single coefficient for all references, and the local
neighborhood version. The latter is not identified with the former. The
criterion characterizations retain actual quantitative consequences and
concrete membership and nonmembership examples.
-/

open Filter
open scoped Topology

namespace NumStability

/-- Fluxes satisfying the literal unrestricted radial bound at one reference. -/
def leveque04_radialFluxClassAt {E : Type*} [NormedAddCommGroup E]
    (physicalFlux : E → E) (reference : E) : Set (E → E → E) :=
  {numericalFlux | ∃ coefficient : ℝ, 0 ≤ coefficient ∧
    ∀ left right : E,
      ‖numericalFlux left right - physicalFlux reference‖ ≤
        coefficient * max ‖right - reference‖ ‖left - reference‖}

/-- The distinct criterion using one coefficient for every reference and pair. -/
def leveque04_uniformRadialFluxClass {E : Type*} [NormedAddCommGroup E]
    (physicalFlux : E → E) : Set (E → E → E) :=
  {numericalFlux | ∃ coefficient : ℝ, 0 ≤ coefficient ∧
    ∀ reference left right : E,
      ‖numericalFlux left right - physicalFlux reference‖ ≤
        coefficient * max ‖right - reference‖ ‖left - reference‖}

/-- Exact membership criteria, their quantitative consequences, and actual
admissibility/separation examples. The source's typical/design qualifier does
not assert membership for every numerical flux. -/
def Leveque04FluxCriterionTarget : Prop :=
  (∀ (m : ℕ), 0 < m →
    ∀ (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
      (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ))
      (reference : Fin m → ℝ),
      (numericalFlux ∈ leveque04_radialFluxClassAt physicalFlux reference ↔
        ∃ coefficient : ℝ, 0 ≤ coefficient ∧
          (∀ left right : Fin m → ℝ,
            ‖numericalFlux left right - physicalFlux reference‖ ≤
              coefficient * max ‖right - reference‖ ‖left - reference‖) ∧
          numericalFlux reference reference = physicalFlux reference ∧
          (∀ ε : ℝ, 0 < ε → 0 < ε / (coefficient + 1) ∧
            ∀ left right : Fin m → ℝ,
              ‖left - reference‖ < ε / (coefficient + 1) →
              ‖right - reference‖ < ε / (coefficient + 1) →
              ‖numericalFlux left right - physicalFlux reference‖ < ε) ∧
          Tendsto (fun p : (Fin m → ℝ) × (Fin m → ℝ) => numericalFlux p.1 p.2)
            (𝓝 (reference, reference)) (𝓝 (physicalFlux reference))) ∧
      (IsLeveque04FluxLipschitzAt physicalFlux numericalFlux reference ↔
        ∃ coefficient radius : ℝ, 0 ≤ coefficient ∧ 0 < radius ∧
          (∀ left right : Fin m → ℝ,
            ‖left - reference‖ < radius → ‖right - reference‖ < radius →
            ‖numericalFlux left right - physicalFlux reference‖ ≤
              coefficient * max ‖right - reference‖ ‖left - reference‖) ∧
          numericalFlux reference reference = physicalFlux reference ∧
          (∀ ε : ℝ, 0 < ε → 0 < min radius (ε / (coefficient + 1)) ∧
            ∀ left right : Fin m → ℝ,
              ‖left - reference‖ < min radius (ε / (coefficient + 1)) →
              ‖right - reference‖ < min radius (ε / (coefficient + 1)) →
              ‖numericalFlux left right - physicalFlux reference‖ < ε) ∧
          Tendsto (fun p : (Fin m → ℝ) × (Fin m → ℝ) => numericalFlux p.1 p.2)
            (𝓝 (reference, reference)) (𝓝 (physicalFlux reference))) ∧
      (numericalFlux ∈ leveque04_radialFluxClassAt physicalFlux reference →
        IsLeveque04FluxLipschitzAt physicalFlux numericalFlux reference)) ∧
  (∀ (physicalFlux : ℝ → ℝ) (numericalFlux : ℝ → ℝ → ℝ) (reference : ℝ),
      (numericalFlux ∈ leveque04_radialFluxClassAt physicalFlux reference ↔
        ∃ coefficient : ℝ, 0 ≤ coefficient ∧
          ∀ left right : ℝ,
            |numericalFlux left right - physicalFlux reference| ≤
              coefficient * max |right - reference| |left - reference|) ∧
      (IsLeveque04FluxLipschitzAt physicalFlux numericalFlux reference ↔
        ∃ coefficient radius : ℝ, 0 ≤ coefficient ∧ 0 < radius ∧
          ∀ left right : ℝ,
            |left - reference| < radius → |right - reference| < radius →
            |numericalFlux left right - physicalFlux reference| ≤
              coefficient * max |right - reference| |left - reference|)) ∧
  (∀ (m : ℕ), 0 < m →
    ∀ (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
      (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ)),
      (numericalFlux ∈ leveque04_uniformRadialFluxClass physicalFlux ↔
        ∃ coefficient : ℝ, 0 ≤ coefficient ∧
          ∀ reference left right : Fin m → ℝ,
            ‖numericalFlux left right - physicalFlux reference‖ ≤
              coefficient * max ‖right - reference‖ ‖left - reference‖) ∧
      (numericalFlux ∈ leveque04_uniformRadialFluxClass physicalFlux →
        (∀ reference, numericalFlux ∈ leveque04_radialFluxClassAt physicalFlux reference) ∧
        IsLeveque04ConsistentFlux physicalFlux numericalFlux ∧
        ∀ reference : Fin m → ℝ,
          ContinuousAt
            (fun p : (Fin m → ℝ) × (Fin m → ℝ) => numericalFlux p.1 p.2)
            (reference, reference))) ∧
  (∀ (m : ℕ), 0 < m →
    ∀ (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ)) (coefficient : ℝ),
      0 ≤ coefficient →
      (∀ left reference : Fin m → ℝ,
        ‖physicalFlux left - physicalFlux reference‖ ≤
          coefficient * ‖left - reference‖) →
      (fun left _right => physicalFlux left) ∈
        leveque04_uniformRadialFluxClass physicalFlux) ∧
  (∀ (m : ℕ), 0 < m →
    (fun (left _right : Fin m → ℝ) => left) ∈
      leveque04_uniformRadialFluxClass (fun state => state)) ∧
  (∀ constant : ℝ,
    (fun (_left _right : ℝ) => constant) ∈
      leveque04_uniformRadialFluxClass (fun _state : ℝ => constant)) ∧
  (∀ reference : ℝ,
    (fun (_left _right : ℝ) => (1 : ℝ)) ∉
      leveque04_radialFluxClassAt (fun _state : ℝ => 0) reference ∧
    ¬IsLeveque04FluxLipschitzAt (fun _state : ℝ => 0)
      (fun (_left _right : ℝ) => 1) reference) ∧
  (IsLeveque04LocallyLipschitzFlux (fun state : ℝ => state ^ 2)
      (fun (left _right : ℝ) => left ^ 2) ∧
    (fun (left _right : ℝ) => left ^ 2) ∉
      leveque04_radialFluxClassAt (fun state : ℝ => state ^ 2) 0)

end NumStability
