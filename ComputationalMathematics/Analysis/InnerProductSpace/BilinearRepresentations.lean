/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Dual
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.BilinearForm.Hom

/-!
# Orthonormal representation of bilinear functionals

For a fixed finite orthonormal basis in the first space, every ordinary
complex bilinear functional has a unique representation by a family of
vectors in the second space. The representers come from the existing
Fréchet–Riesz equivalence. For bilinear forms on one finite-dimensional
space this gives a finite sum of elementary inner-functional products.
Empty bases and zero-dimensional spaces are included.
-/

set_option autoImplicit false

noncomputable section

open scoped BigOperators

namespace NumStability

variable {ι H K : Type*} [Fintype ι]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H]
  [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]

/-- Every bilinear functional has a unique vector family relative to a fixed
finite orthonormal basis in its first space. The two spaces may differ. -/
theorem existsUnique_bilinear_orthonormal_representation
    (e : OrthonormalBasis ι ℂ H) (B : H →ₗ[ℂ] K →ₗ[ℂ] ℂ) :
    ∃! x : ι → K, ∀ (u : H) (v : K),
      B u v = ∑ i, inner ℂ (e i) u * inner ℂ (x i) v := by
  classical
  letI : CompleteSpace K := FiniteDimensional.complete ℂ K
  let x : ι → K := fun i =>
    (InnerProductSpace.toDual ℂ K).symm ((B (e i)).toContinuousLinearMap)
  have hx (i : ι) (v : K) : inner ℂ (x i) v = B (e i) v :=
    InnerProductSpace.toDual_symm_apply
  refine ⟨x, ?_, ?_⟩
  · intro u v
    calc
      B u v = B (∑ i, inner ℂ (e i) u • e i) v := by rw [e.sum_repr']
      _ = ∑ i, inner ℂ (e i) u * inner ℂ (x i) v := by simp [hx]
  · intro y hy
    funext i
    apply ext_inner_right ℂ
    intro v
    have h := hy (e i) v
    simpa [OrthonormalBasis.inner_eq_ite, hx] using h.symm

/-- All bilinear forms on a finite-dimensional complex inner-product space
are finite complex linear combinations of elementary inner-functional
products. The number of terms may be zero. -/
theorem exists_bilinearForm_eq_sum_linMulLin
    [FiniteDimensional ℂ H] (B : H →ₗ[ℂ] H →ₗ[ℂ] ℂ) :
    ∃ m : ℕ, ∃ c : Fin m → ℂ, ∃ x y : Fin m → H,
      B = ∑ i, c i • LinearMap.BilinForm.linMulLin
        (innerSL ℂ (x i)).toLinearMap (innerSL ℂ (y i)).toLinearMap := by
  let e := stdOrthonormalBasis ℂ H
  obtain ⟨y, hy, _⟩ := existsUnique_bilinear_orthonormal_representation e B
  refine ⟨Module.finrank ℂ H, fun _ => 1, e, y, ?_⟩
  apply LinearMap.ext₂
  intro u v
  simpa using hy u v

end NumStability
