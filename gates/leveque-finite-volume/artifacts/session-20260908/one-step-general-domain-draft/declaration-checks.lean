import Mathlib.Data.Set.Operations
import Mathlib.Logic.Function.Basic
import ComputationalMathematics.Source.LeVeque.Chapter01.OneStepMethod

/-!
One-step dependence on arbitrary current data over arbitrary admissible histories.
The update is only defined on attainable current data. No nonempty output type
or extension to unattainable states is assumed. This is an unaudited draft.
-/

namespace NumStability.OneStepDomainDraft

/-- Constancy on current-data fibers is exactly factorization through attainable
current data. History may itself encode any admissibility restriction and current
data may include all independently varying auxiliary information. -/
theorem factorsThrough_iff_rangeFactorization
    {History : Sort*} {CurrentData : Type*} {NextData : Sort*}
    (current : History → CurrentData) (advance : History → NextData) :
    Function.FactorsThrough advance current ↔
      ∃ step : Set.range current → NextData,
        advance = step ∘ Set.rangeFactorization current := by
  constructor
  · intro hdependence
    obtain ⟨representative, hrepresentative⟩ :=
      (Set.rangeFactorization_surjective (f := current)).hasRightInverse
    refine ⟨advance ∘ representative, ?_⟩
    funext history
    apply hdependence
    exact (congrArg Subtype.val (hrepresentative (Set.rangeFactorization current history))).symm
  · rintro ⟨step, hstep⟩ history₁ history₂ hcurrent
    rw [hstep, Function.comp_apply, Function.comp_apply]
    exact congrArg step (Subtype.ext hcurrent)

/-- Explicit equal-current-data formulation, with no history or state model fixed. -/
theorem currentData_dependence_iff_range_update
    {History : Sort*} {CurrentData : Type*} {NextData : Sort*}
    (current : History → CurrentData) (advance : History → NextData) :
    (∀ history₁ history₂, current history₁ = current history₂ →
      advance history₁ = advance history₂) ↔
      ∃ step : Set.range current → NextData,
        advance = step ∘ Set.rangeFactorization current := by
  simpa only [Function.FactorsThrough] using
    factorsThrough_iff_rangeFactorization current advance

/-- Arbitrary admissible finite histories are handled by a subtype; no update
is requested on an inadmissible history or an unattainable final datum. -/
theorem admissibleFiniteHistory_iff_range_update
    {Data NextData : Type*} (n : ℕ)
    (admissible : Set (Fin (n + 1) → Data)) (advance : admissible → NextData) :
    (∀ history₁ history₂ : admissible,
      history₁.val (Fin.last n) = history₂.val (Fin.last n) →
      advance history₁ = advance history₂) ↔
      ∃ step : Set.range (fun history : admissible => history.val (Fin.last n)) → NextData,
        advance = step ∘ Set.rangeFactorization
          (fun history : admissible => history.val (Fin.last n)) :=
  currentData_dependence_iff_range_update _ _

/-- The unchanged source model is one specialization of the general theorem.
This bridge retains its numerical-field/history choices, without asserting that
those choices exhaust the source's intended data or admissibility domain. -/
theorem originalOneStep_iff_range_update
    {Cell : Type*} {m : ℕ} (n : ℕ)
    (advance : (Fin (n + 1) → (Cell → Fin m → ℝ)) → (Cell → Fin m → ℝ)) :
    leveque01IsOneStepMethodAt n advance ↔
      ∃ step : Set.range (fun history : Fin (n + 1) → (Cell → Fin m → ℝ) =>
          history (Fin.last n)) → (Cell → Fin m → ℝ),
        advance = step ∘ Set.rangeFactorization
          (fun history : Fin (n + 1) → (Cell → Fin m → ℝ) => history (Fin.last n)) :=
  factorsThrough_iff_rangeFactorization _ _

/-- Empty admissible history and empty output types remain valid. In this case
a map on all current data is impossible, whereas the required range update exists. -/
theorem emptyDomain_range_update_without_total_extension :
    (∃ step : Set.range (Empty.elim : Empty → Unit) → Empty,
      (Empty.elim : Empty → Empty) = step ∘ Set.rangeFactorization (Empty.elim : Empty → Unit)) ∧
    ¬ Nonempty (Unit → Empty) := by
  constructor
  · apply (currentData_dependence_iff_range_update
      (Empty.elim : Empty → Unit) (Empty.elim : Empty → Empty)).mp
    intro history
    exact history.elim
  · rintro ⟨step⟩
    exact (step ()).elim

/-- A nonempty example with auxiliary earlier information: the current datum
is the first coordinate, and the update ignores the independently varying past. -/
theorem nonempty_currentData_update_example :
    ∃ step : Set.range (Prod.fst : ℕ × Bool → ℕ) → ℕ,
      (fun history : ℕ × Bool => history.1 + 1) =
        step ∘ Set.rangeFactorization (Prod.fst : ℕ × Bool → ℕ) := by
  exact ⟨fun datum => datum.val + 1, rfl⟩

end NumStability.OneStepDomainDraft

#check NumStability.OneStepDomainDraft.factorsThrough_iff_rangeFactorization
#print axioms NumStability.OneStepDomainDraft.factorsThrough_iff_rangeFactorization
#check NumStability.OneStepDomainDraft.currentData_dependence_iff_range_update
#print axioms NumStability.OneStepDomainDraft.currentData_dependence_iff_range_update
#check NumStability.OneStepDomainDraft.admissibleFiniteHistory_iff_range_update
#print axioms NumStability.OneStepDomainDraft.admissibleFiniteHistory_iff_range_update
#check NumStability.OneStepDomainDraft.originalOneStep_iff_range_update
#print axioms NumStability.OneStepDomainDraft.originalOneStep_iff_range_update
#check NumStability.OneStepDomainDraft.emptyDomain_range_update_without_total_extension
#print axioms NumStability.OneStepDomainDraft.emptyDomain_range_update_without_total_extension
#check NumStability.OneStepDomainDraft.nonempty_currentData_update_example
#print axioms NumStability.OneStepDomainDraft.nonempty_currentData_update_example
#check Function.factorsThrough_iff
#print axioms Function.factorsThrough_iff
#check Function.Surjective.hasRightInverse
#print axioms Function.Surjective.hasRightInverse
#check Set.rangeFactorization_surjective
#print axioms Set.rangeFactorization_surjective
#check NumStability.leveque01_oneStepMethod_iff_currentStateMap
#print axioms NumStability.leveque01_oneStepMethod_iff_currentStateMap
