import ComputationalMathematics.Analysis.Normed.Group.SequentialError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCellProjection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.HighResolutionCoordinateSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics
import Lean
import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.ParametricIntervalIntegral
import Mathlib.Analysis.Normed.Group.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.MeasureTheory.Integral.Pi
set_option maxRecDepth 4000
set_option maxHeartbeats 1200000

open MeasureTheory
open scoped BigOperators
namespace NumStability.FiniteDirectionalRepair

/-- Finite active physical cells with shared face IDs. Exterior faces require
incidence with their active cell only; no fictitious exterior physical cell
or unspecified boundary condition is introduced. -/
structure PhysicalData (D Cell Face Point FacePoint : Type*)
    [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] (m : ℕ) where
  cells : FiniteVolumeCellPartition Cell Point
  measure : Measure Point
  positive : ∀ cell, measure (cells.cellRegion cell) ≠ 0
  finite : ∀ cell, measure (cells.cellRegion cell) ≠ ⊤
  leftFace : D → Cell → Face
  rightFace : D → Cell → Face
  faceMeasure : D → Face → Measure FacePoint
  facePoint : D → Face → FacePoint → Point
  left_incidence : ∀ d cell, ∀ᵐ point ∂faceMeasure d (leftFace d cell),
    facePoint d (leftFace d cell) point ∈ closure (cells.cellRegion cell)
  right_incidence : ∀ d cell, ∀ᵐ point ∂faceMeasure d (rightFace d cell),
    facePoint d (rightFace d cell) point ∈ closure (cells.cellRegion cell)
  admissibleStates : D → Set (Fin m → ℝ)
  normalFlux : D → Face → FacePoint → (Fin m → ℝ) → Fin m → ℝ
  hyperbolic : ∀ d face point, IsHyperbolicFluxOn (normalFlux d face point) (admissibleStates d)

variable {D Cell Face Point FacePoint : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

noncomputable def PhysicalData.cellVolume (data : PhysicalData D Cell Face Point FacePoint m)
    (cell : Cell) : ℝ := (data.measure (data.cells.cellRegion cell)).toReal

theorem PhysicalData.cellVolume_pos (data : PhysicalData D Cell Face Point FacePoint m)
    (cell : Cell) : 0 < data.cellVolume cell := ENNReal.toReal_pos (data.positive cell) (data.finite cell)

noncomputable def PhysicalData.cellMean (data : PhysicalData D Cell Face Point FacePoint m)
    (q : Point → ℝ → State) (cell : Cell) (t : ℝ) : State :=
  cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)

noncomputable def PhysicalData.faceFlux (data : PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → State) (face : Face) (t : ℝ) : State :=
  ∫ point, data.normalFlux d face point (q (data.facePoint d face point) t) ∂data.faceMeasure d face

/-- Every subinterval has an actual physical integral balance. All regularity
and trace premises are restricted to active cells and their incident faces. -/
def PhysicalData.ReferenceOn (data : PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → State) (s t : ℝ) : Prop :=
  (∀ cell, ∀ τ ∈ Set.uIcc s t, IntegrableOn (fun x => q x τ) (data.cells.cellRegion cell) data.measure) ∧
  (∀ cell, ∀ τ ∈ Set.uIcc s t,
    Integrable (fun point => data.normalFlux d (data.leftFace d cell) point
      (q (data.facePoint d (data.leftFace d cell) point) τ)) (data.faceMeasure d (data.leftFace d cell)) ∧
    Integrable (fun point => data.normalFlux d (data.rightFace d cell) point
      (q (data.facePoint d (data.rightFace d cell) point) τ)) (data.faceMeasure d (data.rightFace d cell))) ∧
  (∀ x ∈ data.cells.domain, ∀ τ ∈ Set.uIcc s t, q x τ ∈ data.admissibleStates d) ∧
  ∀ u ∈ Set.uIcc s t, ∀ v ∈ Set.uIcc s t,
    (∀ cell, IntervalIntegrable (data.faceFlux d q (data.leftFace d cell)) volume u v ∧
      IntervalIntegrable (data.faceFlux d q (data.rightFace d cell)) volume u v) ∧
    ∀ cell, data.cellVolume cell • (data.cellMean q cell v - data.cellMean q cell u) =
      ∫ τ in u..v, data.faceFlux d q (data.leftFace d cell) τ - data.faceFlux d q (data.rightFace d cell) τ

/-- Boundary/ghost inputs may be closed over in `rule`; the current numerical
array contains only actual active cell values. Shared face IDs ensure the
same numerical flux is reused by both incident cells. -/
noncomputable def advance (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) : State :=
  finiteVolumeCellAverageUpdate dt (data.cellVolume cell) (current cell)
    (rule d dt current (data.rightFace d cell) - rule d dt current (data.leftFace d cell))

noncomputable def sweep (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (stages : List (D × ℝ)) (current : Cell → State) : Cell → State :=
  orderedOperatorSweep (stages.map fun stage => advance data rule stage.1 stage.2) current

theorem advance_mass_balance (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) :
    data.cellVolume cell • advance data rule d dt current cell =
      data.cellVolume cell • current cell - dt •
        (rule d dt current (data.rightFace d cell) - rule d dt current (data.leftFace d cell)) :=
  cellVolume_smul_finiteVolumeCellAverageUpdate _ _ _ _ (data.cellVolume_pos cell).ne'

/-- The finite active-cell balance retains all exterior boundary transfers. -/
theorem finite_mass_balance [Fintype Cell] (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (current : Cell → State) :
    (∑ cell, data.cellVolume cell • advance data rule d dt current cell) =
      (∑ cell, data.cellVolume cell • current cell) - dt •
        ∑ cell, (rule d dt current (data.rightFace d cell) - rule d dt current (data.leftFace d cell)) := by
  simp_rw [advance_mass_balance]
  rw [Finset.sum_sub_distrib, Finset.smul_sum]

theorem sweep_cons (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (stages : List (D × ℝ)) (current : Cell → State) :
    sweep data rule ((d, dt) :: stages) current =
      sweep data rule stages (advance data rule d dt current) := rfl

theorem sweep_split (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (before after : List (D × ℝ)) (d : D) (dt : ℝ) (current : Cell → State) :
    sweep data rule (before ++ (d, dt) :: after) current =
      sweep data rule after (advance data rule d dt (sweep data rule before current)) := by
  simp [sweep, orderedOperatorSweep, List.foldl_append]

def LineLocal [DecidableEq Cell]
    (stencil : D → Face → Finset Cell)
    (rule : D → ℝ → (Cell → State) → Face → State) : Prop :=
  ∀ d dt current other face,
    (∀ cell ∈ stencil d face, current cell = other cell) →
      rule d dt current face = rule d dt other face

theorem advance_local [DecidableEq Cell] (data : PhysicalData D Cell Face Point FacePoint m)
    (stencil : D → Face → Finset Cell)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (hlocal : LineLocal stencil rule) (d : D) (dt : ℝ)
    (current other : Cell → State) (cell : Cell)
    (hagree : ∀ j ∈ insert cell (stencil d (data.leftFace d cell) ∪ stencil d (data.rightFace d cell)),
      current j = other j) : advance data rule d dt current cell = advance data rule d dt other cell := by
  have hc := hagree cell (by simp)
  have hl := hlocal d dt current other (data.leftFace d cell)
    (fun j hj => hagree j (by simp [hj]))
  have hr := hlocal d dt current other (data.rightFace d cell)
    (fun j hj => hagree j (by simp [hj]))
  simp only [advance, hc, hl, hr]

/-- An auxiliary local estimate uses independent physical averages and flux
histories; it is not the high-resolution class or a stand-in for that class. -/
theorem advance_error_le (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound leftBound rightBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hleft : ‖rule d (t - s) current (data.leftFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t‖ ≤ leftBound)
    (hright : ‖rule d (t - s) current (data.rightFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t‖ ≤ rightBound) :
    ‖advance data rule d (t - s) current cell - data.cellMean q cell t‖ ≤
      oldBound + (t - s) / data.cellVolume cell * (leftBound + rightBound) := by
  have href' := href.2.2.2 s Set.left_mem_uIcc t Set.right_mem_uIcc
  have hb := href'.2 cell
  rw [intervalIntegral.integral_sub (href'.1 cell).1 (href'.1 cell).2] at hb
  rw [smul_sub] at hb
  rw [← cellWidth_smul_oneDimensionalCellAverage _ hst,
    ← cellWidth_smul_oneDimensionalCellAverage _ hst] at hb
  have he : data.cellVolume cell • (advance data rule d (t - s) current cell - data.cellMean q cell t) =
      data.cellVolume cell • (current cell - data.cellMean q cell s) +
      (t - s) • ((rule d (t - s) current (data.leftFace d cell) -
        oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t) -
        (rule d (t - s) current (data.rightFace d cell) -
        oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t)) := by
    rw [smul_sub, advance_mass_balance, eq_add_of_sub_eq hb]
    module
  exact norm_le_of_weighted_error_balance (data.cellVolume_pos cell) (sub_nonneg.mpr hst.le)
    he hold hleft hright

end NumStability.FiniteDirectionalRepair


open MeasureTheory Filter
open scoped BigOperators Topology
namespace NumStability.DirectionalQualityRepair

variable {m : ℕ}
local notation "State" => Fin m → ℝ

/-- A genuine local conservation reference, on all space/time subrectangles
of the supplied physical line problem. Values outside this box are unused. -/
def RectangleReferenceOn (q : ℝ → ℝ → State) (flux : State → State)
    (left right horizon : ℝ) : Prop :=
  (∀ t ∈ Set.Icc 0 horizon, IntervalIntegrable (fun x => q x t) volume left right) ∧
  (∀ x ∈ Set.Icc left right, IntervalIntegrable (fun t => flux (q x t)) volume 0 horizon) ∧
  ∀ a ∈ Set.Icc left right, ∀ b ∈ Set.Icc left right,
    ∀ s ∈ Set.Icc 0 horizon, ∀ t ∈ Set.Icc 0 horizon,
      (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
        ∫ τ in s..t, flux (q a τ) - flux (q b τ)

/-- Smoothness is a fixed mathematical condition, never a caller-chosen
eligibility predicate. The same local conservation law and state domain apply. -/
def SmoothReferenceOn (q : ℝ → ℝ → State) (flux : State → State)
    (states : Set State) (left right horizon : ℝ) : Prop :=
  ContDiffOn ℝ ⊤ (Function.uncurry q) (Set.Icc left right ×ˢ Set.Icc 0 horizon) ∧
  RectangleReferenceOn q flux left right horizon ∧
  ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon, q x t ∈ states

noncomputable def windowVariation (start : ℤ) (count : ℕ) (values : ℤ → State) : ℝ :=
  ∑ k ∈ Finset.range count, ‖values (start + k + 1) - values (start + k)‖

/-- Logical line geometry may produce a spatially varying directional law.
Conservation still uses the same physical endpoint flux in every rectangle. -/
def SpatialRectangleReferenceOn (q : ℝ → ℝ → State) (flux : ℝ → State → State)
    (left right horizon : ℝ) : Prop :=
  (∀ t ∈ Set.Icc 0 horizon, IntervalIntegrable (fun x => q x t) volume left right) ∧
  (∀ x ∈ Set.Icc left right, IntervalIntegrable (fun t => flux x (q x t)) volume 0 horizon) ∧
  ∀ a ∈ Set.Icc left right, ∀ b ∈ Set.Icc left right,
    ∀ s ∈ Set.Icc 0 horizon, ∀ t ∈ Set.Icc 0 horizon,
      (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
        ∫ τ in s..t, flux a (q a τ) - flux b (q b τ)

def SpatialSmoothReferenceOn (q : ℝ → ℝ → State) (flux : ℝ → State → State)
    (states : Set State) (left right horizon : ℝ) : Prop :=
  ContDiffOn ℝ ⊤ (Function.uncurry q) (Set.Icc left right ×ˢ Set.Icc 0 horizon) ∧
  SpatialRectangleReferenceOn q flux left right horizon ∧
  ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon, q x t ∈ states

theorem spatial_rectangle_const_iff (q : ℝ → ℝ → State) (flux : State → State)
    (left right horizon : ℝ) :
    SpatialRectangleReferenceOn q (fun _ => flux) left right horizon ↔
      RectangleReferenceOn q flux left right horizon := Iff.rfl

theorem spatial_smooth_const_iff (q : ℝ → ℝ → State) (flux : State → State)
    (states : Set State) (left right horizon : ℝ) :
    SpatialSmoothReferenceOn q (fun _ => flux) states left right horizon ↔
      SmoothReferenceOn q flux states left right horizon := Iff.rfl

/-- Data of a refining one-dimensional numerical family. The full supplied
line is an input, while the explicit finite input window controls locality.
Its extra entries may be supplied boundary/ghost data. No boundary condition
or automatic admissibility outside the used window is inferred. -/
structure LineFamily (m : ℕ) where
  flux : ℝ → (Fin m → ℝ) → Fin m → ℝ
  states : Set (Fin m → ℝ)
  left : ℝ
  right : ℝ
  interval_nonempty : left < right
  hyperbolic : ∀ x ∈ Set.Icc left right, IsHyperbolicFluxOn (flux x) states
  horizon : ℝ
  horizon_pos : 0 < horizon
  grid : ℕ → OneDimensionalFiniteVolumeGrid
  mesh : ℕ → ℝ
  mesh_pos : ∀ n, 0 < mesh n
  mesh_tendsto : Tendsto mesh atTop (𝓝 0)
  meshRatio : ℝ
  meshRatio_pos : 0 < meshRatio
  dt : ℕ → ℝ
  dt_pos : ∀ n, 0 < dt n
  dt_le_horizon : ∀ n, dt n ≤ horizon
  cfl : ℝ
  cfl_pos : 0 < cfl
  activeStart : ℕ → ℤ
  activeCount : ℕ → ℕ
  activeCount_two_le : ∀ n, 2 ≤ activeCount n
  targetLeft : ℝ
  targetRight : ℝ
  target_nonempty : targetLeft < targetRight
  target_inside : left < targetLeft ∧ targetRight < right
  active_coverage : ∀ n x, x ∈ Set.Icc targetLeft targetRight →
    ∃ j ∈ Finset.Ico (activeStart n) (activeStart n + activeCount n),
      x ∈ Set.Icc ((grid n).cellLeft j) ((grid n).cellRight j)
  inputStart : ℕ → ℤ
  inputCount : ℕ → ℕ
  input_covers : ∀ n,
    Finset.Ico (activeStart n) (activeStart n + activeCount n) ⊆
      Finset.Ico (inputStart n) (inputStart n + inputCount n)
  input_geometry : ∀ n j, j ∈ Finset.Ico (inputStart n) (inputStart n + inputCount n) →
    left ≤ (grid n).cellLeft j ∧ (grid n).cellRight j ≤ right ∧
    (grid n).cellVolume j ≤ mesh n ∧ dt n ≤ cfl * (grid n).cellVolume j
  mesh_comparable : ∀ n j, j ∈ Finset.Ico (inputStart n) (inputStart n + inputCount n) →
    mesh n ≤ meshRatio * (grid n).cellVolume j
  numericalFlux : ℕ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ
  admitted : ℕ → (ℤ → Fin m → ℝ) → Prop
  line_local : ∀ n (q other : ℤ → Fin m → ℝ),
    (∀ j ∈ Finset.Ico (inputStart n) (inputStart n + inputCount n), q j = other j) →
    ∀ j ∈ Finset.Icc (activeStart n) (activeStart n + activeCount n),
      numericalFlux n q j = numericalFlux n other j

noncomputable def LineFamily.advance (family : LineFamily m) (n : ℕ) (values : ℤ → State)
    (j : ℤ) : State := riemannFiniteVolumeUpdate (family.grid n) (family.dt n) values
      (family.numericalFlux n values) j

def LineFamily.InitialProjection (family : LineFamily m) (n : ℕ)
    (q : ℝ → ℝ → State) (values : ℤ → State) : Prop :=
  ∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
    values j = finiteVolumeCellAverageOn (family.grid n) (fun x => q x 0) j

/-- The adopted quality convention has uniform refinement content.
Accuracy concerns every actual smooth local reference and its exact projected
inputs. Constants cannot be chosen after each mesh or as an output error norm.
Oscillation control uses the incoming finite window, including boundary data,
with uniform amplification and a vanishing additive rate. Exact TVD is a
stronger sufficient instance, not a restriction on every supplied family. -/
structure LineFamily.HasControlledHighResolution (family : LineFamily m) : Prop where
  order : ∃ p : ℝ, 1 < p ∧
    ∀ q : ℝ → ℝ → State, SpatialSmoothReferenceOn q family.flux family.states
      family.left family.right family.horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ, ∀ n, N ≤ n → ∀ values,
        family.InitialProjection n q values → family.admitted n values ∧
        ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
          ‖family.advance n values j -
            finiteVolumeCellAverageOn (family.grid n) (fun x => q x (family.dt n)) j‖ ≤
              C * family.dt n * (family.mesh n) ^ p
  stability : ∃ L : ℝ, 0 ≤ L ∧ ∀ n values other, family.admitted n values →
    family.admitted n other → ∀ E : ℝ, 0 ≤ E →
    (∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
      ‖values j - other j‖ ≤ E) →
    ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
      ‖family.advance n values j - family.advance n other j‖ ≤ (1 + L * family.dt n) * E
  oscillation : ∃ K : ℝ, 0 ≤ K ∧ ∃ noise : ℕ → ℝ,
    (∀ n, 0 ≤ noise n) ∧ Tendsto noise atTop (𝓝 0) ∧
    ∀ n values, family.admitted n values →
      windowVariation (family.activeStart n) (family.activeCount n - 1) (family.advance n values) ≤
        (1 + K * family.dt n) *
          windowVariation (family.inputStart n) (family.inputCount n - 1) values + family.dt n * noise n

/-- Stability transfers the smooth-reference consistency estimate to actual
perturbed inputs. The supplied exterior entries participate in the incoming
error bound; no boundary accuracy is silently inferred. -/
theorem LineFamily.HasControlledHighResolution.perturbed_accuracy
    (family : LineFamily m) (quality : family.HasControlledHighResolution) :
    ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧ ∀ q : ℝ → ℝ → State,
      SpatialSmoothReferenceOn q family.flux family.states family.left family.right family.horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ, ∀ n, N ≤ n → ∀ projected values,
        family.InitialProjection n q projected → family.admitted n values →
        ∀ E : ℝ, 0 ≤ E →
        (∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
          ‖values j - projected j‖ ≤ E) →
        ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
          ‖family.advance n values j -
            finiteVolumeCellAverageOn (family.grid n) (fun x => q x (family.dt n)) j‖ ≤
            (1 + L * family.dt n) * E + C * family.dt n * (family.mesh n) ^ p := by
  obtain ⟨p, hp, accuracy⟩ := quality.order
  obtain ⟨L, hL, stability⟩ := quality.stability
  refine ⟨p, L, hp, hL, ?_⟩
  intro q hq
  obtain ⟨C, hC, N, hacc⟩ := accuracy q hq
  refine ⟨C, hC, N, ?_⟩
  intro n hn projected values hproj hvalues E hE herr j hj
  have ha := hacc n hn projected hproj
  exact (norm_sub_le_norm_sub_add_norm_sub (family.advance n values j) (family.advance n projected j)
    (finiteVolumeCellAverageOn (family.grid n) (fun x => q x (family.dt n)) j)).trans
      (add_le_add (stability n values projected hvalues ha.1 E hE herr j hj) (ha.2 j hj))

noncomputable def LineFamily.stabilityRate (family : LineFamily m)
    (quality : family.HasControlledHighResolution) : ℝ := Classical.choose quality.stability

theorem LineFamily.stabilityRate_spec (family : LineFamily m)
    (quality : family.HasControlledHighResolution) :
    0 ≤ family.stabilityRate quality ∧ ∀ n values other, family.admitted n values →
      family.admitted n other → ∀ E : ℝ, 0 ≤ E →
      (∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
        ‖values j - other j‖ ≤ E) →
      ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
        ‖family.advance n values j - family.advance n other j‖ ≤
          (1 + family.stabilityRate quality * family.dt n) * E :=
  Classical.choose_spec quality.stability

end NumStability.DirectionalQualityRepair

namespace NumStability.FiniteDirectionalRepair
open DirectionalQualityRepair
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- Actual line coordinates of finite cells, with explicit supplied ghost
values where the finite physical array has no cell. A lookup can neither
broadcast an unrelated cell nor read a different coordinate line. -/
structure LineCoordinates (D Cell Face Line : Type*) where
  cellLine : D → Cell → Line
  cellIndex : D → Cell → ℤ
  faceLine : D → Face → Line
  faceIndex : D → Face → ℤ
  lookup : D → Line → ℤ → Option Cell
  lookup_cell : ∀ d cell, lookup d (cellLine d cell) (cellIndex d cell) = some cell
  lookup_sound : ∀ d line j cell, lookup d line j = some cell →
    cellLine d cell = line ∧ cellIndex d cell = j
  ghost : D → Line → ℤ → (Fin m → ℝ)

def LineCoordinates.extract (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current : Cell → State) (j : ℤ) : State :=
  match coord.lookup d line j with
  | some cell => current cell
  | none => coord.ghost d line j

theorem LineCoordinates.extract_cell (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (current : Cell → State) (cell : Cell) :
    coord.extract d (coord.cellLine d cell) current (coord.cellIndex d cell) = current cell := by
  simp [LineCoordinates.extract, coord.lookup_cell]

theorem LineCoordinates.extract_local (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current other : Cell → State)
    (h : ∀ cell, coord.cellLine d cell = line → current cell = other cell) :
    coord.extract d line current = coord.extract d line other := by
  funext j
  simp only [LineCoordinates.extract]
  split
  next cell he => exact h cell (coord.lookup_sound d line j cell he).1
  next => rfl

/-- The same physical law, measured areas/volumes and actual coordinate maps
underlie the selected one-dimensional family. No total solver or exact
equal-state numerical flux is required. -/
structure LineRealization (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (family : D → Line → LineFamily m) where
  level : D → Line → ℕ
  duration : D → ℝ
  duration_eq : ∀ d line, duration d = (family d line).dt (level d line)
  area : D → Line → ℝ
  area_pos : ∀ d line, 0 < area d line
  left_line : ∀ d cell, coord.faceLine d (data.leftFace d cell) = coord.cellLine d cell
  right_line : ∀ d cell, coord.faceLine d (data.rightFace d cell) = coord.cellLine d cell
  left_index : ∀ d cell, coord.faceIndex d (data.leftFace d cell) = coord.cellIndex d cell
  right_index : ∀ d cell, coord.faceIndex d (data.rightFace d cell) = coord.cellIndex d cell + 1
  active_cell : ∀ d cell, coord.cellIndex d cell ∈
    Finset.Ico ((family d (coord.cellLine d cell)).activeStart (level d (coord.cellLine d cell)))
      ((family d (coord.cellLine d cell)).activeStart (level d (coord.cellLine d cell)) +
        (family d (coord.cellLine d cell)).activeCount (level d (coord.cellLine d cell)))
  volume_eq : ∀ d cell, data.cellVolume cell = area d (coord.cellLine d cell) *
    ((family d (coord.cellLine d cell)).grid (level d (coord.cellLine d cell))).cellVolume
      (coord.cellIndex d cell)
  physical_flux : ∀ d face state,
    Integrable (fun point => data.normalFlux d face point state) (data.faceMeasure d face) ∧
    (∫ point, data.normalFlux d face point state ∂data.faceMeasure d face) =
      area d (coord.faceLine d face) • (family d (coord.faceLine d face)).flux
        (((family d (coord.faceLine d face)).grid (level d (coord.faceLine d face))).cellLeft
          (coord.faceIndex d face)) state
  states_eq : ∀ d line, (family d line).states = data.admissibleStates d

noncomputable def LineRealization.rule
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family)
    (d : D) (_dt : ℝ) (current : Cell → State) (face : Face) : State :=
  realization.area d (coord.faceLine d face) •
    (family d (coord.faceLine d face)).numericalFlux
      (realization.level d (coord.faceLine d face))
      (coord.extract d (coord.faceLine d face) current) (coord.faceIndex d face)

def LineRealization.Admitted
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family) (d : D) (current : Cell → State) : Prop :=
  ∀ cell, (family d (coord.cellLine d cell)).admitted
    (realization.level d (coord.cellLine d cell)) (coord.extract d (coord.cellLine d cell) current)

/-- The executed finite-cell update is exactly the selected one-dimensional
operator on the extracted current line, including its supplied ghost data. -/
theorem LineRealization.advance_eq
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family) (d : D) (current : Cell → State) (cell : Cell) :
    advance data realization.rule d (realization.duration d) current cell =
      (family d (coord.cellLine d cell)).advance (realization.level d (coord.cellLine d cell))
        (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) := by
  have hactual := advance_mass_balance data realization.rule d (realization.duration d) current cell
  have hline := cellVolume_smul_finiteVolumeCellAverageUpdate
    ((family d (coord.cellLine d cell)).dt (realization.level d (coord.cellLine d cell)))
    (((family d (coord.cellLine d cell)).grid (realization.level d (coord.cellLine d cell))).cellVolume
      (coord.cellIndex d cell))
    ((coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell))
    ((family d (coord.cellLine d cell)).numericalFlux (realization.level d (coord.cellLine d cell))
      (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell + 1) -
     (family d (coord.cellLine d cell)).numericalFlux (realization.level d (coord.cellLine d cell))
      (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell))
    ((((family d (coord.cellLine d cell)).grid (realization.level d (coord.cellLine d cell))).cellVolume_pos
      (coord.cellIndex d cell)).ne')
  have harea := congrArg (fun value => realization.area d (coord.cellLine d cell) • value) hline
  have hm : data.cellVolume cell • advance data realization.rule d (realization.duration d) current cell =
      data.cellVolume cell • (family d (coord.cellLine d cell)).advance
        (realization.level d (coord.cellLine d cell))
        (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) := by
    rw [hactual]
    simpa only [LineRealization.rule, realization.left_line, realization.right_line,
      realization.left_index, realization.right_index, realization.volume_eq d cell,
      realization.duration_eq d (coord.cellLine d cell), LineFamily.advance,
      riemannFiniteVolumeUpdate, finiteVolumeCellAverageUpdate, smul_sub, smul_smul, mul_comm,
      mul_div_assoc, mul_assoc,
      coord.extract_cell d current cell] using harea.symm
  have hc := congrArg (fun value => (data.cellVolume cell)⁻¹ • value) hm
  simpa only [smul_smul, inv_mul_cancel₀ (data.cellVolume_pos cell).ne', one_smul] using hc

theorem LineCoordinates.extract_error_le (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current other : Cell → State) {E : ℝ} (hE : 0 ≤ E)
    (herr : ∀ cell, ‖current cell - other cell‖ ≤ E) (j : ℤ) :
    ‖coord.extract d line current j - coord.extract d line other j‖ ≤ E := by
  simp only [LineCoordinates.extract]
  split
  next cell _he => exact herr cell
  next => simpa using hE

theorem LineRealization.coordinate_stability
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family)
    (quality : ∀ d line, (family d line).HasControlledHighResolution)
    (d : D) (current other : Cell → State)
    (hc : realization.Admitted d current) (ho : realization.Admitted d other)
    {E A : ℝ} (hE : 0 ≤ E) (herr : ∀ cell, ‖current cell - other cell‖ ≤ E)
    (hA : ∀ cell, 1 + (family d (coord.cellLine d cell)).stabilityRate (quality d (coord.cellLine d cell)) *
      realization.duration d ≤ A) :
    ∀ cell, ‖advance data realization.rule d (realization.duration d) current cell -
      advance data realization.rule d (realization.duration d) other cell‖ ≤ A * E := by
  intro cell
  rw [realization.advance_eq, realization.advance_eq]
  have hs := ((family d (coord.cellLine d cell)).stabilityRate_spec
    (quality d (coord.cellLine d cell))).2
    (realization.level d (coord.cellLine d cell)) _ _ (hc cell) (ho cell) E hE
    (fun j _ => coord.extract_error_le d (coord.cellLine d cell) current other hE herr j)
    _ (realization.active_cell d cell)
  rw [← realization.duration_eq] at hs
  exact hs.trans (mul_le_mul_of_nonneg_right (hA cell) hE)

/-- No other coordinate line can affect the selected cell's step. The
supplied ghost values are fixed for this observation. -/
theorem LineRealization.coordinate_local
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family) (d : D) (current other : Cell → State)
    (cell : Cell) (h : ∀ c, coord.cellLine d c = coord.cellLine d cell → current c = other c) :
    advance data realization.rule d (realization.duration d) current cell =
      advance data realization.rule d (realization.duration d) other cell := by
  rw [realization.advance_eq, realization.advance_eq,
    coord.extract_local d (coord.cellLine d cell) current other h]

/-- The quality estimate concerns this executed rule, this current line and
this mesh. Projection and boundary-entry errors remain explicit. -/
theorem LineRealization.smooth_accuracy
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family)
    (quality : ∀ d line, (family d line).HasControlledHighResolution) (d : D) (cell : Cell) :
    ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧ ∀ q : ℝ → ℝ → State,
      SpatialSmoothReferenceOn q (family d (coord.cellLine d cell)).flux
        (family d (coord.cellLine d cell)).states (family d (coord.cellLine d cell)).left
        (family d (coord.cellLine d cell)).right (family d (coord.cellLine d cell)).horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ,
        N ≤ realization.level d (coord.cellLine d cell) →
        ∀ projected current : Cell → State,
          (family d (coord.cellLine d cell)).InitialProjection (realization.level d (coord.cellLine d cell)) q
            (coord.extract d (coord.cellLine d cell) projected) →
          realization.Admitted d current → ∀ E : ℝ, 0 ≤ E →
          (∀ c, ‖current c - projected c‖ ≤ E) →
          ‖advance data realization.rule d (realization.duration d) current cell -
            finiteVolumeCellAverageOn
              ((family d (coord.cellLine d cell)).grid (realization.level d (coord.cellLine d cell)))
              (fun x => q x (realization.duration d)) (coord.cellIndex d cell)‖ ≤
            (1 + L * realization.duration d) * E + C * realization.duration d *
              (family d (coord.cellLine d cell)).mesh (realization.level d (coord.cellLine d cell)) ^ p := by
  obtain ⟨p, L, hp, hL, hacc⟩ :=
    LineFamily.HasControlledHighResolution.perturbed_accuracy (family d (coord.cellLine d cell))
      (quality d (coord.cellLine d cell))
  refine ⟨p, L, hp, hL, ?_⟩
  intro q hq
  obtain ⟨C, hC, N, hac⟩ := hacc q hq
  refine ⟨C, hC, N, ?_⟩
  intro hn projected current hproj hadmit E hE herr
  rw [realization.advance_eq, realization.duration_eq d (coord.cellLine d cell)]
  exact hac _ hn _ _ hproj (hadmit cell) E hE
    (fun j _ => coord.extract_error_le d (coord.cellLine d cell) current projected hE herr j)
    _ (realization.active_cell d cell)

theorem shared_face_cancels
    (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D) (dt : ℝ)
    (current : Cell → State) (left right : Cell)
    (shared : data.rightFace d left = data.leftFace d right) :
    -(dt • rule d dt current (data.rightFace d left)) +
      dt • rule d dt current (data.leftFace d right) = 0 := by
  rw [shared]
  exact neg_add_cancel _

end NumStability.FiniteDirectionalRepair
open scoped BigOperators
namespace NumStability.DirectionalPropagationRepair
variable {Cell E : Type*} [NormedAddCommGroup E]

def execution (step : ℕ → (Cell → E) → Cell → E) (initial : Cell → E) : ℕ → Cell → E
  | 0 => initial
  | n + 1 => step n (execution step initial n)

def errorBudget (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ) : ℕ → ℝ
  | 0 => initialError
  | n + 1 => amplification n * errorBudget amplification localDefect splittingDefect initialError n +
    localDefect n + splittingDefect n

/-- Actual successive numerical states are compared with an independent
reference sequence. The directional consistency defect and reference/splitting
mismatch remain separate; no high order for the composite is inferred. -/
theorem execution_error_le
    (step : ℕ → (Cell → E) → Cell → E) (admitted : ℕ → (Cell → E) → Prop)
    (initial : Cell → E) (reference directionalReference : ℕ → Cell → E)
    (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ)
    (hinitial : ∀ cell, ‖initial cell - reference 0 cell‖ ≤ initialError)
    (hactual : ∀ n, admitted n (execution step initial n))
    (hrefadmit : ∀ n, admitted n (reference n))
    (hstable : ∀ n q other, admitted n q → admitted n other →
      ∀ error : ℝ, (∀ cell, ‖q cell - other cell‖ ≤ error) →
      ∀ cell, ‖step n q cell - step n other cell‖ ≤ amplification n * error)
    (hlocal : ∀ n cell, ‖step n (reference n) cell - directionalReference n cell‖ ≤ localDefect n)
    (hsplit : ∀ n cell, ‖directionalReference n cell - reference (n + 1) cell‖ ≤ splittingDefect n) :
    ∀ n cell, ‖execution step initial n cell - reference n cell‖ ≤
      errorBudget amplification localDefect splittingDefect initialError n := by
  intro n
  induction n with
  | zero => exact hinitial
  | succ n ih =>
    intro cell
    have hs := hstable n (execution step initial n) (reference n) (hactual n) (hrefadmit n)
      (errorBudget amplification localDefect splittingDefect initialError n) ih cell
    calc
      ‖execution step initial (n + 1) cell - reference (n + 1) cell‖ ≤
          ‖step n (execution step initial n) cell - step n (reference n) cell‖ +
            ‖step n (reference n) cell - reference (n + 1) cell‖ :=
        norm_sub_le_norm_sub_add_norm_sub ..
      _ ≤ amplification n * errorBudget amplification localDefect splittingDefect initialError n +
          (localDefect n + splittingDefect n) := add_le_add hs
        ((norm_sub_le_norm_sub_add_norm_sub _ (directionalReference n cell) _).trans
          (add_le_add (hlocal n cell) (hsplit n cell)))
      _ = errorBudget amplification localDefect splittingDefect initialError (n + 1) := by
        simp [errorBudget, add_assoc]

theorem execution_error_le_upto
    (step : ℕ → (Cell → E) → Cell → E) (admitted : ℕ → (Cell → E) → Prop)
    (initial : Cell → E) (reference directionalReference : ℕ → Cell → E)
    (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ) (steps : ℕ)
    (hinitial : ∀ cell, ‖initial cell - reference 0 cell‖ ≤ initialError)
    (hactual : ∀ n < steps, admitted n (execution step initial n))
    (hrefadmit : ∀ n < steps, admitted n (reference n))
    (hstable : ∀ n < steps, ∀ q other, admitted n q → admitted n other →
      ∀ error : ℝ, (∀ cell, ‖q cell - other cell‖ ≤ error) →
      ∀ cell, ‖step n q cell - step n other cell‖ ≤ amplification n * error)
    (hlocal : ∀ n < steps, ∀ cell, ‖step n (reference n) cell - directionalReference n cell‖ ≤ localDefect n)
    (hsplit : ∀ n < steps, ∀ cell, ‖directionalReference n cell - reference (n + 1) cell‖ ≤ splittingDefect n) :
    ∀ n ≤ steps, ∀ cell, ‖execution step initial n cell - reference n cell‖ ≤
      errorBudget amplification localDefect splittingDefect initialError n := by
  intro n
  induction n with
  | zero => intro _; exact hinitial
  | succ n ih =>
    intro hn cell
    have hn' : n < steps := Nat.lt_of_succ_le hn
    have hs := hstable n hn' (execution step initial n) (reference n) (hactual n hn') (hrefadmit n hn')
      (errorBudget amplification localDefect splittingDefect initialError n)
      (ih (Nat.le_of_succ_le hn)) cell
    calc
      ‖execution step initial (n + 1) cell - reference (n + 1) cell‖ ≤
          ‖step n (execution step initial n) cell - step n (reference n) cell‖ +
            ‖step n (reference n) cell - reference (n + 1) cell‖ :=
        norm_sub_le_norm_sub_add_norm_sub ..
      _ ≤ amplification n * errorBudget amplification localDefect splittingDefect initialError n +
          (localDefect n + splittingDefect n) := add_le_add hs
        ((norm_sub_le_norm_sub_add_norm_sub _ (directionalReference n cell) _).trans
          (add_le_add (hlocal n hn' cell) (hsplit n hn' cell)))
      _ = errorBudget amplification localDefect splittingDefect initialError (n + 1) := by
        simp [errorBudget, add_assoc]

theorem errorBudget_uniform_le (amplification localDefect splittingDefect : ℕ → ℝ)
    (initialError A delta : ℝ) (hA : 1 ≤ A) (hE : 0 ≤ initialError) (hd : 0 ≤ delta)
    (ha : ∀ n, 0 ≤ amplification n ∧ amplification n ≤ A)
    (hl : ∀ n, 0 ≤ localDefect n) (hs : ∀ n, 0 ≤ splittingDefect n)
    (hdefect : ∀ n, localDefect n + splittingDefect n ≤ delta) :
    ∀ n, errorBudget amplification localDefect splittingDefect initialError n ≤
      A ^ n * (initialError + n * delta) := by
  have hnonneg : ∀ n, 0 ≤ errorBudget amplification localDefect splittingDefect initialError n := by
    intro n
    induction n with
    | zero => exact hE
    | succ n ih => exact add_nonneg (add_nonneg (mul_nonneg (ha n).1 ih) (hl n)) (hs n)
  intro n
  induction n with
  | zero => simp [errorBudget]
  | succ n ih =>
    have hp : 1 ≤ A ^ (n + 1) := one_le_pow₀ hA
    calc
      errorBudget amplification localDefect splittingDefect initialError (n + 1) ≤
          A * (A ^ n * (initialError + n * delta)) + delta := by
        dsimp [errorBudget]
        linarith [mul_le_mul (ha n).2 ih (hnonneg n) (le_trans (by norm_num) hA), hdefect n]
      _ ≤ A ^ (n + 1) * (initialError + (n + 1 : ℕ) * delta) := by
        rw [pow_succ] at hp ⊢
        push_cast
        nlinarith [mul_le_mul_of_nonneg_right hp hd]

end NumStability.DirectionalPropagationRepair
namespace NumStability.FiniteDirectionalRepair
open DirectionalQualityRepair DirectionalPropagationRepair
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
local notation "V" => Fin m → ℝ

noncomputable def coordinateStep (method : ℕ → LineRealization data coord family)
    (direction : ℕ → D) (n : ℕ) : (Cell → V) → Cell → V :=
  advance data (method n).rule (direction n) ((method n).duration (direction n))

/-- Each step reads the actual state produced by the preceding step. -/
noncomputable def coordinateExecution (method : ℕ → LineRealization data coord family)
    (direction : ℕ → D) (initial : Cell → V) : ℕ → Cell → V :=
  execution (coordinateStep method direction) initial

theorem coordinateExecution_succ (method : ℕ → LineRealization data coord family)
    (direction : ℕ → D) (initial : Cell → V) (n : ℕ) :
    coordinateExecution method direction initial (n + 1) =
      advance data (method n).rule (direction n) ((method n).duration (direction n))
        (coordinateExecution method direction initial n) := rfl

theorem coordinateExecution_ordered (method : ℕ → LineRealization data coord family)
    (direction : ℕ → D) (initial : Cell → V) (n : ℕ) :
    coordinateExecution method direction initial n =
      orderedOperatorSweep ((List.range n).map (coordinateStep method direction)) initial := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [coordinateExecution_succ, List.range_succ, List.map_append, orderedOperatorSweep]
    simp only [List.map_cons, List.map_nil, List.foldl_append, List.foldl_cons, List.foldl_nil]
    change coordinateStep method direction n (coordinateExecution method direction initial n) =
      coordinateStep method direction n
        (orderedOperatorSweep ((List.range n).map (coordinateStep method direction)) initial)
    rw [ih]

/-- Physical reference fields conserve throughout each actual stage. Their
endpoint mismatch across stages remains an explicit splitting/reference
defect. Interface estimates compare numerical inputs with actual integrated
physical boundary fluxes; they do not define the high-resolution class. -/
theorem coordinateExecution_physical_error
    (method : ℕ → LineRealization data coord family) (direction : ℕ → D)
    (quality : ∀ d line, (family d line).HasControlledHighResolution)
    (initial : Cell → V) (physical : ℕ → Point → ℝ → V) (steps : ℕ)
    (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ)
    (leftError rightError : ℕ → Cell → ℝ)
    (href : ∀ n < steps, data.ReferenceOn (direction n) (physical n) 0
      ((method n).duration (direction n)))
    (hinitial : ∀ cell, ‖initial cell - data.cellMean (physical 0) cell 0‖ ≤ initialError)
    (hactual : ∀ n < steps, (method n).Admitted (direction n)
      (coordinateExecution method direction initial n))
    (hrefadmit : ∀ n < steps, (method n).Admitted (direction n)
      (fun cell => data.cellMean (physical n) cell 0))
    (hamplification : ∀ n < steps, ∀ cell,
      1 + (family (direction n) (coord.cellLine (direction n) cell)).stabilityRate
        (quality (direction n) (coord.cellLine (direction n) cell)) *
        (method n).duration (direction n) ≤ amplification n)
    (hleft : ∀ n < steps, ∀ cell,
      ‖(method n).rule (direction n) ((method n).duration (direction n))
          (fun c => data.cellMean (physical n) c 0) (data.leftFace (direction n) cell) -
        oneDimensionalCellAverage (data.faceFlux (direction n) (physical n)
          (data.leftFace (direction n) cell)) 0 ((method n).duration (direction n))‖ ≤ leftError n cell)
    (hright : ∀ n < steps, ∀ cell,
      ‖(method n).rule (direction n) ((method n).duration (direction n))
          (fun c => data.cellMean (physical n) c 0) (data.rightFace (direction n) cell) -
        oneDimensionalCellAverage (data.faceFlux (direction n) (physical n)
          (data.rightFace (direction n) cell)) 0 ((method n).duration (direction n))‖ ≤ rightError n cell)
    (hlocal : ∀ n < steps, ∀ cell, (method n).duration (direction n) / data.cellVolume cell *
      (leftError n cell + rightError n cell) ≤ localDefect n)
    (hsplit : ∀ n < steps, ∀ cell,
      ‖data.cellMean (physical n) cell ((method n).duration (direction n)) -
        data.cellMean (physical (n + 1)) cell 0‖ ≤ splittingDefect n) :
    ∀ n ≤ steps, ∀ cell,
      ‖coordinateExecution method direction initial n cell - data.cellMean (physical n) cell 0‖ ≤
        errorBudget amplification localDefect splittingDefect initialError n := by
  apply execution_error_le_upto (coordinateStep method direction)
    (fun n => (method n).Admitted (direction n)) initial
    (fun n cell => data.cellMean (physical n) cell 0)
    (fun n cell => data.cellMean (physical n) cell ((method n).duration (direction n)))
    amplification localDefect splittingDefect initialError steps hinitial hactual hrefadmit
  · intro n hn q other hq ho E herr
    have hE : 0 ≤ E := (norm_nonneg _).trans (herr (Classical.choice data.cells.cells_nonempty))
    exact (method n).coordinate_stability quality (direction n) q other hq ho hE herr
      (hamplification n hn)
  · intro n hn cell
    have hdt : 0 < (method n).duration (direction n) := by
      rw [(method n).duration_eq (direction n) (coord.cellLine (direction n) cell)]
      exact (family (direction n) (coord.cellLine (direction n) cell)).dt_pos _
    have he := advance_error_le data (method n).rule (direction n)
      (fun c => data.cellMean (physical n) c 0) (physical n) (href n hn) hdt cell
      0 (leftError n cell) (rightError n cell) (by simp)
      (by simpa using hleft n hn cell) (by simpa using hright n hn cell)
    apply le_trans ?_ (hlocal n hn cell)
    simpa [coordinateStep] using he
  · exact hsplit

end NumStability.FiniteDirectionalRepair

open MeasureTheory
open scoped BigOperators
namespace NumStability.DirectionalGeometryRepair
open DirectionalFiniteVolume
variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
variable {FacePoint : Type*} [MeasurableSpace FacePoint]

/-- Identification of actual cell measures and actual shared physical faces.
Equality of restricted measures records null-boundary conventions explicitly;
it is substantially stronger than equality of numerical volume scalars.
The same directional law occurs in the face-flux identification. -/
structure CartesianIdentification
    (data : PhysicalData D (D → ℝ) FacePoint m)
    (axes : D → OneDimensionalFiniteVolumeGrid) (flux : D → (Fin m → ℝ) → Fin m → ℝ) : Prop where
  cell_measure : ∀ cell, data.measure.restrict (data.cells.cellRegion cell) =
    volume.restrict (CartesianGrid.cellBox axes cell)
  face_measurable : ∀ d cell, AEMeasurable (data.facePoint d cell) (data.faceMeasure d cell)
  face_measure : ∀ d cell, Measure.map (data.facePoint d cell) (data.faceMeasure d cell) =
    Measure.map (CartesianGrid.facePoint axes d cell)
      (volume.restrict (CartesianGrid.tangentialFaceBox axes d cell))
  normal_flux : ∀ d cell, ∀ᵐ point ∂data.faceMeasure d cell,
    ∀ value, data.normalFlux d cell point value = flux d value

theorem CartesianIdentification.cellVolume_eq
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (cell : D → ℤ) :
    data.cellVolume cell = CartesianGrid.cellVolume axes cell := by
  have hm := congrArg (fun μ : Measure (D → ℝ) => μ Set.univ) (h.cell_measure cell)
  simp only [Measure.restrict_apply_univ] at hm
  rw [PhysicalData.cellVolume, hm, CartesianGrid.cellBox_volume]

theorem CartesianIdentification.cellMean_eq
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : (D → ℝ) → ℝ → Fin m → ℝ)
    (cell : D → ℤ) (t : ℝ) :
    data.cellMean q cell t = cellVolumeAverage volume (CartesianGrid.cellBox axes cell) (fun x => q x t) := by
  have hm := congrArg (fun μ : Measure (D → ℝ) => μ Set.univ) (h.cell_measure cell)
  simp only [Measure.restrict_apply_univ] at hm
  simp only [PhysicalData.cellMean, cellVolumeAverage, hm, h.cell_measure cell]

theorem cartesian_facePoint_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) : Measurable (CartesianGrid.facePoint axes d cell) := by
  apply measurable_pi_lambda
  intro e
  by_cases he : e = d
  · subst e
    simpa only [CartesianGrid.facePoint_normal] using
      (measurable_const : Measurable (fun _ : {e : D // e ≠ d} → ℝ => (axes d).cellLeft (cell d)))
  · simpa only [CartesianGrid.facePoint_transverse axes d cell _ e he] using
      (measurable_pi_apply (⟨e, he⟩ : {e : D // e ≠ d}))

/-- Actual physical face integrals, with their actual field evaluation, are
transported to the corresponding Cartesian face of the same directional law. -/
theorem CartesianIdentification.faceFlux_eq
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : (D → ℝ) → ℝ → Fin m → ℝ)
    (d : D) (cell : D → ℤ) (t : ℝ)
    (hmeas : AEStronglyMeasurable (fun x => flux d (q x t))
      (Measure.map (CartesianGrid.facePoint axes d cell)
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d cell)))) :
    data.faceFlux d q cell t =
      ∫ point in CartesianGrid.tangentialFaceBox axes d cell,
        flux d (q (CartesianGrid.facePoint axes d cell point) t) := by
  unfold PhysicalData.faceFlux
  calc
    _ = ∫ point, flux d (q (data.facePoint d cell point) t) ∂data.faceMeasure d cell := by
      apply integral_congr_ae
      filter_upwards [h.normal_flux d cell] with point hp
      exact hp _
    _ = ∫ x, flux d (q x t) ∂Measure.map (data.facePoint d cell) (data.faceMeasure d cell) := by
      symm
      exact integral_map (h.face_measurable d cell) (by rw [h.face_measure]; exact hmeas)
    _ = ∫ point in CartesianGrid.tangentialFaceBox axes d cell,
        flux d (q (CartesianGrid.facePoint axes d cell point) t) := by
      rw [h.face_measure]
      exact integral_map (cartesian_facePoint_measurable axes d cell).aemeasurable hmeas

end NumStability.DirectionalGeometryRepair

open MeasureTheory
open scoped BigOperators
namespace NumStability.CartesianProjectionRepair
variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}

theorem integral_cellBox_projection (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (q : ℝ → Fin m → ℝ)
    (hq : IntervalIntegrable q volume ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d))) :
    (∫ x in CartesianGrid.cellBox axes cell, q (x d)) =
      CartesianGrid.faceArea axes d cell •
        ∫ x in (axes d).cellLeft (cell d)..(axes d).cellRight (cell d), q x := by
  let μ : D → Measure ℝ := fun e => volume.restrict
    (Set.Ico ((axes e).cellLeft (cell e)) ((axes e).cellRight (cell e)))
  haveI (e : D) : IsFiniteMeasure (μ e) := ⟨by
    simp [μ, Real.volume_Ico]⟩
  have hμ : volume.restrict (CartesianGrid.cellBox axes cell) = Measure.pi μ := by
    exact Measure.restrict_pi_pi (μ := fun _ : D => (volume : Measure ℝ))
      (fun e => Set.Ico ((axes e).cellLeft (cell e)) ((axes e).cellRight (cell e)))
  have hqμ : Integrable q (μ d) := by
    dsimp [μ]
    rw [Measure.restrict_congr_set (Ico_ae_eq_Ioc (μ := volume))]
    exact (intervalIntegrable_iff_integrableOn_Ioc_of_le ((axes d).cell_nonempty (cell d)).le).mp hq
  have hmap : AEStronglyMeasurable q ((Measure.pi μ).map (Function.eval d)) := by
    rw [Measure.pi_map_eval]
    exact hqμ.aestronglyMeasurable.smul_measure _
  have harea : (∏ e ∈ Finset.univ.erase d, μ e Set.univ).toReal = CartesianGrid.faceArea axes d cell := by
    simp only [ENNReal.toReal_prod, μ, Measure.restrict_apply_univ, Real.volume_Ico]
    unfold CartesianGrid.faceArea
    apply Finset.prod_congr rfl
    intro e _
    exact ENNReal.toReal_ofReal (sub_nonneg.mpr ((axes e).cell_nonempty (cell e)).le)
  calc
    _ = ∫ x, q (x d) ∂Measure.pi μ := by rw [hμ]
    _ = ∫ x, q x ∂(Measure.pi μ).map (Function.eval d) :=
      (integral_map (measurable_pi_apply d).aemeasurable hmap).symm
    _ = (∏ e ∈ Finset.univ.erase d, μ e Set.univ).toReal • ∫ x, q x ∂μ d := by
      rw [Measure.pi_map_eval, integral_smul_measure]
    _ = _ := by
      rw [harea]
      dsimp [μ]
      rw [Measure.restrict_congr_set (Ico_ae_eq_Ioc (μ := volume)),
        ← intervalIntegral.integral_of_le ((axes d).cell_nonempty (cell d)).le]

theorem cellVolumeAverage_projection (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (q : ℝ → Fin m → ℝ)
    (hq : IntervalIntegrable q volume ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d))) :
    cellVolumeAverage volume (CartesianGrid.cellBox axes cell) (fun x => q (x d)) =
      finiteVolumeCellAverageOn (axes d) q (cell d) := by
  rw [cellVolumeAverage, CartesianGrid.cellBox_volume, integral_cellBox_projection axes d cell q hq,
    CartesianGrid.cellVolume_eq_width_mul_area, smul_smul]
  have harea : 0 < CartesianGrid.faceArea axes d cell := by
    exact Finset.prod_pos (fun e _ => (axes e).cellVolume_pos (cell e))
  have hwidth := (axes d).cellVolume_pos (cell d)
  unfold finiteVolumeCellAverageOn oneDimensionalCellAverage
  change (((axes d).cellVolume (cell d) * CartesianGrid.faceArea axes d cell)⁻¹ *
    CartesianGrid.faceArea axes d cell) • _ = ((axes d).cellVolume (cell d))⁻¹ • _
  congr 1
  field_simp

end NumStability.CartesianProjectionRepair

namespace NumStability.DirectionalGeometryRepair
open MeasureTheory DirectionalFiniteVolume
variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
variable {FacePoint : Type*} [MeasurableSpace FacePoint]

theorem CartesianIdentification.cellMean_lift
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : ℝ → ℝ → Fin m → ℝ)
    (d : D) (cell : D → ℤ) (t : ℝ)
    (hq : IntervalIntegrable (fun x => q x t) volume
      ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d))) :
    data.cellMean (fun x τ => q (x d) τ) cell t =
      finiteVolumeCellAverageOn (axes d) (fun x => q x t) (cell d) := by
  rw [h.cellMean_eq]
  exact CartesianProjectionRepair.cellVolumeAverage_projection axes d cell (fun x => q x t) hq

theorem CartesianIdentification.faceFlux_lift
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : ℝ → ℝ → Fin m → ℝ)
    (d : D) (cell : D → ℤ) (t : ℝ) :
    data.faceFlux d (fun x τ => q (x d) τ) cell t =
      CartesianGrid.faceArea axes d cell • flux d (q ((axes d).cellLeft (cell d)) t) := by
  have hnormal : ∀ᵐ x ∂Measure.map (CartesianGrid.facePoint axes d cell)
      (volume.restrict (CartesianGrid.tangentialFaceBox axes d cell)),
      x d = (axes d).cellLeft (cell d) := by
    rw [ae_map_iff (cartesian_facePoint_measurable axes d cell).aemeasurable
      (measurableSet_eq_fun (measurable_pi_apply d) measurable_const)]
    exact Filter.Eventually.of_forall (CartesianGrid.facePoint_normal axes d cell)
  have hm : AEStronglyMeasurable (fun x : D → ℝ => flux d (q (x d) t))
      (Measure.map (CartesianGrid.facePoint axes d cell)
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d cell))) := by
    apply (aestronglyMeasurable_const (b := flux d (q ((axes d).cellLeft (cell d)) t))).congr
    filter_upwards [hnormal] with x hx
    rw [hx]
  rw [h.faceFlux_eq _ d cell t hm]
  simp only [CartesianGrid.facePoint_normal, setIntegral_const,
    measureReal_def, CartesianGrid.tangentialFaceBox_volume]

/-- The actual identified field, cell means and boundary fluxes form the
Cartesian directional reference; no unrelated physical flux is quantified. -/
theorem CartesianIdentification.directional_reference_lift
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : ℝ → ℝ → Fin m → ℝ)
    (d : D) (hq : IsRectangleConservationLawSolution q (flux d)) (s t : ℝ) :
    IsDirectionalReference data.cellVolume
      (data.cellMean (fun x τ => q (x d) τ))
      (data.faceFlux d (fun x τ => q (x d) τ)) d s t := by
  have hvol : data.cellVolume = CartesianGrid.cellVolume axes := funext h.cellVolume_eq
  have havg : data.cellMean (fun x τ => q (x d) τ) =
      fun cell τ => finiteVolumeCellAverageOn (axes d) (fun x => q x τ) (cell d) := by
    funext cell τ
    exact h.cellMean_lift q d cell τ (hq.1 _ _ τ)
  have hface : data.faceFlux d (fun x τ => q (x d) τ) =
      fun cell τ => CartesianGrid.faceArea axes d cell • flux d (q ((axes d).cellLeft (cell d)) τ) := by
    funext cell τ
    exact h.faceFlux_lift q d cell τ
  rw [hvol, havg, hface]
  exact DirectionalFiniteVolume.cartesian_reference axes d (flux d) q hq s t

end NumStability.DirectionalGeometryRepair

namespace NumStability.FiniteCartesianRepair
open MeasureTheory FiniteDirectionalRepair
open scoped BigOperators
variable {D Cell Face FacePoint : Type*} [Fintype D] [DecidableEq D]
variable [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- The actual finite physical partition and actual face measures represent
these Cartesian cells/faces. The directional flux is the same law throughout;
this is not a match of volume scalars with unrelated geometry. -/
structure CartesianIdentification
    (data : PhysicalData D Cell Face (D → ℝ) FacePoint m)
    (axes : D → OneDimensionalFiniteVolumeGrid)
    (cellPosition : Cell → D → ℤ) (facePosition : D → Face → D → ℤ)
    (flux : D → State → State) : Prop where
  left_position : ∀ d cell, facePosition d (data.leftFace d cell) = cellPosition cell
  right_position : ∀ d cell, facePosition d (data.rightFace d cell) =
    Function.update (cellPosition cell) d (cellPosition cell d + 1)
  cell_measure : ∀ cell, data.measure.restrict (data.cells.cellRegion cell) =
    volume.restrict (CartesianGrid.cellBox axes (cellPosition cell))
  face_measurable : ∀ d face, AEMeasurable (data.facePoint d face) (data.faceMeasure d face)
  face_measure : ∀ d face, Measure.map (data.facePoint d face) (data.faceMeasure d face) =
    Measure.map (CartesianGrid.facePoint axes d (facePosition d face))
      (volume.restrict (CartesianGrid.tangentialFaceBox axes d (facePosition d face)))
  normal_flux : ∀ d face, ∀ᵐ point ∂data.faceMeasure d face,
    ∀ value, data.normalFlux d face point value = flux d value

variable {data : PhysicalData D Cell Face (D → ℝ) FacePoint m}
variable {axes : D → OneDimensionalFiniteVolumeGrid}
variable {cellPosition : Cell → D → ℤ} {facePosition : D → Face → D → ℤ}
variable {flux : D → (Fin m → ℝ) → Fin m → ℝ}

theorem CartesianIdentification.cellVolume_eq
    (h : CartesianIdentification data axes cellPosition facePosition flux) (cell : Cell) :
    data.cellVolume cell = CartesianGrid.cellVolume axes (cellPosition cell) := by
  have hm := congrArg (fun μ : Measure (D → ℝ) => μ Set.univ) (h.cell_measure cell)
  simp only [Measure.restrict_apply_univ] at hm
  rw [PhysicalData.cellVolume, hm, CartesianGrid.cellBox_volume]

theorem CartesianIdentification.cellMean_eq
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : (D → ℝ) → ℝ → State) (cell : Cell) (t : ℝ) :
    data.cellMean q cell t =
      cellVolumeAverage volume (CartesianGrid.cellBox axes (cellPosition cell)) (fun x => q x t) := by
  have hm := congrArg (fun μ : Measure (D → ℝ) => μ Set.univ) (h.cell_measure cell)
  simp only [Measure.restrict_apply_univ] at hm
  simp only [PhysicalData.cellMean, cellVolumeAverage, hm]
  rw [h.cell_measure cell]

theorem CartesianIdentification.faceFlux_eq
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : (D → ℝ) → ℝ → State) (d : D) (face : Face) (t : ℝ)
    (hmeas : AEStronglyMeasurable (fun x => flux d (q x t))
      (Measure.map (CartesianGrid.facePoint axes d (facePosition d face))
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d (facePosition d face))))) :
    data.faceFlux d q face t =
      ∫ point in CartesianGrid.tangentialFaceBox axes d (facePosition d face),
        flux d (q (CartesianGrid.facePoint axes d (facePosition d face) point) t) := by
  unfold PhysicalData.faceFlux
  calc
    _ = ∫ point, flux d (q (data.facePoint d face point) t) ∂data.faceMeasure d face := by
      apply integral_congr_ae
      filter_upwards [h.normal_flux d face] with point hp
      exact hp _
    _ = ∫ x, flux d (q x t) ∂Measure.map (data.facePoint d face) (data.faceMeasure d face) := by
      symm
      exact integral_map (h.face_measurable d face) (by rw [h.face_measure]; exact hmeas)
    _ = _ := by
      rw [h.face_measure]
      exact integral_map
        (DirectionalGeometryRepair.cartesian_facePoint_measurable axes d (facePosition d face)).aemeasurable hmeas

theorem CartesianIdentification.cellMean_lift
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : ℝ → ℝ → State) (d : D) (cell : Cell) (t : ℝ)
    (hq : IntervalIntegrable (fun x => q x t) volume
      ((axes d).cellLeft (cellPosition cell d)) ((axes d).cellRight (cellPosition cell d))) :
    data.cellMean (fun x τ => q (x d) τ) cell t =
      finiteVolumeCellAverageOn (axes d) (fun x => q x t) (cellPosition cell d) := by
  rw [h.cellMean_eq]
  exact CartesianProjectionRepair.cellVolumeAverage_projection axes d (cellPosition cell) (fun x => q x t) hq

theorem CartesianIdentification.faceFlux_lift
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : ℝ → ℝ → State) (d : D) (face : Face) (t : ℝ) :
    data.faceFlux d (fun x τ => q (x d) τ) face t =
      CartesianGrid.faceArea axes d (facePosition d face) •
        flux d (q ((axes d).cellLeft (facePosition d face d)) t) := by
  have hnormal : ∀ᵐ x ∂Measure.map (CartesianGrid.facePoint axes d (facePosition d face))
      (volume.restrict (CartesianGrid.tangentialFaceBox axes d (facePosition d face))),
      x d = (axes d).cellLeft (facePosition d face d) := by
    rw [ae_map_iff
      (DirectionalGeometryRepair.cartesian_facePoint_measurable axes d (facePosition d face)).aemeasurable
      (measurableSet_eq_fun (measurable_pi_apply d) measurable_const)]
    exact Filter.Eventually.of_forall (CartesianGrid.facePoint_normal axes d (facePosition d face))
  have hm : AEStronglyMeasurable (fun x : D → ℝ => flux d (q (x d) t))
      (Measure.map (CartesianGrid.facePoint axes d (facePosition d face))
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d (facePosition d face)))) := by
    apply (aestronglyMeasurable_const (b := flux d (q ((axes d).cellLeft (facePosition d face d)) t))).congr
    filter_upwards [hnormal] with x hx
    rw [hx]
  rw [h.faceFlux_eq _ d face t hm]
  simp only [CartesianGrid.facePoint_normal, setIntegral_const,
    measureReal_def, CartesianGrid.tangentialFaceBox_volume]

/-- The same physical cell mass and same two boundary fluxes satisfy every
subinterval balance, by the supplied one-dimensional rectangle PDE law. -/
theorem CartesianIdentification.rectangle_balance_lift
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : ℝ → ℝ → State) (d : D) (hq : IsRectangleConservationLawSolution q (flux d))
    (cell : Cell) (s t : ℝ) :
    data.cellVolume cell • (data.cellMean (fun x τ => q (x d) τ) cell t -
      data.cellMean (fun x τ => q (x d) τ) cell s) =
      ∫ τ in s..t, data.faceFlux d (fun x τ => q (x d) τ) (data.leftFace d cell) τ -
        data.faceFlux d (fun x τ => q (x d) τ) (data.rightFace d cell) τ := by
  have href := DirectionalFiniteVolume.cartesian_reference axes d (flux d) q hq s t
  have hb := href.2 (cellPosition cell)
  rw [h.cellVolume_eq, h.cellMean_lift q d cell t (hq.1 _ _ t),
    h.cellMean_lift q d cell s (hq.1 _ _ s)]
  simpa only [h.faceFlux_lift, h.left_position, h.right_position] using hb

end NumStability.FiniteCartesianRepair
namespace NumStability.DirectionalCompleteRepair
open MeasureTheory DirectionalQualityRepair FiniteDirectionalRepair DirectionalPropagationRepair
open scoped BigOperators
variable {D Cell Face FacePoint Line : Type*} [Fintype D] [DecidableEq D] [Fintype Cell]
variable [MeasurableSpace FacePoint] {m : ℕ}
variable {data : PhysicalData D Cell Face (D → ℝ) FacePoint m}
variable {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
local notation "V" => Fin m → ℝ

/-- One complete conditional construction: supplied high-resolution line
families are the actual constituent operators, physical references conserve
on every time subinterval, finite successive execution retains boundary
transfer and explicit splitting errors, and Cartesian observations concern
the same physical data. Solver existence for arbitrary laws and composite
high temporal order are not asserted. -/
theorem coordinate_highResolution_sourceContract (hm : 0 < m) (hD : 0 < Fintype.card D)

    (method : ℕ → LineRealization data coord family) (direction : ℕ → D)
    (quality : ∀ d line, (family d line).HasControlledHighResolution)
    (initial : Cell → V) (physical : ℕ → (D → ℝ) → ℝ → V) (steps : ℕ)
    (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ)
    (leftError rightError : ℕ → Cell → ℝ)
    (href : ∀ n < steps, data.ReferenceOn (direction n) (physical n) 0
      ((method n).duration (direction n)))
    (hinitial : ∀ cell, ‖initial cell - data.cellMean (physical 0) cell 0‖ ≤ initialError)
    (hactual : ∀ n < steps, (method n).Admitted (direction n)
      (coordinateExecution method direction initial n))
    (hrefadmit : ∀ n < steps, (method n).Admitted (direction n)
      (fun cell => data.cellMean (physical n) cell 0))
    (hamplification : ∀ n < steps, ∀ cell,
      1 + (family (direction n) (coord.cellLine (direction n) cell)).stabilityRate
        (quality (direction n) (coord.cellLine (direction n) cell)) *
        (method n).duration (direction n) ≤ amplification n)
    (hleft : ∀ n < steps, ∀ cell,
      ‖(method n).rule (direction n) ((method n).duration (direction n))
          (fun c => data.cellMean (physical n) c 0) (data.leftFace (direction n) cell) -
        oneDimensionalCellAverage (data.faceFlux (direction n) (physical n)
          (data.leftFace (direction n) cell)) 0 ((method n).duration (direction n))‖ ≤ leftError n cell)
    (hright : ∀ n < steps, ∀ cell,
      ‖(method n).rule (direction n) ((method n).duration (direction n))
          (fun c => data.cellMean (physical n) c 0) (data.rightFace (direction n) cell) -
        oneDimensionalCellAverage (data.faceFlux (direction n) (physical n)
          (data.rightFace (direction n) cell)) 0 ((method n).duration (direction n))‖ ≤ rightError n cell)
    (hlocal : ∀ n < steps, ∀ cell, (method n).duration (direction n) / data.cellVolume cell *
      (leftError n cell + rightError n cell) ≤ localDefect n)
    (hsplit : ∀ n < steps, ∀ cell,
      ‖data.cellMean (physical n) cell ((method n).duration (direction n)) -
        data.cellMean (physical (n + 1)) cell 0‖ ≤ splittingDefect n)
    (hschedule : ∀ d : D, ∃ n < steps, direction n = d) :
    0 < m ∧ 0 < Fintype.card D ∧ (∀ d : D, ∃ n < steps, direction n = d) ∧
    (∀ d line, (family d line).HasControlledHighResolution) ∧
    (∀ d line, ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧ ∀ q : ℝ → ℝ → V,
      SpatialSmoothReferenceOn q (family d line).flux (family d line).states (family d line).left (family d line).right (family d line).horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ, ∀ n, N ≤ n → ∀ projected values,
        (family d line).InitialProjection n q projected → (family d line).admitted n values →
        ∀ E : ℝ, 0 ≤ E →
        (∀ j ∈ Finset.Ico ((family d line).inputStart n) ((family d line).inputStart n + (family d line).inputCount n),
          ‖values j - projected j‖ ≤ E) →
        ∀ j ∈ Finset.Ico ((family d line).activeStart n) ((family d line).activeStart n + (family d line).activeCount n),
          ‖(family d line).advance n values j -
            finiteVolumeCellAverageOn ((family d line).grid n) (fun x => q x ((family d line).dt n)) j‖ ≤
            (1 + L * (family d line).dt n) * E + C * (family d line).dt n * ((family d line).mesh n) ^ p) ∧
    (∀ n ≤ steps, coordinateExecution method direction initial n =
      orderedOperatorSweep ((List.range n).map (coordinateStep method direction)) initial) ∧
    (∀ n < steps, ∀ cell,
      coordinateExecution method direction initial (n + 1) cell =
        (family (direction n) (coord.cellLine (direction n) cell)).advance
          ((method n).level (direction n) (coord.cellLine (direction n) cell))
          (coord.extract (direction n) (coord.cellLine (direction n) cell)
            (coordinateExecution method direction initial n)) (coord.cellIndex (direction n) cell)) ∧
    (∀ n < steps,
      (∑ cell, data.cellVolume cell • coordinateExecution method direction initial (n + 1) cell) =
      (∑ cell, data.cellVolume cell • coordinateExecution method direction initial n cell) -
        (method n).duration (direction n) • ∑ cell,
          ((method n).rule (direction n) ((method n).duration (direction n))
            (coordinateExecution method direction initial n) (data.rightFace (direction n) cell) -
           (method n).rule (direction n) ((method n).duration (direction n))
            (coordinateExecution method direction initial n) (data.leftFace (direction n) cell))) ∧
    (∀ n < steps, ∀ cell current other,
      (∀ c, coord.cellLine (direction n) c = coord.cellLine (direction n) cell → current c = other c) →
      advance data (method n).rule (direction n) ((method n).duration (direction n)) current cell =
        advance data (method n).rule (direction n) ((method n).duration (direction n)) other cell) ∧
    (∀ n < steps, ∀ cell, ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧ ∀ q : ℝ → ℝ → V,
      SpatialSmoothReferenceOn q (family (direction n) (coord.cellLine (direction n) cell)).flux
        (family (direction n) (coord.cellLine (direction n) cell)).states (family (direction n) (coord.cellLine (direction n) cell)).left
        (family (direction n) (coord.cellLine (direction n) cell)).right (family (direction n) (coord.cellLine (direction n) cell)).horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ,
        N ≤ (method n).level (direction n) (coord.cellLine (direction n) cell) →
        ∀ projected current : Cell → V,
          (family (direction n) (coord.cellLine (direction n) cell)).InitialProjection ((method n).level (direction n) (coord.cellLine (direction n) cell)) q
            (coord.extract (direction n) (coord.cellLine (direction n) cell) projected) →
          (method n).Admitted (direction n) current → ∀ E : ℝ, 0 ≤ E →
          (∀ c, ‖current c - projected c‖ ≤ E) →
          ‖advance data (method n).rule (direction n) ((method n).duration (direction n)) current cell -
            finiteVolumeCellAverageOn
              ((family (direction n) (coord.cellLine (direction n) cell)).grid ((method n).level (direction n) (coord.cellLine (direction n) cell)))
              (fun x => q x ((method n).duration (direction n))) (coord.cellIndex (direction n) cell)‖ ≤
            (1 + L * (method n).duration (direction n)) * E + C * (method n).duration (direction n) *
              (family (direction n) (coord.cellLine (direction n) cell)).mesh ((method n).level (direction n) (coord.cellLine (direction n) cell)) ^ p) ∧
    (∀ n < steps, ∀ u ∈ Set.uIcc 0 ((method n).duration (direction n)),
      ∀ v ∈ Set.uIcc 0 ((method n).duration (direction n)), ∀ cell,
      data.cellVolume cell • (data.cellMean (physical n) cell v - data.cellMean (physical n) cell u) =
        ∫ τ in u..v, data.faceFlux (direction n) (physical n) (data.leftFace (direction n) cell) τ -
          data.faceFlux (direction n) (physical n) (data.rightFace (direction n) cell) τ) ∧
    (∀ n ≤ steps, ∀ cell,
      ‖coordinateExecution method direction initial n cell - data.cellMean (physical n) cell 0‖ ≤
        errorBudget amplification localDefect splittingDefect initialError n) ∧
    (∀ (axes : D → OneDimensionalFiniteVolumeGrid) (cellPosition : Cell → D → ℤ)
      (facePosition : D → Face → D → ℤ) (flux : D → V → V),
      FiniteCartesianRepair.CartesianIdentification data axes cellPosition facePosition flux →
      (∀ cell, data.cellVolume cell = CartesianGrid.cellVolume axes (cellPosition cell)) ∧
      (∀ (q : (D → ℝ) → ℝ → V) cell t, data.cellMean q cell t =
        cellVolumeAverage volume (CartesianGrid.cellBox axes (cellPosition cell)) (fun x => q x t)) ∧
      (∀ (q : ℝ → ℝ → V) d face t,
        data.faceFlux d (fun x τ => q (x d) τ) face t =
          CartesianGrid.faceArea axes d (facePosition d face) •
            flux d (q ((axes d).cellLeft (facePosition d face d)) t)) ∧
      (∀ (q : ℝ → ℝ → V) d, IsRectangleConservationLawSolution q (flux d) → ∀ cell s t,
        data.cellVolume cell • (data.cellMean (fun x τ => q (x d) τ) cell t -
          data.cellMean (fun x τ => q (x d) τ) cell s) =
          ∫ τ in s..t, data.faceFlux d (fun x τ => q (x d) τ) (data.leftFace d cell) τ -
            data.faceFlux d (fun x τ => q (x d) τ) (data.rightFace d cell) τ)) := by
  refine ⟨hm, hD, hschedule, quality, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro d line
    exact LineFamily.HasControlledHighResolution.perturbed_accuracy (family d line) (quality d line)
  · intro n _
    exact coordinateExecution_ordered method direction initial n
  · intro n _ cell
    rw [coordinateExecution_succ]
    exact (method n).advance_eq (direction n) _ cell
  · intro n _
    rw [coordinateExecution_succ]
    exact finite_mass_balance data (method n).rule (direction n) _ _
  · intro n _ cell current other h
    exact (method n).coordinate_local (direction n) current other cell h
  · intro n _ cell
    exact (method n).smooth_accuracy quality (direction n) cell
  · intro n hn u hu v hv cell
    exact ((href n hn).2.2.2 u hu v hv).2 cell
  · exact coordinateExecution_physical_error method direction quality initial physical steps
      amplification localDefect splittingDefect initialError leftError rightError href hinitial
      hactual hrefadmit hamplification hleft hright hlocal hsplit
  · intro axes cellPosition facePosition flux cart
    refine ⟨cart.cellVolume_eq, cart.cellMean_eq, cart.faceFlux_lift, ?_⟩
    intro q d hq cell s t
    exact cart.rectangle_balance_lift q d hq cell s t

end NumStability.DirectionalCompleteRepair


namespace NumStability.FiniteCartesianDraft

open MeasureTheory
open FiniteDirectionalRepair
open scoped BigOperators

variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}

theorem axis_right_eq_next_left (axis : OneDimensionalFiniteVolumeGrid) (j : ℤ) :
    axis.cellRight j = axis.cellLeft (j + 1) := by
  simpa using axis.adjacent (j + 1)

theorem axis_left_strictMono (axis : OneDimensionalFiniteVolumeGrid) :
    StrictMono axis.cellLeft := by
  apply strictMono_int_of_lt_succ
  intro j
  rw [← axis_right_eq_next_left]
  exact axis.cell_nonempty j

theorem axis_index_unique (axis : OneDimensionalFiniteVolumeGrid) {a b : ℤ} {x : ℝ}
    (ha : x ∈ Set.Ico (axis.cellLeft a) (axis.cellRight a))
    (hb : x ∈ Set.Ico (axis.cellLeft b) (axis.cellRight b)) : a = b := by
  have cannot {j k : ℤ} (hj : x ∈ Set.Ico (axis.cellLeft j) (axis.cellRight j))
      (hk : x ∈ Set.Ico (axis.cellLeft k) (axis.cellRight k)) (hjk : j < k) : False := by
    have hle : j + 1 ≤ k := by omega
    have h := (axis_left_strictMono axis).monotone hle
    rw [← axis_right_eq_next_left] at h
    exact (not_lt_of_ge (h.trans hk.1)) hj.2
  rcases lt_trichotomy a b with h | h | h
  · exact False.elim (cannot ha hb h)
  · exact h
  · exact False.elim (cannot hb ha h)

omit [Fintype D] [DecidableEq D] in
theorem cellBox_disjoint (axes : D → OneDimensionalFiniteVolumeGrid)
    {a b : D → ℤ} (hab : a ≠ b) :
    Disjoint (CartesianGrid.cellBox axes a) (CartesianGrid.cellBox axes b) := by
  apply Set.disjoint_left.mpr
  intro x hx hy
  apply hab
  funext d
  exact axis_index_unique (axes d) (hx d (Set.mem_univ d)) (hy d (Set.mem_univ d))

omit [DecidableEq D] in
theorem cellBox_measurable (axes : D → OneDimensionalFiniteVolumeGrid) (cell : D → ℤ) :
    MeasurableSet (CartesianGrid.cellBox axes cell) :=
  MeasurableSet.univ_pi fun _ => measurableSet_Ico

omit [DecidableEq D] in
theorem tangentialFaceBox_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) : MeasurableSet (CartesianGrid.tangentialFaceBox axes d face) :=
  MeasurableSet.univ_pi fun _ => measurableSet_Ico

def cells (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty) :
    FiniteVolumeCellPartition ↥active (D → ℝ) where
  domain := ⋃ cell : ↥active, CartesianGrid.cellBox axes cell.val
  cellRegion := fun cell => CartesianGrid.cellBox axes cell.val
  cells_nonempty := by
    obtain ⟨cell, hcell⟩ := hne
    exact ⟨⟨cell, hcell⟩⟩
  measurable_cell := fun cell => cellBox_measurable axes cell.val
  disjoint_cells := by
    intro a b hab
    exact cellBox_disjoint axes (fun h => hab (Subtype.ext h))
  covers_domain := by intro point; simp

omit [Fintype D] in
theorem facePoint_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) : Measurable (CartesianGrid.facePoint axes d face) := by
  apply measurable_pi_lambda
  intro e
  by_cases he : e = d
  · subst e
    simpa only [CartesianGrid.facePoint_normal] using
      (measurable_const : Measurable (fun _ : {e : D // e ≠ d} → ℝ => (axes d).cellLeft (face d)))
  · simpa only [CartesianGrid.facePoint_transverse axes d face _ e he] using
      (measurable_pi_apply (⟨e, he⟩ : {e : D // e ≠ d}))

noncomputable def faceMeasure (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) : Measure (D → ℝ) :=
  Measure.map (CartesianGrid.facePoint axes d face)
    (volume.restrict (CartesianGrid.tangentialFaceBox axes d face))

omit [Fintype D] in
theorem left_face_in_closure (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (point : {e : D // e ≠ d} → ℝ)
    (hp : point ∈ CartesianGrid.tangentialFaceBox axes d cell) :
    CartesianGrid.facePoint axes d cell point ∈ closure (CartesianGrid.cellBox axes cell) := by
  apply mem_closure_pi.mpr
  intro e _
  rw [closure_Ico ((axes e).cell_nonempty (cell e)).ne]
  by_cases he : e = d
  · subst e
    rw [CartesianGrid.facePoint_normal]
    exact ⟨le_rfl, (axes d).cell_nonempty (cell d) |>.le⟩
  · rw [CartesianGrid.facePoint_transverse axes d cell point e he]
    exact ⟨(hp ⟨e, he⟩ (by trivial)).1, (hp ⟨e, he⟩ (by trivial)).2.le⟩

omit [Fintype D] in
theorem right_face_in_closure (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (point : {e : D // e ≠ d} → ℝ)
    (hp : point ∈ CartesianGrid.tangentialFaceBox axes d
      (Function.update cell d (cell d + 1))) :
    CartesianGrid.facePoint axes d (Function.update cell d (cell d + 1)) point ∈
      closure (CartesianGrid.cellBox axes cell) := by
  rw [CartesianGrid.tangentialFaceBox_update] at hp
  apply mem_closure_pi.mpr
  intro e _
  rw [closure_Ico ((axes e).cell_nonempty (cell e)).ne]
  by_cases he : e = d
  · subst e
    rw [CartesianGrid.facePoint_normal, ← CartesianGrid.shared_face_position]
    exact ⟨(axes d).cell_nonempty (cell d) |>.le, le_rfl⟩
  · rw [CartesianGrid.facePoint_transverse axes d _ point e he]
    exact ⟨(hp ⟨e, he⟩ (by trivial)).1, (hp ⟨e, he⟩ (by trivial)).2.le⟩

theorem left_face_ae_incidence (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) :
    ∀ᵐ point ∂faceMeasure axes d cell, point ∈ closure (CartesianGrid.cellBox axes cell) := by
  apply (ae_map_iff (facePoint_measurable axes d cell).aemeasurable
    isClosed_closure.measurableSet).2
  filter_upwards [ae_restrict_mem (tangentialFaceBox_measurable axes d cell)] with point hp
  exact left_face_in_closure axes d cell point hp

theorem right_face_ae_incidence (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) :
    ∀ᵐ point ∂faceMeasure axes d (Function.update cell d (cell d + 1)),
      point ∈ closure (CartesianGrid.cellBox axes cell) := by
  apply (ae_map_iff (facePoint_measurable axes d _).aemeasurable
    isClosed_closure.measurableSet).2
  filter_upwards [ae_restrict_mem (tangentialFaceBox_measurable axes d _)] with point hp
  exact right_face_in_closure axes d cell point hp

noncomputable def data (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) :
    PhysicalData D ↥active (D → ℤ) (D → ℝ) (D → ℝ) m where
  cells := cells axes active hne
  measure := volume
  positive := by
    intro cell
    have h := CartesianGrid.cellVolume_pos axes cell.val
    rw [← CartesianGrid.cellBox_volume] at h
    exact (ENNReal.toReal_pos_iff.mp h).1.ne'
  finite := by
    intro cell
    have h := CartesianGrid.cellVolume_pos axes cell.val
    rw [← CartesianGrid.cellBox_volume] at h
    exact (ENNReal.toReal_pos_iff.mp h).2.ne
  leftFace := fun _ cell => cell.val
  rightFace := fun d cell => Function.update cell.val d (cell.val d + 1)
  faceMeasure := faceMeasure axes
  facePoint := fun _ _ point => point
  left_incidence := fun d cell => left_face_ae_incidence axes d cell.val
  right_incidence := fun d cell => right_face_ae_incidence axes d cell.val
  admissibleStates := states
  normalFlux := fun d _ _ => flux d
  hyperbolic := fun d _ _ => hflux d

theorem data_cell_measure (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (cell : ↥active) :
    (data axes active hne states flux hflux).measure.restrict
      ((data axes active hne states flux hflux).cells.cellRegion cell) =
      volume.restrict (CartesianGrid.cellBox axes cell.val) := rfl

theorem data_cellVolume (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (cell : ↥active) :
    (data axes active hne states flux hflux).cellVolume cell =
      CartesianGrid.cellVolume axes cell.val := CartesianGrid.cellBox_volume axes cell.val

theorem data_face_measure (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (face : D → ℤ) :
    Measure.map ((data axes active hne states flux hflux).facePoint d face)
      ((data axes active hne states flux hflux).faceMeasure d face) =
      Measure.map (CartesianGrid.facePoint axes d face)
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d face)) := by
  exact Measure.map_id

theorem data_shared_face (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d))
    (d : D) (left right : ↥active)
    (hadjacent : right.val = Function.update left.val d (left.val d + 1)) :
    (data axes active hne states flux hflux).rightFace d left =
      (data axes active hne states flux hflux).leftFace d right := hadjacent.symm

theorem data_left_position (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (cell : ↥active) :
    (data axes active hne states flux hflux).leftFace d cell = cell.val := rfl

theorem data_right_position (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (cell : ↥active) :
    (data axes active hne states flux hflux).rightFace d cell =
      Function.update cell.val d (cell.val d + 1) := rfl

theorem data_face_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (face : D → ℤ) :
    AEMeasurable ((data axes active hne states flux hflux).facePoint d face)
      ((data axes active hne states flux hflux).faceMeasure d face) := measurable_id.aemeasurable

theorem data_normal_flux (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (face : D → ℤ) :
    ∀ᵐ point ∂(data axes active hne states flux hflux).faceMeasure d face,
      ∀ value, (data axes active hne states flux hflux).normalFlux d face point value = flux d value := by
  exact Filter.Eventually.of_forall fun _ _ => rfl

theorem faceMeasure_area (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) :
    (faceMeasure axes d face Set.univ).toReal = CartesianGrid.faceArea axes d face := by
  rw [faceMeasure, Measure.map_apply_of_aemeasurable
    (facePoint_measurable axes d face).aemeasurable MeasurableSet.univ]
  simpa using CartesianGrid.tangentialFaceBox_volume axes d face

end NumStability.FiniteCartesianDraft





/-!
Explicit CFL-one transport witness. The integer array is an explicit extension
outside the finite active window, including the entering left boundary value.
Window variation is compared with the shifted input window. Exactness here is
specific to unit-speed transport and time step equal to cell width; it is not
a general high-order claim about upwind methods or nonlinear shock formation.
-/

open MeasureTheory Filter
open scoped BigOperators Topology
open NumStability

namespace CFL1RefinementWitness

def grid (h : ℝ) (hh : 0 < h) : OneDimensionalFiniteVolumeGrid where
  cellLeft j := ((j : ℝ) - 1) * h
  cellRight j := (j : ℝ) * h
  cell_nonempty j := by nlinarith
  adjacent j := by simp

theorem grid_volume (h : ℝ) (hh : 0 < h) (j : ℤ) :
    (grid h hh).cellVolume j = h := by
  simp only [OneDimensionalFiniteVolumeGrid.cellVolume, grid]
  ring

noncomputable def advance {ι : Type*} (h : ℝ) (hh : 0 < h)
    (Q : ℤ → ι → ℝ) : ℤ → ι → ℝ :=
  riemannFiniteVolumeUpdate (grid h hh) h Q (fun j => Q (j - 1))

theorem advance_eq_shift {ι : Type*} (h : ℝ) (hh : 0 < h)
    (Q : ℤ → ι → ℝ) (j : ℤ) : advance h hh Q j = Q (j - 1) := by
  simp only [advance, riemannFiniteVolumeUpdate, grid_volume, div_self (ne_of_gt hh),
    add_sub_cancel_right, one_smul]
  abel

noncomputable def averaged {ι : Type*} [Fintype ι] (h : ℝ) (hh : 0 < h)
    (φ : ℝ → ι → ℝ) (t : ℝ) (j : ℤ) : ι → ℝ :=
  finiteVolumeCellAverageOn (grid h hh) (fun x => φ (x - t)) j

theorem averaged_eq_shift {ι : Type*} [Fintype ι] (h : ℝ) (hh : 0 < h)
    (φ : ℝ → ι → ℝ) (t : ℝ) (j : ℤ) :
    averaged h hh φ (t + h) j = averaged h hh φ t (j - 1) := by
  simp only [averaged, finiteVolumeCellAverageOn, oneDimensionalCellAverage,
    grid, Int.cast_sub, Int.cast_one, intervalIntegral.integral_comp_sub_right]
  congr 2 <;> ring

theorem advance_averaged_exact {ι : Type*} [Fintype ι] (h : ℝ) (hh : 0 < h)
    (φ : ℝ → ι → ℝ) (t : ℝ) (j : ℤ) :
    advance h hh (averaged h hh φ t) j = averaged h hh φ (t + h) j := by
  rw [advance_eq_shift, averaged_eq_shift]

theorem averaged_is_cell_average {ι : Type*} [Fintype ι]
    (h : ℝ) (hh : 0 < h) (φ : ℝ → ι → ℝ)
    (hφ : ∀ a b, IntervalIntegrable φ volume a b) (t : ℝ) (j : ℤ) :
    IsOneDimensionalCellAverage (fun x => φ (x - t))
      ((grid h hh).cellLeft j) ((grid h hh).cellRight j)
      (averaged h hh φ t j) := by
  apply finiteVolumeCellAverageOn_spec
  intro i
  simpa only [travelingWave, one_mul] using
    travelingWave_intervalIntegrable_space φ hφ 1
      ((grid h hh).cellLeft i) ((grid h hh).cellRight i) t

theorem translated_is_conserved {ι : Type*} [Fintype ι]
    (φ : ℝ → ι → ℝ) (hφ : ∀ a b, IntervalIntegrable φ volume a b) :
    IsRectangleConservationLawSolution (fun x t => φ (x - t)) id := by
  simpa only [IsRectangleConservationLawSolution, travelingWave, one_mul, one_smul, id_eq] using
    travelingWave_isRectangleConservationLawSolution φ hφ 1

/-- Every locally integrable physical translated profile has zero defect;
the constant zero is uniform in mesh, time, cell and profile. -/
theorem physical_exactness {ι : Type*} [Fintype ι]
    (φ : ℝ → ι → ℝ) (hφ : ∀ a b, IntervalIntegrable φ volume a b)
    (h : ℝ) (hh : 0 < h) (t : ℝ) (j : ℤ) (p : ℝ) (_hp : 1 < p) :
    IsRectangleConservationLawSolution (fun x t => φ (x - t)) id ∧
    IsOneDimensionalCellAverage (fun x => φ (x - t))
      ((grid h hh).cellLeft j) ((grid h hh).cellRight j) (averaged h hh φ t j) ∧
    ‖advance h hh (averaged h hh φ t) j - averaged h hh φ (t + h) j‖ ≤
      (0 : ℝ) * h ^ p := by
  refine ⟨translated_is_conserved φ hφ, averaged_is_cell_average h hh φ hφ t j, ?_⟩
  simp only [advance_averaged_exact, sub_self, norm_zero, zero_mul, le_refl]

def window {E : Type*} (Q : ℤ → E) (start : ℤ) (N : ℕ) : Fin N → E :=
  fun i => Q (start + (i.val : ℤ))

theorem advance_window {ι : Type*} (h : ℝ) (hh : 0 < h)
    (Q : ℤ → ι → ℝ) (start : ℤ) (N : ℕ) :
    window (advance h hh Q) start N = window Q (start - 1) N := by
  funext i
  simp only [window, advance_eq_shift]
  congr 1; ring

/-- Sum of internal adjacent jumps in a finite window, with arbitrary start. -/
noncomputable def windowTV {ι : Type*} [Fintype ι]
    (Q : ℤ → ι → ℝ) (start : ℤ) (N : ℕ) : ℝ :=
  ∑ i ∈ Finset.range (N - 1),
    ‖Q (start + (i : ℤ) + 1) - Q (start + (i : ℤ))‖

theorem advance_windowTV {ι : Type*} [Fintype ι] (h : ℝ) (hh : 0 < h)
    (Q : ℤ → ι → ℝ) (start : ℤ) (N : ℕ) :
    windowTV (advance h hh Q) start N = windowTV Q (start - 1) N := by
  unfold windowTV
  apply Finset.sum_congr rfl
  intro i _hi
  simp only [advance_eq_shift]
  have hleft : start + (i : ℤ) + 1 - 1 = start - 1 + (i : ℤ) + 1 := by ring
  have hright : start + (i : ℤ) - 1 = start - 1 + (i : ℤ) := by ring
  rw [hleft, hright]

theorem advance_no_overshoot (h : ℝ) (hh : 0 < h)
    (Q : ℤ → Fin 1 → ℝ) (start : ℤ) (N : ℕ) (lower upper : ℝ)
    (hbound : ∀ i : Fin N, lower ≤ window Q (start - 1) N i 0 ∧
      window Q (start - 1) N i 0 ≤ upper) :
    ∀ i : Fin N, lower ≤ window (advance h hh Q) start N i 0 ∧
      window (advance h hh Q) start N i 0 ≤ upper := by
  rw [advance_window]
  exact hbound

theorem advance_preserves_monotone (h : ℝ) (hh : 0 < h)
    (Q : ℤ → Fin 1 → ℝ) (start : ℤ) (N : ℕ)
    (hmono : Monotone (fun i : Fin N => window Q (start - 1) N i 0)) :
    Monotone (fun i : Fin N => window (advance h hh Q) start N i 0) := by
  rw [advance_window]
  exact hmono

noncomputable def meshSize (n : ℕ) : ℝ := 1 / ((n : ℝ) + 1)

theorem meshSize_pos (n : ℕ) : 0 < meshSize n := by unfold meshSize; positivity

theorem meshSize_tendsto_zero : Tendsto meshSize atTop (𝓝 0) :=
  tendsto_one_div_add_atTop_nhds_zero_nat

/-- The numerical flux uses exactly the left adjacent value. -/
theorem flux_locality {ι : Type*} (Q R : ℤ → ι → ℝ) (face : ℤ)
    (h : Q (face - 1) = R (face - 1)) :
    (fun j => Q (j - 1)) face = (fun j => R (j - 1)) face := h

/-- Only the shifted finite input window is needed for the active output.
Thus a ghost extension agreeing there gives exactly the same finite output. -/
theorem advance_extension_independent {ι : Type*} (h : ℝ) (hh : 0 < h)
    (Q R : ℤ → ι → ℝ) (start : ℤ) (N : ℕ)
    (heq : window Q (start - 1) N = window R (start - 1) N) :
    window (advance h hh Q) start N = window (advance h hh R) start N := by
  rw [advance_window, advance_window, heq]

/-- A single constant works at every refinement, time, cell and finite window.
The physical profile is arbitrary subject to local interval integrability;
the conclusion therefore applies in particular to every smooth such profile. -/
theorem refinement_accuracy {ι : Type*} [Fintype ι]
    (φ : ℝ → ι → ℝ) (hφ : ∀ a b, IntervalIntegrable φ volume a b)
    (p : ℝ) (_hp : 1 < p) :
    IsRectangleConservationLawSolution (fun x t => φ (x - t)) id ∧
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (n : ℕ) (t : ℝ) (start : ℤ) (N : ℕ) (i : Fin N),
      ‖window (advance (meshSize n) (meshSize_pos n)
          (averaged (meshSize n) (meshSize_pos n) φ t)) start N i -
        window (averaged (meshSize n) (meshSize_pos n) φ (t + meshSize n)) start N i‖
        ≤ C * meshSize n * (meshSize n) ^ p := by
  refine ⟨translated_is_conserved φ hφ, 0, le_rfl, ?_⟩
  intro n t start N i
  simp only [window, advance_averaged_exact, sub_self, norm_zero, zero_mul, le_refl]

/-- Zero growth and zero defect in a uniform quantitative variation bound.
The shifted input window includes entering boundary variation explicitly. -/
theorem refinement_oscillation {ι : Type*} [Fintype ι]
    (Q : ℤ → ι → ℝ) (n : ℕ) (start : ℤ) (N : ℕ) :
    windowTV (advance (meshSize n) (meshSize_pos n) Q) start N ≤
      (1 + (0 : ℝ) * meshSize n) * windowTV Q (start - 1) N + 0 := by
  simp only [advance_windowTV, zero_mul, add_zero, one_mul, le_refl]

def smoothProfile (x : ℝ) : Fin 1 → ℝ := fun _ => x

theorem smoothProfile_smooth : ContDiff ℝ ⊤ smoothProfile := by
  exact contDiff_pi.mpr (fun _ => contDiff_id)

theorem smoothProfile_integrable (a b : ℝ) :
    IntervalIntegrable smoothProfile volume a b :=
  smoothProfile_smooth.continuous.intervalIntegrable a b

theorem smoothProfile_nonconstant : smoothProfile 0 ≠ smoothProfile 1 := by
  intro h
  have h0 := congrFun h 0
  norm_num [smoothProfile] at h0

noncomputable def stepProfile : ℝ → Fin 1 → ℝ := riemannData 1 0 0

theorem stepProfile_integrable (a b : ℝ) :
    IntervalIntegrable stepProfile volume a b := riemannData_intervalIntegrable _ _ _ a b

theorem stepProfile_discontinuous : ¬ ContinuousAt stepProfile 0 := by
  apply (riemannData_isRiemannData (1 : Fin 1 → ℝ) 0 0).not_continuousAt_zero
  intro h
  have h0 := congrFun h 0
  norm_num at h0

/-- The smooth nonconstant profile actually meets the family contract. -/
theorem smooth_refinement (p : ℝ) (hp : 1 < p) :
    ContDiff ℝ ⊤ smoothProfile ∧ smoothProfile 0 ≠ smoothProfile 1 ∧
    IsRectangleConservationLawSolution (fun x t => smoothProfile (x - t)) id ∧
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (n : ℕ) (t : ℝ) (start : ℤ) (N : ℕ) (i : Fin N),
      ‖window (advance (meshSize n) (meshSize_pos n)
          (averaged (meshSize n) (meshSize_pos n) smoothProfile t)) start N i -
        window (averaged (meshSize n) (meshSize_pos n) smoothProfile (t + meshSize n))
          start N i‖ ≤ C * meshSize n * (meshSize n) ^ p :=
  ⟨smoothProfile_smooth, smoothProfile_nonconstant,
    refinement_accuracy smoothProfile smoothProfile_integrable p hp⟩

/-- A discontinuous transport profile also meets the same physical exactness
and refinement bound; this is a transported jump, not a nonlinear shock. -/
theorem step_refinement (p : ℝ) (hp : 1 < p) :
    (¬ ContinuousAt stepProfile 0) ∧
    IsRectangleConservationLawSolution (fun x t => stepProfile (x - t)) id ∧
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (n : ℕ) (t : ℝ) (start : ℤ) (N : ℕ) (i : Fin N),
      ‖window (advance (meshSize n) (meshSize_pos n)
          (averaged (meshSize n) (meshSize_pos n) stepProfile t)) start N i -
        window (averaged (meshSize n) (meshSize_pos n) stepProfile (t + meshSize n))
          start N i‖ ≤ C * meshSize n * (meshSize n) ^ p :=
  ⟨stepProfile_discontinuous, refinement_accuracy stepProfile stepProfile_integrable p hp⟩

end CFL1RefinementWitness

open MeasureTheory Filter Set
open scoped Topology Interval
open NumStability
namespace DimLocalCharacteristicWitness
variable {m : ℕ}
local notation "State" => Fin m → ℝ

/-- A genuine local conservation reference, on all space/time subrectangles
of the supplied physical line problem. Values outside this box are unused. -/
def RectangleReferenceOn (q : ℝ → ℝ → State) (flux : State → State)
    (left right horizon : ℝ) : Prop :=
  (∀ t ∈ Set.Icc 0 horizon, IntervalIntegrable (fun x => q x t) volume left right) ∧
  (∀ x ∈ Set.Icc left right, IntervalIntegrable (fun t => flux (q x t)) volume 0 horizon) ∧
  ∀ a ∈ Set.Icc left right, ∀ b ∈ Set.Icc left right,
    ∀ s ∈ Set.Icc 0 horizon, ∀ t ∈ Set.Icc 0 horizon,
      (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
        ∫ τ in s..t, flux (q a τ) - flux (q b τ)

/-- Smoothness is a fixed mathematical condition, never a caller-chosen
eligibility predicate. The same local conservation law and state domain apply. -/
def SmoothReferenceOn (q : ℝ → ℝ → State) (flux : State → State)
    (states : Set State) (left right horizon : ℝ) : Prop :=
  ContDiffOn ℝ ⊤ (Function.uncurry q) (Set.Icc left right ×ˢ Set.Icc 0 horizon) ∧
  RectangleReferenceOn q flux left right horizon ∧
  ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon, q x t ∈ states

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

theorem local_integral_hasDerivAt
    (F F' : ℝ → ℝ → E) {a b c d t : ℝ} (hab : a ≤ b) (ht : t ∈ Ioo c d)
    (hc : ContinuousOn (Function.uncurry F) (Icc c d ×ˢ Icc a b))
    (hc' : ContinuousOn (Function.uncurry F') (Icc c d ×ˢ Icc a b))
    (hd : ∀ r ∈ Ioo c d, ∀ x ∈ Icc a b, HasDerivAt (fun s => F s x) (F' r x) r) :
    HasDerivAt (fun s => ∫ x in a..b, F s x) (∫ x in a..b, F' t x) t := by
  have hslice (r : ℝ) (hr : r ∈ Icc c d) : ContinuousOn (F r) (Icc a b) :=
    hc.comp (continuous_const.prodMk continuous_id).continuousOn (fun _ hx => ⟨hr, hx⟩)
  have hslice' (r : ℝ) (hr : r ∈ Icc c d) : ContinuousOn (F' r) (Icc a b) :=
    hc'.comp (continuous_const.prodMk continuous_id).continuousOn (fun _ hx => ⟨hr, hx⟩)
  obtain ⟨C, hC⟩ := (isCompact_Icc.prod isCompact_Icc).exists_bound_of_continuousOn hc'
  have hu : Ι a b ⊆ Icc a b := by rw [uIoc_of_le hab]; exact Ioc_subset_Icc_self
  apply (intervalIntegral.hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (s := Ioo c d) (bound := fun _ => C) (Ioo_mem_nhds ht.1 ht.2) ?_
    ((hslice t (Ioo_subset_Icc_self ht)).intervalIntegrable_of_Icc hab)
    (((hslice' t (Ioo_subset_Icc_self ht)).mono hu).aestronglyMeasurable measurableSet_uIoc)
    ?_ intervalIntegrable_const ?_).2
  · filter_upwards [Ioo_mem_nhds ht.1 ht.2] with r hr
    exact ((hslice r (Ioo_subset_Icc_self hr)).mono hu).aestronglyMeasurable measurableSet_uIoc
  · exact ae_of_all _ (fun x hx r hr => hC (r, x) ⟨Ioo_subset_Icc_self hr, hu hx⟩)
  · exact ae_of_all _ (fun x hx r hr => hd r hr x (hu hx))

theorem eq_zero_of_local_integrals [CompleteSpace E] (g : ℝ → E) {L R x : ℝ}
    (hc : ContinuousOn g (Ioo L R)) (hx : x ∈ Ioo L R)
    (hi : ∀ a ∈ Ioo L R, ∀ b ∈ Ioo L R, ∫ y in a..b, g y = 0) : g x = 0 := by
  have hd := intervalIntegral.integral_hasDerivAt_right
    (IntervalIntegrable.refl (f := g) (a := x))
    (ContinuousOn.stronglyMeasurableAtFilter isOpen_Ioo hc x hx)
    (hc.continuousAt (Ioo_mem_nhds hx.1 hx.2))
  have hz : HasDerivAt (fun _ : ℝ => (0 : E)) (g x) x :=
    hd.congr_of_eventuallyEq (by
      filter_upwards [Ioo_mem_nhds hx.1 hx.2] with b hb
      exact (hi x hx b hb).symm)
  exact hz.unique (hasDerivAt_const x 0)

noncomputable def qt (q : ℝ → ℝ → E) (x t : ℝ) : E :=
  fderiv ℝ (Function.uncurry q) (x, t) (0, 1)

noncomputable def qx (q : ℝ → ℝ → E) (x t : ℝ) : E :=
  fderiv ℝ (Function.uncurry q) (x, t) (1, 0)

theorem partial_time {q : ℝ → ℝ → E} {x t : ℝ}
    (hd : DifferentiableAt ℝ (Function.uncurry q) (x, t)) :
    HasDerivAt (q x) (qt q x t) t := by
  simpa only [Function.comp_def, Function.uncurry_apply_pair, qt] using
    hd.hasFDerivAt.comp_hasDerivAt t
      ((hasDerivAt_const t x).prodMk (hasDerivAt_id t))

theorem partial_space {q : ℝ → ℝ → E} {x t : ℝ}
    (hd : DifferentiableAt ℝ (Function.uncurry q) (x, t)) :
    HasDerivAt (fun y => q y t) (qx q x t) x := by
  simpa only [Function.comp_def, Function.uncurry_apply_pair, qx] using
    hd.hasFDerivAt.comp_hasDerivAt x
      ((hasDerivAt_id x).prodMk (hasDerivAt_const x t))

theorem smooth_reference_interior {q : ℝ → ℝ → State} {states : Set State}
    {L R H : ℝ} (hq : SmoothReferenceOn q id states L R H) :
    ContDiffOn ℝ ⊤ (Function.uncurry q) (Ioo L R ×ˢ Ioo 0 H) :=
  hq.1.mono (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)

theorem interior_partials_continuous {q : ℝ → ℝ → E} {L R H : ℝ}
    (hq : ContDiffOn ℝ ⊤ (Function.uncurry q) (Ioo L R ×ˢ Ioo 0 H)) :
    ContinuousOn (Function.uncurry (qt q)) (Ioo L R ×ˢ Ioo 0 H) ∧
    ContinuousOn (Function.uncurry (qx q)) (Ioo L R ×ˢ Ioo 0 H) := by
  have hc := hq.continuousOn_fderiv_of_isOpen (isOpen_Ioo.prod isOpen_Ioo) (by simp)
  exact ⟨hc.clm_apply continuousOn_const, hc.clm_apply continuousOn_const⟩

theorem interior_differentiableAt {q : ℝ → ℝ → E} {L R H x t : ℝ}
    (hq : ContDiffOn ℝ ⊤ (Function.uncurry q) (Ioo L R ×ˢ Ioo 0 H))
    (hx : x ∈ Ioo L R) (ht : t ∈ Ioo 0 H) :
    DifferentiableAt ℝ (Function.uncurry q) (x, t) :=
  (hq.differentiableOn (by simp) (x,t) ⟨hx, ht⟩).differentiableAt
    (prod_mem_nhds (Ioo_mem_nhds hx.1 hx.2) (Ioo_mem_nhds ht.1 ht.2))

theorem interior_mass_derivative {q : ℝ → ℝ → E} {L R H a b t : ℝ}
    (hq : ContDiffOn ℝ ⊤ (Function.uncurry q) (Ioo L R ×ˢ Ioo 0 H))
    (ha : a ∈ Ioo L R) (hb : b ∈ Ioo L R) (hab : a ≤ b) (ht : t ∈ Ioo 0 H) :
    HasDerivAt (fun r => ∫ x in a..b, q x r) (∫ x in a..b, qt q x t) t := by
  have htime : Icc (t / 2) ((t + H) / 2) ⊆ Ioo 0 H := by
    intro r hr; constructor <;> linarith [hr.1, hr.2, ht.1, ht.2]
  have hspace : Icc a b ⊆ Ioo L R := Icc_subset_Ioo ha.1 hb.2
  apply local_integral_hasDerivAt (fun r x => q x r) (fun r x => qt q x r) hab
    (show t ∈ Ioo (t / 2) ((t + H) / 2) by constructor <;> linarith [ht.1, ht.2])
  · exact hq.continuousOn.comp continuous_swap.continuousOn
      (fun _ hp => ⟨hspace hp.2, htime hp.1⟩)
  · exact (interior_partials_continuous hq).1.comp continuous_swap.continuousOn
      (fun _ hp => ⟨hspace hp.2, htime hp.1⟩)
  · intro r hr x hx
    exact partial_time (interior_differentiableAt hq (hspace hx)
      (htime (Ioo_subset_Icc_self hr)))

theorem rectangle_mass_derivative {q : ℝ → ℝ → State} {states : Set State}
    {L R H a b t : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (ha : a ∈ Ioo L R) (hb : b ∈ Ioo L R) (ht : t ∈ Ioo 0 H) :
    HasDerivAt (fun r => ∫ x in a..b, q x r) (q a t - q b t) t := by
  have hc := (smooth_reference_interior hq).continuousOn
  have hboundary : ContinuousOn (fun r => q a r - q b r) (Ioo 0 H) :=
    (hc.comp (continuous_const.prodMk continuous_id).continuousOn (fun _ hr => ⟨ha, hr⟩)).sub
      (hc.comp (continuous_const.prodMk continuous_id).continuousOn (fun _ hr => ⟨hb, hr⟩))
  have hd := intervalIntegral.integral_hasDerivAt_right
    (IntervalIntegrable.refl (f := fun r => q a r - q b r) (a := t))
    (ContinuousOn.stronglyMeasurableAtFilter isOpen_Ioo hboundary t ht)
    (hboundary.continuousAt (Ioo_mem_nhds ht.1 ht.2))
  apply (hd.add_const (∫ x in a..b, q x t)).congr_of_eventuallyEq
  filter_upwards [Ioo_mem_nhds ht.1 ht.2] with r hr
  exact (sub_eq_iff_eq_add.mp (hq.2.1.2.2 a (Ioo_subset_Icc_self ha)
    b (Ioo_subset_Icc_self hb) t (Ioo_subset_Icc_self ht) r (Ioo_subset_Icc_self hr)))

theorem interior_classical {q : ℝ → ℝ → State} {states : Set State}
    {L R H x t : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (hx : x ∈ Ioo L R) (ht : t ∈ Ioo 0 H) :
    IsLinearAdvectionSolutionAt q 1 x t := by
  have hs := smooth_reference_interior hq
  have hp := interior_partials_continuous hs
  have hqt : ContinuousOn (fun y => qt q y t) (Ioo L R) :=
    hp.1.comp (continuous_id.prodMk continuous_const).continuousOn (fun _ hy => ⟨hy, ht⟩)
  have hqx : ContinuousOn (fun y => qx q y t) (Ioo L R) :=
    hp.2.comp (continuous_id.prodMk continuous_const).continuousOn (fun _ hy => ⟨hy, ht⟩)
  have hi_ordered (a b : ℝ) (ha : a ∈ Ioo L R) (hb : b ∈ Ioo L R) (hab : a ≤ b) :
      ∫ y in a..b, (qt q y t + qx q y t) = 0 := by
    have hsub : Icc a b ⊆ Ioo L R := Icc_subset_Ioo ha.1 hb.2
    have hit := (hqt.mono hsub).intervalIntegrable_of_Icc (μ := volume) hab
    have hix := (hqx.mono hsub).intervalIntegrable_of_Icc (μ := volume) hab
    have htint := (interior_mass_derivative hs ha hb hab ht).unique
      (rectangle_mass_derivative hq ha hb ht)
    have hxint : (∫ y in a..b, qx q y t) = q b t - q a t :=
      intervalIntegral.integral_eq_sub_of_hasDerivAt
        (fun y hy => partial_space (interior_differentiableAt hs
          (hsub (uIcc_of_le hab ▸ hy)) ht)) hix
    rw [intervalIntegral.integral_add hit hix, htint, hxint]
    abel
  have hz : qt q x t + qx q x t = 0 :=
    eq_zero_of_local_integrals _ (hqt.add hqx) hx (by
      intro a ha b hb
      rcases le_total a b with hab | hba
      · exact hi_ordered a b ha hb hab
      · change (∫ y in a..b, qt q y t + qx q y t) = 0
        rw [intervalIntegral.integral_symm, hi_ordered b a hb ha hba, neg_zero])
  refine ⟨qt q x t, qx q x t, partial_time (interior_differentiableAt hs hx ht),
    partial_space (interior_differentiableAt hs hx ht), ?_⟩
  simpa only [one_smul] using hz

/-- The entire backward characteristic remains in the physical box. Interior
PDE information propagates to both time endpoints by continuity on the closed box. -/
theorem characteristic_propagation {q : ℝ → ℝ → State} {states : Set State}
    {L R H x t : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (ht : t ∈ Icc 0 H) (hleft : L ≤ x - t) (hright : x ≤ R) :
    q x t = q (x - t) 0 := by
  rcases eq_or_lt_of_le ht.1 with hzero | hpos
  · simp [← hzero]
  let f : ℝ → State := fun r => q (x - t + r) r
  have hclosed : ContinuousOn f (Icc 0 t) :=
    hq.1.continuousOn.comp
      ((continuous_const.add continuous_id).prodMk continuous_id).continuousOn (by
        intro r hr
        constructor <;> constructor <;> dsimp <;> linarith [hr.1, hr.2, ht.2])
  have hd (r : ℝ) (hr : r ∈ Ioo 0 t) : HasDerivAt f 0 r := by
    have hx : x - t + r ∈ Ioo L R := by
      constructor <;> linarith [hr.1, hr.2]
    have hrt : r ∈ Ioo 0 H := ⟨hr.1, lt_of_lt_of_le hr.2 ht.2⟩
    have hpde := interior_classical hq hx hrt
    have hdiff := interior_differentiableAt (smooth_reference_interior hq) hx hrt
    simpa only [f, one_mul] using
      (linearAdvection_hasDerivAt_characteristic (speed := 1) (x := x - t)
        (t := r) (by simpa only [one_mul] using hdiff)
        (by simpa only [one_mul] using hpde))
  obtain ⟨c, hc⟩ := isOpen_Ioo.exists_is_const_of_deriv_eq_zero isPreconnected_Ioo
    (fun r hr => (hd r hr).differentiableAt.differentiableWithinAt)
    (fun r hr => (hd r hr).deriv)
  have heq : EqOn f (fun _ => c) (Icc 0 t) :=
    (show EqOn f (fun _ => c) (Ioo 0 t) from hc).of_subset_closure
      hclosed continuousOn_const Ioo_subset_Icc_self (by rw [closure_Ioo (ne_of_lt hpos)])
  have h := (heq (right_mem_Icc.mpr ht.1)).trans (heq (left_mem_Icc.mpr ht.1)).symm
  simpa [f] using h

theorem local_cell_average_shift {q : ℝ → ℝ → State} {states : Set State}
    {L R H a b t : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (hab : a ≤ b) (ht : t ∈ Icc 0 H) (hleft : L ≤ a - t) (hright : b ≤ R) :
    oneDimensionalCellAverage (fun x => q x t) a b =
      oneDimensionalCellAverage (fun x => q x 0) (a - t) (b - t) := by
  have heq : (∫ x in a..b, q x t) = ∫ x in a..b, q (x - t) 0 := by
    apply intervalIntegral.integral_congr
    intro x hx
    rw [uIcc_of_le hab] at hx
    exact characteristic_propagation hq ht (by linarith [hx.1]) (by linarith [hx.2])
  unfold oneDimensionalCellAverage
  rw [heq, intervalIntegral.integral_comp_sub_right (f := fun x => q x 0)]
  congr 2; ring

end DimLocalCharacteristicWitness

namespace DimLocalCharacteristicWitness
open CFL1RefinementWitness
open NumStability
open MeasureTheory Set
variable {m : ℕ}
local notation "State" => Fin m → ℝ

/-- A smooth local physical reference advances exactly at CFL one, provided
the active cell and its backward-shifted predecessor stay in the box. -/
theorem local_cfl1_exact {q : ℝ → ℝ → State} {states : Set State}
    {L R H : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (h : ℝ) (hh : 0 < h) (hhH : h ≤ H) (j : ℤ)
    (hleft : L ≤ (grid h hh).cellLeft j - h)
    (hright : (grid h hh).cellRight j ≤ R) :
    advance h hh (fun k => finiteVolumeCellAverageOn (grid h hh) (fun x => q x 0) k) j =
      finiteVolumeCellAverageOn (grid h hh) (fun x => q x h) j := by
  rw [advance_eq_shift]
  have havg := local_cell_average_shift hq
    ((grid h hh).cell_nonempty j).le ⟨hh.le, hhH⟩ hleft hright
  have hl : (grid h hh).cellLeft j - h = (grid h hh).cellLeft (j - 1) := by
    simp only [grid, Int.cast_sub, Int.cast_one]
    ring
  have hr : (grid h hh).cellRight j - h = (grid h hh).cellRight (j - 1) := by
    simp only [grid, Int.cast_sub, Int.cast_one]
    ring
  rw [hl, hr] at havg
  exact havg.symm

/-- Only the actually entering predecessor average is needed at CFL one.
There is no condition on values at unused exterior cells. -/
theorem local_cfl1_exact_of_projection {q : ℝ → ℝ → State} {states : Set State}
    {L R H : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (h : ℝ) (hh : 0 < h) (hhH : h ≤ H) (j : ℤ)
    (hleft : L ≤ (grid h hh).cellLeft j - h)
    (hright : (grid h hh).cellRight j ≤ R)
    (values : ℤ → State)
    (hprojection : values (j - 1) =
      finiteVolumeCellAverageOn (grid h hh) (fun x => q x 0) (j - 1)) :
    advance h hh values j = finiteVolumeCellAverageOn (grid h hh) (fun x => q x h) j := by
  rw [advance_eq_shift, hprojection]
  simpa only [advance_eq_shift] using local_cfl1_exact hq h hh hhH j hleft hright

/-- The zero constant is uniform for every smooth local rectangle reference,
every admitted mesh, and every cell obeying the stated physical containment.
This is the local-reference accuracy component; family geometry/admission and
finite-window oscillation remain separate obligations. -/
theorem local_refinement_zero_defect {q : ℝ → ℝ → State} {states : Set State}
    {L R H : ℝ} (hq : SmoothReferenceOn q id states L R H)
    (p : ℝ) (_hp : 1 < p) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (n : ℕ) (j : ℤ), meshSize n ≤ H →
      L ≤ (grid (meshSize n) (meshSize_pos n)).cellLeft j - meshSize n →
      (grid (meshSize n) (meshSize_pos n)).cellRight j ≤ R →
      ∀ values : ℤ → State,
        values (j - 1) = finiteVolumeCellAverageOn (grid (meshSize n) (meshSize_pos n))
          (fun x => q x 0) (j - 1) →
        ‖advance (meshSize n) (meshSize_pos n) values j -
          finiteVolumeCellAverageOn (grid (meshSize n) (meshSize_pos n))
            (fun x => q x (meshSize n)) j‖ ≤ C * meshSize n * (meshSize n) ^ p := by
  refine ⟨0, le_rfl, ?_⟩
  intro n j hH hl hr values hproj
  rw [local_cfl1_exact_of_projection hq (meshSize n) (meshSize_pos n) hH j hl hr values hproj]
  simp only [sub_self, norm_zero, zero_mul, le_refl]

end DimLocalCharacteristicWitness

open MeasureTheory Filter
open scoped BigOperators Topology



namespace CFL1QualityFamilyWitness
open NumStability NumStability.DirectionalQualityRepair
open CFL1RefinementWitness
open MeasureTheory Set Filter
open scoped BigOperators Topology

noncomputable def h (n : ℕ) : ℝ := meshSize (n + 1)

theorem h_pos (n : ℕ) : 0 < h n := meshSize_pos (n + 1)

theorem h_eq (n : ℕ) : h n = 1 / ((n : ℝ) + 2) := by
  simp only [h, meshSize, Nat.cast_add, Nat.cast_one]
  congr 1; ring

theorem h_mul (n : ℕ) : h n * ((n : ℝ) + 2) = 1 := by
  rw [h_eq]
  have : (n : ℝ) + 2 ≠ 0 := by positivity
  field_simp

theorem h_le_half (n : ℕ) : h n ≤ 1 / 2 := by
  rw [h_eq, div_le_div_iff₀ (by positivity) (by norm_num)]
  norm_num

theorem h_tendsto_zero : Tendsto h atTop (𝓝 0) :=
  meshSize_tendsto_zero.comp (tendsto_add_atTop_nat 1)

theorem input_geometry (n : ℕ) (j : ℤ)
    (hj : j ∈ Finset.Ico (-1) ((-1 : ℤ) + ((n + 5 : ℕ) : ℤ))) :
    (-2 : ℝ) ≤ (grid (h n) (h_pos n)).cellLeft j ∧
    (grid (h n) (h_pos n)).cellRight j ≤ 2 := by
  simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat] at hj
  have hjl : (-1 : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj.1
  have hjr : (j : ℝ) ≤ (n : ℝ) + 3 := by
    have : j ≤ (n : ℤ) + 3 := by omega
    exact_mod_cast this
  simp only [grid]
  have hl := mul_le_mul_of_nonneg_right hjl (h_pos n).le
  have hr := mul_le_mul_of_nonneg_right hjr (h_pos n).le
  have hp := h_pos n
  have hb := h_le_half n
  have he := h_mul n
  constructor <;> nlinarith

theorem active_coverage (n : ℕ) (x : ℝ) (hx : x ∈ Icc (0 : ℝ) 1) :
    ∃ j ∈ Finset.Ico (0 : ℤ) (0 + (n + 4 : ℕ)),
      x ∈ Icc ((grid (h n) (h_pos n)).cellLeft j)
        ((grid (h n) (h_pos n)).cellRight j) := by
  let k : ℤ := ⌊x * ((n : ℝ) + 2)⌋
  have hk0 : 0 ≤ k := Int.floor_nonneg.mpr (mul_nonneg hx.1 (by positivity))
  have hkle := Int.floor_le (x * ((n : ℝ) + 2))
  have hklt := Int.lt_floor_add_one (x * ((n : ℝ) + 2))
  have hkmax : k ≤ (n : ℤ) + 2 := by
    have hkr : (k : ℝ) ≤ (n : ℝ) + 2 := by
      dsimp [k]
      nlinarith [mul_le_mul_of_nonneg_right hx.2 (show 0 ≤ (n : ℝ) + 2 by positivity)]
    exact_mod_cast hkr
  refine ⟨k + 1, ?_, ?_⟩
  · simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat]
    omega
  · simp only [grid, Int.cast_add, Int.cast_one, add_sub_cancel_right]
    have hl := mul_le_mul_of_nonneg_right hkle (h_pos n).le
    have hr := mul_lt_mul_of_pos_right hklt (h_pos n)
    have he := h_mul n
    have heq : (x * ((n : ℝ) + 2)) * h n = x := by
      calc
        _ = x * (h n * ((n : ℝ) + 2)) := by ring
        _ = x := by rw [he, mul_one]
    change (k : ℝ) * h n ≤ x ∧ x ≤ ((k : ℝ) + 1) * h n
    dsimp [k] at *
    constructor <;> nlinarith

noncomputable def family (m : ℕ) : LineFamily m where
  flux := fun _ => id
  states := Set.univ
  left := -2
  right := 2
  interval_nonempty := by norm_num
  hyperbolic := by
    intro x hx state hstate
    have heq : (StationaryRiemannField.transportLaw (m := m)).physicalFlux = id :=
      funext StationaryRiemannField.physicalFlux
    rw [← heq]
    exact hyperbolicConservationLaw_isHyperbolicFluxAt _ state
  horizon := 1
  horizon_pos := by norm_num
  grid := fun n => grid (h n) (h_pos n)
  mesh := h
  mesh_pos := h_pos
  mesh_tendsto := h_tendsto_zero
  meshRatio := 1
  meshRatio_pos := by norm_num
  dt := h
  dt_pos := h_pos
  dt_le_horizon := fun n => (h_le_half n).trans (by norm_num)
  cfl := 1
  cfl_pos := by norm_num
  activeStart := fun _ => 0
  activeCount := fun n => n + 4
  activeCount_two_le := by intro n; omega
  targetLeft := 0
  targetRight := 1
  target_nonempty := by norm_num
  target_inside := by norm_num
  active_coverage := active_coverage
  inputStart := fun _ => -1
  inputCount := fun n => n + 5
  input_covers := by
    intro n j hj
    simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat] at hj ⊢
    omega
  input_geometry := by
    intro n j hj
    obtain ⟨hl, hr⟩ := input_geometry n j hj
    exact ⟨hl, hr, (grid_volume _ _ _).le, by rw [grid_volume, one_mul]⟩
  mesh_comparable := by intro n j hj; rw [grid_volume, one_mul]
  numericalFlux := fun _ values j => values (j - 1)
  admitted := fun _ _ => True
  line_local := by
    intro n values other heq j hj
    apply heq
    simp only [Finset.mem_Ico, Finset.mem_Icc, Nat.cast_add, Nat.cast_ofNat] at hj ⊢
    omega

theorem family_advance (m n : ℕ) (values : ℤ → Fin m → ℝ) (j : ℤ) :
    (family m).advance n values j = values (j - 1) :=
  advance_eq_shift (h n) (h_pos n) values j

theorem family_quality (m : ℕ) : (family m).HasControlledHighResolution := by
  constructor
  · refine ⟨2, by norm_num, ?_⟩
    intro q hq
    refine ⟨0, le_rfl, 0, ?_⟩
    intro n hn values hproj
    refine ⟨True.intro, ?_⟩
    intro j hj
    have hj' : 0 ≤ j ∧ j < (n : ℤ) + 4 := by
      simpa only [family, Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat, zero_add] using hj
    have hpred : j - 1 ∈ Finset.Ico (-1) ((-1 : ℤ) + ((n + 5 : ℕ) : ℤ)) := by
      simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat]
      omega
    have hgeom := input_geometry n (j - 1) hpred
    have hgeomj := input_geometry n j (by
      simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat]; omega)
    have hl : (-2 : ℝ) ≤ (grid (h n) (h_pos n)).cellLeft j - h n := by
      have he : (grid (h n) (h_pos n)).cellLeft j - h n =
          (grid (h n) (h_pos n)).cellLeft (j - 1) := by
        simp only [grid, Int.cast_sub, Int.cast_one]; ring
      rw [he]
      exact hgeom.1
    have href : DimLocalCharacteristicWitness.SmoothReferenceOn q id Set.univ (-2) 2 1 := hq
    have hexact := DimLocalCharacteristicWitness.local_cfl1_exact_of_projection href
      (h n) (h_pos n) ((h_le_half n).trans (by norm_num)) j hl hgeomj.2 values
      (hproj (j - 1) hpred)
    change ‖advance (h n) (h_pos n) values j -
      finiteVolumeCellAverageOn (grid (h n) (h_pos n)) (fun x => q x (h n)) j‖ ≤
        (0 : ℝ) * h n * h n ^ (2 : ℝ)
    rw [hexact]
    simp
  · refine ⟨0, le_rfl, ?_⟩
    intro n values other hv ho E hE herr j hj
    rw [family_advance, family_advance]
    simp only [zero_mul, add_zero, one_mul]
    apply herr
    simp only [family, Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat] at hj ⊢
    omega
  · refine ⟨0, le_rfl, fun _ => 0, fun _ => le_rfl, tendsto_const_nhds, ?_⟩
    intro n values hv
    simp only [zero_mul, add_zero, one_mul, mul_zero]
    change windowVariation 0 (n + 4 - 1) ((family m).advance n values) ≤
      windowVariation (-1) (n + 5 - 1) values
    unfold windowVariation
    simp only [family_advance]
    have he (k : ℕ) :
        ‖values ((0 : ℤ) + k + 1 - 1) - values (0 + k - 1)‖ =
        ‖values ((-1 : ℤ) + k + 1) - values (-1 + k)‖ := by
      congr 2 <;> congr 1 <;> ring
    simp_rw [he]
    exact Finset.sum_le_sum_of_subset_of_nonneg
      (Finset.range_mono (by omega)) (fun _ _ _ => norm_nonneg _)

theorem smooth_local_reference :
    SpatialSmoothReferenceOn (fun x t => smoothProfile (x - t)) (fun _ => id)
      Set.univ (-2) 2 1 := by
  have hg := translated_is_conserved smoothProfile smoothProfile_integrable
  have hc : ContDiff ℝ ⊤ (fun p : ℝ × ℝ => smoothProfile (p.1 - p.2)) :=
    contDiff_pi.mpr (fun _ => contDiff_fst.sub contDiff_snd)
  refine ⟨hc.contDiffOn, ?_, fun _ _ _ _ => Set.mem_univ _⟩
  exact ⟨fun t _ => hg.1 (-2) 2 t, fun x _ => hg.2.1 x 0 1,
    fun a _ b _ s _ t _ => hg.2.2 a b s t⟩

theorem smooth_initial_projection (n : ℕ) :
    (family 1).InitialProjection n (fun x t => smoothProfile (x - t))
      (fun j => finiteVolumeCellAverageOn (grid (h n) (h_pos n)) smoothProfile j) := by
  intro j hj
  simp only [family, sub_zero]

/-- The nonsmooth physical example is a transported discontinuity of linear
advection. It is not misclassified as a smooth reference or nonlinear shock. -/
theorem step_local_reference :
    SpatialRectangleReferenceOn (fun x t => stepProfile (x - t)) (fun _ => id) (-2) 2 1 ∧
      ¬ ContinuousAt stepProfile 0 := by
  have hg := translated_is_conserved stepProfile stepProfile_integrable
  exact ⟨⟨fun t _ => hg.1 (-2) 2 t, fun x _ => hg.2.1 x 0 1,
    fun a _ b _ s _ t _ => hg.2.2 a b s t⟩, stepProfile_discontinuous⟩

/-- A literal scalar family satisfies the full current quality predicate.
The fixed target interval has positive length at every refinement. -/
theorem scalar_family_exists : ∃ f : LineFamily 1,
    f.HasControlledHighResolution ∧ f.targetLeft = 0 ∧ f.targetRight = 1 ∧
    f.flux = (fun _ => id) ∧ ∀ n values, f.admitted n values :=
  ⟨family 1, family_quality 1, rfl, rfl, rfl, fun _ _ => True.intro⟩

end CFL1QualityFamilyWitness


namespace NumStability.DimensionalPlacement
open MeasureTheory
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
noncomputable def physicalToDraft (x : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m) : FiniteDirectionalRepair.PhysicalData D Cell Face Point FacePoint m where
  cells := x.cells
  measure := x.measure
  positive := x.positive
  finite := x.finite
  leftFace := x.leftFace
  rightFace := x.rightFace
  faceMeasure := x.faceMeasure
  facePoint := x.facePoint
  left_incidence := x.left_incidence
  right_incidence := x.right_incidence
  admissibleStates := x.admissibleStates
  normalFlux := x.normalFlux
  hyperbolic := x.hyperbolic

noncomputable def physicalFromDraft (x : FiniteDirectionalRepair.PhysicalData D Cell Face Point FacePoint m) : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m where
  cells := x.cells
  measure := x.measure
  positive := x.positive
  finite := x.finite
  leftFace := x.leftFace
  rightFace := x.rightFace
  faceMeasure := x.faceMeasure
  facePoint := x.facePoint
  left_incidence := x.left_incidence
  right_incidence := x.right_incidence
  admissibleStates := x.admissibleStates
  normalFlux := x.normalFlux
  hyperbolic := x.hyperbolic

theorem physical_roundtrip (x : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m) : physicalFromDraft (physicalToDraft x) = x := by cases x; rfl
theorem physical_draft_roundtrip (x : FiniteDirectionalRepair.PhysicalData D Cell Face Point FacePoint m) : physicalToDraft (physicalFromDraft x) = x := by cases x; rfl

noncomputable def coordinatesToDraft (x : FiniteCoordinate.LineCoordinates (m := m) D Cell Face Line) : FiniteDirectionalRepair.LineCoordinates (m := m) D Cell Face Line where
  cellLine := x.cellLine
  cellIndex := x.cellIndex
  faceLine := x.faceLine
  faceIndex := x.faceIndex
  lookup := x.lookup
  lookup_cell := x.lookup_cell
  lookup_sound := x.lookup_sound
  ghost := x.ghost

noncomputable def coordinatesFromDraft (x : FiniteDirectionalRepair.LineCoordinates (m := m) D Cell Face Line) : FiniteCoordinate.LineCoordinates (m := m) D Cell Face Line where
  cellLine := x.cellLine
  cellIndex := x.cellIndex
  faceLine := x.faceLine
  faceIndex := x.faceIndex
  lookup := x.lookup
  lookup_cell := x.lookup_cell
  lookup_sound := x.lookup_sound
  ghost := x.ghost

theorem coordinates_roundtrip (x : FiniteCoordinate.LineCoordinates (m := m) D Cell Face Line) : coordinatesFromDraft (coordinatesToDraft x) = x := by cases x; rfl
theorem coordinates_draft_roundtrip (x : FiniteDirectionalRepair.LineCoordinates (m := m) D Cell Face Line) : coordinatesToDraft (coordinatesFromDraft x) = x := by cases x; rfl

noncomputable def familyToDraft (x : DirectionalLine.LineFamily m) : DirectionalQualityRepair.LineFamily m where
  flux := x.flux
  states := x.states
  left := x.left
  right := x.right
  interval_nonempty := x.interval_nonempty
  hyperbolic := x.hyperbolic
  horizon := x.horizon
  horizon_pos := x.horizon_pos
  grid := x.grid
  mesh := x.mesh
  mesh_pos := x.mesh_pos
  mesh_tendsto := x.mesh_tendsto
  meshRatio := x.meshRatio
  meshRatio_pos := x.meshRatio_pos
  dt := x.dt
  dt_pos := x.dt_pos
  dt_le_horizon := x.dt_le_horizon
  cfl := x.cfl
  cfl_pos := x.cfl_pos
  activeStart := x.activeStart
  activeCount := x.activeCount
  activeCount_two_le := x.activeCount_two_le
  targetLeft := x.targetLeft
  targetRight := x.targetRight
  target_nonempty := x.target_nonempty
  target_inside := x.target_inside
  active_coverage := x.active_coverage
  inputStart := x.inputStart
  inputCount := x.inputCount
  input_covers := x.input_covers
  input_geometry := x.input_geometry
  mesh_comparable := x.mesh_comparable
  numericalFlux := x.numericalFlux
  admitted := x.admitted
  line_local := x.line_local

noncomputable def familyFromDraft (x : DirectionalQualityRepair.LineFamily m) : DirectionalLine.LineFamily m where
  flux := x.flux
  states := x.states
  left := x.left
  right := x.right
  interval_nonempty := x.interval_nonempty
  hyperbolic := x.hyperbolic
  horizon := x.horizon
  horizon_pos := x.horizon_pos
  grid := x.grid
  mesh := x.mesh
  mesh_pos := x.mesh_pos
  mesh_tendsto := x.mesh_tendsto
  meshRatio := x.meshRatio
  meshRatio_pos := x.meshRatio_pos
  dt := x.dt
  dt_pos := x.dt_pos
  dt_le_horizon := x.dt_le_horizon
  cfl := x.cfl
  cfl_pos := x.cfl_pos
  activeStart := x.activeStart
  activeCount := x.activeCount
  activeCount_two_le := x.activeCount_two_le
  targetLeft := x.targetLeft
  targetRight := x.targetRight
  target_nonempty := x.target_nonempty
  target_inside := x.target_inside
  active_coverage := x.active_coverage
  inputStart := x.inputStart
  inputCount := x.inputCount
  input_covers := x.input_covers
  input_geometry := x.input_geometry
  mesh_comparable := x.mesh_comparable
  numericalFlux := x.numericalFlux
  admitted := x.admitted
  line_local := x.line_local

theorem family_roundtrip (x : DirectionalLine.LineFamily m) : familyFromDraft (familyToDraft x) = x := by cases x; rfl
theorem family_draft_roundtrip (x : DirectionalQualityRepair.LineFamily m) : familyToDraft (familyFromDraft x) = x := by cases x; rfl

theorem quality_iff (family : DirectionalLine.LineFamily m) :
    family.HasControlledHighResolution ↔ (familyToDraft family).HasControlledHighResolution := by
  constructor <;> intro h <;> exact ⟨h.order, h.stability, h.oscillation⟩

theorem physical_reference_iff (data : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → Fin m → ℝ) (s t : ℝ) :
    data.ReferenceOn d q s t ↔ (physicalToDraft data).ReferenceOn d q s t := Iff.rfl

theorem physical_mean_eq (data : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m)
    (q : Point → ℝ → Fin m → ℝ) (cell : Cell) (t : ℝ) :
    data.cellMean q cell t = (physicalToDraft data).cellMean q cell t := rfl

theorem physical_flux_eq (data : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → Fin m → ℝ) (face : Face) (t : ℝ) :
    data.faceFlux d q face t = (physicalToDraft data).faceFlux d q face t := rfl

theorem family_advance_eq (family : DirectionalLine.LineFamily m) (n : ℕ)
    (values : ℤ → Fin m → ℝ) (j : ℤ) :
    family.advance n values j = (familyToDraft family).advance n values j := rfl

theorem extraction_eq (coord : FiniteCoordinate.LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current : Cell → Fin m → ℝ) (j : ℤ) :
    coord.extract d line current j = (coordinatesToDraft coord).extract d line current j := rfl

variable {data : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m}
variable {coord : FiniteCoordinate.LineCoordinates (m := m) D Cell Face Line}
variable {families : D → Line → DirectionalLine.LineFamily m}
noncomputable def realizationToDraft (x : FiniteCoordinate.LineRealization data coord families) : FiniteDirectionalRepair.LineRealization (physicalToDraft data) (coordinatesToDraft coord) (fun d line => familyToDraft (families d line)) where
  level := x.level
  duration := x.duration
  duration_eq := x.duration_eq
  area := x.area
  area_pos := x.area_pos
  left_line := x.left_line
  right_line := x.right_line
  left_index := x.left_index
  right_index := x.right_index
  active_cell := x.active_cell
  volume_eq := x.volume_eq
  physical_flux := x.physical_flux
  states_eq := x.states_eq

noncomputable def realizationFromDraft (x : FiniteDirectionalRepair.LineRealization (physicalToDraft data) (coordinatesToDraft coord) (fun d line => familyToDraft (families d line))) : FiniteCoordinate.LineRealization data coord families where
  level := x.level
  duration := x.duration
  duration_eq := x.duration_eq
  area := x.area
  area_pos := x.area_pos
  left_line := x.left_line
  right_line := x.right_line
  left_index := x.left_index
  right_index := x.right_index
  active_cell := x.active_cell
  volume_eq := x.volume_eq
  physical_flux := x.physical_flux
  states_eq := x.states_eq

theorem realization_roundtrip (x : FiniteCoordinate.LineRealization data coord families) : realizationFromDraft (realizationToDraft x) = x := by cases x; rfl
theorem realization_draft_roundtrip (x : FiniteDirectionalRepair.LineRealization (physicalToDraft data) (coordinatesToDraft coord) (fun d line => familyToDraft (families d line))) : realizationToDraft (realizationFromDraft x) = x := by cases x; rfl
theorem rule_eq (method : FiniteCoordinate.LineRealization data coord families)
    (d : D) (dt : ℝ) (current : Cell → Fin m → ℝ) (face : Face) :
    method.rule d dt current face = (realizationToDraft method).rule d dt current face := rfl

theorem admission_iff (method : FiniteCoordinate.LineRealization data coord families)
    (d : D) (current : Cell → Fin m → ℝ) :
    method.Admitted d current ↔ (realizationToDraft method).Admitted d current := Iff.rfl

theorem update_eq (method : FiniteCoordinate.LineRealization data coord families)
    (d : D) (dt : ℝ) (current : Cell → Fin m → ℝ) :
    FiniteCoordinate.advance data method.rule d dt current =
      FiniteDirectionalRepair.advance (physicalToDraft data) (realizationToDraft method).rule d dt current := rfl

end NumStability.DimensionalPlacement
#check NumStability.DimensionalPlacement.physicalToDraft
#print axioms NumStability.DimensionalPlacement.physicalToDraft
#check NumStability.DimensionalPlacement.physicalFromDraft
#print axioms NumStability.DimensionalPlacement.physicalFromDraft
#check NumStability.DimensionalPlacement.physical_roundtrip
#print axioms NumStability.DimensionalPlacement.physical_roundtrip
#check NumStability.DimensionalPlacement.physical_draft_roundtrip
#print axioms NumStability.DimensionalPlacement.physical_draft_roundtrip
#check NumStability.DimensionalPlacement.coordinatesToDraft
#print axioms NumStability.DimensionalPlacement.coordinatesToDraft
#check NumStability.DimensionalPlacement.coordinatesFromDraft
#print axioms NumStability.DimensionalPlacement.coordinatesFromDraft
#check NumStability.DimensionalPlacement.coordinates_roundtrip
#print axioms NumStability.DimensionalPlacement.coordinates_roundtrip
#check NumStability.DimensionalPlacement.coordinates_draft_roundtrip
#print axioms NumStability.DimensionalPlacement.coordinates_draft_roundtrip
#check NumStability.DimensionalPlacement.familyToDraft
#print axioms NumStability.DimensionalPlacement.familyToDraft
#check NumStability.DimensionalPlacement.familyFromDraft
#print axioms NumStability.DimensionalPlacement.familyFromDraft
#check NumStability.DimensionalPlacement.family_roundtrip
#print axioms NumStability.DimensionalPlacement.family_roundtrip
#check NumStability.DimensionalPlacement.family_draft_roundtrip
#print axioms NumStability.DimensionalPlacement.family_draft_roundtrip
#check NumStability.DimensionalPlacement.quality_iff
#print axioms NumStability.DimensionalPlacement.quality_iff
#check NumStability.DimensionalPlacement.physical_reference_iff
#print axioms NumStability.DimensionalPlacement.physical_reference_iff
#check NumStability.DimensionalPlacement.physical_mean_eq
#print axioms NumStability.DimensionalPlacement.physical_mean_eq
#check NumStability.DimensionalPlacement.physical_flux_eq
#print axioms NumStability.DimensionalPlacement.physical_flux_eq
#check NumStability.DimensionalPlacement.family_advance_eq
#print axioms NumStability.DimensionalPlacement.family_advance_eq
#check NumStability.DimensionalPlacement.extraction_eq
#print axioms NumStability.DimensionalPlacement.extraction_eq
#check NumStability.DimensionalPlacement.realizationToDraft
#print axioms NumStability.DimensionalPlacement.realizationToDraft
#check NumStability.DimensionalPlacement.realizationFromDraft
#print axioms NumStability.DimensionalPlacement.realizationFromDraft
#check NumStability.DimensionalPlacement.realization_roundtrip
#print axioms NumStability.DimensionalPlacement.realization_roundtrip
#check NumStability.DimensionalPlacement.realization_draft_roundtrip
#print axioms NumStability.DimensionalPlacement.realization_draft_roundtrip
#check NumStability.DimensionalPlacement.rule_eq
#print axioms NumStability.DimensionalPlacement.rule_eq
#check NumStability.DimensionalPlacement.admission_iff
#print axioms NumStability.DimensionalPlacement.admission_iff
#check NumStability.DimensionalPlacement.update_eq
#print axioms NumStability.DimensionalPlacement.update_eq
open Lean Meta Elab Command in
run_cmd liftTermElabM do
  let pairs : List (Name × Name) := [
    (`NumStability.FiniteDirectionalRepair.PhysicalData, `NumStability.FiniteCoordinate.PhysicalData),
    (`NumStability.FiniteDirectionalRepair.PhysicalData.cellVolume, `NumStability.FiniteCoordinate.PhysicalData.cellVolume),
    (`NumStability.FiniteDirectionalRepair.PhysicalData.cellVolume_pos, `NumStability.FiniteCoordinate.PhysicalData.cellVolume_pos),
    (`NumStability.FiniteDirectionalRepair.PhysicalData.cellMean, `NumStability.FiniteCoordinate.PhysicalData.cellMean),
    (`NumStability.FiniteDirectionalRepair.PhysicalData.faceFlux, `NumStability.FiniteCoordinate.PhysicalData.faceFlux),
    (`NumStability.FiniteDirectionalRepair.advance, `NumStability.FiniteCoordinate.advance),
    (`NumStability.FiniteDirectionalRepair.sweep, `NumStability.FiniteCoordinate.sweep),
    (`NumStability.FiniteDirectionalRepair.advance_mass_balance, `NumStability.FiniteCoordinate.advance_mass_balance),
    (`NumStability.FiniteDirectionalRepair.finite_mass_balance, `NumStability.FiniteCoordinate.finite_mass_balance),
    (`NumStability.FiniteDirectionalRepair.sweep_cons, `NumStability.FiniteCoordinate.sweep_cons),
    (`NumStability.FiniteDirectionalRepair.sweep_split, `NumStability.FiniteCoordinate.sweep_split),
    (`NumStability.FiniteDirectionalRepair.LineLocal, `NumStability.FiniteCoordinate.LineLocal),
    (`NumStability.FiniteDirectionalRepair.advance_local, `NumStability.FiniteCoordinate.advance_local),
    (`NumStability.FiniteDirectionalRepair.PhysicalData.ReferenceOn, `NumStability.FiniteCoordinate.PhysicalData.ReferenceOn),
    (`NumStability.FiniteDirectionalRepair.advance_error_le, `NumStability.FiniteCoordinate.advance_error_le),
    (`NumStability.DirectionalQualityRepair.RectangleReferenceOn, `NumStability.LocalConservationLaw.RectangleReferenceOn),
    (`NumStability.DirectionalQualityRepair.SmoothReferenceOn, `NumStability.LocalConservationLaw.SmoothReferenceOn),
    (`NumStability.DirectionalQualityRepair.SpatialRectangleReferenceOn, `NumStability.LocalConservationLaw.SpatialRectangleReferenceOn),
    (`NumStability.DirectionalQualityRepair.SpatialSmoothReferenceOn, `NumStability.LocalConservationLaw.SpatialSmoothReferenceOn),
    (`NumStability.DirectionalQualityRepair.spatial_rectangle_const_iff, `NumStability.LocalConservationLaw.spatial_rectangle_const_iff),
    (`NumStability.DirectionalQualityRepair.spatial_smooth_const_iff, `NumStability.LocalConservationLaw.spatial_smooth_const_iff),
    (`NumStability.DirectionalQualityRepair.windowVariation, `NumStability.DirectionalLine.windowVariation),
    (`NumStability.DirectionalQualityRepair.LineFamily, `NumStability.DirectionalLine.LineFamily),
    (`NumStability.DirectionalQualityRepair.LineFamily.advance, `NumStability.DirectionalLine.LineFamily.advance),
    (`NumStability.DirectionalQualityRepair.LineFamily.InitialProjection, `NumStability.DirectionalLine.LineFamily.InitialProjection),
    (`NumStability.DirectionalQualityRepair.LineFamily.HasControlledHighResolution, `NumStability.DirectionalLine.LineFamily.HasControlledHighResolution),
    (`NumStability.DirectionalQualityRepair.LineFamily.HasControlledHighResolution.perturbed_accuracy, `NumStability.DirectionalLine.LineFamily.HasControlledHighResolution.perturbed_accuracy),
    (`NumStability.DirectionalQualityRepair.LineFamily.stabilityRate, `NumStability.DirectionalLine.LineFamily.stabilityRate),
    (`NumStability.DirectionalQualityRepair.LineFamily.stabilityRate_spec, `NumStability.DirectionalLine.LineFamily.stabilityRate_spec),
    (`NumStability.FiniteDirectionalRepair.LineCoordinates, `NumStability.FiniteCoordinate.LineCoordinates),
    (`NumStability.FiniteDirectionalRepair.LineCoordinates.extract, `NumStability.FiniteCoordinate.LineCoordinates.extract),
    (`NumStability.FiniteDirectionalRepair.LineCoordinates.extract_cell, `NumStability.FiniteCoordinate.LineCoordinates.extract_cell),
    (`NumStability.FiniteDirectionalRepair.LineCoordinates.extract_local, `NumStability.FiniteCoordinate.LineCoordinates.extract_local),
    (`NumStability.FiniteDirectionalRepair.LineRealization, `NumStability.FiniteCoordinate.LineRealization),
    (`NumStability.FiniteDirectionalRepair.LineRealization.rule, `NumStability.FiniteCoordinate.LineRealization.rule),
    (`NumStability.FiniteDirectionalRepair.LineRealization.Admitted, `NumStability.FiniteCoordinate.LineRealization.Admitted),
    (`NumStability.FiniteDirectionalRepair.LineRealization.advance_eq, `NumStability.FiniteCoordinate.LineRealization.advance_eq),
    (`NumStability.DirectionalPropagationRepair.execution, `NumStability.SequentialError.execution),
    (`NumStability.DirectionalPropagationRepair.errorBudget, `NumStability.SequentialError.errorBudget),
    (`NumStability.DirectionalPropagationRepair.execution_error_le, `NumStability.SequentialError.execution_error_le),
    (`NumStability.DirectionalPropagationRepair.execution_error_le_upto, `NumStability.SequentialError.execution_error_le_upto),
    (`NumStability.DirectionalPropagationRepair.errorBudget_uniform_le, `NumStability.SequentialError.errorBudget_uniform_le),
    (`NumStability.FiniteDirectionalRepair.LineCoordinates.extract_error_le, `NumStability.FiniteCoordinate.LineCoordinates.extract_error_le),
    (`NumStability.FiniteDirectionalRepair.LineRealization.coordinate_stability, `NumStability.FiniteCoordinate.LineRealization.coordinate_stability),
    (`NumStability.FiniteDirectionalRepair.LineRealization.coordinate_local, `NumStability.FiniteCoordinate.LineRealization.coordinate_local),
    (`NumStability.FiniteDirectionalRepair.LineRealization.smooth_accuracy, `NumStability.FiniteCoordinate.LineRealization.smooth_accuracy),
    (`NumStability.FiniteDirectionalRepair.shared_face_cancels, `NumStability.FiniteCoordinate.shared_face_cancels),
    (`NumStability.FiniteDirectionalRepair.coordinateStep, `NumStability.FiniteCoordinate.coordinateStep),
    (`NumStability.FiniteDirectionalRepair.coordinateExecution, `NumStability.FiniteCoordinate.coordinateExecution),
    (`NumStability.FiniteDirectionalRepair.coordinateExecution_succ, `NumStability.FiniteCoordinate.coordinateExecution_succ),
    (`NumStability.FiniteDirectionalRepair.coordinateExecution_ordered, `NumStability.FiniteCoordinate.coordinateExecution_ordered),
    (`NumStability.FiniteDirectionalRepair.coordinateExecution_physical_error, `NumStability.FiniteCoordinate.coordinateExecution_physical_error),
    (`NumStability.CartesianProjectionRepair.integral_cellBox_projection, `NumStability.CartesianGrid.integral_cellBox_projection),
    (`NumStability.CartesianProjectionRepair.cellVolumeAverage_projection, `NumStability.CartesianGrid.cellVolumeAverage_projection),
    (`NumStability.FiniteCartesianDraft.axis_right_eq_next_left, `NumStability.FiniteCartesian.axis_right_eq_next_left),
    (`NumStability.FiniteCartesianDraft.axis_left_strictMono, `NumStability.FiniteCartesian.axis_left_strictMono),
    (`NumStability.FiniteCartesianDraft.axis_index_unique, `NumStability.FiniteCartesian.axis_index_unique),
    (`NumStability.FiniteCartesianDraft.cellBox_disjoint, `NumStability.FiniteCartesian.cellBox_disjoint),
    (`NumStability.FiniteCartesianDraft.cellBox_measurable, `NumStability.FiniteCartesian.cellBox_measurable),
    (`NumStability.FiniteCartesianDraft.tangentialFaceBox_measurable, `NumStability.FiniteCartesian.tangentialFaceBox_measurable),
    (`NumStability.FiniteCartesianDraft.cells, `NumStability.FiniteCartesian.cells),
    (`NumStability.FiniteCartesianDraft.facePoint_measurable, `NumStability.FiniteCartesian.facePoint_measurable),
    (`NumStability.FiniteCartesianDraft.faceMeasure, `NumStability.FiniteCartesian.faceMeasure),
    (`NumStability.FiniteCartesianDraft.left_face_in_closure, `NumStability.FiniteCartesian.left_face_in_closure),
    (`NumStability.FiniteCartesianDraft.right_face_in_closure, `NumStability.FiniteCartesian.right_face_in_closure),
    (`NumStability.FiniteCartesianDraft.left_face_ae_incidence, `NumStability.FiniteCartesian.left_face_ae_incidence),
    (`NumStability.FiniteCartesianDraft.right_face_ae_incidence, `NumStability.FiniteCartesian.right_face_ae_incidence),
    (`NumStability.FiniteCartesianDraft.data, `NumStability.FiniteCartesian.data),
    (`NumStability.FiniteCartesianDraft.data_cell_measure, `NumStability.FiniteCartesian.data_cell_measure),
    (`NumStability.FiniteCartesianDraft.data_cellVolume, `NumStability.FiniteCartesian.data_cellVolume),
    (`NumStability.FiniteCartesianDraft.data_face_measure, `NumStability.FiniteCartesian.data_face_measure),
    (`NumStability.FiniteCartesianDraft.data_shared_face, `NumStability.FiniteCartesian.data_shared_face),
    (`NumStability.FiniteCartesianDraft.data_left_position, `NumStability.FiniteCartesian.data_left_position),
    (`NumStability.FiniteCartesianDraft.data_right_position, `NumStability.FiniteCartesian.data_right_position),
    (`NumStability.FiniteCartesianDraft.data_face_measurable, `NumStability.FiniteCartesian.data_face_measurable),
    (`NumStability.FiniteCartesianDraft.data_normal_flux, `NumStability.FiniteCartesian.data_normal_flux),
    (`NumStability.FiniteCartesianDraft.faceMeasure_area, `NumStability.FiniteCartesian.faceMeasure_area),
    (`NumStability.FiniteCartesianRepair.CartesianIdentification, `NumStability.FiniteCartesian.CartesianIdentification),
    (`NumStability.FiniteCartesianRepair.CartesianIdentification.cellVolume_eq, `NumStability.FiniteCartesian.CartesianIdentification.cellVolume_eq),
    (`NumStability.FiniteCartesianRepair.CartesianIdentification.cellMean_eq, `NumStability.FiniteCartesian.CartesianIdentification.cellMean_eq),
    (`NumStability.FiniteCartesianRepair.CartesianIdentification.faceFlux_eq, `NumStability.FiniteCartesian.CartesianIdentification.faceFlux_eq),
    (`NumStability.FiniteCartesianRepair.CartesianIdentification.cellMean_lift, `NumStability.FiniteCartesian.CartesianIdentification.cellMean_lift),
    (`NumStability.FiniteCartesianRepair.CartesianIdentification.faceFlux_lift, `NumStability.FiniteCartesian.CartesianIdentification.faceFlux_lift),
    (`NumStability.FiniteCartesianRepair.CartesianIdentification.rectangle_balance_lift, `NumStability.FiniteCartesian.CartesianIdentification.rectangle_balance_lift),
    (`DimLocalCharacteristicWitness.local_integral_hasDerivAt, `NumStability.LocalLinearAdvection.local_integral_hasDerivAt),
    (`DimLocalCharacteristicWitness.eq_zero_of_local_integrals, `NumStability.LocalLinearAdvection.eq_zero_of_local_integrals),
    (`DimLocalCharacteristicWitness.qt, `NumStability.LocalLinearAdvection.qt),
    (`DimLocalCharacteristicWitness.qx, `NumStability.LocalLinearAdvection.qx),
    (`DimLocalCharacteristicWitness.partial_time, `NumStability.LocalLinearAdvection.partial_time),
    (`DimLocalCharacteristicWitness.partial_space, `NumStability.LocalLinearAdvection.partial_space),
    (`DimLocalCharacteristicWitness.smooth_reference_interior, `NumStability.LocalLinearAdvection.smooth_reference_interior),
    (`DimLocalCharacteristicWitness.interior_partials_continuous, `NumStability.LocalLinearAdvection.interior_partials_continuous),
    (`DimLocalCharacteristicWitness.interior_differentiableAt, `NumStability.LocalLinearAdvection.interior_differentiableAt),
    (`DimLocalCharacteristicWitness.interior_mass_derivative, `NumStability.LocalLinearAdvection.interior_mass_derivative),
    (`DimLocalCharacteristicWitness.rectangle_mass_derivative, `NumStability.LocalLinearAdvection.rectangle_mass_derivative),
    (`DimLocalCharacteristicWitness.interior_classical, `NumStability.LocalLinearAdvection.interior_classical),
    (`DimLocalCharacteristicWitness.characteristic_propagation, `NumStability.LocalLinearAdvection.characteristic_propagation),
    (`DimLocalCharacteristicWitness.local_cell_average_shift, `NumStability.LocalLinearAdvection.local_cell_average_shift),
    (`CFL1RefinementWitness.grid, `NumStability.CFLUnitShift.grid),
    (`CFL1RefinementWitness.grid_volume, `NumStability.CFLUnitShift.grid_volume),
    (`CFL1RefinementWitness.advance, `NumStability.CFLUnitShift.advance),
    (`CFL1RefinementWitness.advance_eq_shift, `NumStability.CFLUnitShift.advance_eq_shift),
    (`CFL1RefinementWitness.averaged, `NumStability.CFLUnitShift.averaged),
    (`CFL1RefinementWitness.averaged_eq_shift, `NumStability.CFLUnitShift.averaged_eq_shift),
    (`CFL1RefinementWitness.advance_averaged_exact, `NumStability.CFLUnitShift.advance_averaged_exact),
    (`CFL1RefinementWitness.averaged_is_cell_average, `NumStability.CFLUnitShift.averaged_is_cell_average),
    (`CFL1RefinementWitness.translated_is_conserved, `NumStability.CFLUnitShift.translated_is_conserved),
    (`CFL1RefinementWitness.physical_exactness, `NumStability.CFLUnitShift.physical_exactness),
    (`CFL1RefinementWitness.window, `NumStability.CFLUnitShift.window),
    (`CFL1RefinementWitness.advance_window, `NumStability.CFLUnitShift.advance_window),
    (`CFL1RefinementWitness.windowTV, `NumStability.CFLUnitShift.windowTV),
    (`CFL1RefinementWitness.advance_windowTV, `NumStability.CFLUnitShift.advance_windowTV),
    (`CFL1RefinementWitness.advance_no_overshoot, `NumStability.CFLUnitShift.advance_no_overshoot),
    (`CFL1RefinementWitness.advance_preserves_monotone, `NumStability.CFLUnitShift.advance_preserves_monotone),
    (`CFL1RefinementWitness.meshSize, `NumStability.CFLUnitShift.meshSize),
    (`CFL1RefinementWitness.meshSize_pos, `NumStability.CFLUnitShift.meshSize_pos),
    (`CFL1RefinementWitness.meshSize_tendsto_zero, `NumStability.CFLUnitShift.meshSize_tendsto_zero),
    (`CFL1RefinementWitness.flux_locality, `NumStability.CFLUnitShift.flux_locality),
    (`CFL1RefinementWitness.advance_extension_independent, `NumStability.CFLUnitShift.advance_extension_independent),
    (`CFL1RefinementWitness.refinement_accuracy, `NumStability.CFLUnitShift.refinement_accuracy),
    (`CFL1RefinementWitness.refinement_oscillation, `NumStability.CFLUnitShift.refinement_oscillation),
    (`CFL1RefinementWitness.smoothProfile, `NumStability.CFLUnitShift.smoothProfile),
    (`CFL1RefinementWitness.smoothProfile_smooth, `NumStability.CFLUnitShift.smoothProfile_smooth),
    (`CFL1RefinementWitness.smoothProfile_integrable, `NumStability.CFLUnitShift.smoothProfile_integrable),
    (`CFL1RefinementWitness.smoothProfile_nonconstant, `NumStability.CFLUnitShift.smoothProfile_nonconstant),
    (`CFL1RefinementWitness.stepProfile, `NumStability.CFLUnitShift.stepProfile),
    (`CFL1RefinementWitness.stepProfile_integrable, `NumStability.CFLUnitShift.stepProfile_integrable),
    (`CFL1RefinementWitness.stepProfile_discontinuous, `NumStability.CFLUnitShift.stepProfile_discontinuous),
    (`CFL1RefinementWitness.smooth_refinement, `NumStability.CFLUnitShift.smooth_refinement),
    (`CFL1RefinementWitness.step_refinement, `NumStability.CFLUnitShift.step_refinement),
    (`DimLocalCharacteristicWitness.local_cfl1_exact, `NumStability.LocalLinearAdvection.local_cfl1_exact),
    (`DimLocalCharacteristicWitness.local_cfl1_exact_of_projection, `NumStability.LocalLinearAdvection.local_cfl1_exact_of_projection),
    (`DimLocalCharacteristicWitness.local_refinement_zero_defect, `NumStability.LocalLinearAdvection.local_refinement_zero_defect),
    (`CFL1QualityFamilyWitness.h, `NumStability.HighResolutionAdvectionLine.h),
    (`CFL1QualityFamilyWitness.h_pos, `NumStability.HighResolutionAdvectionLine.h_pos),
    (`CFL1QualityFamilyWitness.h_eq, `NumStability.HighResolutionAdvectionLine.h_eq),
    (`CFL1QualityFamilyWitness.h_mul, `NumStability.HighResolutionAdvectionLine.h_mul),
    (`CFL1QualityFamilyWitness.h_le_half, `NumStability.HighResolutionAdvectionLine.h_le_half),
    (`CFL1QualityFamilyWitness.h_tendsto_zero, `NumStability.HighResolutionAdvectionLine.h_tendsto_zero),
    (`CFL1QualityFamilyWitness.input_geometry, `NumStability.HighResolutionAdvectionLine.input_geometry),
    (`CFL1QualityFamilyWitness.active_coverage, `NumStability.HighResolutionAdvectionLine.active_coverage),
    (`CFL1QualityFamilyWitness.family, `NumStability.HighResolutionAdvectionLine.family),
    (`CFL1QualityFamilyWitness.family_advance, `NumStability.HighResolutionAdvectionLine.family_advance),
    (`CFL1QualityFamilyWitness.family_quality, `NumStability.HighResolutionAdvectionLine.family_quality),
    (`CFL1QualityFamilyWitness.smooth_local_reference, `NumStability.HighResolutionAdvectionLine.smooth_local_reference),
    (`CFL1QualityFamilyWitness.smooth_initial_projection, `NumStability.HighResolutionAdvectionLine.smooth_initial_projection),
    (`CFL1QualityFamilyWitness.step_local_reference, `NumStability.HighResolutionAdvectionLine.step_local_reference),
    (`CFL1QualityFamilyWitness.scalar_family_exists, `NumStability.HighResolutionAdvectionLine.scalar_family_exists),
    (`NumStability.DirectionalCompleteRepair.coordinate_highResolution_sourceContract, `NumStability.HighResolutionCoordinateSweep.coordinate_highResolution_specification)]
  let rewriteName := fun name =>
    let exact := pairs.find? (fun p => p.1 == name)
    match exact with
    | some p => p.2
    | none =>
      match pairs.find? (fun p => p.1.isPrefixOf name) with
      | some p => name.replacePrefix p.1 p.2
      | none => name
  let rewrite := fun (expr : Expr) => expr.replace fun sub =>
    match sub with
    | .const n ls => some (.const (rewriteName n) ls)
    | .proj n i e => some (.proj (rewriteName n) i e)
    | _ => none
  for (oldName, newName) in pairs do
    let oldInfo ← getConstInfo oldName
    let newInfo ← getConstInfo newName
    unless oldInfo.levelParams.length == newInfo.levelParams.length do
      throwError "universe arity mismatch {oldName} -> {newName}"
    let levels := (List.range newInfo.levelParams.length).map fun i => Level.param (Name.mkSimple s!"placementLevel{i}")
    let oldType := rewrite (oldInfo.type.instantiateLevelParams oldInfo.levelParams levels)
    let newType := newInfo.type.instantiateLevelParams newInfo.levelParams levels
    unless ← isDefEq oldType newType do
      throwError "type mismatch after explicit nominal-name transport: {oldName} -> {newName}\n{oldType}\n{newType}"
    logInfo m!"TYPE_TRANSPORT_OK {oldName} -> {newName}"
