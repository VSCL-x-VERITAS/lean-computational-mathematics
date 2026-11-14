/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.RecursiveWedgeDefinitions
import Mathlib.LinearAlgebra.PiTensorProduct
import Mathlib.Logic.Equiv.Fin.Basic

set_option autoImplicit false
noncomputable section
universe u
open scoped TensorProduct BigOperators
namespace NumStability.Bhatia.Chapter01.Targets

/-- Internal foundation obligation, not a Bhatia source-row acceptance.
Every positive degree is r+1. Both the algebraic quotient and actual iterated
Hilbert carrier are fixed. No Hilbert structure on PiTensorProduct is assumed.
The entire product sesquilinear form is characterized on finite sums. -/
def tensorPowerHilbertCorrespondenceTarget : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (r : ℕ),
    ∃ Phi : (PiTensorProduct ℂ (fun _ : Fin (r + 1) => H)) ≃ₗ[ℂ]
        (tensorPowerFiniteHilbert H r).carrier,
      (∀ x : Fin (r + 1) → H,
        Phi (PiTensorProduct.tprod ℂ x) = recursiveTensor H r x) ∧
      (∀ x y : Fin (r + 1) → H,
        inner ℂ (recursiveTensor H r x) (recursiveTensor H r y) =
          ∏ i, inner ℂ (x i) (y i)) ∧
      (∀ (a b : ℕ) (c : Fin a → ℂ) (d : Fin b → ℂ)
          (x : Fin a → Fin (r + 1) → H)
          (y : Fin b → Fin (r + 1) → H),
        inner ℂ (Phi (∑ i, c i • PiTensorProduct.tprod ℂ (x i)))
          (Phi (∑ j, d j • PiTensorProduct.tprod ℂ (y j))) =
          ∑ i, ∑ j, star (c i) * d j *
            (∏ l, inner ℂ (x i l) (y j l))) ∧
      (∀ Psi : (PiTensorProduct ℂ (fun _ : Fin (r + 1) => H)) ≃ₗ[ℂ]
          (tensorPowerFiniteHilbert H r).carrier,
        (∀ x : Fin (r + 1) → H,
          Psi (PiTensorProduct.tprod ℂ x) = recursiveTensor H r x) →
        Psi = Phi) ∧
      (Module.finrank ℂ H = 0 →
        (∀ t : PiTensorProduct ℂ (fun _ : Fin (r + 1) => H), t = 0) ∧
        (∀ t : (tensorPowerFiniteHilbert H r).carrier, t = 0))

end NumStability.Bhatia.Chapter01.Targets
