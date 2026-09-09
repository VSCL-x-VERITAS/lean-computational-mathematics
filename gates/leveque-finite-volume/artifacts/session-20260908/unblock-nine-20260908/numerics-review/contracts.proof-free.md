This packet contains exact source theorem headers only. Native elaborated types and axioms are captured separately. Coordinator-selected interpretations qualify correspondence; independent statement audits remain required.

```lean
namespace NumStability
theorem leveque01_finiteVolumeUpdateError_sourceContract {m : ℕ} (hm : 0 < m)
    (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → Fin m → ℝ} {flux : (Fin m → ℝ) → Fin m → ℝ}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ)
    {s t : ℝ} (hst : s < t) (old : ℤ → Fin m → ℝ) :
    0 < m ∧ ∀ i,
      IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x s) i) ∧
      IsOneDimensionalCellAverage (fun x => q x t) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x t) i) ∧
      finiteVolumeCellAverageOn grid (fun x => q x s) i =
        cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i))
          (fun x => q x s) ∧
      IsOneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft i) τ)) s t
        (timeAveragedPhysicalFaceFlux grid q flux s t i) ∧
      timeAveragedPhysicalFaceFlux grid q flux s t i =
        cellVolumeAverage volume (Set.Ioc s t) (fun τ => flux (q (grid.cellLeft i) τ)) ∧
      riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i =
        old i - ((t - s) / grid.cellVolume i) • (rule s t old (i + 1) - rule s t old i) ∧
      grid.cellVolume i • (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i) =
        grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
          (t - s) • ((rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i) -
            (rule s t old (i + 1) - timeAveragedPhysicalFaceFlux grid q flux s t (i + 1))) ∧
      ∀ oldBound leftBound rightBound : ℝ,
        ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound →
        ‖rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i‖ ≤ leftBound →
        ‖rule s t old (i + 1) -
          timeAveragedPhysicalFaceFlux grid q flux s t (i + 1)‖ ≤ rightBound →
        ‖riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
          oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound)
end NumStability
```

```lean
namespace NumStability
theorem leveque01_riemannInformationInterfaceFlux_sourceContract
    {m : ℕ} (hm : 0 < m) (grid : OneDimensionalFiniteVolumeGrid)
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}
    (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ}
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    {s t : ℝ} (hst : s < t) :
    0 < m ∧
    (∀ a b : ℝ, ∀ᵐ τ, HasDerivAt (fun r => ∫ x in a..b, q x r)
      (law.physicalFlux (q a τ) - law.physicalFlux (q b τ)) τ) ∧
    (∀ state j, method.interfaceFlux (fun _ => state)
      (fun _ => method.constants_in_domain state) j = law.physicalFlux state) ∧
    (∀ j,
      let problem := adjacentCellRiemannProblem law old j
      let result := method.solve problem (hdomain j)
      grid.cellRight (j - 1) = grid.cellLeft j ∧
      problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
      method.selectedResult old hdomain j = result ∧
      method.interfaceFlux old hdomain j = method.numericalFlux (method.extract result)) ∧
    ∀ i,
      IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x s) i) ∧
      IsOneDimensionalCellAverage (fun x => q x t) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x t) i) ∧
      finiteVolumeCellAverageOn grid (fun x => q x s) i =
        cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i))
          (fun x => q x s) ∧
      IsOneDimensionalCellAverage (fun τ => law.physicalFlux (q (grid.cellLeft i) τ)) s t
        (timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i) ∧
      timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i =
        cellVolumeAverage volume (Set.Ioc s t)
          (fun τ => law.physicalFlux (q (grid.cellLeft i) τ)) ∧
      riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i =
        old i - ((t - s) / grid.cellVolume i) •
          (method.interfaceFlux old hdomain (i + 1) - method.interfaceFlux old hdomain i) ∧
      grid.cellVolume i •
          (riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i -
            finiteVolumeCellAverageOn grid (fun x => q x t) i) =
        grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
          (t - s) •
            ((method.interfaceFlux old hdomain i - timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i) -
              (method.interfaceFlux old hdomain (i + 1) - timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t (i + 1))) ∧
      ∀ oldBound leftBound rightBound : ℝ,
        ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound →
        ‖method.interfaceFlux old hdomain i -
          timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i‖ ≤ leftBound →
        ‖method.interfaceFlux old hdomain (i + 1) -
          timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t (i + 1)‖ ≤ rightBound →
        ‖riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
          oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound)
end NumStability
```

```lean
namespace NumStability
theorem leveque01_coordinateSplittingBalance_sourceContract
    {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]
    (cellVolume : (D → ℤ) → ℝ) (hvolume : ∀ cell, 0 < cellVolume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hduration : ∀ stage ∈ stages, 0 < stage.2) (state : (D → ℤ) → E) :
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ stage ∈ stages, 0 < stage.2) ∧
    ∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current := sweep cellVolume rule before state
      sweep cellVolume rule stages state =
        sweep cellVolume rule after (advance cellVolume rule d dt current) ∧
      (∀ cell, cellVolume cell • advance cellVolume rule d dt current cell =
        cellVolume cell • current cell - dt • netOutwardFlux rule d dt current cell) ∧
      (∀ base start count,
        (∑ k ∈ Finset.range count, cellVolume (Function.update base d (start + k)) •
          advance cellVolume rule d dt current (Function.update base d (start + k))) =
        (∑ k ∈ Finset.range count, cellVolume (Function.update base d (start + k)) •
          current (Function.update base d (start + k))) -
          dt • (normalFaceFlux rule d dt current (Function.update base d (start + count)) -
            normalFaceFlux rule d dt current (Function.update base d start))) ∧
      ∀ other base,
        (∀ j, current (Function.update base d j) = other (Function.update base d j)) →
        ∀ j, advance cellVolume rule d dt current (Function.update base d j) =
          advance cellVolume rule d dt other (Function.update base d j)
end NumStability
```

```lean
namespace NumStability
theorem leveque01_coordinateSplittingBalance_information
    {D : Type*} [DecidableEq D] {m : ℕ}
    {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
    {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
    {Information : D → Type*}
    (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))
    (cellVolume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : (D → ℤ) → Fin m → ℝ)
    (hadmitted : RiemannInformationCoordinate.SweepAdmitted methods cellVolume area fallback stages state) :
    (∀ other, sweep cellVolume (RiemannInformationCoordinate.guardedRule methods area fallback) stages state =
      sweep cellVolume (RiemannInformationCoordinate.guardedRule methods area other) stages state) ∧
    ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      let current := sweep cellVolume (RiemannInformationCoordinate.guardedRule methods area fallback) before state
      ∃ admitted : RiemannInformationCoordinate.FaceAdmitted methods d dt current cell,
        let problem := adjacentCellRiemannProblem (laws d)
          (fun j => current (Function.update cell d j)) (cell d)
        let result := (methods d dt).solve problem admitted
        problem.leftState = current (Function.update cell d (cell d - 1)) ∧
        problem.rightState = current cell ∧
        normalFaceFlux (RiemannInformationCoordinate.guardedRule methods area fallback) d dt current cell =
          area d cell • (methods d dt).numericalFlux ((methods d dt).extract result)
end NumStability
```

```lean
namespace NumStability
theorem leveque01_coordinateSplittingBalance_cartesian
    {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
    (axes : D → OneDimensionalFiniteVolumeGrid)
    (rule : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (base : D → ℤ) :
    (∀ cell, 0 < CartesianGrid.cellVolume axes cell) ∧
    (∀ cell, (volume (CartesianGrid.cellBox axes cell)).toReal = CartesianGrid.cellVolume axes cell) ∧
    (∀ cell, (volume (CartesianGrid.tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell) ∧
    (∀ cell : D → ℤ, (axes d).cellRight (cell d) =
      (axes d).cellLeft ((Function.update cell d (cell d + 1)) d)) ∧
    (fun j => advance (CartesianGrid.cellVolume axes)
      (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt state (Function.update base d j)) =
      riemannFiniteVolumeUpdate (axes d) dt (fun j => state (Function.update base d j))
        (fun j => rule d (Function.update base d j) dt (fun k => state (Function.update base d k)))
end NumStability
```

