/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.MachBoundary

/-!
# Characteristic boundary coordinates and a linear left relation

Equations (3.37)–(3.38), printed page 59/raw PDF page 81.
-/

namespace NumStability

def leveque03_negativeSpeedCoordinates
    {n k : ℕ} (w : Fin (n + k) → ℝ) : Fin n → ℝ :=
  fun i => w (Fin.castAdd k i)

def leveque03_positiveSpeedCoordinates
    {n k : ℕ} (w : Fin (n + k) → ℝ) : Fin k → ℝ :=
  fun i => w (Fin.natAdd n i)

def leveque03_IsBoundarySpeedSplit
    {n k : ℕ} (speeds : Fin (n + k) → ℝ) : Prop :=
  (∀ i : Fin n, speeds (Fin.castAdd k i) < 0) ∧
    (∀ i : Fin k, 0 < speeds (Fin.natAdd n i))

theorem leveque03_characteristicBoundaryPartition
    {n k : ℕ} (w : Fin (n + k) → ℝ) :
    Fin.append (leveque03_negativeSpeedCoordinates w)
      (leveque03_positiveSpeedCoordinates w) = w := by
  exact Fin.append_castAdd_natAdd

theorem leveque03_characteristicBoundaryPartition_ordered
    {n k : ℕ} (speeds : Fin (n + k) → ℝ)
    (hsplit : leveque03_IsBoundarySpeedSplit speeds)
    (w : Fin (n + k) → ℝ) :
    Fin.append (leveque03_negativeSpeedCoordinates w)
      (leveque03_positiveSpeedCoordinates w) = w ∧
    (∀ i : Fin n, speeds (Fin.castAdd k i) < 0) ∧
    (∀ i : Fin k, 0 < speeds (Fin.natAdd n i)) := by
  exact ⟨leveque03_characteristicBoundaryPartition w, hsplit.1, hsplit.2⟩

def leveque03_IsLeftLinearBoundary
    {n k : ℕ} (w : ℝ → ℝ → (Fin (n + k) → ℝ))
    (left : ℝ) (B₁ : Matrix (Fin k) (Fin n) ℝ)
    (g₁ : ℝ → Fin k → ℝ) : Prop :=
  ∀ t,
    leveque03_positiveSpeedCoordinates (w left t) =
      B₁.mulVec (leveque03_negativeSpeedCoordinates (w left t)) + g₁ t

theorem leveque03_leftLinearBoundary_zero
    {n k : ℕ} (w : ℝ → ℝ → (Fin (n + k) → ℝ))
    (left : ℝ) (g₁ : ℝ → Fin k → ℝ) :
    leveque03_IsLeftLinearBoundary w left 0 g₁ ↔
      ∀ t, leveque03_positiveSpeedCoordinates (w left t) = g₁ t := by
  simp [leveque03_IsLeftLinearBoundary]

end NumStability
