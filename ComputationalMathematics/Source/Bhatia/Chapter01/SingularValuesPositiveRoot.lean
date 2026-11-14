/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.SingularValuesPositiveRootTarget

/-!
# Bhatia's prescribed full singular-value tuple

The positive Gram square root has a full nonnegative decreasing spectral tuple.
Counting every complex scalar includes scalars outside the spectrum and the
empty tuple in dimension zero.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

/-- The prescribed root's sorted tuple includes every eigenvalue multiplicity. -/
theorem singularValuesPositiveRoot : Targets.singularValuesPositiveRootChoice.{u} := by
  classical
  intro H _ _ _ A
  let G := (LinearMap.adjoint A).comp A
  let P := NumStability.positiveSquareRoot G
    (LinearMap.isPositive_adjoint_comp_self A)
  have hP : P.IsPositive := NumStability.positiveSquareRoot_isPositive G
    (LinearMap.isPositive_adjoint_comp_self A)
  change (∀ i : Fin (Module.finrank ℂ H),
      0 ≤ hP.isSymmetric.eigenvalues rfl i) ∧
    Antitone (hP.isSymmetric.eigenvalues rfl) ∧
    ∀ μ : ℂ, (Finset.univ.filter (fun i : Fin (Module.finrank ℂ H) =>
      (hP.isSymmetric.eigenvalues rfl i : ℂ) = μ)).card =
        Module.finrank ℂ (Module.End.eigenspace P μ)
  refine ⟨hP.nonneg_eigenvalues rfl, hP.isSymmetric.eigenvalues_antitone rfl, ?_⟩
  intro μ
  by_cases hμ : Module.End.HasEigenvalue P μ
  · exact hP.isSymmetric.card_filter_eigenvalues_eq rfl hμ
  · have heig : Module.End.eigenspace P μ = ⊥ := by
      by_contra hne
      exact hμ (Module.End.hasEigenvalue_iff.mpr hne)
    have hempty : (Finset.univ.filter (fun i : Fin (Module.finrank ℂ H) =>
        (hP.isSymmetric.eigenvalues rfl i : ℂ) = μ)) = ∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro i hi
      have hiμ := (Finset.mem_filter.mp hi).2
      apply hμ
      exact hiμ ▸ hP.isSymmetric.hasEigenvalue_eigenvalues rfl i
    rw [hempty, Finset.card_empty, heig, finrank_bot]

end NumStability.Bhatia.Chapter01
