/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics
import Mathlib.Analysis.Calculus.MeanValue

/-!
# Uniqueness for the forward advection Cauchy problem

A classical solution on the open forward-time domain is determined by its
continuous initial trace. The argument follows characteristics in the open
domain and uses continuity to reach the initial-time boundary.
-/

open Set

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- A function constant after an initial time has the same value at the initial time
when it is continuous up to that boundary. -/
private theorem eq_initial_of_deriv_zero
    {g : ℝ → E} {a t : ℝ}
    (hcont : ContinuousOn g (Ici a))
    (hderiv : ∀ s, a < s → HasDerivAt g 0 s)
    (ht : a ≤ t) : g t = g a := by
  by_cases hta : t = a
  · simp [hta]
  · have hta' : a < t := lt_of_le_of_ne ht (Ne.symm hta)
    have hdiff : DifferentiableOn ℝ g (Ioi a) := by
      intro s hs
      exact (hderiv s hs).differentiableAt.differentiableWithinAt
    have hzero : (Ioi a).EqOn (deriv g) 0 := by
      intro s hs
      exact (hderiv s hs).deriv
    have hconst : ∀ s ∈ Ioi a, g s = g t := by
      intro s hs
      exact isOpen_Ioi.is_const_of_deriv_eq_zero isPreconnected_Ioi
        hdiff hzero hs hta'
    have hca : ContinuousWithinAt g (Ioi a) a :=
      (hcont a (le_refl a)).mono Ioi_subset_Ici_self
    have ha : a ∈ closure (Ioi a) := by simp [closure_Ioi]
    exact (hca.eq_const_of_mem_closure ha hconst).symm

/-- A forward classical advection field equals its initial profile along each
characteristic, including the initial-time boundary. -/
theorem forward_characteristic_unique
    {field : ℝ → ℝ → E} {velocity initialTime : ℝ}
    (hcont : ContinuousOn (Function.uncurry field)
      (Set.prod Set.univ (Ici initialTime)))
    (hdiff : DifferentiableOn ℝ (Function.uncurry field)
      (Set.prod Set.univ (Ioi initialTime)))
    (hpde : ∀ x t, initialTime < t →
      IsLinearAdvectionSolutionWithinAt field velocity x t Set.univ (Ioi initialTime))
    {x t : ℝ} (ht : initialTime ≤ t) :
    field x t = field (x - velocity * (t - initialTime)) initialTime := by
  let origin := x - velocity * t
  let g : ℝ → E := fun s => field (origin + velocity * s) s
  have hcurve : Continuous (fun s : ℝ => (origin + velocity * s, s)) := by fun_prop
  have hmap : Set.MapsTo (fun s : ℝ => (origin + velocity * s, s))
      (Ici initialTime) (Set.prod Set.univ (Ici initialTime)) := by
    intro s hs
    exact ⟨Set.mem_univ _, hs⟩
  have hgcont : ContinuousOn g (Ici initialTime) :=
    hcont.comp hcurve.continuousOn hmap
  have hgderiv (s : ℝ) (hs : initialTime < s) : HasDerivAt g 0 s := by
    have hmem : (origin + velocity * s, s) ∈
        Set.prod Set.univ (Ioi initialTime) := ⟨Set.mem_univ _, hs⟩
    have hopen : IsOpen (Set.prod Set.univ (Ioi initialTime)) :=
      (isOpen_univ : IsOpen (Set.univ : Set ℝ)).prod isOpen_Ioi
    have hjoint : DifferentiableAt ℝ (Function.uncurry field)
        (origin + velocity * s, s) :=
      (hdiff _ hmem).differentiableAt (hopen.mem_nhds hmem)
    rcases hpde (origin + velocity * s) s hs with ⟨qt, qx, ht', hx', heq⟩
    have hpdeAt : IsLinearAdvectionSolutionAt field velocity (origin + velocity * s) s :=
      ⟨qt, qx, ht'.hasDerivAt (Ioi_mem_nhds hs),
        hx'.hasDerivAt (Filter.univ_mem), heq⟩
    exact linearAdvection_hasDerivAt_characteristic hjoint hpdeAt
  have hconst : g t = g initialTime :=
    eq_initial_of_deriv_zero hgcont hgderiv ht
  convert hconst using 1 <;> dsimp [g, origin] <;> congr 1 <;> ring

end NumStability
