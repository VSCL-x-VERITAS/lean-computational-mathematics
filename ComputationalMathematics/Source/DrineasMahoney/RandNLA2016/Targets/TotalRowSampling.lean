import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.TotalTraceProbability

/-!
# Total norm-squared row-sampling extension contracts

The printed Eq4 distribution has no zero-input normalization rule. These
contracts explicitly extend it by a deterministic `none` outcome with zero
sketch and Gram output. On nonzero inputs they agree with the literal original
iid sampler, and Eq5's expected error formula then extends to every finite
matrix. This is an explicit mathematical convention, not a claim that the
source printed a zero-input branch. Existing nonzero source contracts remain
unchanged.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Exact agreement with the existing independent row law on positive-weight
inputs. The extra `none` outcome has zero probability in this branch. -/
def totalRowSamplingAgrees : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ) (hA : 0 < rowSqNormProbDen A),
    totalRowSqNormTraceProbability (s := s) A =
      FiniteProbability.onSome (rowSqNormTraceProbability (steps := s) A hA)

/-- Chosen zero-input rule: return `none` with explicit zero sketch and Gram. -/
def totalRowSamplingZeroOutput : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ), rowSqNormProbDen A = 0 →
    (totalRowSqNormTraceProbability (s := s) A).eventProb
      {outcome | outcome = none ∧
        totalRowSampleSketch A outcome = (fun _ _ => 0) ∧
        totalRowSampleGram A outcome = (fun _ _ => 0)} = 1

/-- Eq5's error formula for the explicit total sampler, for every finite input.
The norm is Frobenius, the quantity is an expectation, and the sample count is
positive. Empty row/column dimensions and the zero matrix are included. -/
def totalExpectedGramError : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ), 0 < s →
    (totalRowSqNormTraceProbability (s := s) A).expectationReal
      (fun outcome =>
        frobNorm (fun j k => totalRowSampleGram A outcome j k - rowGram A j k)) ≤
      rowSqNormProbDen A / Real.sqrt (s : ℝ)

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
