/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.IntrinsicFrobeniusComparisonTarget
import Mathlib.Analysis.InnerProductSpace.Trace

/-! Bhatia's intrinsic operator/Frobenius comparison on finite-dimensional
complex inner product spaces, including the zero-dimensional space. -/

set_option autoImplicit false
open scoped BigOperators

universe u

namespace NumStability.Bhatia.Chapter01

/-- The comparison uses the actual operator norm and the printed trace
expression; the auxiliary basis is chosen only within the proof. -/
theorem operatorTraceFrobeniusComparison : Targets.operatorTraceFrobeniusComparison.{u} := by
  classical
  intro H _ _ _ A
  let b := stdOrthonormalBasis ℂ H
  let S : ℝ := ∑ i : Fin (Module.finrank ℂ H), ‖A (b i)‖ ^ 2
  have hS : 0 ≤ S := Finset.sum_nonneg fun _ _ => sq_nonneg _
  have htrace :
      (LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)).re = S := by
    rw [LinearMap.trace_eq_sum_inner _ b, Complex.re_sum]
    apply Finset.sum_congr rfl
    intro i _
    simp only [LinearMap.comp_apply, LinearMap.adjoint_inner_right]
    exact inner_self_eq_norm_sq (𝕜 := ℂ) (A (b i))
  have hpoint (x : H) : ‖A x‖ ≤ Real.sqrt S * ‖x‖ := by
    have hsum : ‖A x‖ ≤
        ∑ i : Fin (Module.finrank ℂ H), ‖inner ℂ (b i) x‖ * ‖A (b i)‖ := by
      calc
        ‖A x‖ = ‖∑ i : Fin (Module.finrank ℂ H),
            (inner ℂ (b i) x) • A (b i)‖ := by
          congr 1
          calc
            A x = A (∑ i, (inner ℂ (b i) x) • b i) :=
              congrArg A (b.sum_repr' x).symm
            _ = _ := by simp only [map_sum, map_smul]
        _ ≤ ∑ i, ‖(inner ℂ (b i) x) • A (b i)‖ := norm_sum_le _ _
        _ = _ := by simp only [norm_smul]
    have hcs := Finset.sum_mul_sq_le_sq_mul_sq
      (Finset.univ : Finset (Fin (Module.finrank ℂ H)))
      (fun i => ‖inner ℂ (b i) x‖) (fun i => ‖A (b i)‖)
    have hsq : ‖A x‖ ^ 2 ≤ (Real.sqrt S * ‖x‖) ^ 2 := by
      calc
        ‖A x‖ ^ 2 ≤ (∑ i : Fin (Module.finrank ℂ H),
            ‖inner ℂ (b i) x‖ * ‖A (b i)‖) ^ 2 :=
          pow_le_pow_left₀ (norm_nonneg _) hsum 2
        _ ≤ (∑ i : Fin (Module.finrank ℂ H), ‖inner ℂ (b i) x‖ ^ 2) * S := hcs
        _ = ‖x‖ ^ 2 * S := by rw [b.sum_sq_norm_inner_right]
        _ = (Real.sqrt S * ‖x‖) ^ 2 := by rw [mul_pow, Real.sq_sqrt hS]; ring
    exact (sq_le_sq₀ (norm_nonneg _)
      (mul_nonneg (Real.sqrt_nonneg _) (norm_nonneg _))).mp hsq
  have hlower : ‖A.toContinuousLinearMap‖ ≤ Real.sqrt S :=
    ContinuousLinearMap.opNorm_le_bound _ (Real.sqrt_nonneg _) hpoint
  have hupperSq : S ≤ (Module.finrank ℂ H : ℝ) * ‖A.toContinuousLinearMap‖ ^ 2 := by
    calc
      S ≤ ∑ _i : Fin (Module.finrank ℂ H), ‖A.toContinuousLinearMap‖ ^ 2 := by
        apply Finset.sum_le_sum
        intro i _
        apply pow_le_pow_left₀ (norm_nonneg _)
        simpa only [LinearMap.coe_toContinuousLinearMap, b.norm_eq_one, mul_one]
          using ContinuousLinearMap.le_opNorm A.toContinuousLinearMap (b i)
      _ = _ := by simp
  have hupper : Real.sqrt S ≤
      Real.sqrt (Module.finrank ℂ H : ℝ) * ‖A.toContinuousLinearMap‖ := by
    calc
      Real.sqrt S ≤ Real.sqrt ((Module.finrank ℂ H : ℝ) *
          ‖A.toContinuousLinearMap‖ ^ 2) := Real.sqrt_le_sqrt hupperSq
      _ = _ := by rw [Real.sqrt_mul (Nat.cast_nonneg _), Real.sqrt_sq (norm_nonneg _)]
  change ‖A.toContinuousLinearMap‖ ≤
      Real.sqrt (LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)).re ∧ _
  rw [htrace]
  exact ⟨hlower, hupper⟩

end NumStability.Bhatia.Chapter01
