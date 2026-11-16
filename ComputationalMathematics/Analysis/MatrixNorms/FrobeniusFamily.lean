import ComputationalMathematics.Analysis.MatrixNorms.UnitarilyInvariant

/-!
# Frobenius norms as an isometrically coherent unitarily invariant family

The concrete norm satisfies the usual fixed-shape norm axioms. Its coherence
across rectangular shapes follows from the Gram equation for column isometries;
no product-norm inequalities are assumptions of this construction.
-/

namespace NumStability

open scoped BigOperators Matrix

/-- Entrywise vectorization identifies the explicit Frobenius norm with a
Euclidean norm, including empty rectangular shapes. -/
theorem complexMatrixFrobenius_eq_euclideanNorm {m n : ℕ} (A : CMatrix m n) :
    complexMatrixFrobenius A =
      ‖(WithLp.toLp 2 (fun ij : Fin m × Fin n => A ij.1 ij.2) :
        EuclideanSpace ℂ (Fin m × Fin n))‖ := by
  apply (sq_eq_sq₀ (complexMatrixFrobenius_nonneg A) (norm_nonneg _)).mp
  rw [complexMatrixFrobenius_sq, EuclideanSpace.norm_sq_eq,
    complexMatrixFrobeniusSq_eq_entrywise_sum]

/-- Frobenius definiteness, including empty rectangular shapes. -/
theorem complexMatrixFrobenius_eq_zero_iff {m n : ℕ} (A : CMatrix m n) :
    complexMatrixFrobenius A = 0 ↔ A = 0 := by
  rw [complexMatrixFrobenius_eq_euclideanNorm, norm_eq_zero]
  constructor
  · intro h
    funext i j
    exact congrArg (fun v : EuclideanSpace ℂ (Fin m × Fin n) => v (i, j)) h
  · intro h
    subst A
    rfl

/-- Absolute homogeneity of the complex Frobenius norm. -/
theorem complexMatrixFrobenius_smul {m n : ℕ} (a : ℂ) (A : CMatrix m n) :
    complexMatrixFrobenius (a • A) = ‖a‖ * complexMatrixFrobenius A := by
  simp only [complexMatrixFrobenius_eq_euclideanNorm]
  change ‖a • (WithLp.toLp 2 (fun ij : Fin m × Fin n => A ij.1 ij.2) :
    EuclideanSpace ℂ (Fin m × Fin n))‖ = _
  exact norm_smul _ _

/-- Frobenius triangle inequality. -/
theorem complexMatrixFrobenius_add_le {m n : ℕ} (A B : CMatrix m n) :
    complexMatrixFrobenius (A + B) ≤ complexMatrixFrobenius A + complexMatrixFrobenius B := by
  simp only [complexMatrixFrobenius_eq_euclideanNorm]
  exact norm_add_le
    (WithLp.toLp 2 (fun ij : Fin m × Fin n => A ij.1 ij.2) :
      EuclideanSpace ℂ (Fin m × Fin n))
    (WithLp.toLp 2 (fun ij : Fin m × Fin n => B ij.1 ij.2))

/-- The complexification of the squared Frobenius norm is the Gram trace. -/
theorem complexMatrixFrobeniusSq_eq_trace_gram {m n : ℕ} (A : CMatrix m n) :
    (complexMatrixFrobeniusSq A : ℂ) =
      Matrix.trace ((complexCMatrixAsMatrix A)ᴴ * complexCMatrixAsMatrix A) := by
  unfold complexMatrixFrobeniusSq Matrix.trace
  push_cast
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [Matrix.diag_apply, Matrix.mul_apply]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [Matrix.conjTranspose_apply]
  simp only [complexCMatrixAsMatrix, Complex.star_def]
  rw [← Complex.normSq_eq_conj_mul_self, Complex.normSq_eq_norm_sq]
  push_cast
  ring

/-- Left multiplication by any column isometry preserves the Frobenius norm.
Coordinate zero extensions are special cases of this identity. -/
theorem complexMatrixFrobenius_left_isometry {d m n : ℕ}
    (E : CMatrix d m) (A : CMatrix m n)
    (hE : complexMatrixMul (complexMatrixAdjoint E) E =
      (1 : Matrix (Fin m) (Fin m) ℂ)) :
    complexMatrixFrobenius (complexMatrixMul E A) = complexMatrixFrobenius A := by
  let Em : Matrix (Fin d) (Fin m) ℂ := E
  let Am : Matrix (Fin m) (Fin n) ℂ := A
  have hEmat : Emᴴ * Em = 1 := hE
  have hGram : (Em * Am)ᴴ * (Em * Am) = Amᴴ * Am := by
    rw [Matrix.conjTranspose_mul]
    simp only [Matrix.mul_assoc]
    rw [← Matrix.mul_assoc Emᴴ Em Am, hEmat, Matrix.one_mul]
  have hsq : complexMatrixFrobeniusSq (complexMatrixMul E A) =
      complexMatrixFrobeniusSq A := by
    apply Complex.ofReal_injective
    rw [complexMatrixFrobeniusSq_eq_trace_gram, complexMatrixFrobeniusSq_eq_trace_gram]
    exact congrArg Matrix.trace hGram
  simp only [complexMatrixFrobenius, hsq]

/-- Right multiplication by the adjoint of any column isometry preserves the
Frobenius norm, uniformly across rectangular shapes. -/
theorem complexMatrixFrobenius_right_isometry {m n d : ℕ}
    (A : CMatrix m n) (E : CMatrix d n)
    (hE : complexMatrixMul (complexMatrixAdjoint E) E =
      (1 : Matrix (Fin n) (Fin n) ℂ)) :
    complexMatrixFrobenius (complexMatrixMul A (complexMatrixAdjoint E)) =
      complexMatrixFrobenius A := by
  let Em : Matrix (Fin d) (Fin n) ℂ := E
  let Am : Matrix (Fin m) (Fin n) ℂ := A
  have hEmat : Emᴴ * Em = 1 := hE
  have htrace : Matrix.trace ((Am * Emᴴ)ᴴ * (Am * Emᴴ)) =
      Matrix.trace (Amᴴ * Am) := by
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose]
    have hexpand : Em * Amᴴ * (Am * Emᴴ) = Em * (Amᴴ * Am) * Emᴴ := by
      simp only [Matrix.mul_assoc]
    rw [hexpand, Matrix.trace_mul_cycle Em (Amᴴ * Am) Emᴴ,
      ← Matrix.mul_assoc, hEmat, Matrix.one_mul]
  have hsq : complexMatrixFrobeniusSq (complexMatrixMul A (complexMatrixAdjoint E)) =
      complexMatrixFrobeniusSq A := by
    apply Complex.ofReal_injective
    rw [complexMatrixFrobeniusSq_eq_trace_gram, complexMatrixFrobeniusSq_eq_trace_gram]
    exact htrace
  simp only [complexMatrixFrobenius, hsq]

/-- Concrete Frobenius instance of the fixed-shape unitarily invariant norm
interface. Its rectangular coherence is given by the isometry lemmas above. -/
noncomputable def complexFrobeniusFixedUnitaryInvariantNorm (m n : ℕ) :
    ComplexMatrixFixedUnitaryInvariantNorm m n where
  norm := complexMatrixFrobenius
  norm_nonneg := complexMatrixFrobenius_nonneg
  eq_zero_iff := complexMatrixFrobenius_eq_zero_iff
  smul := complexMatrixFrobenius_smul
  add_le := complexMatrixFrobenius_add_le
  left_unitary := by
    intro U A
    apply complexMatrixFrobenius_left_isometry
    have h := (Matrix.mem_unitaryGroup_iff' (A := U.val)).mp U.property
    simpa only [Matrix.star_eq_conjTranspose] using h
  right_unitary := by
    intro A V
    have hV : complexMatrixMul (complexMatrixAdjoint
        (complexMatrixAdjoint (V : Matrix (Fin n) (Fin n) ℂ)))
        (complexMatrixAdjoint (V : Matrix (Fin n) (Fin n) ℂ)) =
        (1 : Matrix (Fin n) (Fin n) ℂ) := by
      change ((V : Matrix (Fin n) (Fin n) ℂ)ᴴ)ᴴ *
        (V : Matrix (Fin n) (Fin n) ℂ)ᴴ = 1
      rw [Matrix.conjTranspose_conjTranspose]
      have h := (Matrix.mem_unitaryGroup_iff (A := V.val)).mp V.property
      simpa only [Matrix.star_eq_conjTranspose] using h
    have h := complexMatrixFrobenius_right_isometry A
      (complexMatrixAdjoint (V : Matrix (Fin n) (Fin n) ℂ)) hV
    have hinvol : complexMatrixAdjoint (complexMatrixAdjoint
        (V : Matrix (Fin n) (Fin n) ℂ)) = (V : Matrix (Fin n) (Fin n) ℂ) := by
      exact Matrix.conjTranspose_conjTranspose _
    rwa [hinvol] at h

@[simp]
theorem complexFrobeniusFixedUnitaryInvariantNorm_norm {m n : ℕ} (A : CMatrix m n) :
    (complexFrobeniusFixedUnitaryInvariantNorm m n).norm A = complexMatrixFrobenius A := rfl

end NumStability
