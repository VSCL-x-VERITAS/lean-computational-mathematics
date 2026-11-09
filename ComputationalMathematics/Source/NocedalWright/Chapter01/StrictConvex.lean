import ComputationalMathematics.Source.NocedalWright.Chapter01.StrictConvexTarget

/-! # Nocedal--Wright strict convexity -/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The strict form of (1.4) agrees with `StrictConvexOn`. -/
theorem strictConvexDefinition : strictConvexDefinitionTarget := by
  unfold strictConvexDefinitionTarget
  intro n s f
  constructor
  · rintro ⟨hs, hf⟩
    refine ⟨hs, ?_⟩
    intro x hx y hy hxy α hα0 hα1
    exact hf hx hy hxy hα0 (sub_pos.mpr hα1) (by ring)
  · rintro ⟨hs, hf⟩
    refine ⟨hs, ?_⟩
    intro x hx y hy hxy a b ha hb hab
    have hb_eq : b = 1 - a := by linarith
    rw [hb_eq]
    exact hf x hx y hy hxy a ha (by linarith)

end ComputationalMathematics.Source.NocedalWright.Chapter01
