/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionPotentialBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionEnvelopeDerivative
import Mathlib.Analysis.BoundedVariation

/-!
# Spatial regularity and touching-action derivatives of the actual potential

The same selected finite action potential inherits the initial primitive's
global spatial Lipschitz constant. Its spatial derivative almost everywhere is
the same selected variational velocity. The temporal touching-action formula
is proved at positive differentiability points; temporal differentiability
almost everywhere and a PDE weak law remain separate obligations.
-/

noncomputable section
open MeasureTheory

namespace NumStability

/-- Translate the actual minimizing foot to compare two observations at the
same time. The quadratic cost stays unchanged. -/
theorem leveque04_burgersFiniteActionPotential_sub_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time x y : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    leveque04_burgersFiniteActionPotential old origin width x time -
      leveque04_burgersFiniteActionPotential old origin width y time ≤
        leveque04_burgersPrimitiveBound old * |x - y| := by
  let foot := leveque04_burgersFiniteActionFoot old origin width y time
  have hm := leveque04_burgersFiniteActionPotential_le old origin width x time hwidth htime
    (foot + (x - y))
  have hcost : x - (foot + (x - y)) = y - foot := by ring
  rw [hcost] at hm
  have hbound := leveque04_burgersInitialPrimitive_abs_sub_le old origin width
    (foot + (x - y)) foot
  have hshift : foot + (x - y) - foot = x - y := by ring
  rw [hshift] at hbound
  have hdiff := (le_abs_self _).trans hbound
  change leveque04_burgersFiniteActionPotential old origin width x time -
    (leveque04_burgersInitialPrimitive old origin width foot + (y - foot) ^ 2 / (2 * time)) ≤ _
  linarith

theorem leveque04_burgersFiniteActionPotential_abs_sub_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time x y : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    |leveque04_burgersFiniteActionPotential old origin width x time -
      leveque04_burgersFiniteActionPotential old origin width y time| ≤
        leveque04_burgersPrimitiveBound old * |x - y| := by
  apply abs_le.mpr
  have hx := leveque04_burgersFiniteActionPotential_sub_le old origin width time x y hwidth htime
  have hy := leveque04_burgersFiniteActionPotential_sub_le old origin width time y x hwidth htime
  rw [abs_sub_comm y x] at hy
  constructor <;> linarith

theorem leveque04_burgersFiniteActionPotential_spatial_lipschitz {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    LipschitzWith ⟨leveque04_burgersPrimitiveBound old,
      leveque04_burgersPrimitiveBound_nonneg old⟩
      (fun x => leveque04_burgersFiniteActionPotential old origin width x time) := by
  apply LipschitzWith.of_dist_le_mul
  intro x y
  simpa only [Real.dist_eq, NNReal.coe_mk] using
    leveque04_burgersFiniteActionPotential_abs_sub_le old origin width time x y hwidth htime

/-- The actual selected velocity is the derivative at every spatial
differentiability point of the same potential, even at a tied action minimum. -/
theorem leveque04_burgersFiniteActionPotential_spatial_hasDerivAt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hdiff : DifferentiableAt ℝ
      (fun z => leveque04_burgersFiniteActionPotential old origin width z time) x) :
    HasDerivAt (fun z => leveque04_burgersFiniteActionPotential old origin width z time)
      (leveque04_burgersFiniteActionVelocity old origin width x time) x :=
  quadraticActionEnvelope_spatial_hasDerivAt
    (leveque04_burgersInitialPrimitive old origin width)
    (fun z => leveque04_burgersFiniteActionPotential old origin width z time)
    time x (leveque04_burgersFiniteActionFoot old origin width x time) htime
    (fun z => leveque04_burgersFiniteActionPotential_le old origin width z time hwidth htime _)
    rfl hdiff

/-- The spatial derivative identity holds almost everywhere on the whole
physical line, by the genuine Lipschitz bound and real Rademacher theorem. -/
theorem leveque04_burgersFiniteActionPotential_spatial_ae_hasDerivAt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    ∀ᵐ x : ℝ, HasDerivAt
      (fun z => leveque04_burgersFiniteActionPotential old origin width z time)
      (leveque04_burgersFiniteActionVelocity old origin width x time) x := by
  filter_upwards [(leveque04_burgersFiniteActionPotential_spatial_lipschitz
    old origin width time hwidth htime).ae_differentiableAt_real] with x hx
  exact leveque04_burgersFiniteActionPotential_spatial_hasDerivAt old origin width x time
    hwidth htime hx

/-- The temporal derivative is the negative physical Burgers flux at each
positive differentiability point. No temporal a.e. differentiability premise
is hidden in this statement. -/
theorem leveque04_burgersFiniteActionPotential_temporal_hasDerivAt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hdiff : DifferentiableAt ℝ
      (fun s => leveque04_burgersFiniteActionPotential old origin width x s) time) :
    HasDerivAt (fun s => leveque04_burgersFiniteActionPotential old origin width x s)
      (-(leveque04_burgersFiniteActionVelocity old origin width x time) ^ 2 / 2) time :=
  quadraticActionEnvelope_temporal_hasDerivAt
    (leveque04_burgersInitialPrimitive old origin width)
    (fun s => leveque04_burgersFiniteActionPotential old origin width x s)
    x time (leveque04_burgersFiniteActionFoot old origin width x time) htime
    (fun s hs => leveque04_burgersFiniteActionPotential_le old origin width x s hwidth hs _)
    rfl hdiff

end NumStability
