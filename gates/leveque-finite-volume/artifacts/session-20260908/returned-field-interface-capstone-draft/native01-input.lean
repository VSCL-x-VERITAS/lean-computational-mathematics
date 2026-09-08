import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageTraceEstimate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField

/-!
# Prospective interface workflow and separate conditional comparison

Scratch, unselected source-facing assembly. The pure execution contract makes
no exact-solution or accuracy assertion about returned fields. Comparison with
an independently supplied rectangle-conservative field requires additional
explicit hypotheses. No source convention is adopted here.
-/

open MeasureTheory

namespace NumStability.ReturnedFieldInterfaceDraft

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

/-- A per-interface execution of the actual selected solve. The returned field
and information are tied to that result, never to an arbitrary certified solve.
The trace-integrability clause retains the supplied method's all-real domain. -/
def PureInterfaceContract (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) : Prop :=
  let problem := adjacentCellRiemannProblem law old j
  let result := method.solve problem (hdomain j)
  problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
    ∃ returned : ℝ → ℝ → Fin m → ℝ, ∃ information : Information,
      returned = method.field result ∧ information = method.extract result ∧
      IsRiemannData (fun x => returned x 0) (old (j - 1)) (old j) ∧
      (∀ s t, IntervalIntegrable (fun τ => law.physicalFlux (returned 0 τ)) volume s t) ∧
      method.interfaceFlux old hdomain j = method.numericalFlux information

theorem pure_interface_execution (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    PureInterfaceContract method old hdomain j := by
  let result := method.solve (adjacentCellRiemannProblem law old j) (hdomain j)
  exact ⟨rfl, rfl, method.field result, method.extract result, rfl, rfl,
    method.initial result, method.trace_integrable result, rfl⟩

/-- Exact normalized initial averages supply ordered neighboring problem data.
This initialization fact is separate from the general approximate-old-data bound. -/
theorem normalized_interface_execution (grid : OneDimensionalFiniteVolumeGrid)
    (initialState : ℝ → Fin m → ℝ)
    (hintegrable : ∀ i, IntervalIntegrable initialState volume
      (grid.cellLeft i) (grid.cellRight i))
    (method : RiemannFieldFluxMethod law Result Information)
    (hdomain : ∀ i, method.domain
      (adjacentCellRiemannProblem law (finiteVolumeCellAverageOn grid initialState) i)) :
    ∀ i, IsOneDimensionalCellAverage initialState
        (grid.cellLeft i) (grid.cellRight i) (finiteVolumeCellAverageOn grid initialState i) ∧
      grid.cellRight (i - 1) = grid.cellLeft i ∧
      PureInterfaceContract method (finiteVolumeCellAverageOn grid initialState) hdomain i := by
  intro i
  exact ⟨finiteVolumeCellAverageOn_spec grid initialState hintegrable i,
    grid.adjacent i, pure_interface_execution method _ hdomain i⟩

/-- Consistency refers to the actual solve/extract execution for constant data. -/
theorem constant_interface_consistency (method : RiemannFieldFluxMethod law Result Information)
    (state : Fin m → ℝ) (j : ℤ) :
    method.interfaceFlux (fun _ => state) (fun _ => method.constants_in_domain state) j =
      law.physicalFlux state :=
  method.consistent state

/-- The exact adapter retains the selected result and the original flux. Its
rectangle certificate belongs to this exact special case, not every method. -/
theorem exact_adapter_contract (method : RectangleRiemannInterfaceFluxMethod law Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    let problem := adjacentCellRiemannProblem law old j
    let adapted := RiemannFieldFluxMethod.ofExact method
    adapted.solve problem (hdomain j) = method.solve problem (hdomain j) ∧
      adapted.field (adapted.solve problem (hdomain j)) =
        (method.solve problem (hdomain j)).solution ∧
      IsRiemannData (fun x => adapted.field (adapted.solve problem (hdomain j)) x 0)
        (old (j - 1)) (old j) ∧
      IsRectangleConservationLawSolution
        (adapted.field (adapted.solve problem (hdomain j))) law.physicalFlux ∧
      adapted.interfaceFlux old hdomain j = rectangleRiemannInterfaceFlux method old hdomain j := by
  exact ⟨rfl, rfl, (method.solve _ (hdomain j)).solves.1,
    (method.solve _ (hdomain j)).solves.2,
    RiemannFieldFluxMethod.ofExact_interfaceFlux method old hdomain j⟩

/-- Prospective full assembly. Pure execution and constant consistency also have
independent theorems above. Here the physical reference, old-average error and
two trace-error families are additional assumptions, with no chosen tolerance
or convergence order. Local interface zero is compared to the actual physical
face `grid.cellLeft j` in the independent reference field. -/
theorem returned_field_comparison_contract (grid : OneDimensionalFiniteVolumeGrid)
    (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ}
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    {dt : ℝ} (hdt : 0 < dt) (oldBound extractionBound traceBound : ℤ → ℝ)
    (hold : ∀ i, ‖old i - finiteVolumeCellAverageOn grid (fun x => q x 0) i‖ ≤ oldBound i)
    (hextract : ∀ j τ, τ ∈ Set.uIoc 0 dt →
      ‖method.interfaceFlux old hdomain j - law.physicalFlux
        (method.field (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ)‖ ≤
          extractionBound j)
    (htrace : ∀ j τ, τ ∈ Set.uIoc 0 dt →
      ‖law.physicalFlux
        (method.field (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ) -
          law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ traceBound j) :
    (∀ j, PureInterfaceContract method old hdomain j) ∧
    (∀ state j, method.interfaceFlux (fun _ => state)
        (fun _ => method.constants_in_domain state) j = law.physicalFlux state) ∧
    (∀ j, ‖method.interfaceFlux old hdomain j -
        timeAveragedPhysicalFaceFlux grid q law.physicalFlux 0 dt j‖ ≤
          extractionBound j + traceBound j) ∧
    (∀ i, ‖riemannFiniteVolumeUpdate grid dt old (method.interfaceFlux old hdomain) i -
        finiteVolumeCellAverageOn grid (fun x => q x dt) i‖ ≤
      oldBound i + dt / grid.cellVolume i *
        ((extractionBound i + traceBound i) + (extractionBound (i + 1) + traceBound (i + 1)))) := by
  refine ⟨pure_interface_execution method old hdomain,
    constant_interface_consistency method, ?_, ?_⟩
  · intro j
    exact method.interface_error_le grid hq old hdomain hdt j (hextract j) (htrace j)
  · intro i
    exact method.update_error_le grid hq old hdomain hdt i extractionBound traceBound
      (hold i) hextract htrace

/-- A nonexact returned field with genuine ordered data and an independent exact
reference. Positive-time interface flux agreement does not assert equality of
the two space-time fields, and no tolerance is selected by this witness. -/
theorem nonexact_method_with_reference :
    ∃ problem : HyperbolicRiemannProblem (StationaryRiemannField.transportLaw (m := 1)),
      StationaryRiemannField.method.domain problem ∧
      IsRiemannData
        (fun x => StationaryRiemannField.method.field
          (StationaryRiemannField.method.solve problem trivial) x 0)
        problem.leftState problem.rightState ∧
      ¬ IsRectangleConservationLawSolution
        (StationaryRiemannField.method.field (StationaryRiemannField.method.solve problem trivial))
        StationaryRiemannField.transportLaw.physicalFlux ∧
      IsRiemannData
        (fun x => StationaryRiemannField.reference problem.leftState problem.rightState x 0)
        problem.leftState problem.rightState ∧
      IsRectangleConservationLawSolution
        (StationaryRiemannField.reference problem.leftState problem.rightState)
        StationaryRiemannField.transportLaw.physicalFlux ∧
      ∀ t, 0 < t →
        StationaryRiemannField.method.numericalFlux
          (StationaryRiemannField.method.extract (StationaryRiemannField.method.solve problem trivial)) =
        StationaryRiemannField.transportLaw.physicalFlux
          (StationaryRiemannField.reference problem.leftState problem.rightState 0 t) := by
  obtain ⟨problem, hdomain, hnonexact⟩ := StationaryRiemannField.nonexact_instance
  refine ⟨problem, hdomain, StationaryRiemannField.method.initial _, hnonexact,
    StationaryRiemannField.reference_initial _ _,
    StationaryRiemannField.reference_rectangle _ _, ?_⟩
  intro t ht
  rw [StationaryRiemannField.method_flux_eq_returned_trace problem t]
  exact congrArg StationaryRiemannField.transportLaw.physicalFlux
    (StationaryRiemannField.stationary_trace_eq_reference _ _ ht)

end NumStability.ReturnedFieldInterfaceDraft

#check NumStability.ReturnedFieldInterfaceDraft.PureInterfaceContract
#print axioms NumStability.ReturnedFieldInterfaceDraft.PureInterfaceContract
#check NumStability.ReturnedFieldInterfaceDraft.pure_interface_execution
#print axioms NumStability.ReturnedFieldInterfaceDraft.pure_interface_execution
#check NumStability.ReturnedFieldInterfaceDraft.normalized_interface_execution
#print axioms NumStability.ReturnedFieldInterfaceDraft.normalized_interface_execution
#check NumStability.ReturnedFieldInterfaceDraft.constant_interface_consistency
#print axioms NumStability.ReturnedFieldInterfaceDraft.constant_interface_consistency
#check NumStability.ReturnedFieldInterfaceDraft.exact_adapter_contract
#print axioms NumStability.ReturnedFieldInterfaceDraft.exact_adapter_contract
#check NumStability.ReturnedFieldInterfaceDraft.returned_field_comparison_contract
#print axioms NumStability.ReturnedFieldInterfaceDraft.returned_field_comparison_contract
#check NumStability.ReturnedFieldInterfaceDraft.nonexact_method_with_reference
#print axioms NumStability.ReturnedFieldInterfaceDraft.nonexact_method_with_reference
