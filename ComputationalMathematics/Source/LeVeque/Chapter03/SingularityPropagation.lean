/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.InitialDataRegularity
import ComputationalMathematics.Source.LeVeque.Chapter03.RangeOfInfluence

/-!
# Initial singularities and characteristic rays

Printed page 52/raw PDF page 74. A regularity failure in the constructed
solution has an initial singularity at one of its backward characteristic
feet, hence lies on a forward ray from that initial point.
-/

namespace NumStability

/-- A solution regularity failure has at least one initial foot with the same
regularity failure. -/
theorem leveque03_solutionSingularity_hasInitialFoot
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (initialState : ℝ → (Fin m → ℝ))
    (X T : ℝ) (n : WithTop ℕ∞)
    (hsing : ¬ ContDiffAt ℝ n
      (fun z : ℝ × ℝ => leveque03_initialDataSolution eigenbasis speeds initialState z.1 z.2)
      (X, T)) :
    ∃ p, ¬ ContDiffAt ℝ n initialState (X - speeds p * T) := by
  by_contra hnone
  push_neg at hnone
  exact hsing (leveque03_initialDataSolution_contDiffAt
    eigenbasis speeds initialState X T n hnone)

/-- At nonnegative time, each solution singularity lies on a forward
characteristic ray from an initial point with a regularity failure. -/
theorem leveque03_solutionSingularity_onInitialRay
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (initialState : ℝ → (Fin m → ℝ))
    (X T : ℝ) (n : WithTop ℕ∞) (hT : 0 ≤ T)
    (hsing : ¬ ContDiffAt ℝ n
      (fun z : ℝ × ℝ => leveque03_initialDataSolution eigenbasis speeds initialState z.1 z.2)
      (X, T)) :
    ∃ origin : ℝ,
      ¬ ContDiffAt ℝ n initialState origin ∧
        (X, T) ∈ leveque03_rangeOfInfluence speeds origin := by
  obtain ⟨p, hp⟩ := leveque03_solutionSingularity_hasInitialFoot
    eigenbasis speeds initialState X T n hsing
  refine ⟨X - speeds p * T, hp, ⟨hT, p, ?_⟩⟩
  dsimp [leveque03_characteristicCurve]
  ring

end NumStability
