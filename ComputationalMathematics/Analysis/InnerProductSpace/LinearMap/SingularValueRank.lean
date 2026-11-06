/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.AbsoluteValue
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Absolute values, kernels, and singular-value rank

The actual positive absolute value preserves the image norm of each vector.
It therefore has the same kernel and range dimension as the original operator.
The positive entries in the full singular-value tuple count that dimension,
with zero eigenvalues retained with their multiplicities.

All statements allow a zero-dimensional complex Hilbert space.
-/

set_option autoImplicit false

namespace NumStability

variable {H : Type*} [NormedAddCommGroup H]
variable [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

/-- Applying the actual absolute value preserves the norm of an operator's
image of every vector. -/
theorem norm_linearMapAbs_apply (A : H →ₗ[ℂ] H) (x : H) :
    ‖linearMapAbs A x‖ = ‖A x‖ := by
  have hsq := congrArg (fun T : H →ₗ[ℂ] H => T x) (linearMapAbs_comp_self A)
  simp only [LinearMap.comp_apply] at hsq
  have hinner : inner ℂ (linearMapAbs A x) (linearMapAbs A x) =
      inner ℂ (A x) (A x) := by
    calc
      inner ℂ (linearMapAbs A x) (linearMapAbs A x) =
          inner ℂ x (linearMapAbs A (linearMapAbs A x)) :=
        (linearMapAbs_isPositive A).isSymmetric x (linearMapAbs A x)
      _ = inner ℂ x (LinearMap.adjoint A (A x)) :=
        congrArg (fun y => inner ℂ x y) hsq
      _ = inner ℂ (A x) (A x) := LinearMap.adjoint_inner_right A x (A x)
  rw [norm_eq_sqrt_re_inner (𝕜 := ℂ) (linearMapAbs A x),
    norm_eq_sqrt_re_inner (𝕜 := ℂ) (A x), hinner]

/-- The actual absolute value and the original operator have exactly the
same kernel. -/
theorem ker_linearMapAbs (A : H →ₗ[ℂ] H) :
    (linearMapAbs A).ker = A.ker := by
  ext x
  change linearMapAbs A x = 0 ↔ A x = 0
  constructor
  · intro hx
    apply norm_eq_zero.mp
    rw [← norm_linearMapAbs_apply A x, hx, norm_zero]
  · intro hx
    apply norm_eq_zero.mp
    rw [norm_linearMapAbs_apply A x, hx, norm_zero]

/-- The actual absolute value and the original operator have the same
finite-dimensional range dimension. -/
theorem finrank_range_linearMapAbs (A : H →ₗ[ℂ] H) :
    Module.finrank ℂ (linearMapAbs A).range = Module.finrank ℂ A.range := by
  have habs := (linearMapAbs A).finrank_range_add_finrank_ker
  rw [ker_linearMapAbs A] at habs
  exact Nat.add_right_cancel (habs.trans A.finrank_range_add_finrank_ker.symm)

/-- The number of positive entries in the actual full singular-value tuple
is the range dimension, including when the tuple is empty. -/
theorem card_positive_linearMapSingularValue (A : H →ₗ[ℂ] H) :
    (Finset.univ.filter (fun i : Fin (Module.finrank ℂ H) =>
      0 < linearMapSingularValue A i)).card = Module.finrank ℂ A.range := by
  classical
  let P := linearMapAbs A
  have hP := linearMapAbs_isPositive A
  have hzero :
      (Finset.univ.filter (fun i : Fin (Module.finrank ℂ H) =>
        linearMapSingularValue A i = 0)).card = Module.finrank ℂ P.ker := by
    by_cases h0 : Module.End.HasEigenvalue P 0
    · have hc := hP.isSymmetric.card_filter_eigenvalues_eq
        (n := Module.finrank ℂ H) rfl h0
      rw [Module.End.eigenspace_zero] at hc
      simpa [linearMapSingularValue, P] using hc
    · have hker : P.ker = ⊥ := by
        simpa only [Module.End.hasEigenvalue_iff, Module.End.eigenspace_zero,
          not_not] using h0
      have hf :
          (Finset.univ.filter (fun i : Fin (Module.finrank ℂ H) =>
            linearMapSingularValue A i = 0)).card = 0 := by
        rw [Finset.card_eq_zero, Finset.filter_eq_empty_iff]
        intro i _ hi
        apply h0
        have hv : Module.End.HasEigenvalue P (linearMapSingularValue A i : ℂ) :=
          hP.isSymmetric.hasEigenvalue_eigenvalues rfl i
        simpa [hi] using hv
      rw [hker, finrank_bot]
      exact hf
  have hpos (i : Fin (Module.finrank ℂ H)) :
      (¬ linearMapSingularValue A i = 0) ↔ 0 < linearMapSingularValue A i :=
    ⟨fun hi => lt_of_le_of_ne (linearMapSingularValue_nonneg A i) (Ne.symm hi),
      fun hi => ne_of_gt hi⟩
  have hsplit := Finset.card_filter_add_card_filter_not
    (s := (Finset.univ : Finset (Fin (Module.finrank ℂ H))))
    (fun i => linearMapSingularValue A i = 0)
  simp_rw [hpos] at hsplit
  rw [hzero, show P.ker = A.ker from ker_linearMapAbs A,
    Finset.card_univ, Fintype.card_fin] at hsplit
  exact Nat.add_right_cancel
    ((Nat.add_comm _ _).trans (hsplit.trans A.finrank_range_add_finrank_ker.symm))

end NumStability
