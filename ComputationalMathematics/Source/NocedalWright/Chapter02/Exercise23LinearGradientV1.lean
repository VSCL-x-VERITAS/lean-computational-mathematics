import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise23LinearGradientTargetV1

/-!
The gradient of a linear functional in Nocedal and Wright,
*Numerical Optimization*, second edition, Exercise 2.3.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The linear functional `x ↦ ⟪a, x⟫` has gradient `a`. -/
theorem exercise23LinearGradientV1 : exercise23LinearGradientTargetV1 := by
  intro n _ a x
  have h : HasGradientAt (fun y : EuclideanSpace ℝ (Fin n) => inner ℝ a y) a x := by
    apply hasGradientAt_iff_hasFDerivAt.mpr
    exact (InnerProductSpace.toDual ℝ (EuclideanSpace ℝ (Fin n)) a).hasFDerivAt
  exact ⟨h.differentiableAt, h.gradient⟩

end ComputationalMathematics.Source.NocedalWright.Chapter02
