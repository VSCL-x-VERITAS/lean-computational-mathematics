/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AffineRiemannFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicEvolution
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersPhysicalFluctuationsTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovFlux

/-!
PROOF-FREE DRAFT OUTSIDE THE PRODUCT TREE. Not extracted, compiled, admitted,
frozen or accepted. The original Eq.4.37 scope is all-real Burgers plus retained
scalar-affine and matrix-linear applications. Full matrix-affine offsets remain
explicit derived generic support, not a required literal book scope here.

Actual construction and forward integral PDE/initial data are conclusions, not
an assumed solver/correctness premise. The elementary forward-balance predicate
below states its entire integrability and physical rectangle law explicitly;
it does not assert equivalence to Definition11.1 or entropy uniqueness.
-/

open MeasureTheory Filter
open scoped Topology

namespace NumStability

/-- Forward physical conservation on all real spatial intervals. In the
target below this is asserted only of the explicit selected model fields. -/
def Leveque04Equation37ForwardBalance
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (physicalFlux : E → E) : Prop :=
  (∀ time : ℝ, 0 ≤ time → ∀ a b : ℝ,
    IntervalIntegrable (fun x => q x time) volume a b) ∧
  (∀ x s t : ℝ, 0 ≤ s → s ≤ t →
    IntervalIntegrable (fun time => physicalFlux (q x time)) volume s t) ∧
  (∀ a b s t : ℝ, 0 ≤ s → s ≤ t →
    (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      ∫ time in s..t, physicalFlux (q a time) - physicalFlux (q b time))

/-- The all-real-state Burgers local physical-flux application. The field is
the actual selected entropy shock/fan constructor, with its fixed front value. -/
def Leveque04Equation37BurgersTarget : Prop :=
  ∀ left right : ℝ,
    (∀ x : ℝ, leveque04_burgersSelectedField left right x 0 =
      riemannData left right right x) ∧
    Leveque04Equation37ForwardBalance
      (leveque04_burgersSelectedField left right) (fun q : ℝ => q ^ 2 / 2) ∧
    (∀ time : ℝ, 0 < time →
      leveque04_burgersSelectedField left right 0 time =
        leveque04_burgersSelectedInterfaceState left right ∧
      (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2 =
        leveque04_burgersPhysicalInterfaceFlux left right) ∧
    (∀ duration : ℝ, 0 < duration →
      IntervalIntegrable (fun time =>
        (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2) volume 0 duration ∧
      (∫ time in (0 : ℝ)..duration,
        (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2) / duration =
          leveque04_burgersPhysicalInterfaceFlux left right) ∧
    (right < left → left + right = 0 → ∀ representative : ℝ,
      representative = left ∨ representative = right →
        representative ^ 2 / 2 = leveque04_burgersPhysicalInterfaceFlux left right)

/-- Scalar affine physical flux `a*q+b`, with both natural origin
representatives. The physical offset remains visible, including when a=0. -/
def Leveque04Equation37ScalarAffineTarget : Prop :=
  ∀ a b left right representative : ℝ,
    representative = left ∨ representative = right →
    let q := travelingWave (riemannData left representative right) a
    let f := fun state : ℝ => a * state + b
    let numericalFlux := if a < 0 then f right else f left
    (∀ x : ℝ, q x 0 = riemannData left representative right x) ∧
    Leveque04Equation37ForwardBalance q f ∧
    (∀ time : ℝ, 0 < time →
      f (q 0 time) = numericalFlux ∧
      ContinuousAt (fun x => f (q x time)) 0 ∧
      Tendsto (fun x => f (q x time)) (𝓝[<] 0) (𝓝 numericalFlux) ∧
      Tendsto (fun x => f (q x time)) (𝓝[>] 0) (𝓝 numericalFlux)) ∧
    (∀ duration : ℝ, 0 < duration →
      IntervalIntegrable (fun time => f (q 0 time)) volume 0 duration ∧
      (∫ time in (0 : ℝ)..duration, f (q 0 time)) / duration = numericalFlux)

/-- Every positive finite-dimensional real diagonalizable linear system.
Zero and repeated speeds are allowed; no CFL or strict ordering is imposed. -/
def Leveque04Equation37LinearTarget : Prop :=
  ∀ m : ℕ, 0 < m →
    ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ),
    (∀ p, coefficient.mulVec (basis p) = speeds p • basis p) →
    ∀ left right representative : Fin m → ℝ,
    representative = left ∨ representative = right →
    let q := linearRiemannSolution basis speeds left representative right
    let numericalFlux := leveque04_linearGodunovFlux coefficient basis speeds left right
    (∀ x : ℝ, q x 0 = riemannData left representative right x) ∧
    (∀ x time : ℝ, q x time = linearCharacteristicEvolution basis speeds
      (riemannData left representative right) x time) ∧
    Leveque04Equation37ForwardBalance q coefficient.mulVec ∧
    (∀ time : ℝ, 0 < time →
      q 0 time = selectedLinearRiemannRayZeroValue basis speeds left representative right ∧
      coefficient.mulVec (q 0 time) = numericalFlux ∧
      ContinuousAt (fun x => coefficient.mulVec (q x time)) 0 ∧
      Tendsto (fun x => coefficient.mulVec (q x time)) (𝓝[<] 0) (𝓝 numericalFlux) ∧
      Tendsto (fun x => coefficient.mulVec (q x time)) (𝓝[>] 0) (𝓝 numericalFlux)) ∧
    (∀ duration : ℝ, 0 < duration →
      IntervalIntegrable (fun time => coefficient.mulVec (q 0 time)) volume 0 duration ∧
      oneDimensionalCellAverage (fun time => coefficient.mulVec (q 0 time)) 0 duration =
        numericalFlux)

/-- Complete original model-bound Eq.4.37 candidate. Generic matrix-affine
strengthening is reusable support and is deliberately not a required branch. -/
def Leveque04Equation37Target : Prop :=
  Leveque04Equation37BurgersTarget ∧
    Leveque04Equation37ScalarAffineTarget ∧ Leveque04Equation37LinearTarget

end NumStability
