/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FirstVariationTarget
import Mathlib.Analysis.Calculus.Deriv.Comp

/-!
# First variation and the linearized conservation law
-/

namespace NumStability.Leveque02Tracer

/-- The actual first variation yields the fixed-background linearized system. -/
theorem firstVariation : firstVariationTarget := by
  intro m admissibleStates background flux derivative perturbation x t qx hflux hqx
  constructor
  · intro direction
    have hline : HasDerivAt
        (fun ε : ℝ => (background : Fin m → ℝ) + ε • direction) direction 0 := by
      simpa only [one_smul] using
        ((hasDerivAt_id (x := (0 : ℝ))).smul_const direction).const_add
          (background : Fin m → ℝ)
    have hbase : (background : Fin m → ℝ) =
        (background : Fin m → ℝ) + (0 : ℝ) • direction := by simp
    have hfluxLine := hflux.comp_hasDerivAt_of_eq 0 hline hbase
    exact ⟨hline, by simpa only [Function.comp_apply, zero_smul, add_zero] using hfluxLine⟩
  · rw [conservationLaw_iff_quasilinearAt perturbation (fun state => derivative state)
      (fun _ => derivative) x t qx hqx derivative.hasFDerivAt]
    simp only [IsQuasilinearConservationLawSolutionAt, LinearMap.toMatrix'_mulVec,
      ContinuousLinearMap.coe_coe]
    constructor
    · rintro ⟨qt, qx', hqt, hqx', hres⟩
      have heq := hqx'.unique hqx
      subst qx'
      exact ⟨qt, hqt, hres⟩
    · rintro ⟨qt, hqt, hres⟩
      exact ⟨qt, qx, hqt, hqx, hres⟩

end NumStability.Leveque02Tracer
