/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ForwardCauchy
import ComputationalMathematics.Source.LeVeque.Chapter02.AdvectionCauchyTarget

/-!
# LeVeque's whole-line advection initial-value problem

The translated initial profile is a forward classical solution and is unique
among solutions continuous up to the initial-time boundary.
-/

namespace NumStability.Leveque02Tracer

/-- The audited whole-line advection Cauchy target. -/
theorem advectionCauchy : advectionCauchyTarget := by
  intro E instAdd instSpace initial velocity initialTime hinitial
  let solution : ℝ → ℝ → E :=
    fun x t => initial (x - velocity * (t - initialTime))
  have hcoord : Differentiable ℝ (fun p : ℝ × ℝ =>
      p.1 - velocity * (p.2 - initialTime)) := by fun_prop
  have hdiff : Differentiable ℝ (Function.uncurry solution) := by
    simpa only [solution, Function.uncurry_apply_pair] using hinitial.comp hcoord
  have hcont : ContinuousOn (Function.uncurry solution)
      (Set.prod Set.univ (Set.Ici initialTime)) := hdiff.continuous.continuousOn
  have hdiffOn : DifferentiableOn ℝ (Function.uncurry solution)
      (Set.prod Set.univ (Set.Ioi initialTime)) := hdiff.differentiableOn
  have hinit (x : ℝ) : solution x initialTime = initial x := by
    simp [solution]
  let shifted : ℝ → E := fun y => initial (y + velocity * initialTime)
  have hshift : Differentiable ℝ shifted := by
    apply hinitial.comp
    fun_prop
  have hsolution : solution = travelingWave shifted velocity := by
    funext x t
    dsimp [solution, shifted, travelingWave]
    congr 1
    ring
  have hpde (x t : ℝ) (ht : initialTime < t) :
      IsLinearAdvectionSolutionWithinAt solution velocity x t
        Set.univ (Set.Ioi initialTime) := by
    rw [hsolution]
    rcases travelingWave_isLinearAdvectionSolutionAt velocity x t
      (hshift (x - velocity * t)).hasDerivAt with ⟨qt, qx, htime, hspace, hzero⟩
    exact ⟨qt, qx, htime.hasDerivWithinAt, hspace.hasDerivWithinAt, hzero⟩
  refine ⟨hcont, hdiffOn, hinit, hpde, ?_⟩
  intro field hfcont hfdiff hfpde hfinit x t ht
  rw [forward_characteristic_unique hfcont hfdiff hfpde ht, hfinit]

end NumStability.Leveque02Tracer
