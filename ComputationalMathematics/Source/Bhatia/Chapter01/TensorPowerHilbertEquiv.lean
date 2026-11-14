/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.TensorPowerClassPreservationTarget
import Mathlib.LinearAlgebra.PiTensorProduct
import Mathlib.Logic.Equiv.Fin.Basic

/-!
The positive degree is r + 1. The existing recursive Hilbert carrier and its
instances are retained. This defines only the algebraic linear equivalence;
the generator and Hilbert correspondence obligations remain separate.
-/

set_option autoImplicit false
noncomputable section
universe u
open scoped TensorProduct

namespace NumStability.Bhatia.Chapter01.Targets

/-- Head-first identification of the indexed tensor quotient with the existing
recursive finite Hilbert carrier. No correspondence theorem is assumed. -/
def tensorPowerHilbertEquiv (H : Type u)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] :
    (r : ℕ) → (PiTensorProduct ℂ (fun _ : Fin (r + 1) => H)) ≃ₗ[ℂ]
      (tensorPowerFiniteHilbert H r).carrier
  | 0 => PiTensorProduct.subsingletonEquiv
      (R := ℂ) (s := fun _ : Fin 1 => H) (0 : Fin 1)
  | r + 1 =>
      let e : Fin ((r + 1) + 1) ≃ Fin 1 ⊕ Fin (r + 1) :=
        (finCongr (Nat.add_comm (r + 1) 1)).trans
          (finSumFinEquiv (m := 1) (n := r + 1)).symm
      (PiTensorProduct.reindex ℂ (fun _ : Fin ((r + 1) + 1) => H) e).trans
        ((PiTensorProduct.tmulEquiv ℂ H (ι := Fin 1) (ι₂ := Fin (r + 1))).symm.trans
          (TensorProduct.congr
            (PiTensorProduct.subsingletonEquiv
              (R := ℂ) (s := fun _ : Fin 1 => H) (0 : Fin 1))
            (tensorPowerHilbertEquiv H r)))

end NumStability.Bhatia.Chapter01.Targets
