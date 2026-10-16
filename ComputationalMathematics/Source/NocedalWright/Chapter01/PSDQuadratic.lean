import ComputationalMathematics.Source.NocedalWright.Chapter01.PSDQuadraticTarget

/-! # Nocedal--Wright positive-semidefinite quadratics -/

open scoped Matrix

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- A quadratic form with a symmetric positive-semidefinite matrix is convex. -/
theorem psdQuadraticConvex : psdQuadraticConvexTarget := by
  unfold psdQuadraticConvexTarget
  intro n H hH
  refine ⟨convex_univ, ?_⟩
  intro x _ y _ a b ha hb hab
  have hsymm : Hᵀ = H := by
    simpa [Matrix.conjTranspose] using hH.isHermitian.eq
  have hcross : x ⬝ᵥ (H *ᵥ y) = y ⬝ᵥ (H *ᵥ x) := by
    calc
      x ⬝ᵥ (H *ᵥ y) = (x ᵥ* H) ⬝ᵥ y := Matrix.dotProduct_mulVec x H y
      _ = (Hᵀ *ᵥ x) ⬝ᵥ y := by
        rw [show x ᵥ* H = Hᵀ *ᵥ x by
          simpa using Matrix.vecMul_transpose Hᵀ x]
      _ = (H *ᵥ x) ⬝ᵥ y := by rw [hsymm]
      _ = y ⬝ᵥ (H *ᵥ x) := dotProduct_comm _ _
  have hdiff : 0 ≤ (x - y) ⬝ᵥ (H *ᵥ (x - y)) := by
    simpa using hH.dotProduct_mulVec_nonneg (x - y)
  change (a • x + b • y) ⬝ᵥ (H *ᵥ (a • x + b • y)) ≤
    a * (x ⬝ᵥ (H *ᵥ x)) + b * (y ⬝ᵥ (H *ᵥ y))
  rw [Matrix.mulVec_add, Matrix.mulVec_smul, Matrix.mulVec_smul]
  simp only [add_dotProduct, dotProduct_add, smul_dotProduct, dotProduct_smul,
    smul_eq_mul]
  simp only [Matrix.mulVec_sub, sub_dotProduct, dotProduct_sub] at hdiff
  rw [hcross] at hdiff
  rw [hcross]
  have hab0 : 0 ≤ a * b := mul_nonneg ha hb
  have hq : 0 ≤ (x ⬝ᵥ (H *ᵥ x)) - 2 * (y ⬝ᵥ (H *ᵥ x)) +
      (y ⬝ᵥ (H *ᵥ y)) := by linarith
  have hprod := mul_nonneg hab0 hq
  have hb_eq : b = 1 - a := by linarith
  calc
    a * (a * (x ⬝ᵥ (H *ᵥ x)) + b * (y ⬝ᵥ (H *ᵥ x))) +
        b * (a * (y ⬝ᵥ (H *ᵥ x)) + b * (y ⬝ᵥ (H *ᵥ y))) =
      a * (x ⬝ᵥ (H *ᵥ x)) + b * (y ⬝ᵥ (H *ᵥ y)) -
        a * b * ((x ⬝ᵥ (H *ᵥ x)) - 2 * (y ⬝ᵥ (H *ᵥ x)) +
          (y ⬝ᵥ (H *ᵥ y))) := by rw [hb_eq]; ring
    _ ≤ a * (x ⬝ᵥ (H *ᵥ x)) + b * (y ⬝ᵥ (H *ᵥ y)) := sub_le_self _ hprod

end ComputationalMathematics.Source.NocedalWright.Chapter01
