import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem471.Contract

/-!
# Vershynin Chapter 4, singular-covariance whitening prompt
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- The general-case conclusion requested by the parenthetical singular-
covariance prompt in the proof of Theorem 4.7.1.  This is deliberately the
full probabilistic theorem: the population second moment may be singular, no
inverse or full-dimensional whitening hypothesis is exposed, and the sample
matrix is the literal empirical second moment of independent copies. -/
theorem hdp_04_singular_covariance_whitening :
    ∃ C : ℝ, 0 < C ∧
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
        (∫ ω, NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω -
            NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
              (fun j ω ↦ Z ω j)) ∂μ) ≤
          C * (K : ℝ) ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
            NumStability.realMatrixOperatorNorm
              (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
                (fun j ω ↦ Z ω j)) := by
  exact hdp_04_theorem_4_7_1

/-- The general-case covariance conclusion in exhaustive probability and
coordinate form, including singular population matrices and dimension zero.
No whitening factor or inverse is required. -/
theorem hdp_04_singular_covariance_whitening_explicit_probability :
    ∃ C : ℝ, 0 < C ∧
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
        (∫ ω, sSup {q : ℝ | ∃ x : Fin n → ℝ, (∑ j, x j ^ 2) = 1 ∧
          q = Real.sqrt (∑ a, (∑ b,
            ((m : ℝ)⁻¹ * ∑ i, X i ω a * X i ω b -
              ∫ η, Z η a * Z η b ∂μ) * x b) ^ 2)} ∂μ) ≤
          C * (K : ℝ) ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
            sSup {q : ℝ | ∃ x : Fin n → ℝ, (∑ j, x j ^ 2) = 1 ∧
              q = Real.sqrt (∑ a, (∑ b, (∫ ω, Z ω a * Z ω b ∂μ) * x b) ^ 2)} := by
  exact hdp_04_theorem_4_7_1_explicit_probability

end NumStability.HDP.Contract
