import ComputationalMathematics.Source.NocedalWright.Chapter01.LinearFunctionTarget

/-! # Nocedal--Wright affine functions are convex -/

open scoped BigOperators

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- Every finite-dimensional affine scalar function is convex. -/
theorem linearFunctionConvex : linearFunctionConvexTarget := by
  unfold linearFunctionConvexTarget
  intro n c α
  refine ⟨convex_univ, ?_⟩
  intro x _ y _ a b ha hb hab
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  apply le_of_eq
  have hsum : (∑ i, c i * (a * x i + b * y i)) =
      a * (∑ i, c i * x i) + b * (∑ i, c i * y i) := by
    calc
      _ = ∑ i, (a * (c i * x i) + b * (c i * y i)) := by
        apply Finset.sum_congr rfl
        intro i _
        ring
      _ = (∑ i, a * (c i * x i)) + ∑ i, b * (c i * y i) :=
        Finset.sum_add_distrib
      _ = _ := by rw [Finset.mul_sum, Finset.mul_sum]
  rw [hsum]
  calc
    a * (∑ i, c i * x i) + b * (∑ i, c i * y i) + α =
        a * (∑ i, c i * x i) + b * (∑ i, c i * y i) + (a + b) * α := by
          simp [hab]
    _ = a * ((∑ i, c i * x i) + α) + b * ((∑ i, c i * y i) + α) := by ring

end ComputationalMathematics.Source.NocedalWright.Chapter01
