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

end NumStability.HDP.Contract
