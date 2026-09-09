# Declaration dossier for LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_coordinateHighResolutionMethods_sourceContract (hm : 0 < m) (hD : 0 < Fintype.card D)

    (method : ℕ → LineRealization data coord family) (direction : ℕ → D)
    (quality : ∀ d line, (family d line).HasControlledHighResolution)
    (initial : Cell → V) (physical : ℕ → (D → ℝ) → ℝ → V) (steps : ℕ)
    (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ)
    (leftError rightError : ℕ → Cell → ℝ)
    (href : ∀ n < steps, data.ReferenceOn (direction n) (physical n) 0
      ((method n).duration (direction n)))
    (hinitial : ∀ cell, ‖initial cell - data.cellMean (physical 0) cell 0‖ ≤ initialError)
    (hactual : ∀ n < steps, (method n).Admitted (direction n)
      (coordinateExecution method direction initial n))
    (hrefadmit : ∀ n < steps, (method n).Admitted (direction n)
      (fun cell => data.cellMean (physical n) cell 0))
    (hamplification : ∀ n < steps, ∀ cell,
      1 + (family (direction n) (coord.cellLine (direction n) cell)).stabilityRate
        (quality (direction n) (coord.cellLine (direction n) cell)) *
        (method n).duration (direction n) ≤ amplification n)
    (hleft : ∀ n < steps, ∀ cell,
      ‖(method n).rule (direction n) ((method n).duration (direction n))
          (fun c => data.cellMean (physical n) c 0) (data.leftFace (direction n) cell) -
        oneDimensionalCellAverage (data.faceFlux (direction n) (physical n)
          (data.leftFace (direction n) cell)) 0 ((method n).duration (direction n))‖ ≤ leftError n cell)
    (hright : ∀ n < steps, ∀ cell,
      ‖(method n).rule (direction n) ((method n).duration (direction n))
          (fun c => data.cellMean (physical n) c 0) (data.rightFace (direction n) cell) -
        oneDimensionalCellAverage (data.faceFlux (direction n) (physical n)
          (data.rightFace (direction n) cell)) 0 ((method n).duration (direction n))‖ ≤ rightError n cell)
    (hlocal : ∀ n < steps, ∀ cell, (method n).duration (direction n) / data.cellVolume cell *
      (leftError n cell + rightError n cell) ≤ localDefect n)
    (hsplit : ∀ n < steps, ∀ cell,
      ‖data.cellMean (physical n) cell ((method n).duration (direction n)) -
        data.cellMean (physical (n + 1)) cell 0‖ ≤ splittingDefect n)
    (hschedule : ∀ d : D, ∃ n < steps, direction n = d) :
    0 < m ∧ 0 < Fintype.card D ∧ (∀ d : D, ∃ n < steps, direction n = d) ∧
    (∀ d line, (family d line).HasControlledHighResolution) ∧
    (∀ d line, ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧ ∀ q : ℝ → ℝ → V,
      SpatialSmoothReferenceOn q (family d line).flux (family d line).states (family d line).left (family d line).right (family d line).horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ, ∀ n, N ≤ n → ∀ projected values,
        (family d line).InitialProjection n q projected → (family d line).admitted n values →
        ∀ E : ℝ, 0 ≤ E →
        (∀ j ∈ Finset.Ico ((family d line).inputStart n) ((family d line).inputStart n + (family d line).inputCount n),
          ‖values j - projected j‖ ≤ E) →
        ∀ j ∈ Finset.Ico ((family d line).activeStart n) ((family d line).activeStart n + (family d line).activeCount n),
          ‖(family d line).advance n values j -
            finiteVolumeCellAverageOn ((family d line).grid n) (fun x => q x ((family d line).dt n)) j‖ ≤
            (1 + L * (family d line).dt n) * E + C * (family d line).dt n * ((family d line).mesh n) ^ p) ∧
    (∀ n ≤ steps, coordinateExecution method direction initial n =
      orderedOperatorSweep ((List.range n).map (coordinateStep method direction)) initial) ∧
    (∀ n < steps, ∀ cell,
      coordinateExecution method direction initial (n + 1) cell =
        (family (direction n) (coord.cellLine (direction n) cell)).advance
          ((method n).level (direction n) (coord.cellLine (direction n) cell))
          (coord.extract (direction n) (coord.cellLine (direction n) cell)
            (coordinateExecution method direction initial n)) (coord.cellIndex (direction n) cell)) ∧
    (∀ n < steps,
      (∑ cell, data.cellVolume cell • coordinateExecution method direction initial (n + 1) cell) =
      (∑ cell, data.cellVolume cell • coordinateExecution method direction initial n cell) -
        (method n).duration (direction n) • ∑ cell,
          ((method n).rule (direction n) ((method n).duration (direction n))
            (coordinateExecution method direction initial n) (data.rightFace (direction n) cell) -
           (method n).rule (direction n) ((method n).duration (direction n))
            (coordinateExecution method direction initial n) (data.leftFace (direction n) cell))) ∧
    (∀ n < steps, ∀ cell current other,
      (∀ c, coord.cellLine (direction n) c = coord.cellLine (direction n) cell → current c = other c) →
      advance data (method n).rule (direction n) ((method n).duration (direction n)) current cell =
        advance data (method n).rule (direction n) ((method n).duration (direction n)) other cell) ∧
    (∀ n < steps, ∀ cell, ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧ ∀ q : ℝ → ℝ → V,
      SpatialSmoothReferenceOn q (family (direction n) (coord.cellLine (direction n) cell)).flux
        (family (direction n) (coord.cellLine (direction n) cell)).states (family (direction n) (coord.cellLine (direction n) cell)).left
        (family (direction n) (coord.cellLine (direction n) cell)).right (family (direction n) (coord.cellLine (direction n) cell)).horizon →
      ∃ C : ℝ, 0 ≤ C ∧ ∃ N : ℕ,
        N ≤ (method n).level (direction n) (coord.cellLine (direction n) cell) →
        ∀ projected current : Cell → V,
          (family (direction n) (coord.cellLine (direction n) cell)).InitialProjection ((method n).level (direction n) (coord.cellLine (direction n) cell)) q
            (coord.extract (direction n) (coord.cellLine (direction n) cell) projected) →
          (method n).Admitted (direction n) current → ∀ E : ℝ, 0 ≤ E →
          (∀ c, ‖current c - projected c‖ ≤ E) →
          ‖advance data (method n).rule (direction n) ((method n).duration (direction n)) current cell -
            finiteVolumeCellAverageOn
              ((family (direction n) (coord.cellLine (direction n) cell)).grid ((method n).level (direction n) (coord.cellLine (direction n) cell)))
              (fun x => q x ((method n).duration (direction n))) (coord.cellIndex (direction n) cell)‖ ≤
            (1 + L * (method n).duration (direction n)) * E + C * (method n).duration (direction n) *
              (family (direction n) (coord.cellLine (direction n) cell)).mesh ((method n).level (direction n) (coord.cellLine (direction n) cell)) ^ p) ∧
    (∀ n < steps, ∀ u ∈ Set.uIcc 0 ((method n).duration (direction n)),
      ∀ v ∈ Set.uIcc 0 ((method n).duration (direction n)), ∀ cell,
      data.cellVolume cell • (data.cellMean (physical n) cell v - data.cellMean (physical n) cell u) =
        ∫ τ in u..v, data.faceFlux (direction n) (physical n) (data.leftFace (direction n) cell) τ -
          data.faceFlux (direction n) (physical n) (data.rightFace (direction n) cell) τ) ∧
    (∀ n ≤ steps, ∀ cell,
      ‖coordinateExecution method direction initial n cell - data.cellMean (physical n) cell 0‖ ≤
        errorBudget amplification localDefect splittingDefect initialError n) ∧
    (∀ (axes : D → OneDimensionalFiniteVolumeGrid) (cellPosition : Cell → D → ℤ)
      (facePosition : D → Face → D → ℤ) (flux : D → V → V),
      FiniteCartesian.CartesianIdentification data axes cellPosition facePosition flux →
      (∀ cell, data.cellVolume cell = CartesianGrid.cellVolume axes (cellPosition cell)) ∧
      (∀ (q : (D → ℝ) → ℝ → V) cell t, data.cellMean q cell t =
        cellVolumeAverage volume (CartesianGrid.cellBox axes (cellPosition cell)) (fun x => q x t)) ∧
      (∀ (q : ℝ → ℝ → V) d face t,
        data.faceFlux d (fun x τ => q (x d) τ) face t =
          CartesianGrid.faceArea axes d (facePosition d face) •
            flux d (q ((axes d).cellLeft (facePosition d face d)) t)) ∧
      (∀ (q : ℝ → ℝ → V) d, IsRectangleConservationLawSolution q (flux d) → ∀ cell s t,
        data.cellVolume cell • (data.cellMean (fun x τ => q (x d) τ) cell t -
          data.cellMean (fun x τ => q (x d) τ) cell s) =
          ∫ τ in s..t, data.faceFlux d (fun x τ => q (x d) τ) (data.leftFace d cell) τ -
            data.faceFlux d (fun x τ => q (x d) τ) (data.rightFace d cell) τ))
```

## Elaborated target type

```lean
∀ {D : Type u_1} {Cell : Type u_2} {Face : Type u_3} {FacePoint : Type u_4} {Line : Type u_5} [inst : Fintype D]
  [inst_1 : DecidableEq D] [inst_2 : Fintype Cell] [inst_3 : MeasurableSpace FacePoint] {m : Nat}
  {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face (D → Real) FacePoint m}
  {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line}
  {family : D → Line → NumStability.DirectionalLine.LineFamily m},
  instLTNat.lt 0 m →
    instLTNat.lt 0 (Fintype.card D) →
      ∀ (method : Nat → NumStability.FiniteCoordinate.LineRealization data coord family) (direction : Nat → D)
        (quality : ∀ (d : D) (line : Line), (family d line).HasControlledHighResolution) (initial : Cell → Fin m → Real)
        (physical : Nat → (D → Real) → Real → Fin m → Real) (steps : Nat)
        (amplification localDefect splittingDefect : Nat → Real) (initialError : Real)
        (leftError rightError : Nat → Cell → Real),
        (∀ (n : Nat),
            instLTNat.lt n steps → data.ReferenceOn (direction n) (physical n) 0 ((method n).duration (direction n))) →
          (∀ (cell : Cell),
              Real.instLE.le (Pi.normedRing.norm (instHSub.hSub (initial cell) (data.cellMean (physical 0) cell 0)))
                initialError) →
            (∀ (n : Nat),
                instLTNat.lt n steps →
                  (method n).Admitted (direction n)
                    (NumStability.FiniteCoordinate.coordinateExecution method direction initial n)) →
              (∀ (n : Nat),
                  instLTNat.lt n steps →
                    (method n).Admitted (direction n) fun cell => data.cellMean (physical n) cell 0) →
                (∀ (n : Nat),
                    instLTNat.lt n steps →
                      ∀ (cell : Cell),
                        Real.instLE.le
                          (instHAdd.hAdd 1
                            (instHMul.hMul ((family (direction n) (coord.cellLine (direction n) cell)).stabilityRate ⋯)
                              ((method n).duration (direction n))))
                          (amplification n)) →
                  (∀ (n : Nat),
                      instLTNat.lt n steps →
                        ∀ (cell : Cell),
                          Real.instLE.le
                            (Pi.normedRing.norm
                              (instHSub.hSub
                                ((method n).rule (direction n) ((method n).duration (direction n))
                                  (fun c => data.cellMean (physical n) c 0) (data.leftFace (direction n) cell))
                                (NumStability.oneDimensionalCellAverage
                                  (data.faceFlux (direction n) (physical n) (data.leftFace (direction n) cell)) 0
                                  ((method n).duration (direction n)))))
                            (leftError n cell)) →
                    (∀ (n : Nat),
                        instLTNat.lt n steps →
                          ∀ (cell : Cell),
                            Real.instLE.le
                              (Pi.normedRing.norm
                                (instHSub.hSub
                                  ((method n).rule (direction n) ((method n).duration (direction n))
                                    (fun c => data.cellMean (physical n) c 0) (data.rightFace (direction n) cell))
                                  (NumStability.oneDimensionalCellAverage
                                    (data.faceFlux (direction n) (physical n) (data.rightFace (direction n) cell)) 0
                                    ((method n).duration (direction n)))))
                              (rightError n cell)) →
                      (∀ (n : Nat),
                          instLTNat.lt n steps →
                            ∀ (cell : Cell),
                              Real.instLE.le
                                (instHMul.hMul
                                  (instHDiv.hDiv ((method n).duration (direction n)) (data.cellVolume cell))
                                  (instHAdd.hAdd (leftError n cell) (rightError n cell)))
                                (localDefect n)) →
                        (∀ (n : Nat),
                            instLTNat.lt n steps →
                              ∀ (cell : Cell),
                                Real.instLE.le
                                  (Pi.normedRing.norm
                                    (instHSub.hSub (data.cellMean (physical n) cell ((method n).duration (direction n)))
                                      (data.cellMean (physical (instHAdd.hAdd n 1)) cell 0)))
                                  (splittingDefect n)) →
                          (∀ (d : D), Exists fun n => And (instLTNat.lt n steps) (Eq (direction n) d)) →
                            And (instLTNat.lt 0 m)
                              (And (instLTNat.lt 0 (Fintype.card D))
                                (And (∀ (d : D), Exists fun n => And (instLTNat.lt n steps) (Eq (direction n) d))
                                  (And (∀ (d : D) (line : Line), (family d line).HasControlledHighResolution)
                                    (And
                                      (∀ (d : D) (line : Line),
                                        Exists fun p =>
                                          Exists fun L =>
                                            And (Real.instLT.lt 1 p)
                                              (And (Real.instLE.le 0 L)
                                                (∀ (q : Real → Real → Fin m → Real),
                                                  NumStability.LocalConservationLaw.SpatialSmoothReferenceOn q
                                                      (family d line).flux (family d line).states (family d line).left
                                                      (family d line).right (family d line).horizon →
                                                    Exists fun C => ⋯)))
                                      (And
                                        (∀ (n : Nat),
                                          instLENat.le n steps →
                                            Eq
                                              (NumStability.FiniteCoordinate.coordinateExecution method direction
                                                initial n)
                                              (NumStability.orderedOperatorSweep
                                                (List.map
                                                  (NumStability.FiniteCoordinate.coordinateStep method direction)
                                                  (List.range n))
                                                initial))
                                        (And
                                          (∀ (n : Nat),
                                            instLTNat.lt n steps →
                                              ∀ (cell : Cell),
                                                Eq
                                                  (NumStability.FiniteCoordinate.coordinateExecution method direction
                                                    initial (instHAdd.hAdd n 1) cell)
                                                  ((family (direction n) (coord.cellLine (direction n) cell)).advance
                                                    ((method n).level (direction n) (coord.cellLine (direction n) cell))
                                                    (coord.extract (direction n) (coord.cellLine (direction n) cell)
                                                      (NumStability.FiniteCoordinate.coordinateExecution method
                                                        direction initial n))
                                                    (coord.cellIndex (direction n) cell)))
                                          (And
                                            (∀ (n : Nat),
                                              instLTNat.lt n steps →
                                                Eq
                                                  (Finset.univ.sum fun cell =>
                                                    instHSMul.hSMul (data.cellVolume cell)
                                                      (NumStability.FiniteCoordinate.coordinateExecution method
                                                        direction initial (instHAdd.hAdd n 1) cell))
                                                  (instHSub.hSub
                                                    (Finset.univ.sum fun cell =>
                                                      instHSMul.hSMul (data.cellVolume cell)
                                                        (NumStability.FiniteCoordinate.coordinateExecution method
                                                          direction initial n cell))
                                                    (instHSMul.hSMul ((method n).duration (direction n))
                                                      (Finset.univ.sum fun cell =>
                                                        instHSub.hSub ((method n).rule (direction n) ⋯ ⋯ ⋯)
                                                          ((method n).rule (direction n) ⋯ ⋯ ⋯)))))
                                            (And
                                              (∀ (n : Nat),
                                                instLTNat.lt n steps →
                                                  ∀ (cell : Cell) (current other : Cell → Fin m → Real),
                                                    (∀ (c : Cell),
                                                        Eq (coord.cellLine (direction n) c)
                                                            (coord.cellLine (direction n) cell) →
                                                          Eq (current c) (other c)) →
                                                      Eq
                                                        (NumStability.FiniteCoordinate.advance data (method n).rule
                                                          (direction n) ((method n).duration (direction n)) current
                                                          cell)
                                                        (NumStability.FiniteCoordinate.advance data (method n).rule
                                                          (direction n) ((method n).duration (direction n)) other cell))
                                              (And
                                                (∀ (n : Nat),
                                                  instLTNat.lt n steps →
                                                    ∀ (cell : Cell), Exists fun p => Exists fun L => ⋯)
                                                (And
                                                  (∀ (n : Nat),
                                                    instLTNat.lt n steps →
                                                      ∀ (u : Real),
                                                        Set.instMembership.mem (Set.uIcc 0 ⋯) u → ∀ (v : Real), ⋯ → ⋯)
                                                  (And
                                                    (∀ (n : Nat),
                                                      instLENat.le n steps →
                                                        ∀ (cell : Cell),
                                                          Real.instLE.le (Pi.normedRing.norm ⋯)
                                                            (NumStability.SequentialError.errorBudget amplification
                                                              localDefect splittingDefect initialError n))
                                                    (∀ (axes : D → NumStability.OneDimensionalFiniteVolumeGrid)
                                                      (cellPosition : Cell → D → Int)
                                                      (facePosition : D → Face → D → Int)
                                                      (flux : D → (Fin m → Real) → Fin m → Real), ⋯ → ⋯))))))))))))
```

## Fully explicit elaborated target type

```lean
∀ {D : ⋯} {Cell : ⋯} {Face : ⋯} {FacePoint : ⋯} {Line : ⋯} [inst : ⋯] [inst_1 : ⋯] [inst_2 : ⋯] [inst_3 : ⋯] {m : ⋯}
  {data : ⋯} {coord : ⋯} {family : ⋯} (hm : ⋯) (hD : ⋯) (method : ⋯) (direction : ⋯) (quality : ⋯) (initial : ⋯)
  (physical : ⋯) (steps : ⋯) (amplification localDefect splittingDefect : ⋯) (initialError : ⋯)
  (leftError rightError : ⋯) (href : ⋯) (hinitial : ⋯) (hactual : ⋯) (hrefadmit : ⋯) (hamplification : ⋯) (hleft : ⋯)
  (hright :
    ∀ (n : ⋯),
      ⋯ →
        ∀ (cell : ⋯),
          @LE.le.{0} Real Real.instLE
            (@Norm.norm.{0} (Fin m → Real)
              (@NormedRing.toNorm.{0} (Fin m → Real)
                (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                  @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
              (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                (@instHSub.{0} (Fin m → Real)
                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                (@NumStability.FiniteCoordinate.LineRealization.rule.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell Face
                  (D → Real) FacePoint Line
                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_3 m data coord family (method n) (direction n)
                  (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell Face
                    (D → Real) FacePoint Line (@MeasurableSpace.pi.{u_1, 0} ⋯ ⋯ ⋯) ⋯ ⋯ ⋯ ⋯ ⋯ ⋯ ⋯ ⋯)
                  ⋯ ⋯)
                ⋯))
            ⋯)
  (hlocal :
    ∀ (n : Nat),
      @LT.lt.{0} Nat instLTNat n steps →
        ∀ (cell : Cell),
          @LE.le.{0} Real Real.instLE
            (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
              (@HDiv.hDiv.{0, 0, 0} Real Real Real
                (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell Face
                  (D → Real) FacePoint Line
                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_3 m data coord family (method n) (direction n))
                (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
                  FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_3 m data cell))
              (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd) (leftError n cell)
                (rightError n cell)))
            (localDefect n))
  (hsplit :
    ∀ (n : Nat),
      @LT.lt.{0} Nat instLTNat n steps →
        ∀ (cell : Cell),
          @LE.le.{0} Real Real.instLE
            (@Norm.norm.{0} (Fin m → Real)
              (@NormedRing.toNorm.{0} (Fin m → Real)
                (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                  @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
              (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                (@instHSub.{0} (Fin m → Real)
                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
                  FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_3 m data (physical n) cell
                  (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell Face
                    (D → Real) FacePoint Line
                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                      @UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    inst_3 m data coord family (method n) (direction n)))
                (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
                  FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_3 m data
                  (physical
                    (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
                      (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))))
                  cell (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))))
            (splittingDefect n))
  (hschedule :
    ∀ (d : D),
      @Exists.{1} Nat fun (n : Nat) => And (@LT.lt.{0} Nat instLTNat n steps) (@Eq.{u_1 + 1} D (direction n) d)),
  And (@LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
    (And
      (@LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))
        (@Fintype.card.{u_1} D inst))
      (And
        (∀ (d : D),
          @Exists.{1} Nat fun (n : Nat) => And (@LT.lt.{0} Nat instLTNat n steps) (@Eq.{u_1 + 1} D (direction n) d))
        (And
          (∀ (d : D) (line : Line),
            @NumStability.DirectionalLine.LineFamily.HasControlledHighResolution m (family d line))
          (And
            (∀ (d : D) (line : Line),
              @Exists.{1} Real fun (p : Real) =>
                @Exists.{1} Real fun (L : Real) =>
                  And
                    (@LT.lt.{0} Real Real.instLT
                      (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)) p)
                    (And
                      (@LE.le.{0} Real Real.instLE
                        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) L)
                      (∀ (q : Real → Real → Fin m → Real),
                        @NumStability.LocalConservationLaw.SpatialSmoothReferenceOn m q
                            (@NumStability.DirectionalLine.LineFamily.flux m (family d line))
                            (@NumStability.DirectionalLine.LineFamily.states m (family d line))
                            (@NumStability.DirectionalLine.LineFamily.left m (family d line))
                            (@NumStability.DirectionalLine.LineFamily.right m (family d line))
                            (@NumStability.DirectionalLine.LineFamily.horizon m (family d line)) →
                          @Exists.{1} Real fun (C : Real) =>
                            And
                              (@LE.le.{0} Real Real.instLE
                                (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) C)
                              (@Exists.{1} Nat fun (N : Nat) =>
                                ∀ (n : Nat),
                                  @LE.le.{0} Nat instLENat N n →
                                    ∀ (projected values : Int → Fin m → Real),
                                      @NumStability.DirectionalLine.LineFamily.InitialProjection m (family d line) n q
                                          projected →
                                        @NumStability.DirectionalLine.LineFamily.admitted m (family d line) n values →
                                          ∀ (E : Real),
                                            @LE.le.{0} Real Real.instLE
                                                (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                  (@Zero.toOfNat0.{0} Real Real.instZero))
                                                E →
                                              (∀ (j : Int),
                                                  @Membership.mem.{0, 0} Int (Finset.{0} Int)
                                                      (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int
                                                        (@Finset.instSetLike.{0} Int))
                                                      (@Finset.Ico.{0} Int
                                                        (@PartialOrder.toPreorder.{0} Int
                                                          (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0} Int
                                                            (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                              Int
                                                              (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                                Int
                                                                (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                  Int instConditionallyCompleteLinearOrder)))))
                                                        Int.instLocallyFiniteOrder
                                                        (@NumStability.DirectionalLine.LineFamily.inputStart m
                                                          (family d line) n)
                                                        (@HAdd.hAdd.{0, 0, 0} Int Int Int
                                                          (@instHAdd.{0} Int Int.instAdd)
                                                          (@NumStability.DirectionalLine.LineFamily.inputStart m
                                                            (family d line) n)
                                                          (@Nat.cast.{0} Int instNatCastInt
                                                            (@NumStability.DirectionalLine.LineFamily.inputCount m
                                                              (family d line) n))))
                                                      j →
                                                    @LE.le.{0} Real Real.instLE
                                                      (@Norm.norm.{0} (Fin m → Real)
                                                        (@NormedRing.toNorm.{0} (Fin m → Real)
                                                          (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                            (Fin.fintype m) fun (i : Fin m) =>
                                                            @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                                        (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                          (Fin m → Real)
                                                          (@instHSub.{0} (Fin m → Real)
                                                            (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                              fun (i : Fin m) => Real.instSub))
                                                          (values j) (projected j)))
                                                      E) →
                                                ∀ (j : Int),
                                                  @Membership.mem.{0, 0} Int (Finset.{0} Int)
                                                      (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int
                                                        (@Finset.instSetLike.{0} Int))
                                                      (@Finset.Ico.{0} Int
                                                        (@PartialOrder.toPreorder.{0} Int
                                                          (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0} Int
                                                            (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                              Int
                                                              (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                                Int
                                                                (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                  Int instConditionallyCompleteLinearOrder)))))
                                                        Int.instLocallyFiniteOrder
                                                        (@NumStability.DirectionalLine.LineFamily.activeStart m
                                                          (family d line) n)
                                                        (@HAdd.hAdd.{0, 0, 0} Int Int Int
                                                          (@instHAdd.{0} Int Int.instAdd)
                                                          (@NumStability.DirectionalLine.LineFamily.activeStart m
                                                            (family d line) n)
                                                          (@Nat.cast.{0} Int instNatCastInt
                                                            (@NumStability.DirectionalLine.LineFamily.activeCount m
                                                              (family d line) n))))
                                                      j →
                                                    @LE.le.{0} Real Real.instLE
                                                      (@Norm.norm.{0} (Fin m → Real)
                                                        (@NormedRing.toNorm.{0} (Fin m → Real)
                                                          (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                            (Fin.fintype m) fun (i : Fin m) =>
                                                            @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                                        (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                          (Fin m → Real)
                                                          (@instHSub.{0} (Fin m → Real)
                                                            (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                              fun (i : Fin m) => Real.instSub))
                                                          (@NumStability.DirectionalLine.LineFamily.advance m
                                                            (family d line) n values j)
                                                          (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
                                                            (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                              fun (i : Fin m) => Real.normedAddCommGroup)
                                                            (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                              (fun (i : Fin m) =>
                                                                @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                  Real
                                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                    Real
                                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                      Real
                                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                        Real.normedCommRing))))
                                                              fun (i : Fin m) =>
                                                              @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                                Real.instRCLike
                                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                  Real
                                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                    Real
                                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                      Real
                                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                        Real.normedCommRing))))
                                                                (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                  Real.instRCLike))
                                                            (@NumStability.DirectionalLine.LineFamily.grid m
                                                              (family d line) n)
                                                            (fun (x : Real) =>
                                                              q x
                                                                (@NumStability.DirectionalLine.LineFamily.dt m
                                                                  (family d line) n))
                                                            j)))
                                                      (@HAdd.hAdd.{0, 0, 0} Real Real Real
                                                        (@instHAdd.{0} Real Real.instAdd)
                                                        (@HMul.hMul.{0, 0, 0} Real Real Real
                                                          (@instHMul.{0} Real Real.instMul)
                                                          (@HAdd.hAdd.{0, 0, 0} Real Real Real
                                                            (@instHAdd.{0} Real Real.instAdd)
                                                            (@OfNat.ofNat.{0} Real (nat_lit 1)
                                                              (@One.toOfNat1.{0} Real Real.instOne))
                                                            (@HMul.hMul.{0, 0, 0} Real Real Real
                                                              (@instHMul.{0} Real Real.instMul) L
                                                              (@NumStability.DirectionalLine.LineFamily.dt m
                                                                (family d line) n)))
                                                          E)
                                                        (@HMul.hMul.{0, 0, 0} Real Real Real
                                                          (@instHMul.{0} Real Real.instMul)
                                                          (@HMul.hMul.{0, 0, 0} Real Real Real
                                                            (@instHMul.{0} Real Real.instMul) C
                                                            (@NumStability.DirectionalLine.LineFamily.dt m
                                                              (family d line) n))
                                                          (@HPow.hPow.{0, 0, 0} Real Real Real
                                                            (@instHPow.{0, 0} Real Real Real.instPow)
                                                            (@NumStability.DirectionalLine.LineFamily.mesh m
                                                              (family d line) n)
                                                            p)))))))
            (And
              (∀ (n : Nat),
                @LE.le.{0} Nat instLENat n steps →
                  @Eq.{u_2 + 1} (Cell → Fin m → Real)
                    (@NumStability.FiniteCoordinate.coordinateExecution.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell Face
                      (D → Real) FacePoint Line
                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      inst_3 m data coord family method direction initial n)
                    (@NumStability.orderedOperatorSweep.{u_2} (Cell → Fin m → Real)
                      (@List.map.{0, u_2} Nat ((Cell → Fin m → Real) → Cell → Fin m → Real)
                        (@NumStability.FiniteCoordinate.coordinateStep.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell Face
                          (D → Real) FacePoint Line
                          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                            @UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          inst_3 m data coord family method direction)
                        (List.range n))
                      initial))
              (And
                (∀ (n : Nat),
                  @LT.lt.{0} Nat instLTNat n steps →
                    ∀ (cell : Cell),
                      @Eq.{1} (Fin m → Real)
                        (@NumStability.FiniteCoordinate.coordinateExecution.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell Face
                          (D → Real) FacePoint Line
                          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                            @UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          inst_3 m data coord family method direction initial
                          (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
                            (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                          cell)
                        (@NumStability.DirectionalLine.LineFamily.advance m
                          (family (direction n)
                            (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3, u_5} m D Cell Face
                              Line coord (direction n) cell))
                          (@NumStability.FiniteCoordinate.LineRealization.level.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell
                            Face (D → Real) FacePoint Line
                            (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                              @UniformSpace.toTopologicalSpace.{0} Real
                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            inst_3 m data coord family (method n) (direction n)
                            (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3, u_5} m D Cell Face
                              Line coord (direction n) cell))
                          (@NumStability.FiniteCoordinate.LineCoordinates.extract.{u_1, u_2, u_3, u_5} D Cell Face Line
                            m coord (direction n)
                            (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3, u_5} m D Cell Face
                              Line coord (direction n) cell)
                            (@NumStability.FiniteCoordinate.coordinateExecution.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell
                              Face (D → Real) FacePoint Line
                              (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                @UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              inst_3 m data coord family method direction initial n))
                          (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_1, u_2, u_3, u_5} m D Cell Face
                            Line coord (direction n) cell)))
                (And
                  (∀ (n : Nat),
                    @LT.lt.{0} Nat instLTNat n steps →
                      @Eq.{1} (Fin m → Real)
                        (@Finset.sum.{u_2, 0} Cell (Fin m → Real)
                          (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                            Real.instAddCommMonoid)
                          (@Finset.univ.{u_2} Cell inst_2) fun (cell : Cell) =>
                          @HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                            (@instHSMul.{0, 0} Real (Fin m → Real)
                              (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                  (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                  (@Algebra.id.{0} Real Real.instCommSemiring))))
                            (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, u_2, u_3, u_1, u_4} D Cell
                              Face (D → Real) FacePoint
                              (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                @UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              inst_3 m data cell)
                            (@NumStability.FiniteCoordinate.coordinateExecution.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell
                              Face (D → Real) FacePoint Line
                              (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                @UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              inst_3 m data coord family method direction initial
                              (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
                                (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                              cell))
                        (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                          (@instHSub.{0} (Fin m → Real)
                            (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                          (@Finset.sum.{u_2, 0} Cell (Fin m → Real)
                            (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                              Real.instAddCommMonoid)
                            (@Finset.univ.{u_2} Cell inst_2) fun (cell : Cell) =>
                            @HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                              (@instHSMul.{0, 0} Real (Fin m → Real)
                                (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                    (@Algebra.id.{0} Real Real.instCommSemiring))))
                              (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, u_2, u_3, u_1, u_4} D Cell
                                Face (D → Real) FacePoint
                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace)
                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                  @UniformSpace.toTopologicalSpace.{0} Real
                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                inst_3 m data cell)
                              (@NumStability.FiniteCoordinate.coordinateExecution.{u_1, u_2, u_3, u_1, u_4, u_5} D Cell
                                Face (D → Real) FacePoint Line
                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace)
                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                  @UniformSpace.toTopologicalSpace.{0} Real
                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                inst_3 m data coord family method direction initial n cell))
                          (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                            (@instHSMul.{0, 0} Real (Fin m → Real)
                              (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                  (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                  (@Algebra.id.{0} Real Real.instCommSemiring))))
                            (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1, u_4, u_5} D
                              Cell Face (D → Real) FacePoint Line
                              (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                @UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              inst_3 m data coord family (method n) (direction n))
                            (@Finset.sum.{u_2, 0} Cell (Fin m → Real)
                              (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                Real.instAddCommMonoid)
                              (@Finset.univ.{u_2} Cell inst_2) fun (cell : Cell) =>
                              @HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                (@instHSub.{0} (Fin m → Real)
                                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                    Real.instSub))
                                (@NumStability.FiniteCoordinate.LineRealization.rule.{u_1, u_2, u_3, u_1, u_4, u_5} D
                                  Cell Face (D → Real) FacePoint Line
                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                    Real.measurableSpace)
                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                    @UniformSpace.toTopologicalSpace.{0} Real
                                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                  inst_3 m data coord family (method n) (direction n)
                                  (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1, u_4,
                                        u_5}
                                    D Cell Face (D → Real) FacePoint Line
                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                      Real.measurableSpace)
                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                      @UniformSpace.toTopologicalSpace.{0} Real
                                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                    inst_3 m data coord family (method n) (direction n))
                                  (@NumStability.FiniteCoordinate.coordinateExecution.{u_1, u_2, u_3, u_1, u_4, u_5} D
                                    Cell Face (D → Real) FacePoint Line
                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                      Real.measurableSpace)
                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                      @UniformSpace.toTopologicalSpace.{0} Real
                                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                    inst_3 m data coord family method direction initial n)
                                  (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, u_2, u_3, u_1, u_4} D
                                    Cell Face (D → Real) FacePoint
                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                      Real.measurableSpace)
                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                      @UniformSpace.toTopologicalSpace.{0} Real
                                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                    inst_3 m data (direction n) cell))
                                (@NumStability.FiniteCoordinate.LineRealization.rule.{u_1, u_2, u_3, u_1, u_4, u_5} D
                                  Cell Face (D → Real) FacePoint Line
                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                    Real.measurableSpace)
                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                    @UniformSpace.toTopologicalSpace.{0} Real
                                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                  inst_3 m data coord family (method n) (direction n)
                                  (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1, u_4,
                                        u_5}
                                    D Cell Face (D → Real) FacePoint Line
                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                      Real.measurableSpace)
                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                      @UniformSpace.toTopologicalSpace.{0} Real
                                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                    inst_3 m data coord family (method n) (direction n))
                                  (@NumStability.FiniteCoordinate.coordinateExecution.{u_1, u_2, u_3, u_1, u_4, u_5} D
                                    Cell Face (D → Real) FacePoint Line
                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                      Real.measurableSpace)
                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                      @UniformSpace.toTopologicalSpace.{0} Real
                                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                    inst_3 m data coord family method direction initial n)
                                  (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, u_2, u_3, u_1, u_4} D Cell
                                    Face (D → Real) FacePoint
                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                      Real.measurableSpace)
                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                      @UniformSpace.toTopologicalSpace.{0} Real
                                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                    inst_3 m data (direction n) cell))))))
                  (And
                    (∀ (n : Nat),
                      @LT.lt.{0} Nat instLTNat n steps →
                        ∀ (cell : Cell) (current other : Cell → Fin m → Real),
                          (∀ (c : Cell),
                              @Eq.{u_5 + 1} Line
                                  (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3, u_5} m D Cell
                                    Face Line coord (direction n) c)
                                  (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3, u_5} m D Cell
                                    Face Line coord (direction n) cell) →
                                @Eq.{1} (Fin m → Real) (current c) (other c)) →
                            @Eq.{1} (Fin m → Real)
                              (@NumStability.FiniteCoordinate.advance.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
                                FacePoint
                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace)
                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                  @UniformSpace.toTopologicalSpace.{0} Real
                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                inst_3 m data
                                (@NumStability.FiniteCoordinate.LineRealization.rule.{u_1, u_2, u_3, u_1, u_4, u_5} D
                                  Cell Face (D → Real) FacePoint Line
                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                    Real.measurableSpace)
                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                    @UniformSpace.toTopologicalSpace.{0} Real
                                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                  inst_3 m data coord family (method n))
                                (direction n)
                                (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1, u_4, u_5}
                                  D Cell Face (D → Real) FacePoint Line
                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                    Real.measurableSpace)
                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                    @UniformSpace.toTopologicalSpace.{0} Real
                                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                  inst_3 m data coord family (method n) (direction n))
                                current cell)
                              (@NumStability.FiniteCoordinate.advance.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
                                FacePoint
                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace)
                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                  @UniformSpace.toTopologicalSpace.{0} Real
                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                inst_3 m data
                                (@NumStability.FiniteCoordinate.LineRealization.rule.{u_1, u_2, u_3, u_1, u_4, u_5} D
                                  Cell Face (D → Real) FacePoint Line
                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                    Real.measurableSpace)
                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                    @UniformSpace.toTopologicalSpace.{0} Real
                                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                  inst_3 m data coord family (method n))
                                (direction n)
                                (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1, u_4, u_5}
                                  D Cell Face (D → Real) FacePoint Line
                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                    Real.measurableSpace)
                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                    @UniformSpace.toTopologicalSpace.{0} Real
                                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                  inst_3 m data coord family (method n) (direction n))
                                other cell))
                    (And
                      (∀ (n : Nat),
                        @LT.lt.{0} Nat instLTNat n steps →
                          ∀ (cell : Cell),
                            @Exists.{1} Real fun (p : Real) =>
                              @Exists.{1} Real fun (L : Real) =>
                                And
                                  (@LT.lt.{0} Real Real.instLT
                                    (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)) p)
                                  (And
                                    (@LE.le.{0} Real Real.instLE
                                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) L)
                                    (∀ (q : Real → Real → Fin m → Real),
                                      @NumStability.LocalConservationLaw.SpatialSmoothReferenceOn m q
                                          (@NumStability.DirectionalLine.LineFamily.flux m
                                            (family (direction n)
                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3,
                                                    u_5}
                                                m D Cell Face Line coord (direction n) cell)))
                                          (@NumStability.DirectionalLine.LineFamily.states m
                                            (family (direction n)
                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3,
                                                    u_5}
                                                m D Cell Face Line coord (direction n) cell)))
                                          (@NumStability.DirectionalLine.LineFamily.left m
                                            (family (direction n)
                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3,
                                                    u_5}
                                                m D Cell Face Line coord (direction n) cell)))
                                          (@NumStability.DirectionalLine.LineFamily.right m
                                            (family (direction n)
                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3,
                                                    u_5}
                                                m D Cell Face Line coord (direction n) cell)))
                                          (@NumStability.DirectionalLine.LineFamily.horizon m
                                            (family (direction n)
                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3,
                                                    u_5}
                                                m D Cell Face Line coord (direction n) cell))) →
                                        @Exists.{1} Real fun (C : Real) =>
                                          And
                                            (@LE.le.{0} Real Real.instLE
                                              (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                (@Zero.toOfNat0.{0} Real Real.instZero))
                                              C)
                                            (@Exists.{1} Nat fun (N : Nat) =>
                                              @LE.le.{0} Nat instLENat N
                                                  (@NumStability.FiniteCoordinate.LineRealization.level.{u_1, u_2, u_3,
                                                        u_1, u_4, u_5}
                                                    D Cell Face (D → Real) FacePoint Line
                                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                      Real.measurableSpace)
                                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                      fun (i : D) =>
                                                      @UniformSpace.toTopologicalSpace.{0} Real
                                                        (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                          Real.pseudoMetricSpace))
                                                    inst_3 m data coord family (method n) (direction n)
                                                    (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2,
                                                          u_3, u_5}
                                                      m D Cell Face Line coord (direction n) cell)) →
                                                ∀ (projected current : Cell → Fin m → Real),
                                                  @NumStability.DirectionalLine.LineFamily.InitialProjection m
                                                      (family (direction n)
                                                        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                              u_2, u_3, u_5}
                                                          m D Cell Face Line coord (direction n) cell))
                                                      (@NumStability.FiniteCoordinate.LineRealization.level.{u_1, u_2,
                                                            u_3, u_1, u_4, u_5}
                                                        D Cell Face (D → Real) FacePoint Line
                                                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real)
                                                          fun (a : D) => Real.measurableSpace)
                                                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                          fun (i : D) =>
                                                          @UniformSpace.toTopologicalSpace.{0} Real
                                                            (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                              Real.pseudoMetricSpace))
                                                        inst_3 m data coord family (method n) (direction n)
                                                        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                              u_2, u_3, u_5}
                                                          m D Cell Face Line coord (direction n) cell))
                                                      q
                                                      (@NumStability.FiniteCoordinate.LineCoordinates.extract.{u_1, u_2,
                                                            u_3, u_5}
                                                        D Cell Face Line m coord (direction n)
                                                        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                              u_2, u_3, u_5}
                                                          m D Cell Face Line coord (direction n) cell)
                                                        projected) →
                                                    @NumStability.FiniteCoordinate.LineRealization.Admitted.{u_1, u_2,
                                                            u_3, u_1, u_4, u_5}
                                                        D Cell Face (D → Real) FacePoint Line
                                                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real)
                                                          fun (a : D) => Real.measurableSpace)
                                                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                          fun (i : D) =>
                                                          @UniformSpace.toTopologicalSpace.{0} Real
                                                            (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                              Real.pseudoMetricSpace))
                                                        inst_3 m data coord family (method n) (direction n) current →
                                                      ∀ (E : Real),
                                                        @LE.le.{0} Real Real.instLE
                                                            (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                              (@Zero.toOfNat0.{0} Real Real.instZero))
                                                            E →
                                                          (∀ (c : Cell),
                                                              @LE.le.{0} Real Real.instLE
                                                                (@Norm.norm.{0} (Fin m → Real)
                                                                  (@NormedRing.toNorm.{0} (Fin m → Real)
                                                                    (@Pi.normedRing.{0, 0} (Fin m)
                                                                      (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                      fun (i : Fin m) =>
                                                                      @NormedCommRing.toNormedRing.{0} Real
                                                                        Real.normedCommRing))
                                                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                                    (Fin m → Real)
                                                                    (@instHSub.{0} (Fin m → Real)
                                                                      (@Pi.instSub.{0, 0} (Fin m)
                                                                        (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                                        Real.instSub))
                                                                    (current c) (projected c)))
                                                                E) →
                                                            @LE.le.{0} Real Real.instLE
                                                              (@Norm.norm.{0} (Fin m → Real)
                                                                (@NormedRing.toNorm.{0} (Fin m → Real)
                                                                  (@Pi.normedRing.{0, 0} (Fin m)
                                                                    (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                    fun (i : Fin m) =>
                                                                    @NormedCommRing.toNormedRing.{0} Real
                                                                      Real.normedCommRing))
                                                                (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real)
                                                                  (Fin m → Real)
                                                                  (@instHSub.{0} (Fin m → Real)
                                                                    (@Pi.instSub.{0, 0} (Fin m)
                                                                      (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                                      Real.instSub))
                                                                  (@NumStability.FiniteCoordinate.advance.{u_1, u_2,
                                                                        u_3, u_1, u_4}
                                                                    D Cell Face (D → Real) FacePoint
                                                                    (@MeasurableSpace.pi.{u_1, 0} D
                                                                      (fun (a : D) => Real) fun (a : D) =>
                                                                      Real.measurableSpace)
                                                                    (@Pi.topologicalSpace.{0, u_1} D
                                                                      (fun (a : D) => Real) fun (i : D) =>
                                                                      @UniformSpace.toTopologicalSpace.{0} Real
                                                                        (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                          Real.pseudoMetricSpace))
                                                                    inst_3 m data
                                                                    (@NumStability.FiniteCoordinate.LineRealization.rule.{u_1,
                                                                          u_2, u_3, u_1, u_4, u_5}
                                                                      D Cell Face (D → Real) FacePoint Line
                                                                      (@MeasurableSpace.pi.{u_1, 0} D
                                                                        (fun (a : D) => Real) fun (a : D) =>
                                                                        Real.measurableSpace)
                                                                      (@Pi.topologicalSpace.{0, u_1} D
                                                                        (fun (a : D) => Real) fun (i : D) =>
                                                                        @UniformSpace.toTopologicalSpace.{0} Real
                                                                          (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                            Real.pseudoMetricSpace))
                                                                      inst_3 m data coord family (method n))
                                                                    (direction n)
                                                                    (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1,
                                                                          u_2, u_3, u_1, u_4, u_5}
                                                                      D Cell Face (D → Real) FacePoint Line
                                                                      (@MeasurableSpace.pi.{u_1, 0} D
                                                                        (fun (a : D) => Real) fun (a : D) =>
                                                                        Real.measurableSpace)
                                                                      (@Pi.topologicalSpace.{0, u_1} D
                                                                        (fun (a : D) => Real) fun (i : D) =>
                                                                        @UniformSpace.toTopologicalSpace.{0} Real
                                                                          (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                            Real.pseudoMetricSpace))
                                                                      inst_3 m data coord family (method n)
                                                                      (direction n))
                                                                    current cell)
                                                                  (@NumStability.finiteVolumeCellAverageOn.{0}
                                                                    (Fin m → Real)
                                                                    (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                                      (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                      fun (i : Fin m) => Real.normedAddCommGroup)
                                                                    (@Pi.normedSpace.{0, 0, 0} Real Real.normedField
                                                                      (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                                                      (fun (i : Fin m) =>
                                                                        @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                          Real
                                                                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                            Real
                                                                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                              Real
                                                                              (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                Real Real.normedCommRing))))
                                                                      fun (i : Fin m) =>
                                                                      @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                                        Real.instRCLike
                                                                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                          Real
                                                                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                            Real
                                                                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                              Real
                                                                              (@NormedCommRing.toSeminormedCommRing.{0}
                                                                                Real Real.normedCommRing))))
                                                                        (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                          Real.instRCLike))
                                                                    (@NumStability.DirectionalLine.LineFamily.grid m
                                                                      (family (direction n)
                                                                        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                              u_2, u_3, u_5}
                                                                          m D Cell Face Line coord (direction n) cell))
                                                                      (@NumStability.FiniteCoordinate.LineRealization.level.{u_1,
                                                                            u_2, u_3, u_1, u_4, u_5}
                                                                        D Cell Face (D → Real) FacePoint Line
                                                                        (@MeasurableSpace.pi.{u_1, 0} D
                                                                          (fun (a : D) => Real) fun (a : D) =>
                                                                          Real.measurableSpace)
                                                                        (@Pi.topologicalSpace.{0, u_1} D
                                                                          (fun (a : D) => Real) fun (i : D) =>
                                                                          @UniformSpace.toTopologicalSpace.{0} Real
                                                                            (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                              Real.pseudoMetricSpace))
                                                                        inst_3 m data coord family (method n)
                                                                        (direction n)
                                                                        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                              u_2, u_3, u_5}
                                                                          m D Cell Face Line coord (direction n) cell)))
                                                                    (fun (x : Real) =>
                                                                      q x
                                                                        (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1,
                                                                              u_2, u_3, u_1, u_4, u_5}
                                                                          D Cell Face (D → Real) FacePoint Line
                                                                          (@MeasurableSpace.pi.{u_1, 0} D
                                                                            (fun (a : D) => Real) fun (a : D) =>
                                                                            Real.measurableSpace)
                                                                          (@Pi.topologicalSpace.{0, u_1} D
                                                                            (fun (a : D) => Real) fun (i : D) =>
                                                                            @UniformSpace.toTopologicalSpace.{0} Real
                                                                              (@PseudoMetricSpace.toUniformSpace.{0}
                                                                                Real Real.pseudoMetricSpace))
                                                                          inst_3 m data coord family (method n)
                                                                          (direction n)))
                                                                    (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_1,
                                                                          u_2, u_3, u_5}
                                                                      m D Cell Face Line coord (direction n) cell))))
                                                              (@HAdd.hAdd.{0, 0, 0} Real Real Real
                                                                (@instHAdd.{0} Real Real.instAdd)
                                                                (@HMul.hMul.{0, 0, 0} Real Real Real
                                                                  (@instHMul.{0} Real Real.instMul)
                                                                  (@HAdd.hAdd.{0, 0, 0} Real Real Real
                                                                    (@instHAdd.{0} Real Real.instAdd)
                                                                    (@OfNat.ofNat.{0} Real (nat_lit 1)
                                                                      (@One.toOfNat1.{0} Real Real.instOne))
                                                                    (@HMul.hMul.{0, 0, 0} Real Real Real
                                                                      (@instHMul.{0} Real Real.instMul) L
                                                                      (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1,
                                                                            u_2, u_3, u_1, u_4, u_5}
                                                                        D Cell Face (D → Real) FacePoint Line
                                                                        (@MeasurableSpace.pi.{u_1, 0} D
                                                                          (fun (a : D) => Real) fun (a : D) =>
                                                                          Real.measurableSpace)
                                                                        (@Pi.topologicalSpace.{0, u_1} D
                                                                          (fun (a : D) => Real) fun (i : D) =>
                                                                          @UniformSpace.toTopologicalSpace.{0} Real
                                                                            (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                              Real.pseudoMetricSpace))
                                                                        inst_3 m data coord family (method n)
                                                                        (direction n))))
                                                                  E)
                                                                (@HMul.hMul.{0, 0, 0} Real Real Real
                                                                  (@instHMul.{0} Real Real.instMul)
                                                                  (@HMul.hMul.{0, 0, 0} Real Real Real
                                                                    (@instHMul.{0} Real Real.instMul) C
                                                                    (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1,
                                                                          u_2, u_3, u_1, u_4, u_5}
                                                                      D Cell Face (D → Real) FacePoint Line
                                                                      (@MeasurableSpace.pi.{u_1, 0} D
                                                                        (fun (a : D) => Real) fun (a : D) =>
                                                                        Real.measurableSpace)
                                                                      (@Pi.topologicalSpace.{0, u_1} D
                                                                        (fun (a : D) => Real) fun (i : D) =>
                                                                        @UniformSpace.toTopologicalSpace.{0} Real
                                                                          (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                            Real.pseudoMetricSpace))
                                                                      inst_3 m data coord family (method n)
                                                                      (direction n)))
                                                                  (@HPow.hPow.{0, 0, 0} Real Real Real
                                                                    (@instHPow.{0, 0} Real Real Real.instPow)
                                                                    (@NumStability.DirectionalLine.LineFamily.mesh m
                                                                      (family (direction n)
                                                                        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                              u_2, u_3, u_5}
                                                                          m D Cell Face Line coord (direction n) cell))
                                                                      (@NumStability.FiniteCoordinate.LineRealization.level.{u_1,
                                                                            u_2, u_3, u_1, u_4, u_5}
                                                                        D Cell Face (D → Real) FacePoint Line
                                                                        (@MeasurableSpace.pi.{u_1, 0} D
                                                                          (fun (a : D) => Real) fun (a : D) =>
                                                                          Real.measurableSpace)
                                                                        (@Pi.topologicalSpace.{0, u_1} D
                                                                          (fun (a : D) => Real) fun (i : D) =>
                                                                          @UniformSpace.toTopologicalSpace.{0} Real
                                                                            (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                              Real.pseudoMetricSpace))
                                                                        inst_3 m data coord family (method n)
                                                                        (direction n)
                                                                        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                              u_2, u_3, u_5}
                                                                          m D Cell Face Line coord (direction n) cell)))
                                                                    p)))))))
                      (And
                        (∀ (n : Nat),
                          @LT.lt.{0} Nat instLTNat n steps →
                            ∀ (u : Real),
                              @Membership.mem.{0, 0} Real (Set.{0} Real) (@Set.instMembership.{0} Real)
                                  (@Set.uIcc.{0} Real Real.lattice
                                    (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                                    (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1, u_4,
                                          u_5}
                                      D Cell Face (D → Real) FacePoint Line
                                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                        Real.measurableSpace)
                                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                        @UniformSpace.toTopologicalSpace.{0} Real
                                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                      inst_3 m data coord family (method n) (direction n)))
                                  u →
                                ∀ (v : Real),
                                  @Membership.mem.{0, 0} Real (Set.{0} Real) (@Set.instMembership.{0} Real)
                                      (@Set.uIcc.{0} Real Real.lattice
                                        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                                        (@NumStability.FiniteCoordinate.LineRealization.duration.{u_1, u_2, u_3, u_1,
                                              u_4, u_5}
                                          D Cell Face (D → Real) FacePoint Line
                                          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                            Real.measurableSpace)
                                          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                            @UniformSpace.toTopologicalSpace.{0} Real
                                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                          inst_3 m data coord family (method n) (direction n)))
                                      v →
                                    ∀ (cell : Cell),
                                      @Eq.{1} (Fin m → Real)
                                        (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                          (@instHSMul.{0, 0} Real (Fin m → Real)
                                            (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                              (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                                (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                                (@Algebra.id.{0} Real Real.instCommSemiring))))
                                          (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, u_2, u_3, u_1,
                                                u_4}
                                            D Cell Face (D → Real) FacePoint
                                            (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                              Real.measurableSpace)
                                            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                              @UniformSpace.toTopologicalSpace.{0} Real
                                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                            inst_3 m data cell)
                                          (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                            (@instHSub.{0} (Fin m → Real)
                                              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                Real.instSub))
                                            (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, u_2, u_3, u_1,
                                                  u_4}
                                              D Cell Face (D → Real) FacePoint
                                              (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                Real.measurableSpace)
                                              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                @UniformSpace.toTopologicalSpace.{0} Real
                                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                              inst_3 m data (physical n) cell v)
                                            (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, u_2, u_3, u_1,
                                                  u_4}
                                              D Cell Face (D → Real) FacePoint
                                              (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                Real.measurableSpace)
                                              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                @UniformSpace.toTopologicalSpace.{0} Real
                                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                              inst_3 m data (physical n) cell u)))
                                        (@intervalIntegral.{0} (Fin m → Real)
                                          (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                            (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                          (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                            (fun (a : Fin m) => Real) (Fin.fintype m)
                                            (fun (i : Fin m) =>
                                              @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                      Real.normedCommRing))))
                                            fun (i : Fin m) =>
                                            @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                              (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                      Real.normedCommRing))))
                                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                          (fun (τ : Real) =>
                                            @HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                              (@instHSub.{0} (Fin m → Real)
                                                (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                                  Real.instSub))
                                              (@NumStability.FiniteCoordinate.PhysicalData.faceFlux.{u_1, u_2, u_3, u_1,
                                                    u_4}
                                                D Cell Face (D → Real) FacePoint
                                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                  Real.measurableSpace)
                                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                  @UniformSpace.toTopologicalSpace.{0} Real
                                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                                inst_3 m data (direction n) (physical n)
                                                (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, u_2, u_3,
                                                      u_1, u_4}
                                                  D Cell Face (D → Real) FacePoint
                                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                    Real.measurableSpace)
                                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                    @UniformSpace.toTopologicalSpace.{0} Real
                                                      (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                        Real.pseudoMetricSpace))
                                                  inst_3 m data (direction n) cell)
                                                τ)
                                              (@NumStability.FiniteCoordinate.PhysicalData.faceFlux.{u_1, u_2, u_3, u_1,
                                                    u_4}
                                                D Cell Face (D → Real) FacePoint
                                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                  Real.measurableSpace)
                                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                  @UniformSpace.toTopologicalSpace.{0} Real
                                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                                inst_3 m data (direction n) (physical n)
                                                (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, u_2, u_3,
                                                      u_1, u_4}
                                                  D Cell Face (D → Real) FacePoint
                                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                    Real.measurableSpace)
                                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                    @UniformSpace.toTopologicalSpace.{0} Real
                                                      (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                        Real.pseudoMetricSpace))
                                                  inst_3 m data (direction n) cell)
                                                τ))
                                          u v (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)))
                        (And
                          (∀ (n : Nat),
                            @LE.le.{0} Nat instLENat n steps →
                              ∀ (cell : Cell),
                                @LE.le.{0} Real Real.instLE
                                  (@Norm.norm.{0} (Fin m → Real)
                                    (@NormedRing.toNorm.{0} (Fin m → Real)
                                      (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                        fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                    (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                      (@instHSub.{0} (Fin m → Real)
                                        (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                          Real.instSub))
                                      (@NumStability.FiniteCoordinate.coordinateExecution.{u_1, u_2, u_3, u_1, u_4, u_5}
                                        D Cell Face (D → Real) FacePoint Line
                                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                          Real.measurableSpace)
                                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                          @UniformSpace.toTopologicalSpace.{0} Real
                                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                        inst_3 m data coord family method direction initial n cell)
                                      (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, u_2, u_3, u_1, u_4} D
                                        Cell Face (D → Real) FacePoint
                                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                          Real.measurableSpace)
                                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                          @UniformSpace.toTopologicalSpace.{0} Real
                                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                        inst_3 m data (physical n) cell
                                        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))))
                                  (NumStability.SequentialError.errorBudget amplification localDefect splittingDefect
                                    initialError n))
                          (∀ (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) (cellPosition : Cell → D → Int)
                            (facePosition : D → Face → D → Int) (flux : D → (Fin m → Real) → Fin m → Real),
                            @NumStability.FiniteCartesian.CartesianIdentification.{u_1, u_2, u_3, u_4} D Cell Face
                                FacePoint inst inst_1 inst_3 m data axes cellPosition facePosition flux →
                              And
                                (∀ (cell : Cell),
                                  @Eq.{1} Real
                                    (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, u_2, u_3, u_1, u_4} D
                                      Cell Face (D → Real) FacePoint
                                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                        Real.measurableSpace)
                                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                        @UniformSpace.toTopologicalSpace.{0} Real
                                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                      inst_3 m data cell)
                                    (@NumStability.CartesianGrid.cellVolume.{u_1} D inst axes (cellPosition cell)))
                                (And
                                  (∀ (q : (D → Real) → Real → Fin m → Real) (cell : Cell) (t : Real),
                                    @Eq.{1} (Fin m → Real)
                                      (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, u_2, u_3, u_1, u_4} D
                                        Cell Face (D → Real) FacePoint
                                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                          Real.measurableSpace)
                                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                          @UniformSpace.toTopologicalSpace.{0} Real
                                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                        inst_3 m data q cell t)
                                      (@NumStability.cellVolumeAverage.{u_1, 0} (D → Real) (Fin m → Real)
                                        (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1} (D → Real)
                                          (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst (fun (a : D) => Real)
                                            fun (i : D) => Real.measureSpace))
                                        (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                          fun (i : Fin m) => Real.normedAddCommGroup)
                                        (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                          (fun (a : Fin m) => Real) (Fin.fintype m)
                                          (fun (i : Fin m) =>
                                            @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                          fun (i : Fin m) =>
                                          @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                        (@MeasureTheory.MeasureSpace.volume.{u_1} (D → Real)
                                          (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst (fun (a : D) => Real)
                                            fun (i : D) => Real.measureSpace))
                                        (@NumStability.CartesianGrid.cellBox.{u_1} D axes (cellPosition cell))
                                        fun (x : D → Real) => q x t))
                                  (And
                                    (∀ (q : Real → Real → Fin m → Real) (d : D) (face : Face) (t : Real),
                                      @Eq.{1} (Fin m → Real)
                                        (@NumStability.FiniteCoordinate.PhysicalData.faceFlux.{u_1, u_2, u_3, u_1, u_4}
                                          D Cell Face (D → Real) FacePoint
                                          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                            Real.measurableSpace)
                                          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                            @UniformSpace.toTopologicalSpace.{0} Real
                                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                          inst_3 m data d (fun (x : D → Real) (τ : Real) => q (x d) τ) face t)
                                        (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                          (@instHSMul.{0, 0} Real (Fin m → Real)
                                            (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                              (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                                (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                                (@Algebra.id.{0} Real Real.instCommSemiring))))
                                          (@NumStability.CartesianGrid.faceArea.{u_1} D inst inst_1 axes d
                                            (facePosition d face))
                                          (flux d
                                            (q
                                              (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft (axes d)
                                                (facePosition d face d))
                                              t))))
                                    (∀ (q : Real → Real → Fin m → Real) (d : D),
                                      @NumStability.IsRectangleConservationLawSolution.{0} (Fin m → Real)
                                          (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                            (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                          (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                            (fun (a : Fin m) => Real) (Fin.fintype m)
                                            (fun (i : Fin m) =>
                                              @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                      Real.normedCommRing))))
                                            fun (i : Fin m) =>
                                            @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                              (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                      Real.normedCommRing))))
                                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                          q (flux d) →
                                        ∀ (cell : Cell) (s t : Real),
                                          @Eq.{1} (Fin m → Real)
                                            (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                              (@instHSMul.{0, 0} Real (Fin m → Real)
                                                (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                                    (@Algebra.id.{0} Real Real.instCommSemiring))))
                                              (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, u_2, u_3,
                                                    u_1, u_4}
                                                D Cell Face (D → Real) FacePoint
                                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                  Real.measurableSpace)
                                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                  @UniformSpace.toTopologicalSpace.{0} Real
                                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                                inst_3 m data cell)
                                              (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                                (@instHSub.{0} (Fin m → Real)
                                                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                    fun (i : Fin m) => Real.instSub))
                                                (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, u_2, u_3,
                                                      u_1, u_4}
                                                  D Cell Face (D → Real) FacePoint
                                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                    Real.measurableSpace)
                                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                    @UniformSpace.toTopologicalSpace.{0} Real
                                                      (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                        Real.pseudoMetricSpace))
                                                  inst_3 m data (fun (x : D → Real) (τ : Real) => q (x d) τ) cell t)
                                                (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, u_2, u_3,
                                                      u_1, u_4}
                                                  D Cell Face (D → Real) FacePoint
                                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                    Real.measurableSpace)
                                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                    @UniformSpace.toTopologicalSpace.{0} Real
                                                      (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                        Real.pseudoMetricSpace))
                                                  inst_3 m data (fun (x : D → Real) (τ : Real) => q (x d) τ) cell s)))
                                            (@intervalIntegral.{0} (Fin m → Real)
                                              (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                (Fin.fintype m) fun (i : Fin m) => Real.normedAddCommGroup)
                                              (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                (fun (a : Fin m) => Real) (Fin.fintype m)
                                                (fun (i : Fin m) =>
                                                  @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                          Real.normedCommRing))))
                                                fun (i : Fin m) =>
                                                @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                          Real.normedCommRing))))
                                                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                              (fun (τ : Real) =>
                                                @HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                                  (@instHSub.{0} (Fin m → Real)
                                                    (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                      fun (i : Fin m) => Real.instSub))
                                                  (@NumStability.FiniteCoordinate.PhysicalData.faceFlux.{u_1, u_2, u_3,
                                                        u_1, u_4}
                                                    D Cell Face (D → Real) FacePoint
                                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                      Real.measurableSpace)
                                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                      fun (i : D) =>
                                                      @UniformSpace.toTopologicalSpace.{0} Real
                                                        (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                          Real.pseudoMetricSpace))
                                                    inst_3 m data d (fun (x : D → Real) (τ : Real) => q (x d) τ)
                                                    (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, u_2,
                                                          u_3, u_1, u_4}
                                                      D Cell Face (D → Real) FacePoint
                                                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real)
                                                        fun (a : D) => Real.measurableSpace)
                                                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                        fun (i : D) =>
                                                        @UniformSpace.toTopologicalSpace.{0} Real
                                                          (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                            Real.pseudoMetricSpace))
                                                      inst_3 m data d cell)
                                                    τ)
                                                  (@NumStability.FiniteCoordinate.PhysicalData.faceFlux.{u_1, u_2, u_3,
                                                        u_1, u_4}
                                                    D Cell Face (D → Real) FacePoint
                                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                      Real.measurableSpace)
                                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                      fun (i : D) =>
                                                      @UniformSpace.toTopologicalSpace.{0} Real
                                                        (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                          Real.pseudoMetricSpace))
                                                    inst_3 m data d (fun (x : D → Real) (τ : Real) => q (x d) τ)
                                                    (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, u_2,
                                                          u_3, u_1, u_4}
                                                      D Cell Face (D → Real) FacePoint
                                                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real)
                                                        fun (a : D) => Real.measurableSpace)
                                                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                        fun (i : D) =>
                                                        @UniformSpace.toTopologicalSpace.{0} Real
                                                          (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                            Real.pseudoMetricSpace))
                                                      inst_3 m data d cell)
                                                    τ))
                                              s t
                                              (@MeasureTheory.MeasureSpace.volume.{0} Real
                                                Real.measureSpace)))))))))))))))))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.HighResolutionCoordinateSweep`
- `ComputationalMathematics.Analysis.Normed.Group.SequentialError` imports: `Mathlib.Algebra.Order.Ring.Pow`, `Mathlib.Analysis.Normed.Group.Basic`, `Mathlib.Tactic.Linarith`, `Mathlib.Tactic.NormNum`, `Mathlib.Tactic.Push`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `Mathlib.Analysis.Calculus.FDeriv.Basic`, `Mathlib.LinearAlgebra.Matrix.ToLin`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.MeasureTheory.Integral.Average`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting` imports: `Mathlib.Data.List.Basic`, `Mathlib.Data.Real.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference` imports: `Mathlib.Analysis.Calculus.ContDiff.Defs`, `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `Mathlib.Analysis.SpecialFunctions.Pow.Real`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates` imports: `ComputationalMathematics.Analysis.Normed.Group.SequentialError`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `Mathlib.MeasureTheory.Measure.Lebesgue.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCellProjection` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`, `Mathlib.MeasureTheory.Integral.Pi`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference` imports: `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianGeometry` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`, `Mathlib.MeasureTheory.Integral.Pi`, `Mathlib.Topology.Instances.Int`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCellProjection`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianGeometry`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.HighResolutionCoordinateSweep` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.CartesianGrid.cellBox`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d98a429751fc75f171b958d377c6c9899691b75351f20921fd09cff68df67a58`

Type:

```lean
{D : Type u_1} → (D → NumStability.OneDimensionalFiniteVolumeGrid) → (D → Int) → Set (D → Real)
```

Fully explicit type:

```lean
{D : Type u_1} → (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) → (cell : D → Int) → Set.{u_1} (D → Real)
```

Definition body (one-level semantic boundary):

```lean
fun {D} axes cell => Set.univ.pi fun d => Set.Ico ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d))
```

### D002: `NumStability.CartesianGrid.cellVolume`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b2c577258c5fb7c0706c03a3c2c5a1d18a889d5f555b229b2fc11de44c0243ea`

Type:

```lean
{D : Type u_1} → [Fintype D] → (D → NumStability.OneDimensionalFiniteVolumeGrid) → (D → Int) → Real
```

Fully explicit type:

```lean
{D : Type u_1} → [Fintype.{u_1} D] → (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) → (cell : D → Int) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [Fintype D] axes cell => Finset.univ.prod fun d => (axes d).cellVolume (cell d)
```

### D003: `NumStability.CartesianGrid.faceArea`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `51648336baeec9a7c5985999877892e66b8ac454f3300738dcfe2126a1cfd017`

Type:

```lean
{D : Type u_1} →
  [Fintype D] → [DecidableEq D] → (D → NumStability.OneDimensionalFiniteVolumeGrid) → D → (D → Int) → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  [Fintype.{u_1} D] →
    [DecidableEq.{u_1 + 1} D] →
      (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) → (d : D) → (cell : D → Int) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [Fintype D] [DecidableEq D] axes d cell => (Finset.univ.erase d).prod fun e => (axes e).cellVolume (cell e)
```

### D004: `NumStability.DirectionalLine.LineFamily`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `1d8a6a107307f8cce9988be0a3bce151d8bbd1683ab010f1be55a091158f46a0`

Type:

```lean
Nat → Type
```

Fully explicit type:

```lean
(m : Nat) → Type
```

### D005: `NumStability.DirectionalLine.LineFamily.HasControlledHighResolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `6e393ec19e43cc052fbdc37ff559b05d9e2db224d58aa5ee25ddfacd3f38a065`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Prop
```

Fully explicit type:

```lean
{m : Nat} → (family : NumStability.DirectionalLine.LineFamily m) → Prop
```

### D006: `NumStability.DirectionalLine.LineFamily.InitialProjection`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `bb70da08ec1b1f16fe483bc52ede9c686185cfc9db7f1120ff13d3aefb70cf8f`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → (Real → Real → Fin m → Real) → (Int → Fin m → Real) → Prop
```

Fully explicit type:

```lean
{m : Nat} →
  (family : NumStability.DirectionalLine.LineFamily m) →
    (n : Nat) → (q : Real → Real → Fin m → Real) → (values : Int → Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} family n q values =>
  ∀ (j : Int),
    SetLike.instMembership.mem
        (Finset.Ico (family.inputStart n) (instHAdd.hAdd (family.inputStart n) (family.inputCount n).cast)) j →
      Eq (values j) (NumStability.finiteVolumeCellAverageOn (family.grid n) (fun x => q x 0) j)
```

### D007: `NumStability.DirectionalLine.LineFamily.activeCount`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `688c49a2bc2dd73ecdb1c36bf13e762b514cc19f9148b9556ed5592894a93760`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → Nat
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Nat → Nat
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.21
```

### D008: `NumStability.DirectionalLine.LineFamily.activeStart`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c949a3b5de3aa5470691003baf51ec223833561fb6d8ad51b19fd21054ed4d6d`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → Int
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Nat → Int
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.20
```

### D009: `NumStability.DirectionalLine.LineFamily.admitted`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a20fcaff465f4944d7590b47a5a2d953b8f0d0b5b02794878039721c6aad81de`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → (Int → Fin m → Real) → Prop
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Nat → (Int → Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.34
```

### D010: `NumStability.DirectionalLine.LineFamily.advance`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `0452aed3625808f064a995f7410dfcdcce40bdb25e9770c617f40b001b8b25b2`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → (Int → Fin m → Real) → Int → Fin m → Real
```

Fully explicit type:

```lean
{m : Nat} →
  (family : NumStability.DirectionalLine.LineFamily m) →
    (n : Nat) → (values : Int → Fin m → Real) → (j : Int) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {m} family n values j =>
  NumStability.riemannFiniteVolumeUpdate (family.grid n) (family.dt n) values (family.numericalFlux n values) j
```

### D011: `NumStability.DirectionalLine.LineFamily.dt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `de7086962e7080c617acddc95f120cd751a8cb92762c684f6eea7c419251d788`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → Real
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Nat → Real
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.15
```

### D012: `NumStability.DirectionalLine.LineFamily.flux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4e812d972c4fe0668bea2552d668cffc863591bb3d496b1b3d76303fdb051700`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Real → (Fin m → Real) → Fin m → Real
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Real → (Fin m → Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.1
```

### D013: `NumStability.DirectionalLine.LineFamily.grid`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `064ff73fcf4d132458c73bc0818a5b40f275d3deba1fd2b862a4de821e5e0dfc`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → NumStability.OneDimensionalFiniteVolumeGrid
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Nat → NumStability.OneDimensionalFiniteVolumeGrid
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.9
```

### D014: `NumStability.DirectionalLine.LineFamily.horizon`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `321cceb3e54f8d6741378d227096ccde1e70823373afc94c48e6cd79a10d43d6`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Real
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Real
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.7
```

### D015: `NumStability.DirectionalLine.LineFamily.inputCount`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `905ee32532663ba9e94b4e1f9017c253ad9623f23bdf874bc71855aaa45be4eb`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → Nat
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Nat → Nat
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.29
```

### D016: `NumStability.DirectionalLine.LineFamily.inputStart`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f9c67b5bde237d7a87fa38cad6b8fd423af0b33c725e6d9a48c70d4c9d8a90e7`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → Int
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Nat → Int
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.28
```

### D017: `NumStability.DirectionalLine.LineFamily.left`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `353227b286fd26cad47b6b4ac52abf5fd45730917b2ee3c8f8236d8ca02838b0`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Real
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Real
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.3
```

### D018: `NumStability.DirectionalLine.LineFamily.mesh`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e895697d29ea78c28ae71cd835a9bda96ba2a1a57a0ba091a581b3b541e3c90f`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → Real
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Nat → Real
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.10
```

### D019: `NumStability.DirectionalLine.LineFamily.right`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3006e919adebd661d380d215f9cdf5a5f4c3f3de4e159ee794d9040587df34c0`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Real
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Real
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.4
```

### D020: `NumStability.DirectionalLine.LineFamily.stabilityRate`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `84eb5df216f8ba33bbbb088266a7602068ca55f85dff3d16938248f96ce0e0b1`

Type:

```lean
{m : Nat} → (family : NumStability.DirectionalLine.LineFamily m) → family.HasControlledHighResolution → Real
```

Fully explicit type:

```lean
{m : Nat} →
  (family : NumStability.DirectionalLine.LineFamily m) →
    (quality : @NumStability.DirectionalLine.LineFamily.HasControlledHighResolution m family) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {m} family quality => Classical.choose ⋯
```

### D021: `NumStability.DirectionalLine.LineFamily.states`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `04a9c1f46a60fa61554f4a0ffc0cab0a04fb11b81fd8e48c80690f78fb10462e`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Set (Fin m → Real)
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Set.{0} (Fin m → Real)
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.2
```

### D022: `NumStability.FiniteCartesian.CartesianIdentification`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e3439768a0fbc54c1d41b6a497acfde4f9ad5db17875a864377dbde7ef3dd8d`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {FacePoint : Type u_4} →
        [Fintype D] →
          [DecidableEq D] →
            [inst : MeasurableSpace FacePoint] →
              {m : Nat} →
                NumStability.FiniteCoordinate.PhysicalData D Cell Face (D → Real) FacePoint m →
                  (D → NumStability.OneDimensionalFiniteVolumeGrid) →
                    (Cell → D → Int) → (D → Face → D → Int) → (D → (Fin m → Real) → Fin m → Real) → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {FacePoint : Type u_4} →
        [Fintype.{u_1} D] →
          [DecidableEq.{u_1 + 1} D] →
            [inst : MeasurableSpace.{u_4} FacePoint] →
              {m : Nat} →
                (data :
                    @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
                      FacePoint
                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      inst m) →
                  (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) →
                    (cellPosition : Cell → D → Int) →
                      (facePosition : D → Face → D → Int) → (flux : D → (Fin m → Real) → Fin m → Real) → Prop
```

### D023: `NumStability.FiniteCoordinate.LineCoordinates`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `fa75cb504a97439980f4d6000798c9dabc3ce6783f99a9b631d71741545985a1`

Type:

```lean
{m : Nat} → Type u_7 → Type u_8 → Type u_9 → Type u_10 → Type (max (max (max u_10 u_7) u_8) u_9)
```

Fully explicit type:

```lean
{m : Nat} →
  (D : Type u_7) → (Cell : Type u_8) → (Face : Type u_9) → (Line : Type u_10) → Type (max (max (max u_10 u_7) u_8) u_9)
```

### D024: `NumStability.FiniteCoordinate.LineCoordinates.cellIndex`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a5f5ce598f705e1ad8f7c07414d0ecd87f6b103a59dfe47213e02049b478df47`

Type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Cell → Int
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_7, u_8, u_9, u_10} m D Cell Face Line) →
            D → Cell → Int
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.2
```

### D025: `NumStability.FiniteCoordinate.LineCoordinates.cellLine`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f7ec6a0be8564faa11b5bd1322b358cbc1abc9141ca3f6729624c512ed14daf5`

Type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Cell → Line
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_7, u_8, u_9, u_10} m D Cell Face Line) →
            D → Cell → Line
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.1
```

### D026: `NumStability.FiniteCoordinate.LineCoordinates.extract`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3d84bd0ab48d5fbc750b764825b21bc7a4bc334cfaff284ada222af3df6a54ee`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_6} →
        {m : Nat} →
          NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line →
            D → Line → (Cell → Fin m → Real) → Int → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_6} →
        {m : Nat} →
          (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line) →
            (d : D) → (line : Line) → (current : Cell → Fin m → Real) → (j : Int) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Line} {m} coord d line current j =>
  NumStability.FiniteCoordinate.LineCoordinates.extract.match_1 (fun x => Fin m → Real) (coord.lookup d line j)
    (fun cell => current cell) fun _ => coord.ghost d line j
```

### D027: `NumStability.FiniteCoordinate.LineRealization`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `8b5032a4cd6210cfb2fd839712d0e4ab72311d5a5db0416f8838dda6eac754ba`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                      NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line →
                        (D → Line → NumStability.DirectionalLine.LineFamily m) → Type (max u_1 u_6)
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    (data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m) →
                      (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line) →
                        (family : D → Line → NumStability.DirectionalLine.LineFamily m) → Type (max u_1 u_6)
```

### D028: `NumStability.FiniteCoordinate.LineRealization.Admitted`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5e560bcd200db709f7647509a57d76f86a7e5c404905b23e37db90a2fbbee31a`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          NumStability.FiniteCoordinate.LineRealization data coord family →
                            D → (Cell → Fin m → Real) → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (realization :
                              @NumStability.FiniteCoordinate.LineRealization.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face
                                Point FacePoint Line inst inst_1 inst_2 m data coord family) →
                            (d : D) → (current : Cell → Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} {family} realization d current =>
  ∀ (cell : Cell),
    (family d (coord.cellLine d cell)).admitted (realization.level d (coord.cellLine d cell))
      (coord.extract d (coord.cellLine d cell) current)
```

### D029: `NumStability.FiniteCoordinate.LineRealization.duration`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9da0b80b8df82cd21a91edf81a1fff334f36d728f4765637447f0c8e8613b89f`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          NumStability.FiniteCoordinate.LineRealization data coord family → D → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (self :
                              @NumStability.FiniteCoordinate.LineRealization.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face
                                Point FacePoint Line inst inst_1 inst_2 m data coord family) →
                            D → Real
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint Line [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m data
    coord family self =>
  self.2
```

### D030: `NumStability.FiniteCoordinate.LineRealization.level`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `738d394e155607e53bc35cf30fccffab57fb4b7e9170fc7d6bcb79c158fa743d`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          NumStability.FiniteCoordinate.LineRealization data coord family → D → Line → Nat
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (self :
                              @NumStability.FiniteCoordinate.LineRealization.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face
                                Point FacePoint Line inst inst_1 inst_2 m data coord family) →
                            D → Line → Nat
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint Line [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m data
    coord family self =>
  self.1
```

### D031: `NumStability.FiniteCoordinate.LineRealization.rule`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f523c58e02e809db975593e34601a528452e3b18aa11815d0edfdb14faa92a08`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          NumStability.FiniteCoordinate.LineRealization data coord family →
                            D → Real → (Cell → Fin m → Real) → Face → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (realization :
                              @NumStability.FiniteCoordinate.LineRealization.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face
                                Point FacePoint Line inst inst_1 inst_2 m data coord family) →
                            (d : D) → (_dt : Real) → (current : Cell → Fin m → Real) → (face : Face) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} {family} realization d _dt current face =>
  instHSMul.hSMul (realization.area d (coord.faceLine d face))
    ((family d (coord.faceLine d face)).numericalFlux (realization.level d (coord.faceLine d face))
      (coord.extract d (coord.faceLine d face) current) (coord.faceIndex d face))
```

### D032: `NumStability.FiniteCoordinate.PhysicalData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `d9acae0614eda36259cbe72ec8a6b53e8cbee9ee4318f08ffddfe952511ee822`

Type:

```lean
Type u_1 →
  Type u_2 →
    Type u_3 →
      (Point : Type u_4) →
        (FacePoint : Type u_5) →
          [MeasurableSpace Point] →
            [TopologicalSpace Point] →
              [MeasurableSpace FacePoint] → Nat → Type (max (max (max (max u_1 u_2) u_3) u_4) u_5)
```

Fully explicit type:

```lean
(D : Type u_1) →
  (Cell : Type u_2) →
    (Face : Type u_3) →
      (Point : Type u_4) →
        (FacePoint : Type u_5) →
          [MeasurableSpace.{u_4} Point] →
            [TopologicalSpace.{u_4} Point] →
              [MeasurableSpace.{u_5} FacePoint] → (m : Nat) → Type (max (max (max (max u_1 u_2) u_3) u_4) u_5)
```

### D033: `NumStability.FiniteCoordinate.PhysicalData.ReferenceOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `97864db533199bfffab129e823620c9471721f55f30c32eace06515ec03530b8`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → (Point → Real → Fin m → Real) → Real → Real → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (d : D) → (q : Point → Real → Fin m → Real) → (s t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data d q s t =>
  And
    (∀ (cell : Cell) (τ : Real),
      Set.instMembership.mem (Set.uIcc s t) τ →
        MeasureTheory.IntegrableOn (fun x => q x τ) (data.cells.cellRegion cell) data.measure)
    (And
      (∀ (cell : Cell) (τ : Real),
        Set.instMembership.mem (Set.uIcc s t) τ →
          And
            (MeasureTheory.Integrable
              (fun point =>
                data.normalFlux d (data.leftFace d cell) point (q (data.facePoint d (data.leftFace d cell) point) τ))
              (data.faceMeasure d (data.leftFace d cell)))
            (MeasureTheory.Integrable
              (fun point =>
                data.normalFlux d (data.rightFace d cell) point (q (data.facePoint d (data.rightFace d cell) point) τ))
              (data.faceMeasure d (data.rightFace d cell))))
      (And
        (∀ (x : Point),
          Set.instMembership.mem data.cells.domain x →
            ∀ (τ : Real),
              Set.instMembership.mem (Set.uIcc s t) τ → Set.instMembership.mem (data.admissibleStates d) (q x τ))
        (∀ (u : Real),
          Set.instMembership.mem (Set.uIcc s t) u →
            ∀ (v : Real),
              Set.instMembership.mem (Set.uIcc s t) v →
                And
                  (∀ (cell : Cell),
                    And (IntervalIntegrable (data.faceFlux d q (data.leftFace d cell)) Real.measureSpace.volume u v)
                      (IntervalIntegrable (data.faceFlux d q (data.rightFace d cell)) Real.measureSpace.volume u v))
                  (∀ (cell : Cell),
                    Eq
                      (instHSMul.hSMul (data.cellVolume cell)
                        (instHSub.hSub (data.cellMean q cell v) (data.cellMean q cell u)))
                      (intervalIntegral
                        (fun τ =>
                          instHSub.hSub (data.faceFlux d q (data.leftFace d cell) τ)
                            (data.faceFlux d q (data.rightFace d cell) τ))
                        u v Real.measureSpace.volume)))))
```

### D034: `NumStability.FiniteCoordinate.PhysicalData.cellMean`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7b645175230b06ccfdc98256713a331c11e663b8958c8b71ba97902ea37d8738`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    (Point → Real → Fin m → Real) → Cell → Real → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (q : Point → Real → Fin m → Real) → (cell : Cell) → (t : Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data q cell t =>
  NumStability.cellVolumeAverage data.measure (data.cells.cellRegion cell) fun x => q x t
```

### D035: `NumStability.FiniteCoordinate.PhysicalData.cellVolume`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3740809241090b0fa337df1ea6f347bce37508ae5f099a58d1bb40482c9e1de6`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} → NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → Cell → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (cell : Cell) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data cell =>
  (MeasureTheory.Measure.instFunLike.coe data.measure (data.cells.cellRegion cell)).toReal
```

### D036: `NumStability.FiniteCoordinate.PhysicalData.faceFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `84b61d6ae40dc926057db05bb70fe6684afe2771af942506ef9767ffb3d9c7ed`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → (Point → Real → Fin m → Real) → Face → Real → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (d : D) → (q : Point → Real → Fin m → Real) → (face : Face) → (t : Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data d q face t =>
  MeasureTheory.integral (data.faceMeasure d face) fun point =>
    data.normalFlux d face point (q (data.facePoint d face point) t)
```

### D037: `NumStability.FiniteCoordinate.PhysicalData.leftFace`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f0c97fbc4dfc618572b13da72459e2376fc2f1f5ad8e382df2b3f6b0c5914363`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} → NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → D → Cell → Face
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Cell → Face
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.5
```

### D038: `NumStability.FiniteCoordinate.PhysicalData.rightFace`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8d17eb50708ace3c80d39f12f9794b0dc63f49d4fd6a3b65b527a7e48bd1ea8c`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} → NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → D → Cell → Face
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Cell → Face
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.6
```

### D039: `NumStability.FiniteCoordinate.advance`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b2254dd74a7c5a9b75a35e1a4d7149a146256d9df6a6ab3ee00b212e6802c339`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    (D → Real → (Cell → Fin m → Real) → Face → Fin m → Real) →
                      D → Real → (Cell → Fin m → Real) → Cell → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (rule : D → Real → (Cell → Fin m → Real) → Face → Fin m → Real) →
                      (d : D) → (dt : Real) → (current : Cell → Fin m → Real) → (cell : Cell) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data rule d dt current cell =>
  NumStability.finiteVolumeCellAverageUpdate dt (data.cellVolume cell) (current cell)
    (instHSub.hSub (rule d dt current (data.rightFace d cell)) (rule d dt current (data.leftFace d cell)))
```

### D040: `NumStability.FiniteCoordinate.coordinateExecution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5b0265c84c642e8f9eb61c6e02f08353319a0c512f7102411225ebd99f3572b0`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (Nat → NumStability.FiniteCoordinate.LineRealization data coord family) →
                            (Nat → D) → (Cell → Fin m → Real) → Nat → Cell → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (method :
                              Nat →
                                @NumStability.FiniteCoordinate.LineRealization.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell
                                  Face Point FacePoint Line inst inst_1 inst_2 m data coord family) →
                            (direction : Nat → D) → (initial : Cell → Fin m → Real) → Nat → Cell → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} {family} method direction initial =>
  NumStability.SequentialError.execution (NumStability.FiniteCoordinate.coordinateStep method direction) initial
```

### D041: `NumStability.FiniteCoordinate.coordinateStep`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c213bec978d16fa1a07ecd2fa421ea952b9d21ecc3a95b4dda8bb7e4fa240013`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (Nat → NumStability.FiniteCoordinate.LineRealization data coord family) →
                            (Nat → D) → Nat → (Cell → Fin m → Real) → Cell → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (method :
                              Nat →
                                @NumStability.FiniteCoordinate.LineRealization.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell
                                  Face Point FacePoint Line inst inst_1 inst_2 m data coord family) →
                            (direction : Nat → D) → (n : Nat) → (Cell → Fin m → Real) → Cell → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} {family} method direction n =>
  NumStability.FiniteCoordinate.advance data (method n).rule (direction n) ((method n).duration (direction n))
```

### D042: `NumStability.IsRectangleConservationLawSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `fbb14b5d2b7941d655b995775ba7559106550b42dada80ff310b1923062aded3`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → Real → E) → (E → E) → Prop
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (q : Real → Real → E) → (flux : E → E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] q flux =>
  And (∀ (a b t : Real), IntervalIntegrable (fun x => q x t) Real.measureSpace.volume a b)
    (And (∀ (x s t : Real), IntervalIntegrable (fun τ => flux (q x τ)) Real.measureSpace.volume s t)
      (∀ (a b s t : Real),
        Eq
          (instHSub.hSub (intervalIntegral (fun x => q x t) a b Real.measureSpace.volume)
            (intervalIntegral (fun x => q x s) a b Real.measureSpace.volume))
          (intervalIntegral (fun τ => instHSub.hSub (flux (q a τ)) (flux (q b τ))) s t Real.measureSpace.volume)))
```

### D043: `NumStability.LocalConservationLaw.SpatialSmoothReferenceOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `719c2734dc3e85bf8c16f624d1bdbdb3171c0923c9922f4bc7f6384207df76c8`

Type:

```lean
{m : Nat} →
  (Real → Real → Fin m → Real) → (Real → (Fin m → Real) → Fin m → Real) → Set (Fin m → Real) → Real → Real → Real → Prop
```

Fully explicit type:

```lean
{m : Nat} →
  (q : Real → Real → Fin m → Real) →
    (flux : Real → (Fin m → Real) → Fin m → Real) →
      (states : Set.{0} (Fin m → Real)) → (left right horizon : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} q flux states left right horizon =>
  And
    (ContDiffOn Real WithTop.top.top (Function.uncurry q)
      (Set.instSProd.sprod (Set.Icc left right) (Set.Icc 0 horizon)))
    (And (NumStability.LocalConservationLaw.SpatialRectangleReferenceOn q flux left right horizon)
      (∀ (x : Real),
        Set.instMembership.mem (Set.Icc left right) x →
          ∀ (t : Real), Set.instMembership.mem (Set.Icc 0 horizon) t → Set.instMembership.mem states (q x t)))
```

### D044: `NumStability.OneDimensionalFiniteVolumeGrid`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `f45b4f5e41b1c7954e0f18cce119693e8b371eeee4d32f4d849109d5363609ce`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D045: `NumStability.OneDimensionalFiniteVolumeGrid.cellLeft`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `b7710f4b704055e41f311498ad422f4456733c8825429083c430d39299154b76`

Type:

```lean
NumStability.OneDimensionalFiniteVolumeGrid → Int → Real
```

Fully explicit type:

```lean
(self : NumStability.OneDimensionalFiniteVolumeGrid) → Int → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.1
```

### D046: `NumStability.SequentialError.errorBudget`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.Normed.Group.SequentialError`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d984609811fa87c7e033b59409eb7e5f0258effa210ef9867c92064d3800705d`

Type:

```lean
(Nat → Real) → (Nat → Real) → (Nat → Real) → Real → Nat → Real
```

Fully explicit type:

```lean
(amplification localDefect splittingDefect : Nat → Real) → (initialError : Real) → Nat → Real
```

Definition body (one-level semantic boundary):

```lean
fun amplification localDefect splittingDefect initialError x =>
  Nat.brecOn x fun x f =>
    NumStability.SequentialError.execution.match_1 (fun x => Nat.below x → Real) x (fun _ x => initialError)
      (fun n x =>
        instHAdd.hAdd (instHAdd.hAdd (instHMul.hMul (amplification n) x.1) (localDefect n)) (splittingDefect n))
      f
```

### D047: `NumStability.cellVolumeAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `bc8800385daf12f69f5f7359f6f4ae6dcc02bae04ea06c59c19ad641935524ed`

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

### D048: `NumStability.finiteVolumeCellAverageOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `65e6559cfb9ca07940be04cbe50ab95271f5d1de635854144495cca35ed0c4d9`

Type:

```lean
{State : Type u_1} →
  [inst : NormedAddCommGroup State] →
    [NormedSpace Real State] → NumStability.OneDimensionalFiniteVolumeGrid → (Real → State) → Int → State
```

Fully explicit type:

```lean
{State : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} State] →
    [@NormedSpace.{0, u_1} Real State Real.normedField
          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} State inst)] →
      (grid : NumStability.OneDimensionalFiniteVolumeGrid) → (state : Real → State) → (i : Int) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} [NormedAddCommGroup State] [NormedSpace Real State] grid state i =>
  NumStability.oneDimensionalCellAverage state (grid.cellLeft i) (grid.cellRight i)
```

### D049: `NumStability.oneDimensionalCellAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `0c59840079f273e3900b018ab6f6dbe73c00e7370875b883e4413e18c63ddc92`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → E
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (field : Real → E) → (left right : Real) → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] field left right =>
  instHSMul.hSMul (Real.instInv.inv (instHSub.hSub right left))
    (intervalIntegral (fun x => field x) left right Real.measureSpace.volume)
```

### D050: `NumStability.orderedOperatorSweep`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5830ce6de1bee8addeaf85abcbff49e9482235cb48e3ee7fec77df9b25815735`

Type:

```lean
{State : Type u_1} → List (State → State) → State → State
```

Fully explicit type:

```lean
{State : Type u_1} → (operators : List.{u_1} (State → State)) → (state : State) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} operators state => List.foldl (fun current step => step current) state operators
```

### D051: `NumStability.DirectionalLine.LineFamily.HasControlledHighResolution.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `5ad758336310b413bf5d3b327f45c18c6bda109e97edd3ccc98f81c1901f3d75`

Type:

```lean
∀ {m : Nat} {family : NumStability.DirectionalLine.LineFamily m},
  (Exists fun p =>
      And (Real.instLT.lt 1 p)
        (∀ (q : Real → Real → Fin m → Real),
          NumStability.LocalConservationLaw.SpatialSmoothReferenceOn q family.flux family.states family.left
              family.right family.horizon →
            Exists fun C =>
              And (Real.instLE.le 0 C)
                (Exists fun N =>
                  ∀ (n : Nat),
                    instLENat.le N n →
                      ∀ (values : Int → Fin m → Real),
                        family.InitialProjection n q values →
                          And (family.admitted n values)
                            (∀ (j : Int),
                              SetLike.instMembership.mem
                                  (Finset.Ico (family.activeStart n)
                                    (instHAdd.hAdd (family.activeStart n) (family.activeCount n).cast))
                                  j →
                                Real.instLE.le
                                  (Pi.normedRing.norm
                                    (instHSub.hSub (family.advance n values j)
                                      (NumStability.finiteVolumeCellAverageOn (family.grid n)
                                        (fun x => q x (family.dt n)) j)))
                                  (instHMul.hMul (instHMul.hMul C (family.dt n))
                                    (instHPow.hPow (family.mesh n) p)))))) →
    (Exists fun L =>
        And (Real.instLE.le 0 L)
          (∀ (n : Nat) (values other : Int → Fin m → Real),
            family.admitted n values →
              family.admitted n other →
                ∀ (E : Real),
                  Real.instLE.le 0 E →
                    (∀ (j : Int),
                        SetLike.instMembership.mem
                            (Finset.Ico (family.inputStart n)
                              (instHAdd.hAdd (family.inputStart n) (family.inputCount n).cast))
                            j →
                          Real.instLE.le (Pi.normedRing.norm (instHSub.hSub (values j) (other j))) E) →
                      ∀ (j : Int),
                        SetLike.instMembership.mem
                            (Finset.Ico (family.activeStart n)
                              (instHAdd.hAdd (family.activeStart n) (family.activeCount n).cast))
                            j →
                          Real.instLE.le
                            (Pi.normedRing.norm (instHSub.hSub (family.advance n values j) (family.advance n other j)))
                            (instHMul.hMul (instHAdd.hAdd 1 (instHMul.hMul L (family.dt n))) E))) →
      (Exists fun K =>
          And (Real.instLE.le 0 K)
            (Exists fun noise =>
              And (∀ (n : Nat), Real.instLE.le 0 (noise n))
                (And (Filter.Tendsto noise Filter.atTop (nhds 0))
                  (∀ (n : Nat) (values : Int → Fin m → Real),
                    family.admitted n values →
                      Real.instLE.le
                        (NumStability.DirectionalLine.windowVariation (family.activeStart n)
                          (instHSub.hSub (family.activeCount n) 1) (family.advance n values))
                        (instHAdd.hAdd
                          (instHMul.hMul (instHAdd.hAdd 1 (instHMul.hMul K (family.dt n)))
                            (NumStability.DirectionalLine.windowVariation (family.inputStart n)
                              (instHSub.hSub (family.inputCount n) 1) values))
                          (instHMul.hMul (family.dt n) (noise n))))))) →
        family.HasControlledHighResolution
```

Fully explicit type:

```lean
∀ {m : Nat} {family : NumStability.DirectionalLine.LineFamily m}
  (order :
    @Exists.{1} Real fun (p : Real) =>
      And (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)) p)
        (∀ (q : Real → Real → Fin m → Real),
          @NumStability.LocalConservationLaw.SpatialSmoothReferenceOn m q
              (@NumStability.DirectionalLine.LineFamily.flux m family)
              (@NumStability.DirectionalLine.LineFamily.states m family)
              (@NumStability.DirectionalLine.LineFamily.left m family)
              (@NumStability.DirectionalLine.LineFamily.right m family)
              (@NumStability.DirectionalLine.LineFamily.horizon m family) →
            @Exists.{1} Real fun (C : Real) =>
              And
                (@LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                  C)
                (@Exists.{1} Nat fun (N : Nat) =>
                  ∀ (n : Nat),
                    @LE.le.{0} Nat instLENat N n →
                      ∀ (values : Int → Fin m → Real),
                        @NumStability.DirectionalLine.LineFamily.InitialProjection m family n q values →
                          And (@NumStability.DirectionalLine.LineFamily.admitted m family n values)
                            (∀ (j : Int),
                              @Membership.mem.{0, 0} Int (Finset.{0} Int)
                                  (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int (@Finset.instSetLike.{0} Int))
                                  (@Finset.Ico.{0} Int
                                    (@PartialOrder.toPreorder.{0} Int
                                      (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0} Int
                                        (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                          Int
                                          (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0} Int
                                            (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0} Int
                                              instConditionallyCompleteLinearOrder)))))
                                    Int.instLocallyFiniteOrder
                                    (@NumStability.DirectionalLine.LineFamily.activeStart m family n)
                                    (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
                                      (@NumStability.DirectionalLine.LineFamily.activeStart m family n)
                                      (@Nat.cast.{0} Int instNatCastInt
                                        (@NumStability.DirectionalLine.LineFamily.activeCount m family n))))
                                  j →
                                @LE.le.{0} Real Real.instLE
                                  (@Norm.norm.{0} (Fin m → Real)
                                    (@NormedRing.toNorm.{0} (Fin m → Real)
                                      (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                        fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                    (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                      (@instHSub.{0} (Fin m → Real)
                                        (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                          Real.instSub))
                                      (@NumStability.DirectionalLine.LineFamily.advance m family n values j)
                                      (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
                                        (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                          fun (i : Fin m) => Real.normedAddCommGroup)
                                        (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                          (fun (a : Fin m) => Real) (Fin.fintype m)
                                          (fun (i : Fin m) =>
                                            @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                          fun (i : Fin m) =>
                                          @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                                        (@NumStability.DirectionalLine.LineFamily.grid m family n)
                                        (fun (x : Real) => q x (@NumStability.DirectionalLine.LineFamily.dt m family n))
                                        j)))
                                  (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                    (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) C
                                      (@NumStability.DirectionalLine.LineFamily.dt m family n))
                                    (@HPow.hPow.{0, 0, 0} Real Real Real (@instHPow.{0, 0} Real Real Real.instPow)
                                      (@NumStability.DirectionalLine.LineFamily.mesh m family n) p))))))
  (stability :
    @Exists.{1} Real fun (L : Real) =>
      And (@LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) L)
        (∀ (n : Nat) (values other : Int → Fin m → Real),
          @NumStability.DirectionalLine.LineFamily.admitted m family n values →
            @NumStability.DirectionalLine.LineFamily.admitted m family n other →
              ∀ (E : Real),
                @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                    E →
                  (∀ (j : Int),
                      @Membership.mem.{0, 0} Int (Finset.{0} Int)
                          (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int (@Finset.instSetLike.{0} Int))
                          (@Finset.Ico.{0} Int
                            (@PartialOrder.toPreorder.{0} Int
                              (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0} Int
                                (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0} Int
                                  (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0} Int
                                    (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0} Int
                                      instConditionallyCompleteLinearOrder)))))
                            Int.instLocallyFiniteOrder (@NumStability.DirectionalLine.LineFamily.inputStart m family n)
                            (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
                              (@NumStability.DirectionalLine.LineFamily.inputStart m family n)
                              (@Nat.cast.{0} Int instNatCastInt
                                (@NumStability.DirectionalLine.LineFamily.inputCount m family n))))
                          j →
                        @LE.le.{0} Real Real.instLE
                          (@Norm.norm.{0} (Fin m → Real)
                            (@NormedRing.toNorm.{0} (Fin m → Real)
                              (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                            (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                              (@instHSub.{0} (Fin m → Real)
                                (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                              (values j) (other j)))
                          E) →
                    ∀ (j : Int),
                      @Membership.mem.{0, 0} Int (Finset.{0} Int)
                          (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int (@Finset.instSetLike.{0} Int))
                          (@Finset.Ico.{0} Int
                            (@PartialOrder.toPreorder.{0} Int
                              (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0} Int
                                (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0} Int
                                  (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0} Int
                                    (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0} Int
                                      instConditionallyCompleteLinearOrder)))))
                            Int.instLocallyFiniteOrder (@NumStability.DirectionalLine.LineFamily.activeStart m family n)
                            (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
                              (@NumStability.DirectionalLine.LineFamily.activeStart m family n)
                              (@Nat.cast.{0} Int instNatCastInt
                                (@NumStability.DirectionalLine.LineFamily.activeCount m family n))))
                          j →
                        @LE.le.{0} Real Real.instLE
                          (@Norm.norm.{0} (Fin m → Real)
                            (@NormedRing.toNorm.{0} (Fin m → Real)
                              (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                            (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                              (@instHSub.{0} (Fin m → Real)
                                (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                              (@NumStability.DirectionalLine.LineFamily.advance m family n values j)
                              (@NumStability.DirectionalLine.LineFamily.advance m family n other j)))
                          (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                            (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                              (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
                              (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) L
                                (@NumStability.DirectionalLine.LineFamily.dt m family n)))
                            E)))
  (oscillation :
    @Exists.{1} Real fun (K : Real) =>
      And (@LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) K)
        (@Exists.{1} (Nat → Real) fun (noise : Nat → Real) =>
          And
            (∀ (n : Nat),
              @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                (noise n))
            (And
              (@Filter.Tendsto.{0, 0} Nat Real noise (@Filter.atTop.{0} Nat Nat.instPreorder)
                (@nhds.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))))
              (∀ (n : Nat) (values : Int → Fin m → Real),
                @NumStability.DirectionalLine.LineFamily.admitted m family n values →
                  @LE.le.{0} Real Real.instLE
                    (@NumStability.DirectionalLine.windowVariation m
                      (@NumStability.DirectionalLine.LineFamily.activeStart m family n)
                      (@HSub.hSub.{0, 0, 0} Nat Nat Nat (@instHSub.{0} Nat instSubNat)
                        (@NumStability.DirectionalLine.LineFamily.activeCount m family n)
                        (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                      (@NumStability.DirectionalLine.LineFamily.advance m family n values))
                    (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                      (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                        (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                          (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
                          (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) K
                            (@NumStability.DirectionalLine.LineFamily.dt m family n)))
                        (@NumStability.DirectionalLine.windowVariation m
                          (@NumStability.DirectionalLine.LineFamily.inputStart m family n)
                          (@HSub.hSub.{0, 0, 0} Nat Nat Nat (@instHSub.{0} Nat instSubNat)
                            (@NumStability.DirectionalLine.LineFamily.inputCount m family n)
                            (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                          values))
                      (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                        (@NumStability.DirectionalLine.LineFamily.dt m family n) (noise n))))))),
  @NumStability.DirectionalLine.LineFamily.HasControlledHighResolution m family
```

### D052: `NumStability.DirectionalLine.LineFamily.HasControlledHighResolution.stability`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `5a7d9cdff3c0c1590082205b4cd5caeee2db4f6c88d5c1ddd1246f6be23e5d79`

Type:

```lean
∀ {m : Nat} {family : NumStability.DirectionalLine.LineFamily m},
  family.HasControlledHighResolution →
    Exists fun L =>
      And (Real.instLE.le 0 L)
        (∀ (n : Nat) (values other : Int → Fin m → Real),
          family.admitted n values →
            family.admitted n other →
              ∀ (E : Real),
                Real.instLE.le 0 E →
                  (∀ (j : Int),
                      SetLike.instMembership.mem
                          (Finset.Ico (family.inputStart n)
                            (instHAdd.hAdd (family.inputStart n) (family.inputCount n).cast))
                          j →
                        Real.instLE.le (Pi.normedRing.norm (instHSub.hSub (values j) (other j))) E) →
                    ∀ (j : Int),
                      SetLike.instMembership.mem
                          (Finset.Ico (family.activeStart n)
                            (instHAdd.hAdd (family.activeStart n) (family.activeCount n).cast))
                          j →
                        Real.instLE.le
                          (Pi.normedRing.norm (instHSub.hSub (family.advance n values j) (family.advance n other j)))
                          (instHMul.hMul (instHAdd.hAdd 1 (instHMul.hMul L (family.dt n))) E))
```

Fully explicit type:

```lean
∀ {m : Nat} {family : NumStability.DirectionalLine.LineFamily m}
  (self : @NumStability.DirectionalLine.LineFamily.HasControlledHighResolution m family),
  @Exists.{1} Real fun (L : Real) =>
    And (@LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) L)
      (∀ (n : Nat) (values other : Int → Fin m → Real),
        @NumStability.DirectionalLine.LineFamily.admitted m family n values →
          @NumStability.DirectionalLine.LineFamily.admitted m family n other →
            ∀ (E : Real),
              @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                  E →
                (∀ (j : Int),
                    @Membership.mem.{0, 0} Int (Finset.{0} Int)
                        (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int (@Finset.instSetLike.{0} Int))
                        (@Finset.Ico.{0} Int
                          (@PartialOrder.toPreorder.{0} Int
                            (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0} Int
                              (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0} Int
                                (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0} Int
                                  (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0} Int
                                    instConditionallyCompleteLinearOrder)))))
                          Int.instLocallyFiniteOrder (@NumStability.DirectionalLine.LineFamily.inputStart m family n)
                          (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
                            (@NumStability.DirectionalLine.LineFamily.inputStart m family n)
                            (@Nat.cast.{0} Int instNatCastInt
                              (@NumStability.DirectionalLine.LineFamily.inputCount m family n))))
                        j →
                      @LE.le.{0} Real Real.instLE
                        (@Norm.norm.{0} (Fin m → Real)
                          (@NormedRing.toNorm.{0} (Fin m → Real)
                            (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                              @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                          (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                            (@instHSub.{0} (Fin m → Real)
                              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                            (values j) (other j)))
                        E) →
                  ∀ (j : Int),
                    @Membership.mem.{0, 0} Int (Finset.{0} Int)
                        (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int (@Finset.instSetLike.{0} Int))
                        (@Finset.Ico.{0} Int
                          (@PartialOrder.toPreorder.{0} Int
                            (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0} Int
                              (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0} Int
                                (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0} Int
                                  (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0} Int
                                    instConditionallyCompleteLinearOrder)))))
                          Int.instLocallyFiniteOrder (@NumStability.DirectionalLine.LineFamily.activeStart m family n)
                          (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
                            (@NumStability.DirectionalLine.LineFamily.activeStart m family n)
                            (@Nat.cast.{0} Int instNatCastInt
                              (@NumStability.DirectionalLine.LineFamily.activeCount m family n))))
                        j →
                      @LE.le.{0} Real Real.instLE
                        (@Norm.norm.{0} (Fin m → Real)
                          (@NormedRing.toNorm.{0} (Fin m → Real)
                            (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                              @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                          (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                            (@instHSub.{0} (Fin m → Real)
                              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                            (@NumStability.DirectionalLine.LineFamily.advance m family n values j)
                            (@NumStability.DirectionalLine.LineFamily.advance m family n other j)))
                        (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                          (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                            (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
                            (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) L
                              (@NumStability.DirectionalLine.LineFamily.dt m family n)))
                          E))
```

### D053: `NumStability.DirectionalLine.LineFamily.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `537161f03c3f7cb768b5135bacf86acec4b2a3502473d1c044b734007858d4cb`

Type:

```lean
{m : Nat} →
  (flux : Real → (Fin m → Real) → Fin m → Real) →
    (states : Set (Fin m → Real)) →
      (left right : Real) →
        Real.instLT.lt left right →
          (∀ (x : Real),
              Set.instMembership.mem (Set.Icc left right) x → NumStability.IsHyperbolicFluxOn (flux x) states) →
            (horizon : Real) →
              Real.instLT.lt 0 horizon →
                (grid : Nat → NumStability.OneDimensionalFiniteVolumeGrid) →
                  (mesh : Nat → Real) →
                    (∀ (n : Nat), Real.instLT.lt 0 (mesh n)) →
                      Filter.Tendsto mesh Filter.atTop (nhds 0) →
                        (meshRatio : Real) →
                          Real.instLT.lt 0 meshRatio →
                            (dt : Nat → Real) →
                              (∀ (n : Nat), Real.instLT.lt 0 (dt n)) →
                                (∀ (n : Nat), Real.instLE.le (dt n) horizon) →
                                  (cfl : Real) →
                                    Real.instLT.lt 0 cfl →
                                      (activeStart : Nat → Int) →
                                        (activeCount : Nat → Nat) →
                                          (∀ (n : Nat), instLENat.le 2 (activeCount n)) →
                                            (targetLeft targetRight : Real) →
                                              Real.instLT.lt targetLeft targetRight →
                                                And (Real.instLT.lt left targetLeft)
                                                    (Real.instLT.lt targetRight right) →
                                                  (∀ (n : Nat) (x : Real),
                                                      Set.instMembership.mem (Set.Icc targetLeft targetRight) x →
                                                        Exists fun j =>
                                                          And
                                                            (SetLike.instMembership.mem
                                                              (Finset.Ico (activeStart n)
                                                                (instHAdd.hAdd (activeStart n) (activeCount n).cast))
                                                              j)
                                                            (Set.instMembership.mem
                                                              (Set.Icc ((grid n).cellLeft j) ((grid n).cellRight j))
                                                              x)) →
                                                    (inputStart : Nat → Int) →
                                                      (inputCount : Nat → Nat) →
                                                        (∀ (n : Nat),
                                                            Finset.instHasSubset.Subset
                                                              (Finset.Ico (activeStart n)
                                                                (instHAdd.hAdd (activeStart n) (activeCount n).cast))
                                                              (Finset.Ico (inputStart n)
                                                                (instHAdd.hAdd (inputStart n) (inputCount n).cast))) →
                                                          (∀ (n : Nat) (j : Int),
                                                              SetLike.instMembership.mem
                                                                  (Finset.Ico (inputStart n)
                                                                    (instHAdd.hAdd (inputStart n) (inputCount n).cast))
                                                                  j →
                                                                And (Real.instLE.le left ((grid n).cellLeft j))
                                                                  (And (Real.instLE.le ((grid n).cellRight j) right)
                                                                    (And
                                                                      (Real.instLE.le ((grid n).cellVolume j) (mesh n))
                                                                      (Real.instLE.le (dt n)
                                                                        (instHMul.hMul cfl
                                                                          ((grid n).cellVolume j)))))) →
                                                            (∀ (n : Nat) (j : Int),
                                                                SetLike.instMembership.mem
                                                                    (Finset.Ico (inputStart n)
                                                                      (instHAdd.hAdd (inputStart n)
                                                                        (inputCount n).cast))
                                                                    j →
                                                                  Real.instLE.le (mesh n)
                                                                    (instHMul.hMul meshRatio ((grid n).cellVolume j))) →
                                                              (numericalFlux :
                                                                  Nat → (Int → Fin m → Real) → Int → Fin m → Real) →
                                                                (Nat → (Int → Fin m → Real) → Prop) →
                                                                  (∀ (n : Nat) (q other : Int → Fin m → Real),
                                                                      (∀ (j : Int),
                                                                          SetLike.instMembership.mem
                                                                              (Finset.Ico (inputStart n)
                                                                                (instHAdd.hAdd (inputStart n)
                                                                                  (inputCount n).cast))
                                                                              j →
                                                                            Eq (q j) (other j)) →
                                                                        ∀ (j : Int),
                                                                          SetLike.instMembership.mem
                                                                              (Finset.Icc (activeStart n)
                                                                                (instHAdd.hAdd (activeStart n)
                                                                                  (activeCount n).cast))
                                                                              j →
                                                                            Eq (numericalFlux n q j)
                                                                              (numericalFlux n other j)) →
                                                                    NumStability.DirectionalLine.LineFamily m
```

Fully explicit type:

```lean
{m : Nat} →
  (flux : Real → (Fin m → Real) → Fin m → Real) →
    (states : Set.{0} (Fin m → Real)) →
      (left right : Real) →
        (interval_nonempty : @LT.lt.{0} Real Real.instLT left right) →
          (hyperbolic :
              ∀ (x : Real),
                @Membership.mem.{0, 0} Real (Set.{0} Real) (@Set.instMembership.{0} Real)
                    (@Set.Icc.{0} Real Real.instPreorder left right) x →
                  @NumStability.IsHyperbolicFluxOn m (flux x) states) →
            (horizon : Real) →
              (horizon_pos :
                  @LT.lt.{0} Real Real.instLT
                    (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) horizon) →
                (grid : Nat → NumStability.OneDimensionalFiniteVolumeGrid) →
                  (mesh : Nat → Real) →
                    (mesh_pos :
                        ∀ (n : Nat),
                          @LT.lt.{0} Real Real.instLT
                            (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) (mesh n)) →
                      (mesh_tendsto :
                          @Filter.Tendsto.{0, 0} Nat Real mesh (@Filter.atTop.{0} Nat Nat.instPreorder)
                            (@nhds.{0} Real
                              (@UniformSpace.toTopologicalSpace.{0} Real
                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))) →
                        (meshRatio : Real) →
                          (meshRatio_pos :
                              @LT.lt.{0} Real Real.instLT
                                (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) meshRatio) →
                            (dt : Nat → Real) →
                              (dt_pos :
                                  ∀ (n : Nat),
                                    @LT.lt.{0} Real Real.instLT
                                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                                      (dt n)) →
                                (dt_le_horizon : ∀ (n : Nat), @LE.le.{0} Real Real.instLE (dt n) horizon) →
                                  (cfl : Real) →
                                    (cfl_pos :
                                        @LT.lt.{0} Real Real.instLT
                                          (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                                          cfl) →
                                      (activeStart : Nat → Int) →
                                        (activeCount : Nat → Nat) →
                                          (activeCount_two_le :
                                              ∀ (n : Nat),
                                                @LE.le.{0} Nat instLENat
                                                  (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))
                                                  (activeCount n)) →
                                            (targetLeft targetRight : Real) →
                                              (target_nonempty : @LT.lt.{0} Real Real.instLT targetLeft targetRight) →
                                                (target_inside :
                                                    And (@LT.lt.{0} Real Real.instLT left targetLeft)
                                                      (@LT.lt.{0} Real Real.instLT targetRight right)) →
                                                  (active_coverage :
                                                      ∀ (n : Nat) (x : Real),
                                                        @Membership.mem.{0, 0} Real (Set.{0} Real)
                                                            (@Set.instMembership.{0} Real)
                                                            (@Set.Icc.{0} Real Real.instPreorder targetLeft targetRight)
                                                            x →
                                                          @Exists.{1} Int fun (j : Int) =>
                                                            And
                                                              (@Membership.mem.{0, 0} Int (Finset.{0} Int)
                                                                (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int
                                                                  (@Finset.instSetLike.{0} Int))
                                                                (@Finset.Ico.{0} Int
                                                                  (@PartialOrder.toPreorder.{0} Int
                                                                    (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0}
                                                                      Int
                                                                      (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                                        Int
                                                                        (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                                          Int
                                                                          (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                            Int
                                                                            instConditionallyCompleteLinearOrder)))))
                                                                  Int.instLocallyFiniteOrder (activeStart n)
                                                                  (@HAdd.hAdd.{0, 0, 0} Int Int Int
                                                                    (@instHAdd.{0} Int Int.instAdd) (activeStart n)
                                                                    (@Nat.cast.{0} Int instNatCastInt (activeCount n))))
                                                                j)
                                                              (@Membership.mem.{0, 0} Real (Set.{0} Real)
                                                                (@Set.instMembership.{0} Real)
                                                                (@Set.Icc.{0} Real Real.instPreorder
                                                                  (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft
                                                                    (grid n) j)
                                                                  (NumStability.OneDimensionalFiniteVolumeGrid.cellRight
                                                                    (grid n) j))
                                                                x)) →
                                                    (inputStart : Nat → Int) →
                                                      (inputCount : Nat → Nat) →
                                                        (input_covers :
                                                            ∀ (n : Nat),
                                                              @HasSubset.Subset.{0} (Finset.{0} Int)
                                                                (@Finset.instHasSubset.{0} Int)
                                                                (@Finset.Ico.{0} Int
                                                                  (@PartialOrder.toPreorder.{0} Int
                                                                    (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0}
                                                                      Int
                                                                      (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                                        Int
                                                                        (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                                          Int
                                                                          (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                            Int
                                                                            instConditionallyCompleteLinearOrder)))))
                                                                  Int.instLocallyFiniteOrder (activeStart n)
                                                                  (@HAdd.hAdd.{0, 0, 0} Int Int Int
                                                                    (@instHAdd.{0} Int Int.instAdd) (activeStart n)
                                                                    (@Nat.cast.{0} Int instNatCastInt (activeCount n))))
                                                                (@Finset.Ico.{0} Int
                                                                  (@PartialOrder.toPreorder.{0} Int
                                                                    (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0}
                                                                      Int
                                                                      (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                                        Int
                                                                        (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                                          Int
                                                                          (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                            Int
                                                                            instConditionallyCompleteLinearOrder)))))
                                                                  Int.instLocallyFiniteOrder (inputStart n)
                                                                  (@HAdd.hAdd.{0, 0, 0} Int Int Int
                                                                    (@instHAdd.{0} Int Int.instAdd) (inputStart n)
                                                                    (@Nat.cast.{0} Int instNatCastInt
                                                                      (inputCount n))))) →
                                                          (input_geometry :
                                                              ∀ (n : Nat) (j : Int),
                                                                @Membership.mem.{0, 0} Int (Finset.{0} Int)
                                                                    (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int
                                                                      (@Finset.instSetLike.{0} Int))
                                                                    (@Finset.Ico.{0} Int
                                                                      (@PartialOrder.toPreorder.{0} Int
                                                                        (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0}
                                                                          Int
                                                                          (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                                            Int
                                                                            (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                                              Int
                                                                              (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                                Int
                                                                                instConditionallyCompleteLinearOrder)))))
                                                                      Int.instLocallyFiniteOrder (inputStart n)
                                                                      (@HAdd.hAdd.{0, 0, 0} Int Int Int
                                                                        (@instHAdd.{0} Int Int.instAdd) (inputStart n)
                                                                        (@Nat.cast.{0} Int instNatCastInt
                                                                          (inputCount n))))
                                                                    j →
                                                                  And
                                                                    (@LE.le.{0} Real Real.instLE left
                                                                      (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft
                                                                        (grid n) j))
                                                                    (And
                                                                      (@LE.le.{0} Real Real.instLE
                                                                        (NumStability.OneDimensionalFiniteVolumeGrid.cellRight
                                                                          (grid n) j)
                                                                        right)
                                                                      (And
                                                                        (@LE.le.{0} Real Real.instLE
                                                                          (NumStability.OneDimensionalFiniteVolumeGrid.cellVolume
                                                                            (grid n) j)
                                                                          (mesh n))
                                                                        (@LE.le.{0} Real Real.instLE (dt n)
                                                                          (@HMul.hMul.{0, 0, 0} Real Real Real
                                                                            (@instHMul.{0} Real Real.instMul) cfl
                                                                            (NumStability.OneDimensionalFiniteVolumeGrid.cellVolume
                                                                              (grid n) j)))))) →
                                                            (mesh_comparable :
                                                                ∀ (n : Nat) (j : Int),
                                                                  @Membership.mem.{0, 0} Int (Finset.{0} Int)
                                                                      (@SetLike.instMembership.{0, 0} (Finset.{0} Int)
                                                                        Int (@Finset.instSetLike.{0} Int))
                                                                      (@Finset.Ico.{0} Int
                                                                        (@PartialOrder.toPreorder.{0} Int
                                                                          (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0}
                                                                            Int
                                                                            (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                                              Int
                                                                              (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                                                Int
                                                                                (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                                  Int
                                                                                  instConditionallyCompleteLinearOrder)))))
                                                                        Int.instLocallyFiniteOrder (inputStart n)
                                                                        (@HAdd.hAdd.{0, 0, 0} Int Int Int
                                                                          (@instHAdd.{0} Int Int.instAdd) (inputStart n)
                                                                          (@Nat.cast.{0} Int instNatCastInt
                                                                            (inputCount n))))
                                                                      j →
                                                                    @LE.le.{0} Real Real.instLE (mesh n)
                                                                      (@HMul.hMul.{0, 0, 0} Real Real Real
                                                                        (@instHMul.{0} Real Real.instMul) meshRatio
                                                                        (NumStability.OneDimensionalFiniteVolumeGrid.cellVolume
                                                                          (grid n) j))) →
                                                              (numericalFlux :
                                                                  Nat → (Int → Fin m → Real) → Int → Fin m → Real) →
                                                                (admitted : Nat → (Int → Fin m → Real) → Prop) →
                                                                  (line_local :
                                                                      ∀ (n : Nat) (q other : Int → Fin m → Real),
                                                                        (∀ (j : Int),
                                                                            @Membership.mem.{0, 0} Int (Finset.{0} Int)
                                                                                (@SetLike.instMembership.{0, 0}
                                                                                  (Finset.{0} Int) Int
                                                                                  (@Finset.instSetLike.{0} Int))
                                                                                (@Finset.Ico.{0} Int
                                                                                  (@PartialOrder.toPreorder.{0} Int
                                                                                    (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0}
                                                                                      Int
                                                                                      (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                                                        Int
                                                                                        (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                                                          Int
                                                                                          (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                                            Int
                                                                                            instConditionallyCompleteLinearOrder)))))
                                                                                  Int.instLocallyFiniteOrder
                                                                                  (inputStart n)
                                                                                  (@HAdd.hAdd.{0, 0, 0} Int Int Int
                                                                                    (@instHAdd.{0} Int Int.instAdd)
                                                                                    (inputStart n)
                                                                                    (@Nat.cast.{0} Int instNatCastInt
                                                                                      (inputCount n))))
                                                                                j →
                                                                              @Eq.{1} (Fin m → Real) (q j) (other j)) →
                                                                          ∀ (j : Int),
                                                                            @Membership.mem.{0, 0} Int (Finset.{0} Int)
                                                                                (@SetLike.instMembership.{0, 0}
                                                                                  (Finset.{0} Int) Int
                                                                                  (@Finset.instSetLike.{0} Int))
                                                                                (@Finset.Icc.{0} Int
                                                                                  (@PartialOrder.toPreorder.{0} Int
                                                                                    (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0}
                                                                                      Int
                                                                                      (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                                                        Int
                                                                                        (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                                                          Int
                                                                                          (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                                            Int
                                                                                            instConditionallyCompleteLinearOrder)))))
                                                                                  Int.instLocallyFiniteOrder
                                                                                  (activeStart n)
                                                                                  (@HAdd.hAdd.{0, 0, 0} Int Int Int
                                                                                    (@instHAdd.{0} Int Int.instAdd)
                                                                                    (activeStart n)
                                                                                    (@Nat.cast.{0} Int instNatCastInt
                                                                                      (activeCount n))))
                                                                                j →
                                                                              @Eq.{1} (Fin m → Real)
                                                                                (numericalFlux n q j)
                                                                                (numericalFlux n other j)) →
                                                                    NumStability.DirectionalLine.LineFamily m
```

### D054: `NumStability.DirectionalLine.LineFamily.numericalFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `2690de6a2c4a981f8fee65753f932dad2b77d9e4b61a239dd6919bc0e3aae53d`

Type:

```lean
{m : Nat} → NumStability.DirectionalLine.LineFamily m → Nat → (Int → Fin m → Real) → Int → Fin m → Real
```

Fully explicit type:

```lean
{m : Nat} → (self : NumStability.DirectionalLine.LineFamily m) → Nat → (Int → Fin m → Real) → Int → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m self => self.33
```

### D055: `NumStability.FiniteCartesian.CartesianIdentification.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `d2f9c3d27cf4021723a7478628984ca77467b14aa4905c7f76cb12405bd5e633`

Type:

```lean
∀ {D : Type u_1} {Cell : Type u_2} {Face : Type u_3} {FacePoint : Type u_4} [inst : Fintype D] [inst_1 : DecidableEq D]
  [inst_2 : MeasurableSpace FacePoint] {m : Nat}
  {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face (D → Real) FacePoint m}
  {axes : D → NumStability.OneDimensionalFiniteVolumeGrid} {cellPosition : Cell → D → Int}
  {facePosition : D → Face → D → Int} {flux : D → (Fin m → Real) → Fin m → Real},
  (∀ (d : D) (cell : Cell), Eq (facePosition d (data.leftFace d cell)) (cellPosition cell)) →
    (∀ (d : D) (cell : Cell),
        Eq (facePosition d (data.rightFace d cell))
          (Function.update (cellPosition cell) d (instHAdd.hAdd (cellPosition cell d) 1))) →
      (∀ (cell : Cell),
          Eq (data.measure.restrict (data.cells.cellRegion cell))
            (MeasureTheory.MeasureSpace.pi.volume.restrict
              (NumStability.CartesianGrid.cellBox axes (cellPosition cell)))) →
        (∀ (d : D) (face : Face), AEMeasurable (data.facePoint d face) (data.faceMeasure d face)) →
          (∀ (d : D) (face : Face),
              Eq (MeasureTheory.Measure.map (data.facePoint d face) (data.faceMeasure d face))
                (MeasureTheory.Measure.map (NumStability.CartesianGrid.facePoint axes d (facePosition d face))
                  (MeasureTheory.MeasureSpace.pi.volume.restrict
                    (NumStability.CartesianGrid.tangentialFaceBox axes d (facePosition d face))))) →
            (∀ (d : D) (face : Face),
                Filter.Eventually
                  (fun point => ∀ (value : Fin m → Real), Eq (data.normalFlux d face point value) (flux d value))
                  (MeasureTheory.ae (data.faceMeasure d face))) →
              NumStability.FiniteCartesian.CartesianIdentification data axes cellPosition facePosition flux
```

Fully explicit type:

```lean
∀ {D : Type u_1} {Cell : Type u_2} {Face : Type u_3} {FacePoint : Type u_4} [inst : Fintype.{u_1} D]
  [inst_1 : DecidableEq.{u_1 + 1} D] [inst_2 : MeasurableSpace.{u_4} FacePoint] {m : Nat}
  {data :
    @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real) FacePoint
      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
        @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      inst_2 m}
  {axes : D → NumStability.OneDimensionalFiniteVolumeGrid} {cellPosition : Cell → D → Int}
  {facePosition : D → Face → D → Int} {flux : D → (Fin m → Real) → Fin m → Real}
  (left_position :
    ∀ (d : D) (cell : Cell),
      @Eq.{u_1 + 1} (D → Int)
        (facePosition d
          (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d cell))
        (cellPosition cell))
  (right_position :
    ∀ (d : D) (cell : Cell),
      @Eq.{u_1 + 1} (D → Int)
        (facePosition d
          (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d cell))
        (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst_1 (cellPosition cell) d
          (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (cellPosition cell d)
            (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))
  (cell_measure :
    ∀ (cell : Cell),
      @Eq.{u_1 + 1}
        (@MeasureTheory.Measure.{u_1} (D → Real)
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace))
        (@MeasureTheory.Measure.restrict.{u_1} (D → Real)
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@NumStability.FiniteCoordinate.PhysicalData.measure.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data)
          (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_1} Cell (D → Real)
            (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@NumStability.FiniteCoordinate.PhysicalData.cells.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
              FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                @UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              inst_2 m data)
            cell))
        (@MeasureTheory.Measure.restrict.{u_1} (D → Real)
          (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1} (D → Real)
            (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst (fun (a : D) => Real) fun (i : D) => Real.measureSpace))
          (@MeasureTheory.MeasureSpace.volume.{u_1} (D → Real)
            (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst (fun (a : D) => Real) fun (i : D) => Real.measureSpace))
          (@NumStability.CartesianGrid.cellBox.{u_1} D axes (cellPosition cell))))
  (face_measurable :
    ∀ (d : D) (face : Face),
      @AEMeasurable.{u_4, u_1} FacePoint (D → Real)
        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace) inst_2
        (@NumStability.FiniteCoordinate.PhysicalData.facePoint.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
          FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
            @UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          inst_2 m data d face)
        (@NumStability.FiniteCoordinate.PhysicalData.faceMeasure.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
          FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
            @UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          inst_2 m data d face))
  (face_measure :
    ∀ (d : D) (face : Face),
      @Eq.{u_1 + 1}
        (@MeasureTheory.Measure.{u_1} (D → Real)
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace))
        (@MeasureTheory.Measure.map.{u_4, u_1} FacePoint (D → Real) inst_2
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@NumStability.FiniteCoordinate.PhysicalData.facePoint.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d face)
          (@NumStability.FiniteCoordinate.PhysicalData.faceMeasure.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d face))
        (@MeasureTheory.Measure.map.{u_1, u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
          (D → Real)
          (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1}
            ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
            (@MeasureTheory.MeasureSpace.pi.{u_1, 0} (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d)
              (@Subtype.fintype.{u_1} D (fun (e : D) => @Ne.{u_1 + 1} D e d)
                (fun (a : D) => @instDecidableNot (@Eq.{u_1 + 1} D a d) (inst_1 a d)) inst)
              (fun (a : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real)
              fun (i : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real.measureSpace))
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@NumStability.CartesianGrid.facePoint.{u_1} D inst_1 axes d (facePosition d face))
          (@MeasureTheory.Measure.restrict.{u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
            (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1}
              ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
              (@MeasureTheory.MeasureSpace.pi.{u_1, 0} (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d)
                (@Subtype.fintype.{u_1} D (fun (e : D) => @Ne.{u_1 + 1} D e d)
                  (fun (a : D) => @instDecidableNot (@Eq.{u_1 + 1} D a d) (inst_1 a d)) inst)
                (fun (a : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real)
                fun (i : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real.measureSpace))
            (@MeasureTheory.MeasureSpace.volume.{u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
              (@MeasureTheory.MeasureSpace.pi.{u_1, 0} (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d)
                (@Subtype.fintype.{u_1} D (fun (e : D) => @Ne.{u_1 + 1} D e d)
                  (fun (a : D) => @instDecidableNot (@Eq.{u_1 + 1} D a d) (inst_1 a d)) inst)
                (fun (a : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real)
                fun (i : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real.measureSpace))
            (@NumStability.CartesianGrid.tangentialFaceBox.{u_1} D axes d (facePosition d face)))))
  (normal_flux :
    ∀ (d : D) (face : Face),
      @Filter.Eventually.{u_4} FacePoint
        (fun (point : FacePoint) =>
          ∀ (value : Fin m → Real),
            @Eq.{1} (Fin m → Real)
              (@NumStability.FiniteCoordinate.PhysicalData.normalFlux.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
                FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_2 m data d face point value)
              (flux d value))
        (@MeasureTheory.ae.{u_4, u_4} FacePoint (@MeasureTheory.Measure.{u_4} FacePoint inst_2)
          (@MeasureTheory.Measure.instFunLike.{u_4} FacePoint inst_2)
          (@MeasureTheory.Measure.instOuterMeasureClass.{u_4} FacePoint inst_2)
          (@NumStability.FiniteCoordinate.PhysicalData.faceMeasure.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d face))),
  @NumStability.FiniteCartesian.CartesianIdentification.{u_1, u_2, u_3, u_4} D Cell Face FacePoint inst inst_1 inst_2 m
    data axes cellPosition facePosition flux
```

### D056: `NumStability.FiniteCoordinate.LineCoordinates.extract.match_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `b3fc3b8f801d2c2eaa9e81c94334406b6931847d2a6b2dd3f8cfbd1044572832`

Type:

```lean
{Cell : Type u_1} →
  (motive : Option Cell → Sort u_2) →
    (x : Option Cell) → ((cell : Cell) → motive (Option.some cell)) → (Unit → motive Option.none) → motive x
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  (motive : Option.{u_1} Cell → Sort u_2) →
    (x : Option.{u_1} Cell) →
      (h_1 : (cell : Cell) → motive (@Option.some.{u_1} Cell cell)) →
        (h_2 : (a : Unit) → motive (@Option.none.{u_1} Cell)) → motive x
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} motive x h_1 h_2 => Option.casesOn x (h_2 Unit.unit) fun val => h_1 val
```

### D057: `NumStability.FiniteCoordinate.LineCoordinates.faceIndex`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `719b880c1b18168e4c1b36276ae306d87252869c239af41b455e4edb54b4bb87`

Type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Face → Int
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_7, u_8, u_9, u_10} m D Cell Face Line) →
            D → Face → Int
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.4
```

### D058: `NumStability.FiniteCoordinate.LineCoordinates.faceLine`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `df3ed7405ea614e84a6c7ed21a2d02ba09b85aa6f06a1fdb9f849f3cbeed9a9f`

Type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Face → Line
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_7, u_8, u_9, u_10} m D Cell Face Line) →
            D → Face → Line
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.3
```

### D059: `NumStability.FiniteCoordinate.LineCoordinates.ghost`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `5910cebbc232b8ce78b95623a3420e55e3eeb25d62dde46bed853fe5ba73726d`

Type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Line → Int → Fin m → Real
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_7, u_8, u_9, u_10} m D Cell Face Line) →
            D → Line → Int → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.8
```

### D060: `NumStability.FiniteCoordinate.LineCoordinates.lookup`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `2d27e01756cd29004bf5579bcac4466e182f6f419f3b47692f08550ce44cdd62`

Type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Line → Int → Option Cell
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_7, u_8, u_9, u_10} m D Cell Face Line) →
            D → Line → Int → Option.{u_8} Cell
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.5
```

### D061: `NumStability.FiniteCoordinate.LineCoordinates.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `eb7c42e6162ffab7820b649aaf9d0a403c57f6c917a0c0c5274578500b71e2e8`

Type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          (cellLine : D → Cell → Line) →
            (cellIndex : D → Cell → Int) →
              (D → Face → Line) →
                (D → Face → Int) →
                  (lookup : D → Line → Int → Option Cell) →
                    (∀ (d : D) (cell : Cell), Eq (lookup d (cellLine d cell) (cellIndex d cell)) (Option.some cell)) →
                      (∀ (d : D) (line : Line) (j : Int) (cell : Cell),
                          Eq (lookup d line j) (Option.some cell) →
                            And (Eq (cellLine d cell) line) (Eq (cellIndex d cell) j)) →
                        (D → Line → Int → Fin m → Real) → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_7} →
    {Cell : Type u_8} →
      {Face : Type u_9} →
        {Line : Type u_10} →
          (cellLine : D → Cell → Line) →
            (cellIndex : D → Cell → Int) →
              (faceLine : D → Face → Line) →
                (faceIndex : D → Face → Int) →
                  (lookup : D → Line → Int → Option.{u_8} Cell) →
                    (lookup_cell :
                        ∀ (d : D) (cell : Cell),
                          @Eq.{u_8 + 1} (Option.{u_8} Cell) (lookup d (cellLine d cell) (cellIndex d cell))
                            (@Option.some.{u_8} Cell cell)) →
                      (lookup_sound :
                          ∀ (d : D) (line : Line) (j : Int) (cell : Cell),
                            @Eq.{u_8 + 1} (Option.{u_8} Cell) (lookup d line j) (@Option.some.{u_8} Cell cell) →
                              And (@Eq.{u_10 + 1} Line (cellLine d cell) line) (@Eq.{1} Int (cellIndex d cell) j)) →
                        (ghost : D → Line → Int → Fin m → Real) →
                          @NumStability.FiniteCoordinate.LineCoordinates.{u_7, u_8, u_9, u_10} m D Cell Face Line
```

### D062: `NumStability.FiniteCoordinate.LineRealization.area`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e039577245d076d39c3820325c6cd61dd8557f06c992e2b9de4891eda96e9127`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          NumStability.FiniteCoordinate.LineRealization data coord family → D → Line → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (self :
                              @NumStability.FiniteCoordinate.LineRealization.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face
                                Point FacePoint Line inst inst_1 inst_2 m data coord family) →
                            D → Line → Real
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint Line [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m data
    coord family self =>
  self.4
```

### D063: `NumStability.FiniteCoordinate.LineRealization.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `ccce6d1a911b66cc929252ab8937f6d59d64ce42017656e1d5c85b3d0a757f4c`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (level : D → Line → Nat) →
                            (duration : D → Real) →
                              (∀ (d : D) (line : Line), Eq (duration d) ((family d line).dt (level d line))) →
                                (area : D → Line → Real) →
                                  (∀ (d : D) (line : Line), Real.instLT.lt 0 (area d line)) →
                                    (∀ (d : D) (cell : Cell),
                                        Eq (coord.faceLine d (data.leftFace d cell)) (coord.cellLine d cell)) →
                                      (∀ (d : D) (cell : Cell),
                                          Eq (coord.faceLine d (data.rightFace d cell)) (coord.cellLine d cell)) →
                                        (∀ (d : D) (cell : Cell),
                                            Eq (coord.faceIndex d (data.leftFace d cell)) (coord.cellIndex d cell)) →
                                          (∀ (d : D) (cell : Cell),
                                              Eq (coord.faceIndex d (data.rightFace d cell))
                                                (instHAdd.hAdd (coord.cellIndex d cell) 1)) →
                                            (∀ (d : D) (cell : Cell),
                                                SetLike.instMembership.mem
                                                  (Finset.Ico
                                                    ((family d (coord.cellLine d cell)).activeStart
                                                      (level d (coord.cellLine d cell)))
                                                    (instHAdd.hAdd
                                                      ((family d (coord.cellLine d cell)).activeStart
                                                        (level d (coord.cellLine d cell)))
                                                      ((family d (coord.cellLine d cell)).activeCount
                                                          (level d (coord.cellLine d cell))).cast))
                                                  (coord.cellIndex d cell)) →
                                              (∀ (d : D) (cell : Cell),
                                                  Eq (data.cellVolume cell)
                                                    (instHMul.hMul (area d (coord.cellLine d cell))
                                                      (((family d (coord.cellLine d cell)).grid
                                                            (level d (coord.cellLine d cell))).cellVolume
                                                        (coord.cellIndex d cell)))) →
                                                (∀ (d : D) (face : Face) (state : Fin m → Real),
                                                    And
                                                      (MeasureTheory.Integrable
                                                        (fun point => data.normalFlux d face point state)
                                                        (data.faceMeasure d face))
                                                      (Eq
                                                        (MeasureTheory.integral (data.faceMeasure d face) fun point =>
                                                          data.normalFlux d face point state)
                                                        (instHSMul.hSMul (area d (coord.faceLine d face))
                                                          ((family d (coord.faceLine d face)).flux
                                                            (((family d (coord.faceLine d face)).grid
                                                                  (level d (coord.faceLine d face))).cellLeft
                                                              (coord.faceIndex d face))
                                                            state)))) →
                                                  (∀ (d : D) (line : Line),
                                                      Eq (family d line).states (data.admissibleStates d)) →
                                                    NumStability.FiniteCoordinate.LineRealization data coord family
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        {family : D → Line → NumStability.DirectionalLine.LineFamily m} →
                          (level : D → Line → Nat) →
                            (duration : D → Real) →
                              (duration_eq :
                                  ∀ (d : D) (line : Line),
                                    @Eq.{1} Real (duration d)
                                      (@NumStability.DirectionalLine.LineFamily.dt m (family d line) (level d line))) →
                                (area : D → Line → Real) →
                                  (area_pos :
                                      ∀ (d : D) (line : Line),
                                        @LT.lt.{0} Real Real.instLT
                                          (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                                          (area d line)) →
                                    (left_line :
                                        ∀ (d : D) (cell : Cell),
                                          @Eq.{u_6 + 1} Line
                                            (@NumStability.FiniteCoordinate.LineCoordinates.faceLine.{u_1, u_2, u_3,
                                                  u_6}
                                              m D Cell Face Line coord d
                                              (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, u_2, u_3, u_4,
                                                    u_5}
                                                D Cell Face Point FacePoint inst inst_1 inst_2 m data d cell))
                                            (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3,
                                                  u_6}
                                              m D Cell Face Line coord d cell)) →
                                      (right_line :
                                          ∀ (d : D) (cell : Cell),
                                            @Eq.{u_6 + 1} Line
                                              (@NumStability.FiniteCoordinate.LineCoordinates.faceLine.{u_1, u_2, u_3,
                                                    u_6}
                                                m D Cell Face Line coord d
                                                (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, u_2, u_3,
                                                      u_4, u_5}
                                                  D Cell Face Point FacePoint inst inst_1 inst_2 m data d cell))
                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3,
                                                    u_6}
                                                m D Cell Face Line coord d cell)) →
                                        (left_index :
                                            ∀ (d : D) (cell : Cell),
                                              @Eq.{1} Int
                                                (@NumStability.FiniteCoordinate.LineCoordinates.faceIndex.{u_1, u_2,
                                                      u_3, u_6}
                                                  m D Cell Face Line coord d
                                                  (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, u_2, u_3,
                                                        u_4, u_5}
                                                    D Cell Face Point FacePoint inst inst_1 inst_2 m data d cell))
                                                (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_1, u_2,
                                                      u_3, u_6}
                                                  m D Cell Face Line coord d cell)) →
                                          (right_index :
                                              ∀ (d : D) (cell : Cell),
                                                @Eq.{1} Int
                                                  (@NumStability.FiniteCoordinate.LineCoordinates.faceIndex.{u_1, u_2,
                                                        u_3, u_6}
                                                    m D Cell Face Line coord d
                                                    (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, u_2,
                                                          u_3, u_4, u_5}
                                                      D Cell Face Point FacePoint inst inst_1 inst_2 m data d cell))
                                                  (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
                                                    (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_1, u_2,
                                                          u_3, u_6}
                                                      m D Cell Face Line coord d cell)
                                                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))) →
                                            (active_cell :
                                                ∀ (d : D) (cell : Cell),
                                                  @Membership.mem.{0, 0} Int (Finset.{0} Int)
                                                    (@SetLike.instMembership.{0, 0} (Finset.{0} Int) Int
                                                      (@Finset.instSetLike.{0} Int))
                                                    (@Finset.Ico.{0} Int
                                                      (@PartialOrder.toPreorder.{0} Int
                                                        (@ConditionallyCompletePartialOrderSup.toPartialOrder.{0} Int
                                                          (@ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup.{0}
                                                            Int
                                                            (@ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.{0}
                                                              Int
                                                              (@ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice.{0}
                                                                Int instConditionallyCompleteLinearOrder)))))
                                                      Int.instLocallyFiniteOrder
                                                      (@NumStability.DirectionalLine.LineFamily.activeStart m
                                                        (family d
                                                          (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                u_2, u_3, u_6}
                                                            m D Cell Face Line coord d cell))
                                                        (level d
                                                          (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                u_2, u_3, u_6}
                                                            m D Cell Face Line coord d cell)))
                                                      (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
                                                        (@NumStability.DirectionalLine.LineFamily.activeStart m
                                                          (family d
                                                            (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                  u_2, u_3, u_6}
                                                              m D Cell Face Line coord d cell))
                                                          (level d
                                                            (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                  u_2, u_3, u_6}
                                                              m D Cell Face Line coord d cell)))
                                                        (@Nat.cast.{0} Int instNatCastInt
                                                          (@NumStability.DirectionalLine.LineFamily.activeCount m
                                                            (family d
                                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                    u_2, u_3, u_6}
                                                                m D Cell Face Line coord d cell))
                                                            (level d
                                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                    u_2, u_3, u_6}
                                                                m D Cell Face Line coord d cell))))))
                                                    (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_1, u_2,
                                                          u_3, u_6}
                                                      m D Cell Face Line coord d cell)) →
                                              (volume_eq :
                                                  ∀ (d : D) (cell : Cell),
                                                    @Eq.{1} Real
                                                      (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, u_2,
                                                            u_3, u_4, u_5}
                                                        D Cell Face Point FacePoint inst inst_1 inst_2 m data cell)
                                                      (@HMul.hMul.{0, 0, 0} Real Real Real
                                                        (@instHMul.{0} Real Real.instMul)
                                                        (area d
                                                          (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                u_2, u_3, u_6}
                                                            m D Cell Face Line coord d cell))
                                                        (NumStability.OneDimensionalFiniteVolumeGrid.cellVolume
                                                          (@NumStability.DirectionalLine.LineFamily.grid m
                                                            (family d
                                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                    u_2, u_3, u_6}
                                                                m D Cell Face Line coord d cell))
                                                            (level d
                                                              (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1,
                                                                    u_2, u_3, u_6}
                                                                m D Cell Face Line coord d cell)))
                                                          (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_1,
                                                                u_2, u_3, u_6}
                                                            m D Cell Face Line coord d cell)))) →
                                                (physical_flux :
                                                    ∀ (d : D) (face : Face) (state : Fin m → Real),
                                                      And
                                                        (@MeasureTheory.Integrable.{0, u_5} (Fin m → Real)
                                                          (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                            fun (i : Fin m) =>
                                                            @UniformSpace.toTopologicalSpace.{0} Real
                                                              (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                Real.pseudoMetricSpace))
                                                          (@SeminormedAddGroup.toContinuousENorm.{0} (Fin m → Real)
                                                            (@Pi.seminormedAddGroup.{0, 0} (Fin m)
                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                              fun (i : Fin m) =>
                                                              @SeminormedAddCommGroup.toSeminormedAddGroup.{0} Real
                                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                  Real
                                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                    Real
                                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                      Real
                                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                        Real.normedCommRing))))))
                                                          FacePoint inst_2
                                                          (fun (point : FacePoint) =>
                                                            @NumStability.FiniteCoordinate.PhysicalData.normalFlux.{u_1,
                                                                  u_2, u_3, u_4, u_5}
                                                              D Cell Face Point FacePoint inst inst_1 inst_2 m data d
                                                              face point state)
                                                          (@NumStability.FiniteCoordinate.PhysicalData.faceMeasure.{u_1,
                                                                u_2, u_3, u_4, u_5}
                                                            D Cell Face Point FacePoint inst inst_1 inst_2 m data d
                                                            face))
                                                        (@Eq.{1} (Fin m → Real)
                                                          (@MeasureTheory.integral.{u_5, 0} FacePoint (Fin m → Real)
                                                            (@Pi.normedAddCommGroup.{0, 0} (Fin m)
                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                              fun (i : Fin m) => Real.normedAddCommGroup)
                                                            (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m)
                                                              (fun (a : Fin m) => Real) (Fin.fintype m)
                                                              (fun (i : Fin m) =>
                                                                @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                  Real
                                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                    Real
                                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                      Real
                                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                        Real.normedCommRing))))
                                                              fun (i : Fin m) =>
                                                              @InnerProductSpace.toNormedSpace.{0, 0} Real Real
                                                                Real.instRCLike
                                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0}
                                                                  Real
                                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0}
                                                                    Real
                                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0}
                                                                      Real
                                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                                        Real.normedCommRing))))
                                                                (@RCLike.toInnerProductSpaceReal.{0} Real
                                                                  Real.instRCLike))
                                                            inst_2
                                                            (@NumStability.FiniteCoordinate.PhysicalData.faceMeasure.{u_1,
                                                                  u_2, u_3, u_4, u_5}
                                                              D Cell Face Point FacePoint inst inst_1 inst_2 m data d
                                                              face)
                                                            fun (point : FacePoint) =>
                                                            @NumStability.FiniteCoordinate.PhysicalData.normalFlux.{u_1,
                                                                  u_2, u_3, u_4, u_5}
                                                              D Cell Face Point FacePoint inst inst_1 inst_2 m data d
                                                              face point state)
                                                          (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                                            (@instHSMul.{0, 0} Real (Fin m → Real)
                                                              (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                                                (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                                                  (@CommSemiring.toSemiring.{0} Real
                                                                    Real.instCommSemiring)
                                                                  (@Algebra.id.{0} Real Real.instCommSemiring))))
                                                            (area d
                                                              (@NumStability.FiniteCoordinate.LineCoordinates.faceLine.{u_1,
                                                                    u_2, u_3, u_6}
                                                                m D Cell Face Line coord d face))
                                                            (@NumStability.DirectionalLine.LineFamily.flux m
                                                              (family d
                                                                (@NumStability.FiniteCoordinate.LineCoordinates.faceLine.{u_1,
                                                                      u_2, u_3, u_6}
                                                                  m D Cell Face Line coord d face))
                                                              (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft
                                                                (@NumStability.DirectionalLine.LineFamily.grid m
                                                                  (family d
                                                                    (@NumStability.FiniteCoordinate.LineCoordinates.faceLine.{u_1,
                                                                          u_2, u_3, u_6}
                                                                      m D Cell Face Line coord d face))
                                                                  (level d
                                                                    (@NumStability.FiniteCoordinate.LineCoordinates.faceLine.{u_1,
                                                                          u_2, u_3, u_6}
                                                                      m D Cell Face Line coord d face)))
                                                                (@NumStability.FiniteCoordinate.LineCoordinates.faceIndex.{u_1,
                                                                      u_2, u_3, u_6}
                                                                  m D Cell Face Line coord d face))
                                                              state)))) →
                                                  (states_eq :
                                                      ∀ (d : D) (line : Line),
                                                        @Eq.{1} (Set.{0} (Fin m → Real))
                                                          (@NumStability.DirectionalLine.LineFamily.states m
                                                            (family d line))
                                                          (@NumStability.FiniteCoordinate.PhysicalData.admissibleStates.{u_1,
                                                                u_2, u_3, u_4, u_5}
                                                            D Cell Face Point FacePoint inst inst_1 inst_2 m data d)) →
                                                    @NumStability.FiniteCoordinate.LineRealization.{u_1, u_2, u_3, u_4,
                                                          u_5, u_6}
                                                      D Cell Face Point FacePoint Line inst inst_1 inst_2 m data coord
                                                      family
```

### D064: `NumStability.FiniteCoordinate.PhysicalData.admissibleStates`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `0c48dda27ed14c7015d2edc0b2f3ee757195ea317f236b4a384d7eef8e022399`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → D → Set (Fin m → Real)
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Set.{0} (Fin m → Real)
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.11
```

### D065: `NumStability.FiniteCoordinate.PhysicalData.cells`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `94036f4fe18549ad26ea64b90e1c90e52c45baa0cfa079c61b9e6ff1921bed2b`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    NumStability.FiniteVolumeCellPartition Cell Point
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    @NumStability.FiniteVolumeCellPartition.{u_2, u_4} Cell Point inst
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.1
```

### D066: `NumStability.FiniteCoordinate.PhysicalData.faceMeasure`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `7f0dd068d0d47bb896cf1df482df291793cf4c62c0e2ed633e437c696ad153d4`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → Face → MeasureTheory.Measure FacePoint
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Face → @MeasureTheory.Measure.{u_5} FacePoint inst_2
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.7
```

### D067: `NumStability.FiniteCoordinate.PhysicalData.facePoint`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6bfc8f55388278fc8fb34c1520d136a00ccc6ddc67865b67fc067888138be154`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → Face → FacePoint → Point
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Face → FacePoint → Point
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.8
```

### D068: `NumStability.FiniteCoordinate.PhysicalData.measure`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `967a8b8c99c6c7e20f030623e5538d7c0f600586623ab46aaddb3d63534c2e2f`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → MeasureTheory.Measure Point
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    @MeasureTheory.Measure.{u_4} Point inst
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.2
```

### D069: `NumStability.FiniteCoordinate.PhysicalData.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `d206a659634d6c81a56b36c9fef3bab8417e39cd53fb5e7202739a80c03c6765`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  (cells : NumStability.FiniteVolumeCellPartition Cell Point) →
                    (measure : MeasureTheory.Measure Point) →
                      (∀ (cell : Cell), Ne (MeasureTheory.Measure.instFunLike.coe measure (cells.cellRegion cell)) 0) →
                        (∀ (cell : Cell),
                            Ne (MeasureTheory.Measure.instFunLike.coe measure (cells.cellRegion cell))
                              instTopENNReal.top) →
                          (leftFace rightFace : D → Cell → Face) →
                            (faceMeasure : D → Face → MeasureTheory.Measure FacePoint) →
                              (facePoint : D → Face → FacePoint → Point) →
                                (∀ (d : D) (cell : Cell),
                                    Filter.Eventually
                                      (fun point =>
                                        Set.instMembership.mem (closure (cells.cellRegion cell))
                                          (facePoint d (leftFace d cell) point))
                                      (MeasureTheory.ae (faceMeasure d (leftFace d cell)))) →
                                  (∀ (d : D) (cell : Cell),
                                      Filter.Eventually
                                        (fun point =>
                                          Set.instMembership.mem (closure (cells.cellRegion cell))
                                            (facePoint d (rightFace d cell) point))
                                        (MeasureTheory.ae (faceMeasure d (rightFace d cell)))) →
                                    (admissibleStates : D → Set (Fin m → Real)) →
                                      (normalFlux : D → Face → FacePoint → (Fin m → Real) → Fin m → Real) →
                                        (∀ (d : D) (face : Face) (point : FacePoint),
                                            NumStability.IsHyperbolicFluxOn (normalFlux d face point)
                                              (admissibleStates d)) →
                                          NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (cells : @NumStability.FiniteVolumeCellPartition.{u_2, u_4} Cell Point inst) →
                    (measure : @MeasureTheory.Measure.{u_4} Point inst) →
                      (positive :
                          ∀ (cell : Cell),
                            @Ne.{1} ENNReal
                              (@DFunLike.coe.{u_4 + 1, u_4 + 1, 1} (@MeasureTheory.Measure.{u_4} Point inst)
                                (Set.{u_4} Point) (fun (x : Set.{u_4} Point) => ENNReal)
                                (@MeasureTheory.Measure.instFunLike.{u_4} Point inst) measure
                                (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_4} Cell Point inst cells
                                  cell))
                              (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal))) →
                        (finite :
                            ∀ (cell : Cell),
                              @Ne.{1} ENNReal
                                (@DFunLike.coe.{u_4 + 1, u_4 + 1, 1} (@MeasureTheory.Measure.{u_4} Point inst)
                                  (Set.{u_4} Point) (fun (x : Set.{u_4} Point) => ENNReal)
                                  (@MeasureTheory.Measure.instFunLike.{u_4} Point inst) measure
                                  (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_4} Cell Point inst cells
                                    cell))
                                (@Top.top.{0} ENNReal instTopENNReal)) →
                          (leftFace rightFace : D → Cell → Face) →
                            (faceMeasure : D → Face → @MeasureTheory.Measure.{u_5} FacePoint inst_2) →
                              (facePoint : D → Face → FacePoint → Point) →
                                (left_incidence :
                                    ∀ (d : D) (cell : Cell),
                                      @Filter.Eventually.{u_5} FacePoint
                                        (fun (point : FacePoint) =>
                                          @Membership.mem.{u_4, u_4} Point (Set.{u_4} Point)
                                            (@Set.instMembership.{u_4} Point)
                                            (@closure.{u_4} Point inst_1
                                              (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_4} Cell Point
                                                inst cells cell))
                                            (facePoint d (leftFace d cell) point))
                                        (@MeasureTheory.ae.{u_5, u_5} FacePoint
                                          (@MeasureTheory.Measure.{u_5} FacePoint inst_2)
                                          (@MeasureTheory.Measure.instFunLike.{u_5} FacePoint inst_2)
                                          (@MeasureTheory.Measure.instOuterMeasureClass.{u_5} FacePoint inst_2)
                                          (faceMeasure d (leftFace d cell)))) →
                                  (right_incidence :
                                      ∀ (d : D) (cell : Cell),
                                        @Filter.Eventually.{u_5} FacePoint
                                          (fun (point : FacePoint) =>
                                            @Membership.mem.{u_4, u_4} Point (Set.{u_4} Point)
                                              (@Set.instMembership.{u_4} Point)
                                              (@closure.{u_4} Point inst_1
                                                (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_4} Cell
                                                  Point inst cells cell))
                                              (facePoint d (rightFace d cell) point))
                                          (@MeasureTheory.ae.{u_5, u_5} FacePoint
                                            (@MeasureTheory.Measure.{u_5} FacePoint inst_2)
                                            (@MeasureTheory.Measure.instFunLike.{u_5} FacePoint inst_2)
                                            (@MeasureTheory.Measure.instOuterMeasureClass.{u_5} FacePoint inst_2)
                                            (faceMeasure d (rightFace d cell)))) →
                                    (admissibleStates : D → Set.{0} (Fin m → Real)) →
                                      (normalFlux : D → Face → FacePoint → (Fin m → Real) → Fin m → Real) →
                                        (hyperbolic :
                                            ∀ (d : D) (face : Face) (point : FacePoint),
                                              @NumStability.IsHyperbolicFluxOn m (normalFlux d face point)
                                                (admissibleStates d)) →
                                          @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell
                                            Face Point FacePoint inst inst_1 inst_2 m
```

### D070: `NumStability.FiniteCoordinate.PhysicalData.normalFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `b6886690342b2d280916b55714903f8d01ae83e9df5270b33a078c8d384bffa6`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → Face → FacePoint → (Fin m → Real) → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Face → FacePoint → (Fin m → Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.12
```

### D071: `NumStability.FiniteVolumeCellPartition.cellRegion`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `32dd6b17c69eb1ad645253a6f164e371ce8f60b4e07173cb0964fefc72bfff00`

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

### D072: `NumStability.FiniteVolumeCellPartition.domain`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `cb0a0118a712ffbf02f6fbd9b166402e15f1bf39f75b88baf56f9f032c269ce2`

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

### D073: `NumStability.LocalConservationLaw.SpatialRectangleReferenceOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `a7611c8b83f02ee5144aa3de3da43630fe9492907c3031764332adcd89eec9ab`

Type:

```lean
{m : Nat} → (Real → Real → Fin m → Real) → (Real → (Fin m → Real) → Fin m → Real) → Real → Real → Real → Prop
```

Fully explicit type:

```lean
{m : Nat} →
  (q : Real → Real → Fin m → Real) → (flux : Real → (Fin m → Real) → Fin m → Real) → (left right horizon : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} q flux left right horizon =>
  And
    (∀ (t : Real),
      Set.instMembership.mem (Set.Icc 0 horizon) t →
        IntervalIntegrable (fun x => q x t) Real.measureSpace.volume left right)
    (And
      (∀ (x : Real),
        Set.instMembership.mem (Set.Icc left right) x →
          IntervalIntegrable (fun t => flux x (q x t)) Real.measureSpace.volume 0 horizon)
      (∀ (a : Real),
        Set.instMembership.mem (Set.Icc left right) a →
          ∀ (b : Real),
            Set.instMembership.mem (Set.Icc left right) b →
              ∀ (s : Real),
                Set.instMembership.mem (Set.Icc 0 horizon) s →
                  ∀ (t : Real),
                    Set.instMembership.mem (Set.Icc 0 horizon) t →
                      Eq
                        (instHSub.hSub (intervalIntegral (fun x => q x t) a b Real.measureSpace.volume)
                          (intervalIntegral (fun x => q x s) a b Real.measureSpace.volume))
                        (intervalIntegral (fun τ => instHSub.hSub (flux a (q a τ)) (flux b (q b τ))) s t
                          Real.measureSpace.volume)))
```

### D074: `NumStability.OneDimensionalFiniteVolumeGrid.cellRight`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e793c9aec7a283c6d560c9430d496d51051f9329f075b5c3daabfb5ebdc1e5fb`

Type:

```lean
NumStability.OneDimensionalFiniteVolumeGrid → Int → Real
```

Fully explicit type:

```lean
(self : NumStability.OneDimensionalFiniteVolumeGrid) → Int → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.2
```

### D075: `NumStability.OneDimensionalFiniteVolumeGrid.cellVolume`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1b11f8006577d74cfa9d8b4175b4078ee6606a698c5053cb84064b8c194a49d3`

Type:

```lean
NumStability.OneDimensionalFiniteVolumeGrid → Int → Real
```

Fully explicit type:

```lean
(grid : NumStability.OneDimensionalFiniteVolumeGrid) → (i : Int) → Real
```

Definition body (one-level semantic boundary):

```lean
fun grid i => instHSub.hSub (grid.cellRight i) (grid.cellLeft i)
```

### D076: `NumStability.OneDimensionalFiniteVolumeGrid.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `a5756070c766460340964fdc56e62557e58afc0dc8fd8cce2029d5d3262db199`

Type:

```lean
(cellLeft cellRight : Int → Real) →
  (∀ (i : Int), Real.instLT.lt (cellLeft i) (cellRight i)) →
    (∀ (i : Int), Eq (cellRight (instHSub.hSub i 1)) (cellLeft i)) → NumStability.OneDimensionalFiniteVolumeGrid
```

Fully explicit type:

```lean
(cellLeft cellRight : Int → Real) →
  (cell_nonempty : ∀ (i : Int), @LT.lt.{0} Real Real.instLT (cellLeft i) (cellRight i)) →
    (adjacent :
        ∀ (i : Int),
          @Eq.{1} Real
            (cellRight
              (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
            (cellLeft i)) →
      NumStability.OneDimensionalFiniteVolumeGrid
```

### D077: `NumStability.SequentialError.execution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.Normed.Group.SequentialError`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `dffe0d7bfc398c78596e06554cd6b0cd8214af1ab1c1c9241325b9339d392364`

Type:

```lean
{Cell : Type u_1} → {E : Type u_2} → (Nat → (Cell → E) → Cell → E) → (Cell → E) → Nat → Cell → E
```

Fully explicit type:

```lean
{Cell : Type u_1} → {E : Type u_2} → (step : Nat → (Cell → E) → Cell → E) → (initial : Cell → E) → Nat → Cell → E
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} {E} step initial x =>
  Nat.brecOn (motive := fun x => Cell → E) x fun x f =>
    NumStability.SequentialError.execution.match_1 (fun x => Nat.below (motive := fun x => Cell → E) x → Cell → E) x
      (fun _ x => initial) (fun n x => step n x.1) f
```

### D078: `NumStability.SequentialError.execution.match_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.Normed.Group.SequentialError`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `1002990472a6f1d27abf945ffc4f52229f9865c87ec1dbdd4fab6f4862ae127c`

Type:

```lean
(motive : Nat → Sort u_1) → (x : Nat) → (Unit → motive 0) → ((n : Nat) → motive n.succ) → motive x
```

Fully explicit type:

```lean
(motive : Nat → Sort u_1) →
  (x : Nat) →
    (h_1 : (a : Unit) → motive (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))) →
      (h_2 : (n : Nat) → motive (Nat.succ n)) → motive x
```

Definition body (one-level semantic boundary):

```lean
fun motive x h_1 h_2 => Nat.casesOn x (h_1 Unit.unit) fun n => h_2 n
```

### D079: `NumStability.finiteVolumeCellAverageUpdate`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `2c211fbf68ab80aa19f6cbb49d99879941ac27a6722aa66c55bbad97b5f33d56`

Type:

```lean
{E : Type u_1} → [inst : AddCommGroup E] → [Module Real E] → Real → Real → E → E → E
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : AddCommGroup.{u_1} E] →
    [@Module.{0, u_1} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_1} E inst)] →
      (timeStep cellVolume : Real) → (oldAverage netOutwardFlux : E) → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [AddCommGroup E] [Module Real E] timeStep cellVolume oldAverage netOutwardFlux =>
  instHSub.hSub oldAverage (instHSMul.hSMul (instHDiv.hDiv timeStep cellVolume) netOutwardFlux)
```

### D080: `NumStability.riemannFiniteVolumeUpdate`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5f0ca989def21ed8e967fb586b47106a111ff6c121a5cdc0b0e980f00a72171b`

Type:

```lean
{Component : Type u_1} →
  NumStability.OneDimensionalFiniteVolumeGrid →
    Real → (Int → Component → Real) → (Int → Component → Real) → Int → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  (grid : NumStability.OneDimensionalFiniteVolumeGrid) →
    (timeStep : Real) → (cellAverages edgeFlux : Int → Component → Real) → (i : Int) → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun {Component} grid timeStep cellAverages edgeFlux i =>
  instHSub.hSub (cellAverages i)
    (instHSMul.hSMul (instHDiv.hDiv timeStep (grid.cellVolume i))
      (instHSub.hSub (edgeFlux (instHAdd.hAdd i 1)) (edgeFlux i)))
```

### D081: `NumStability.CartesianGrid.facePoint`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4c747f89f36977c53c80c7f670f81c119ebec661ebcbd97dfc64a43027269df9`

Type:

```lean
{D : Type u_1} →
  [DecidableEq D] →
    (D → NumStability.OneDimensionalFiniteVolumeGrid) →
      (d : D) → (D → Int) → ((Subtype fun e => Ne e d) → Real) → D → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  [DecidableEq.{u_1 + 1} D] →
    (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) →
      (d : D) → (cell : D → Int) → (point : (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real) → D → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [DecidableEq D] axes d cell point e => if h : Eq e d then (axes d).cellLeft (cell d) else point ⟨e, h⟩
```

### D082: `NumStability.CartesianGrid.tangentialFaceBox`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `34633c4e8e7cd18c85f69e619e5085227df05ab49501e6441e3deffb29265b81`

Type:

```lean
{D : Type u_1} →
  (D → NumStability.OneDimensionalFiniteVolumeGrid) → (d : D) → (D → Int) → Set ((Subtype fun e => Ne e d) → Real)
```

Fully explicit type:

```lean
{D : Type u_1} →
  (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) →
    (d : D) → (cell : D → Int) → Set.{u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
```

Definition body (one-level semantic boundary):

```lean
fun {D} axes d cell =>
  Set.univ.pi fun e => Set.Ico ((axes e.val).cellLeft (cell e.val)) ((axes e.val).cellRight (cell e.val))
```

### D083: `NumStability.DirectionalLine.windowVariation`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `452ffc50e9d41e11ab83242c364550a7e31c07be285d7bd9a679422774038a05`

Type:

```lean
{m : Nat} → Int → Nat → (Int → Fin m → Real) → Real
```

Fully explicit type:

```lean
{m : Nat} → (start : Int) → (count : Nat) → (values : Int → Fin m → Real) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {m} start count values =>
  (Finset.range count).sum fun k =>
    Pi.normedRing.norm
      (instHSub.hSub (values (instHAdd.hAdd (instHAdd.hAdd start k.cast) 1)) (values (instHAdd.hAdd start k.cast)))
```

### D084: `NumStability.FiniteVolumeCellPartition`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `643d6beb37c358dd676e40a0ed44bb8a1161a339bf1a86fade7e9a749db8accc`

Type:

```lean
Type u_1 → (Point : Type u_2) → [MeasurableSpace Point] → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Cell : Type u_1) → (Point : Type u_2) → [MeasurableSpace.{u_2} Point] → Type (max u_1 u_2)
```

### D085: `NumStability.IsHyperbolicFluxOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `94bad8b852444c4d21cfba9a629ee1e790e006684d925ba21373a3f9b6d00a01`

Type:

```lean
{m : Nat} → ((Fin m → Real) → Fin m → Real) → Set (Fin m → Real) → Prop
```

Fully explicit type:

```lean
{m : Nat} → (flux : (Fin m → Real) → Fin m → Real) → (states : Set.{0} (Fin m → Real)) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} flux states =>
  ∀ (state : Fin m → Real), Set.instMembership.mem states state → NumStability.IsHyperbolicFluxAt flux state
```

### D086: `NumStability.FiniteVolumeCellPartition.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `739bab2b22ae879c4f9ff0943c6641c3a50b089aa099d9b3ca55f7e3dbb2945b`

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

### D087: `NumStability.IsHyperbolicFluxAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f3c7e9b05681e761c2bdf245f341cbda0480762d7a41c10863afad36b06495ac`

Type:

```lean
{m : Nat} → ((Fin m → Real) → Fin m → Real) → (Fin m → Real) → Prop
```

Fully explicit type:

```lean
{m : Nat} → (flux : (Fin m → Real) → Fin m → Real) → (state : Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} flux state =>
  Exists fun derivative =>
    And (HasFDerivAt flux derivative state)
      (NumStability.IsRealHyperbolicMatrix (EquivLike.toFunLike.coe LinearMap.toMatrix' derivative.toLinearMap))
```

### D088: `NumStability.IsHyperbolicFluxAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `theorem`
- Distance from target type: `5`
- Semantic SHA-256: `56914ea600c008889cf7a321fb9725518cbcfbc35c6f46b7b5ae2efa1e8016a6`

Type:

```lean
RingHomInvPair (RingHom.id Real) (RingHom.id Real)
```

Fully explicit type:

```lean
@RingHomInvPair.{0, 0} Real Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
  (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
  (@RingHom.id.{0} Real
    (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
  (@RingHom.id.{0} Real
    (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
```

### D089: `NumStability.IsHyperbolicFluxAt._proof_2`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `theorem`
- Distance from target type: `5`
- Semantic SHA-256: `45d3d1103b49ff0e7e5c94c9e228d5836e8f391818c033dff1ce8e9b522d12e0`

Type:

```lean
∀ {m : Nat}, SMulCommClass Real Real (Fin m → Real)
```

Fully explicit type:

```lean
∀ {m : Nat},
  @SMulCommClass.{0, 0, 0} Real Real (Fin m → Real)
    (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
      (@SemigroupAction.toSMul.{0, 0} Real Real
        (@Monoid.toSemigroup.{0} Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring))))
        (@MulAction.toSemigroupAction.{0, 0} Real Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
          (@DistribMulAction.toMulAction.{0, 0} Real Real
            (@MonoidWithZero.toMonoid.{0} Real
              (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
            (@AddCommMonoid.toAddMonoid.{0} Real
              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                  (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))
            (@Module.toDistribMulAction.{0, 0} Real Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                  (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring))))
              (@Semiring.toModule.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))))
    (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
      (@SemigroupAction.toSMul.{0, 0} Real Real
        (@Monoid.toSemigroup.{0} Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring))))
        (@MulAction.toSemigroupAction.{0, 0} Real Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
          (@DistribMulAction.toMulAction.{0, 0} Real Real
            (@MonoidWithZero.toMonoid.{0} Real
              (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
            (@AddCommMonoid.toAddMonoid.{0} Real
              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                  (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))
            (@Module.toDistribMulAction.{0, 0} Real Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                  (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring))))
              (@Semiring.toModule.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))))
```

### D090: `NumStability.IsRealHyperbolicMatrix`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `d47cd84c44b0c456ec06f4b48845c39c02daf4bc4240508afd66168e57eb795c`

Type:

```lean
{ι : Type u_1} → [Fintype ι] → Matrix ι ι Real → Prop
```

Fully explicit type:

```lean
{ι : Type u_1} → [Fintype.{u_1} ι] → (coefficient : Matrix.{u_1, u_1, 0} ι ι Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] coefficient =>
  Exists fun eigenvalues =>
    Exists fun eigenbasis =>
      ∀ (p : ι),
        Eq (coefficient.mulVec (Module.Basis.instFunLike.coe eigenbasis p))
          (instHSMul.hSMul (eigenvalues p) (Module.Basis.instFunLike.coe eigenbasis p))
```

### D091: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5305322be4a562f24a6e568a2b0f4a4e3d7cf5ae9a842e07f0c4058c86e0fc14`

Type:

```lean
(R : Type u) → [inst : CommSemiring R] → Algebra R R
```

Fully explicit type:

```lean
(R : Type u) → [inst : CommSemiring.{u} R] → @Algebra.{u, u} R R inst (@CommSemiring.toSemiring.{u} R inst)
```

Definition body (one-level semantic boundary):

```lean
fun R [CommSemiring R] =>
  let __spread.0 :=
    (have __src := RingHom.id R;
      { toFun := fun x => x, map_one' := ⋯, map_mul' := ⋯, map_zero' := ⋯, map_add' := ⋯ }).toAlgebra;
  let __SMul := instSMulOfMul;
  { toSMul := __SMul, algebraMap := __spread.0.algebraMap, commutes' := ⋯, smul_def' := ⋯ }
```

### D092: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7ed84d651a0f6a77f78d6fd14524fe110f2045971d1f824f15cc8f5b8071484f`

Type:

```lean
{R : Type u} → {A : Type v} → {inst : CommSemiring R} → {inst_1 : Semiring A} → [self : Algebra R A] → SMul R A
```

Fully explicit type:

```lean
{R : Type u} →
  {A : Type v} →
    {inst : CommSemiring.{u} R} → {inst_1 : Semiring.{v} A} → [self : @Algebra.{u, v} R A inst inst_1] → SMul.{u, v} R A
```

Definition body (one-level semantic boundary):

```lean
fun R A {inst} {inst_1} [self : Algebra R A] => self.1
```

### D093: `And`

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

### D094: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bcda2e78d6b7602d359ab954baf5c3bd0f6b2503b3ec9a72e1a21a48b9d18d89`

Type:

```lean
{R : Type u} → [self : CommSemiring R] → Semiring R
```

Fully explicit type:

```lean
{R : Type u} → [self : CommSemiring.{u} R] → Semiring.{u} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : CommSemiring R] => self.1
```

### D095: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `41576e47c21e72ff272622fb2a65e2858beda94a321ffdbc1128f58d338ee803`

Type:

```lean
{α : Type u_1} → [ConditionallyCompleteLattice α] → ConditionallyCompletePartialOrder α
```

Fully explicit type:

```lean
{α : Type u_1} → [ConditionallyCompleteLattice.{u_1} α] → ConditionallyCompletePartialOrder.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : ConditionallyCompleteLattice α] =>
  { toPartialOrder := inst.toSemilatticeInf.toPartialOrder, toSupSet := inst.toSupSet, isLUB_csSup_of_directed := ⋯,
    toInfSet := inst.toInfSet, isGLB_csInf_of_directed := ⋯ }
```

### D096: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e1dad077d30ec2d5da19d9c26f0e709993b8eda004ce89d1f4086cf5f98094d5`

Type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrder α] → ConditionallyCompleteLattice α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrder.{u_5} α] → ConditionallyCompleteLattice.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompleteLinearOrder α] => self.1
```

### D097: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderSup`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0a6600990c410e212f88c8bab1f49a4e87b20d0f1746cac2db2ef05eef506e9a`

Type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrder α] → ConditionallyCompletePartialOrderSup α
```

Fully explicit type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrder.{u_3} α] → ConditionallyCompletePartialOrderSup.{u_3} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompletePartialOrder α] => self.1
```

### D098: `ConditionallyCompletePartialOrderSup.toPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bfa7581b4b5850e23e0b1b8bb631326fd267df3d15a38c0776f4472d9c8c7d1d`

Type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrderSup α] → PartialOrder α
```

Fully explicit type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrderSup.{u_3} α] → PartialOrder.{u_3} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompletePartialOrderSup α] => self.1
```

### D099: `DecidableEq`

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

### D100: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Fully explicit type:

```lean
{G : Type u} → [self : DivInvMonoid.{u} G] → Div.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D101: `Eq`

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

### D102: `Exists`

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

### D103: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

Fully explicit type:

```lean
(n : Nat) → Type
```

### D104: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Type:

```lean
(n : Nat) → Fintype (Fin n)
```

Fully explicit type:

```lean
(n : Nat) → Fintype.{0} (Fin n)
```

Definition body (one-level semantic boundary):

```lean
fun n => { elems := { val := Multiset.ofList (List.finRange n), nodup := ⋯ }, complete := ⋯ }
```

### D105: `Finset`

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

### D106: `Finset.Ico`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `256e28d69fc14d1c084345d68cbe49ed3d7c9201ffebf16a70893f13dcafaf29`

Type:

```lean
{α : Type u_1} → [inst : Preorder α] → [LocallyFiniteOrder α] → α → α → Finset α
```

Fully explicit type:

```lean
{α : Type u_1} → [inst : Preorder.{u_1} α] → [@LocallyFiniteOrder.{u_1} α inst] → (a b : α) → Finset.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Preorder α] [inst_1 : LocallyFiniteOrder α] a b => inst_1.finsetIco a b
```

### D107: `Finset.instSetLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D108: `Finset.sum`

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

### D109: `Finset.univ`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D110: `Fintype`

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

### D111: `Fintype.card`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Card`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d671060b6c3404522971da5a02da4d36f016d436f12fae1266ef0720d68247cd`

Type:

```lean
(α : Type u_4) → [Fintype α] → Nat
```

Fully explicit type:

```lean
(α : Type u_4) → [Fintype.{u_4} α] → Nat
```

Definition body (one-level semantic boundary):

```lean
fun α [Fintype α] => Finset.univ.card
```

### D112: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0cc1e812ed29ffd61aa88cc157fd57b24a4728a006314eec34a80ac32a5f63`

Type:

```lean
{ι : Type u_1} → {M : Type u_2} → {α : Type u_7} → [SMul M α] → SMul M (ι → α)
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : Type u_2} → {α : Type u_7} → [SMul.{u_2, u_7} M α] → SMul.{u_2, max u_1 u_7} M (ι → α)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} {α} [SMul M α] => Pi.instSMul
```

### D113: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HAdd.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D114: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HDiv.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D115: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4e00447a4a8ef4c2ce13e307c56a1fbcd7fa8c732fe039a452b42477a50df2c6`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HMul α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HMul.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HMul α β γ] => self.1
```

### D116: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6196b8cbb884c4f39841ba74b23d75f3c753fe0d044cc402bd6e4e3bd59d5cb8`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HPow α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HPow.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HPow α β γ] => self.1
```

### D117: `HSMul.hSMul`

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

### D118: `HSub.hSub`

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

### D119: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `683435a8d27d50ec1482d74d23f541d52d05ff0411c60f88d16c32132aca9f3e`

Type:

```lean
{𝕜 : Type u_4} →
  {E : Type u_5} →
    {inst : RCLike 𝕜} → {inst_1 : SeminormedAddCommGroup E} → [self : InnerProductSpace 𝕜 E] → NormedSpace 𝕜 E
```

Fully explicit type:

```lean
{𝕜 : Type u_4} →
  {E : Type u_5} →
    {inst : RCLike.{u_4} 𝕜} →
      {inst_1 : SeminormedAddCommGroup.{u_5} E} →
        [self : @InnerProductSpace.{u_4, u_5} 𝕜 E inst inst_1] →
          @NormedSpace.{u_4, u_5} 𝕜 E
            (@DenselyNormedField.toNormedField.{u_4} 𝕜 (@RCLike.toDenselyNormedField.{u_4} 𝕜 inst)) inst_1
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : InnerProductSpace 𝕜 E] => self.1
```

### D120: `Int`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `257bf50f640447b541733c8fd9c6bcca584fc9dd85c221eb4f37888655c88e08`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D121: `Int.instAdd`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f3fe827ffb6fc81658773a6ada6451aeb9c1a54d32b216d8dede8eae9142825b`

Type:

```lean
Add Int
```

Fully explicit type:

```lean
Add.{0} Int
```

Definition body (one-level semantic boundary):

```lean
{ add := Int.add }
```

### D122: `Int.instLocallyFiniteOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Int.Interval`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4a1c3108e7b2d23ddef3d893b082c76c30eb0cdd7f59adf28416d0c67238b53d`

Type:

```lean
LocallyFiniteOrder Int
```

Fully explicit type:

```lean
@LocallyFiniteOrder.{0} Int
  (@PartialOrder.toPreorder.{0} Int
    (@SemilatticeInf.toPartialOrder.{0} Int (@Lattice.toSemilatticeInf.{0} Int instLatticeInt)))
```

Definition body (one-level semantic boundary):

```lean
{
  finsetIcc := fun a b =>
    Finset.map (Nat.castEmbedding.trans (addLeftEmbedding a))
      (Finset.range (instHSub.hSub (instHAdd.hAdd b 1) a).toNat),
  finsetIco := fun a b =>
    Finset.map (Nat.castEmbedding.trans (addLeftEmbedding a)) (Finset.range (instHSub.hSub b a).toNat),
  finsetIoc := fun a b =>
    Finset.map (Nat.castEmbedding.trans (addLeftEmbedding (instHAdd.hAdd a 1)))
      (Finset.range (instHSub.hSub b a).toNat),
  finsetIoo := fun a b =>
    Finset.map (Nat.castEmbedding.trans (addLeftEmbedding (instHAdd.hAdd a 1)))
      (Finset.range (instHSub.hSub (instHSub.hSub b a) 1).toNat),
  finset_mem_Icc := ⋯, finset_mem_Ico := ⋯, finset_mem_Ioc := ⋯, finset_mem_Ioo := ⋯ }
```

### D123: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `54a32f2661f788eb2b860006c4d1e8031e126febafe1c8d03ce50529b773dc48`

Type:

```lean
{α : Type u} → [self : LE α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u} → [self : LE.{u} α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LE α] => self.1
```

### D124: `LT.lt`

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

### D125: `List.map`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `509306b13208ac7c4830c43f93dc873d045ae0ae6b1984beea3ee3ecf89cb205`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → (α → β) → List α → List β
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → (f : α → β) → (l : List.{u_1} α) → List.{u_2} β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f x =>
  List.brecOn x fun x f_1 =>
    instDecidableEqList.match_1 (fun x => List.below x → List β) x (fun _ x => List.nil)
      (fun a as x => List.cons (f a) x.1) f_1
```

### D126: `List.range`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `18d1b115003fcdf01cbb5adfb076945d24a2a8edcbc8804f6e5f9f4f4b7a6375`

Type:

```lean
Nat → List Nat
```

Fully explicit type:

```lean
(n : Nat) → List.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
fun n => List.range.loop n List.nil
```

### D127: `MeasurableSpace`

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

### D128: `MeasurableSpace.pi`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5abd6255cb5a248caaba9dbb79fda4690e04ec72945aca88c3e0fba53f12972b`

Type:

```lean
{δ : Type u_4} → {X : δ → Type u_6} → [m : (a : δ) → MeasurableSpace (X a)] → MeasurableSpace ((a : δ) → X a)
```

Fully explicit type:

```lean
{δ : Type u_4} →
  {X : δ → Type u_6} → [m : (a : δ) → MeasurableSpace.{u_6} (X a)] → MeasurableSpace.{max u_4 u_6} ((a : δ) → X a)
```

Definition body (one-level semantic boundary):

```lean
fun {δ} {X} [m : (a : δ) → MeasurableSpace (X a)] => iSup fun a => MeasurableSpace.comap (fun b => b a) (m a)
```

### D129: `MeasureTheory.MeasureSpace.pi`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b44ca2107139ebd9cd90a857fbd25dbe0be4e82716a918fd216df60edd75bf62`

Type:

```lean
{ι : Type u_1} →
  [Fintype ι] →
    {α : ι → Type u_4} → [(i : ι) → MeasureTheory.MeasureSpace (α i)] → MeasureTheory.MeasureSpace ((i : ι) → α i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  [Fintype.{u_1} ι] →
    {α : ι → Type u_4} →
      [(i : ι) → MeasureTheory.MeasureSpace.{u_4} (α i)] → MeasureTheory.MeasureSpace.{max u_1 u_4} ((i : ι) → α i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] {α} [inst_1 : (i : ι) → MeasureTheory.MeasureSpace (α i)] =>
  { toMeasurableSpace := MeasurableSpace.pi, volume := MeasureTheory.Measure.pi fun x => (inst_1 x).volume }
```

### D130: `MeasureTheory.MeasureSpace.toMeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9fcb81af41d67aceded7670716064bc53819a6094bbccd3cb85d7a18952295d3`

Type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace α] → MeasurableSpace α
```

Fully explicit type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace.{u_6} α] → MeasurableSpace.{u_6} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : MeasureTheory.MeasureSpace α] => self.1
```

### D131: `MeasureTheory.MeasureSpace.volume`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8aa44f6be6ed612f15d809220aa22d43c0715b7383456cd968b96336c71bcb65`

Type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace α] → MeasureTheory.Measure α
```

Fully explicit type:

```lean
{α : Type u_6} →
  [self : MeasureTheory.MeasureSpace.{u_6} α] →
    @MeasureTheory.Measure.{u_6} α (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_6} α self)
```

Definition body (one-level semantic boundary):

```lean
fun α [self : MeasureTheory.MeasureSpace α] => self.2
```

### D132: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D133: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D134: `Nat.cast`

- Role: `external-frontier`
- Owner module: `Init.Data.Cast`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `6e24327ea908b1837083bb15aef27d593e950a2ff8ade81d8aa94bfe33b64450`

Type:

```lean
{R : Type u} → [NatCast R] → Nat → R
```

Fully explicit type:

```lean
{R : Type u} → [NatCast.{u} R] → Nat → R
```

Definition body (one-level semantic boundary):

```lean
fun {R} [inst : NatCast R] => inst.natCast
```

### D135: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing α] → NonUnitalSeminormedRing α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing.{u_5} α] → NonUnitalSeminormedRing.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSeminormedCommRing α] => self.1
```

### D136: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Type:

```lean
{α : Type u_2} → [NonUnitalSeminormedRing α] → SeminormedAddCommGroup α
```

Fully explicit type:

```lean
{α : Type u_2} → [NonUnitalSeminormedRing.{u_2} α] → SeminormedAddCommGroup.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : NonUnitalSeminormedRing α] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D137: `Norm.norm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `25f5aa97df9bb1faeacd7e5e6446ecbd367452a7105f098063355423713fe15a`

Type:

```lean
{E : Type u_8} → [self : Norm E] → E → Real
```

Fully explicit type:

```lean
{E : Type u_8} → [self : Norm.{u_8} E] → E → Real
```

Definition body (one-level semantic boundary):

```lean
fun E [self : Norm E] => self.1
```

### D138: `NormedCommRing.toNormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ff5852fa6ac00f6a258a1d8fe950a0ed74f219c79c926896eb081436331a480e`

Type:

```lean
{α : Type u_5} → [self : NormedCommRing α] → NormedRing α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NormedCommRing.{u_5} α] → NormedRing.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedCommRing α] => self.1
```

### D139: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → SeminormedCommRing α
```

Fully explicit type:

```lean
{α : Type u_2} → [β : NormedCommRing.{u_2} α] → SeminormedCommRing.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toRing := β.toRing, toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯,
    norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D140: `NormedRing.toNorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0957abfc66401a60ac36872f31eb54890d14b0b45613e38ba8f235c467f63751`

Type:

```lean
{α : Type u_5} → [self : NormedRing α] → Norm α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NormedRing.{u_5} α] → Norm.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedRing α] => self.1
```

### D141: `OfNat.ofNat`

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

### D142: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cc544b5b2a2aabc84389a9fe2f052127dc6dae9964782b117b9b19b773e542d5`

Type:

```lean
{α : Type u_1} → [One α] → OfNat α 1
```

Fully explicit type:

```lean
{α : Type u_1} → [One.{u_1} α] → OfNat.{u_1} α (nat_lit 1)
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : One α] => { ofNat := inst.one }
```

### D143: `PartialOrder.toPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `079686fa1ec6d596bcdb475c56a12b7f5a0594bf346c64220c2c992e0f0aae3b`

Type:

```lean
{α : Type u_2} → [self : PartialOrder α] → Preorder α
```

Fully explicit type:

```lean
{α : Type u_2} → [self : PartialOrder.{u_2} α] → Preorder.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PartialOrder α] => self.1
```

### D144: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9b57724ac626ed82a5e3b9060068391fe112af839994c2304c9990493e8e9fbc`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommMonoid (f i)] → AddCommMonoid ((i : I) → f i)
```

Fully explicit type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommMonoid.{v₁} (f i)] → AddCommMonoid.{max u v₁} ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommMonoid (f i)] =>
  let __src := Pi.addMonoid;
  have __src_1 := Pi.addCommSemigroup;
  { toAddMonoid := __src, add_comm := ⋯ }
```

### D145: `Pi.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5deaec32b4deac749a5db5453affea1938386e569380df7daeec26aee3cfd7c2`

Type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [(i : ι) → Sub (G i)] → Sub ((i : ι) → G i)
```

Fully explicit type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [(i : ι) → Sub.{u_4} (G i)] → Sub.{max u_1 u_4} ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [(i : ι) → Sub (G i)] => { sub := fun f g i => instHSub.hSub (f i) (g i) }
```

### D146: `Pi.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `6c82ababc565a0a95c28bec085e8f86c2438699bb486e0ae0b52b3836c28e80e`

Type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} → [Fintype ι] → [(i : ι) → NormedAddCommGroup (G i)] → NormedAddCommGroup ((i : ι) → G i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} →
    [Fintype.{u_1} ι] → [(i : ι) → NormedAddCommGroup.{u_4} (G i)] → NormedAddCommGroup.{max u_1 u_4} ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [Fintype ι] [(i : ι) → NormedAddCommGroup (G i)] =>
  let __src := Pi.seminormedAddGroup;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, add_comm := ⋯,
    toPseudoMetricSpace := __src.toPseudoMetricSpace, eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D147: `Pi.normedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Lemmas`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f9dab15f307cbf227004c74c0bb06dec60fd13239b8d79b0751df5ec0ca2a0d9`

Type:

```lean
{ι : Type u_3} → {R : ι → Type u_4} → [Fintype ι] → [(i : ι) → NormedRing (R i)] → NormedRing ((i : ι) → R i)
```

Fully explicit type:

```lean
{ι : Type u_3} →
  {R : ι → Type u_4} → [Fintype.{u_3} ι] → [(i : ι) → NormedRing.{u_4} (R i)] → NormedRing.{max u_3 u_4} ((i : ι) → R i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {R} [Fintype ι] [(i : ι) → NormedRing (R i)] =>
  let __src := Pi.seminormedRing;
  have __src_1 := Pi.normedAddCommGroup;
  { toNorm := __src.toNorm, toRing := __src.toRing, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    eq_of_dist_eq_zero := ⋯, dist_eq := ⋯, norm_mul_le := ⋯ }
```

### D148: `Pi.normedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d355935213de78232f83237164c0ae5a33cf298df9f793729cab1e7594836114`

Type:

```lean
{𝕜 : Type u_1} →
  [inst : NormedField 𝕜] →
    {ι : Type u_6} →
      {E : ι → Type u_7} →
        [inst_1 : Fintype ι] →
          [inst_2 : (i : ι) → SeminormedAddCommGroup (E i)] →
            [(i : ι) → NormedSpace 𝕜 (E i)] → NormedSpace 𝕜 ((i : ι) → E i)
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : NormedField.{u_1} 𝕜] →
    {ι : Type u_6} →
      {E : ι → Type u_7} →
        [inst_1 : Fintype.{u_6} ι] →
          [inst_2 : (i : ι) → SeminormedAddCommGroup.{u_7} (E i)] →
            [(i : ι) → @NormedSpace.{u_1, u_7} 𝕜 (E i) inst (inst_2 i)] →
              @NormedSpace.{u_1, max u_6 u_7} 𝕜 ((i : ι) → E i) inst
                (@Pi.seminormedAddCommGroup.{u_6, u_7} ι E inst_1 inst_2)
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NormedField 𝕜] {ι} {E} [Fintype ι] [(i : ι) → SeminormedAddCommGroup (E i)] [(i : ι) → NormedSpace 𝕜 (E i)] =>
  { toModule := Pi.module ι E 𝕜, norm_smul_le := ⋯ }
```

### D149: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a81381c20af462683322c70d792fc61454007e60d0781bb4fda6103a009c8abd`

Type:

```lean
{ι : Type u_5} → {Y : ι → Type v} → [t₂ : (i : ι) → TopologicalSpace (Y i)] → TopologicalSpace ((i : ι) → Y i)
```

Fully explicit type:

```lean
{ι : Type u_5} →
  {Y : ι → Type v} → [t₂ : (i : ι) → TopologicalSpace.{v} (Y i)] → TopologicalSpace.{max u_5 v} ((i : ι) → Y i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {Y} [t₂ : (i : ι) → TopologicalSpace (Y i)] => iInf fun i => TopologicalSpace.induced (fun f => f i) (t₂ i)
```

### D150: `PseudoMetricSpace.toUniformSpace`

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

### D151: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f602276baee30d3dbe02bd6b756a9097f750d59a7f91ca7635dcfc935fd22981`

Type:

```lean
{𝕜 : Type u_1} → [inst : RCLike 𝕜] → InnerProductSpace Real 𝕜
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : RCLike.{u_1} 𝕜] →
    @InnerProductSpace.{0, u_1} Real 𝕜 Real.instRCLike
      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{u_1} 𝕜
        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{u_1} 𝕜
          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{u_1} 𝕜
            (@NormedCommRing.toSeminormedCommRing.{u_1} 𝕜
              (@NormedField.toNormedCommRing.{u_1} 𝕜
                (@DenselyNormedField.toNormedField.{u_1} 𝕜 (@RCLike.toDenselyNormedField.{u_1} 𝕜 inst)))))))
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [RCLike 𝕜] =>
  let __spread.0 := Inner.rclikeToReal 𝕜 𝕜;
  { toNormedSpace := NormedAlgebra.toNormedSpace 𝕜, toInner := __spread.0, norm_sq_eq_re_inner := ⋯,
    conj_inner_symm := ⋯, add_left := ⋯, smul_left := ⋯ }
```

### D152: `Real`

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

### D153: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Type:

```lean
Add Real
```

Fully explicit type:

```lean
Add.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ add := Real.add✝ }
```

### D154: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `11a549e6c9caa007a4627570dd86aea756ada755f141da0356b8766788f2eef7`

Type:

```lean
AddCommMonoid Real
```

Fully explicit type:

```lean
AddCommMonoid.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D155: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `092dfdf642984bd4a336b502f7ac3f87adafd02a6236ba9033e90c0e1439ca7d`

Type:

```lean
CommSemiring Real
```

Fully explicit type:

```lean
CommSemiring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D156: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `166f2abb65bf1271e5e8d70fdb78c55672c7e366b30439e83b517f803cdefac3`

Type:

```lean
DivInvMonoid Real
```

Fully explicit type:

```lean
DivInvMonoid.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toMonoid := Real.instMonoid, toInv := Real.instInv, div := DivInvMonoid.div',
  div_eq_mul_inv := Real.instDivInvMonoid._proof_1, zpow := zpowRec, zpow_zero' := Real.instDivInvMonoid._proof_2,
  zpow_succ' := Real.instDivInvMonoid._proof_3, zpow_neg' := Real.instDivInvMonoid._proof_4 }
```

### D157: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `144d825fc543455e17044e843560e0415f8e4e9da60afb52f34edb809b7c34d3`

Type:

```lean
LE Real
```

Fully explicit type:

```lean
LE.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ le := Real.le✝ }
```

### D158: `Real.instLT`

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

### D159: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Type:

```lean
Mul Real
```

Fully explicit type:

```lean
Mul.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ mul := Real.mul✝ }
```

### D160: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b4e24b050b7fb50c4c115c51d5cd4c1b180cae53633f58a38c7d5ce3ccf86c81`

Type:

```lean
One Real
```

Fully explicit type:

```lean
One.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ one := Real.one✝ }
```

### D161: `Real.instPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.SpecialFunctions.Pow.Real`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d7348547260a6fa37dab6a95efbf0e3e5560a074d2443d0cb606f21bce228fe0`

Type:

```lean
Pow Real Real
```

Fully explicit type:

```lean
Pow.{0, 0} Real Real
```

Definition body (one-level semantic boundary):

```lean
{ pow := Real.rpow }
```

### D162: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d2fdb97b9d861fcf61e6dbea9993dfa0ca6aa16609742f215c35b3f7ddd16b8e`

Type:

```lean
RCLike Real
```

Fully explicit type:

```lean
RCLike.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toDenselyNormedField := Real.denselyNormedField, toStarRing := instStarRingReal,
  toNormedAlgebra := NormedAlgebra.id Real, toCompleteSpace := Real.instCompleteSpace, re := AddMonoidHom.id Real,
  im := 0, I := 0, I_re_ax := Real.instRCLike._proof_1, I_mul_I_ax := Real.instRCLike._proof_8, re_add_im_ax := ⋯,
  ofReal_re_ax := Real.instRCLike._proof_11, ofReal_im_ax := Real.instRCLike._proof_12, mul_re_ax := ⋯, mul_im_ax := ⋯,
  conj_re_ax := ⋯, conj_im_ax := ⋯, conj_I_ax := Real.instRCLike._proof_7, norm_sq_eq_def_ax := ⋯, mul_im_I_ax := ⋯,
  toPartialOrder := Real.partialOrder, le_iff_re_im := @Real.instRCLike._proof_13, toDecidableEq := Real.decidableEq }
```

### D163: `Real.instSub`

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

### D164: `Real.instZero`

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

### D165: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5bccf78d647cf08233ff548c19523f80b1d1bf11b5a76aa50396199e2c0c7510`

Type:

```lean
Lattice Real
```

Fully explicit type:

```lean
Lattice.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D166: `Real.measurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `51b107725c4edbe40e50ff5651a2c7ee5a10037e341c2764964a6d6cc26d82a1`

Type:

```lean
MeasurableSpace Real
```

Fully explicit type:

```lean
MeasurableSpace.{0} Real
```

Definition body (one-level semantic boundary):

```lean
borel Real
```

### D167: `Real.measureSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Haar.OfBasis`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d9de6598dfa4dc9b2cc1dfbccf206b37d159db61f4b35cc745a68902fbc74b22`

Type:

```lean
MeasureTheory.MeasureSpace Real
```

Fully explicit type:

```lean
MeasureTheory.MeasureSpace.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D168: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Type:

```lean
NormedAddCommGroup Real
```

Fully explicit type:

```lean
NormedAddCommGroup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toNorm := Real.norm, toAddCommGroup := Real.instAddCommGroup, toMetricSpace := Real.metricSpace, dist_eq := ⋯ }
```

### D169: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Type:

```lean
NormedCommRing Real
```

Fully explicit type:

```lean
NormedCommRing.{0} Real
```

Definition body (one-level semantic boundary):

```lean
let __src := Real.normedAddCommGroup;
let __src_1 := Real.commRing;
{ toNorm := __src.toNorm, toAddMonoid := __src.toAddMonoid, add_comm := Real.normedCommRing._proof_1,
  toMul := __src_1.toMul, left_distrib := Real.normedCommRing._proof_2, right_distrib := Real.normedCommRing._proof_3,
  zero_mul := Real.normedCommRing._proof_4, mul_zero := Real.normedCommRing._proof_5,
  mul_assoc := Real.normedCommRing._proof_6, toOne := __src_1.toOne, one_mul := Real.normedCommRing._proof_7,
  mul_one := Real.normedCommRing._proof_8, toNatCast := __src_1.toNatCast, natCast_zero := Real.normedCommRing._proof_9,
  natCast_succ := Real.normedCommRing._proof_10, npow := __src_1.npow, npow_zero := Real.normedCommRing._proof_11,
  npow_succ := Real.normedCommRing._proof_12, toNeg := __src.toNeg, toSub := __src.toSub,
  sub_eq_add_neg := Real.normedCommRing._proof_13, zsmul := __src.zsmul, zsmul_zero' := Real.normedCommRing._proof_14,
  zsmul_succ' := Real.normedCommRing._proof_15, zsmul_neg' := Real.normedCommRing._proof_16,
  neg_add_cancel := Real.normedCommRing._proof_17, toIntCast := __src_1.toIntCast,
  intCast_ofNat := Real.normedCommRing._proof_18, intCast_negSucc := Real.normedCommRing._proof_19,
  toMetricSpace := __src.toMetricSpace, dist_eq := ⋯, norm_mul_le := Real.normedCommRing._proof_20, mul_comm := ⋯ }
```

### D170: `Real.normedField`

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

### D171: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Type:

```lean
PseudoMetricSpace Real
```

Fully explicit type:

```lean
PseudoMetricSpace.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ dist := fun x y => abs (instHSub.hSub x y), dist_self := Real.pseudoMetricSpace._proof_1, dist_comm := ⋯,
  dist_triangle := ⋯, edist_dist := Real.pseudoMetricSpace._proof_2, uniformity_dist := Real.pseudoMetricSpace._proof_3,
  cobounded_sets := Real.pseudoMetricSpace._proof_4 }
```

### D172: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Type:

```lean
{α : Type u_2} → [β : SeminormedCommRing α] → NonUnitalSeminormedCommRing α
```

Fully explicit type:

```lean
{α : Type u_2} → [β : SeminormedCommRing.{u_2} α] → NonUnitalSeminormedCommRing.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : SeminormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D173: `Set`

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

### D174: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D175: `Set.uIcc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.UnorderedInterval`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `53623b127289993b0a6b152099093b949fab395160dd4c87afcb2f3e4b86821e`

Type:

```lean
{α : Type u_1} → [Lattice α] → α → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Lattice.{u_1} α] → (a b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Lattice α] a b => Set.Icc (SemilatticeInf.toMin.min a b) (SemilatticeSup.toMax.max a b)
```

### D176: `SetLike.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.SetLike.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D177: `UniformSpace.toTopologicalSpace`

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

### D178: `Zero.toOfNat0`

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

### D179: `instAddNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a1534bcd3e1888406ac787d30eeff8a284cb6688c23f5e8de09351dda91a280c`

Type:

```lean
Add Nat
```

Fully explicit type:

```lean
Add.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
{ add := Nat.add }
```

### D180: `instConditionallyCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Int.ConditionallyCompleteOrder`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4116bcf638c9c73b4af24fcbca7b9ae2faa668e71ae8a38d96ba7917d2362e2b`

Type:

```lean
ConditionallyCompleteLinearOrder Int
```

Fully explicit type:

```lean
ConditionallyCompleteLinearOrder.{0} Int
```

Definition body (one-level semantic boundary):

```lean
let __spread.0 := Int.instLinearOrder;
let __spread.1 := LinearOrder.toLattice;
{ toPartialOrder := __spread.0.toPartialOrder, sup := __spread.1.sup,
  le_sup_left := instConditionallyCompleteLinearOrder._proof_1,
  le_sup_right := instConditionallyCompleteLinearOrder._proof_4,
  sup_le := instConditionallyCompleteLinearOrder._proof_9, inf := __spread.1.inf, inf_le_left := ⋯, inf_le_right := ⋯,
  le_inf := ⋯,
  sSup := fun s => if h : And s.Nonempty (BddAbove s) then ((Classical.choose ⋯).greatestOfBdd ⋯ ⋯).val else 0,
  sInf := fun s => if h : And s.Nonempty (BddBelow s) then ((Classical.choose ⋯).leastOfBdd ⋯ ⋯).val else 0,
  le_csSup := ⋯, csSup_le := ⋯, csInf_le := ⋯, le_csInf := ⋯, toOrd := __spread.0.toOrd, le_total := ⋯,
  toDecidableLE := __spread.0.toDecidableLE, toDecidableEq := __spread.0.toDecidableEq,
  toDecidableLT := __spread.0.toDecidableLT, csSup_of_not_bddAbove := ⋯, csInf_of_not_bddBelow := ⋯,
  compare_eq_compareOfLessAndEq := ⋯ }
```

### D181: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Add.{u_1} α] → HAdd.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D182: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Div.{u_1} α] → HDiv.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```

### D183: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1fd375514ac68e29e7941c94ba308ea936395db23d0fee63a5c69dcccd3b2bdc`

Type:

```lean
{α : Type u_1} → [Mul α] → HMul α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Mul.{u_1} α] → HMul.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Mul α] => { hMul := fun a b => inst.mul a b }
```

### D184: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `eb300d353d84392c776cad5e356479f878030744a43f9a1584942a89d16350b4`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [Pow α β] → HPow α β α
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → [Pow.{u_1, u_2} α β] → HPow.{u_1, u_2, u_1} α β α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : Pow α β] => { hPow := fun a b => inst.pow a b }
```

### D185: `instHSMul`

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

### D186: `instHSub`

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

### D187: `instLENat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `002e628e28a06e89ab80e69408fa3be9fc3e200fafd33e0f71d9111a8944875e`

Type:

```lean
LE Nat
```

Fully explicit type:

```lean
LE.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
{ le := Nat.le }
```

### D188: `instLTNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4054f2341fdda887b2040c624c0867866ab56eabf3441d6ffc9451c94ae1663c`

Type:

```lean
LT Nat
```

Fully explicit type:

```lean
LT.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
{ lt := Nat.lt }
```

### D189: `instNatCastInt`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7fb46bceee4f1142c75008c8ac4be64c11c4bdbc7972ff89c0a5335ad80a2033`

Type:

```lean
NatCast Int
```

Fully explicit type:

```lean
NatCast.{0} Int
```

Definition body (one-level semantic boundary):

```lean
{ natCast := fun n => Int.ofNat n }
```

### D190: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7018dea92aae8c272f3a065f25e2bedb9732a0b602c3d54b166fa0cf2ce1ea92`

Type:

```lean
(n : Nat) → OfNat Nat n
```

Fully explicit type:

```lean
(n : Nat) → OfNat.{0} Nat n
```

Definition body (one-level semantic boundary):

```lean
fun n => { ofNat := n }
```

### D191: `intervalIntegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e2e08df1f4ea189c5c8b18b5894e96ab72c9a6e408e68c9dbbb6462e003414b2`

Type:

```lean
{E : Type u_5} →
  [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → MeasureTheory.Measure Real → E
```

Fully explicit type:

```lean
{E : Type u_5} →
  [inst : NormedAddCommGroup.{u_5} E] →
    [@NormedSpace.{0, u_5} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_5} E inst)] →
      (f : Real → E) → (a b : Real) → (μ : @MeasureTheory.Measure.{0} Real Real.measurableSpace) → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] f a b μ =>
  instHSub.hSub (MeasureTheory.integral (μ.restrict (Set.Ioc a b)) fun x => f x)
    (MeasureTheory.integral (μ.restrict (Set.Ioc b a)) fun x => f x)
```

### D192: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D193: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D194: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D195: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D196: `Classical.choose`

- Role: `external-frontier`
- Owner module: `Init.Classical`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b1c701cdfaf2d85710069fad282daeeed4f8640330d48f3d379fb221f4e4fb07`

Type:

```lean
{α : Sort u} → {p : α → Prop} → (Exists fun x => p x) → α
```

Fully explicit type:

```lean
{α : Sort u} → {p : α → Prop} → (h : @Exists.{u} α fun (x : α) => p x) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {p} h => (Classical.indefiniteDescription p h).val
```

### D197: `ContDiffOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `8ac638d00c58b4e68dfe06c2f42994f61ed5a3bc9ab20cfdc86a7cf98864450f`

Type:

```lean
(𝕜 : Type u) →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type uE} →
      [inst_1 : NormedAddCommGroup E] →
        [NormedSpace 𝕜 E] →
          {F : Type uF} → [inst_3 : NormedAddCommGroup F] → [NormedSpace 𝕜 F] → WithTop ENat → (E → F) → Set E → Prop
```

Fully explicit type:

```lean
(𝕜 : Type u) →
  [inst : NontriviallyNormedField.{u} 𝕜] →
    {E : Type uE} →
      [inst_1 : NormedAddCommGroup.{uE} E] →
        [@NormedSpace.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1)] →
          {F : Type uF} →
            [inst_3 : NormedAddCommGroup.{uF} F] →
              [@NormedSpace.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)] →
                (n : WithTop.{0} ENat) → (f : E → F) → (s : Set.{uE} E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 [NontriviallyNormedField 𝕜] {E} [NormedAddCommGroup E] [NormedSpace 𝕜 E] {F} [NormedAddCommGroup F]
    [NormedSpace 𝕜 F] n f s =>
  ∀ (x : E), Set.instMembership.mem s x → ContDiffWithinAt 𝕜 n f s x
```

### D198: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D199: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Type:

```lean
{α : Type u_2} → [DenselyNormedField α] → NontriviallyNormedField α
```

Fully explicit type:

```lean
{α : Type u_2} → [DenselyNormedField.{u_2} α] → NontriviallyNormedField.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : DenselyNormedField α] => { toNormedField := inst.toNormedField, non_trivial := ⋯ }
```

### D200: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D201: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D202: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D203: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D204: `ENat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENat.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `16349df6eaf312f3e93f26d366e785c80c82626298cced892c553952ae67d08a`

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
WithTop Nat
```

### D205: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D206: `ESeminormedAddCommMonoid.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D207: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D208: `ESeminormedAddMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D209: `Finset.erase`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Erase`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `960c1ae47eed3bfc6648bebbab6704a872a71528db7f21683cd55b77654a2701`

Type:

```lean
{α : Type u_1} → [DecidableEq α] → Finset α → α → Finset α
```

Fully explicit type:

```lean
{α : Type u_1} → [DecidableEq.{u_1 + 1} α] → (s : Finset.{u_1} α) → (a : α) → Finset.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [DecidableEq α] s a => { val := s.val.erase a, nodup := ⋯ }
```

### D210: `Finset.prod`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.BigOperators.Group.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e364cffe1f2457eedceca9fe0617d7a66084963ffb6e6ed760d1f3fe74eee841`

Type:

```lean
{ι : Type u_1} → {M : Type u_3} → [CommMonoid M] → Finset ι → (ι → M) → M
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : Type u_3} → [CommMonoid.{u_3} M] → (s : Finset.{u_1} ι) → (f : ι → M) → M
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [CommMonoid M] s f => (Multiset.map f s.val).prod
```

### D211: `Function.uncurry`

- Role: `external-frontier`
- Owner module: `Init.Data.Function`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `588a8e97090f93380cd47f82f5e1a8f3dfe6781e800ef2678c60dfdc97617dcd`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → {φ : Sort u_3} → (α → β → φ) → Prod α β → φ
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → {φ : Sort u_3} → (α → β → φ) → Prod.{u_1, u_2} α β → φ
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} {φ} f a => f a.fst a.snd
```

### D212: `IntervalIntegrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `438d3df5ccfcf0ec98ba944c6cd9e02b599992e15f8bcb33aaf6cc91c6e2c352`

Type:

```lean
{ε : Type u_3} →
  [inst : TopologicalSpace ε] → [ENormedAddMonoid ε] → (Real → ε) → MeasureTheory.Measure Real → Real → Real → Prop
```

Fully explicit type:

```lean
{ε : Type u_3} →
  [inst : TopologicalSpace.{u_3} ε] →
    [@ENormedAddMonoid.{u_3} ε inst] →
      (f : Real → ε) → (μ : @MeasureTheory.Measure.{0} Real Real.measurableSpace) → (a b : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ε} [TopologicalSpace ε] [ENormedAddMonoid ε] f μ a b =>
  And (MeasureTheory.IntegrableOn f (Set.Ioc a b) μ) (MeasureTheory.IntegrableOn f (Set.Ioc b a) μ)
```

### D213: `Inv.inv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D214: `List`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ec06a72bb009eecaedd9dbf6a3349bbea0bbc480e0a21179f4e21b3e219b952d`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

### D215: `List.foldl`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `528cbed637e4ef546b621011d5cf13a5a950202dac919ee6cff2046010954d44`

Type:

```lean
{α : Type u} → {β : Type v} → (α → β → α) → α → List β → α
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (f : α → β → α) → (init : α) → List.{v} β → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f x x_1 =>
  List.brecOn (motive := fun x => α → α) x_1
    (fun x f_1 x_2 =>
      List.foldl.match_1 (fun x x_3 => List.below (motive := fun x => α → α) x_3 → α) x_2 x (fun a x => a)
        (fun a b l x => x.1 (f a b)) f_1)
    x
```

### D216: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `51e5158e8f2f2a375463d510858200b96afa04fb8f33126da2c5d1c572a76165`

Type:

```lean
{ε : Type u_5} →
  [inst : TopologicalSpace ε] →
    [ContinuousENorm ε] →
      {α : Type u_8} →
        {x : MeasurableSpace α} → (α → ε) → autoParam (MeasureTheory.Measure α) MeasureTheory.Integrable._auto_1 → Prop
```

Fully explicit type:

```lean
{ε : Type u_5} →
  [inst : TopologicalSpace.{u_5} ε] →
    [@ContinuousENorm.{u_5} ε inst] →
      {α : Type u_8} →
        {x : MeasurableSpace.{u_8} α} →
          (f : α → ε) →
            (μ : autoParam.{u_8 + 1} (@MeasureTheory.Measure.{u_8} α x) MeasureTheory.Integrable._auto_1) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ε} [TopologicalSpace ε] [ContinuousENorm ε] {α} {x} f μ =>
  And (MeasureTheory.AEStronglyMeasurable f μ) (MeasureTheory.HasFiniteIntegral f μ)
```

### D217: `MeasureTheory.IntegrableOn`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntegrableOn`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D218: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

Fully explicit type:

```lean
(α : Type u_6) → [MeasurableSpace.{u_6} α] → Type u_6
```

### D219: `MeasureTheory.Measure.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D220: `MeasureTheory.Measure.restrict`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Restrict`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D221: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D222: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D223: `Nat.below`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `04a84157ffe59e0d301c0043561b314a7ab23e9ec7be060ff84461bda2e48a65`

Type:

```lean
{motive : Nat → Sort u} → Nat → Sort (max 1 u)
```

Fully explicit type:

```lean
{motive : (t : Nat) → Sort u} → (t : Nat) → Sort (max 1 u)
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t => Nat.rec PUnit (fun n n_ih => PProd (motive n) n_ih) t
```

### D224: `Nat.brecOn`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `112a5e33ebc43ed10219858c8cc3892005a54c63ed7cb7590213f5a7791f9c14`

Type:

```lean
{motive : Nat → Sort u} → (t : Nat) → ((t : Nat) → Nat.below t → motive t) → motive t
```

Fully explicit type:

```lean
{motive : (t : Nat) → Sort u} → (t : Nat) → (F_1 : (t : Nat) → (f : @Nat.below.{u} motive t) → motive t) → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t F_1 => (Nat.brecOn.go t F_1).1
```

### D225: `Nat.succ`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `c069f332a974e3dbf1dc48acb0a49ab7d732c776b5cccdbe836db99ce812bdb2`

Type:

```lean
Nat → Nat
```

Fully explicit type:

```lean
(n : Nat) → Nat
```

### D226: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → AddCommMonoid α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring.{u} α] → AddCommMonoid.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocSemiring α] => self.1
```

### D227: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Type:

```lean
{α : Type u} → [self : NonUnitalSemiring α] → NonUnitalNonAssocSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalSemiring.{u} α] → NonUnitalNonAssocSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSemiring α] => self.1
```

### D228: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `dc08b02d757cccbd21bce550b40d3f76d2ee704ec2cd7f5507023d827296474f`

Type:

```lean
{α : Type u_5} → [self : NontriviallyNormedField α] → NormedField α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NontriviallyNormedField.{u_5} α] → NormedField.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NontriviallyNormedField α] => self.1
```

### D229: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

Fully explicit type:

```lean
(E : Type u_8) → Type u_8
```

### D230: `NormedAddCommGroup.toENormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D231: `NormedAddCommGroup.toNormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D232: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D233: `NormedAddGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D234: `NormedAddGroup.toENormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c2e4373a88aee873807ebe0c84a9ad97e86c59f70ff5cf5af4d6497b3024e91a`

Type:

```lean
{F : Type u_7} → [inst : NormedAddGroup F] → ENormedAddMonoid F
```

Fully explicit type:

```lean
{F : Type u_7} →
  [inst : NormedAddGroup.{u_7} F] →
    @ENormedAddMonoid.{u_7} F
      (@UniformSpace.toTopologicalSpace.{u_7} F
        (@PseudoMetricSpace.toUniformSpace.{u_7} F
          (@SeminormedAddGroup.toPseudoMetricSpace.{u_7} F (@NormedAddGroup.toSeminormedAddGroup.{u_7} F inst))))
```

Definition body (one-level semantic boundary):

```lean
fun {F} [inst : NormedAddGroup F] =>
  { toContinuousENorm := SeminormedAddGroup.toContinuousENorm, toAddMonoid := inst.toAddMonoid, enorm_zero := ⋯,
    enorm_add_le := ⋯, enorm_eq_zero := ⋯ }
```

### D235: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

Fully explicit type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField.{u_6} 𝕜] → [SeminormedAddCommGroup.{u_7} E] → Type (max u_6 u_7)
```

### D236: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D237: `Option`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `f8032ff16991de9a44b60e677d281af2d3581ac7df43657647bc43faa3161b32`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

### D238: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Type:

```lean
(I : Type u) →
  (α : Type u_1) → (β : Type u_2) → [inst : Semiring α] → [inst_1 : AddCommMonoid β] → [Module α β] → Module α (I → β)
```

Fully explicit type:

```lean
(I : Type u) →
  (α : Type u_1) →
    (β : Type u_2) →
      [inst : Semiring.{u_1} α] →
        [inst_1 : AddCommMonoid.{u_2} β] →
          [@Module.{u_1, u_2} α β inst inst_1] →
            @Module.{u_1, max u u_2} α (I → β) inst
              (@Pi.addCommMonoid.{u, u_2} I (fun (a : I) => β) fun (i : I) => inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun I α β [Semiring α] [AddCommMonoid β] [Module α β] => Pi.module I (fun a => β) α
```

### D239: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommGroup (f i)] → AddCommGroup ((i : I) → f i)
```

Fully explicit type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommGroup.{v₁} (f i)] → AddCommGroup.{max u v₁} ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommGroup (f i)] =>
  let __src := Pi.addGroup;
  have __src_1 := Pi.addCommMonoid;
  { toAddGroup := __src, add_comm := ⋯ }
```

### D240: `Pi.normedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e1d8c48f10ab6dcecabe68ad092908fcd0f83c41f7ec434a1553f79491f53fdb`

Type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [Fintype ι] → [(i : ι) → NormedAddGroup (G i)] → NormedAddGroup ((i : ι) → G i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} →
    [Fintype.{u_1} ι] → [(i : ι) → NormedAddGroup.{u_4} (G i)] → NormedAddGroup.{max u_1 u_4} ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [Fintype ι] [(i : ι) → NormedAddGroup (G i)] =>
  let __src := Pi.seminormedAddGroup;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D241: `Pi.seminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `44ef291083756b8ed4dcdb745f9c537989525c10e19d60aed1bd242ba80c3113`

Type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} → [Fintype ι] → [(i : ι) → SeminormedAddGroup (G i)] → SeminormedAddGroup ((i : ι) → G i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} →
    [Fintype.{u_1} ι] → [(i : ι) → SeminormedAddGroup.{u_4} (G i)] → SeminormedAddGroup.{max u_1 u_4} ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [Fintype ι] [(i : ι) → SeminormedAddGroup (G i)] =>
  { norm := fun f => (Finset.univ.sup fun b => SeminormedAddGroup.toNNNorm.nnnorm (f b)).toReal,
    toAddGroup := Pi.addGroup, toPseudoMetricSpace := pseudoMetricSpacePi, dist_eq := ⋯ }
```

### D242: `Prod`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `3df3b0cff45fb04022db70edff8e5747def6cae602cd8c33e673abac1bb4e347`

Type:

```lean
Type u → Type v → Type (max u v)
```

Fully explicit type:

```lean
(α : Type u) → (β : Type v) → Type (max u v)
```

### D243: `Prod.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `27e0d8aa96ebce1ea21b6abcaf95b2c6b98b7dfe173d5ad327db0cc367a5cb55`

Type:

```lean
{E : Type u_2} → {F : Type u_3} → [NormedAddCommGroup E] → [NormedAddCommGroup F] → NormedAddCommGroup (Prod E F)
```

Fully explicit type:

```lean
{E : Type u_2} →
  {F : Type u_3} →
    [NormedAddCommGroup.{u_2} E] → [NormedAddCommGroup.{u_3} F] → NormedAddCommGroup.{max u_3 u_2} (Prod.{u_2, u_3} E F)
```

Definition body (one-level semantic boundary):

```lean
fun {E} {F} [NormedAddCommGroup E] [NormedAddCommGroup F] =>
  let __src := Prod.seminormedAddGroup;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, add_comm := ⋯,
    toPseudoMetricSpace := __src.toPseudoMetricSpace, eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D244: `Prod.normedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3cbe8225107eb42f7977e2aa7f0dce7094ba4bf6550143c5c6f82e0753202f50`

Type:

```lean
{𝕜 : Type u_1} →
  {E : Type u_3} →
    {F : Type u_4} →
      [inst : NormedField 𝕜] →
        [inst_1 : SeminormedAddCommGroup E] →
          [inst_2 : SeminormedAddCommGroup F] → [NormedSpace 𝕜 E] → [NormedSpace 𝕜 F] → NormedSpace 𝕜 (Prod E F)
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  {E : Type u_3} →
    {F : Type u_4} →
      [inst : NormedField.{u_1} 𝕜] →
        [inst_1 : SeminormedAddCommGroup.{u_3} E] →
          [inst_2 : SeminormedAddCommGroup.{u_4} F] →
            [@NormedSpace.{u_1, u_3} 𝕜 E inst inst_1] →
              [@NormedSpace.{u_1, u_4} 𝕜 F inst inst_2] →
                @NormedSpace.{u_1, max u_4 u_3} 𝕜 (Prod.{u_3, u_4} E F) inst
                  (@Prod.seminormedAddCommGroup.{u_3, u_4} E F inst_1 inst_2)
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} {E} {F} [NormedField 𝕜] [SeminormedAddCommGroup E] [SeminormedAddCommGroup F] [NormedSpace 𝕜 E]
    [NormedSpace 𝕜 F] =>
  have __src := Prod.seminormedAddCommGroup;
  let __src := Prod.instModule;
  { toModule := __src, norm_smul_le := ⋯ }
```

### D245: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Type:

```lean
DenselyNormedField Real
```

Fully explicit type:

```lean
DenselyNormedField.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toNormedField := Real.normedField, lt_norm_lt := Real.denselyNormedField._proof_1 }
```

### D246: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Type:

```lean
AddCommGroup Real
```

Fully explicit type:

```lean
AddCommGroup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D247: `Real.instCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f537dc5e9be2b886066e25d0f560dc52fd1be771759ec3e7b40a5f5f3e6c6467`

Type:

```lean
CommMonoid Real
```

Fully explicit type:

```lean
CommMonoid.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D248: `Real.instInv`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D249: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D250: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `896bb94fc15867c0df82ea0f639eb6116e90a24819a66a54db9442e47cba7274`

Type:

```lean
Preorder Real
```

Fully explicit type:

```lean
Preorder.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D251: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Type:

```lean
Ring Real
```

Fully explicit type:

```lean
Ring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D252: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D253: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Type:

```lean
{R : Type u} → [self : Ring R] → Semiring R
```

Fully explicit type:

```lean
{R : Type u} → [self : Ring.{u} R] → Semiring.{u} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Ring R] => self.1
```

### D254: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D255: `SProd.sprod`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.SProd`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `5f7389129230ea3e3c1e3bd52b23a5c8506ec2ec85a3e7b594a9337adeccb818`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : SProd α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : SProd.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : SProd α β γ] => self.1
```

### D256: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D257: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D258: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D259: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonUnitalSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : Semiring.{u} α] → NonUnitalSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Semiring α] => self.1
```

### D260: `Set.Icc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5d4d1d0cca151d5f96eb45776025e642f79e9040e66fffcf889bd1224442ecc8`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → (a b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] a b => setOf fun x => And (inst.le a x) (inst.le x b)
```

### D261: `Set.Ico`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `48aa2cf5736dd57481b68491490245577ea0b7b50fe2429fb88f717769ea5830`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → (a b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] a b => setOf fun x => And (inst.le a x) (inst.lt x b)
```

### D262: `Set.instSProd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Operations`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7150b196c4ee63f112470ff0614afca7bcfd16b80b4ae6a7361ac8dd84b3e14d`

Type:

```lean
{α : Type u} → {β : Type v} → SProd (Set α) (Set β) (Set (Prod α β))
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → SProd.{u, v, max v u} (Set.{u} α) (Set.{v} β) (Set.{max v u} (Prod.{u, v} α β))
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} => { sprod := Set.prod }
```

### D263: `Set.pi`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Operations`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6647c8b93a11dd04ffa0bc45a571cdfcb8ddabfa023a6b0e8e8790df7b56186f`

Type:

```lean
{ι : Type u_1} → {α : ι → Type u_2} → Set ι → ((i : ι) → Set (α i)) → Set ((i : ι) → α i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {α : ι → Type u_2} → (s : Set.{u_1} ι) → (t : (i : ι) → Set.{u_2} (α i)) → Set.{max u_1 u_2} ((i : ι) → α i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {α} s t => setOf fun f => ∀ (i : ι), Set.instMembership.mem s i → Set.instMembership.mem (t i) (f i)
```

### D264: `Set.univ`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `4a477fd0b844ae25dae2fe8488226265a7c6b23c8087f3feda3f6197172b13e7`

Type:

```lean
{α : Type u} → Set α
```

Fully explicit type:

```lean
{α : Type u} → Set.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} => setOf fun _a => True
```

### D265: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D266: `Top.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Notation`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D267: `TopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `c85328c9b77ed49bcba2dd67e9f87b53aaf251834d29c69856ef079a9ec4b57b`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(X : Type u) → Type u
```

### D268: `Unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8544f990089bb705329f8e13de94d6583865877bcb1ebec4f8c096524a17581e`

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
PUnit
```

### D269: `WithTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.TypeTags`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `457f8131bb826c2c59be9b2ca994625740814f42ae0f92a7247987f009756f2a`

Type:

```lean
Type u_2 → Type u_2
```

Fully explicit type:

```lean
(α : Type u_2) → Type u_2
```

Definition body (one-level semantic boundary):

```lean
fun α => Option α
```

### D270: `WithTop.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.TypeTags`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7656af4828558ad72ccc643779cf6d88b0845b677b37efa1d18644d0fbbd959f`

Type:

```lean
{α : Type u_1} → Top (WithTop α)
```

Fully explicit type:

```lean
{α : Type u_1} → Top.{u_1} (WithTop.{u_1} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { top := Option.none }
```

### D271: `AEMeasurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `6dc48478b911cadddc9129039bc8859282262cccd65bca8d46f3cdc5415a69cd`

Type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [MeasurableSpace β] →
      {_m : MeasurableSpace α} → (α → β) → autoParam (MeasureTheory.Measure α) AEMeasurable._auto_1 → Prop
```

Fully explicit type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [MeasurableSpace.{u_2} β] →
      {_m : MeasurableSpace.{u_1} α} →
        (f : α → β) → (μ : autoParam.{u_1 + 1} (@MeasureTheory.Measure.{u_1} α _m) AEMeasurable._auto_1) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [MeasurableSpace β] {_m} f μ => Exists fun g => And (Measurable g) ((MeasureTheory.ae μ).EventuallyEq f g)
```

### D272: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(G : Type u) → Type u
```

### D273: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D274: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D275: `Filter.Eventually`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `48c8fc03616b0f899835653f1d062e3de4f566255a80b15231ebdedcb0a5c4c4`

Type:

```lean
{α : Type u_1} → (α → Prop) → Filter α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → (p : α → Prop) → (f : Filter.{u_1} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} p f => Filter.instMembership.mem f (setOf fun x => p x)
```

### D276: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `7e5f54349644c32198960083c0e0eb6c033c80a8656d02a78b3eae9a4f5131f2`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → (α → β) → Filter α → Filter β → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → (f : α → β) → (l₁ : Filter.{u_1} α) → (l₂ : Filter.{u_2} β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f l₁ l₂ => Filter.instPartialOrder.le (Filter.map f l₁) l₂
```

### D277: `Filter.atTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.AtTopBot.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `f743a11da6fe9e156755f41ec35f4d61b87ca4af4575ede456b477a74caa45f3`

Type:

```lean
{α : Type u_3} → [Preorder α] → Filter α
```

Fully explicit type:

```lean
{α : Type u_3} → [Preorder.{u_3} α] → Filter.{u_3} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Preorder α] => iInf fun a => Filter.principal (Set.Ici a)
```

### D278: `Finset.Icc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `930ef57574f3e1daba61853cc191d2acf9378933bef58d5dd89943d8740ed017`

Type:

```lean
{α : Type u_1} → [inst : Preorder α] → [LocallyFiniteOrder α] → α → α → Finset α
```

Fully explicit type:

```lean
{α : Type u_1} → [inst : Preorder.{u_1} α] → [@LocallyFiniteOrder.{u_1} α inst] → (a b : α) → Finset.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Preorder α] [inst_1 : LocallyFiniteOrder α] a b => inst_1.finsetIcc a b
```

### D279: `Finset.instHasSubset`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `69a612877b6112e479175009ff3380b7a42d8480050906edd4996240c8b175a0`

Type:

```lean
{α : Type u_1} → HasSubset (Finset α)
```

Fully explicit type:

```lean
{α : Type u_1} → HasSubset.{u_1} (Finset.{u_1} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { Subset := fun s t => ∀ ⦃a : α⦄, SetLike.instMembership.mem s a → SetLike.instMembership.mem t a }
```

### D280: `Function.update`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Function.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `092e6c4864b94365603f748d7cf0dd798223b04b127d4c37969b0c09cac29193`

Type:

```lean
{α : Sort u} → {β : α → Sort v} → [DecidableEq α] → ((a : α) → β a) → (a' : α) → β a' → (a : α) → β a
```

Fully explicit type:

```lean
{α : Sort u} → {β : α → Sort v} → [DecidableEq.{u} α] → (f : (a : α) → β a) → (a' : α) → (v : β a') → (a : α) → β a
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [DecidableEq α] f a' v a => if h : Eq a a' then Eq.ndrec v ⋯ else f a
```

### D281: `HasSubset.Subset`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `7c9560733523c0ce0c86bc53889a57a7fea2b2cc4c4a116fba2021bed1745efa`

Type:

```lean
{α : Type u} → [self : HasSubset α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u} → [self : HasSubset.{u} α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : HasSubset α] => self.1
```

### D282: `Int.instSub`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `cdec027f4b1a52ca9841248e8efbabc901ed4e9b4220aa4074044d4c9537c68c`

Type:

```lean
Sub Int
```

Fully explicit type:

```lean
Sub.{0} Int
```

Definition body (one-level semantic boundary):

```lean
{ sub := Int.sub }
```

### D283: `MeasureTheory.Measure.instOuterMeasureClass`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `12c72524345059262ce157fe3d4314569e2e86487366f251af8f57723dda88b7`

Type:

```lean
∀ {α : Type u_1} [inst : MeasurableSpace α], MeasureTheory.OuterMeasureClass (MeasureTheory.Measure α) α
```

Fully explicit type:

```lean
∀ {α : Type u_1} [inst : MeasurableSpace.{u_1} α],
  @MeasureTheory.OuterMeasureClass.{u_1, u_1} (@MeasureTheory.Measure.{u_1} α inst) α
    (@MeasureTheory.Measure.instFunLike.{u_1} α inst)
```

### D284: `MeasureTheory.Measure.map`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Map`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `35d0f192bfc92d083756f0df86ca1ad37f0c1f0bfa39120f6adf90414c4a3b75`

Type:

```lean
{α : Type u_4} →
  {β : Type u_5} →
    [inst : MeasurableSpace α] →
      [inst_1 : MeasurableSpace β] → (α → β) → MeasureTheory.Measure α → MeasureTheory.Measure β
```

Fully explicit type:

```lean
{α : Type u_4} →
  {β : Type u_5} →
    [inst : MeasurableSpace.{u_4} α] →
      [inst_1 : MeasurableSpace.{u_5} β] →
        (f : α → β) → (μ : @MeasureTheory.Measure.{u_4} α inst) → @MeasureTheory.Measure.{u_5} β inst_1
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.Measure.wrapped✝.1
```

### D285: `MeasureTheory.ae`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.OuterMeasure.AE`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a2cf721ae5d77711462e063686e22be219128cc7ab3b90958a7ce538754e0fd5`

Type:

```lean
{α : Type u_1} →
  {F : Type u_3} → [inst : FunLike F (Set α) ENNReal] → [MeasureTheory.OuterMeasureClass F α] → F → Filter α
```

Fully explicit type:

```lean
{α : Type u_1} →
  {F : Type u_3} →
    [inst : FunLike.{u_3 + 1, u_1 + 1, 1} F (Set.{u_1} α) ENNReal] →
      [@MeasureTheory.OuterMeasureClass.{u_3, u_1} F α inst] → (μ : F) → Filter.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {F} [inst : FunLike F (Set α) ENNReal] [MeasureTheory.OuterMeasureClass F α] μ =>
  Filter.ofCountableUnion (fun x => Eq (inst.coe μ x) 0) ⋯ ⋯
```

### D286: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

Fully explicit type:

```lean
(R : Type u) → (M : Type v) → [Semiring.{u} R] → [AddCommMonoid.{v} M] → Type (max u v)
```

### D287: `Nat.casesOn`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ef6de7a898de834052ce3878aa9641c2b9e400122a4e012169c25b12d9da029d`

Type:

```lean
{motive : Nat → Sort u} → (t : Nat) → motive Nat.zero → ((n : Nat) → motive n.succ) → motive t
```

Fully explicit type:

```lean
{motive : (t : Nat) → Sort u} →
  (t : Nat) → (zero : motive Nat.zero) → (succ : (n : Nat) → motive (Nat.succ n)) → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t zero succ => Nat.rec zero (fun n n_ih => succ n) t
```

### D288: `Nat.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5ea89e9915200c8782bc933f9184e28eb38f4c9610b00cf1310cc6e6435642d8`

Type:

```lean
Preorder Nat
```

Fully explicit type:

```lean
Preorder.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D289: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D290: `Option.casesOn`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `f5c7fcf26356582d01d4d242e269e57122d269619688ef18143c576ae90dc704`

Type:

```lean
{α : Type u} →
  {motive : Option α → Sort u_1} →
    (t : Option α) → motive Option.none → ((val : α) → motive (Option.some val)) → motive t
```

Fully explicit type:

```lean
{α : Type u} →
  {motive : (t : Option.{u} α) → Sort u_1} →
    (t : Option.{u} α) →
      (none : motive (@Option.none.{u} α)) → (some : (val : α) → motive (@Option.some.{u} α val)) → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {α} {motive} t none some => Option.rec none (fun val => some val) t
```

### D291: `Option.none`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `fc62ffaad8d042f4eec99bba251ffd4d2254863bc9071098e1e1ae18d8cb0694`

Type:

```lean
{α : Type u} → Option α
```

Fully explicit type:

```lean
{α : Type u} → Option.{u} α
```

### D292: `Option.some`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `ad8453c20fc76a257ee5d58ea22396778d3ef25ba2f1aa634b2e7c5bd2d584d9`

Type:

```lean
{α : Type u} → α → Option α
```

Fully explicit type:

```lean
{α : Type u} → (val : α) → Option.{u} α
```

### D293: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `9e6f6ef922e3c39bdc8dcf74fa873f2e393c916c08aa49739c9dcafb3f96877b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → AddMonoid G
```

Fully explicit type:

```lean
{G : Type u} → [self : SubNegMonoid.{u} G] → AddMonoid.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.1
```

### D294: `Subtype`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `3b0bb8433bd0c981dbdb4d6256bf74c50e9883207dae8d309dcb705135cf932c`

Type:

```lean
{α : Sort u} → (α → Prop) → Sort (max 1 u)
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Sort (max 1 u)
```

### D295: `Subtype.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Sets`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `8045b4145e4e6f4c0a3e8bc7388454b389fa1e5daa8d17fa79b03bf4447dde18`

Type:

```lean
{α : Type u_1} → (p : α → Prop) → [DecidablePred p] → [Fintype α] → Fintype (Subtype fun x => p x)
```

Fully explicit type:

```lean
{α : Type u_1} →
  (p : α → Prop) →
    [@DecidablePred.{u_1 + 1} α p] → [Fintype.{u_1} α] → Fintype.{u_1} (@Subtype.{u_1 + 1} α fun (x : α) => p x)
```

Definition body (one-level semantic boundary):

```lean
fun {α} p [DecidablePred p] [Fintype α] => Fintype.subtype (Finset.filter p Finset.univ) ⋯
```

### D296: `Unit.unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e5d4ec6d7dbc312235968b914130d2d6ec344f051fd5f7c0276905a3c63cc953`

Type:

```lean
Unit
```

Fully explicit type:

```lean
Unit
```

Definition body (one-level semantic boundary):

```lean
PUnit.unit
```

### D297: `closure`

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

### D298: `instDecidableNot`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `37aa26a947d5738f12ec544d42841f48b475aa5a77621b11677f5a37fce0c2f9`

Type:

```lean
{p : Prop} → [dp : Decidable p] → Decidable (Not p)
```

Fully explicit type:

```lean
{p : Prop} → [dp : Decidable p] → Decidable (Not p)
```

Definition body (one-level semantic boundary):

```lean
fun {p} [dp : Decidable p] =>
  instDecidableAnd.match_1 (fun dp => Decidable (Not p)) dp (fun hp => Decidable.isFalse ⋯) fun hp =>
    Decidable.isTrue hp
```

### D299: `instOfNat`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `d01cf83431e28a96433c57a624e20a771e5e0ddc02355969c5044adf1ba168a5`

Type:

```lean
{n : Nat} → OfNat Int n
```

Fully explicit type:

```lean
{n : Nat} → OfNat.{0} Int n
```

Definition body (one-level semantic boundary):

```lean
fun {n} => { ofNat := Int.ofNat n }
```

### D300: `instSubNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5b0e20a4d2b3e0a67bd35de1b5c84cc60d6dc867658112d84cad483055804868`

Type:

```lean
Sub Nat
```

Fully explicit type:

```lean
Sub.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
{ sub := Nat.sub }
```

### D301: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D302: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D303: `nhds`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `8eb445823f4b15a765f7e0cd634f73196d36b4f09054d2aef43a69d3138c6ce8`

Type:

```lean
{X : Type u_3} → [TopologicalSpace X] → X → Filter X
```

Fully explicit type:

```lean
{X : Type u_3} → [TopologicalSpace.{u_3} X] → (x : X) → Filter.{u_3} X
```

Definition body (one-level semantic boundary):

```lean
wrapped✝.1
```

### D304: `Finset.range`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Range`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `0d8947d3b91a57604f7b7be615f2ff236f2058a47281af31ea2498635666e9e7`

Type:

```lean
Nat → Finset Nat
```

Fully explicit type:

```lean
(n : Nat) → Finset.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
fun n => { val := Multiset.range n, nodup := ⋯ }
```

### D305: `Not`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `0bfdacbe07f6cbb8995b354e36299fd742f29398c188d7cc23dedcdc47f57a9a`

Type:

```lean
Prop → Prop
```

Fully explicit type:

```lean
(a : Prop) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun a => a → False
```

### D306: `Subtype.mk`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `488ac61b6d3c07fb9a2f54a03a39e6001a4c7cedfd07515f0f9865e7fef9ef51`

Type:

```lean
{α : Sort u} → {p : α → Prop} → (val : α) → p val → Subtype p
```

Fully explicit type:

```lean
{α : Sort u} → {p : α → Prop} → (val : α) → (property : p val) → @Subtype.{u} α p
```

### D307: `Subtype.val`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `69c61ab82498e5563eaf5f0313ea7f2164c284c3dc742024a30332372a46663d`

Type:

```lean
{α : Sort u} → {p : α → Prop} → Subtype p → α
```

Fully explicit type:

```lean
{α : Sort u} → {p : α → Prop} → (self : @Subtype.{u} α p) → α
```

Definition body (one-level semantic boundary):

```lean
fun α p self => self.1
```

### D308: `dite`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `a2551097d29bac847f3c59e8213b5882afd4a95e9247c2382e8bce33011974b5`

Type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → (c → α) → (Not c → α) → α
```

Fully explicit type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → (t : c → α) → (e : Not c → α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} c [h : Decidable c] t e => Decidable.casesOn h e t
```

### D309: `CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D310: `CompleteBooleanAlgebra.toCompleteDistribLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D311: `CompleteBooleanAlgebra.toCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D312: `CompleteDistribLattice.toFrame`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D313: `CompleteLattice.instOmegaCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D314: `ContinuousLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `0755150640fdc13f3d12ef9d25818b269a296f4838674f17959fc49dd8cab962`

Type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        RingHom R S →
          (M : Type u_3) →
            [TopologicalSpace M] →
              [inst_3 : AddCommMonoid M] →
                (M₂ : Type u_4) →
                  [TopologicalSpace M₂] →
                    [inst_5 : AddCommMonoid M₂] → [Module R M] → [Module S M₂] → Type (max u_3 u_4)
```

Fully explicit type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring.{u_1} R] →
      [inst_1 : Semiring.{u_2} S] →
        (σ :
            @RingHom.{u_1, u_2} R S (@Semiring.toNonAssocSemiring.{u_1} R inst)
              (@Semiring.toNonAssocSemiring.{u_2} S inst_1)) →
          (M : Type u_3) →
            [TopologicalSpace.{u_3} M] →
              [inst_3 : AddCommMonoid.{u_3} M] →
                (M₂ : Type u_4) →
                  [TopologicalSpace.{u_4} M₂] →
                    [inst_5 : AddCommMonoid.{u_4} M₂] →
                      [@Module.{u_1, u_3} R M inst inst_3] →
                        [@Module.{u_2, u_4} S M₂ inst_1 inst_5] → Type (max u_3 u_4)
```

### D315: `ContinuousLinearMap.toLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `9f9853b750cccc494240df6aaa291df7574b484c4ef82b93b35f4e8d951fb171`

Type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        {σ : RingHom R S} →
          {M : Type u_3} →
            [inst_2 : TopologicalSpace M] →
              [inst_3 : AddCommMonoid M] →
                {M₂ : Type u_4} →
                  [inst_4 : TopologicalSpace M₂] →
                    [inst_5 : AddCommMonoid M₂] →
                      [inst_6 : Module R M] → [inst_7 : Module S M₂] → ContinuousLinearMap σ M M₂ → LinearMap σ M M₂
```

Fully explicit type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring.{u_1} R] →
      [inst_1 : Semiring.{u_2} S] →
        {σ :
            @RingHom.{u_1, u_2} R S (@Semiring.toNonAssocSemiring.{u_1} R inst)
              (@Semiring.toNonAssocSemiring.{u_2} S inst_1)} →
          {M : Type u_3} →
            [inst_2 : TopologicalSpace.{u_3} M] →
              [inst_3 : AddCommMonoid.{u_3} M] →
                {M₂ : Type u_4} →
                  [inst_4 : TopologicalSpace.{u_4} M₂] →
                    [inst_5 : AddCommMonoid.{u_4} M₂] →
                      [inst_6 : @Module.{u_1, u_3} R M inst inst_3] →
                        [inst_7 : @Module.{u_2, u_4} S M₂ inst_1 inst_5] →
                          (self :
                              @ContinuousLinearMap.{u_1, u_2, u_3, u_4} R S inst inst_1 σ M inst_2 inst_3 M₂ inst_4
                                inst_5 inst_6 inst_7) →
                            @LinearMap.{u_1, u_2, u_3, u_4} R S inst inst_1 σ M M₂ inst_3 inst_5 inst_6 inst_7
```

Definition body (one-level semantic boundary):

```lean
fun R S [Semiring R] [Semiring S] σ M [TopologicalSpace M] [AddCommMonoid M] M₂ [TopologicalSpace M₂] [AddCommMonoid M₂]
    [Module R M] [Module S M₂] self =>
  self.1
```

### D316: `DFinsupp.instEquivLikeLinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.DFinsupp`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `fe0373c4e4a236db57ec78aa51496bc89dab4fb0097dc18c96c70c6df789463d`

Type:

```lean
{R : Type u_7} →
  {S : Type u_8} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        (σ : RingHom R S) →
          {σ' : RingHom S R} →
            [inst_2 : RingHomInvPair σ σ'] →
              [inst_3 : RingHomInvPair σ' σ] →
                (M : Type u_9) →
                  (M₂ : Type u_10) →
                    [inst_4 : AddCommMonoid M] →
                      [inst_5 : AddCommMonoid M₂] →
                        [inst_6 : Module R M] → [inst_7 : Module S M₂] → EquivLike (LinearEquiv σ M M₂) M M₂
```

Fully explicit type:

```lean
{R : Type u_7} →
  {S : Type u_8} →
    [inst : Semiring.{u_7} R] →
      [inst_1 : Semiring.{u_8} S] →
        (σ :
            @RingHom.{u_7, u_8} R S (@Semiring.toNonAssocSemiring.{u_7} R inst)
              (@Semiring.toNonAssocSemiring.{u_8} S inst_1)) →
          {σ' :
              @RingHom.{u_8, u_7} S R (@Semiring.toNonAssocSemiring.{u_8} S inst_1)
                (@Semiring.toNonAssocSemiring.{u_7} R inst)} →
            [inst_2 : @RingHomInvPair.{u_7, u_8} R S inst inst_1 σ σ'] →
              [inst_3 : @RingHomInvPair.{u_8, u_7} S R inst_1 inst σ' σ] →
                (M : Type u_9) →
                  (M₂ : Type u_10) →
                    [inst_4 : AddCommMonoid.{u_9} M] →
                      [inst_5 : AddCommMonoid.{u_10} M₂] →
                        [inst_6 : @Module.{u_7, u_9} R M inst inst_4] →
                          [inst_7 : @Module.{u_8, u_10} S M₂ inst_1 inst_5] →
                            EquivLike.{max (u_10 + 1) (u_9 + 1), u_9 + 1, u_10 + 1}
                              (@LinearEquiv.{u_7, u_8, u_9, u_10} R S inst inst_1 σ σ' inst_2 inst_3 M M₂ inst_4 inst_5
                                inst_6 inst_7)
                              M M₂
```

Definition body (one-level semantic boundary):

```lean
fun {R} {S} [Semiring R] [Semiring S] σ {σ'} [RingHomInvPair σ σ'] [RingHomInvPair σ' σ] M M₂ [AddCommMonoid M]
    [AddCommMonoid M₂] [Module R M] [Module S M₂] =>
  inferInstance
```

### D317: `Disjoint`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Disjoint`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D318: `EquivLike.toFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Equiv`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `0f60978070e976ff8040a5b974a5b08a27d74758a8f4361a6276a17c12a1d96a`

Type:

```lean
{E : Sort u_1} → {α : Sort u_3} → {β : Sort u_4} → [EquivLike E α β] → FunLike E α β
```

Fully explicit type:

```lean
{E : Sort u_1} → {α : Sort u_3} → {β : Sort u_4} → [EquivLike.{u_1, u_3, u_4} E α β] → FunLike.{u_1, u_3, u_4} E α β
```

Definition body (one-level semantic boundary):

```lean
fun {E} {α} {β} [inst : EquivLike E α β] => { coe := inst.coe, coe_injective' := ⋯ }
```

### D319: `HasFDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.FDeriv.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `c88b26f5f3fc2e71d02af18ecf4a0d54c0195c980c065fee932526f3a7dc8335`

Type:

```lean
{𝕜 : Type u_1} →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup E] →
        [inst_2 : Module 𝕜 E] →
          [inst_3 : TopologicalSpace E] →
            {F : Type u_3} →
              [inst_4 : AddCommGroup F] →
                [inst_5 : Module 𝕜 F] →
                  [inst_6 : TopologicalSpace F] → (E → F) → ContinuousLinearMap (RingHom.id 𝕜) E F → E → Prop
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : NontriviallyNormedField.{u_1} 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup.{u_2} E] →
        [inst_2 :
            @Module.{u_1, u_2} 𝕜 E
              (@DivisionSemiring.toSemiring.{u_1} 𝕜
                (@Semifield.toDivisionSemiring.{u_1} 𝕜
                  (@Field.toSemifield.{u_1} 𝕜
                    (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
              (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1)] →
          [inst_3 : TopologicalSpace.{u_2} E] →
            {F : Type u_3} →
              [inst_4 : AddCommGroup.{u_3} F] →
                [inst_5 :
                    @Module.{u_1, u_3} 𝕜 F
                      (@DivisionSemiring.toSemiring.{u_1} 𝕜
                        (@Semifield.toDivisionSemiring.{u_1} 𝕜
                          (@Field.toSemifield.{u_1} 𝕜
                            (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                      (@AddCommGroup.toAddCommMonoid.{u_3} F inst_4)] →
                  [inst_6 : TopologicalSpace.{u_3} F] →
                    (f : E → F) →
                      (f' :
                          @ContinuousLinearMap.{u_1, u_1, u_2, u_3} 𝕜 𝕜
                            (@DivisionSemiring.toSemiring.{u_1} 𝕜
                              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                (@Field.toSemifield.{u_1} 𝕜
                                  (@NormedField.toField.{u_1} 𝕜
                                    (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                            (@DivisionSemiring.toSemiring.{u_1} 𝕜
                              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                (@Field.toSemifield.{u_1} 𝕜
                                  (@NormedField.toField.{u_1} 𝕜
                                    (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                            (@RingHom.id.{u_1} 𝕜
                              (@Semiring.toNonAssocSemiring.{u_1} 𝕜
                                (@DivisionSemiring.toSemiring.{u_1} 𝕜
                                  (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                    (@Field.toSemifield.{u_1} 𝕜
                                      (@NormedField.toField.{u_1} 𝕜
                                        (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))))
                            E inst_3 (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) F inst_6
                            (@AddCommGroup.toAddCommMonoid.{u_3} F inst_4) inst_2 inst_5) →
                        (x : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NontriviallyNormedField 𝕜] {E} [AddCommGroup E] [Module 𝕜 E] [TopologicalSpace E] {F} [AddCommGroup F]
    [Module 𝕜 F] [TopologicalSpace F] f f' x =>
  HasFDerivAtFilter f f' (Filter.instSProd.sprod (nhds x) (Filter.instPure.pure x))
```

### D320: `HeytingAlgebra.toOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Heyting.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D321: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D322: `LinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Equiv.Defs`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `6a1e194e5e1f3458fc29174b3ebc7e52b4b228d4e72f70b8b3129d5a513816a3`

Type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        (σ : RingHom R S) →
          {σ' : RingHom S R} →
            [RingHomInvPair σ σ'] →
              [RingHomInvPair σ' σ] →
                (M : Type u_16) →
                  (M₂ : Type u_17) →
                    [inst_4 : AddCommMonoid M] →
                      [inst_5 : AddCommMonoid M₂] → [Module R M] → [Module S M₂] → Type (max u_16 u_17)
```

Fully explicit type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring.{u_14} R] →
      [inst_1 : Semiring.{u_15} S] →
        (σ :
            @RingHom.{u_14, u_15} R S (@Semiring.toNonAssocSemiring.{u_14} R inst)
              (@Semiring.toNonAssocSemiring.{u_15} S inst_1)) →
          {σ' :
              @RingHom.{u_15, u_14} S R (@Semiring.toNonAssocSemiring.{u_15} S inst_1)
                (@Semiring.toNonAssocSemiring.{u_14} R inst)} →
            [@RingHomInvPair.{u_14, u_15} R S inst inst_1 σ σ'] →
              [@RingHomInvPair.{u_15, u_14} S R inst_1 inst σ' σ] →
                (M : Type u_16) →
                  (M₂ : Type u_17) →
                    [inst_4 : AddCommMonoid.{u_16} M] →
                      [inst_5 : AddCommMonoid.{u_17} M₂] →
                        [@Module.{u_14, u_16} R M inst inst_4] →
                          [@Module.{u_15, u_17} S M₂ inst_1 inst_5] → Type (max u_16 u_17)
```

### D323: `LinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `4d6a16b4507b37ff97503f46684751acdb916a859224b68a1c2a8b68af63e31c`

Type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        RingHom R S →
          (M : Type u_16) →
            (M₂ : Type u_17) →
              [inst_2 : AddCommMonoid M] →
                [inst_3 : AddCommMonoid M₂] → [Module R M] → [Module S M₂] → Type (max u_16 u_17)
```

Fully explicit type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring.{u_14} R] →
      [inst_1 : Semiring.{u_15} S] →
        (σ :
            @RingHom.{u_14, u_15} R S (@Semiring.toNonAssocSemiring.{u_14} R inst)
              (@Semiring.toNonAssocSemiring.{u_15} S inst_1)) →
          (M : Type u_16) →
            (M₂ : Type u_17) →
              [inst_2 : AddCommMonoid.{u_16} M] →
                [inst_3 : AddCommMonoid.{u_17} M₂] →
                  [@Module.{u_14, u_16} R M inst inst_2] →
                    [@Module.{u_15, u_17} S M₂ inst_1 inst_3] → Type (max u_16 u_17)
```

### D324: `LinearMap.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `ab4e5f87ffe446bf4b1a818669f80f82d003b1d88bffa60d6568767a5b492e76`

Type:

```lean
{R₁ : Type u_2} →
  {R₂ : Type u_3} →
    {M : Type u_8} →
      {M₂ : Type u_10} →
        [inst : Semiring R₁] →
          [inst_1 : Semiring R₂] →
            [inst_2 : AddCommMonoid M] →
              [inst_3 : AddCommMonoid M₂] →
                [inst_4 : Module R₁ M] →
                  [inst_5 : Module R₂ M₂] → {σ₁₂ : RingHom R₁ R₂} → AddCommMonoid (LinearMap σ₁₂ M M₂)
```

Fully explicit type:

```lean
{R₁ : Type u_2} →
  {R₂ : Type u_3} →
    {M : Type u_8} →
      {M₂ : Type u_10} →
        [inst : Semiring.{u_2} R₁] →
          [inst_1 : Semiring.{u_3} R₂] →
            [inst_2 : AddCommMonoid.{u_8} M] →
              [inst_3 : AddCommMonoid.{u_10} M₂] →
                [inst_4 : @Module.{u_2, u_8} R₁ M inst inst_2] →
                  [inst_5 : @Module.{u_3, u_10} R₂ M₂ inst_1 inst_3] →
                    {σ₁₂ :
                        @RingHom.{u_2, u_3} R₁ R₂ (@Semiring.toNonAssocSemiring.{u_2} R₁ inst)
                          (@Semiring.toNonAssocSemiring.{u_3} R₂ inst_1)} →
                      AddCommMonoid.{max u_10 u_8}
                        (@LinearMap.{u_2, u_3, u_8, u_10} R₁ R₂ inst inst_1 σ₁₂ M M₂ inst_2 inst_3 inst_4 inst_5)
```

Definition body (one-level semantic boundary):

```lean
fun {R₁} {R₂} {M} {M₂} [Semiring R₁] [Semiring R₂] [AddCommMonoid M] [AddCommMonoid M₂] [Module R₁ M] [Module R₂ M₂]
    {σ₁₂} =>
  Function.Injective.addCommMonoid (fun f => LinearMap.instFunLike.coe f) ⋯ ⋯ ⋯ ⋯
```

### D325: `LinearMap.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `017b40e990cc84887be863ba33792de76923fe3ca657329d8c9158a2e880ffee`

Type:

```lean
{R : Type u_1} →
  {R₂ : Type u_3} →
    {S : Type u_5} →
      {M : Type u_8} →
        {M₂ : Type u_10} →
          [inst : Semiring R] →
            [inst_1 : Semiring R₂] →
              [inst_2 : AddCommMonoid M] →
                [inst_3 : AddCommMonoid M₂] →
                  [inst_4 : Module R M] →
                    [inst_5 : Module R₂ M₂] →
                      {σ₁₂ : RingHom R R₂} →
                        [inst_6 : Semiring S] →
                          [inst_7 : Module S M₂] → [SMulCommClass R₂ S M₂] → Module S (LinearMap σ₁₂ M M₂)
```

Fully explicit type:

```lean
{R : Type u_1} →
  {R₂ : Type u_3} →
    {S : Type u_5} →
      {M : Type u_8} →
        {M₂ : Type u_10} →
          [inst : Semiring.{u_1} R] →
            [inst_1 : Semiring.{u_3} R₂] →
              [inst_2 : AddCommMonoid.{u_8} M] →
                [inst_3 : AddCommMonoid.{u_10} M₂] →
                  [inst_4 : @Module.{u_1, u_8} R M inst inst_2] →
                    [inst_5 : @Module.{u_3, u_10} R₂ M₂ inst_1 inst_3] →
                      {σ₁₂ :
                          @RingHom.{u_1, u_3} R R₂ (@Semiring.toNonAssocSemiring.{u_1} R inst)
                            (@Semiring.toNonAssocSemiring.{u_3} R₂ inst_1)} →
                        [inst_6 : Semiring.{u_5} S] →
                          [inst_7 : @Module.{u_5, u_10} S M₂ inst_6 inst_3] →
                            [@SMulCommClass.{u_3, u_5, u_10} R₂ S M₂
                                  (@SMulZeroClass.toSMul.{u_3, u_10} R₂ M₂
                                    (@AddZero.toZero.{u_10} M₂
                                      (@AddZeroClass.toAddZero.{u_10} M₂
                                        (@AddMonoid.toAddZeroClass.{u_10} M₂
                                          (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3))))
                                    (@DistribSMul.toSMulZeroClass.{u_3, u_10} R₂ M₂
                                      (@AddMonoid.toAddZeroClass.{u_10} M₂
                                        (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3))
                                      (@DistribMulAction.toDistribSMul.{u_3, u_10} R₂ M₂
                                        (@MonoidWithZero.toMonoid.{u_3} R₂ (@Semiring.toMonoidWithZero.{u_3} R₂ inst_1))
                                        (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3)
                                        (@Module.toDistribMulAction.{u_3, u_10} R₂ M₂ inst_1 inst_3 inst_5))))
                                  (@SMulZeroClass.toSMul.{u_5, u_10} S M₂
                                    (@AddZero.toZero.{u_10} M₂
                                      (@AddZeroClass.toAddZero.{u_10} M₂
                                        (@AddMonoid.toAddZeroClass.{u_10} M₂
                                          (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3))))
                                    (@DistribSMul.toSMulZeroClass.{u_5, u_10} S M₂
                                      (@AddMonoid.toAddZeroClass.{u_10} M₂
                                        (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3))
                                      (@DistribMulAction.toDistribSMul.{u_5, u_10} S M₂
                                        (@MonoidWithZero.toMonoid.{u_5} S (@Semiring.toMonoidWithZero.{u_5} S inst_6))
                                        (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3)
                                        (@Module.toDistribMulAction.{u_5, u_10} S M₂ inst_6 inst_3 inst_7))))] →
                              @Module.{u_5, max u_10 u_8} S
                                (@LinearMap.{u_1, u_3, u_8, u_10} R R₂ inst inst_1 σ₁₂ M M₂ inst_2 inst_3 inst_4 inst_5)
                                inst_6
                                (@LinearMap.addCommMonoid.{u_1, u_3, u_8, u_10} R R₂ M M₂ inst inst_1 inst_2 inst_3
                                  inst_4 inst_5 σ₁₂)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {R₂} {S} {M} {M₂} [Semiring R] [Semiring R₂] [AddCommMonoid M] [AddCommMonoid M₂] [Module R M] [Module R₂ M₂]
    {σ₁₂} [Semiring S] [Module S M₂] [SMulCommClass R₂ S M₂] =>
  { toDistribMulAction := LinearMap.instDistribMulAction, add_smul := ⋯, zero_smul := ⋯ }
```

### D326: `LinearMap.toMatrix'`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.ToLin`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `e6a54896ef32827c20d64677b2bde29030c3fcd47def618d946669e8a97f5747`

Type:

```lean
{R : Type u_1} →
  [inst : CommSemiring R] →
    {m : Type u_4} →
      {n : Type u_5} →
        [DecidableEq n] →
          [Fintype n] → LinearEquiv (RingHom.id R) (LinearMap (RingHom.id R) (n → R) (m → R)) (Matrix m n R)
```

Fully explicit type:

```lean
{R : Type u_1} →
  [inst : CommSemiring.{u_1} R] →
    {m : Type u_4} →
      {n : Type u_5} →
        [DecidableEq.{u_5 + 1} n] →
          [Fintype.{u_5} n] →
            @LinearEquiv.{u_1, u_1, max (max u_1 u_4) u_1 u_5, max (max u_1 u_5) u_4} R R
              (@CommSemiring.toSemiring.{u_1} R inst) (@CommSemiring.toSemiring.{u_1} R inst)
              (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
              (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
              (@RingHomInvPair.ids.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))
              (@RingHomInvPair.ids.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))
              (@LinearMap.{u_1, u_1, max u_1 u_5, max u_1 u_4} R R (@CommSemiring.toSemiring.{u_1} R inst)
                (@CommSemiring.toSemiring.{u_1} R inst)
                (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (n → R) (m → R)
                (@Pi.addCommMonoid.{u_5, u_1} n (fun (a : n) => R) fun (i : n) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.addCommMonoid.{u_4, u_1} m (fun (a : m) => R) fun (i : m) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.Function.module.{u_5, u_1, u_1} n R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@Pi.Function.module.{u_4, u_1, u_1} m R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
              (Matrix.{u_4, u_5, u_1} m n R)
              (@LinearMap.addCommMonoid.{u_1, u_1, max u_1 u_5, max u_1 u_4} R R (n → R) (m → R)
                (@CommSemiring.toSemiring.{u_1} R inst) (@CommSemiring.toSemiring.{u_1} R inst)
                (@Pi.addCommMonoid.{u_5, u_1} n (fun (a : n) => R) fun (i : n) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.addCommMonoid.{u_4, u_1} m (fun (a : m) => R) fun (i : m) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.Function.module.{u_5, u_1, u_1} n R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@Pi.Function.module.{u_4, u_1, u_1} m R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
              (@Matrix.addCommMonoid.{u_1, u_4, u_5} m n R
                (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                  (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                    (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))))
              (@LinearMap.module.{u_1, u_1, u_1, max u_1 u_5, max u_1 u_4} R R R (n → R) (m → R)
                (@CommSemiring.toSemiring.{u_1} R inst) (@CommSemiring.toSemiring.{u_1} R inst)
                (@Pi.addCommMonoid.{u_5, u_1} n (fun (a : n) => R) fun (i : n) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.addCommMonoid.{u_4, u_1} m (fun (a : m) => R) fun (i : m) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.Function.module.{u_5, u_1, u_1} n R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@Pi.Function.module.{u_4, u_1, u_1} m R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@CommSemiring.toSemiring.{u_1} R inst)
                (@Pi.Function.module.{u_4, u_1, u_1} m R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@Function.smulCommClass.{u_4, u_1, u_1, u_1} m R R R
                  (@SemigroupAction.toSMul.{u_1, u_1} R R
                    (@Monoid.toSemigroup.{u_1} R
                      (@MonoidWithZero.toMonoid.{u_1} R
                        (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                    (@MulAction.toSemigroupAction.{u_1, u_1} R R
                      (@MonoidWithZero.toMonoid.{u_1} R
                        (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                      (@DistribMulAction.toMulAction.{u_1, u_1} R R
                        (@MonoidWithZero.toMonoid.{u_1} R
                          (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                        (@AddCommMonoid.toAddMonoid.{u_1} R
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                              (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))))
                        (@Module.toDistribMulAction.{u_1, u_1} R R (@CommSemiring.toSemiring.{u_1} R inst)
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                              (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                          (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))))
                  (@SemigroupAction.toSMul.{u_1, u_1} R R
                    (@Monoid.toSemigroup.{u_1} R
                      (@MonoidWithZero.toMonoid.{u_1} R
                        (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                    (@MulAction.toSemigroupAction.{u_1, u_1} R R
                      (@MonoidWithZero.toMonoid.{u_1} R
                        (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                      (@DistribMulAction.toMulAction.{u_1, u_1} R R
                        (@MonoidWithZero.toMonoid.{u_1} R
                          (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                        (@AddCommMonoid.toAddMonoid.{u_1} R
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                              (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))))
                        (@Module.toDistribMulAction.{u_1, u_1} R R (@CommSemiring.toSemiring.{u_1} R inst)
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                              (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                          (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))))
                  (@Algebra.to_smulCommClass.{u_1, u_1} R R inst (@CommSemiring.toSemiring.{u_1} R inst)
                    (@Algebra.id.{u_1} R inst))))
              (@Matrix.module.{u_1, u_4, u_5, u_1} m n R R (@CommSemiring.toSemiring.{u_1} R inst)
                (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                  (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                    (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
```

Definition body (one-level semantic boundary):

```lean
fun {R} [CommSemiring R] {m} {n} [DecidableEq n] [Fintype n] =>
  { toFun := fun f => EquivLike.toFunLike.coe Matrix.of fun i j => LinearMap.instFunLike.coe f (Pi.single j 1) i,
    map_add' := ⋯, map_smul' := ⋯, invFun := Matrix.mulVecLin, left_inv := ⋯, right_inv := ⋯ }
```

### D327: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Type:

```lean
Type u → Type u' → Type v → Type (max u u' v)
```

Fully explicit type:

```lean
(m : Type u) → (n : Type u') → (α : Type v) → Type (max u u' v)
```

Definition body (one-level semantic boundary):

```lean
fun m n α => m → n → α
```

### D328: `Matrix.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `6b893d81bc298230772e16cd0c8ddf7d2638ac0d6127094b06a1290d88f8c3ae`

Type:

```lean
{m : Type u_2} → {n : Type u_3} → {α : Type v} → [AddCommMonoid α] → AddCommMonoid (Matrix m n α)
```

Fully explicit type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {α : Type v} → [AddCommMonoid.{v} α] → AddCommMonoid.{max (max v u_3) u_2} (Matrix.{u_2, u_3, v} m n α)
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {α} [AddCommMonoid α] => Pi.addCommMonoid
```

### D329: `Matrix.module`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `4fdec58292003fac825b4ffe1900f940d4ef3c8d02e84e23484d4b31f8742856`

Type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {R : Type u_7} →
      {α : Type v} → [inst : Semiring R] → [inst_1 : AddCommMonoid α] → [Module R α] → Module R (Matrix m n α)
```

Fully explicit type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {R : Type u_7} →
      {α : Type v} →
        [inst : Semiring.{u_7} R] →
          [inst_1 : AddCommMonoid.{v} α] →
            [@Module.{u_7, v} R α inst inst_1] →
              @Module.{u_7, max (max v u_3) u_2} R (Matrix.{u_2, u_3, v} m n α) inst
                (@Matrix.addCommMonoid.{v, u_2, u_3} m n α inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {R} {α} [Semiring R] [AddCommMonoid α] [Module R α] => Pi.module m (fun a => n → α) R
```

### D330: `MeasurableSet`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D331: `NonAssocSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `1674e66231d0f66dfe9fae191c7ae33207a78635bcf5490a9cfbb402d16f9bc0`

Type:

```lean
{α : Type u} → [self : NonAssocSemiring α] → NonUnitalNonAssocSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonAssocSemiring.{u} α] → NonUnitalNonAssocSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonAssocSemiring α] => self.1
```

### D332: `Nonempty`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `37c79de378d44cb9dc334502b161bb140da0544579086aded2cf83ff99c462c7`

Type:

```lean
Sort u → Prop
```

Fully explicit type:

```lean
(α : Sort u) → Prop
```

### D333: `OmegaCompletePartialOrder.toPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D334: `Order.Frame.toHeytingAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D335: `RingHom.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Hom.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `a6f90353b229eb95293a3c089ae20ade7711021afe852d8f78a4f79577dab479`

Type:

```lean
(α : Type u_5) → [inst : NonAssocSemiring α] → RingHom α α
```

Fully explicit type:

```lean
(α : Type u_5) → [inst : NonAssocSemiring.{u_5} α] → @RingHom.{u_5, u_5} α α inst inst
```

Definition body (one-level semantic boundary):

```lean
fun α [NonAssocSemiring α] => { toFun := id, map_one' := ⋯, map_mul' := ⋯, map_zero' := ⋯, map_add' := ⋯ }
```

### D336: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `ff102bae4edee1f1bb819368914caf0ac2ec810b7e80210cd357fd643729a472`

Type:

```lean
{R : Type u_1} → [inst : Semiring R] → Module R R
```

Fully explicit type:

```lean
{R : Type u_1} →
  [inst : Semiring.{u_1} R] →
    @Module.{u_1, u_1} R R inst
      (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
        (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R inst)))
```

Definition body (one-level semantic boundary):

```lean
fun {R} [Semiring R] =>
  { toMulAction := (MonoidWithZero.toMulActionWithZero R).toMulAction, smul_zero := ⋯, smul_add := ⋯, add_smul := ⋯,
    zero_smul := ⋯ }
```

### D337: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `33076e5ce1b65d0dacdacdea942f424abbe54f3ff639c158f37c0f533984f227`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonAssocSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : Semiring.{u} α] → NonAssocSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toNonUnitalNonAssocSemiring := self.toNonUnitalNonAssocSemiring, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯,
    toNatCast := self.toNatCast, natCast_zero := ⋯, natCast_succ := ⋯ }
```

### D338: `Set.instCompleteAtomicBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.BooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D339: `instDecidableEqFin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `7f6d785554f797d18d5ae0b7475c25e8deca421e6ee688f036987ac99c66e1cd`

Type:

```lean
(n : Nat) → DecidableEq (Fin n)
```

Fully explicit type:

```lean
(n : Nat) → DecidableEq.{1} (Fin n)
```

Definition body (one-level semantic boundary):

```lean
fun n i j =>
  instDecidableEqFin.match_1 n i j (fun x => Decidable (Eq i j)) (decEq i.val j.val) (fun h => Decidable.isTrue ⋯)
    fun h => Decidable.isFalse ⋯
```

### D340: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `98c22aec54da8e2278fb6c5ae1daeffb76abd7bad320de72096bec6a7046bc17`

Type:

```lean
{M : Type u} → [self : AddCommMonoid M] → AddMonoid M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddCommMonoid.{u} M] → AddMonoid.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddCommMonoid M] => self.1
```

### D341: `CommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `1c9ac43c2f2e02a3e345036ace32d209b04abe0516407e31bcb54ee4c7201d0d`

Type:

```lean
{α : Type u} → [s : CommRing α] → NonUnitalCommRing α
```

Fully explicit type:

```lean
{α : Type u} → [s : CommRing.{u} α] → NonUnitalCommRing.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [s : CommRing α] =>
  { toAddMonoid := s.toAddMonoid, toNeg := s.toNeg, toSub := s.toSub, sub_eq_add_neg := ⋯, zsmul := s.zsmul,
    zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯, toMul := s.toMul,
    left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯, mul_comm := ⋯ }
```

### D342: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `ea6124156f152313d3298dd94738351217f9626c6fc23cb2b63efa1528a4f9b9`

Type:

```lean
{M : Type u_12} →
  {A : Type u_13} → {inst : Monoid M} → {inst_1 : AddMonoid A} → [self : DistribMulAction M A] → MulAction M A
```

Fully explicit type:

```lean
{M : Type u_12} →
  {A : Type u_13} →
    {inst : Monoid.{u_12} M} →
      {inst_1 : AddMonoid.{u_13} A} →
        [self : @DistribMulAction.{u_12, u_13} M A inst inst_1] → @MulAction.{u_12, u_13} M A inst
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} {inst_1} [self : DistribMulAction M A] => self.1
```

### D343: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `715de3f0bd9e7bcf034726e1efbf1b4dad42a16e2ce790d4403774d16ed5b549`

Type:

```lean
{m : Type u_2} →
  {n : Type u_3} → {α : Type v} → [NonUnitalNonAssocSemiring α] → [Fintype n] → Matrix m n α → (n → α) → m → α
```

Fully explicit type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {α : Type v} →
      [NonUnitalNonAssocSemiring.{v} α] → [Fintype.{u_3} n] → (M : Matrix.{u_2, u_3, v} m n α) → (v : n → α) → m → α
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {α} [NonUnitalNonAssocSemiring α] [Fintype n] M v x =>
  have i := x;
  dotProduct (fun j => M i j) v
```

### D344: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `6`
- Semantic SHA-256: `91ccb83aac9752d74388b4b5edfdf55080a7f53ae5fb386c8f8ffab46ed2ceab`

Type:

```lean
Type u_1 →
  (R : Type u_3) →
    (M : Type u_6) → [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [Module R M] → Type (max (max u_1 u_3) u_6)
```

Fully explicit type:

```lean
(ι : Type u_1) →
  (R : Type u_3) →
    (M : Type u_6) →
      [inst : Semiring.{u_3} R] →
        [inst_1 : AddCommMonoid.{u_6} M] → [@Module.{u_3, u_6} R M inst inst_1] → Type (max (max u_1 u_3) u_6)
```

### D345: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `09f2e6b4c6d86c2bb88f692b220637928f7ce01a1c3f043a706fedea853492be`

Type:

```lean
{ι : Type u_1} →
  {R : Type u_3} →
    {M : Type u_6} →
      [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [inst_2 : Module R M] → FunLike (Module.Basis ι R M) ι M
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {R : Type u_3} →
    {M : Type u_6} →
      [inst : Semiring.{u_3} R] →
        [inst_1 : AddCommMonoid.{u_6} M] →
          [inst_2 : @Module.{u_3, u_6} R M inst inst_1] →
            FunLike.{max (max (u_6 + 1) (u_3 + 1)) (u_1 + 1), u_1 + 1, u_6 + 1}
              (@Module.Basis.{u_1, u_3, u_6} ι R M inst inst_1 inst_2) ι M
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {R} {M} [Semiring R] [AddCommMonoid M] [Module R M] =>
  { coe := fun b i => EquivLike.toFunLike.coe b.repr.symm (Finsupp.single i 1), coe_injective' := ⋯ }
```

### D346: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `136930a747dcd73895587cb4c7ea1df27360fed0a4adb57efb71bb8949f0fa71`

Type:

```lean
{M : Type u} → [self : Monoid M] → Semigroup M
```

Fully explicit type:

```lean
{M : Type u} → [self : Monoid.{u} M] → Semigroup.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : Monoid M] => self.1
```

### D347: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Type:

```lean
{M₀ : Type u} → [self : MonoidWithZero M₀] → Monoid M₀
```

Fully explicit type:

```lean
{M₀ : Type u} → [self : MonoidWithZero.{u} M₀] → Monoid.{u} M₀
```

Definition body (one-level semantic boundary):

```lean
fun M₀ [self : MonoidWithZero M₀] => self.1
```

### D348: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `2a4074e38a7cedd1ecdaf86a42d3be01ad9728988610178bf9a698f57a876516`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Monoid α} → [self : MulAction α β] → SemigroupAction α β
```

Fully explicit type:

```lean
{α : Type u_9} →
  {β : Type u_10} →
    {inst : Monoid.{u_9} α} →
      [self : @MulAction.{u_9, u_10} α β inst] → @SemigroupAction.{u_9, u_10} α β (@Monoid.toSemigroup.{u_9} α inst)
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : MulAction α β] => self.1
```

### D349: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Type:

```lean
{α : Type u} → [self : NonUnitalCommRing α] → NonUnitalNonAssocCommRing α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalCommRing.{u} α] → NonUnitalNonAssocCommRing.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalNonAssocRing := self.toNonUnitalNonAssocRing, mul_comm := ⋯ }
```

### D350: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing α] → NonUnitalNonAssocRing α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing.{u} α] → NonUnitalNonAssocRing.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocCommRing α] => self.1
```

### D351: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocRing α] → NonUnitalNonAssocSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocRing.{u} α] → NonUnitalNonAssocSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toAddMonoid := self.toAddMonoid, add_comm := ⋯, toMul := self.toMul, left_distrib := ⋯, right_distrib := ⋯,
    zero_mul := ⋯, mul_zero := ⋯ }
```

### D352: `Real.commRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `da00a22f1d267a99bad32236c81af717f9f20a554bd227178f282f3393d64a7e`

Type:

```lean
CommRing Real
```

Fully explicit type:

```lean
CommRing.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toAdd := Real.instAdd, add_assoc := ⋯, toZero := Real.instZero, zero_add := ⋯, add_zero := ⋯, nsmul := nsmulRec,
  nsmul_zero := Real.commRing._proof_4, nsmul_succ := Real.commRing._proof_5, add_comm := ⋯, toMul := Real.instMul,
  left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯, toOne := Real.instOne,
  one_mul := ⋯, mul_one := ⋯, natCast := fun n => { cauchy := n.cast }, natCast_zero := Real.commRing._proof_14,
  natCast_succ := ⋯, npow := npowRec, npow_zero := Real.commRing._proof_16, npow_succ := Real.commRing._proof_17,
  toNeg := Real.instNeg, toSub := Real.instSub, sub_eq_add_neg := Real.commRing._proof_18, zsmul := zsmulRec,
  zsmul_zero' := Real.commRing._proof_19, zsmul_succ' := Real.commRing._proof_20, zsmul_neg' := Real.commRing._proof_21,
  neg_add_cancel := ⋯, intCast := fun z => { cauchy := z.cast }, intCast_ofNat := Real.commRing._proof_23,
  intCast_negSucc := ⋯, mul_comm := ⋯ }
```

### D353: `RingHomInvPair`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.CompTypeclasses`
- Declaration kind: `inductive`
- Distance from target type: `6`
- Semantic SHA-256: `eba5e79959e8652c489365b8e4a0a1562cfc528d141ca51502769b8b6f807ad9`

Type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} → [inst : Semiring R₁] → [inst_1 : Semiring R₂] → RingHom R₁ R₂ → outParam (RingHom R₂ R₁) → Prop
```

Fully explicit type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} →
    [inst : Semiring.{u_1} R₁] →
      [inst_1 : Semiring.{u_2} R₂] →
        (σ :
            @RingHom.{u_1, u_2} R₁ R₂ (@Semiring.toNonAssocSemiring.{u_1} R₁ inst)
              (@Semiring.toNonAssocSemiring.{u_2} R₂ inst_1)) →
          (σ' :
              outParam.{max (u_1 + 1) (u_2 + 1)}
                (@RingHom.{u_2, u_1} R₂ R₁ (@Semiring.toNonAssocSemiring.{u_2} R₂ inst_1)
                  (@Semiring.toNonAssocSemiring.{u_1} R₁ inst))) →
            Prop
```

### D354: `SMulCommClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `inductive`
- Distance from target type: `6`
- Semantic SHA-256: `25ca5b6e5618ba5262412f36bda1bf0ec64f56ca37162dc1ff3be3719f8983c5`

Type:

```lean
(M : Type u_9) → (N : Type u_10) → (α : Type u_11) → [SMul M α] → [SMul N α] → Prop
```

Fully explicit type:

```lean
(M : Type u_9) → (N : Type u_10) → (α : Type u_11) → [SMul.{u_9, u_11} M α] → [SMul.{u_10, u_11} N α] → Prop
```

### D355: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `5a8783c66a2e56a4cc509bbb0651eda5b66e25c197307a42445cac31c4a4bb6c`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Semigroup α} → [self : SemigroupAction α β] → SMul α β
```

Fully explicit type:

```lean
{α : Type u_9} →
  {β : Type u_10} → {inst : Semigroup.{u_9} α} → [self : @SemigroupAction.{u_9, u_10} α β inst] → SMul.{u_9, u_10} α β
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : SemigroupAction α β] => self.1
```

### D356: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Type:

```lean
{α : Type u} → [self : Semiring α] → MonoidWithZero α
```

Fully explicit type:

```lean
{α : Type u} → [self : Semiring.{u} α] → MonoidWithZero.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toMul := self.toMul, mul_assoc := ⋯, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯, npow := self.npow,
    npow_zero := ⋯, npow_succ := ⋯, toZero := self.toZero, zero_mul := ⋯, mul_zero := ⋯ }
```
