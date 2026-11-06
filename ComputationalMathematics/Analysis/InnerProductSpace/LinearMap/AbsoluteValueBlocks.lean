/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.Polar
import Mathlib.Analysis.InnerProductSpace.ProdL2

/-!
# Positivity of absolute-value operator blocks

For every endomorphism of a finite-dimensional complex inner-product space, the
L2 block with diagonal blocks `|A|`, `|A*|` and off-diagonal blocks `A*`, `A` is
positive. The diagonal blocks are the actual functional-calculus square roots.

A full polar unitary identifies the second diagonal root by positive-root
uniqueness. The whole block is then a positive congruence of the first root.
Singular operators and the zero-dimensional space require no extra hypotheses.
-/

set_option autoImplicit false

namespace NumStability

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
  [FiniteDimensional ℂ H]

private theorem abs_adjoint_polar (A U : H →ₗ[ℂ] H)
    (hU : U ∈ unitary (H →ₗ[ℂ] H)) (hA : A = U.comp (linearMapAbs A)) :
    linearMapAbs A.adjoint = U.comp ((linearMapAbs A).comp U.adjoint) := by
  have hUt : U.adjoint.comp U = LinearMap.id := (Unitary.mem_iff.mp hU).1
  have hP := linearMapAbs_isPositive A
  apply Eq.symm
  apply linearMapAbs_unique A.adjoint _ (hP.conj_adjoint U)
  rw [LinearMap.adjoint_adjoint]
  have hAdj : A.adjoint = (linearMapAbs A).comp U.adjoint := by
    calc
      A.adjoint = (U.comp (linearMapAbs A)).adjoint := congrArg LinearMap.adjoint hA
      _ = (linearMapAbs A).comp U.adjoint := by
        rw [LinearMap.adjoint_comp, hP.1.adjoint_eq]
  calc
    _ = (U.comp (linearMapAbs A)).comp ((linearMapAbs A).comp U.adjoint) := by
      ext x
      have hu (y : H) : U.adjoint (U y) = y :=
        congrArg (fun f : H →ₗ[ℂ] H => f y) hUt
      simp only [LinearMap.comp_apply, hu]
    _ = A.comp A.adjoint := by rw [← hA, ← hAdj]

private theorem block_of_polar_isPositive (A U : H →ₗ[ℂ] H)
    (hU : U ∈ unitary (H →ₗ[ℂ] H)) (hA : A = U.comp (linearMapAbs A)) :
    let L := WithLp.linearEquiv 2 ℂ (H × H)
    (L.symm.toLinearMap.comp
      ((((linearMapAbs A).coprod A.adjoint).prod
        (A.coprod (linearMapAbs A.adjoint))).comp L.toLinearMap)).IsPositive := by
  let P := linearMapAbs A
  let L := WithLp.linearEquiv 2 ℂ (H × H)
  let F : WithLp 2 (H × H) →ₗ[ℂ] H :=
    (LinearMap.id.coprod U.adjoint).comp L.toLinearMap
  let J : H →ₗ[ℂ] WithLp 2 (H × H) :=
    L.symm.toLinearMap.comp (LinearMap.id.prod U)
  have hJF : J = F.adjoint := by
    apply (LinearMap.eq_adjoint_iff J F).mpr
    intro x y
    simp [J, F, L, WithLp.prod_inner_apply, LinearMap.adjoint_inner_right,
      inner_add_right]
  have hpos := (linearMapAbs_isPositive A).adjoint_conj F
  rw [← hJF] at hpos
  convert hpos using 1
  rw [abs_adjoint_polar A U hU hA]
  have hAdj : A.adjoint = P.comp U.adjoint := by
    calc
      A.adjoint = (U.comp P).adjoint := congrArg LinearMap.adjoint hA
      _ = P.comp U.adjoint := by
        rw [LinearMap.adjoint_comp, (linearMapAbs_isPositive A).1.adjoint_eq]
  rw [hAdj]
  ext z
  have hApply (x : H) : A x = U (P x) :=
    congrArg (fun f : H →ₗ[ℂ] H => f x) hA
  simp [J, F, L, P, hApply, map_add]

/-- The prescribed absolute-value block is positive on the genuine L2 direct
sum, for every finite-dimensional complex endomorphism, including singular
operators and dimension zero. -/
theorem absolute_value_block_isPositive (A : H →ₗ[ℂ] H) :
    letI : CompleteSpace H := FiniteDimensional.complete ℂ H
    let T : H →L[ℂ] H := A.toContinuousLinearMap
    let P : H →ₗ[ℂ] H := (CFC.sqrt (T.adjoint * T)).toLinearMap
    let Q : H →ₗ[ℂ] H := (CFC.sqrt (T * T.adjoint)).toLinearMap
    let L := WithLp.linearEquiv 2 ℂ (H × H)
    (L.symm.toLinearMap.comp
      (((P.coprod A.adjoint).prod (A.coprod Q)).comp L.toLinearMap)).IsPositive := by
  letI : CompleteSpace H := FiniteDimensional.complete ℂ H
  obtain ⟨U, hU, hA⟩ := exists_unitary_comp_linearMapAbs A
  simpa only [linearMapAbs, LinearMap.adjoint_toContinuousLinearMap,
    ContinuousLinearMap.adjoint_adjoint] using block_of_polar_isPositive A U hU hA

end NumStability
