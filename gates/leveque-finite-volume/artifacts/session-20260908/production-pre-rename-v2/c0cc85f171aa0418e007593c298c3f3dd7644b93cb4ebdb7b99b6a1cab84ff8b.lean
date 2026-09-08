/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Fin.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Logic.Function.Basic

/-!
# LeVeque Chapter 1, one-step dependence

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 10 (raw PDF page 32). At a fixed time level the next numerical field
depends only on the current field. The update may depend on the chosen time level.
-/

namespace NumStability

/-- One-step dependence at time level `n`. -/
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


end NumStability
