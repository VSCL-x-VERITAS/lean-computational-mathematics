/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.BoundaryPartition
import ComputationalMathematics.Source.LeVeque.Chapter03.CharacteristicCoordinates

/-!
# Periodic boundary conditions for a linear hyperbolic system

Equations (3.41) and (3.42), printed page 61/raw PDF page 83. The same
fixed eigenbasis is used at both ends of the spatial interval.
-/

namespace NumStability

/-- The periodic boundary condition (3.41) identifies the full state at both
ends of the interval at every nonnegative boundary time. -/
def leveque03_IsPeriodicBoundary
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ)) (a b : ℝ) : Prop :=
  ∀ t, 0 ≤ t → q a t = q b t

/-- Equation (3.42): periodic state data are exactly the paired incoming and
outgoing characteristic data at opposite ends. -/
theorem leveque03_periodicBoundary_characteristic
    {n k : ℕ} (eigenbasis : Module.Basis (Fin (n + k)) ℝ (Fin (n + k) → ℝ))
    (q : ℝ → ℝ → (Fin (n + k) → ℝ)) (a b : ℝ) :
    leveque03_IsPeriodicBoundary q a b ↔
      (∀ t, 0 ≤ t →
        leveque03_positiveSpeedCoordinates
            (leveque03_characteristicVariables eigenbasis (q a t)) =
          leveque03_positiveSpeedCoordinates
            (leveque03_characteristicVariables eigenbasis (q b t))) ∧
      (∀ t, 0 ≤ t →
        leveque03_negativeSpeedCoordinates
            (leveque03_characteristicVariables eigenbasis (q b t)) =
          leveque03_negativeSpeedCoordinates
            (leveque03_characteristicVariables eigenbasis (q a t))) := by
  constructor
  · intro h
    exact ⟨fun t ht => by rw [h t ht], fun t ht => by rw [h t ht]⟩
  · rintro ⟨hpos, hneg⟩ t ht
    have hw : leveque03_characteristicVariables eigenbasis (q a t) =
        leveque03_characteristicVariables eigenbasis (q b t) := by
      rw [← leveque03_characteristicBoundaryPartition
        (leveque03_characteristicVariables eigenbasis (q a t)),
        ← leveque03_characteristicBoundaryPartition
          (leveque03_characteristicVariables eigenbasis (q b t))]
      congr 1
      · exact (hneg t ht).symm
      · exact hpos t ht
    have ha : leveque03_characteristicVariables eigenbasis (q a t) =
        eigenbasis.equivFun (q a t) := by
      simpa only [leveque03_characteristicVariables] using
        (leveque03_characteristicCoordinates eigenbasis (q a t))
    have hb : leveque03_characteristicVariables eigenbasis (q b t) =
        eigenbasis.equivFun (q b t) := by
      simpa only [leveque03_characteristicVariables] using
        (leveque03_characteristicCoordinates eigenbasis (q b t))
    exact eigenbasis.equivFun.injective (ha ▸ hb ▸ hw)

/-- The source's incoming/outgoing reading of (3.42), under its
noncharacteristic ordering of negative followed by positive speeds. -/
theorem leveque03_periodicBoundary_characteristicSplit
    {n k : ℕ} (eigenbasis : Module.Basis (Fin (n + k)) ℝ (Fin (n + k) → ℝ))
    (speeds : Fin (n + k) → ℝ)
    (_hsplit : leveque03_IsBoundarySpeedSplit speeds)
    (q : ℝ → ℝ → (Fin (n + k) → ℝ)) (a b : ℝ) :
    leveque03_IsPeriodicBoundary q a b ↔
      (∀ t, 0 ≤ t →
        leveque03_positiveSpeedCoordinates
            (leveque03_characteristicVariables eigenbasis (q a t)) =
          leveque03_positiveSpeedCoordinates
            (leveque03_characteristicVariables eigenbasis (q b t))) ∧
      (∀ t, 0 ≤ t →
        leveque03_negativeSpeedCoordinates
            (leveque03_characteristicVariables eigenbasis (q b t)) =
          leveque03_negativeSpeedCoordinates
            (leveque03_characteristicVariables eigenbasis (q a t))) :=
  leveque03_periodicBoundary_characteristic eigenbasis q a b

end NumStability
