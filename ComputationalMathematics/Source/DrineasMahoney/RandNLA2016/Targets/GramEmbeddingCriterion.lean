import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.Core

/-! # Equation (7) as a success criterion

This is a condition on an arbitrary sketch, not a claim that a particular
randomized construction succeeds. Its quadratic criterion holds simultaneously
for every coefficient vector and includes zero coefficient dimension.
-/
namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Eq. (7)'s identity-Gram equality and its exact all-vector interpretation. -/
def gramEmbeddingCriterion : Prop :=
  ∀ (m d t : ℕ) (U : Matrix (Fin m) (Fin d) ℝ)
    (B : Matrix (Fin t) (Fin d) ℝ), HasOrthonormalColumns U →
    ∀ ε : ℝ, 0 < ε → ε < 1 →
      opNorm2 (fun i j => rowGram U i j - rowSketchGram B i j) =
        opNorm2 (fun i j => idMatrix d i j - rowSketchGram B i j) ∧
      (opNorm2 (fun i j => idMatrix d i j - rowSketchGram B i j) ≤ ε ↔
        ∀ x : Fin d → ℝ,
          |vecNorm2Sq (B.mulVec x) - vecNorm2Sq x| ≤ ε * vecNorm2Sq x) ∧
      (opNorm2 (fun i j => idMatrix d i j - rowSketchGram B i j) ≤ ε ↔
        ∀ x : Fin d → ℝ,
          (1 - ε) * vecNorm2Sq x ≤ vecNorm2Sq (B.mulVec x) ∧
          vecNorm2Sq (B.mulVec x) ≤ (1 + ε) * vecNorm2Sq x)

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
