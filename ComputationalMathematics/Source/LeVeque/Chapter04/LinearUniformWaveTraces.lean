/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LinearUniformWaveLocations
import Mathlib.Tactic.Module

/-!
# Global one-sided traces of the actual uniform characteristic field

The selected uniform reconstruction, and hence its characteristic evolution,
take their left traces as point values. The right trace adds all modal wave
vectors whose translated grid interfaces meet the point, including coincident
fronts. These traces require neither a CFL bound nor bounded cell data.
-/

open Filter Set
open scoped Topology BigOperators

namespace NumStability

/-- The actual uniform reconstruction takes its left trace at every point. -/
theorem leveque04_uniformReconstruction_tendsto_left_at
    {E : Type*} [TopologicalSpace E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (z : ℝ) :
    Tendsto (leveque04_uniformReconstruction origin width old)
      (𝓝[<] z) (𝓝 (leveque04_uniformReconstruction origin width old z)) := by
  by_cases hface : ∃ j : ℤ, z = leveque04_uniformInterface origin width j
  · obtain ⟨j, rfl⟩ := hface
    rw [leveque04_uniformReconstruction_face origin width hwidth old j]
    exact leveque04_uniformReconstruction_tendsto_left origin width hwidth old j
  · have hc := leveque04_uniformReconstruction_continuousAt_of_ne_interfaces
      origin width hwidth old z (fun j hj => hface ⟨j, hj⟩)
    exact hc.continuousWithinAt.tendsto

/-- The right trace selects the next cell exactly when the point is the right
face of its ceiling-indexed cell. -/
theorem leveque04_uniformReconstruction_tendsto_right_at
    {E : Type*} [TopologicalSpace E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (z : ℝ) :
    let k : ℤ := ⌈(z - origin) / width⌉
    Tendsto (leveque04_uniformReconstruction origin width old) (𝓝[>] z)
      (𝓝 (if z = leveque04_uniformInterface origin width k then old (k + 1) else old k)) := by
  classical
  let k : ℤ := ⌈(z - origin) / width⌉
  change Tendsto _ _ (𝓝 (if z = leveque04_uniformInterface origin width k
    then old (k + 1) else old k))
  by_cases hface : z = leveque04_uniformInterface origin width k
  · rw [if_pos hface]
    simpa only [← hface] using
      leveque04_uniformReconstruction_tendsto_right origin width hwidth old k
  · rw [if_neg hface]
    have hnone : ∀ j : ℤ, z ≠ leveque04_uniformInterface origin width j := by
      intro j hj
      have hk : k = j := by
        dsimp only [k]
        rw [hj]
        simp [leveque04_uniformInterface, hwidth.ne']
      apply hface
      simpa only [hk] using hj
    exact (leveque04_uniformReconstruction_continuousAt_of_ne_interfaces
      origin width hwidth old z hnone).continuousWithinAt.tendsto

/-- The actual modal wave reaching a point, or zero when that mode has no
interface at the point. Each mode uses its own characteristic foot index. -/
noncomputable def leveque04_uniformModalFrontJump
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (old : ℤ → Fin m → ℝ)
    (time z : ℝ) (p : Fin m) : Fin m → ℝ :=
  let k : ℤ := ⌈(z - speeds p * time - origin) / width⌉
  if z = leveque04_uniformInterface origin width k + speeds p * time
  then leveque03_riemannWave basis (old k) (old (k + 1)) p else 0

private theorem tendsto_sub_nhdsLT (z shift : ℝ) :
    Tendsto (fun x : ℝ => x - shift) (𝓝[<] z) (𝓝[<] (z - shift)) := by
  apply tendsto_nhdsWithin_iff.2
  constructor
  · exact (continuous_sub_right shift).continuousAt.continuousWithinAt.tendsto
  · filter_upwards [self_mem_nhdsWithin] with x hx
    exact sub_lt_sub_right hx shift

private theorem tendsto_sub_nhdsGT (z shift : ℝ) :
    Tendsto (fun x : ℝ => x - shift) (𝓝[>] z) (𝓝[>] (z - shift)) := by
  apply tendsto_nhdsWithin_iff.2
  constructor
  · exact (continuous_sub_right shift).continuousAt.continuousWithinAt.tendsto
  · filter_upwards [self_mem_nhdsWithin] with x hx
    exact sub_lt_sub_right hx shift

/-- The actual uniform characteristic evolution takes its left trace as its
point value, for arbitrary times and bilateral data. -/
theorem leveque04_linearUniformEvolution_tendsto_left_at
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) (time z : ℝ) :
    Tendsto
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time) (𝓝[<] z)
      (𝓝 (linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) z time)) := by
  have hmode (p : Fin m) :
      Tendsto (fun x => basis.equivFun
          (leveque04_uniformReconstruction origin width old (x - speeds p * time)) p • basis p)
        (𝓝[<] z)
        (𝓝 (basis.equivFun
          (leveque04_uniformReconstruction origin width old (z - speeds p * time)) p • basis p)) := by
    exact ((leveque04_uniformReconstruction_tendsto_left_at origin width hwidth
      (fun j => basis.equivFun (old j) p) (z - speeds p * time)).comp
      (tendsto_sub_nhdsLT z (speeds p * time))).smul_const (basis p)
  simpa only [linearCharacteristicEvolution] using
    tendsto_finset_sum Finset.univ (fun p _ => hmode p)

/-- The right trace of the actual field adds exactly the sum of all actual
modal waves whose translated interfaces coincide at the selected point. -/
theorem leveque04_linearUniformEvolution_tendsto_right_at
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → Fin m → ℝ) (time z : ℝ) :
    Tendsto
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time) (𝓝[>] z)
      (𝓝 (linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) z time +
        ∑ p, leveque04_uniformModalFrontJump basis speeds origin width old time z p)) := by
  classical
  let index := fun p : Fin m => ⌈(z - speeds p * time - origin) / width⌉
  let rightValue := fun p : Fin m =>
    if z - speeds p * time = leveque04_uniformInterface origin width (index p)
    then basis.equivFun (old (index p + 1)) p else basis.equivFun (old (index p)) p
  have hmode (p : Fin m) :
      Tendsto (fun x => basis.equivFun
          (leveque04_uniformReconstruction origin width old (x - speeds p * time)) p • basis p)
        (𝓝[>] z) (𝓝 (rightValue p • basis p)) := by
    exact ((leveque04_uniformReconstruction_tendsto_right_at origin width hwidth
      (fun j => basis.equivFun (old j) p) (z - speeds p * time)).comp
      (tendsto_sub_nhdsGT z (speeds p * time))).smul_const (basis p)
  have hsum := tendsto_finset_sum Finset.univ (fun p _ => hmode p)
  have hvalue : (∑ p, rightValue p • basis p) =
      linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) z time +
        ∑ p, leveque04_uniformModalFrontJump basis speeds origin width old time z p := by
    rw [linearCharacteristicEvolution, ← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro p _
    change (if z - speeds p * time = leveque04_uniformInterface origin width (index p)
      then basis.equivFun (old (index p + 1)) p else basis.equivFun (old (index p)) p) • basis p =
      basis.equivFun (old (index p)) p • basis p +
        (if z = leveque04_uniformInterface origin width (index p) + speeds p * time
        then leveque03_riemannWave basis (old (index p)) (old (index p + 1)) p else 0)
    by_cases hfront : z = leveque04_uniformInterface origin width (index p) + speeds p * time
    · have hfoot : z - speeds p * time =
          leveque04_uniformInterface origin width (index p) := by linarith
      simp only [if_pos hfront, if_pos hfoot, leveque03_riemannWave,
        leveque03_waveStrength, leveque03_characteristicVariables,
        leveque03_characteristicCoordinates]
      module
    · have hfoot : z - speeds p * time ≠
          leveque04_uniformInterface origin width (index p) := by
        intro heq
        apply hfront
        linarith
      simp only [if_neg hfront, if_neg hfoot, add_zero]
  rw [hvalue] at hsum
  simpa only [linearCharacteristicEvolution] using hsum

end NumStability
