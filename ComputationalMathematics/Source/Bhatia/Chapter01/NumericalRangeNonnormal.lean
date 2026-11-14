/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.NumericalRangeNonnormalMatrixTarget

/-!
# Bhatia Chapter I: a nonnormal numerical range larger than the eigenvalue hull

Exercise I.2.9(i), printed page 8. The `2 × 2` Jordan block `J = !![0, 1; 0, 0]`
is not normal: `J J*` and `J* J` differ in the top-left entry. Its only
eigenvalue is `0`, so the eigenvalue hull is at most `{0}`. The numerical range
contains `0`, at the first basis vector, and `1/2`, at `(1, 1)/√2`.
-/

set_option autoImplicit false

open Matrix

namespace NumStability.Bhatia.Chapter01

/-- Exercise I.2.9(i): the Jordan block is nonnormal, and its numerical range is
strictly bigger than the convex hull of its eigenvalues. -/
theorem numericalRangeNonnormalMatrixStrict : Targets.numericalRangeNonnormalMatrixStrict := by
  refine ⟨2, !![0, 1; 0, 0], ?_, ?_⟩
  · intro h
    have h0 := congrFun (congrFun h 0) 0
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply] at h0
  · have heig : {lam : ℂ | ∃ v : Fin 2 → ℂ, v ≠ 0 ∧
        (!![0, 1; 0, 0] : Matrix (Fin 2) (Fin 2) ℂ).mulVec v = lam • v} ⊆ {0} := by
      rintro lam ⟨v, hv, hAv⟩
      by_contra hlam
      have hlam' : lam ≠ 0 := hlam
      have h0 := congrFun hAv 0
      have h1 := congrFun hAv 1
      simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two] at h0 h1
      have hv1 : v 1 = 0 := by
        rcases h1 with h1 | h1
        · exact absurd h1 hlam'
        · exact h1
      have hv0 : v 0 = 0 := by
        rw [hv1] at h0
        rcases mul_eq_zero.1 h0.symm with h | h
        · exact absurd h hlam'
        · exact h
      exact hv (funext fun i => by fin_cases i <;> simp [hv0, hv1])
    have hzero : (0 : ℂ) ∈ {z : ℂ | ∃ x : Fin 2 → ℂ, star x ⬝ᵥ x = 1 ∧
        z = star x ⬝ᵥ (!![0, 1; 0, 0] : Matrix (Fin 2) (Fin 2) ℂ).mulVec x} :=
      ⟨Pi.single 0 1, by simp [dotProduct, Fin.sum_univ_two],
        by simp [dotProduct, Matrix.mulVec, Fin.sum_univ_two]⟩
    have hhull : convexHull ℝ {lam : ℂ | ∃ v : Fin 2 → ℂ, v ≠ 0 ∧
        (!![0, 1; 0, 0] : Matrix (Fin 2) (Fin 2) ℂ).mulVec v = lam • v} ⊆ {0} := by
      calc _ ⊆ convexHull ℝ ({0} : Set ℂ) := convexHull_mono heig
        _ = {0} := convexHull_singleton 0
    refine ⟨hhull.trans (Set.singleton_subset_iff.2 hzero), fun hsub => ?_⟩
    set c : ℂ := (((Real.sqrt 2)⁻¹ : ℝ) : ℂ)
    have hc : (starRingEnd ℂ) c * c = 1 / 2 := by
      have hs : Real.sqrt 2 * Real.sqrt 2 = 2 := Real.mul_self_sqrt (by norm_num)
      simp only [c, Complex.conj_ofReal, ← Complex.ofReal_mul]
      rw [← mul_inv, hs]; push_cast; ring
    have hmem : (1 / 2 : ℂ) ∈ {z : ℂ | ∃ x : Fin 2 → ℂ, star x ⬝ᵥ x = 1 ∧
        z = star x ⬝ᵥ (!![0, 1; 0, 0] : Matrix (Fin 2) (Fin 2) ℂ).mulVec x} := by
      refine ⟨![c, c], ?_, ?_⟩
      · simp only [dotProduct, Fin.sum_univ_two, Pi.star_apply, Matrix.cons_val_zero,
          Matrix.cons_val_one, Matrix.cons_val_fin_one]
        rw [← Complex.star_def] at hc; rw [hc]; norm_num
      · simp only [dotProduct, Matrix.mulVec, Fin.sum_univ_two]
        simp [hc]
    have := hhull (hsub hmem)
    norm_num at this

end NumStability.Bhatia.Chapter01
