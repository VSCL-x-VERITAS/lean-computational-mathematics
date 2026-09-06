/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02
import ComputationalMathematics.Source.LeVeque.Chapter01.LinearFluxSpecialization
import ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw

/-!
# LeVeque Chapter 1, advection as contaminant conservation

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 4 (raw PDF page 26).
-/

namespace NumStability

open MeasureTheory
open scoped Interval

/-- The one-component linear flux induced by `[ū]` is scalar multiplication
by the advection speed. -/
theorem leveque01_advectionFlux_isSpeedTimesState
    (speed : ℝ) (state : Fin 1 → ℝ) :
    constantLinearFlux (constantCoefficientScalarMatrix speed) state =
      fun _ => speed * state 0 := by
  funext i
  fin_cases i
  simp [constantLinearFlux, constantCoefficientScalarMatrix,
    Matrix.mulVec, dotProduct]

/-- A solution of the scalar advection equation is the one-component
conservation law with contaminant flux `f(q) = ū q`. -/
theorem leveque01_advectionLinearFlux
    (q : ℝ → ℝ → ℝ) (speed x t : ℝ)
    (hadvection : leveque01_equation02_scalarAdvectionAt q speed x t) :
    leveque01_equation08_conservationLawAt
      (scalarAsOneComponentSystem q)
      (constantLinearFlux (constantCoefficientScalarMatrix speed)) x t ∧
      ∀ state : Fin 1 → ℝ,
        constantLinearFlux (constantCoefficientScalarMatrix speed) state =
          fun _ => speed * state 0 := by
  constructor
  · apply leveque01_equation01_isLinearFluxConservationLaw
    exact (leveque01_equation02_isOneDimensionalSpecialization
      q speed x t).2 hadvection
  · exact leveque01_advectionFlux_isSpeedTimesState speed

/-- Conservation of contaminant mass with the constant physical flux
`f(q) = ū q` implies the scalar advection equation under explicit classical
smoothness and differentiation-under-the-integral hypotheses.  This records
the source's conservation-to-advection direction rather than assuming the PDE
as the theorem above does. -/
theorem leveque01_advectionLinearFlux_fromMassConservation
    (q : ℝ → ℝ → ℝ) (speed t : ℝ)
    (qt qx fluxx : ℝ → (Fin 1 → ℝ))
    (hintegralMass : IsIntegralConservationLawSolution
      (scalarAsOneComponentSystem q)
      (constantLinearFlux (constantCoefficientScalarMatrix speed)))
    (hqt : ∀ x,
      HasDerivAt (fun τ => scalarAsOneComponentSystem q x τ) (qt x) t)
    (hqx : ∀ x,
      HasDerivAt (fun ξ => scalarAsOneComponentSystem q ξ t) (qx x) x)
    (hfluxx : ∀ x,
      HasDerivAt
        (fun ξ => constantLinearFlux
          (constantCoefficientScalarMatrix speed)
          (scalarAsOneComponentSystem q ξ t))
        (fluxx x) x)
    (hqtIntegrable : ∀ a b, IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : ∀ a b, IntervalIntegrable fluxx volume a b)
    (hinterchange : ∀ a b,
      HasDerivAt
        (fun τ => ∫ x in a..b, scalarAsOneComponentSystem q x τ)
        (∫ x in a..b, qt x) t)
    (hresidualContinuous : Continuous fun x => qt x + fluxx x) :
    (∀ state : Fin 1 → ℝ,
      constantLinearFlux (constantCoefficientScalarMatrix speed) state =
        fun _ => speed * state 0) ∧
      ∀ x, leveque01_equation02_scalarAdvectionAt q speed x t := by
  constructor
  · exact leveque01_advectionFlux_isSpeedTimesState speed
  · have hconservation := integralConservationLaw_implies_pointwise
      (scalarAsOneComponentSystem q)
      (constantLinearFlux (constantCoefficientScalarMatrix speed))
      qt fluxx t hintegralMass hqt hfluxx hqtIntegrable
      hfluxxIntegrable hinterchange hresidualContinuous
    intro x
    have hsystem :=
      (leveque01_linearFlux_specializesEquation01
        (scalarAsOneComponentSystem q)
        (constantCoefficientScalarMatrix speed) x t (qx x) (hqx x)).1
        (hconservation x)
    exact (leveque01_equation02_isOneDimensionalSpecialization
      q speed x t).1 hsystem

end NumStability
