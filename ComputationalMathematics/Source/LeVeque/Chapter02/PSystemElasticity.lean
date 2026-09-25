/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearPWaveSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.PSystemElasticityTarget
import Mathlib.Tactic

/-!
# The structural p-system analogy for nonlinear longitudinal elasticity
-/

namespace NumStability.Leveque02Tracer

/-- The sign-reversed, density-normalized stress law gives the same two
pointwise equations as the generic p-system at a common coordinate. -/
theorem pSystemElasticity : pSystemElasticityTarget := by
  refine ⟨?_, ?_, ?_⟩
  · intro strain velocity stressLaw density x t strainTime velocitySpace
      velocityTime stressSpace hdensity hstrain hvelocitySpace hvelocityTime hstress
    dsimp
    have hdensity_ne : density ≠ 0 := ne_of_gt hdensity
    have hpressure :
        HasDerivAt (fun y => -stressLaw (strain y t) / density)
          (-stressSpace / density) x := by
      exact hstress.neg.div_const density
    refine ⟨hpressure, ?_⟩
    have hscaled :
        (density * velocityTime - stressSpace = 0) ↔
        (velocityTime + -stressSpace / density = 0) := by
      constructor
      · intro h
        calc
          velocityTime + -stressSpace / density =
              (density * velocityTime - stressSpace) / density := by
            field_simp [hdensity_ne]
            ring
          _ = 0 := by rw [h]; simp
      · intro h
        have hmul := congrArg (fun z : ℝ => z * density) h
        field_simp [hdensity_ne] at hmul
        linarith
    constructor
    · rintro ⟨hkinematic, hmomentum⟩
      exact ⟨strainTime, velocitySpace, velocityTime,
        -stressSpace / density, hstrain, hvelocitySpace,
        hvelocityTime, hpressure, hkinematic, hscaled.mp hmomentum⟩
    · rintro ⟨st, vs, vt, ps, hst, hvs, hvt, hps, hkinematic, hmomentum⟩
      have hst_eq : st = strainTime := hst.unique hstrain
      have hvs_eq : vs = velocitySpace := hvs.unique hvelocitySpace
      have hvt_eq : vt = velocityTime := hvt.unique hvelocityTime
      have hps_eq : ps = -stressSpace / density := hps.unique hpressure
      subst st
      subst vs
      subst vt
      subst ps
      exact ⟨hkinematic, hscaled.mpr hmomentum⟩
  · intro stressLaw e
    simp
  · refine ⟨(1 : ℝ), (-(1 / 2) : ℝ), ?_⟩
    norm_num

end NumStability.Leveque02Tracer
