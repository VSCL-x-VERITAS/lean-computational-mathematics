import ComputationalMathematics.Optimization.Modeling.Basic

/-!
# Convex programs with explicit function domains

The domain sets record where each function is part of the optimization problem.
Values of the total Lean functions outside those sets are immaterial.
-/

noncomputable section

namespace ComputationalMathematics.Optimization.Modeling

/-- A function agrees on `s` with a real linear map plus a constant. -/
def IsAffineOn {X : Type} [AddCommGroup X] [Module ℝ X]
    (s : Set X) (f : X → ℝ) : Prop :=
  ∃ (linear : X →ₗ[ℝ] ℝ) (offset : ℝ), ∀ x ∈ s, f x = linear x + offset

/-- Classification of a constrained program by the shape of each function on
its declared domain. Equality functions use the affine convention of the source. -/
def IsConvexProgramOnDomains {X : Type} [AddCommGroup X] [Module ℝ X]
    {ε ι : Type} (objectiveDomain : Set X)
    (equalityDomain : ε → Set X) (inequalityDomain : ι → Set X)
    (objective : X → ℝ) (equality : ε → X → ℝ)
    (inequality : ι → X → ℝ) : Prop :=
  ConvexOn ℝ objectiveDomain objective ∧
    (∀ k, IsAffineOn (equalityDomain k) (equality k)) ∧
    ∀ k, ConcaveOn ℝ (inequalityDomain k) (inequality k)

end ComputationalMathematics.Optimization.Modeling
