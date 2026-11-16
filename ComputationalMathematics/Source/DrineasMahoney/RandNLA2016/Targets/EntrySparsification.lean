import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation02.SpectralApproximation.TruncatedSampling

/-!
# Corrected, thresholded entry-sparsification contract

This is the square theorem supported by Drineas--Zouzias (survey reference18),
with its explicit zero branch and upward-compatible integer sample condition.
It is a correction to applying survey Equation(2) to the unchanged raw sampler.
The strict-threshold convention is the printed algorithm-box convention.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Corrected reference18 guarantee, including all matrices and at most `s`
nonzero entries. The sample condition is multiplied by the positive `eps²`. -/
def correctedTruncatedEntryGuarantee : Prop :=
  ∀ (n s : ℕ) (A : Fin n → Fin n → ℝ) (eps δ : ℝ),
    0 < n → 0 < s → 0 < eps → 0 < δ → δ < 1 →
    14 * (n : ℝ) * frobNormSqRect A * Real.log ((2 * (n : ℝ)) / δ) ≤
      (s : ℝ) * eps ^ 2 →
    1 - δ ≤
      (truncatedElementwiseProbability (s := s) (eps / (2 * (n : ℝ))) A).eventProb
        {outcome |
          rectOpNorm2Le (fun i j => A i j -
            truncatedElementwiseSketch (eps / (2 * (n : ℝ))) A outcome i j) eps ∧
          (Finset.univ.filter (fun ij : Fin n × Fin n =>
            truncatedElementwiseSketch (eps / (2 * (n : ℝ))) A outcome ij.1 ij.2 ≠ 0)).card ≤ s}

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
