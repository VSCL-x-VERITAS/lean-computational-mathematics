/- SPDX-License-Identifier: MIT -/
import Mathlib.Analysis.Distribution.TestFunction
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.MeasureTheory.Function.LpSpace.Indicator
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# Indicator Sobolev Obstruction Target

The owner-selected one-dimensional domain; its endpoints are excluded.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.Eymard.Chapter01

open MeasureTheory Set TopologicalSpace
open scoped ENNReal Topology

/-- The owner-selected one-dimensional domain; its endpoints are excluded. -/
def indicatorObstructionDomain : Opens ℝ :=
  ⟨Ioo (-1 : ℝ) 1, isOpen_Ioo⟩

/-- Ordinary Lebesgue measure restricted to the selected interval. -/
def indicatorObstructionMeasure : Measure ℝ :=
  volume.restrict (indicatorObstructionDomain : Set ℝ)

/-- Actual characteristic function, with value zero at the jump and outside the cell. -/
def positiveCellIndicator : ℝ → ℝ :=
  (Ioo (0 : ℝ) 1).indicator (fun _ => 1)

/-- The weak-derivative relation on the same interval, using actual smooth,
compactly supported tests and their ordinary derivative. Integrability is explicit.
The relation is on representatives; all its integrals use the restricted measure. -/
def IsL2WeakDerivativeOnObstructionInterval (u g : ℝ → ℝ) : Prop :=
  MemLp u 2 indicatorObstructionMeasure ∧
  MemLp g 2 indicatorObstructionMeasure ∧
  ∀ φ : TestFunction indicatorObstructionDomain ℝ ⊤,
    Integrable (fun x => u x * deriv (φ : ℝ → ℝ) x)
      indicatorObstructionMeasure ∧
    Integrable (fun x => g x * φ x) indicatorObstructionMeasure ∧
    -(∫ x, u x * deriv (φ : ℝ → ℝ) x ∂indicatorObstructionMeasure) =
      ∫ x, g x * φ x ∂indicatorObstructionMeasure

/-- The representative-level preimage of H¹((-1,1)) = W¹,²((-1,1)).
This uses existence of an actual L² weak derivative, with no chosen derivative
operator, continuity surrogate, boundary trace or zero-boundary requirement. -/
def InH1OnObstructionInterval (u : ℝ → ℝ) : Prop :=
  ∃ g : ℝ → ℝ, IsL2WeakDerivativeOnObstructionInterval u g

/-- Full owner-selected obstruction. The first two analytic clauses say the
distributional derivative is evaluation at zero and that this functional has no
L² density on the interval. The last clause states precisely the failed H¹
inclusion for any family containing this indicator; it makes no claim about
nonconforming methods, convergence failure, or higher-dimensional jumps. -/
def indicatorSobolevObstructionTarget : Prop :=
  MemLp positiveCellIndicator 2 indicatorObstructionMeasure ∧
  (∀ φ : TestFunction indicatorObstructionDomain ℝ ⊤,
    Integrable (fun x => positiveCellIndicator x * deriv (φ : ℝ → ℝ) x)
      indicatorObstructionMeasure ∧
    -(∫ x, positiveCellIndicator x * deriv (φ : ℝ → ℝ) x
      ∂indicatorObstructionMeasure) = φ 0) ∧
  (∀ g : ℝ → ℝ, MemLp g 2 indicatorObstructionMeasure →
    (∀ φ : TestFunction indicatorObstructionDomain ℝ ⊤,
      Integrable (fun x => g x * φ x) indicatorObstructionMeasure) ∧
    ∃ φ : TestFunction indicatorObstructionDomain ℝ ⊤,
      (∫ x, g x * φ x ∂indicatorObstructionMeasure) ≠ φ 0) ∧
  ¬ InH1OnObstructionInterval positiveCellIndicator ∧
  (∀ V : Set (ℝ → ℝ), positiveCellIndicator ∈ V →
    ¬ V ⊆ {u | InH1OnObstructionInterval u})

end NumStability.Eymard.Chapter01
