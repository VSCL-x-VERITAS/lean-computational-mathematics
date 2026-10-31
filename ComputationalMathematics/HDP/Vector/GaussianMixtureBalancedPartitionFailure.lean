import ComputationalMathematics.HDP.Vector.GaussianMixtureBinaryPartition
import ComputationalMathematics.HDP.Vector.GaussianMixtureCounterexample
import ComputationalMathematics.HDP.Probability.BalancedGaussianTesting

/-!
# Balanced Gaussian lower bounds for arbitrary binary partitions

Reusable mathematics transported from preserved runtime assets.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding
open NumStability.HDP.Probability

/-- Under the existing balanced paired law, an arbitrary data-only predicate
output cannot recover the partition with fewer than one allowed error below
its Gaussian testing overlap. Invalid binary latent-label support is included
in the bad event. No measurability of the output rule is required. -/
theorem coordinateMean_balanced_binaryPartitionFailure_lower
    (m n : ℕ)
    (partitionRule : (Fin (m + 2) → Fin (n + 1) → ℝ) →
      Fin (m + 2) → Prop)
    {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloor r ≤
      balancedGaussianBitOuter (latentNoiseCoordinateSideMeasure (m + 1) n) r
        {p | let omega := pairedLift m n r p.1 p.2
          let X := fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) omega i
          ¬ MakesAtMostBinaryPartitionErrorsUpToSwap
              (fun i ↦ canonicalLabel omega i) (partitionRule X) budget ∨
            ¬ ∀ i, canonicalLabel omega i = -1 ∨ canonicalLabel omega i = 1} := by
  classical
  let side := latentNoiseCoordinateSideMeasure (m + 1) n
  let mean := coordinateMean r (0 : Fin (n + 1))
  let target : Fin (m + 2) := Fin.last (m + 1)
  let reference : Fin (m + 2) := (0 : Fin (m + 1)).castSucc
  let omega : Bool → ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))) →
      Fin (m + 2) → ℝ × (Fin (n + 1) → ℝ) :=
    fun theta z ↦ pairedLift m n r theta z
  let X : Bool → ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))) →
      Fin (m + 2) → Fin (n + 1) → ℝ :=
    fun theta z i ↦ canonicalPoint mean (omega theta z) i
  have houtput (theta : Bool)
      (z : ℝ × ((Fin n → ℝ) ×
        (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :
      partitionRule (X theta z) = partitionRule (X true z) :=
    congrArg partitionRule (pairedLift_canonicalPoint_eq m n r theta true z)
  let oracle : ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))) → Bool :=
    fun s ↦ decide ((s.2 (0 : Fin (m + 1))).1 = 1)
  let sameCluster : Set (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :=
    {z | partitionRule (X true z) target ↔ partitionRule (X true z) reference}
  let success : Bool → Set (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :=
    fun theta ↦ {z |
      MakesAtMostBinaryPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel (omega theta z) i)
        (partitionRule (X theta z)) budget ∧
      ∀ i, canonicalLabel (omega theta z) i = -1 ∨
        canonicalLabel (omega theta z) i = 1}
  have hsuccess : ∀ theta z, z ∈ success theta →
      (z ∈ sameCluster ↔ theta = oracle z.2) := by
    intro theta z hz
    rcases hz with ⟨hpartition, hlabels⟩
    rw [houtput theta z] at hpartition
    have hrel := sameCluster_iff_labels_eq_of_binaryPartitionErrors_lt_one_at
      (fun i ↦ canonicalLabel (omega theta z) i)
      (partitionRule (X true z)) hbudget hpartition target reference
      (hlabels target) (hlabels reference)
    have htarget : canonicalLabel (omega theta z) target =
        rademacherValue theta := by
      simp [omega, target, canonicalLabel]
    have hreference : canonicalLabel (omega theta z) reference =
        (z.2.2 (0 : Fin (m + 1))).1 := by
      change (pairedLift m n r theta z (0 : Fin (m + 1)).castSucc).1 = _
      rw [pairedLift_castSucc_row]
    change (z ∈ sameCluster ↔ theta = oracle z.2)
    rw [show z ∈ sameCluster ↔
        canonicalLabel (omega theta z) target =
          canonicalLabel (omega theta z) reference by
      simpa [sameCluster] using hrel]
    rw [htarget, hreference]
    rcases hlabels reference with href | href <;>
      cases theta <;>
        simp [oracle, rademacherValue, ← hreference, href] <;> norm_num
  have htest := gaussianReal_prod_balanced_partitionFailure_outer_lower
    side hr oracle sameCluster success hsuccess
  simpa only [success, Set.mem_setOf_eq, not_and_or, side, omega, X, mean] using htest

/-- All latent labels of the existing paired sample are binary outside a null
set under the existing balanced outer law, for every real signal parameter. -/
theorem balancedGaussianBitOuter_pairedLift_labelBad_eq_zero
    (m n : ℕ) (r : ℝ) :
    balancedGaussianBitOuter (latentNoiseCoordinateSideMeasure (m + 1) n) r
      {p | ¬ ∀ i, canonicalLabel (pairedLift m n r p.1 p.2) i = -1 ∨
        canonicalLabel (pairedLift m n r p.1 p.2) i = 1} = 0 := by
  let side := latentNoiseCoordinateSideMeasure (m + 1) n
  have hside : ∀ᵐ s ∂side,
      ∀ i, canonicalLabel s.2 i = -1 ∨ canonicalLabel s.2 i = 1 := by
    change ∀ᵐ s ∂(NumStability.standardGaussianVectorMeasure n).prod
      (latentNoiseSampleMeasure (m + 1) (n + 1)),
        ∀ i, canonicalLabel s.2 i = -1 ∨ canonicalLabel s.2 i = 1
    exact (Measure.quasiMeasurePreserving_snd
      (μ := NumStability.standardGaussianVectorMeasure n)
      (ν := latentNoiseSampleMeasure (m + 1) (n + 1))).ae
        (canonicalLabels_ae_eq_neg_one_or_one (m + 1) (n + 1))
  have hconditional (theta : Bool) (a : ℝ) :
      ((gaussianReal a 1).prod side)
        {z | ¬ ∀ i, canonicalLabel (pairedLift m n r theta z) i = -1 ∨
          canonicalLabel (pairedLift m n r theta z) i = 1} = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [(Measure.quasiMeasurePreserving_snd
      (μ := gaussianReal a 1) (ν := side)).ae hside] with z hz
    refine not_not_intro ?_
    intro i
    cases i using Fin.lastCases with
    | last =>
        cases theta <;> simp [canonicalLabel, rademacherValue]
    | cast i =>
        simpa only [canonicalLabel, pairedLift_castSucc_row] using hz i
  simp only [balancedGaussianBitOuter, OuterMeasure.smul_apply,
    OuterMeasure.add_apply, OuterMeasure.map_apply,
    Measure.toOuterMeasure_apply, smul_eq_mul]
  change (2 : ℝ≥0∞)⁻¹ *
    (((gaussianReal r 1).prod side)
      {z | ¬ ∀ i, canonicalLabel (pairedLift m n r true z) i = -1 ∨
        canonicalLabel (pairedLift m n r true z) i = 1} +
    ((gaussianReal (-r) 1).prod side)
      {z | ¬ ∀ i, canonicalLabel (pairedLift m n r false z) i = -1 ∨
        canonicalLabel (pairedLift m n r false z) i = 1}) = 0
  rw [hconditional true r, hconditional false (-r), zero_add, mul_zero]

/-- An arbitrary data-only binary partition has failure outer measure at least
the existing Gaussian overlap under the existing balanced paired law. The
partition rule can be nonmeasurable. No binary-support hypothesis is added. -/
theorem coordinateMean_balanced_binaryPartitionFailure_outer_lower
    (m n : ℕ)
    (partitionRule : (Fin (m + 2) → Fin (n + 1) → ℝ) →
      Fin (m + 2) → Prop)
    {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloor r ≤
      balancedGaussianBitOuter (latentNoiseCoordinateSideMeasure (m + 1) n) r
        {p | let omega := pairedLift m n r p.1 p.2
          let X := fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) omega i
          ¬ MakesAtMostBinaryPartitionErrorsUpToSwap
              (fun i ↦ canonicalLabel omega i) (partitionRule X) budget} := by
  let law := balancedGaussianBitOuter
    (latentNoiseCoordinateSideMeasure (m + 1) n) r
  let failure : Set (Bool × (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))))) :=
    {p | let omega := pairedLift m n r p.1 p.2
      let X := fun i ↦ canonicalPoint
        (coordinateMean r (0 : Fin (n + 1))) omega i
      ¬ MakesAtMostBinaryPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel omega i) (partitionRule X) budget}
  let labelBad : Set (Bool × (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))))) :=
    {p | ¬ ∀ i, canonicalLabel (pairedLift m n r p.1 p.2) i = -1 ∨
      canonicalLabel (pairedLift m n r p.1 p.2) i = 1}
  have hzero : law labelBad = 0 :=
    balancedGaussianBitOuter_pairedLift_labelBad_eq_zero m n r
  have hcore := coordinateMean_balanced_binaryPartitionFailure_lower
    m n partitionRule hr hbudget
  change gaussianIntervalFloor r ≤ law (failure ∪ labelBad) at hcore
  change gaussianIntervalFloor r ≤ law failure
  calc
    gaussianIntervalFloor r ≤ law (failure ∪ labelBad) := hcore
    _ ≤ law failure + law labelBad := measure_union_le failure labelBad
    _ = law failure := by rw [hzero, add_zero]

end NumStability.HDP.Vector.GaussianMixture

end
