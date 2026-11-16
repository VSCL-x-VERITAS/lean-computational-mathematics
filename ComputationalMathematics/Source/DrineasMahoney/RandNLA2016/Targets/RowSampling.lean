import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.Core
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.Gram
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.TraceProbability

/-!
# Source contracts for norm-squared and leverage sampling

Proof-free statements for equations (4)--(6) of Drineas--Mahoney (2016).
The positive denominator in equation (4) excludes the undefined norm-squared
distribution of the zero matrix. Equation (6) uses a positive-dimensional
orthonormal basis and the paper's normalized leverage probabilities.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

open scoped BigOperators

/-- Equation (4): norm-squared row probabilities form the stated distribution. -/
def rowNormDistribution : Prop :=
  ∀ (m n : ℕ) (A : Fin m → Fin n → ℝ),
    0 < rowSqNormProbDen A →
      (∀ i, 0 ≤ rowSqNormProb A i) ∧
      (∑ i : Fin m, rowSqNormProb A i) = 1 ∧
      ∀ i, rowSqNormProb A i =
        (∑ j : Fin n, A i j ^ 2) /
          (∑ r : Fin m, ∑ j : Fin n, A r j ^ 2)

/-- Equation (6): normalized leverage probabilities are squared row norms
divided by the dimension, equivalently the diagonal of `UUᵀ` divided by it. -/
def leverageDistribution : Prop :=
  ∀ (m n : ℕ) (U : Fin m → Fin n → ℝ),
    0 < n → HasOrthonormalColumns U →
      (∀ i, 0 ≤ leverageScoreProb U i) ∧
      (∑ i : Fin m, leverageScoreProb U i) = 1 ∧
      (∀ i, leverageScoreProb U i = (∑ j : Fin n, U i j ^ 2) / (n : ℝ)) ∧
      ∀ i, leverageScoreProb U i = (∑ j : Fin n, U i j * U i j) / (n : ℝ)

/-- Equation (5) is an expectation bound, as specified by its following prose.
The norm on the Gram difference is Frobenius and sampling is with replacement. -/
def expectedGramError : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ)
    (hA : 0 < rowSqNormProbDen A),
    0 < s →
      (rowSqNormTraceProbability (steps := s) A hA).expectationReal
        (fun samples =>
          frobNorm (fun j k => rowSampleGram s A samples j k - rowGram A j k)) ≤
        rowSqNormProbDen A / Real.sqrt (s : ℝ)

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
