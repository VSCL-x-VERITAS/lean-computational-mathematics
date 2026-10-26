/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointPhysicalDomain
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointStencilReachability
import ComputationalMathematics.Source.LeVeque.Chapter04.StencilDomains

/-!
# LeVeque Chapter 4: the physical three-point domain

At a fixed physical observation, actual three-point evolution reads only
its initial stencil envelope. Complete finite-volume cells extend it by
half a width; this correction vanishes during fixed-ratio refinement.
The source interval describes possible permitted influence, not essential
dependence of every callback. Projection-update witnesses in the reusable
reachability module establish that each discrete cone site is possible.
-/

open Set Filter MeasureTheory
open scoped Topology
namespace NumStability

/-- Actual numerical dependency contracts at a fixed physical
observation point/time, including the full initial finite-volume cells. -/
def Leveque04ThreePointPhysicalDomainTarget : Prop :=
  (∀ (m : ℕ) (F : ℕ → ℤ → (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ) → Fin m → ℝ)
    (left right : ℝ → Fin m → ℝ) (X T dt width ratio : ℝ) (steps : ℕ) (i : ℤ),
    0 < dt → 0 < width → ratio = dt/width → (steps : ℝ)*dt = T →
    EqOn left right (Icc (X-T/ratio) (X+T/ratio)) →
    centeredStencilEvolution (fun n u j => F n j (u (j-1)) (u j) (u (j+1)))
      (fun j => left (X+((j-i : ℤ) : ℝ)*width)) steps i =
    centeredStencilEvolution (fun n u j => F n j (u (j-1)) (u j) (u (j+1)))
      (fun j => right (X+((j-i : ℤ) : ℝ)*width)) steps i) ∧
  (∀ (m : ℕ) (F : ℕ → ℤ → (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ) → Fin m → ℝ)
    (left right : ℝ → Fin m → ℝ) (X T dt width ratio : ℝ) (steps : ℕ) (i : ℤ),
    0 < dt → 0 < width → ratio = dt/width → (steps : ℝ)*dt = T →
    (∀ j ∈ Icc (i-(steps : ℤ)) (i+(steps : ℤ)),
      IntervalIntegrable left volume
        (X+((j-i : ℤ) : ℝ)*width-width/2) (X+((j-i : ℤ) : ℝ)*width+width/2)) →
    (∀ j ∈ Icc (i-(steps : ℤ)) (i+(steps : ℤ)),
      IntervalIntegrable right volume
        (X+((j-i : ℤ) : ℝ)*width-width/2) (X+((j-i : ℤ) : ℝ)*width+width/2)) →
    EqOn left right (Icc (X-T/ratio-width/2) (X+T/ratio+width/2)) →
    centeredStencilEvolution (fun n u j => F n j (u (j-1)) (u j) (u (j+1)))
      (fun j => oneDimensionalCellAverage left
        (X+((j-i : ℤ) : ℝ)*width-width/2) (X+((j-i : ℤ) : ℝ)*width+width/2)) steps i =
    centeredStencilEvolution (fun n u j => F n j (u (j-1)) (u j) (u (j+1)))
      (fun j => oneDimensionalCellAverage right
        (X+((j-i : ℤ) : ℝ)*width-width/2) (X+((j-i : ℤ) : ℝ)*width+width/2)) steps i) ∧
  (∀ (X T ratio : ℝ) (dt width : ℕ → ℝ) (steps : ℕ → ℕ),
    0 < ratio → (∀ k, 0 < width k) → (∀ k, dt k = ratio*width k) →
    (∀ k, (steps k : ℝ)*dt k = T) → Tendsto width atTop (nhds 0) →
    Tendsto (fun k => X-(steps k : ℝ)*width k-width k/2) atTop (nhds (X-T/ratio)) ∧
    Tendsto (fun k => X+(steps k : ℝ)*width k+width k/2) atTop (nhds (X+T/ratio)))

/-- The independently accepted physical numerical-domain contract. -/
theorem leveque04_threePointPhysicalDomain : Leveque04ThreePointPhysicalDomainTarget := by
  constructor
  · intro m
    exact threePointEvolution_pointInitialization_eq (E := Fin m → ℝ)
  · constructor
    · intro m
      exact threePointEvolution_cellAverageInitialization_eq (E := Fin m → ℝ)
    · exact fixedRatioRefinement_cellSupport_endpoints_tendsto

end NumStability
