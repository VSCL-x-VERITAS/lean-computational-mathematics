/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.MachBoundary
import ComputationalMathematics.Source.LeVeque.Chapter03.CoupledAcousticsSpectrum

/-!
# Zero-speed characteristics at boundaries

Exercise 3.8, printed page 63/raw PDF page 85. A zero-speed family retains
its initial value at a fixed spatial point, so it requires no incoming datum
at either boundary.
-/

namespace NumStability

/-- The multiplicity of the zero eigenvalue in a finite speed family. -/
noncomputable def leveque03_zeroSpeedCount
    {m : ℕ} (speeds : Fin m → ℝ) : ℕ :=
  (Finset.univ.filter fun p => speeds p = 0).card

/-- Positive, negative, and zero characteristic families partition the system. -/
theorem leveque03_boundaryCount_withZeroSpeeds
    {m : ℕ} (speeds : Fin m → ℝ) :
    leveque03_leftInflowCount speeds +
      leveque03_rightInflowCount speeds +
      leveque03_zeroSpeedCount speeds = m := by
  classical
  let S : Finset (Fin m) := Finset.univ.filter fun p => ¬ 0 < speeds p
  have hfirst : leveque03_leftInflowCount speeds + S.card = m := by
    simpa [leveque03_leftInflowCount, S] using
      (Finset.card_filter_add_card_filter_not
        (s := (Finset.univ : Finset (Fin m))) (p := fun p => 0 < speeds p))
  have hneg : (S.filter fun p => speeds p < 0) =
      (Finset.univ.filter fun p : Fin m => speeds p < 0) := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, S]
    constructor
    · exact fun h => h.2
    · intro h
      exact ⟨not_lt.mpr h.le, h⟩
  have hzero : (S.filter fun p => ¬ speeds p < 0) =
      (Finset.univ.filter fun p : Fin m => speeds p = 0) := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, S]
    constructor
    · rintro ⟨hnpos, hnneg⟩
      exact le_antisymm (le_of_not_gt hnpos) (le_of_not_gt hnneg)
    · intro hz
      simp [hz]
  have hsecond : leveque03_rightInflowCount speeds +
      leveque03_zeroSpeedCount speeds = S.card := by
    simpa [leveque03_rightInflowCount, leveque03_zeroSpeedCount,
      ← hneg, ← hzero] using
      (Finset.card_filter_add_card_filter_not
        (s := S) (p := fun p => speeds p < 0))
  omega

/-- A zero-speed characteristic is stationary. -/
theorem leveque03_zeroSpeed_stationary
    {E : Type*} (profile : ℝ → E) (x t : ℝ) :
    travelingWave profile 0 x t = profile x := by
  simp [travelingWave]

/-- With zero background velocity, the coupled system has one incoming
family at each boundary and one stationary family. -/
theorem leveque03_coupledAcoustics_zeroBackground_boundaryCounts
    (soundSpeed : ℝ) (hsound : 0 < soundSpeed) :
    leveque03_leftInflowCount (leveque03_coupledAcousticsSpeeds 0 soundSpeed) = 1 ∧
    leveque03_rightInflowCount (leveque03_coupledAcousticsSpeeds 0 soundSpeed) = 1 ∧
    leveque03_zeroSpeedCount (leveque03_coupledAcousticsSpeeds 0 soundSpeed) = 1 := by
  classical
  have huniv : (Finset.univ : Finset (Fin 3)) = {0, 1, 2} := by decide
  simp [leveque03_leftInflowCount, leveque03_rightInflowCount,
    leveque03_zeroSpeedCount, leveque03_coupledAcousticsSpeeds,
    huniv, Finset.filter_insert, Finset.filter_singleton,
    hsound, not_lt.mpr hsound.le, ne_of_gt hsound]

end NumStability
