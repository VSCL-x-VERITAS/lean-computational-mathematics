/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.TensorFunctionals

/-!
# Inner product on the tensor quotient

Statement contract for Bhatia, Matrix Analysis (1997), I.4, printed page 14.
The binary `TensorProduct` quotient carries its existing Mathlib product inner
product. The existing `tensorConjugateBilinearEquiv` gives the functional
realization on that same carrier. The contract records the full finite-sum
formula, consistency with the tensor relations, definiteness and compatibility
with that realization.
-/

set_option autoImplicit false

noncomputable section

open scoped BigOperators TensorProduct

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Full product inner product on the actual tensor quotient, retaining its
finite-representative formula, all four relation consistencies, definiteness,
and the fixed functional realization on that same carrier. -/
def tensorQuotientInnerProductConstruction : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let Phi := NumStability.tensorConjugateBilinearEquiv (H := H) (K := H)
    -- Pure tensors, with no restriction on any of the four vectors.
    (∀ (u₁ u₂ v₁ v₂ : H),
      inner ℂ (u₁ ⊗ₜ[ℂ] u₂) (v₁ ⊗ₜ[ℂ] v₂) =
        inner ℂ u₁ v₁ * inner ℂ u₂ v₂) ∧
    -- Every finite formal representative, including empty sums in either slot.
    (∀ (m n : ℕ) (c : Fin m → ℂ) (d : Fin n → ℂ)
        (x y : Fin m → H) (z w : Fin n → H),
      inner ℂ (∑ i, c i • (x i ⊗ₜ[ℂ] y i)) (∑ j, d j • (z j ⊗ₜ[ℂ] w j)) =
        ∑ i, ∑ j, star (c i) * d j *
          (inner ℂ (x i) (z j) * inner ℂ (y i) (w j))) ∧
    -- Each printed relation pairs to zero against every quotient value,
    -- in both arguments. These relations already vanish in this actual quotient.
    (∀ (a : ℂ) (x₁ x₂ y₁ y₂ : H) (T : H ⊗[ℂ] H),
      let r₁ := a • (x₁ ⊗ₜ[ℂ] y₁) - ((a • x₁) ⊗ₜ[ℂ] y₁)
      let r₂ := a • (x₁ ⊗ₜ[ℂ] y₁) - (x₁ ⊗ₜ[ℂ] (a • y₁))
      let r₃ := (x₁ ⊗ₜ[ℂ] y₁) + (x₂ ⊗ₜ[ℂ] y₁) - ((x₁ + x₂) ⊗ₜ[ℂ] y₁)
      let r₄ := (x₁ ⊗ₜ[ℂ] y₁) + (x₁ ⊗ₜ[ℂ] y₂) - (x₁ ⊗ₜ[ℂ] (y₁ + y₂))
      (inner ℂ r₁ T = 0 ∧ inner ℂ T r₁ = 0) ∧
      (inner ℂ r₂ T = 0 ∧ inner ℂ T r₂ = 0) ∧
      (inner ℂ r₃ T = 0 ∧ inner ℂ T r₃ = 0) ∧
      (inner ℂ r₄ T = 0 ∧ inner ℂ T r₄ = 0)) ∧
    -- The actual form is sesquilinear and Hermitian on all quotient elements.
    (∀ (S T : H ⊗[ℂ] H), inner ℂ S T = star (inner ℂ T S)) ∧
    (∀ (S T U : H ⊗[ℂ] H),
      (inner ℂ (S + T) U = inner ℂ S U + inner ℂ T U) ∧
      (inner ℂ U (S + T) = inner ℂ U S + inner ℂ U T)) ∧
    (∀ (a : ℂ) (S T : H ⊗[ℂ] H),
      (inner ℂ (a • S) T = star a * inner ℂ S T) ∧
      (inner ℂ S (a • T) = a * inner ℂ S T)) ∧
    -- Definiteness is required for every quotient element, not assumed.
    (∀ (T : H ⊗[ℂ] H),
      (0 ≤ (inner ℂ T T).re) ∧ ((inner ℂ T T = 0) ↔ T = 0)) ∧
    -- Phi is the actual existing complex-linear equivalence on this same quotient.
    Function.Bijective (fun T : H ⊗[ℂ] H => Phi T) ∧
    (∀ (T : H ⊗[ℂ] H) (u v : H),
      Phi T u v = inner ℂ (u ⊗ₜ[ℂ] v) T) ∧
    (∀ (x y u v : H),
      Phi (x ⊗ₜ[ℂ] y) u v = inner ℂ u x * inner ℂ v y) ∧
    (∀ (m : ℕ) (c : Fin m → ℂ) (x y : Fin m → H) (u v : H),
      Phi (∑ i, c i • (x i ⊗ₜ[ℂ] y i)) u v =
        ∑ i, c i * (inner ℂ u (x i) * inner ℂ v (y i))) ∧
    -- Compatibility also tests an arbitrary second quotient argument.
    (∀ (m : ℕ) (c : Fin m → ℂ) (x y : Fin m → H) (T : H ⊗[ℂ] H),
      inner ℂ (∑ i, c i • (x i ⊗ₜ[ℂ] y i)) T =
        ∑ i, star (c i) * Phi T (x i) (y i)) ∧
    -- Only uniqueness among sesquilinear extensions with this pure rule.
    -- P is a comparison extension in the conclusion, not construction input.
    (∀ P : (H ⊗[ℂ] H) →ₛₗ[starRingEnd ℂ] ((H ⊗[ℂ] H) →ₗ[ℂ] ℂ),
      (∀ (u₁ u₂ v₁ v₂ : H),
        P (u₁ ⊗ₜ[ℂ] u₂) (v₁ ⊗ₜ[ℂ] v₂) =
          inner ℂ u₁ v₁ * inner ℂ u₂ v₂) →
      ∀ (S T : H ⊗[ℂ] H), P S T = inner ℂ S T)

end NumStability.Bhatia.Chapter01.Targets
