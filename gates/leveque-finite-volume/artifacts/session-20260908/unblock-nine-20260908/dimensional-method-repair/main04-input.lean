import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateCoordinateSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity

/-! Scratch only. Prospective directional numerical-method correspondence.
The independent physical reference supplies initial averages and physical flux
integrals; no hypothesis states an error bound for the numerical output.
No high-resolution, convergence, or exact multidimensional evolution is claimed.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability.DirectionalMethodRepair

variable {D : Type*} [DecidableEq D] {m : ℕ}

local notation "Cell" => D → ℤ
local notation "State" => Fin m → ℝ

/-- Independent control-volume conservation for the directional problem.
`mean` and `physical` describe a supplied physical reference, not the numerical
update. The main contract below realizes them by cell and face integrals. -/
def IsDirectionalReference (cellVolume : Cell → ℝ)
    (mean : Cell → ℝ → State) (physical : Cell → ℝ → State) (d : D) (s t : ℝ) : Prop :=
  (∀ cell, IntervalIntegrable (physical cell) volume s t) ∧
  ∀ cell, cellVolume cell • (mean cell t - mean cell s) =
    ∫ τ in s..t, physical cell τ - physical (Function.update cell d (cell d + 1)) τ

noncomputable def faceAverage (physical : Cell → ℝ → State) (s t : ℝ) (cell : Cell) : State :=
  oneDimensionalCellAverage (physical cell) s t

theorem reference_weighted_balance (cellVolume : Cell → ℝ)
    (mean : Cell → ℝ → State) (physical : Cell → ℝ → State) (d : D)
    {s t : ℝ} (h : IsDirectionalReference cellVolume mean physical d s t) (hst : s < t) (cell : Cell) :
    cellVolume cell • mean cell t = cellVolume cell • mean cell s +
      (t - s) • (faceAverage physical s t cell -
        faceAverage physical s t (Function.update cell d (cell d + 1))) := by
  have hleft := cellWidth_smul_oneDimensionalCellAverage (physical cell) hst
  have hright := cellWidth_smul_oneDimensionalCellAverage
    (physical (Function.update cell d (cell d + 1))) hst
  have hb := h.2 cell
  rw [intervalIntegral.integral_sub (h.1 cell)
    (h.1 (Function.update cell d (cell d + 1)))] at hb
  rw [smul_sub] at hb
  simpa only [faceAverage, smul_sub, hleft, hright] using (eq_add_of_sub_eq hb).trans (add_comm _ _)

/-- Numerical old-average and physical face-flux errors control the actual
coordinate update. The independent reference is fixed before the conclusion. -/
theorem advance_error_le (cellVolume : Cell → ℝ) (hvolume : ∀ cell, 0 < cellVolume cell)
    (rule : D → Cell → ℝ → (ℤ → State) → State)
    (d : D) (old : Cell → State) (mean : Cell → ℝ → State)
    (physical : Cell → ℝ → State) {s t : ℝ}
    (href : IsDirectionalReference cellVolume mean physical d s t)
    (hst : s < t) (cell : Cell) {oldBound leftBound rightBound : ℝ}
    (hold : ‖old cell - mean cell s‖ ≤ oldBound)
    (hleft : ‖CoordinateLineBalance.normalFaceFlux rule d (t - s) old cell -
      faceAverage physical s t cell‖ ≤ leftBound)
    (hright : ‖CoordinateLineBalance.normalFaceFlux rule d (t - s) old
        (Function.update cell d (cell d + 1)) -
      faceAverage physical s t (Function.update cell d (cell d + 1))‖ ≤ rightBound) :
    ‖CoordinateLineBalance.advance cellVolume rule d (t - s) old cell - mean cell t‖ ≤
      oldBound + (t - s) / cellVolume cell * (leftBound + rightBound) := by
  have hp := reference_weighted_balance cellVolume mean physical d href hst cell
  have hnum := CoordinateLineBalance.advance_mass_balance cellVolume hvolume rule d (t - s) old cell
  have hbalance : cellVolume cell •
      (CoordinateLineBalance.advance cellVolume rule d (t - s) old cell - mean cell t) =
      cellVolume cell • (old cell - mean cell s) + (t - s) •
        ((CoordinateLineBalance.normalFaceFlux rule d (t - s) old cell - faceAverage physical s t cell) -
         (CoordinateLineBalance.normalFaceFlux rule d (t - s) old (Function.update cell d (cell d + 1)) -
          faceAverage physical s t (Function.update cell d (cell d + 1)))) := by
    rw [smul_sub, hnum, hp]
    simp only [CoordinateLineBalance.netOutwardFlux]
    module
  have hn := congrArg norm hbalance
  have hineq : cellVolume cell *
      ‖CoordinateLineBalance.advance cellVolume rule d (t - s) old cell - mean cell t‖ ≤
      cellVolume cell * oldBound + (t - s) * (leftBound + rightBound) := by
    calc
      _ = ‖cellVolume cell •
        (CoordinateLineBalance.advance cellVolume rule d (t - s) old cell - mean cell t)‖ := by
          simp [norm_smul, abs_of_pos (hvolume cell)]
      _ = _ := hn
      _ ≤ ‖cellVolume cell • (old cell - mean cell s)‖ + ‖(t - s) •
        ((CoordinateLineBalance.normalFaceFlux rule d (t - s) old cell - faceAverage physical s t cell) -
         (CoordinateLineBalance.normalFaceFlux rule d (t - s) old (Function.update cell d (cell d + 1)) -
          faceAverage physical s t (Function.update cell d (cell d + 1))))‖ := norm_add_le _ _
      _ ≤ _ := by
        simp only [norm_smul, Real.norm_eq_abs, abs_of_pos (hvolume cell), abs_of_pos (sub_pos.mpr hst)]
        exact add_le_add (mul_le_mul_of_nonneg_left hold (hvolume cell).le)
          (mul_le_mul_of_nonneg_left ((norm_sub_le _ _).trans (add_le_add hleft hright))
            (sub_nonneg.mpr hst.le))
  apply (mul_le_mul_iff_right₀ (hvolume cell)).mp
  calc
    _ ≤ _ := hineq
    _ = cellVolume cell * (oldBound + (t - s) / cellVolume cell * (leftBound + rightBound)) := by
      field_simp [(hvolume cell).ne']

/-- A Cartesian directional reference is derived from a real rectangle PDE,
using actual axis-cell averages and area-weighted physical boundary fluxes. -/
theorem cartesian_reference [Fintype D] (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (flux : State → State)
    (q : ℝ → ℝ → State) (hq : IsRectangleConservationLawSolution q flux) (s t : ℝ) :
    IsDirectionalReference (CartesianGrid.cellVolume axes)
      (fun cell t => finiteVolumeCellAverageOn (axes d) (fun x => q x t) (cell d))
      (fun cell t => CartesianGrid.faceArea axes d cell •
        flux (q ((axes d).cellLeft (cell d)) t)) d s t := by
  refine ⟨?_, ?_⟩
  · intro cell
    exact (hq.2.1 _ s t).smul (CartesianGrid.faceArea axes d cell)
  · intro cell
    have hb := hq.2.2 ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d)) s t
    have hs := cellWidth_smul_oneDimensionalCellAverage
      (fun x => q x s) ((axes d).cell_nonempty (cell d))
    have ht := cellWidth_smul_oneDimensionalCellAverage
      (fun x => q x t) ((axes d).cell_nonempty (cell d))
    rw [CartesianGrid.cellVolume_eq_width_mul_area axes d cell]
    rw [mul_comm, mul_smul, smul_sub]
    simp only [finiteVolumeCellAverageOn, OneDimensionalFiniteVolumeGrid.cellVolume] at *
    rw [hs, ht, hb]
    simp only [Function.update_self, CartesianGrid.faceArea_update]
    rw [← (axes d).adjacent (cell d + 1)]
    simp only [add_sub_cancel_right]
    rw [← intervalIntegral.integral_smul]
    congr 1
    funext τ
    rw [smul_sub]

/-- Supplied physical cells and shared normal-face geometry, with actual
directional flux functions hyperbolic on declared admissible states.
No chart, Jacobian, boundary extension or geometry is inferred from indices. -/
structure PhysicalData (D Point FacePoint : Type*) [DecidableEq D]
    [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] (m : ℕ) where
  cells : FiniteVolumeCellPartition (D → ℤ) Point
  measure : Measure Point
  positive : ∀ cell, measure (cells.cellRegion cell) ≠ 0
  finite : ∀ cell, measure (cells.cellRegion cell) ≠ ⊤
  faceMeasure : D → (D → ℤ) → Measure FacePoint
  facePoint : D → (D → ℤ) → FacePoint → Point
  incidence : ∀ d cell point,
    facePoint d cell point ∈ closure (cells.cellRegion (Function.update cell d (cell d - 1))) ∧
    facePoint d cell point ∈ closure (cells.cellRegion cell)
  admissibleStates : D → Set (Fin m → ℝ)
  normalFlux : D → (D → ℤ) → FacePoint → (Fin m → ℝ) → (Fin m → ℝ)
  hyperbolic : ∀ d cell point, IsHyperbolicFluxOn (normalFlux d cell point) (admissibleStates d)

namespace PhysicalData

variable {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
  [MeasurableSpace FacePoint]
variable (data : PhysicalData D Point FacePoint m)

noncomputable def cellVolume (cell : Cell) : ℝ := (data.measure (data.cells.cellRegion cell)).toReal

theorem cellVolume_pos (cell : Cell) : 0 < data.cellVolume cell :=
  ENNReal.toReal_pos (data.positive cell) (data.finite cell)

noncomputable def cellMean (q : Point → ℝ → State) (cell : Cell) (t : ℝ) : State :=
  cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)

noncomputable def faceFlux (d : D) (q : Point → ℝ → State) (cell : Cell) (t : ℝ) : State :=
  ∫ point, data.normalFlux d cell point (q (data.facePoint d cell point) t) ∂data.faceMeasure d cell

/-- Actual physical-reference inputs on one finite directional substep.
They do not mention the numerical rule or its output. -/
def ReferenceOn (d : D) (q : Point → ℝ → State) (s t : ℝ) : Prop :=
  (∀ cell, ∀ τ ∈ Set.uIcc s t, IntegrableOn (fun x => q x τ) (data.cells.cellRegion cell) data.measure) ∧
  (∀ cell, ∀ τ ∈ Set.uIcc s t, Integrable
    (fun point => data.normalFlux d cell point (q (data.facePoint d cell point) τ)) (data.faceMeasure d cell)) ∧
  (∀ cell point, ∀ τ ∈ Set.uIcc s t, q (data.facePoint d cell point) τ ∈ data.admissibleStates d) ∧
  (∀ x ∈ data.cells.domain, ∀ τ ∈ Set.uIcc s t, q x τ ∈ data.admissibleStates d) ∧
  IsDirectionalReference data.cellVolume (data.cellMean q) (data.faceFlux d q) d s t

end PhysicalData

/-- One primary conjunction: actual directional flux/domain linkage and
physical reference, conservative prefix execution, conditional numerical
errors and the measured Cartesian realization of the same executor.
The caller supplies geometry and boundary extensions; no general coverage
or high-resolution/convergence assertion is hidden here. -/
theorem directional_splitting_contract
    {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] [Fintype D]
    (data : PhysicalData D Point FacePoint m)
    (hdimension : 0 < m)
    (rule : D → Cell → ℝ → (ℤ → State) → State)
    (admitted : D → Cell → ℝ → (ℤ → State) → Prop)
    (hconstant : ∀ d cell dt value, 0 < dt → value ∈ data.admissibleStates d →
      admitted d cell dt (fun _ => value) →
      Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell)
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hpositive : ∀ stage ∈ stages, 0 < stage.2)
    (initial : Cell → State)
    (reference : List (D × ℝ) → D → ℝ → Point → ℝ → State)
    (oldError faceError : List (D × ℝ) → D → ℝ → Cell → ℝ)
    (hreferences : ∀ before d dt after, stages = before ++ (d, dt) :: after →
      data.ReferenceOn d (reference before d dt) 0 dt)
    (hadmitted : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      admitted d cell dt (fun j => CoordinateLineBalance.sweep data.cellVolume rule before initial
        (Function.update cell d j)))
    (hstates : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      CoordinateLineBalance.sweep data.cellVolume rule before initial cell ∈ data.admissibleStates d)
    (hold : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.sweep data.cellVolume rule before initial cell -
        data.cellMean (reference before d dt) cell 0‖ ≤ oldError before d dt cell)
    (hface : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.normalFaceFlux rule d dt
          (CoordinateLineBalance.sweep data.cellVolume rule before initial) cell -
        faceAverage (data.faceFlux d (reference before d dt)) 0 dt cell‖ ≤ faceError before d dt cell) :
    0 < m ∧
    (∀ d cell point, IsHyperbolicFluxOn (data.normalFlux d cell point) (data.admissibleStates d)) ∧
    (∀ d cell dt value, 0 < dt → value ∈ data.admissibleStates d →
      admitted d cell dt (fun _ => value) →
      Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell) ∧
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current := CoordinateLineBalance.sweep data.cellVolume rule before initial
      0 < dt ∧ data.ReferenceOn d (reference before d dt) 0 dt ∧
      (∀ cell, admitted d cell dt (fun j => current (Function.update cell d j))) ∧
      (∀ cell, current cell ∈ data.admissibleStates d) ∧
      CoordinateLineBalance.sweep data.cellVolume rule stages initial =
        CoordinateLineBalance.sweep data.cellVolume rule after
          (CoordinateLineBalance.advance data.cellVolume rule d dt current) ∧
      (∀ cell, data.cellVolume cell • CoordinateLineBalance.advance data.cellVolume rule d dt current cell =
        data.cellVolume cell • current cell - dt • CoordinateLineBalance.netOutwardFlux rule d dt current cell) ∧
      (∀ base start count,
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          CoordinateLineBalance.advance data.cellVolume rule d dt current (Function.update base d (start + k))) =
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          current (Function.update base d (start + k))) -
        dt • (CoordinateLineBalance.normalFaceFlux rule d dt current (Function.update base d (start + count)) -
          CoordinateLineBalance.normalFaceFlux rule d dt current (Function.update base d start))) ∧
      (∀ other base, (∀ j, current (Function.update base d j) = other (Function.update base d j)) →
        ∀ j, CoordinateLineBalance.advance data.cellVolume rule d dt current (Function.update base d j) =
          CoordinateLineBalance.advance data.cellVolume rule d dt other (Function.update base d j)) ∧
      ∀ cell, ‖CoordinateLineBalance.advance data.cellVolume rule d dt current cell -
          data.cellMean (reference before d dt) cell dt‖ ≤
        oldError before d dt cell + dt / data.cellVolume cell *
          (faceError before d dt cell + faceError before d dt (Function.update cell d (cell d + 1)))) ∧
    (∀ (axes : D → OneDimensionalFiniteVolumeGrid)
      (lineRule : D → Cell → ℝ → (ℤ → State) → State),
      data.cellVolume = CartesianGrid.cellVolume axes →
      rule = CartesianCoordinateUpdate.areaWeightedRule axes lineRule →
      (∀ cell, (volume (CartesianGrid.cellBox axes cell)).toReal = data.cellVolume cell) ∧
      (∀ d cell, (volume (CartesianGrid.tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell) ∧
      (∀ d dt state base,
        (fun j => CoordinateLineBalance.advance data.cellVolume rule d dt state (Function.update base d j)) =
        riemannFiniteVolumeUpdate (axes d) dt (fun j => state (Function.update base d j))
          (fun j => lineRule d (Function.update base d j) dt (fun k => state (Function.update base d k)))) ∧
      ∀ d (flux : State → State) (q : ℝ → ℝ → State), IsRectangleConservationLawSolution q flux → ∀ s t,
        IsDirectionalReference data.cellVolume
          (fun cell τ => finiteVolumeCellAverageOn (axes d) (fun x => q x τ) (cell d))
          (fun cell τ => CartesianGrid.faceArea axes d cell • flux (q ((axes d).cellLeft (cell d)) τ)) d s t) := by
  refine ⟨hdimension, data.hyperbolic, hconstant, hnonempty, hcover, ?_, ?_⟩
  · intro before d dt after hstages
    dsimp only
    have hdt : 0 < dt := hpositive (d, dt) (by rw [hstages]; simp)
    have href := hreferences before d dt after hstages
    refine ⟨hdt, href, hadmitted before d dt after hstages, hstates before d dt after hstages, ?_,
      CoordinateLineBalance.advance_mass_balance data.cellVolume data.cellVolume_pos rule d dt _,
      CoordinateLineBalance.finite_line_mass_balance data.cellVolume data.cellVolume_pos rule d dt _, ?_, ?_⟩
    · subst stages
      simp [CoordinateLineBalance.sweep, orderedOperatorSweep, List.foldl_append]
    · intro other base hline
      exact CoordinateLineBalance.advance_line_local data.cellVolume rule d dt _ other base hline
    · intro cell
      simpa only [sub_zero] using advance_error_le data.cellVolume data.cellVolume_pos rule d
        (CoordinateLineBalance.sweep data.cellVolume rule before initial)
        (data.cellMean (reference before d dt)) (data.faceFlux d (reference before d dt))
        href.2.2.2.2 hdt cell (hold before d dt after hstages cell)
        (by simpa using hface before d dt after hstages cell)
        (by simpa using hface before d dt after hstages (Function.update cell d (cell d + 1)))
  · intro axes lineRule hvolume hrule
    rw [hvolume, hrule]
    exact ⟨CartesianGrid.cellBox_volume axes, CartesianGrid.tangentialFaceBox_volume axes,
      CartesianCoordinateUpdate.cartesian_full_line_update axes lineRule,
      fun d flux q hq s t => cartesian_reference axes d flux q hq s t⟩

/-- The rejected coordinate-index flux cannot be constant-consistent with a
single fixed physical flux on unit-area faces, even at one admissible state. -/
theorem index_rule_not_constant_consistent (physical : (Fin 1 → ℝ) → Fin 1 → ℝ)
    (value : Fin 1 → ℝ) :
    ¬ ∀ cell : Fin 2 → ℤ, (fun _ : Fin 1 => (cell 0 : ℝ)) = physical value := by
  intro h
  have hzero := congrFun (h (fun _ => 0)) 0
  have hone := congrFun (h (fun _ => 1)) 0
  norm_num at hzero hone
  linarith

/-- The physical-reference premise has nonconstant examples in either of two
directions: a translated step supplies the actual rectangle conservation law.
This witness asserts no global convergence or multidimensional PDE evolution. -/
theorem nonconstant_cartesian_reference
    (axes : Fin 2 → OneDimensionalFiniteVolumeGrid) (d : Fin 2) (s t : ℝ) :
    ∃ q : ℝ → ℝ → Fin 1 → ℝ,
      q (-1) 0 = 0 ∧ q 1 0 = 1 ∧
      IsDirectionalReference (CartesianGrid.cellVolume axes)
        (fun cell τ => finiteVolumeCellAverageOn (axes d) (fun x => q x τ) (cell d))
        (fun cell τ => CartesianGrid.faceArea axes d cell • q ((axes d).cellLeft (cell d)) τ) d s t := by
  let q := StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1
  refine ⟨q, ?_, ?_, ?_⟩
  · simp [q, StationaryRiemannField.reference, riemannData]
  · simp [q, StationaryRiemannField.reference, riemannData]
  · have hq : IsRectangleConservationLawSolution q (fun state => state) := by
      have heq : (StationaryRiemannField.transportLaw (m := 1)).physicalFlux = (fun state => state) :=
        funext StationaryRiemannField.physicalFlux
      simpa only [heq] using
        StationaryRiemannField.reference_rectangle (0 : Fin 1 → ℝ) 1
    exact cartesian_reference axes d _ q hq s t

end NumStability.DirectionalMethodRepair
