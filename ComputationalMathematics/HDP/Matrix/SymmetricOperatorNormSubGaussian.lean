import ComputationalMathematics.HDP.Matrix.OperatorNormSubGaussian
import ComputationalMathematics.HDP.Matrix.OperatorNormLowerExpectation
import ComputationalMathematics.HDP.Probability.IndependentMask

/-!
# Operator norm of symmetric matrices with sub-Gaussian entries

A symmetric matrix is split into an upper-triangular mask and the transpose
of a strict-upper-triangular mask.  The rectangular operator-norm tail applies
to both masks, and a union bound plus the operator-norm triangle inequality
gives the symmetric tail.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators RealInnerProductSpace

namespace NumStability.HDP.Matrix

/-- A symmetric random matrix whose entries on and above the diagonal form an
independent centered sub-Gaussian family has the standard square-matrix
operator-norm upper tail. -/
theorem exists_symmetric_operatorNorm_tail_of_independent_centered_subGaussian_entries :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {n : ℕ} (hn : 0 < n),
        letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
        ∀ (A : Ω → Matrix (Fin n) (Fin n) ℝ),
        (∀ ω i j, A ω i j = A ω j i) →
        (∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (fun ω => A ω ij.1.1 ij.1.2)) →
        (∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
          Integrable (fun ω => A ω ij.1.1 ij.1.2) μ ∧
            (∫ ω, A ω ij.1.1 ij.1.2 ∂μ) = 0) →
        iIndepFun
          (fun ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2} =>
            fun ω => A ω ij.1.1 ij.1.2) μ →
        ∀ {t : ℝ}, 0 < t →
          μ.real {ω |
            C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
                (fun ij : Fin n × Fin n => fun ω => A ω ij.1 ij.2) *
                (Real.sqrt n + t) <
              NumStability.realMatrixOperatorNorm (A ω)} ≤
            4 * Real.exp (-t ^ 2) := by
  rcases exists_operatorNorm_tail_of_independent_centered_subGaussian_entries with
    ⟨C, hC, hTail⟩
  refine ⟨4 * C, by positivity, ?_⟩
  intro Ω instΩ μ instμ n hn
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  intro A hSym hSub hCenter hIndep t ht
  let X : Fin n × Fin n → Ω → ℝ := fun ij ω => A ω ij.1 ij.2
  let U : Ω → Matrix (Fin n) (Fin n) ℝ :=
    fun ω i j => if i ≤ j then A ω i j else 0
  let V : Ω → Matrix (Fin n) (Fin n) ℝ :=
    fun ω i j => if i < j then A ω i j else 0
  let K : ℝ :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
  let KU : ℝ :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
      (fun ij : Fin n × Fin n => fun ω => U ω ij.1 ij.2)
  let KV : ℝ :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
      (fun ij : Fin n × Fin n => fun ω => V ω ij.1 ij.2)
  have hZeroSub :
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
        (fun _ : Ω => (0 : ℝ)) := by
    apply (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite).2
    simp [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
      NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_zero]
  have hUSub : ∀ ij : Fin n × Fin n,
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
        (fun ω => U ω ij.1 ij.2) := by
    intro ij
    by_cases hij : ij.1 ≤ ij.2
    · simpa [U, hij] using hSub ⟨ij, hij⟩
    · simpa [U, hij] using hZeroSub
  have hVSub : ∀ ij : Fin n × Fin n,
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
        (fun ω => V ω ij.1 ij.2) := by
    intro ij
    by_cases hij : ij.1 < ij.2
    · simpa [V, hij] using hSub ⟨ij, hij.le⟩
    · simpa [V, hij] using hZeroSub
  have hUCenter : ∀ ij : Fin n × Fin n,
      Integrable (fun ω => U ω ij.1 ij.2) μ ∧
        (∫ ω, U ω ij.1 ij.2 ∂μ) = 0 := by
    intro ij
    by_cases hij : ij.1 ≤ ij.2
    · simpa [U, hij] using hCenter ⟨ij, hij⟩
    · simp [U, hij]
  have hVCenter : ∀ ij : Fin n × Fin n,
      Integrable (fun ω => V ω ij.1 ij.2) μ ∧
        (∫ ω, V ω ij.1 ij.2 ∂μ) = 0 := by
    intro ij
    by_cases hij : ij.1 < ij.2
    · simpa [V, hij] using hCenter ⟨ij, hij.le⟩
    · simp [V, hij]
  have hUIndep : iIndepFun
      (fun ij : Fin n × Fin n => fun ω => U ω ij.1 ij.2) μ := by
    simpa [U] using
      (NumStability.HDP.Probability.iIndepFun_subtype_zeroExtend
        (fun ij : Fin n × Fin n => ij.1 ≤ ij.2)
        (fun ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2} =>
          fun ω => A ω ij.1.1 ij.1.2) hIndep)
  have hStrictIndep : iIndepFun
      (fun ij : {ij : Fin n × Fin n // ij.1 < ij.2} =>
        fun ω => A ω ij.1.1 ij.1.2) μ := by
    exact hIndep.precomp
      (g := fun ij : {ij : Fin n × Fin n // ij.1 < ij.2} =>
        (⟨ij.1, ij.2.le⟩ : {ij : Fin n × Fin n // ij.1 ≤ ij.2}))
      (by
        intro a b hab
        apply Subtype.ext
        exact congrArg
          (fun z : {ij : Fin n × Fin n // ij.1 ≤ ij.2} => z.1) hab)
  have hVIndep : iIndepFun
      (fun ij : Fin n × Fin n => fun ω => V ω ij.1 ij.2) μ := by
    simpa [V] using
      (NumStability.HDP.Probability.iIndepFun_subtype_zeroExtend
        (fun ij : Fin n × Fin n => ij.1 < ij.2)
        (fun ij : {ij : Fin n × Fin n // ij.1 < ij.2} =>
          fun ω => A ω ij.1.1 ij.1.2) hStrictIndep)
  have hKU : KU ≤ K := by
    change NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
        (fun ij : Fin n × Fin n => fun ω => U ω ij.1 ij.2) ≤ K
    unfold NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
    apply Finset.sup'_le Finset.univ_nonempty
    intro ij _hij
    by_cases hij : ij.1 ≤ ij.2
    · simpa [U, X, hij] using
        (NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_toReal_le_max
          (μ := μ) (X := X) ij)
    · simpa [U, hij, K, NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
        NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_zero] using
        (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
          (μ := μ) (X := X))
  have hKV : KV ≤ K := by
    change NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
        (fun ij : Fin n × Fin n => fun ω => V ω ij.1 ij.2) ≤ K
    unfold NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
    apply Finset.sup'_le Finset.univ_nonempty
    intro ij _hij
    by_cases hij : ij.1 < ij.2
    · simpa [V, X, hij] using
        (NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_toReal_le_max
          (μ := μ) (X := X) ij)
    · simpa [V, hij, K, NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
        NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_zero] using
        (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
          (μ := μ) (X := X))
  have hUTail := hTail hn hn U hUSub hUCenter hUIndep ht
  have hVTail := hTail hn hn V hVSub hVCenter hVIndep ht
  have hK0 : 0 ≤ K :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
  have hKU0 : 0 ≤ KU :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
  have hKV0 : 0 ≤ KV :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
  have hsqrt0 : 0 ≤ Real.sqrt (n : ℝ) := Real.sqrt_nonneg _
  have hUThreshold :
      C * KU * (Real.sqrt n + Real.sqrt n + t) ≤
        2 * C * K * (Real.sqrt n + t) := by
    have hCKU : C * KU ≤ C * K :=
      mul_le_mul_of_nonneg_left hKU hC.le
    have hsum0 : 0 ≤ Real.sqrt (n : ℝ) + Real.sqrt n + t := by positivity
    calc
      C * KU * (Real.sqrt n + Real.sqrt n + t) ≤
          C * K * (Real.sqrt n + Real.sqrt n + t) :=
        mul_le_mul_of_nonneg_right hCKU hsum0
      _ ≤ 2 * C * K * (Real.sqrt n + t) := by
        nlinarith [mul_nonneg hC.le hK0]
  have hVThreshold :
      C * KV * (Real.sqrt n + Real.sqrt n + t) ≤
        2 * C * K * (Real.sqrt n + t) := by
    have hCKV : C * KV ≤ C * K :=
      mul_le_mul_of_nonneg_left hKV hC.le
    have hsum0 : 0 ≤ Real.sqrt (n : ℝ) + Real.sqrt n + t := by positivity
    calc
      C * KV * (Real.sqrt n + Real.sqrt n + t) ≤
          C * K * (Real.sqrt n + Real.sqrt n + t) :=
        mul_le_mul_of_nonneg_right hCKV hsum0
      _ ≤ 2 * C * K * (Real.sqrt n + t) := by
        nlinarith [mul_nonneg hC.le hK0]
  have hDecomp : ∀ ω, A ω = U ω + (V ω).transpose := by
    intro ω
    ext i j
    by_cases hij : i ≤ j
    · have hnot : ¬j < i := not_lt_of_ge hij
      simp [U, V, hij, hnot]
    · have hji : j < i := lt_of_not_ge hij
      simp [U, V, hij, hji, hSym ω i j]
  have hTriangle : ∀ ω,
      NumStability.realMatrixOperatorNorm (A ω) ≤
        NumStability.realMatrixOperatorNorm (U ω) +
          NumStability.realMatrixOperatorNorm (V ω) := by
    intro ω
    rw [hDecomp ω]
    calc
      NumStability.realMatrixOperatorNorm (U ω + (V ω).transpose) ≤
          NumStability.realMatrixOperatorNorm (U ω) +
            NumStability.realMatrixOperatorNorm ((V ω).transpose) := by
        unfold NumStability.realMatrixOperatorNorm
        simpa [NumStability.realMatrixContinuousLinearMap] using
          norm_add_le
            (NumStability.realMatrixContinuousLinearMap (U ω))
            (NumStability.realMatrixContinuousLinearMap ((V ω).transpose))
      _ = NumStability.realMatrixOperatorNorm (U ω) +
          NumStability.realMatrixOperatorNorm (V ω) := by
        rw [realMatrixOperatorNorm_transpose]
  let EU : Set Ω := {ω |
    C * KU * (Real.sqrt n + Real.sqrt n + t) <
      NumStability.realMatrixOperatorNorm (U ω)}
  let EV : Set Ω := {ω |
    C * KV * (Real.sqrt n + Real.sqrt n + t) <
      NumStability.realMatrixOperatorNorm (V ω)}
  have hEvent : {ω |
      (4 * C) * K * (Real.sqrt n + t) <
        NumStability.realMatrixOperatorNorm (A ω)} ⊆ EU ∪ EV := by
    intro ω hω
    by_contra hnot
    rw [Set.mem_union, not_or] at hnot
    have hUle : NumStability.realMatrixOperatorNorm (U ω) ≤
        C * KU * (Real.sqrt n + Real.sqrt n + t) := by
      exact le_of_not_gt hnot.1
    have hVle : NumStability.realMatrixOperatorNorm (V ω) ≤
        C * KV * (Real.sqrt n + Real.sqrt n + t) := by
      exact le_of_not_gt hnot.2
    have hsum : NumStability.realMatrixOperatorNorm (U ω) +
        NumStability.realMatrixOperatorNorm (V ω) ≤
          4 * C * K * (Real.sqrt n + t) := by
      calc
        NumStability.realMatrixOperatorNorm (U ω) +
            NumStability.realMatrixOperatorNorm (V ω) ≤
            C * KU * (Real.sqrt n + Real.sqrt n + t) +
              C * KV * (Real.sqrt n + Real.sqrt n + t) :=
          add_le_add hUle hVle
        _ ≤ 2 * C * K * (Real.sqrt n + t) +
            2 * C * K * (Real.sqrt n + t) :=
          add_le_add hUThreshold hVThreshold
        _ = 4 * C * K * (Real.sqrt n + t) := by ring
    exact (not_lt_of_ge ((hTriangle ω).trans hsum)) (by simpa [mul_assoc] using hω)
  calc
    μ.real {ω |
        (4 * C) * K * (Real.sqrt n + t) <
          NumStability.realMatrixOperatorNorm (A ω)} ≤
        μ.real (EU ∪ EV) := measureReal_mono hEvent (by finiteness)
    _ ≤ μ.real EU + μ.real EV := measureReal_union_le _ _
    _ ≤ 2 * Real.exp (-t ^ 2) + 2 * Real.exp (-t ^ 2) := by
      exact add_le_add (by simpa [EU, KU] using hUTail)
        (by simpa [EV, KV] using hVTail)
    _ = 4 * Real.exp (-t ^ 2) := by ring

end NumStability.HDP.Matrix
