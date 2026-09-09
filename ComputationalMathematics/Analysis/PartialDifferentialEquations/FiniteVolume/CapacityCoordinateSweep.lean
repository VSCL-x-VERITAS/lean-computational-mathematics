/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Normed.Group.SequentialError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalFluxError

/-!
# Ordered capacity sweeps with stage-dependent boundary data

One execution producer accepts the actual coordinate/method pair at each stage.
Mass balance retains exterior transfer, and locality concerns each current stage.
Physical error propagation separately assumes actual/reference admission, positive
durations, conditional stability, net flux defect and reference splitting defect.
The constant-coordinate case is a specialization of this producer.
-/

namespace NumStability.CapacityCoordinate.Sweep
open MeasureTheory NumStability NumStability.FiniteCoordinate NumStability.SequentialError NumStability.CapacityCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : ℕ → LineCoordinates (m := m) D Cell Face Line}

/-- The `n`-th stage operator of an ordered capacity sweep: one conservative finite-volume
`advance` of the whole cell array, using the face rule of that stage's own method `method n`
(a method for the stage coordinates `coord k` at `k = n`), in the sweep direction `direction n`
with the actual supplied time step `duration n`. Boundary/ghost data may change from stage to
stage through the stage method. -/
noncomputable def step (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (n : ℕ) : (Cell → State) → Cell → State :=
  advance data (method n).rule (direction n) (duration n)

/-- The actual ordered capacity execution with stage-dependent coordinates, methods, sweep
directions and time steps: `run method direction duration initial 0` is `initial`, and the array
after `n + 1` stages applies the stage operator `step method direction duration n` to the array
after `n` stages. By `run_ordered` this is the `orderedOperatorSweep` of the first `n` stage
operators, so the constant-coordinate sweep is the special case of a constant `coord`. -/
noncomputable def run (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) : ℕ → Cell → State :=
  execution (step method direction duration) initial

theorem run_succ (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) (n : ℕ) :
    run method direction duration initial (n + 1) =
      advance data (method n).rule (direction n) (duration n)
        (run method direction duration initial n) := rfl

theorem run_ordered (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) (n : ℕ) :
    run method direction duration initial n =
      orderedOperatorSweep ((List.range n).map (step method direction duration)) initial := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [run_succ, List.range_succ, List.map_append, orderedOperatorSweep]
    simp only [List.map_cons, List.map_nil, List.foldl_append, List.foldl_cons, List.foldl_nil]
    change step method direction duration n (run method direction duration initial n) =
      step method direction duration n
        (orderedOperatorSweep ((List.range n).map (step method direction duration)) initial)
    rw [ih]

/-- Actual ordered capacity execution, compared with physical measured cell
means. Stability, net physical-flux defect, and stage-reference mismatch remain
independent hypotheses. This theorem does not define a high-resolution class. -/
theorem run_physical_error (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) (physical : ℕ → Point → ℝ → State)
    (steps : ℕ) (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ)
    (netError : ℕ → Cell → ℝ)
    (hdt : ∀ n < steps, 0 < duration n)
    (href : ∀ n < steps, data.ReferenceOn (direction n) (physical n) 0 (duration n))
    (hinitial : ∀ cell, ‖initial cell - data.cellMean (physical 0) cell 0‖ ≤ initialError)
    (hactual : ∀ n < steps, (method n).Admitted (direction n) (duration n)
      (run method direction duration initial n))
    (hrefadmit : ∀ n < steps, (method n).Admitted (direction n) (duration n)
      (fun cell => data.cellMean (physical n) cell 0))
    (hstable : ∀ n < steps, (method n).StableAt (direction n) (duration n) (amplification n))
    (hnet : ∀ n < steps, ∀ cell,
      ‖NumStability.FiniteCoordinate.netFluxDefect data (method n).rule (direction n)
        (fun c => data.cellMean (physical n) c 0) (physical n) 0 (duration n) cell‖ ≤ netError n cell)
    (hlocal : ∀ n < steps, ∀ cell,
      duration n / data.cellVolume cell * netError n cell ≤ localDefect n)
    (hsplit : ∀ n < steps, ∀ cell,
      ‖data.cellMean (physical n) cell (duration n) -
        data.cellMean (physical (n + 1)) cell 0‖ ≤ splittingDefect n) :
    ∀ n ≤ steps, ∀ cell,
      ‖run method direction duration initial n cell - data.cellMean (physical n) cell 0‖ ≤
        errorBudget amplification localDefect splittingDefect initialError n := by
  apply execution_error_le_upto (step method direction duration)
    (fun n => (method n).Admitted (direction n) (duration n)) initial
    (fun n cell => data.cellMean (physical n) cell 0)
    (fun n cell => data.cellMean (physical n) cell (duration n))
    amplification localDefect splittingDefect initialError steps hinitial hactual hrefadmit
  · intro n hn current other hc ho E herr
    have hE : 0 ≤ E := (norm_nonneg _).trans (herr (Classical.choice data.cells.cells_nonempty))
    exact (method n).coordinate_stability (direction n) (duration n) (amplification n)
      (hstable n hn) current other hc ho hE herr
  · intro n hn cell
    have he := NumStability.FiniteCoordinate.advance_error_le_net data (method n).rule (direction n)
      (fun c => data.cellMean (physical n) c 0) (physical n) (href n hn) (hdt n hn) cell
      0 (netError n cell) (by simp) (hnet n hn cell)
    apply le_trans ?_ (hlocal n hn cell)
    simpa [step] using he
  · exact hsplit

end NumStability.CapacityCoordinate.Sweep

namespace NumStability.CapacityCoordinate.Sweep
open MeasureTheory NumStability NumStability.FiniteCoordinate NumStability.CapacityCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : ℕ → LineCoordinates (m := m) D Cell Face Line}

theorem run_zero (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) :
    run method direction duration initial 0 = initial := rfl

/-- Every stage applies its own capacity line operator to the actual preceding array. -/
theorem run_line_step (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) (k : ℕ) (cell : Cell) :
    run method direction duration initial (k + 1) cell =
      NumStability.FiniteCoordinate.PhysicalLine.lineAdvance data (coord k) (method k).numericalFlux (direction k)
        ((coord k).cellLine (direction k) cell) (duration k)
        ((coord k).extract (direction k) ((coord k).cellLine (direction k) cell)
          (run method direction duration initial k)) ((coord k).cellIndex (direction k) cell) := by
  rw [run_succ]
  exact (method k).advance_eq (direction k) (duration k) _ cell

/-- Conservation retains actual exterior transfer. No admission, quality,
stability or step-size hypothesis is needed for this identity. -/
theorem run_mass_balance [Fintype Cell] (method : ∀ k, Method data (coord k))
    (direction : ℕ → D) (duration : ℕ → ℝ) (initial : Cell → State) (k : ℕ) :
    (∑ cell, data.cellVolume cell • run method direction duration initial (k + 1) cell) =
      (∑ cell, data.cellVolume cell • run method direction duration initial k cell) -
        duration k • ∑ cell,
          ((method k).rule (direction k) (duration k) (run method direction duration initial k)
              (data.rightFace (direction k) cell) -
            (method k).rule (direction k) (duration k) (run method direction duration initial k)
              (data.leftFace (direction k) cell)) := by
  rw [run_succ]
  exact finite_mass_balance data (method k).rule (direction k) (duration k) _

/-- Stage-locality concerns the current stage's coordinate line and its fixed
supplied ghosts. It makes no claim about the entire composed initial stencil. -/
theorem step_coordinate_local (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (k : ℕ) (current other : Cell → State) (cell : Cell)
    (h : ∀ c, (coord k).cellLine (direction k) c = (coord k).cellLine (direction k) cell →
      current c = other c) :
    step method direction duration k current cell = step method direction duration k other cell :=
  (method k).coordinate_local (direction k) (duration k) current other cell h

theorem run_stage_local (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial otherInitial : Cell → State) (k : ℕ) (cell : Cell)
    (h : ∀ c, (coord k).cellLine (direction k) c = (coord k).cellLine (direction k) cell →
      run method direction duration initial k c = run method direction duration otherInitial k c) :
    run method direction duration initial (k + 1) cell =
      run method direction duration otherInitial (k + 1) cell := by
  rw [run_succ, run_succ]
  exact (method k).coordinate_local (direction k) (duration k) _ _ cell h

/-- Direct application to arbitrary stage-dependent ghost functions. The
original physical capacities and line maps remain fixed by withGhost. -/
theorem run_withGhost_line_step (base : LineCoordinates (m := m) D Cell Face Line)
    (method : ℕ → Method data base) (ghost : ℕ → D → Line → ℤ → State)
    (direction : ℕ → D) (duration : ℕ → ℝ) (initial : Cell → State) (k : ℕ) (cell : Cell) :
    run (fun n => (method n).withGhost (ghost n)) direction duration initial (k + 1) cell =
      NumStability.FiniteCoordinate.PhysicalLine.lineAdvance data base (method k).numericalFlux (direction k)
        (base.cellLine (direction k) cell) (duration k)
        ((base.withGhost (ghost k)).extract (direction k) (base.cellLine (direction k) cell)
          (run (fun n => (method n).withGhost (ghost n)) direction duration initial k))
        (base.cellIndex (direction k) cell) := by
  rw [run_succ]
  exact (method k).advance_withGhost_eq (ghost k) (direction k) (duration k) _ cell

end NumStability.CapacityCoordinate.Sweep
