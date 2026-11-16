import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Preconditioning.CountSketch.PairCollision

/-!
# Orthonormal subspaces under signed-hash embeddings

The exact product of the iid uniform hash law and the independent Rademacher
sign law has Gram-error second moment at most `(d²+d)/r` on any fixed
orthonormal basis. Retaining reversed-pair cross terms before summing Gram
entries gives the linear term `d`; bounding each entry separately by twice its
coefficient-square sum would instead lose this cancellation.

Markov's inequality gives spectral control and simultaneous squared-norm
preservation on the represented subspace. Neither hash injectivity nor leverage
flattening is a premise or a conclusion.
-/

open scoped BigOperators

namespace NumStability

/-- The full signed-hash second moment retains the reversed-pair cross term. -/
theorem countSketchProbability_expectationReal_rowGram_entry_error_sq_eq
    {r m n : ℕ} (hr : 0 < r) (A : Fin m → Fin n → ℝ) (j l : Fin n) :
    (countSketchProbability (r := r) (m := m) hr).expectationReal
      (fun x => (rowGram (preconditionRows
        (countSketchRows x.1 (rademacherSignVector x.2)) A) j l - rowGram A j l) ^ 2) =
    (r : ℝ)⁻¹ * ∑ p : CountSketchDistinctPair m,
      ((A p.1.1 j * A p.1.2 l) ^ 2 +
        (A p.1.1 j * A p.1.2 l) * (A p.1.2 j * A p.1.1 l)) := by
  classical
  rw [countSketchProbability, FiniteProbability.prod_expectationReal_eq]
  have hsign : ∀ hash : CountSketchHash r m,
      (rademacherTraceProbability m).expectationReal
        (fun ω => (rowGram (preconditionRows
          (countSketchRows hash (rademacherSignVector ω)) A) j l - rowGram A j l) ^ 2) =
      ∑ p : CountSketchDistinctPair m,
        (if hash p.1.1 = hash p.1.2 then (1 : ℝ) else 0) *
        ((A p.1.1 j * A p.1.2 l) ^ 2 +
          (A p.1.1 j * A p.1.2 l) * (A p.1.2 j * A p.1.1 l)) := by
    intro hash
    rw [rademacherTraceProbability_expectationReal_countSketchRows_rowGram_entry_error_sq_eq,
      countSketchDistinctPair_fourKernel_sum_eq_sum_sq_add_swap]
    apply Finset.sum_congr rfl
    intro p _
    by_cases h : hash p.1.1 = hash p.1.2
    · simp [h]
    · simp [h, Ne.symm h]
  simp_rw [hsign]
  rw [FiniteProbability.expectationReal_sum, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro p _
  rw [FiniteProbability.expectationReal_mul_const,
    countSketchHashProbability_expectationReal_pairCollisionIndicator_eq_inv hr p.1.1 p.1.2 p.2]

private theorem gram_cross_row {m n : ℕ} (A : Fin m → Fin n → ℝ) (a b : Fin m) :
    (∑ j : Fin n, ∑ l : Fin n,
      (A a j * A b l) * (A b j * A a l)) =
      (∑ j : Fin n, A a j * A b j) ^ 2 := by
  rw [pow_two, Finset.sum_mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  apply Finset.sum_congr rfl
  intro l _
  ring

private theorem gram_cross_all {m n : ℕ} (A : Fin m → Fin n → ℝ) :
    (∑ j : Fin n, ∑ l : Fin n, ∑ a : Fin m, ∑ b : Fin m,
      (A a j * A b l) * (A b j * A a l)) = frobNormSq (rowGram A) := by
  unfold frobNormSq rowGram
  apply Finset.sum_congr rfl
  intro j _
  apply Finset.sum_congr rfl
  intro l _
  rw [pow_two, Finset.sum_mul_sum]
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro b _
  ring

private theorem gram_coeff_sum_nonneg {m n : ℕ} (A : Fin m → Fin n → ℝ) (a b : Fin m) :
    0 ≤ ∑ j : Fin n, ∑ l : Fin n,
      ((A a j * A b l) ^ 2 + (A a j * A b l) * (A b j * A a l)) := by
  simp_rw [Finset.sum_add_distrib]
  rw [gram_cross_row]
  exact add_nonneg (Finset.sum_nonneg fun j _ => Finset.sum_nonneg fun l _ => sq_nonneg _) (sq_nonneg _)

/-- The orthonormal-column moment numerator is at most `d²+d`; reversed-pair
cancellation is retained before discarding the diagonal input-row terms. -/
theorem countSketchDistinctPair_gramMoment_sum_le_of_hasOrthonormalColumns
    {m d : ℕ} (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U) :
    (∑ j : Fin d, ∑ l : Fin d, ∑ p : CountSketchDistinctPair m,
      ((U p.1.1 j * U p.1.2 l) ^ 2 +
        (U p.1.1 j * U p.1.2 l) * (U p.1.2 j * U p.1.1 l))) ≤
      (d : ℝ) ^ 2 + (d : ℝ) := by
  classical
  let F := fun a b : Fin m => ∑ j : Fin d, ∑ l : Fin d,
    ((U a j * U b l) ^ 2 + (U a j * U b l) * (U b j * U a l))
  have hswap : (∑ j : Fin d, ∑ l : Fin d, ∑ p : CountSketchDistinctPair m,
      ((U p.1.1 j * U p.1.2 l) ^ 2 +
        (U p.1.1 j * U p.1.2 l) * (U p.1.2 j * U p.1.1 l))) =
      ∑ p : CountSketchDistinctPair m, F p.1.1 p.1.2 := by
    dsimp [F]
    conv_lhs => arg 2; ext j; rw [Finset.sum_comm]
    rw [Finset.sum_comm]
  have hall : (∑ a : Fin m, ∑ b : Fin m, F a b) = (d : ℝ) ^ 2 + (d : ℝ) := by
    dsimp [F]
    simp_rw [Finset.sum_add_distrib]
    have hreorder : ∀ f : Fin m → Fin m → Fin d → Fin d → ℝ,
        (∑ a, ∑ b, ∑ j, ∑ l, f a b j l) = ∑ j, ∑ l, ∑ a, ∑ b, f a b j l := by
      intro f
      conv_lhs => arg 2; ext a; rw [Finset.sum_comm]; arg 2; ext j; rw [Finset.sum_comm]
      rw [Finset.sum_comm]
      conv_lhs => arg 2; ext j; rw [Finset.sum_comm]
    rw [hreorder, hreorder,
      countSketchAllPairs_gramCoeffSq_sum_eq_frobNormSqRect_sq,
      gram_cross_all, frobNormSqRect_eq_nat_of_hasOrthonormalColumns U hU,
      rowGram_eq_id_of_orthonormal_columns U hU, frobNormSq_idMatrix]
  rw [hswap, ← guarded_pair_sum_eq_countSketchDistinctPair_sum F]
  apply le_trans ?_ (le_of_eq hall)
  apply Finset.sum_le_sum
  intro a _
  apply Finset.sum_le_sum
  intro b _
  by_cases hab : a = b
  · simp only [hab, ↓reduceIte]
    exact gram_coeff_sum_nonneg U b b
  · simp [hab]

/-- An actual iid uniform hash and independent signs embed any fixed
orthonormal basis with Frobenius second moment at most `(d²+d)/r`. -/
theorem countSketchProbability_expectationReal_rowGram_frob_error_sq_le_of_hasOrthonormalColumns
    {r m d : ℕ} (hr : 0 < r) (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U) :
    (countSketchProbability (r := r) (m := m) hr).expectationReal
      (fun x => frobNormSq (fun j k => rowGram
        (preconditionRows (countSketchRows x.1 (rademacherSignVector x.2)) U) j k -
        rowGram U j k)) ≤ ((d : ℝ) ^ 2 + (d : ℝ)) / (r : ℝ) := by
  classical
  unfold frobNormSq
  rw [FiniteProbability.expectationReal_sum]
  simp_rw [FiniteProbability.expectationReal_sum,
    countSketchProbability_expectationReal_rowGram_entry_error_sq_eq hr U]
  simp_rw [← Finset.mul_sum]
  rw [div_eq_mul_inv, mul_comm (_ + _)]
  exact mul_le_mul_of_nonneg_left
    (countSketchDistinctPair_gramMoment_sum_le_of_hasOrthonormalColumns U hU)
    (inv_nonneg.mpr (Nat.cast_nonneg r))

/-- The sharp sufficient dimension bound controls the actual signed-hash
Frobenius Gram error by Markov's inequality. -/
theorem countSketchProbability_eventProb_rowGram_frob_error_le_of_dimension
    {r m d : ℕ} (hr : 0 < r) (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    {ε δ : ℝ} (hε : 0 < ε) (hδ : 0 < δ)
    (hbudget : ((d : ℝ) ^ 2 + (d : ℝ)) / (ε ^ 2 * δ) ≤ (r : ℝ)) :
    1 - δ ≤ (countSketchProbability (r := r) (m := m) hr).eventProb
      {x | frobNorm (fun j k => rowGram
        (preconditionRows (countSketchRows x.1 (rademacherSignVector x.2)) U) j k -
        rowGram U j k) ≤ ε} := by
  let P := countSketchProbability (r := r) (m := m) hr
  let Z := fun x : CountSketchHash r m × RademacherTrace m =>
    frobNorm (fun j k => rowGram
      (preconditionRows (countSketchRows x.1 (rademacherSignVector x.2)) U) j k -
      rowGram U j k)
  have hmom : P.expectationReal (fun x => Z x ^ 2) ≤
      ((d : ℝ) ^ 2 + (d : ℝ)) / (r : ℝ) := by
    simpa [P, Z, frobNorm_sq] using
      countSketchProbability_expectationReal_rowGram_frob_error_sq_le_of_hasOrthonormalColumns hr U hU
  have hbound : (((d : ℝ) ^ 2 + (d : ℝ)) / (r : ℝ)) / ε ^ 2 ≤ δ := by
    have hrR : 0 < (r : ℝ) := Nat.cast_pos.mpr hr
    have heps : 0 < ε ^ 2 := sq_pos_of_pos hε
    have h := (div_le_iff₀ (mul_pos heps hδ)).mp hbudget
    apply (div_le_iff₀ heps).mpr
    apply (div_le_iff₀ hrR).mpr
    nlinarith [h]
  have hmarkov := FiniteProbability.eventProb_le_ge_one_sub_expectationReal_sq_div
    P Z ε (fun _ => frobNorm_nonneg _) hε
  have hle : P.expectationReal (fun x => Z x ^ 2) / ε ^ 2 ≤ δ :=
    (div_le_div_of_nonneg_right hmom (sq_nonneg ε)).trans hbound
  exact le_trans (by linarith) hmarkov

/-- A Frobenius Gram bound controls every vector in the represented subspace
simultaneously. The witness only identifies subspace membership. -/
theorem subspace_normSq_geometry_of_gram_frob_le
    {r m d : ℕ} (Pi : Fin r → Fin m → ℝ) (U : Fin m → Fin d → ℝ)
    (hU : HasOrthonormalColumns U) {ε : ℝ}
    (hF : frobNorm (fun j k => rowGram (preconditionRows Pi U) j k - rowGram U j k) ≤ ε)
    (v : Fin m → ℝ) (hv : ∃ z : Fin d → ℝ, v = rectMatMulVec U z) :
    (1 - ε) * vecNorm2Sq v ≤ vecNorm2Sq (rectMatMulVec Pi v) ∧
      vecNorm2Sq (rectMatMulVec Pi v) ≤ (1 + ε) * vecNorm2Sq v := by
  obtain ⟨z, rfl⟩ := hv
  let Delta := fun j k => rowGram (preconditionRows Pi U) j k - rowGram U j k
  have hquad : |finiteQuadraticForm Delta z| ≤ ε * vecNorm2Sq z := by
    simpa [finiteQuadraticForm, finiteMatVec, matMulVec] using
      abs_vecInnerProduct_matMulVec_le_of_opNorm2Le Delta (opNorm2Le_of_frobNorm_le Delta hF) z
  change |finiteQuadraticForm (fun j k => rowGram (preconditionRows Pi U) j k - rowGram U j k) z| ≤ _ at hquad
  rw [finiteQuadraticForm_sub,
    finiteQuadraticForm_rowGram_eq_vecNorm2Sq_rectMatMulVec,
    finiteQuadraticForm_rowGram_eq_vecNorm2Sq_rectMatMulVec] at hquad
  have hcompose : rectMatMulVec (preconditionRows Pi U) z =
      rectMatMulVec Pi (rectMatMulVec U z) := by
    exact rectMatMulVec_preconditionRows_eq_preconditionRows_rectMatMulVec Pi U z
  rw [hcompose, hasOrthonormalColumns_vecNorm2Sq_rectMatMulVec_eq U hU z] at hquad
  rw [hasOrthonormalColumns_vecNorm2Sq_rectMatMulVec_eq U hU z]
  obtain ⟨hl, hu⟩ := abs_le.mp hquad
  constructor <;> nlinarith

/-- Spectral Gram control and simultaneous geometry for the actual independent
signed-hash family with its sharp sufficient dimension threshold. -/
theorem countSketchProbability_eventProb_subspace_geometry_of_dimension
    {r m d : ℕ} (hr : 0 < r) (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U)
    {ε δ : ℝ} (hε : 0 < ε) (hδ : 0 < δ)
    (hbudget : ((d : ℝ) ^ 2 + (d : ℝ)) / (ε ^ 2 * δ) ≤ (r : ℝ)) :
    1 - δ ≤ (countSketchProbability (r := r) (m := m) hr).eventProb
      {x | let Pi := countSketchRows x.1 (rademacherSignVector x.2)
        opNorm2 (fun j k => idMatrix d j k - rowGram (preconditionRows Pi U) j k) ≤ ε ∧
        ∀ v : Fin m → ℝ, (∃ z : Fin d → ℝ, v = rectMatMulVec U z) →
          (1 - ε) * vecNorm2Sq v ≤ vecNorm2Sq (rectMatMulVec Pi v) ∧
          vecNorm2Sq (rectMatMulVec Pi v) ≤ (1 + ε) * vecNorm2Sq v} := by
  apply (countSketchProbability_eventProb_rowGram_frob_error_le_of_dimension hr U hU hε hδ hbudget).trans
  apply FiniteProbability.eventProb_mono
  intro x hx
  dsimp only
  refine ⟨?_, fun v hv => subspace_normSq_geometry_of_gram_frob_le _ U hU hx v hv⟩
  apply (opNorm2_le_frobNorm _).trans
  have heq : (fun j k => idMatrix d j k - rowGram
      (preconditionRows (countSketchRows x.1 (rademacherSignVector x.2)) U) j k) =
      (fun j k => -(rowGram
        (preconditionRows (countSketchRows x.1 (rademacherSignVector x.2)) U) j k - rowGram U j k)) := by
    rw [rowGram_eq_id_of_orthonormal_columns U hU]
    funext j k
    ring
  rw [heq, frobNorm_neg]
  exact hx

end NumStability
