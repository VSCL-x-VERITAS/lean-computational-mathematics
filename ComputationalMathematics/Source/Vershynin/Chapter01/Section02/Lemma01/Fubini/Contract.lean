import ComputationalMathematics.HDP.Scalar.Preliminaries
/-! Stable Chapter 1 contract for the Tonelli interchange in Lemma 1.2.1's proof. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Tonelli interchanges the probability and positive-threshold integrals of the
strict-superlevel indicator used in the layer-cake proof. -/
theorem hdp_01_hlem_h1_d2_d1_hfubini_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    (∫⁻ ω, ∫⁻ t in Set.Ioi 0,
        (Set.Iio (X ω)).indicator (fun _ => (1 : ENNReal)) t ∂volume ∂μ) =
      ∫⁻ t in Set.Ioi 0, ∫⁻ ω,
        (Set.Iio (X ω)).indicator (fun _ => (1 : ENNReal)) t ∂μ ∂volume := by
  apply MeasureTheory.lintegral_lintegral_swap
  have hs : MeasurableSet {p : Ω × ℝ | p.2 < X p.1} :=
    measurableSet_lt measurable_snd (hX.comp measurable_fst)
  have hm : Measurable
      ({p : Ω × ℝ | p.2 < X p.1}.indicator (fun _ => (1 : ENNReal))) :=
    measurable_const.indicator hs
  convert hm.aemeasurable using 1

end NumStability.HDP.Contract
