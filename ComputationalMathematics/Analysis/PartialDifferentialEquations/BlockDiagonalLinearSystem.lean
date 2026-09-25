/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import Mathlib.Data.Matrix.Block

/-!
# Block-diagonal constant-coefficient linear systems

A source-independent pointwise splitting theorem for two systems.
-/

namespace NumStability

/-- A block-diagonal constant-coefficient system solves exactly when its two
component systems solve independently. -/
theorem isConstantCoefficientLinearSystemSolutionAt_fromBlocks_iff
    {ι κ : Type*} [Fintype ι] [Fintype κ]
    (p : ℝ → ℝ → (ι → ℝ)) (s : ℝ → ℝ → (κ → ℝ))
    (A : Matrix ι ι ℝ) (B : Matrix κ κ ℝ) (x t : ℝ) :
    IsConstantCoefficientLinearSystemSolutionAt
      (fun x t => Sum.elim (p x t) (s x t))
      (Matrix.fromBlocks A 0 0 B) x t ↔
    IsConstantCoefficientLinearSystemSolutionAt p A x t ∧
    IsConstantCoefficientLinearSystemSolutionAt s B x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, heq⟩
    constructor
    · refine ⟨qt ∘ Sum.inl, qx ∘ Sum.inl, ?_, ?_, ?_⟩
      · apply hasDerivAt_pi.mpr
        intro i
        simpa using (hasDerivAt_pi.mp ht (Sum.inl i))
      · apply hasDerivAt_pi.mpr
        intro i
        simpa using (hasDerivAt_pi.mp hx (Sum.inl i))
      · funext i
        have hi := congrFun heq (Sum.inl i)
        simpa [Matrix.fromBlocks_mulVec] using hi
    · refine ⟨qt ∘ Sum.inr, qx ∘ Sum.inr, ?_, ?_, ?_⟩
      · apply hasDerivAt_pi.mpr
        intro i
        simpa using (hasDerivAt_pi.mp ht (Sum.inr i))
      · apply hasDerivAt_pi.mpr
        intro i
        simpa using (hasDerivAt_pi.mp hx (Sum.inr i))
      · funext i
        have hi := congrFun heq (Sum.inr i)
        simpa [Matrix.fromBlocks_mulVec] using hi
  · rintro ⟨⟨pt, px, hpt, hpx, hp⟩, ⟨st, sx, hst, hsx, hs⟩⟩
    refine ⟨Sum.elim pt st, Sum.elim px sx, ?_, ?_, ?_⟩
    · apply hasDerivAt_pi.mpr
      intro i
      cases i with
      | inl j => simpa using (hasDerivAt_pi.mp hpt j)
      | inr j => simpa using (hasDerivAt_pi.mp hst j)
    · apply hasDerivAt_pi.mpr
      intro i
      cases i with
      | inl j => simpa using (hasDerivAt_pi.mp hpx j)
      | inr j => simpa using (hasDerivAt_pi.mp hsx j)
    · funext i
      cases i with
      | inl j => simpa [Matrix.fromBlocks_mulVec] using congrFun hp j
      | inr j => simpa [Matrix.fromBlocks_mulVec] using congrFun hs j

end NumStability
