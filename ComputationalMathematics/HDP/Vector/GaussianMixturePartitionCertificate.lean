import ComputationalMathematics.HDP.Vector.GaussianMixturePartitionFailure

/-!
# Regular binary partition certificates

Reusable mathematics transported from preserved runtime assets.
-/

noncomputable section

open Filter MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Probability

/-- Any null-measurable event certifying partition success has probability at
most one minus the canonical outer failure lower bound. -/
theorem coordinateMean_canonical_binaryPartitionCertificate_real_upper
    {m n : ℕ} (hm2 : 2 ≤ m) (hn : 0 < n) (r budget : ℝ)
    (partitionRule : (Fin m → Fin n → ℝ) → Fin m → Prop)
    (hr : 0 ≤ r) (hbudget : budget < 1)
    (good : Set (Fin m → ℝ × (Fin n → ℝ)))
    (hgood : NullMeasurableSet good (latentNoiseSampleMeasure m n))
    (hcertificate : ∀ omega ∈ good,
      MakesAtMostBinaryPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel omega i)
        (partitionRule (fun i ↦ canonicalPoint
          (coordinateMean r ⟨0, hn⟩) omega i)) budget) :
    (latentNoiseSampleMeasure m n).real good ≤
      1 - gaussianIntervalFloorReal r := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) := by
    unfold latentNoiseSampleMeasure
    infer_instance
  have hlower := coordinateMean_canonical_binaryPartitionFailure_real_lower
    hm2 hn r budget partitionRule hr hbudget
  have hsubset :
      {omega | ¬ MakesAtMostBinaryPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel omega i)
        (partitionRule (fun i ↦ canonicalPoint
          (coordinateMean r ⟨0, hn⟩) omega i)) budget} ⊆ goodᶜ := by
    intro omega hfailure hmem
    exact hfailure (hcertificate omega hmem)
  have hbound := hlower.trans (measureReal_mono hsubset (measure_ne_top _ _))
  rw [probReal_compl_eq_one_sub₀ hgood] at hbound
  linarith

end NumStability.HDP.Vector.GaussianMixture

end
