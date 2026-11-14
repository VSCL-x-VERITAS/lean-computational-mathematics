/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.GramMatrix
import Mathlib.LinearAlgebra.Basis.Defs
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# Gram computation of a biorthogonal basis

Proof-free source target for Bhatia, Matrix Analysis (1997), Problem I.6.1,
printed page 20 / PDF page 32. The vector tuple is fixed by the inverse Gram
formula; the proposition records its basis and biorthogonality obligations.
The separate coordinate question is outside this target.
-/

set_option autoImplicit false
noncomputable section
universe u
open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

/-- Inverse-Gram output for Problem I.6.1, first sentence.
This realization is author-selected; the source prints a computation question.
Column j of the inverse Gram matrix supplies the coefficients of vector j. -/
def gramBiorthogonalBasisVectors {H : Type u}
    [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (n : ℕ) (U : Module.Basis (Fin n) ℂ H) :
    Fin n → H :=
  let G : Matrix (Fin n) (Fin n) ℂ :=
    Matrix.gram ℂ (fun i : Fin n => U i)
  fun j => ∑ i : Fin n, (G⁻¹) i j • U i

/-- Transparent first-sentence contract. The Gram-defined tuple itself
is a basis and is biorthogonal to the supplied arbitrary ordered basis.
Every finite size, including zero, is quantified. -/
def gramBiorthogonalBasisTarget : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (n : ℕ) (U : Module.Basis (Fin n) ℂ H),
    let V := gramBiorthogonalBasisVectors n U
    (∃ Vbasis : Module.Basis (Fin n) ℂ H,
      ∀ j : Fin n, Vbasis j = V j) ∧
    (∀ i j : Fin n,
      inner ℂ (V i) (U j) = (if i = j then 1 else 0 : ℂ))

end NumStability.Bhatia.Chapter01.Targets
