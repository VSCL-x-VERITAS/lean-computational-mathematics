/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.WaveSpeedParts

/-!
# LeVeque Chapter 4, equations (4.42)–(4.43): wave fluctuations

Each fluctuation is the finite sum of wave jumps weighted by the appropriate
signed propagation speed. Equation (4.43) is the notation change from the
expanded wave update; its derivation from REA is a separate source claim.
-/

namespace NumStability

/-- Left-going fluctuation from a single interface, the first line of
(4.42). -/
noncomputable def leveque04_negativeFluctuation
    {m : ℕ} (waveSpeed : Fin m → ℝ)
    (wave : Fin m → (Fin m → ℝ)) : Fin m → ℝ :=
  ∑ p, leveque04_negativeVelocity (waveSpeed p) • wave p

/-- Right-going fluctuation from a single interface, the second line of
(4.42). -/
noncomputable def leveque04_positiveFluctuation
    {m : ℕ} (waveSpeed : Fin m → ℝ)
    (wave : Fin m → (Fin m → ℝ)) : Fin m → ℝ :=
  ∑ p, leveque04_positiveVelocity (waveSpeed p) • wave p

/-- Equation (4.42) introduces notation for the two signed wave sums. -/
theorem leveque04_equation42
    {m : ℕ} (waveSpeed : Fin m → ℝ)
    (wave : Fin m → (Fin m → ℝ)) :
    leveque04_negativeFluctuation waveSpeed wave =
        ∑ p, leveque04_negativeVelocity (waveSpeed p) • wave p ∧
      leveque04_positiveFluctuation waveSpeed wave =
        ∑ p, leveque04_positiveVelocity (waveSpeed p) • wave p :=
  ⟨rfl, rfl⟩

/-- Equation (4.43) is equivalent to the expanded two-interface wave update:
the right-going waves enter from the left and left-going waves from the right. -/
theorem leveque04_equation43
    {m : ℕ} (timeStep cellWidth : ℝ)
    (oldState newState : Fin m → ℝ)
    (leftSpeed rightSpeed : Fin m → ℝ)
    (leftWave rightWave : Fin m → (Fin m → ℝ)) :
    (newState = oldState - (timeStep / cellWidth) •
      ((∑ p, leveque04_positiveVelocity (leftSpeed p) • leftWave p) +
       (∑ p, leveque04_negativeVelocity (rightSpeed p) • rightWave p))) ↔
      newState = oldState - (timeStep / cellWidth) •
        (leveque04_positiveFluctuation leftSpeed leftWave +
         leveque04_negativeFluctuation rightSpeed rightWave) :=
  Iff.rfl

end NumStability
