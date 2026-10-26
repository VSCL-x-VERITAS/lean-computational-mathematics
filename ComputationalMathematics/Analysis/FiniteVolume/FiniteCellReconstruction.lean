/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Notation.Indicator
import Mathlib.Data.Real.Basic
import Mathlib.Data.Fintype.Fin

/-!
# Finite Cell Reconstruction

Transparent mathematical definitions used by the Chapter 1 formalization.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

open scoped BigOperators

namespace NumStability.Eymard.Chapter01

/-- Union of the finitely indexed cell regions. -/
def finiteCellUnion {α : Type*} {n : ℕ} (K : Fin n → Set α) : Set α :=
  ⋃ i, K i

/-- Finite cellwise reconstruction from the supplied cell values. -/
def finiteCellReconstruction {α : Type*} {n : ℕ}
    (K : Fin n → Set α) (U : Fin n → ℝ) (x : α) : ℝ :=
  ∑ i : Fin n, U i * (K i).indicator (fun _ => (1 : ℝ)) x

/-- Cellwise reconstruction with the supplied off-cell extension. -/
def finiteCellSkeletonExtension {α : Type*} {n : ℕ}
    (K : Fin n → Set α) (U : Fin n → ℝ) (g : α → ℝ) (x : α) : ℝ :=
  finiteCellReconstruction K U x + (finiteCellUnion K)ᶜ.indicator g x

end NumStability.Eymard.Chapter01
