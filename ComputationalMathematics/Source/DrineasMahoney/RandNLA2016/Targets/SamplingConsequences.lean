import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.IndependentTrace
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.Elementwise.Core
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.Gram
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.TraceProbability

/-! # Column sampling, output sparsity, and the explicit Eq. (5) Markov consequence

These contracts retain separate selected child claims. The Gram tail has the
visible confidence-dependent threshold dictated by Markov's inequality.
-/
namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets
open scoped BigOperators

/-- Algorithm 2 transposed back samples columns, retaining one column per trial. -/
def columnSamplingAlgorithm : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin n)), 0 < s →
    (∀ ω, (P.iid s).prob ω = ∏ t, P.prob (ω t)) ∧
    (P.iid s).eventProb {ω | ∀ t, 0 < P.prob (ω t)} = 1 ∧
    ∀ (ω : Fin s → Fin n) i t,
      (Matrix.transpose (rowSampleSketchWithProb s (Matrix.transpose A) P.prob ω)) i t =
        (1 / Real.sqrt ((s : ℝ) * P.prob (ω t))) * A i (ω t)

/-- At most `s` distinct entries of the zero-initialized Algorithm 1 output
are nonzero. Repeated samples and sampled zero entries can make this strict. -/
def elementwiseSamplingSparsity : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin m × Fin n)), 0 < s →
    ∀ (ω : ElementwiseTrace m n s), (∀ t, 0 < P.prob (ω t)) →
      (Finset.univ.filter (fun ij : Fin m × Fin n =>
        elementwiseTraceSketchWithProb s A (fun _ _ => 0)
          (fun i j => P.prob (i,j)) ω ij.1 ij.2 ≠ 0)).card ≤ s

/-- The direct high-probability consequence of the unsquared Eq. (5) expectation:
the threshold is enlarged by `1/δ`, with the literal nonzero-input norm law. -/
def gramErrorHighProbability : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ)
    (hA : 0 < rowSqNormProbDen A), 0 < s →
    ∀ δ : ℝ, 0 < δ → δ < 1 →
      1 - δ ≤ (rowSqNormTraceProbability (steps := s) A hA).eventProb
        {ω | frobNorm (fun j k => rowSampleGram s A ω j k - rowGram A j k) ≤
          rowSqNormProbDen A / (δ * Real.sqrt (s : ℝ))}

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
