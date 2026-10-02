import ComputationalMathematics.Analysis.Eigenvalues.CourantFischer
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Courant--Fischer characterization of real singular values

This module transfers the real symmetric Courant--Fischer theorem to
rectangular matrices through the positive-semidefinite right Gram matrix.  The
result is stated directly in terms of Euclidean operator norms and exposes the
attainment witnesses hidden by the usual max--min notation.
-/

namespace NumStability

open scoped BigOperators RealInnerProductSpace

noncomputable section

/-- The exact right Gram matrix used by the singular-value Courant--Fischer
theorem.  This lightweight analysis definition avoids importing an
algorithm-oriented module merely to state the spectral result. -/
def rectCourantFischerRightGram {m n : ℕ}
    (A : Fin m → Fin n → ℝ) : Matrix (Fin n) (Fin n) ℝ :=
  fun j k => ∑ i : Fin m, A i j * A i k

/-- The exact right Gram matrix is symmetric. -/
theorem rectCourantFischerRightGram_symmetric {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    IsSymmetricFiniteMatrix (rectCourantFischerRightGram A) := by
  intro j k
  unfold rectCourantFischerRightGram
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- The quadratic form of the lightweight right Gram is the squared coordinate
norm of the rectangular matrix action. -/
theorem finiteQuadraticForm_rectCourantFischerRightGram_eq_sum_sq
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (x : Fin n → ℝ) :
    finiteQuadraticForm (rectCourantFischerRightGram A) x =
      ∑ i : Fin m, (∑ j : Fin n, A i j * x j) ^ 2 := by
  classical
  unfold finiteQuadraticForm finiteMatVec rectCourantFischerRightGram
  calc
    ∑ a : Fin n,
        x a * ∑ b : Fin n, (∑ i : Fin m, A i a * A i b) * x b =
        ∑ a : Fin n, ∑ b : Fin n, ∑ i : Fin m,
          (A i a * x a) * (A i b * x b) := by
      apply Finset.sum_congr rfl
      intro a _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro b _
      rw [Finset.sum_mul, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ = ∑ b : Fin n, ∑ a : Fin n, ∑ i : Fin m,
          (A i a * x a) * (A i b * x b) := by
      rw [Finset.sum_comm]
    _ = ∑ b : Fin n, ∑ i : Fin m, ∑ a : Fin n,
          (A i a * x a) * (A i b * x b) := by
      apply Finset.sum_congr rfl
      intro b _
      rw [Finset.sum_comm]
    _ = ∑ i : Fin m, ∑ b : Fin n, ∑ a : Fin n,
          (A i a * x a) * (A i b * x b) := by
      rw [Finset.sum_comm]
    _ = ∑ i : Fin m, ∑ a : Fin n, ∑ b : Fin n,
          (A i a * x a) * (A i b * x b) := by
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.sum_comm]
    _ = ∑ i : Fin m,
          (∑ a : Fin n, A i a * x a) *
            (∑ b : Fin n, A i b * x b) := by
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro a _
      rw [Finset.mul_sum]
    _ = ∑ i : Fin m, (∑ j : Fin n, A i j * x j) ^ 2 := by
      apply Finset.sum_congr rfl
      intro i _
      ring

/-- The exact right Gram matrix is Hermitian over `ℝ`. -/
def rectCourantFischerRightGram_isHermitian {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    Matrix.IsHermitian (rectCourantFischerRightGram A) :=
  (rectCourantFischerRightGram_symmetric A).to_matrix_isHermitian

/-- The decreasing singular-value sequence used by the rectangular
Courant--Fischer theorem: square roots of the decreasing eigenvalues of
`AᵀA`. -/
def rectCourantFischerSingularValue {m n : ℕ}
    (A : Fin m → Fin n → ℝ) : Fin n → ℝ :=
  fun i => Real.sqrt
    (hermitianOrderedEigenvalue
      (rectCourantFischerRightGram_isHermitian A) i)

/-- Witness form of
`σᵢ(A) = max_{dim E = i+1} min_{x ∈ E, ‖x‖ = 1} ‖Ax‖` for zero-based
indices. -/
def IsSingularValueMaxMin {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (singularValue : Fin n → ℝ)
    (i : Fin n) : Prop :=
  ∃ E : Submodule ℝ (EuclideanSpace ℝ (Fin n)),
    Module.finrank ℝ E = i.val + 1 ∧
    (∀ x : EuclideanSpace ℝ (Fin n), x ∈ E → ‖x‖ = 1 →
      singularValue i ≤ ‖Matrix.toEuclideanLin A x‖) ∧
    (∃ x : EuclideanSpace ℝ (Fin n), x ∈ E ∧ ‖x‖ = 1 ∧
      ‖Matrix.toEuclideanLin A x‖ = singularValue i) ∧
    ∀ F : Submodule ℝ (EuclideanSpace ℝ (Fin n)),
      Module.finrank ℝ F = i.val + 1 →
      ∃ x : EuclideanSpace ℝ (Fin n), x ∈ F ∧ ‖x‖ = 1 ∧
        ‖Matrix.toEuclideanLin A x‖ ≤ singularValue i

/-- The right-Gram Rayleigh form is the squared Euclidean norm of the
rectangular matrix action. -/
theorem matrixRayleighForm_rectRightGram_eq_norm_sq {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (x : EuclideanSpace ℝ (Fin n)) :
    matrixRayleighForm (rectCourantFischerRightGram A) x =
      ‖Matrix.toEuclideanLin A x‖ ^ 2 := by
  rw [matrixRayleighForm, EuclideanSpace.norm_sq_eq, PiLp.inner_apply]
  simp only [Matrix.toLpLin_apply, WithLp.ofLp_toLp]
  rw [show (∑ i : Fin n, inner ℝ (x i)
      (Matrix.mulVec (rectCourantFischerRightGram A) x i)) =
      finiteQuadraticForm (rectCourantFischerRightGram A) x by
    unfold finiteQuadraticForm finiteMatVec
    apply Finset.sum_congr rfl
    intro i _
    change (∑ j : Fin n, rectCourantFischerRightGram A i j * x j) * x i =
      x i * ∑ j : Fin n, rectCourantFischerRightGram A i j * x j
    ring]
  rw [finiteQuadraticForm_rectCourantFischerRightGram_eq_sum_sq]
  apply Finset.sum_congr rfl
  intro i _
  simp [Matrix.mulVec, dotProduct]

/-- Ordered eigenvalues of a right Gram matrix are nonnegative. -/
theorem rectGramOrderedEigenvalue_nonneg {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (i : Fin n) :
    0 ≤ hermitianOrderedEigenvalue
      (rectCourantFischerRightGram_isHermitian A) i := by
  obtain ⟨E, hdim, hlower, ⟨x, hxE, hnorm, heq⟩, hupper⟩ :=
    hermitian_courantFischer_maxMin (rectCourantFischerRightGram A)
      (rectCourantFischerRightGram_isHermitian A) i
  rw [← heq, matrixRayleighForm_rectRightGram_eq_norm_sq]
  positivity

theorem rectCourantFischerSingularValue_nonneg {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (i : Fin n) :
    0 ≤ rectCourantFischerSingularValue A i :=
  Real.sqrt_nonneg _

theorem rectCourantFischerSingularValue_sq {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (i : Fin n) :
    (rectCourantFischerSingularValue A i) ^ 2 =
      hermitianOrderedEigenvalue
        (rectCourantFischerRightGram_isHermitian A) i := by
  exact Real.sq_sqrt (rectGramOrderedEigenvalue_nonneg A i)

theorem rectCourantFischerSingularValue_antitone {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    Antitone (rectCourantFischerSingularValue A) := by
  intro i j hij
  exact Real.sqrt_le_sqrt
    (hermitianOrderedEigenvalue_antitone
      (rectCourantFischerRightGram_isHermitian A) hij)

/-- Courant--Fischer max--min theorem for every ordered singular value of a
finite real rectangular matrix. -/
theorem rect_singularValue_courantFischer_maxMin {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (i : Fin n) :
    IsSingularValueMaxMin A (rectCourantFischerSingularValue A) i := by
  obtain ⟨E, hdim, hlower, ⟨x, hxE, hnorm, heq⟩, hupper⟩ :=
    hermitian_courantFischer_maxMin (rectCourantFischerRightGram A)
      (rectCourantFischerRightGram_isHermitian A) i
  refine ⟨E, hdim, ?_, ?_, ?_⟩
  · intro y hyE hynorm
    have hsq := hlower y hyE hynorm
    rw [matrixRayleighForm_rectRightGram_eq_norm_sq] at hsq
    have hsigma := rectCourantFischerSingularValue_sq A i
    have hsigma0 := rectCourantFischerSingularValue_nonneg A i
    have hnorm0 := norm_nonneg (Matrix.toEuclideanLin A y)
    nlinarith
  · refine ⟨x, hxE, hnorm, ?_⟩
    rw [matrixRayleighForm_rectRightGram_eq_norm_sq] at heq
    have hsigma := rectCourantFischerSingularValue_sq A i
    have hsigma0 := rectCourantFischerSingularValue_nonneg A i
    have hnorm0 := norm_nonneg (Matrix.toEuclideanLin A x)
    nlinarith
  · intro F hdimF
    obtain ⟨y, hyF, hynorm, hle⟩ := hupper F hdimF
    refine ⟨y, hyF, hynorm, ?_⟩
    rw [matrixRayleighForm_rectRightGram_eq_norm_sq] at hle
    have hsigma := rectCourantFischerSingularValue_sq A i
    have hsigma0 := rectCourantFischerSingularValue_nonneg A i
    have hnorm0 := norm_nonneg (Matrix.toEuclideanLin A y)
    nlinarith

/-- The leading right-Gram singular value is the Euclidean operator norm of a
real rectangular matrix. -/
theorem rectCourantFischerSingularValue_zero_eq_operatorNorm {m n : ℕ}
    (hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ) :
    rectCourantFischerSingularValue A ⟨0, hn⟩ =
      realMatrixOperatorNorm A := by
  let i0 : Fin n := ⟨0, hn⟩
  let G := rectCourantFischerRightGram A
  let hG := rectCourantFischerRightGram_isHermitian A
  obtain ⟨_, ⟨x, hxunit, hxatt, hxbound⟩, _⟩ :=
    realMatrixOperatorNorm_characterization hn A
  have htrailtop : hermitianTrailSubspace hG i0 = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    rw [finrank_hermitianTrailSubspace, finrank_euclideanSpace_fin]
    simp [i0]
  have hxtrail : x ∈ hermitianTrailSubspace hG i0 := by
    rw [htrailtop]
    trivial
  have hxray :=
    rayleigh_le_hermitianOrderedEigenvalue_mul_norm_sq_of_mem_trail
      hG i0 hxtrail
  rw [matrixRayleighForm_rectRightGram_eq_norm_sq, hxunit, one_pow,
    mul_one] at hxray
  have hsigmaSq := rectCourantFischerSingularValue_sq A i0
  have hsigma0 := rectCourantFischerSingularValue_nonneg A i0
  have hop0 : 0 ≤ realMatrixOperatorNorm A := norm_nonneg _
  have hop_le_sigma : realMatrixOperatorNorm A ≤
      rectCourantFischerSingularValue A i0 := by
    rw [hxatt] at hxray
    nlinarith
  let e : EuclideanSpace ℝ (Fin n) := hermitianOrderedEigenbasis hG i0
  have heunit : ‖e‖ = 1 := norm_hermitianOrderedEigenbasis hG i0
  have heray := matrixRayleighForm_hermitianOrderedEigenbasis hG i0
  rw [matrixRayleighForm_rectRightGram_eq_norm_sq] at heray
  have heq : ‖Matrix.toEuclideanLin A e‖ =
      rectCourantFischerSingularValue A i0 := by
    nlinarith [norm_nonneg (Matrix.toEuclideanLin A e)]
  have hsigma_le_op : rectCourantFischerSingularValue A i0 ≤
      realMatrixOperatorNorm A := by
    rw [← heq]
    exact hxbound e heunit
  exact le_antisymm hsigma_le_op hop_le_sigma

/-- The exact semantic content of saying that `m` and `M` are respectively
the largest lower and smallest upper Euclidean expansion constants of `A`. -/
def AreOptimalExtremeSingularValueBounds {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (lower upper : ℝ) : Prop :=
  (∀ x : EuclideanSpace ℝ (Fin n),
      lower * ‖x‖ ≤ ‖Matrix.toEuclideanLin A x‖ ∧
        ‖Matrix.toEuclideanLin A x‖ ≤ upper * ‖x‖) ∧
    (∀ upper' : ℝ,
      (∀ x : EuclideanSpace ℝ (Fin n),
        ‖Matrix.toEuclideanLin A x‖ ≤ upper' * ‖x‖) →
      upper ≤ upper') ∧
    ∀ lower' : ℝ,
      (∀ x : EuclideanSpace ℝ (Fin n),
        lower' * ‖x‖ ≤ ‖Matrix.toEuclideanLin A x‖) →
      lower' ≤ lower

/-- The least and greatest singular values are exactly the optimal upper and
lower Euclidean expansion constants.  The domain is written as `Fin (n + 1)`
so that both extreme indices exist without an additional nonemptiness
hypothesis. -/
theorem rectCourantFischer_extremeSingularValues_areOptimalBounds {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
    AreOptimalExtremeSingularValueBounds A
      (rectCourantFischerSingularValue A (Fin.last n))
      (rectCourantFischerSingularValue A (0 : Fin (n + 1))) := by
  let smin := rectCourantFischerSingularValue A (Fin.last n)
  let smax := rectCourantFischerSingularValue A (0 : Fin (n + 1))
  obtain ⟨E, hdim, hlower, ⟨xmin, hxminE, hxminNorm, hxminEq⟩, _⟩ :=
    rect_singularValue_courantFischer_maxMin A (Fin.last n)
  have hEtop : E = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    rw [hdim, finrank_euclideanSpace_fin]
    simp
  have hminUnit : ∀ x : EuclideanSpace ℝ (Fin (n + 1)), ‖x‖ = 1 →
      smin ≤ ‖Matrix.toEuclideanLin A x‖ := by
    intro x hx
    exact hlower x (by rw [hEtop]; trivial) hx
  have hminAll : ∀ x : EuclideanSpace ℝ (Fin (n + 1)),
      smin * ‖x‖ ≤ ‖Matrix.toEuclideanLin A x‖ := by
    intro x
    by_cases hx : x = 0
    · simp [hx]
    · let a : ℝ := ‖x‖
      have haPos : 0 < a := norm_pos_iff.mpr hx
      let y : EuclideanSpace ℝ (Fin (n + 1)) := a⁻¹ • x
      have hyNorm : ‖y‖ = 1 := by
        simp [y, a, norm_smul, haPos.ne']
      have hyLower := hminUnit y hyNorm
      have hxy : x = a • y := by
        simp [y, a, haPos.ne']
      have hmap : Matrix.toEuclideanLin A x =
          a • Matrix.toEuclideanLin A y := by
        rw [hxy, map_smul]
      have hnormMap : ‖Matrix.toEuclideanLin A x‖ =
          a * ‖Matrix.toEuclideanLin A y‖ := by
        rw [hmap, norm_smul]
        simp [a]
      calc
        smin * ‖x‖ = a * smin := by simp [a, mul_comm]
        _ ≤ a * ‖Matrix.toEuclideanLin A y‖ :=
          mul_le_mul_of_nonneg_left hyLower (le_of_lt haPos)
        _ = ‖Matrix.toEuclideanLin A x‖ := hnormMap.symm
  obtain ⟨_, ⟨xmax, hxmaxNorm, hxmaxEq, _⟩, _⟩ :=
    realMatrixOperatorNorm_characterization (Nat.succ_pos n) A
  have hsmax : smax = realMatrixOperatorNorm A := by
    exact rectCourantFischerSingularValue_zero_eq_operatorNorm
      (Nat.succ_pos n) A
  have hmaxAll : ∀ x : EuclideanSpace ℝ (Fin (n + 1)),
      ‖Matrix.toEuclideanLin A x‖ ≤ smax * ‖x‖ := by
    intro x
    rw [hsmax]
    exact ContinuousLinearMap.le_opNorm (realMatrixContinuousLinearMap A) x
  refine ⟨?_, ?_, ?_⟩
  · intro x
    exact ⟨hminAll x, hmaxAll x⟩
  · intro upper' hupper'
    have h := hupper' xmax
    rw [hxmaxNorm, mul_one, hxmaxEq, ← hsmax] at h
    exact h
  · intro lower' hlower'
    have h := hlower' xmin
    rw [hxminNorm, mul_one, hxminEq] at h
    exact h

/-- The extreme singular values control every pairwise distance under a real
rectangular matrix.  This is the vector bound applied to the difference of
the two inputs. -/
theorem rectCourantFischer_extremeSingularValues_distanceBounds {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
    ∀ x y : EuclideanSpace ℝ (Fin (n + 1)),
      rectCourantFischerSingularValue A (Fin.last n) * ‖x - y‖ ≤
          ‖Matrix.toEuclideanLin A x - Matrix.toEuclideanLin A y‖ ∧
        ‖Matrix.toEuclideanLin A x - Matrix.toEuclideanLin A y‖ ≤
          rectCourantFischerSingularValue A (0 : Fin (n + 1)) * ‖x - y‖ := by
  intro x y
  simpa only [map_sub] using
    (rectCourantFischer_extremeSingularValues_areOptimalBounds A).1 (x - y)

end

end NumStability
