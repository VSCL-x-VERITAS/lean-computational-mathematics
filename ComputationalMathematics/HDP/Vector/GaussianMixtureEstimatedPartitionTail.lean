import ComputationalMathematics.HDP.Vector.GaussianMixtureAmplitudeNonpositiveTail
import ComputationalMathematics.HDP.Vector.GaussianMixturePartitionRecovery

/-!
# Estimated-amplitude partition tail for the Gaussian mixture

Positive scaling preserves the strict binary partition. Combining its
unit-direction failure bound with the nonpositive-amplitude event gives a
six-exponential tail under the two separate constants and explicit thresholds.
-/

open MeasureTheory

namespace NumStability.HDP.Vector.GaussianMixture

theorem exists_canonicalEstimatedScale_partition_six_exp_tail_of_thresholds :
    ∃ C D : ℝ, 0 < C ∧ 0 < D ∧
      ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
        ∀ (mean : Fin n → ℝ), 0 < NumStability.vecNorm2 mean →
        ∀ (epsilon : ℝ),
          let L : ℝ := 2 * (NumStability.vecNorm2 mean + 1)
          let base : ℝ := Real.sqrt ((n : ℝ) / (m : ℝ)) +
            Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ)
          let deltaC : ℝ := C * base
          let qC : ℝ := L ^ 2 * max deltaC (deltaC ^ 2)
          let deltaD : ℝ := D * base
          let qD : ℝ := L ^ 2 * max deltaD (deltaD ^ 2)
          4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < epsilon / 2 →
          (2 * Real.sqrt qC) ^ 2 *
              ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * qC) ≤
            epsilon / 2 * (NumStability.vecNorm2 mean ^ 2 / 2) ^ 2 →
          Real.exp (-2 * (m : ℝ) *
              (epsilon / 2 -
                4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) ≤
            2 * Real.exp (-(n : ℝ)) →
          qD < NumStability.vecNorm2 mean ^ 2 →
          (latentNoiseSampleMeasure m n).real
            {ω |
              let X : Fin m → Fin n → ℝ := fun i ↦ canonicalPoint mean ω i
              let a := Real.sqrt (max
                (NumStability.hermitianOrderedEigenvalue
                  (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
                  ⟨0, hn⟩ - 1) 0)
              ¬ MakesAtMostPartitionErrorsUpToSwap
                (fun i ↦ canonicalLabel ω i)
                (a • (fun j ↦
                  NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn X j))
                X (epsilon * m)} ≤ 6 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, hunit⟩ :=
    exists_canonicalSpectralClustering_partition_four_exp_tail_of_thresholds
  obtain ⟨D, hD, hscale⟩ := exists_canonicalSpectralAmplitude_nonpositive_tail_of_threshold
  refine ⟨C, D, hC, hD, ?_⟩
  intro m n hm hn mean hmean epsilon
  dsimp only
  intro hidealScale hbudget hidealTail hsmall
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let X : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → Fin n → ℝ :=
    fun ω i ↦ canonicalPoint mean ω i
  let labels : (Fin m → ℝ × (Fin n → ℝ)) → Fin m → ℝ :=
    fun ω i ↦ canonicalLabel ω i
  let direction : (Fin m → ℝ × (Fin n → ℝ)) → Fin n → ℝ :=
    fun ω j ↦
      NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn (X ω) j
  let scale : (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun ω ↦ Real.sqrt (max
      (NumStability.hermitianOrderedEigenvalue
        (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian (X ω))
        ⟨0, hn⟩ - 1) 0)
  let unitBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
      (labels ω) (direction ω) (X ω) (epsilon * m)}
  let scaleBad : Set (Fin m → ℝ × (Fin n → ℝ)) := {ω | scale ω ≤ 0}
  let estimatedBad : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    {ω | ¬ MakesAtMostPartitionErrorsUpToSwap
      (labels ω) (scale ω • direction ω) (X ω) (epsilon * m)}
  have hunitTail : μ.real unitBad ≤ 4 * Real.exp (-(n : ℝ)) := by
    simpa [μ, unitBad, labels, direction, X] using
      (hunit hm hn mean hmean epsilon hidealScale hbudget hidealTail)
  have hscaleTail : μ.real scaleBad ≤ 2 * Real.exp (-(n : ℝ)) := by
    simpa [μ, scaleBad, scale, X, Real.sq_sqrt (Nat.cast_nonneg n)] using
      (hscale hm hn mean hmean (t := Real.sqrt (n : ℝ))
        (Real.sqrt_nonneg _) hsmall)
  have hsubset : estimatedBad ⊆ unitBad ∪ scaleBad := by
    intro ω hbad
    by_cases hpositive : 0 < scale ω
    · left
      intro hgood
      exact hbad ((makesAtMostPartitionErrorsUpToSwap_smul_iff_of_pos
        (scale ω) hpositive (labels ω) (direction ω) (X ω) (epsilon * m)).mpr hgood)
    · right
      exact le_of_not_gt hpositive
  change μ.real estimatedBad ≤ 6 * Real.exp (-(n : ℝ))
  calc
    μ.real estimatedBad ≤ μ.real (unitBad ∪ scaleBad) :=
      measureReal_mono hsubset (measure_ne_top _ _)
    _ ≤ μ.real unitBad + μ.real scaleBad := measureReal_union_le _ _
    _ ≤ 4 * Real.exp (-(n : ℝ)) + 2 * Real.exp (-(n : ℝ)) :=
      add_le_add hunitTail hscaleTail
    _ = 6 * Real.exp (-(n : ℝ)) := by ring

end NumStability.HDP.Vector.GaussianMixture
