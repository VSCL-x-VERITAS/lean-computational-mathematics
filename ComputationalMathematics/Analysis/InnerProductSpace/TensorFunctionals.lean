/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.TensorProduct

/-!
# Tensor products as conjugate-bilinear functionals

The canonical linear realization sends a tensor `t` to the functional
`(u, v) ↦ ⟪u ⊗ₜ v, t⟫`. Its pure-tensor rule is the product of the two
inner products. In finite dimension every separately conjugate-linear
functional has a unique representing tensor, including zero-dimensional
factors. The functional carrier has its pointwise complex module structure;
no norm or isometry on that carrier is asserted.
-/

set_option autoImplicit false

noncomputable section

open scoped TensorProduct BigOperators

namespace NumStability

variable {H K : Type*}
  [NormedAddCommGroup H] [InnerProductSpace ℂ H]
  [NormedAddCommGroup K] [InnerProductSpace ℂ K]

/-- The canonical linear realization into all algebraic conjugate-bilinear
functionals, obtained by currying the tensor inner product. -/
def tensorConjugateBilinearMap :
    H ⊗[ℂ] K →ₗ[ℂ] H →ₛₗ[starRingEnd ℂ] K →ₛₗ[starRingEnd ℂ] ℂ :=
  (TensorProduct.lcurry (starRingEnd ℂ) H K ℂ).comp
    (LinearMap.flip (innerₛₗ ℂ (E := H ⊗[ℂ] K)))

@[simp]
theorem tensorConjugateBilinearMap_apply (t : H ⊗[ℂ] K) (u : H) (v : K) :
    tensorConjugateBilinearMap t u v = inner ℂ (u ⊗ₜ[ℂ] v) t := rfl

@[simp]
theorem tensorConjugateBilinearMap_tmul (x u : H) (y v : K) :
    tensorConjugateBilinearMap (x ⊗ₜ[ℂ] y) u v = inner ℂ u x * inner ℂ v y :=
  TensorProduct.inner_tmul ℂ u x v y

/-- Evaluation against all pure tensors determines a tensor uniquely. -/
theorem tensorConjugateBilinearMap_injective :
    Function.Injective (tensorConjugateBilinearMap (H := H) (K := K)) := by
  intro s t h
  apply TensorProduct.ext_iff_inner_left.mpr
  intro u v
  exact LinearMap.congr_fun (LinearMap.congr_fun h u) v

variable [FiniteDimensional ℂ H] [FiniteDimensional ℂ K]

/-- In finite dimension every algebraic conjugate-bilinear functional is
represented by a tensor. No positive dimension is required. -/
theorem tensorConjugateBilinearMap_surjective :
    Function.Surjective (tensorConjugateBilinearMap (H := H) (K := K)) := by
  classical
  intro B
  let e := stdOrthonormalBasis ℂ H
  let f := stdOrthonormalBasis ℂ K
  refine ⟨∑ i, ∑ j, B (e i) (f j) • (e i ⊗ₜ[ℂ] f j), ?_⟩
  apply e.toBasis.ext
  intro a
  apply f.toBasis.ext
  intro b
  simp [tensorConjugateBilinearMap_apply,
    TensorProduct.inner_tmul, OrthonormalBasis.inner_eq_ite]

/-- The canonical linear identification with the entire pointwise module
of separately conjugate-linear functionals. -/
def tensorConjugateBilinearEquiv :
    H ⊗[ℂ] K ≃ₗ[ℂ] H →ₛₗ[starRingEnd ℂ] K →ₛₗ[starRingEnd ℂ] ℂ :=
  LinearEquiv.ofBijective tensorConjugateBilinearMap
    ⟨tensorConjugateBilinearMap_injective, tensorConjugateBilinearMap_surjective⟩

@[simp]
theorem tensorConjugateBilinearEquiv_apply (t : H ⊗[ℂ] K) (u : H) (v : K) :
    tensorConjugateBilinearEquiv t u v = inner ℂ (u ⊗ₜ[ℂ] v) t := rfl

/-- Every conjugate-bilinear functional has exactly one representing tensor. -/
theorem existsUnique_tensor_inner_representation
    (B : H →ₛₗ[starRingEnd ℂ] K →ₛₗ[starRingEnd ℂ] ℂ) :
    ∃! t : H ⊗[ℂ] K, ∀ (u : H) (v : K), inner ℂ (u ⊗ₜ[ℂ] v) t = B u v := by
  obtain ⟨t, ht⟩ := tensorConjugateBilinearMap_surjective B
  refine ⟨t, fun u v => LinearMap.congr_fun (LinearMap.congr_fun ht u) v, ?_⟩
  intro s hs
  apply tensorConjugateBilinearMap_injective
  apply LinearMap.ext₂
  intro u v
  exact (hs u v).trans (LinearMap.congr_fun (LinearMap.congr_fun ht u) v).symm

end NumStability
