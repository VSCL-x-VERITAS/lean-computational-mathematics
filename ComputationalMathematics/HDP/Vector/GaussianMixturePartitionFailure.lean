import ComputationalMathematics.HDP.Vector.GaussianMixtureBalancedPartitionFailure

/-!
# Canonical Gaussian lower bounds for arbitrary binary partitions

Reusable mathematics transported from preserved runtime assets.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding
open NumStability.HDP.Probability

/-- The existing paired lift sends the existing balanced outer law to the
existing canonical latent-sample law on every event, including nonmeasurable
ones. This identity holds for every real coordinate-signal parameter. -/
theorem balancedGaussianBitOuter_pairedLift_apply_eq_canonical
    (m n : ℕ) (r : ℝ)
    (A : Set (Fin (m + 2) → ℝ × (Fin (n + 1) → ℝ))) :
    balancedGaussianBitOuter (latentNoiseCoordinateSideMeasure (m + 1) n) r
      {p | pairedLift m n r p.1 p.2 ∈ A} =
    latentNoiseSampleMeasure (m + 2) (n + 1) A := by
  let side := latentNoiseCoordinateSideMeasure (m + 1) n
  let raw := rademacherPMF.toMeasure.prod ((gaussianReal 0 1).prod side)
  let e := latentNoiseCoordinateSplitEquiv
    (Fin.last (m + 1)) (0 : Fin (n + 1))
  let F : ℝ × (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) →
      Bool × (ℝ × ((Fin n → ℝ) ×
        (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :=
    fun w ↦ (decide (w.1 = 1), (r * w.1 + w.2.1, w.2.2))
  let B : Set (Bool × (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))))) :=
    {p | pairedLift m n r p.1 p.2 ∈ A}
  have hbalanced : balancedGaussianBitOuter side r B = raw (F ⁻¹' B) := by
    symm
    simpa only [raw, F, Measure.toOuterMeasure_apply] using
      balancedGaussianBitOuter_apply_eq_rademacher side r B
  have hsplit : latentNoiseSampleMeasure (m + 2) (n + 1) A = raw (e '' A) := by
    simpa only [raw, e, side, latentNoiseCoordinateSplitEquiv',
      latentNoiseCoordinateResidualMeasure] using
      latentNoiseSampleMeasure_apply_split'_outer
        (Fin.last (m + 1)) (0 : Fin (n + 1)) A
  have hevents : raw (F ⁻¹' B) = raw (e '' A) := by
    apply measure_congr
    filter_upwards [(Measure.quasiMeasurePreserving_fst
      (μ := rademacherPMF.toMeasure)
      (ν := (gaussianReal 0 1).prod side)).ae
        rademacher_ae_eq_neg_one_or_one] with w hw
    have hreassemble : pairedLift m n r (F w).1 (F w).2 = e.symm w := by
      rcases w with ⟨s, z⟩
      rcases hw with rfl | rfl <;>
        rw [pairedLift_eq_split_symm] <;> norm_num [F, e, rademacherValue]
    rw [MeasurableEquiv.image_eq_preimage_symm]
    exact congrArg (fun omega ↦ omega ∈ A) hreassemble
  exact hbalanced.trans (hevents.trans hsplit.symm)

/-- Every arbitrary data-only predicate-output rule has failure outer measure
at least the existing Gaussian overlap under the canonical latent-sample law.
The rule and failure set need not be measurable. -/
theorem coordinateMean_canonical_binaryPartitionFailure_lower_succ
    (m n : ℕ)
    (partitionRule : (Fin (m + 2) → Fin (n + 1) → ℝ) →
      Fin (m + 2) → Prop)
    {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloor r ≤
      latentNoiseSampleMeasure (m + 2) (n + 1)
        {omega | ¬ MakesAtMostBinaryPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel omega i)
          (partitionRule (fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) omega i)) budget} := by
  let failure : Set (Fin (m + 2) → ℝ × (Fin (n + 1) → ℝ)) :=
    {omega | ¬ MakesAtMostBinaryPartitionErrorsUpToSwap
      (fun i ↦ canonicalLabel omega i)
      (partitionRule (fun i ↦ canonicalPoint
        (coordinateMean r (0 : Fin (n + 1))) omega i)) budget}
  have hbalanced := coordinateMean_balanced_binaryPartitionFailure_outer_lower
    m n partitionRule hr hbudget
  change gaussianIntervalFloor r ≤ latentNoiseSampleMeasure (m + 2) (n + 1) failure
  calc
    gaussianIntervalFloor r ≤
        balancedGaussianBitOuter (latentNoiseCoordinateSideMeasure (m + 1) n) r
          {p | pairedLift m n r p.1 p.2 ∈ failure} := by
      simpa only [failure, Set.mem_setOf_eq] using hbalanced
    _ = latentNoiseSampleMeasure (m + 2) (n + 1) failure :=
      balancedGaussianBitOuter_pairedLift_apply_eq_canonical m n r failure

/-- Real-valued form of the canonical arbitrary-partition failure lower bound.
Its evaluation is defined on arbitrary events without a measurability premise. -/
theorem coordinateMean_canonical_binaryPartitionFailure_real_lower_succ
    (m n : ℕ)
    (partitionRule : (Fin (m + 2) → Fin (n + 1) → ℝ) →
      Fin (m + 2) → Prop)
    {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloorReal r ≤
      (latentNoiseSampleMeasure (m + 2) (n + 1)).real
        {omega | ¬ MakesAtMostBinaryPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel omega i)
          (partitionRule (fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) omega i)) budget} := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure (m + 2) (n + 1)) := by
    unfold latentNoiseSampleMeasure
    infer_instance
  rw [← gaussianIntervalFloor_toReal, Measure.real_def]
  exact ENNReal.toReal_mono (measure_ne_top _ _)
    (coordinateMean_canonical_binaryPartitionFailure_lower_succ
      m n partitionRule hr hbudget)

/-- Canonical outer failure lower bound at every nondegenerate sample size and
dimension, for an arbitrary data-only binary partition rule. -/
theorem coordinateMean_canonical_binaryPartitionFailure_lower
    {m n : ℕ} (hm2 : 2 ≤ m) (hn : 0 < n) (r budget : ℝ)
    (partitionRule : (Fin m → Fin n → ℝ) → Fin m → Prop)
    (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloor r ≤
      latentNoiseSampleMeasure m n
        {omega | ¬ MakesAtMostBinaryPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel omega i)
          (partitionRule (fun i ↦ canonicalPoint
            (coordinateMean r ⟨0, hn⟩) omega i)) budget} := by
  obtain ⟨m', rfl⟩ := Nat.exists_eq_add_of_le' hm2
  obtain ⟨n', rfl⟩ := Nat.exists_eq_add_of_le' (show 1 ≤ n from hn)
  simpa using coordinateMean_canonical_binaryPartitionFailure_lower_succ
    m' n' partitionRule hr hbudget

/-- Real-valued canonical outer failure lower bound in arbitrary nondegenerate
dimensions. The rule and failure set need not be measurable. -/
theorem coordinateMean_canonical_binaryPartitionFailure_real_lower
    {m n : ℕ} (hm2 : 2 ≤ m) (hn : 0 < n) (r budget : ℝ)
    (partitionRule : (Fin m → Fin n → ℝ) → Fin m → Prop)
    (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloorReal r ≤
      (latentNoiseSampleMeasure m n).real
        {omega | ¬ MakesAtMostBinaryPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel omega i)
          (partitionRule (fun i ↦ canonicalPoint
            (coordinateMean r ⟨0, hn⟩) omega i)) budget} := by
  obtain ⟨m', rfl⟩ := Nat.exists_eq_add_of_le' hm2
  obtain ⟨n', rfl⟩ := Nat.exists_eq_add_of_le' (show 1 ≤ n from hn)
  simpa using coordinateMean_canonical_binaryPartitionFailure_real_lower_succ
    m' n' partitionRule hr hbudget

end NumStability.HDP.Vector.GaussianMixture

end
