# Declaration dossier for LEV-CH01-FINITE-VOLUME-FLUX-UPDATE

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_finiteVolumeFluxUpdate_sourceContract
    {Cell Interface Point E : Type*}
    [MeasurableSpace Point] [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (μ : Measure Point) (conservedField : Point → E)
    (physicalConservationFlux : E → E)
    (localNumericalFlux : E → E → E)
    (timeStart timeEnd fluxTolerance : ℝ)
    (hTimeInterval : timeStart < timeEnd)
    (hFluxTolerance : 0 < fluxTolerance)
    (hPositiveCellVolume : ∀ cell, μ (mesh.cellRegion cell) ≠ 0)
    (hFiniteCellVolume : ∀ cell, μ (mesh.cellRegion cell) ≠ ⊤)
    (hIntegrable : ∀ cell,
      IntegrableOn conservedField (mesh.cellRegion cell) μ)
    (hFluxApproximation : ∀ interface,
      dist
          (neighboringCellNumericalFlux mesh localNumericalFlux
            (finiteVolumeCellAverages mesh μ conservedField) interface)
          (conservationLawInterfaceFlux mesh conservedField
            physicalConservationFlux interface) <
        fluxTolerance) :
    0 < timeEnd - timeStart ∧
      0 < fluxTolerance ∧
      (∀ cell,
        IsCellVolumeAverage μ (mesh.cellRegion cell) conservedField
          (finiteVolumeCellAverages mesh μ conservedField cell)) ∧
      (∀ interface,
        neighboringCellNumericalFlux mesh localNumericalFlux
            (finiteVolumeCellAverages mesh μ conservedField) interface =
          localNumericalFlux
            (finiteVolumeCellAverages mesh μ conservedField
              (mesh.leftCell interface))
            (finiteVolumeCellAverages mesh μ conservedField
              (mesh.rightCell interface)) ∧
        dist
            (neighboringCellNumericalFlux mesh localNumericalFlux
              (finiteVolumeCellAverages mesh μ conservedField) interface)
            (conservationLawInterfaceFlux mesh conservedField
              physicalConservationFlux interface) <
          fluxTolerance) ∧
      ∃ updatedCellAverages : Cell → E,
        (∀ cell,
          (μ (mesh.cellRegion cell)).toReal • updatedCellAverages cell =
            (μ (mesh.cellRegion cell)).toReal •
                finiteVolumeCellAverages mesh μ conservedField cell -
              (timeEnd - timeStart) •
                finiteVolumeNetOutwardFlux mesh
                  (neighboringCellNumericalFlux mesh localNumericalFlux
                    (finiteVolumeCellAverages mesh μ conservedField)) cell) ∧
        ∀ cells : Finset Cell,
          ∑ cell ∈ cells,
              (μ (mesh.cellRegion cell)).toReal • updatedCellAverages cell =
            (∑ cell ∈ cells,
              (μ (mesh.cellRegion cell)).toReal •
                finiteVolumeCellAverages mesh μ conservedField cell) -
              (timeEnd - timeStart) •
                finiteVolumeBoundaryFlux mesh
                  (neighboringCellNumericalFlux mesh localNumericalFlux
                    (finiteVolumeCellAverages mesh μ conservedField)) cells
```

## Elaborated target type

```lean
∀ {Cell : Type u_1} {Interface : Type u_2} {Point : Type u_3} {E : Type u_4} [inst : MeasurableSpace Point]
  [inst_1 : TopologicalSpace Point] [inst_2 : Fintype Interface] [inst_3 : DecidableEq Cell]
  [inst_4 : NormedAddCommGroup E] [inst_5 : NormedSpace Real E]
  (mesh : NumStability.FiniteVolumeInterfaceMesh Cell Interface Point) (μ : MeasureTheory.Measure Point)
  (conservedField : Point → E) (physicalConservationFlux : E → E) (localNumericalFlux : E → E → E)
  (timeStart timeEnd fluxTolerance : Real),
  Real.instLT.lt timeStart timeEnd →
    Real.instLT.lt 0 fluxTolerance →
      (∀ (cell : Cell), Ne (MeasureTheory.Measure.instFunLike.coe μ (mesh.cellRegion cell)) 0) →
        (∀ (cell : Cell), Ne (MeasureTheory.Measure.instFunLike.coe μ (mesh.cellRegion cell)) instTopENNReal.top) →
          (∀ (cell : Cell), MeasureTheory.IntegrableOn conservedField (mesh.cellRegion cell) μ) →
            (∀ (interface : Interface),
                Real.instLT.lt
                  (NormedAddCommGroup.toSeminormedAddCommGroup.dist
                    (NumStability.neighboringCellNumericalFlux mesh localNumericalFlux
                      (NumStability.finiteVolumeCellAverages mesh μ conservedField) interface)
                    (NumStability.conservationLawInterfaceFlux mesh conservedField physicalConservationFlux interface))
                  fluxTolerance) →
              And (Real.instLT.lt 0 (instHSub.hSub timeEnd timeStart))
                (And (Real.instLT.lt 0 fluxTolerance)
                  (And
                    (∀ (cell : Cell),
                      NumStability.IsCellVolumeAverage μ (mesh.cellRegion cell) conservedField
                        (NumStability.finiteVolumeCellAverages mesh μ conservedField cell))
                    (And
                      (∀ (interface : Interface),
                        And
                          (Eq
                            (NumStability.neighboringCellNumericalFlux mesh localNumericalFlux
                              (NumStability.finiteVolumeCellAverages mesh μ conservedField) interface)
                            (localNumericalFlux
                              (NumStability.finiteVolumeCellAverages mesh μ conservedField (mesh.leftCell interface))
                              (NumStability.finiteVolumeCellAverages mesh μ conservedField (mesh.rightCell interface))))
                          (Real.instLT.lt
                            (NormedAddCommGroup.toSeminormedAddCommGroup.dist
                              (NumStability.neighboringCellNumericalFlux mesh localNumericalFlux
                                (NumStability.finiteVolumeCellAverages mesh μ conservedField) interface)
                              (NumStability.conservationLawInterfaceFlux mesh conservedField physicalConservationFlux
                                interface))
                            fluxTolerance))
                      (Exists fun updatedCellAverages =>
                        And
                          (∀ (cell : Cell),
                            Eq
                              (instHSMul.hSMul (MeasureTheory.Measure.instFunLike.coe μ (mesh.cellRegion cell)).toReal
                                (updatedCellAverages cell))
                              (instHSub.hSub
                                (instHSMul.hSMul (MeasureTheory.Measure.instFunLike.coe μ (mesh.cellRegion cell)).toReal
                                  (NumStability.finiteVolumeCellAverages mesh μ conservedField cell))
                                (instHSMul.hSMul (instHSub.hSub timeEnd timeStart)
                                  (NumStability.finiteVolumeNetOutwardFlux mesh
                                    (NumStability.neighboringCellNumericalFlux mesh localNumericalFlux
                                      (NumStability.finiteVolumeCellAverages mesh μ conservedField))
                                    cell))))
                          (∀ (cells : Finset Cell),
                            Eq
                              (cells.sum fun cell =>
                                instHSMul.hSMul (MeasureTheory.Measure.instFunLike.coe μ (mesh.cellRegion cell)).toReal
                                  (updatedCellAverages cell))
                              (instHSub.hSub
                                (cells.sum fun cell =>
                                  instHSMul.hSMul
                                    (MeasureTheory.Measure.instFunLike.coe μ (mesh.cellRegion cell)).toReal
                                    (NumStability.finiteVolumeCellAverages mesh μ conservedField cell))
                                (instHSMul.hSMul (instHSub.hSub timeEnd timeStart)
                                  (NumStability.finiteVolumeBoundaryFlux mesh
                                    (NumStability.neighboringCellNumericalFlux mesh localNumericalFlux
                                      (NumStability.finiteVolumeCellAverages mesh μ conservedField))
                                    cells))))))))
```

## Fully explicit elaborated target type

```lean
∀ {Cell : Type u_1} {Interface : Type u_2} {Point : Type u_3} {E : Type u_4} [inst : MeasurableSpace.{u_3} Point]
  [inst_1 : TopologicalSpace.{u_3} Point] [inst_2 : Fintype.{u_2} Interface] [inst_3 : DecidableEq.{u_1 + 1} Cell]
  [inst_4 : NormedAddCommGroup.{u_4} E]
  [inst_5 : @NormedSpace.{0, u_4} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4)]
  (mesh : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1)
  (μ : @MeasureTheory.Measure.{u_3} Point inst) (conservedField : Point → E) (physicalConservationFlux : E → E)
  (localNumericalFlux : E → E → E) (timeStart timeEnd fluxTolerance : Real)
  (hTimeInterval : @LT.lt.{0} Real Real.instLT timeStart timeEnd)
  (hFluxTolerance :
    @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
      fluxTolerance)
  (hPositiveCellVolume :
    ∀ (cell : Cell),
      @Ne.{1} ENNReal
        (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
          (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) μ
          (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
            (@NumStability.FiniteVolumeInterfaceMesh.toFiniteVolumeCellPartition.{u_1, u_2, u_3} Cell Interface Point
              inst inst_1 mesh)
            cell))
        (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal)))
  (hFiniteCellVolume :
    ∀ (cell : Cell),
      @Ne.{1} ENNReal
        (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
          (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) μ
          (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
            (@NumStability.FiniteVolumeInterfaceMesh.toFiniteVolumeCellPartition.{u_1, u_2, u_3} Cell Interface Point
              inst inst_1 mesh)
            cell))
        (@Top.top.{0} ENNReal instTopENNReal))
  (hIntegrable :
    ∀ (cell : Cell),
      @MeasureTheory.IntegrableOn.{u_3, u_4} Point E inst
        (@UniformSpace.toTopologicalSpace.{u_4} E
          (@PseudoMetricSpace.toUniformSpace.{u_4} E
            (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
        (@SeminormedAddGroup.toContinuousENorm.{u_4} E
          (@SeminormedAddCommGroup.toSeminormedAddGroup.{u_4} E
            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4)))
        conservedField
        (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
          (@NumStability.FiniteVolumeInterfaceMesh.toFiniteVolumeCellPartition.{u_1, u_2, u_3} Cell Interface Point inst
            inst_1 mesh)
          cell)
        μ)
  (hFluxApproximation :
    ∀ (interface : Interface),
      @LT.lt.{0} Real Real.instLT
        (@Dist.dist.{u_4} E
          (@PseudoMetricSpace.toDist.{u_4} E
            (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4)))
          (@NumStability.neighboringCellNumericalFlux.{u_1, u_2, u_3, u_4, u_4} Cell Interface Point E E inst inst_1
            mesh localNumericalFlux
            (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1 inst_4
              inst_5 mesh μ conservedField)
            interface)
          (@NumStability.conservationLawInterfaceFlux.{u_1, u_2, u_3, u_4, u_4} Cell Interface Point E E inst inst_1
            mesh conservedField physicalConservationFlux interface))
        fluxTolerance),
  And
    (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
      (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) timeEnd timeStart))
    (And
      (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
        fluxTolerance)
      (And
        (∀ (cell : Cell),
          @NumStability.IsCellVolumeAverage.{u_3, u_4} Point E inst inst_4 inst_5 μ
            (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
              (@NumStability.FiniteVolumeInterfaceMesh.toFiniteVolumeCellPartition.{u_1, u_2, u_3} Cell Interface Point
                inst inst_1 mesh)
              cell)
            conservedField
            (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1 inst_4
              inst_5 mesh μ conservedField cell))
        (And
          (∀ (interface : Interface),
            And
              (@Eq.{u_4 + 1} E
                (@NumStability.neighboringCellNumericalFlux.{u_1, u_2, u_3, u_4, u_4} Cell Interface Point E E inst
                  inst_1 mesh localNumericalFlux
                  (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1 inst_4
                    inst_5 mesh μ conservedField)
                  interface)
                (localNumericalFlux
                  (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1 inst_4
                    inst_5 mesh μ conservedField
                    (@NumStability.FiniteVolumeInterfaceMesh.leftCell.{u_1, u_2, u_3} Cell Interface Point inst inst_1
                      mesh interface))
                  (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1 inst_4
                    inst_5 mesh μ conservedField
                    (@NumStability.FiniteVolumeInterfaceMesh.rightCell.{u_1, u_2, u_3} Cell Interface Point inst inst_1
                      mesh interface))))
              (@LT.lt.{0} Real Real.instLT
                (@Dist.dist.{u_4} E
                  (@PseudoMetricSpace.toDist.{u_4} E
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4)))
                  (@NumStability.neighboringCellNumericalFlux.{u_1, u_2, u_3, u_4, u_4} Cell Interface Point E E inst
                    inst_1 mesh localNumericalFlux
                    (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1
                      inst_4 inst_5 mesh μ conservedField)
                    interface)
                  (@NumStability.conservationLawInterfaceFlux.{u_1, u_2, u_3, u_4, u_4} Cell Interface Point E E inst
                    inst_1 mesh conservedField physicalConservationFlux interface))
                fluxTolerance))
          (@Exists.{max (u_1 + 1) (u_4 + 1)} (Cell → E) fun (updatedCellAverages : Cell → E) =>
            And
              (∀ (cell : Cell),
                @Eq.{u_4 + 1} E
                  (@HSMul.hSMul.{0, u_4, u_4} Real E E
                    (@instHSMul.{0, u_4} Real E
                      (@SMulZeroClass.toSMul.{0, u_4} Real E
                        (@AddZero.toZero.{u_4} E
                          (@AddZeroClass.toAddZero.{u_4} E
                            (@AddMonoid.toAddZeroClass.{u_4} E
                              (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))))
                        (@DistribSMul.toSMulZeroClass.{0, u_4} Real E
                          (@AddMonoid.toAddZeroClass.{u_4} E
                            (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                              (@UniformSpace.toTopologicalSpace.{u_4} E
                                (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                              (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))
                          (@DistribMulAction.toDistribSMul.{0, u_4} Real E Real.instMonoid
                            (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                              (@UniformSpace.toTopologicalSpace.{u_4} E
                                (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                              (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4))))
                            (@Module.toDistribMulAction.{0, u_4} Real E Real.semiring
                              (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))
                              (@NormedSpace.toModule.{0, u_4} Real E Real.normedField
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4) inst_5))))))
                    (ENNReal.toReal
                      (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
                        (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) μ
                        (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
                          (@NumStability.FiniteVolumeInterfaceMesh.toFiniteVolumeCellPartition.{u_1, u_2, u_3} Cell
                            Interface Point inst inst_1 mesh)
                          cell)))
                    (updatedCellAverages cell))
                  (@HSub.hSub.{u_4, u_4, u_4} E E E
                    (@instHSub.{u_4} E
                      (@SubNegMonoid.toSub.{u_4} E
                        (@AddGroup.toSubNegMonoid.{u_4} E
                          (@NormedAddGroup.toAddGroup.{u_4} E (@NormedAddCommGroup.toNormedAddGroup.{u_4} E inst_4)))))
                    (@HSMul.hSMul.{0, u_4, u_4} Real E E
                      (@instHSMul.{0, u_4} Real E
                        (@SMulZeroClass.toSMul.{0, u_4} Real E
                          (@AddZero.toZero.{u_4} E
                            (@AddZeroClass.toAddZero.{u_4} E
                              (@AddMonoid.toAddZeroClass.{u_4} E
                                (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                      (@UniformSpace.toTopologicalSpace.{u_4} E
                                        (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))))
                          (@DistribSMul.toSMulZeroClass.{0, u_4} Real E
                            (@AddMonoid.toAddZeroClass.{u_4} E
                              (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))
                            (@DistribMulAction.toDistribSMul.{0, u_4} Real E Real.instMonoid
                              (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4))))
                              (@Module.toDistribMulAction.{0, u_4} Real E Real.semiring
                                (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))
                                (@NormedSpace.toModule.{0, u_4} Real E Real.normedField
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4) inst_5))))))
                      (ENNReal.toReal
                        (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
                          (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) μ
                          (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
                            (@NumStability.FiniteVolumeInterfaceMesh.toFiniteVolumeCellPartition.{u_1, u_2, u_3} Cell
                              Interface Point inst inst_1 mesh)
                            cell)))
                      (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1
                        inst_4 inst_5 mesh μ conservedField cell))
                    (@HSMul.hSMul.{0, u_4, u_4} Real E E
                      (@instHSMul.{0, u_4} Real E
                        (@SMulZeroClass.toSMul.{0, u_4} Real E
                          (@AddZero.toZero.{u_4} E
                            (@AddZeroClass.toAddZero.{u_4} E
                              (@AddMonoid.toAddZeroClass.{u_4} E
                                (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                      (@UniformSpace.toTopologicalSpace.{u_4} E
                                        (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))))
                          (@DistribSMul.toSMulZeroClass.{0, u_4} Real E
                            (@AddMonoid.toAddZeroClass.{u_4} E
                              (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))
                            (@DistribMulAction.toDistribSMul.{0, u_4} Real E Real.instMonoid
                              (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4))))
                              (@Module.toDistribMulAction.{0, u_4} Real E Real.semiring
                                (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))
                                (@NormedSpace.toModule.{0, u_4} Real E Real.normedField
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4) inst_5))))))
                      (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) timeEnd timeStart)
                      (@NumStability.finiteVolumeNetOutwardFlux.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1
                        inst_2 inst_3 (@NormedAddCommGroup.toAddCommGroup.{u_4} E inst_4) mesh
                        (@NumStability.neighboringCellNumericalFlux.{u_1, u_2, u_3, u_4, u_4} Cell Interface Point E E
                          inst inst_1 mesh localNumericalFlux
                          (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst
                            inst_1 inst_4 inst_5 mesh μ conservedField))
                        cell))))
              (∀ (cells : Finset.{u_1} Cell),
                @Eq.{u_4 + 1} E
                  (@Finset.sum.{u_1, u_4} Cell E
                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_4} E
                      (@UniformSpace.toTopologicalSpace.{u_4} E
                        (@PseudoMetricSpace.toUniformSpace.{u_4} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                        (@UniformSpace.toTopologicalSpace.{u_4} E
                          (@PseudoMetricSpace.toUniformSpace.{u_4} E
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                        (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))
                    cells fun (cell : Cell) =>
                    @HSMul.hSMul.{0, u_4, u_4} Real E E
                      (@instHSMul.{0, u_4} Real E
                        (@SMulZeroClass.toSMul.{0, u_4} Real E
                          (@AddZero.toZero.{u_4} E
                            (@AddZeroClass.toAddZero.{u_4} E
                              (@AddMonoid.toAddZeroClass.{u_4} E
                                (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                      (@UniformSpace.toTopologicalSpace.{u_4} E
                                        (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))))
                          (@DistribSMul.toSMulZeroClass.{0, u_4} Real E
                            (@AddMonoid.toAddZeroClass.{u_4} E
                              (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))
                            (@DistribMulAction.toDistribSMul.{0, u_4} Real E Real.instMonoid
                              (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4))))
                              (@Module.toDistribMulAction.{0, u_4} Real E Real.semiring
                                (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))
                                (@NormedSpace.toModule.{0, u_4} Real E Real.normedField
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4) inst_5))))))
                      (ENNReal.toReal
                        (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
                          (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) μ
                          (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
                            (@NumStability.FiniteVolumeInterfaceMesh.toFiniteVolumeCellPartition.{u_1, u_2, u_3} Cell
                              Interface Point inst inst_1 mesh)
                            cell)))
                      (updatedCellAverages cell))
                  (@HSub.hSub.{u_4, u_4, u_4} E E E
                    (@instHSub.{u_4} E
                      (@SubNegMonoid.toSub.{u_4} E
                        (@AddGroup.toSubNegMonoid.{u_4} E
                          (@NormedAddGroup.toAddGroup.{u_4} E (@NormedAddCommGroup.toNormedAddGroup.{u_4} E inst_4)))))
                    (@Finset.sum.{u_1, u_4} Cell E
                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_4} E
                        (@UniformSpace.toTopologicalSpace.{u_4} E
                          (@PseudoMetricSpace.toUniformSpace.{u_4} E
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                          (@UniformSpace.toTopologicalSpace.{u_4} E
                            (@PseudoMetricSpace.toUniformSpace.{u_4} E
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                          (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))
                      cells fun (cell : Cell) =>
                      @HSMul.hSMul.{0, u_4, u_4} Real E E
                        (@instHSMul.{0, u_4} Real E
                          (@SMulZeroClass.toSMul.{0, u_4} Real E
                            (@AddZero.toZero.{u_4} E
                              (@AddZeroClass.toAddZero.{u_4} E
                                (@AddMonoid.toAddZeroClass.{u_4} E
                                  (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                      (@UniformSpace.toTopologicalSpace.{u_4} E
                                        (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                        (@UniformSpace.toTopologicalSpace.{u_4} E
                                          (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                        (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))))
                            (@DistribSMul.toSMulZeroClass.{0, u_4} Real E
                              (@AddMonoid.toAddZeroClass.{u_4} E
                                (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                      (@UniformSpace.toTopologicalSpace.{u_4} E
                                        (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))
                              (@DistribMulAction.toDistribSMul.{0, u_4} Real E Real.instMonoid
                                (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                      (@UniformSpace.toTopologicalSpace.{u_4} E
                                        (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4))))
                                (@Module.toDistribMulAction.{0, u_4} Real E Real.semiring
                                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                      (@UniformSpace.toTopologicalSpace.{u_4} E
                                        (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))
                                  (@NormedSpace.toModule.{0, u_4} Real E Real.normedField
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4) inst_5))))))
                        (ENNReal.toReal
                          (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst)
                            (Set.{u_3} Point) (fun (x : Set.{u_3} Point) => ENNReal)
                            (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) μ
                            (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
                              (@NumStability.FiniteVolumeInterfaceMesh.toFiniteVolumeCellPartition.{u_1, u_2, u_3} Cell
                                Interface Point inst inst_1 mesh)
                              cell)))
                        (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1
                          inst_4 inst_5 mesh μ conservedField cell))
                    (@HSMul.hSMul.{0, u_4, u_4} Real E E
                      (@instHSMul.{0, u_4} Real E
                        (@SMulZeroClass.toSMul.{0, u_4} Real E
                          (@AddZero.toZero.{u_4} E
                            (@AddZeroClass.toAddZero.{u_4} E
                              (@AddMonoid.toAddZeroClass.{u_4} E
                                (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                      (@UniformSpace.toTopologicalSpace.{u_4} E
                                        (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))))
                          (@DistribSMul.toSMulZeroClass.{0, u_4} Real E
                            (@AddMonoid.toAddZeroClass.{u_4} E
                              (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))))
                            (@DistribMulAction.toDistribSMul.{0, u_4} Real E Real.instMonoid
                              (@ESeminormedAddMonoid.toAddMonoid.{u_4} E
                                (@UniformSpace.toTopologicalSpace.{u_4} E
                                  (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                (@ESeminormedAddCommMonoid.toESeminormedAddMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4))))
                              (@Module.toDistribMulAction.{0, u_4} Real E Real.semiring
                                (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_4} E
                                  (@UniformSpace.toTopologicalSpace.{u_4} E
                                    (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_4} E
                                    (@UniformSpace.toTopologicalSpace.{u_4} E
                                      (@PseudoMetricSpace.toUniformSpace.{u_4} E
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4))))
                                    (@NormedAddCommGroup.toENormedAddCommMonoid.{u_4} E inst_4)))
                                (@NormedSpace.toModule.{0, u_4} Real E Real.normedField
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_4) inst_5))))))
                      (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) timeEnd timeStart)
                      (@NumStability.finiteVolumeBoundaryFlux.{u_1, u_2, u_3, u_4} Cell Interface Point E inst inst_1
                        inst_2 inst_3 (@NormedAddCommGroup.toAddCommGroup.{u_4} E inst_4) mesh
                        (@NumStability.neighboringCellNumericalFlux.{u_1, u_2, u_3, u_4, u_4} Cell Interface Point E E
                          inst inst_1 mesh localNumericalFlux
                          (@NumStability.finiteVolumeCellAverages.{u_1, u_2, u_3, u_4} Cell Interface Point E inst
                            inst_1 inst_4 inst_5 mesh μ conservedField))
                        cells))))))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`, `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference` imports: `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Module`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Tactic.Module`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.FiniteVolumeCellPartition.cellRegion`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `d0c5faafb12ba37fe6caa6161268436881416f82881f38a2a4b79e450af0089e`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace Point] → NumStability.FiniteVolumeCellPartition Cell Point → Cell → Set Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace.{u_2} Point] →
      (self : @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst) → Cell → Set.{u_2} Point
```

Definition body (one-level semantic boundary):

```lean
fun Cell Point [MeasurableSpace Point] self => self.2
```

### D002: `NumStability.FiniteVolumeInterfaceMesh`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `36d02005b0f0e0879560a8ba453ba2143bcc10c5ed1f1f139147379be55539ea`

Type:

```lean
Type u_1 →
  Type u_2 → (Point : Type u_3) → [MeasurableSpace Point] → [TopologicalSpace Point] → Type (max (max u_1 u_2) u_3)
```

Fully explicit type:

```lean
(Cell : Type u_1) →
  (Interface : Type u_2) →
    (Point : Type u_3) → [MeasurableSpace.{u_3} Point] → [TopologicalSpace.{u_3} Point] → Type (max (max u_1 u_2) u_3)
```

### D003: `NumStability.FiniteVolumeInterfaceMesh.leftCell`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8d1cf87d7f25261a9fffa021def916a9f4cd2e5d72e0d601d6cf007fef52cc88`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace Point] →
        [inst_1 : TopologicalSpace Point] →
          NumStability.FiniteVolumeInterfaceMesh Cell Interface Point → Interface → Cell
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace.{u_3} Point] →
        [inst_1 : TopologicalSpace.{u_3} Point] →
          (self : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1) →
            Interface → Cell
```

Definition body (one-level semantic boundary):

```lean
fun Cell Interface Point [MeasurableSpace Point] [TopologicalSpace Point] self => self.3
```

### D004: `NumStability.FiniteVolumeInterfaceMesh.rightCell`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `40e8c321a33e4159a9e139f51d8ca44db8b8b8de6935f39dfdb2b3cbe730e108`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace Point] →
        [inst_1 : TopologicalSpace Point] →
          NumStability.FiniteVolumeInterfaceMesh Cell Interface Point → Interface → Cell
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace.{u_3} Point] →
        [inst_1 : TopologicalSpace.{u_3} Point] →
          (self : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1) →
            Interface → Cell
```

Definition body (one-level semantic boundary):

```lean
fun Cell Interface Point [MeasurableSpace Point] [TopologicalSpace Point] self => self.4
```

### D005: `NumStability.FiniteVolumeInterfaceMesh.toFiniteVolumeCellPartition`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `b2287279161df471d21d6c2b17ec9bd83327c5c8961e684c6ba6e900b754a9be`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace Point] →
        [inst_1 : TopologicalSpace Point] →
          NumStability.FiniteVolumeInterfaceMesh Cell Interface Point →
            NumStability.FiniteVolumeCellPartition Cell Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace.{u_3} Point] →
        [inst_1 : TopologicalSpace.{u_3} Point] →
          (self : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1) →
            @NumStability.FiniteVolumeCellPartition.{u_1, u_3} Cell Point inst
```

Definition body (one-level semantic boundary):

```lean
fun Cell Interface Point [MeasurableSpace Point] [TopologicalSpace Point] self => self.1
```

### D006: `NumStability.IsCellVolumeAverage`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `21cd05067505b36e256af0d1c214a5dcc2f714d4a719ef199a54075de31db284`

Type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace Point] →
      [inst_1 : NormedAddCommGroup E] →
        [NormedSpace Real E] → MeasureTheory.Measure Point → Set Point → (Point → E) → E → Prop
```

Fully explicit type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace.{u_1} Point] →
      [inst_1 : NormedAddCommGroup.{u_2} E] →
        [@NormedSpace.{0, u_2} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1)] →
          (μ : @MeasureTheory.Measure.{u_1} Point inst) →
            (region : Set.{u_1} Point) → (field : Point → E) → (average : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Point} {E} [MeasurableSpace Point] [NormedAddCommGroup E] [NormedSpace Real E] μ region field average =>
  And (Ne (MeasureTheory.Measure.instFunLike.coe μ region) 0)
    (And (Ne (MeasureTheory.Measure.instFunLike.coe μ region) instTopENNReal.top)
      (And (MeasureTheory.IntegrableOn field region μ) (Eq average (NumStability.cellVolumeAverage μ region field))))
```

### D007: `NumStability.conservationLawInterfaceFlux`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `81eb699cbab5ed550a9c54ee56cbd6d3f4990683933a49b8f76e77a05d41a80e`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {State : Type u_4} →
        {Flux : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              NumStability.FiniteVolumeInterfaceMesh Cell Interface Point →
                (Point → State) → (State → Flux) → Interface → Flux
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {State : Type u_4} →
        {Flux : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            [inst_1 : TopologicalSpace.{u_3} Point] →
              (mesh : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1) →
                (conservedField : Point → State) → (physicalConservationFlux : State → Flux) → Interface → Flux
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} {Interface} {Point} {State} {Flux} [MeasurableSpace Point] [TopologicalSpace Point] mesh conservedField
    physicalConservationFlux interface =>
  physicalConservationFlux (conservedField (mesh.interfacePoint interface))
```

### D008: `NumStability.finiteVolumeBoundaryFlux`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8bbd6570f379d08f1262c9a6f6f8795dd805a2ca744f085173ff702f3ad41ff6`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {Flux : Type u_4} →
        [inst : MeasurableSpace Point] →
          [inst_1 : TopologicalSpace Point] →
            [Fintype Interface] →
              [DecidableEq Cell] →
                [AddCommGroup Flux] →
                  NumStability.FiniteVolumeInterfaceMesh Cell Interface Point → (Interface → Flux) → Finset Cell → Flux
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {Flux : Type u_4} →
        [inst : MeasurableSpace.{u_3} Point] →
          [inst_1 : TopologicalSpace.{u_3} Point] →
            [Fintype.{u_2} Interface] →
              [DecidableEq.{u_1 + 1} Cell] →
                [AddCommGroup.{u_4} Flux] →
                  (mesh : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1) →
                    (interfaceFlux : Interface → Flux) → (cells : Finset.{u_1} Cell) → Flux
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} {Interface} {Point} {Flux} [MeasurableSpace Point] [TopologicalSpace Point] [Fintype Interface]
    [DecidableEq Cell] [AddCommGroup Flux] mesh interfaceFlux cells =>
  Finset.univ.sum fun interface =>
    instHSub.hSub (ite (SetLike.instMembership.mem cells (mesh.leftCell interface)) (interfaceFlux interface) 0)
      (ite (SetLike.instMembership.mem cells (mesh.rightCell interface)) (interfaceFlux interface) 0)
```

### D009: `NumStability.finiteVolumeCellAverages`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d24033933f51602e598eccfcce5517e4d818aeb7387bb462b9259a2a3b389606`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {E : Type u_4} →
        [inst : MeasurableSpace Point] →
          [inst_1 : TopologicalSpace Point] →
            [inst_2 : NormedAddCommGroup E] →
              [NormedSpace Real E] →
                NumStability.FiniteVolumeInterfaceMesh Cell Interface Point →
                  MeasureTheory.Measure Point → (Point → E) → Cell → E
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {E : Type u_4} →
        [inst : MeasurableSpace.{u_3} Point] →
          [inst_1 : TopologicalSpace.{u_3} Point] →
            [inst_2 : NormedAddCommGroup.{u_4} E] →
              [@NormedSpace.{0, u_4} Real E Real.normedField
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst_2)] →
                (mesh : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1) →
                  (μ : @MeasureTheory.Measure.{u_3} Point inst) → (conservedField : Point → E) → Cell → E
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} {Interface} {Point} {E} [MeasurableSpace Point] [TopologicalSpace Point] [NormedAddCommGroup E]
    [NormedSpace Real E] mesh μ conservedField cell =>
  NumStability.cellVolumeAverage μ (mesh.cellRegion cell) conservedField
```

### D010: `NumStability.finiteVolumeNetOutwardFlux`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `693351d19ae1e8fcbc6bbf1b6351883232ab33f9d0d7bccd77395d8e2e02ce54`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {Flux : Type u_4} →
        [inst : MeasurableSpace Point] →
          [inst_1 : TopologicalSpace Point] →
            [Fintype Interface] →
              [DecidableEq Cell] →
                [AddCommGroup Flux] →
                  NumStability.FiniteVolumeInterfaceMesh Cell Interface Point → (Interface → Flux) → Cell → Flux
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {Flux : Type u_4} →
        [inst : MeasurableSpace.{u_3} Point] →
          [inst_1 : TopologicalSpace.{u_3} Point] →
            [Fintype.{u_2} Interface] →
              [DecidableEq.{u_1 + 1} Cell] →
                [AddCommGroup.{u_4} Flux] →
                  (mesh : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1) →
                    (interfaceFlux : Interface → Flux) → (cell : Cell) → Flux
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} {Interface} {Point} {Flux} [MeasurableSpace Point] [TopologicalSpace Point] [Fintype Interface]
    [DecidableEq Cell] [AddCommGroup Flux] mesh interfaceFlux cell =>
  Finset.univ.sum fun interface =>
    instHSub.hSub (ite (Eq (mesh.leftCell interface) cell) (interfaceFlux interface) 0)
      (ite (Eq (mesh.rightCell interface) cell) (interfaceFlux interface) 0)
```

### D011: `NumStability.neighboringCellNumericalFlux`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a3386f7c99245a12b97d09b4b8e0def0ab9d0f35db9125320a1326afe605724d`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {State : Type u_4} →
        {Flux : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              NumStability.FiniteVolumeInterfaceMesh Cell Interface Point →
                (State → State → Flux) → (Cell → State) → Interface → Flux
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      {State : Type u_4} →
        {Flux : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            [inst_1 : TopologicalSpace.{u_3} Point] →
              (mesh : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1) →
                (localNumericalFlux : State → State → Flux) → (cellAverages : Cell → State) → Interface → Flux
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} {Interface} {Point} {State} {Flux} [MeasurableSpace Point] [TopologicalSpace Point] mesh localNumericalFlux
    cellAverages interface =>
  localNumericalFlux (cellAverages (mesh.leftCell interface)) (cellAverages (mesh.rightCell interface))
```

### D012: `NumStability.FiniteVolumeCellPartition`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `541ff72eb500f2f48d4d8c6c3232a3e3b60e8177b3d5bbbddde2e2791cebff03`

Type:

```lean
Type u_1 → (Point : Type u_2) → [MeasurableSpace Point] → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Cell : Type u_1) → (Point : Type u_2) → [MeasurableSpace.{u_2} Point] → Type (max u_1 u_2)
```

### D013: `NumStability.FiniteVolumeInterfaceMesh.interfacePoint`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e46f316e0c6857b83aad8a7f09c377d456d46e3dc78fa7f98b5864ca02c3e341`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace Point] →
        [inst_1 : TopologicalSpace Point] →
          NumStability.FiniteVolumeInterfaceMesh Cell Interface Point → Interface → Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace.{u_3} Point] →
        [inst_1 : TopologicalSpace.{u_3} Point] →
          (self : @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1) →
            Interface → Point
```

Definition body (one-level semantic boundary):

```lean
fun Cell Interface Point [MeasurableSpace Point] [TopologicalSpace Point] self => self.6
```

### D014: `NumStability.FiniteVolumeInterfaceMesh.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `030fbcfecac1b286f2a217169b5980abdfab3eca51ea7c801ae4c7c253b04f9a`

Type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace Point] →
        [inst_1 : TopologicalSpace Point] →
          (toFiniteVolumeCellPartition : NumStability.FiniteVolumeCellPartition Cell Point) →
            Nonempty Interface →
              (leftCell rightCell : Interface → Cell) →
                (∀ (interface : Interface), Ne (leftCell interface) (rightCell interface)) →
                  (interfacePoint : Interface → Point) →
                    (∀ (interface : Interface),
                        Set.instMembership.mem toFiniteVolumeCellPartition.domain (interfacePoint interface)) →
                      (∀ (interface : Interface),
                          Set.instMembership.mem (closure (toFiniteVolumeCellPartition.cellRegion (leftCell interface)))
                            (interfacePoint interface)) →
                        (∀ (interface : Interface),
                            Set.instMembership.mem
                              (closure (toFiniteVolumeCellPartition.cellRegion (rightCell interface)))
                              (interfacePoint interface)) →
                          NumStability.FiniteVolumeInterfaceMesh Cell Interface Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Interface : Type u_2} →
    {Point : Type u_3} →
      [inst : MeasurableSpace.{u_3} Point] →
        [inst_1 : TopologicalSpace.{u_3} Point] →
          (toFiniteVolumeCellPartition : @NumStability.FiniteVolumeCellPartition.{u_1, u_3} Cell Point inst) →
            (interfaces_nonempty : Nonempty.{u_2 + 1} Interface) →
              (leftCell rightCell : Interface → Cell) →
                (leftCell_ne_rightCell :
                    ∀ (interface : Interface), @Ne.{u_1 + 1} Cell (leftCell interface) (rightCell interface)) →
                  (interfacePoint : Interface → Point) →
                    (interfacePoint_mem_domain :
                        ∀ (interface : Interface),
                          @Membership.mem.{u_3, u_3} Point (Set.{u_3} Point) (@Set.instMembership.{u_3} Point)
                            (@NumStability.FiniteVolumeCellPartition.domain.{u_1, u_3} Cell Point inst
                              toFiniteVolumeCellPartition)
                            (interfacePoint interface)) →
                      (interfacePoint_mem_leftCellClosure :
                          ∀ (interface : Interface),
                            @Membership.mem.{u_3, u_3} Point (Set.{u_3} Point) (@Set.instMembership.{u_3} Point)
                              (@closure.{u_3} Point inst_1
                                (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
                                  toFiniteVolumeCellPartition (leftCell interface)))
                              (interfacePoint interface)) →
                        (interfacePoint_mem_rightCellClosure :
                            ∀ (interface : Interface),
                              @Membership.mem.{u_3, u_3} Point (Set.{u_3} Point) (@Set.instMembership.{u_3} Point)
                                (@closure.{u_3} Point inst_1
                                  (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_1, u_3} Cell Point inst
                                    toFiniteVolumeCellPartition (rightCell interface)))
                                (interfacePoint interface)) →
                          @NumStability.FiniteVolumeInterfaceMesh.{u_1, u_2, u_3} Cell Interface Point inst inst_1
```

### D015: `NumStability.cellVolumeAverage`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `cf2e2e0d30c189de5352968f5369b343f70aa5ca34fa6e1ffb0e90675c639914`

Type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace Point] →
      [inst_1 : NormedAddCommGroup E] → [NormedSpace Real E] → MeasureTheory.Measure Point → Set Point → (Point → E) → E
```

Fully explicit type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace.{u_1} Point] →
      [inst_1 : NormedAddCommGroup.{u_2} E] →
        [@NormedSpace.{0, u_2} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1)] →
          (μ : @MeasureTheory.Measure.{u_1} Point inst) → (region : Set.{u_1} Point) → (field : Point → E) → E
```

Definition body (one-level semantic boundary):

```lean
fun {Point} {E} [MeasurableSpace Point] [NormedAddCommGroup E] [NormedSpace Real E] μ region field =>
  instHSMul.hSMul (Real.instInv.inv (MeasureTheory.Measure.instFunLike.coe μ region).toReal)
    (MeasureTheory.integral (μ.restrict region) fun point => field point)
```

### D016: `NumStability.FiniteVolumeCellPartition.domain`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `9cec13ba10bda6041ed3e4634aaa21482936f2d3b181ddeca5a8018010a05b84`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} → [inst : MeasurableSpace Point] → NumStability.FiniteVolumeCellPartition Cell Point → Set Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace.{u_2} Point] →
      (self : @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst) → Set.{u_2} Point
```

Definition body (one-level semantic boundary):

```lean
fun Cell Point [MeasurableSpace Point] self => self.1
```

### D017: `NumStability.FiniteVolumeCellPartition.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `70af43774fd5d6cca8bcbb4d47e87ca7c602c3cd2ed577cb1ccdab58fb896810`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace Point] →
      (domain : Set Point) →
        (cellRegion : Cell → Set Point) →
          Nonempty Cell →
            (∀ (cell : Cell), MeasurableSet (cellRegion cell)) →
              (∀ {cell₁ cell₂ : Cell}, Ne cell₁ cell₂ → Disjoint (cellRegion cell₁) (cellRegion cell₂)) →
                (∀ (point : Point),
                    Iff (Set.instMembership.mem domain point)
                      (Exists fun cell => Set.instMembership.mem (cellRegion cell) point)) →
                  NumStability.FiniteVolumeCellPartition Cell Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace.{u_2} Point] →
      (domain : Set.{u_2} Point) →
        (cellRegion : Cell → Set.{u_2} Point) →
          (cells_nonempty : Nonempty.{u_1 + 1} Cell) →
            (measurable_cell : ∀ (cell : Cell), @MeasurableSet.{u_2} Point inst (cellRegion cell)) →
              (disjoint_cells :
                  ∀ {cell₁ cell₂ : Cell},
                    @Ne.{u_1 + 1} Cell cell₁ cell₂ →
                      @Disjoint.{u_2} (Set.{u_2} Point)
                        (@OmegaCompletePartialOrder.toPartialOrder.{u_2} (Set.{u_2} Point)
                          (@CompleteLattice.instOmegaCompletePartialOrder.{u_2} (Set.{u_2} Point)
                            (@CompleteBooleanAlgebra.toCompleteLattice.{u_2} (Set.{u_2} Point)
                              (@CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra.{u_2} (Set.{u_2} Point)
                                (@Set.instCompleteAtomicBooleanAlgebra.{u_2} Point)))))
                        (@HeytingAlgebra.toOrderBot.{u_2} (Set.{u_2} Point)
                          (@Order.Frame.toHeytingAlgebra.{u_2} (Set.{u_2} Point)
                            (@CompleteDistribLattice.toFrame.{u_2} (Set.{u_2} Point)
                              (@CompleteBooleanAlgebra.toCompleteDistribLattice.{u_2} (Set.{u_2} Point)
                                (@CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra.{u_2} (Set.{u_2} Point)
                                  (@Set.instCompleteAtomicBooleanAlgebra.{u_2} Point))))))
                        (cellRegion cell₁) (cellRegion cell₂)) →
                (covers_domain :
                    ∀ (point : Point),
                      Iff
                        (@Membership.mem.{u_2, u_2} Point (Set.{u_2} Point) (@Set.instMembership.{u_2} Point) domain
                          point)
                        (@Exists.{u_1 + 1} Cell fun (cell : Cell) =>
                          @Membership.mem.{u_2, u_2} Point (Set.{u_2} Point) (@Set.instMembership.{u_2} Point)
                            (cellRegion cell) point)) →
                  @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst
```

### D018: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8c0fca6ee264d934b25c679f16be6b83bb2a2f7c58a8ac0afab0c146219e16a1`

Type:

```lean
{A : Type u} → [self : AddGroup A] → SubNegMonoid A
```

Fully explicit type:

```lean
{A : Type u} → [self : AddGroup.{u} A] → SubNegMonoid.{u} A
```

Definition body (one-level semantic boundary):

```lean
fun A [self : AddGroup A] => self.1
```

### D019: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4b5cfcaa0e3b1157089b486d5bfd51b9d15b881ea9cad302a6c8f701cae9ef1a`

Type:

```lean
{M : Type u} → [self : AddMonoid M] → AddZeroClass M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddMonoid.{u} M] → AddZeroClass.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toZero := self.toZero, toAdd := self.toAdd, zero_add := ⋯, add_zero := ⋯ }
```

### D020: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `aa06299f9d38f11e9dad40701d7541d8eba2a4ac673c643f4c5f5ce1369490cc`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Zero M
```

Fully explicit type:

```lean
{M : Type u_2} → [self : AddZero.{u_2} M] → Zero.{u_2} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.1
```

### D021: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8f64c653a96443ff67b52a5edb3fc264d279905b936c7303e9dd2469af000213`

Type:

```lean
{M : Type u} → [self : AddZeroClass M] → AddZero M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddZeroClass.{u} M] → AddZero.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZeroClass M] => self.1
```

### D022: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D023: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9db5c150b3c86d10b50e19602d0c0af9e5012dfe5f13b0d7b57925729f2478f0`

Type:

```lean
{F : Sort u_1} → {α : outParam (Sort u_2)} → {β : outParam (α → Sort u_3)} → [self : DFunLike F α β] → F → (a : α) → β a
```

Fully explicit type:

```lean
{F : Sort u_1} →
  {α : outParam.{u_2 + 1} (Sort u_2)} →
    {β : outParam.{max u_2 (u_3 + 1)} (α → Sort u_3)} → [self : DFunLike.{u_1, u_2, u_3} F α β] → F → (a : α) → β a
```

Definition body (one-level semantic boundary):

```lean
fun F {α} {β} [self : DFunLike F α β] => self.1
```

### D024: `DecidableEq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ceb5edcca38a0d8e0cbe42efd319eed4e877a75211690cacfd89ee5799fb1004`

Type:

```lean
Sort u → Sort (max 1 u)
```

Fully explicit type:

```lean
(α : Sort u) → Sort (max 1 u)
```

Definition body (one-level semantic boundary):

```lean
fun α => (a b : α) → Decidable (Eq a b)
```

### D025: `Dist.dist`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0317151292d4f2f69a403fb4cad22e6f162d91567334fd322bebacd914657851`

Type:

```lean
{α : Type u_3} → [self : Dist α] → α → α → Real
```

Fully explicit type:

```lean
{α : Type u_3} → [self : Dist.{u_3} α] → α → α → Real
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Dist α] => self.1
```

### D026: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `17a3c7e66a4c2897891d468da70a58e73aa0b8e044ea0cc90d8d6e9e51c08f02`

Type:

```lean
{M : Type u_1} → {A : Type u_7} → [inst : Monoid M] → [inst_1 : AddMonoid A] → [DistribMulAction M A] → DistribSMul M A
```

Fully explicit type:

```lean
{M : Type u_1} →
  {A : Type u_7} →
    [inst : Monoid.{u_1} M] →
      [inst_1 : AddMonoid.{u_7} A] →
        [@DistribMulAction.{u_1, u_7} M A inst inst_1] →
          @DistribSMul.{u_1, u_7} M A (@AddMonoid.toAddZeroClass.{u_7} A inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun {M} {A} [Monoid M] [AddMonoid A] [inst_2 : DistribMulAction M A] =>
  let __src := inst_2;
  { toSMul := __src.toSMul, smul_zero := ⋯, smul_add := ⋯ }
```

### D027: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f640928ea31b161891006aaf9950d636ac5e1fbda413a7712f36546c938b3fdf`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : AddZeroClass A} → [self : DistribSMul M A] → SMulZeroClass M A
```

Fully explicit type:

```lean
{M : Type u_12} →
  {A : Type u_13} →
    {inst : AddZeroClass.{u_13} A} →
      [self : @DistribSMul.{u_12, u_13} M A inst] →
        @SMulZeroClass.{u_12, u_13} M A (@AddZero.toZero.{u_13} A (@AddZeroClass.toAddZero.{u_13} A inst))
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : DistribSMul M A] => self.1
```

### D028: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5b8f4d61311ebccecf6a54ceca44191d394e0108c8596129a77f03c15a7e457f`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
WithTop NNReal
```

### D029: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1aa070f54e8aff7a6558c977220472990963777ddc5f04c5284f49422c06b41f`

Type:

```lean
ENNReal → Real
```

Fully explicit type:

```lean
(a : ENNReal) → Real
```

Definition body (one-level semantic boundary):

```lean
fun a => a.toNNReal.toReal
```

### D030: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7d58c19063063d627291b91068fa4bf2bf5ff88679897376ac465b9f52e93642`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ENormedAddCommMonoid E] → ESeminormedAddCommMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} →
  {inst : TopologicalSpace.{u_8} E} →
    [self : @ENormedAddCommMonoid.{u_8} E inst] → @ESeminormedAddCommMonoid.{u_8} E inst
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ENormedAddCommMonoid E] => self.1
```

### D031: `ESeminormedAddCommMonoid.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `38db724db757c42f8e8affdaa0b60310db98b78e8ba320c452775788f7191220`

Type:

```lean
{E : Type u_8} → [inst : TopologicalSpace E] → [self : ESeminormedAddCommMonoid E] → AddCommMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} →
  [inst : TopologicalSpace.{u_8} E] → [self : @ESeminormedAddCommMonoid.{u_8} E inst] → AddCommMonoid.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [TopologicalSpace E] self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D032: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ad2e3c6c509dab0e1668564037784368e6c01e3dc381545577f451993c8283a4`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddCommMonoid E] → ESeminormedAddMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} →
  {inst : TopologicalSpace.{u_8} E} →
    [self : @ESeminormedAddCommMonoid.{u_8} E inst] → @ESeminormedAddMonoid.{u_8} E inst
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddCommMonoid E] => self.1
```

### D033: `ESeminormedAddMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bf6ea4b699c55bfcdc7d32c89ca4d866413afa4dc5af86c3f4ff641d96cab901`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddMonoid E] → AddMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} → {inst : TopologicalSpace.{u_8} E} → [self : @ESeminormedAddMonoid.{u_8} E inst] → AddMonoid.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddMonoid E] => self.2
```

### D034: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

Fully explicit type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D035: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Prop
```

### D036: `Finset`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `56a880af39b5f8e2e55560abe97637994d5830a3a7ed0adaa46c44b8c3eaf831`

Type:

```lean
Type u_4 → Type u_4
```

Fully explicit type:

```lean
(α : Type u_4) → Type u_4
```

### D037: `Finset.sum`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.BigOperators.Group.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `931ceac4e9efb5833f58970d10ced4621362e020ea1119492a8d379b7e692372`

Type:

```lean
{ι : Type u_1} → {M : Type u_3} → [AddCommMonoid M] → Finset ι → (ι → M) → M
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : Type u_3} → [AddCommMonoid.{u_3} M] → (s : Finset.{u_1} ι) → (f : ι → M) → M
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [AddCommMonoid M] s f => (Multiset.map f s.val).sum
```

### D038: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Type:

```lean
Type u_4 → Type u_4
```

Fully explicit type:

```lean
(α : Type u_4) → Type u_4
```

### D039: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f1757307432fadbd23925bbf0a318b8da57d17711478e1073a19ce64c21d55f4`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSMul α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HSMul.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSMul α β γ] => self.1
```

### D040: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `98025b38d523c0eadea77ba4961a20b2a913b23c079c4bfeba24a7bfaa24a4bc`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSub α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HSub.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSub α β γ] => self.1
```

### D041: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Type:

```lean
{α : Type u} → [self : LT α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u} → [self : LT.{u} α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LT α] => self.1
```

### D042: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

Fully explicit type:

```lean
(α : Type u_7) → Type u_7
```

### D043: `MeasureTheory.IntegrableOn`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntegrableOn`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `dabc1688ef0e599a1f54ac0aa2c596e2bf70ce60ba22c33b537a76452e7cb6ed`

Type:

```lean
{α : Type u_1} →
  {ε : Type u_3} →
    {mα : MeasurableSpace α} →
      [inst : TopologicalSpace ε] →
        [ContinuousENorm ε] →
          (α → ε) → Set α → autoParam (MeasureTheory.Measure α) MeasureTheory.IntegrableOn._auto_1 → Prop
```

Fully explicit type:

```lean
{α : Type u_1} →
  {ε : Type u_3} →
    {mα : MeasurableSpace.{u_1} α} →
      [inst : TopologicalSpace.{u_3} ε] →
        [@ContinuousENorm.{u_3} ε inst] →
          (f : α → ε) →
            (s : Set.{u_1} α) →
              (μ : autoParam.{u_1 + 1} (@MeasureTheory.Measure.{u_1} α mα) MeasureTheory.IntegrableOn._auto_1) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {ε} {mα} [TopologicalSpace ε] [ContinuousENorm ε] f s μ => MeasureTheory.Integrable f (μ.restrict s)
```

### D044: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

Fully explicit type:

```lean
(α : Type u_6) → [MeasurableSpace.{u_6} α] → Type u_6
```

### D045: `MeasureTheory.Measure.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `94b2becf9230ce3d438e9b668f79f08e69dbe28c937b1aaca32d96e94b64a5b2`

Type:

```lean
{α : Type u_1} → [inst : MeasurableSpace α] → FunLike (MeasureTheory.Measure α) (Set α) ENNReal
```

Fully explicit type:

```lean
{α : Type u_1} →
  [inst : MeasurableSpace.{u_1} α] →
    FunLike.{u_1 + 1, u_1 + 1, 1} (@MeasureTheory.Measure.{u_1} α inst) (Set.{u_1} α) ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {α} [MeasurableSpace α] =>
  { coe := fun μ => MeasureTheory.OuterMeasure.instFunLikeSetENNReal.coe μ.toOuterMeasure, coe_injective' := ⋯ }
```

### D046: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Type:

```lean
{R : Type u} →
  {M : Type v} → {inst : Semiring R} → {inst_1 : AddCommMonoid M} → [self : Module R M] → DistribMulAction R M
```

Fully explicit type:

```lean
{R : Type u} →
  {M : Type v} →
    {inst : Semiring.{u} R} →
      {inst_1 : AddCommMonoid.{v} M} →
        [self : @Module.{u, v} R M inst inst_1] →
          @DistribMulAction.{u, v} R M (@MonoidWithZero.toMonoid.{u} R (@Semiring.toMonoidWithZero.{u} R inst))
            (@AddCommMonoid.toAddMonoid.{v} M inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun R M {inst} {inst_1} [self : Module R M] => self.1
```

### D047: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `635adc1f9e4a981a5c01b21338fdf89e637bd4ef0aa6911bda4dc03acfe9fba6`

Type:

```lean
{α : Sort u} → α → α → Prop
```

Fully explicit type:

```lean
{α : Sort u} → (a b : α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} a b => Not (Eq a b)
```

### D048: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

Fully explicit type:

```lean
(E : Type u_8) → Type u_8
```

### D049: `NormedAddCommGroup.toAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c92bdde4376567f29ebdebaf4a7dd986bfb96211cd0306e14540b80cd23009d2`

Type:

```lean
{E : Type u_8} → [self : NormedAddCommGroup E] → AddCommGroup E
```

Fully explicit type:

```lean
{E : Type u_8} → [self : NormedAddCommGroup.{u_8} E] → AddCommGroup.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : NormedAddCommGroup E] => self.2
```

### D050: `NormedAddCommGroup.toENormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `eac639a9ae15f19554f668c9811538a135f4f05df04330bd8145b300efe57cfb`

Type:

```lean
{E : Type u_4} → [inst : NormedAddCommGroup E] → ENormedAddCommMonoid E
```

Fully explicit type:

```lean
{E : Type u_4} →
  [inst : NormedAddCommGroup.{u_4} E] →
    @ENormedAddCommMonoid.{u_4} E
      (@UniformSpace.toTopologicalSpace.{u_4} E
        (@PseudoMetricSpace.toUniformSpace.{u_4} E
          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst))))
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  let __spread.0 := NormedAddGroup.toENormedAddMonoid;
  have __spread.1 := inst;
  { toESeminormedAddMonoid := __spread.0.toESeminormedAddMonoid, add_comm := ⋯, enorm_eq_zero := ⋯ }
```

### D051: `NormedAddCommGroup.toNormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cdc7999c66248f7b0f68477de30ff4d9ea7a7f0df0bc6f092bc024f699d646fe`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → NormedAddGroup E
```

Fully explicit type:

```lean
{E : Type u_5} → [NormedAddCommGroup.{u_5} E] → NormedAddGroup.{u_5} E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯ }
```

### D052: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → SeminormedAddCommGroup E
```

Fully explicit type:

```lean
{E : Type u_5} → [NormedAddCommGroup.{u_5} E] → SeminormedAddCommGroup.{u_5} E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D053: `NormedAddGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `06ba17aab699c28aaa8877d0b107536ebd2aefd8bf59143b2357c84bb820d89e`

Type:

```lean
{E : Type u_8} → [self : NormedAddGroup E] → AddGroup E
```

Fully explicit type:

```lean
{E : Type u_8} → [self : NormedAddGroup.{u_8} E] → AddGroup.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : NormedAddGroup E] => self.2
```

### D054: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

Fully explicit type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField.{u_6} 𝕜] → [SeminormedAddCommGroup.{u_7} E] → Type (max u_6 u_7)
```

### D055: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Type:

```lean
{𝕜 : Type u_6} →
  {E : Type u_7} → {inst : NormedField 𝕜} → {inst_1 : SeminormedAddCommGroup E} → [self : NormedSpace 𝕜 E] → Module 𝕜 E
```

Fully explicit type:

```lean
{𝕜 : Type u_6} →
  {E : Type u_7} →
    {inst : NormedField.{u_6} 𝕜} →
      {inst_1 : SeminormedAddCommGroup.{u_7} E} →
        [self : @NormedSpace.{u_6, u_7} 𝕜 E inst inst_1] →
          @Module.{u_6, u_7} 𝕜 E
            (@DivisionSemiring.toSemiring.{u_6} 𝕜
              (@Semifield.toDivisionSemiring.{u_6} 𝕜 (@Field.toSemifield.{u_6} 𝕜 (@NormedField.toField.{u_6} 𝕜 inst))))
            (@AddCommGroup.toAddCommMonoid.{u_7} E (@SeminormedAddCommGroup.toAddCommGroup.{u_7} E inst_1))
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : NormedSpace 𝕜 E] => self.1
```

### D056: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Type:

```lean
{α : Type u} → (x : Nat) → [self : OfNat α x] → α
```

Fully explicit type:

```lean
{α : Type u} → (x : Nat) → [self : OfNat.{u} α x] → α
```

Definition body (one-level semantic boundary):

```lean
fun α x [self : OfNat α x] => self.1
```

### D057: `PseudoMetricSpace.toDist`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fa467f9e7a02f275bcca2268e14eb56a268d0a9e342eda05224326df8fadae8f`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → Dist α
```

Fully explicit type:

```lean
{α : Type u} → [self : PseudoMetricSpace.{u} α] → Dist.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.1
```

### D058: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Fully explicit type:

```lean
{α : Type u} → [self : PseudoMetricSpace.{u} α] → UniformSpace.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D059: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D060: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Type:

```lean
LT Real
```

Fully explicit type:

```lean
LT.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ lt := Real.lt✝ }
```

### D061: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Type:

```lean
Monoid Real
```

Fully explicit type:

```lean
Monoid.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D062: `Real.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `926d9e8fcca2819a885d446e168b20c7c8aac2e542d59ed2b48e32c9a4659a36`

Type:

```lean
Sub Real
```

Fully explicit type:

```lean
Sub.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ sub := fun a b => instHAdd.hAdd a (Real.instNeg.neg b) }
```

### D063: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Type:

```lean
Zero Real
```

Fully explicit type:

```lean
Zero.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ zero := Real.zero✝ }
```

### D064: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Type:

```lean
NormedField Real
```

Fully explicit type:

```lean
NormedField.{0} Real
```

Definition body (one-level semantic boundary):

```lean
let __src := Real.normedAddCommGroup;
let __src_1 := Real.instField;
{ toNorm := __src.toNorm, toAddMonoid := __src.toAddMonoid, add_comm := Real.normedField._proof_1,
  toMul := __src_1.toMul, left_distrib := Real.normedField._proof_2, right_distrib := Real.normedField._proof_3,
  zero_mul := Real.normedField._proof_4, mul_zero := Real.normedField._proof_5, mul_assoc := Real.normedField._proof_6,
  toOne := __src_1.toOne, one_mul := Real.normedField._proof_7, mul_one := Real.normedField._proof_8,
  toNatCast := __src_1.toNatCast, natCast_zero := Real.normedField._proof_9, natCast_succ := Real.normedField._proof_10,
  npow := __src_1.npow, npow_zero := Real.normedField._proof_11, npow_succ := Real.normedField._proof_12,
  toNeg := __src.toNeg, toSub := __src.toSub, sub_eq_add_neg := Real.normedField._proof_13, zsmul := __src.zsmul,
  zsmul_zero' := Real.normedField._proof_14, zsmul_succ' := Real.normedField._proof_15,
  zsmul_neg' := Real.normedField._proof_16, neg_add_cancel := Real.normedField._proof_17,
  toIntCast := __src_1.toIntCast, intCast_ofNat := Real.normedField._proof_18,
  intCast_negSucc := Real.normedField._proof_19, mul_comm := Real.normedField._proof_20, toInv := __src_1.toInv,
  toDiv := __src_1.toDiv, div_eq_mul_inv := ⋯, zpow := __src_1.zpow, zpow_zero' := ⋯, zpow_succ' := ⋯, zpow_neg' := ⋯,
  toNontrivial := ⋯, toNNRatCast := __src_1.toNNRatCast, toRatCast := __src_1.toRatCast, mul_inv_cancel := ⋯,
  inv_zero := ⋯, nnratCast_def := ⋯, nnqsmul := __src_1.nnqsmul, nnqsmul_def := ⋯, ratCast_def := ⋯,
  qsmul := __src_1.qsmul, qsmul_def := ⋯, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯, norm_mul := ⋯ }
```

### D065: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Type:

```lean
Semiring Real
```

Fully explicit type:

```lean
Semiring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D066: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a8cadadddb0c9fd4a7bcb7c57401fafb43a1f330afa35fdacacb6d0e82d0bcf6`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : Zero A} → [self : SMulZeroClass M A] → SMul M A
```

Fully explicit type:

```lean
{M : Type u_12} →
  {A : Type u_13} → {inst : Zero.{u_13} A} → [self : @SMulZeroClass.{u_12, u_13} M A inst] → SMul.{u_12, u_13} M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : SMulZeroClass M A] => self.1
```

### D067: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3f8499f7dfc2e8115a48b4ac0bec5328dd7223a18dd71fc0061e711fbd543126`

Type:

```lean
{E : Type u_8} → [self : SeminormedAddCommGroup E] → PseudoMetricSpace E
```

Fully explicit type:

```lean
{E : Type u_8} → [self : SeminormedAddCommGroup.{u_8} E] → PseudoMetricSpace.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : SeminormedAddCommGroup E] => self.3
```

### D068: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8cf35215f509cdee10a3a95158cbaadd3c5fb584bc0d1f4fad6ecfc69b1bd205`

Type:

```lean
{E : Type u_5} → [SeminormedAddCommGroup E] → SeminormedAddGroup E
```

Fully explicit type:

```lean
{E : Type u_5} → [SeminormedAddCommGroup.{u_5} E] → SeminormedAddGroup.{u_5} E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : SeminormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D069: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `17a83cbf3059dd0bbaefd43c93ce329f1d6b760d440889322b3582a18b23a141`

Type:

```lean
{E : Type u_4} → [inst : SeminormedAddGroup E] → ContinuousENorm E
```

Fully explicit type:

```lean
{E : Type u_4} →
  [inst : SeminormedAddGroup.{u_4} E] →
    @ContinuousENorm.{u_4} E
      (@UniformSpace.toTopologicalSpace.{u_4} E
        (@PseudoMetricSpace.toUniformSpace.{u_4} E (@SeminormedAddGroup.toPseudoMetricSpace.{u_4} E inst)))
```

Definition body (one-level semantic boundary):

```lean
fun {E} [SeminormedAddGroup E] => { toENorm := NNNorm.toENorm, continuous_enorm := ⋯ }
```

### D070: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a6e551515032966c16e4f42e4548ff1854c2dce05ffe51e98b66943caecc78ec`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

Definition body (one-level semantic boundary):

```lean
fun α => α → Prop
```

### D071: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f60885ee7a5e97dbc3d343ecb54849b15ae9ca7cc989f350d3b7fee2d2d0724b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → Sub G
```

Fully explicit type:

```lean
{G : Type u} → [self : SubNegMonoid.{u} G] → Sub.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.3
```

### D072: `Top.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Notation`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `32c978930b5eb9164add86b32aeacdc99d2d10df09b4b1989d12a6e346774504`

Type:

```lean
{α : Type u_1} → [self : Top α] → α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : Top.{u_1} α] → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Top α] => self.1
```

### D073: `TopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `c85328c9b77ed49bcba2dd67e9f87b53aaf251834d29c69856ef079a9ec4b57b`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(X : Type u) → Type u
```

### D074: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Fully explicit type:

```lean
{α : Type u} → [self : UniformSpace.{u} α] → TopologicalSpace.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
```

### D075: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Type:

```lean
{α : Type u_1} → [Zero α] → OfNat α 0
```

Fully explicit type:

```lean
{α : Type u_1} → [Zero.{u_1} α] → OfNat.{u_1} α (nat_lit 0)
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Zero α] => { ofNat := inst.zero }
```

### D076: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `04ea7c06812eccb8531b763b7aa28fd8f968befff069e74166ff1b406f7512e3`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [SMul α β] → HSMul α β β
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → [SMul.{u_1, u_2} α β] → HSMul.{u_1, u_2, u_2} α β β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : SMul α β] => { hSMul := inst.smul }
```

### D077: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `aa782f2b5af3d068f4c5340de4b32b193fece2c659a45582cc3024a19b550c87`

Type:

```lean
{α : Type u_1} → [Sub α] → HSub α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Sub.{u_1} α] → HSub.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Sub α] => { hSub := fun a b => inst.sub a b }
```

### D078: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `fc363bb86fd9c29e754e22d842cff17acbad13559cb0e03d31f4863045cd3c07`

Type:

```lean
Top ENNReal
```

Fully explicit type:

```lean
Top.{0} ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.top
```

### D079: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `6e5878abb65d5809d3258e569c8ff0f08b39804b377a07fec18d700b4e3fea86`

Type:

```lean
Zero ENNReal
```

Fully explicit type:

```lean
Zero.{0} ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.zero
```

### D080: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(G : Type u) → Type u
```

### D081: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f727c3f01db957bd004eab61d742db6d02c6f9b2cdad465fa6f0ac214e09ccfd`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddCommMonoid G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommGroup.{u} G] → AddCommMonoid.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D082: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `7f49725cf4bc16610110860af8f38e6d0fe472c7c1af93721407bad8c7375729`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddGroup G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommGroup.{u} G] → AddGroup.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : AddCommGroup G] => self.1
```

### D083: `AddCommGroup.toDivisionAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `72951116f9ecb1048b235282fec669b8c3dfd809e3810c987dc6f18968d013d3`

Type:

```lean
{G : Type u_1} → [AddCommGroup G] → SubtractionCommMonoid G
```

Fully explicit type:

```lean
{G : Type u_1} → [AddCommGroup.{u_1} G] → SubtractionCommMonoid.{u_1} G
```

Definition body (one-level semantic boundary):

```lean
fun {G} [inst : AddCommGroup G] =>
  let __src := inst;
  let __src_1 := AddGroup.toSubtractionMonoid;
  { toSubNegMonoid := __src.toSubNegMonoid, neg_neg := ⋯, neg_add_rev := ⋯, neg_eq_of_add := ⋯, add_comm := ⋯ }
```

### D084: `Finset.decidableMem`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6265a6c308d7d4e34391342149b97b283c647b57ec6c25f98fe1e2192ac05af7`

Type:

```lean
{α : Type u_1} → [_h : DecidableEq α] → (a : α) → (s : Finset α) → Decidable (SetLike.instMembership.mem s a)
```

Fully explicit type:

```lean
{α : Type u_1} →
  [_h : DecidableEq.{u_1 + 1} α] →
    (a : α) →
      (s : Finset.{u_1} α) →
        Decidable
          (@Membership.mem.{u_1, u_1} α (Finset.{u_1} α)
            (@SetLike.instMembership.{u_1, u_1} (Finset.{u_1} α) α (@Finset.instSetLike.{u_1} α)) s a)
```

Definition body (one-level semantic boundary):

```lean
fun {α} [DecidableEq α] a s => Multiset.decidableMem a s.val
```

### D085: `Finset.instSetLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f43bd57c8a5e05334ba371d3e354fb5f1cd42a3177ae342e6448d872bd6428b6`

Type:

```lean
{α : Type u_1} → SetLike (Finset α) α
```

Fully explicit type:

```lean
{α : Type u_1} → SetLike.{u_1, u_1} (Finset.{u_1} α) α
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { coe := fun s => setOf fun a => Multiset.instMembership.mem s.val a, coe_injective' := ⋯ }
```

### D086: `Finset.univ`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `194413a784fbc0b27d0cb6b1ab67ed060210172bf16ba24045aa439e58f9a8c7`

Type:

```lean
{α : Type u_1} → [Fintype α] → Finset α
```

Fully explicit type:

```lean
{α : Type u_1} → [Fintype.{u_1} α] → Finset.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Fintype α] => inst.elems
```

### D087: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `941ea3346e809f919727c21bfcdeea342714a6b83f1cf871d648aa2cb14d6e9e`

Type:

```lean
{α : outParam (Type u)} → {γ : Type v} → [self : Membership α γ] → γ → α → Prop
```

Fully explicit type:

```lean
{α : outParam.{u + 2} (Type u)} → {γ : Type v} → [self : Membership.{u, v} α γ] → γ → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} γ [self : Membership α γ] => self.1
```

### D088: `NegZeroClass.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `881414a459dbdc250afc9bc468e98b17f776dfd31f2aa5eb9acee71a8d1543f7`

Type:

```lean
{G : Type u_2} → [self : NegZeroClass G] → Zero G
```

Fully explicit type:

```lean
{G : Type u_2} → [self : NegZeroClass.{u_2} G] → Zero.{u_2} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : NegZeroClass G] => self.1
```

### D089: `SetLike.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.SetLike.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `47a75450bbb51c4e8fdd9e8881cc3fa741dfb5f1f186d952055686e285c081e4`

Type:

```lean
{A : Type u_1} → {B : Type u_2} → [i : SetLike A B] → Membership B A
```

Fully explicit type:

```lean
{A : Type u_1} → {B : Type u_2} → [i : SetLike.{u_1, u_2} A B] → Membership.{u_2, u_1} B A
```

Definition body (one-level semantic boundary):

```lean
fun {A} {B} [i : SetLike A B] => { mem := fun p x => Set.instMembership.mem (i.coe p) x }
```

### D090: `SubNegZeroMonoid.toNegZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `0ca9c4737492ec2a9a5ab16ab065d00204507f2caf80997692c360afbf962577`

Type:

```lean
{G : Type u_2} → [self : SubNegZeroMonoid G] → NegZeroClass G
```

Fully explicit type:

```lean
{G : Type u_2} → [self : SubNegZeroMonoid.{u_2} G] → NegZeroClass.{u_2} G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toZero := self.toZero, toNeg := self.toNeg, neg_zero := ⋯ }
```

### D091: `SubtractionCommMonoid.toSubtractionMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e56d8d718ddbe8a62b0e5b703adfd59bd19f46dac79c341b3d3742ed6ee462c9`

Type:

```lean
{G : Type u} → [self : SubtractionCommMonoid G] → SubtractionMonoid G
```

Fully explicit type:

```lean
{G : Type u} → [self : SubtractionCommMonoid.{u} G] → SubtractionMonoid.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubtractionCommMonoid G] => self.1
```

### D092: `SubtractionMonoid.toSubNegZeroMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `700a470249543a704f0b5910309b7d1f4c918e3b645f806242c291c98eff4e28`

Type:

```lean
{α : Type u_1} → [SubtractionMonoid α] → SubNegZeroMonoid α
```

Fully explicit type:

```lean
{α : Type u_1} → [SubtractionMonoid.{u_1} α] → SubNegZeroMonoid.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : SubtractionMonoid α] =>
  let __src := inst.toSubNegMonoid;
  { toSubNegMonoid := __src, neg_zero := ⋯ }
```

### D093: `ite`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3029bae29d2d16b5aeb879ad3c12a1b3c4e78998083bf1ab4614942fafdece0e`

Type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → α → α → α
```

Fully explicit type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → (t e : α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} c [h : Decidable c] t e => Decidable.casesOn h (fun x => e) fun x => t
```

### D094: `Inv.inv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `c3aea3c6e2edd31a7b2cf071814315808ef7d84fd01d8c9b719313846ebca438`

Type:

```lean
{α : Type u} → [self : Inv α] → α → α
```

Fully explicit type:

```lean
{α : Type u} → [self : Inv.{u} α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Inv α] => self.1
```

### D095: `MeasureTheory.Measure.restrict`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Restrict`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `63c4446a3ae02833cbb1104dcc4f2ea534c0eae36f5642bfa8858a6593aa11e8`

Type:

```lean
{α : Type u_2} → {_m0 : MeasurableSpace α} → MeasureTheory.Measure α → Set α → MeasureTheory.Measure α
```

Fully explicit type:

```lean
{α : Type u_2} →
  {_m0 : MeasurableSpace.{u_2} α} →
    (μ : @MeasureTheory.Measure.{u_2} α _m0) → (s : Set.{u_2} α) → @MeasureTheory.Measure.{u_2} α _m0
```

Definition body (one-level semantic boundary):

```lean
fun {α} {_m0} μ s => LinearMap.instFunLike.coe (MeasureTheory.Measure.restrictₗ s) μ
```

### D096: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `428563f3d6b771605a3267457bf33b62ec2efa91a42b57b96121b85c0269a9ab`

Type:

```lean
{α : Type u_6} →
  {G : Type u_7} →
    [inst : NormedAddCommGroup G] →
      [NormedSpace Real G] → {x : MeasurableSpace α} → MeasureTheory.Measure α → (α → G) → G
```

Fully explicit type:

```lean
{α : Type u_6} →
  {G : Type u_7} →
    [inst : NormedAddCommGroup.{u_7} G] →
      [@NormedSpace.{0, u_7} Real G Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_7} G inst)] →
        {x : MeasurableSpace.{u_6} α} → (μ : @MeasureTheory.Measure.{u_6} α x) → (f : α → G) → G
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.wrapped✝.1
```

### D097: `Nonempty`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `37c79de378d44cb9dc334502b161bb140da0544579086aded2cf83ff99c462c7`

Type:

```lean
Sort u → Prop
```

Fully explicit type:

```lean
(α : Sort u) → Prop
```

### D098: `Real.instInv`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `8996fd673a1e2289aaf761085a60a161bdafebda8cdd48d1efb3c89da1382980`

Type:

```lean
Inv Real
```

Fully explicit type:

```lean
Inv.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ inv := Real.inv'✝ }
```

### D099: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5858be77d319c5a0e238602f16818ed6fb2e2b52a81ff7edb07bc219d652f201`

Type:

```lean
{α : Type u} → Membership α (Set α)
```

Fully explicit type:

```lean
{α : Type u} → Membership.{u, u} α (Set.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { mem := Set.Mem }
```

### D100: `closure`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `581a7071ff8fbc236d0005c1e7b3ef84a2ffaaab4eb7812b63823d4654a40942`

Type:

```lean
{X : Type u} → [TopologicalSpace X] → Set X → Set X
```

Fully explicit type:

```lean
{X : Type u} → [TopologicalSpace.{u} X] → (s : Set.{u} X) → Set.{u} X
```

Definition body (one-level semantic boundary):

```lean
fun {X} [TopologicalSpace X] s => (setOf fun t => And (IsClosed t) (Set.instHasSubset.Subset s t)).sInter
```

### D101: `CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `3a25d65eea18eac65c870b595439bf5f5b25e6d990cea7e3a635eb81bad4a258`

Type:

```lean
{α : Type u} → [self : CompleteAtomicBooleanAlgebra α] → CompleteBooleanAlgebra α
```

Fully explicit type:

```lean
{α : Type u} → [self : CompleteAtomicBooleanAlgebra.{u} α] → CompleteBooleanAlgebra.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompleteAtomicBooleanAlgebra α] => self.1
```

### D102: `CompleteBooleanAlgebra.toCompleteDistribLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `5b7b6334d9d65401dbf1e65d1fba2f464f54b88cbfb541ea9f6fe64419b9d357`

Type:

```lean
{α : Type u} → [CompleteBooleanAlgebra α] → CompleteDistribLattice α
```

Fully explicit type:

```lean
{α : Type u} → [CompleteBooleanAlgebra.{u} α] → CompleteDistribLattice.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : CompleteBooleanAlgebra α] =>
  let __spread.0 := inst;
  let __spread.1 := BooleanAlgebra.toBiheytingAlgebra;
  { toCompleteLattice := __spread.0.toCompleteLattice, toHImp := __spread.0.toHImp, le_himp_iff := ⋯,
    toCompl := __spread.0.toCompl, himp_bot := ⋯, toSDiff := __spread.0.toSDiff, sdiff_le_iff := ⋯,
    toHNot := __spread.1.toHNot, top_sdiff := ⋯ }
```

### D103: `CompleteBooleanAlgebra.toCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `ef39a255ef10c0230be1cee558369fc7eb1b981c98d0e640e56097b98344a675`

Type:

```lean
{α : Type u_1} → [self : CompleteBooleanAlgebra α] → CompleteLattice α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : CompleteBooleanAlgebra.{u_1} α] → CompleteLattice.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompleteBooleanAlgebra α] => self.1
```

### D104: `CompleteDistribLattice.toFrame`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `9575e3922b928b13137e39541f6916c83a8c3d846f283ef286612bada2e926b1`

Type:

```lean
{α : Type u_1} → [self : CompleteDistribLattice α] → Order.Frame α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : CompleteDistribLattice.{u_1} α] → Order.Frame.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompleteDistribLattice α] => self.1
```

### D105: `CompleteLattice.instOmegaCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `a588686a2b08b742c60791d874ae481ba89fc2f75533682f87dbe461bb89639e`

Type:

```lean
{α : Type u_2} → [CompleteLattice α] → OmegaCompletePartialOrder α
```

Fully explicit type:

```lean
{α : Type u_2} → [CompleteLattice.{u_2} α] → OmegaCompletePartialOrder.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : CompleteLattice α] =>
  { toPartialOrder := inst.toCompleteSemilatticeInf.toPartialOrder,
    ωSup := fun c => iSup fun i => OmegaCompletePartialOrder.Chain.instFunLikeNat.coe c i, le_ωSup := ⋯, ωSup_le := ⋯ }
```

### D106: `Disjoint`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Disjoint`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `b3c1a3f72029bdabf392b01ef59e09df14985ee45c8304a6e3013b31345ac3bb`

Type:

```lean
{α : Type u_1} → [inst : PartialOrder α] → [OrderBot α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} →
  [inst : PartialOrder.{u_1} α] →
    [@OrderBot.{u_1} α (@Preorder.toLE.{u_1} α (@PartialOrder.toPreorder.{u_1} α inst))] → (a b : α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : PartialOrder α] [inst_1 : OrderBot α] a b => ∀ ⦃x : α⦄, inst.le x a → inst.le x b → inst.le x inst_1.bot
```

### D107: `HeytingAlgebra.toOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Heyting.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `2ee82a12c7227f6741bb957fb8033ec6bd4dc5696e0118ba976cd5cc433ce74c`

Type:

```lean
{α : Type u_4} → [self : HeytingAlgebra α] → OrderBot α
```

Fully explicit type:

```lean
{α : Type u_4} →
  [self : HeytingAlgebra.{u_4} α] →
    @OrderBot.{u_4} α
      (@Preorder.toLE.{u_4} α
        (@PartialOrder.toPreorder.{u_4} α
          (@SemilatticeSup.toPartialOrder.{u_4} α
            (@Lattice.toSemilatticeSup.{u_4} α
              (@GeneralizedHeytingAlgebra.toLattice.{u_4} α
                (@HeytingAlgebra.toGeneralizedHeytingAlgebra.{u_4} α self))))))
```

Definition body (one-level semantic boundary):

```lean
fun α [self : HeytingAlgebra α] => self.2
```

### D108: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D109: `MeasurableSet`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `2e9235174f4747f2e37b86692acc96182e23810c202fe6e159a326c4a72cf4ff`

Type:

```lean
{α : Type u_1} → [MeasurableSpace α] → Set α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → [MeasurableSpace.{u_1} α] → (s : Set.{u_1} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : MeasurableSpace α] s => inst.MeasurableSet' s
```

### D110: `OmegaCompletePartialOrder.toPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `04c999d7f177b80a86d128413a961873b394ba8a928e9f40ec1711b6050fc2de`

Type:

```lean
{α : Type u_6} → [self : OmegaCompletePartialOrder α] → PartialOrder α
```

Fully explicit type:

```lean
{α : Type u_6} → [self : OmegaCompletePartialOrder.{u_6} α] → PartialOrder.{u_6} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : OmegaCompletePartialOrder α] => self.1
```

### D111: `Order.Frame.toHeytingAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `d4cf848cdacfde27a40baabeb09bc470dcfcc4d195ff7dedbad201a5ff6a03ab`

Type:

```lean
{α : Type u_1} → [self : Order.Frame α] → HeytingAlgebra α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : Order.Frame.{u_1} α] → HeytingAlgebra.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toLattice := self.toLattice, toOrderTop := self.toOrderTop, toHImp := self.toHImp, le_himp_iff := ⋯,
    toOrderBot := self.toOrderBot, toCompl := self.toCompl, himp_bot := ⋯ }
```

### D112: `Set.instCompleteAtomicBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.BooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `5ebef163c77bbddf9cd7439ed0b00fe337f343e5a1bbb203a126211604f9e398`

Type:

```lean
{α : Type u_1} → CompleteAtomicBooleanAlgebra (Set α)
```

Fully explicit type:

```lean
{α : Type u_1} → CompleteAtomicBooleanAlgebra.{u_1} (Set.{u_1} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} =>
  let __src := Set.instBooleanAlgebra;
  { toLattice := __src.toLattice, toSupSet := Set.instSupSet, le_sSup := ⋯, sSup_le := ⋯, toInfSet := Set.instInfSet,
    sInf_le := ⋯, le_sInf := ⋯, toTop := __src.toTop, le_top := ⋯, toBot := __src.toBot, bot_le := ⋯, le_sup_inf := ⋯,
    toCompl := __src.toCompl, toSDiff := __src.toSDiff, toHImp := __src.toHImp, inf_compl_le_bot := ⋯,
    top_le_sup_compl := ⋯, sdiff_eq := ⋯, himp_eq := ⋯, iInf_iSup_eq := ⋯ }
```

## Complete local imported sources

### `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`

Path: `NumStability/Analysis/PartialDifferentialEquations/FiniteVolume/FluxDifference.lean`
SHA-256: `e44e135d4047068af4fc5498d3842c408607e352f09fa07b35eee0c4e493b190`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.BigOperators.Module
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Module

/-!
# Conservative finite-volume flux differences

Source-independent data for a one-dimensional conservative update.  Interface
flux `edgeFlux i` is the flux through the left edge of cell `i`, so the update
subtracts the right-minus-left flux difference.  The finite-sum theorem makes
the resulting boundary-flux conservation exact.
-/

open scoped BigOperators

namespace NumStability

/-- One conservative flux-difference update of cell `i`.

`timeStepOverCellWidth` is the usual ratio `Δt / Δx`; keeping it abstract
also covers non-dimensionalized updates. -/
def conservativeFluxDifferenceUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℕ → E) (i : ℕ) : E :=
  cellAverages i -
    timeStepOverCellWidth • (edgeFlux (i + 1) - edgeFlux i)

/-- The same conservative edge-flux update on integer-indexed cells. -/
def conservativeFluxDifferenceUpdateInt
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℤ → E) (i : ℤ) : E :=
  cellAverages i -
    timeStepOverCellWidth • (edgeFlux (i + 1) - edgeFlux i)

/-- Summing a conservative flux-difference update over the first `cellCount`
cells cancels every interior interface flux.  Only the two boundary fluxes
remain. -/
theorem sum_conservativeFluxDifferenceUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℕ → E) (cellCount : ℕ) :
    ∑ i ∈ Finset.range cellCount,
        conservativeFluxDifferenceUpdate
          timeStepOverCellWidth cellAverages edgeFlux i =
      (∑ i ∈ Finset.range cellCount, cellAverages i) -
        timeStepOverCellWidth •
          (edgeFlux cellCount - edgeFlux 0) := by
  induction cellCount with
  | zero => simp
  | succ cellCount ih =>
      rw [Finset.sum_range_succ, Finset.sum_range_succ, ih]
      simp only [conservativeFluxDifferenceUpdate]
      module

/-- If the two boundary fluxes agree, a finite block's total cell average is
unchanged by the conservative update. -/
theorem sum_conservativeFluxDifferenceUpdate_of_boundaryFlux_eq
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℕ → E) (cellCount : ℕ)
    (hboundary : edgeFlux cellCount = edgeFlux 0) :
    ∑ i ∈ Finset.range cellCount,
        conservativeFluxDifferenceUpdate
          timeStepOverCellWidth cellAverages edgeFlux i =
      ∑ i ∈ Finset.range cellCount, cellAverages i := by
  rw [sum_conservativeFluxDifferenceUpdate, hboundary, sub_self,
    smul_zero, sub_zero]

end NumStability
```

### `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`

Path: `NumStability/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean`
SHA-256: `e61d1e7525a477b62b5953056c8af11374e7cf1dfbeb2de21d147b271ea36586`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# One-dimensional finite-volume cell averages

Source-independent definitions for the average of a Banach-space-valued field
over an ordered, nondegenerate one-dimensional cell.  The accompanying
predicate records both nondegeneracy and interval integrability explicitly.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- A finite-volume grid represented by a nonempty measurable partition of a
chosen spatial domain.  Geometry-specific shape conditions are intentionally
left to downstream grid structures. -/
structure FiniteVolumeCellPartition (Cell Point : Type*)
    [MeasurableSpace Point] where
  domain : Set Point
  cellRegion : Cell → Set Point
  cells_nonempty : Nonempty Cell
  measurable_cell : ∀ cell, MeasurableSet (cellRegion cell)
  disjoint_cells : ∀ {cell₁ cell₂}, cell₁ ≠ cell₂ →
    Disjoint (cellRegion cell₁) (cellRegion cell₂)
  covers_domain : ∀ point,
    point ∈ domain ↔ ∃ cell, point ∈ cellRegion cell

/-- A cellwise material property represented by the material-parameter value
obtained after averaging over that cell.  The wrapper keeps the role of an
assigned effective property distinct from the underlying spatial parameter
field without postulating an unconstrained conversion or suitability
predicate. -/
structure CellAveragedMaterialProperty (Parameter : Type*) where
  averagedParameter : Parameter

/-- A model-indexed rule for averaging material parameters over finite-volume
cells.  The rule is deliberately not fixed to an arithmetic, harmonic, or
tensor mean.  Its two laws capture the source-independent content of being a
cell average: changing a field outside the cell has no effect, and constant
fields are reproduced on positive finite-volume cells. -/
structure CellMaterialAveragingRule
    (Model Cell Point Parameter : Type*) [MeasurableSpace Point]
    (cellRegion : Cell → Set Point) where
  averageParameter :
    Model → Measure Point → Cell → (Point → Parameter) → Parameter
  local_congr : ∀ model volumeMeasure cell field₁ field₂,
    Set.EqOn field₁ field₂ (cellRegion cell) →
      averageParameter model volumeMeasure cell field₁ =
        averageParameter model volumeMeasure cell field₂
  preserves_constants : ∀ model volumeMeasure cell parameter,
    volumeMeasure (cellRegion cell) ≠ 0 →
      volumeMeasure (cellRegion cell) ≠ ⊤ →
        averageParameter model volumeMeasure cell (fun _ => parameter) =
          parameter

/-- The normalized Bochner integral of a field over a measurable cell region.
The associated predicate below records the hypotheses under which this is a
genuine finite, positive-volume average. -/
noncomputable def cellVolumeAverage
    {Point E : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Measure Point) (region : Set Point) (field : Point → E) : E :=
  (μ region).toReal⁻¹ • ∫ point in region, field point ∂μ

/-- `average` is the normalized volume average of `field` on `region`.
Positivity, finiteness, and integrability rule out the degenerate conventions
of `ENNReal.toReal` and the Bochner integral. -/
def IsCellVolumeAverage
    {Point E : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Measure Point) (region : Set Point) (field : Point → E)
    (average : E) : Prop :=
  μ region ≠ 0 ∧
    μ region ≠ ⊤ ∧
    IntegrableOn field region μ ∧
    average = cellVolumeAverage μ region field

/-- The canonical normalized integral satisfies the volume-average predicate
on every finite, positive-volume cell where the field is integrable. -/
theorem cellVolumeAverage_isCellVolumeAverage
    {Point E : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Measure Point) (region : Set Point) (field : Point → E)
    (hpositive : μ region ≠ 0) (hfinite : μ region ≠ ⊤)
    (hintegrable : IntegrableOn field region μ) :
    IsCellVolumeAverage μ region field
      (cellVolumeAverage μ region field) :=
  ⟨hpositive, hfinite, hintegrable, rfl⟩

/-- The average of a field over the one-dimensional interval from `left` to
`right`: its Bochner integral divided by the cell width.

Use `IsOneDimensionalCellAverage` when the mathematical assertion must also
record that the interval is nondegenerate and the field is integrable there.
-/
noncomputable def oneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right : ℝ) : E :=
  (right - left)⁻¹ • ∫ x in left..right, field x

/-- `average` is the finite-volume average of `field` on an ordered,
nondegenerate cell, with interval integrability stated explicitly. -/
def IsOneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right : ℝ) (average : E) : Prop :=
  left < right ∧
    IntervalIntegrable field volume left right ∧
      average = oneDimensionalCellAverage field left right

/-- The canonical average satisfies the cell-average predicate whenever the
cell is ordered and the field is interval integrable. -/
theorem oneDimensionalCellAverage_isCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) {left right : ℝ}
    (hcell : left < right)
    (hfield : IntervalIntegrable field volume left right) :
    IsOneDimensionalCellAverage field left right
      (oneDimensionalCellAverage field left right) :=
  ⟨hcell, hfield, rfl⟩

/-- Multiplying a cell average by its positive width recovers the cell
integral. -/
theorem cellWidth_smul_oneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) {left right : ℝ} (hcell : left < right) :
    (right - left) • oneDimensionalCellAverage field left right =
      ∫ x in left..right, field x := by
  have hwidth : right - left ≠ 0 := sub_ne_zero.mpr (ne_of_gt hcell)
  simp [oneDimensionalCellAverage, smul_smul, hwidth]

end NumStability
```

### `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`

Path: `NumStability/Analysis/PartialDifferentialEquations/FiniteVolume/LocalFluxBalance.lean`
SHA-256: `005b3ab65508cbb34f0a53866c96934c79495e3950228a7231c8a01304bd13d7`

```lean
/-
SPDX-License-Identifier: MIT
-/

import NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Algebra.BigOperators.Module
import Mathlib.Tactic.Module

/-!
# Local numerical fluxes on finite-volume cell partitions

Source-independent infrastructure for conservative finite-volume updates on an
abstract finite collection of cells and oriented interfaces.  Cell states are
genuine normalized volume averages.  An interface flux is computed only from
the averages in the two cells incident to that interface.  No integer or
half-line indexing convention is built in.

The boundary-flux identity below works for every finite collection of cells.
An interface whose two cells are both inside the collection cancels, while an
interface crossing its boundary contributes with the orientation of that
interface.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

/-- A finite-volume partition equipped with oriented interfaces between
distinct cells.  `interfacePoint` identifies where the corresponding physical
conservation-law flux is evaluated; it is required to lie in the modeled
domain. -/
structure FiniteVolumeInterfaceMesh
    (Cell Interface Point : Type*) [MeasurableSpace Point]
    [TopologicalSpace Point]
    extends FiniteVolumeCellPartition Cell Point where
  interfaces_nonempty : Nonempty Interface
  leftCell : Interface → Cell
  rightCell : Interface → Cell
  leftCell_ne_rightCell : ∀ interface,
    leftCell interface ≠ rightCell interface
  interfacePoint : Interface → Point
  interfacePoint_mem_domain : ∀ interface,
    interfacePoint interface ∈ domain
  interfacePoint_mem_leftCellClosure : ∀ interface,
    interfacePoint interface ∈ closure (cellRegion (leftCell interface))
  interfacePoint_mem_rightCellClosure : ∀ interface,
    interfacePoint interface ∈ closure (cellRegion (rightCell interface))

/-- The normalized integral of a conserved field on each cell of a
finite-volume mesh. -/
noncomputable def finiteVolumeCellAverages
    {Cell Interface Point E : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (μ : Measure Point) (conservedField : Point → E) : Cell → E :=
  fun cell => cellVolumeAverage μ (mesh.cellRegion cell) conservedField

/-- A local interface flux uses precisely the approximate averages in the
oriented left and right cells of that interface. -/
def neighboringCellNumericalFlux
    {Cell Interface Point State Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (localNumericalFlux : State → State → Flux)
    (cellAverages : Cell → State) : Interface → Flux :=
  fun interface => localNumericalFlux
    (cellAverages (mesh.leftCell interface))
    (cellAverages (mesh.rightCell interface))

/-- The correct physical interface flux obtained by applying the flux of a
conservation law to the conserved field at the interface point. -/
def conservationLawInterfaceFlux
    {Cell Interface Point State Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (conservedField : Point → State)
    (physicalConservationFlux : State → Flux) : Interface → Flux :=
  fun interface =>
    physicalConservationFlux (conservedField (mesh.interfacePoint interface))

/-- Net outward numerical flux from one cell.  An oriented interface is
outgoing from its left cell and incoming to its right cell. -/
def finiteVolumeNetOutwardFlux
    {Cell Interface Point Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup Flux]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (interfaceFlux : Interface → Flux) (cell : Cell) : Flux :=
  ∑ interface : Interface,
    ((if mesh.leftCell interface = cell then interfaceFlux interface else 0) -
      (if mesh.rightCell interface = cell then interfaceFlux interface else 0))

/-- Oriented flux through the boundary of a finite collection of cells.
Interfaces internal to the collection occur once with each sign and hence
cancel. -/
def finiteVolumeBoundaryFlux
    {Cell Interface Point Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup Flux]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (interfaceFlux : Interface → Flux) (cells : Finset Cell) : Flux :=
  ∑ interface : Interface,
    ((if mesh.leftCell interface ∈ cells then interfaceFlux interface else 0) -
      (if mesh.rightCell interface ∈ cells then interfaceFlux interface else 0))

/-- Summing cellwise net outward flux over any finite cell collection leaves
exactly its oriented boundary flux. -/
theorem sum_finiteVolumeNetOutwardFlux_eq_boundaryFlux
    {Cell Interface Point Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup Flux]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (interfaceFlux : Interface → Flux) (cells : Finset Cell) :
    ∑ cell ∈ cells, finiteVolumeNetOutwardFlux mesh interfaceFlux cell =
      finiteVolumeBoundaryFlux mesh interfaceFlux cells := by
  classical
  simp only [finiteVolumeNetOutwardFlux, finiteVolumeBoundaryFlux,
    Finset.sum_sub_distrib]
  have hleft :
      (∑ cell ∈ cells, ∑ interface : Interface,
          if mesh.leftCell interface = cell then interfaceFlux interface else 0) =
        ∑ interface : Interface,
          if mesh.leftCell interface ∈ cells then interfaceFlux interface else 0 := by
    calc
      _ = ∑ interface : Interface, ∑ cell ∈ cells,
          if mesh.leftCell interface = cell then interfaceFlux interface else 0 :=
        Finset.sum_comm
      _ = _ := by simp [eq_comm]
  have hright :
      (∑ cell ∈ cells, ∑ interface : Interface,
          if mesh.rightCell interface = cell then interfaceFlux interface else 0) =
        ∑ interface : Interface,
          if mesh.rightCell interface ∈ cells then interfaceFlux interface else 0 := by
    calc
      _ = ∑ interface : Interface, ∑ cell ∈ cells,
          if mesh.rightCell interface = cell then interfaceFlux interface else 0 :=
        Finset.sum_comm
      _ = _ := by simp [eq_comm]
  rw [hleft, hright]

/-- Update one cell average over a time interval from its net outward flux.
The cell volume is an explicit argument so geometry-specific volume choices
remain outside this source-independent operation. -/
noncomputable def finiteVolumeCellAverageUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStep cellVolume : ℝ) (oldAverage netOutwardFlux : E) : E :=
  oldAverage - (timeStep / cellVolume) • netOutwardFlux

/-- Multiplying the average update by a nonzero cell volume recovers the
integral conservative balance for the cell total. -/
theorem cellVolume_smul_finiteVolumeCellAverageUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStep cellVolume : ℝ) (oldAverage netOutwardFlux : E)
    (hcellVolume : cellVolume ≠ 0) :
    cellVolume • finiteVolumeCellAverageUpdate
        timeStep cellVolume oldAverage netOutwardFlux =
      cellVolume • oldAverage - timeStep • netOutwardFlux := by
  have hscale : cellVolume * (timeStep / cellVolume) = timeStep := by
    field_simp
  simp [finiteVolumeCellAverageUpdate, smul_sub, smul_smul, hscale]

/-- Cellwise conservative total balances sum to the corresponding boundary
balance on every finite cell collection. -/
theorem sum_finiteVolumeCellTotalBalance
    {Cell Interface Point E : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup E] [Module ℝ E]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (cellVolume : Cell → ℝ) (timeStep : ℝ)
    (oldAverage updatedAverage : Cell → E)
    (interfaceFlux : Interface → E)
    (hbalance : ∀ cell,
      cellVolume cell • updatedAverage cell =
        cellVolume cell • oldAverage cell -
          timeStep • finiteVolumeNetOutwardFlux mesh interfaceFlux cell)
    (cells : Finset Cell) :
    ∑ cell ∈ cells, cellVolume cell • updatedAverage cell =
      (∑ cell ∈ cells, cellVolume cell • oldAverage cell) -
        timeStep • finiteVolumeBoundaryFlux mesh interfaceFlux cells := by
  calc
    ∑ cell ∈ cells, cellVolume cell • updatedAverage cell =
        ∑ cell ∈ cells,
          (cellVolume cell • oldAverage cell -
            timeStep • finiteVolumeNetOutwardFlux mesh interfaceFlux cell) := by
      apply Finset.sum_congr rfl
      intro cell hcell
      exact hbalance cell
    _ = (∑ cell ∈ cells, cellVolume cell • oldAverage cell) -
        timeStep •
          (∑ cell ∈ cells,
            finiteVolumeNetOutwardFlux mesh interfaceFlux cell) := by
      simp [Finset.sum_sub_distrib, Finset.smul_sum]
    _ = (∑ cell ∈ cells, cellVolume cell • oldAverage cell) -
        timeStep • finiteVolumeBoundaryFlux mesh interfaceFlux cells := by
      rw [sum_finiteVolumeNetOutwardFlux_eq_boundaryFlux]

end NumStability
```
