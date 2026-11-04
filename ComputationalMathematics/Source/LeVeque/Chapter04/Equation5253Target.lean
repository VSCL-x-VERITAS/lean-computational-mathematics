/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AffineRiemannFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersPhysicalFluctuationsTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovFlux

/-!
Proof-free preparation only, not a compiled or admitted product module.

The two targets keep the original selected Burgers, scalar-affine and
complete-real-eigenbasis linear applications. The Burgers fan contributions
are actual integrals; the single-jump formula has its strict transonic
exception. Actual physical traces and time averages identify the flux, without
an arbitrary solver, supplied splitting identity or global mesh/CFL claim.
-/

open MeasureTheory
open scoped Topology

namespace NumStability

/-- The negative Burgers fluctuation identity in equation (4.52). -/
def Leveque04Equation52BurgersTarget : Prop :=
  ∀ left right : ℝ,
    leveque04_burgersFanShockMinusContribution left right =
      leveque04_burgersPhysicalMinusFluctuation left right ∧
    leveque04_burgersPhysicalMinusFluctuation left right =
      (if left < 0 ∧ 0 < right then -(left ^ 2) / 2
       else min 0 ((left + right) / 2) * (right - left)) ∧
    (∀ time : ℝ, 0 < time →
      (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2 =
        leveque04_burgersPhysicalInterfaceFlux left right ∧
      leveque04_burgersPhysicalInterfaceFlux left right =
        left ^ 2 / 2 + leveque04_burgersFanShockMinusContribution left right) ∧
    (∀ duration : ℝ, 0 < duration →
      IntervalIntegrable (fun time =>
        (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2) volume 0 duration ∧
      (∫ time in (0 : ℝ)..duration,
        (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2) / duration =
          leveque04_burgersPhysicalInterfaceFlux left right) ∧
    (right < left → left + right = 0 → ∀ representative : ℝ,
      representative = left ∨ representative = right →
      representative ^ 2 / 2 = leveque04_burgersPhysicalInterfaceFlux left right ∧
      leveque04_burgersFanShockMinusContribution left right = 0)

/-- The positive Burgers fluctuation identity in equation (4.53). -/
def Leveque04Equation53BurgersTarget : Prop :=
  ∀ left right : ℝ,
    leveque04_burgersFanShockPlusContribution left right =
      leveque04_burgersPhysicalPlusFluctuation left right ∧
    leveque04_burgersPhysicalPlusFluctuation left right =
      (if left < 0 ∧ 0 < right then right ^ 2 / 2
       else max 0 ((left + right) / 2) * (right - left)) ∧
    (∀ time : ℝ, 0 < time →
      (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2 =
        leveque04_burgersPhysicalInterfaceFlux left right ∧
      leveque04_burgersPhysicalInterfaceFlux left right =
        right ^ 2 / 2 - leveque04_burgersFanShockPlusContribution left right) ∧
    (∀ duration : ℝ, 0 < duration →
      IntervalIntegrable (fun time =>
        (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2) volume 0 duration ∧
      (∫ time in (0 : ℝ)..duration,
        (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2) / duration =
          leveque04_burgersPhysicalInterfaceFlux left right) ∧
    (right < left → left + right = 0 → ∀ representative : ℝ,
      representative = left ∨ representative = right →
      representative ^ 2 / 2 = leveque04_burgersPhysicalInterfaceFlux left right ∧
      leveque04_burgersFanShockPlusContribution left right = 0)

/-- The negative fluctuation identity (4.52) for a scalar affine flux. -/
def Leveque04Equation52ScalarAffineTarget : Prop :=
  ∀ a b left right representative : ℝ,
    representative = left ∨ representative = right →
    let q := travelingWave (riemannData left representative right) a
    let f := fun state : ℝ => a * state + b
    let numericalFlux := if a < 0 then f right else f left
    (∀ time : ℝ, 0 < time → f (q 0 time) = numericalFlux) ∧
    numericalFlux = f left + min a 0 * (right - left) ∧
    numericalFlux - f left = min a 0 * (right - left) ∧
    (∀ duration : ℝ, 0 < duration →
      IntervalIntegrable (fun time => f (q 0 time)) volume 0 duration ∧
      (∫ time in (0 : ℝ)..duration, f (q 0 time)) / duration = numericalFlux)

/-- The positive fluctuation identity (4.53) for a scalar affine flux. -/
def Leveque04Equation53ScalarAffineTarget : Prop :=
  ∀ a b left right representative : ℝ,
    representative = left ∨ representative = right →
    let q := travelingWave (riemannData left representative right) a
    let f := fun state : ℝ => a * state + b
    let numericalFlux := if a < 0 then f right else f left
    (∀ time : ℝ, 0 < time → f (q 0 time) = numericalFlux) ∧
    numericalFlux = f right - max a 0 * (right - left) ∧
    f right - numericalFlux = max a 0 * (right - left) ∧
    (∀ duration : ℝ, 0 < duration →
      IntervalIntegrable (fun time => f (q 0 time)) volume 0 duration ∧
      (∫ time in (0 : ℝ)..duration, f (q 0 time)) / duration = numericalFlux)

/-- The negative fluctuation identity (4.52) for a linear system. -/
def Leveque04Equation52LinearTarget : Prop :=
  ∀ m : ℕ, 0 < m →
    ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ),
    (∀ p, coefficient.mulVec (basis p) = speeds p • basis p) →
    ∀ left right representative : Fin m → ℝ,
    representative = left ∨ representative = right →
    let q := linearRiemannSolution basis speeds left representative right
    let numericalFlux := leveque04_linearGodunovFlux coefficient basis speeds left right
    let fluctuation := leveque04_negativeFluctuation speeds
      (leveque03_riemannWave basis left right)
    (∀ time : ℝ, 0 < time → coefficient.mulVec (q 0 time) = numericalFlux) ∧
    numericalFlux = coefficient.mulVec left + fluctuation ∧
    numericalFlux - coefficient.mulVec left = fluctuation ∧
    (leveque04_negativeCoefficientPart basis speeds).mulVec (right - left) = fluctuation ∧
    (∀ duration : ℝ, 0 < duration →
      IntervalIntegrable (fun time => coefficient.mulVec (q 0 time)) volume 0 duration ∧
      oneDimensionalCellAverage (fun time => coefficient.mulVec (q 0 time)) 0 duration =
        numericalFlux)

/-- The positive fluctuation identity (4.53) for a linear system. -/
def Leveque04Equation53LinearTarget : Prop :=
  ∀ m : ℕ, 0 < m →
    ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ),
    (∀ p, coefficient.mulVec (basis p) = speeds p • basis p) →
    ∀ left right representative : Fin m → ℝ,
    representative = left ∨ representative = right →
    let q := linearRiemannSolution basis speeds left representative right
    let numericalFlux := leveque04_linearGodunovFlux coefficient basis speeds left right
    let fluctuation := leveque04_positiveFluctuation speeds
      (leveque03_riemannWave basis left right)
    (∀ time : ℝ, 0 < time → coefficient.mulVec (q 0 time) = numericalFlux) ∧
    numericalFlux = coefficient.mulVec right - fluctuation ∧
    coefficient.mulVec right - numericalFlux = fluctuation ∧
    (leveque04_positiveCoefficientPart basis speeds).mulVec (right - left) = fluctuation ∧
    (∀ duration : ℝ, 0 < duration →
      IntervalIntegrable (fun time => coefficient.mulVec (q 0 time)) volume 0 duration ∧
      oneDimensionalCellAverage (fun time => coefficient.mulVec (q 0 time)) 0 duration =
        numericalFlux)

/-- Equation (4.52) for Burgers, scalar affine fluxes and linear systems. -/
def Leveque04Equation52Target : Prop :=
  Leveque04Equation52BurgersTarget ∧
    Leveque04Equation52ScalarAffineTarget ∧ Leveque04Equation52LinearTarget

/-- Equation (4.53) for Burgers, scalar affine fluxes and linear systems. -/
def Leveque04Equation53Target : Prop :=
  Leveque04Equation53BurgersTarget ∧
    Leveque04Equation53ScalarAffineTarget ∧ Leveque04Equation53LinearTarget

end NumStability
