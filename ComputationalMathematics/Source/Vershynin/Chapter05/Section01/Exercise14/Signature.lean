import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.Topology.MetricSpace.HausdorffDistance
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen proof-free signature for Exercise 5.1.14. -/

noncomputable section

open MeasureTheory
open Set
open scoped ENNReal

namespace NumStability.HDP.Contract

def hdp_05_hex_h5_d1_d14__contract_type : Prop :=
  ∀ {Ω : Type*} [PseudoMetricSpace Ω] [MeasurableSpace Ω] [BorelSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {A : Set Ω},
    IsClosed A →
    A.Nonempty →
    {K : ℝ} → 0 < K →
    Integrable (fun x => Metric.infDist x A) μ →
    (∀ {f : Ω → ℝ} {L : NNReal},
      Measurable f → Integrable f μ → LipschitzWith L f →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun x => f x - ∫ y, f y ∂μ) ≤
          ENNReal.ofReal K * ENNReal.ofNNReal L) →
    (1 / 2 : ENNReal) ≤ μ A →
    ∃ c : ℝ, 0 < c ∧ ∀ {t : ℝ}, 0 ≤ t →
      1 - 2 * Real.exp (-c * t ^ 2 / K ^ 2) ≤
        μ.real {x | Metric.infDist x A ≤ t}

end NumStability.HDP.Contract
