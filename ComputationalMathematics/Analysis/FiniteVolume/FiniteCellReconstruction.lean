/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Notation.Indicator
import Mathlib.Data.Real.Basic
import Mathlib.Data.Fintype.Fin

set_option autoImplicit false

noncomputable section

open scoped BigOperators

namespace NumStability.Eymard.Chapter01

def finiteCellUnion {α : Type*} {n : ℕ} (K : Fin n → Set α) : Set α :=
  ⋃ i, K i

def finiteCellReconstruction {α : Type*} {n : ℕ}
    (K : Fin n → Set α) (U : Fin n → ℝ) (x : α) : ℝ :=
  ∑ i : Fin n, U i * (K i).indicator (fun _ => (1 : ℝ)) x

def finiteCellSkeletonExtension {α : Type*} {n : ℕ}
    (K : Fin n → Set α) (U : Fin n → ℝ) (g : α → ℝ) (x : α) : ℝ :=
  finiteCellReconstruction K U x + (finiteCellUnion K)ᶜ.indicator g x

end NumStability.Eymard.Chapter01
