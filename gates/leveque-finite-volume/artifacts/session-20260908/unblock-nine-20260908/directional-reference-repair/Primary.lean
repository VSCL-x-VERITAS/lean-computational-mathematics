import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.Normed.Group.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.MeasureTheory.Integral.Pi

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

#check NumStability.FiniteDirectionalRepair.PhysicalData
#print axioms NumStability.FiniteDirectionalRepair.PhysicalData
#check NumStability.FiniteDirectionalRepair.PhysicalData.ReferenceOn
#print axioms NumStability.FiniteDirectionalRepair.PhysicalData.ReferenceOn
#check NumStability.FiniteDirectionalRepair.advance_mass_balance
#print axioms NumStability.FiniteDirectionalRepair.advance_mass_balance
#check NumStability.FiniteDirectionalRepair.finite_mass_balance
#print axioms NumStability.FiniteDirectionalRepair.finite_mass_balance
#check NumStability.FiniteDirectionalRepair.sweep_cons
#print axioms NumStability.FiniteDirectionalRepair.sweep_cons
#check NumStability.FiniteDirectionalRepair.sweep_split
#print axioms NumStability.FiniteDirectionalRepair.sweep_split
#check NumStability.FiniteDirectionalRepair.LineLocal
#print axioms NumStability.FiniteDirectionalRepair.LineLocal
#check NumStability.FiniteDirectionalRepair.advance_local
#print axioms NumStability.FiniteDirectionalRepair.advance_local
#check NumStability.FiniteDirectionalRepair.advance_error_le
#print axioms NumStability.FiniteDirectionalRepair.advance_error_le

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

#check NumStability.DirectionalQualityRepair.RectangleReferenceOn
#print axioms NumStability.DirectionalQualityRepair.RectangleReferenceOn
#check NumStability.DirectionalQualityRepair.SmoothReferenceOn
#print axioms NumStability.DirectionalQualityRepair.SmoothReferenceOn
#check NumStability.DirectionalQualityRepair.LineFamily
#print axioms NumStability.DirectionalQualityRepair.LineFamily
#check NumStability.DirectionalQualityRepair.LineFamily.HasControlledHighResolution
#print axioms NumStability.DirectionalQualityRepair.LineFamily.HasControlledHighResolution
#check NumStability.DirectionalQualityRepair.LineFamily.HasControlledHighResolution.perturbed_accuracy
#print axioms NumStability.DirectionalQualityRepair.LineFamily.HasControlledHighResolution.perturbed_accuracy
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
#check NumStability.FiniteDirectionalRepair.LineCoordinates
#print axioms NumStability.FiniteDirectionalRepair.LineCoordinates
#check NumStability.FiniteDirectionalRepair.LineCoordinates.extract_local
#print axioms NumStability.FiniteDirectionalRepair.LineCoordinates.extract_local
#check NumStability.FiniteDirectionalRepair.LineRealization
#print axioms NumStability.FiniteDirectionalRepair.LineRealization
#check NumStability.FiniteDirectionalRepair.LineRealization.advance_eq
#print axioms NumStability.FiniteDirectionalRepair.LineRealization.advance_eq
#check NumStability.FiniteDirectionalRepair.LineRealization.coordinate_stability
#print axioms NumStability.FiniteDirectionalRepair.LineRealization.coordinate_stability
#check NumStability.FiniteDirectionalRepair.LineRealization.coordinate_local
#print axioms NumStability.FiniteDirectionalRepair.LineRealization.coordinate_local
#check NumStability.FiniteDirectionalRepair.LineRealization.smooth_accuracy
#print axioms NumStability.FiniteDirectionalRepair.LineRealization.smooth_accuracy
#check NumStability.FiniteDirectionalRepair.shared_face_cancels
#print axioms NumStability.FiniteDirectionalRepair.shared_face_cancels
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
#check NumStability.DirectionalPropagationRepair.execution_error_le
#print axioms NumStability.DirectionalPropagationRepair.execution_error_le
#check NumStability.DirectionalPropagationRepair.errorBudget_uniform_le
#print axioms NumStability.DirectionalPropagationRepair.errorBudget_uniform_le
#check NumStability.DirectionalPropagationRepair.execution_error_le_upto
#print axioms NumStability.DirectionalPropagationRepair.execution_error_le_upto
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
#check NumStability.FiniteDirectionalRepair.coordinateExecution_ordered
#print axioms NumStability.FiniteDirectionalRepair.coordinateExecution_ordered
#check NumStability.FiniteDirectionalRepair.coordinateExecution_physical_error
#print axioms NumStability.FiniteDirectionalRepair.coordinateExecution_physical_error

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

#check NumStability.DirectionalGeometryRepair.CartesianIdentification.cellMean_lift
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification.cellMean_lift
#check NumStability.DirectionalGeometryRepair.CartesianIdentification.faceFlux_lift
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification.faceFlux_lift
#check NumStability.DirectionalGeometryRepair.CartesianIdentification.directional_reference_lift
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification.directional_reference_lift
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
#check NumStability.FiniteCartesianRepair.CartesianIdentification
#print axioms NumStability.FiniteCartesianRepair.CartesianIdentification
#check NumStability.FiniteCartesianRepair.CartesianIdentification.cellVolume_eq
#print axioms NumStability.FiniteCartesianRepair.CartesianIdentification.cellVolume_eq
#check NumStability.FiniteCartesianRepair.CartesianIdentification.faceFlux_lift
#print axioms NumStability.FiniteCartesianRepair.CartesianIdentification.faceFlux_lift
#check NumStability.FiniteCartesianRepair.CartesianIdentification.rectangle_balance_lift
#print axioms NumStability.FiniteCartesianRepair.CartesianIdentification.rectangle_balance_lift
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
#check NumStability.DirectionalCompleteRepair.coordinate_highResolution_sourceContract
#print axioms NumStability.DirectionalCompleteRepair.coordinate_highResolution_sourceContract
