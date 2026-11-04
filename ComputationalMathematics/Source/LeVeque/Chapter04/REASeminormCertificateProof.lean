/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REASeminormCertificateTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.REASeminormRectangleCriterion
import ComputationalMathematics.Source.LeVeque.Chapter04.REAConcreteCertificateRealizations

/-!
# The prescribed-certificate reconstruct–evolve–average recipe

The full statement includes the generic supplied-IVP recipe, every retained
concrete conclusion, actual flux identification, the arbitrary-data exact
matrix realization and the nonexact quadratic weak-residual realization.
-/

noncomputable section
namespace NumStability.REA.SeminormRecipe
open MeasureTheory ConcreteRealization

theorem genericRecipe : GenericRecipeTarget := by
  intro m problem method grid old step next
  rfl

theorem actualEquationIdentification : ActualEquationIdentificationTarget :=
  ⟨fun _ _ => rfl, fun _ => rfl⟩

theorem generalExactMatrix : GeneralExactMatrixTarget := by
  intro m hm coefficient _hcoefficient basis speeds heigen old origin width hwidth step hstep
  dsimp only
  let grid := leveque04_uniformGrid origin width hwidth
  let R := leveque04_uniformReconstruction origin width old
  let W := linearCharacteristicEvolution basis speeds R
  let V := fun x => W x step
  have hgrid := uniformGrid_covers origin width hwidth
  have hR := uniformReconstruction origin width hwidth old
  have hW := uniformLinearIVP coefficient basis speeds heigen old origin width hwidth step
  have hV : ∀ j, IntervalIntegrable V volume (grid.cellLeft j) (grid.cellRight j) :=
    fun j => leveque04_linearUniformEvolution_intervalIntegrable
      basis speeds origin width hwidth old step _ _
  refine ⟨hgrid, hR, hW, hm, hstep, hgrid, R, V, hR, hV, ?_, fun _ => rfl⟩
  exact Or.inl ⟨W, hW, fun _ => rfl⟩

private theorem legacyStage_of_exact {m : ℕ} {problem : Leveque04ForwardIVP m}
    {grid : OneDimensionalFiniteVolumeGrid} {old next : ℤ → State m} {step : ℝ}
    (h : Stage problem none grid old step next) :
    Leveque04CertifiedREAStageFor problem none grid old step next := by
  rcases h with ⟨hm, hstep, hgrid, R, V, hR, hV, hend, hnext⟩
  refine ⟨hm, hstep, hgrid, R, V, hR, hV, ?_, hnext⟩
  rcases hend with ⟨W, hW, hWV⟩ | ⟨procedure, hnone, _hexec, _hcert⟩
  · exact Or.inl ⟨W, hW, hWV⟩
  · cases hnone

theorem retainedConcrete : NumStability.REA.RetainedConcreteTarget := by
  refine ⟨?_, ?_, ?_⟩
  · intro m hm coefficient hcoefficient basis speeds heigen old origin width hwidth step hstep
    rcases generalExactMatrix m hm coefficient hcoefficient basis speeds heigen old
      origin width hwidth step hstep with ⟨hg, hR, hW, hstage⟩
    exact ⟨hg, hR, hW, legacyStage_of_exact hstage⟩
  · intro speed
    have hflux : (leveque04_scalarAdvectionMatrix speed).mulVec =
        fun state : State 1 => speed • state := by
      funext state component
      have hcomponent : component = 0 := Subsingleton.elim _ _
      subst component
      simp [leveque04_scalarAdvectionMatrix, Matrix.mulVec, dotProduct, Pi.smul_apply]
    refine ⟨fun state => congrFun hflux state, ?_⟩
    change ConservativeIVP (fun state : State 1 => speed • state) =
      ConservativeIVP (leveque04_scalarAdvectionMatrix speed).mulVec
    rw [hflux]
  · intro speed curvature linear constant origin width hwidth step hstep
    dsimp only
    let grid := leveque04_uniformGrid origin width hwidth
    let R := leveque04_quadraticREAReconstruction curvature linear constant
    let V := leveque04_quadraticREAEndpoint speed curvature linear constant step
    let W := leveque04_quadraticREAReference speed curvature linear constant
    let procedure := leveque04_scalarTaylorProcedure speed curvature
    have hg := uniformGrid_covers origin width hwidth
    have hR := quadraticReconstruction curvature linear constant grid
    have hV : ∀ j, IntervalIntegrable V volume (grid.cellLeft j) (grid.cellRight j) :=
      fun j => quadraticEndpoint_integrable speed curvature linear constant step _ _
    have hexec := quadraticExecute speed curvature linear constant step grid
    have hcert := quadraticLegacyResidual speed curvature linear constant step grid
    have hrefcert := quadraticLegacyReference speed curvature linear constant step grid
    have hW := quadraticReference_IVP speed curvature linear constant step
    have hWI (j : ℤ) : IntervalIntegrable (fun x => W x step) volume
        (grid.cellLeft j) (grid.cellRight j) :=
      (hW.2 _ _).1 step ⟨hstep.le, le_rfl⟩
    have hstage : Leveque04CertifiedREAStageFor (leveque04_scalarAdvectionForwardIVP speed)
        (some procedure) grid
        (leveque04_quadraticREAOldMeans curvature linear constant grid) step
        (leveque04_quadraticREANextMeans speed curvature linear constant step grid) := by
      refine ⟨by decide, hstep, hg, R, V, hR, hV, ?_, fun _ => rfl⟩
      exact Or.inr ⟨procedure, rfl, hexec, hcert⟩
    have hmeans (j : ℤ) :
        leveque04_quadraticREANextMeans speed curvature linear constant step grid j -
          oneDimensionalCellAverage (fun x => W x step)
            (grid.cellLeft j) (grid.cellRight j) =
          fun _ => -curvature * speed ^ 2 * step ^ 2 := by
      funext component
      change oneDimensionalCellAverage V (grid.cellLeft j) (grid.cellRight j) component -
        oneDimensionalCellAverage (fun x => W x step)
          (grid.cellLeft j) (grid.cellRight j) component = _
      rw [oneDimensionalCellAverage_apply _ _ _ (hV j),
        oneDimensionalCellAverage_apply _ _ _ (hWI j)]
      exact AdvectionTaylor.quadraticTaylorPath_cellAverage_sub_reference
        speed curvature linear constant step _ _ (grid.cell_nonempty j)
    refine ⟨hg, hR, hV, hexec, hcert, hrefcert, hW, hstage,
      (fun x => AdvectionTaylor.quadraticTaylorPath_sub_reference
        speed curvature linear constant x step),
      hmeans, ?_⟩
    intro hproduct
    constructor
    · intro x heq
      exact AdvectionTaylor.quadraticTaylorPath_ne_reference
        speed curvature linear constant x step hproduct hstep (congrFun heq 0)
    · intro j heq
      have hc := congrFun heq 0
      change oneDimensionalCellAverage V (grid.cellLeft j) (grid.cellRight j) 0 =
        oneDimensionalCellAverage (fun x => W x step)
          (grid.cellLeft j) (grid.cellRight j) 0 at hc
      rw [oneDimensionalCellAverage_apply _ _ _ (hV j),
        oneDimensionalCellAverage_apply _ _ _ (hWI j)] at hc
      exact AdvectionTaylor.quadraticTaylorPath_cellAverage_ne_reference
        speed curvature linear constant step _ _ (grid.cell_nonempty j) hproduct hstep hc

theorem quadraticWeakRectangle : NumStability.REA.QuadraticWeakRectangleTarget := by
  intro speed curvature linear constant grid step hstep
  exact quadraticRectangleCertificate speed curvature linear constant step hstep grid

theorem quadraticGeneralStage : QuadraticGeneralStageTarget := by
  intro speed curvature
  let flux := fun state : State 1 => speed • state
  let eta := fun (_ : Input 1) t => AdvectionTaylor.residualBudget speed curvature t
  let criterion := Rectangle.criterion flux (by decide) eta
  refine ⟨criterion, ?_, ?_⟩
  · intro i endpoint
    exact Rectangle.certificate_iff flux (by decide) eta i endpoint
  · intro linear constant origin width hwidth step hstep
    dsimp only
    let grid := leveque04_uniformGrid origin width hwidth
    let R := leveque04_quadraticREAReconstruction curvature linear constant
    let V := leveque04_quadraticREAEndpoint speed curvature linear constant step
    have hcert : Certificate criterion ⟨grid, R, step, hstep⟩ V :=
      (Rectangle.certificate_iff flux (by decide) eta _ _).2
        (quadraticRectangleCertificate speed curvature linear constant step hstep grid)
    refine ⟨by decide, hstep, uniformGrid_covers origin width hwidth, R, V,
      quadraticReconstruction curvature linear constant grid,
      fun j => quadraticEndpoint_integrable speed curvature linear constant step _ _,
      ?_, fun _ => rfl⟩
    refine Or.inr ⟨ScalarTaylorProcedure speed criterion, rfl, ?_, hcert⟩
    exact quadraticExecute speed curvature linear constant step grid

end NumStability.REA.SeminormRecipe

namespace NumStability

/-- The full prescribed-certificate REA recipe and all its concrete commitments. -/
theorem leveque04_reaPrescribedCertificate : REA.SeminormRecipe.FullTarget :=
  ⟨REA.SeminormRecipe.genericRecipe, REA.SeminormRecipe.retainedConcrete,
    REA.SeminormRecipe.actualEquationIdentification, REA.SeminormRecipe.generalExactMatrix,
    REA.SeminormRecipe.quadraticWeakRectangle, REA.SeminormRecipe.quadraticGeneralStage⟩

end NumStability
