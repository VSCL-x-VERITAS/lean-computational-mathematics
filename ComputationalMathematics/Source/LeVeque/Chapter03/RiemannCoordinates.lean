/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.WaveSuperposition
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData

/-!
# Characteristic coordinates of linear Riemann data

Equations (3.15)–(3.17), printed page 53/raw PDF page 75. The constant left
and right states decompose into eigenvector strengths; each coordinate is a
two-state step transported at its own characteristic speed. Both printed step
formulas leave the value on their jump ray unspecified.
-/

namespace NumStability

/-- Equation (3.15): decompose both Riemann states in the fixed right-
eigenvector basis. -/
theorem leveque03_riemannStates_decompose
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) :
    left = ∑ p, (leveque03_characteristicVariables eigenbasis left p) • eigenbasis p ∧
    right = ∑ p, (leveque03_characteristicVariables eigenbasis right p) • eigenbasis p := by
  exact ⟨leveque03_eigenvectorSuperposition eigenbasis (fun _ _ => left) 0 0,
    leveque03_eigenvectorSuperposition eigenbasis (fun _ _ => right) 0 0⟩

/-- Equation (3.16): the pth characteristic coordinate has the two printed
initial values on the strict half-lines. -/
theorem leveque03_riemannCharacteristicData
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right) (p : Fin m) :
    IsRiemannData
      (fun x => leveque03_initialCharacteristicVariables eigenbasis initialState x p)
      (leveque03_characteristicVariables eigenbasis left p)
      (leveque03_characteristicVariables eigenbasis right p) := by
  constructor
  · intro x hx
    simp only [leveque03_initialCharacteristicVariables, hdata.1 x hx]
  · intro x hx
    simp only [leveque03_initialCharacteristicVariables, hdata.2 x hx]

/-- Equation (3.17): the pth characteristic coordinate transports its
two-state initial profile at speed `speeds p`. -/
theorem leveque03_riemannCharacteristicPropagation
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (initialState : ℝ → (Fin m → ℝ)) (left right : Fin m → ℝ)
    (hdata : IsRiemannData initialState left right) (p : Fin m) :
    (∀ x t, x - speeds p * t < 0 →
      leveque03_initialCharacteristicVariables eigenbasis initialState
        (x - speeds p * t) p =
        leveque03_characteristicVariables eigenbasis left p) ∧
    (∀ x t, 0 < x - speeds p * t →
      leveque03_initialCharacteristicVariables eigenbasis initialState
        (x - speeds p * t) p =
        leveque03_characteristicVariables eigenbasis right p) := by
  have hstep := leveque03_riemannCharacteristicData eigenbasis initialState left right hdata p
  exact ⟨fun x t hx => hstep.1 _ hx, fun x t hx => hstep.2 _ hx⟩

end NumStability
