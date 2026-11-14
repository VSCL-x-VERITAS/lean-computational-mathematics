/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Chapter I.5. Runtime proof-free proposal.
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.WedgeDefinitions
import Mathlib.LinearAlgebra.Span.Defs


/-!
# Symmetric tensor product and its full span

Proof-free contract for Bhatia, Matrix Analysis (1997), I.5, printed page 16.
The actual tensor quotient uses the unsigned sum over all permutations with
coefficient `1 / sqrt(k!)`. The subspace spans every input tuple. Source claims
use positive degree and impose no positive-dimension or distinctness condition.
The inherited tensor Hilbert structure and later basis/dimension assertions
remain separate obligations.
-/

set_option autoImplicit false
universe u
open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- The prescribed unsigned normalized sum in the actual tensor quotient.
The shared coefficient has exactly the source value 1 / sqrt(k!). -/
def normalizedSymmetricProduct {H : Type u} [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (k : ℕ) (_hk : 0 < k) (x : Fin k → H) :
    PiTensorProduct ℂ (fun _ : Fin k => H) :=
  wedgeCoefficient k •
    ∑ σ : Equiv.Perm (Fin k),
      PiTensorProduct.tprod ℂ (fun i : Fin k => x (σ i))

/-- The full span over every input tuple, inside the same tensor quotient. -/
def symmetricSpace (H : Type u) [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (k : ℕ) (hk : 0 < k) :
    Submodule ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  Submodule.span ℂ (Set.range (normalizedSymmetricProduct k hk :
    (Fin k → H) → PiTensorProduct ℂ (fun _ : Fin k => H)))

/-- Both definitions in I.5.symmetric-product, over the complete source domain. -/
def symmetricProductDefinition : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (hk : 0 < k),
    (∀ x : Fin k → H,
      normalizedSymmetricProduct k hk x =
        (((Real.sqrt (Nat.factorial k : ℝ))⁻¹ : ℝ) : ℂ) •
          ∑ σ : Equiv.Perm (Fin k),
            PiTensorProduct.tprod ℂ (fun i : Fin k => x (σ i))) ∧
    symmetricSpace H k hk =
      Submodule.span ℂ (Set.range (normalizedSymmetricProduct k hk :
        (Fin k → H) → PiTensorProduct ℂ (fun _ : Fin k => H)))

end

end NumStability.Bhatia.Chapter01.Targets
