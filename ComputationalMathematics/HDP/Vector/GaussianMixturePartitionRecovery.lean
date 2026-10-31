import ComputationalMathematics.HDP.Vector.GaussianMixtureRecovery

/-!
# Source-level partition semantics for Gaussian-mixture clustering

The book assigns a zero score to the second cluster and regards the two output
cluster names as interchangeable.  The existing margin-based recovery API uses
the stronger event obtained by changing the sign of the classifier direction;
at an exact zero that stronger event counts an error in both orientations.  This
module records the literal partition semantics and the implication from the
stronger event used by the probability proof.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Vector.GaussianMixture

/-- Errors for the book's partition rule after declaring `firstLabel` to be
the latent label represented by the positive-score output cluster. -/
def partitionMisclassifiedIndices {m n : ℕ} (labels : Fin m → ℝ)
    (firstLabel : ℝ) (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ) :
    Set (Fin m) :=
  {i | ¬ ((0 < dotProduct v (X i)) ↔ labels i = firstLabel)}

/-- The source's clustering guarantee: the positive-score cluster may
represent either latent community, so the output is compared up to one global
swap of the two cluster names. -/
def MakesAtMostPartitionErrorsUpToSwap {m n : ℕ} (labels : Fin m → ℝ)
    (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ) (budget : ℝ) : Prop :=
  ∃ firstLabel : ℝ, (firstLabel = -1 ∨ firstLabel = 1) ∧
    (Set.ncard (partitionMisclassifiedIndices labels firstLabel v X) : ℝ) ≤
      budget

/-- Enlarging the permitted error budget preserves a literal up-to-swap
partition guarantee. -/
theorem makesAtMostPartitionErrorsUpToSwap_mono {m n : ℕ}
    (labels : Fin m → ℝ) (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ)
    {budget budget' : ℝ}
    (h : MakesAtMostPartitionErrorsUpToSwap labels v X budget)
    (hbudget : budget ≤ budget') :
    MakesAtMostPartitionErrorsUpToSwap labels v X budget' := by
  rcases h with ⟨firstLabel, hfirstLabel, hcount⟩
  exact ⟨firstLabel, hfirstLabel, hcount.trans hbudget⟩

/-- The margin API's sign-oriented error event implies the literal source
partition event.  The implication also resolves the source's `score = 0`
boundary: the source puts such a point in the second cluster, whereas the
margin event conservatively counts it as an error in either orientation. -/
theorem makesAtMostErrorsUpToSign_implies_partitionErrorsUpToSwap
    {m n : ℕ} (labels : Fin m → ℝ) (v : Fin n → ℝ)
    (X : Fin m → Fin n → ℝ) (budget : ℝ)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (h : MakesAtMostErrorsUpToSign labels v X budget) :
    MakesAtMostPartitionErrorsUpToSwap labels v X budget := by
  rcases h with ⟨s, hs, hcount⟩
  rcases hs with rfl | rfl
  · refine ⟨-1, Or.inl rfl, ?_⟩
    apply le_trans (Nat.cast_le.mpr (Set.ncard_mono ?_)) hcount
    intro i hi
    change ¬ ((0 < dotProduct v (X i)) ↔ labels i = -1) at hi
    change labels i * dotProduct ((-1 : ℝ) • v) (X i) ≤ 0
    rcases hlabels i with hlabel | hlabel
    · rw [hlabel]
      rw [smul_dotProduct]
      simp only [smul_eq_mul]
      by_cases hscore : 0 < dotProduct v (X i)
      · exfalso
        apply hi
        simp [hscore, hlabel]
      · have hscore' := le_of_not_gt hscore
        nlinarith
    · rw [hlabel]
      rw [smul_dotProduct]
      simp only [smul_eq_mul]
      by_cases hscore : 0 < dotProduct v (X i)
      · nlinarith
      · exfalso
        apply hi
        simp [hscore, hlabel] ; norm_num
  · refine ⟨1, Or.inr rfl, ?_⟩
    apply le_trans (Nat.cast_le.mpr (Set.ncard_mono ?_)) hcount
    intro i hi
    change ¬ ((0 < dotProduct v (X i)) ↔ labels i = 1) at hi
    change labels i * dotProduct ((1 : ℝ) • v) (X i) ≤ 0
    rcases hlabels i with hlabel | hlabel
    · rw [hlabel]
      simp only [one_smul]
      by_cases hscore : 0 < dotProduct v (X i)
      · nlinarith
      · exfalso
        apply hi
        simp [hscore, hlabel] ; norm_num
    · rw [hlabel]
      simp only [one_smul]
      by_cases hscore : 0 < dotProduct v (X i)
      · exfalso
        apply hi
        simp [hscore, hlabel]
      · have hscore' := le_of_not_gt hscore
        nlinarith

/-- If the real-valued error budget is strictly below one, literal partition
recovery forces the output to preserve the equality relation between any two
rows whose latent labels are binary.  No support hypothesis is needed for the
other rows. -/
theorem sameCluster_iff_labels_eq_of_partitionErrors_lt_one_at
    {m n : ℕ} (labels : Fin m → ℝ) (v : Fin n → ℝ)
    (X : Fin m → Fin n → ℝ) {budget : ℝ}
    (hbudget : budget < 1)
    (h : MakesAtMostPartitionErrorsUpToSwap labels v X budget)
    (i j : Fin m) (hiLabel : labels i = -1 ∨ labels i = 1)
    (hjLabel : labels j = -1 ∨ labels j = 1) :
    ((0 < dotProduct v (X i)) ↔ (0 < dotProduct v (X j))) ↔
      labels i = labels j := by
  rcases h with ⟨firstLabel, hfirst, hcount⟩
  have hcardlt : Set.ncard
      (partitionMisclassifiedIndices labels firstLabel v X) < 1 := by
    have hcastlt : (Set.ncard
        (partitionMisclassifiedIndices labels firstLabel v X) : ℝ) < 1 :=
      hcount.trans_lt hbudget
    exact_mod_cast hcastlt
  have hempty : partitionMisclassifiedIndices labels firstLabel v X = ∅ := by
    rw [← Set.ncard_eq_zero]
    omega
  have hi : (0 < dotProduct v (X i)) ↔ labels i = firstLabel := by
    have : i ∉ partitionMisclassifiedIndices labels firstLabel v X := by
      rw [hempty]
      simp
    simpa [partitionMisclassifiedIndices] using this
  have hj : (0 < dotProduct v (X j)) ↔ labels j = firstLabel := by
    have : j ∉ partitionMisclassifiedIndices labels firstLabel v X := by
      rw [hempty]
      simp
    simpa [partitionMisclassifiedIndices] using this
  rw [hi, hj]
  rcases hfirst with rfl | rfl <;>
    rcases hiLabel with hiLabel | hiLabel <;>
      rcases hjLabel with hjLabel | hjLabel <;>
        simp [hiLabel, hjLabel] <;> norm_num

/-- If the real-valued error budget is strictly below one, literal partition
recovery forces the output to preserve the equality relation between every
pair of binary latent labels. -/
theorem sameCluster_iff_labels_eq_of_partitionErrors_lt_one
    {m n : ℕ} (labels : Fin m → ℝ) (v : Fin n → ℝ)
    (X : Fin m → Fin n → ℝ) {budget : ℝ}
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (hbudget : budget < 1)
    (h : MakesAtMostPartitionErrorsUpToSwap labels v X budget)
    (i j : Fin m) :
    ((0 < dotProduct v (X i)) ↔ (0 < dotProduct v (X j))) ↔
      labels i = labels j :=
  sameCluster_iff_labels_eq_of_partitionErrors_lt_one_at labels v X
    hbudget h i j (hlabels i) (hlabels j)

/-- With literal up-to-swap partition semantics, every binary partition makes
at most half of the labels wrong after the better global naming is chosen. -/
theorem makesAtMostPartitionErrorsUpToSwap_half {m n : ℕ}
    (labels : Fin m → ℝ) (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1) :
    MakesAtMostPartitionErrorsUpToSwap labels v X ((m : ℝ) / 2) := by
  let A : Set (Fin m) := partitionMisclassifiedIndices labels 1 v X
  let B : Set (Fin m) := partitionMisclassifiedIndices labels (-1) v X
  have hB : B = Aᶜ := by
    ext i
    rcases hlabels i with hlabel | hlabel
    · by_cases hscore : 0 < dotProduct v (X i) <;>
        simp [A, B, partitionMisclassifiedIndices, hlabel, hscore] <;> norm_num
    · by_cases hscore : 0 < dotProduct v (X i) <;>
        simp [A, B, partitionMisclassifiedIndices, hlabel, hscore] <;> norm_num
  have hsum : A.ncard + B.ncard = m := by
    rw [hB, Set.ncard_add_ncard_compl]
    simp
  have hhalf : 2 * A.ncard ≤ m ∨ 2 * B.ncard ≤ m := by omega
  rcases hhalf with hA | hBcard
  · refine ⟨1, Or.inr rfl, ?_⟩
    change (A.ncard : ℝ) ≤ (m : ℝ) / 2
    have hAreal : 2 * (A.ncard : ℝ) ≤ (m : ℝ) := by exact_mod_cast hA
    linarith
  · refine ⟨-1, Or.inl rfl, ?_⟩
    change (B.ncard : ℝ) ≤ (m : ℝ) / 2
    have hBreal : 2 * (B.ncard : ℝ) ≤ (m : ℝ) := by exact_mod_cast hBcard
    linarith

/-- Any error tolerance at least one half is therefore automatic under the
source's up-to-swap interpretation. -/
theorem makesAtMostPartitionErrorsUpToSwap_of_half_le {m n : ℕ}
    (labels : Fin m → ℝ) (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1) {epsilon : ℝ}
    (hepsilon : 1 / 2 ≤ epsilon) :
    MakesAtMostPartitionErrorsUpToSwap labels v X (epsilon * m) := by
  rcases makesAtMostPartitionErrorsUpToSwap_half labels v X hlabels with
    ⟨firstLabel, hfirstLabel, hcount⟩
  refine ⟨firstLabel, hfirstLabel, hcount.trans ?_⟩
  have hm : 0 ≤ (m : ℝ) := Nat.cast_nonneg m
  nlinarith

/-- Without any signal or sample-size assumptions, the canonical binary labels
are classified correctly up to a global cluster swap on at least half of the
sample.  Thus the failure event for the enlarged tolerance
`max epsilon (1 / 2)` is null.  This is the conclusion-only weakening used to
record the unconditional part of the source theorem when its printed
quantitative hypotheses do not support the printed `epsilon`-error bound. -/
theorem canonicalSpectralClustering_partition_max_half_failure_measure_zero
    {m n : ℕ} (hn : 0 < n) (mean : Fin n → ℝ) (epsilon : ℝ) :
    (latentNoiseSampleMeasure m n).real
        {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
          (fun i ↦ canonicalLabel ω i)
          (fun j ↦
            NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
              hn (fun i ↦ canonicalPoint mean ω i) j)
          (fun i ↦ canonicalPoint mean ω i)
          (max epsilon (1 / 2) * m)} = 0 := by
  let mu := latentNoiseSampleMeasure m n
  let labels : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → ℝ :=
    fun ω i ↦ canonicalLabel ω i
  let X : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → Fin n → ℝ :=
    fun ω i ↦ canonicalPoint mean ω i
  let direction : (Fin m → ℝ × (Fin n → ℝ)) → Fin n → ℝ :=
    fun ω j ↦
      NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
        hn (X ω) j
  let sourceBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
      (labels ω) (direction ω) (X ω) (max epsilon (1 / 2) * m)}
  let labelBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1}
  have hlabelZero : mu labelBad = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
    change ¬ ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1
    exact not_not_intro hω
  have hsubset : sourceBad ⊆ labelBad := by
    intro ω hsource
    change ¬ MakesAtMostPartitionErrorsUpToSwap
      (labels ω) (direction ω) (X ω) (max epsilon (1 / 2) * m) at hsource
    change ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1
    intro hlabels
    apply hsource
    apply makesAtMostPartitionErrorsUpToSwap_mono
      (labels ω) (direction ω) (X ω)
      (makesAtMostPartitionErrorsUpToSwap_half
        (labels ω) (direction ω) (X ω) hlabels)
    have hm : 0 ≤ (m : ℝ) := Nat.cast_nonneg m
    calc
      (m : ℝ) / 2 = (1 / 2 : ℝ) * m := by ring
      _ ≤ max epsilon (1 / 2) * m :=
        mul_le_mul_of_nonneg_right (le_max_right epsilon (1 / 2)) hm
  have hsourceZero : mu sourceBad = 0 :=
    measure_mono_null hsubset hlabelZero
  change mu.real sourceBad = 0
  rw [Measure.real_def, hsourceZero]
  simp

/-- The assembled finite-sample theorem, translated from the stronger margin
event to the book's literal partition and cluster-swap semantics. -/
theorem exists_canonicalSpectralClustering_partition_four_exp_tail_of_thresholds :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
        ∀ (epsilon : ℝ),
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let delta : ℝ := C *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) +
              Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
          let q : ℝ := L ^ 2 * max delta (delta ^ 2)
          4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2 →
          (2 * Real.sqrt q) ^ 2 *
              ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
            epsilon / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2 →
          Real.exp (-2 * (m : ℝ) *
              (epsilon / 2 -
                4 * Real.exp
                  (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) ≤
            2 * Real.exp (-(n : ℝ)) →
          (latentNoiseSampleMeasure m n).real
              {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
                (fun i ↦ canonicalLabel ω i)
                (fun j ↦
                  NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
                    hn (fun i ↦ canonicalPoint mean ω i) j)
                (fun i ↦ canonicalPoint mean ω i) (epsilon * m)} ≤
            4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, hold⟩ :=
    exists_canonicalSpectralClustering_four_exp_tail_of_thresholds
  refine ⟨C, hC, ?_⟩
  intro m n hm hn mean hmean epsilon
  dsimp only
  intro hidealScale hbudget hidealTail
  let mu := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure mu :=
    ⟨by simp [mu, latentNoiseSampleMeasure]⟩
  let labels : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → ℝ :=
    fun ω i ↦ canonicalLabel ω i
  let X : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → Fin n → ℝ :=
    fun ω i ↦ canonicalPoint mean ω i
  let direction : (Fin m → ℝ × (Fin n → ℝ)) → Fin n → ℝ :=
    fun ω j ↦
      NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
        hn (X ω) j
  let oldBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ MakesAtMostErrorsUpToSign (labels ω) (direction ω) (X ω)
      (epsilon * m)}
  let sourceBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
      (labels ω) (direction ω) (X ω) (epsilon * m)}
  let labelBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1}
  have holdTail : mu.real oldBad ≤ 4 * Real.exp (-(n : ℝ)) := by
    simpa [mu, oldBad, labels, direction, X] using
      hold hm hn mean hmean epsilon hidealScale hbudget hidealTail
  have hlabelZero : mu labelBad = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
    change ¬ ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1
    exact not_not_intro hω
  have hlabelRealZero : mu.real labelBad = 0 := by
    rw [Measure.real_def, hlabelZero]
    simp
  have hsubset : sourceBad ⊆ oldBad ∪ labelBad := by
    intro ω hsource
    by_contra hnot
    rw [Set.mem_union, not_or] at hnot
    have hlabels : ∀ i, labels ω i = -1 ∨ labels ω i = 1 := by
      exact not_not.mp hnot.2
    have holdGood : MakesAtMostErrorsUpToSign
        (labels ω) (direction ω) (X ω) (epsilon * m) := by
      exact not_not.mp hnot.1
    exact hsource
      (makesAtMostErrorsUpToSign_implies_partitionErrorsUpToSwap
        (labels ω) (direction ω) (X ω) (epsilon * m) hlabels holdGood)
  change mu.real sourceBad ≤ 4 * Real.exp (-(n : ℝ))
  calc
    mu.real sourceBad ≤ mu.real (oldBad ∪ labelBad) :=
      measureReal_mono hsubset (measure_ne_top _ _)
    _ ≤ mu.real oldBad + mu.real labelBad := measureReal_union_le _ _
    _ ≤ 4 * Real.exp (-(n : ℝ)) := by
      rw [hlabelRealZero, add_zero]
      exact holdTail

end NumStability.HDP.Vector.GaussianMixture
