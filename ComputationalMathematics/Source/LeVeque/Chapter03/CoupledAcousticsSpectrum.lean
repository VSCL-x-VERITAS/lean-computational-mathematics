/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.CoupledAcoustics
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticWaveStrengths

/-!
# Spectrum and waves of the coupled acoustic-tracer system

Equations (3.34)–(3.36) and Figure 3.7, printed page 58/raw PDF page 80.
The source prints `r¹` twice in (3.35); the third vector's checked
eigenpair is recorded separately from a formal refutation of that label.
-/

namespace NumStability

/-- The three speeds of equation (3.34). -/
def leveque03_coupledAcousticsSpeeds
    (backgroundVelocity soundSpeed : ℝ) : Fin 3 → ℝ :=
  ![backgroundVelocity - soundSpeed,
    backgroundVelocity,
    backgroundVelocity + soundSpeed]

/-- The three displayed vectors, with the third assigned its corrected
family index. -/
def leveque03_coupledAcousticsEigenvectors
    (density soundSpeed : ℝ) : Fin 3 → (Fin 3 → ℝ) :=
  ![![-acousticImpedance density soundSpeed, 1, 0],
    ![0, 0, 1],
    ![acousticImpedance density soundSpeed, 1, 0]]

/-- Each displayed vector is an eigenvector of the coupled matrix at its
corresponding speed. -/
theorem leveque03_coupledAcoustics_eigenpairs
    (bulkModulus density backgroundVelocity soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hbulk : bulkModulus = density * soundSpeed ^ 2) :
    ∀ p : Fin 3,
      (leveque03_coupledAcousticsMatrix bulkModulus density backgroundVelocity).mulVec
        (leveque03_coupledAcousticsEigenvectors density soundSpeed p) =
      leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed p •
        leveque03_coupledAcousticsEigenvectors density soundSpeed p := by
  intro p
  subst bulkModulus
  funext i
  fin_cases p <;> fin_cases i <;>
    simp [leveque03_coupledAcousticsMatrix,
      leveque03_coupledAcousticsEigenvectors,
      leveque03_coupledAcousticsSpeeds, acousticImpedance,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;>
    field_simp [hdensity] <;>
    ring

/-- Positive sound speed orders the three families strictly. -/
theorem leveque03_coupledAcousticsSpeeds_ordered
    (backgroundVelocity soundSpeed : ℝ) (hsound : 0 < soundSpeed) :
    StrictMono (leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed) := by
  intro i j hij
  fin_cases i <;> fin_cases j <;>
    simp [leveque03_coupledAcousticsSpeeds] at hij ⊢ <;>
    linarith

/-- The first and third vectors printed with the same `r¹` label differ
when impedance is positive. -/
theorem leveque03_coupledAcoustics_printedThirdLabel_inconsistent
    (density soundSpeed : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) :
    leveque03_coupledAcousticsEigenvectors density soundSpeed 0 ≠
      leveque03_coupledAcousticsEigenvectors density soundSpeed 2 := by
  intro heq
  have h := congrFun heq 0
  simp [leveque03_coupledAcousticsEigenvectors] at h
  linarith

/-- The first vector cannot carry the third speed in a positive-sound-speed
medium. -/
theorem leveque03_coupledAcoustics_firstVector_notThirdSpeed
    (bulkModulus density backgroundVelocity soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hbulk : bulkModulus = density * soundSpeed ^ 2)
    (hsound : 0 < soundSpeed) :
    (leveque03_coupledAcousticsMatrix bulkModulus density backgroundVelocity).mulVec
        (leveque03_coupledAcousticsEigenvectors density soundSpeed 0) ≠
      leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed 2 •
        leveque03_coupledAcousticsEigenvectors density soundSpeed 0 := by
  intro hthird
  have hfirst := leveque03_coupledAcoustics_eigenpairs bulkModulus density
    backgroundVelocity soundSpeed hdensity hbulk 0
  rw [hfirst] at hthird
  have h := congrFun hthird 1
  simp [leveque03_coupledAcousticsEigenvectors,
    leveque03_coupledAcousticsSpeeds] at h
  linarith

/-- The acoustic strengths flank the independent tracer jump. -/
noncomputable def leveque03_coupledAcousticsWaveStrengths
    (density soundSpeed deltaPressure deltaVelocity deltaTracer : ℝ) :
    Fin 3 → ℝ :=
  ![acousticWaveStrengths density soundSpeed deltaPressure deltaVelocity 0,
    deltaTracer,
    acousticWaveStrengths density soundSpeed deltaPressure deltaVelocity 1]

/-- Equation (3.36): explicit components of all three strengths. -/
theorem leveque03_coupledAcousticsWaveStrengths_formula
    (density soundSpeed deltaPressure deltaVelocity deltaTracer : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) :
    leveque03_coupledAcousticsWaveStrengths density soundSpeed
        deltaPressure deltaVelocity deltaTracer =
      ![(-deltaPressure + acousticImpedance density soundSpeed * deltaVelocity) /
          (2 * acousticImpedance density soundSpeed),
        deltaTracer,
        (deltaPressure + acousticImpedance density soundSpeed * deltaVelocity) /
          (2 * acousticImpedance density soundSpeed)] := by
  unfold leveque03_coupledAcousticsWaveStrengths
  rw [Leveque02Tracer.acousticWaveStrengthsFormula density soundSpeed
    deltaPressure deltaVelocity hZ]
  rfl

/-- These three strengths reconstruct every pressure-velocity-tracer jump. -/
theorem leveque03_coupledAcousticsWaveStrengths_reconstruct
    (density soundSpeed deltaPressure deltaVelocity deltaTracer : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) :
    ∑ p : Fin 3,
      leveque03_coupledAcousticsWaveStrengths density soundSpeed
        deltaPressure deltaVelocity deltaTracer p •
        leveque03_coupledAcousticsEigenvectors density soundSpeed p =
      ![deltaPressure, deltaVelocity, deltaTracer] := by
  rw [leveque03_coupledAcousticsWaveStrengths_formula density soundSpeed
    deltaPressure deltaVelocity deltaTracer hZ]
  have hne : acousticImpedance density soundSpeed ≠ 0 := ne_of_gt hZ
  funext i
  fin_cases i <;>
    simp [leveque03_coupledAcousticsEigenvectors, Fin.sum_univ_succ] <;>
    field_simp [hne] <;>
    ring

/-- The acoustic families' strengths and directions do not involve the
passive tracer. -/
theorem leveque03_coupledAcoustics_acousticWaves_independentOfTracer
    (density soundSpeed deltaPressure deltaVelocity deltaTracer₁ deltaTracer₂ : ℝ) :
    leveque03_coupledAcousticsWaveStrengths density soundSpeed
        deltaPressure deltaVelocity deltaTracer₁ 0 =
      leveque03_coupledAcousticsWaveStrengths density soundSpeed
        deltaPressure deltaVelocity deltaTracer₂ 0 ∧
    leveque03_coupledAcousticsWaveStrengths density soundSpeed
        deltaPressure deltaVelocity deltaTracer₁ 2 =
      leveque03_coupledAcousticsWaveStrengths density soundSpeed
        deltaPressure deltaVelocity deltaTracer₂ 2 ∧
    leveque03_coupledAcousticsEigenvectors density soundSpeed 0 2 = 0 ∧
    leveque03_coupledAcousticsEigenvectors density soundSpeed 2 2 = 0 := by
  simp [leveque03_coupledAcousticsWaveStrengths,
    leveque03_coupledAcousticsEigenvectors]

/-- The second wave changes only tracer and travels at the fluid speed. -/
theorem leveque03_coupledAcoustics_contactWave
    (density soundSpeed backgroundVelocity deltaPressure deltaVelocity
      deltaTracer : ℝ) :
    leveque03_coupledAcousticsWaveStrengths density soundSpeed
        deltaPressure deltaVelocity deltaTracer 1 •
        leveque03_coupledAcousticsEigenvectors density soundSpeed 1 =
      ![0, 0, deltaTracer] ∧
    leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed 1 =
      backgroundVelocity := by
  simp [leveque03_coupledAcousticsWaveStrengths,
    leveque03_coupledAcousticsEigenvectors,
    leveque03_coupledAcousticsSpeeds]

/-- Figure 3.7: the speed signs in positive subsonic and supersonic flow. -/
theorem leveque03_coupledAcoustics_figure37
    (backgroundVelocity soundSpeed : ℝ)
    (hbackground : 0 < backgroundVelocity) (hsound : 0 < soundSpeed) :
    (backgroundVelocity < soundSpeed →
      leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed 0 < 0 ∧
      0 < leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed 1 ∧
      0 < leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed 2) ∧
    (soundSpeed < backgroundVelocity →
      0 < leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed 0 ∧
      0 < leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed 1 ∧
      0 < leveque03_coupledAcousticsSpeeds backgroundVelocity soundSpeed 2) := by
  simp [leveque03_coupledAcousticsSpeeds]
  constructor
  · intro h
    refine ⟨h, hbackground, ?_⟩
    linarith
  · intro h
    refine ⟨h, hbackground, ?_⟩
    linarith

end NumStability
