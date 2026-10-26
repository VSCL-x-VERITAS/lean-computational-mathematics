/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.MeasureTheory.Function.LpSeminorm.Basic
import Mathlib.MeasureTheory.Integral.Prod
import Mathlib.Topology.Algebra.Support
import Mathlib.Algebra.Order.Floor.Ring

/-!
# Concrete scalar finite-volume operations

Full-line geometry, normalized initial averages, primitive recursion through the
existing generic conservative update, reconstruction and the compact C1 weak
identity. These transparent definitions state no convergence theorem.
-/

set_option autoImplicit false
noncomputable section
open MeasureTheory Filter
open scoped Topology BigOperators ENNReal

namespace NumStability.Eymard.Chapter01

/-- `face i` is the source point x_(i-1/2), so cell i ends at `face (i+1)`. -/
def laxWendroffWidth (face : ℤ → ℝ) (i : ℤ) : ℝ :=
  face (i + 1) - face i

/-- Actual supremum of all cell widths, not a supplied mesh-size callback. -/
def laxWendroffMeshSize (face : ℤ → ℝ) : ℝ :=
  sSup (Set.range (laxWendroffWidth face))

/-- Definition 20.1's full-line geometry. The shared lower bound is separate. -/
def laxWendroffMesh (face : ℤ → ℝ) : Prop :=
  StrictMono face ∧
  (∀ x : ℝ, ∃ i : ℤ, x ∈ Set.Icc (face i) (face (i + 1))) ∧
  BddAbove (Set.range (laxWendroffWidth face))

/-- The actual positive adjacent source intervals, using existing mesh evidence.
The generic grid forgets neither endpoint; the full source mesh predicate and
common lower ratio remain hypotheses of the source target. -/
def laxWendroffGrid (face : ℤ → ℝ) (hmesh : laxWendroffMesh face) :
    NumStability.OneDimensionalFiniteVolumeGrid :=
  { cellLeft := face
    cellRight := fun i => face (i + 1)
    cell_nonempty := fun i => hmesh.1 (lt_add_one i)
    adjacent := fun i => congrArg face (sub_add_cancel i 1) }

/-- The prescribed explicit recurrence. Each scalar state is represented by the
constant singleton function, and the existing generic update is evaluated at
the unique component. The shared left interface j has flux g(U_(j-1), U_j).
No solver or independent interface-flux field is supplied by the caller. -/
def laxWendroffValues (face : ℤ → ℝ) (hmesh : laxWendroffMesh face) (k : ℝ)
    (initial : ℝ → ℝ) (g : ℝ → ℝ → ℝ) (n : ℕ) : ℤ → ℝ :=
  Nat.rec
    (fun i => NumStability.oneDimensionalCellAverage initial (face i) (face (i + 1)))
    (fun _ previous i =>
      NumStability.riemannFiniteVolumeUpdate (Component := Unit)
        (laxWendroffGrid face hmesh) k
        (fun j _ => previous j)
        (fun j _ => g (previous (j - 1)) (previous j)) i ()) n

/-- Equation 21.4, with a half-open spatial interface convention. On an admissible
mesh exactly one summand is nonzero. Values at negative time are immaterial. -/
def laxWendroffReconstruction (face : ℤ → ℝ) (hmesh : laxWendroffMesh face) (k : ℝ)
    (initial : ℝ → ℝ) (g : ℝ → ℝ → ℝ) (z : ℝ × ℝ) : ℝ :=
  ∑' i : ℤ, if z.1 ∈ Set.Ico (face i) (face (i + 1)) then
    laxWendroffValues face hmesh k initial g (Nat.floor (z.2 / k)) i else 0

/-- Closed half-space of space-time points with nonnegative time coordinate. -/
def laxWendroffHalfSpace : Set (ℝ × ℝ) := {z | 0 ≤ z.2}

/-- C^1 up to the boundary, with compact support relative to the closed
half-space. Tests may be nonzero at t=0. Values at t<0 are unrestricted. -/
def laxWendroffTest (φ : (ℝ × ℝ) → ℝ) : Prop :=
  ContDiffOn ℝ 1 φ laxWendroffHalfSpace ∧
    IsCompact (closure (Function.support φ ∩ laxWendroffHalfSpace))

/-- Within-half-space Fréchet derivative of a test function in the spatial direction. -/
def laxWendroffTestX (φ : (ℝ × ℝ) → ℝ) (z : ℝ × ℝ) : ℝ :=
  fderivWithin ℝ φ laxWendroffHalfSpace z (1, 0)

/-- Within-half-space Fréchet derivative of a test function in the time direction. -/
def laxWendroffTestT (φ : (ℝ × ℝ) → ℝ) (z : ℝ × ℝ) : ℝ :=
  fderivWithin ℝ φ laxWendroffHalfSpace z (0, 1)

/-- Full first conclusion, Definition 19.2, including initial datum and all tests. -/
def laxWendroffWeakSolution (physicalFlux initial : ℝ → ℝ)
    (u : (ℝ × ℝ) → ℝ) : Prop :=
  MemLp u ∞ (volume.restrict {z : ℝ × ℝ | 0 < z.2}) ∧
  ∀ φ : (ℝ × ℝ) → ℝ, laxWendroffTest φ →
    (∫ x : ℝ, ∫ t in Set.Ici (0 : ℝ), u (x, t) * laxWendroffTestT φ (x, t)) +
    (∫ x : ℝ, ∫ t in Set.Ici (0 : ℝ),
      physicalFlux (u (x, t)) * laxWendroffTestX φ (x, t)) +
    (∫ x : ℝ, initial x * φ (x, 0)) = 0

end NumStability.Eymard.Chapter01
