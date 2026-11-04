import ComputationalMathematics.HDP.Matrix.SubGaussianBilinearMaximum
import ComputationalMathematics.Source.Vershynin.Chapter04.Equation415.PositiveScaleQuarterNetCase

/-!
Proof-free prospective owner-qualified Equation 4.15 parent.
No theorem, proof, axiom, admission or compilation is asserted by this file.
The source's literal coordinate discrepancies stay in the source packet.
Matrix.toEuclideanLin explicitly selects the corrected invariant pairing
sum_(i : Fin m) sum_(j : Fin n) A_ij x_j y_i, not the printed mixed indices.
-/

noncomputable section
open MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators

universe u

namespace NumStability.HDP.Contract.Equation415OwnerQualified

/-- Positive-dimensional, positive-intrinsic-scale displayed formula, with
one absolute c common to the derived pair tail and the actual net maximum. -/
def PositiveScaleParent : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ {Ω : Type u} [MeasurableSpace Ω] {μ : Measure Ω}
      [IsProbabilityMeasure μ] {m n : ℕ}
      [Nonempty (Fin m)] [Nonempty (Fin n)],
    ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ),
    (∀ ij : Fin m × Fin n,
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
        (fun ω => A ω ij.1 ij.2)) →
    (∀ ij : Fin m × Fin n,
      Integrable (fun ω => A ω ij.1 ij.2) μ ∧
        (∫ ω, A ω ij.1 ij.2 ∂μ) = 0) →
    iIndepFun (fun ij : Fin m × Fin n => fun ω => A ω ij.1 ij.2) μ →
    let K := NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
      (fun ij : Fin m × Fin n => fun ω => A ω ij.1 ij.2)
    0 < K →
    ∀ (N : Finset (EuclideanSpace ℝ (Fin n)))
      (M : Finset (EuclideanSpace ℝ (Fin m))),
    NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N →
    NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) M →
    ∀ (hN : N.Nonempty) (hM : M.Nonempty),
    N.card ≤ 9 ^ n → M.card ≤ 9 ^ m →
    ∀ {u : ℝ}, 0 ≤ u →
      let q : Ω → ℝ := fun ω => (N ×ˢ M).sup' (hN.product hM)
        (fun xy => inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)
      let b : ℝ := 2 * Real.exp (-(c * u ^ 2 / K ^ 2))
      (∀ x ∈ N, ∀ y ∈ M,
        μ.real {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} ≤ b) ∧
      ({ω | u ≤ q ω} =
        ⋃ x ∈ N, ⋃ y ∈ M, {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y}) ∧
      μ.real {ω | u ≤ q ω} ≤
        ∑ xy ∈ N ×ˢ M,
          μ.real {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2} ∧
      (∑ xy ∈ N ×ˢ M,
          μ.real {ω | u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2}) ≤
        (9 ^ (n + m) : ℕ) * b ∧
      μ.real {ω | u ≤ q ω} ≤ (9 ^ (n + m) : ℕ) * b

/-- Separately named zero-scale statement: finite gauges prevent an infinite
norm's real default from being mistaken for zero. No quotient is used. -/
def ZeroScaleMatrixCase : Prop :=
  ∀ {Ω : Type u} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {m n : ℕ}
    [Nonempty (Fin m)] [Nonempty (Fin n)],
  ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ),
  (∀ ij : Fin m × Fin n, Measurable (fun ω => A ω ij.1 ij.2)) →
  (∀ ij : Fin m × Fin n,
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
      (fun ω => A ω ij.1 ij.2) < ∞) →
  let K := NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
    (fun ij : Fin m × Fin n => fun ω => A ω ij.1 ij.2)
  (K = 0 ↔ A =ᵐ[μ] (fun _ => (0 : Matrix (Fin m) (Fin n) ℝ))) ∧
  (K = 0 →
    ∀ (N : Finset (EuclideanSpace ℝ (Fin n)))
      (M : Finset (EuclideanSpace ℝ (Fin m)))
      (hN : N.Nonempty) (hM : M.Nonempty),
      let q : Ω → ℝ := fun ω => (N ×ˢ M).sup' (hN.product hM)
        (fun xy => inner ℝ (Matrix.toEuclideanLin (A ω) xy.1) xy.2)
      (q =ᵐ[μ] (fun _ => (0 : ℝ))) ∧
      ∀ {u : ℝ}, 0 ≤ u →
        μ.real {ω | u ≤ q ω} = if u ≤ 0 then 1 else 0)

/-- Empty-dimensional extension uses the actual empty union event, never a
fabricated maximum or intrinsic maximum over an empty entry family. -/
def EmptyDimensionUnionCase : Prop :=
  ∀ {Ω : Type u} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {m n : ℕ},
  m = 0 ∨ n = 0 →
  ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ)
    (N : Finset (EuclideanSpace ℝ (Fin n)))
    (M : Finset (EuclideanSpace ℝ (Fin m))),
  NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N →
  NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) M →
  (∀ ω, A ω = 0) ∧ N ×ˢ M = ∅ ∧
    ∀ u : ℝ,
      μ.real {ω | ∃ x ∈ N, ∃ y ∈ M,
        u ≤ inner ℝ (Matrix.toEuclideanLin (A ω) x) y} = 0

/-- One prospective parent bundle; the zero/empty clauses are explicit
mathematical qualifications, not claims about a printed source convention. -/
def CompleteOwnerQualifiedParent : Prop :=
  PositiveScaleParent.{u} ∧ ZeroScaleMatrixCase.{u} ∧ EmptyDimensionUnionCase.{u}

end NumStability.HDP.Contract.Equation415OwnerQualified
