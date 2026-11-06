/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Orthonormal

/-!
# Uniqueness of positively normalized QR factorizations

Two orthonormal expansions of the same ordered finite family have the same
orthonormal vectors and triangular coefficients when their diagonal entries
are strictly positive real scalars. No independence or dimension hypothesis
is needed once both factorizations are supplied, and the empty family is included.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]

/-- The coefficients of an orthonormal expansion are recovered by inner products. -/
theorem orthonormal_expansion_coefficient {ι : Type*} [Fintype ι]
    {Q : ι → H} (hQ : Orthonormal 𝕜 Q) {x : H} {r : ι → 𝕜}
    (hx : x = ∑ i, r i • Q i) (i : ι) : r i = inner 𝕜 (Q i) x := by
  rw [hx]
  exact (hQ.inner_right_fintype r i).symm

/-- Upper-triangular orthonormal factorizations of the same finite input are
unique when each diagonal entry is an embedded strictly positive real. -/
theorem qr_unique_of_pos_diagonal {n : ℕ} (X Q P : Fin n → H)
    (R S : Fin n → Fin n → 𝕜)
    (hQ : Orthonormal 𝕜 Q) (hP : Orthonormal 𝕜 P)
    (hR : ∀ j, X j = ∑ i, R i j • Q i)
    (hS : ∀ j, X j = ∑ i, S i j • P i)
    (hRt : ∀ i j, j < i → R i j = 0)
    (hSt : ∀ i j, j < i → S i j = 0)
    (hRd : ∀ j, ∃ d : ℝ, 0 < d ∧ R j j = (d : 𝕜))
    (hSd : ∀ j, ∃ d : ℝ, 0 < d ∧ S j j = (d : 𝕜)) :
    Q = P ∧ R = S := by
  classical
  have coeffR (i j : Fin n) : R i j = inner 𝕜 (Q i) (X j) :=
    orthonormal_expansion_coefficient hQ (hR j) i
  have coeffS (i j : Fin n) : S i j = inner 𝕜 (P i) (X j) :=
    orthonormal_expansion_coefficient hP (hS j) i
  have hQP : ∀ j, Q j = P j := by
    intro j
    refine (show WellFounded ((· < ·) : Fin n → Fin n → Prop) from
      wellFounded_lt).induction (C := fun k : Fin n => Q k = P k) j ?_
    intro j ih
    have hprevious (i : Fin n) (hi : i < j) : R i j = S i j := by
      rw [coeffR, coeffS, ih i hi]
    have hsum : (∑ i, (R i j • Q i - S i j • P i)) = 0 := by
      rw [Finset.sum_sub_distrib, ← hR j, ← hS j, sub_self]
    have hisolate : (∑ i, (R i j • Q i - S i j • P i)) =
        R j j • Q j - S j j • P j := by
      apply Finset.sum_eq_single_of_mem j (Finset.mem_univ j)
      intro i _ hij
      rcases lt_or_gt_of_ne hij with hi | hi
      · rw [hprevious i hi, ih i hi, sub_self]
      · simp only [hRt i j hi, hSt i j hi, zero_smul, sub_self]
    have hdiag : R j j • Q j = S j j • P j :=
      sub_eq_zero.mp (hisolate.symm.trans hsum)
    obtain ⟨d, hd, hdiagR⟩ := hRd j
    obtain ⟨e, he, hdiagS⟩ := hSd j
    have hde : d = e := by
      have hn := congrArg norm hdiag
      simpa only [hdiagR, hdiagS, norm_smul, RCLike.norm_ofReal,
        abs_of_pos hd, abs_of_pos he, hQ.norm_eq_one, hP.norm_eq_one,
        mul_one] using hn
    have hd0 : (d : 𝕜) ≠ 0 := by
      exact_mod_cast ne_of_gt hd
    rw [hdiagR, hdiagS, ← hde] at hdiag
    have hc := congrArg (fun v : H => (d : 𝕜)⁻¹ • v) hdiag
    simpa only [smul_smul, inv_mul_cancel₀ hd0, one_smul] using hc
  refine ⟨funext hQP, ?_⟩
  funext i j
  rw [coeffR, coeffS, hQP i]

end NumStability
