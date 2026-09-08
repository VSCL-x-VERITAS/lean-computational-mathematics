# Exact prospective contracts

Unselected scratch mathematics; no source interpretation is adopted.

```lean
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
```

```lean
theorem pure_interface_execution (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    PureInterfaceContract method old hdomain j
```

```lean
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
      PureInterfaceContract method (finiteVolumeCellAverageOn grid initialState) hdomain i
```

```lean
theorem constant_interface_consistency (method : RiemannFieldFluxMethod law Result Information)
    (state : Fin m → ℝ) (j : ℤ) :
    method.interfaceFlux (fun _ => state) (fun _ => method.constants_in_domain state) j =
      law.physicalFlux state
```

```lean
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
      adapted.interfaceFlux old hdomain j = rectangleRiemannInterfaceFlux method old hdomain j
```

```lean
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
        ((extractionBound i + traceBound i) + (extractionBound (i + 1) + traceBound (i + 1))))
```

```lean
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
          (StationaryRiemannField.reference problem.leftState problem.rightState 0 t)
```

