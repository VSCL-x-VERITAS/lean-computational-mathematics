import ComputationalMathematics.Analysis.MatrixAlgebra
import Mathlib.Analysis.InnerProductSpace.Rayleigh

/-!
# Operator norm of a finite real rectangular matrix

This module identifies the continuous-linear-map norm of a real matrix with
the attained maxima over nonzero vectors and over the Euclidean unit sphere.
-/

namespace NumStability

open scoped RealInnerProductSpace

noncomputable section

/-- The continuous linear map represented by a finite real matrix. -/
def realMatrixContinuousLinearMap {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    EuclideanSpace ℝ (Fin n) →L[ℝ] EuclideanSpace ℝ (Fin m) :=
  LinearMap.toContinuousLinearMap (Matrix.toEuclideanLin A)

/-- The subordinate Euclidean operator norm of a finite real matrix. -/
def realMatrixOperatorNorm {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) : ℝ :=
  ‖realMatrixContinuousLinearMap A‖

/-- Witness form of the two maximum characterizations of a finite real
matrix's Euclidean operator norm. -/
def IsRealMatrixOperatorNorm {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (c : ℝ) : Prop :=
  c = ‖realMatrixContinuousLinearMap A‖ ∧
    (∃ x : EuclideanSpace ℝ (Fin n),
      ‖x‖ = 1 ∧ ‖Matrix.toEuclideanLin A x‖ = c ∧
      ∀ y : EuclideanSpace ℝ (Fin n), ‖y‖ = 1 →
        ‖Matrix.toEuclideanLin A y‖ ≤ c) ∧
    (∃ x : EuclideanSpace ℝ (Fin n),
      x ≠ 0 ∧ ‖Matrix.toEuclideanLin A x‖ / ‖x‖ = c ∧
      ∀ y : EuclideanSpace ℝ (Fin n), y ≠ 0 →
        ‖Matrix.toEuclideanLin A y‖ / ‖y‖ ≤ c)

/-- Witness form of the bilinear two-sphere maximum characterization of a
finite real matrix's Euclidean operator norm. -/
def IsRealMatrixBilinearOperatorNorm {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (c : ℝ) : Prop :=
  c = ‖realMatrixContinuousLinearMap A‖ ∧
    ∃ x : EuclideanSpace ℝ (Fin n),
      ∃ y : EuclideanSpace ℝ (Fin m),
        ‖x‖ = 1 ∧ ‖y‖ = 1 ∧
          inner ℝ (Matrix.toEuclideanLin A x) y = c ∧
          ∀ u : EuclideanSpace ℝ (Fin n),
            ∀ v : EuclideanSpace ℝ (Fin m),
              ‖u‖ = 1 → ‖v‖ = 1 →
                inner ℝ (Matrix.toEuclideanLin A u) v ≤ c

/-- The real quadratic form associated with a square matrix. -/
def realMatrixQuadraticForm {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (x : EuclideanSpace ℝ (Fin n)) : ℝ :=
  inner ℝ (Matrix.toEuclideanLin A x) x

/-- Witness form of the absolute quadratic-form maximum characterization of
the Euclidean operator norm of a real symmetric matrix. -/
def IsSymmetricRealMatrixQuadraticOperatorNorm {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (c : ℝ) : Prop :=
  c = ‖realMatrixContinuousLinearMap A‖ ∧
    ∃ x : EuclideanSpace ℝ (Fin n),
      ‖x‖ = 1 ∧ |realMatrixQuadraticForm A x| = c ∧
        ∀ y : EuclideanSpace ℝ (Fin n), ‖y‖ = 1 →
          |realMatrixQuadraticForm A y| ≤ c

theorem exists_continuousLinearMap_unit_opNorm_attained_rect
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [ProperSpace E]
    [NormedAddCommGroup F] [NormedSpace ℝ F]
    (T : E →L[ℝ] F) (hunit : ({x : E | ‖x‖ = 1} : Set E).Nonempty) :
    ∃ x : E, ‖x‖ = 1 ∧ ‖T x‖ = ‖T‖ ∧
      ∀ y : E, ‖y‖ = 1 → ‖T y‖ ≤ ‖T‖ := by
  obtain ⟨x, hx, hmax⟩ :=
    isCompact_norm_unit_sphere.exists_isMaxOn hunit
      (T.continuous.norm.continuousOn)
  change ‖x‖ = 1 at hx
  have hop : ‖T‖ = ‖T x‖ := by
    apply le_antisymm
    · refine ContinuousLinearMap.opNorm_le_bound T (norm_nonneg (T x)) ?_
      intro y
      by_cases hy : y = 0
      · simp [hy]
      · let a : ℝ := ‖y‖
        have ha_pos : 0 < a := norm_pos_iff.mpr hy
        let z : E := a⁻¹ • y
        have hz : ‖z‖ = 1 := by
          simp [z, a, norm_smul, ha_pos.ne']
        have hzmax : ‖T z‖ ≤ ‖T x‖ := hmax hz
        have hy_eq : y = a • z := by
          simp [z, a, ha_pos.ne']
        calc
          ‖T y‖ = ‖T (a • z)‖ := by rw [hy_eq]
          _ = ‖a • T z‖ := by rw [map_smul]
          _ = a * ‖T z‖ := by simp [a, norm_smul]
          _ ≤ a * ‖T x‖ := mul_le_mul_of_nonneg_left hzmax (norm_nonneg y)
          _ = ‖T x‖ * ‖y‖ := by ring
    · have hle := ContinuousLinearMap.le_opNorm T x
      simpa [hx] using hle
  refine ⟨x, hx, hop.symm, ?_⟩
  intro y hy
  rw [hop]
  exact hmax hy

/-- A nonzero-domain real rectangular matrix attains both standard maximum
forms of its Euclidean operator norm. -/
theorem realMatrixOperatorNorm_characterization {m n : ℕ} (hn : 0 < n)
    (A : Matrix (Fin m) (Fin n) ℝ) :
    IsRealMatrixOperatorNorm A (realMatrixOperatorNorm A) := by
  let i : Fin n := ⟨0, hn⟩
  have hunit : ({x : EuclideanSpace ℝ (Fin n) | ‖x‖ = 1} : Set _).Nonempty := by
    refine ⟨EuclideanSpace.single i (1 : ℝ), ?_⟩
    simp
  obtain ⟨x, hx, hTx, hmax⟩ :=
    exists_continuousLinearMap_unit_opNorm_attained_rect
      (realMatrixContinuousLinearMap A) hunit
  refine ⟨rfl, ?_, ?_⟩
  · refine ⟨x, hx, ?_, ?_⟩
    · simpa [realMatrixOperatorNorm, realMatrixContinuousLinearMap] using hTx
    · intro y hy
      simpa [realMatrixOperatorNorm, realMatrixContinuousLinearMap] using
        hmax y hy
  · refine ⟨x, ?_, ?_, ?_⟩
    · intro hzero
      simp [hzero] at hx
    · rw [hx, div_one]
      simpa [realMatrixOperatorNorm, realMatrixContinuousLinearMap] using hTx
    · intro y hy
      have hynorm : 0 < ‖y‖ := norm_pos_iff.mpr hy
      apply (div_le_iff₀ hynorm).2
      simpa [realMatrixOperatorNorm, realMatrixContinuousLinearMap] using
        (ContinuousLinearMap.le_opNorm (realMatrixContinuousLinearMap A) y)

/-- The Euclidean operator norm equals its literal coordinate supremum,
including the empty unit sphere in a zero-dimensional domain. -/
theorem realMatrixOperatorNorm_eq_coordinate_sSup {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    realMatrixOperatorNorm A =
      sSup {q : ℝ | ∃ x : Fin n → ℝ, (∑ j, x j ^ 2) = 1 ∧
        q = Real.sqrt (∑ a, (∑ b, A a b * x b) ^ 2)} := by
  have hnorm (x : EuclideanSpace ℝ (Fin n)) :
      ‖Matrix.toEuclideanLin A x‖ =
        Real.sqrt (∑ a, (∑ b, A a b * x b) ^ 2) := by
    rw [EuclideanSpace.norm_eq]
    simp only [Real.norm_eq_abs, sq_abs]
    rfl
  by_cases hn : 0 < n
  · obtain ⟨_, ⟨x, hx, hAx, hmax⟩, _⟩ :=
      realMatrixOperatorNorm_characterization hn A
    have hxSq : (∑ j, x j ^ 2) = 1 := by
      simpa only [hx, one_pow, Real.norm_eq_abs, sq_abs] using
        (EuclideanSpace.norm_sq_eq x).symm
    have hmem : realMatrixOperatorNorm A ∈
        {q : ℝ | ∃ y : Fin n → ℝ, (∑ j, y j ^ 2) = 1 ∧
          q = Real.sqrt (∑ a, (∑ b, A a b * y b) ^ 2)} :=
      ⟨fun j ↦ x j, hxSq, hAx.symm.trans (hnorm x)⟩
    have hupper : ∀ q ∈
        {q : ℝ | ∃ y : Fin n → ℝ, (∑ j, y j ^ 2) = 1 ∧
          q = Real.sqrt (∑ a, (∑ b, A a b * y b) ^ 2)},
        q ≤ realMatrixOperatorNorm A := by
      rintro q ⟨y, hy, rfl⟩
      have hunit : ‖(WithLp.toLp 2 y : EuclideanSpace ℝ (Fin n))‖ = 1 := by
        rw [EuclideanSpace.norm_eq]
        simp only [Real.norm_eq_abs, sq_abs, hy, Real.sqrt_one]
      simpa only [hnorm] using hmax (WithLp.toLp 2 y) hunit
    exact le_antisymm (le_csSup ⟨_, hupper⟩ hmem)
      (csSup_le ⟨_, hmem⟩ hupper)
  · have hn0 : n = 0 := Nat.eq_zero_of_not_pos hn
    subst n
    have hempty :
        {q : ℝ | ∃ x : Fin 0 → ℝ, (∑ j, x j ^ 2) = 1 ∧
          q = Real.sqrt (∑ a, (∑ b, A a b * x b) ^ 2)} = ∅ := by
      ext q
      simp
    rw [hempty, Real.sSup_empty, realMatrixOperatorNorm]
    exact ContinuousLinearMap.opNorm_subsingleton _

/-- A real rectangular matrix with nonzero domain and codomain dimensions
attains its operator norm as a bilinear form on the product of the two unit
spheres. -/
theorem realMatrixOperatorNorm_bilinear_characterization {m n : ℕ}
    (hm : 0 < m) (hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ) :
    IsRealMatrixBilinearOperatorNorm A (realMatrixOperatorNorm A) := by
  obtain ⟨hop, ⟨x, hx, hAx, hbound⟩, _⟩ :=
    realMatrixOperatorNorm_characterization hn A
  refine ⟨hop, ?_⟩
  by_cases hzero : Matrix.toEuclideanLin A x = 0
  · let j : Fin m := ⟨0, hm⟩
    let y : EuclideanSpace ℝ (Fin m) := EuclideanSpace.single j (1 : ℝ)
    have hy : ‖y‖ = 1 := by simp [y]
    have hopzero : realMatrixOperatorNorm A = 0 := by
      rw [← hAx, hzero, norm_zero]
    refine ⟨x, y, hx, hy, ?_, ?_⟩
    · simp [hzero, hopzero]
    · intro u v hu hv
      rw [hopzero]
      have hu0 : ‖Matrix.toEuclideanLin A u‖ = 0 :=
        le_antisymm (by simpa [hopzero] using hbound u hu) (norm_nonneg _)
      have hAu : Matrix.toEuclideanLin A u = 0 := norm_eq_zero.mp hu0
      simp [hAu]
  · let z : EuclideanSpace ℝ (Fin m) := Matrix.toEuclideanLin A x
    let y : EuclideanSpace ℝ (Fin m) := ‖z‖⁻¹ • z
    have hz : z ≠ 0 := by simpa [z] using hzero
    have hznorm : ‖z‖ ≠ 0 := norm_ne_zero_iff.mpr hz
    have hy : ‖y‖ = 1 := by
      simp [y, norm_smul, hznorm]
    have hinner : inner ℝ z y = ‖z‖ := by
      dsimp [y]
      rw [real_inner_smul_right, real_inner_self_eq_norm_sq]
      field_simp
    refine ⟨x, y, hx, hy, ?_, ?_⟩
    · rw [← hAx]
      exact hinner
    · intro u v hu hv
      calc
        inner ℝ (Matrix.toEuclideanLin A u) v
            ≤ ‖Matrix.toEuclideanLin A u‖ * ‖v‖ :=
          real_inner_le_norm _ _
        _ = ‖Matrix.toEuclideanLin A u‖ := by rw [hv, mul_one]
        _ ≤ realMatrixOperatorNorm A := hbound u hu

/-- A real symmetric matrix of positive dimension attains its operator norm
as the absolute value of its quadratic form on the unit sphere. -/
theorem symmetricRealMatrixOperatorNorm_quadratic_characterization {n : ℕ}
    (hn : 0 < n) (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) :
    IsSymmetricRealMatrixQuadraticOperatorNorm A
      (realMatrixOperatorNorm A) := by
  let T := realMatrixContinuousLinearMap A
  let i : Fin n := ⟨0, hn⟩
  have hunit : ({x : EuclideanSpace ℝ (Fin n) | ‖x‖ = 1} : Set _).Nonempty := by
    refine ⟨EuclideanSpace.single i (1 : ℝ), ?_⟩
    simp
  have hcontinuous : Continuous
      (fun x : EuclideanSpace ℝ (Fin n) => |realMatrixQuadraticForm A x|) := by
    simpa [realMatrixQuadraticForm, realMatrixContinuousLinearMap] using
      ((realMatrixContinuousLinearMap A).continuous.inner continuous_id).abs
  obtain ⟨x, hx, hmax⟩ :=
    isCompact_norm_unit_sphere.exists_isMaxOn hunit hcontinuous.continuousOn
  change ‖x‖ = 1 at hx
  have hupper : ∀ y : EuclideanSpace ℝ (Fin n), ‖y‖ = 1 →
      |realMatrixQuadraticForm A y| ≤ realMatrixOperatorNorm A := by
    intro y hy
    calc
      |realMatrixQuadraticForm A y|
          ≤ ‖Matrix.toEuclideanLin A y‖ * ‖y‖ := by
        exact abs_real_inner_le_norm _ _
      _ = ‖Matrix.toEuclideanLin A y‖ := by rw [hy, mul_one]
      _ ≤ realMatrixOperatorNorm A := by
        simpa [hy, realMatrixOperatorNorm, realMatrixContinuousLinearMap] using
          (ContinuousLinearMap.le_opNorm (realMatrixContinuousLinearMap A) y)
  have hsym : (T : EuclideanSpace ℝ (Fin n) →ₗ[ℝ]
      EuclideanSpace ℝ (Fin n)).IsSymmetric := by
    simpa [T, realMatrixContinuousLinearMap] using
      (Matrix.isHermitian_iff_isSymmetric.mp hA)
  have hop_le : realMatrixOperatorNorm A ≤ |realMatrixQuadraticForm A x| := by
    rw [realMatrixOperatorNorm]
    change ‖T‖ ≤ _
    rw [T.norm_eq_iSup_rayleighQuotient hsym]
    refine ciSup_le fun y => ?_
    by_cases hyzero : y = 0
    · simp [hyzero]
    · let z : EuclideanSpace ℝ (Fin n) := ‖y‖⁻¹ • y
      have hynorm : ‖y‖ ≠ 0 := norm_ne_zero_iff.mpr hyzero
      have hz : ‖z‖ = 1 := by
        simp [z, norm_smul, hynorm]
      have hzmax := hmax hz
      have hscale := T.rayleigh_smul y (c := (‖y‖⁻¹ : ℝ)) (inv_ne_zero hynorm)
      rw [← hscale]
      simpa [z, T, realMatrixQuadraticForm,
        ContinuousLinearMap.rayleighQuotient,
        ContinuousLinearMap.reApplyInnerSelf_apply, hz] using hzmax
  have heq : |realMatrixQuadraticForm A x| = realMatrixOperatorNorm A :=
    le_antisymm (hupper x hx) hop_le
  exact ⟨rfl, x, hx, heq, hupper⟩

end

end NumStability
