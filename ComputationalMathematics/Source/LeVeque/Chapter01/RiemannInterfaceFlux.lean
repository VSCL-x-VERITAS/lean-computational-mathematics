/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation11

/-!
# LeVeque Chapter 1, Riemann problems at cell interfaces

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 5 (raw PDF page 27), following equation (1.11).

The theorem below formalizes the operational claim rather than an unfolding
of a record predicate.  It constructs the neighboring cell averages from
actual normalized cell integrals, feeds them in the correct order to a
certified solver for a hyperbolic conservation law, extracts numerical-flux
information from the certified solution, and uses those interface fluxes in a
time-step update.  Constant-state consistency qualifies the numerical flux
without identifying it with a universally exact physical-flux formula.
-/

open MeasureTheory

namespace NumStability

/-- For a positive-dimensional hyperbolic conservation law on an actual
one-dimensional finite-volume grid, a certified Riemann-interface method
realizes the Chapter 1 workflow.

The constructed `cellAverages i` are the integrals of `initialState` over the
positive-volume cells divided by those volumes.  At interface `i`, the solver
receives `cellAverages (i - 1)` on the left and `cellAverages i` on the right;
its returned space-time field is certified both to have that Riemann initial
trace and to satisfy the integral conservation law.  The numerical flux is a
function of information extracted from this certified solution, and the same
interface flux enters the cell-average time update. -/
theorem leveque01_riemannInterfaceFlux_sourceContract
    {m : ℕ} (hm : 0 < m)
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (grid : OneDimensionalFiniteVolumeGrid)
    (initialState : ℝ → (Fin m → ℝ))
    (hintegrable : ∀ i, IntervalIntegrable initialState volume
      (grid.cellLeft i) (grid.cellRight i))
    {Information : Type*}
    (method : RiemannInterfaceFluxMethod law Information)
    (timeStep : ℝ) (htimeStep : 0 < timeStep) :
    0 < m ∧ 0 < timeStep ∧
      ∃ cellAverages : ℤ → (Fin m → ℝ),
        (∀ i,
          IsOneDimensionalCellAverage initialState
            (grid.cellLeft i) (grid.cellRight i) (cellAverages i)) ∧
        (∀ i, grid.cellRight (i - 1) = grid.cellLeft i) ∧
        ∃ solved : (i : ℤ) →
            CertifiedHyperbolicRiemannSolution law
              (adjacentCellRiemannProblem law cellAverages i),
          (∀ i,
            leveque01Equation11RiemannData
              (fun x ↦ (solved i).solution x 0)
              (cellAverages (i - 1)) (cellAverages i)) ∧
          (∀ i,
            IsIntegralConservationLawSolution
              (solved i).solution law.physicalFlux) ∧
          ∃ information : ℤ → Information,
            (∀ i,
              information i = method.extractInformation (solved i)) ∧
            ∃ numericalFlux : ℤ → (Fin m → ℝ),
              (∀ i,
                numericalFlux i =
                  method.numericalFluxFromInformation (information i)) ∧
              (∀ state,
                method.numericalFluxFromInformation
                    (method.extractInformation
                      (method.solve
                        ({ leftState := state, rightState := state } :
                          HyperbolicRiemannProblem law))) =
                  law.physicalFlux state) ∧
              ∃ updatedCellAverages : ℤ → (Fin m → ℝ),
                ∀ i,
                  updatedCellAverages i =
                    riemannFiniteVolumeUpdate grid timeStep
                      cellAverages numericalFlux i := by
  refine ⟨hm, htimeStep, ?_⟩
  let cellAverages : ℤ → (Fin m → ℝ) :=
    finiteVolumeCellAverageOn grid initialState
  refine ⟨cellAverages, ?_, grid.adjacent, ?_⟩
  · intro i
    exact finiteVolumeCellAverageOn_spec grid initialState hintegrable i
  · let solved : (i : ℤ) →
        CertifiedHyperbolicRiemannSolution law
          (adjacentCellRiemannProblem law cellAverages i) :=
      fun i ↦ method.solve (adjacentCellRiemannProblem law cellAverages i)
    refine ⟨solved, ?_, ?_, ?_⟩
    · intro i
      exact (solved i).solves.1
    · intro i
      exact (solved i).solves.2
    · let information : ℤ → Information :=
        fun i ↦ method.extractInformation (solved i)
      refine ⟨information, fun _ ↦ rfl, ?_⟩
      let numericalFlux : ℤ → (Fin m → ℝ) :=
        fun i ↦ method.numericalFluxFromInformation (information i)
      refine ⟨numericalFlux, fun _ ↦ rfl,
        method.consistent_on_constant_states, ?_⟩
      exact ⟨riemannFiniteVolumeUpdate grid timeStep
          cellAverages numericalFlux, fun _ ↦ rfl⟩

/-- At a fixed interface, the method result is a certified solution of the
ordered adjacent-cell Riemann problem, and the interface flux is computed from
information extracted from precisely that solution. -/
theorem leveque01_riemannInterfaceFlux
    {m : ℕ}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {Information : Type*}
    (method : RiemannInterfaceFluxMethod law Information)
    (cellAverages : ℤ → (Fin m → ℝ)) (i : ℤ) :
    IsHyperbolicRiemannSolution law
        (adjacentCellRiemannProblem law cellAverages i)
        (method.solve
          (adjacentCellRiemannProblem law cellAverages i)).solution ∧
      riemannInterfaceFlux method cellAverages i =
        method.numericalFluxFromInformation
          (method.extractInformation
            (method.solve
              (adjacentCellRiemannProblem law cellAverages i))) := by
  exact ⟨(method.solve
    (adjacentCellRiemannProblem law cellAverages i)).solves, rfl⟩

end NumStability
