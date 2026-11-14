/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.Frobenius

/-!
# Frobenius norm and trace identities

Bhatia, Matrix Analysis, Section I.2, printed page 7 (PDF page 19), with the
finite complex Hilbert setting and singular-value definition from printed
pages 1–6 (PDF pages 13–18).

The singular values are the full eigenvalue tuple of the actual positive
absolute value. The propositions retain the actual complex Gram trace and
quantify the coordinate formula over every orthonormal basis.
-/

set_option autoImplicit false
open scoped BigOperators

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Printed page 7: the singular-value quantity is a norm and equals the
square root of the nonnegative real Gram trace. Singular values are concretely
the full sorted eigenvalue tuple of the actual positive absolute value. -/
def frobeniusNormAndTrace : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    (∀ A : H →ₗ[ℂ] H,
      0 ≤ NumStability.linearMapFrobenius A ∧
        (NumStability.linearMapFrobenius A = 0 ↔ A = 0)) ∧
    (∀ (c : ℂ) (A : H →ₗ[ℂ] H),
      NumStability.linearMapFrobenius (c • A) = ‖c‖ * NumStability.linearMapFrobenius A) ∧
    (∀ A B : H →ₗ[ℂ] H,
      NumStability.linearMapFrobenius (A + B) ≤
        NumStability.linearMapFrobenius A + NumStability.linearMapFrobenius B) ∧
    (∀ A : H →ₗ[ℂ] H,
      let t : ℂ := LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)
      t.im = 0 ∧ 0 ≤ t.re ∧
        (((∑ j : Fin (Module.finrank ℂ H),
          NumStability.linearMapSingularValue A j ^ 2) : ℝ) : ℂ) = t ∧
        NumStability.linearMapFrobenius A = Real.sqrt t.re)

/-- Printed page 7: the entire singular-square sum, complex Gram trace and
entry-square sum agree for every orthonormal basis of the arbitrary space. -/
def frobeniusTraceAndEveryBasisEntries : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let t : ℂ := LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)
    t.im = 0 ∧ 0 ≤ t.re ∧
      (((∑ j : Fin (Module.finrank ℂ H),
        NumStability.linearMapSingularValue A j ^ 2) : ℝ) : ℂ) = t ∧
      NumStability.linearMapFrobenius A = Real.sqrt t.re ∧
      (∀ E : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H,
        let M := LinearMap.toMatrix E.toBasis E.toBasis A
        (∀ i j, M i j = inner ℂ (E i) (A (E j))) ∧
          t = (((∑ i, ∑ j, ‖M i j‖ ^ 2) : ℝ) : ℂ) ∧
          NumStability.linearMapFrobenius A = Real.sqrt (∑ i, ∑ j, ‖M i j‖ ^ 2))

end NumStability.Bhatia.Chapter01.Targets
