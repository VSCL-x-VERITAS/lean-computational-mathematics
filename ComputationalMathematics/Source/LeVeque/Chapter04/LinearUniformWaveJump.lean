/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LinearUniformWaveTraces

/-!
# Noncancellation of coincident actual modal waves

The ceiling selection recovers the actual interface wave whenever its
translated front reaches the point. Selected waves belong to independent
basis directions, so their finite sum vanishes exactly when every summand
vanishes. A nonzero sum gives a genuine jump of the actual characteristic field.
-/

open scoped BigOperators

namespace NumStability

/-- At an actual translated interface, the selected modal front correction is
exactly the actual wave at that interface. -/
theorem leveque04_uniformModalFrontJump_eq_wave_of_front
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) (time z : ℝ) (p : Fin m) (j : ℤ)
    (hz : z = leveque04_uniformInterface origin width j + speeds p * time) :
    leveque04_uniformModalFrontJump basis speeds origin width old time z p =
      leveque03_riemannWave basis (old j) (old (j + 1)) p := by
  have hfoot : z - speeds p * time = leveque04_uniformInterface origin width j := by
    linarith
  have hindex : ⌈(z - speeds p * time - origin) / width⌉ = j := by
    rw [hfoot]
    simp [leveque04_uniformInterface, hwidth.ne']
  simp only [leveque04_uniformModalFrontJump, hindex, if_pos hz]

/-- A finite sum of selected actual modal waves vanishes exactly when every
selected wave vanishes. This is purely independence of the basis directions. -/
theorem leveque04_uniformModalFrontJump_sum_eq_zero_iff
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (old : ℤ → Fin m → ℝ)
    (time z : ℝ) :
    (∑ p, leveque04_uniformModalFrontJump basis speeds origin width old time z p) = 0 ↔
      ∀ p, leveque04_uniformModalFrontJump basis speeds origin width old time z p = 0 := by
  classical
  let index := fun p : Fin m => ⌈(z - speeds p * time - origin) / width⌉
  let amplitude := fun p : Fin m =>
    if z = leveque04_uniformInterface origin width (index p) + speeds p * time
    then leveque03_waveStrength basis (old (index p)) (old (index p + 1)) p else 0
  have hmode (p : Fin m) :
      leveque04_uniformModalFrontJump basis speeds origin width old time z p =
        amplitude p • basis p := by
    dsimp only [leveque04_uniformModalFrontJump, amplitude, index]
    split_ifs <;> simp only [leveque03_riemannWave, zero_smul]
  constructor
  · intro hsum p
    have hcomb : (∑ q, amplitude q • basis q) = 0 := by
      calc
        (∑ q, amplitude q • basis q) =
            ∑ q, leveque04_uniformModalFrontJump basis speeds origin width old time z q :=
          Finset.sum_congr rfl (fun q _ => (hmode q).symm)
        _ = 0 := hsum
    have hzero := (Fintype.linearIndependent_iff.mp basis.linearIndependent) amplitude hcomb p
    rw [hmode p, hzero, zero_smul]
  · intro hzero
    simp only [hzero, Finset.sum_const_zero]

/-- The summed right-trace correction vanishes exactly when every actual
wave located at that point vanishes, even when several modes arrive together. -/
theorem leveque04_uniformModalFrontJump_sum_eq_zero_iff_waves
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) (time z : ℝ) :
    (∑ p, leveque04_uniformModalFrontJump basis speeds origin width old time z p) = 0 ↔
      ∀ (p : Fin m) (j : ℤ),
        z = leveque04_uniformInterface origin width j + speeds p * time →
          leveque03_riemannWave basis (old j) (old (j + 1)) p = 0 := by
  rw [leveque04_uniformModalFrontJump_sum_eq_zero_iff]
  constructor
  · intro hzero p j hz
    have hp := hzero p
    rw [leveque04_uniformModalFrontJump_eq_wave_of_front
      basis speeds origin width hwidth old time z p j hz] at hp
    exact hp
  · intro hzero p
    dsimp only [leveque04_uniformModalFrontJump]
    split_ifs with hfront
    · exact hzero p _ hfront
    · rfl

/-- A nonzero finite coincident-wave correction gives distinct actual
one-sided traces of the characteristic evolution. -/
theorem leveque04_linearUniformEvolution_hasJumpAt
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) (time z : ℝ)
    (hne : (∑ p, leveque04_uniformModalFrontJump basis speeds origin width old time z p) ≠ 0) :
    HasJumpAt
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time) z
      (linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) z time)
      (linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) z time +
        ∑ p, leveque04_uniformModalFrontJump basis speeds origin width old time z p) := by
  refine ⟨leveque04_linearUniformEvolution_tendsto_left_at
      basis speeds origin width hwidth old time z,
    leveque04_linearUniformEvolution_tendsto_right_at
      basis speeds origin width hwidth old time z, ?_⟩
  intro heq
  apply hne
  exact add_left_cancel (by simpa only [add_zero] using heq.symm)

end NumStability
