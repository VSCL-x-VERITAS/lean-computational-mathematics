import ComputationalMathematics.HDP.Vector.GaussianMixtureIdeal

/-!
# Coordinate decomposition of latent Gaussian-mixture samples

Reusable measurable equivalences separate one sample row and one Gaussian
coordinate from the remaining latent signs and noise. The side-measure and
law identities support binary-testing lower bounds without source imports.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- The law of the Gaussian coordinates other than `j`, together with the
sample rows other than `i`. -/
def latentNoiseCoordinateSideMeasure (m n : ℕ) :
    Measure ((Fin n → ℝ) × (Fin m → ℝ × (Fin (n + 1) → ℝ))) :=
  (NumStability.standardGaussianVectorMeasure n).prod
    (Measure.pi fun _ : Fin m ↦ latentNoiseObservationMeasure (n + 1))

instance latentNoiseCoordinateSideMeasure_isProbabilityMeasure (m n : ℕ) :
    IsProbabilityMeasure (latentNoiseCoordinateSideMeasure m n) :=
  ⟨by simp [latentNoiseCoordinateSideMeasure,
      NumStability.standardGaussianVectorMeasure]⟩

/-- Measurably split a selected sample row and then a selected Gaussian
coordinate in that row.  The two leading coordinates are respectively the
Rademacher sign and the scalar standard Gaussian. -/
def latentNoiseCoordinateSplitEquiv {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)) ≃ᵐ
      ℝ × (ℝ × ((Fin n → ℝ) ×
        (Fin m → ℝ × (Fin (n + 1) → ℝ)))) := by
  let Obs := ℝ × (Fin (n + 1) → ℝ)
  let rowSplit : (Fin (m + 1) → Obs) ≃ᵐ Obs × (Fin m → Obs) :=
    MeasurableEquiv.piFinSuccAbove (fun _ : Fin (m + 1) ↦ Obs) i
  let noiseSplit : (Fin (n + 1) → ℝ) ≃ᵐ ℝ × (Fin n → ℝ) :=
    MeasurableEquiv.piFinSuccAbove (fun _ : Fin (n + 1) ↦ ℝ) j
  exact rowSplit |>.trans
    (MeasurableEquiv.prodCongr
      (MeasurableEquiv.prodCongr (MeasurableEquiv.refl ℝ) noiseSplit)
      (MeasurableEquiv.refl _)) |>.trans
    MeasurableEquiv.prodAssoc |>.trans
    (MeasurableEquiv.prodCongr (MeasurableEquiv.refl ℝ)
      MeasurableEquiv.prodAssoc)

@[simp] theorem latentNoiseCoordinateSplitEquiv_fst {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (omega : Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)) :
    (latentNoiseCoordinateSplitEquiv i j omega).1 = (omega i).1 := rfl

@[simp] theorem latentNoiseCoordinateSplitEquiv_snd_fst {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (omega : Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)) :
    (latentNoiseCoordinateSplitEquiv i j omega).2.1 = (omega i).2 j := rfl

@[simp] theorem latentNoiseCoordinateSplitEquiv_rowTail {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (omega : Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)) :
    (latentNoiseCoordinateSplitEquiv i j omega).2.2.2 =
      fun k ↦ omega (i.succAbove k) := rfl

@[simp] theorem latentNoiseCoordinateSplitEquiv_noiseTail {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (omega : Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)) :
    (latentNoiseCoordinateSplitEquiv i j omega).2.2.1 =
      fun k ↦ (omega i).2 (j.succAbove k) := rfl

@[simp] theorem latentNoiseCoordinateSplitEquiv_symm_selectedLabel {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (z : ℝ × (ℝ × ((Fin n → ℝ) ×
      (Fin m → ℝ × (Fin (n + 1) → ℝ))))) :
    ((latentNoiseCoordinateSplitEquiv i j).symm z i).1 = z.1 := by
  have h := latentNoiseCoordinateSplitEquiv_fst i j
    ((latentNoiseCoordinateSplitEquiv i j).symm z)
  simpa using h.symm

@[simp] theorem latentNoiseCoordinateSplitEquiv_symm_selectedNoise {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (z : ℝ × (ℝ × ((Fin n → ℝ) ×
      (Fin m → ℝ × (Fin (n + 1) → ℝ))))) :
    ((latentNoiseCoordinateSplitEquiv i j).symm z i).2 j = z.2.1 := by
  have h := latentNoiseCoordinateSplitEquiv_snd_fst i j
    ((latentNoiseCoordinateSplitEquiv i j).symm z)
  simpa using h.symm

@[simp] theorem latentNoiseCoordinateSplitEquiv_symm_rowTail {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (z : ℝ × (ℝ × ((Fin n → ℝ) ×
      (Fin m → ℝ × (Fin (n + 1) → ℝ))))) (k : Fin m) :
    (latentNoiseCoordinateSplitEquiv i j).symm z (i.succAbove k) =
      z.2.2.2 k := by
  have h := congrFun (latentNoiseCoordinateSplitEquiv_rowTail i j
    ((latentNoiseCoordinateSplitEquiv i j).symm z)) k
  simpa using h.symm

@[simp] theorem latentNoiseCoordinateSplitEquiv_symm_noiseTail {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (z : ℝ × (ℝ × ((Fin n → ℝ) ×
      (Fin m → ℝ × (Fin (n + 1) → ℝ))))) (k : Fin n) :
    ((latentNoiseCoordinateSplitEquiv i j).symm z i).2 (j.succAbove k) =
      z.2.2.1 k := by
  have h := congrFun (latentNoiseCoordinateSplitEquiv_noiseTail i j
    ((latentNoiseCoordinateSplitEquiv i j).symm z)) k
  simpa using h.symm

/-- The selected sign and selected scalar noise coordinate split off from the
full canonical sample as independent leading product factors. -/
theorem latentNoiseCoordinateSplitEquiv_measurePreserving {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    MeasurePreserving (latentNoiseCoordinateSplitEquiv i j)
      (latentNoiseSampleMeasure (m + 1) (n + 1))
      (rademacherPMF.toMeasure.prod
        ((gaussianReal 0 1).prod (latentNoiseCoordinateSideMeasure m n))) := by
  let Obs := ℝ × (Fin (n + 1) → ℝ)
  let obsLaw : Measure Obs := latentNoiseObservationMeasure (n + 1)
  let rowLaws : Fin (m + 1) → Measure Obs := fun _ ↦ obsLaw
  let rowTailLaw : Measure (Fin m → Obs) :=
    Measure.pi fun _ : Fin m ↦ obsLaw
  let gaussianTailLaw : Measure (Fin n → ℝ) :=
    NumStability.standardGaussianVectorMeasure n
  let gaussianLaws : Fin (n + 1) → Measure ℝ := fun _ ↦ gaussianReal 0 1
  letI : ∀ k : Fin (m + 1), SigmaFinite (rowLaws k) :=
    fun _ ↦ IsFiniteMeasure.toSigmaFinite _
  letI : ∀ k : Fin (n + 1), SigmaFinite (gaussianLaws k) :=
    fun _ ↦ inferInstance
  have hrow : MeasurePreserving
      (MeasurableEquiv.piFinSuccAbove (fun _ : Fin (m + 1) ↦ Obs) i)
      (latentNoiseSampleMeasure (m + 1) (n + 1))
      (obsLaw.prod rowTailLaw) := by
    simpa [latentNoiseSampleMeasure, obsLaw, rowLaws, rowTailLaw] using
      (MeasureTheory.measurePreserving_piFinSuccAbove rowLaws i)
  have hnoise : MeasurePreserving
      (MeasurableEquiv.piFinSuccAbove (fun _ : Fin (n + 1) ↦ ℝ) j)
      (NumStability.standardGaussianVectorMeasure (n + 1))
      ((gaussianReal 0 1).prod gaussianTailLaw) := by
    simpa [NumStability.standardGaussianVectorMeasure, gaussianLaws,
      gaussianTailLaw] using
      (MeasureTheory.measurePreserving_piFinSuccAbove gaussianLaws j)
  have hobs : MeasurePreserving
      (MeasurableEquiv.prodCongr (MeasurableEquiv.refl ℝ)
        (MeasurableEquiv.piFinSuccAbove (fun _ : Fin (n + 1) ↦ ℝ) j))
      obsLaw
      (rademacherPMF.toMeasure.prod
        ((gaussianReal 0 1).prod gaussianTailLaw)) := by
    simpa [obsLaw, latentNoiseObservationMeasure] using
      ((MeasurePreserving.id rademacherPMF.toMeasure).prod hnoise)
  letI : SFinite gaussianTailLaw := inferInstance
  letI : SFinite rowTailLaw := inferInstance
  have h1 := (hobs.prod (MeasurePreserving.id rowTailLaw)).comp hrow
  have h2 :=
    (MeasureTheory.measurePreserving_prodAssoc
      rademacherPMF.toMeasure ((gaussianReal 0 1).prod gaussianTailLaw)
      rowTailLaw).comp h1
  have h3 :=
    ((MeasurePreserving.id rademacherPMF.toMeasure).prod
      (MeasureTheory.measurePreserving_prodAssoc
        (gaussianReal 0 1) gaussianTailLaw rowTailLaw)).comp h2
  simpa [latentNoiseCoordinateSplitEquiv, latentNoiseCoordinateSideMeasure,
    gaussianTailLaw, rowTailLaw, obsLaw, Obs] using h3

theorem latentNoiseCoordinateSplitEquiv_map {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    Measure.map (latentNoiseCoordinateSplitEquiv i j)
        (latentNoiseSampleMeasure (m + 1) (n + 1)) =
      rademacherPMF.toMeasure.prod
        ((gaussianReal 0 1).prod (latentNoiseCoordinateSideMeasure m n)) :=
  (latentNoiseCoordinateSplitEquiv_measurePreserving i j).map_eq

/-- Setwise form of `latentNoiseCoordinateSplitEquiv_map`, convenient for
arbitrary measurable events in the original canonical sample space. -/
theorem latentNoiseSampleMeasure_apply_split {m n : ℕ}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (A : Set (Fin (m + 1) → ℝ × (Fin (n + 1) → ℝ)))
    (hA : MeasurableSet A) :
    latentNoiseSampleMeasure (m + 1) (n + 1) A =
      (rademacherPMF.toMeasure.prod
        ((gaussianReal 0 1).prod (latentNoiseCoordinateSideMeasure m n)))
          (latentNoiseCoordinateSplitEquiv i j '' A) := by
  let e := latentNoiseCoordinateSplitEquiv i j
  have himage : MeasurableSet (e '' A) :=
    e.measurableEmbedding.measurableSet_image.mpr hA
  rw [← (latentNoiseCoordinateSplitEquiv_measurePreserving i j).map_eq,
    Measure.map_apply e.measurable himage]
  rw [Set.preimage_image_eq A (latentNoiseCoordinateSplitEquiv i j).injective]

/-- Dimension-indexed version of the side law, for callers whose dimensions
are named `m` and `n` rather than as successors. -/
def latentNoiseCoordinateResidualMeasure (m n : ℕ) :
    Measure ((Fin (n - 1) → ℝ) ×
      (Fin (m - 1) → ℝ × (Fin n → ℝ))) :=
  (NumStability.standardGaussianVectorMeasure (n - 1)).prod
    (Measure.pi fun _ : Fin (m - 1) ↦ latentNoiseObservationMeasure n)

instance latentNoiseCoordinateResidualMeasure_isProbabilityMeasure
    (m n : ℕ) :
    IsProbabilityMeasure (latentNoiseCoordinateResidualMeasure m n) :=
  ⟨by simp [latentNoiseCoordinateResidualMeasure,
      NumStability.standardGaussianVectorMeasure]⟩

/-- The selected row sign and selected scalar noise coordinate split off for
arbitrary nonempty dimensions (witnessed by `i` and `j`). -/
def latentNoiseCoordinateSplitEquiv' {m n : ℕ} (i : Fin m) (j : Fin n) :
    (Fin m → ℝ × (Fin n → ℝ)) ≃ᵐ
      ℝ × (ℝ × ((Fin (n - 1) → ℝ) ×
        (Fin (m - 1) → ℝ × (Fin n → ℝ)))) := by
  cases m with
  | zero => exact Fin.elim0 i
  | succ m =>
      cases n with
      | zero => exact Fin.elim0 j
      | succ n =>
          simpa using latentNoiseCoordinateSplitEquiv i j

@[simp] theorem latentNoiseCoordinateSplitEquiv'_fst {m n : ℕ}
    (i : Fin m) (j : Fin n) (omega : Fin m → ℝ × (Fin n → ℝ)) :
    (latentNoiseCoordinateSplitEquiv' i j omega).1 = (omega i).1 := by
  cases m with
  | zero => exact Fin.elim0 i
  | succ m =>
      cases n with
      | zero => exact Fin.elim0 j
      | succ n => rfl

@[simp] theorem latentNoiseCoordinateSplitEquiv'_snd_fst {m n : ℕ}
    (i : Fin m) (j : Fin n) (omega : Fin m → ℝ × (Fin n → ℝ)) :
    (latentNoiseCoordinateSplitEquiv' i j omega).2.1 = (omega i).2 j := by
  cases m with
  | zero => exact Fin.elim0 i
  | succ m =>
      cases n with
      | zero => exact Fin.elim0 j
      | succ n => rfl

theorem latentNoiseCoordinateSplitEquiv'_measurePreserving {m n : ℕ}
    (i : Fin m) (j : Fin n) :
    MeasurePreserving (latentNoiseCoordinateSplitEquiv' i j)
      (latentNoiseSampleMeasure m n)
      (rademacherPMF.toMeasure.prod
        ((gaussianReal 0 1).prod
          (latentNoiseCoordinateResidualMeasure m n))) := by
  cases m with
  | zero => exact Fin.elim0 i
  | succ m =>
      cases n with
      | zero => exact Fin.elim0 j
      | succ n =>
          simpa [latentNoiseCoordinateSplitEquiv',
            latentNoiseCoordinateResidualMeasure,
            latentNoiseCoordinateSideMeasure] using
            (latentNoiseCoordinateSplitEquiv_measurePreserving i j)

theorem latentNoiseCoordinateSplitEquiv'_map {m n : ℕ}
    (i : Fin m) (j : Fin n) :
    Measure.map (latentNoiseCoordinateSplitEquiv' i j)
        (latentNoiseSampleMeasure m n) =
      rademacherPMF.toMeasure.prod
        ((gaussianReal 0 1).prod
          (latentNoiseCoordinateResidualMeasure m n)) :=
  (latentNoiseCoordinateSplitEquiv'_measurePreserving i j).map_eq

theorem latentNoiseSampleMeasure_apply_split' {m n : ℕ}
    (i : Fin m) (j : Fin n)
    (A : Set (Fin m → ℝ × (Fin n → ℝ))) (hA : MeasurableSet A) :
    latentNoiseSampleMeasure m n A =
      (rademacherPMF.toMeasure.prod
        ((gaussianReal 0 1).prod
          (latentNoiseCoordinateResidualMeasure m n)))
        (latentNoiseCoordinateSplitEquiv' i j '' A) := by
  let e := latentNoiseCoordinateSplitEquiv' i j
  have himage : MeasurableSet (e '' A) :=
    e.measurableEmbedding.measurableSet_image.mpr hA
  rw [← (latentNoiseCoordinateSplitEquiv'_measurePreserving i j).map_eq,
    Measure.map_apply e.measurable himage]
  rw [Set.preimage_image_eq A (latentNoiseCoordinateSplitEquiv' i j).injective]

/-- The setwise split identity also holds for arbitrary (possibly
nonmeasurable) events, because the splitting map is a measurable embedding and
measures are evaluated through their outer measures on such sets. -/
theorem latentNoiseSampleMeasure_apply_split'_outer {m n : ℕ}
    (i : Fin m) (j : Fin n)
    (A : Set (Fin m → ℝ × (Fin n → ℝ))) :
    latentNoiseSampleMeasure m n A =
      (rademacherPMF.toMeasure.prod
        ((gaussianReal 0 1).prod
          (latentNoiseCoordinateResidualMeasure m n)))
        (latentNoiseCoordinateSplitEquiv' i j '' A) := by
  rw [← (latentNoiseCoordinateSplitEquiv'_measurePreserving i j).map_eq,
    (latentNoiseCoordinateSplitEquiv' i j).measurableEmbedding.map_apply,
    Set.preimage_image_eq A (latentNoiseCoordinateSplitEquiv' i j).injective]

end NumStability.HDP.Vector.GaussianMixture
