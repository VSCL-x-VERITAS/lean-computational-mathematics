import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation02.SpectralApproximation.TruncatedSampling

/-!
# Corrected entry sparsification on bounded accuracy

This source-local contract selects strict thresholding, the actual squared-entry
law with its deterministic zero branch, and accuracy and failure tolerance in
(0,1). It states the support count for every output as well as the spectral
error probability. The broader positive-accuracy contract remains unchanged.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Corrected finite sampling guarantee for `0 < eps < 1`, with deterministic
support size and the actual Option-valued thresholded sampling law. -/
def correctedTruncatedEntryGuaranteeUnitAccuracy : Prop :=
  ∀ (n s : ℕ) (A : Fin n → Fin n → ℝ) (eps δ : ℝ),
    0 < n → 0 < s → 0 < eps → eps < 1 → 0 < δ → δ < 1 →
    14 * (n : ℝ) * frobNormSqRect A * Real.log ((2 * (n : ℝ)) / δ) ≤
      (s : ℝ) * eps ^ 2 →
    (∀ outcome : Option (ElementwiseTrace n n s),
      (Finset.univ.filter (fun ij : Fin n × Fin n =>
        truncatedElementwiseSketch (eps / (2 * (n : ℝ))) A outcome ij.1 ij.2 ≠ 0)).card ≤ s) ∧
    1 - δ ≤
      (truncatedElementwiseProbability (s := s) (eps / (2 * (n : ℝ))) A).eventProb
        {outcome |
          rectOpNorm2Le (fun i j => A i j -
            truncatedElementwiseSketch (eps / (2 * (n : ℝ))) A outcome i j) eps ∧
          (Finset.univ.filter (fun ij : Fin n × Fin n =>
            truncatedElementwiseSketch (eps / (2 * (n : ℝ))) A outcome ij.1 ij.2 ≠ 0)).card ≤ s}

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
