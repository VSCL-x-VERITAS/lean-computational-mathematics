/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Exercise I.5.1, printed16/PDF28.
-/
import ComputationalMathematics.Analysis.InnerProductSpace.PiTensorProduct
import ComputationalMathematics.Source.Bhatia.Chapter01.WedgeDefinitions
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# Target for the inner product of normalized antisymmetric tensors

The degree is positive, both vector tuples are arbitrary, and the inner product
is the actual product Hilbert inner product on the tensor quotient. The
determinant has the first tuple as its row index and the second as its column
index. No orthogonality, independence or dimension bound is assumed.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- The source normalized wedge inner product is the cross-Gram determinant. -/
def wedgeGramDeterminant : Prop :=
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
    inner ℂ (normalizedWedge k hk x) (normalizedWedge k hk y) =
      Matrix.det (fun i j => inner ℂ (x i) (y j))

end

end NumStability.Bhatia.Chapter01.Targets
