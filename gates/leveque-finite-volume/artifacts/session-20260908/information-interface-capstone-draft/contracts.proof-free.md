# Prospective information-interface contracts (proof-free)

This file mechanically extracts actual theorem headers from the bound Candidate.lean.
It preserves every premise and conclusion, including dependent result domains.
The transparent PureInterfaceContract body is included. No source-faithfulness
decision or accuracy interpretation is supplied by extraction.

The generic declarations live in NumStability.InformationInterfaceDraft;
the concrete unit-grid declarations live in its Witness namespace. Generic
implicit variables are `{m : ℕ}`, `{law : OneDimensionalHyperbolicConservationLaw (Fin m)}`,
`{Result : HyperbolicRiemannProblem law → Type*}` and `{Information : Type*}`.
The unit grid has cellLeft(i)=i and cellRight(i)=i+1, with checked positivity
and adjacency; no geometry assumption is hidden in a source predicate.

Normalization uses the existing definition
`cellVolumeAverage μ region field = (μ region).toReal⁻¹ • ∫ x in region, field x ∂μ`.
The checked Mathlib theorem Real.volume_Ioc gives
`volume (Set.Ioc a b) = ENNReal.ofReal (b-a)`.
Positive cell width and positive step length give ordinary spatial/time division
by length. Initialization includes interval integrability, and physical comparison
gets trace integrability from its explicit premises and the independent rectangle law.
The bridge alone is a total-operator identity and does not imply integrability.

Pure execution does not certify physical solutionhood. Finite-step error bounds
are additional hypotheses, not a definition of good approximation. The mass-rate
conclusion is almost everywhere in time for each fixed spatial interval; its
exceptional set can depend on that interval. The fixture restriction `0 < dt < 1`
is not a general method requirement or an adopted accuracy convention.

```lean
def PureInterfaceContract (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) : Prop :=
  let problem := adjacentCellRiemannProblem law old j
  let result := method.solve problem (hdomain j)
  let information := method.extract result
  problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
    method.selectedResult old hdomain j = result ∧
    method.interfaceFlux old hdomain j = method.numericalFlux information
```

```lean
theorem pure_interface_execution (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    PureInterfaceContract method old hdomain j
```

```lean
theorem normalized_spatial_average (grid : OneDimensionalFiniteVolumeGrid)
    (field : ℝ → Fin m → ℝ) (i : ℤ) :
    finiteVolumeCellAverageOn grid field i =
      cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i)) field
```

```lean
theorem normalized_physical_face_flux (grid : OneDimensionalFiniteVolumeGrid)
    (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    {s t : ℝ} (hst : s < t) (j : ℤ) :
    timeAveragedPhysicalFaceFlux grid q flux s t j =
      cellVolumeAverage volume (Set.Ioc s t) (fun τ => flux (q (grid.cellLeft j) τ))
```

```lean
theorem normalized_interface_execution (grid : OneDimensionalFiniteVolumeGrid)
    (initialState : ℝ → Fin m → ℝ)
    (hintegrable : ∀ i, IntervalIntegrable initialState volume
      (grid.cellLeft i) (grid.cellRight i))
    (method : RiemannInformationFluxMethod law Result Information)
    (hdomain : ∀ j, method.domain
      (adjacentCellRiemannProblem law (finiteVolumeCellAverageOn grid initialState) j))
    (dt : ℝ) :
    let old := finiteVolumeCellAverageOn grid initialState
    let numericalFlux := method.interfaceFlux old hdomain
    ∀ i, IsOneDimensionalCellAverage initialState (grid.cellLeft i) (grid.cellRight i) (old i) ∧
      old i = cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i)) initialState ∧
      grid.cellRight (i - 1) = grid.cellLeft i ∧
      PureInterfaceContract method old hdomain i ∧
      PureInterfaceContract method old hdomain (i + 1) ∧
      riemannFiniteVolumeUpdate grid dt old numericalFlux i =
        old i - (dt / grid.cellVolume i) • (numericalFlux (i + 1) - numericalFlux i)
```

```lean
theorem constant_interface_consistency (method : RiemannInformationFluxMethod law Result Information)
    (state : Fin m → ℝ) (j : ℤ) :
    method.interfaceFlux (fun _ => state) (fun _ => method.constants_in_domain state) j =
      law.physicalFlux state
```

```lean
theorem field_adapter_contract (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    let adapted := RiemannInformationFluxMethod.ofField method
    let problem := adjacentCellRiemannProblem law old j
    let result := adapted.solve problem (hdomain j)
    adapted.domain problem = method.domain problem ∧
      result = method.solve problem (hdomain j) ∧
      adapted.extract result = method.extract result ∧
      adapted.numericalFlux (adapted.extract result) = method.numericalFlux (method.extract result) ∧
      adapted.interfaceFlux old hdomain j = method.interfaceFlux old hdomain j
```

```lean
theorem finite_step_reference_comparison (grid : OneDimensionalFiniteVolumeGrid)
    (method : RiemannInformationFluxMethod law Result Information) (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    {s t oldBound aLeft bLeft aRight bRight : ℝ} (hst : s < t) (i : ℤ)
    (localTrace : (j : ℤ) → Result (adjacentCellRiemannProblem law old j) → ℝ → Fin m → ℝ)
    (hold : ‖old i - cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i))
      (fun x => q x s)‖ ≤ oldBound)
    (hl : IntervalIntegrable (localTrace i (method.selectedResult old hdomain i)) volume s t)
    (hr : IntervalIntegrable (localTrace (i + 1) (method.selectedResult old hdomain (i + 1))) volume s t)
    (hnl : ∀ τ ∈ Set.uIoc s t, ‖method.interfaceFlux old hdomain i -
      localTrace i (method.selectedResult old hdomain i) τ‖ ≤ aLeft)
    (hel : ∀ τ ∈ Set.uIoc s t, ‖localTrace i (method.selectedResult old hdomain i) τ -
      law.physicalFlux (q (grid.cellLeft i) τ)‖ ≤ bLeft)
    (hnr : ∀ τ ∈ Set.uIoc s t, ‖method.interfaceFlux old hdomain (i + 1) -
      localTrace (i + 1) (method.selectedResult old hdomain (i + 1)) τ‖ ≤ aRight)
    (her : ∀ τ ∈ Set.uIoc s t, ‖localTrace (i + 1) (method.selectedResult old hdomain (i + 1)) τ -
      law.physicalFlux (q (grid.cellLeft (i + 1)) τ)‖ ≤ bRight) :
    PureInterfaceContract method old hdomain i ∧ PureInterfaceContract method old hdomain (i + 1) ∧
    (∀ a b : ℝ, ∀ᵐ τ, HasDerivAt (fun r => ∫ x in a..b, q x r)
      (law.physicalFlux (q a τ) - law.physicalFlux (q b τ)) τ) ∧
    (‖method.interfaceFlux old hdomain i - cellVolumeAverage volume (Set.Ioc s t)
      (fun τ => law.physicalFlux (q (grid.cellLeft i) τ))‖ ≤ aLeft + bLeft) ∧
    (‖method.interfaceFlux old hdomain (i + 1) - cellVolumeAverage volume (Set.Ioc s t)
      (fun τ => law.physicalFlux (q (grid.cellLeft (i + 1)) τ))‖ ≤ aRight + bRight) ∧
    (‖riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i -
      cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i)) (fun x => q x t)‖ ≤
      oldBound + (t - s) / grid.cellVolume i * ((aLeft + bLeft) + (aRight + bRight)))
```

```lean
noncomputable def initialState : ℝ → Fin 1 → ℝ := riemannData 0 0 1
```

```lean
theorem initialState_integrable (i : ℤ) :
    IntervalIntegrable initialState volume (unitGrid.cellLeft i) (unitGrid.cellRight i)
```

```lean
theorem normalized_pair :
    finiteVolumeCellAverageOn unitGrid initialState (-1) = 0 ∧
      finiteVolumeCellAverageOn unitGrid initialState 0 = 1
```

```lean
theorem information_only_applicability (dt : ℝ) (hdt : 0 < dt) :
    let law := StationaryRiemannField.transportLaw (m := 1)
    let method := LeftStateInformationFlux.method law
    let old := finiteVolumeCellAverageOn unitGrid initialState
    (∀ i, IsOneDimensionalCellAverage initialState (unitGrid.cellLeft i) (unitGrid.cellRight i) (old i) ∧
      old i = cellVolumeAverage volume (Set.Ioc (unitGrid.cellLeft i) (unitGrid.cellRight i)) initialState ∧
      unitGrid.cellRight (i - 1) = unitGrid.cellLeft i ∧
      PureInterfaceContract method old (fun _ => trivial) i ∧
      PureInterfaceContract method old (fun _ => trivial) (i + 1) ∧
      riemannFiniteVolumeUpdate unitGrid dt old (method.interfaceFlux old (fun _ => trivial)) i =
        old i - (dt / unitGrid.cellVolume i) •
          (method.interfaceFlux old (fun _ => trivial) (i + 1) - method.interfaceFlux old (fun _ => trivial) i)) ∧
    method.extract (method.selectedResult old (fun _ => trivial) 0) = (0, 1) ∧
    method.interfaceFlux old (fun _ => trivial) 0 = 0 ∧
    method.interfaceFlux old (fun _ => trivial) 0 =
      cellVolumeAverage volume (Set.Ioc 0 dt)
        (fun τ => law.physicalFlux (StationaryRiemannField.reference 0 1 0 τ))
```

```lean
theorem finite_step_comparison_applicability {dt : ℝ} (hdt : 0 < dt) (hdt1 : dt < 1) :
    let method := LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1))
    let old := finiteVolumeCellAverageOn unitGrid initialState
    riemannFiniteVolumeUpdate unitGrid dt old (method.interfaceFlux old (fun _ => trivial)) 0 =
      cellVolumeAverage volume (Set.Ioc (0 : ℝ) 1)
        (fun x => StationaryRiemannField.reference 0 1 x dt)
```
