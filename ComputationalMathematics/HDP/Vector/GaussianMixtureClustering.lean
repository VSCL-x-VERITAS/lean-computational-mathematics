import ComputationalMathematics.HDP.Vector.GaussianMixture
import ComputationalMathematics.HDP.Vector.SpectralClustering
import ComputationalMathematics.HDP.Vector.SphericalSubGaussian
import Mathlib.MeasureTheory.Measure.Real

/-!
# Gaussian-mixture clustering guarantees

This module records the latent-label error event and the final probability
assembly used by the spectral-clustering proof.  The two statistical bad
events correspond to covariance/eigenvector estimation and ideal Gaussian
classification.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Vector.GaussianMixture

/-- Joint law of one latent community sign and the point generated from it. -/
def latentGaussianMixtureObservationMeasure {n : ℕ} (mean : Fin n → ℝ) :
    Measure (ℝ × (Fin n → ℝ)) :=
  Measure.map (fun z : ℝ × (Fin n → ℝ) ↦ (z.1, mixtureMap mean z))
    (NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure.prod
      (NumStability.standardGaussianVectorMeasure n))

/-- Product law of `m` labeled observations from the symmetric Gaussian
mixture.  Unlike the point-only law, this retains the latent community signs
needed to state the misclassification event. -/
def latentGaussianMixtureSampleMeasure (m : ℕ) {n : ℕ}
    (mean : Fin n → ℝ) : Measure (Fin m → ℝ × (Fin n → ℝ)) :=
  Measure.pi fun _ : Fin m ↦ latentGaussianMixtureObservationMeasure mean

/-- A labeled sample has the joint latent Gaussian-mixture law. -/
def HasLatentGaussianMixtureSampleLaw {Ω : Type*} [MeasurableSpace Ω]
    {m n : ℕ} (P : Measure Ω) (labels : Ω → Fin m → ℝ)
    (X : Ω → Fin m → Fin n → ℝ) (mean : Fin n → ℝ) : Prop :=
  HasLaw (fun ω i ↦ (labels ω i, X ω i))
    (latentGaussianMixtureSampleMeasure m mean) P

/-- The population second-moment matrix of the symmetric mixture
`X = θ μ + g`: the identity plus the rank-one signal `μ μᵀ`. -/
def populationSecondMoment {n : ℕ} (mean : Fin n → ℝ) :
    Matrix (Fin n) (Fin n) ℝ :=
  fun i j ↦ (1 : Matrix (Fin n) (Fin n) ℝ) i j + mean i * mean j

theorem populationSecondMoment_apply {n : ℕ} (mean : Fin n → ℝ)
    (i j : Fin n) :
    populationSecondMoment mean i j = (if i = j then 1 else 0) +
      mean i * mean j := by
  simp [populationSecondMoment, Matrix.one_apply]

/-- The mixture mean direction is an eigenvector of its population
second-moment matrix, with eigenvalue `1 + ‖μ‖₂²`. -/
theorem populationSecondMoment_mulVec_mean {n : ℕ} (mean : Fin n → ℝ) :
    (populationSecondMoment mean).mulVec mean =
      (1 + NumStability.vecNorm2 mean ^ 2) • mean := by
  ext i
  simp only [populationSecondMoment, Matrix.mulVec, dotProduct, Matrix.one_apply,
    Pi.smul_apply, smul_eq_mul, add_mul, Finset.sum_add_distrib]
  have hdiag : (∑ x, (if i = x then 1 else 0) * mean x) = mean i := by
    simp
  rw [hdiag]
  rw [show (∑ j, mean i * mean j * mean j) = mean i * ∑ j, mean j ^ 2 by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _hj
    ring]
  rw [show (∑ j, mean j ^ 2) = NumStability.vecNorm2 mean ^ 2 by
    exact (NumStability.vecNorm2_sq mean).symm]
  ring

/-- Sample indices whose projection sign disagrees with the latent sign. -/
def misclassifiedIndices {m n : ℕ} (labels : Fin m → ℝ)
    (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ) : Set (Fin m) :=
  {i | labels i * dotProduct v (X i) ≤ 0}

/-- Correct clustering up to the unavoidable global sign of the chosen
eigenvector, with a real-valued error budget. -/
def MakesAtMostErrorsUpToSign {m n : ℕ} (labels : Fin m → ℝ)
    (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ) (budget : ℝ) : Prop :=
  ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
    (Set.ncard (misclassifiedIndices labels (s • v) X) : ℝ) ≤ budget

/-- Ideal-direction errors, allowing a positive robustness margin. -/
def idealMarginErrors {m n : ℕ} (labels : Fin m → ℝ)
    (u : Fin n → ℝ) (X : Fin m → Fin n → ℝ) (τ : ℝ) : Set (Fin m) :=
  {i | labels i * dotProduct u (X i) ≤ τ}

/-- Points on which an `η`-sized direction perturbation can consume the
chosen margin `τ`. -/
def directionUnstableIndices {m n : ℕ} (X : Fin m → Fin n → ℝ)
    (η τ : ℝ) : Set (Fin m) :=
  {i | τ ≤ η * NumStability.vecNorm2 (X i)}

/-- Finite-dimensional Cauchy--Schwarz in the repository's `vecNorm2`
notation. -/
theorem abs_dotProduct_le_vecNorm2_mul_vecNorm2 {n : ℕ}
    (x y : Fin n → ℝ) :
    |dotProduct x y| ≤ NumStability.vecNorm2 x * NumStability.vecNorm2 y := by
  have h := abs_real_inner_le_norm
    (WithLp.toLp 2 x : EuclideanSpace ℝ (Fin n))
    (WithLp.toLp 2 y : EuclideanSpace ℝ (Fin n))
  simpa [PiLp.inner_apply, dotProduct, real_inner_eq_re_inner,
    RCLike.inner_apply, mul_comm,
    NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2] using h

/-- A direction estimate close up to global sign can only misclassify an
index that was already inside the ideal margin or whose point norm is large
enough to make the perturbation unstable. -/
theorem misclassifiedIndices_subset_idealMarginErrors_union_unstable
    {m n : ℕ} (labels : Fin m → ℝ)
    (u v : Fin n → ℝ) (X : Fin m → Fin n → ℝ)
    (s η τ : ℝ)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (hdist : NumStability.vecNorm2 (u - s • v) ≤ η) :
    misclassifiedIndices labels (s • v) X ⊆
      idealMarginErrors labels u X τ ∪ directionUnstableIndices X η τ := by
  intro i hi
  by_contra hnot
  rw [Set.mem_union, not_or] at hnot
  have hideal : τ < labels i * dotProduct u (X i) := by
    exact lt_of_not_ge hnot.1
  have hunstable : η * NumStability.vecNorm2 (X i) < τ := by
    exact lt_of_not_ge hnot.2
  have hcs := abs_dotProduct_le_vecNorm2_mul_vecNorm2 (u - s • v) (X i)
  have hnormX : 0 ≤ NumStability.vecNorm2 (X i) :=
    NumStability.vecNorm2_nonneg _
  have herr : |dotProduct (u - s • v) (X i)| < τ := by
    exact hcs.trans_lt ((mul_le_mul_of_nonneg_right hdist hnormX).trans_lt hunstable)
  have hdot : dotProduct u (X i) - dotProduct (s • v) (X i) =
      dotProduct (u - s • v) (X i) := by
    unfold dotProduct
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro j _hj
    simp [Pi.smul_apply]
    ring
  have hlabelAbs : |labels i| = 1 := by
    rcases hlabels i with h | h <;> simp [h]
  have hlerr : labels i * dotProduct (u - s • v) (X i) < τ := by
    calc
      labels i * dotProduct (u - s • v) (X i) ≤
          |labels i * dotProduct (u - s • v) (X i)| := le_abs_self _
      _ = |dotProduct (u - s • v) (X i)| := by rw [abs_mul, hlabelAbs, one_mul]
      _ < τ := herr
  change labels i * dotProduct (s • v) (X i) ≤ 0 at hi
  rw [← hdot] at hlerr
  nlinarith

/-- Cardinal form of the robust deterministic transfer. -/
theorem ncard_misclassified_le_ideal_add_unstable
    {m n : ℕ} (labels : Fin m → ℝ)
    (u v : Fin n → ℝ) (X : Fin m → Fin n → ℝ)
    (s η τ : ℝ)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (hdist : NumStability.vecNorm2 (u - s • v) ≤ η) :
    Set.ncard (misclassifiedIndices labels (s • v) X) ≤
      Set.ncard (idealMarginErrors labels u X τ) +
        Set.ncard (directionUnstableIndices X η τ) := by
  calc
    Set.ncard (misclassifiedIndices labels (s • v) X) ≤
        Set.ncard (idealMarginErrors labels u X τ ∪
          directionUnstableIndices X η τ) :=
      Set.ncard_le_ncard
        (misclassifiedIndices_subset_idealMarginErrors_union_unstable
          labels u v X s η τ hlabels hdist)
    _ ≤ Set.ncard (idealMarginErrors labels u X τ) +
        Set.ncard (directionUnstableIndices X η τ) := Set.ncard_union_le _ _

/-- The two half-budget bounds imply the source's `εm` conclusion. -/
theorem makesAtMostErrorsUpToSign_of_margin_and_direction
    {m n : ℕ} (labels : Fin m → ℝ)
    (u v : Fin n → ℝ) (X : Fin m → Fin n → ℝ)
    (s η τ ε : ℝ) (hs : s = -1 ∨ s = 1)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (hdist : NumStability.vecNorm2 (u - s • v) ≤ η)
    (hideal : (Set.ncard (idealMarginErrors labels u X τ) : ℝ) ≤ ε * m / 2)
    (hunstable : (Set.ncard (directionUnstableIndices X η τ) : ℝ) ≤
      ε * m / 2) :
    MakesAtMostErrorsUpToSign labels v X (ε * m) := by
  refine ⟨s, hs, ?_⟩
  have hcard := ncard_misclassified_le_ideal_add_unstable
    labels u v X s η τ hlabels hdist
  have hcardR : (Set.ncard (misclassifiedIndices labels (s • v) X) : ℝ) ≤
      (Set.ncard (idealMarginErrors labels u X τ) : ℝ) +
        (Set.ncard (directionUnstableIndices X η τ) : ℝ) := by
    exact_mod_cast hcard
  linarith

/-- Union-bound assembly for the last step of the Gaussian-mixture spectral
clustering proof.  Outside the covariance/eigenvector bad event and the ideal
classification bad event, the deterministic transfer must certify at most
`εm` errors (up to global sign). -/
theorem spectral_clustering_failure_tail_of_two_bad_events
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {m n : ℕ}
    (X : Ω → Fin m → Fin n → ℝ)
    (labels : Ω → Fin m → ℝ)
    (v : Ω → Fin n → ℝ) (ε : ℝ)
    (covarianceBad idealBad : Set Ω)
    (hcov : μ.real covarianceBad ≤ 2 * Real.exp (-(n : ℝ)))
    (hideal : μ.real idealBad ≤ 2 * Real.exp (-(n : ℝ)))
    (htransfer : ∀ ω, ω ∉ covarianceBad → ω ∉ idealBad →
      MakesAtMostErrorsUpToSign (labels ω) (v ω) (X ω) (ε * m)) :
    μ.real {ω | ¬ MakesAtMostErrorsUpToSign
        (labels ω) (v ω) (X ω) (ε * m)} ≤
      4 * Real.exp (-(n : ℝ)) := by
  have hsubset :
      {ω | ¬ MakesAtMostErrorsUpToSign
        (labels ω) (v ω) (X ω) (ε * m)} ⊆
        covarianceBad ∪ idealBad := by
    intro ω hω
    by_contra hnot
    rw [Set.mem_union, not_or] at hnot
    exact hω (htransfer ω hnot.1 hnot.2)
  calc
    μ.real {ω | ¬ MakesAtMostErrorsUpToSign
        (labels ω) (v ω) (X ω) (ε * m)} ≤
        μ.real (covarianceBad ∪ idealBad) :=
      measureReal_mono hsubset (by finiteness)
    _ ≤ μ.real covarianceBad + μ.real idealBad :=
      measureReal_union_le _ _
    _ ≤ 4 * Real.exp (-(n : ℝ)) := by linarith

/-- Quantitative assembly of the Gaussian-mixture spectral-clustering proof.

The model and top-Rayleigh hypotheses identify the source's sample and
algorithm.  The two explicit statistical inputs are precisely the conclusions
of covariance estimation/Davis--Kahan and ideal Gaussian sign recovery;
outside their bad events, the deterministic robust transfer yields the
`εm`-misclassification conclusion. -/
theorem exists_spectral_clustering_guarantee_of_covariance_and_margin_steps :
    ∃ C c : ℝ, 0 < C ∧ 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
        [IsProbabilityMeasure P] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (mean : Fin n → ℝ) (ε : ℝ),
        0 < ε →
        C * Real.sqrt (Real.log (1 / ε)) ≤ NumStability.vecNorm2 mean →
        Real.rpow ((n : ℝ) / NumStability.vecNorm2 mean) c ≤ (m : ℝ) →
        ∀ (labels : Ω → Fin m → ℝ)
          (X : Ω → Fin m → Fin n → ℝ)
          (v : Ω → Fin n → ℝ),
        HasLatentGaussianMixtureSampleLaw P labels X mean →
        (∀ ω, NumStability.HDP.Vector.SpectralClustering.IsTopRayleighVector
          (NumStability.HDP.Vector.SpectralClustering.clusteringSampleCovariance
            (X ω)) (v ω)) →
        (∀ ω i, labels ω i = -1 ∨ labels ω i = 1) →
        ∀ (η τ : ℝ), 0 ≤ η →
        ∀ (covarianceBad idealBad : Set Ω),
        P.real covarianceBad ≤ 2 * Real.exp (-(n : ℝ)) →
        P.real idealBad ≤ 2 * Real.exp (-(n : ℝ)) →
        (∀ ω, ω ∉ covarianceBad →
          ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
            NumStability.vecNorm2 (mean - s • v ω) ≤ η ∧
            (Set.ncard (directionUnstableIndices (X ω) η τ) : ℝ) ≤
              ε * m / 2) →
        (∀ ω, ω ∉ idealBad →
          (Set.ncard (idealMarginErrors (labels ω) mean (X ω) τ) : ℝ) ≤
            ε * m / 2) →
        P.real {ω | ¬ MakesAtMostErrorsUpToSign
          (labels ω) (v ω) (X ω) (ε * m)} ≤
            4 * Real.exp (-(n : ℝ)) := by
  refine ⟨1, 1, by norm_num, by norm_num, ?_⟩
  intro Ω _ P _ m n hm hn mean ε hε hsignal hsample labels X v hmodel hv
    hlabels η τ hη covarianceBad idealBad hcov hideal hdirection hidealCount
  apply spectral_clustering_failure_tail_of_two_bad_events
    X labels v ε covarianceBad idealBad hcov hideal
  intro ω hωcov hωideal
  obtain ⟨s, hs, hdist, hunstable⟩ := hdirection ω hωcov
  exact makesAtMostErrorsUpToSign_of_margin_and_direction
    (labels ω) mean (v ω) (X ω) s η τ ε hs (hlabels ω) hdist
      (hidealCount ω hωideal) hunstable

end NumStability.HDP.Vector.GaussianMixture
