import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.IndependentTrace
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.Elementwise.Core
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.Gram
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Preconditioning.ExactTransforms.Core

/-! # Algorithm contracts for Drineas--Mahoney (2016)

Algorithms 1 and 2 use a supplied finite distribution and exactly `s` independent
samples with replacement. Zero-probability outcomes are excluded almost surely.
The unbiasedness claims require the distribution to cover every nonzero entry
or row; without this support condition those claims are false. Algorithm 3
specifies products once its random preprocessing matrices have been drawn.
As in the source meta-algorithm, these preprocessing matrices preserve dimensions.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets
open scoped BigOperators

/-- Algorithm 1 and equation (1): iid sampling and the accumulated exact update. -/
def elementwiseSamplingAlgorithm : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin m × Fin n)), 0 < s →
    (∀ ω, (P.iid s).prob ω = ∏ t, P.prob (ω t)) ∧
    (P.iid s).eventProb {ω | ∀ t, 0 < P.prob (ω t)} = 1 ∧
    ∀ (ω : ElementwiseTrace m n s) i j,
      elementwiseTraceSketchWithProb s A (fun _ _ => 0)
        (fun r c => P.prob (r,c)) ω i j =
      ∑ t : Fin s, if (ω t).1 = i ∧ (ω t).2 = j then
        (1 / ((s : ℝ) * P.prob (i,j))) * A i j else 0

/-- Algorithm 2 and equation (3): iid row sampling with the prescribed scale. -/
def rowSamplingAlgorithm : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin m)), 0 < s →
    (∀ ω, (P.iid s).prob ω = ∏ t, P.prob (ω t)) ∧
    (P.iid s).eventProb {ω | ∀ t, 0 < P.prob (ω t)} = 1 ∧
    ∀ (ω : RowTrace m s) t j,
      rowSampleSketchWithProb s A P.prob ω t j =
        (1 / Real.sqrt ((s : ℝ) * P.prob (ω t))) * A (ω t) j

/-- Algorithm 3: the exact left, right and two-sided matrix products.
The meta-algorithm does not prescribe a unique law for the preprocessing maps. -/
def randomProjectionPreconditioningAlgorithm : Prop :=
  ∀ (m n : ℕ) (L : Fin m → Fin m → ℝ)
    (A : Fin m → Fin n → ℝ) (R : Fin n → Fin n → ℝ),
    (∀ i j, preconditionRows L A i j = ∑ k : Fin m, L i k * A k j) ∧
    (∀ i j, preconditionColumns A R i j = ∑ k : Fin n, A i k * R k j) ∧
    (∀ i j, preconditionElements L A R i j =
      ∑ k : Fin m, ∑ l : Fin n, L i k * A k l * R l j)

/-- The elementwise sketch is unbiased when the supplied law covers `A`'s support. -/
def elementwiseSamplingUnbiased : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin m × Fin n)),
    0 < s → (∀ i j, P.prob (i,j) = 0 → A i j = 0) →
    ∀ i j, (P.iid s).expectationReal
      (fun ω => elementwiseTraceSketchWithProb s A (fun _ _ => 0)
        (fun r c => P.prob (r,c)) ω i j) = A i j

/-- The row sketch's Gram matrix is unbiased when the law covers every nonzero row. -/
def rowSamplingGramUnbiased : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin m)),
    0 < s → (∀ i, P.prob i = 0 → ∀ j, A i j = 0) →
    ∀ j k, (P.iid s).expectationReal
      (fun ω => rowGram (rowSampleSketchWithProb s A P.prob ω) j k) = rowGram A j k

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
