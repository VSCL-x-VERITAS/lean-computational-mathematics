/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.UniformReconstructionContinuity
import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannWaveStrength
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicCoordinates

/-!
# Discontinuity locations of the actual uniform characteristic field

The independent basis coordinates distinguish every nonzero incoming wave,
including waves whose translated interfaces coincide. No sign, time-step,
separation, or bounded-data condition is needed to identify these locations.
-/

namespace NumStability

/-- An actual basis wave vanishes precisely when that characteristic
coordinate agrees on its two states. -/
theorem leveque04_riemannWave_eq_zero_iff_coordinates_eq
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) (p : Fin m) :
    leveque03_riemannWave basis left right p = 0 ↔
      basis.equivFun left p = basis.equivFun right p := by
  simp only [leveque03_riemannWave, leveque03_waveStrength,
    leveque03_characteristicVariables, leveque03_characteristicCoordinates,
    smul_eq_zero, basis.ne_zero p, or_false, sub_eq_zero]
  exact eq_comm

/-- The actual characteristic field is continuous exactly when every wave
whose translated interface reaches the point has zero strength. -/
theorem leveque04_linearUniformEvolution_continuousAt_iff
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) (time z : ℝ) :
    ContinuousAt
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time) z ↔
      ∀ (p : Fin m) (j : ℤ),
        z = leveque04_uniformInterface origin width j + speeds p * time →
          leveque03_riemannWave basis (old j) (old (j + 1)) p = 0 := by
  let field := fun x => linearCharacteristicEvolution basis speeds
    (leveque04_uniformReconstruction origin width old) x time
  have hcoordinate (p : Fin m) (x : ℝ) :
      basis.equivFun (field x) p =
        leveque04_uniformReconstruction origin width
          (fun j => basis.equivFun (old j) p) (x - speeds p * time) := by
    simp only [field, linearCharacteristicEvolution_coordinate,
      leveque04_uniformReconstruction]
  have hcontinuous : ContinuousAt field z ↔
      ∀ p : Fin m,
        ContinuousAt (leveque04_uniformReconstruction origin width
          (fun j => basis.equivFun (old j) p)) (z - speeds p * time) := by
    have hbasis : ContinuousAt field z ↔
        ContinuousAt (fun x => basis.equivFun (field x)) z :=
      (basis.equivFun.toContinuousLinearEquiv.toHomeomorph.comp_continuousAt_iff
        field z).symm
    rw [hbasis, continuousAt_pi]
    apply forall_congr'
    intro p
    change ContinuousAt (fun x => basis.equivFun (field x) p) z ↔ _
    have hfun : (fun x => basis.equivFun (field x) p) =
        (fun x => leveque04_uniformReconstruction origin width
          (fun j => basis.equivFun (old j) p) (x - speeds p * time)) :=
      funext (hcoordinate p)
    rw [hfun]
    exact (Homeomorph.subRight (speeds p * time)).comp_continuousAt_iff'
      (leveque04_uniformReconstruction origin width
        (fun j => basis.equivFun (old j) p)) z
  change ContinuousAt field z ↔ _
  rw [hcontinuous]
  constructor
  · intro h p j hj
    apply (leveque04_riemannWave_eq_zero_iff_coordinates_eq basis _ _ p).2
    apply (leveque04_uniformReconstruction_continuousAt_iff origin width hwidth
      (fun j => basis.equivFun (old j) p) (z - speeds p * time)).1 (h p) j
    linarith
  · intro h p
    apply (leveque04_uniformReconstruction_continuousAt_iff origin width hwidth
      (fun j => basis.equivFun (old j) p) (z - speeds p * time)).2
    intro j hj
    apply (leveque04_riemannWave_eq_zero_iff_coordinates_eq basis _ _ p).1
    apply h p j
    linarith

/-- The discontinuities of the actual uniform characteristic evolution are
exactly the translated interfaces carrying at least one nonzero basis wave. -/
theorem leveque04_linearUniformEvolution_not_continuousAt_iff
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) (time z : ℝ) :
    ¬ ContinuousAt
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time) z ↔
      ∃ (p : Fin m) (j : ℤ),
        z = leveque04_uniformInterface origin width j + speeds p * time ∧
          leveque03_riemannWave basis (old j) (old (j + 1)) p ≠ 0 := by
  rw [leveque04_linearUniformEvolution_continuousAt_iff
    basis speeds origin width hwidth old time z]
  simp only [not_forall, exists_prop]

end NumStability
