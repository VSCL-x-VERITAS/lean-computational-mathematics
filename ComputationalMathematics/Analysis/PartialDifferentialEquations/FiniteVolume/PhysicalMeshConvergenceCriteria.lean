/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ConvergenceCriteria
import Mathlib.MeasureTheory.Measure.WithDensity
import Mathlib.Algebra.Order.Floor.Ring

/-!
# Convergence on actual refining physical meshes

The prescribed active physical cells cover the domain, have disjoint interiors,
and their actual positive widths are bounded by the mesh size tending to zero.
Counting weights are those actual widths. Reconstruction indices must select
the actual spatial cells and physical time slabs. Arbitrary-measure and arbitrary
locator utilities remain in `ConvergenceCriteria` without supplying these guards.
-/

noncomputable section

namespace NumStability

open Filter MeasureTheory Set
open scoped Topology ENNReal

variable {A E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- A genuine cell partition on a prescribed physical domain. Closed endpoints
allow either representative on null interfaces; cell interiors are disjoint. -/
def IsPhysicalCellMesh (domain : Set ℝ) (active : A → Set ℤ)
    (edge : A → ℤ → ℝ) (dx : A → ℝ) : Prop :=
  MeasurableSet domain ∧
    (∀ a, (active a).Nonempty) ∧
    (∀ a i, i ∈ active a → edge a i < edge a (i + 1) ∧
      edge a (i + 1) - edge a i ≤ dx a ∧
      Ioo (edge a i) (edge a (i + 1)) ⊆ domain) ∧
    (∀ a i j, i ∈ active a → j ∈ active a → i < j →
      edge a (i + 1) ≤ edge a j) ∧
    ∀ a x, x ∈ domain → ∃ i ∈ active a, x ∈ Icc (edge a i) (edge a (i + 1))

def physicalCellCenter (edge : A → ℤ → ℝ) : A → ℤ → ℝ :=
  fun a i => (edge a i + edge a (i + 1)) / 2

def physicalCellWeight (active : A → Set ℤ) (edge : A → ℤ → ℝ)
    (a : A) (i : ℤ) : ℝ≥0∞ := by
  classical
  exact if i ∈ active a then ENNReal.ofReal (edge a (i + 1) - edge a i) else 0

/-- No arbitrary measure is supplied: every active index has its actual physical width. -/
def physicalCellGridMeasure (active : A → Set ℤ) (edge : A → ℤ → ℝ)
    (a : A) : Measure ℤ :=
  Measure.count.withDensity (physicalCellWeight active edge a)

/-- Actual time edges, including nonuniform time steps bounded by the refining mesh size. -/
def IsPhysicalTimeMesh (time : A → ℕ → ℝ) (dt : A → ℝ) : Prop :=
  ∀ a, time a 0 = 0 ∧ ∀ n, time a n < time a (n + 1) ∧
    time a (n + 1) - time a n ≤ dt a

def HasPhysicalHorizon (time : A → ℕ → ℝ) (steps : A → ℕ) (T : ℝ) : Prop :=
  0 < T ∧ ∀ a, time a (steps a) = T

/-- General fixed-time observation in the actual containing slab. Exact clock
alignment is the separate Chapter 8 specialization `HasPhysicalHorizon`. -/
def HasPhysicalObservationTime (time : A → ℕ → ℝ) (steps : A → ℕ) (T : ℝ) : Prop :=
  0 < T ∧ ∀ a, time a (steps a) ≤ T ∧ T < time a (steps a + 1)

/-- Supplied reconstruction indices have to follow actual cells and actual time slabs. -/
def HasPhysicalReconstructionIndices (domain : Set ℝ) (active : A → Set ℤ)
    (edge : A → ℤ → ℝ) (time : A → ℕ → ℝ)
    (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ) : Prop :=
  (∀ a x, x ∈ domain → spaceCell a x ∈ active a ∧
    x ∈ Icc (edge a (spaceCell a x)) (edge a (spaceCell a x + 1))) ∧
    ∀ a t, 0 ≤ t → time a (timeCell a t) ≤ t ∧
      t < time a (timeCell a t + 1)

def uniformPhysicalEdge (origin dx : A → ℝ) : A → ℤ → ℝ :=
  fun a i => origin a + (i : ℝ) * dx a

def uniformPhysicalSpaceCell (origin dx : A → ℝ) : A → ℝ → ℤ :=
  fun a x => ⌊(x - origin a) / dx a⌋

def uniformPhysicalTime (dt : A → ℝ) : A → ℕ → ℝ :=
  fun a n => (n : ℝ) * dt a

def uniformPhysicalTimeCell (dt : A → ℝ) : A → ℝ → ℕ :=
  fun a t => ⌊t / dt a⌋₊

def activePhysicalGridFunction (active : A → Set ℤ) (U : A → ℤ → E)
    (a : A) (i : ℤ) : E := by
  classical
  exact if i ∈ active a then U a i else 0

/-- A prescribed genuine grid norm can replace the p-norm. The represented error
is the actual physical-grid difference, extended by zero at inactive indices. -/
def HasPhysicalChosenNormConvergence (l : Filter A) (domain : Set ℝ)
    (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
    (time : A → ℕ → ℝ) (steps : A → ℕ) (Q : A → ℕ → ℤ → E)
    (reference : A → ℤ → E)
    (X : A → Type*) [∀ a, NormedAddCommGroup (X a)]
    (representation : ∀ a, X a →+ (ℤ → E)) (T : ℝ) : Prop :=
  IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
    IsPhysicalTimeMesh time dt ∧ HasPhysicalObservationTime time steps T ∧
    HasRepresentedGridNormConvergence l X representation
      (activePhysicalGridFunction active (numericalAtHorizon Q steps))
      (activePhysicalGridFunction active reference)

/-- The physical point-reference p-norm qualification on an actual refining mesh. -/
def HasPhysicalPointConvergence (l : Filter A) (p : ℝ≥0∞)
    (domain : Set ℝ) (active : A → Set ℤ) (edge : A → ℤ → ℝ)
    (dx dt : A → ℝ) (time : A → ℕ → ℝ) (steps : A → ℕ)
    (Q : A → ℕ → ℤ → E)
    (q : ℝ → ℝ → E) (T : ℝ) : Prop :=
  1 ≤ p ∧ IsSpaceTimeRefinement l dx dt ∧
    IsPhysicalCellMesh domain active edge dx ∧ IsPhysicalTimeMesh time dt ∧
    HasPhysicalObservationTime time steps T ∧
    HasGridErrorConvergence l p (physicalCellGridMeasure active edge)
      (numericalAtHorizon Q steps) (pointReference q (physicalCellCenter edge) T)

/-- Cell means use the same physical cells as the refining geometry and norm. -/
def HasPhysicalCellMeanConvergence (l : Filter A) (p : ℝ≥0∞)
    (domain : Set ℝ) (active : A → Set ℤ) (edge : A → ℤ → ℝ)
    (dx dt : A → ℝ) (time : A → ℕ → ℝ) (steps : A → ℕ)
    (Q : A → ℕ → ℤ → E)
    (q : ℝ → ℝ → E) (T : ℝ) : Prop :=
  1 ≤ p ∧ IsSpaceTimeRefinement l dx dt ∧
    IsPhysicalCellMesh domain active edge dx ∧ IsPhysicalTimeMesh time dt ∧
    HasPhysicalObservationTime time steps T ∧
    (∀ a i, i ∈ active a →
      IntervalIntegrable (fun x => q x T) volume (edge a i) (edge a (i + 1))) ∧
    HasGridErrorConvergence l p (physicalCellGridMeasure active edge)
      (numericalAtHorizon Q steps)
      (cellMeanReference q edge (fun a i => edge a (i + 1)) T)

/-- Actual reconstructed field convergence, carrying physical mesh and index guards. -/
def HasPhysicalSpaceTimeConvergence (l : Filter A) (domain : Set ℝ)
    (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
    (time : A → ℕ → ℝ) (Q : A → ℕ → ℤ → E)
    (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ)
    (q : ℝ → ℝ → E) (T : ℝ) : Prop :=
  IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
    IsPhysicalTimeMesh time dt ∧
    HasPhysicalReconstructionIndices domain active edge time spaceCell timeCell ∧
    0 < T ∧ HasSpaceTimeL1Convergence l domain T
      (numericalSpaceTimeReconstruction Q spaceCell timeCell) q

def HasPhysicalLocalSpaceTimeConvergence (l : Filter A) (domain : Set ℝ)
    (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
    (time : A → ℕ → ℝ) (Q : A → ℕ → ℤ → E)
    (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ)
    (q : ℝ → ℝ → E) : Prop :=
  IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
    IsPhysicalTimeMesh time dt ∧
    HasPhysicalReconstructionIndices domain active edge time spaceCell timeCell ∧
    HasLocalSpaceTimeL1Convergence l domain
      (numericalSpaceTimeReconstruction Q spaceCell timeCell) q

/-- A fixed problem's weak-solution set remains distinct from a selected reference. -/
def HasPhysicalSolutionSetConvergence (l : Filter A) (domain : Set ℝ)
    (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
    (time : A → ℕ → ℝ) (Q : A → ℕ → ℤ → E)
    (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ)
    (W : Set (ℝ → ℝ → E)) (T : ℝ) : Prop :=
  IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
    IsPhysicalTimeMesh time dt ∧
    HasPhysicalReconstructionIndices domain active edge time spaceCell timeCell ∧
    0 < T ∧ HasSolutionSetL1Convergence l domain T
      (numericalSpaceTimeReconstruction Q spaceCell timeCell) W

/-- Mesh and initialization may depend on the datum; each selected reference belongs
to that same datum's prescribed solution set. No existence/uniqueness is inferred. -/
def HasPhysicalDataClassConvergence {D : Type*} (dataClass : Set D)
    (solutions : D → Set (ℝ → ℝ → E)) (selected : D → ℝ → ℝ → E)
    (l : Filter A) (p : ℝ≥0∞) (domain : Set ℝ)
    (active : D → A → Set ℤ) (edge : D → A → ℤ → ℝ)
    (dx dt : D → A → ℝ) (time : D → A → ℕ → ℝ) (steps : D → A → ℕ)
    (Q : D → A → ℕ → ℤ → E) (initial : D → A → ℤ → E) (T : ℝ) : Prop :=
  ∀ d ∈ dataClass,
    (∀ a i, i ∈ active d a → Q d a 0 i = initial d a i) ∧
    selected d ∈ solutions d ∧
    HasPhysicalPointConvergence l p domain (active d) (edge d) (dx d) (dt d)
      (time d) (steps d) (Q d) (selected d) T

end NumStability
