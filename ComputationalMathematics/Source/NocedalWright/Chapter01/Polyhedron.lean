import ComputationalMathematics.Source.NocedalWright.Chapter01.PolyhedronTarget

/-! # Nocedal--Wright polyhedra are convex -/

open scoped Matrix

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- Sets cut out by linear equalities and inequalities are convex. -/
theorem polyhedronConvex : polyhedronConvexTarget := by
  unfold polyhedronConvexTarget
  intro n m p A C b d x hx y hy a β ha hβ hab
  rcases hx with ⟨hxA, hxC⟩
  rcases hy with ⟨hyA, hyC⟩
  constructor
  · rw [Matrix.mulVec_add, Matrix.mulVec_smul, Matrix.mulVec_smul, hxA, hyA]
    ext i
    simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    rw [← add_mul, hab, one_mul]
  · intro i
    rw [Matrix.mulVec_add, Matrix.mulVec_smul, Matrix.mulVec_smul]
    simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    calc
      a * (C *ᵥ x) i + β * (C *ᵥ y) i ≤ a * d i + β * d i :=
        add_le_add (mul_le_mul_of_nonneg_left (hxC i) ha)
          (mul_le_mul_of_nonneg_left (hyC i) hβ)
      _ = d i := by rw [← add_mul, hab, one_mul]

end ComputationalMathematics.Source.NocedalWright.Chapter01
