import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.IndependentTrace
import ComputationalMathematics.Analysis.FiniteProbabilityVariance
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-! Scalar moments for the literal finite iid trace law. -/

namespace NumStability.FiniteProbability
open scoped BigOperators
variable {Ω : Type*} [Fintype Ω]

/-- Product observables factor under the finite iid law. -/
theorem iid_expectationReal_prod (P : FiniteProbability Ω) (s : ℕ)
    (f : Fin s → Ω → ℝ) :
    (P.iid s).expectationReal (fun ω => ∏ t, f t (ω t)) =
      ∏ t, P.expectationReal (f t) := by
  classical
  have h := Finset.prod_univ_sum
    (t := fun _ : Fin s => (Finset.univ : Finset Ω))
    (f := fun t x => P.prob x * f t x)
  simpa [expectationReal, iid, Finset.prod_mul_distrib] using h.symm

/-- Distinct draws have the product of their one-step expectations. -/
theorem iid_expectationReal_mul_eval_ne (P : FiniteProbability Ω) {s : ℕ}
    (t u : Fin s) (htu : t ≠ u) (f g : Ω → ℝ) :
    (P.iid s).expectationReal (fun ω => f (ω t) * g (ω u)) =
      P.expectationReal f * P.expectationReal g := by
  classical
  let F : Fin s → Ω → ℝ := fun k x =>
    (if k = t then f x else 1) * (if k = u then g x else 1)
  have hpoint (ω : Fin s → Ω) : (∏ k, F k (ω k)) = f (ω t) * g (ω u) := by
    change (∏ k, (if k = t then f (ω k) else 1) *
      (if k = u then g (ω k) else 1)) = _
    rw [Finset.prod_mul_distrib]
    simp
  have hone (k : Fin s) : P.expectationReal (F k) =
      (if k = t then P.expectationReal f else 1) *
      (if k = u then P.expectationReal g else 1) := by
    by_cases ht : k = t
    · subst k
      simp [F, htu]
    · by_cases hu : k = u
      · subst k
        simp [F, htu.symm]
      · simp [F, ht, hu, expectationReal_const]
  have h := P.iid_expectationReal_prod s F
  simp_rw [hpoint, hone] at h
  rw [Finset.prod_mul_distrib] at h
  simpa using h

/-- The centered sum of iid scalar observations has variance `s` times the
one-observation variance. This uses independence of draws, not of coordinates. -/
theorem iid_expectationReal_centered_sum_sq (P : FiniteProbability Ω) (s : ℕ)
    (f : Ω → ℝ) :
    (P.iid s).expectationReal
      (fun ω => (∑ t : Fin s, (f (ω t) - P.expectationReal f)) ^ 2) =
      (s : ℝ) * P.varianceReal f := by
  classical
  let μ := P.expectationReal f
  have hcenter : P.expectationReal (fun x => f x - μ) = 0 := by
    rw [expectationReal_sub, expectationReal_const]
    exact sub_self _
  have hsame (t : Fin s) : (P.iid s).expectationReal
      (fun ω => (f (ω t) - μ) * (f (ω t) - μ)) = P.varianceReal f := by
    simpa only [varianceReal, μ, ← pow_two] using
      P.iid_expectationReal_eval t (fun x => (f x - μ) * (f x - μ))
  have hdiff (t u : Fin s) (htu : t ≠ u) : (P.iid s).expectationReal
      (fun ω => (f (ω t) - μ) * (f (ω u) - μ)) = 0 := by
    exact (P.iid_expectationReal_mul_eval_ne t u htu
      (fun x => f x - μ) (fun x => f x - μ)).trans (by rw [hcenter, zero_mul])
  have hsquare (ω : Fin s → Ω) :
      (∑ t : Fin s, (f (ω t) - μ)) ^ 2 =
        ∑ t : Fin s, ∑ u : Fin s, (f (ω t) - μ) * (f (ω u) - μ) := by
    rw [sq, Finset.sum_mul]
    simp_rw [Finset.mul_sum]
  change (P.iid s).expectationReal (fun ω => (∑ t : Fin s, (f (ω t) - μ)) ^ 2) = _
  simp_rw [hsquare, expectationReal_sum]
  have hinner (t : Fin s) :
      (∑ u : Fin s, (P.iid s).expectationReal
        (fun ω => (f (ω t) - μ) * (f (ω u) - μ))) = P.varianceReal f := by
    rw [← hsame t]
    apply Finset.sum_eq_single t
    · intro u _ hut
      exact hdiff t u hut.symm
    · intro ht
      exact False.elim (ht (Finset.mem_univ t))
  simp only [hinner, Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]

/-- Exact second moment of the scalar sample-average error. -/
theorem iid_expectationReal_sampleAverage_sub_mean_sq (P : FiniteProbability Ω)
    {s : ℕ} (hs : 0 < (s : ℝ)) (f : Ω → ℝ) :
    (P.iid s).expectationReal
      (fun ω => ((∑ t : Fin s, f (ω t)) / (s : ℝ) - P.expectationReal f) ^ 2) =
      P.varianceReal f / (s : ℝ) := by
  have hpoint (ω : Fin s → Ω) :
      (∑ t : Fin s, f (ω t)) / (s : ℝ) - P.expectationReal f =
        (∑ t : Fin s, (f (ω t) - P.expectationReal f)) / (s : ℝ) := by
    rw [Finset.sum_sub_distrib, Finset.sum_const]
    simp only [Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    field_simp [hs.ne']
  simp_rw [hpoint, div_pow, div_eq_mul_inv]
  rw [expectationReal_mul_const, iid_expectationReal_centered_sum_sq]
  field_simp

end NumStability.FiniteProbability
