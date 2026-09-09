/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Normed.Group.SequentialError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError

/-!
Locality, uniform constituent error bounds and actual finite successive-step error propagation.
-/

namespace NumStability.FiniteCoordinate
open DirectionalLine NumStability.LocalConservationLaw
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
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

end NumStability.FiniteCoordinate

namespace NumStability.FiniteCoordinate
open DirectionalLine SequentialError
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

end NumStability.FiniteCoordinate
