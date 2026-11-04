/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation15DomainCriterionTarget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RadialFluxControl
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# The radial flux criterion on a prescribed state range

The defining quantitative bound yields consistency and an explicit uniform
diagonal modulus. The examples distinguish qualification from arbitrary-flux
admissibility and distinguish local radial control from an unrestricted bound.
-/

open Filter
open scoped Topology

namespace NumStability

private theorem radialFluxClassOn_characterization
    {E : Type*} [NormedAddCommGroup E] (states : Set E)
    (physicalFlux : E → E) (numericalFlux : E → E → E) :
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
          Tendsto (fun p : E × E => numericalFlux p.1 p.2)
            (𝓝[states ×ˢ states] (reference, reference)) (𝓝 (physicalFlux reference))) := by
  constructor
  · rintro ⟨coefficient, hcoefficient, hbound⟩
    exact ⟨coefficient, hcoefficient, hbound,
      fun _ href => radialFluxBound_consistent hbound href,
      fun _ href _ hε => radialFluxBound_modulus hcoefficient hbound href hε,
      fun _ href => radialFluxBound_tendsto hcoefficient hbound href⟩
  · rintro ⟨coefficient, hcoefficient, hbound, _⟩
    exact ⟨coefficient, hcoefficient, hbound⟩

private theorem square_left_locally_radial :
    IsLeveque04LocallyLipschitzFlux (fun state : ℝ => state ^ 2)
      (fun (left _right : ℝ) => left ^ 2) := by
  intro reference
  refine ⟨2 * |reference| + 1, 1, by positivity, zero_lt_one, ?_⟩
  intro left right hleft _hright
  simp only [Real.norm_eq_abs] at hleft ⊢
  have hsum : |left + reference| ≤ 2 * |reference| + 1 := by
    calc
      |left + reference| = |(left - reference) + (reference + reference)| := by
        congr 1
        ring
      _ ≤ |left - reference| + |reference + reference| := abs_add_le _ _
      _ ≤ 1 + (|reference| + |reference|) :=
        add_le_add hleft.le (abs_add_le _ _)
      _ = 2 * |reference| + 1 := by ring
  calc
    |left ^ 2 - reference ^ 2| = |left - reference| * |left + reference| := by
      rw [← abs_mul]
      congr 1
      ring
    _ ≤ |left - reference| * (2 * |reference| + 1) :=
      mul_le_mul_of_nonneg_left hsum (abs_nonneg _)
    _ = (2 * |reference| + 1) * |left - reference| := mul_comm _ _
    _ ≤ (2 * |reference| + 1) * max |left - reference| |right - reference| :=
      mul_le_mul_of_nonneg_left (le_max_left _ _) (by positivity)

private theorem square_left_not_globally_radial :
    (fun (left _right : ℝ) => left ^ 2) ∉
      leveque04_radialFluxClassAt (fun state : ℝ => state ^ 2) 0 := by
  rintro ⟨coefficient, hcoefficient, hbound⟩
  have hpositive : 0 ≤ coefficient + 1 := by linarith
  have h := hbound (coefficient + 1) 0
  simp only [Real.norm_eq_abs, zero_pow (by decide : 2 ≠ 0), sub_zero,
    abs_zero, abs_of_nonneg (sq_nonneg (coefficient + 1)), abs_of_nonneg hpositive,
    max_eq_right hpositive] at h
  nlinarith

/-- The whole prescribed-domain criterion, its quantitative consequences and
qualifying and nonqualifying examples. -/
theorem leveque04_fluxDomainCriterion : Leveque04FluxDomainCriterionTarget := by
  unfold Leveque04FluxDomainCriterionTarget
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro m _hm states physicalFlux numericalFlux
    exact radialFluxClassOn_characterization states physicalFlux numericalFlux
  · intro states physicalFlux numericalFlux
    simpa only [Real.norm_eq_abs] using
      radialFluxClassOn_characterization states physicalFlux numericalFlux
  · intro m _hm physicalFlux numericalFlux
    constructor
    · simp only [leveque04_radialFluxClassOn, leveque04_uniformRadialFluxClass,
        Set.mem_setOf_eq, Set.mem_univ, forall_const]
    · rintro ⟨coefficient, hcoefficient, hbound⟩
      have hlocal (reference : Fin m → ℝ) :
          IsLeveque04FluxLipschitzAt physicalFlux numericalFlux reference := by
        refine ⟨coefficient, 1, hcoefficient, zero_lt_one, ?_⟩
        intro left right _hleft _hright
        simpa only [max_comm] using
          hbound reference (Set.mem_univ _) left (Set.mem_univ _) right (Set.mem_univ _)
      refine ⟨fun reference => (hlocal reference).consistent, ?_⟩
      intro reference
      refine ⟨⟨coefficient, hcoefficient, ?_⟩, hlocal reference, ?_⟩
      · intro left right
        exact hbound reference (Set.mem_univ _) left (Set.mem_univ _) right (Set.mem_univ _)
      · change Tendsto (fun p => numericalFlux p.1 p.2)
          (𝓝 (reference, reference)) (𝓝 (numericalFlux reference reference))
        rw [(hlocal reference).consistent]
        exact (hlocal reference).tendsto_diagonal
  · intro m _hm states physicalFlux coefficient hcoefficient hphysical
    refine ⟨coefficient, hcoefficient, ?_⟩
    intro reference href left hleft right _hright
    exact (hphysical left hleft reference href).trans
      (mul_le_mul_of_nonneg_left (le_max_right _ _) hcoefficient)
  · intro m _hm states
    refine ⟨1, zero_le_one, ?_⟩
    intro reference _href left _hleft right _hright
    simpa only [one_mul] using (le_max_right ‖right - reference‖ ‖left - reference‖)
  · intro m _hm states constant
    refine ⟨0, le_refl 0, ?_⟩
    intro reference _href left _hleft right _hright
    simp
  · intro states hnonempty
    obtain ⟨reference, href⟩ := hnonempty
    rintro ⟨coefficient, _hcoefficient, hbound⟩
    have h := hbound reference href reference href reference href
    norm_num [Real.norm_eq_abs] at h
    exact (one_ne_zero : (1 : ℝ) ≠ 0) h
  · refine ⟨square_left_locally_radial, square_left_not_globally_radial, ?_⟩
    rintro ⟨coefficient, hcoefficient, hbound⟩
    apply square_left_not_globally_radial
    exact ⟨coefficient, hcoefficient,
      fun left right => hbound 0 (Set.mem_univ _) left (Set.mem_univ _) right (Set.mem_univ _)⟩

end NumStability
