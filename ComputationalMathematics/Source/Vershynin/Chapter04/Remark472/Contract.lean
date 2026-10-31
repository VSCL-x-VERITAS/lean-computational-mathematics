import ComputationalMathematics.HDP.Vector.SampleComplexity
import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem471.Contract

/-!
# Vershynin Chapter 4, Remark 4.7.2
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- The sufficient aspect-ratio form of Vershynin, Remark 4.7.2.  The
constant depending on `K` is made explicit. -/
theorem hdp_04_remark_4_7_2_of_aspectRatio_le :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (Z : Ω → Fin n → ℝ) (X : Fin m → Ω → Fin n → ℝ)
          (K : ℝ≥0),
        1 ≤ K →
        (∀ j, Measurable (fun ω ↦ Z ω j)) →
        (∀ j, MemLp (fun ω ↦ Z ω j) 2 μ) →
        (∀ i j, Measurable (fun ω ↦ X i ω j)) →
        (∀ i, IdentDistrib (X i) Z μ μ) →
        iIndepFun X μ →
        NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
          (fun j ω ↦ Z ω j) K →
        ∀ {ε : ℝ}, 0 < ε → ε < 1 →
        (n : ℝ) / (m : ℝ) ≤
          (ε / (2 * (C * (K : ℝ) ^ 2))) ^ 2 →
        (∫ ω, NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω -
            NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
              (fun j ω ↦ Z ω j)) ∂μ) ≤
          ε * NumStability.realMatrixOperatorNorm
            (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
              (fun j ω ↦ Z ω j)) := by
  rcases hdp_04_theorem_4_7_1 with ⟨D, hD, hbound⟩
  let C : ℝ := max 1 D
  have hC : 1 ≤ C := le_max_left _ _
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ m n hm hn Z X K hK hZMeas hZLp hXMeas hIdent hIndep hRel
    ε hε0 hε1 hsize
  let Sigma : Matrix (Fin n) (Fin n) ℝ :=
    NumStability.HDP.Vector.Covariance.secondMomentMatrix μ (fun j ω ↦ Z ω j)
  let error : ℝ := ∫ ω, NumStability.realMatrixOperatorNorm
    (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω - Sigma) ∂μ
  have hsource := hbound hm hn Z X K hK hZMeas hZLp hXMeas hIdent hIndep hRel
  have hmReal : 0 < (m : ℝ) := by exact_mod_cast hm
  have hratio0 : 0 ≤ (n : ℝ) / (m : ℝ) :=
    div_nonneg (Nat.cast_nonneg n) hmReal.le
  have hfactor0 : 0 ≤
      (K : ℝ) ^ 2 *
        (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
        NumStability.realMatrixOperatorNorm Sigma :=
    mul_nonneg
      (mul_nonneg (sq_nonneg (K : ℝ)) (add_nonneg (Real.sqrt_nonneg _) hratio0))
      (norm_nonneg _)
  have hDC : D ≤ C := le_max_right _ _
  have hCbound : error ≤
      (C * (K : ℝ) ^ 2) *
        (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
        NumStability.realMatrixOperatorNorm Sigma := by
    calc
      error ≤ D * (K : ℝ) ^ 2 *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
          NumStability.realMatrixOperatorNorm Sigma := by simpa [error, Sigma] using hsource
      _ = D * ((K : ℝ) ^ 2 *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
          NumStability.realMatrixOperatorNorm Sigma) := by ring
      _ ≤ C * ((K : ℝ) ^ 2 *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
          NumStability.realMatrixOperatorNorm Sigma) :=
        mul_le_mul_of_nonneg_right hDC hfactor0
      _ = (C * (K : ℝ) ^ 2) *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
          NumStability.realMatrixOperatorNorm Sigma := by ring
  have hKreal : 1 ≤ (K : ℝ) := by exact_mod_cast hK
  have ha : 1 ≤ C * (K : ℝ) ^ 2 := by
    nlinarith [sq_nonneg ((K : ℝ) - 1)]
  have hresult := NumStability.HDP.Vector.Covariance.relativeError_le_of_aspectRatio_le
    (n := (n : ℝ)) (m := (m : ℝ))
    (a := C * (K : ℝ) ^ 2) (error := error)
    (sigmaNorm := NumStability.realMatrixOperatorNorm Sigma)
    (Nat.cast_nonneg n) hmReal hε0 hε1 ha
    (norm_nonneg _) hCbound hsize
  simpa [error, Sigma] using hresult

/-- Vershynin, Remark 4.7.2: for fixed subgaussian parameter `K`, an
integer sample size comparable to `ε⁻² n` gives the asserted expected
relative operator-norm error.  The comparison constant is explicit in
`K`, as required by Theorem 4.7.1.  The chosen count works for every
independent sample from the stated distribution. -/
theorem hdp_04_remark_4_7_2 :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {n : ℕ},
        0 < n →
        ∀ (Z : Ω → Fin n → ℝ) (K : ℝ≥0),
        1 ≤ K →
        (∀ j, Measurable (fun ω ↦ Z ω j)) →
        (∀ j, MemLp (fun ω ↦ Z ω j) 2 μ) →
        NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
          (fun j ω ↦ Z ω j) K →
        ∀ {ε : ℝ}, 0 < ε → ε < 1 →
        ∃ m : ℕ, 0 < m ∧
          (2 * (C * (K : ℝ) ^ 2) / ε) ^ 2 * (n : ℝ) ≤ (m : ℝ) ∧
          (m : ℝ) ≤ 2 * ((2 * (C * (K : ℝ) ^ 2) / ε) ^ 2 * (n : ℝ)) ∧
          ∀ (X : Fin m → Ω → Fin n → ℝ),
          (∀ i j, Measurable (fun ω ↦ X i ω j)) →
          (∀ i, IdentDistrib (X i) Z μ μ) →
          iIndepFun X μ →
          (∫ ω, NumStability.realMatrixOperatorNorm
            (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω -
              NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
                (fun j ω ↦ Z ω j)) ∂μ) ≤
            ε * NumStability.realMatrixOperatorNorm
              (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
                (fun j ω ↦ Z ω j)) := by
  rcases hdp_04_remark_4_7_2_of_aspectRatio_le with ⟨C, hC, hbound⟩
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ n hn Z K hK hZMeas hZLp hRel ε hε0 hε1
  have hnReal : 1 ≤ (n : ℝ) := by exact_mod_cast hn
  have hKreal : 1 ≤ (K : ℝ) := by exact_mod_cast hK
  have ha : 1 ≤ C * (K : ℝ) ^ 2 := by
    nlinarith [sq_nonneg ((K : ℝ) - 1)]
  obtain ⟨m, hm, hlow, hhigh, hratio⟩ :=
    NumStability.HDP.Vector.Covariance.exists_nat_sample_size_of_aspectRatio
      hnReal hε0 hε1 ha
  refine ⟨m, hm, hlow, hhigh, ?_⟩
  intro X hXMeas hIdent hIndep
  exact hbound hm hn Z X K hK hZMeas hZLp hXMeas hIdent hIndep hRel
    hε0 hε1 hratio

/-- The sufficient aspect-ratio accuracy estimate in explicit probability
and coordinate form. The genuine zero-error case includes dimension zero. -/
theorem hdp_04_remark_4_7_2_of_aspectRatio_le_explicit_probability :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {m n : ℕ},
        μ Set.univ = 1 → 0 < m →
        ∀ (Z : Ω → Fin n → ℝ) (X : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0),
        1 ≤ K →
        (∀ j, Measurable (fun ω ↦ Z ω j)) →
        (∀ j, Integrable (fun ω ↦ Z ω j ^ 2) μ) →
        (∀ i j, Measurable (fun ω ↦ X i ω j)) →
        (∀ i, AEMeasurable (X i) μ ∧ AEMeasurable Z μ ∧
          Measure.map (X i) μ = Measure.map Z μ) →
        (∀ (S : Finset (Fin m)) (B : Fin m → Set (Fin n → ℝ)),
          (∀ i, i ∈ S → MeasurableSet (B i)) →
          μ (⋂ i ∈ S, (X i) ⁻¹' B i) = ∏ i ∈ S, μ ((X i) ⁻¹' B i)) →
        (∀ x : Fin n → ℝ,
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun ω ↦ ∑ j, Z ω j * x j) ≤
              (K : ℝ≥0∞) * ENNReal.ofReal
                (Real.sqrt (∫ ω, (∑ j, Z ω j * x j) ^ 2 ∂μ))) →
        ∀ {ε : ℝ}, 0 < ε → ε < 1 →
        (n : ℝ) / (m : ℝ) ≤ (ε / (2 * (C * (K : ℝ) ^ 2))) ^ 2 →
        (∫ ω, sSup {q : ℝ | ∃ x : Fin n → ℝ, (∑ j, x j ^ 2) = 1 ∧
          q = Real.sqrt (∑ a, (∑ b,
            ((m : ℝ)⁻¹ * ∑ i, X i ω a * X i ω b -
              ∫ η, Z η a * Z η b ∂μ) * x b) ^ 2)} ∂μ) ≤
          ε * sSup {q : ℝ | ∃ x : Fin n → ℝ, (∑ j, x j ^ 2) = 1 ∧
            q = Real.sqrt (∑ a, (∑ b, (∫ ω, Z ω a * Z ω b ∂μ) * x b) ^ 2)} := by
  obtain ⟨D, hD, hbound⟩ := hdp_04_theorem_4_7_1_explicit_probability
  let C : ℝ := max 1 D
  have hC : 1 ≤ C := le_max_left _ _
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ m n hμ hm Z X K hK hZMeas hZSq hXMeas hLaw hEvents hMarginal
    ε hε0 hε1 hsize
  let Sigma : Matrix (Fin n) (Fin n) ℝ :=
    NumStability.HDP.Vector.Covariance.secondMomentMatrix μ (fun j ω ↦ Z ω j)
  let error : ℝ := ∫ ω, NumStability.realMatrixOperatorNorm
    (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω - Sigma) ∂μ
  have hsource : error ≤ D * (K : ℝ) ^ 2 *
      (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
      NumStability.realMatrixOperatorNorm Sigma := by
    simpa only [error, Sigma, NumStability.realMatrixOperatorNorm_eq_coordinate_sSup,
      NumStability.HDP.Vector.Covariance.randomSampleCovariance,
      NumStability.HDP.Vector.Covariance.sampleCovariance,
      NumStability.HDP.Vector.Covariance.secondMomentMatrix, Matrix.sub_apply] using
        hbound hμ hm Z X K hK hZMeas hZSq hXMeas hLaw hEvents hMarginal
  have hmReal : 0 < (m : ℝ) := by exact_mod_cast hm
  have hratio0 : 0 ≤ (n : ℝ) / (m : ℝ) :=
    div_nonneg (Nat.cast_nonneg n) hmReal.le
  have hfactor0 : 0 ≤ (K : ℝ) ^ 2 *
      (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
      NumStability.realMatrixOperatorNorm Sigma := by
    exact mul_nonneg
      (mul_nonneg (sq_nonneg _) (add_nonneg (Real.sqrt_nonneg _) hratio0))
      (norm_nonneg _)
  have hCbound : error ≤ (C * (K : ℝ) ^ 2) *
      (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
      NumStability.realMatrixOperatorNorm Sigma := by
    calc
      error ≤ D * (K : ℝ) ^ 2 *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
          NumStability.realMatrixOperatorNorm Sigma := hsource
      _ = D * ((K : ℝ) ^ 2 *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
          NumStability.realMatrixOperatorNorm Sigma) := by ring
      _ ≤ C * ((K : ℝ) ^ 2 *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
          NumStability.realMatrixOperatorNorm Sigma) :=
        mul_le_mul_of_nonneg_right (le_max_right _ _) hfactor0
      _ = (C * (K : ℝ) ^ 2) *
          (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
          NumStability.realMatrixOperatorNorm Sigma := by ring
  have hKreal : 1 ≤ (K : ℝ) := by exact_mod_cast hK
  have ha : 1 ≤ C * (K : ℝ) ^ 2 := by nlinarith [sq_nonneg ((K : ℝ) - 1)]
  have hresult := NumStability.HDP.Vector.Covariance.relativeError_le_of_aspectRatio_le
    (n := (n : ℝ)) (m := (m : ℝ)) (a := C * (K : ℝ) ^ 2) (error := error)
    (sigmaNorm := NumStability.realMatrixOperatorNorm Sigma)
    (Nat.cast_nonneg n) hmReal hε0 hε1 ha (norm_nonneg _) hCbound hsize
  simpa only [error, Sigma, NumStability.realMatrixOperatorNorm_eq_coordinate_sSup,
    NumStability.HDP.Vector.Covariance.randomSampleCovariance,
    NumStability.HDP.Vector.Covariance.sampleCovariance,
    NumStability.HDP.Vector.Covariance.secondMomentMatrix, Matrix.sub_apply] using hresult

/-- For positive dimension, the sufficient integer sample count is chosen
before every subsequently supplied iid sample. Its comparison constants are
`4` and `8`, with explicit dependence on the inherited parameter `K`. -/
theorem hdp_04_remark_4_7_2_explicit_probability :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n : ℕ},
        μ Set.univ = 1 → 0 < n →
        ∀ (Z : Ω → Fin n → ℝ) (K : ℝ≥0),
        1 ≤ K →
        (∀ j, Measurable (fun ω ↦ Z ω j)) →
        (∀ j, Integrable (fun ω ↦ Z ω j ^ 2) μ) →
        (∀ x : Fin n → ℝ,
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun ω ↦ ∑ j, Z ω j * x j) ≤
              (K : ℝ≥0∞) * ENNReal.ofReal
                (Real.sqrt (∫ ω, (∑ j, Z ω j * x j) ^ 2 ∂μ))) →
        ∀ {ε : ℝ}, 0 < ε → ε < 1 →
        ∃ m : ℕ, 0 < m ∧
          4 * C ^ 2 * (K : ℝ) ^ 4 * ε⁻¹ ^ 2 * (n : ℝ) ≤ (m : ℝ) ∧
          (m : ℝ) ≤ 8 * C ^ 2 * (K : ℝ) ^ 4 * ε⁻¹ ^ 2 * (n : ℝ) ∧
          ∀ (X : Fin m → Ω → Fin n → ℝ),
          (∀ i j, Measurable (fun ω ↦ X i ω j)) →
          (∀ i, AEMeasurable (X i) μ ∧ AEMeasurable Z μ ∧
            Measure.map (X i) μ = Measure.map Z μ) →
          (∀ (S : Finset (Fin m)) (B : Fin m → Set (Fin n → ℝ)),
            (∀ i, i ∈ S → MeasurableSet (B i)) →
            μ (⋂ i ∈ S, (X i) ⁻¹' B i) = ∏ i ∈ S, μ ((X i) ⁻¹' B i)) →
          (∫ ω, sSup {q : ℝ | ∃ x : Fin n → ℝ, (∑ j, x j ^ 2) = 1 ∧
            q = Real.sqrt (∑ a, (∑ b,
              ((m : ℝ)⁻¹ * ∑ i, X i ω a * X i ω b -
                ∫ η, Z η a * Z η b ∂μ) * x b) ^ 2)} ∂μ) ≤
            ε * sSup {q : ℝ | ∃ x : Fin n → ℝ, (∑ j, x j ^ 2) = 1 ∧
              q = Real.sqrt (∑ a, (∑ b, (∫ ω, Z ω a * Z ω b ∂μ) * x b) ^ 2)} := by
  obtain ⟨C, hC, hbound⟩ := hdp_04_remark_4_7_2_of_aspectRatio_le_explicit_probability
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ n hμ hn Z K hK hZMeas hZSq hMarginal ε hε0 hε1
  have hnReal : 1 ≤ (n : ℝ) := by exact_mod_cast hn
  have hKreal : 1 ≤ (K : ℝ) := by exact_mod_cast hK
  have ha : 1 ≤ C * (K : ℝ) ^ 2 := by nlinarith [sq_nonneg ((K : ℝ) - 1)]
  obtain ⟨m, hm, hlow, hhigh, hratio⟩ :=
    NumStability.HDP.Vector.Covariance.exists_nat_sample_size_of_aspectRatio hnReal hε0 hε1 ha
  have hcomparison : (2 * (C * (K : ℝ) ^ 2) / ε) ^ 2 * (n : ℝ) =
      4 * C ^ 2 * (K : ℝ) ^ 4 * ε⁻¹ ^ 2 * (n : ℝ) := by
    rw [div_eq_mul_inv]
    ring
  refine ⟨m, hm, hcomparison ▸ hlow, ?_, ?_⟩
  · rw [hcomparison] at hhigh
    nlinarith only [hhigh]
  · intro X hXMeas hLaw hEvents
    exact hbound hμ hm Z X K hK hZMeas hZSq hXMeas hLaw hEvents hMarginal
      hε0 hε1 hratio

end NumStability.HDP.Contract
