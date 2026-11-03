/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ScalarAdvectionCellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection

/-!
# Actual adjacent face flux and the one-cell travel threshold

Figure 4.2 and its accompanying text on printed pages 68–69 compare positive
advection over less than one cell with travel beyond one cell. The flux below
is the normalized physical time integral of the actual translated uniform
reconstruction. The primary small-step branch is strict; the equality branch
is a separately identified derived boundary result.

The upstream-step witness works for every larger step, without an upper
Courant bound. Transport, rectangle conservation and physical-average support,
the exact witness values and the impossibility of a universal two-input flux
are explicit mathematical realizations of the source geometry.
-/

open MeasureTheory

namespace NumStability

/-- Whole positive-advection adjacent-flux geometry, using actual physical
time and space averages for arbitrary bilateral cell data. -/
def Leveque04AdjacentFluxCFLGeometryTarget : Prop :=
  ∀ (origin width speed dt : ℝ),
    0 < width → 0 < speed → 0 < dt →
  let face := leveque04_uniformInterface origin width
  let reconstruct := fun old : ℤ → ℝ =>
    leveque04_uniformReconstruction origin width old
  let q := fun (old : ℤ → ℝ) (x t : ℝ) =>
    leveque04_scalarAdvectedField (reconstruct old) speed x t
  let flux := fun (old : ℤ → ℝ) (i : ℤ) =>
    leveque04_scalarTimeFaceFluxAverage (reconstruct old) speed dt (face (i - 1))
  let newMean := fun (old : ℤ → ℝ) (i : ℤ) =>
    leveque04_scalarNewCellAverage (reconstruct old) speed dt (face (i - 1)) width
  (∀ old : ℤ → ℝ,
    IsUniformAdvection (q old) speed ∧
    IsRectangleConservationLawSolution (q old) (fun state => speed * state) ∧
    (∀ i : ℤ,
      oneDimensionalCellAverage (fun x => q old x 0) (face (i - 1)) (face i) = old i) ∧
    (∀ i : ℤ, IntervalIntegrable (fun x => q old x dt)
      volume (face (i - 1)) (face i)) ∧
    (∀ i : ℤ, IntervalIntegrable (fun t => speed * q old (face (i - 1)) t)
      volume 0 dt)) ∧
  (speed * dt < width → ∀ (old : ℤ → ℝ) (i : ℤ),
    flux old i = speed * old (i - 1)) ∧
  (speed * dt = width → ∀ (old : ℤ → ℝ) (i : ℤ),
    flux old i = speed * old (i - 1)) ∧
  (width < speed * dt → ∀ i : ℤ,
    let zero : ℤ → ℝ := fun _ => 0
    let upstream : ℤ → ℝ := fun j => if j ≤ i - 2 then 1 else 0
    upstream (i - 2) = 1 ∧
    upstream (i - 1) = zero (i - 1) ∧
    upstream i = zero i ∧
    upstream (i + 1) = zero (i + 1) ∧
    flux zero i = 0 ∧
    flux upstream i = speed - width / dt ∧
    0 < flux upstream i ∧
    newMean zero i = 0 ∧
    newMean upstream i = min ((speed * dt - width) / width) 1 ∧
    0 < newMean upstream i ∧
    ¬ ∃ F : ℝ → ℝ → ℝ, ∀ old : ℤ → ℝ,
      flux old i = F (old (i - 1)) (old i))

end NumStability
