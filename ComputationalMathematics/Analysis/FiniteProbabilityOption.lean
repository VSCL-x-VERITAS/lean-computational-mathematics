import ComputationalMathematics.Analysis.FiniteProbability

/-! Finite laws with an explicit deterministic fallback outcome. -/

namespace NumStability.FiniteProbability

variable {Ω : Type*} [Fintype Ω]

attribute [local instance] Classical.propDecidable

/-- Lift a finite law to `Option Ω`, assigning zero mass to `none`. -/
noncomputable def onSome (P : FiniteProbability Ω) : FiniteProbability (Option Ω) where
  prob := fun o => o.elim 0 P.prob
  prob_nonneg := by intro o; cases o <;> simp [P.prob_nonneg]
  prob_sum := by simp [Fintype.sum_option, P.prob_sum]

/-- The deterministic law which always returns `none`. -/
noncomputable def atNone : FiniteProbability (Option Ω) where
  prob := fun o => o.elim 1 (fun _ => 0)
  prob_nonneg := by intro o; cases o <;> simp
  prob_sum := by simp [Fintype.sum_option]

theorem eventProb_onSome (P : FiniteProbability Ω) (E : Set (Option Ω)) :
    (onSome P).eventProb E = P.eventProb {x | some x ∈ E} := by
  classical
  simp only [eventProb, onSome, Fintype.sum_option]
  simp only [Option.elim_none, Option.elim_some, ite_self, zero_add]
  rfl

theorem eventProb_atNone (E : Set (Option Ω)) :
    (atNone : FiniteProbability (Option Ω)).eventProb E =
      if none ∈ E then 1 else 0 := by
  classical
  simp [eventProb, atNone, Fintype.sum_option]

end NumStability.FiniteProbability
