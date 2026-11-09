import ComputationalMathematics.Source.NocedalWright.Chapter01.ConvexSetTarget

/-! # Nocedal--Wright convex sets -/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The source's line-segment definition agrees with `Convex`. -/
theorem convexSetDefinition : convexSetDefinitionTarget := by
  unfold convexSetDefinitionTarget
  intro n s
  constructor
  · intro hs x hx y hy α hα0 hα1
    exact hs hx hy hα0 (sub_nonneg.mpr hα1) (by ring)
  · intro h x hx y hy a b ha hb hab
    have hb_eq : b = 1 - a := by linarith
    rw [hb_eq]
    exact h x hx y hy a ha (by linarith)

end ComputationalMathematics.Source.NocedalWright.Chapter01
