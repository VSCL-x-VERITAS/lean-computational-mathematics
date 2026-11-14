/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.SymmetricProductTarget
import ComputationalMathematics.Analysis.InnerProductSpace.PiTensorProduct
import Mathlib.LinearAlgebra.Matrix.Permanent

/-!
# Inner product of normalized symmetric tensors

Statement contract for Bhatia, Matrix Analysis (1997), Exercise I.5.5.
Both symmetric products are the existing unsigned permutation sums on the actual
PiTensorProduct quotient. The ambient inner product is the constructed product
Hilbert structure on that same carrier. The matrix keeps x in its first inner
slot and y in its second.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- The cross inner product of two arbitrary normalized symmetric products
is the permanent of their cross-inner-product matrix. No orthogonality,
independence, nonzero dimension or bound on the positive degree is assumed. -/
def symmetricProductInnerPermanent : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (hk : 0 < k) (x y : Fin k → H),
    letI : NormedAddCommGroup (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
      PiTensorProduct.productNormedAddCommGroup
    letI : SeminormedAddCommGroup (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
      PiTensorProduct.productSeminormedAddCommGroup
    letI : InnerProductSpace ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
      PiTensorProduct.productInnerProductSpace
    letI : NormedSpace ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
      PiTensorProduct.productNormedSpace
    inner ℂ (normalizedSymmetricProduct k hk x) (normalizedSymmetricProduct k hk y) =
      Matrix.permanent (fun i j : Fin k => inner ℂ (x i) (y j))

end

end NumStability.Bhatia.Chapter01.Targets
