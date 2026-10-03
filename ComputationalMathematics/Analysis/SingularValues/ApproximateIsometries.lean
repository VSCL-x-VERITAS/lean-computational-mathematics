import ComputationalMathematics.Analysis.SingularValues.CourantFischer
import ComputationalMathematics.HDP.Scalar.SquareDeviation

/-!
# Approximate isometries from Gram-matrix control

This module converts an operator-norm bound on `Aᵀ A - I` into uniform
Euclidean distortion bounds and the corresponding bounds on the extreme
singular values of a real rectangular matrix.
-/

namespace NumStability

open scoped RealInnerProductSpace

noncomputable section

/-- Every vector is distorted by at most the multiplicative factors
`1 - δ` and `1 + δ`. -/
def ApproximateIsometryBounds {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (δ : ℝ) : Prop :=
  ∀ x : EuclideanSpace ℝ (Fin n),
    (1 - δ) * ‖x‖ ≤ ‖Matrix.toEuclideanLin A x‖ ∧
      ‖Matrix.toEuclideanLin A x‖ ≤ (1 + δ) * ‖x‖

/-- The unit-vector form of the approximate-isometry bounds. -/
def UnitApproximateIsometryBounds {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (δ : ℝ) : Prop :=
  ∀ x : EuclideanSpace ℝ (Fin n), ‖x‖ = 1 →
    1 - δ ≤ ‖Matrix.toEuclideanLin A x‖ ∧
      ‖Matrix.toEuclideanLin A x‖ ≤ 1 + δ

/-- The extreme singular values lie between the approximate-isometry
constants. -/
def ExtremeSingularValueBounds {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) (δ : ℝ) : Prop :=
  1 - δ ≤ rectCourantFischerSingularValue A (Fin.last n) ∧
    rectCourantFischerSingularValue A (Fin.last n) ≤
      rectCourantFischerSingularValue A (0 : Fin (n + 1)) ∧
    rectCourantFischerSingularValue A (0 : Fin (n + 1)) ≤ 1 + δ

/-- Converse form of the elementary square-deviation inequality: if the
square of a nonnegative number is sufficiently close to one, then the number
itself is within `δ` of one. -/
theorem abs_sub_one_le_of_abs_sq_sub_one_le_max {z δ : ℝ}
    (hz : 0 ≤ z) (hδ : 0 ≤ δ)
    (h : |z ^ 2 - 1| ≤ max δ (δ ^ 2)) : |z - 1| ≤ δ := by
  have hchain : max |z - 1| (|z - 1| ^ 2) ≤ max δ (δ ^ 2) :=
    (HDP.Scalar.SquareDeviation.max_le_abs_sq_sub_one hz
      (abs_nonneg (z - 1)) le_rfl).trans h
  by_cases hδone : δ ≤ 1
  · have hδsq : δ ^ 2 ≤ δ := by nlinarith
    rw [max_eq_left hδsq] at hchain
    exact (le_max_left |z - 1| (|z - 1| ^ 2)).trans hchain
  · have honeδ : 1 ≤ δ := le_of_lt (lt_of_not_ge hδone)
    have hδle : δ ≤ δ ^ 2 := by nlinarith
    rw [max_eq_right hδle] at hchain
    have hsq : |z - 1| ^ 2 ≤ δ ^ 2 :=
      (le_max_right |z - 1| (|z - 1| ^ 2)).trans hchain
    nlinarith [abs_nonneg (z - 1)]

/-- The quadratic form of `Aᵀ A - I` is the difference of squared norms. -/
theorem realMatrixQuadraticForm_transpose_mul_self_sub_one {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (x : EuclideanSpace ℝ (Fin n)) :
    realMatrixQuadraticForm (A.transpose * A - 1) x =
      ‖Matrix.toEuclideanLin A x‖ ^ 2 - ‖x‖ ^ 2 := by
  unfold realMatrixQuadraticForm
  rw [map_sub, Matrix.toLpLin_mul_same, Matrix.toLpLin_one]
  rw [show Matrix.toEuclideanLin A.transpose =
      (Matrix.toEuclideanLin A).adjoint by
    simpa using Matrix.toEuclideanLin_conjTranspose_eq_adjoint A]
  simp only [LinearMap.sub_apply, LinearMap.comp_apply, LinearMap.id_apply]
  rw [inner_sub_left, LinearMap.adjoint_inner_left]
  rw [real_inner_self_eq_norm_sq, real_inner_self_eq_norm_sq]

/-- Bounds on all vectors are equivalent to bounds on unit vectors.  This
formalizes the normalization step in the usual proof. -/
theorem approximateIsometryBounds_iff_unit {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (δ : ℝ) :
    ApproximateIsometryBounds A δ ↔ UnitApproximateIsometryBounds A δ := by
  constructor
  · intro h x hx
    simpa [ApproximateIsometryBounds, hx] using h x
  · intro h x
    by_cases hx : x = 0
    · simp [hx]
    · let a : ℝ := ‖x‖
      have haPos : 0 < a := norm_pos_iff.mpr hx
      let y : EuclideanSpace ℝ (Fin n) := a⁻¹ • x
      have hyNorm : ‖y‖ = 1 := by
        simp [y, a, norm_smul, haPos.ne']
      obtain ⟨hyLower, hyUpper⟩ := h y hyNorm
      have hxy : x = a • y := by
        simp [y, a, haPos.ne']
      have hmap : Matrix.toEuclideanLin A x =
          a • Matrix.toEuclideanLin A y := by
        rw [hxy, map_smul]
      have hnormMap : ‖Matrix.toEuclideanLin A x‖ =
          a * ‖Matrix.toEuclideanLin A y‖ := by
        rw [hmap, norm_smul]
        simp [a]
      constructor
      · calc
          (1 - δ) * ‖x‖ = a * (1 - δ) := by simp [a, mul_comm]
          _ ≤ a * ‖Matrix.toEuclideanLin A y‖ :=
            mul_le_mul_of_nonneg_left hyLower (le_of_lt haPos)
          _ = ‖Matrix.toEuclideanLin A x‖ := hnormMap.symm
      · calc
          ‖Matrix.toEuclideanLin A x‖ =
              a * ‖Matrix.toEuclideanLin A y‖ := hnormMap
          _ ≤ a * (1 + δ) :=
            mul_le_mul_of_nonneg_left hyUpper (le_of_lt haPos)
          _ = (1 + δ) * ‖x‖ := by simp [a, mul_comm]

/-- Gram-matrix control gives the unit-vector distortion estimate. -/
theorem unitApproximateIsometryBounds_of_gramDeviation {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ} (hδ : 0 ≤ δ)
    (hGram : realMatrixOperatorNorm (A.transpose * A - 1) ≤
      max δ (δ ^ 2)) :
    UnitApproximateIsometryBounds A δ := by
  let H : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ := A.transpose * A - 1
  have hH : H.IsHermitian := by
    simp [H, Matrix.IsHermitian]
  obtain ⟨_, ⟨_, _, _, hQuadratic⟩⟩ :=
    symmetricRealMatrixOperatorNorm_quadratic_characterization
      (Nat.succ_pos n) H hH
  intro x hx
  have hq : |‖Matrix.toEuclideanLin A x‖ ^ 2 - 1| ≤
      max δ (δ ^ 2) := by
    have := (hQuadratic x hx).trans hGram
    simpa [H, realMatrixQuadraticForm_transpose_mul_self_sub_one, hx] using this
  have habs := abs_sub_one_le_of_abs_sq_sub_one_le_max
    (norm_nonneg (Matrix.toEuclideanLin A x)) hδ hq
  constructor <;> linarith [neg_le_of_abs_le habs, le_of_abs_le habs]

/-- Gram-matrix control gives the approximate-isometry bounds for every
vector. -/
theorem approximateIsometryBounds_of_gramDeviation {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ} (hδ : 0 ≤ δ)
    (hGram : realMatrixOperatorNorm (A.transpose * A - 1) ≤
      max δ (δ ^ 2)) :
    ApproximateIsometryBounds A δ :=
  (approximateIsometryBounds_iff_unit A δ).2
    (unitApproximateIsometryBounds_of_gramDeviation A hδ hGram)

/-- Uniform approximate-isometry bounds imply the corresponding extreme
singular-value bounds. -/
theorem extremeSingularValueBounds_of_approximateIsometryBounds {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ}
    (h : ApproximateIsometryBounds A δ) :
    ExtremeSingularValueBounds A δ := by
  have hOptimal := rectCourantFischer_extremeSingularValues_areOptimalBounds A
  refine ⟨hOptimal.2.2 (1 - δ) (fun x => (h x).1), ?_,
    hOptimal.2.1 (1 + δ) (fun x => (h x).2)⟩
  exact rectCourantFischerSingularValue_antitone A
    (Fin.zero_le (Fin.last n))

/-- Source-level approximate-isometry lemma: a small operator-norm deviation
of the right Gram matrix from the identity controls every vector and both
extreme singular values.  The final equivalence records the normalization
step used in the proof. -/
theorem approximateIsometry_of_gramDeviation {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) {δ : ℝ} (hδ : 0 < δ)
    (hGram : realMatrixOperatorNorm (A.transpose * A - 1) ≤
      max δ (δ ^ 2)) :
    ApproximateIsometryBounds A δ ∧
      ExtremeSingularValueBounds A δ ∧
      (ApproximateIsometryBounds A δ ↔ UnitApproximateIsometryBounds A δ) := by
  have hBounds := approximateIsometryBounds_of_gramDeviation A hδ.le hGram
  exact ⟨hBounds, extremeSingularValueBounds_of_approximateIsometryBounds A hBounds,
    approximateIsometryBounds_iff_unit A δ⟩

end

end NumStability
