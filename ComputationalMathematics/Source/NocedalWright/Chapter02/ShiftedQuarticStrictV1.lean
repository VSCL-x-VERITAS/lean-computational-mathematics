import ComputationalMathematics.Source.NocedalWright.Chapter02.ShiftedQuarticStrictTargetV1
import Mathlib.Algebra.Order.Ring.Basic

/-!
The shifted-quartic example on printed page 13 of Nocedal and Wright,
*Numerical Optimization*, second edition.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The shifted quartic has a strict local minimum at `2`. -/
theorem shiftedQuarticStrictV1 : shiftedQuarticStrictTargetV1 := by
  refine ⟨Set.univ, isOpen_univ, Set.mem_univ _, ?_⟩
  intro x _ hx
  have hpos : (0 : ℝ) < (x - 2) ^ 4 :=
    (show Even 4 from ⟨2, rfl⟩).pow_pos (sub_ne_zero.mpr hx)
  simpa using hpos

end ComputationalMathematics.Source.NocedalWright.Chapter02
