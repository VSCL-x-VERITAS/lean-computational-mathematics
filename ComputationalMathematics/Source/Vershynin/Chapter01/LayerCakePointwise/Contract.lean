import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Stable Chapter 1 contract for the pointwise identity in the proof of Lemma 1.2.1. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory

/-- A nonnegative real is the length of `[0,x]`, equivalently the integral of
the strict-threshold indicator over positive thresholds. -/
theorem hdp_01_hlem_hlayer_hcake_hpointwise {x : ℝ} (hx : 0 ≤ x) :
    x = (∫ _t in Set.Ioc 0 x, (1 : ℝ) ∂volume) ∧
      ENNReal.ofReal x =
        ∫⁻ t in Set.Ioi 0,
          (Set.Iio x).indicator (fun _ => (1 : ENNReal)) t ∂volume :=
  NumStability.HDP.Scalar.Preliminaries.layerCakePointwise hx

end NumStability.HDP.Contract
