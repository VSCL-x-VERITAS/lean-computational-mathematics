/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteGridWeakTest
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFullCFLEntropy
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersOleinikBoundTarget

/-!
# The admitted original all-state Burgers Godunov definition

This proof-free target uses the actual selected shock/fan field, physical
zero-ray flux/fluctuations and supplied-ghost finite conservative recipe.
Pair solves and the algebraic recipe have no CFL or state-bound premise.
Only the derived actual finite-field branch assumes the full characteristic
bound `M * duration ≤ width`, including zero bound and terminal contact.

The corrected weak identity integrates the initial term over the whole real
line. Global compact C1 tests may be nonzero at time zero. The literal printed
half-line defect remains in the source record. No uniqueness, viscosity
equivalence, smaller active-front-speed CFL or post-horizon PDE is asserted.
The reused physical-fluctuation and Oleinik predicates are transparent fixed
mathematical statements about this same actual field, not solver callbacks.
-/

open Set MeasureTheory Filter
open scoped Topology BigOperators

namespace NumStability

/-- The full admitted original definition and its explicitly derived support:
actual all-real Riemann fields, corrected weak admissibility criterion,
physical flux, unconditional finite recipe, and full-CFL physical slab. -/
def Leveque04BurgersGodunovAlgorithmTarget : Prop :=
  -- The fixed Burgers flux and its actual characteristic/convexity derivatives.
  (∀ state : ℝ,
    HasDerivAt (fun q : ℝ => q ^ 2 / 2) state state ∧
    HasDerivAt (deriv (fun q : ℝ => q ^ 2 / 2)) 1 state) ∧
  -- Actual pair IVP, chosen representatives, local analytic class and weak law.
  (∀ left right : ℝ,
    (∀ x : ℝ,
      leveque04_burgersSelectedField left right x 0 =
        riemannData left right right x) ∧
    (∀ x time : ℝ, 0 < time →
      leveque04_burgersSelectedField left right x time =
        if left ≤ right then max left (min (x / time) right)
        else if x < ((left + right) / 2) * time then left else right) ∧
    (left = right → ∀ x time : ℝ, 0 ≤ time →
      leveque04_burgersSelectedField left right x time = left) ∧
    (right < left →
      right < (left + right) / 2 ∧ (left + right) / 2 < left ∧
      (right ^ 2 / 2 - left ^ 2 / 2) = ((left + right) / 2) * (right - left)) ∧
    Measurable (fun z : ℝ × ℝ => leveque04_burgersSelectedField left right z.1 z.2) ∧
    (∀ x time : ℝ, 0 ≤ time →
      |leveque04_burgersSelectedField left right x time| ≤ max |left| |right|) ∧
    (∀ time a b : ℝ, 0 ≤ time →
      IntervalIntegrable (fun x => leveque04_burgersSelectedField left right x time) volume a b ∧
      IntegrableOn (fun x => leveque04_burgersSelectedField left right x time) (Icc a b) ∧
      IntegrableOn (fun x => |leveque04_burgersSelectedField left right x time -
        riemannData left right right x|) (Icc a b)) ∧
    (∀ x : ℝ, x ≠ 0 →
      Tendsto (fun time => leveque04_burgersSelectedField left right x time)
        (𝓝[>] (0 : ℝ)) (𝓝 (riemannData left right right x))) ∧
    (∀ a b : ℝ,
      Tendsto (fun time => ∫ x in Icc a b,
        |leveque04_burgersSelectedField left right x time - riemannData left right right x|)
        (𝓝[>] (0 : ℝ)) (𝓝 (0 : ℝ))) ∧
    (∀ test : ℝ × ℝ → ℝ, ContDiff ℝ 1 test → HasCompactSupport test →
      Integrable (fun z : ℝ × ℝ =>
        leveque04_burgersSelectedField left right z.1 z.2 * forwardTestDerivative test (0, 1) z +
          (leveque04_burgersSelectedField left right z.1 z.2 ^ 2 / 2) *
            forwardTestDerivative test (1, 0) z) ∧
      Integrable (fun x => riemannData left right right x * test (x, 0)) ∧
      (∫ time in Ici (0 : ℝ), ∫ x,
        leveque04_burgersSelectedField left right x time * fderiv ℝ test (x, time) (0, 1) +
          (leveque04_burgersSelectedField left right x time ^ 2 / 2) *
            fderiv ℝ test (x, time) (1, 0)) +
        (∫ x, riemannData left right right x * test (x, 0)) = 0) ∧
    leveque04_burgersSelectedInterfaceState left right =
      (if left ≤ right then max left (min 0 right)
       else if 0 < left + right then left else right)) ∧
  -- Fixed actual-field statements, including sharp1/t, strict uniform E2,
  -- source-order existential E, true G/time average and transonic fluctuations.
  Leveque04BurgersOleinikBoundTarget ∧
  Leveque04BurgersPhysicalFluctuationsTarget ∧
  -- The arbitrary supplied finite recipe is unconditional on M or CFL.
  (∀ (N : ℕ), 1 ≤ N → ∀ (old : Fin (N + 2) → ℝ) (origin width duration : ℝ),
    0 < width → 0 < duration →
      (∀ face : Fin (N + 1),
        (∀ x time : ℝ,
          leveque04_burgersFiniteGridField old origin width face x time =
            leveque04_burgersSelectedField (old face.castSucc) (old face.succ)
              (x - leveque04_uniformInterface origin width (face.val : ℤ)) time) ∧
        (∀ x : ℝ,
          leveque04_burgersFiniteGridField old origin width face x 0 =
            riemannData (old face.castSucc) (old face.succ) (old face.succ)
              (x - leveque04_uniformInterface origin width (face.val : ℤ))) ∧
        (∀ time : ℝ, 0 < time →
          leveque04_burgersFiniteGridField old origin width face
              (leveque04_uniformInterface origin width (face.val : ℤ)) time =
            leveque04_burgersSelectedInterfaceState (old face.castSucc) (old face.succ)) ∧
        leveque04_burgersFiniteGridFlux old face =
          leveque04_burgersPhysicalInterfaceFlux (old face.castSucc) (old face.succ) ∧
        (∫ time in (0 : ℝ)..duration,
          (leveque04_burgersFiniteGridField old origin width face
            (leveque04_uniformInterface origin width (face.val : ℤ)) time) ^ 2 / 2) / duration =
          leveque04_burgersFiniteGridFlux old face) ∧
      (∀ cell : Fin N,
        leveque04_uniformInterface origin width (cell.succ.val : ℤ) -
            leveque04_uniformInterface origin width (cell.castSucc.val : ℤ) = width ∧
        leveque04_burgersFiniteGridStep duration width old cell =
          old cell.castSucc.succ - (duration / width) *
            (leveque04_burgersFiniteGridFlux old cell.succ -
              leveque04_burgersFiniteGridFlux old cell.castSucc) ∧
        leveque04_burgersFiniteGridStep duration width old cell =
          leveque04_burgersPhysicalFluctuationUpdate duration width
            (old cell.castSucc.castSucc) (old cell.castSucc.succ) (old cell.succ.succ)) ∧
      (∑ cell : Fin N, width * leveque04_burgersFiniteGridStep duration width old cell) =
        (∑ cell : Fin N, width * old cell.castSucc.succ) - duration *
          (leveque04_burgersFiniteGridFlux old (Fin.last N) -
            leveque04_burgersFiniteGridFlux old 0) ∧
      (leveque04_burgersFiniteGridFlux old (Fin.last N) = leveque04_burgersFiniteGridFlux old 0 →
        (∑ cell : Fin N, width * leveque04_burgersFiniteGridStep duration width old cell) =
          ∑ cell : Fin N, width * old cell.castSucc.succ)) ∧
  -- Derived physical field support uses full characteristic M*duration<=width.
  (∀ (N : ℕ), 1 ≤ N → ∀ (old : Fin (N + 2) → ℝ) (origin width bound duration : ℝ),
    0 < width → 0 ≤ bound → 0 < duration →
    (∀ j, |old j| ≤ bound) → bound * duration ≤ width →
      (∀ cell : Fin N,
        oneDimensionalCellAverage (fun x => leveque04_burgersFiniteGridREA old origin width x 0)
          (leveque04_uniformInterface origin width (cell.castSucc.val : ℤ))
          (leveque04_uniformInterface origin width (cell.succ.val : ℤ)) =
            (fun _ : Fin 1 => old cell.castSucc.succ)) ∧
      (∀ face : Fin (N + 1), ∀ time ∈ Icc 0 duration,
        leveque04_burgersFiniteGridREA old origin width
            (leveque04_uniformInterface origin width (face.val : ℤ)) time =
          (fun _ : Fin 1 => leveque04_burgersSelectedField
            (old face.castSucc) (old face.succ) 0 time)) ∧
      (∀ face : Fin (N + 1),
        oneDimensionalCellAverage
          (fun time (_ : Fin 1) =>
            (leveque04_burgersFiniteGridREA old origin width
              (leveque04_uniformInterface origin width (face.val : ℤ)) time 0) ^ 2 / 2)
          0 duration = (fun _ : Fin 1 => leveque04_burgersFiniteGridFlux old face)) ∧
      (∀ cell : Fin N,
        oneDimensionalCellAverage
          (fun x => leveque04_burgersFiniteGridREA old origin width x duration)
          (leveque04_uniformInterface origin width (cell.castSucc.val : ℤ))
          (leveque04_uniformInterface origin width (cell.succ.val : ℤ)) =
            (fun _ : Fin 1 => leveque04_burgersFiniteGridStep duration width old cell)) ∧
      (∀ time ∈ Icc 0 duration, ∀ cell : Fin N,
        oneDimensionalCellAverage
          (fun x => leveque04_burgersFiniteGridREA old origin width x time 0)
          (leveque04_uniformInterface origin width (cell.castSucc.val : ℤ))
          (leveque04_uniformInterface origin width (cell.succ.val : ℤ)) =
            leveque04_burgersFiniteGridStep time width old cell) ∧
      (∀ a b : ℝ,
        LocalConservationLaw.RectangleReferenceOn
          (leveque04_burgersFiniteGridREA old origin width)
          (fun state (_ : Fin 1) => (state 0) ^ 2 / 2) a b duration) ∧
      (∀ reference a b s t : ℝ, a ≤ b → 0 ≤ s → s ≤ t → t ≤ duration →
        (∫ x in a..b,
          |leveque04_burgersFiniteGridREA old origin width x t 0 - reference|) -
          (∫ x in a..b,
            |leveque04_burgersFiniteGridREA old origin width x s 0 - reference|) ≤
          ∫ time in s..t,
            burgersKruzkovFlux reference (leveque04_burgersFiniteGridREA old origin width a time 0) -
              burgersKruzkovFlux reference (leveque04_burgersFiniteGridREA old origin width b time 0)) ∧
      (∀ test : ℝ × ℝ → ℝ, ContDiff ℝ 1 test → HasCompactSupport test →
        tsupport test ⊆ {z : ℝ × ℝ | z.2 < duration} →
        Integrable (fun z : ℝ × ℝ =>
          leveque04_burgersFiniteGridREA old origin width z.1 z.2 0 *
              forwardTestDerivative test (0, 1) z +
            (leveque04_burgersFiniteGridREA old origin width z.1 z.2 0 ^ 2 / 2) *
              forwardTestDerivative test (1, 0) z) ∧
        Integrable (fun x => leveque04_burgersFiniteGridREA old origin width x 0 0 * test (x, 0)) ∧
        (∫ time in Ici (0 : ℝ), ∫ x,
          leveque04_burgersFiniteGridREA old origin width x time 0 *
              fderiv ℝ test (x, time) (0, 1) +
            (leveque04_burgersFiniteGridREA old origin width x time 0 ^ 2 / 2) *
              fderiv ℝ test (x, time) (1, 0)) +
          (∫ x, leveque04_burgersFiniteGridREA old origin width x 0 0 * test (x, 0)) = 0))

end NumStability
