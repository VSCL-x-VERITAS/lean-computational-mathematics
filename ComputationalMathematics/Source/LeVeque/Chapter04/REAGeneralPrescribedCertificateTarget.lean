/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAGeneralPrescribedCertificate

/-!
# General prescribed-certificate REA target

The primary recipe ranges over substantive mathematical error/residual
presentations. Actual exact matrix and nonexact scalar realizations remain.
Positive-rectangle orientation and explicit defect formulas are separate support
propositions. This file supplies no proof or validation of arbitrary PDE data.
-/

namespace NumStability.REA

open MeasureTheory

/-- The existing three concrete commitments, preserved literally as support. -/
def RetainedConcreteTarget : Prop :=
  (∀ (m : ℕ), 0 < m →
    ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ),
    IsRealHyperbolicMatrix coefficient →
    ∀ (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ),
    (∀ p, coefficient.mulVec (basis p) = speeds p • basis p) →
    ∀ (old : ℤ → Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
      (timeStep : ℝ), 0 < timeStep →
    let grid := leveque04_uniformGrid origin width hwidth
    let reconstructed := leveque04_uniformReconstruction origin width old
    let evolved := linearCharacteristicEvolution basis speeds reconstructed
    let endpoint := fun x => evolved x timeStep
    let next := fun i =>
      oneDimensionalCellAverage endpoint (grid.cellLeft i) (grid.cellRight i)
    Leveque04REAGridCoversLine grid ∧
      Leveque04REAReconstruction grid old reconstructed ∧
      leveque04_linearREAForwardIVP coefficient reconstructed timeStep evolved ∧
      Leveque04CertifiedREAStageFor (leveque04_linearREAForwardIVP coefficient)
        none grid old timeStep next) ∧
  (∀ speed : ℝ,
    (∀ state : Fin 1 → ℝ,
      (leveque04_scalarAdvectionMatrix speed).mulVec state = speed • state) ∧
    leveque04_scalarAdvectionForwardIVP speed =
      leveque04_linearREAForwardIVP (leveque04_scalarAdvectionMatrix speed)) ∧
  (∀ (speed curvature linear constant origin width : ℝ) (hwidth : 0 < width)
    (timeStep : ℝ), 0 < timeStep →
    let grid := leveque04_uniformGrid origin width hwidth
    let reconstructed := leveque04_quadraticREAReconstruction curvature linear constant
    let endpoint := leveque04_quadraticREAEndpoint speed curvature linear constant timeStep
    let reference := leveque04_quadraticREAReference speed curvature linear constant
    let procedure := leveque04_scalarTaylorProcedure speed curvature
    let old := leveque04_quadraticREAOldMeans curvature linear constant grid
    let next := leveque04_quadraticREANextMeans speed curvature linear constant timeStep grid
    let referenceNext := fun i => oneDimensionalCellAverage
      (fun x => reference x timeStep) (grid.cellLeft i) (grid.cellRight i)
    Leveque04REAGridCoversLine grid ∧
    Leveque04REAReconstruction grid old reconstructed ∧
    (∀ i, IntervalIntegrable endpoint volume (grid.cellLeft i) (grid.cellRight i)) ∧
    procedure.execute grid reconstructed timeStep = some endpoint ∧
    Leveque04REAPrescribedCertificate procedure.criterion grid reconstructed timeStep endpoint ∧
    Leveque04REAPrescribedCertificate
      (.reference (leveque04_scalarAdvectionForwardIVP speed)
        (fun _ _ step => AdvectionTaylor.endpointBudget speed curvature step))
      grid reconstructed timeStep endpoint ∧
    leveque04_scalarAdvectionForwardIVP speed reconstructed timeStep reference ∧
    Leveque04CertifiedREAStageFor (leveque04_scalarAdvectionForwardIVP speed)
      (some procedure) grid old timeStep next ∧
    (∀ x, endpoint x 0 - reference x timeStep 0 =
      -curvature * speed ^ 2 * timeStep ^ 2) ∧
    (∀ i, next i - referenceNext i = fun _ => -curvature * speed ^ 2 * timeStep ^ 2) ∧
    (speed * curvature ≠ 0 →
      (∀ x, endpoint x ≠ reference x timeStep) ∧
      ∀ i, next i ≠ referenceNext i))

/-- Proposed full statement, conditional on actual mathematical presentations.
The exact old cases remain; the generic recipe is no longer their closed catalogue.
No proof or physical authentication of arbitrary presentations is supplied. -/
def GeneralPrescribedCertificateTarget : Prop :=
  GenericRecipeTarget ∧ RetainedConcreteTarget ∧
    ActualEquationIdentificationTarget ∧ GeneralExactMatrixTarget ∧
    QuadraticWeakRectangleTarget ∧ QuadraticGeneralStageTarget

/-- Separate DERIVED support obligations, not extra printed parent assertions. -/
def DerivedRectangleSupportTargets : Prop :=
  (∀ (m : ℕ), 0 < m → ∀ flux : State m → State m,
    PositiveRectangleCompatibility flux) ∧ QuadraticRectangleFormulaTarget

end NumStability.REA
