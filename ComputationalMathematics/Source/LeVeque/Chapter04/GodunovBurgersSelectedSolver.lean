/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersInitialPotential
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectanglePi

/-!
# Selected scalar Burgers Riemann solver

Ascending states use the centered rarefaction for positive time;
descending states use the Rankine--Hugoniot moving jump. Both choices
have the exact initial data and satisfy the shared rectangle law.
The rectangle certificate does not by itself encode entropy admissibility.
-/

namespace NumStability

/-- The Burgers shock/rarefaction branch choice on every ordered pair. -/
noncomputable def leveque04_burgersSelectedField (left right x t : ℝ) : ℝ :=
  if left ≤ right then leveque04_burgersRarefactionGlobalCandidate left right x t
  else travelingWave (riemannData left right right) ((left + right) / 2) x t

theorem leveque04_burgersSelectedField_initial (left right x : ℝ) :
    leveque04_burgersSelectedField left right x 0 = riemannData left right right x := by
  unfold leveque04_burgersSelectedField
  split_ifs
  · exact leveque04_burgersRarefactionGlobalCandidate_initial left right x
  · simp [travelingWave]

theorem leveque04_burgersSelectedField_isRectangleSolution (left right : ℝ) :
    IsRectangleConservationLawSolution
      (leveque04_burgersSelectedField left right) (fun u : ℝ => u ^ 2 / 2) := by
  by_cases horder : left ≤ right
  · have heq : leveque04_burgersSelectedField left right =
        leveque04_burgersRarefactionGlobalCandidate left right := by
      funext x t
      simp [leveque04_burgersSelectedField, horder]
    rw [heq]
    exact leveque04_burgersRarefactionGlobalCandidate_isRectangleSolution left right horder
  · have heq : leveque04_burgersSelectedField left right =
        travelingWave (riemannData left right right) ((left + right) / 2) := by
      funext x t
      simp [leveque04_burgersSelectedField, horder]
    rw [heq]
    exact leveque04_burgersRarefaction_backwardJump_rectangle left right

theorem leveque04_burgersSelectedField_constant (state x t : ℝ) :
    leveque04_burgersSelectedField state state x t = state := by
  unfold leveque04_burgersSelectedField
  simp only [le_refl, if_true, leveque04_burgersRarefactionGlobalCandidate]
  split_ifs
  · simp [travelingWave, riemannData]
  · exact max_eq_left (min_le_right (x / t) state)

/-- The scalar Burgers identity determines the entire one-coordinate
physical flux, without assuming a second flux representation. -/
theorem leveque04_burgersPhysicalFlux_eq
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ, law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2) :
    law.physicalFlux = fun state _ => (state 0) ^ 2 / 2 := by
  funext state i
  fin_cases i
  have hstate : state = fun _ : Fin 1 => state 0 := by
    funext j
    fin_cases j
    rfl
  rw [hstate]
  exact hburgers (state 0)

/-- Every scalar ordered pair now has a constructed rectangle-certified
Burgers solver; no Riemann-solution existence premise is required. -/
noncomputable def leveque04_burgersSelectedSolve
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ, law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (problem : HyperbolicRiemannProblem law) :
    CertifiedRectangleRiemannSolution law problem where
  solution := fun x t _ =>
    leveque04_burgersSelectedField (problem.leftState 0) (problem.rightState 0) x t
  solves := by
    constructor
    · constructor
      · intro x hx
        funext i
        fin_cases i
        change leveque04_burgersSelectedField (problem.leftState 0) (problem.rightState 0) x 0 = problem.leftState 0
        rw [leveque04_burgersSelectedField_initial]
        simp [riemannData, hx]
      · intro x hx
        funext i
        fin_cases i
        change leveque04_burgersSelectedField (problem.leftState 0) (problem.rightState 0) x 0 = problem.rightState 0
        rw [leveque04_burgersSelectedField_initial]
        simp [riemannData, hx, not_lt.mpr hx.le]
    · rw [leveque04_burgersPhysicalFlux_eq law hburgers]
      exact IsRectangleConservationLawSolution.pi _ (fun _ u => u ^ 2 / 2)
        (fun _ => leveque04_burgersSelectedField_isRectangleSolution
          (problem.leftState 0) (problem.rightState 0))

/-- The exact time-averaged interface method now accepts every scalar
Burgers ordered pair. -/
noncomputable def leveque04_burgersSelectedFluxMethod
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ, law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (timeStep : ℝ) (htime : 0 < timeStep) :
    RectangleRiemannInterfaceFluxMethod law (ℝ → ℝ → Fin 1 → ℝ) :=
  rectangleExactTimeAverageRiemannMethod law (fun _ => True)
    (fun problem _ => leveque04_burgersSelectedSolve law hburgers problem)
    (fun _ => trivial) timeStep htime (by
      intro state τ
      funext i
      fin_cases i
      exact leveque04_burgersSelectedField_constant (state 0) 0 τ)

/-- The numerical flux is the physical time average of the actual
constructed shock/rarefaction field. -/
theorem leveque04_burgersSelectedFlux_eq_timeAverage
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ, law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (problem : HyperbolicRiemannProblem law)
    (timeStep : ℝ) (htime : 0 < timeStep) :
    let method := leveque04_burgersSelectedFluxMethod law hburgers timeStep htime
    method.numericalFluxFromInformation (method.extractInformation (method.solve problem trivial)) =
      oneDimensionalCellAverage
        (fun τ => law.physicalFlux
          (fun _ : Fin 1 => leveque04_burgersSelectedField
            (problem.leftState 0) (problem.rightState 0) 0 τ)) 0 timeStep := rfl

end NumStability
