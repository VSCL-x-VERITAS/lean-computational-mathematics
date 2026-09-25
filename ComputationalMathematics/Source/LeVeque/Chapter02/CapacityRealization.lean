/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CapacityRealizationTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.CapacityBalance
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: CapacityRealization

A nonconstant-capacity realization of the tracer balance law.
-/

namespace NumStability.Leveque02Tracer

private def c (x : ℝ) : ℝ := 1 + x
private noncomputable def q (x t : ℝ) : ℝ := 5 + t - x - x ^ 2 / 2
private def f (s : ℝ) : ℝ := s

private theorem q_time (x t : ℝ) :
    HasDerivAt (fun τ => q x τ) 1 t := by
  unfold q
  convert (hasDerivAt_id t).const_add (5 - x - x ^ 2 / 2) using 1
  funext τ
  dsimp [id]
  ring

private theorem q_space (x t : ℝ) :
    HasDerivAt (fun ξ => q ξ t) (-(1 + x)) x := by
  have hpow : HasDerivAt (fun ξ : ℝ => ξ ^ 2) (2 * x) x := by
    simpa [id, mul_comm] using (hasDerivAt_id x).pow 2
  have hlin : HasDerivAt (fun ξ : ℝ => 5 + t - ξ) (-1) x := by
    simpa [id] using (hasDerivAt_id x).const_sub (5 + t)
  unfold q
  convert hlin.sub (hpow.const_mul (1 / 2 : ℝ)) using 1
  funext ξ
  dsimp
  ring
  ring

theorem capacityRealization : capacityRealizationTarget := by
  refine ⟨?_, capacityBalance, c, q, f, ?_, ?_⟩
  · intro capacity state flux
    constructor <;> rfl
  · norm_num [c]
  · intro x hx t ht
    have hx0 : 0 < x := hx.1
    have hx1 : x < 1 := hx.2
    have ht0 : 0 < t := ht.1
    have hsq : x ^ 2 < 1 := by
      nlinarith [mul_pos hx0 (sub_pos.mpr hx1)]
    have hqpos : 0 < q x t := by
      dsimp [q]
      nlinarith
    have hcpos : 0 < c x := by
      dsimp [c]
      linarith
    have hdist : (capacityStateFlux (c x) (q x t) f).1 ≠ q x t := by
      simp only [capacityStateFlux]
      intro heq
      have hp : 0 < x * q x t := mul_pos hx0 hqpos
      dsimp [c] at heq
      nlinarith
    have hweighted :
        HasDerivAt (fun τ => (capacityStateFlux (c x) (q x τ) f).1) (c x) t := by
      simpa [capacityStateFlux] using (q_time x t).const_mul (c x)
    have hflux :
        HasDerivAt (fun ξ => (capacityStateFlux (c ξ) (q ξ t) f).2)
          (-(1 + x)) x := by
      simpa [capacityStateFlux, f] using q_space x t
    refine ⟨hcpos, hqpos, hdist, 1, c x, -(1 + x), ?_, ?_, q_time x t,
      hweighted, hflux, ?_⟩
    · norm_num
    · linarith
    · simp [c]

#print axioms q_time
#print axioms q_space
#print axioms capacityRealization

end NumStability.Leveque02Tracer
