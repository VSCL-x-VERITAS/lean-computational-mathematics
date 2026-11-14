/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Chapter I.5.
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.WedgeDefinitions
import ComputationalMathematics.Analysis.InnerProductSpace.PiTensorProduct

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- I.5.wedge-unit: the source-normalized signed tensor sum has norm one
for every orthonormal positive-length tuple. The norm is the constructed
product Hilbert norm on the actual tensor quotient; it is not supplied as
a parameter. No dimension lower bound or upper bound on k is imposed.
-/
def wedgeUnit : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (hk : 0 < k) (x : Fin k → H),
    letI : NormedAddCommGroup (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
      PiTensorProduct.productNormedAddCommGroup
    letI : SeminormedAddCommGroup (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
      PiTensorProduct.productSeminormedAddCommGroup
    letI : InnerProductSpace ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
      PiTensorProduct.productInnerProductSpace
    letI : NormedSpace ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
      PiTensorProduct.productNormedSpace
    Orthonormal ℂ x → ‖normalizedWedge k hk x‖ = 1

end

end NumStability.Bhatia.Chapter01.Targets
