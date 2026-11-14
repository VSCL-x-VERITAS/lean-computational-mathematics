/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.UnitaryInvariancePositiveRootTarget
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.FrobeniusComposition
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRootSingularValues

/-!
# Bhatia's two-sided unitary norm invariance

The operator norm and the prescribed positive-Gram-root Frobenius quantity are
unchanged by independent unitary factors on the left and right. The proof uses
isometric composition rather than a unitary norm-one assertion, so the
zero-dimensional Hilbert space is included.
-/

set_option autoImplicit false
open scoped BigOperators
universe u

namespace NumStability.Bhatia.Chapter01

/-- Both source norms are invariant under two independently supplied unitaries. -/
theorem unitaryInvariancePositiveRootChoice :
    Targets.unitaryInvariancePositiveRootChoice.{u} := by
  classical
  intro H _ _ _
  let F : (H →ₗ[ℂ] H) → ℝ := fun B =>
    let G := (LinearMap.adjoint B).comp B
    let P := NumStability.positiveSquareRoot G
      (LinearMap.isPositive_adjoint_comp_self B)
    let hs : P.IsPositive := NumStability.positiveSquareRoot_isPositive G
      (LinearMap.isPositive_adjoint_comp_self B)
    let s : Fin (Module.finrank ℂ H) → ℝ := hs.isSymmetric.eigenvalues rfl
    Real.sqrt (∑ i : Fin (Module.finrank ℂ H), s i ^ 2)
  change ∀ (A U V : H →ₗ[ℂ] H), U ∈ unitary (H →ₗ[ℂ] H) →
    V ∈ unitary (H →ₗ[ℂ] H) →
    ‖A.toContinuousLinearMap‖ = ‖(U.comp (A.comp V)).toContinuousLinearMap‖ ∧
      F A = F (U.comp (A.comp V))
  intro A U V hU hV
  have hUgram : (LinearMap.adjoint U).comp U = LinearMap.id := by
    simpa only [LinearMap.star_eq_adjoint, Module.End.mul_eq_comp] using
      (Unitary.star_mul_self_of_mem hU)
  have hVgram : (LinearMap.adjoint V).comp V = LinearMap.id := by
    simpa only [LinearMap.star_eq_adjoint, Module.End.mul_eq_comp] using
      (Unitary.star_mul_self_of_mem hV)
  have hVco : V.comp (LinearMap.adjoint V) = LinearMap.id := by
    simpa only [LinearMap.star_eq_adjoint, Module.End.mul_eq_comp] using
      (Unitary.mul_star_self_of_mem hV)
  have hinner (W : H →ₗ[ℂ] H)
      (hW : (LinearMap.adjoint W).comp W = LinearMap.id) (x y : H) :
      inner ℂ (W x) (W y) = inner ℂ x y := by
    calc
      inner ℂ (W x) (W y) = inner ℂ x ((LinearMap.adjoint W) (W y)) :=
        (LinearMap.adjoint_inner_right W x (W y)).symm
      _ = inner ℂ x y := by
        change inner ℂ x (((LinearMap.adjoint W).comp W) y) = _
        rw [hW, LinearMap.id_apply]
  let uI := U.isometryOfInner (hinner U hUgram)
  let vI := V.isometryOfInner (hinner V hVgram)
  let vE := vI.toLinearIsometryEquiv rfl
  have hnorm : ‖(U.comp (A.comp V)).toContinuousLinearMap‖ =
      ‖A.toContinuousLinearMap‖ := by
    calc
      ‖(U.comp (A.comp V)).toContinuousLinearMap‖ =
          ‖uI.toContinuousLinearMap.comp (A.comp V).toContinuousLinearMap‖ := by
        congr 1
      _ = ‖(A.comp V).toContinuousLinearMap‖ :=
        uI.norm_toContinuousLinearMap_comp
      _ = ‖A.toContinuousLinearMap.comp vE.toLinearIsometry.toContinuousLinearMap‖ := by
        congr 1
      _ = ‖A.toContinuousLinearMap‖ :=
        ContinuousLinearMap.opNorm_comp_linearIsometryEquiv A.toContinuousLinearMap vE
  have hF (B : H →ₗ[ℂ] H) : F B = NumStability.linearMapFrobenius B :=
    congrArg (fun s : Fin (Module.finrank ℂ H) → ℝ => Real.sqrt (∑ i, s i ^ 2))
      (NumStability.positiveSquareRoot_adjoint_comp_self_eigenvalues B)
  refine ⟨hnorm.symm, ?_⟩
  rw [hF A, hF (U.comp (A.comp V))]
  exact ((NumStability.linearMapFrobenius_comp_left_of_adjoint_comp_self
    U (A.comp V) hUgram).trans
    (NumStability.linearMapFrobenius_comp_right_of_comp_adjoint_self A V hVco)).symm

end NumStability.Bhatia.Chapter01
