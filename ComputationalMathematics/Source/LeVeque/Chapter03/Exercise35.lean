/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.Exercise34

/-!
# Exercise 3.5: reflected pressure-pulse foundation

Printed page 62/raw PDF page 84. Images of the initial unit pulse are
reflected across the walls at `x=0` and `x=4`; the image pattern has period 8.
-/

namespace NumStability

open MeasureTheory

/-- The pressure pulse and all of its even, period-eight reflected images. -/
noncomputable def leveque03_exercise35ReflectedPulse (x : ℝ) : ℝ :=
  by
    classical
    exact if ∃ k : ℤ,
        (1 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ 2) ∨
        (-2 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ -1)
      then 1 else 0

theorem leveque03_exercise35ReflectedPulse_periodic (x : ℝ) :
    leveque03_exercise35ReflectedPulse (x + 8) =
      leveque03_exercise35ReflectedPulse x := by
  unfold leveque03_exercise35ReflectedPulse
  congr 1
  apply propext
  constructor
  · rintro ⟨k, h⟩
    refine ⟨k - 1, ?_⟩
    have heq : x + 8 - 8 * (k : ℝ) = x - 8 * ((k - 1 : ℤ) : ℝ) := by
      push_cast
      ring
    simpa only [heq] using h
  · rintro ⟨k, h⟩
    refine ⟨k + 1, ?_⟩
    have heq : x - 8 * (k : ℝ) = x + 8 - 8 * ((k + 1 : ℤ) : ℝ) := by
      push_cast
      ring
    simpa only [← heq] using h

theorem leveque03_exercise35ReflectedPulse_even (x : ℝ) :
    leveque03_exercise35ReflectedPulse (-x) =
      leveque03_exercise35ReflectedPulse x := by
  have hflip (y : ℝ) :
      (∃ k : ℤ,
        (1 ≤ y - 8 * (k : ℝ) ∧ y - 8 * (k : ℝ) ≤ 2) ∨
        (-2 ≤ y - 8 * (k : ℝ) ∧ y - 8 * (k : ℝ) ≤ -1)) →
      (∃ k : ℤ,
        (1 ≤ -y - 8 * (k : ℝ) ∧ -y - 8 * (k : ℝ) ≤ 2) ∨
        (-2 ≤ -y - 8 * (k : ℝ) ∧ -y - 8 * (k : ℝ) ≤ -1)) := by
    rintro ⟨k, h⟩
    refine ⟨-k, ?_⟩
    have heq : -y - 8 * ((-k : ℤ) : ℝ) = -(y - 8 * (k : ℝ)) := by
      push_cast
      ring
    rcases h with hpos | hneg
    · right
      rw [heq]
      constructor <;> linarith [hpos.1, hpos.2]
    · left
      rw [heq]
      constructor <;> linarith [hneg.1, hneg.2]
  unfold leveque03_exercise35ReflectedPulse
  congr 1
  apply propext
  constructor
  · intro h
    simpa only [neg_neg] using hflip (-x) h
  · exact hflip x

theorem leveque03_exercise35ReflectedPulse_wallFour (z : ℝ) :
    leveque03_exercise35ReflectedPulse (4 - z) =
      leveque03_exercise35ReflectedPulse (4 + z) := by
  have heven := leveque03_exercise35ReflectedPulse_even (4 - z)
  have hperiod := leveque03_exercise35ReflectedPulse_periodic (z - 4)
  have hleft : -(4 - z) = z - 4 := by ring
  have hright : z - 4 + 8 = 4 + z := by ring
  rw [hleft] at heven
  rw [hright] at hperiod
  exact heven.symm.trans hperiod.symm

/-- On the physical tube, only the original positive image is present. -/
theorem leveque03_exercise35ReflectedPulse_initialInterval
    (x : ℝ) (hx : 0 ≤ x ∧ x ≤ 4) :
    leveque03_exercise35ReflectedPulse x =
      leveque03_exercise34InitialPressure x := by
  unfold leveque03_exercise35ReflectedPulse
    leveque03_exercise34InitialPressure
  congr 1
  apply propext
  constructor
  · rintro ⟨k, hk⟩
    rcases lt_trichotomy k 0 with hneg | hzero | hpos
    · have hkreal : (k : ℝ) ≤ -1 := by
        exact_mod_cast (show k ≤ -1 by omega)
      rcases hk with h | h <;> linarith [hx.1, hx.2, hkreal]
    · subst k
      norm_num at hk
      rcases hk with h | h
      · exact h
      · linarith [hx.1, h.2]
    · have hkreal : (1 : ℝ) ≤ k := by
        exact_mod_cast (show 1 ≤ k by omega)
      rcases hk with h | h <;> linarith [hx.1, hx.2, hkreal]
  · intro h
    refine ⟨0, Or.inl ?_⟩
    simpa using h

theorem leveque03_exercise35ReflectedPulse_intervalIntegrable (a b : ℝ) :
    IntervalIntegrable leveque03_exercise35ReflectedPulse volume a b := by
  classical
  rw [intervalIntegrable_iff]
  have hc (v : ℝ) :
      Integrable (fun _ : ℝ => v) (volume.restrict (Set.uIoc a b)) :=
    (intervalIntegrable_const (a := a) (b := b) (c := v)).def'
  have hset : MeasurableSet
      {x : ℝ | ∃ k : ℤ,
        (1 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ 2) ∨
        (-2 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ -1)} := by
    have hstep (k : ℤ) : MeasurableSet
        {x : ℝ | (1 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ 2) ∨
          (-2 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ -1)} := by
      have hcont : Continuous (fun x : ℝ => x - 8 * (k : ℝ)) :=
        continuous_id.sub continuous_const
      have hfirst : MeasurableSet
          {x : ℝ | 1 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ 2} := by
        simpa only [Set.preimage_setOf_eq, Set.mem_Icc] using
          (measurableSet_Icc.preimage hcont.measurable)
      have hsecond : MeasurableSet
          {x : ℝ | -2 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ -1} := by
        simpa only [Set.preimage_setOf_eq, Set.mem_Icc] using
          (measurableSet_Icc.preimage hcont.measurable)
      exact hfirst.union hsecond
    have hunion : MeasurableSet
        (⋃ k : ℤ, {x : ℝ | (1 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ 2) ∨
          (-2 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ -1)}) :=
      MeasurableSet.iUnion hstep
    convert hunion using 1
    ext x
    simp
  have hp := Integrable.piecewise (μ := volume.restrict (Set.uIoc a b))
    (s := {x : ℝ | ∃ k : ℤ,
      (1 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ 2) ∨
      (-2 ≤ x - 8 * (k : ℝ) ∧ x - 8 * (k : ℝ) ≤ -1)})
    hset (hc 1).integrableOn (hc 0).integrableOn
  simpa only [Set.piecewise, Set.mem_setOf_eq,
    leveque03_exercise35ReflectedPulse] using hp

noncomputable def leveque03_exercise35Solution
    (density soundSpeed : ℝ) (x t : ℝ) : Fin 2 → ℝ :=
  leveque03_acousticInitialDataSolution density soundSpeed
    leveque03_exercise35ReflectedPulse (fun _ => 0) x t

theorem leveque03_exercise35Solution_initial
    (density soundSpeed : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed)
    (x : ℝ) (hx : 0 ≤ x ∧ x ≤ 4) :
    leveque03_exercise35Solution density soundSpeed x 0 =
      ![leveque03_exercise34InitialPressure x, 0] := by
  rw [leveque03_exercise35Solution,
    leveque03_acousticInitialDataSolution_initial density soundSpeed
      leveque03_exercise35ReflectedPulse (fun _ => 0) hZ x,
    leveque03_exercise35ReflectedPulse_initialInterval x hx]

theorem leveque03_exercise35Solution_leftWall
    (density soundSpeed : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0) (t : ℝ) :
    leveque03_exercise35Solution density soundSpeed 0 t 1 = 0 := by
  have hformula := leveque03_acousticZeroVelocity_formula density soundSpeed
    hZ leveque03_exercise35ReflectedPulse 0 t
  have heven := leveque03_exercise35ReflectedPulse_even (soundSpeed * t)
  have hcomp := congrFun hformula 1
  simpa [leveque03_exercise35Solution, heven] using hcomp

theorem leveque03_exercise35Solution_rightWall
    (density soundSpeed : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0) (t : ℝ) :
    leveque03_exercise35Solution density soundSpeed 4 t 1 = 0 := by
  have hformula := leveque03_acousticZeroVelocity_formula density soundSpeed
    hZ leveque03_exercise35ReflectedPulse 4 t
  have hwall := leveque03_exercise35ReflectedPulse_wallFour (soundSpeed * t)
  have hcomp := congrFun hformula 1
  simpa [leveque03_exercise35Solution, hwall] using hcomp

noncomputable def leveque03_exercise35LeftStrength
    (density soundSpeed : ℝ) (x : ℝ) : ℝ :=
  (-(1 / (2 * acousticImpedance density soundSpeed))) *
    leveque03_exercise35ReflectedPulse x

noncomputable def leveque03_exercise35RightStrength
    (density soundSpeed : ℝ) (x : ℝ) : ℝ :=
  (1 / (2 * acousticImpedance density soundSpeed)) *
    leveque03_exercise35ReflectedPulse x

noncomputable def leveque03_exercise35WaveSolution
    (density soundSpeed : ℝ) (x t : ℝ) : Fin 2 → ℝ :=
  eigenmodeTravelingWave (leveque03_exercise35LeftStrength density soundSpeed)
    (-soundSpeed) (linearAcousticsLeftEigenvector density soundSpeed) x t +
  eigenmodeTravelingWave (leveque03_exercise35RightStrength density soundSpeed)
    soundSpeed (linearAcousticsRightEigenvector density soundSpeed) x t

theorem leveque03_exercise35WaveSolution_weak
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    IsRectangleConservationLawSolution
      (leveque03_exercise35WaveSolution density soundSpeed)
      (linearAcousticsMatrix bulkModulus density).mulVec := by
  let q : Fin 2 → ℝ → ℝ → (Fin 2 → ℝ) :=
    ![eigenmodeTravelingWave (leveque03_exercise35LeftStrength density soundSpeed)
        (-soundSpeed) (linearAcousticsLeftEigenvector density soundSpeed),
      eigenmodeTravelingWave (leveque03_exercise35RightStrength density soundSpeed)
        soundSpeed (linearAcousticsRightEigenvector density soundSpeed)]
  have hq : ∀ p, IsRectangleConservationLawSolution (q p)
      (linearAcousticsMatrix bulkModulus density).mulVec := by
    intro p
    fin_cases p
    · exact eigenmodeTravelingWave_isRectangleSolution _ _
        (fun a b => (leveque03_exercise35ReflectedPulse_intervalIntegrable a b).const_mul _)
        _ _ (linearAcousticsMatrix_mulVec_leftEigenvector
          bulkModulus density soundSpeed hdensity hmaterial)
    · exact eigenmodeTravelingWave_isRectangleSolution _ _
        (fun a b => (leveque03_exercise35ReflectedPulse_intervalIntegrable a b).const_mul _)
        _ _ (linearAcousticsMatrix_mulVec_rightEigenvector
          bulkModulus density soundSpeed hdensity hmaterial)
  simpa [leveque03_exercise35WaveSolution, q, Fin.sum_univ_succ] using
    finite_sum_isRectangleSolution (linearAcousticsMatrix bulkModulus density) q hq

theorem leveque03_exercise35WaveSolution_eq
    (density soundSpeed : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0)
    (x t : ℝ) :
    leveque03_exercise35WaveSolution density soundSpeed x t =
      leveque03_exercise35Solution density soundSpeed x t := by
  have hdensity : density ≠ 0 := by
    intro h
    apply hZ
    simp [acousticImpedance, h]
  have hspeed : soundSpeed ≠ 0 := by
    intro h
    apply hZ
    simp [acousticImpedance, h]
  rw [leveque03_exercise35Solution,
    leveque03_acousticZeroVelocity_formula density soundSpeed hZ
      leveque03_exercise35ReflectedPulse x t]
  ext i
  fin_cases i <;>
    simp [leveque03_exercise35WaveSolution,
      leveque03_exercise35LeftStrength,
      leveque03_exercise35RightStrength,
      eigenmodeTravelingWave, travelingWave,
      linearAcousticsLeftEigenvector,
      linearAcousticsRightEigenvector, Pi.add_apply,
      smul_eq_mul, acousticImpedance] <;>
    field_simp [hdensity, hspeed] <;> ring

theorem leveque03_exercise35Solution_weak
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hspeed : soundSpeed ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    IsRectangleConservationLawSolution
      (leveque03_exercise35Solution density soundSpeed)
      (linearAcousticsMatrix bulkModulus density).mulVec := by
  have hZ : acousticImpedance density soundSpeed ≠ 0 := by
    simp [acousticImpedance, hdensity, hspeed]
  have heq : leveque03_exercise35WaveSolution density soundSpeed =
      leveque03_exercise35Solution density soundSpeed := by
    funext x t
    exact leveque03_exercise35WaveSolution_eq density soundSpeed hZ x t
  rw [← heq]
  exact leveque03_exercise35WaveSolution_weak
    bulkModulus density soundSpeed hdensity hmaterial

/-- The six requested snapshots are instances of one exact two-wave formula;
the speed remains a parameter because the exercise does not fix material
constants. -/
noncomputable def leveque03_exercise35SampleTime : Fin 6 → ℝ :=
  ![0, 1 / 2, 1, 3 / 2, 2, 3]

theorem leveque03_exercise35SampleProfiles
    (density soundSpeed : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0)
    (i : Fin 6) (x : ℝ) :
    leveque03_exercise35Solution density soundSpeed x
        (leveque03_exercise35SampleTime i) =
      ![(leveque03_exercise35ReflectedPulse
            (x + soundSpeed * leveque03_exercise35SampleTime i) +
          leveque03_exercise35ReflectedPulse
            (x - soundSpeed * leveque03_exercise35SampleTime i)) / 2,
        (leveque03_exercise35ReflectedPulse
            (x - soundSpeed * leveque03_exercise35SampleTime i) -
          leveque03_exercise35ReflectedPulse
            (x + soundSpeed * leveque03_exercise35SampleTime i)) /
          (2 * acousticImpedance density soundSpeed)] := by
  exact leveque03_acousticZeroVelocity_formula density soundSpeed hZ
    leveque03_exercise35ReflectedPulse x
      (leveque03_exercise35SampleTime i)

/-- The reflected solution satisfies the source IBVP on the physical tube,
with all six requested snapshots supplied by the exact sample formula. -/
theorem leveque03_exercise35FullSolution
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : 0 < density) (hspeed : 0 < soundSpeed)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    IsRectangleConservationLawSolution
        (leveque03_exercise35Solution density soundSpeed)
        (linearAcousticsMatrix bulkModulus density).mulVec ∧
      (∀ x, 0 ≤ x → x ≤ 4 →
        leveque03_exercise35Solution density soundSpeed x 0 =
          ![leveque03_exercise34InitialPressure x, 0]) ∧
      (∀ t, leveque03_exercise35Solution density soundSpeed 0 t 1 = 0 ∧
        leveque03_exercise35Solution density soundSpeed 4 t 1 = 0) ∧
      (∀ i : Fin 6, ∀ x,
        leveque03_exercise35Solution density soundSpeed x
            (leveque03_exercise35SampleTime i) =
          ![(leveque03_exercise35ReflectedPulse
                (x + soundSpeed * leveque03_exercise35SampleTime i) +
              leveque03_exercise35ReflectedPulse
                (x - soundSpeed * leveque03_exercise35SampleTime i)) / 2,
            (leveque03_exercise35ReflectedPulse
                (x - soundSpeed * leveque03_exercise35SampleTime i) -
              leveque03_exercise35ReflectedPulse
                (x + soundSpeed * leveque03_exercise35SampleTime i)) /
              (2 * acousticImpedance density soundSpeed)]) := by
  have hZ : 0 < acousticImpedance density soundSpeed :=
    mul_pos hdensity hspeed
  refine ⟨leveque03_exercise35Solution_weak bulkModulus density soundSpeed
    hdensity.ne' hspeed.ne' hmaterial, ?_, ?_, ?_⟩
  · exact fun x hx0 hx4 =>
      leveque03_exercise35Solution_initial density soundSpeed hZ x ⟨hx0, hx4⟩
  · exact fun t => ⟨leveque03_exercise35Solution_leftWall
      density soundSpeed hZ.ne' t,
      leveque03_exercise35Solution_rightWall density soundSpeed hZ.ne' t⟩
  · exact fun i x => leveque03_exercise35SampleProfiles
      density soundSpeed hZ.ne' i x

end NumStability
