import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise476.CounterexampleScalar
import ComputationalMathematics.HDP.Vector.GaussianMixtureCounterexample

/-!
# Canonical Gaussian-mixture counterexample for Chapter 4

Source-facing assembly of the scalar family and reusable Gaussian-testing
obstruction. The coordinate-supported signal contradicts the printed recovery
guarantee; the corrected source result remains separately named and audited.
-/

noncomputable section

open Filter MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Contract.Theorem475Counterexample

open NumStability.HDP.Contract.Exercise476CounterexampleScalar
open NumStability.HDP.Probability

/-- Source-facing alias for the reusable coordinate-supported signal. -/
abbrev coordinateMean {n : ℕ} (hn : 0 < n) (r : ℝ) : Fin n → ℝ :=
  NumStability.HDP.Vector.GaussianMixture.coordinateMean r ⟨0, hn⟩


lemma vecNorm2_coordinateMean {n : ℕ} (hn : 0 < n) {r : ℝ} (hr : 0 ≤ r) :
    NumStability.vecNorm2 (coordinateMean hn r) = r := by
  simpa [coordinateMean, abs_of_nonneg hr] using
    NumStability.HDP.Vector.GaussianMixture.vecNorm2_coordinateMean
      r ⟨0, hn⟩

/-- At `epsilon = 1/(2m)`, the real-valued error allowance is exactly one half. -/
lemma epsilon_mul_sampleSize {m : ℕ} (hm : 0 < m) :
    epsilon m * (m : ℝ) = 1 / 2 := by
  unfold epsilon
  have hmR : (m : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hm)
  field_simp

lemma epsilon_mul_sampleSize_lt_one {m : ℕ} (hm : 0 < m) :
    epsilon m * (m : ℝ) < 1 := by
  rw [epsilon_mul_sampleSize hm]
  norm_num

/-- A pointwise capstone: once the scalar family has all its eventual
properties, the printed probability conclusion fails for its coordinate
signal. -/
theorem counterexample_at
    {A c : ℝ} (hA : 0 < A) (hc : 0 < c) {k : ℕ}
    (hk2 : 2 ≤ k) (hn : 0 < dimension A c k)
    (hscale : 4 * Real.exp (-((dimension A c k : ℕ) : ℝ)) <
      gaussianIntervalFloorReal (radius A k)) :
    let mean : Fin (dimension A c k) → ℝ :=
      coordinateMean hn (radius A k)
    0 < epsilon k ∧
    A * Real.sqrt (Real.log (1 / epsilon k)) ≤ NumStability.vecNorm2 mean ∧
    Real.rpow (((dimension A c k : ℕ) : ℝ) /
      NumStability.vecNorm2 mean) c ≤ (k : ℝ) ∧
    4 * Real.exp (-((dimension A c k : ℕ) : ℝ)) <
      (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure
        k (dimension A c k)).real
          {ω | ¬ NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
            (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
            (fun j ↦
              NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
                hn
                (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i) j)
            (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i)
            (epsilon k * k)} := by
  dsimp only
  have hk1 : 1 ≤ k := le_trans (by omega : 1 ≤ 2) hk2
  have hr : 0 < radius A k := radius_pos hA hk1
  have hnorm : NumStability.vecNorm2 (coordinateMean hn (radius A k)) =
      radius A k := vecNorm2_coordinateMean hn hr.le
  refine ⟨epsilon_pos hk1, ?_, ?_, ?_⟩
  · rw [hnorm]
    exact (printed_separation A hk1).le
  · rw [hnorm]
    exact printed_sample_size hA hc hk1
  · refine hscale.trans_le ?_
    exact
      NumStability.HDP.Vector.GaussianMixture.coordinateMean_canonical_spectral_partitionFailure_real_lower
        hk2 hn (radius A k) (epsilon k * k) hr.le
        (epsilon_mul_sampleSize_lt_one (lt_of_lt_of_le Nat.zero_lt_two hk2))

/-- For every pair of positive printed constants, the coordinate-supported
counterexample family eventually satisfies both printed hypotheses while the
claimed `4 exp (-n)` failure upper bound is false. -/
theorem eventually_coordinate_counterexample
    {A c : ℝ} (hA : 0 < A) (hc : 0 < c) :
    ∀ᶠ k : ℕ in atTop,
      0 < k ∧ ∃ (hn : 0 < dimension A c k),
        let mean : Fin (dimension A c k) → ℝ :=
          coordinateMean hn (radius A k)
        0 < epsilon k ∧
        A * Real.sqrt (Real.log (1 / epsilon k)) ≤ NumStability.vecNorm2 mean ∧
        Real.rpow (((dimension A c k : ℕ) : ℝ) /
          NumStability.vecNorm2 mean) c ≤ (k : ℝ) ∧
        4 * Real.exp (-((dimension A c k : ℕ) : ℝ)) <
          (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure
            k (dimension A c k)).real
            {ω | ¬ NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
              (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
              (fun j ↦
                NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
                  hn
                  (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i) j)
              (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i)
              (epsilon k * k)} := by
  have hnEventually : ∀ᶠ k : ℕ in atTop, 0 < dimension A c k :=
    (tendsto_dimension A c hA hc).eventually_gt_atTop 0
  filter_upwards [eventually_ge_atTop 2, hnEventually,
      eventually_four_exp_neg_dimension_lt_gaussianIntervalFloorReal hA hc] with
      k hk2 hn hscale
  exact ⟨lt_of_lt_of_le Nat.zero_lt_two hk2, hn,
    counterexample_at hA hc hk2 hn hscale⟩

/-- The literal printed finite-sample claim, with its original `epsilon * m`
budget rather than the library's audited `max epsilon (1/2) * m` weakening. -/
def PrintedTheorem475 : Prop :=
  ∃ Csignal c : ℝ,
    0 < Csignal ∧ 0 < c ∧
    ∀ {m n : ℕ}, (hm : 0 < m) → (hn : 0 < n) →
      ∀ (mean : Fin n → ℝ) (ε : ℝ),
        0 < ε →
        Csignal * Real.sqrt (Real.log (1 / ε)) ≤
          NumStability.vecNorm2 mean →
        Real.rpow ((n : ℝ) / NumStability.vecNorm2 mean) c ≤ (m : ℝ) →
        (NumStability.HDP.Vector.GaussianMixture.latentNoiseSampleMeasure m n).real
            {ω | ¬ NumStability.HDP.Vector.GaussianMixture.MakesAtMostPartitionErrorsUpToSwap
              (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalLabel ω i)
              (fun j ↦
                NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
                  hn
                  (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalPoint
                    mean ω i) j)
              (fun i ↦ NumStability.HDP.Vector.GaussianMixture.canonicalPoint mean ω i)
              (ε * m)} ≤
          4 * Real.exp (-(n : ℝ))

/-- The printed theorem is false for every proposed pair of positive
constants. -/
theorem not_printedTheorem475 :
    ¬ PrintedTheorem475 := by
  rintro ⟨A, c, hA, hc, hclaim⟩
  obtain ⟨k, hk, hn, hε, hseparation, hsample, hfailureStrict⟩ :=
    (eventually_coordinate_counterexample hA hc).exists
  let mean : Fin (dimension A c k) → ℝ := coordinateMean hn (radius A k)
  have hupper := hclaim hk hn mean (epsilon k) hε hseparation hsample
  exact (not_lt_of_ge hupper) hfailureStrict

end NumStability.HDP.Contract.Theorem475Counterexample

namespace NumStability.HDP.Contract

/-- The exact first-edition Theorem 4.7.5 claim is contradicted by the
coordinate-supported canonical family. -/
theorem hdp_04_theorem_4_7_5_printed_statement_counterexample :
    ¬ Theorem475Counterexample.PrintedTheorem475 :=
  Theorem475Counterexample.not_printedTheorem475

/-- Exercise 4.7.6 asks for a proof of the same printed probability claim, so
the canonical counterexample also refutes its requested final conclusion. -/
theorem hdp_04_exercise_4_7_6_printed_conclusion_counterexample :
    ¬ Theorem475Counterexample.PrintedTheorem475 :=
  hdp_04_theorem_4_7_5_printed_statement_counterexample

end NumStability.HDP.Contract
