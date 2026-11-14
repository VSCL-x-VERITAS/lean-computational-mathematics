/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.TensorPowerClassPreservationTarget

/-!
Proof-free statement for Bhatia, Matrix Analysis (1997),
I.4 tensor-power property 3, printed p. 15 / PDF p. 27.

Reuse the transparent recursive finite Hilbert tensor construction: one factor
is H, each further factor is added on the left by the actual TensorProduct
quotient with its pinned product Hilbert instances, and the induced operator
is recursively TensorProduct.map. Positive k is represented by k-1 binary
steps. Neither a tensor carrier, product core, nor tensor action is supplied
as a theorem assumption. The identity concerns linear maps on the entire
constructed carrier. No nontriviality or operator-class premise is imposed.

The source quotient/generator/action/product-inner-product correspondence
requires an explicit native dossier. Any transfer to the separately used
PiTensorProduct model requires its own checked correspondence; no such
transfer is assumed or proved here. This file claims no elaboration,
source-faithfulness acceptance, proof, or row closure.
-/

set_option autoImplicit false
noncomputable section
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The unconditional adjoint law on the actual recursive product Hilbert
power, for every finite complex H, every positive k, and every endomorphism A.
Equality is of full-domain linear maps, not just their values on pure tensors. -/
def tensorPowerAdjointTarget : Prop :=
  ∀ (H : Type u)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (k : ℕ), 0 < k →
    ∀ A : H →ₗ[ℂ] H,
      LinearMap.adjoint (tensorPowerFiniteHilbertMap H (k - 1) A) =
        tensorPowerFiniteHilbertMap H (k - 1) (LinearMap.adjoint A)

end NumStability.Bhatia.Chapter01.Targets
