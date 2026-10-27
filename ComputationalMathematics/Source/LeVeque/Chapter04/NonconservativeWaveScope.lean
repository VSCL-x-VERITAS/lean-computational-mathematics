/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.VariableCoefficientConservationForm
import ComputationalMathematics.Source.LeVeque.Chapter04.UpwindInterpretations
import ComputationalMathematics.Source.LeVeque.Chapter04.GeneralWaveUpdate
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: wave updates beyond flux differencing

The variable-coefficient example from Chapter 1 has no local conservative
flux for the unchanged state. The signed-wave update still has a definition
for spatially and state-dependent speeds. Its consistency and convergence for
a chosen problem require separate analysis.
-/

namespace NumStability

/-- Direct wave-propagation update for a system, using incoming signed
Riemann waves at the two cell faces. No state-only physical flux is an
argument, so the same formula is available for nonconservative systems. -/
noncomputable def leveque04_directWavePropagationStep
    {m : ℕ} (scale : ℝ) (old : ℤ → (Fin m → ℝ))
    (waveSpeed : ℤ → Fin m → ℝ)
    (wave : ℤ → Fin m → (Fin m → ℝ)) (i : ℤ) : Fin m → ℝ :=
  old i - scale •
    (leveque04_positiveFluctuation (waveSpeed i) (wave i) +
      leveque04_negativeFluctuation (waveSpeed (i + 1)) (wave (i + 1)))

/-- In a conservative problem whose Riemann waves resolve the flux jump,
the direct wave step agrees with the selected flux-difference update. This
connects the flux-free generalization back to the Chapter 4 method. -/
theorem leveque04_directWavePropagationStep_eq_conservative
    {m : ℕ} (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (old : ℤ → (Fin m → ℝ))
    (waveSpeed : ℤ → Fin m → ℝ)
    (wave : ℤ → Fin m → (Fin m → ℝ))
    (hriemann : ∀ j, flux (old j) - flux (old (j - 1)) =
      ∑ p, waveSpeed j p • wave j p)
    (scale : ℝ) (i : ℤ) :
    conservativeFluxDifferenceUpdateInt scale old
        (fun j => leveque04_generalFluctuationFlux
          (fun k => flux (old k))
          (fun k => leveque04_negativeFluctuation (waveSpeed k) (wave k)) j) i =
      leveque04_directWavePropagationStep scale old waveSpeed wave i := by
  simpa only [leveque04_directWavePropagationStep,
    leveque04_positiveFluctuation, leveque04_negativeFluctuation] using
    leveque04_equation41 flux old waveSpeed wave hriemann scale i

/-- The signed-wave update with a speed evaluated at the current cell and
state. It uses neighboring waves directly and needs no physical flux
function. -/
noncomputable def leveque04_nonconservativeWaveStep
    (timeStep cellWidth : ℝ)
    (speed : ℤ → ℝ → ℝ) (cellAverage : ℤ → ℝ) (i : ℤ) : ℝ :=
  cellAverage i - timeStep / cellWidth *
    (leveque04_positiveVelocity (speed i (cellAverage i)) *
        leveque04_leftWaveJump cellAverage i +
      leveque04_negativeVelocity (speed i (cellAverage i)) *
        leveque04_rightWaveJump cellAverage i)

/-- For a uniform speed, the flux-free signed-wave formula coincides with
the already proved conservative upwind formula (4.35). -/
theorem leveque04_nonconservativeWaveStep_constantSpeed
    (timeStep cellWidth velocity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) :
    leveque04_nonconservativeWaveStep timeStep cellWidth
        (fun _ _ => velocity) cellAverage i =
      leveque04_signedUpwindStep timeStep cellWidth velocity
        cellAverage i := by
  rw [leveque04_equation35]
  rfl

/-- Direct wave updates preserve a constant state even when the supplied
speed varies with position and state. -/
theorem leveque04_nonconservativeWaveStep_constantState
    (timeStep cellWidth value : ℝ) (speed : ℤ → ℝ → ℝ) (i : ℤ) :
    leveque04_nonconservativeWaveStep timeStep cellWidth
        speed (fun _ => value) i = value := by
  simp [leveque04_nonconservativeWaveStep,
    leveque04_leftWaveJump, leveque04_rightWaveJump]

/-- At a cell with positive local speed, the direct wave update reuses the
upwind convex-combination theorem with that cell's speed. -/
theorem leveque04_nonconservativeWaveStep_localConvex
    (timeStep cellWidth : ℝ) (speed : ℤ → ℝ → ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ)
    (hvelocity : 0 < speed i (cellAverage i))
    (hcfl : IsLeveque04PositiveUpwindCFL timeStep cellWidth
      (speed i (cellAverage i))) :
    ∃ weight : ℝ, 0 ≤ weight ∧ weight ≤ 1 ∧
      leveque04_nonconservativeWaveStep timeStep cellWidth
          speed cellAverage i =
        weight * cellAverage (i - 1) + (1 - weight) * cellAverage i := by
  have heq : leveque04_nonconservativeWaveStep timeStep cellWidth
        speed cellAverage i =
      leveque04_positiveUpwindStep timeStep cellWidth
        (speed i (cellAverage i)) cellAverage i := by
    rw [leveque04_equation25 timeStep cellWidth
      (speed i (cellAverage i)) cellAverage i hvelocity]
    simp only [leveque04_nonconservativeWaveStep,
      leveque04_leftWaveJump, leveque04_rightWaveJump,
      leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_left hvelocity.le, min_eq_right hvelocity.le,
      zero_mul, add_zero]
    ring
  rw [heq]
  exact leveque04_upwindConvexCombination timeStep cellWidth
    (speed i (cellAverage i)) cellAverage i hvelocity hcfl

/-- Under the local positive-speed CFL bound, the variable-speed wave step
lies between its two incoming cell values. -/
theorem leveque04_nonconservativeWaveStep_localBounds
    (timeStep cellWidth : ℝ) (speed : ℤ → ℝ → ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) (lower upper : ℝ)
    (hvelocity : 0 < speed i (cellAverage i))
    (hcfl : IsLeveque04PositiveUpwindCFL timeStep cellWidth
      (speed i (cellAverage i)))
    (hleft : lower ≤ cellAverage (i - 1) ∧ cellAverage (i - 1) ≤ upper)
    (hcurrent : lower ≤ cellAverage i ∧ cellAverage i ≤ upper) :
    lower ≤ leveque04_nonconservativeWaveStep timeStep cellWidth
        speed cellAverage i ∧
      leveque04_nonconservativeWaveStep timeStep cellWidth
        speed cellAverage i ≤ upper := by
  obtain ⟨weight, hw0, hw1, hstep⟩ :=
    leveque04_nonconservativeWaveStep_localConvex
      timeStep cellWidth speed cellAverage i hvelocity hcfl
  rw [hstep]
  have hrest : 0 ≤ 1 - weight := by linarith
  have hloleft := mul_nonneg hw0 (sub_nonneg.mpr hleft.1)
  have hlocurrent := mul_nonneg hrest (sub_nonneg.mpr hcurrent.1)
  have hupleft := mul_nonneg hw0 (sub_nonneg.mpr hleft.2)
  have hupcurrent := mul_nonneg hrest (sub_nonneg.mpr hcurrent.2)
  constructor <;> nlinarith

/-- A smooth positive hyperbolic variable coefficient with no local flux
for the unchanged state is available from the existing Chapter 1 result;
the direct signed-wave step remains a well-defined local operation for its
sampled speeds. -/
theorem leveque04_nonconservative_variableCoefficient_witness :
    ∃ coefficient : ℝ → ℝ,
      ContDiff ℝ (⊤ : ℕ∞) coefficient ∧
      (∀ x, 0 < coefficient x) ∧
      (∀ x, IsRealHyperbolicMatrix (constantCoefficientScalarMatrix (coefficient x))) ∧
      ¬ ∃ flux : ℝ → ℝ → ℝ, RepresentsScalarTransportFlux coefficient flux :=
  leveque01_exists_hyperbolic_variableCoefficient_without_localFlux

end NumStability
