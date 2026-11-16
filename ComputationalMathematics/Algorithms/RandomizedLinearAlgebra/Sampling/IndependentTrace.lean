import ComputationalMathematics.Analysis.FiniteProbability

/-! # Finite independent sampling traces

A supplied finite law gives the product law on a fixed number of draws.
No positivity of every atom is required: zero-mass atoms occur with probability zero.
-/

namespace NumStability.FiniteProbability
open scoped BigOperators

variable {Ω : Type*} [Fintype Ω]

/-- The exact iid law on `s` samples from `P`. -/
noncomputable def iid (P : FiniteProbability Ω) (s : ℕ) :
    FiniteProbability (Fin s → Ω) where
  prob ω := ∏ t, P.prob (ω t)
  prob_nonneg ω := Finset.prod_nonneg (fun t _ => P.prob_nonneg (ω t))
  prob_sum := by
    classical
    have h := Finset.prod_univ_sum
      (t := fun _ : Fin s => (Finset.univ : Finset Ω))
      (f := fun _ x => P.prob x)
    simpa [P.prob_sum] using h.symm

/-- A function of one draw has its supplied one-step expectation. -/
theorem iid_expectationReal_eval (P : FiniteProbability Ω) {s : ℕ}
    (t : Fin s) (f : Ω → ℝ) :
    (P.iid s).expectationReal (fun ω => f (ω t)) = P.expectationReal f := by
  classical
  have h := Finset.prod_univ_sum
    (t := fun _ : Fin s => (Finset.univ : Finset Ω))
    (f := fun k x => if k = t then P.prob x * f x else P.prob x)
  have hleft : (∏ k : Fin s, ∑ x ∈ (Finset.univ : Finset Ω),
      (if k = t then P.prob x * f x else P.prob x)) = P.expectationReal f := by
    simp [P.prob_sum, expectationReal]
  have hright : (∑ ω : Fin s → Ω,
      ∏ k, (if k = t then P.prob (ω k) * f (ω k) else P.prob (ω k))) =
      (P.iid s).expectationReal (fun ω => f (ω t)) := by
    change (∑ ω : Fin s → Ω, ∏ k,
      (if k = t then P.prob (ω k) * f (ω k) else P.prob (ω k))) =
      ∑ ω : Fin s → Ω, (∏ k, P.prob (ω k)) * f (ω t)
    apply Finset.sum_congr rfl
    intro ω _
    have h₁ := Finset.prod_eq_mul_prod_diff_singleton
      (s := (Finset.univ : Finset (Fin s))) t
      (fun k => if k = t then P.prob (ω k) * f (ω k) else P.prob (ω k))
      (by simp)
    have h₂ := Finset.prod_eq_mul_prod_diff_singleton
      (s := (Finset.univ : Finset (Fin s))) t (fun k => P.prob (ω k)) (by simp)
    simp only [if_pos] at h₁ h₂
    rw [h₁, h₂]
    have herase : (∏ k ∈ Finset.univ \ {t},
        (if k = t then P.prob (ω k) * f (ω k) else P.prob (ω k))) =
        ∏ k ∈ Finset.univ \ {t}, P.prob (ω k) := by
      apply Finset.prod_congr rfl
      intro k hk
      have hkt : k ≠ t := by simpa using hk
      simp [hkt]
    rw [herase]
    ring
  rw [← hright, ← hleft]
  simpa using h.symm

/-- All sampled atoms have positive supplied probability, almost surely. -/
theorem iid_eventProb_positive (P : FiniteProbability Ω) (s : ℕ) :
    (P.iid s).eventProb {ω | ∀ t, 0 < P.prob (ω t)} = 1 := by
  classical
  let E : Set (Fin s → Ω) := {ω | ∀ t, 0 < P.prob (ω t)}
  have hz : (P.iid s).eventProb Eᶜ = 0 := by
    unfold eventProb
    apply Finset.sum_eq_zero
    intro ω _
    by_cases he : ω ∈ Eᶜ
    · have hn : ¬ ∀ t, 0 < P.prob (ω t) := he
      obtain ⟨t, ht⟩ := not_forall.mp hn
      have ht0 : P.prob (ω t) = 0 := le_antisymm (le_of_not_gt ht) (P.prob_nonneg _)
      have hm : (P.iid s).prob ω = 0 := by
        exact Finset.prod_eq_zero (Finset.mem_univ t) ht0
      simp [he, hm]
    · simp [he]
  have hsplit := (P.iid s).eventProb_add_eventProb_compl E
  rw [hz] at hsplit
  simpa [E] using hsplit

end NumStability.FiniteProbability
