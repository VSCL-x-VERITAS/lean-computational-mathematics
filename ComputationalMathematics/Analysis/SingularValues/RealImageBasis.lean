import ComputationalMathematics.Analysis.SingularValues.RealSVD
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.Finsupp.LinearCombination

/-!
# Image bases from supplied real singular-value decompositions

The retained left singular vectors of a supplied real SVD certificate span the
matrix image. Lifting those same vectors into the image gives an explicit basis,
including when the rank is zero. The image equality uses the certificate's
`rank_eq`; this module does not construct an SVD certificate.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.RealImageBasis

variable {m n r : ℕ}
variable {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
variable {u : Fin r → EuclideanSpace ℝ (Fin m)}
variable {v : Fin r → EuclideanSpace ℝ (Fin n)}

/-- The retained vectors in the ordinary coordinate carrier of `mulVecLin`. -/
def leftCoordinates (u : Fin r → EuclideanSpace ℝ (Fin m)) :
    Fin r → (Fin m → ℝ) := fun k ↦ WithLp.ofLp (u k)

theorem leftCoordinates_linearIndependent (h : IsRealMatrixSVD A r s u v) :
    LinearIndependent ℝ (leftCoordinates u) := by
  let e := WithLp.linearEquiv 2 ℝ (Fin m → ℝ)
  have hi := h.leftSingularVectors_orthonormal.linearIndependent.map_injOn
    e.toLinearMap (fun _ _ _ _ hxy ↦ e.injective hxy)
  simpa only [Function.comp_def, leftCoordinates, WithLp.coe_linearEquiv] using hi

theorem range_le_leftCoordinates_span (h : IsRealMatrixSVD A r s u v) :
    LinearMap.range A.mulVecLin ≤ Submodule.span ℝ (Set.range (leftCoordinates u)) := by
  classical
  rw [Matrix.range_mulVecLin]
  refine Submodule.span_le.mpr ?_
  rintro _ ⟨j, rfl⟩
  apply (Submodule.mem_span_range_iff_exists_fun ℝ).mpr
  refine ⟨fun k ↦ s (Fin.castLE h.rank_le_width k) * v k j, ?_⟩
  ext i
  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  change (∑ k : Fin r, (s (Fin.castLE h.rank_le_width k) * v k j) * u k i) = A i j
  rw [h.reconstruction i j]
  apply Finset.sum_congr rfl
  intro k _
  exact mul_right_comm _ _ _

/-- Exact image/span equality, using the supplied certificate's `rank_eq`. -/
theorem range_eq_leftCoordinates_span (h : IsRealMatrixSVD A r s u v) :
    LinearMap.range A.mulVecLin = Submodule.span ℝ (Set.range (leftCoordinates u)) := by
  apply Submodule.eq_of_le_of_finrank_eq (range_le_leftCoordinates_span h)
  calc
    Module.finrank ℝ (LinearMap.range A.mulVecLin) = A.rank := rfl
    _ = r := h.rank_eq.symm
    _ = Module.finrank ℝ (Submodule.span ℝ (Set.range (leftCoordinates u))) := by
      simpa only [Fintype.card_fin] using
        (finrank_span_eq_card (leftCoordinates_linearIndependent h)).symm

/-- The exact retained coordinate vectors lifted into the exact real image. -/
def imageFamily (h : IsRealMatrixSVD A r s u v) :
    Fin r → LinearMap.range A.mulVecLin := fun k ↦
  ⟨leftCoordinates u k, by
    rw [range_eq_leftCoordinates_span h]
    exact Submodule.subset_span ⟨k, rfl⟩⟩

@[simp] theorem imageFamily_val (h : IsRealMatrixSVD A r s u v) (k : Fin r) :
    (imageFamily h k).val = WithLp.ofLp (u k) := rfl

theorem imageFamily_linearIndependent (h : IsRealMatrixSVD A r s u v) :
    LinearIndependent ℝ (imageFamily h) := by
  apply LinearIndependent.of_comp (LinearMap.range A.mulVecLin).subtype
  simpa only [Function.comp_def, imageFamily] using leftCoordinates_linearIndependent h

theorem imageFamily_span_eq_top (h : IsRealMatrixSVD A r s u v) :
    Submodule.span ℝ (Set.range (imageFamily h)) = ⊤ := by
  apply (imageFamily_linearIndependent h).span_eq_top_of_card_eq_finrank'
  simpa only [Fintype.card_fin, Matrix.rank] using h.rank_eq

/-- `Basis.mk` on the supplied vectors, with no nonempty-index premise. -/
def imageBasis (h : IsRealMatrixSVD A r s u v) :
    Module.Basis (Fin r) ℝ (LinearMap.range A.mulVecLin) :=
  Module.Basis.mk (imageFamily_linearIndependent h) (by rw [imageFamily_span_eq_top h])

theorem imageBasis_coe (h : IsRealMatrixSVD A r s u v) :
    ⇑(imageBasis h) = imageFamily h := by
  exact Module.Basis.coe_mk _ _

@[simp] theorem imageBasis_val (h : IsRealMatrixSVD A r s u v) (k : Fin r) :
    ((imageBasis h k : LinearMap.range A.mulVecLin) : Fin m → ℝ) = WithLp.ofLp (u k) := by
  rw [show imageBasis h k = imageFamily h k from congrFun (imageBasis_coe h) k]
  rfl

end NumStability.RealImageBasis
