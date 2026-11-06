/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.ProdL2
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Module
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# A fixed unitary diagonalization of repeated blocks

The normalized sum-and-difference rotation on the Hilbert L2 product is
unitary. The same rotation, chosen independently of the operator, conjugates
four repeated blocks to the direct sum of twice that operator and zero.
The statements include the zero space and require no invertibility,
normality or positivity of the operator.
-/

set_option autoImplicit false

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
  [FiniteDimensional ℂ E]

/-- The prescribed normalized sum-and-difference rotation is unitary and
diagonalizes every repeated-block operator on the genuine L2 product. -/
theorem repeated_block_unitary_diagonalization :
    let L := WithLp.linearEquiv 2 ℂ (E × E)
    let I : E →ₗ[ℂ] E := LinearMap.id
    let c : ℂ := ((Real.sqrt 2)⁻¹ : ℝ)
    let W := L.symm.toLinearMap.comp
      ((c • ((I.coprod I).prod ((-I).coprod I))).comp L.toLinearMap)
    W.comp (LinearMap.adjoint W) = LinearMap.id ∧
    (LinearMap.adjoint W).comp W = LinearMap.id ∧
    (∀ p : WithLp 2 (E × E),
      W p = WithLp.toLp 2
        (c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2),
         c • (-(WithLp.ofLp p).1 + (WithLp.ofLp p).2))) ∧
    (∀ A : E →ₗ[ℂ] E,
      let M := L.symm.toLinearMap.comp
        (((A.coprod A).prod (A.coprod A)).comp L.toLinearMap)
      let N := L.symm.toLinearMap.comp
        ((((2 : ℂ) • A).prodMap (0 : E →ₗ[ℂ] E)).comp L.toLinearMap)
      W.comp (M.comp (LinearMap.adjoint W)) = N) := by
  let L := WithLp.linearEquiv 2 ℂ (E × E)
  let I : E →ₗ[ℂ] E := LinearMap.id
  let c : ℂ := ((Real.sqrt 2)⁻¹ : ℝ)
  let W := L.symm.toLinearMap.comp
    ((c • ((I.coprod I).prod ((-I).coprod I))).comp L.toLinearMap)
  let V := L.symm.toLinearMap.comp
    ((c • ((I.coprod (-I)).prod (I.coprod I))).comp L.toLinearMap)
  have hs : (Real.sqrt 2) ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  have hs0 : Real.sqrt 2 ≠ 0 := ne_of_gt (Real.sqrt_pos.2 (by norm_num))
  have hc : c * c = (1 / 2 : ℂ) := by
    have h : (Real.sqrt 2)⁻¹ * (Real.sqrt 2)⁻¹ = (1 / 2 : ℝ) := by
      field_simp [hs0]
      nlinarith
    calc
      c * c = (((Real.sqrt 2)⁻¹ * (Real.sqrt 2)⁻¹ : ℝ) : ℂ) := by simp [c]
      _ = ((1 / 2 : ℝ) : ℂ) := congrArg (fun x : ℝ => (x : ℂ)) h
      _ = (1 / 2 : ℂ) := by norm_num
  have hstar : starRingEnd ℂ c = c := by simp [c]
  have hW (p : WithLp 2 (E × E)) :
      W p = WithLp.toLp 2
        (c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2),
         c • (-(WithLp.ofLp p).1 + (WithLp.ofLp p).2)) := by
    simp [W, L, I]
  have hV (p : WithLp 2 (E × E)) :
      V p = WithLp.toLp 2
        (c • ((WithLp.ofLp p).1 - (WithLp.ofLp p).2),
         c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2)) := by
    simp [V, L, I, sub_eq_add_neg]
  have hadj : LinearMap.adjoint W = V := by
    symm
    apply (LinearMap.eq_adjoint_iff V W).2
    intro p q
    rw [hV, hW]
    simp only [WithLp.prod_inner_apply,
      inner_add_left, inner_add_right, inner_sub_left,
      inner_neg_right, inner_smul_left, inner_smul_right, hstar]
    ring
  change W.comp (LinearMap.adjoint W) = LinearMap.id ∧
    (LinearMap.adjoint W).comp W = LinearMap.id ∧ _ ∧ _
  refine ⟨?_, ?_, hW, ?_⟩
  · rw [hadj]
    apply LinearMap.ext
    intro p
    change W (V p) = p
    rw [hW, hV]
    apply L.injective
    change (c • (c • ((WithLp.ofLp p).1 - (WithLp.ofLp p).2) +
      c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2)),
      c • (-(c • ((WithLp.ofLp p).1 - (WithLp.ofLp p).2)) +
        c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2))) =
      ((WithLp.ofLp p).1, (WithLp.ofLp p).2)
    apply Prod.ext
    <;> simp only [smul_add, smul_sub, smul_neg, smul_smul, hc]
    <;> module
  · rw [hadj]
    apply LinearMap.ext
    intro p
    change V (W p) = p
    rw [hV, hW]
    apply L.injective
    change (c • (c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2) -
      c • (-(WithLp.ofLp p).1 + (WithLp.ofLp p).2)),
      c • (c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2) +
        c • (-(WithLp.ofLp p).1 + (WithLp.ofLp p).2))) =
      ((WithLp.ofLp p).1, (WithLp.ofLp p).2)
    apply Prod.ext
    <;> simp only [smul_add, smul_sub, smul_neg, smul_smul, hc]
    <;> module
  · intro A
    let M := L.symm.toLinearMap.comp
      (((A.coprod A).prod (A.coprod A)).comp L.toLinearMap)
    let N := L.symm.toLinearMap.comp
      ((((2 : ℂ) • A).prodMap (0 : E →ₗ[ℂ] E)).comp L.toLinearMap)
    change W.comp (M.comp (LinearMap.adjoint W)) = N
    have hM (q : WithLp 2 (E × E)) :
        M q = WithLp.toLp 2
          (A ((WithLp.ofLp q).1 + (WithLp.ofLp q).2),
           A ((WithLp.ofLp q).1 + (WithLp.ofLp q).2)) := by
      simp [M, L]
    have hN (q : WithLp 2 (E × E)) :
        N q = WithLp.toLp 2 ((2 : ℂ) • A (WithLp.ofLp q).1, (0 : E)) := by
      simp [N, L]
    rw [hadj]
    apply LinearMap.ext
    intro p
    change W (M (V p)) = N p
    rw [hN, hW, hM, hV]
    apply L.injective
    change (c • (A (c • ((WithLp.ofLp p).1 - (WithLp.ofLp p).2) +
      c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2)) +
      A (c • ((WithLp.ofLp p).1 - (WithLp.ofLp p).2) +
        c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2))),
      c • (-A (c • ((WithLp.ofLp p).1 - (WithLp.ofLp p).2) +
        c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2)) +
        A (c • ((WithLp.ofLp p).1 - (WithLp.ofLp p).2) +
          c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2)))) =
      ((2 : ℂ) • A (WithLp.ofLp p).1, (0 : E))
    apply Prod.ext
    <;> simp only [map_add, map_sub, map_smul, smul_add, smul_sub,
      smul_neg, smul_smul, hc]
    <;> module

end NumStability
