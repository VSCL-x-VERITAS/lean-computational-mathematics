/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.Exercise37Average
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Periodic
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
# Exercise 3.7: an acoustic wave bouncing between piston and wall

Printed page 63/raw PDF page 85. Integer floors count successive reflected
arrivals. The initial state is imposed on the open tube, since the prescribed
piston velocity is incompatible with the initial velocity at `(0,0)` when
`epsilon` is nonzero.
-/

namespace NumStability

open MeasureTheory

/-- Number of successive waves after an unfolded characteristic crossing;
the extension to negative arguments is convenient outside the physical tube. -/
noncomputable def leveque03_exercise37Step (z : ℝ) : ℝ :=
  (⌊z / 2⌋ : ℤ) + 1

theorem leveque03_exercise37Step_sub_two (z : ℝ) :
    leveque03_exercise37Step (z - 2) =
      leveque03_exercise37Step z - 1 := by
  have h : (z - 2) / 2 = z / 2 - 1 := by ring
  simp [leveque03_exercise37Step, h, Int.floor_sub_one]

theorem leveque03_exercise37Step_neg (z : ℝ)
    (hlower : -2 ≤ z) (hupper : z < 0) :
    leveque03_exercise37Step z = 0 := by
  have hfloor : ⌊z / 2⌋ = (-1 : ℤ) :=
    Int.floor_eq_iff.mpr (by
      have hb : (-1 : ℝ) ≤ z / 2 ∧ z / 2 < 0 := by
        constructor
        · apply (le_div_iff₀ (by norm_num : (0 : ℝ) < 2)).2
          linarith
        · apply (div_lt_iff₀ (by norm_num : (0 : ℝ) < 2)).2
          linarith
      simpa using hb)
  simp [leveque03_exercise37Step, hfloor]

theorem leveque03_exercise37Step_mono :
    Monotone leveque03_exercise37Step := by
  intro x y hxy
  have hfloor : ⌊x / 2⌋ ≤ ⌊y / 2⌋ :=
    Int.floor_mono (by linarith)
  have hcast : ((⌊x / 2⌋ : ℤ) : ℝ) ≤ ((⌊y / 2⌋ : ℤ) : ℝ) := by
    exact_mod_cast hfloor
  dsimp [leveque03_exercise37Step]
  linarith

/-- The staircase differs from its linear trend by at most one wave. -/
theorem leveque03_exercise37Step_remainder (z : ℝ) :
    0 < leveque03_exercise37Step z - z / 2 ∧
      leveque03_exercise37Step z - z / 2 ≤ 1 := by
  have hlow := Int.floor_le (z / 2)
  have hhigh := Int.lt_floor_add_one (z / 2)
  dsimp [leveque03_exercise37Step]
  constructor <;> linarith

/-- The bounded, period-two phase error of the staircase. -/
noncomputable def leveque03_exercise37Remainder (z : ℝ) : ℝ :=
  leveque03_exercise37Step z - z / 2

theorem leveque03_exercise37Step_add_two (z : ℝ) :
    leveque03_exercise37Step (z + 2) =
      leveque03_exercise37Step z + 1 := by
  have h := leveque03_exercise37Step_sub_two (z + 2)
  have harg : z + 2 - 2 = z := by ring
  rw [harg] at h
  linarith

theorem leveque03_exercise37Remainder_periodic :
    Function.Periodic leveque03_exercise37Remainder 2 := by
  intro z
  simp only [leveque03_exercise37Remainder,
    leveque03_exercise37Step_add_two]
  ring

theorem leveque03_exercise37Remainder_intervalIntegrable (a b : ℝ) :
    IntervalIntegrable leveque03_exercise37Remainder volume a b := by
  unfold leveque03_exercise37Remainder
  exact (leveque03_exercise37Step_mono.intervalIntegrable).sub
    ((by fun_prop : Continuous (fun z : ℝ => z / 2)).intervalIntegrable a b)

theorem leveque03_exercise37Remainder_periodIntegral :
    ∫ z in (0 : ℝ)..2, leveque03_exercise37Remainder z = 1 := by
  have hstep (z : ℝ) (hz : z ∈ Set.Ioc (0 : ℝ) 2) (hne : z ≠ 2) :
      leveque03_exercise37Step z = 1 := by
    have hf : ⌊z / 2⌋ = (0 : ℤ) :=
      Int.floor_eq_iff.mpr (by
        have hb : (0 : ℝ) ≤ z / 2 ∧ z / 2 < 1 := by
          constructor
          · apply (le_div_iff₀ (by norm_num : (0 : ℝ) < 2)).2
            linarith [hz.1]
          · apply (div_lt_iff₀ (by norm_num : (0 : ℝ) < 2)).2
            have : z < 2 := lt_of_le_of_ne hz.2 hne
            linarith
        simpa using hb)
    simp [leveque03_exercise37Step, hf]
  have heq :
      (∫ z in (0 : ℝ)..2, leveque03_exercise37Remainder z) =
        ∫ z in (0 : ℝ)..2, (1 - z / 2) := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [Measure.ae_ne volume (2 : ℝ)] with z hne hz
    have hzI : z ∈ Set.Ioc (0 : ℝ) 2 := by simpa using hz
    simp [leveque03_exercise37Remainder, hstep z hzI hne]
  rw [heq]
  norm_num [integral_sub, integral_id]
  show (2 : ℝ) - 2 / 2 = 1
  norm_num

theorem leveque03_exercise37Remainder_periodIntegral_any (a : ℝ) :
    ∫ z in a..a + 2, leveque03_exercise37Remainder z = 1 := by
  rw [leveque03_exercise37Remainder_periodic.intervalIntegral_add_eq a 0]
  simpa using leveque03_exercise37Remainder_periodIntegral

theorem leveque03_exercise37Step_periodIntegral (a : ℝ) :
    ∫ z in a..a + 2, leveque03_exercise37Step z = a + 2 := by
  have hlinear : IntervalIntegrable (fun z : ℝ => z / 2) volume a (a + 2) :=
    (by fun_prop : Continuous (fun z : ℝ => z / 2)).intervalIntegrable a (a + 2)
  have hstep := leveque03_exercise37Step_mono.intervalIntegrable
    (a := a) (b := a + 2) (μ := volume)
  have hrem := leveque03_exercise37Remainder_intervalIntegrable a (a + 2)
  have hfun : leveque03_exercise37Step =
      fun z => leveque03_exercise37Remainder z + z / 2 := by
    funext z
    simp [leveque03_exercise37Remainder]
  rw [hfun, intervalIntegral.integral_add hrem hlinear,
    leveque03_exercise37Remainder_periodIntegral_any]
  norm_num [integral_id]
  ring

/-- Over one bounce period, the wave-arrival staircase has an exact mean. -/
theorem leveque03_exercise37Step_timePeriodIntegral
    (soundSpeed a d : ℝ) (hspeed : 0 < soundSpeed) :
    ∫ t in a..a + 2 / soundSpeed,
        leveque03_exercise37Step (soundSpeed * t + d) =
      (soundSpeed * a + d + 2) / soundSpeed := by
  have h := intervalIntegral.integral_comp_mul_add
    (f := leveque03_exercise37Step) (a := a)
    (b := a + 2 / soundSpeed) hspeed.ne' d
  rw [h]
  have hend : soundSpeed * (a + 2 / soundSpeed) + d =
      soundSpeed * a + d + 2 := by
    field_simp [hspeed.ne']
    ring
  rw [hend, leveque03_exercise37Step_periodIntegral]
  simp only [smul_eq_mul]
  field_simp [hspeed.ne']

/-- Invariant carried by the right-running family. -/
noncomputable def leveque03_exercise37RightInvariant
    (density soundSpeed initialPressure epsilon x t : ℝ) : ℝ :=
  initialPressure + 2 * acousticImpedance density soundSpeed * epsilon *
    leveque03_exercise37Step (soundSpeed * t - x)

/-- Invariant carried by the left-running family after wall reflection. -/
noncomputable def leveque03_exercise37LeftInvariant
    (density soundSpeed initialPressure epsilon x t : ℝ) : ℝ :=
  initialPressure + 2 * acousticImpedance density soundSpeed * epsilon *
    leveque03_exercise37Step (soundSpeed * t + x - 2)

/-- The pressure field for Exercise 3.7. -/
noncomputable def leveque03_exercise37Pressure
    (density soundSpeed initialPressure epsilon x t : ℝ) : ℝ :=
  (leveque03_exercise37RightInvariant density soundSpeed initialPressure epsilon x t +
    leveque03_exercise37LeftInvariant density soundSpeed initialPressure epsilon x t) / 2

/-- The velocity field for Exercise 3.7. -/
noncomputable def leveque03_exercise37Velocity
    (density soundSpeed initialPressure epsilon x t : ℝ) : ℝ :=
  (leveque03_exercise37RightInvariant density soundSpeed initialPressure epsilon x t -
    leveque03_exercise37LeftInvariant density soundSpeed initialPressure epsilon x t) /
    (2 * acousticImpedance density soundSpeed)

theorem leveque03_exercise37_initial
    (density soundSpeed initialPressure epsilon x : ℝ)
    (hx0 : 0 < x) (hx1 : x < 1) :
    leveque03_exercise37Pressure density soundSpeed initialPressure epsilon x 0 =
        initialPressure ∧
      leveque03_exercise37Velocity density soundSpeed initialPressure epsilon x 0 =
        0 := by
  have hr : leveque03_exercise37Step (-x) = 0 :=
    leveque03_exercise37Step_neg (-x) (by linarith) (by linarith)
  have hl : leveque03_exercise37Step (x - 2) = 0 :=
    leveque03_exercise37Step_neg (x - 2) (by linarith) (by linarith)
  simp [leveque03_exercise37Pressure, leveque03_exercise37Velocity,
    leveque03_exercise37RightInvariant, leveque03_exercise37LeftInvariant,
    hr, hl]

theorem leveque03_exercise37_boundary
    (density soundSpeed initialPressure epsilon t : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0) :
    leveque03_exercise37Velocity density soundSpeed initialPressure epsilon 0 t =
        epsilon ∧
      leveque03_exercise37Velocity density soundSpeed initialPressure epsilon 1 t =
        0 := by
  constructor
  · have hstep := leveque03_exercise37Step_sub_two (soundSpeed * t)
    simp only [leveque03_exercise37Velocity,
      leveque03_exercise37RightInvariant,
      leveque03_exercise37LeftInvariant,
      sub_zero, add_zero, hstep]
    field_simp [hZ]
    ring
  · have heq :
        leveque03_exercise37RightInvariant density soundSpeed initialPressure
            epsilon 1 t =
          leveque03_exercise37LeftInvariant density soundSpeed initialPressure
            epsilon 1 t := by
      have harg : soundSpeed * t + 1 - 2 = soundSpeed * t - 1 := by ring
      simp only [leveque03_exercise37RightInvariant,
        leveque03_exercise37LeftInvariant, harg]
    change (leveque03_exercise37RightInvariant density soundSpeed initialPressure
        epsilon 1 t -
      leveque03_exercise37LeftInvariant density soundSpeed initialPressure
        epsilon 1 t) / (2 * acousticImpedance density soundSpeed) = 0
    rw [heq]
    simp

/-- Eigenmode strengths; a constant state is split equally between the two
characteristic families. -/
noncomputable def leveque03_exercise37RightStrength
    (density soundSpeed initialPressure epsilon x : ℝ) : ℝ :=
  initialPressure / (2 * acousticImpedance density soundSpeed) +
    epsilon * leveque03_exercise37Step (-x)

/-- The left-going wave strength for Exercise 3.7. -/
noncomputable def leveque03_exercise37LeftStrength
    (density soundSpeed initialPressure epsilon x : ℝ) : ℝ :=
  -initialPressure / (2 * acousticImpedance density soundSpeed) -
    epsilon * leveque03_exercise37Step (x - 2)

theorem leveque03_exercise37RightStrength_intervalIntegrable
    (density soundSpeed initialPressure epsilon a b : ℝ)
    (hepsilon : 0 ≤ epsilon) :
    IntervalIntegrable
      (leveque03_exercise37RightStrength density soundSpeed initialPressure epsilon)
      MeasureTheory.volume a b := by
  apply Antitone.intervalIntegrable
  intro x y hxy
  have hstep := leveque03_exercise37Step_mono (show -y ≤ -x by linarith)
  dsimp [leveque03_exercise37RightStrength]
  nlinarith

theorem leveque03_exercise37LeftStrength_intervalIntegrable
    (density soundSpeed initialPressure epsilon a b : ℝ)
    (hepsilon : 0 ≤ epsilon) :
    IntervalIntegrable
      (leveque03_exercise37LeftStrength density soundSpeed initialPressure epsilon)
      MeasureTheory.volume a b := by
  apply Antitone.intervalIntegrable
  intro x y hxy
  have hstep := leveque03_exercise37Step_mono (show x - 2 ≤ y - 2 by linarith)
  dsimp [leveque03_exercise37LeftStrength]
  nlinarith

/-- The wave representation of the solution for Exercise 3.7. -/
noncomputable def leveque03_exercise37WaveSolution
    (density soundSpeed initialPressure epsilon : ℝ) (x t : ℝ) : Fin 2 → ℝ :=
  eigenmodeTravelingWave
      (leveque03_exercise37LeftStrength density soundSpeed initialPressure epsilon)
      (-soundSpeed) (linearAcousticsLeftEigenvector density soundSpeed) x t +
    eigenmodeTravelingWave
      (leveque03_exercise37RightStrength density soundSpeed initialPressure epsilon)
      soundSpeed (linearAcousticsRightEigenvector density soundSpeed) x t

theorem leveque03_exercise37WaveSolution_weak
    (bulkModulus density soundSpeed initialPressure epsilon : ℝ)
    (hdensity : density ≠ 0)
    (hepsilon : 0 ≤ epsilon)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    IsRectangleConservationLawSolution
      (leveque03_exercise37WaveSolution density soundSpeed initialPressure epsilon)
      (linearAcousticsMatrix bulkModulus density).mulVec := by
  let q : Fin 2 → ℝ → ℝ → (Fin 2 → ℝ) :=
    ![eigenmodeTravelingWave
        (leveque03_exercise37LeftStrength density soundSpeed initialPressure epsilon)
        (-soundSpeed) (linearAcousticsLeftEigenvector density soundSpeed),
      eigenmodeTravelingWave
        (leveque03_exercise37RightStrength density soundSpeed initialPressure epsilon)
        soundSpeed (linearAcousticsRightEigenvector density soundSpeed)]
  have hq : ∀ p, IsRectangleConservationLawSolution (q p)
      (linearAcousticsMatrix bulkModulus density).mulVec := by
    intro p
    fin_cases p
    · exact eigenmodeTravelingWave_isRectangleSolution _ _
        (leveque03_exercise37LeftStrength_intervalIntegrable
          density soundSpeed initialPressure epsilon · · hepsilon)
        _ _ (linearAcousticsMatrix_mulVec_leftEigenvector
          bulkModulus density soundSpeed hdensity hmaterial)
    · exact eigenmodeTravelingWave_isRectangleSolution _ _
        (leveque03_exercise37RightStrength_intervalIntegrable
          density soundSpeed initialPressure epsilon · · hepsilon)
        _ _ (linearAcousticsMatrix_mulVec_rightEigenvector
          bulkModulus density soundSpeed hdensity hmaterial)
  simpa [leveque03_exercise37WaveSolution, q, Fin.sum_univ_succ] using
    finite_sum_isRectangleSolution (linearAcousticsMatrix bulkModulus density) q hq

theorem leveque03_exercise37WaveSolution_eq
    (density soundSpeed initialPressure epsilon x t : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0) :
    leveque03_exercise37WaveSolution density soundSpeed initialPressure epsilon x t =
      ![leveque03_exercise37Pressure density soundSpeed initialPressure epsilon x t,
        leveque03_exercise37Velocity density soundSpeed initialPressure epsilon x t] := by
  have hdensity : density ≠ 0 := by
    intro h
    apply hZ
    simp [acousticImpedance, h]
  have hspeed : soundSpeed ≠ 0 := by
    intro h
    apply hZ
    simp [acousticImpedance, h]
  ext i
  fin_cases i <;>
    simp [leveque03_exercise37WaveSolution,
      leveque03_exercise37Pressure, leveque03_exercise37Velocity,
      leveque03_exercise37RightInvariant,
      leveque03_exercise37LeftInvariant,
      leveque03_exercise37RightStrength,
      leveque03_exercise37LeftStrength,
      eigenmodeTravelingWave, travelingWave,
      linearAcousticsLeftEigenvector,
      linearAcousticsRightEigenvector, Pi.add_apply,
      smul_eq_mul, acousticImpedance] <;>
    field_simp [hdensity, hspeed] <;> norm_num <;> ring

/-- The exact reflected-wave solution of the compatible parts of the printed
initial-boundary data. The corner `(0,0)` is excluded from the initial trace. -/
theorem leveque03_exercise37FullSolution
    (bulkModulus density soundSpeed initialPressure epsilon : ℝ)
    (hdensity : 0 < density) (hspeed : 0 < soundSpeed)
    (hepsilon : 0 ≤ epsilon)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    IsRectangleConservationLawSolution
      (fun x t => ![
        leveque03_exercise37Pressure density soundSpeed initialPressure epsilon x t,
        leveque03_exercise37Velocity density soundSpeed initialPressure epsilon x t])
      (linearAcousticsMatrix bulkModulus density).mulVec ∧
      (∀ x, 0 < x → x < 1 →
        leveque03_exercise37Pressure density soundSpeed initialPressure epsilon x 0 =
          initialPressure ∧
        leveque03_exercise37Velocity density soundSpeed initialPressure epsilon x 0 = 0) ∧
      leveque03_exercise37PistonWallVelocity
        (leveque03_exercise37Velocity density soundSpeed initialPressure epsilon)
        epsilon := by
  have hZ : acousticImpedance density soundSpeed ≠ 0 :=
    (mul_pos hdensity hspeed).ne'
  have heq : leveque03_exercise37WaveSolution density soundSpeed
      initialPressure epsilon =
      fun x t => ![
        leveque03_exercise37Pressure density soundSpeed initialPressure epsilon x t,
        leveque03_exercise37Velocity density soundSpeed initialPressure epsilon x t] := by
    funext x t
    exact leveque03_exercise37WaveSolution_eq
      density soundSpeed initialPressure epsilon x t hZ
  refine ⟨?_, ?_, ?_⟩
  · rw [← heq]
    exact leveque03_exercise37WaveSolution_weak bulkModulus density soundSpeed
      initialPressure epsilon hdensity.ne' hepsilon hmaterial
  · exact fun x hx0 hx1 =>
      leveque03_exercise37_initial density soundSpeed initialPressure epsilon
        x hx0 hx1
  · intro t _
    exact leveque03_exercise37_boundary density soundSpeed initialPressure
      epsilon t hZ

/-- The exact wave pressure stays within one acoustic wave increment of the
uniform slow-compression pressure, at every point and time. -/
theorem leveque03_exercise37Pressure_slow_error
    (bulkModulus density soundSpeed initialPressure epsilon x t : ℝ)
    (hdensity : 0 < density) (hspeed : 0 < soundSpeed)
    (hepsilon : 0 ≤ epsilon)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    |leveque03_exercise37Pressure density soundSpeed initialPressure epsilon x t -
      leveque03_exercise37SlowPressure bulkModulus initialPressure epsilon x t| ≤
      acousticImpedance density soundSpeed * epsilon := by
  let er := leveque03_exercise37Step (soundSpeed * t - x) -
    (soundSpeed * t - x) / 2
  let el := leveque03_exercise37Step (soundSpeed * t + x - 2) -
    (soundSpeed * t + x - 2) / 2
  have hr := leveque03_exercise37Step_remainder (soundSpeed * t - x)
  have hl := leveque03_exercise37Step_remainder (soundSpeed * t + x - 2)
  have hb : -1 ≤ er + el - 1 ∧ er + el - 1 ≤ 1 := by
    dsimp [er, el]
    constructor <;> linarith
  have hcoef : 0 ≤ acousticImpedance density soundSpeed * epsilon :=
    mul_nonneg (mul_pos hdensity hspeed).le hepsilon
  have hform :
      leveque03_exercise37Pressure density soundSpeed initialPressure epsilon x t -
        leveque03_exercise37SlowPressure bulkModulus initialPressure epsilon x t =
      acousticImpedance density soundSpeed * epsilon * (er + el - 1) := by
    dsimp [leveque03_exercise37Pressure,
      leveque03_exercise37RightInvariant,
      leveque03_exercise37LeftInvariant,
      leveque03_exercise37SlowPressure, acousticImpedance, er, el]
    rw [hmaterial]
    ring
  rw [hform]
  apply abs_le.mpr
  constructor
  · have h := mul_le_mul_of_nonneg_left hb.1 hcoef
    nlinarith
  · exact mul_le_mul_of_nonneg_left hb.2 hcoef |>.trans_eq (mul_one _)

/-- The exact wave velocity differs from the affine slow profile by at most
one piston-speed increment before any averaging. -/
theorem leveque03_exercise37Velocity_slow_error
    (density soundSpeed initialPressure epsilon x t : ℝ)
    (hdensity : 0 < density) (hspeed : 0 < soundSpeed)
    (hepsilon : 0 ≤ epsilon) :
    |leveque03_exercise37Velocity density soundSpeed initialPressure epsilon x t -
      leveque03_exercise37SlowVelocity epsilon x t| ≤ epsilon := by
  let er := leveque03_exercise37Step (soundSpeed * t - x) -
    (soundSpeed * t - x) / 2
  let el := leveque03_exercise37Step (soundSpeed * t + x - 2) -
    (soundSpeed * t + x - 2) / 2
  have hr := leveque03_exercise37Step_remainder (soundSpeed * t - x)
  have hl := leveque03_exercise37Step_remainder (soundSpeed * t + x - 2)
  have hb : -1 ≤ er - el ∧ er - el ≤ 1 := by
    dsimp [er, el]
    constructor <;> linarith
  have hZ : acousticImpedance density soundSpeed ≠ 0 :=
    (mul_pos hdensity hspeed).ne'
  have hform :
      leveque03_exercise37Velocity density soundSpeed initialPressure epsilon x t -
        leveque03_exercise37SlowVelocity epsilon x t =
      epsilon * (er - el) := by
    dsimp [leveque03_exercise37Velocity,
      leveque03_exercise37RightInvariant,
      leveque03_exercise37LeftInvariant,
      leveque03_exercise37SlowVelocity, er, el]
    field_simp [hZ]
    ring
  rw [hform]
  apply abs_le.mpr
  constructor
  · have h := mul_le_mul_of_nonneg_left hb.1 hepsilon
    nlinarith
  · exact mul_le_mul_of_nonneg_left hb.2 hepsilon |>.trans_eq (mul_one _)

end NumStability
