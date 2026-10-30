import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.UnderdeterminedSpec
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.SingularValues.Basic
import ComputationalMathematics.Analysis.SingularValues.Realification
import ComputationalMathematics.Analysis.SingularValues.WeylMirsky

/-!
# The operator norm of a Moore--Penrose inverse

The existing arbitrary-positive-rank bound and exact reciprocal-singular-value
formula are reusable spectral results. Their historical public names remain
available through the original source module. A rank-index helper is public
in the Pseudoinverse namespace because retained source perturbation endpoints
also use it; the remaining proof helpers stay private to this module.
-/

namespace NumStability

open ComplexOrder
open scoped BigOperators

namespace Pseudoinverse

/-- A rank-indexed singular-value list is nonzero precisely in its initial block. -/
theorem singularValue_ne_zero_iff_le_rankIndex
    {m n : ℕ} (A : CMatrix m n) (i : Fin n)
    (hrank : complexMatrixRank A = i.1 + 1) (j : Fin n) :
    complexMatrixSingularValue A j ≠ 0 ↔ j ≤ i := by
  classical
  let s : Finset (Fin n) :=
    Finset.univ.filter (fun l => complexMatrixSingularValue A l ≠ 0)
  have hcard : s.card = i.1 + 1 := by
    calc
      s.card = Fintype.card
          {l : Fin n // complexMatrixSingularValue A l ≠ 0} := by
            simp [s, Fintype.card_subtype]
      _ = complexMatrixRank A :=
        (complexMatrixRank_eq_card_nonzero_singularValue A).symm
      _ = i.1 + 1 := hrank
  have hi_ne : complexMatrixSingularValue A i ≠ 0 := by
    intro hi_zero
    have hs_sub : s ⊆ Finset.Iio i := by
      intro l hl
      simp only [s, Finset.mem_filter, Finset.mem_univ, true_and] at hl
      simp only [Finset.mem_Iio]
      by_contra hnot
      have hil : i ≤ l := le_of_not_gt hnot
      have hle := complexMatrixSingularValue_antitone A hil
      have hl_nonneg := complexMatrixSingularValue_nonneg A l
      rw [hi_zero] at hle
      have hl_zero : complexMatrixSingularValue A l = 0 := le_antisymm hle hl_nonneg
      exact hl hl_zero
    have hcard_le := Finset.card_le_card hs_sub
    rw [hcard, Fin.card_Iio] at hcard_le
    omega
  constructor
  · intro hj_ne
    by_contra hnot
    have hij : i < j := lt_of_not_ge hnot
    have hic_sub : Finset.Iic j ⊆ s := by
      intro l hl
      simp only [Finset.mem_Iic] at hl
      simp only [s, Finset.mem_filter, Finset.mem_univ, true_and]
      have hj_pos : 0 < complexMatrixSingularValue A j :=
        lt_of_le_of_ne' (complexMatrixSingularValue_nonneg A j) hj_ne
      have hjl := complexMatrixSingularValue_antitone A hl
      exact ne_of_gt (lt_of_lt_of_le hj_pos hjl)
    have hcard_le := Finset.card_le_card hic_sub
    rw [Fin.card_Iic, hcard] at hcard_le
    omega
  · intro hji hj_zero
    have hle := complexMatrixSingularValue_antitone A hji
    rw [hj_zero] at hle
    have hi_nonneg := complexMatrixSingularValue_nonneg A i
    exact hi_ne (le_antisymm hle hi_nonneg)

end Pseudoinverse

private theorem finrank_leadSpan
    {n : ℕ} (b : OrthonormalBasis (Fin n) ℂ (EuclideanSpace ℂ (Fin n)))
    (i : Fin n) :
    Module.finrank ℂ
        (Submodule.span ℂ (⇑b '' (↑(Finset.Iic i) : Set (Fin n)))) =
      i.1 + 1 := by
  classical
  have hli : LinearIndependent ℂ
      (fun k : {j // j ∈ Finset.Iic i} => b (k : Fin n)) :=
    (b.orthonormal.comp (fun k : {j // j ∈ Finset.Iic i} => (k : Fin n))
      Subtype.val_injective).linearIndependent
  have hrange :
      Set.range (fun k : {j // j ∈ Finset.Iic i} => b (k : Fin n)) =
        ⇑b '' (↑(Finset.Iic i) : Set (Fin n)) := by
    ext y
    constructor
    · rintro ⟨⟨l, hl⟩, rfl⟩
      exact ⟨l, Finset.mem_coe.mpr hl, rfl⟩
    · rintro ⟨l, hl, rfl⟩
      exact ⟨⟨l, Finset.mem_coe.mp hl⟩, rfl⟩
  rw [← hrange, finrank_span_eq_card hli, Fintype.card_coe, Fin.card_Iic]
private theorem leadSpan_eq_gramRange_of_rankIndex
    {m n : ℕ} (A : CMatrix m n) (i : Fin n)
    (hrank : complexMatrixRank A = i.1 + 1) :
    Submodule.span ℂ
        (⇑(complexMatrixGramEigenvectorBasis A) ''
          (↑(Finset.Iic i) : Set (Fin n))) =
      LinearMap.range (complexMatrixGramLin A) := by
  classical
  apply Submodule.eq_of_le_of_finrank_eq
  · apply Submodule.span_le.2
    rintro _ ⟨j, hj, rfl⟩
    have hjle : j ≤ i := by simpa using hj
    have hσ : complexMatrixSingularValue A j ≠ 0 :=
      (Pseudoinverse.singularValue_ne_zero_iff_le_rankIndex A i hrank j).2 hjle
    have hlam : complexMatrixGramEigenvalues A j ≠ 0 :=
      (complexMatrixSingularValue_ne_zero_iff_gramEigenvalue_ne_zero A j).1 hσ
    refine ⟨((complexMatrixGramEigenvalues A j : ℂ)⁻¹) •
        complexMatrixGramEigenvectorBasis A j, ?_⟩
    rw [map_smul, complexMatrixGramLin_apply_eigenvectorBasis, smul_smul]
    rw [inv_mul_cancel₀]
    · simp
    · exact_mod_cast hlam
  · rw [finrank_leadSpan, complexMatrixGramLin_finrank_range_eq_complexMatrixRank,
      hrank]
private theorem complexMatrixRank_adjoint {m n : ℕ} (A : CMatrix m n) :
    complexMatrixRank (complexMatrixAdjoint A) = complexMatrixRank A := by
  unfold complexMatrixRank
  change Matrix.rank (Matrix.conjTranspose (A : Matrix (Fin m) (Fin n) ℂ)) = Matrix.rank A
  exact Matrix.rank_conjTranspose (A : Matrix (Fin m) (Fin n) ℂ)
private theorem gramRange_eq_adjointRange {m n : ℕ} (A : CMatrix m n) :
    LinearMap.range (complexMatrixGramLin A) =
      LinearMap.range (complexMatrixEuclideanLin (complexMatrixAdjoint A)) := by
  apply Submodule.eq_of_le_of_finrank_eq
  · intro x hx
    rcases hx with ⟨y, rfl⟩
    refine ⟨complexMatrixEuclideanLin A y, ?_⟩
    rw [← complexMatrixEuclideanLin_mul,
      complexMatrixEuclideanLin_adjoint_mul_self]
  · rw [complexMatrixGramLin_finrank_range_eq_complexMatrixRank]
    rw [← complexMatrixRank_eq_finrank_range_euclideanLin,
      complexMatrixRank_adjoint]
private theorem complexification_eq_adjoint_of_symmetric
    {n : ℕ} (P : Fin n → Fin n → ℝ) (hP : IsSymmetricFiniteMatrix P) :
    realRectToCMatrix P = complexMatrixAdjoint (realRectToCMatrix P) := by
  rw [← realRectToCMatrix_finiteTranspose]
  congr 1
  ext i j
  exact hP i j
private theorem complex_penrose1
    {m n : ℕ} {A : Fin m → Fin n → ℝ} {Aplus : Fin n → Fin m → ℝ}
    (hMP : RectMoorePenrosePseudoinverse m n A Aplus) :
    complexMatrixMul
        (complexMatrixMul (realRectToCMatrix A) (realRectToCMatrix Aplus))
        (realRectToCMatrix A) =
      realRectToCMatrix A := by
  rw [← realRectToCMatrix_rectMatMul, ← realRectToCMatrix_rectMatMul]
  exact congrArg realRectToCMatrix hMP.reproduces_matrix
private theorem complex_penrose2
    {m n : ℕ} {A : Fin m → Fin n → ℝ} {Aplus : Fin n → Fin m → ℝ}
    (hMP : RectMoorePenrosePseudoinverse m n A Aplus) :
    complexMatrixMul
        (complexMatrixMul (realRectToCMatrix Aplus) (realRectToCMatrix A))
        (realRectToCMatrix Aplus) =
      realRectToCMatrix Aplus := by
  rw [← realRectToCMatrix_rectMatMul, ← realRectToCMatrix_rectMatMul]
  exact congrArg realRectToCMatrix hMP.reproduces_pseudoinverse
private theorem pseudoinverse_output_mem_gramRange
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (Aplus : Fin n → Fin m → ℝ)
    (hMP : RectMoorePenrosePseudoinverse m n A Aplus)
    (y : EuclideanSpace ℂ (Fin m)) :
    complexMatrixEuclideanLin (realRectToCMatrix Aplus) y ∈
      LinearMap.range (complexMatrixGramLin (realRectToCMatrix A)) := by
  let C := realRectToCMatrix A
  let Cp := realRectToCMatrix Aplus
  let P := complexMatrixMul Cp C
  let x := complexMatrixEuclideanLin Cp y
  have hPfix : complexMatrixEuclideanLin P x = x := by
    calc
      complexMatrixEuclideanLin P x =
          complexMatrixEuclideanLin Cp (complexMatrixEuclideanLin C x) := by
            exact complexMatrixEuclideanLin_mul Cp C x
      _ = complexMatrixEuclideanLin Cp
          (complexMatrixEuclideanLin C (complexMatrixEuclideanLin Cp y)) := rfl
      _ = complexMatrixEuclideanLin
          (complexMatrixMul (complexMatrixMul Cp C) Cp) y := by
            rw [complexMatrixEuclideanLin_mul, complexMatrixEuclideanLin_mul]
      _ = complexMatrixEuclideanLin Cp y := by
            rw [show complexMatrixMul (complexMatrixMul Cp C) Cp = Cp by
              exact complex_penrose2 hMP]
      _ = x := rfl
  have hPadj : P = complexMatrixAdjoint P := by
    calc
      P = realRectToCMatrix (rectMatMul Aplus A) := by
            symm
            exact realRectToCMatrix_rectMatMul Aplus A
      _ = complexMatrixAdjoint
          (realRectToCMatrix (rectMatMul Aplus A)) :=
            complexification_eq_adjoint_of_symmetric _
              hMP.domain_projection_symmetric
      _ = complexMatrixAdjoint P := by
            rw [realRectToCMatrix_rectMatMul]
  rw [gramRange_eq_adjointRange]
  refine ⟨complexMatrixEuclideanLin (complexMatrixAdjoint Cp) x, ?_⟩
  calc
    complexMatrixEuclideanLin (complexMatrixAdjoint C)
        (complexMatrixEuclideanLin (complexMatrixAdjoint Cp) x) =
      complexMatrixEuclideanLin
        (complexMatrixMul (complexMatrixAdjoint C) (complexMatrixAdjoint Cp)) x := by
          rw [complexMatrixEuclideanLin_mul]
    _ = complexMatrixEuclideanLin (complexMatrixAdjoint P) x := by
          rw [show complexMatrixAdjoint P =
              complexMatrixMul (complexMatrixAdjoint C) (complexMatrixAdjoint Cp) by
            exact complexMatrixAdjoint_mul Cp C]
    _ = complexMatrixEuclideanLin P x := by rw [← hPadj]
    _ = x := hPfix
private theorem rangeProjection_idempotent
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (Aplus : Fin n → Fin m → ℝ)
    (hPenrose1 : rectMatMul (rectMatMul A Aplus) A = A) :
    rectMatMul (rectMatMul A Aplus) (rectMatMul A Aplus) =
      rectMatMul A Aplus := by
  calc
    rectMatMul (rectMatMul A Aplus) (rectMatMul A Aplus) =
        rectMatMul (rectMatMul (rectMatMul A Aplus) A) Aplus := by
          exact (rectMatMul_assoc (rectMatMul A Aplus) A Aplus).symm
    _ = rectMatMul A Aplus := by rw [hPenrose1]
private theorem rangeProjection_rectOpNorm2Le_one
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (Aplus : Fin n → Fin m → ℝ)
    (hMP : RectMoorePenrosePseudoinverse m n A Aplus) :
    rectOpNorm2Le (rectMatMul A Aplus) 1 := by
  intro x
  have hIdemEq := rangeProjection_idempotent A Aplus hMP.reproduces_matrix
  have hIdem : ∀ i j : Fin m,
      finiteMatMul (rectMatMul A Aplus) (rectMatMul A Aplus) i j =
        rectMatMul A Aplus i j := by
    intro i j
    simpa [finiteMatMul, rectMatMul] using congrFun (congrFun hIdemEq i) j
  have h := finiteVecNorm2_finiteMatVec_le_of_symmetric_idempotent
    (rectMatMul A Aplus) hMP.range_projection_symmetric hIdem x
  simpa [finiteVecNorm2_fin, finiteMatVec, rectMatMulVec] using h
private theorem rangeProjection_complex_action_le
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (Aplus : Fin n → Fin m → ℝ)
    (hMP : RectMoorePenrosePseudoinverse m n A Aplus)
    (y : EuclideanSpace ℂ (Fin m)) :
    ‖complexMatrixEuclideanLin
        (realRectToCMatrix (rectMatMul A Aplus)) y‖ ≤ ‖y‖ := by
  have hop : complexMatrixOp2
      (realRectToCMatrix (rectMatMul A Aplus)) ≤ 1 :=
    complexMatrixOp2_realRectToCMatrix_le_of_rectOpNorm2Le _ (by norm_num)
      (rangeProjection_rectOpNorm2Le_one A Aplus hMP)
  calc
    ‖complexMatrixEuclideanLin
        (realRectToCMatrix (rectMatMul A Aplus)) y‖ ≤
      complexMatrixOp2 (realRectToCMatrix (rectMatMul A Aplus)) * ‖y‖ := by
        rw [complexMatrixOp2_eq_norm_euclideanLin]
        exact ContinuousLinearMap.le_opNorm
          (complexMatrixEuclideanLin
            (realRectToCMatrix (rectMatMul A Aplus))).toContinuousLinearMap y
    _ ≤ 1 * ‖y‖ := mul_le_mul_of_nonneg_right hop (norm_nonneg y)
    _ = ‖y‖ := one_mul _
/-- A Moore--Penrose inverse has operator norm at most the reciprocal of the
least positive singular value selected by the matrix rank. -/
theorem higham20_lemma20_11_pseudoinverse_op2_le_recip_rankSingular
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (Aplus : Fin n → Fin m → ℝ)
    (i : Fin n) (hMP : RectMoorePenrosePseudoinverse m n A Aplus)
    (hrank : complexMatrixRank (realRectToCMatrix A) = i.1 + 1) :
    complexMatrixOp2 (realRectToCMatrix Aplus) ≤
      1 / complexMatrixSingularValue (realRectToCMatrix A) i := by
  let C := realRectToCMatrix A
  let Cp := realRectToCMatrix Aplus
  let sigma := complexMatrixSingularValue C i
  have hsigma_ne : sigma ≠ 0 := by
    exact Pseudoinverse.singularValue_ne_zero_iff_le_rankIndex C i hrank i |>.2 le_rfl
  have hsigma_pos : 0 < sigma :=
    lt_of_le_of_ne' (complexMatrixSingularValue_nonneg C i) hsigma_ne
  rw [complexMatrixOp2_eq_norm_euclideanLin]
  apply ContinuousLinearMap.opNorm_le_bound _ (le_of_lt (one_div_pos.mpr hsigma_pos))
  intro y
  let x := complexMatrixEuclideanLin Cp y
  have hxGram : x ∈ LinearMap.range (complexMatrixGramLin C) := by
    exact pseudoinverse_output_mem_gramRange A Aplus hMP y
  have hxLead : x ∈ Submodule.span ℂ
      (⇑(complexMatrixGramEigenvectorBasis C) ''
        (↑(Finset.Iic i) : Set (Fin n))) := by
    rw [leadSpan_eq_gramRange_of_rankIndex C i hrank]
    exact hxGram
  have hlower : sigma * ‖x‖ ≤ ‖complexMatrixEuclideanLin C x‖ :=
    Ch14Ext.ch14ext_singularValue_mul_norm_le_norm_euclideanLin_of_mem_leadSpan
      C i hxLead
  have hAx : ‖complexMatrixEuclideanLin C x‖ ≤ ‖y‖ := by
    calc
      ‖complexMatrixEuclideanLin C x‖ =
          ‖complexMatrixEuclideanLin
            (realRectToCMatrix (rectMatMul A Aplus)) y‖ := by
            congr 1
            rw [realRectToCMatrix_rectMatMul, complexMatrixEuclideanLin_mul]
      _ ≤ ‖y‖ := rangeProjection_complex_action_le A Aplus hMP y
  have hbound : sigma * ‖x‖ ≤ ‖y‖ := hlower.trans hAx
  change ‖x‖ ≤ (1 / sigma) * ‖y‖
  calc
    ‖x‖ = (1 / sigma) * (sigma * ‖x‖) := by
      field_simp [hsigma_ne]
    _ ≤ (1 / sigma) * ‖y‖ :=
      mul_le_mul_of_nonneg_left hbound (le_of_lt (one_div_pos.mpr hsigma_pos))
private theorem domainProjection_fixes_adjointRange
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (Aplus : Fin n → Fin m → ℝ)
    (hMP : RectMoorePenrosePseudoinverse m n A Aplus)
    {v : EuclideanSpace ℂ (Fin n)}
    (hv : v ∈ LinearMap.range
      (complexMatrixEuclideanLin (complexMatrixAdjoint (realRectToCMatrix A)))) :
    complexMatrixEuclideanLin
        (complexMatrixMul (realRectToCMatrix Aplus) (realRectToCMatrix A)) v = v := by
  let C := realRectToCMatrix A
  let Cp := realRectToCMatrix Aplus
  let P := complexMatrixMul Cp C
  rcases hv with ⟨z, rfl⟩
  have hPadj : P = complexMatrixAdjoint P := by
    calc
      P = realRectToCMatrix (rectMatMul Aplus A) := by
            symm
            exact realRectToCMatrix_rectMatMul Aplus A
      _ = complexMatrixAdjoint
          (realRectToCMatrix (rectMatMul Aplus A)) :=
            complexification_eq_adjoint_of_symmetric _
              hMP.domain_projection_symmetric
      _ = complexMatrixAdjoint P := by
            rw [realRectToCMatrix_rectMatMul]
  have hMP1adj :
      complexMatrixMul
          (complexMatrixMul (complexMatrixAdjoint C) (complexMatrixAdjoint Cp))
          (complexMatrixAdjoint C) =
        complexMatrixAdjoint C := by
    have h := congrArg complexMatrixAdjoint (complex_penrose1 hMP)
    rw [complexMatrixAdjoint_mul, complexMatrixAdjoint_mul] at h
    simpa [complexMatrixMul_assoc] using h
  calc
    complexMatrixEuclideanLin P
        (complexMatrixEuclideanLin (complexMatrixAdjoint C) z) =
      complexMatrixEuclideanLin (complexMatrixAdjoint P)
        (complexMatrixEuclideanLin (complexMatrixAdjoint C) z) := by
          exact congrArg
            (fun M => complexMatrixEuclideanLin M
              (complexMatrixEuclideanLin (complexMatrixAdjoint C) z)) hPadj
    _ = complexMatrixEuclideanLin
        (complexMatrixMul (complexMatrixAdjoint C) (complexMatrixAdjoint Cp))
        (complexMatrixEuclideanLin (complexMatrixAdjoint C) z) := by
          rw [complexMatrixAdjoint_mul]
    _ = complexMatrixEuclideanLin
        (complexMatrixMul
          (complexMatrixMul (complexMatrixAdjoint C) (complexMatrixAdjoint Cp))
          (complexMatrixAdjoint C)) z := by
          exact (complexMatrixEuclideanLin_mul
            (complexMatrixMul (complexMatrixAdjoint C) (complexMatrixAdjoint Cp))
            (complexMatrixAdjoint C) z).symm
    _ = complexMatrixEuclideanLin (complexMatrixAdjoint C) z := by rw [hMP1adj]
/-- Exact arbitrary-positive-rank identity `||A⁺||₂ = 1 / σ_rank(A)`. -/
theorem higham20_lemma20_11_pseudoinverse_op2_eq_recip_rankSingular
    {m n : ℕ} (A : Fin m → Fin n → ℝ) (Aplus : Fin n → Fin m → ℝ)
    (i : Fin n) (hMP : RectMoorePenrosePseudoinverse m n A Aplus)
    (hrank : complexMatrixRank (realRectToCMatrix A) = i.1 + 1) :
    complexMatrixOp2 (realRectToCMatrix Aplus) =
      1 / complexMatrixSingularValue (realRectToCMatrix A) i := by
  let C := realRectToCMatrix A
  let Cp := realRectToCMatrix Aplus
  let sigma := complexMatrixSingularValue C i
  let v := complexMatrixGramEigenvectorBasis C i
  have hsigma_ne : sigma ≠ 0 :=
    Pseudoinverse.singularValue_ne_zero_iff_le_rankIndex C i hrank i |>.2 le_rfl
  have hsigma_pos : 0 < sigma :=
    lt_of_le_of_ne' (complexMatrixSingularValue_nonneg C i) hsigma_ne
  have hvLead : v ∈ Submodule.span ℂ
      (⇑(complexMatrixGramEigenvectorBasis C) ''
        (↑(Finset.Iic i) : Set (Fin n))) := by
    apply Submodule.subset_span
    exact ⟨i, by simp, rfl⟩
  have hvGram : v ∈ LinearMap.range (complexMatrixGramLin C) := by
    rw [← leadSpan_eq_gramRange_of_rankIndex C i hrank]
    exact hvLead
  have hvAdj : v ∈ LinearMap.range
      (complexMatrixEuclideanLin (complexMatrixAdjoint C)) := by
    rw [← gramRange_eq_adjointRange C]
    exact hvGram
  have hfix : complexMatrixEuclideanLin Cp
      (complexMatrixEuclideanLin C v) = v := by
    rw [← complexMatrixEuclideanLin_mul]
    exact domainProjection_fixes_adjointRange A Aplus hMP hvAdj
  have happly := ContinuousLinearMap.le_opNorm
    (complexMatrixEuclideanLin Cp).toContinuousLinearMap
    (complexMatrixEuclideanLin C v)
  have hvnorm : ‖v‖ = 1 := complexMatrixGramEigenvectorBasis_norm C i
  have hCvnorm : ‖complexMatrixEuclideanLin C v‖ = sigma := by
    exact (complexMatrixSingularValue_eq_norm_euclideanLin_gramEigenvectorBasis C i).symm
  have hlower : 1 / sigma ≤ complexMatrixOp2 Cp := by
    rw [div_le_iff₀ hsigma_pos]
    calc
      1 = ‖v‖ := hvnorm.symm
      _ = ‖complexMatrixEuclideanLin Cp (complexMatrixEuclideanLin C v)‖ := by rw [hfix]
      _ ≤ ‖(complexMatrixEuclideanLin Cp).toContinuousLinearMap‖ *
          ‖complexMatrixEuclideanLin C v‖ := happly
      _ = complexMatrixOp2 Cp * sigma := by
        rw [hCvnorm, complexMatrixOp2_eq_norm_euclideanLin]
  apply le_antisymm
  · exact higham20_lemma20_11_pseudoinverse_op2_le_recip_rankSingular
      A Aplus i hMP hrank
  · exact hlower

end NumStability
