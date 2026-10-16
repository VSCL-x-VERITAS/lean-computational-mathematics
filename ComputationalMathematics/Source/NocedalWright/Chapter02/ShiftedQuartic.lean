import ComputationalMathematics.Source.NocedalWright.Chapter02.ShiftedQuarticTarget

/-! The shifted-quartic example from Nocedal and Wright, Chapter 2. -/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The shifted quartic has a strict local minimum at two. -/
theorem shiftedQuarticStrictLocalMinimizer : shiftedQuarticStrictLocalTarget := by
  unfold shiftedQuarticStrictLocalTarget
  apply Filter.Eventually.of_forall
  intro y hy
  have hsub : y - 2 ≠ 0 := sub_ne_zero.mpr hy
  simpa using (Even.pow_pos (by decide : Even 4) hsub)

end ComputationalMathematics.Source.NocedalWright.Chapter02
