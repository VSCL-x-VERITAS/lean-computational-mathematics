/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellConstantMediumTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.115): Maxwell evolution in a constant scalar medium
-/

namespace NumStability.Leveque02Tracer

/-- Substituting constant nonzero scalar material coefficients into the two
source-free Maxwell evolution equations gives the displayed `E,B` system. -/
theorem maxwellConstantMedium : maxwellConstantMediumTarget := by
  intro ε μ D E B H x t hε hμ hDE hBH hAmp hFar hEtime
  have hDtime (i : Fin 3) :
      maxwellTimePartial D i x t = ε * maxwellTimePartial E i x t := by
    have heq : (fun τ => D x τ i) = (fun τ => ε * E x τ i) := by
      funext τ
      have h := congrFun (hDE x τ) i
      simpa only [Pi.smul_apply, smul_eq_mul] using h
    unfold maxwellTimePartial
    rw [heq]
    exact deriv_const_mul_field ε
  have hBspace (i j : Fin 3) :
      maxwellSpatialPartial B i j x t =
        μ * maxwellSpatialPartial H i j x t := by
    have heq : (fun s => B (Function.update x j s) t i) =
        (fun s => μ * H (Function.update x j s) t i) := by
      funext s
      have h := congrFun (hBH (Function.update x j s) t) i
      simpa only [Pi.smul_apply, smul_eq_mul] using h
    unfold maxwellSpatialPartial
    rw [heq]
    exact deriv_const_mul_field μ
  have hCurl (i : Fin 3) :
      maxwellCurl B x t i = μ * maxwellCurl H x t i := by
    fin_cases i <;> simp [maxwellCurl, hBspace] <;> ring
  constructor
  · intro i
    have hAmpI := congrFun hAmp.2.2 i
    rw [hDtime i] at hAmpI
    rw [hCurl i]
    field_simp
    nlinarith
  · intro i
    exact congrFun hFar.2.2 i

end NumStability.Leveque02Tracer
