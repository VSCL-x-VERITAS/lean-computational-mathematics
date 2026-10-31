import ComputationalMathematics.HDP.Probability.RademacherGaussianTesting
import ComputationalMathematics.HDP.Vector.GaussianMixtureLatentDecomposition
import ComputationalMathematics.HDP.Vector.GaussianMixturePartitionRecovery

/-!
# Lower bounds for Gaussian-mixture partition recovery

Reusable coordinate-supported signals and paired latent observations that
reduce partition recovery to balanced Gaussian binary testing. These results
provide probabilistic obstructions; numbered source claims are kept in the
Vershynin correspondence modules.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding
open NumStability.HDP.Probability

/-- A signal supported on one coordinate. -/
def coordinateMean (r : ℝ) (j : Fin n) : Fin n → ℝ :=
  Pi.single j r

@[simp] theorem vecNorm2_coordinateMean (r : ℝ) (j : Fin n) :
    NumStability.vecNorm2 (coordinateMean r j) = |r| := by
  unfold coordinateMean NumStability.vecNorm2 NumStability.vecNorm2Sq
  rw [Finset.sum_eq_single j]
  · simp [Real.sqrt_sq_eq_abs]
  · intro i _ hi
    simp [hi]
  · simp

/-- Reassemble the latent sample after separating its selected label and noise coordinate. -/
def pairedLift (m n : ℕ) (r : ℝ) (theta : Bool)
    (z : ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :
    Fin (m + 2) → ℝ × (Fin (n + 1) → ℝ) :=
  Fin.lastCases
    (rademacherValue theta,
      Fin.cases (z.1 - rademacherValue theta * r) z.2.1)
    z.2.2

@[simp] theorem pairedLift_last_label (m n : ℕ) (r : ℝ) (theta : Bool)
    (z : ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :
    ((pairedLift m n r theta z) (Fin.last (m + 1))).1 =
      rademacherValue theta := by
  simp [pairedLift]

@[simp] theorem pairedLift_last_noise_zero (m n : ℕ) (r : ℝ)
    (theta : Bool)
    (z : ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :
    ((pairedLift m n r theta z) (Fin.last (m + 1))).2 0 =
      z.1 - rademacherValue theta * r := by
  simp [pairedLift]

@[simp] theorem pairedLift_last_noise_succ (m n : ℕ) (r : ℝ)
    (theta : Bool)
    (z : ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) (j : Fin n) :
    ((pairedLift m n r theta z) (Fin.last (m + 1))).2 j.succ = z.2.1 j := by
  simp [pairedLift]

@[simp] theorem pairedLift_castSucc_row (m n : ℕ) (r : ℝ)
    (theta : Bool)
    (z : ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) (i : Fin (m + 1)) :
    pairedLift m n r theta z i.castSucc = z.2.2 i := by
  simp [pairedLift]

theorem pairedLift_eq_split_symm (m n : ℕ) (r : ℝ) (theta : Bool)
    (z : ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :
    pairedLift m n r theta z =
      (latentNoiseCoordinateSplitEquiv
        (Fin.last (m + 1)) (0 : Fin (n + 1))).symm
        (rademacherValue theta,
          (z.1 - rademacherValue theta * r, z.2)) := by
  apply (latentNoiseCoordinateSplitEquiv
    (Fin.last (m + 1)) (0 : Fin (n + 1))).injective
  rw [(latentNoiseCoordinateSplitEquiv
    (Fin.last (m + 1)) (0 : Fin (n + 1))).apply_symm_apply]
  apply Prod.ext
  · simp
  apply Prod.ext
  · simp
  apply Prod.ext
  · ext j
    change ((pairedLift m n r theta z) (Fin.last (m + 1))).2 j.succ = z.2.1 j
    simp
  · funext i
    simp [latentNoiseCoordinateSplitEquiv, pairedLift]
    change Fin.init (pairedLift m n r theta z) i = z.2.2 i
    exact pairedLift_castSucc_row m n r theta z i

theorem pairedLift_canonicalPoint_eq (m n : ℕ) (r : ℝ)
    (theta theta' : Bool)
    (z : ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :
    (fun i ↦ canonicalPoint (coordinateMean r (0 : Fin (n + 1)))
      (pairedLift m n r theta z) i) =
  (fun i ↦ canonicalPoint (coordinateMean r (0 : Fin (n + 1)))
      (pairedLift m n r theta' z) i) := by
  ext i j
  cases i using Fin.lastCases with
  | last =>
      cases j using Fin.cases with
      | zero =>
          cases theta <;> cases theta' <;>
            simp [canonicalPoint, mixtureMap, coordinateMean, pairedLift,
              rademacherValue]
      | succ j =>
          simp [canonicalPoint, mixtureMap, coordinateMean, pairedLift]
  | cast i =>
      simp [canonicalPoint, mixtureMap, coordinateMean, pairedLift]

/-- A data-only direction rule cannot distinguish the paired hidden-bit worlds
with failure below their Gaussian overlap. No eigenvector or measurability
assumption is imposed on the rule. -/
theorem coordinateMean_balanced_partitionFailure_lower
    (m n : ℕ)
    (directionRule : (Fin (m + 2) → Fin (n + 1) → ℝ) → Fin (n + 1) → ℝ)
    {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloor r ≤
      balancedGaussianBitOuter (latentNoiseCoordinateSideMeasure (m + 1) n) r
        {p | let omega := pairedLift m n r p.1 p.2
          let X := fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1)))
              (pairedLift m n r true p.2) i
          let direction := directionRule X
          ¬ MakesAtMostPartitionErrorsUpToSwap
              (fun i ↦ canonicalLabel omega i) direction X budget ∨
            ¬ ∀ i, canonicalLabel omega i = -1 ∨ canonicalLabel omega i = 1} := by
  let side := latentNoiseCoordinateSideMeasure (m + 1) n
  let mean := coordinateMean r (0 : Fin (n + 1))
  let target : Fin (m + 2) := Fin.last (m + 1)
  let reference : Fin (m + 2) := (0 : Fin (m + 1)).castSucc
  let omega : Bool → ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))) →
      Fin (m + 2) → ℝ × (Fin (n + 1) → ℝ) :=
    fun theta z ↦ pairedLift m n r theta z
  let X : ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))) →
      Fin (m + 2) → Fin (n + 1) → ℝ :=
    fun z i ↦ canonicalPoint mean (omega true z) i
  let direction : ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))) → Fin (n + 1) → ℝ :=
    fun z ↦ directionRule (X z)
  let oracle : ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))) → Bool :=
    fun s ↦ decide ((s.2 (0 : Fin (m + 1))).1 = 1)
  let sameCluster : Set (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :=
    {z | (0 < dotProduct (direction z) (X z target)) ↔
      (0 < dotProduct (direction z) (X z reference))}
  let success : Bool → Set (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :=
    fun theta ↦ {z |
      MakesAtMostPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel (omega theta z) i)
        (direction z) (X z) budget ∧
      ∀ i, canonicalLabel (omega theta z) i = -1 ∨
        canonicalLabel (omega theta z) i = 1}
  have hsuccess : ∀ theta z, z ∈ success theta →
      (z ∈ sameCluster ↔ theta = oracle z.2) := by
    intro theta z hz
    rcases hz with ⟨hpartition, hlabels⟩
    have hrel := sameCluster_iff_labels_eq_of_partitionErrors_lt_one
      (fun i ↦ canonicalLabel (omega theta z) i)
      (direction z) (X z) hlabels hbudget hpartition target reference
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
  let bad : Set (Bool × (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))))) :=
    {p | ¬ MakesAtMostPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel (omega p.1 p.2) i)
        (direction p.2) (X p.2) budget ∨
      ¬ ∀ i, canonicalLabel (omega p.1 p.2) i = -1 ∨
        canonicalLabel (omega p.1 p.2) i = 1}
  have hevent : {p | p.2 ∉ success p.1} = bad := by
    ext p
    simp only [success, bad, Set.mem_setOf_eq, not_and_or]
  have hbad : gaussianIntervalFloor r ≤
      balancedGaussianBitOuter side r bad := by
    rw [← hevent]
    exact htest
  simpa [bad, side, omega, X, direction, mean] using hbad

/-- The data-only balanced obstruction transported back to the canonical
latent sample law.  This successor-indexed form is the exact transport core. -/
theorem coordinateMean_canonical_partitionFailure_lower_succ
    (m n : ℕ)
    (directionRule : (Fin (m + 2) → Fin (n + 1) → ℝ) → Fin (n + 1) → ℝ)
    {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloor r ≤
      latentNoiseSampleMeasure (m + 2) (n + 1)
        {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel ω i)
          (directionRule (fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) ω i))
          (fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) ω i)
          budget} := by
  let side := latentNoiseCoordinateSideMeasure (m + 1) n
  let mean := coordinateMean r (0 : Fin (n + 1))
  let e := latentNoiseCoordinateSplitEquiv
    (Fin.last (m + 1)) (0 : Fin (n + 1))
  let μ := latentNoiseSampleMeasure (m + 2) (n + 1)
  let raw := rademacherPMF.toMeasure.prod ((gaussianReal 0 1).prod side)
  let F : ℝ × (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) →
      Bool × (ℝ × ((Fin n → ℝ) ×
        (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))) :=
    fun w ↦ (decide (w.1 = 1), (r * w.1 + w.2.1, w.2.2))
  let A : Set (Bool × (ℝ × ((Fin n → ℝ) ×
      (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))))) :=
    {p | let ω := pairedLift m n r p.1 p.2
      let X := fun i ↦ canonicalPoint mean (pairedLift m n r true p.2) i
      let direction := directionRule X
      ¬ MakesAtMostPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel ω i) direction X budget ∨
        ¬ ∀ i, canonicalLabel ω i = -1 ∨ canonicalLabel ω i = 1}
  let sourceBad : Set (Fin (m + 2) → ℝ × (Fin (n + 1) → ℝ)) :=
    {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
      (fun i ↦ canonicalLabel ω i)
      (directionRule (fun i ↦ canonicalPoint mean ω i))
      (fun i ↦ canonicalPoint mean ω i) budget}
  let labelBad : Set (Fin (m + 2) → ℝ × (Fin (n + 1) → ℝ)) :=
    {ω | ¬ ∀ i, canonicalLabel ω i = -1 ∨ canonicalLabel ω i = 1}
  let P := F ⁻¹' A
  let Q := e '' (sourceBad ∪ labelBad)
  have hbalanced : gaussianIntervalFloor r ≤
      balancedGaussianBitOuter side r A := by
    simpa [A, side, mean] using
      coordinateMean_balanced_partitionFailure_lower m n directionRule hr hbudget
  have hraw : gaussianIntervalFloor r ≤ raw P := by
    calc
      gaussianIntervalFloor r ≤ balancedGaussianBitOuter side r A := hbalanced
      _ = raw P := by
        symm
        simpa [raw, F, P] using
          balancedGaussianBitOuter_apply_eq_rademacher side r A
  have hpos : (Prod.mk (1 : ℝ)) ⁻¹' P ⊆ (Prod.mk (1 : ℝ)) ⁻¹' Q := by
    intro z hz
    let z' : ℝ × ((Fin n → ℝ) ×
        (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))) :=
      (r + z.1, z.2)
    let ω := pairedLift m n r true z'
    have hA : (true, z') ∈ A := by
      simpa [P, F, z', add_comm] using hz
    have hUnion : ω ∈ sourceBad ∪ labelBad := by
      simpa [A, sourceBad, labelBad, ω, z', mean] using hA
    refine ⟨ω, hUnion, ?_⟩
    dsimp [ω]
    rw [pairedLift_eq_split_symm]
    norm_num [e, z', rademacherValue]
  have hneg : (Prod.mk (-1 : ℝ)) ⁻¹' P ⊆ (Prod.mk (-1 : ℝ)) ⁻¹' Q := by
    intro z hz
    let z' : ℝ × ((Fin n → ℝ) ×
        (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ))) :=
      (-r + z.1, z.2)
    let ω := pairedLift m n r false z'
    have hA : (false, z') ∈ A := by
      norm_num [P, F, z'] at hz ⊢
      exact hz
    have hX : (fun i ↦ canonicalPoint mean
        (pairedLift m n r true z') i) =
        (fun i ↦ canonicalPoint mean ω i) := by
      simpa [mean, ω] using pairedLift_canonicalPoint_eq m n r true false z'
    have hUnion : ω ∈ sourceBad ∪ labelBad := by
      simpa [A, sourceBad, labelBad, ω, z', mean, hX] using hA
    refine ⟨ω, hUnion, ?_⟩
    dsimp [ω]
    rw [pairedLift_eq_split_symm]
    norm_num [e, z', rademacherValue]
  have hPQ : raw P ≤ raw Q := by
    change raw.toOuterMeasure P ≤ raw.toOuterMeasure Q
    change (rademacherPMF.toMeasure.prod
      ((gaussianReal 0 1).prod side)).toOuterMeasure P ≤
      (rademacherPMF.toMeasure.prod
      ((gaussianReal 0 1).prod side)).toOuterMeasure Q
    rw [rademacher_prod_toOuterMeasure]
    simp only [OuterMeasure.add_apply, OuterMeasure.smul_apply,
      OuterMeasure.map_apply]
    exact add_le_add (mul_le_mul_right (measure_mono hpos) _)
      (mul_le_mul_right (measure_mono hneg) _)
  have hsplit : μ (sourceBad ∪ labelBad) = raw Q := by
    simpa [μ, raw, Q, e, side, latentNoiseCoordinateSplitEquiv',
      latentNoiseCoordinateResidualMeasure] using
      latentNoiseSampleMeasure_apply_split'_outer
        (Fin.last (m + 1)) (0 : Fin (n + 1)) (sourceBad ∪ labelBad)
  have hlabelZero : μ labelBad = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [canonicalLabels_ae_eq_neg_one_or_one (m + 2) (n + 1)] with ω hω
    exact not_not_intro hω
  have hunion_le : μ (sourceBad ∪ labelBad) ≤ μ sourceBad := by
    calc
      μ (sourceBad ∪ labelBad) ≤ μ sourceBad + μ labelBad := measure_union_le _ _
      _ = μ sourceBad := by rw [hlabelZero, add_zero]
  have hsource : gaussianIntervalFloor r ≤ μ sourceBad := by
    calc
      gaussianIntervalFloor r ≤ raw P := hraw
      _ ≤ raw Q := hPQ
      _ = μ (sourceBad ∪ labelBad) := hsplit.symm
      _ ≤ μ sourceBad := hunion_le
  simpa [μ, sourceBad, mean] using hsource

/-- Real-valued outer-measure evaluation of the successor-indexed transport
core. Measurability is not required for this failure-set lower bound. -/
theorem coordinateMean_canonical_partitionFailure_real_lower_succ
    (m n : ℕ)
    (directionRule : (Fin (m + 2) → Fin (n + 1) → ℝ) → Fin (n + 1) → ℝ)
    {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloorReal r ≤
      (latentNoiseSampleMeasure (m + 2) (n + 1)).real
        {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel ω i)
          (directionRule (fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) ω i))
          (fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) ω i)
          budget} := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure (m + 2) (n + 1)) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  rw [← gaussianIntervalFloor_toReal, Measure.real_def]
  exact ENNReal.toReal_mono (measure_ne_top _ _)
    (coordinateMean_canonical_partitionFailure_lower_succ
      m n directionRule hr hbudget)

/-- The data-only coordinate-signal lower bound at arbitrary sample and
ambient dimensions satisfying the natural nondegeneracy hypotheses. -/
theorem coordinateMean_canonical_partitionFailure_real_lower
    {m n : ℕ} (hm2 : 2 ≤ m) (hn : 0 < n) (r budget : ℝ)
    (directionRule : (Fin m → Fin n → ℝ) → Fin n → ℝ)
    (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloorReal r ≤
      (latentNoiseSampleMeasure m n).real
        {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel ω i)
          (directionRule (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i))
          (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i)
          budget} := by
  obtain ⟨m', rfl⟩ := Nat.exists_eq_add_of_le' hm2
  obtain ⟨n', rfl⟩ := Nat.exists_eq_add_of_le'
    (show 1 ≤ n from hn)
  simpa using coordinateMean_canonical_partitionFailure_real_lower_succ
    m' n' directionRule hr hbudget

/-- Every null-measurable event certifying successful recovery has probability
at most one minus the Gaussian overlap. The recovery set itself and the
direction selector need not be measurable: its complement contains the
failure set, so the arbitrary-set lower bound still applies. -/
theorem coordinateMean_canonical_partitionCertificate_real_upper
    {m n : ℕ} (hm2 : 2 ≤ m) (hn : 0 < n) (r budget : ℝ)
    (directionRule : (Fin m → Fin n → ℝ) → Fin n → ℝ)
    (hr : 0 ≤ r) (hbudget : budget < 1)
    (good : Set (Fin m → ℝ × (Fin n → ℝ)))
    (hgood : NullMeasurableSet good (latentNoiseSampleMeasure m n))
    (hcertificate : ∀ ω ∈ good, MakesAtMostPartitionErrorsUpToSwap
      (fun i ↦ canonicalLabel ω i)
      (directionRule (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i))
      (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i) budget) :
    (latentNoiseSampleMeasure m n).real good ≤
      1 - gaussianIntervalFloorReal r := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  have hlower := coordinateMean_canonical_partitionFailure_real_lower
    hm2 hn r budget directionRule hr hbudget
  have hsubset :
      {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel ω i)
        (directionRule (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i))
        (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i) budget} ⊆ goodᶜ := by
    intro ω hfailure hmem
    exact hfailure (hcertificate ω hmem)
  have hbound := hlower.trans (measureReal_mono hsubset (measure_ne_top _ _))
  rw [probReal_compl_eq_one_sub₀ hgood] at hbound
  linarith

/-- For a null-measurable success event, the outer failure lower bound gives
a genuine success-probability upper bound by complementation. This applies
to every direction rule depending only on the observed point array. -/
theorem coordinateMean_canonical_partitionSuccess_real_upper
    {m n : ℕ} (hm2 : 2 ≤ m) (hn : 0 < n) (r budget : ℝ)
    (directionRule : (Fin m → Fin n → ℝ) → Fin n → ℝ)
    (hr : 0 ≤ r) (hbudget : budget < 1)
    (hSuccess : NullMeasurableSet
      {ω | MakesAtMostPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel ω i)
        (directionRule (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i))
        (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i) budget}
      (latentNoiseSampleMeasure m n)) :
    (latentNoiseSampleMeasure m n).real
      {ω | MakesAtMostPartitionErrorsUpToSwap
        (fun i ↦ canonicalLabel ω i)
        (directionRule (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i))
        (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i) budget} ≤
      1 - gaussianIntervalFloorReal r := by
  exact coordinateMean_canonical_partitionCertificate_real_upper
    hm2 hn r budget directionRule hr hbudget _ hSuccess (fun _ hω ↦ hω)

/-- Leading-eigenvector specialization of the data-only Gaussian testing bound. -/
theorem coordinateMean_balanced_spectral_partitionFailure_lower
    (m n : ℕ) {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloor r ≤
      balancedGaussianBitOuter (latentNoiseCoordinateSideMeasure (m + 1) n) r
        {p | let omega := pairedLift m n r p.1 p.2
          let X := fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1)))
              (pairedLift m n r true p.2) i
          let direction := fun j ↦
            NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
              (Nat.succ_pos n) X j
          ¬ MakesAtMostPartitionErrorsUpToSwap
              (fun i ↦ canonicalLabel omega i) direction X budget ∨
            ¬ ∀ i, canonicalLabel omega i = -1 ∨ canonicalLabel omega i = 1} := by
  exact coordinateMean_balanced_partitionFailure_lower m n
    (fun X j ↦ NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
      (Nat.succ_pos n) X j) hr hbudget

/-- Leading-eigenvector specialization of the data-only Gaussian testing bound. -/
theorem coordinateMean_canonical_spectral_partitionFailure_lower_succ
    (m n : ℕ) {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloor r ≤
      latentNoiseSampleMeasure (m + 2) (n + 1)
        {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel ω i)
          (fun j ↦
            NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
              (Nat.succ_pos n)
              (fun i ↦ canonicalPoint
                (coordinateMean r (0 : Fin (n + 1))) ω i) j)
          (fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) ω i)
          budget} := by
  exact coordinateMean_canonical_partitionFailure_lower_succ m n
    (fun X j ↦ NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
      (Nat.succ_pos n) X j) hr hbudget

/-- Leading-eigenvector specialization of the data-only Gaussian testing bound. -/
theorem coordinateMean_canonical_spectral_partitionFailure_real_lower_succ
    (m n : ℕ) {r budget : ℝ} (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloorReal r ≤
      (latentNoiseSampleMeasure (m + 2) (n + 1)).real
        {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel ω i)
          (fun j ↦
            NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
              (Nat.succ_pos n)
              (fun i ↦ canonicalPoint
                (coordinateMean r (0 : Fin (n + 1))) ω i) j)
          (fun i ↦ canonicalPoint
            (coordinateMean r (0 : Fin (n + 1))) ω i)
          budget} := by
  exact coordinateMean_canonical_partitionFailure_real_lower_succ m n
    (fun X j ↦ NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
      (Nat.succ_pos n) X j) hr hbudget

/-- Leading-eigenvector specialization of the data-only Gaussian testing bound. -/
theorem coordinateMean_canonical_spectral_partitionFailure_real_lower
    {m n : ℕ} (hm2 : 2 ≤ m) (hn : 0 < n) (r budget : ℝ)
    (hr : 0 ≤ r) (hbudget : budget < 1) :
    gaussianIntervalFloorReal r ≤
      (latentNoiseSampleMeasure m n).real
        {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel ω i)
          (fun j ↦
            NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
              hn
              (fun i ↦ canonicalPoint
                (coordinateMean r ⟨0, hn⟩) ω i) j)
          (fun i ↦ canonicalPoint (coordinateMean r ⟨0, hn⟩) ω i)
          budget} := by
  exact coordinateMean_canonical_partitionFailure_real_lower hm2 hn r budget
    (fun X j ↦ NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
      hn X j) hr hbudget

end NumStability.HDP.Vector.GaussianMixture
