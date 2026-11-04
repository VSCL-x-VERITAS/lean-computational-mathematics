/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction
import Mathlib.Data.Int.Interval
import Mathlib.Data.Set.Finite.Lattice
import Mathlib.Tactic.Linarith

/-!
# Local finiteness of translated uniform interfaces

A bounded real interval meets only finitely many interfaces of a positive-width
uniform grid. Taking a finite union over characteristic modes preserves this
property for every real time. Any active subset of these potential fronts
inherits the same finiteness, independently of the cell data or CFL regime.
-/

namespace NumStability

/-- One translated uniform lattice has only finitely many points in a bounded
closed interval. The interval may be empty, and the shift is arbitrary. -/
theorem leveque04_translatedUniformInterfaces_finite_inter_Icc
    (origin width shift a b : ℝ) (hwidth : 0 < width) :
    ({z : ℝ | ∃ j : ℤ,
        z = leveque04_uniformInterface origin width j + shift} ∩
      Set.Icc a b).Finite := by
  let lower : ℤ := ⌈(a - origin - shift) / width⌉
  let upper : ℤ := ⌊(b - origin - shift) / width⌋
  have hfinite :
      ((fun j : ℤ => leveque04_uniformInterface origin width j + shift) ''
        Set.Icc lower upper).Finite :=
    (Set.finite_Icc lower upper).image _
  apply hfinite.subset
  rintro z ⟨⟨j, rfl⟩, hz⟩
  refine ⟨j, ⟨?_, ?_⟩, rfl⟩
  · apply Int.ceil_le.mpr
    apply (div_le_iff₀ hwidth).mpr
    dsimp only [leveque04_uniformInterface] at hz
    linarith [hz.1]
  · apply Int.le_floor.mpr
    apply (le_div_iff₀ hwidth).mpr
    dsimp only [leveque04_uniformInterface] at hz
    linarith [hz.2]

/-- The potential fronts of any finite collection of characteristic modes are
locally finite. No time-sign, speed, separation, or CFL condition is needed. -/
theorem leveque04_uniformWaveFronts_finite_inter_Icc
    {m : ℕ} (speeds : Fin m → ℝ) (origin width time a b : ℝ)
    (hwidth : 0 < width) :
    ({z : ℝ | ∃ (p : Fin m) (j : ℤ),
        z = leveque04_uniformInterface origin width j + speeds p * time} ∩
      Set.Icc a b).Finite := by
  have hfinite :
      (⋃ p : Fin m,
        ({z : ℝ | ∃ j : ℤ,
            z = leveque04_uniformInterface origin width j + speeds p * time} ∩
          Set.Icc a b)).Finite :=
    Set.finite_iUnion fun p =>
      leveque04_translatedUniformInterfaces_finite_inter_Icc
        origin width (speeds p * time) a b hwidth
  apply hfinite.subset
  rintro z ⟨⟨p, j, hj⟩, hz⟩
  exact Set.mem_iUnion.mpr ⟨p, ⟨⟨j, hj⟩, hz⟩⟩

/-- Any active-wave subset of the translated interfaces inherits local
finiteness. In particular, no bound on the values of the cell data is needed. -/
theorem leveque04_uniformWaveFrontSubset_finite_inter_Icc
    {m : ℕ} (speeds : Fin m → ℝ) (origin width time a b : ℝ)
    (hwidth : 0 < width) (active : Set ℝ)
    (hactive : active ⊆ {z : ℝ | ∃ (p : Fin m) (j : ℤ),
      z = leveque04_uniformInterface origin width j + speeds p * time}) :
    (active ∩ Set.Icc a b).Finite := by
  apply (leveque04_uniformWaveFronts_finite_inter_Icc
    speeds origin width time a b hwidth).subset
  rintro z ⟨hz, hab⟩
  exact ⟨hactive hz, hab⟩

end NumStability
