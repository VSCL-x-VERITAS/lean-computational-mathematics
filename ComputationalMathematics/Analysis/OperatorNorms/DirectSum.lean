/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.ProdL2
import Mathlib.Analysis.Normed.Operator.Prod
import Mathlib.Tactic.Ring

/-!
# Operator norms of Hilbert direct sums

The diagonal operator on the genuine `WithLp 2` product has operator norm equal
to the maximum of the two component operator norms. The proof uses the squared
product norm for its upper bound and the two coordinate embeddings for its
lower bounds. It does not require a unit vector, finite dimension or nonzero
summands.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 E F : Type*} [RCLike 𝕜]
  [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  [NormedAddCommGroup F] [NormedSpace 𝕜 F]

/-- The actual L2 diagonal sum has the maximum of the two operator norms,
including when either or both summands are the zero space. -/
theorem l2_direct_sum_opNorm (f : E →L[𝕜] E) (g : F →L[𝕜] F) :
    let L := WithLp.prodContinuousLinearEquiv 2 𝕜 E F
    ‖L.symm.toContinuousLinearMap.comp
      ((f.prodMap g).comp L.toContinuousLinearMap)‖ = max ‖f‖ ‖g‖ := by
  let L := WithLp.prodContinuousLinearEquiv 2 𝕜 E F
  let T := L.symm.toContinuousLinearMap.comp
    ((f.prodMap g).comp L.toContinuousLinearMap)
  change ‖T‖ = max ‖f‖ ‖g‖
  have hT (x : WithLp 2 (E × F)) :
      T x = WithLp.toLp 2 (f x.fst, g x.snd) := rfl
  let C := max ‖f‖ ‖g‖
  have hC : 0 ≤ C := (norm_nonneg f).trans (le_max_left _ _)
  apply le_antisymm
  · apply T.opNorm_le_bound hC
    intro x
    have hf : ‖f x.fst‖ ≤ C * ‖x.fst‖ :=
      (f.le_opNorm x.fst).trans
        (mul_le_mul_of_nonneg_right (le_max_left _ _) (norm_nonneg _))
    have hg : ‖g x.snd‖ ≤ C * ‖x.snd‖ :=
      (g.le_opNorm x.snd).trans
        (mul_le_mul_of_nonneg_right (le_max_right _ _) (norm_nonneg _))
    have hf2 : ‖f x.fst‖ ^ 2 ≤ (C * ‖x.fst‖) ^ 2 :=
      (sq_le_sq₀ (norm_nonneg _) (mul_nonneg hC (norm_nonneg _))).mpr hf
    have hg2 : ‖g x.snd‖ ^ 2 ≤ (C * ‖x.snd‖) ^ 2 :=
      (sq_le_sq₀ (norm_nonneg _) (mul_nonneg hC (norm_nonneg _))).mpr hg
    have hTx : ‖T x‖ ^ 2 = ‖f x.fst‖ ^ 2 + ‖g x.snd‖ ^ 2 := by
      rw [hT, WithLp.prod_norm_sq_eq_of_L2]
      rfl
    have hx := WithLp.prod_norm_sq_eq_of_L2 x
    apply (sq_le_sq₀ (norm_nonneg _) (mul_nonneg hC (norm_nonneg _))).mp
    calc
      ‖T x‖ ^ 2 = ‖f x.fst‖ ^ 2 + ‖g x.snd‖ ^ 2 := hTx
      _ ≤ (C * ‖x.fst‖) ^ 2 + (C * ‖x.snd‖) ^ 2 := add_le_add hf2 hg2
      _ = C ^ 2 * (‖x.fst‖ ^ 2 + ‖x.snd‖ ^ 2) := by ring
      _ = C ^ 2 * ‖x‖ ^ 2 := by rw [hx]
      _ = (C * ‖x‖) ^ 2 := by ring
  · apply max_le
    · apply f.opNorm_le_bound (norm_nonneg T)
      intro x
      have h := T.le_opNorm (WithLp.toLp 2 (x, (0 : F)))
      simpa only [hT, WithLp.toLp_fst, WithLp.toLp_snd,
        Prod.fst, Prod.snd, map_zero, WithLp.norm_toLp_fst] using h
    · apply g.opNorm_le_bound (norm_nonneg T)
      intro y
      have h := T.le_opNorm (WithLp.toLp 2 ((0 : E), y))
      simpa only [hT, WithLp.toLp_fst, WithLp.toLp_snd,
        Prod.fst, Prod.snd, map_zero, WithLp.norm_toLp_snd] using h

end NumStability
