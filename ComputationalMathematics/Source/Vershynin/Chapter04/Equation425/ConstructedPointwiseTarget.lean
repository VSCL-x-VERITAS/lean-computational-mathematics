import ComputationalMathematics.HDP.Vector.Whitening
import Mathlib.Probability.Independence.Basic

/-!
# Equation (4.25) with a jointly constructed pointwise realization

The input is a vector law, rather than a fixed representative on a prescribed
probability space. Population and samples are constructed together. Singular
and zero second moments remain in scope. No unchanged numerical sub-Gaussian
constant is promised for the ambient isotropic completion.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped ENNReal NNReal BigOperators MatrixOrder

namespace NumStability.HDP.Contract

/-- Complete owner-qualified pointwise law realization and the actual
coefficient-one sample Gram identity and Euclidean operator-norm estimate. -/
def equation425ConstructedPointwiseTarget : Prop :=
  ∀ (m n : ℕ), 0 < m → 0 < n →
  ∀ (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν] (K : ℝ≥0),
  1 ≤ K →
  NumStability.HDP.Vector.SubGaussian.IsSubGaussian ν (fun j x => x j) →
  NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound ν
    (fun j x => x j) K →
  (∀ j : Fin n, MemLp (fun x : Fin n → ℝ => x j) 2 ν) →
  let Sigma : Matrix (Fin n) (Fin n) ℝ :=
    NumStability.HDP.Vector.Covariance.secondMomentMatrix ν
    (fun j x => x j)
  let S : Matrix (Fin n) (Fin n) ℝ := CFC.sqrt Sigma
  S.PosSemidef ∧ S * S = Sigma ∧
  ∃ (Ω : Type) (measurableΩ : MeasurableSpace Ω),
    letI : MeasurableSpace Ω := measurableΩ
    ∃ μ : Measure Ω, IsProbabilityMeasure μ ∧
      ∃ F Z : Option (Fin m) → Ω → Fin n → ℝ,
        (∀ o, Measurable (F o) ∧ Measurable (Z o)) ∧
        (∀ o j, MemLp (fun ω => F o ω j) 2 μ ∧
          MemLp (fun ω => Z o ω j) 2 μ) ∧
        (∀ o, μ.map (F o) = ν) ∧
        iIndepFun F μ ∧ iIndepFun Z μ ∧
        iIndepFun (fun o ω => (F o ω, Z o ω)) μ ∧
        (∀ o, IdentDistrib (Z o) (Z none) μ μ) ∧
        (∀ o, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω => Z o ω j)) ∧
        (∀ o, NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ
          (fun j ω => Z o ω j)) ∧
        (∀ o ω, F o ω = S.mulVec (Z o ω)) ∧
        (∀ ω,
          let samples : Fin m → Fin n → ℝ := fun i => F (some i) ω
          let rows : Matrix (Fin m) (Fin n) ℝ := fun i j => Z (some i) ω j
          let R : Matrix (Fin n) (Fin n) ℝ :=
            ((m : ℝ)⁻¹) • (rows.transpose * rows) - 1
          R = NumStability.HDP.Vector.Covariance.sampleCovariance
            (fun i => Z (some i) ω) - 1 ∧
          NumStability.HDP.Vector.Covariance.sampleCovariance samples - Sigma =
            S * R * S ∧
          NumStability.realMatrixOperatorNorm
              (NumStability.HDP.Vector.Covariance.sampleCovariance samples - Sigma) =
            NumStability.realMatrixOperatorNorm (S * R * S) ∧
          NumStability.realMatrixOperatorNorm (S * R * S) ≤
            NumStability.realMatrixOperatorNorm R *
              NumStability.realMatrixOperatorNorm Sigma)

end NumStability.HDP.Contract
