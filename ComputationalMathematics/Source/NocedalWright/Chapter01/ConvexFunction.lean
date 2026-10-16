import ComputationalMathematics.Source.NocedalWright.Chapter01.ConvexFunctionTarget

/-! # Nocedal--Wright convex functions -/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- Equation (1.4) agrees with `ConvexOn` on a convex domain. -/
theorem convexFunction14 : convexFunction14Target := by
  unfold convexFunction14Target
  intro n s f
  constructor
  · rintro ⟨hs, hf⟩
    refine ⟨hs, ?_⟩
    intro x hx y hy α hα0 hα1
    exact hf hx hy hα0 (sub_nonneg.mpr hα1) (by ring)
  · rintro ⟨hs, hf⟩
    refine ⟨hs, ?_⟩
    intro x hx y hy a b ha hb hab
    have hb_eq : b = 1 - a := by linarith
    rw [hb_eq]
    exact hf x hx y hy a ha (by linarith)

end ComputationalMathematics.Source.NocedalWright.Chapter01
