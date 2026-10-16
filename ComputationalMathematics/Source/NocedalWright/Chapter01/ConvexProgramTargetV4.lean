import ComputationalMathematics.Optimization.Modeling.Domains

/-!
# Nocedal--Wright convex-program definition target, revision 4
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

open ComputationalMathematics.Optimization.Modeling

/-- The source's convex-program class, with the domain and affine convention
made explicit for each objective and constraint function. -/
def convexProgramDefinitionTargetV4 : Prop :=
  ∀ {n : ℕ} {ε ι : Type}
    (objectiveDomain : Set (Fin n → ℝ))
    (equalityDomain : ε → Set (Fin n → ℝ))
    (inequalityDomain : ι → Set (Fin n → ℝ))
    (objective : (Fin n → ℝ) → ℝ)
    (equality : ε → (Fin n → ℝ) → ℝ)
    (inequality : ι → (Fin n → ℝ) → ℝ),
    IsConvexProgramOnDomains objectiveDomain equalityDomain inequalityDomain
      objective equality inequality ↔
      ConvexOn ℝ objectiveDomain objective ∧
        (∀ k, IsAffineOn (equalityDomain k) (equality k)) ∧
        ∀ k, ConcaveOn ℝ (inequalityDomain k) (inequality k)

end ComputationalMathematics.Source.NocedalWright.Chapter01
