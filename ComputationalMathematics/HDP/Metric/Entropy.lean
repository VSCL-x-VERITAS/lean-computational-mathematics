import Mathlib.Analysis.SpecialFunctions.Log.ENNRealLog
import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Metric entropy and finite-bit metric codes

Extended-valued definitions of metric entropy and the least bit length of a
code whose fibers have prescribed metric diameter.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Metric

/-- Base-two logarithm of the internal covering number. The extended-real
codomain retains the values at zero and infinity. -/
noncomputable def metricEntropy
    {T : Type*} [PseudoEMetricSpace T] (K : Set T) (ε : ℝ≥0) : EReal :=
  ENNReal.log (Metric.coveringNumber ε K).toENNReal / ENNReal.log 2

/-- An `N`-bit metric code on `K` has at most `2^N` codewords, and points with
the same codeword are within distance `ε`. -/
def IsMetricCode
    {T : Type*} [PseudoEMetricSpace T] (K : Set T) (ε : ℝ≥0) (N : ℕ) : Prop :=
  ∃ encode : K → Fin (2 ^ N),
    ∀ x y : K, encode x = encode y → edist (x : T) y ≤ ε

/-- The least number of bits sufficient to represent every point of `K` with
metric accuracy `ε`; it is infinite when no finite-bit code exists. -/
noncomputable def codingComplexity
    {T : Type*} [PseudoEMetricSpace T] (K : Set T) (ε : ℝ≥0) : ℕ∞ :=
  ⨅ (N : ℕ) (_ : IsMetricCode K ε N), (N : ℕ∞)

theorem codingComplexity_eq_iInf
    {T : Type*} [PseudoEMetricSpace T] (K : Set T) (ε : ℝ≥0) :
    codingComplexity K ε =
      ⨅ (N : ℕ) (_ : ∃ encode : K → Fin (2 ^ N),
        ∀ x y : K, encode x = encode y → edist (x : T) y ≤ ε),
        (N : ℕ∞) := rfl

end NumStability.HDP.Metric
