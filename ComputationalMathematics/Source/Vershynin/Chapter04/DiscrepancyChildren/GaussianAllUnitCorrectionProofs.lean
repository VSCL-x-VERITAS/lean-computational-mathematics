import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianAllUnitCorrections

/-!
# Gaussian-mixture recovery under explicit thresholds

These analyst corrections retain the joint sampling law and every unit leading
eigenvector on one measurable event. The exercise includes all five stages.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped BigOperators RealInnerProductSpace ENNReal
open NumStability.HDP.Vector.GaussianMixture

namespace NumStability.HDP.Contract.DiscrepancyChildren.GaussianAllUnit

private theorem betterMatchingErrorCount_le_of_partition {m n : ℕ}
    (labels : Fin m → ℝ) (v : EuclideanSpace ℝ (Fin n))
    (X : Fin m → Fin n → ℝ) (budget : ℝ)
    (h : MakesAtMostPartitionErrorsUpToSwap labels (fun j ↦ v j) X budget) :
    betterMatchingErrorCount labels v X ≤ budget := by
  rcases h with ⟨firstLabel, hfirst, hcount⟩
  rcases hfirst with rfl | rfl
  · exact (min_le_right _ _).trans
      (by simpa only [partitionMisclassifiedIndices, dotProduct] using hcount)
  · exact (min_le_left _ _).trans
      (by simpa only [partitionMisclassifiedIndices, dotProduct] using hcount)

private theorem jointLawContract_proof {m n : ℕ} (mean : Fin n → ℝ) :
    jointLawContract (m := m) mean := by
  dsimp [jointLawContract]
  refine ⟨by simp [latentNoiseSampleMeasure], ?_, ?_, ?_⟩
  · intro S L B hL hB
    exact latentNoiseSampleMeasure_finite_rectangle m n S L B hL hB
  · intro i
    have hmap := (canonicalLabel_hasLaw m n i).map_eq
    have hmeas : Measurable (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ canonicalLabel ω i) := by
      unfold canonicalLabel
      fun_prop
    constructor
    · change latentNoiseSampleMeasure m n
        ((fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ canonicalLabel ω i) ⁻¹' {(-1 : ℝ)}) = _
      rw [← Measure.map_apply hmeas (measurableSet_singleton (-1 : ℝ)), hmap]
      rw [PMF.toMeasure_apply_singleton
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF (-1)
        (measurableSet_singleton _)]
      simp
    · change latentNoiseSampleMeasure m n
        ((fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ canonicalLabel ω i) ⁻¹' {(1 : ℝ)}) = _
      rw [← Measure.map_apply hmeas (measurableSet_singleton (1 : ℝ)), hmap]
      rw [PMF.toMeasure_apply_singleton
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF (1)
        (measurableSet_singleton _)]
      simp
  · intro i
    exact ⟨measurable_canonicalPoint mean i,
      (canonicalPoint_hasLaw m n mean i).map_eq⟩

private theorem unitTopOutputContract_proof {m n : ℕ} (hn : 0 < n)
    (X : Fin m → Fin n → ℝ) (v : EuclideanSpace ℝ (Fin n))
    (hv : IsUnitTopEmpiricalEigenvector hn X v) :
    unitTopOutputContract hn X v := by
  let M := NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X
  let hM := NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X
  let i0 : Fin n := ⟨0, hn⟩
  have htrailtop : NumStability.hermitianTrailSubspace hM i0 = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    rw [NumStability.finrank_hermitianTrailSubspace, finrank_euclideanSpace_fin]
    simp [i0]
  have hvRayleigh : NumStability.matrixRayleighForm M v =
      NumStability.hermitianOrderedEigenvalue hM i0 := by
    rw [NumStability.matrixRayleighForm, hv.2, real_inner_smul_right,
      real_inner_self_eq_norm_sq, hv.1, one_pow, mul_one]
  have hmax : ∀ w : EuclideanSpace ℝ (Fin n), ‖w‖ = 1 →
      NumStability.matrixRayleighForm M w ≤ NumStability.matrixRayleighForm M v := by
    intro w hw
    have hwtrail : w ∈ NumStability.hermitianTrailSubspace hM i0 := by
      rw [htrailtop]
      trivial
    have hbound := NumStability.rayleigh_le_hermitianOrderedEigenvalue_mul_norm_sq_of_mem_trail
      hM i0 hwtrail
    rw [hw, one_pow, mul_one] at hbound
    exact hbound.trans_eq hvRayleigh.symm
  refine ⟨hv.1, hv.2, hmax, ?_⟩
  refine ⟨{i | 0 < ∑ j, v j * X i j}, {i | (∑ j, v j * X i j) ≤ 0}, ?_, ?_⟩
  · intro i; rfl
  · intro i; rfl

private theorem allUnitFinalThresholds_proof : allUnitFinalThresholds := by
  obtain ⟨Ccov, hCcov, hcertificate⟩ :=
    exists_allUnit_partition_four_exp_certificate_of_thresholds
  refine ⟨Ccov, hCcov, ?_⟩
  intro m n hm hn mean hmean epsilon hepsilon
  dsimp only
  intro hfirst hsecond hthird
  have houtput : ∀ (sample : Fin m → Fin n → ℝ)
      (v : EuclideanSpace ℝ (Fin n)),
      IsUnitTopEmpiricalEigenvector hn sample v →
      unitTopOutputContract hn sample v := by
    intro sample v hv
    exact unitTopOutputContract_proof hn sample v hv
  obtain ⟨good, hgoodMeas, hgoodMass, hgoodAll⟩ :=
    hcertificate hm hn mean hmean epsilon hfirst hsecond hthird
  let μ := latentNoiseSampleMeasure m n
  let binary : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ∀ i, canonicalLabel ω i = -1 ∨ canonicalLabel ω i = 1}
  have hbinaryMeas : MeasurableSet binary := by
    dsimp [binary]
    rw [setOf_forall]
    apply MeasurableSet.iInter
    intro i
    have hi : Measurable (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ canonicalLabel ω i) := by
      unfold canonicalLabel
      fun_prop
    exact (hi (measurableSet_singleton (-1 : ℝ))).union
      (hi (measurableSet_singleton (1 : ℝ)))
  have hbinaryAE : ∀ᵐ ω ∂μ, ω ∈ binary :=
    canonicalLabels_ae_eq_neg_one_or_one m n
  let good' := binary ∩ good
  have hgood'Meas : MeasurableSet good' := hbinaryMeas.inter hgoodMeas
  have hgood'Mass : μ.real good' = μ.real good := by
    change (μ (binary ∩ good)).toReal = (μ good).toReal
    rw [Measure.measure_inter_eq_of_ae hbinaryAE]
  refine ⟨houtput, good', hgood'Meas, hgood'Mass.symm ▸ hgoodMass, ?_, ?_⟩
  · intro ω hω
    have hbin : ∀ i : Fin m, (ω i).1 = -1 ∨ (ω i).1 = 1 := by
      simpa [good', binary, canonicalLabel] using hω.1
    refine ⟨hbin, ?_⟩
    intro v hv
    exact betterMatchingErrorCount_le_of_partition _ v _ _
      (hgoodAll ω hω.2 v hv)
  · intro rule hRule ω hω
    exact betterMatchingErrorCount_le_of_partition _ (rule _) _ _
      (hgoodAll ω hω.2 (rule _) (hRule _))

theorem theorem475_allUnitCorrection_child_proved :
    HDP04Theorem475AllUnitCorrectionChildTarget := by
  refine ⟨?_, allUnitFinalThresholds_proof⟩
  intro m n hm hn mean
  exact jointLawContract_proof mean

private theorem exercisePopulationAllUnitStage_proof : exercisePopulationAllUnitStage := by
  constructor
  · intro n mean
    exact NumStability.HDP.Contract.hdp_04_exercise_4_7_6_population_signal mean
  · intro n hn mean hmean
    dsimp only
    have htop := (populationOrderedTopEigenbasis_eq_sign_direction hn mean hmean).1
    refine ⟨htop, ?_⟩
    intro v hv hSv
    exact (population_unitTopEigenvector_characterization hn mean hmean v hv hSv).2

private theorem exercisePerturbationAllUnitStage_proof :
    exercisePerturbationAllUnitStage := by
  intro m n hm hn mean hmean X v hv
  exact exists_sign_mean_sub_scaledUnitTopEigenvector_le_sqrt
    hn mean hmean _
    (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
    v hv.1 hv.2

private theorem exerciseTransferAllUnitStage_proof : exerciseTransferAllUnitStage := by
  intro m n hm hn labels hlabels X mean hmean epsilon tau q htau hq
    hdeviation hideal hbudget v hv
  have hsign := makesAtMostErrorsUpToSign_unitTop_of_deviation_le
    hm hn labels hlabels X mean hmean epsilon tau q htau hq
    hdeviation hideal hbudget v hv
  have hpartition := makesAtMostErrorsUpToSign_implies_partitionErrorsUpToSwap
    labels (fun j ↦ v j) X (epsilon * m) hlabels hsign
  exact ⟨hsign, betterMatchingErrorCount_le_of_partition labels v X _ hpartition⟩

theorem exercise476_allUnitCorrection_child_proved :
    HDP04Exercise476AllUnitCorrectionChildTarget := by
  refine ⟨?_, exercisePopulationAllUnitStage_proof,
    NumStability.HDP.Contract.hdp_04_exercise_4_7_6_covariance_estimation,
    exercisePerturbationAllUnitStage_proof,
    NumStability.HDP.Contract.hdp_04_exercise_4_7_6_ideal_classification,
    exerciseTransferAllUnitStage_proof, allUnitFinalThresholds_proof⟩
  intro m n hm hn mean
  exact jointLawContract_proof mean

end NumStability.HDP.Contract.DiscrepancyChildren.GaussianAllUnit

