/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.BiorthogonalSpanningUniqueTarget
import Mathlib.Analysis.InnerProductSpace.Basic

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01

/-- Bhatia, Exercise I.1.1: a spanning independent tuple has a unique biorthogonal tuple. -/
theorem biorthogonal_unique_spanning : Targets.biorthogonalUniqueSpanning.{u} := by
  intro H _ _ _ k X _hX hspan Y Z hY hZ
  funext i
  apply ext_inner_right ℂ
  intro v
  have hv : v ∈ Submodule.span ℂ (Set.range X) := by
    rw [hspan]
    exact Submodule.mem_top
  induction hv using Submodule.span_induction with
  | mem x hx =>
      obtain ⟨j, rfl⟩ := hx
      rw [hY i j, hZ i j]
  | zero => simp
  | add x y _hx _hy hx hy =>
      simp only [inner_add_right, hx, hy]
  | smul a x _hx hx =>
      simp only [inner_smul_right, hx]

end NumStability.Bhatia.Chapter01
