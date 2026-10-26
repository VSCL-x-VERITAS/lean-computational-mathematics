/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.MovingFrontTimeNull
import ComputationalMathematics.Source.LeVeque.Chapter04.REAFiniteNonlinearFanConservation

/-!
# Time-null traces of finite nonstationary Riemann fronts

A fixed spatial face meets each affine front with nonzero speed at no more
than one time. A finite family of such fronts has a time-null trace there.
Stationary fronts require a separate physical-flux compatibility argument.
-/

open MeasureTheory

namespace NumStability

/-- A fixed point meets a nonstationary affine front only on a time-null set. -/
theorem leveque04_affineFront_time_null
    (origin speed x : ℝ) (hspeed : speed ≠ 0) :
    volume {t : ℝ | x = origin + speed * t} = 0 := by
  have hsubset : {t : ℝ | x = origin + speed * t} ⊆
      ({(x - origin) / speed} : Set ℝ) := by
    intro t ht
    simp only [Set.mem_setOf_eq] at ht
    simp only [Set.mem_singleton_iff]
    apply (eq_div_iff hspeed).2
    linear_combination ht.symm
  exact measure_mono_null hsubset (measure_singleton _)

/-- Every fixed face meets a finite family of nonstationary affine fronts
only on a time-null set. -/
theorem leveque04_finiteAffineFronts_time_null
    {ι κ : Type*} (indices : Finset ι) (faces : ι → Finset κ)
    (origin speed : ι → κ → ℝ)
    (hspeed : ∀ i ∈ indices, ∀ p ∈ faces i, speed i p ≠ 0)
    (x : ℝ) :
    volume {t : ℝ | x ∈ leveque04_finiteFanFronts indices
      (fun i t => (faces i).image (fun p => origin i p + speed i p * t)) t} = 0 := by
  classical
  have hsingle (i : ι) (hi : i ∈ indices) (p : κ) (hp : p ∈ faces i) :
      ∀ᵐ t : ℝ ∂volume, x ≠ origin i p + speed i p * t := by
    apply ae_iff.mpr
    simpa only [not_not] using
      leveque04_affineFront_time_null (origin i p) (speed i p) x
        (hspeed i hi p hp)
  have hall : ∀ᵐ t : ℝ ∂volume,
      ∀ i ∈ indices, ∀ p ∈ faces i,
        x ≠ origin i p + speed i p * t := by
    apply (Finset.eventually_all indices).2
    intro i hi
    apply (Finset.eventually_all (faces i)).2
    intro p hp
    exact hsingle i hi p hp
  have havoid : ∀ᵐ t : ℝ ∂volume,
      x ∉ leveque04_finiteFanFronts indices
        (fun i t => (faces i).image (fun p => origin i p + speed i p * t)) t := by
    filter_upwards [hall] with t ht hmem
    change x ∈ (indices.biUnion (fun i =>
      (faces i).image (fun p => origin i p + speed i p * t))) at hmem
    obtain ⟨i, hi, himage⟩ := Finset.mem_biUnion.mp hmem
    obtain ⟨p, hp, heq⟩ := Finset.mem_image.mp himage
    exact ht i hi p hp heq.symm
  simpa only [not_not] using (ae_iff.mp havoid)

/-- A certified nonlinear evolution transfers conservation to its finite
fan assembly when all moving fronts have nonzero speed and the fields agree
away from those fronts. -/
theorem leveque04_finiteFanGluing_rectangleSolution_of_affine_fronts
    {ι κ : Type*} {m : ℕ}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (indices : Finset ι) (faces : ι → Finset κ)
    (origin speed : ι → κ → ℝ)
    (hspeed : ∀ i ∈ indices, ∀ p ∈ faces i, speed i p ≠ 0)
    (fan : ι → ℝ → Set ℝ)
    (background : ℝ → ℝ → (Fin m → ℝ))
    (riemann : ι → ℝ → ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (hoff : ∀ t x, x ∉ leveque04_finiteFanFronts indices
        (fun i t => (faces i).image
          (fun p => origin i p + speed i p * t)) t →
      q x t = leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x) :
    IsRectangleConservationLawSolution
      (fun x t => leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x)
      law.physicalFlux := by
  apply leveque04_finiteFanGluing_rectangleSolution_of_temporally_null_fronts
    law indices fan background riemann q
    (fun i t => (faces i).image (fun p => origin i p + speed i p * t))
    hq hoff
  intro x
  exact leveque04_finiteAffineFronts_time_null
    indices faces origin speed hspeed x

/-- A finite family of affine fronts also transfers rectangle conservation
when stationary fronts have matching physical flux at each fixed face. -/
theorem leveque04_finiteFanGluing_rectangleSolution_of_affine_fronts_with_stationaryFlux
    {ι κ : Type*} {m : ℕ}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (indices : Finset ι) (faces : ι → Finset κ)
    (origin speed : ι → κ → ℝ)
    (fan : ι → ℝ → Set ℝ)
    (background : ℝ → ℝ → (Fin m → ℝ))
    (riemann : ι → ℝ → ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (hoff : ∀ t x, x ∉ leveque04_finiteFanFronts indices
        (fun i t => (faces i).image
          (fun p => origin i p + speed i p * t)) t →
      q x t = leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x)
    (hstationary : ∀ x t,
      (∃ i ∈ indices, ∃ p ∈ faces i,
        speed i p = 0 ∧ x = origin i p) →
      law.physicalFlux (q x t) =
        law.physicalFlux
          (leveque04_finiteFanGluing indices (fun i => fan i t)
            (fun y => background y t) (fun i y => riemann i y t) x)) :
    IsRectangleConservationLawSolution
      (fun x t => leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x)
      law.physicalFlux := by
  apply leveque04_finiteFanGluing_rectangleSolution_of_finite_fronts
    law indices fan background riemann q
    (fun i t => (faces i).image
      (fun p => origin i p + speed i p * t)) hq hoff
  intro x
  have hall : ∀ᵐ t : ℝ ∂volume,
      ∀ i ∈ indices, ∀ p ∈ faces i,
        x ≠ origin i p + speed i p * t ∨
          (speed i p = 0 ∧ x = origin i p) := by
    apply (Finset.eventually_all indices).2
    intro i hi
    apply (Finset.eventually_all (faces i)).2
    intro p hp
    exact affineMovingFront_ae_ne_or_stationary
      (origin i p) (speed i p) x
  filter_upwards [hall] with t ht
  by_cases hs : ∃ i ∈ indices, ∃ p ∈ faces i,
      speed i p = 0 ∧ x = origin i p
  · exact hstationary x t hs
  · have hnot : x ∉ leveque04_finiteFanFronts indices
        (fun i t => (faces i).image
          (fun p => origin i p + speed i p * t)) t := by
      intro hmem
      change x ∈ (indices.biUnion (fun i =>
        (faces i).image (fun p => origin i p + speed i p * t))) at hmem
      obtain ⟨i, hi, himage⟩ := Finset.mem_biUnion.mp hmem
      obtain ⟨p, hp, heq⟩ := Finset.mem_image.mp himage
      rcases ht i hi p hp with hn | hstat
      · exact hn heq.symm
      · exact hs ⟨i, hi, p, hp, hstat⟩
    exact congrArg law.physicalFlux (hoff t x hnot)

end NumStability
