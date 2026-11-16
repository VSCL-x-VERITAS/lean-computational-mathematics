import ComputationalMathematics.Analysis.FiniteProbabilityOption
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.Elementwise.NonzeroCardinality
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Concentration.SpectralTransfer.Elementwise
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Algorithm01.ElementwiseSampling.HitCountConcentration

/-!
# Thresholded entry sampling, including the deterministic zero branch

Reference 18 of the RandNLA survey thresholds before sampling. This differs from
its raw Algorithm 1: the thresholded estimator is unbiased for the thresholded
matrix. When that matrix is zero, the local proof in Drineas--Zouzias returns
zero without sampling. `none` records that deterministic branch; `some samples`
records the independent with-replacement trace. Zero-probability traces may be
represented, but never contribute probability mass.
-/

namespace NumStability

open scoped BigOperators

/-- The complete thresholded law. It never normalizes a zero Frobenius denominator. -/
noncomputable def truncatedElementwiseProbability {m n s : ℕ}
    (tau : ℝ) (A : Fin m → Fin n → ℝ) :
    FiniteProbability (Option (ElementwiseTrace m n s)) := by
  classical
  exact if h : 0 < sqMagProbDen (elementwiseTruncate tau A) then
    FiniteProbability.onSome (sqMagTraceProbability (steps := s) (elementwiseTruncate tau A) h)
  else FiniteProbability.atNone

/-- Accumulated inverse-probability sketch, or the zero sketch in the zero branch. -/
noncomputable def truncatedElementwiseSketch {m n s : ℕ}
    (tau : ℝ) (A : Fin m → Fin n → ℝ)
    (outcome : Option (ElementwiseTrace m n s)) : Fin m → Fin n → ℝ :=
  outcome.elim (fun _ _ => 0)
    (fun samples => elementwiseTraceSketch s (elementwiseTruncate tau A)
      (fun _ _ => 0) samples)

theorem truncatedElementwiseProbability_eventProb_of_pos {m n s : ℕ}
    (tau : ℝ) (A : Fin m → Fin n → ℝ)
    (hden : 0 < sqMagProbDen (elementwiseTruncate tau A))
    (E : Set (Option (ElementwiseTrace m n s))) :
    (truncatedElementwiseProbability tau A).eventProb E =
      (sqMagTraceProbability (steps := s) (elementwiseTruncate tau A) hden).eventProb
        {samples | some samples ∈ E} := by
  classical
  simp only [truncatedElementwiseProbability, dif_pos hden]
  exact FiniteProbability.eventProb_onSome _ _

theorem truncatedElementwiseProbability_eventProb_of_not_pos {m n s : ℕ}
    (tau : ℝ) (A : Fin m → Fin n → ℝ)
    (hden : ¬ 0 < sqMagProbDen (elementwiseTruncate tau A))
    (E : Set (Option (ElementwiseTrace m n s))) :
    (truncatedElementwiseProbability tau A).eventProb E =
      (FiniteProbability.atNone : FiniteProbability (Option (ElementwiseTrace m n s))).eventProb E := by
  classical
  simp [truncatedElementwiseProbability, hden]

/-- A nonpositive sum of squares means every thresholded entry is zero. -/
theorem elementwiseTruncate_eq_zero_of_not_pos {m n : ℕ}
    (tau : ℝ) (A : Fin m → Fin n → ℝ)
    (hden : ¬ 0 < sqMagProbDen (elementwiseTruncate tau A)) :
    elementwiseTruncate tau A = fun _ _ => 0 := by
  have hzero : frobNormSqRect (elementwiseTruncate tau A) = 0 := by
    exact le_antisymm (le_of_not_gt hden) (frobNormSqRect_nonneg _)
  have heach := (frobNormSqRect_eq_zero_iff _).mp hzero
  exact funext fun i => funext fun j => heach i j

/-- The zero branch has deterministic error at most half the requested accuracy. -/
theorem truncatedElementwiseSketch_none_error {n s : ℕ}
    (A : Fin n → Fin n → ℝ) {eps : ℝ} (heps : 0 ≤ eps) (hn : 0 < n)
    (hden : ¬ 0 < sqMagProbDen (elementwiseTruncate (eps / (2 * (n : ℝ))) A)) :
    rectOpNorm2Le (fun i j => A i j -
      truncatedElementwiseSketch (s := s) (eps / (2 * (n : ℝ))) A none i j) (eps / 2) := by
  have htrunc := elementwiseTruncate_eq_zero_of_not_pos _ A hden
  simpa [htrunc, truncatedElementwiseSketch] using
    elementwiseTruncate_square_error_rectOpNorm2Le_half (eps := eps) A heps hn

/-- A trace has at most `s` nonzero coordinates, even when it repeats entries. -/
theorem truncatedElementwiseSketch_nonzero_card_le {m n s : ℕ}
    (tau : ℝ) (A : Fin m → Fin n → ℝ)
    (outcome : Option (ElementwiseTrace m n s)) :
    (Finset.univ.filter (fun ij : Fin m × Fin n =>
      truncatedElementwiseSketch tau A outcome ij.1 ij.2 ≠ 0)).card ≤ s := by
  classical
  cases outcome with
  | none => simp [truncatedElementwiseSketch]
  | some samples =>
    exact elementwiseTraceSketch_nonzero_card_le s (elementwiseTruncate tau A) samples

end NumStability
