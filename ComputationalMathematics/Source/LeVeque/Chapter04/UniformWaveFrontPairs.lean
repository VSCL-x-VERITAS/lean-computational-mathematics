/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LinearUniformWaveJump

/-!
# Finite actual mode-interface pairs at a characteristic front

Each mode contributes at most one interface at a fixed point and time. The
finite selection below enumerates all actual pairs when the width is positive,
and its actual wave sum is the modal right-trace correction.
-/

open scoped BigOperators

namespace NumStability

/-- The finite mode-interface pairs whose translated fronts reach a point.
The index is selected independently at each mode's actual characteristic foot. -/
noncomputable def leveque04_uniformWaveFrontPairs
    {m : ℕ} (speeds : Fin m → ℝ) (origin width time z : ℝ) :
    Finset (Fin m × ℤ) :=
  let index := fun p : Fin m => ⌈(z - speeds p * time - origin) / width⌉
  (Finset.univ.filter fun p =>
    z = leveque04_uniformInterface origin width (index p) + speeds p * time).image
      (fun p => (p, index p))

/-- Positive width makes the finite selection enumerate exactly the actual
translated interface pairs, including all coincidences between modes. -/
theorem leveque04_uniformWaveFrontPairs_mem_iff
    {m : ℕ} (speeds : Fin m → ℝ) (origin width time z : ℝ) (hwidth : 0 < width)
    (p : Fin m) (j : ℤ) :
    (p, j) ∈ leveque04_uniformWaveFrontPairs speeds origin width time z ↔
      z = leveque04_uniformInterface origin width j + speeds p * time := by
  classical
  let index := fun q : Fin m => ⌈(z - speeds q * time - origin) / width⌉
  change (p, j) ∈ (Finset.univ.filter fun q =>
    z = leveque04_uniformInterface origin width (index q) + speeds q * time).image
      (fun q => (q, index q)) ↔ _
  constructor
  · intro h
    obtain ⟨q, hq, heq⟩ := Finset.mem_image.mp h
    have hqp : q = p := congrArg Prod.fst heq
    subst q
    have hindex : index p = j := congrArg Prod.snd heq
    simpa only [hindex] using (Finset.mem_filter.mp hq).2
  · intro hfront
    have hfoot : z - speeds p * time = leveque04_uniformInterface origin width j := by
      linarith
    have hindex : index p = j := by
      dsimp only [index]
      rw [hfoot]
      simp [leveque04_uniformInterface, hwidth.ne']
    apply Finset.mem_image.mpr
    refine ⟨p, Finset.mem_filter.mpr ⟨Finset.mem_univ p, ?_⟩, ?_⟩
    · simpa only [hindex] using hfront
    · exact Prod.ext rfl hindex

/-- Projection to the mode is injective on the selected pairs: a mode never
contributes two different interface indices to the same selected point. -/
theorem leveque04_uniformWaveFrontPairs_fst_injOn
    {m : ℕ} (speeds : Fin m → ℝ) (origin width time z : ℝ) :
    Set.InjOn Prod.fst
      (↑(leveque04_uniformWaveFrontPairs speeds origin width time z) : Set (Fin m × ℤ)) := by
  classical
  intro a ha b hb hab
  obtain ⟨p, _, rfl⟩ := Finset.mem_image.mp ha
  obtain ⟨q, _, rfl⟩ := Finset.mem_image.mp hb
  change p = q at hab
  subst q
  rfl

/-- There are at most as many coincident actual pairs as characteristic modes. -/
theorem leveque04_uniformWaveFrontPairs_card_le
    {m : ℕ} (speeds : Fin m → ℝ) (origin width time z : ℝ) :
    (leveque04_uniformWaveFrontPairs speeds origin width time z).card ≤ m := by
  classical
  unfold leveque04_uniformWaveFrontPairs
  exact Finset.card_image_le.trans (by simpa using (Finset.card_filter_le
    (s := (Finset.univ : Finset (Fin m)))
    (p := fun p => z = leveque04_uniformInterface origin width
      ⌈(z - speeds p * time - origin) / width⌉ + speeds p * time)))

/-- Summing actual waves over the finite selected pairs gives exactly the
modal right-trace correction, with coincident families each included once. -/
theorem leveque04_uniformWaveFrontPairs_sum_waves
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (origin width : ℝ) (old : ℤ → Fin m → ℝ) (time z : ℝ) :
    (∑ pair ∈ leveque04_uniformWaveFrontPairs speeds origin width time z,
      leveque03_riemannWave basis (old pair.2) (old (pair.2 + 1)) pair.1) =
      ∑ p, leveque04_uniformModalFrontJump basis speeds origin width old time z p := by
  classical
  let index := fun p : Fin m => ⌈(z - speeds p * time - origin) / width⌉
  have hinj : Function.Injective (fun p : Fin m => (p, index p)) :=
    fun _ _ heq => congrArg Prod.fst heq
  change (∑ pair ∈ (Finset.univ.filter fun p =>
      z = leveque04_uniformInterface origin width (index p) + speeds p * time).image
        (fun p => (p, index p)),
      leveque03_riemannWave basis (old pair.2) (old (pair.2 + 1)) pair.1) = _
  rw [Finset.sum_image (fun _ _ _ _ heq => hinj heq), Finset.sum_filter]
  rfl

end NumStability
