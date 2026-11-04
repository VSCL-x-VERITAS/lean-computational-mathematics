/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REASeminormCertificate
import ComputationalMathematics.Source.LeVeque.Chapter04.REAGeneralPrescribedCertificateTarget

/-!
# Full proof-free REA target using direct field seminorms

All six original commitments remain. Only the representation-dependent generic
recipe and general matrix/quadratic stages use the direct criterion types.
The three representation-independent commitments are retained verbatim by
reference. The quadratic claim retains its existential prescribed criterion
and its equivalence on every input and endpoint.
-/

namespace NumStability.REA.SeminormRecipe
open MeasureTheory

/-- Same complete matrix realization, now in the direct-seminorm recipe. -/
def GeneralExactMatrixTarget : Prop :=
  ∀ (m : ℕ), 0 < m →
    ∀ (coefficient : Matrix (Fin m) (Fin m) ℝ),
    IsRealHyperbolicMatrix coefficient →
    ∀ (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ),
    (∀ k, coefficient.mulVec (basis k) = speeds k • basis k) →
    ∀ (old : ℤ → Fin m → ℝ) (origin width : ℝ) (hwidth : 0 < width)
      (step : ℝ), 0 < step →
    let grid := leveque04_uniformGrid origin width hwidth
    let reconstructed := leveque04_uniformReconstruction origin width old
    let evolved := linearCharacteristicEvolution basis speeds reconstructed
    let endpoint := fun x => evolved x step
    let next := fun j =>
      oneDimensionalCellAverage endpoint (grid.cellLeft j) (grid.cellRight j)
    Leveque04REAGridCoversLine grid ∧
      Leveque04REAReconstruction grid old reconstructed ∧
      leveque04_linearREAForwardIVP coefficient reconstructed step evolved ∧
      Stage (leveque04_linearREAForwardIVP coefficient) none grid old step next

/-- Preserve the original existential criterion and all-input/endpoint iff,
along with every scalar-data, grid and positive-horizon quantifier. -/
def QuadraticGeneralStageTarget : Prop :=
  ∀ speed curvature : ℝ,
    ∃ criterion : Criterion (ConservativeIVP (fun state : State 1 => speed • state)),
      (∀ (i : Input 1) (endpoint : Profile 1),
        Certificate criterion i endpoint ↔
          RectangleCertificate (fun state : State 1 => speed • state)
            (fun _ t => AdvectionTaylor.residualBudget speed curvature t) i endpoint) ∧
      ∀ (linear constant origin width : ℝ) (hwidth : 0 < width)
        (step : ℝ), 0 < step →
        let grid := leveque04_uniformGrid origin width hwidth
        let old := leveque04_quadraticREAOldMeans curvature linear constant grid
        let next := leveque04_quadraticREANextMeans speed curvature linear constant step grid
        Stage (ConservativeIVP (fun state : State 1 => speed • state))
          (some (ScalarTaylorProcedure speed criterion)) grid old step next

/-- Full original six-part boundary; no statement proof is supplied. -/
def FullTarget : Prop :=
  GenericRecipeTarget ∧ NumStability.REA.RetainedConcreteTarget ∧
    NumStability.REA.ActualEquationIdentificationTarget ∧ GeneralExactMatrixTarget ∧
    NumStability.REA.QuadraticWeakRectangleTarget ∧ QuadraticGeneralStageTarget

end NumStability.REA.SeminormRecipe
