import ComputationalMathematics.Source.LeVeque.Chapter01.Equation03AdvectedProfile

#check NumStability.leveque01_equation03_profilePropagates
#check NumStability.leveque01_equation03_scalarAdvection
#check NumStability.leveque01_equation03_advectedProfile

-- Re-elaborate the exact audited contracts after the namespace-preserving move
-- to the canonical `ComputationalMathematics` import tree.
example {E : Type*} (profile : ℝ → E) (speed x t : ℝ) :
    NumStability.travelingWave profile speed (x + speed * t) t = profile x :=
  NumStability.leveque01_equation03_profilePropagates profile speed x t

example {profile : ℝ → ℝ} {profile' speed x t : ℝ}
    (hprofile : HasDerivAt profile profile' (x - speed * t)) :
    NumStability.IsLinearAdvectionSolutionAt
      (NumStability.travelingWave profile speed) speed x t :=
  NumStability.leveque01_equation03_scalarAdvection hprofile

example (profile : ℝ → ℝ) (speed : ℝ) :
    (∀ x t,
      NumStability.travelingWave profile speed (x + speed * t) t = profile x) ∧
      (Differentiable ℝ profile →
        NumStability.IsLinearAdvectionSolution
          (NumStability.travelingWave profile speed) speed) :=
  NumStability.leveque01_equation03_advectedProfile profile speed

#print axioms NumStability.leveque01_equation03_profilePropagates
#print axioms NumStability.leveque01_equation03_scalarAdvection
#print axioms NumStability.leveque01_equation03_advectedProfile
