import Mathlib.Data.Fin.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Logic.Function.Basic

/-!
Scratch source-correspondence candidate for LeVeque, Chapter 1, printed 10,
raw PDF 32. This artifact is not a production declaration or a closed gate row.
At a fixed time level, all earlier numerical fields may be supplied, but the
next field must depend only on the last (current) one. The update may depend
on the chosen time level; no autonomous or fixed-step-size method is assumed.
-/

namespace NumStability

/-- Candidate meaning of one-step dependence at time level `n`. -/
abbrev leveque01IsOneStepMethodAt
    {Cell : Type*} {m : ℕ} (n : ℕ)
    (advance : (Fin (n + 1) → (Cell → Fin m → ℝ)) → (Cell → Fin m → ℝ)) :
    Prop :=
  Function.FactorsThrough advance (fun history => history (Fin.last n))

/-- One-step dependence is exactly representation by a map on the current
numerical field, with no dependence on earlier fields. -/
theorem leveque01_oneStepMethod_iff_currentStateMap
    {Cell : Type*} {m : ℕ} (n : ℕ)
    (advance : (Fin (n + 1) → (Cell → Fin m → ℝ)) → (Cell → Fin m → ℝ)) :
    leveque01IsOneStepMethodAt n advance ↔
      ∃ step : (Cell → Fin m → ℝ) → (Cell → Fin m → ℝ),
        advance = step ∘ (fun history => history (Fin.last n)) :=
  Function.factorsThrough_iff advance

#check Function.FactorsThrough
#check Function.factorsThrough_iff
#print axioms leveque01_oneStepMethod_iff_currentStateMap

end NumStability
