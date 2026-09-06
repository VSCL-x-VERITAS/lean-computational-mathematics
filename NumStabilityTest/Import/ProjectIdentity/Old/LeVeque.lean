import NumStability.Source.LeVeque.Chapter01.Equation03AdvectedProfile

/-! Project identity migration: old import API regression. -/

#check NumStability.leveque01_equation03_advectedProfile

open NumStability

example (profile : ℝ → ℝ) (speed x t : ℝ) :
    travelingWave profile speed (x + speed * t) t = profile x :=
  (leveque01_equation03_advectedProfile profile speed).1 x t

example (profile : ℝ → ℝ) (speed : ℝ) (hp : Differentiable ℝ profile) :
    IsLinearAdvectionSolution (travelingWave profile speed) speed :=
  (leveque01_equation03_advectedProfile profile speed).2 hp
