import ComputationalMathematics.HDP.Vector.GaussianMixtureLinearPerturbation
import ComputationalMathematics.HDP.Vector.GaussianMixturePartitionRecovery
import ComputationalMathematics.HDP.Probability.BinaryTesting

/-!
# Uniform threshold certificates for every unit top empirical direction

The sufficient-threshold guarantee is simultaneous over all unit top vectors,
including arbitrary choices inside tied eigenspaces. Its single measurable
certificate depends on covariance deviation, ideal margins and binary labels,
not on a chosen eigenvector or a data-only selection rule. No measurability of
such a rule or of the full simultaneous success set is assumed. These are
explicit sufficient-threshold results, with no derivation from other premises.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped BigOperators RealInnerProductSpace

namespace NumStability.HDP.Vector.GaussianMixture

/-- Every unit vector at the largest empirical eigenvalue is allowed. The
ordered eigenvalue names a value, not a particular eigenbasis vector. -/
def IsUnitTopEmpiricalEigenvector {m n : ℕ} (hn : 0 < n)
    (X : Fin m → Fin n → ℝ) (v : EuclideanSpace ℝ (Fin n)) : Prop :=
  ‖v‖ = 1 ∧ (EuclideanSpectralClustering.sampleSecondMoment X).toEuclideanLin v =
    NumStability.hermitianOrderedEigenvalue
      (EuclideanSpectralClustering.sampleSecondMoment_isHermitian X) ⟨0, hn⟩ • v

/-- A supplied rule is a function of the point sample alone, and may choose any
unit top vector. Neither a hidden canonical rule nor measurability is required. -/
def IsDataOnlyUnitTopRule {m n : ℕ} (hn : 0 < n)
    (rule : (Fin m → Fin n → ℝ) → EuclideanSpace ℝ (Fin n)) : Prop :=
  ∀ X, IsUnitTopEmpiricalEigenvector hn X (rule X)

private theorem operatorNorm_sub_rev {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ) :
    NumStability.realMatrixOperatorNorm (S - T) =
      NumStability.realMatrixOperatorNorm (T - S) := by
  unfold NumStability.realMatrixOperatorNorm NumStability.realMatrixContinuousLinearMap
  simp only [map_sub]
  exact norm_sub_rev _ _

/-- The square-root alignment estimate holds for every unit top eigenvector.
It follows from the existing linear estimate for small perturbations and the
universal sign-distance bound for large perturbations. -/
theorem exists_sign_mean_sub_scaledUnitTopEigenvector_le_sqrt {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (T : Matrix (Fin n) (Fin n) ℝ) (hT : T.IsHermitian)
    (v : EuclideanSpace ℝ (Fin n)) (hv : ‖v‖ = 1)
    (hTv : T.toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩ • v) :
    ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
      ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
        s • (NumStability.vecNorm2 mean • v)‖ ≤
        2 * Real.sqrt (NumStability.realMatrixOperatorNorm (T - populationSecondMoment mean)) := by
  let r := NumStability.vecNorm2 mean
  let e := NumStability.realMatrixOperatorNorm (T - populationSecondMoment mean)
  have hr : 0 < r := hmean
  have he : 0 ≤ e := norm_nonneg _
  have hsqrte : (Real.sqrt e) ^ 2 = e := Real.sq_sqrt he
  have hsqrt2 : (Real.sqrt 2) ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  by_cases hsmall : e ≤ r ^ 2 / 2
  · obtain ⟨s, hs, hdist⟩ := exists_sign_mean_sub_scaledUnitTopEigenvector_le_linear
      hn mean hmean T hT v hv hTv
    rw [operatorNorm_sub_rev] at hdist
    refine ⟨s, hs, hdist.trans ?_⟩
    change 2 * Real.sqrt 2 * e / r ≤ 2 * Real.sqrt e
    have hroot : Real.sqrt 2 * Real.sqrt e ≤ r := by
      apply (sq_le_sq₀ (by positivity) hr.le).mp
      rw [mul_pow, hsqrt2, hsqrte]
      linarith
    apply (div_le_iff₀ hr).mpr
    calc
      2 * Real.sqrt 2 * e = 2 * Real.sqrt 2 * (Real.sqrt e) ^ 2 := by rw [hsqrte]
      _ = (2 * Real.sqrt e) * (Real.sqrt 2 * Real.sqrt e) := by ring
      _ ≤ (2 * Real.sqrt e) * r := mul_le_mul_of_nonneg_left hroot (by positivity)
  · let u := populationDirection mean
    have hu : ‖u‖ = 1 := norm_populationDirection mean hmean
    obtain ⟨s, hs, hdist⟩ := exists_sign_norm_sub_le_sqrt_two_mul_sin_angle u v hu hv
    have hscale : r * Real.sqrt 2 ≤ 2 * Real.sqrt e := by
      apply (sq_le_sq₀ (by positivity) (by positivity)).mp
      rw [mul_pow, hsqrt2]
      nlinarith [sq_nonneg (Real.sqrt e)]
    refine ⟨s, hs, ?_⟩
    have hvec : (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) - s • (r • v) =
        r • (u - s • v) := by
      rw [show (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) = r • u from
        mean_eq_norm_smul_populationDirection mean hmean]
      module
    rw [hvec, norm_smul, Real.norm_eq_abs, abs_of_pos hr]
    calc
      r * ‖u - s • v‖ ≤ r * (Real.sqrt 2 * Real.sin (InnerProductGeometry.angle u v)) :=
        mul_le_mul_of_nonneg_left hdist hr.le
      _ ≤ r * Real.sqrt 2 := by
        have hsin := Real.sin_le_one (InnerProductGeometry.angle u v)
        exact mul_le_mul_of_nonneg_left
          (by simpa only [mul_one] using mul_le_mul_of_nonneg_left hsin (Real.sqrt_nonneg 2)) hr.le
      _ ≤ 2 * Real.sqrt e := hscale

/-- The original trace-energy margin transfer is valid for every supplied unit
top vector, with exactly the displayed square-root/ambient-dimension budget. -/
theorem makesAtMostErrorsUpToSign_unitTop_of_deviation_le
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (labels : Fin m → ℝ) (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (X : Fin m → Fin n → ℝ) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) (epsilon tau q : ℝ)
    (htau : 0 < tau) (_hq : 0 ≤ q)
    (hdeviation : NumStability.realMatrixOperatorNorm
      (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment mean) ≤ q)
    (hideal : (Set.ncard (idealMarginErrors labels mean X tau) : ℝ) ≤ epsilon * m / 2)
    (hbudget : (2 * Real.sqrt q) ^ 2 *
      ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤ epsilon / 2 * tau ^ 2)
    (v : EuclideanSpace ℝ (Fin n)) (hv : IsUnitTopEmpiricalEigenvector hn X v) :
    MakesAtMostErrorsUpToSign labels (fun j ↦ v j) X (epsilon * m) := by
  let r := NumStability.vecNorm2 mean
  let e := NumStability.realMatrixOperatorNorm
    (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment mean)
  let eta := 2 * Real.sqrt q
  obtain ⟨s, hs, hdist⟩ := exists_sign_mean_sub_scaledUnitTopEigenvector_le_sqrt
    hn mean hmean _ (EuclideanSpectralClustering.sampleSecondMoment_isHermitian X) v hv.1 hv.2
  have hvec : (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) - s • (r • v) =
      WithLp.toLp 2 (mean - s • (r • (fun j ↦ v j))) := by ext j; rfl
  rw [hvec, Spherical.norm_toLp_eq_vecNorm2] at hdist
  have hdistRaw : NumStability.vecNorm2 (mean - s • (r • (fun j ↦ v j))) ≤ eta :=
    hdist.trans (mul_le_mul_of_nonneg_left (Real.sqrt_le_sqrt hdeviation) (by norm_num))
  have hactual : eta ^ 2 * ((n : ℝ) + r ^ 2 + (n : ℝ) * e) ≤
      epsilon / 2 * tau ^ 2 := by
    have hcoefficient : (n : ℝ) + r ^ 2 + (n : ℝ) * e ≤
        (n : ℝ) + r ^ 2 + (n : ℝ) * q := by
      have hmul : (n : ℝ) * e ≤ (n : ℝ) * q :=
        mul_le_mul_of_nonneg_left hdeviation (Nat.cast_nonneg n)
      linarith
    exact (mul_le_mul_of_nonneg_left hcoefficient (sq_nonneg eta)).trans hbudget
  have hunstable := ncard_directionUnstable_le_half_budget_of_sampleSecondMoment_deviation
    hm X mean eta tau epsilon htau hactual
  have hscaled := makesAtMostErrorsUpToSign_of_margin_and_direction
    labels mean (r • (fun j ↦ v j)) X s eta tau epsilon hs hlabels hdistRaw hideal hunstable
  exact (makesAtMostErrorsUpToSign_pos_smul_iff labels (fun j ↦ v j) X (epsilon * m) r hmean).mp hscaled

/-- Literal strict-positive/nonpositive partition recovery after the better of
the two global matchings, with the same deterministic scalar hypotheses. -/
theorem makesAtMostPartitionErrorsUpToSwap_unitTop_of_deviation_le
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (labels : Fin m → ℝ) (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (X : Fin m → Fin n → ℝ) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) (epsilon tau q : ℝ)
    (htau : 0 < tau) (hq : 0 ≤ q)
    (hdeviation : NumStability.realMatrixOperatorNorm
      (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment mean) ≤ q)
    (hideal : (Set.ncard (idealMarginErrors labels mean X tau) : ℝ) ≤ epsilon * m / 2)
    (hbudget : (2 * Real.sqrt q) ^ 2 *
      ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤ epsilon / 2 * tau ^ 2)
    (v : EuclideanSpace ℝ (Fin n)) (hv : IsUnitTopEmpiricalEigenvector hn X v) :
    MakesAtMostPartitionErrorsUpToSwap labels (fun j ↦ v j) X (epsilon * m) :=
  makesAtMostErrorsUpToSign_implies_partitionErrorsUpToSwap labels (fun j ↦ v j) X
    (epsilon * m) hlabels (makesAtMostErrorsUpToSign_unitTop_of_deviation_le
      hm hn labels hlabels X mean hmean epsilon tau q htau hq hdeviation hideal hbudget v hv)

/-- A single measurable certificate from covariance and ideal-margin tails
works simultaneously for all unit top empirical vectors. It is chosen from a
primitive covariance/margin/label event before any direction is supplied. -/
theorem exists_measurable_allUnit_partition_certificate_of_covariance_tail
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (epsilon q eta : ℝ) (hq : 0 ≤ q)
    (hidealScale : 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2)
    (hbudget : (2 * Real.sqrt q) ^ 2 *
      ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
      epsilon / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2)
    (hcovariance : (latentNoiseSampleMeasure m n).real
      {ω | q < NumStability.realMatrixOperatorNorm
        (EuclideanSpectralClustering.sampleSecondMoment
          (fun i ↦ canonicalPoint mean ω i) - populationSecondMoment mean)} ≤ eta) :
    ∃ good : Set (Fin m → ℝ × (Fin n → ℝ)),
      MeasurableSet good ∧
      1 - (eta + Real.exp (-2 * (m : ℝ) *
        (epsilon / 2 - 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2)) ≤
        (latentNoiseSampleMeasure m n).real good ∧
      ∀ ω ∈ good, ∀ v : EuclideanSpace ℝ (Fin n),
        IsUnitTopEmpiricalEigenvector hn (fun i ↦ canonicalPoint mean ω i) v →
        MakesAtMostPartitionErrorsUpToSwap (fun i ↦ canonicalLabel ω i)
          (fun j ↦ v j) (fun i ↦ canonicalPoint mean ω i) (epsilon * m) := by
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let X := fun (ω : Fin m → ℝ × (Fin n → ℝ)) i ↦ canonicalPoint mean ω i
  let labels := fun (ω : Fin m → ℝ × (Fin n → ℝ)) i ↦ canonicalLabel ω i
  let covarianceBad := {ω | q < NumStability.realMatrixOperatorNorm
    (EuclideanSpectralClustering.sampleSecondMoment (X ω) - populationSecondMoment mean)}
  let idealBad := {ω | epsilon / 2 * m ≤
    (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
      (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)}
  let labelBad := {ω | ¬ ∀ i, labels ω i = -1 ∨ labels ω i = 1}
  let primitiveGood := (covarianceBad ∪ idealBad ∪ labelBad)ᶜ
  have hlabelZero : μ labelBad = 0 := by
    rw [measure_eq_zero_iff_ae_notMem]
    filter_upwards [canonicalLabels_ae_eq_neg_one_or_one m n] with ω hω
    exact not_not_intro hω
  have hlabelRealZero : μ.real labelBad = 0 := by
    rw [Measure.real_def, hlabelZero]
    simp
  have hidealTail := canonicalIdealMarginErrorCount_hoeffding hm mean hmean hidealScale
  have hfailure : μ.real primitiveGoodᶜ ≤ eta + Real.exp (-2 * (m : ℝ) *
      (epsilon / 2 - 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) := by
    change μ.real (covarianceBad ∪ idealBad ∪ labelBad)ᶜᶜ ≤ _
    rw [compl_compl]
    calc
      _ ≤ μ.real (covarianceBad ∪ idealBad) + μ.real labelBad := measureReal_union_le _ _
      _ ≤ (μ.real covarianceBad + μ.real idealBad) + μ.real labelBad := by
        have hUnion := measureReal_union_le (μ := μ) covarianceBad idealBad
        linarith
      _ = μ.real covarianceBad + μ.real idealBad := by rw [hlabelRealZero, add_zero]
      _ ≤ _ := add_le_add hcovariance hidealTail
  obtain ⟨good, hmeas, hsubset, hmass⟩ :=
    NumStability.HDP.Probability.exists_measurable_subset_of_failure_measureReal_le
      primitiveGood hfailure
  refine ⟨good, hmeas, hmass, ?_⟩
  intro ω hω v hv
  have hnot := hsubset hω
  change ω ∉ covarianceBad ∪ idealBad ∪ labelBad at hnot
  simp only [Set.mem_union, not_or] at hnot
  have hdeviation : NumStability.realMatrixOperatorNorm
      (EuclideanSpectralClustering.sampleSecondMoment (X ω) - populationSecondMoment mean) ≤ q :=
    le_of_not_gt hnot.1.1
  have hideal : (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
      (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) ≤ epsilon * m / 2 := by
    have hlt : (Set.ncard (idealMarginErrors (labels ω) mean (X ω)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) < epsilon / 2 * m :=
      lt_of_not_ge hnot.1.2
    nlinarith
  have hlabels : ∀ i, labels ω i = -1 ∨ labels ω i = 1 := not_not.mp hnot.2
  exact makesAtMostPartitionErrorsUpToSwap_unitTop_of_deviation_le hm hn
    (labels ω) hlabels (X ω) mean hmean epsilon (NumStability.vecNorm2 mean ^ 2 / 2) q
    (by positivity) hq hdeviation hideal hbudget v hv

/-- One uniform covariance constant and one measurable good event give the
four-exponential guarantee simultaneously for every unit top eigenvector.
The three displayed thresholds are explicit added sufficient hypotheses. -/
theorem exists_allUnit_partition_four_exp_certificate_of_thresholds :
    ∃ Ccov : ℝ, 0 < Ccov ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
        ∀ (epsilon : ℝ),
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let delta : ℝ := Ccov * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
            Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
          let q : ℝ := L ^ 2 * max delta (delta ^ 2)
          4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2 →
          (2 * Real.sqrt q) ^ 2 *
            ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
            epsilon / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2 →
          Real.exp (-2 * (m : ℝ) * (epsilon / 2 -
            4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) ≤
            2 * Real.exp (-(n : ℝ)) →
          ∃ good : Set (Fin m → ℝ × (Fin n → ℝ)),
            MeasurableSet good ∧
            1 - 4 * Real.exp (-(n : ℝ)) ≤ (latentNoiseSampleMeasure m n).real good ∧
            ∀ ω ∈ good, ∀ v : EuclideanSpace ℝ (Fin n),
              IsUnitTopEmpiricalEigenvector hn (fun i ↦ canonicalPoint mean ω i) v →
              MakesAtMostPartitionErrorsUpToSwap (fun i ↦ canonicalLabel ω i)
                (fun j ↦ v j) (fun i ↦ canonicalPoint mean ω i) (epsilon * m) := by
  obtain ⟨Ccov, hCcov, hcovariance⟩ := exists_canonicalSampleCovarianceDeviation_tail
  refine ⟨Ccov, hCcov, ?_⟩
  intro m n hm hn mean hmean epsilon
  dsimp only
  intro hidealScale hbudget hconfidence
  let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
  let delta : ℝ := Ccov * (Real.sqrt ((n : ℝ) / (m : ℝ)) +
    Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
  let q : ℝ := L ^ 2 * max delta (delta ^ 2)
  have hq : 0 ≤ q := by dsimp [q]; positivity
  have hcovarianceTail : (latentNoiseSampleMeasure m n).real
      {ω | q < NumStability.realMatrixOperatorNorm
        (EuclideanSpectralClustering.sampleSecondMoment
          (fun i ↦ canonicalPoint mean ω i) - populationSecondMoment mean)} ≤
      2 * Real.exp (-(n : ℝ)) := by
    have htail := hcovariance hm hn mean
      (t := Real.sqrt (n : ℝ)) (Real.sqrt_nonneg _)
    rw [Real.sq_sqrt (Nat.cast_nonneg n)] at htail
    simpa [q, delta, L, EuclideanSpectralClustering.sampleSecondMoment,
      Covariance.randomSampleCovariance] using htail
  obtain ⟨good, hmeas, hmass, hall⟩ :=
    exists_measurable_allUnit_partition_certificate_of_covariance_tail hm hn mean hmean
      epsilon q (2 * Real.exp (-(n : ℝ))) hq hidealScale hbudget hcovarianceTail
  exact ⟨good, hmeas, by linarith, hall⟩

/-- A simultaneous certificate applies to every supplied data-only unit-top
rule on that same event. The quantifier over rules comes after `good`, so no
rule-dependent certificate or selection convention is hidden here. -/
theorem allUnit_partition_certificate_applies_to_rules
    {m n : ℕ} (hn : 0 < n) (mean : Fin n → ℝ) (epsilon : ℝ)
    (good : Set (Fin m → ℝ × (Fin n → ℝ)))
    (hall : ∀ ω ∈ good, ∀ v : EuclideanSpace ℝ (Fin n),
      IsUnitTopEmpiricalEigenvector hn (fun i ↦ canonicalPoint mean ω i) v →
      MakesAtMostPartitionErrorsUpToSwap (fun i ↦ canonicalLabel ω i)
        (fun j ↦ v j) (fun i ↦ canonicalPoint mean ω i) (epsilon * m)) :
    ∀ rule : (Fin m → Fin n → ℝ) → EuclideanSpace ℝ (Fin n),
      IsDataOnlyUnitTopRule hn rule → ∀ ω ∈ good,
      MakesAtMostPartitionErrorsUpToSwap (fun i ↦ canonicalLabel ω i)
        (fun j ↦ rule (fun i ↦ canonicalPoint mean ω i) j)
        (fun i ↦ canonicalPoint mean ω i) (epsilon * m) := by
  intro rule hRule ω hω
  exact hall ω hω _ (hRule _)

/-- The population top eigenvalue and all its unit eigenvectors are completely
characterized. This includes n=1 and asserts no nonexistent residual eigenvalue. -/
theorem population_unitTopEigenvector_characterization {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (v : EuclideanSpace ℝ (Fin n)) (hv : ‖v‖ = 1)
    (hSv : (populationSecondMoment mean).toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue (populationSecondMoment_isHermitian mean) ⟨0, hn⟩ • v) :
    NumStability.hermitianOrderedEigenvalue (populationSecondMoment_isHermitian mean) ⟨0, hn⟩ =
      1 + NumStability.vecNorm2 mean ^ 2 ∧
      ∃ s : ℝ, (s = -1 ∨ s = 1) ∧ v = s • populationDirection mean := by
  refine ⟨(populationOrderedTopEigenbasis_eq_sign_direction hn mean hmean).1, ?_⟩
  obtain ⟨s, hs, hdist⟩ := exists_sign_mean_sub_scaledUnitTopEigenvector_le_linear
    hn mean hmean (populationSecondMoment mean) (populationSecondMoment_isHermitian mean) v hv hSv
  have hdistZero : ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
      s • (NumStability.vecNorm2 mean • v)‖ ≤ 0 := by
    simpa [NumStability.realMatrixOperatorNorm, NumStability.realMatrixContinuousLinearMap] using hdist
  have hEq := sub_eq_zero.mp (norm_eq_zero.mp (le_antisymm hdistZero (norm_nonneg _)))
  have hDir : populationDirection mean = s • v := by
    apply (smul_right_injective (EuclideanSpace ℝ (Fin n)) hmean.ne')
    calc
      NumStability.vecNorm2 mean • populationDirection mean = WithLp.toLp 2 mean :=
        (mean_eq_norm_smul_populationDirection mean hmean).symm
      _ = s • (NumStability.vecNorm2 mean • v) := hEq
      _ = NumStability.vecNorm2 mean • (s • v) := by module
  rcases hs with rfl | rfl
  · exact ⟨-1, Or.inl rfl, by
      simpa only [neg_one_smul, neg_neg] using congrArg Neg.neg hDir.symm⟩
  · exact ⟨1, Or.inr rfl, by simpa only [one_smul] using hDir.symm⟩

end NumStability.HDP.Vector.GaussianMixture
