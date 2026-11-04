import ComputationalMathematics.HDP.Matrix.IsotropicRows
import ComputationalMathematics.HDP.Matrix.SingularValueIntegrability
import ComputationalMathematics.HDP.Probability.TailExpectation
import ComputationalMathematics.Analysis.SingularValues.ExtremeValues

/-!
# Vershynin Chapter 4, Exercise 4.6.3
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.6.3: integrating Theorem 4.6.1 gives two-sided
expectation bounds for the extreme singular values.  The endpoint-order
conjunct exposes the meanings of `s_n` and `s_1`; integrability is derived from
the assumed coordinate `L²` bounds rather than added as a premise. -/
theorem hdp_04_exercise_4_6_3 :
    ∃ D : ℝ, 0 < D ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m)
        (A : Ω → Matrix (Fin m) (Fin (n + 1)) ℝ) {K : ℝ},
        1 ≤ K →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ i j, MemLp (fun ω => A ω i j) 2 μ) →
        (∀ i j, ∫ ω, A ω i j ∂μ = 0) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω => A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω => fun j => A ω i j) μ →
        (∀ ω i,
            NumStability.rectCourantFischerSingularValue
                (A ω) (Fin.last n) ≤
              NumStability.rectCourantFischerSingularValue (A ω) i ∧
            NumStability.rectCourantFischerSingularValue (A ω) i ≤
              NumStability.rectCourantFischerSingularValue
                (A ω) (0 : Fin (n + 1))) ∧
          Real.sqrt (m : ℝ) - D * K ^ 2 * Real.sqrt (n + 1 : ℝ) ≤
            (∫ ω, NumStability.rectCourantFischerSingularValue
              (A ω) (Fin.last n) ∂μ) ∧
          (∫ ω, NumStability.rectCourantFischerSingularValue
              (A ω) (Fin.last n) ∂μ) ≤
            (∫ ω, NumStability.rectCourantFischerSingularValue
              (A ω) (0 : Fin (n + 1)) ∂μ) ∧
          (∫ ω, NumStability.rectCourantFischerSingularValue
              (A ω) (0 : Fin (n + 1)) ∂μ) ≤
            Real.sqrt (m : ℝ) + D * K ^ 2 * Real.sqrt (n + 1 : ℝ) := by
  rcases NumStability.HDP.Matrix.exists_extremeSingularValue_tail_of_independent_isotropic_subGaussian_rows with ⟨C, hC, htail⟩
  let D : ℝ := 3 * C
  have hD : 0 < D := by dsimp [D]; positivity
  refine ⟨D, hD, ?_⟩
  intro Ω _ μ _ m n hm A K hK hMeas hLp hMean hIso hPsi hIndep
  have hEntryInt : ∀ ij : Fin m × Fin (n + 1),
      Integrable (fun ω => A ω ij.1 ij.2) μ := by
    intro ij
    exact (hLp ij.1 ij.2).integrable (by norm_num)
  have hMinInt : Integrable (fun ω =>
      NumStability.rectCourantFischerSingularValue
        (A ω) (Fin.last n)) μ :=
    NumStability.HDP.Matrix.integrable_rectCourantFischerSingularValue_of_entries
      A hEntryInt (Fin.last n)
  have hMaxInt : Integrable (fun ω =>
      NumStability.rectCourantFischerSingularValue
        (A ω) (0 : Fin (n + 1))) μ :=
    NumStability.HDP.Matrix.integrable_rectCourantFischerSingularValue_of_entries
      A hEntryInt (0 : Fin (n + 1))
  let smin : Ω → ℝ := fun ω =>
    NumStability.rectCourantFischerSingularValue (A ω) (Fin.last n)
  let smax : Ω → ℝ := fun ω =>
    NumStability.rectCourantFischerSingularValue (A ω) (0 : Fin (n + 1))
  let r : ℝ := Real.sqrt (m : ℝ)
  let q : ℝ := Real.sqrt (n + 1 : ℝ)
  let b : ℝ := C * K ^ 2
  have hKpos : 0 < K := lt_of_lt_of_le zero_lt_one hK
  have hb : 0 < b := by dsimp [b]; positivity
  have hq1 : 1 ≤ q := by
    dsimp [q]
    apply (Real.one_le_sqrt).2
    norm_num
  have hsqrtpi : Real.sqrt Real.pi ≤ 2 := by
    exact (Real.sqrt_le_iff).2 ⟨by norm_num, by nlinarith [Real.pi_le_four]⟩
  have hsqrtpiq : Real.sqrt Real.pi ≤ 2 * q := by nlinarith
  have htailUpper : ∀ {t : ℝ}, 0 < t →
      μ.real {ω | r + b * q + b * t < smax ω} ≤
        2 * Real.exp (-t ^ 2) := by
    intro t ht
    have hsource := htail hm A hK hMeas hLp hMean hIso hPsi hIndep ht.le
    have hsubset : {ω | r + b * q + b * t < smax ω} ⊆
        {ω |
          r - C * K ^ 2 * (q + t) > smin ω ∨
            smax ω > r + C * K ^ 2 * (q + t)} := by
      intro ω hω
      right
      dsimp [b] at hω
      nlinarith
    exact (measureReal_mono hsubset (by
      exact ne_top_of_le_ne_top
        (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
        (measure_mono (Set.subset_univ _)))).trans (by
          simpa [r, q, smin, smax] using hsource)
  have hMaxExpected :=
    NumStability.HDP.Probability.expectation_le_add_mul_sqrt_pi_of_gaussian_upper_tail
      hMaxInt hb htailUpper
  let deficit : Ω → ℝ := fun ω => r - smin ω
  have hDeficitInt : Integrable deficit μ :=
    (integrable_const r).sub hMinInt
  have htailLower : ∀ {t : ℝ}, 0 < t →
      μ.real {ω | b * q + b * t < deficit ω} ≤
        2 * Real.exp (-t ^ 2) := by
    intro t ht
    have hsource := htail hm A hK hMeas hLp hMean hIso hPsi hIndep ht.le
    have hsubset : {ω | b * q + b * t < deficit ω} ⊆
        {ω |
          r - C * K ^ 2 * (q + t) > smin ω ∨
            smax ω > r + C * K ^ 2 * (q + t)} := by
      intro ω hω
      left
      dsimp [b, deficit] at hω
      nlinarith
    exact (measureReal_mono hsubset (by
      exact ne_top_of_le_ne_top
        (show μ Set.univ ≠ (⊤ : ℝ≥0∞) by simp)
        (measure_mono (Set.subset_univ _)))).trans (by
          simpa [r, q, smin, smax] using hsource)
  have hDeficitExpected :=
    NumStability.HDP.Probability.expectation_le_add_mul_sqrt_pi_of_gaussian_upper_tail
      hDeficitInt hb htailLower
  have hMiddle : (∫ ω, smin ω ∂μ) ≤ ∫ ω, smax ω ∂μ := by
    apply integral_mono hMinInt hMaxInt
    intro ω
    exact NumStability.rectCourantFischerSingularValue_antitone
      (A ω) (Fin.zero_le (Fin.last n))
  have hUpper : (∫ ω, smax ω ∂μ) ≤ r + D * K ^ 2 * q := by
    calc
      (∫ ω, smax ω ∂μ) ≤ r + b * q + b * Real.sqrt Real.pi := hMaxExpected
      _ ≤ r + b * q + b * (2 * q) := by gcongr
      _ = r + D * K ^ 2 * q := by dsimp [b, D]; ring
  have hDeficitIntegral :
      (∫ ω, deficit ω ∂μ) = r - ∫ ω, smin ω ∂μ := by
    dsimp [deficit]
    rw [integral_sub (integrable_const r) hMinInt,
      integral_const, probReal_univ, one_smul]
  have hLower : r - D * K ^ 2 * q ≤ ∫ ω, smin ω ∂μ := by
    rw [hDeficitIntegral] at hDeficitExpected
    have hbound : b * q + b * Real.sqrt Real.pi ≤ D * K ^ 2 * q := by
      calc
        b * q + b * Real.sqrt Real.pi ≤ b * q + b * (2 * q) := by gcongr
        _ = D * K ^ 2 * q := by dsimp [b, D]; ring
    linarith
  change
    (∀ ω i,
        NumStability.rectCourantFischerSingularValue
            (A ω) (Fin.last n) ≤
          NumStability.rectCourantFischerSingularValue (A ω) i ∧
        NumStability.rectCourantFischerSingularValue (A ω) i ≤
          NumStability.rectCourantFischerSingularValue
            (A ω) (0 : Fin (n + 1))) ∧
      r - D * K ^ 2 * q ≤ (∫ ω, smin ω ∂μ) ∧
        (∫ ω, smin ω ∂μ) ≤ (∫ ω, smax ω ∂μ) ∧
        (∫ ω, smax ω ∂μ) ≤ r + D * K ^ 2 * q
  refine ⟨?_, hLower, hMiddle, hUpper⟩
  intro ω i
  exact ⟨
    NumStability.rectCourantFischerSingularValue_antitone (A ω)
      (Fin.le_last i),
    NumStability.rectCourantFischerSingularValue_antitone (A ω)
      (Fin.zero_le i)⟩

/-- Exercise 4.6.3 with the subgaussian bound stated pointwise for every
unit scalar marginal. The spectrum is the canonical column-padded spectrum;
all three ordinary expectation inequalities are retained. -/
theorem hdp_04_exercise_4_6_3_unit_marginals :
    ∃ D : ℝ, 0 < D ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m)
        (A : Ω → Matrix (Fin m) (Fin (n + 1)) ℝ) {K : ℝ},
        1 ≤ K →
        (∀ i j, Measurable (fun ω ↦ A ω i j)) →
        (∀ i j, MemLp (fun ω ↦ A ω i j) 2 μ) →
        (∀ i j, ∫ ω, A ω i j ∂μ = 0) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω ↦ A ω i j)) →
        (∀ i (z : Fin (n + 1) → ℝ), (∑ j, z j ^ 2) = 1 →
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun ω ↦ ∑ j, A ω i j * z j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω ↦ fun j ↦ A ω i j) μ →
        (∀ ω i,
            NumStability.rectCourantFischerSingularValue (A ω) (Fin.last n) ≤
              NumStability.rectCourantFischerSingularValue (A ω) i ∧
            NumStability.rectCourantFischerSingularValue (A ω) i ≤
              NumStability.rectCourantFischerSingularValue (A ω) (0 : Fin (n + 1))) ∧
          Real.sqrt (m : ℝ) - D * K ^ 2 * Real.sqrt (n + 1 : ℝ) ≤
            (∫ ω, NumStability.rectCourantFischerSingularValue (A ω) (Fin.last n) ∂μ) ∧
          (∫ ω, NumStability.rectCourantFischerSingularValue (A ω) (Fin.last n) ∂μ) ≤
            (∫ ω, NumStability.rectCourantFischerSingularValue (A ω) (0 : Fin (n + 1)) ∂μ) ∧
          (∫ ω, NumStability.rectCourantFischerSingularValue (A ω) (0 : Fin (n + 1)) ∂μ) ≤
            Real.sqrt (m : ℝ) + D * K ^ 2 * Real.sqrt (n + 1 : ℝ) := by
  obtain ⟨D, hD, hbound⟩ := hdp_04_exercise_4_6_3
  refine ⟨D, hD, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp hMean hIso hMarginal hIndep
  exact hbound hm A hK hMeas hLp hMean hIso
    (fun i ↦ NumStability.HDP.Vector.SubGaussian.psiTwoNorm_le_iff_unit_marginals.mpr
      (hMarginal i)) hIndep

/-- Exercise 4.6.3 for the actual coefficients of any pointwise SVD satisfying
all coordinate decomposition conditions. The endpoint identities transport the
existing expectation bounds and derive integrability from the entry `L²`
bounds, without a measurability assumption on the supplied SVD fields. -/
theorem hdp_04_exercise_4_6_3_explicit_svd :
    ∃ D : ℝ, 0 < D ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (_hm : 0 < m)
        (A : Ω → Matrix (Fin m) (Fin (n + 1)) ℝ) {K : ℝ},
        1 ≤ K →
        (∀ i j, Measurable (fun ω ↦ A ω i j)) →
        (∀ i j, MemLp (fun ω ↦ A ω i j) 2 μ) →
        (∀ i j, ∫ ω, A ω i j ∂μ = 0) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω ↦ A ω i j)) →
        (∀ i (z : Fin (n + 1) → ℝ), (∑ j, z j ^ 2) = 1 →
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun ω ↦ ∑ j, A ω i j * z j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω ↦ fun j ↦ A ω i j) μ →
        ∀ (r : Ω → ℕ) (s : Ω → Fin (n + 1) → ℝ)
          (u : ∀ ω, Fin (r ω) → EuclideanSpace ℝ (Fin m))
          (v : ∀ ω, Fin (r ω) → EuclideanSpace ℝ (Fin (n + 1))),
          (∀ ω, NumStability.RealMatrixSVDExplicitFields
            (A ω) (r ω) (s ω) (u ω) (v ω)) →
          (∀ ω i, s ω (Fin.last n) ≤ s ω i ∧
            s ω i ≤ s ω (0 : Fin (n + 1))) ∧
          Integrable (fun ω ↦ s ω (Fin.last n)) μ ∧
          Integrable (fun ω ↦ s ω (0 : Fin (n + 1))) μ ∧
          Real.sqrt (m : ℝ) - D * K ^ 2 * Real.sqrt (n + 1 : ℝ) ≤
            (∫ ω, s ω (Fin.last n) ∂μ) ∧
          (∫ ω, s ω (Fin.last n) ∂μ) ≤
            (∫ ω, s ω (0 : Fin (n + 1)) ∂μ) ∧
          (∫ ω, s ω (0 : Fin (n + 1)) ∂μ) ≤
            Real.sqrt (m : ℝ) + D * K ^ 2 * Real.sqrt (n + 1 : ℝ) := by
  obtain ⟨D, hD, hbound⟩ := hdp_04_exercise_4_6_3_unit_marginals
  refine ⟨D, hD, ?_⟩
  intro Ω instΩ μ instμ m n hm A K hK hMeas hLp hMean hIso hMarginal hIndep
    r s u v hFields
  have hSVD : ∀ ω, NumStability.IsRealMatrixSVD
      (A ω) (r ω) (s ω) (u ω) (v ω) :=
    fun ω ↦ NumStability.isRealMatrixSVD_iff_explicit_fields.mpr (hFields ω)
  have hMin : (fun ω ↦ s ω (Fin.last n)) =
      (fun ω ↦ NumStability.rectCourantFischerSingularValue
        (A ω) (Fin.last n)) := by
    funext ω
    exact (hSVD ω).extremeSingularValues_eq_rectCourantFischer.1
  have hMax : (fun ω ↦ s ω (0 : Fin (n + 1))) =
      (fun ω ↦ NumStability.rectCourantFischerSingularValue
        (A ω) (0 : Fin (n + 1))) := by
    funext ω
    exact (hSVD ω).extremeSingularValues_eq_rectCourantFischer.2
  have hEntryInt : ∀ ij : Fin m × Fin (n + 1),
      Integrable (fun ω ↦ A ω ij.1 ij.2) μ :=
    fun ij ↦ (hLp ij.1 ij.2).integrable (by norm_num)
  have hMinInt : Integrable (fun ω ↦ s ω (Fin.last n)) μ := by
    rw [hMin]
    exact NumStability.HDP.Matrix.integrable_rectCourantFischerSingularValue_of_entries
      A hEntryInt (Fin.last n)
  have hMaxInt : Integrable (fun ω ↦ s ω (0 : Fin (n + 1))) μ := by
    rw [hMax]
    exact NumStability.HDP.Matrix.integrable_rectCourantFischerSingularValue_of_entries
      A hEntryInt (0 : Fin (n + 1))
  obtain ⟨_, hLower, hMiddle, hUpper⟩ :=
    hbound hm A hK hMeas hLp hMean hIso hMarginal hIndep
  refine ⟨?_, hMinInt, hMaxInt, ?_⟩
  · intro ω i
    exact ⟨(hSVD ω).singularValues_antitone (Fin.le_last i),
      (hSVD ω).singularValues_antitone (Fin.zero_le i)⟩
  · simpa only [hMin, hMax] using And.intro hLower (And.intro hMiddle hUpper)

end NumStability.HDP.Contract
