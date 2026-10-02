import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.RankFactorizations.Core
import ComputationalMathematics.Analysis.MatrixNorms.UnitarilyInvariant
import ComputationalMathematics.Analysis.OperatorNorms.RealComplexification
import ComputationalMathematics.Analysis.SingularValues.RealSVD
import ComputationalMathematics.Analysis.SingularValues.WeylMirsky

/-!
# Eckart--Young foundations

Reusable rank-cutoff and perturbation lemmas for best low-rank approximation.
The source-specific truncation contracts live in the corresponding source
modules.
-/

namespace NumStability

open scoped BigOperators

/-- An explicit real factorization through `Fin k` has ordinary real matrix
rank at most `k`. -/
theorem RectRankAtMost.realMatrixRank_le {m n k : ℕ}
    {B : Matrix (Fin m) (Fin n) ℝ} (hB : RectRankAtMost m n k B) :
    B.rank ≤ k := by
  rcases hB with ⟨fac⟩
  let X : Matrix (Fin m) (Fin k) ℝ := fac.left
  let Y : Matrix (Fin k) (Fin n) ℝ := fac.right
  have hprod : B = X * Y := by
    ext i j
    exact fac.factorization i j
  rw [hprod]
  exact (Matrix.rank_mul_le_left X Y).trans (Matrix.rank_le_width X)

/-- An explicit real factorization through `Fin k` has complexified matrix rank
at most `k`. -/
theorem RectRankAtMost.realRectMatrixRank_le {m n k : ℕ}
    {B : Matrix (Fin m) (Fin n) ℝ} (hB : RectRankAtMost m n k B) :
    realRectMatrixRank B ≤ k := by
  rcases hB with ⟨fac⟩
  let X : Matrix (Fin m) (Fin k) ℂ := fun i a => fac.left i a
  let Y : Matrix (Fin k) (Fin n) ℂ := fun a j => fac.right a j
  have hprod : realRectToCMatrix B =
      ((X * Y : Matrix (Fin m) (Fin n) ℂ) : CMatrix m n) := by
    ext i j
    simp only [realRectToCMatrix, Matrix.mul_apply, X, Y]
    rw [fac.factorization i j]
    push_cast
    rfl
  rw [realRectMatrixRank, hprod]
  exact (Matrix.rank_mul_le_left X Y).trans (Matrix.rank_le_width X)

/-- The positive ordered singular values of a finite complex matrix occupy
exactly the initial segment cut out by its rank. -/
theorem complexMatrixSingularValue_pos_iff_lt_rank {m n : ℕ}
    (A : CMatrix m n) (i : Fin n) :
    0 < complexMatrixSingularValue A i ↔ i.val < complexMatrixRank A := by
  have hcount :
      (Finset.univ.filter fun j : Fin n =>
        0 < complexMatrixSingularValue A j).card = complexMatrixRank A := by
    calc
      (Finset.univ.filter fun j : Fin n =>
          0 < complexMatrixSingularValue A j).card =
          Fintype.card {j : Fin n // 0 < complexMatrixSingularValue A j} :=
        (Fintype.card_subtype _).symm
      _ = Fintype.card
          {j : Fin n // complexMatrixSingularValue A j ≠ 0} := by
        apply Fintype.card_congr
        exact Equiv.subtypeEquivRight fun j => by
          constructor
          · exact ne_of_gt
          · intro hne
            exact lt_of_le_of_ne (complexMatrixSingularValue_nonneg A j)
              (Ne.symm hne)
      _ = complexMatrixRank A :=
        (complexMatrixRank_eq_card_nonzero_singularValue A).symm
  have hiff :=
    Tuple.lt_card_gt_iff_apply_gt_of_antitone
      (f := complexMatrixSingularValue A) (j := i) (a := 0)
      (complexMatrixSingularValue_antitone A)
  rw [hcount] at hiff
  exact hiff.symm

/-- Ordered singular values vanish at and after the matrix-rank cutoff. -/
theorem complexMatrixSingularValue_eq_zero_of_rank_le {m n : ℕ}
    (A : CMatrix m n) (i : Fin n) (hi : complexMatrixRank A ≤ i.val) :
    complexMatrixSingularValue A i = 0 := by
  apply le_antisymm
  · apply le_of_not_gt
    intro hpos
    exact (Nat.not_lt_of_ge hi)
      ((complexMatrixSingularValue_pos_iff_lt_rank A i).mp hpos)
  · exact complexMatrixSingularValue_nonneg A i

/-- Weyl--Mirsky for two real rectangular matrices, measured by the real
Euclidean operator norm of their difference. -/
theorem realRect_singularValue_abs_sub_le_operatorNorm {m n : ℕ}
    (A B : Matrix (Fin m) (Fin n) ℝ) (i : Fin n) :
    |complexMatrixSingularValue (realRectToCMatrix A) i -
        complexMatrixSingularValue (realRectToCMatrix B) i| ≤
      realMatrixOperatorNorm (fun r c => A r c - B r c) := by
  let D : Matrix (Fin m) (Fin n) ℝ := fun r c => A r c - B r c
  have hmatrix : realRectToCMatrix A =
      realRectToCMatrix B + realRectToCMatrix D := by
    ext r c
    simp [realRectToCMatrix, D]
  have hlinadd : complexMatrixEuclideanLin
      (realRectToCMatrix B + realRectToCMatrix D) =
        complexMatrixEuclideanLin (realRectToCMatrix B) +
          complexMatrixEuclideanLin (realRectToCMatrix D) :=
    map_add (Matrix.toEuclideanLin (𝕜 := ℂ) (m := Fin m) (n := Fin n)) _ _
  have hdiff : ∀ x : EuclideanSpace ℂ (Fin n),
      ‖complexMatrixEuclideanLin (realRectToCMatrix A) x -
          complexMatrixEuclideanLin (realRectToCMatrix B) x‖ ≤
        realMatrixOperatorNorm D * ‖x‖ := by
    intro x
    rw [hmatrix, hlinadd]
    simp only [LinearMap.add_apply, add_sub_cancel_left]
    rw [realMatrixOperatorNorm_eq_complexMatrixOp2_realRectToCMatrix,
      complexMatrixOp2_eq_norm_euclideanLin]
    exact ContinuousLinearMap.le_opNorm
      (complexMatrixEuclideanLin (realRectToCMatrix D)).toContinuousLinearMap x
  simpa [D] using
    (Ch14Ext.ch14ext_singularValue_abs_sub_le_of_euclideanLin_diff_bound
      (realRectToCMatrix B) (realRectToCMatrix A) hdiff i)

/-- **Eckart--Young operator lower bound.** Every real rank-at-most-`k`
competitor leaves residual operator norm at least the zero-based `k`-th
singular value of `A` (the source's `(k+1)`-st singular value). -/
theorem eckartYoungOperatorLowerBound {m n k : ℕ}
    (A B : Matrix (Fin m) (Fin n) ℝ) (hk : k < n)
    (hB : RectRankAtMost m n k B) :
    complexMatrixSingularValue (realRectToCMatrix A) ⟨k, hk⟩ ≤
      realMatrixOperatorNorm (fun r c => A r c - B r c) := by
  have hrank : realRectMatrixRank B ≤ k := hB.realRectMatrixRank_le
  have hzero : complexMatrixSingularValue (realRectToCMatrix B) ⟨k, hk⟩ = 0 :=
    complexMatrixSingularValue_eq_zero_of_rank_le
      (realRectToCMatrix B) ⟨k, hk⟩ hrank
  have hpert := realRect_singularValue_abs_sub_le_operatorNorm A B ⟨k, hk⟩
  rw [hzero, sub_zero,
    abs_of_nonneg (complexMatrixSingularValue_nonneg _ _)] at hpert
  exact hpert

/-! ## Shifted singular-value lower bound -/

/-- The span of a finite subfamily of an orthonormal basis has the cardinality
of that subfamily.  This local dimension lemma is the bookkeeping bridge used
by the shifted Eckart--Young min--max argument. -/
private theorem finrank_span_orthonormalBasis_image_finset {n : ℕ}
    (b : OrthonormalBasis (Fin n) ℂ (EuclideanSpace ℂ (Fin n)))
    (t : Finset (Fin n)) :
    Module.finrank ℂ (Submodule.span ℂ (⇑b '' (↑t : Set (Fin n)))) = t.card := by
  classical
  have hli : LinearIndependent ℂ
      (fun a : {j // j ∈ t} => b (a : Fin n)) :=
    (b.orthonormal.comp (fun a : {j // j ∈ t} => (a : Fin n))
      Subtype.val_injective).linearIndependent
  have hrange : Set.range (fun a : {j // j ∈ t} => b (a : Fin n)) =
      ⇑b '' (↑t : Set (Fin n)) := by
    ext y
    constructor
    · rintro ⟨⟨a, ha⟩, rfl⟩
      exact ⟨a, Finset.mem_coe.mpr ha, rfl⟩
    · rintro ⟨a, ha, rfl⟩
      exact ⟨⟨a, Finset.mem_coe.mp ha⟩, rfl⟩
  rw [← hrange, finrank_span_eq_card hli]
  exact Fintype.card_coe t

/-- If two subspaces of an `n`-dimensional complex Euclidean space have
dimensions summing to more than `n`, their intersection contains a nonzero
vector. -/
private theorem exists_nonzero_mem_inf_of_finrank_add_gt {n : ℕ}
    (V W : Submodule ℂ (EuclideanSpace ℂ (Fin n)))
    (h : n < Module.finrank ℂ V + Module.finrank ℂ W) :
    ∃ x : EuclideanSpace ℂ (Fin n), x ≠ 0 ∧ x ∈ V ∧ x ∈ W := by
  have heq := Submodule.finrank_sup_add_finrank_inf_eq V W
  have hle := Submodule.finrank_le (V ⊔ W)
  rw [finrank_euclideanSpace_fin] at hle
  have hne : V ⊓ W ≠ ⊥ := by
    intro hbot
    rw [hbot, finrank_bot] at heq
    omega
  obtain ⟨x, hxmem, hxne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hne
  rw [Submodule.mem_inf] at hxmem
  exact ⟨x, hxne, hxmem.1, hxmem.2⟩

/-- **Shifted Eckart--Young singular-value bound.**  Subtracting a real
rank-at-most-`k` matrix cannot push the zero-based `i`-th residual singular
value below the zero-based `(k+i)`-th singular value of the original matrix.

This is the pointwise singular-value dominance behind the all-unitarily-
invariant-norm form of Eckart--Young--Mirsky. -/
theorem eckartYoungShiftedSingularValueLowerBound {m n k q : ℕ}
    (A B : Matrix (Fin m) (Fin n) ℝ) (hwidth : k + q ≤ n)
    (hB : RectRankAtMost m n k B) (i : Fin q) :
    complexMatrixSingularValue (realRectToCMatrix A)
        (Fin.castLE hwidth (Fin.natAdd k i)) ≤
      complexMatrixSingularValue
        (realRectToCMatrix (fun a b => A a b - B a b))
        ⟨i.val, lt_of_lt_of_le i.isLt
          (le_trans (Nat.le_add_left q k) hwidth)⟩ := by
  classical
  let AC : CMatrix m n := realRectToCMatrix A
  let BC : CMatrix m n := realRectToCMatrix B
  let D : Matrix (Fin m) (Fin n) ℝ := fun a b => A a b - B a b
  let DC : CMatrix m n := realRectToCMatrix D
  let ii : Fin n := ⟨i.val, lt_of_lt_of_le i.isLt
    (le_trans (Nat.le_add_left q k) hwidth)⟩
  let ji : Fin n := Fin.castLE hwidth (Fin.natAdd k i)
  let V : Submodule ℂ (EuclideanSpace ℂ (Fin n)) :=
    Submodule.span ℂ
      (⇑(complexMatrixGramEigenvectorBasis AC) ''
        (↑(Finset.Iic ji) : Set (Fin n)))
  let W : Submodule ℂ (EuclideanSpace ℂ (Fin n)) :=
    Submodule.span ℂ
      (⇑(complexMatrixGramEigenvectorBasis DC) ''
        (↑(Finset.Ici ii) : Set (Fin n)))
  let K : Submodule ℂ (EuclideanSpace ℂ (Fin n)) :=
    LinearMap.ker (complexMatrixEuclideanLin BC)
  have hV : Module.finrank ℂ V = k + i.val + 1 := by
    dsimp [V]
    rw [finrank_span_orthonormalBasis_image_finset, Fin.card_Iic]
    rfl
  have hW : Module.finrank ℂ W = n - i.val := by
    dsimp [W]
    rw [finrank_span_orthonormalBasis_image_finset, Fin.card_Ici]
  have hrange : Module.finrank ℂ
      (LinearMap.range (complexMatrixEuclideanLin BC)) ≤ k := by
    rw [← complexMatrixRank_eq_finrank_range_euclideanLin]
    exact hB.realRectMatrixRank_le
  have hranknull : Module.finrank ℂ
        (LinearMap.range (complexMatrixEuclideanLin BC)) +
      Module.finrank ℂ K = n := by
    dsimp [K]
    simpa using LinearMap.finrank_range_add_finrank_ker
      (complexMatrixEuclideanLin BC)
  have hVK : i.val + 1 ≤ Module.finrank ℂ
      (V ⊓ K : Submodule ℂ (EuclideanSpace ℂ (Fin n))) := by
    have hsup := Submodule.finrank_le (V ⊔ K)
    rw [finrank_euclideanSpace_fin] at hsup
    have heq := Submodule.finrank_sup_add_finrank_inf_eq V K
    omega
  have hinter : n < Module.finrank ℂ
      (V ⊓ K : Submodule ℂ (EuclideanSpace ℂ (Fin n))) +
        Module.finrank ℂ W := by
    omega
  obtain ⟨x, hxne, hxVK, hxW⟩ :=
    exists_nonzero_mem_inf_of_finrank_add_gt (V ⊓ K) W hinter
  have hxV : x ∈ V := (Submodule.mem_inf.mp hxVK).1
  have hxK : x ∈ K := (Submodule.mem_inf.mp hxVK).2
  have hBCzero : complexMatrixEuclideanLin BC x = 0 := by
    simpa [K, LinearMap.mem_ker] using hxK
  have hmatrix : AC = BC + DC := by
    ext a b
    simp [AC, BC, DC, D, realRectToCMatrix]
  have hlin : complexMatrixEuclideanLin AC =
      complexMatrixEuclideanLin BC + complexMatrixEuclideanLin DC := by
    rw [hmatrix]
    exact map_add
      (Matrix.toEuclideanLin (𝕜 := ℂ) (m := Fin m) (n := Fin n)) _ _
  have haction : complexMatrixEuclideanLin AC x =
      complexMatrixEuclideanLin DC x := by
    rw [hlin]
    simp [hBCzero]
  have hlead : complexMatrixSingularValue AC ji * ‖x‖ ≤
      ‖complexMatrixEuclideanLin AC x‖ :=
    Ch14Ext.ch14ext_singularValue_mul_norm_le_norm_euclideanLin_of_mem_leadSpan
      AC ji hxV
  have htrail : ‖complexMatrixEuclideanLin DC x‖ ≤
      complexMatrixSingularValue DC ii * ‖x‖ :=
    Ch14Ext.ch14ext_norm_le_singularValue_mul_norm_of_mem_trailSpan
      DC ii hxW
  have hxpos : 0 < ‖x‖ := norm_pos_iff.mpr hxne
  have hmul : complexMatrixSingularValue AC ji * ‖x‖ ≤
      complexMatrixSingularValue DC ii * ‖x‖ := by
    rw [haction] at hlead
    exact hlead.trans htrail
  exact le_of_mul_le_mul_right hmul hxpos

/-! ## Exact SVD head and tail -/

/-- The first `k` terms of supplied rank-`k+q` real SVD data. -/
noncomputable def realSVDHead {m n k q : ℕ}
    (s : Fin n → ℝ)
    (u : Fin (k + q) → EuclideanSpace ℝ (Fin m))
    (v : Fin (k + q) → EuclideanSpace ℝ (Fin n))
    (hwidth : k + q ≤ n) : Matrix (Fin m) (Fin n) ℝ :=
  fun i j => ∑ a : Fin k,
    s (Fin.castLE hwidth (Fin.castAdd q a)) *
      u (Fin.castAdd q a) i * v (Fin.castAdd q a) j

/-- The remaining `q` terms of supplied rank-`k+q` real SVD data. -/
noncomputable def realSVDTail {m n k q : ℕ}
    (s : Fin n → ℝ)
    (u : Fin (k + q) → EuclideanSpace ℝ (Fin m))
    (v : Fin (k + q) → EuclideanSpace ℝ (Fin n))
    (hwidth : k + q ≤ n) : Matrix (Fin m) (Fin n) ℝ :=
  fun i j => ∑ c : Fin q,
    s (Fin.castLE hwidth (Fin.natAdd k c)) *
      u (Fin.natAdd k c) i * v (Fin.natAdd k c) j

/-- The zero-extended singular-value sequence of an exact SVD tail. -/
noncomputable def realSVDTailSingularValues {n k q : ℕ}
    (s : Fin n → ℝ) (hwidth : k + q ≤ n) : Fin n → ℝ :=
  fun i => if hi : i.val < q then
    s (Fin.castLE hwidth (Fin.natAdd k (⟨i.val, hi⟩ : Fin q)))
  else 0

@[simp]
theorem realSVDTailSingularValues_castLE {n k q : ℕ}
    (s : Fin n → ℝ) (hwidth : k + q ≤ n) (c : Fin q) :
    realSVDTailSingularValues s hwidth
        (Fin.castLE (le_trans (Nat.le_add_left q k) hwidth) c) =
      s (Fin.castLE hwidth (Fin.natAdd k c)) := by
  unfold realSVDTailSingularValues
  split
  · congr 2
  · rename_i hnot
    exact (hnot c.isLt).elim

/-- Splitting a supplied rank-length SVD at `k` partitions its reconstruction
into the exact head and tail matrices. -/
theorem IsRealMatrixSVD.sub_head_eq_tail {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) :
    (fun i j => A i j - realSVDHead s u v h.rank_le_width i j) =
      realSVDTail s u v h.rank_le_width := by
  funext i j
  rw [h.reconstruction i j]
  change
    (∑ a : Fin (k + q),
        s (Fin.castLE h.rank_le_width a) * u a i * v a j) -
      (∑ a : Fin k,
        s (Fin.castLE h.rank_le_width (Fin.castAdd q a)) *
          u (Fin.castAdd q a) i * v (Fin.castAdd q a) j) =
      ∑ c : Fin q,
        s (Fin.castLE h.rank_le_width (Fin.natAdd k c)) *
          u (Fin.natAdd k c) i * v (Fin.natAdd k c) j
  rw [Fin.sum_univ_add]
  ring

/-- The SVD head has rank at most the number of retained terms. -/
theorem realSVDHead_rankAtMost {m n k q : ℕ}
    (s : Fin n → ℝ)
    (u : Fin (k + q) → EuclideanSpace ℝ (Fin m))
    (v : Fin (k + q) → EuclideanSpace ℝ (Fin n))
    (hwidth : k + q ≤ n) :
    RectRankAtMost m n k (realSVDHead s u v hwidth) := by
  refine ⟨{
    left := fun i a => u (Fin.castAdd q a) i
    right := fun a j =>
      s (Fin.castLE hwidth (Fin.castAdd q a)) * v (Fin.castAdd q a) j
    factorization := ?_ }⟩
  intro i j
  unfold realSVDHead
  apply Finset.sum_congr rfl
  intro a _
  ring

/-! ## Norm of an orthonormal diagonal factor -/

/-- Analysis matrix assembled from two orthonormal column families and a
diagonal coefficient vector. -/
noncomputable def realOrthonormalDiagonalFactor {m n r : ℕ}
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (d : Fin r → ℝ)
    (v : Fin r → EuclideanSpace ℝ (Fin n)) :
    Matrix (Fin m) (Fin n) ℝ :=
  fun i j => ∑ a : Fin r, d a * u a i * v a j

/-- An orthonormal diagonal factor has the same real matrix rank as its
diagonal matrix.  No nonvanishing assumption on the diagonal is needed. -/
theorem realOrthonormalDiagonalFactor_rank_eq_diagonal {m n r : ℕ}
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (d : Fin r → ℝ)
    (v : Fin r → EuclideanSpace ℝ (Fin n))
    (hu : Orthonormal ℝ u) (hv : Orthonormal ℝ v) :
    (realOrthonormalDiagonalFactor u d v).rank =
      (Matrix.diagonal d).rank := by
  let U : Matrix (Fin m) (Fin r) ℝ := fun i a => u a i
  let Ut : Matrix (Fin r) (Fin m) ℝ := fun a i => u a i
  let Vt : Matrix (Fin r) (Fin n) ℝ := fun a j => v a j
  let V : Matrix (Fin n) (Fin r) ℝ := fun j a => v a j
  let D : Matrix (Fin r) (Fin r) ℝ := Matrix.diagonal d
  have hu' : ∀ a b : Fin r,
      (∑ i : Fin m, u a i * u b i) = if a = b then 1 else 0 := by
    rw [orthonormal_iff_ite] at hu
    intro a b
    have hab := hu a b
    rw [PiLp.inner_apply] at hab
    simpa [real_inner_eq_re_inner, RCLike.inner_apply, mul_comm] using hab
  have hv' : ∀ a b : Fin r,
      (∑ j : Fin n, v a j * v b j) = if a = b then 1 else 0 := by
    rw [orthonormal_iff_ite] at hv
    intro a b
    have hab := hv a b
    rw [PiLp.inner_apply] at hab
    simpa [real_inner_eq_re_inner, RCLike.inner_apply, mul_comm] using hab
  have hUtU : Ut * U = (1 : Matrix (Fin r) (Fin r) ℝ) := by
    ext a b
    simp [Matrix.mul_apply, Ut, U, hu', Matrix.one_apply]
  have hVtV : Vt * V = (1 : Matrix (Fin r) (Fin r) ℝ) := by
    ext a b
    simp [Matrix.mul_apply, Vt, V, hv', Matrix.one_apply]
  have hfactor : realOrthonormalDiagonalFactor u d v = U * D * Vt := by
    ext i j
    simp only [Matrix.mul_apply, U, D, Vt, Matrix.diagonal_apply]
    simp only [mul_ite, mul_zero, Finset.sum_ite_eq', Finset.mem_univ,
      ↓reduceIte]
    unfold realOrthonormalDiagonalFactor
    apply Finset.sum_congr rfl
    intro a _
    ring
  have hcompress : Ut * realOrthonormalDiagonalFactor u d v * V = D := by
    rw [hfactor]
    simp only [← Matrix.mul_assoc, hUtU, one_mul]
    rw [Matrix.mul_assoc, hVtV, mul_one]
  apply le_antisymm
  · rw [hfactor]
    exact (Matrix.rank_mul_le_left (U * D) Vt).trans
      (Matrix.rank_mul_le_right U D)
  · change D.rank ≤ (realOrthonormalDiagonalFactor u d v).rank
    rw [← hcompress]
    exact (Matrix.rank_mul_le_left (Ut * realOrthonormalDiagonalFactor u d v) V).trans
      (Matrix.rank_mul_le_right Ut (realOrthonormalDiagonalFactor u d v))

/-- The tail of an exact rank-`k+q` SVD is itself an exact rank-`q` SVD with
the shifted, zero-extended singular-value sequence. -/
theorem IsRealMatrixSVD.tail_isRealMatrixSVD {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) :
    IsRealMatrixSVD (realSVDTail s u v h.rank_le_width) q
      (realSVDTailSingularValues s h.rank_le_width)
      (fun c => u (Fin.natAdd k c))
      (fun c => v (Fin.natAdd k c)) := by
  let dfull : Fin (k + q) → ℝ :=
    fun a => s (Fin.castLE h.rank_le_width a)
  have hAfactor : A = realOrthonormalDiagonalFactor u dfull v := by
    ext i j
    rw [h.reconstruction i j]
    unfold realOrthonormalDiagonalFactor dfull
    rfl
  have hfullDiagRank : (Matrix.diagonal dfull).rank = k + q := by
    rw [← realOrthonormalDiagonalFactor_rank_eq_diagonal u dfull v
      h.leftSingularVectors_orthonormal h.rightSingularVectors_orthonormal,
      ← hAfactor]
    exact h.rank_eq.symm
  have hdfull_ne : ∀ a : Fin (k + q), dfull a ≠ 0 := by
    intro a ha
    have hcard : Fintype.card {b : Fin (k + q) // dfull b ≠ 0} = k + q := by
      simpa [Matrix.rank_diagonal] using hfullDiagRank
    have hlt : Fintype.card {b : Fin (k + q) // dfull b ≠ 0} < k + q := by
      simpa using (Fintype.card_subtype_lt
        (p := fun b => dfull b ≠ 0) (by simpa using ha))
    omega
  let dtail : Fin q → ℝ := fun c =>
    s (Fin.castLE h.rank_le_width (Fin.natAdd k c))
  have htailRank : (realSVDTail s u v h.rank_le_width).rank = q := by
    change (realOrthonormalDiagonalFactor
      (fun c : Fin q => u (Fin.natAdd k c)) dtail
      (fun c : Fin q => v (Fin.natAdd k c))).rank = q
    rw [realOrthonormalDiagonalFactor_rank_eq_diagonal
        (fun c : Fin q => u (Fin.natAdd k c)) dtail
        (fun c : Fin q => v (Fin.natAdd k c))
        (h.leftSingularVectors_orthonormal.comp (Fin.natAdd k)
          (Fin.natAdd_injective q k))
        (h.rightSingularVectors_orthonormal.comp (Fin.natAdd k)
          (Fin.natAdd_injective q k)),
      Matrix.rank_diagonal]
    have hne : ∀ c : Fin q, dtail c ≠ 0 := by
      intro c
      exact hdfull_ne (Fin.natAdd k c)
    simp [hne]
  refine
    { rank_eq := htailRank.symm
      rank_le_width := le_trans (Nat.le_add_left q k) h.rank_le_width
      singularValues_nonnegative := ?_
      singularValues_antitone := ?_
      singularValues_zero_of_rank_le := ?_
      leftSingularVectors_orthonormal :=
        h.leftSingularVectors_orthonormal.comp (Fin.natAdd k)
          (Fin.natAdd_injective q k)
      rightSingularVectors_orthonormal :=
        h.rightSingularVectors_orthonormal.comp (Fin.natAdd k)
          (Fin.natAdd_injective q k)
      reconstruction := ?_ }
  · intro i
    unfold realSVDTailSingularValues
    split
    · exact h.singularValues_nonnegative _
    · exact le_rfl
  · intro i j hij
    by_cases hi : i.val < q
    · by_cases hj : j.val < q
      · simp only [realSVDTailSingularValues, dif_pos hi, dif_pos hj]
        apply h.singularValues_antitone
        apply Fin.le_iff_val_le_val.mpr
        simpa using hij
      · simp only [realSVDTailSingularValues, dif_neg hj, dif_pos hi]
        exact h.singularValues_nonnegative _
    · have hj : ¬ j.val < q := by omega
      simp only [realSVDTailSingularValues, dif_neg hj, dif_neg hi]
      exact le_rfl
  · intro i hi
    rw [realSVDTailSingularValues, dif_neg (Nat.not_lt_of_ge hi)]
  · intro i j
    unfold realSVDTail
    apply Finset.sum_congr rfl
    intro c _
    rw [realSVDTailSingularValues_castLE]

/-- Coordinates against an orthonormal family satisfy the finite Bessel
inequality. -/
theorem vecNorm2Sq_inner_orthonormal_le {n r : ℕ}
    (v : Fin r → EuclideanSpace ℝ (Fin n)) (hv : Orthonormal ℝ v)
    (x : Fin n → ℝ) :
    vecNorm2Sq (fun a => ∑ j : Fin n, v a j * x j) ≤ vecNorm2Sq x := by
  let xE : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 x
  have h := hv.sum_inner_products_le
    (x := xE) (s := (Finset.univ : Finset (Fin r)))
  have hinner : ∀ a : Fin r,
      inner ℝ (v a) xE = ∑ j : Fin n, v a j * x j := by
    intro a
    rw [PiLp.inner_apply]
    simp only [real_inner_eq_re_inner, RCLike.inner_apply, conj_trivial, xE]
    apply Finset.sum_congr rfl
    intro j _
    simp [mul_comm]
  unfold vecNorm2Sq
  simpa [hinner, xE, EuclideanSpace.norm_sq_eq, Real.norm_eq_abs, sq_abs]
    using h

/-- A nonnegative diagonal bounded by `M` contracts squared Euclidean norm by
at most `M²`. -/
theorem vecNorm2Sq_diagonal_upper_bound {r : ℕ}
    (d y : Fin r → ℝ) {M : ℝ} (hM : 0 ≤ M)
    (hd0 : ∀ a, 0 ≤ d a) (hdM : ∀ a, d a ≤ M) :
    vecNorm2Sq (fun a => d a * y a) ≤ M ^ 2 * vecNorm2Sq y := by
  unfold vecNorm2Sq
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro a _
  have hsq : d a ^ 2 ≤ M ^ 2 := by nlinarith [hd0 a, hdM a]
  have := mul_le_mul_of_nonneg_right hsq (sq_nonneg (y a))
  nlinarith

/-- Pointwise Euclidean action bound for an orthonormal diagonal factor. -/
theorem realOrthonormalDiagonalFactor_vecNorm2_le {m n r : ℕ}
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (d : Fin r → ℝ)
    (v : Fin r → EuclideanSpace ℝ (Fin n))
    (hu : Orthonormal ℝ u) (hv : Orthonormal ℝ v)
    {M : ℝ} (hM : 0 ≤ M) (hd0 : ∀ a, 0 ≤ d a)
    (hdM : ∀ a, d a ≤ M) (x : Fin n → ℝ) :
    vecNorm2 (rectMatMulVec (realOrthonormalDiagonalFactor u d v) x) ≤
      M * vecNorm2 x := by
  let y : Fin r → ℝ := fun a => ∑ j : Fin n, v a j * x j
  have haction : rectMatMulVec (realOrthonormalDiagonalFactor u d v) x =
      fun i => ∑ a : Fin r, u a i * (d a * y a) := by
    funext i
    unfold rectMatMulVec realOrthonormalDiagonalFactor
    simp_rw [Finset.sum_mul]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro a _
    dsimp [y]
    calc
      (∑ j : Fin n, d a * u a i * v a j * x j) =
          ∑ j : Fin n, u a i * (d a * (v a j * x j)) := by
        apply Finset.sum_congr rfl
        intro j _
        ring
      _ = u a i * ∑ j : Fin n, d a * (v a j * x j) := by
        rw [Finset.mul_sum]
      _ = u a i * (d a * ∑ j : Fin n, v a j * x j) := by
        congr 1
        rw [Finset.mul_sum]
  have hu' : ∀ a b : Fin r,
      (∑ i : Fin m, u a i * u b i) = idMatrix r a b := by
    rw [orthonormal_iff_ite] at hu
    intro a b
    have hab := hu a b
    rw [PiLp.inner_apply] at hab
    simpa [real_inner_eq_re_inner, RCLike.inner_apply, idMatrix, mul_comm] using hab
  have hleft :
      vecNorm2Sq (rectMatMulVec (realOrthonormalDiagonalFactor u d v) x) =
        vecNorm2Sq (fun a => d a * y a) := by
    rw [haction]
    exact vecNorm2Sq_leftOrthonormalFactor
      (fun i a => u a i) (fun a => d a * y a) hu'
  have hdiag := vecNorm2Sq_diagonal_upper_bound d y hM hd0 hdM
  have hright := vecNorm2Sq_inner_orthonormal_le v hv x
  have hsq :
      vecNorm2Sq (rectMatMulVec (realOrthonormalDiagonalFactor u d v) x) ≤
        M ^ 2 * vecNorm2Sq x := by
    rw [hleft]
    exact hdiag.trans (mul_le_mul_of_nonneg_left hright (sq_nonneg M))
  have hsq' :
      vecNorm2 (rectMatMulVec (realOrthonormalDiagonalFactor u d v) x) ^ 2 ≤
        (M * vecNorm2 x) ^ 2 := by
    simpa [vecNorm2_sq, mul_pow] using hsq
  have habs := (sq_le_sq).mp hsq'
  simpa [abs_of_nonneg (vecNorm2_nonneg _),
    abs_of_nonneg (mul_nonneg hM (vecNorm2_nonneg x))] using habs

/-- A pointwise rectangular Euclidean bound controls the continuous operator
norm. -/
theorem realMatrixOperatorNorm_le_of_rectOpNorm2Le {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) {M : ℝ} (hM : 0 ≤ M)
    (hA : rectOpNorm2Le A M) :
    realMatrixOperatorNorm A ≤ M := by
  unfold realMatrixOperatorNorm
  apply ContinuousLinearMap.opNorm_le_bound (realMatrixContinuousLinearMap A) hM
  intro x
  have hnorm {d : ℕ} (z : Fin d → ℝ) :
      ‖WithLp.toLp 2 z‖ = vecNorm2 z := by
    rw [EuclideanSpace.norm_eq]
    simp only [Real.norm_eq_abs, sq_abs]
    rw [show ∑ i, z i ^ 2 = vecNorm2 z ^ 2 by exact (vecNorm2_sq z).symm]
    exact Real.sqrt_sq (vecNorm2_nonneg z)
  have hxnorm : ‖x‖ = vecNorm2 (WithLp.ofLp x) := by
    rw [← hnorm (WithLp.ofLp x)]
  have haction : ‖realMatrixContinuousLinearMap A x‖ =
      vecNorm2 (rectMatMulVec A (WithLp.ofLp x)) := by
    rw [← hnorm]
    rfl
  rw [haction, hxnorm]
  exact hA (WithLp.ofLp x)

/-- The SVD tail is an orthonormal diagonal factor on the restricted tail
families. -/
theorem realSVDTail_eq_orthonormalDiagonalFactor {m n k q : ℕ}
    (s : Fin n → ℝ)
    (u : Fin (k + q) → EuclideanSpace ℝ (Fin m))
    (v : Fin (k + q) → EuclideanSpace ℝ (Fin n))
    (hwidth : k + q ≤ n) :
    realSVDTail s u v hwidth =
      realOrthonormalDiagonalFactor
        (fun c : Fin q => u (Fin.natAdd k c))
        (fun c : Fin q => s (Fin.castLE hwidth (Fin.natAdd k c)))
        (fun c : Fin q => v (Fin.natAdd k c)) := by
  funext i j
  unfold realSVDTail realOrthonormalDiagonalFactor
  apply Finset.sum_congr rfl
  intro c _
  ring

/-- The SVD tail after `k` terms has operator norm at most the next singular
value. -/
theorem IsRealMatrixSVD.operatorNorm_tail_le {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) (hq : 0 < q) :
    realMatrixOperatorNorm (realSVDTail s u v h.rank_le_width) ≤
      s (Fin.castLE h.rank_le_width
        (Fin.natAdd k (⟨0, hq⟩ : Fin q))) := by
  let c0 : Fin q := ⟨0, hq⟩
  let M : ℝ := s (Fin.castLE h.rank_le_width (Fin.natAdd k c0))
  have hu : Orthonormal ℝ (fun c : Fin q => u (Fin.natAdd k c)) :=
    h.leftSingularVectors_orthonormal.comp (Fin.natAdd k)
      (Fin.natAdd_injective q k)
  have hv : Orthonormal ℝ (fun c : Fin q => v (Fin.natAdd k c)) :=
    h.rightSingularVectors_orthonormal.comp (Fin.natAdd k)
      (Fin.natAdd_injective q k)
  have hM : 0 ≤ M := h.singularValues_nonnegative _
  have hd0 : ∀ c : Fin q,
      0 ≤ s (Fin.castLE h.rank_le_width (Fin.natAdd k c)) :=
    fun c => h.singularValues_nonnegative _
  have hdM : ∀ c : Fin q,
      s (Fin.castLE h.rank_le_width (Fin.natAdd k c)) ≤ M := by
    intro c
    apply h.singularValues_antitone
    apply Fin.le_iff_val_le_val.mpr
    simp [c0]
  rw [realSVDTail_eq_orthonormalDiagonalFactor]
  apply realMatrixOperatorNorm_le_of_rectOpNorm2Le _ hM
  intro x
  exact realOrthonormalDiagonalFactor_vecNorm2_le
    (fun c : Fin q => u (Fin.natAdd k c))
    (fun c : Fin q => s (Fin.castLE h.rank_le_width (Fin.natAdd k c)))
    (fun c : Fin q => v (Fin.natAdd k c)) hu hv hM hd0 hdM x

/-- The canonical singular value at the first omitted slot is bounded by the
corresponding supplied SVD coefficient. -/
theorem IsRealMatrixSVD.canonicalSingularValue_le_firstTail {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) (hq : 0 < q) :
    complexMatrixSingularValue (realRectToCMatrix A)
        (Fin.castLE h.rank_le_width (Fin.natAdd k (⟨0, hq⟩ : Fin q))) ≤
      s (Fin.castLE h.rank_le_width
        (Fin.natAdd k (⟨0, hq⟩ : Fin q))) := by
  let Ak := realSVDHead s u v h.rank_le_width
  have hk : k < n := lt_of_lt_of_le (Nat.lt_add_of_pos_right hq) h.rank_le_width
  let ik : Fin n := ⟨k, hk⟩
  have hindex : Fin.castLE h.rank_le_width
      (Fin.natAdd k (⟨0, hq⟩ : Fin q)) = ik := by
    apply Fin.ext
    rfl
  have hlower := eckartYoungOperatorLowerBound A Ak hk
    (realSVDHead_rankAtMost s u v h.rank_le_width)
  have hres : (fun i j => A i j - Ak i j) =
      realSVDTail s u v h.rank_le_width := h.sub_head_eq_tail
  have hupper := h.operatorNorm_tail_le hq
  rw [← hres] at hupper
  simpa [ik, hindex] using hlower.trans hupper

/-- A supplied rank-length SVD gives an explicit rank-at-most-rank
factorization of the original matrix. -/
theorem IsRealMatrixSVD.rankAtMost {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) : RectRankAtMost m n r A := by
  refine ⟨{
    left := fun i a => u a i
    right := fun a j => s (Fin.castLE h.rank_le_width a) * v a j
    factorization := ?_ }⟩
  intro i j
  rw [h.reconstruction i j]
  apply Finset.sum_congr rfl
  intro a _
  ring

/-- Squared Frobenius norm of an orthonormal diagonal factor is the sum of
the squared diagonal coefficients. -/
theorem frobNormSqRect_realOrthonormalDiagonalFactor_eq_sum_sq {m n r : ℕ}
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (d : Fin r → ℝ)
    (v : Fin r → EuclideanSpace ℝ (Fin n))
    (hu : Orthonormal ℝ u) (hv : Orthonormal ℝ v) :
    frobNormSqRect (realOrthonormalDiagonalFactor u d v) =
      ∑ a : Fin r, d a ^ 2 := by
  have hu' : ∀ a b : Fin r,
      (∑ i : Fin m, u a i * u b i) = idMatrix r a b := by
    rw [orthonormal_iff_ite] at hu
    intro a b
    have hab := hu a b
    rw [PiLp.inner_apply] at hab
    simpa [real_inner_eq_re_inner, RCLike.inner_apply, idMatrix, mul_comm] using hab
  have hvnorm : ∀ a : Fin r, ∑ j : Fin n, (v a j) ^ 2 = 1 := by
    intro a
    have ha := hv.1 a
    have hasq := congrArg (fun z : ℝ => z ^ 2) ha
    change ‖v a‖ ^ 2 = (1 : ℝ) ^ 2 at hasq
    rw [EuclideanSpace.norm_sq_eq] at hasq
    simpa [Real.norm_eq_abs, sq_abs] using hasq
  have hcol : ∀ j : Fin n,
      (∑ i : Fin m, (realOrthonormalDiagonalFactor u d v i j) ^ 2) =
        ∑ a : Fin r, (d a * v a j) ^ 2 := by
    intro j
    have h := vecNorm2Sq_leftOrthonormalFactor
      (fun i a => u a i) (fun a => d a * v a j) hu'
    unfold vecNorm2Sq at h
    simpa [realOrthonormalDiagonalFactor, mul_assoc, mul_left_comm, mul_comm]
      using h
  unfold frobNormSqRect
  calc
    (∑ i : Fin m, ∑ j : Fin n,
        (realOrthonormalDiagonalFactor u d v i j) ^ 2) =
        ∑ j : Fin n, ∑ i : Fin m,
          (realOrthonormalDiagonalFactor u d v i j) ^ 2 := by
      rw [Finset.sum_comm]
    _ = ∑ j : Fin n, ∑ a : Fin r, (d a * v a j) ^ 2 := by
      apply Finset.sum_congr rfl
      intro j _
      exact hcol j
    _ = ∑ a : Fin r, ∑ j : Fin n, (d a * v a j) ^ 2 := by
      rw [Finset.sum_comm]
    _ = ∑ a : Fin r, d a ^ 2 := by
      apply Finset.sum_congr rfl
      intro a _
      calc
        (∑ j : Fin n, (d a * v a j) ^ 2) =
            d a ^ 2 * ∑ j : Fin n, (v a j) ^ 2 := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro j _
          ring
        _ = d a ^ 2 := by rw [hvnorm a, mul_one]

/-- A supplied real SVD computes the squared Frobenius norm as the sum of the
squares of its nonzero rank-length singular sequence. -/
theorem IsRealMatrixSVD.frobNormSq_eq_sum_rank_singularValues {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) :
    frobNormSqRect A = ∑ a : Fin r, s (Fin.castLE h.rank_le_width a) ^ 2 := by
  have hfactor : A = realOrthonormalDiagonalFactor u
      (fun a : Fin r => s (Fin.castLE h.rank_le_width a)) v := by
    ext i j
    rw [h.reconstruction i j]
    unfold realOrthonormalDiagonalFactor
    apply Finset.sum_congr rfl
    intro a _
    ring
  calc
    frobNormSqRect A = frobNormSqRect
        (realOrthonormalDiagonalFactor u
          (fun a : Fin r => s (Fin.castLE h.rank_le_width a)) v) :=
      congrArg frobNormSqRect hfactor
    _ = ∑ a : Fin r, s (Fin.castLE h.rank_le_width a) ^ 2 :=
      frobNormSqRect_realOrthonormalDiagonalFactor_eq_sum_sq
        u (fun a : Fin r => s (Fin.castLE h.rank_le_width a)) v
          h.leftSingularVectors_orthonormal h.rightSingularVectors_orthonormal

/-- Zero extension makes the full-width sum of supplied singular squares equal
to its rank-length prefix sum. -/
theorem IsRealMatrixSVD.sum_singularValues_sq_eq_sum_rank {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) :
    (∑ i : Fin n, s i ^ 2) =
      ∑ a : Fin r, s (Fin.castLE h.rank_le_width a) ^ 2 := by
  let e : Fin r ↪ Fin n :=
    ⟨Fin.castLE h.rank_le_width, Fin.castLE_injective h.rank_le_width⟩
  let t : Finset (Fin n) := Finset.univ.map e
  have hsubset : t ⊆ Finset.univ := Finset.subset_univ t
  have hout : ∀ i ∈ (Finset.univ : Finset (Fin n)), i ∉ t → s i ^ 2 = 0 := by
    intro i _ hi
    have hir : r ≤ i.val := by
      by_contra hnot
      have hir' : i.val < r := Nat.lt_of_not_ge hnot
      let a : Fin r := ⟨i.val, hir'⟩
      have hea : e a = i := by
        apply Fin.ext
        rfl
      apply hi
      exact Finset.mem_map.mpr ⟨a, Finset.mem_univ a, hea⟩
    rw [h.singularValues_zero_of_rank_le i hir, zero_pow]
    norm_num
  have hsum := Finset.sum_subset hsubset hout
  calc
    (∑ i : Fin n, s i ^ 2) = ∑ i ∈ t, s i ^ 2 := hsum.symm
    _ = ∑ a : Fin r, s (e a) ^ 2 := by
      simp [t]
    _ = ∑ a : Fin r, s (Fin.castLE h.rank_le_width a) ^ 2 := rfl

/-- Transport an SVD certificate across an equality of its rank index type. -/
theorem IsRealMatrixSVD.castRank {m n r r' : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) (hr : r' = r) :
    IsRealMatrixSVD A r' s
      (fun a => u (Fin.cast hr a))
      (fun a => v (Fin.cast hr a)) := by
  subst r'
  simpa using h

/-- Every supplied ordered SVD singular value agrees with the canonical
complexified Gram singular value. -/
theorem IsRealMatrixSVD.singularValue_eq_canonical {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) (i : Fin n) :
    s i = complexMatrixSingularValue (realRectToCMatrix A) i := by
  have hle : ∀ j : Fin n,
      complexMatrixSingularValue (realRectToCMatrix A) j ≤ s j := by
    intro j
    by_cases hj : r ≤ j.val
    · have hrank : realRectMatrixRank A ≤ r := h.rankAtMost.realRectMatrixRank_le
      have hzcanon := complexMatrixSingularValue_eq_zero_of_rank_le
        (realRectToCMatrix A) j (hrank.trans hj)
      have hzs := h.singularValues_zero_of_rank_le j hj
      rw [hzcanon, hzs]
    · have hjr : j.val < r := Nat.lt_of_not_ge hj
      let k := j.val
      let q := r - k
      have hq : 0 < q := by omega
      have hr : k + q = r := by omega
      let u' : Fin (k + q) → EuclideanSpace ℝ (Fin m) :=
        fun a => u (Fin.cast hr a)
      let v' : Fin (k + q) → EuclideanSpace ℝ (Fin n) :=
        fun a => v (Fin.cast hr a)
      have h' : IsRealMatrixSVD A (k + q) s u' v' := by
        simpa [u', v'] using h.castRank hr
      have hb := h'.canonicalSingularValue_le_firstTail hq
      have hidx : Fin.castLE h'.rank_le_width
          (Fin.natAdd k (⟨0, hq⟩ : Fin q)) = j := by
        apply Fin.ext
        rfl
      simpa [hidx] using hb
  have hsqle : ∀ j : Fin n,
      complexMatrixSingularValue (realRectToCMatrix A) j ^ 2 ≤ s j ^ 2 := by
    intro j
    nlinarith [complexMatrixSingularValue_nonneg (realRectToCMatrix A) j,
      h.singularValues_nonnegative j, hle j]
  have hsum :
      (∑ j : Fin n,
          complexMatrixSingularValue (realRectToCMatrix A) j ^ 2) =
        ∑ j : Fin n, s j ^ 2 := by
    calc
      (∑ j : Fin n,
          complexMatrixSingularValue (realRectToCMatrix A) j ^ 2) =
          complexMatrixFrobeniusSq (realRectToCMatrix A) :=
        (complexMatrixFrobeniusSq_eq_sum_singularValue_sq
          (realRectToCMatrix A)).symm
      _ = frobNormSqRect A := by
        rw [← frobNormRect_sq A,
          frobNormRect_sq_eq_complexMatrixFrobeniusSq_realRectToCMatrix]
      _ = ∑ a : Fin r, s (Fin.castLE h.rank_le_width a) ^ 2 :=
        h.frobNormSq_eq_sum_rank_singularValues
      _ = ∑ j : Fin n, s j ^ 2 := h.sum_singularValues_sq_eq_sum_rank.symm
  have hall := (Finset.sum_eq_sum_iff_of_le
    (s := (Finset.univ : Finset (Fin n)))
    (fun j _ => hsqle j)).mp hsum
  have hsquares := hall i (Finset.mem_univ i)
  nlinarith [complexMatrixSingularValue_nonneg (realRectToCMatrix A) i,
    h.singularValues_nonnegative i]

/-- The canonical singular values of an exact SVD tail are its shifted,
zero-extended supplied singular-value sequence. -/
theorem IsRealMatrixSVD.tail_singularValue_eq {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) (i : Fin n) :
    complexMatrixSingularValue
        (realRectToCMatrix (realSVDTail s u v h.rank_le_width)) i =
      realSVDTailSingularValues s h.rank_le_width i := by
  symm
  exact h.tail_isRealMatrixSVD.singularValue_eq_canonical i

/-- The operator norm of a nonempty exact SVD tail is exactly its first
coefficient, i.e. the source's `(k+1)`-st singular value. -/
theorem IsRealMatrixSVD.operatorNorm_tail_eq {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) (hq : 0 < q) :
    realMatrixOperatorNorm (realSVDTail s u v h.rank_le_width) =
      s (Fin.castLE h.rank_le_width
        (Fin.natAdd k (⟨0, hq⟩ : Fin q))) := by
  let Ak := realSVDHead s u v h.rank_le_width
  have hk : k < n := lt_of_lt_of_le (Nat.lt_add_of_pos_right hq) h.rank_le_width
  have hlower := eckartYoungOperatorLowerBound A Ak hk
    (realSVDHead_rankAtMost s u v h.rank_le_width)
  have hidx : (⟨k, hk⟩ : Fin n) =
      Fin.castLE h.rank_le_width (Fin.natAdd k (⟨0, hq⟩ : Fin q)) := by
    apply Fin.ext
    rfl
  rw [hidx, ← h.singularValue_eq_canonical,
    h.sub_head_eq_tail] at hlower
  exact le_antisymm (h.operatorNorm_tail_le hq) hlower

/-! ## Best-approximation certificates -/

/-- Residual measured by the real Euclidean operator norm. -/
noncomputable def lowRankResidualOperator {m n : ℕ}
    (A B : Matrix (Fin m) (Fin n) ℝ) : ℝ :=
  realMatrixOperatorNorm (fun i j => A i j - B i j)

/-- An operator-norm best rank-`k` approximation certificate. -/
structure IsBestRankApproxOperator (m n k : ℕ)
    (A Ak : Matrix (Fin m) (Fin n) ℝ) : Prop where
  rank_le : RectRankAtMost m n k Ak
  optimal : ∀ B, RectRankAtMost m n k B →
    lowRankResidualOperator A Ak ≤ lowRankResidualOperator A B

/-- Residual measured by a represented real unitarily invariant norm. -/
noncomputable def lowRankResidualUnitaryInvariant {m n : ℕ}
    (N : RealRectUnitarilyInvariantNorm m n)
    (A B : Matrix (Fin m) (Fin n) ℝ) : ℝ :=
  N.norm (fun i j => A i j - B i j)

/-- A single rank-`k` approximation which is best simultaneously for every
real rectangular unitarily invariant norm. -/
structure IsBestRankApproxUnitaryInvariant (m n k : ℕ)
    (A Ak : Matrix (Fin m) (Fin n) ℝ) : Prop where
  rank_le : RectRankAtMost m n k Ak
  optimal : ∀ (N : RealRectUnitarilyInvariantNorm m n) B,
    RectRankAtMost m n k B →
      lowRankResidualUnitaryInvariant N A Ak ≤
        lowRankResidualUnitaryInvariant N A B

/-- The first `k` terms of rank-`k+q` SVD data are a best rank-`k`
approximation in the operator norm whenever the tail is nonempty. -/
theorem IsRealMatrixSVD.isBestRankApproxOperator_head {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) (hq : 0 < q) :
    IsBestRankApproxOperator m n k A
      (realSVDHead s u v h.rank_le_width) := by
  let Ak := realSVDHead s u v h.rank_le_width
  let tailIndex : Fin n := Fin.castLE h.rank_le_width
    (Fin.natAdd k (⟨0, hq⟩ : Fin q))
  have hk : k < n := lt_of_lt_of_le (Nat.lt_add_of_pos_right hq) h.rank_le_width
  have hidx : (⟨k, hk⟩ : Fin n) = tailIndex := by
    apply Fin.ext
    rfl
  refine ⟨realSVDHead_rankAtMost s u v h.rank_le_width, ?_⟩
  intro B hB
  have hlower := eckartYoungOperatorLowerBound A B hk hB
  rw [hidx, ← h.singularValue_eq_canonical tailIndex] at hlower
  have hupper := h.operatorNorm_tail_le hq
  have hres : (fun i j => A i j - Ak i j) =
      realSVDTail s u v h.rank_le_width := h.sub_head_eq_tail
  unfold lowRankResidualOperator
  rw [hres]
  exact hupper.trans hlower

/-- **Eckart--Young--Mirsky for every unitarily invariant norm.**  The first
`k` terms of exact rank-`k+q` real SVD data are simultaneously best among all
rank-at-most-`k` competitors for every symmetric-gauge represented
unitarily invariant norm. -/
theorem IsRealMatrixSVD.isBestRankApproxUnitaryInvariant_head {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) :
    IsBestRankApproxUnitaryInvariant m n k A
      (realSVDHead s u v h.rank_le_width) := by
  let Ak := realSVDHead s u v h.rank_le_width
  refine ⟨realSVDHead_rankAtMost s u v h.rank_le_width, ?_⟩
  intro N B hB
  have hres : (fun i j => A i j - Ak i j) =
      realSVDTail s u v h.rank_le_width := h.sub_head_eq_tail
  unfold lowRankResidualUnitaryInvariant RealRectUnitarilyInvariantNorm.norm
  rw [hres]
  apply N.gauge.mono_nonnegative
  · intro i
    exact complexMatrixSingularValue_nonneg _ _
  · intro i
    rw [h.tail_singularValue_eq i]
    by_cases hi : i.val < q
    · rw [realSVDTailSingularValues, dif_pos hi]
      let c : Fin q := ⟨i.val, hi⟩
      have hshift := eckartYoungShiftedSingularValueLowerBound
        A B h.rank_le_width hB c
      rw [h.singularValue_eq_canonical
        (Fin.castLE h.rank_le_width (Fin.natAdd k c))]
      simpa [c] using hshift
    · rw [realSVDTailSingularValues, dif_neg hi]
      exact complexMatrixSingularValue_nonneg _ _

/-! ## Frobenius optimality -/

/-- Coordinates of a matrix on a supplied orthonormal right family. -/
noncomputable def realMatrixRightOrthonormalCoordinates {m n r : ℕ}
    (B : Matrix (Fin m) (Fin n) ℝ)
    (v : Fin r → EuclideanSpace ℝ (Fin n)) : Matrix (Fin m) (Fin r) ℝ :=
  fun i a => ∑ j : Fin n, B i j * v a j

/-- Right orthonormal coordinates preserve a rank-at-most certificate. -/
theorem RectRankAtMost.rightOrthonormalCoordinates {m n r k : ℕ}
    {B : Matrix (Fin m) (Fin n) ℝ} (hB : RectRankAtMost m n k B)
    (v : Fin r → EuclideanSpace ℝ (Fin n)) :
    RectRankAtMost m r k (realMatrixRightOrthonormalCoordinates B v) := by
  rcases hB with ⟨fac⟩
  refine ⟨{
    left := fac.left
    right := fun b a => ∑ j : Fin n, fac.right b j * v a j
    factorization := ?_ }⟩
  intro i a
  unfold realMatrixRightOrthonormalCoordinates
  simp_rw [fac.factorization, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro b _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  ring

/-- Taking coordinates along an orthonormal right family cannot increase the
squared Frobenius norm. -/
theorem frobNormSqRect_rightOrthonormalCoordinates_le {m n r : ℕ}
    (M : Matrix (Fin m) (Fin n) ℝ)
    (v : Fin r → EuclideanSpace ℝ (Fin n)) (hv : Orthonormal ℝ v) :
    frobNormSqRect (realMatrixRightOrthonormalCoordinates M v) ≤
      frobNormSqRect M := by
  unfold frobNormSqRect realMatrixRightOrthonormalCoordinates
  apply Finset.sum_le_sum
  intro i _
  simpa [vecNorm2Sq, mul_comm] using
    (vecNorm2Sq_inner_orthonormal_le v hv (fun j => M i j))

/-- An exact SVD becomes a diagonal left factor after taking coordinates along
its right singular family. -/
theorem IsRealMatrixSVD.rightOrthonormalCoordinates_eq {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) :
    realMatrixRightOrthonormalCoordinates A v =
      fun i a => s (Fin.castLE h.rank_le_width a) * u a i := by
  funext i a
  unfold realMatrixRightOrthonormalCoordinates
  simp_rw [h.reconstruction, Finset.sum_mul]
  rw [Finset.sum_comm]
  have hv := h.rightSingularVectors_orthonormal
  rw [orthonormal_iff_ite] at hv
  calc
    (∑ x : Fin r, ∑ j : Fin n,
        (s (Fin.castLE h.rank_le_width x) * u x i * v x j) * v a j) =
        ∑ x : Fin r,
          (s (Fin.castLE h.rank_le_width x) * u x i) *
            (∑ j : Fin n, v x j * v a j) := by
      apply Finset.sum_congr rfl
      intro x _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = ∑ x : Fin r,
        (s (Fin.castLE h.rank_le_width x) * u x i) *
          (if x = a then 1 else 0) := by
      apply Finset.sum_congr rfl
      intro x _
      congr 1
      have hxa := hv x a
      rw [PiLp.inner_apply] at hxa
      simpa [real_inner_eq_re_inner, RCLike.inner_apply, mul_comm] using hxa
    _ = s (Fin.castLE h.rank_le_width a) * u a i := by simp

/-- Tail singular-square energy is bounded by the squared Frobenius residual
of every rank-at-most-`k` competitor. -/
theorem IsRealMatrixSVD.tail_sum_sq_le_residual_frob_sq {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v)
    (B : Matrix (Fin m) (Fin n) ℝ) (hB : RectRankAtMost m n k B) :
    (∑ c : Fin q,
        s (Fin.castLE h.rank_le_width (Fin.natAdd k c)) ^ 2) ≤
      frobNormSqRect (fun i j => A i j - B i j) := by
  let d : Fin (k + q) → ℝ := fun a => s (Fin.castLE h.rank_le_width a)
  let C : Matrix (Fin m) (Fin (k + q)) ℝ :=
    fun i a => d a * u a i
  let Bc := realMatrixRightOrthonormalCoordinates B v
  have hBc : RectRankAtMost m (k + q) k Bc :=
    hB.rightOrthonormalCoordinates v
  rcases hBc with ⟨fac⟩
  obtain ⟨x, hx, _hxzero, henergy⟩ :=
    rectRankFactorization_exists_orthonormalRightKernelFamily_energy_le
      (A := C) fac
  let xE : Fin q → EuclideanSpace ℝ (Fin (k + q)) :=
    fun c => (x c : EuclideanSpace ℝ (Fin (k + q)))
  have hxE : Orthonormal ℝ xE := by
    rw [orthonormal_iff_ite] at hx ⊢
    intro c e
    have hce := hx c e
    simpa [xE, Submodule.coe_inner] using hce
  have hmono : ∀ i j : Fin (k + q), i.val ≤ j.val → d j ^ 2 ≤ d i ^ 2 := by
    intro i j hij
    have hcast : Fin.castLE h.rank_le_width i ≤
        Fin.castLE h.rank_le_width j := by
      exact Fin.le_iff_val_le_val.mpr hij
    have hs := h.singularValues_antitone hcast
    have hi0 := h.singularValues_nonnegative (Fin.castLE h.rank_le_width i)
    have hj0 := h.singularValues_nonnegative (Fin.castLE h.rank_le_width j)
    dsimp [d]
    nlinarith
  have hdiag :=
    sum_vecNorm2Sq_diagonal_rectMatMulVec_ge_tail_sq_of_orthonormal_antitone
      d xE hxE hmono
  have hu' : ∀ a b : Fin (k + q),
      (∑ i : Fin m, u a i * u b i) = idMatrix (k + q) a b := by
    have hu := h.leftSingularVectors_orthonormal
    rw [orthonormal_iff_ite] at hu
    intro a b
    have hab := hu a b
    rw [PiLp.inner_apply] at hab
    simpa [real_inner_eq_re_inner, RCLike.inner_apply, idMatrix, mul_comm] using hab
  have haction : ∀ z : Fin (k + q) → ℝ,
      vecNorm2Sq (rectMatMulVec C z) =
        vecNorm2Sq (fun a => d a * z a) := by
    intro z
    have hleft := vecNorm2Sq_leftOrthonormalFactor
      (fun i a => u a i) (fun a => d a * z a) hu'
    have heq : rectMatMulVec C z =
        fun i => ∑ a : Fin (k + q), u a i * (d a * z a) := by
      funext i
      unfold rectMatMulVec C
      apply Finset.sum_congr rfl
      intro a _
      ring
    rw [heq]
    exact hleft
  have hsource :
      (∑ c : Fin q, d (Fin.natAdd k c) ^ 2) ≤
        ∑ c : Fin q,
          vecNorm2Sq (rectMatMulVec C
            (fun j => (xE c : EuclideanSpace ℝ (Fin (k + q))) j)) := by
    calc
      (∑ c : Fin q, d (Fin.natAdd k c) ^ 2) ≤
          ∑ c : Fin q,
            vecNorm2Sq (rectMatMulVec
              (fun i j : Fin (k + q) => if i = j then d i else 0)
              (fun j => (xE c : EuclideanSpace ℝ (Fin (k + q))) j)) := hdiag
      _ = ∑ c : Fin q,
          vecNorm2Sq (rectMatMulVec C
            (fun j => (xE c : EuclideanSpace ℝ (Fin (k + q))) j)) := by
        apply Finset.sum_congr rfl
        intro c _
        rw [haction]
        congr 1
        funext a
        unfold rectMatMulVec
        simp
  have hcompressed : frobNormSqRect (fun i a => C i a - Bc i a) ≤
      frobNormSqRect (fun i j => A i j - B i j) := by
    have hcoordA := h.rightOrthonormalCoordinates_eq
    have heq : (fun i a => C i a - Bc i a) =
        realMatrixRightOrthonormalCoordinates (fun i j => A i j - B i j) v := by
      funext i a
      have hAia := congrFun (congrFun hcoordA i) a
      have hCA : C i a = realMatrixRightOrthonormalCoordinates A v i a := by
        simpa [C, d] using hAia.symm
      rw [hCA]
      unfold Bc realMatrixRightOrthonormalCoordinates
      calc
        (∑ j : Fin n, A i j * v a j) - ∑ j : Fin n, B i j * v a j =
            ∑ j : Fin n, (A i j * v a j - B i j * v a j) := by
          rw [Finset.sum_sub_distrib]
        _ = ∑ j : Fin n, (A i j - B i j) * v a j := by
          apply Finset.sum_congr rfl
          intro j _
          ring
    rw [heq]
    exact frobNormSqRect_rightOrthonormalCoordinates_le _ v
      h.rightSingularVectors_orthonormal
  have henergy' :
      (∑ c : Fin q,
          vecNorm2Sq (rectMatMulVec C
            (fun j => (xE c : EuclideanSpace ℝ (Fin (k + q))) j))) ≤
        frobNormSqRect (fun i j => C i j - Bc i j) := by
    simpa [xE] using henergy
  exact (by simpa [d] using hsource.trans (henergy'.trans hcompressed))

/-- The Frobenius norm of the exact SVD tail is the square root of its tail
singular-square sum. -/
theorem IsRealMatrixSVD.frobNorm_tail_eq {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) :
    frobNormRect (realSVDTail s u v h.rank_le_width) =
      Real.sqrt (∑ c : Fin q,
        s (Fin.castLE h.rank_le_width (Fin.natAdd k c)) ^ 2) := by
  unfold frobNormRect
  congr 1
  rw [realSVDTail_eq_orthonormalDiagonalFactor]
  exact frobNormSqRect_realOrthonormalDiagonalFactor_eq_sum_sq
    (fun c : Fin q => u (Fin.natAdd k c))
    (fun c : Fin q => s (Fin.castLE h.rank_le_width (Fin.natAdd k c)))
    (fun c : Fin q => v (Fin.natAdd k c))
    (h.leftSingularVectors_orthonormal.comp (Fin.natAdd k)
      (Fin.natAdd_injective q k))
    (h.rightSingularVectors_orthonormal.comp (Fin.natAdd k)
      (Fin.natAdd_injective q k))

/-- The first `k` terms of exact rank-`k+q` SVD data are a Frobenius-best
rank-`k` approximation. -/
theorem IsRealMatrixSVD.isBestRankApproxFrob_head {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A (k + q) s u v) :
    IsBestRankApproxFrob m n k A (realSVDHead s u v h.rank_le_width) := by
  refine ⟨realSVDHead_rankAtMost s u v h.rank_le_width, ?_⟩
  intro B hB
  have hlower := h.tail_sum_sq_le_residual_frob_sq B hB
  have hsqrt := Real.sqrt_le_sqrt hlower
  have hres : (fun i j => A i j - realSVDHead s u v h.rank_le_width i j) =
      realSVDTail s u v h.rank_le_width := h.sub_head_eq_tail
  unfold lowRankResidualFrob
  rw [hres, h.frobNorm_tail_eq]
  exact hsqrt

end NumStability
