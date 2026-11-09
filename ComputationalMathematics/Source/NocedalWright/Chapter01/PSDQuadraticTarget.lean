import ComputationalMathematics.Optimization.Convex.Euclidean

open scoped Matrix

/-!
# Nocedal--Wright positive-semidefinite quadratic target
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The quadratic form `x ↦ xᵀHx` is convex when `H` is symmetric positive
semidefinite. -/
def psdQuadraticConvexTarget : Prop :=
  ∀ {n : ℕ} (H : Matrix (Fin n) (Fin n) ℝ),
    H.PosSemidef →
      ConvexOn ℝ Set.univ (fun x : Fin n → ℝ => (x ⬝ᵥ (H *ᵥ x)))

end ComputationalMathematics.Source.NocedalWright.Chapter01
