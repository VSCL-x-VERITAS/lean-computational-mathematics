/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.StarOrder
import Mathlib.Analysis.InnerProductSpace.ProdL2
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.Rpow.Basic

/-!
# Bhatia Corollary I.3.4

The diagonal blocks are the actual positive square roots from continuous
functional calculus. The block acts on the Hilbert direct sum.
-/

set_option autoImplicit false
noncomputable section
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- For every finite-dimensional complex Hilbert space and endomorphism, the
prescribed block with diagonal absolute values is positive semidefinite. -/
def absoluteValueBlockPositive : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    letI : CompleteSpace H := FiniteDimensional.complete ℂ H
    let T : H →L[ℂ] H := LinearMap.toContinuousLinearMap A
    let P : H →ₗ[ℂ] H := (CFC.sqrt ((ContinuousLinearMap.adjoint T) * T)).toLinearMap
    let Q : H →ₗ[ℂ] H := (CFC.sqrt (T * (ContinuousLinearMap.adjoint T))).toLinearMap
    let L := WithLp.linearEquiv 2 ℂ (H × H)
    let M := L.symm.toLinearMap.comp
      (((P.coprod (LinearMap.adjoint A)).prod (A.coprod Q)).comp L.toLinearMap)
    M.IsPositive

end NumStability.Bhatia.Chapter01.Targets
