/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ScalarAdvectionCauchyTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.AdvectionCauchy
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: ScalarAdvectionCauchy

Classical Cauchy solution for scalar constant-velocity advection.
-/

namespace NumStability.Leveque02Tracer

theorem scalarAdvectionCauchy : scalarAdvectionCauchyTarget := by
  intro initial velocity initialTime hinitial
  let solution : ℝ → ℝ → ℝ :=
    fun x t => initial (x - velocity * (t - initialTime))
  have hcoord : ContDiff ℝ 1 (fun p : ℝ × ℝ =>
      p.1 - velocity * (p.2 - initialTime)) := by fun_prop
  have hcd : ContDiff ℝ 1 (Function.uncurry solution) := by
    simpa only [solution, Function.uncurry_apply_pair] using hinitial.comp hcoord
  have hdiffInitial : Differentiable ℝ initial :=
    hinitial.differentiable (by norm_num)
  obtain ⟨hcont, _hdiff, hinit, hpde, hunique⟩ :=
    advectionCauchy ℝ initial velocity initialTime hdiffInitial
  refine ⟨hcont, hcd.contDiffOn, hinit, hpde, ?_⟩
  intro field hfcont hfcd hfpde hfinit x t ht
  exact hunique field hfcont (hfcd.differentiableOn (by norm_num))
    hfpde hfinit x t ht

end NumStability.Leveque02Tracer
