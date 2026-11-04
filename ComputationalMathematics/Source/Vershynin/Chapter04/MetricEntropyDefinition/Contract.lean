import ComputationalMathematics.HDP.Metric.Entropy

/-!
# Vershynin Chapter 4, metric-entropy definition
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Section 4.3.1: the metric entropy is the base-two logarithm of
the covering number. -/
theorem hdp_04_metric_entropy_definition
    {T : Type*} [PseudoEMetricSpace T] (K : Set T) (ε : ℝ≥0) :
    NumStability.HDP.Metric.metricEntropy K ε =
      ENNReal.log (Metric.coveringNumber ε K).toENNReal / ENNReal.log 2 := rfl

end NumStability.HDP.Contract
