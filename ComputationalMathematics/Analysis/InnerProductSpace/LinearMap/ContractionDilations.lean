/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.ContractionDefects
import Mathlib.Analysis.InnerProductSpace.ProdL2
import Mathlib.Tactic.Abel
import Mathlib.Tactic.Linarith

/-!
# Unitary block dilations of contractions

The two defect roots of a contraction give unitary operators on the genuine
Hilbert L2 sum. Both signs of the second block column are included. Their
unitarity uses the ordered defect-root intertwining identity, and does not
require normality, invertibility, strict contraction or positive dimension.
The second operator is obtained from the first by the fixed sign reflection.
-/

set_option autoImplicit false

namespace NumStability

set_option maxHeartbeats 0 in
/-- The two explicit defect-root blocks of a contraction have both adjoint
products equal to the identity on the actual Hilbert L2 sum. -/
theorem contraction_block_unitaries
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (A : H →L[ℂ] H) (hA : ‖A‖ ≤ 1) :
    letI : CompleteSpace H := FiniteDimensional.complete ℂ H
    let S := CFC.sqrt (1 - A * A.adjoint)
    let T := CFC.sqrt (1 - A.adjoint * A)
    let L := WithLp.linearEquiv 2 ℂ (H × H)
    let U := L.symm.toLinearMap.comp
      (((A.toLinearMap.coprod S.toLinearMap).prod
        (T.toLinearMap.coprod (-A.adjoint.toLinearMap))).comp L.toLinearMap)
    let V := L.symm.toLinearMap.comp
      (((A.toLinearMap.coprod (-S.toLinearMap)).prod
        (T.toLinearMap.coprod A.adjoint.toLinearMap)).comp L.toLinearMap)
    U.adjoint.comp U = LinearMap.id ∧ U.comp U.adjoint = LinearMap.id ∧
      V.adjoint.comp V = LinearMap.id ∧ V.comp V.adjoint = LinearMap.id := by
  letI : CompleteSpace H := FiniteDimensional.complete ℂ H
  let S := CFC.sqrt (1 - A * A.adjoint)
  let T := CFC.sqrt (1 - A.adjoint * A)
  let L := WithLp.linearEquiv 2 ℂ (H × H)
  let U := L.symm.toLinearMap.comp
    (((A.toLinearMap.coprod S.toLinearMap).prod
      (T.toLinearMap.coprod (-A.adjoint.toLinearMap))).comp L.toLinearMap)
  let V := L.symm.toLinearMap.comp
    (((A.toLinearMap.coprod (-S.toLinearMap)).prod
      (T.toLinearMap.coprod A.adjoint.toLinearMap)).comp L.toLinearMap)
  let R := L.symm.toLinearMap.comp
    (((A.adjoint.toLinearMap.coprod T.toLinearMap).prod
      (S.toLinearMap.coprod (-A.toLinearMap))).comp L.toLinearMap)
  let J := L.symm.toLinearMap.comp
    (((LinearMap.id : H →ₗ[ℂ] H).prodMap (-LinearMap.id)).comp L.toLinearMap)
  have defect_nonneg (B : H →L[ℂ] H) (hB : ‖B‖ ≤ 1) :
      0 ≤ (1 : H →L[ℂ] H) - B.adjoint * B := by
    have hn : ‖star B * B‖ ≤ 1 := by
      rw [CStarRing.norm_star_mul_self]
      nlinarith [norm_nonneg B]
    exact sub_nonneg.mpr
      ((CStarAlgebra.norm_le_one_iff_of_nonneg _ (star_mul_self_nonneg B)).mp hn)
  have hTdef := defect_nonneg A hA
  have hSdef : 0 ≤ (1 : H →L[ℂ] H) - A * A.adjoint := by
    simpa only [ContinuousLinearMap.adjoint_adjoint] using
      defect_nonneg A.adjoint ((ContinuousLinearMap.adjoint.norm_map A).le.trans hA)
  have hSsquare : S * S = 1 - A * A.adjoint := CFC.sqrt_mul_sqrt_self _ hSdef
  have hTsquare : T * T = 1 - A.adjoint * A := CFC.sqrt_mul_sqrt_self _ hTdef
  have hSstar : star S = S := (IsSelfAdjoint.of_nonneg (CFC.sqrt_nonneg _)).star_eq
  have hTstar : star T = T := (IsSelfAdjoint.of_nonneg (CFC.sqrt_nonneg _)).star_eq
  have hAS : A.adjoint * S = T * A.adjoint := adjoint_mul_sqrt_defect_eq A hA
  have hSA : S * A = A * T := by
    have h := congrArg (fun B : H →L[ℂ] H => star B) hAS
    have hAstar : star A.adjoint = A := ContinuousLinearMap.adjoint_adjoint A
    simpa only [star_mul, hAstar, hSstar, hTstar] using h
  have hAS_apply (x : H) : A.adjoint (S x) = T (A.adjoint x) :=
    congrArg (fun B : H →L[ℂ] H => B x) hAS
  have hSA_apply (x : H) : S (A x) = A (T x) :=
    congrArg (fun B : H →L[ℂ] H => B x) hSA
  have hS2 (x : H) : S (S x) = x - A (A.adjoint x) :=
    congrArg (fun B : H →L[ℂ] H => B x) hSsquare
  have hT2 (x : H) : T (T x) = x - A.adjoint (A x) :=
    congrArg (fun B : H →L[ℂ] H => B x) hTsquare
  have hSinner (x y : H) : inner ℂ (S x) y = inner ℂ x (S y) := by
    have h : S.adjoint = S := hSstar
    simpa only [h] using ContinuousLinearMap.adjoint_inner_left S y x
  have hTinner (x y : H) : inner ℂ (T x) y = inner ℂ x (T y) := by
    have h : T.adjoint = T := hTstar
    simpa only [h] using ContinuousLinearMap.adjoint_inner_left T y x
  have hU (x : WithLp 2 (H × H)) :
      U x = WithLp.toLp 2
        (A (WithLp.ofLp x).1 + S (WithLp.ofLp x).2,
         T (WithLp.ofLp x).1 - A.adjoint (WithLp.ofLp x).2) := by
    simp [U, L, sub_eq_add_neg]
  have hR (x : WithLp 2 (H × H)) :
      R x = WithLp.toLp 2
        (A.adjoint (WithLp.ofLp x).1 + T (WithLp.ofLp x).2,
         S (WithLp.ofLp x).1 - A (WithLp.ofLp x).2) := by
    simp [R, L, sub_eq_add_neg]
  have hUadj : U.adjoint = R := by
    symm
    apply (LinearMap.eq_adjoint_iff R U).mpr
    intro x y
    rw [hR, hU]
    simp only [WithLp.prod_inner_apply, inner_add_left, inner_add_right,
      inner_sub_left, inner_sub_right, hSinner, hTinner,
      ContinuousLinearMap.adjoint_inner_left, ContinuousLinearMap.adjoint_inner_right]
    abel
  have hRU : R.comp U = LinearMap.id := by
    apply LinearMap.ext
    intro x
    change R (U x) = x
    rw [hR, hU]
    apply L.injective
    change (A.adjoint (A (WithLp.ofLp x).1 + S (WithLp.ofLp x).2) +
        T (T (WithLp.ofLp x).1 - A.adjoint (WithLp.ofLp x).2),
      S (A (WithLp.ofLp x).1 + S (WithLp.ofLp x).2) -
        A (T (WithLp.ofLp x).1 - A.adjoint (WithLp.ofLp x).2)) =
      ((WithLp.ofLp x).1, (WithLp.ofLp x).2)
    apply Prod.ext
    <;> simp only [map_add, map_sub, hAS_apply, hSA_apply, hS2, hT2]
    <;> abel
  have hUR : U.comp R = LinearMap.id := by
    apply LinearMap.ext
    intro x
    change U (R x) = x
    rw [hU, hR]
    apply L.injective
    change (A (A.adjoint (WithLp.ofLp x).1 + T (WithLp.ofLp x).2) +
        S (S (WithLp.ofLp x).1 - A (WithLp.ofLp x).2),
      T (A.adjoint (WithLp.ofLp x).1 + T (WithLp.ofLp x).2) -
        A.adjoint (S (WithLp.ofLp x).1 - A (WithLp.ofLp x).2)) =
      ((WithLp.ofLp x).1, (WithLp.ofLp x).2)
    apply Prod.ext
    <;> simp only [map_add, map_sub, hAS_apply, hSA_apply, hS2, hT2]
    <;> abel
  have hJadj : J.adjoint = J := by
    symm
    apply (LinearMap.eq_adjoint_iff J J).mpr
    intro x y
    simp [J, L, WithLp.prod_inner_apply]
  have hJJ : J.comp J = LinearMap.id := by
    apply LinearMap.ext
    intro x
    apply L.injective
    simp [J, L]
    rfl
  have hV : V = U.comp J := by
    apply LinearMap.ext
    intro x
    apply L.injective
    simp [V, U, J, L]
  have hUl : U.adjoint.comp U = LinearMap.id := by rwa [hUadj]
  have hUr : U.comp U.adjoint = LinearMap.id := by rwa [hUadj]
  change U.adjoint.comp U = LinearMap.id ∧ U.comp U.adjoint = LinearMap.id ∧
    V.adjoint.comp V = LinearMap.id ∧ V.comp V.adjoint = LinearMap.id
  refine ⟨hUl, hUr, ?_, ?_⟩
  · rw [hV, LinearMap.adjoint_comp, hJadj]
    calc
      (J.comp U.adjoint).comp (U.comp J) = J.comp ((U.adjoint.comp U).comp J) := by
        simp only [LinearMap.comp_assoc]
      _ = LinearMap.id := by rw [hUl, LinearMap.id_comp]; exact hJJ
  · rw [hV, LinearMap.adjoint_comp, hJadj]
    calc
      (U.comp J).comp (J.comp U.adjoint) = U.comp ((J.comp J).comp U.adjoint) := by
        simp only [LinearMap.comp_assoc]
      _ = LinearMap.id := by rw [hJJ, LinearMap.id_comp]; exact hUr

end NumStability
