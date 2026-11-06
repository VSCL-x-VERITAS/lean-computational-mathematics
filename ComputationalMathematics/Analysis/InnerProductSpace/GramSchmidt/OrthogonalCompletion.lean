/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Diagonal

/-!
# Completing an orthogonal family with zero entries

An orthogonal family whose length is the ambient dimension has a complete
orthonormal basis with nonnegative diagonal input coefficients. Nonzero family
vectors are normalized in their original positions, while zero positions are
filled by the completed Gram–Schmidt basis. Every off-diagonal coefficient
vanishes, including coefficients along the newly filled vectors.

No independence, nonzero-vector, or positive-dimension assumption is required.
-/

set_option autoImplicit false

namespace NumStability

/-- Complete a possibly zero orthogonal family to an orthonormal basis whose
input coefficient matrix is diagonal, with the vector norms as its diagonal. -/
theorem exists_orthonormalBasis_inner_eq_norm_of_orthogonal
    {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]
    [FiniteDimensional 𝕜 H] {n : ℕ} (hdim : Module.finrank 𝕜 H = n)
    (f : Fin n → H) (hf : Pairwise fun i j => inner 𝕜 (f i) (f j) = 0) :
    ∃ Y : OrthonormalBasis (Fin n) 𝕜 H,
      ∀ i j : Fin n, inner 𝕜 (Y i) (f j) = if i = j then (‖f j‖ : 𝕜) else 0 := by
  classical
  have hcard : Module.finrank 𝕜 H = Fintype.card (Fin n) := by simpa using hdim
  let Y : OrthonormalBasis (Fin n) 𝕜 H :=
    InnerProductSpace.gramSchmidtOrthonormalBasis hcard f
  refine ⟨Y, ?_⟩
  intro i j
  by_cases hij : i = j
  · subst j
    rw [if_pos rfl]
    change inner 𝕜 (InnerProductSpace.gramSchmidtOrthonormalBasis hcard f i) (f i) = _
    rw [inner_gramSchmidtOrthonormalBasis_input hcard f i,
      InnerProductSpace.gramSchmidt_of_orthogonal 𝕜 hf]
  · rw [if_neg hij]
    change inner 𝕜 (InnerProductSpace.gramSchmidtOrthonormalBasis hcard f i) (f j) = 0
    by_cases hi : f i = 0
    · have hraw : InnerProductSpace.gramSchmidt 𝕜 f i = 0 := by
        rw [InnerProductSpace.gramSchmidt_of_orthogonal 𝕜 hf]
        exact hi
      have hnormed : InnerProductSpace.gramSchmidtNormed 𝕜 f i = 0 :=
        (gramSchmidtNormed_eq_zero_iff f i).mpr hraw
      exact InnerProductSpace.inner_gramSchmidtOrthonormalBasis_eq_zero hcard hnormed j
    · rw [InnerProductSpace.gramSchmidtOrthonormalBasis_apply_of_orthogonal hcard hf hi,
        inner_smul_left, hf hij, mul_zero]

end NumStability
