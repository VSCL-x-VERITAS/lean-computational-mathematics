/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality

/-!
# High-resolution coordinate execution on supplied physical meshes

The selected level executes its actual capacity methods in the supplied order.
Valid substeps record positive within-horizon durations and admission of the actual
intermediate arrays. Bare algebraic execution stays available independently.
Conservation retains boundary transfer. Stability and physical reference-error estimates
are explicit conditional observations, not restrictions on core quality. Cartesian
identifications concern the same data; supplied directional balances are not asserted
to be equivalent to an unsplit continuum PDE or a universal geometric construction.
-/

namespace NumStability.PhysicalHighResolutionSweep
open MeasureTheory NumStability NumStability.FiniteCoordinate NumStability.SequentialError
open scoped BigOperators
variable {D FacePoint : Type*} [Fintype D] [DecidableEq D] [MeasurableSpace FacePoint] {m : ℕ}
local notation "Point" => D → ℝ
local notation "State" => Fin m → ℝ
variable (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m)

/-- The line coordinates of refinement level `level` with the supplied numerical ghost values
replaced by the stage-`k` boundary data `ghost k`. Only the ghost values change: the physical
cells, faces, coordinate lines and lookups of `family.coordinates level` are retained, so each
stage of a sweep may use its own boundary data on the same mesh. -/
def coordinates (level : ℕ) (ghost : ℕ → D → family.Line level → ℤ → State) (k : ℕ) :=
  (family.coordinates level).withGhost (ghost k)

/-- The supplied capacity line method of level `level`, re-indexed to the stage-`k`
coordinates `coordinates family level ghost k`. Its numerical-flux and admission functions are
exactly those of `family.method level`; only the ghost data seen through the coordinates
changes with the stage `k`. -/
def method (level : ℕ) (ghost : ℕ → D → family.Line level → ℤ → State) (k : ℕ) :
    NumStability.CapacityCoordinate.Method (family.data level) (coordinates family level ghost k) :=
  (family.method level).withGhost (ghost k)

/-- The ordered capacity sweep of level `level` on its actual physical mesh:
`execution family level direction duration ghost initial k` is the cell array after `k` stages,
where stage `n` advances the whole array in direction `direction n` with the actual time step
`duration n` using the stage method `method family level ghost n`, and stage `0` returns
`initial`. This is bare algebraic execution: no admission, stability or step-size hypothesis is
needed to define it. -/
noncomputable def execution (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → State) (initial : family.Cell level → State) :=
  NumStability.CapacityCoordinate.Sweep.run (method family level ghost) direction duration initial

/-- The supplied high-resolution family is executed on its actual selected
physical mesh. Quality, unconditional operator construction and conditional
analysis are separate fields. No stability assumption restricts construction. -/
structure Specification (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → State) (initial : family.Cell level → State)
    (steps : ℕ) : Prop where
  quality : family.HasHighResolution
  schedule : ∀ d : D, ∃ k < steps, direction k = d
  ordered : ∀ k ≤ steps, execution family level direction duration ghost initial k =
    orderedOperatorSweep ((List.range k).map
      (NumStability.CapacityCoordinate.Sweep.step (method family level ghost) direction duration)) initial
  constituent : ∀ k < steps, ∀ cell,
    execution family level direction duration ghost initial (k + 1) cell =
      NumStability.FiniteCoordinate.PhysicalLine.lineAdvance (family.data level) (family.coordinates level)
        (family.method level).numericalFlux (direction k)
        ((family.coordinates level).cellLine (direction k) cell) (duration k)
        (((family.coordinates level).withGhost (ghost k)).extract (direction k)
          ((family.coordinates level).cellLine (direction k) cell)
          (execution family level direction duration ghost initial k))
        ((family.coordinates level).cellIndex (direction k) cell)
  conservative : ∀ k < steps, (by
    letI := family.finiteCell level
    exact (∑ cell, (family.data level).cellVolume cell •
      execution family level direction duration ghost initial (k + 1) cell) =
      (∑ cell, (family.data level).cellVolume cell •
        execution family level direction duration ghost initial k cell) - duration k •
      ∑ cell,
        ((method family level ghost k).rule (direction k) (duration k)
          (execution family level direction duration ghost initial k)
          ((family.data level).rightFace (direction k) cell) -
        (method family level ghost k).rule (direction k) (duration k)
          (execution family level direction duration ghost initial k)
          ((family.data level).leftFace (direction k) cell)))
  line_local : ∀ k < steps, ∀ cell current other,
    (∀ c, (family.coordinates level).cellLine (direction k) c =
      (family.coordinates level).cellLine (direction k) cell → current c = other c) →
    advance (family.data level) (method family level ghost k).rule (direction k) (duration k)
      current cell =
    advance (family.data level) (method family level ghost k).rule (direction k) (duration k)
      other cell
  accuracy : ∀ d (q : Point → ℝ → State) (p : ℝ)
    (certificate : family.AccuracyCertificate d q p),
    ∀ n, certificate.threshold ≤ n → ∀ dt : ℝ, 0 < dt → dt ≤ family.horizon →
    ∀ boundary : D → family.Line n → ℤ → State, ∀ current : family.Cell n → State,
    ((family.method n).withGhost boundary).Admitted d dt current →
    ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
      (family.projected n q 0) →
    ∀ A E G : ℝ, (family.method n).StableAt d dt A →
    (∀ cell, ‖current cell - family.projected n q 0 cell‖ ≤ E) →
    (∀ cell j,
      (family.coordinates n).lookup d ((family.coordinates n).cellLine d cell) j = none →
      ‖boundary d ((family.coordinates n).cellLine d cell) j -
        family.referenceGhost n q d ((family.coordinates n).cellLine d cell) j‖ ≤ G) →
    ∀ cell,
    ‖advance (family.data n) ((family.method n).withGhost boundary).rule d dt current cell -
      family.projected n q dt cell‖ ≤
        A * max E G + certificate.constant * dt * family.mesh n ^ p
  physical_error : ∀ (physical : ℕ → Point → ℝ → State)
    (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ)
    (netError : ℕ → family.Cell level → ℝ),
    (∀ k < steps, 0 < duration k) →
    (∀ k < steps, (family.data level).ReferenceOn (direction k) (physical k) 0 (duration k)) →
    (∀ cell, ‖initial cell - (family.data level).cellMean (physical 0) cell 0‖ ≤ initialError) →
    (∀ k < steps, (method family level ghost k).Admitted (direction k) (duration k)
      (execution family level direction duration ghost initial k)) →
    (∀ k < steps, (method family level ghost k).Admitted (direction k) (duration k)
      (fun cell => (family.data level).cellMean (physical k) cell 0)) →
    (∀ k < steps, (method family level ghost k).StableAt (direction k) (duration k) (amplification k)) →
    (∀ k < steps, ∀ cell,
      ‖NumStability.FiniteCoordinate.netFluxDefect (family.data level) (method family level ghost k).rule
        (direction k) (fun c => (family.data level).cellMean (physical k) c 0)
        (physical k) 0 (duration k) cell‖ ≤ netError k cell) →
    (∀ k < steps, ∀ cell,
      duration k / (family.data level).cellVolume cell * netError k cell ≤ localDefect k) →
    (∀ k < steps, ∀ cell,
      ‖(family.data level).cellMean (physical k) cell (duration k) -
        (family.data level).cellMean (physical (k + 1)) cell 0‖ ≤ splittingDefect k) →
    ∀ k ≤ steps, ∀ cell,
      ‖execution family level direction duration ghost initial k cell -
        (family.data level).cellMean (physical k) cell 0‖ ≤
          errorBudget amplification localDefect splittingDefect initialError k
  cartesian : ∀ (axes : D → OneDimensionalFiniteVolumeGrid)
    (cellPosition : family.Cell level → D → ℤ)
    (facePosition : D → family.Face level → D → ℤ) (flux : D → State → State),
    FiniteCartesian.CartesianIdentification (family.data level) axes cellPosition facePosition flux →
    (∀ cell, (family.data level).cellVolume cell = CartesianGrid.cellVolume axes (cellPosition cell)) ∧
    (∀ (q : Point → ℝ → State) cell t, (family.data level).cellMean q cell t =
      cellVolumeAverage volume (CartesianGrid.cellBox axes (cellPosition cell)) (fun x => q x t)) ∧
    (∀ (q : ℝ → ℝ → State) d face t,
      (family.data level).faceFlux d (fun x τ => q (x d) τ) face t =
        CartesianGrid.faceArea axes d (facePosition d face) •
          flux d (q ((axes d).cellLeft (facePosition d face d)) t)) ∧
    (∀ (q : ℝ → ℝ → State) d, IsRectangleConservationLawSolution q (flux d) → ∀ cell s t,
      (family.data level).cellVolume cell •
        ((family.data level).cellMean (fun x τ => q (x d) τ) cell t -
          (family.data level).cellMean (fun x τ => q (x d) τ) cell s) =
        ∫ τ in s..t,
          (family.data level).faceFlux d (fun x σ => q (x d) σ)
            ((family.data level).leftFace d cell) τ -
          (family.data level).faceFlux d (fun x σ => q (x d) σ)
            ((family.data level).rightFace d cell) τ)

/-- Supplied high-resolution methods admit coordinate execution without
additional stability or common-area hypotheses. Error analysis is retained as
an explicit conditional component of the same construction. -/
theorem specification (quality : family.HasHighResolution)
    (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → State) (initial : family.Cell level → State)
    (steps : ℕ) (hschedule : ∀ d : D, ∃ k < steps, direction k = d) :
    Specification family level direction duration ghost initial steps := by
  refine {
    quality := quality
    schedule := hschedule
    ordered := ?_
    constituent := ?_
    conservative := ?_
    line_local := ?_
    accuracy := ?_
    physical_error := ?_
    cartesian := ?_ }
  · intro k _
    exact NumStability.CapacityCoordinate.Sweep.run_ordered (method family level ghost) direction duration initial k
  · intro k _ cell
    change advance (family.data level) ((family.method level).withGhost (ghost k)).rule
      (direction k) (duration k) (execution family level direction duration ghost initial k) cell = _
    exact (family.method level).advance_withGhost_eq (ghost k) (direction k) (duration k) _ cell
  · intro k _
    letI := family.finiteCell level
    exact finite_mass_balance (family.data level) (method family level ghost k).rule (direction k)
      (duration k) (execution family level direction duration ghost initial k)
  · intro k _ cell current other h
    exact (method family level ghost k).coordinate_local (direction k) (duration k) current other cell h
  · intro d q p certificate n hn dt hdt hT boundary current hactual hprojected A E G hstable hcell hghost cell
    exact NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.perturbed_at family certificate
      n hn dt hdt hT boundary current hactual hprojected
      A E G hstable hcell hghost cell
  · intro physical amplification localDefect splittingDefect initialError netError
      hdt href hinitial hactual hrefadmit hstable hnet hlocal hsplit
    exact NumStability.CapacityCoordinate.Sweep.run_physical_error (method family level ghost) direction duration initial
      physical steps amplification localDefect splittingDefect initialError netError
      hdt href hinitial hactual hrefadmit hstable hnet hlocal hsplit
  · intro axes cellPosition facePosition flux cart
    exact ⟨cart.cellVolume_eq, cart.cellMean_eq, cart.faceFlux_lift,
      fun q d hq cell s t => cart.rectangle_balance_lift q d hq cell s t⟩

end NumStability.PhysicalHighResolutionSweep



namespace NumStability.PhysicalHighResolutionSweep
open NumStability NumStability.FiniteCoordinate
variable {D FacePoint : Type*} [Fintype D] [DecidableEq D] [MeasurableSpace FacePoint] {m : ℕ}

/-- A particular numerical run uses positive substeps in the quality horizon
and the actual intermediate arrays belong to each method's admitted domain.
This is separate from the total algebraic coordinate-sweep construction. -/
def ValidSubsteps (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m)
    (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → Fin m → ℝ)
    (initial : family.Cell level → Fin m → ℝ) (steps : ℕ) : Prop :=
  ∀ k < steps, 0 < duration k ∧ duration k ≤ family.horizon ∧
    (method family level ghost k).Admitted (direction k) (duration k)
      (execution family level direction duration ghost initial k)

/-- The total construction specializes to an actual admitted coordinate run.
Stability is still confined to the conditional error analysis. -/
theorem admitted_specification (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m)
    (quality : family.HasHighResolution) (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → Fin m → ℝ)
    (initial : family.Cell level → Fin m → ℝ) (steps : ℕ)
    (hschedule : ∀ d : D, ∃ k < steps, direction k = d)
    (hvalid : ValidSubsteps family level direction duration ghost initial steps) :
    Specification family level direction duration ghost initial steps ∧
      ValidSubsteps family level direction duration ghost initial steps :=
  ⟨specification family quality level direction duration ghost initial steps hschedule, hvalid⟩

end NumStability.PhysicalHighResolutionSweep
