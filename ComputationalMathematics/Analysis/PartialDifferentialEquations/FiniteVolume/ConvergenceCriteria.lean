/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.MeasureTheory.Function.LpSeminorm.Basic
import Mathlib.Topology.Instances.ENNReal.Lemmas

/-!
# Convergence criteria for prescribed numerical families

The mesh family, reference, norm and observation domain are parameters. These
definitions do not assert that a method converges, identify a PDE solution, or
equate different reference or norm choices. Extended errors retain infinite
values, and only the error needs to be integrable.
-/

noncomputable section

namespace NumStability

open Filter MeasureTheory Set
open scoped Topology ENNReal

variable {A I E : Type*} [MeasurableSpace I]
variable [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- An explicitly selected positive refining mesh family. -/
def IsSpaceTimeRefinement (l : Filter A) (dx dt : A → ℝ) : Prop :=
  NeBot l ∧ (∀ a, 0 < dx a ∧ 0 < dt a) ∧
    Tendsto dx l (𝓝 0) ∧ Tendsto dt l (𝓝 0)

/-- The mesh-dependent discrete error in a chosen physical measure and state norm. -/
def gridErrorENorm (p : ℝ≥0∞) (μ : Measure I) (Q reference : I → E) : ℝ≥0∞ :=
  eLpNorm (fun i => Q i - reference i) p μ

/-- An arbitrary prescribed genuine grid norm, represented faithfully as grid functions.
The normed spaces may vary with the mesh; this is not an arbitrary scalar error oracle. -/
def HasRepresentedGridNormConvergence (l : Filter A) (X : A → Type*)
    [∀ a, NormedAddCommGroup (X a)] (representation : ∀ a, X a →+ (I → E))
    (Q reference : A → I → E) : Prop :=
  (∀ a, Function.Injective (representation a)) ∧
    ∃ error : ∀ a, X a,
      (∀ a i, representation a (error a) i = Q a i - reference a i) ∧
      Tendsto (fun a => ‖error a‖) l (𝓝 0)

/-- Convergence for the prescribed discrete reference and chosen error norm. -/
def HasGridErrorConvergence (l : Filter A) (p : ℝ≥0∞)
    (μ : A → Measure I) (Q reference : A → I → E) : Prop :=
  (∀ a, AEStronglyMeasurable (fun i => Q a i - reference a i) (μ a)) ∧
    Tendsto (fun a => gridErrorENorm p (μ a) (Q a) (reference a)) l (𝓝 0)

/-- Actual point references at a fixed physical time. -/
def pointReference (q : ℝ → ℝ → E) (center : A → I → ℝ) (T : ℝ) : A → I → E :=
  fun a i => q (center a i) T

/-- Actual normalized physical cell means at a fixed physical time. -/
def cellMeanReference (q : ℝ → ℝ → E) (left right : A → I → ℝ)
    (T : ℝ) : A → I → E :=
  fun a i => oneDimensionalCellAverage (fun x => q x T) (left a i) (right a i)

/-- A clock observing the same fixed horizon on every mesh. -/
def HasExactHorizon (dt : A → ℝ) (steps : A → ℕ) (T : ℝ) : Prop :=
  0 < T ∧ ∀ a, (steps a : ℝ) * dt a = T

/-- Actual numerical output at the chosen executed time level. -/
def numericalAtHorizon (Q : A → ℕ → I → E) (steps : A → ℕ) : A → I → E :=
  fun a i => Q a (steps a) i

/-- Fixed-time convergence with actual point references, on the prescribed refining family. -/
def HasPointReferenceConvergence (l : Filter A) (p : ℝ≥0∞)
    (dx dt : A → ℝ) (μ : A → Measure I) (steps : A → ℕ)
    (Q : A → ℕ → I → E) (q : ℝ → ℝ → E) (center : A → I → ℝ)
    (T : ℝ) : Prop :=
  1 ≤ p ∧ IsSpaceTimeRefinement l dx dt ∧ HasExactHorizon dt steps T ∧
    HasGridErrorConvergence l p μ (numericalAtHorizon Q steps) (pointReference q center T)

/-- The cell-mean alternative requires genuine positive-width integrable physical cells. -/
def HasCellMeanReferenceConvergence (l : Filter A) (p : ℝ≥0∞)
    (dx dt : A → ℝ) (μ : A → Measure I) (steps : A → ℕ)
    (Q : A → ℕ → I → E) (q : ℝ → ℝ → E) (left right : A → I → ℝ)
    (T : ℝ) : Prop :=
  1 ≤ p ∧ IsSpaceTimeRefinement l dx dt ∧ HasExactHorizon dt steps T ∧
    (∀ a i, left a i < right a i ∧
      IntervalIntegrable (fun x => q x T) volume (left a i) (right a i)) ∧
    HasGridErrorConvergence l p μ (numericalAtHorizon Q steps)
      (cellMeanReference q left right T)

/-- Literal sampling of a numerical array using the supplied spatial/time cell locators.
The locators and their geometry belong to the prescribed mesh context. -/
def numericalSpaceTimeReconstruction (Q : A → ℕ → I → E)
    (spaceCell : A → ℝ → I) (timeCell : A → ℝ → ℕ) : A → ℝ → ℝ → E :=
  fun a x t => Q a (timeCell a t) (spaceCell a x)

/-- Extended physical space-time L1 error, with the spatial integral performed first. -/
def spaceTimeL1Error (domain : Set ℝ) (T : ℝ) (U q : ℝ → ℝ → E) : ℝ≥0∞ :=
  ∫⁻ t in Icc 0 T, ∫⁻ x in domain, ‖U x t - q x t‖ₑ

/-- Measurability of the actual error on the prescribed space-time domain. -/
def MeasurableSpaceTimeError (domain : Set ℝ) (T : ℝ)
    (U q : ℝ → ℝ → E) : Prop :=
  AEStronglyMeasurable (fun z : ℝ × ℝ => U z.1 z.2 - q z.1 z.2)
    ((volume.restrict domain).prod (volume.restrict (Icc 0 T)))

/-- Convergence on a prescribed spatial domain and finite time interval. -/
def HasSpaceTimeL1Convergence (l : Filter A) (domain : Set ℝ) (T : ℝ)
    (U : A → ℝ → ℝ → E) (q : ℝ → ℝ → E) : Prop :=
  (∀ a, MeasurableSpaceTimeError domain T (U a) q) ∧
    Tendsto (fun a => spaceTimeL1Error domain T (U a) q) l (𝓝 0)

/-- Local convergence on every bounded spatial interval and positive finite horizon. -/
def HasLocalSpaceTimeL1Convergence (l : Filter A) (domain : Set ℝ)
    (U : A → ℝ → ℝ → E) (q : ℝ → ℝ → E) : Prop :=
  ∀ a b T : ℝ, a ≤ b → 0 < T →
    HasSpaceTimeL1Convergence l (domain ∩ Icc a b) T U q

/-- Distance to a prescribed same-problem solution set; the empty-set value is infinity. -/
def solutionSetL1Error (domain : Set ℝ) (T : ℝ) (U : ℝ → ℝ → E)
    (W : Set (ℝ → ℝ → E)) : ℝ≥0∞ :=
  ⨅ q ∈ W, spaceTimeL1Error domain T U q

/-- Set convergence does not select one member of the reference solution set. -/
def HasSolutionSetL1Convergence (l : Filter A) (domain : Set ℝ) (T : ℝ)
    (U : A → ℝ → ℝ → E) (W : Set (ℝ → ℝ → E)) : Prop :=
  (∀ a q, q ∈ W → MeasurableSpaceTimeError domain T (U a) q) ∧
    Tendsto (fun a => solutionSetL1Error domain T (U a) W) l (𝓝 0)

/-- Initialization is supplied numerical data, rather than an implicit exact-sampling assumption. -/
def HasNumericalInitialization {D : Type*} (Q : D → A → ℕ → I → E)
    (initial : D → A → I → E) : Prop :=
  ∀ d a i, Q d a 0 i = initial d a i

/-- Qualification for all data in a prescribed class, for actual selected references. -/
def HasDataClassGridConvergence {D : Type*} (dataClass : Set D)
    (l : Filter A) (p : ℝ≥0∞) (μ : A → Measure I)
    (Q reference : D → A → I → E) : Prop :=
  ∀ d ∈ dataClass, HasGridErrorConvergence l p μ (Q d) (reference d)

/-- A fixed problem's supplied solution sets and selected references remain tied to the
same datum. This qualification does not assert that such selections exist or are unique. -/
def HasSelectedReferenceDataConvergence {D : Type*} (dataClass : Set D)
    (solutions : D → Set (ℝ → ℝ → E)) (selected : D → ℝ → ℝ → E)
    (l : Filter A) (p : ℝ≥0∞) (dx dt : A → ℝ) (μ : A → Measure I)
    (steps : A → ℕ) (Q : D → A → ℕ → I → E) (initial : D → A → I → E)
    (center : A → I → ℝ) (T : ℝ) : Prop :=
  HasNumericalInitialization Q initial ∧
    ∀ d ∈ dataClass, selected d ∈ solutions d ∧
      HasPointReferenceConvergence l p dx dt μ steps (Q d) (selected d) center T

end NumStability
