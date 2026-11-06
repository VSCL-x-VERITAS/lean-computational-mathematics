/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.Topology.FiniteConfigurations
import ComputationalMathematics.Analysis.LinearOperators.Schur.Complex.Triangulation
import Mathlib.Topology.Algebra.Module.PerfectSpace
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic

/-!
# Density of simple complex spectra

Complex square matrices with a full tuple of distinct characteristic roots are
dense in the usual finite matrix topology. Schur triangulation reduces the
construction to perturbing the diagonal through injective finite tuples.
The empty matrix is included, with characteristic polynomial the empty product.
-/

set_option autoImplicit false
open scoped Matrix BigOperators Matrix.Norms.L2Operator

namespace NumStability

/-- Every complex square matrix can be approximated by matrices with a full
tuple of distinct roots of their characteristic polynomial. -/
theorem dense_matrices_simple_spectrum (n : ℕ) :
    Dense {A : Matrix (Fin n) (Fin n) ℂ |
      ∃ b : Fin n → ℂ, Function.Injective b ∧
        A.charpoly = ∏ i : Fin n, (Polynomial.X - Polynomial.C (b i))} := by
  classical
  intro A
  obtain ⟨U, T, hU, hT, htri⟩ := schur_triangulation A
  let V : (Matrix (Fin n) (Fin n) ℂ)ˣ := Unitary.toUnits ⟨U, hU⟩
  have hT' : (↑(V⁻¹) : Matrix (Fin n) (Fin n) ℂ) * A *
      (V : Matrix (Fin n) (Fin n) ℂ) = T := hT
  have hback : (V : Matrix (Fin n) (Fin n) ℂ) * T *
      (↑(V⁻¹) : Matrix (Fin n) (Fin n) ℂ) = A := by
    rw [← hT']
    simp only [mul_assoc, Units.mul_inv, mul_one, Units.mul_inv_cancel_left]
  let F : (Fin n → ℂ) → Matrix (Fin n) (Fin n) ℂ := fun b =>
    (V : Matrix (Fin n) (Fin n) ℂ) *
      (T + Matrix.diagonal (fun i => b i - T i i)) *
      (↑(V⁻¹) : Matrix (Fin n) (Fin n) ℂ)
  have hF : Continuous F := by
    dsimp only [F]
    fun_prop
  have hdiag : F (fun i => T i i) = A := by
    simpa [F] using hback
  have himage : F '' {b : Fin n → ℂ | Function.Injective b} ⊆
      {B : Matrix (Fin n) (Fin n) ℂ |
        ∃ b : Fin n → ℂ, Function.Injective b ∧
          B.charpoly = ∏ i : Fin n, (Polynomial.X - Polynomial.C (b i))} := by
    rintro B ⟨b, hb, rfl⟩
    refine ⟨b, hb, ?_⟩
    have ht : T.BlockTriangular id := fun i j hij => htri i j hij
    have ht' := ht.add (Matrix.blockTriangular_diagonal (b := id) (fun i => b i - T i i))
    change ((V : Matrix (Fin n) (Fin n) ℂ) *
      (T + Matrix.diagonal (fun i => b i - T i i)) *
      (↑(V⁻¹) : Matrix (Fin n) (Fin n) ℂ)).charpoly = _
    rw [Matrix.charpoly_units_conj V _, Matrix.charpoly_of_upperTriangular _ ht']
    apply Finset.prod_congr rfl
    intro i hi
    congr 2
    simp only [Matrix.add_apply, Matrix.diagonal_apply_eq]
    ring
  have hclosure : F (fun i => T i i) ∈
      closure (F '' {b : Fin n → ℂ | Function.Injective b}) :=
    hF.range_subset_closure_image_dense (dense_injective_fin (X := ℂ) n) ⟨_, rfl⟩
  rw [hdiag] at hclosure
  exact closure_mono himage hclosure

end NumStability
