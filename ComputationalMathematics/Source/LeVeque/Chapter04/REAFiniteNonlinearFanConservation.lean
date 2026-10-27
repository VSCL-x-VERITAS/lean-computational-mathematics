/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAFiniteNonlinearFanGluing
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleAEEq
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface

/-!
# Conservation transfer for a finite nonadditive fan assembly

An exact certified evolution transfers its rectangle conservation law to a
finite fan gluing if the fields agree away from spatially null front sets
and their physical fluxes agree almost everywhere in time at every face.
The remaining Riemann-selection problem is to establish those hypotheses.
-/

open MeasureTheory

namespace NumStability

/-- The moving front points of a finite family of selected Riemann fans. -/
noncomputable def leveque04_finiteFanFronts {ι : Type*}
    (indices : Finset ι) (front : ι → ℝ → Finset ℝ) (t : ℝ) : Set ℝ := by
  classical
  exact ↑(indices.biUnion (fun i => front i t))

/-- Finitely many fan fronts do not alter a spatial cell integral. -/
theorem leveque04_finiteFanFronts_measure_zero {ι : Type*}
    (indices : Finset ι) (front : ι → ℝ → Finset ℝ) (t : ℝ) :
    volume (leveque04_finiteFanFronts indices front t) = 0 := by
  classical
  unfold leveque04_finiteFanFronts
  exact (Finset.finite_toSet _).measure_zero volume

/-- Transfer a nonlinear rectangle conservation law across finitely many
noninteracting fan interiors, subject to off-front equality and face traces. -/
theorem leveque04_finiteFanGluing_rectangleSolution_of_ae
    {ι : Type*} {m : ℕ}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (indices : Finset ι) (fan : ι → ℝ → Set ℝ)
    (background : ℝ → ℝ → (Fin m → ℝ))
    (riemann : ι → ℝ → ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (front : ℝ → Set ℝ)
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (hfront : ∀ t, volume (front t) = 0)
    (hoff : ∀ t x, x ∉ front t →
      q x t = leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x)
    (hface : ∀ x : ℝ, ∀ᵐ t : ℝ ∂volume,
      law.physicalFlux (q x t) =
        law.physicalFlux
          (leveque04_finiteFanGluing indices (fun i => fan i t)
            (fun y => background y t) (fun i y => riemann i y t) x)) :
    IsRectangleConservationLawSolution
      (fun x t => leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x)
      law.physicalFlux := by
  apply rectangleSolution_congr_ae q _ law.physicalFlux hq
  · intro t
    filter_upwards [compl_mem_ae_iff.mpr (hfront t)] with x hx
    exact hoff t x hx
  · exact hface

/-- For finitely many point fronts, the spatial null-set condition in the
finite-fan conservation transfer follows from finiteness. -/
theorem leveque04_finiteFanGluing_rectangleSolution_of_finite_fronts
    {ι : Type*} {m : ℕ}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (indices : Finset ι) (fan : ι → ℝ → Set ℝ)
    (background : ℝ → ℝ → (Fin m → ℝ))
    (riemann : ι → ℝ → ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (front : ι → ℝ → Finset ℝ)
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (hoff : ∀ t x, x ∉ leveque04_finiteFanFronts indices front t →
      q x t = leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x)
    (hface : ∀ x : ℝ, ∀ᵐ t : ℝ ∂volume,
      law.physicalFlux (q x t) =
        law.physicalFlux
          (leveque04_finiteFanGluing indices (fun i => fan i t)
            (fun y => background y t) (fun i y => riemann i y t) x)) :
    IsRectangleConservationLawSolution
      (fun x t => leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x)
      law.physicalFlux := by
  exact leveque04_finiteFanGluing_rectangleSolution_of_ae
    law indices fan background riemann q
    (leveque04_finiteFanFronts indices front)
    hq (leveque04_finiteFanFronts_measure_zero indices front)
    hoff hface

/-- When each fixed face meets moving fronts only on a time-null set,
off-front equality also supplies the required physical-flux trace. -/
theorem leveque04_finiteFanGluing_rectangleSolution_of_temporally_null_fronts
    {ι : Type*} {m : ℕ}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (indices : Finset ι) (fan : ι → ℝ → Set ℝ)
    (background : ℝ → ℝ → (Fin m → ℝ))
    (riemann : ι → ℝ → ℝ → (Fin m → ℝ))
    (q : ℝ → ℝ → (Fin m → ℝ))
    (front : ι → ℝ → Finset ℝ)
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (hoff : ∀ t x, x ∉ leveque04_finiteFanFronts indices front t →
      q x t = leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x)
    (hfrontTime : ∀ x : ℝ,
      volume {t : ℝ | x ∈ leveque04_finiteFanFronts indices front t} = 0) :
    IsRectangleConservationLawSolution
      (fun x t => leveque04_finiteFanGluing indices (fun i => fan i t)
        (fun y => background y t) (fun i y => riemann i y t) x)
      law.physicalFlux := by
  apply leveque04_finiteFanGluing_rectangleSolution_of_finite_fronts
    law indices fan background riemann q front hq hoff
  intro x
  filter_upwards [compl_mem_ae_iff.mpr (hfrontTime x)] with t ht
  exact congrArg law.physicalFlux (hoff t x ht)

end NumStability
