/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Analysis.InnerProductSpace.ProdL2
import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-!
# Bhatia I.3: repeated blocks and positivity

Transparent statement targets on the genuine Hilbert direct sum. Statement
faithfulness and proof acceptance are separate outstanding obligations.
-/

set_option autoImplicit false
noncomputable section
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The printed unitary implements the displayed equivalence in the direction
`W M W* = (2A) ⊕ 0`. Its formula is fixed before the arbitrary operator. -/
def repeatedBlockUnitaryEquivalence : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let L := WithLp.linearEquiv 2 ℂ (H × H)
    let I : H →ₗ[ℂ] H := LinearMap.id
    let c : ℂ := ((Real.sqrt 2)⁻¹ : ℝ)
    let W := L.symm.toLinearMap.comp
      ((c • ((I.coprod I).prod ((-I).coprod I))).comp L.toLinearMap)
    W.comp (LinearMap.adjoint W) = LinearMap.id ∧
    (LinearMap.adjoint W).comp W = LinearMap.id ∧
    (∀ p : WithLp 2 (H × H),
      W p = WithLp.toLp 2
        (c • ((WithLp.ofLp p).1 + (WithLp.ofLp p).2),
         c • (-(WithLp.ofLp p).1 + (WithLp.ofLp p).2))) ∧
    (∀ A : H →ₗ[ℂ] H,
      let M := L.symm.toLinearMap.comp
        (((A.coprod A).prod (A.coprod A)).comp L.toLinearMap)
      let N := L.symm.toLinearMap.comp
        ((((2 : ℂ) • A).prodMap (0 : H →ₗ[ℂ] H)).comp L.toLinearMap)
      W.comp (M.comp (LinearMap.adjoint W)) = N)

/-- Both sides use Mathlib's actual symmetric, nonnegative quadratic-form
predicate. The block's vector domain is every pair in the Hilbert L2 sum. -/
def repeatedBlockPositiveEquivalence : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let L := WithLp.linearEquiv 2 ℂ (H × H)
    let M := L.symm.toLinearMap.comp
      (((A.coprod A).prod (A.coprod A)).comp L.toLinearMap)
    A.IsPositive ↔ M.IsPositive

end NumStability.Bhatia.Chapter01.Targets
