import Mathlib.Probability.CDF
import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-! Frozen proof-free signature for Exercise 5.2.11. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

def hdp_05_hex_h5_d2_d11__contract_type : Prop :=
  ∀ n : ℕ,
    Measure.map
        (fun z i => ProbabilityTheory.cdf (ProbabilityTheory.gaussianReal 0 1) (z i))
        (Measure.pi (fun _ : Fin n => ProbabilityTheory.gaussianReal 0 1)) =
      Measure.pi (fun _ : Fin n =>
        (MeasureTheory.volume : Measure ℝ).restrict (Set.Icc 0 1))

end NumStability.HDP.Contract
