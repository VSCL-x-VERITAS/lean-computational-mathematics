import ComputationalMathematics.HDP.Probability.GaussianOverlap

/-!
# Balanced Gaussian binary testing

Reusable outer-measure models for a balanced latent bit observed through two
translated Gaussian laws. The partition-failure bounds allow arbitrary side
information and do not assume that the decision or success sets are measurable.
-/

open Set MeasureTheory
open scoped ENNReal NNReal Real

namespace NumStability.HDP.Probability

open ProbabilityTheory

/-- The balanced outer law with conditional observations
`N(r,1) × nu` and `N(-r,1) × nu`.  Keeping this as an outer measure makes
evaluation on arbitrary, possibly nonmeasurable events definitional. -/
noncomputable def balancedGaussianBitOuter
    {S : Type*} [MeasurableSpace S] (nu : Measure S) (r : ℝ) :
    OuterMeasure (Bool × (ℝ × S)) :=
  (2 : ℝ≥0∞)⁻¹ •
    (OuterMeasure.map (fun z : ℝ × S ↦ (true, z))
        ((gaussianReal r 1).prod nu).toOuterMeasure +
      OuterMeasure.map (fun z : ℝ × S ↦ (false, z))
        ((gaussianReal (-r) 1).prod nu).toOuterMeasure)

@[simp] theorem balancedGaussianBitOuter_apply_univ
    {S : Type*} [MeasurableSpace S] (nu : Measure S) [SFinite nu]
    [IsProbabilityMeasure nu] (r : ℝ) :
    balancedGaussianBitOuter nu r Set.univ = 1 := by
  simp [balancedGaussianBitOuter, OuterMeasure.map_apply]
  exact ENNReal.inv_two_add_inv_two

/-- A balanced latent bit cannot be recovered through an arbitrary partition
relation with failure probability below the overlap of the two conditional
Gaussian laws.  The side information, oracle, partition, and success sets need
not be measurable. -/
theorem gaussianReal_prod_balanced_partitionFailure_lower
    {S : Type*} [MeasurableSpace S] (nu : Measure S) [SFinite nu]
    [IsProbabilityMeasure nu] {r : ℝ} (hr : 0 ≤ r)
    (oracle : S → Bool) (sameCluster : Set (ℝ × S))
    (success : Bool → Set (ℝ × S))
    (hsuccess : ∀ theta z, z ∈ success theta →
      (z ∈ sameCluster ↔ theta = oracle z.2)) :
    gaussianIntervalFloor r ≤
      ((gaussianReal r 1).prod nu (success true)ᶜ +
        (gaussianReal (-r) 1).prod nu (success false)ᶜ) / 2 := by
  let decision : Set (ℝ × S) :=
    {z | (z ∈ sameCluster ↔ oracle z.2 = true)}
  have hpos : decisionᶜ ⊆ (success true)ᶜ := by
    intro z hz hzs
    apply hz
    change z ∈ sameCluster ↔ oracle z.2 = true
    have hs := hsuccess true z hzs
    change z ∈ sameCluster ↔ true = oracle z.2 at hs
    cases h : oracle z.2 <;> simp [h] at hs ⊢ <;> exact hs
  have hneg : decision ⊆ (success false)ᶜ := by
    intro z hz hzs
    have hs := hsuccess false z hzs
    change z ∈ sameCluster ↔ oracle z.2 = true at hz
    change z ∈ sameCluster ↔ false = oracle z.2 at hs
    cases h : oracle z.2 with
    | false =>
        simp [h] at hz hs
        exact hz hs
    | true =>
        simp [h] at hz hs
        exact hs hz
  apply (ENNReal.le_div_iff_mul_le (Or.inl (by norm_num))
    (Or.inl (by norm_num))).2
  rw [mul_comm]
  exact (gaussianReal_prod_binaryTestingError_lower nu hr decision).trans
    (add_le_add (measure_mono hpos) (measure_mono hneg))

/-- Outer-measure form of
`gaussianReal_prod_balanced_partitionFailure_lower`. -/
theorem gaussianReal_prod_balanced_partitionFailure_outer_lower
    {S : Type*} [MeasurableSpace S] (nu : Measure S) [SFinite nu]
    [IsProbabilityMeasure nu] {r : ℝ} (hr : 0 ≤ r)
    (oracle : S → Bool) (sameCluster : Set (ℝ × S))
    (success : Bool → Set (ℝ × S))
    (hsuccess : ∀ theta z, z ∈ success theta →
      (z ∈ sameCluster ↔ theta = oracle z.2)) :
    gaussianIntervalFloor r ≤
      balancedGaussianBitOuter nu r
        {omega | omega.2 ∉ success omega.1} := by
  have h := gaussianReal_prod_balanced_partitionFailure_lower
    nu hr oracle sameCluster success hsuccess
  simp only [balancedGaussianBitOuter, OuterMeasure.smul_apply,
    OuterMeasure.add_apply, OuterMeasure.map_apply,
    Measure.toOuterMeasure_apply, smul_eq_mul]
  change gaussianIntervalFloor r ≤
    (2 : ℝ≥0∞)⁻¹ *
      ((gaussianReal r 1).prod nu (success true)ᶜ +
        (gaussianReal (-r) 1).prod nu (success false)ᶜ)
  simpa [ENNReal.div_eq_inv_mul] using h

end NumStability.HDP.Probability
