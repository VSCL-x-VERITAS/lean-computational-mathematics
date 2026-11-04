/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonDiffusion
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import Mathlib.MeasureTheory.Integral.IntervalIntegral.TrapezoidalRule

/-!
# Proof-free Crank–Nicolson face-flux accuracy

The primary scalar statement compares the actual centered numerical flux on
exact cell averages with the physical time-average reference. Local smoothness
and coefficient errors remain explicit. The finite-component statement is a
separate derived extension. Neither statement asserts stability or convergence
of the numerical evolution.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The normalized physical cell means of the reference field at a fixed time. -/
noncomputable def leveque04_cnAccuracyReferenceAverages
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (origin width time : ℝ) (j : ℤ) : E :=
  oneDimensionalCellAverage (fun x => q x time)
    (origin + (j : ℝ) * width - width / 2)
    (origin + (j : ℝ) * width + width / 2)

/-- Regularity and coefficient bounds used in the Crank–Nicolson flux estimates. -/
def Leveque04CNFluxAccuracyRegularity
    (q qX qXX : ℝ → ℝ → ℝ)
    (physicalCoefficient K B curvatureBound face width oldTime timeStep : ℝ) : Prop :=
  (∀ time ∈ Set.Icc oldTime (oldTime + timeStep),
    HasDerivAt (fun x => q x time) (qX face time) face) ∧
  (∀ time : ℝ, time = oldTime ∨ time = oldTime + timeStep →
    ∀ x ∈ Set.Icc (face - width) (face + width),
      HasDerivAt (fun y => q y time) (qX x time) x) ∧
  (∀ time : ℝ, time = oldTime ∨ time = oldTime + timeStep →
    ∀ x ∈ Set.Icc (face - width) (face + width),
      HasDerivAt (fun y => qX y time) (qXX x time) x) ∧
  (∀ time : ℝ, time = oldTime ∨ time = oldTime + timeStep →
    ∀ x ∈ Set.Icc (face - width) (face + width),
      |qXX x time - qXX face time| ≤ K * |x - face|) ∧
  (∀ time : ℝ, time = oldTime ∨ time = oldTime + timeStep → |qX face time| ≤ B) ∧
  ContDiffOn ℝ 2 (fun time => -(physicalCoefficient * qX face time))
    [[oldTime, oldTime + timeStep]] ∧
  (∀ time ∈ Set.Icc oldTime (oldTime + timeStep),
    |iteratedDerivWithin 2 (fun t => -(physicalCoefficient * qX face t))
      [[oldTime, oldTime + timeStep]] time| ≤ curvatureBound)

/-- The scalar Crank–Nicolson physical flux accuracy specification. -/
def Leveque04CNFluxAccuracyScalarTarget : Prop :=
  ∀ (q qX qXX : ℝ → ℝ → ℝ) (diffusivity : ℝ → ℝ)
    (coefficient : ℤ → ℝ) (K B curvatureBound origin width oldTime timeStep : ℝ) (i : ℤ),
  0 ≤ K → 0 ≤ B → 0 ≤ curvatureBound → 0 < width → 0 < timeStep →
  let face := origin + (i : ℝ) * width - width / 2
  Leveque04CNFluxAccuracyRegularity q qX qXX (diffusivity face)
    K B curvatureBound face width oldTime timeStep →
  let before := leveque04_cnAccuracyReferenceAverages q origin width oldTime
  let after := leveque04_cnAccuracyReferenceAverages q origin width (oldTime + timeStep)
  let numericalFlux := leveque04_crankNicolsonInterfaceFlux coefficient width before after i
  let physicalFlux := fun time => -(diffusivity face * qX face time)
  let referenceFlux := oneDimensionalCellAverage physicalFlux oldTime (oldTime + timeStep)
  (∀ time : ℝ, time = oldTime ∨ time = oldTime + timeStep →
    IntervalIntegrable (fun x => q x time) volume (face - width) face ∧
    IntervalIntegrable (fun x => q x time) volume face (face + width)) ∧
  IntervalIntegrable physicalFlux volume oldTime (oldTime + timeStep) ∧
  |numericalFlux - referenceFlux| ≤
    2 * |coefficient i| * K * width ^ 2 +
      |coefficient i - diffusivity face| * B + curvatureBound * timeStep ^ 2 / 12 ∧
  (∀ D E : ℝ, 0 ≤ D → 0 ≤ E → |coefficient i| ≤ D →
    |coefficient i - diffusivity face| ≤ E * width ^ 2 →
    |numericalFlux - referenceFlux| ≤
      (2 * D * K + E * B) * width ^ 2 + curvatureBound * timeStep ^ 2 / 12)

/-- The Crank–Nicolson interface flux applied componentwise to vector grid data. -/
noncomputable def leveque04_cnAccuracyComponentFlux
    {m : ℕ} (coefficient : ℤ → ℝ) (width : ℝ)
    (before after : ℤ → Fin m → ℝ) (i : ℤ) : Fin m → ℝ :=
  fun p => leveque04_crankNicolsonInterfaceFlux coefficient width
    (fun j => before j p) (fun j => after j p) i

/-- The finite-vector Crank–Nicolson physical flux accuracy specification. -/
def Leveque04CNFluxAccuracyVectorTarget : Prop :=
  ∀ m : ℕ, 0 < m →
  ∀ (q qX qXX : ℝ → ℝ → Fin m → ℝ) (diffusivity : ℝ → ℝ)
    (coefficient : ℤ → ℝ) (K B curvatureBound origin width oldTime timeStep : ℝ) (i : ℤ),
  0 ≤ K → 0 ≤ B → 0 ≤ curvatureBound → 0 < width → 0 < timeStep →
  let face := origin + (i : ℝ) * width - width / 2
  (∀ p : Fin m, Leveque04CNFluxAccuracyRegularity
    (fun x time => q x time p) (fun x time => qX x time p)
    (fun x time => qXX x time p) (diffusivity face)
    K B curvatureBound face width oldTime timeStep) →
  let before := leveque04_cnAccuracyReferenceAverages q origin width oldTime
  let after := leveque04_cnAccuracyReferenceAverages q origin width (oldTime + timeStep)
  let numericalFlux := leveque04_cnAccuracyComponentFlux coefficient width before after i
  let physicalFlux := fun time => (-diffusivity face) • qX face time
  let referenceFlux := oneDimensionalCellAverage physicalFlux oldTime (oldTime + timeStep)
  (∀ time : ℝ, time = oldTime ∨ time = oldTime + timeStep →
    IntervalIntegrable (fun x => q x time) volume (face - width) face ∧
    IntervalIntegrable (fun x => q x time) volume face (face + width)) ∧
  IntervalIntegrable physicalFlux volume oldTime (oldTime + timeStep) ∧
  (∀ time : ℝ, time = oldTime ∨ time = oldTime + timeStep →
    ∀ j : ℤ, j = i ∨ j = i - 1 → ∀ p : Fin m,
      leveque04_cnAccuracyReferenceAverages q origin width time j p =
        leveque04_cnAccuracyReferenceAverages (fun x t => q x t p) origin width time j) ∧
  (∀ p : Fin m, referenceFlux p =
    oneDimensionalCellAverage (fun time => -(diffusivity face * qX face time p))
      oldTime (oldTime + timeStep)) ∧
  ‖numericalFlux - referenceFlux‖ ≤
    2 * |coefficient i| * K * width ^ 2 +
      |coefficient i - diffusivity face| * B + curvatureBound * timeStep ^ 2 / 12 ∧
  (∀ D E : ℝ, 0 ≤ D → 0 ≤ E → |coefficient i| ≤ D →
    |coefficient i - diffusivity face| ≤ E * width ^ 2 →
    ‖numericalFlux - referenceFlux‖ ≤
      (2 * D * K + E * B) * width ^ 2 + curvatureBound * timeStep ^ 2 / 12)

/-- The scalar and finite-vector Crank–Nicolson flux accuracy specifications together. -/
def Leveque04CNFluxAccuracyTarget : Prop :=
  Leveque04CNFluxAccuracyScalarTarget ∧ Leveque04CNFluxAccuracyVectorTarget

end NumStability
