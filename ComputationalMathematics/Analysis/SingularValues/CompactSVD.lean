import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.GramBasis

/-!
# Exact compact real singular value decomposition

The canonical right-Gram construction includes rank zero. Existing authored declaration names are retained.
-/

namespace NumStability

open scoped BigOperators

/-- Exact compact real SVD data
`A = U_r diag(sigma) V_r^T`.  The columns of `U_r` and `V_r` are
orthonormal and the retained singular values are positive. -/
structure Higham20CompactRealSVD {m n r : Nat}
    (A : Fin m -> Fin n -> Real)
    (U : Fin m -> Fin r -> Real) (sigma : Fin r -> Real)
    (V : Fin n -> Fin r -> Real) : Prop where
  factorization :
    rectMatMul (rectMatMul U (diagMatrix sigma)) (finiteTranspose V) = A
  left_columns_orthonormal :
    rectMatMul (finiteTranspose U) U = idMatrix r
  right_columns_orthonormal :
    rectMatMul (finiteTranspose V) V = idMatrix r
  singularValue_pos : forall k : Fin r, 0 < sigma k

end NumStability

namespace NumStability.Ch14Ext

open NumStability
open scoped BigOperators

/-- The finite set of nonzero right-Gram singular directions. -/
noncomputable def ch14ext_nonzeroRightGramSingularIndices {m n : ℕ}
    (A : Fin m → Fin n → ℝ) : Finset (Fin n) := by
  classical
  exact Finset.univ.filter
    (fun a => rectRightGramBasisSingularValue A a ≠ 0)

/-- Left factor of the canonical compact SVD, enumerating precisely the
nonzero right-Gram singular directions. -/
noncomputable def ch14ext_compactSVDLeft {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    Fin m → Fin (ch14ext_nonzeroRightGramSingularIndices A).card → ℝ :=
  fun i a =>
    rectRightGramLeftSingularZeroSafe A i
      ((ch14ext_nonzeroRightGramSingularIndices A).orderEmbOfFin rfl a)

/-- Positive singular values of the canonical compact SVD. -/
noncomputable def ch14ext_compactSVDSingularValues {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    Fin (ch14ext_nonzeroRightGramSingularIndices A).card → ℝ :=
  fun a =>
    rectRightGramBasisSingularValue A
      ((ch14ext_nonzeroRightGramSingularIndices A).orderEmbOfFin rfl a)

/-- Right factor of the canonical compact SVD. -/
noncomputable def ch14ext_compactSVDRight {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    Fin n → Fin (ch14ext_nonzeroRightGramSingularIndices A).card → ℝ :=
  fun j a =>
    rectRightGramEigenbasis A j
      ((ch14ext_nonzeroRightGramSingularIndices A).orderEmbOfFin rfl a)

private theorem ch14ext_compactSVD_selected_singularValue_ne_zero {m n : ℕ}
    (A : Fin m → Fin n → ℝ)
    (a : Fin (ch14ext_nonzeroRightGramSingularIndices A).card) :
    rectRightGramBasisSingularValue A
        ((ch14ext_nonzeroRightGramSingularIndices A).orderEmbOfFin rfl a) ≠ 0 := by
  have hmem := Finset.orderEmbOfFin_mem
    (ch14ext_nonzeroRightGramSingularIndices A) rfl a
  simpa [ch14ext_nonzeroRightGramSingularIndices] using hmem

private theorem ch14ext_nonzeroRightGramSVDHead_eq {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    rectRightGramBasisSVDHead A
        (ch14ext_nonzeroRightGramSingularIndices A) = A := by
  classical
  let s := ch14ext_nonzeroRightGramSingularIndices A
  have htail : rectRightGramBasisSVDTail A s = 0 := by
    ext i j
    unfold rectRightGramBasisSVDTail
    apply Finset.sum_eq_zero
    intro a ha
    have hnot : a ∉ s := Finset.mem_compl.mp ha
    have htau : rectRightGramBasisSingularValue A a = 0 := by
      by_contra hne
      exact hnot (by
        simpa [s, ch14ext_nonzeroRightGramSingularIndices] using hne)
    simp [htau]
  ext i j
  have hsplit := rectRightGramBasisSVD_head_add_tail A s i j
  rw [htail] at hsplit
  simpa [s] using hsplit

/-- The right-Gram construction gives an exact compact SVD for every real
rectangular matrix, including rank zero. -/
theorem ch14ext_compactSVD_certificate {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    Higham20CompactRealSVD A
      (ch14ext_compactSVDLeft A)
      (ch14ext_compactSVDSingularValues A)
      (ch14ext_compactSVDRight A) := by
  classical
  let s := ch14ext_nonzeroRightGramSingularIndices A
  let e : Fin s.card → Fin n := fun a => s.orderEmbOfFin rfl a
  let U : Fin m → Fin s.card → ℝ :=
    fun i a => rectRightGramLeftSingularZeroSafe A i (e a)
  let sigma : Fin s.card → ℝ :=
    fun a => rectRightGramBasisSingularValue A (e a)
  let V : Fin n → Fin s.card → ℝ :=
    fun j a => rectRightGramEigenbasis A j (e a)
  have hne : ∀ a : Fin s.card, sigma a ≠ 0 := by
    intro a
    simpa [s, e, sigma] using
      ch14ext_compactSVD_selected_singularValue_ne_zero A a
  have hpos : ∀ a : Fin s.card, 0 < sigma a := by
    intro a
    exact lt_of_le_of_ne
      (rectRightGramBasisSingularValue_nonneg A (e a)) (Ne.symm (hne a))
  have hhead : rectRightGramBasisSVDHead A s = A := by
    simpa [s] using ch14ext_nonzeroRightGramSVDHead_eq A
  have hfactorization :
      rectMatMul (rectMatMul U (diagMatrix sigma)) (finiteTranspose V) = A := by
    ext i j
    calc
      rectMatMul (rectMatMul U (diagMatrix sigma)) (finiteTranspose V) i j =
          ∑ a : Fin s.card, U i a * (sigma a * V j a) := by
            unfold rectMatMul diagMatrix finiteTranspose
            apply Finset.sum_congr rfl
            intro a _
            rw [Finset.sum_eq_single a]
            · simp
              ring
            · intro b _ hba
              simp [hba]
            · intro ha
              exact (ha (Finset.mem_univ a)).elim
      _ = rectRightGramBasisSVDHead A s i j := by
            symm
            simpa [rectRightGramBasisSVDHeadRankFactorization,
              U, sigma, V, e] using
              (rectRightGramBasisSVDHeadRankFactorization A s).factorization i j
      _ = A i j := congrFun (congrFun hhead i) j
  have hleft : rectMatMul (finiteTranspose U) U = idMatrix s.card := by
    ext a b
    change ∑ i : Fin m, U i a * U i b = idMatrix s.card a b
    have horth :=
      rectRightGramLeftSingularZeroSafe_col_orthonormal_of_pos A
        (hpos a) (hpos b)
    change ∑ i : Fin m,
        rectRightGramLeftSingularZeroSafe A i (e a) *
          rectRightGramLeftSingularZeroSafe A i (e b) = _ at horth
    rw [horth]
    by_cases hab : a = b
    · subst b
      simp [idMatrix]
    · have heab : e a ≠ e b := fun h => hab ((s.orderEmbOfFin rfl).injective h)
      simp [idMatrix, hab, heab]
  have hright : rectMatMul (finiteTranspose V) V = idMatrix s.card := by
    ext a b
    change ∑ j : Fin n, V j a * V j b = idMatrix s.card a b
    have horth := rectRightGramEigenbasis_col_orthonormal A (e a) (e b)
    change ∑ j : Fin n,
        rectRightGramEigenbasis A j (e a) *
          rectRightGramEigenbasis A j (e b) = _ at horth
    rw [horth]
    by_cases hab : a = b
    · subst b
      simp [idMatrix]
    · have heab : e a ≠ e b := fun h => hab ((s.orderEmbOfFin rfl).injective h)
      simp [idMatrix, hab, heab]
  change Higham20CompactRealSVD A U sigma V
  exact ⟨hfactorization, hleft, hright, hpos⟩


end NumStability.Ch14Ext
