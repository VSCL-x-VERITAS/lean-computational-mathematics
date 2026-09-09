# Declaration dossier for LEV-CH01-COORDINATE-DIRECTIONAL-METHODS-INTERPRETED-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_coordinateDirectionalMethods_sourceContract
    {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] [Fintype D]
    (data : PhysicalData D Point FacePoint m)
    (hdimension : 0 < m)
    (rule : D → Cell → ℝ → (ℤ → State) → State)
    (admitted : D → Cell → ℝ → (ℤ → State) → Prop)
    (hconstant : ∀ d cell dt value, 0 < dt → value ∈ data.admissibleStates d →
      admitted d cell dt (fun _ => value) →
      Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell)
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hpositive : ∀ stage ∈ stages, 0 < stage.2)
    (initial : Cell → State)
    (reference : List (D × ℝ) → D → ℝ → Point → ℝ → State)
    (oldError faceError : List (D × ℝ) → D → ℝ → Cell → ℝ)
    (hreferences : ∀ before d dt after, stages = before ++ (d, dt) :: after →
      data.ReferenceOn d (reference before d dt) 0 dt)
    (hadmitted : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      admitted d cell dt (fun j => CoordinateLineBalance.sweep data.cellVolume rule before initial
        (Function.update cell d j)))
    (hstates : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      CoordinateLineBalance.sweep data.cellVolume rule before initial cell ∈ data.admissibleStates d)
    (hold : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.sweep data.cellVolume rule before initial cell -
        data.cellMean (reference before d dt) cell 0‖ ≤ oldError before d dt cell)
    (hface : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.normalFaceFlux rule d dt
          (CoordinateLineBalance.sweep data.cellVolume rule before initial) cell -
        faceAverage (data.faceFlux d (reference before d dt)) 0 dt cell‖ ≤ faceError before d dt cell) :
    0 < m ∧
    (∀ d cell point, IsHyperbolicFluxOn (data.normalFlux d cell point) (data.admissibleStates d)) ∧
    (∀ d cell dt value, 0 < dt → value ∈ data.admissibleStates d →
      admitted d cell dt (fun _ => value) →
      Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell) ∧
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current
```

## Elaborated target type

```lean
∀ {D : Type u_1} [inst : DecidableEq D] {m : Nat} {Point : Type u_2} {FacePoint : Type u_3}
  [inst_1 : MeasurableSpace Point] [inst_2 : TopologicalSpace Point] [inst_3 : MeasurableSpace FacePoint]
  [inst_4 : Fintype D] (data : NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m),
  instLTNat.lt 0 m →
    ∀ (rule : D → (D → Int) → Real → (Int → Fin m → Real) → Fin m → Real)
      (admitted : D → (D → Int) → Real → (Int → Fin m → Real) → Prop),
      (∀ (d : D) (cell : D → Int) (dt : Real) (value : Fin m → Real),
          Real.instLT.lt 0 dt →
            Set.instMembership.mem (data.admissibleStates d) value →
              (admitted d cell dt fun x => value) →
                And
                  (MeasureTheory.Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell))
                  (Eq (rule d cell dt fun x => value)
                    (MeasureTheory.integral (data.faceMeasure d cell) fun point =>
                      data.normalFlux d cell point value))) →
        ∀ (stages : List (Prod D Real)),
          Ne stages List.nil →
            (∀ (d : D), Exists fun dt => List.instMembership.mem stages { fst := d, snd := dt }) →
              (∀ (stage : Prod D Real), List.instMembership.mem stages stage → Real.instLT.lt 0 stage.snd) →
                ∀ (initial : (D → Int) → Fin m → Real)
                  (reference : List (Prod D Real) → D → Real → Point → Real → Fin m → Real)
                  (oldError faceError : List (Prod D Real) → D → Real → (D → Int) → Real),
                  (∀ (before : List (Prod D Real)) (d : D) (dt : Real) (after : List (Prod D Real)),
                      Eq stages (instHAppendOfAppend.hAppend before (List.cons { fst := d, snd := dt } after)) →
                        data.ReferenceOn d (reference before d dt) 0 dt) →
                    (∀ (before : List (Prod D Real)) (d : D) (dt : Real) (after : List (Prod D Real)),
                        Eq stages (instHAppendOfAppend.hAppend before (List.cons { fst := d, snd := dt } after)) →
                          ∀ (cell : D → Int),
                            admitted d cell dt fun j =>
                              NumStability.CoordinateLineBalance.sweep data.cellVolume rule before initial
                                (Function.update cell d j)) →
                      (∀ (before : List (Prod D Real)) (d : D) (dt : Real) (after : List (Prod D Real)),
                          Eq stages (instHAppendOfAppend.hAppend before (List.cons { fst := d, snd := dt } after)) →
                            ∀ (cell : D → Int),
                              Set.instMembership.mem (data.admissibleStates d)
                                (NumStability.CoordinateLineBalance.sweep data.cellVolume rule before initial cell)) →
                        (∀ (before : List (Prod D Real)) (d : D) (dt : Real) (after : List (Prod D Real)),
                            Eq stages (instHAppendOfAppend.hAppend before (List.cons { fst := d, snd := dt } after)) →
                              ∀ (cell : D → Int),
                                Real.instLE.le
                                  (Pi.normedRing.norm
                                    (instHSub.hSub
                                      (NumStability.CoordinateLineBalance.sweep data.cellVolume rule before initial
                                        cell)
                                      (data.cellMean (reference before d dt) cell 0)))
                                  (oldError before d dt cell)) →
                          (∀ (before : List (Prod D Real)) (d : D) (dt : Real) (after : List (Prod D Real)),
                              Eq stages (instHAppendOfAppend.hAppend before (List.cons { fst := d, snd := dt } after)) →
                                ∀ (cell : D → Int),
                                  Real.instLE.le
                                    (Pi.normedRing.norm
                                      (instHSub.hSub
                                        (NumStability.CoordinateLineBalance.normalFaceFlux rule d dt
                                          (NumStability.CoordinateLineBalance.sweep data.cellVolume rule before initial)
                                          cell)
                                        (NumStability.DirectionalFiniteVolume.faceAverage
                                          (data.faceFlux d (reference before d dt)) 0 dt cell)))
                                    (faceError before d dt cell)) →
                            And (instLTNat.lt 0 m)
                              (And
                                (∀ (d : D) (cell : D → Int) (point : FacePoint),
                                  NumStability.IsHyperbolicFluxOn (data.normalFlux d cell point)
                                    (data.admissibleStates d))
                                (And
                                  (∀ (d : D) (cell : D → Int) (dt : Real) (value : Fin m → Real),
                                    Real.instLT.lt 0 dt →
                                      Set.instMembership.mem (data.admissibleStates d) value →
                                        (admitted d cell dt fun x => value) →
                                          And
                                            (MeasureTheory.Integrable (fun point => data.normalFlux d cell point value)
                                              (data.faceMeasure d cell))
                                            (Eq (rule d cell dt fun x => value)
                                              (MeasureTheory.integral (data.faceMeasure d cell) fun point =>
                                                data.normalFlux d cell point value)))
                                  (And (Ne stages List.nil)
                                    (And
                                      (∀ (d : D),
                                        Exists fun dt => List.instMembership.mem stages { fst := d, snd := dt })
                                      (And
                                        (∀ (before : List (Prod D Real)) (d : D) (dt : Real)
                                          (after : List (Prod D Real)),
                                          Eq stages
                                              (instHAppendOfAppend.hAppend before
                                                (List.cons { fst := d, snd := dt } after)) →
                                            have current :=
                                              NumStability.CoordinateLineBalance.sweep data.cellVolume rule before
                                                initial;
                                            And (Real.instLT.lt 0 dt)
                                              (And (data.ReferenceOn d (reference before d dt) 0 dt)
                                                (And
                                                  (∀ (cell : D → Int),
                                                    admitted d cell dt fun j => current (Function.update cell d j))
                                                  (And
                                                    (∀ (cell : D → Int),
                                                      Set.instMembership.mem (data.admissibleStates d) (current cell))
                                                    (And
                                                      (Eq
                                                        (NumStability.CoordinateLineBalance.sweep data.cellVolume rule
                                                          stages initial)
                                                        (NumStability.CoordinateLineBalance.sweep data.cellVolume rule
                                                          after
                                                          (NumStability.CoordinateLineBalance.advance data.cellVolume
                                                            rule d dt current)))
                                                      (And
                                                        (∀ (cell : D → Int),
                                                          Eq
                                                            (instHSMul.hSMul (data.cellVolume cell)
                                                              (NumStability.CoordinateLineBalance.advance
                                                                data.cellVolume rule d dt current cell))
                                                            (instHSub.hSub
                                                              (instHSMul.hSMul (data.cellVolume cell) (current cell))
                                                              (instHSMul.hSMul dt
                                                                (NumStability.CoordinateLineBalance.netOutwardFlux rule
                                                                  d dt current cell))))
                                                        (And
                                                          (∀ (base : D → Int) (start : Int) (count : Nat),
                                                            Eq ((Finset.range count).sum fun k => ⋯)
                                                              (instHSub.hSub ((Finset.range count).sum ⋯)
                                                                (instHSMul.hSMul dt
                                                                  (instHSub.hSub
                                                                    (NumStability.CoordinateLineBalance.normalFaceFlux
                                                                      rule d dt current
                                                                      (Function.update base d
                                                                        (instHAdd.hAdd start count.cast)))
                                                                    (NumStability.CoordinateLineBalance.normalFaceFlux
                                                                      rule d dt current
                                                                      (Function.update base d start))))))
                                                          (And
                                                            (∀ (other : (D → Int) → Fin m → Real) (base : D → Int),
                                                              (∀ (j : Int),
                                                                  Eq (current (Function.update base d j))
                                                                    (other (Function.update base d j))) →
                                                                ∀ (j : Int), Eq ⋯ ⋯)
                                                            (∀ (cell : D → Int),
                                                              Real.instLE.le
                                                                (Pi.normedRing.norm
                                                                  (instHSub.hSub
                                                                    (NumStability.CoordinateLineBalance.advance
                                                                      data.cellVolume rule d dt current cell)
                                                                    (data.cellMean (reference before d dt) cell dt)))
                                                                (instHAdd.hAdd (oldError before d dt cell)
                                                                  (instHMul.hMul
                                                                    (instHDiv.hDiv dt (data.cellVolume cell))
                                                                    (instHAdd.hAdd (faceError before d dt cell)
                                                                      (faceError before d dt
                                                                        (Function.update cell d
                                                                          (instHAdd.hAdd (cell d) 1)))))))))))))))
                                        (∀ (axes : D → NumStability.OneDimensionalFiniteVolumeGrid)
                                          (lineRule : D → (D → Int) → Real → (Int → Fin m → Real) → Fin m → Real),
                                          Eq data.cellVolume (NumStability.CartesianGrid.cellVolume axes) →
                                            Eq rule
                                                (NumStability.CartesianCoordinateUpdate.areaWeightedRule axes
                                                  lineRule) →
                                              And
                                                (∀ (cell : D → Int),
                                                  Eq
                                                    (MeasureTheory.Measure.instFunLike.coe
                                                        MeasureTheory.MeasureSpace.pi.volume
                                                        (NumStability.CartesianGrid.cellBox axes cell)).toReal
                                                    (data.cellVolume cell))
                                                (And
                                                  (∀ (d : D) (cell : D → Int),
                                                    Eq
                                                      (MeasureTheory.Measure.instFunLike.coe
                                                          MeasureTheory.MeasureSpace.pi.volume
                                                          (NumStability.CartesianGrid.tangentialFaceBox axes d
                                                            cell)).toReal
                                                      (NumStability.CartesianGrid.faceArea axes d cell))
                                                  (And
                                                    (∀ (d : D) (dt : Real) (state : (D → Int) → Fin m → Real)
                                                      (base : D → Int),
                                                      Eq
                                                        (fun j =>
                                                          NumStability.CoordinateLineBalance.advance data.cellVolume
                                                            rule d dt state (Function.update base d j))
                                                        (NumStability.riemannFiniteVolumeUpdate (axes d) dt
                                                          (fun j => state (Function.update base d j)) fun j =>
                                                          lineRule d (Function.update base d j) dt fun k =>
                                                            state (Function.update base d k)))
                                                    (∀ (d : D) (flux : (Fin m → Real) → Fin m → Real)
                                                      (q : Real → Real → Fin m → Real),
                                                      NumStability.IsRectangleConservationLawSolution q flux →
                                                        ∀ (s t : Real),
                                                          NumStability.DirectionalFiniteVolume.IsDirectionalReference
                                                            data.cellVolume
                                                            (fun cell τ =>
                                                              NumStability.finiteVolumeCellAverageOn (axes d)
                                                                (fun x => q x τ) (cell d))
                                                            (fun cell τ =>
                                                              instHSMul.hSMul
                                                                (NumStability.CartesianGrid.faceArea axes d cell)
                                                                (flux (q ((axes d).cellLeft (cell d)) τ)))
                                                            d s t)))))))))
```

## Fully explicit elaborated target type

```lean
∀ {D : Type u_1} [inst : DecidableEq.{u_1 + 1} D] {m : Nat} {Point : Type u_2} {FacePoint : Type u_3}
  [inst_1 : MeasurableSpace.{u_2} Point] [inst_2 : TopologicalSpace.{u_2} Point]
  [inst_3 : MeasurableSpace.{u_3} FacePoint] [inst_4 : Fintype.{u_1} D]
  (data :
    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_1, u_2, u_3} D Point FacePoint inst inst_1 inst_2 inst_3 m)
  (hdimension : @LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
  (rule : D → (D → Int) → Real → (Int → Fin m → Real) → Fin m → Real)
  (admitted : D → (D → Int) → Real → (Int → Fin m → Real) → Prop)
  (hconstant :
    ∀ (d : D) (cell : D → Int) (dt : Real) (value : Fin m → Real),
      @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt →
        @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
            (@NumStability.DirectionalFiniteVolume.PhysicalData.admissibleStates.{u_1, u_2, u_3} D Point FacePoint inst
              inst_1 inst_2 inst_3 m data d)
            value →
          (admitted d cell dt fun (x : Int) => value) →
            And
              (@MeasureTheory.Integrable.{0, u_3} (Fin m → Real)
                (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@SeminormedAddGroup.toContinuousENorm.{0} (Fin m → Real)
                  (@Pi.seminormedAddGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                    @SeminormedAddCommGroup.toSeminormedAddGroup.{0} Real
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))))
                FacePoint inst_3
                (fun (point : FacePoint) =>
                  @NumStability.DirectionalFiniteVolume.PhysicalData.normalFlux.{u_1, u_2, u_3} D Point FacePoint inst
                    inst_1 inst_2 inst_3 m data d cell point value)
                (@NumStability.DirectionalFiniteVolume.PhysicalData.faceMeasure.{u_1, u_2, u_3} D Point FacePoint inst
                  inst_1 inst_2 inst_3 m data d cell))
              (@Eq.{1} (Fin m → Real) (rule d cell dt fun (x : Int) => value)
                (@MeasureTheory.integral.{u_3, 0} FacePoint (Fin m → Real)
                  (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                    Real.normedAddCommGroup)
                  (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
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
                  inst_3
                  (@NumStability.DirectionalFiniteVolume.PhysicalData.faceMeasure.{u_1, u_2, u_3} D Point FacePoint inst
                    inst_1 inst_2 inst_3 m data d cell)
                  fun (point : FacePoint) =>
                  @NumStability.DirectionalFiniteVolume.PhysicalData.normalFlux.{u_1, u_2, u_3} D Point FacePoint inst
                    inst_1 inst_2 inst_3 m data d cell point value)))
  (stages : List.{u_1} (Prod.{u_1, 0} D Real))
  (hnonempty : @Ne.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages (@List.nil.{u_1} (Prod.{u_1, 0} D Real)))
  (hcover :
    ∀ (d : D),
      @Exists.{1} Real fun (dt : Real) =>
        @Membership.mem.{u_1, u_1} (Prod.{u_1, 0} D Real) (List.{u_1} (Prod.{u_1, 0} D Real))
          (@List.instMembership.{u_1} (Prod.{u_1, 0} D Real)) stages (@Prod.mk.{u_1, 0} D Real d dt))
  (hpositive :
    ∀ (stage : Prod.{u_1, 0} D Real),
      @Membership.mem.{u_1, u_1} (Prod.{u_1, 0} D Real) (List.{u_1} (Prod.{u_1, 0} D Real))
          (@List.instMembership.{u_1} (Prod.{u_1, 0} D Real)) stages stage →
        @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
          (@Prod.snd.{u_1, 0} D Real stage))
  (initial : (D → Int) → Fin m → Real)
  (reference : List.{u_1} (Prod.{u_1, 0} D Real) → D → Real → Point → Real → Fin m → Real)
  (oldError faceError : List.{u_1} (Prod.{u_1, 0} D Real) → D → Real → (D → Int) → Real)
  (hreferences :
    ∀ (before : List.{u_1} (Prod.{u_1, 0} D Real)) (d : D) (dt : Real) (after : List.{u_1} (Prod.{u_1, 0} D Real)),
      @Eq.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages
          (@HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} (Prod.{u_1, 0} D Real)) (List.{u_1} (Prod.{u_1, 0} D Real))
            (List.{u_1} (Prod.{u_1, 0} D Real))
            (@instHAppendOfAppend.{u_1} (List.{u_1} (Prod.{u_1, 0} D Real))
              (@List.instAppend.{u_1} (Prod.{u_1, 0} D Real)))
            before (@List.cons.{u_1} (Prod.{u_1, 0} D Real) (@Prod.mk.{u_1, 0} D Real d dt) after)) →
        @NumStability.DirectionalFiniteVolume.PhysicalData.ReferenceOn.{u_1, u_2, u_3} D inst m Point FacePoint inst_1
          inst_2 inst_3 data d (reference before d dt)
          (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt)
  (hadmitted :
    ∀ (before : List.{u_1} (Prod.{u_1, 0} D Real)) (d : D) (dt : Real) (after : List.{u_1} (Prod.{u_1, 0} D Real)),
      @Eq.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages
          (@HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} (Prod.{u_1, 0} D Real)) (List.{u_1} (Prod.{u_1, 0} D Real))
            (List.{u_1} (Prod.{u_1, 0} D Real))
            (@instHAppendOfAppend.{u_1} (List.{u_1} (Prod.{u_1, 0} D Real))
              (@List.instAppend.{u_1} (Prod.{u_1, 0} D Real)))
            before (@List.cons.{u_1} (Prod.{u_1, 0} D Real) (@Prod.mk.{u_1, 0} D Real d dt) after)) →
        ∀ (cell : D → Int),
          admitted d cell dt fun (j : Int) =>
            @NumStability.CoordinateLineBalance.sweep.{u_1, 0} D (Fin m → Real) inst
              (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommGroup)
              (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                          (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
              (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst m Point FacePoint
                inst_1 inst_2 inst_3 data)
              rule before initial (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst cell d j))
  (hstates :
    ∀ (before : List.{u_1} (Prod.{u_1, 0} D Real)) (d : D) (dt : Real) (after : List.{u_1} (Prod.{u_1, 0} D Real)),
      @Eq.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages
          (@HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} (Prod.{u_1, 0} D Real)) (List.{u_1} (Prod.{u_1, 0} D Real))
            (List.{u_1} (Prod.{u_1, 0} D Real))
            (@instHAppendOfAppend.{u_1} (List.{u_1} (Prod.{u_1, 0} D Real))
              (@List.instAppend.{u_1} (Prod.{u_1, 0} D Real)))
            before (@List.cons.{u_1} (Prod.{u_1, 0} D Real) (@Prod.mk.{u_1, 0} D Real d dt) after)) →
        ∀ (cell : D → Int),
          @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
            (@NumStability.DirectionalFiniteVolume.PhysicalData.admissibleStates.{u_1, u_2, u_3} D Point FacePoint inst
              inst_1 inst_2 inst_3 m data d)
            (@NumStability.CoordinateLineBalance.sweep.{u_1, 0} D (Fin m → Real) inst
              (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommGroup)
              (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                          (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
              (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst m Point FacePoint
                inst_1 inst_2 inst_3 data)
              rule before initial cell))
  (hold :
    ∀ (before : List.{u_1} (Prod.{u_1, 0} D Real)) (d : D) (dt : Real) (after : List.{u_1} (Prod.{u_1, 0} D Real)),
      @Eq.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages
          (@HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} (Prod.{u_1, 0} D Real)) (List.{u_1} (Prod.{u_1, 0} D Real))
            (List.{u_1} (Prod.{u_1, 0} D Real))
            (@instHAppendOfAppend.{u_1} (List.{u_1} (Prod.{u_1, 0} D Real))
              (@List.instAppend.{u_1} (Prod.{u_1, 0} D Real)))
            before (@List.cons.{u_1} (Prod.{u_1, 0} D Real) (@Prod.mk.{u_1, 0} D Real d dt) after)) →
        ∀ (cell : D → Int),
          @LE.le.{0} Real Real.instLE
            (@Norm.norm.{0} (Fin m → Real)
              (@NormedRing.toNorm.{0} (Fin m → Real)
                (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                  @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
              (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                (@instHSub.{0} (Fin m → Real)
                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                (@NumStability.CoordinateLineBalance.sweep.{u_1, 0} D (Fin m → Real) inst
                  (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommGroup)
                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                    (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                      (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                        (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                  (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst m Point
                    FacePoint inst_1 inst_2 inst_3 data)
                  rule before initial cell)
                (@NumStability.DirectionalFiniteVolume.PhysicalData.cellMean.{u_1, u_2, u_3} D inst m Point FacePoint
                  inst_1 inst_2 inst_3 data (reference before d dt) cell
                  (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))))
            (oldError before d dt cell))
  (hface :
    ∀ (before : List.{u_1} (Prod.{u_1, 0} D Real)) (d : D) (dt : Real) (after : List.{u_1} (Prod.{u_1, 0} D Real)),
      @Eq.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages
          (@HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} (Prod.{u_1, 0} D Real)) (List.{u_1} (Prod.{u_1, 0} D Real))
            (List.{u_1} (Prod.{u_1, 0} D Real))
            (@instHAppendOfAppend.{u_1} (List.{u_1} (Prod.{u_1, 0} D Real))
              (@List.instAppend.{u_1} (Prod.{u_1, 0} D Real)))
            before (@List.cons.{u_1} (Prod.{u_1, 0} D Real) (@Prod.mk.{u_1, 0} D Real d dt) after)) →
        ∀ (cell : D → Int),
          @LE.le.{0} Real Real.instLE
            (@Norm.norm.{0} (Fin m → Real)
              (@NormedRing.toNorm.{0} (Fin m → Real)
                (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                  @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
              (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                (@instHSub.{0} (Fin m → Real)
                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                (@NumStability.CoordinateLineBalance.normalFaceFlux.{u_1, 0} D (Fin m → Real) inst rule d dt
                  (@NumStability.CoordinateLineBalance.sweep.{u_1, 0} D (Fin m → Real) inst
                    (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommGroup)
                    (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                      (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                        (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                          (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                      (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                    (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst m Point
                      FacePoint inst_1 inst_2 inst_3 data)
                    rule before initial)
                  cell)
                (@NumStability.DirectionalFiniteVolume.faceAverage.{u_1} D m
                  (@NumStability.DirectionalFiniteVolume.PhysicalData.faceFlux.{u_1, u_2, u_3} D inst m Point FacePoint
                    inst_1 inst_2 inst_3 data d (reference before d dt))
                  (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt cell)))
            (faceError before d dt cell)),
  And (@LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
    (And
      (∀ (d : D) (cell : D → Int) (point : FacePoint),
        @NumStability.IsHyperbolicFluxOn m
          (@NumStability.DirectionalFiniteVolume.PhysicalData.normalFlux.{u_1, u_2, u_3} D Point FacePoint inst inst_1
            inst_2 inst_3 m data d cell point)
          (@NumStability.DirectionalFiniteVolume.PhysicalData.admissibleStates.{u_1, u_2, u_3} D Point FacePoint inst
            inst_1 inst_2 inst_3 m data d))
      (And
        (∀ (d : D) (cell : D → Int) (dt : Real) (value : Fin m → Real),
          @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt →
            @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
                (@NumStability.DirectionalFiniteVolume.PhysicalData.admissibleStates.{u_1, u_2, u_3} D Point FacePoint
                  inst inst_1 inst_2 inst_3 m data d)
                value →
              (admitted d cell dt fun (x : Int) => value) →
                And
                  (@MeasureTheory.Integrable.{0, u_3} (Fin m → Real)
                    (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                      @UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@SeminormedAddGroup.toContinuousENorm.{0} (Fin m → Real)
                      (@Pi.seminormedAddGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                        fun (i : Fin m) =>
                        @SeminormedAddCommGroup.toSeminormedAddGroup.{0} Real
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))))
                    FacePoint inst_3
                    (fun (point : FacePoint) =>
                      @NumStability.DirectionalFiniteVolume.PhysicalData.normalFlux.{u_1, u_2, u_3} D Point FacePoint
                        inst inst_1 inst_2 inst_3 m data d cell point value)
                    (@NumStability.DirectionalFiniteVolume.PhysicalData.faceMeasure.{u_1, u_2, u_3} D Point FacePoint
                      inst inst_1 inst_2 inst_3 m data d cell))
                  (@Eq.{1} (Fin m → Real) (rule d cell dt fun (x : Int) => value)
                    (@MeasureTheory.integral.{u_3, 0} FacePoint (Fin m → Real)
                      (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                        fun (i : Fin m) => Real.normedAddCommGroup)
                      (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
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
                      inst_3
                      (@NumStability.DirectionalFiniteVolume.PhysicalData.faceMeasure.{u_1, u_2, u_3} D Point FacePoint
                        inst inst_1 inst_2 inst_3 m data d cell)
                      fun (point : FacePoint) =>
                      @NumStability.DirectionalFiniteVolume.PhysicalData.normalFlux.{u_1, u_2, u_3} D Point FacePoint
                        inst inst_1 inst_2 inst_3 m data d cell point value)))
        (And (@Ne.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages (@List.nil.{u_1} (Prod.{u_1, 0} D Real)))
          (And
            (∀ (d : D),
              @Exists.{1} Real fun (dt : Real) =>
                @Membership.mem.{u_1, u_1} (Prod.{u_1, 0} D Real) (List.{u_1} (Prod.{u_1, 0} D Real))
                  (@List.instMembership.{u_1} (Prod.{u_1, 0} D Real)) stages (@Prod.mk.{u_1, 0} D Real d dt))
            (And
              (∀ (before : List.{u_1} (Prod.{u_1, 0} D Real)) (d : D) (dt : Real)
                (after : List.{u_1} (Prod.{u_1, 0} D Real)),
                @Eq.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages
                    (@HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} (Prod.{u_1, 0} D Real))
                      (List.{u_1} (Prod.{u_1, 0} D Real)) (List.{u_1} (Prod.{u_1, 0} D Real))
                      (@instHAppendOfAppend.{u_1} (List.{u_1} (Prod.{u_1, 0} D Real))
                        (@List.instAppend.{u_1} (Prod.{u_1, 0} D Real)))
                      before (@List.cons.{u_1} (Prod.{u_1, 0} D Real) (@Prod.mk.{u_1, 0} D Real d dt) after)) →
                  have current : (D → Int) → Fin m → Real :=
                    @NumStability.CoordinateLineBalance.sweep.{u_1, 0} D (Fin m → Real) inst
                      (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        Real.instAddCommGroup)
                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                        (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                          (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                            (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                      (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst m Point
                        FacePoint inst_1 inst_2 inst_3 data)
                      rule before initial;
                  And
                    (@LT.lt.{0} Real Real.instLT
                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt)
                    (And
                      (@NumStability.DirectionalFiniteVolume.PhysicalData.ReferenceOn.{u_1, u_2, u_3} D inst m Point
                        FacePoint inst_1 inst_2 inst_3 data d (reference before d dt)
                        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt)
                      (And
                        (∀ (cell : D → Int),
                          admitted d cell dt fun (j : Int) =>
                            current (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst cell d j))
                        (And
                          (∀ (cell : D → Int),
                            @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real))
                              (@Set.instMembership.{0} (Fin m → Real))
                              (@NumStability.DirectionalFiniteVolume.PhysicalData.admissibleStates.{u_1, u_2, u_3} D
                                Point FacePoint inst inst_1 inst_2 inst_3 m data d)
                              (current cell))
                          (And
                            (@Eq.{u_1 + 1} ((D → Int) → Fin m → Real)
                              (@NumStability.CoordinateLineBalance.sweep.{u_1, 0} D (Fin m → Real) inst
                                (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                  Real.instAddCommGroup)
                                (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                    (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                      (@Semiring.toNonUnitalSemiring.{0} Real
                                        (@Ring.toSemiring.{0} Real Real.instRing))))
                                  (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                          (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                    (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                                (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst m
                                  Point FacePoint inst_1 inst_2 inst_3 data)
                                rule stages initial)
                              (@NumStability.CoordinateLineBalance.sweep.{u_1, 0} D (Fin m → Real) inst
                                (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                  Real.instAddCommGroup)
                                (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                    (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                      (@Semiring.toNonUnitalSemiring.{0} Real
                                        (@Ring.toSemiring.{0} Real Real.instRing))))
                                  (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                          (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                    (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                                (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst m
                                  Point FacePoint inst_1 inst_2 inst_3 data)
                                rule after
                                (@NumStability.CoordinateLineBalance.advance.{u_1, 0} D (Fin m → Real) inst
                                  (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                    Real.instAddCommGroup)
                                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                                    (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                      (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                        (@Semiring.toNonUnitalSemiring.{0} Real
                                          (@Ring.toSemiring.{0} Real Real.instRing))))
                                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                                  (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst
                                    m Point FacePoint inst_1 inst_2 inst_3 data)
                                  rule d dt current)))
                            (And
                              (∀ (cell : D → Int),
                                @Eq.{1} (Fin m → Real)
                                  (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                    (@instHSMul.{0, 0} Real (Fin m → Real)
                                      (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                        (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                          (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                          (@Algebra.id.{0} Real Real.instCommSemiring))))
                                    (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D
                                      inst m Point FacePoint inst_1 inst_2 inst_3 data cell)
                                    (@NumStability.CoordinateLineBalance.advance.{u_1, 0} D (Fin m → Real) inst
                                      (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                        Real.instAddCommGroup)
                                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                                        (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                          (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                            (@Semiring.toNonUnitalSemiring.{0} Real
                                              (@Ring.toSemiring.{0} Real Real.instRing))))
                                        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                          (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                                      (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D
                                        inst m Point FacePoint inst_1 inst_2 inst_3 data)
                                      rule d dt current cell))
                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                    (@instHSub.{0} (Fin m → Real)
                                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                        Real.instSub))
                                    (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                      (@instHSMul.{0, 0} Real (Fin m → Real)
                                        (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                          (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                            (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                            (@Algebra.id.{0} Real Real.instCommSemiring))))
                                      (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D
                                        inst m Point FacePoint inst_1 inst_2 inst_3 data cell)
                                      (current cell))
                                    (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                      (@instHSMul.{0, 0} Real (Fin m → Real)
                                        (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                          (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                            (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                            (@Algebra.id.{0} Real Real.instCommSemiring))))
                                      dt
                                      (@NumStability.CoordinateLineBalance.netOutwardFlux.{u_1, 0} D (Fin m → Real) inst
                                        (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                          Real.instAddCommGroup)
                                        rule d dt current cell))))
                              (And
                                (∀ (base : (a : D) → Int) (start : Int) (count : Nat),
                                  @Eq.{1} (Fin m → Real)
                                    (@Finset.sum.{0, 0} Nat (Fin m → Real)
                                      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                        Real.instAddCommMonoid)
                                      (Finset.range count) fun (k : Nat) =>
                                      @HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                        (@instHSMul.{0, 0} Real (Fin m → Real)
                                          (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                            (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                              (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                              (@Algebra.id.{0} Real Real.instCommSemiring))))
                                        (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D
                                          inst m Point FacePoint inst_1 inst_2 inst_3 data
                                          (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                                            (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                              (@Nat.cast.{0} Int instNatCastInt k))))
                                        (@NumStability.CoordinateLineBalance.advance.{u_1, 0} D (Fin m → Real) inst
                                          (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                            Real.instAddCommGroup)
                                          (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                                            (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                              (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                                (@Semiring.toNonUnitalSemiring.{0} Real
                                                  (@Ring.toSemiring.{0} Real Real.instRing))))
                                            (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                              (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                      Real.normedCommRing))))
                                              (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                        Real.normedCommRing))))
                                                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                                          (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3}
                                            D inst m Point FacePoint inst_1 inst_2 inst_3 data)
                                          rule d dt current
                                          (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                                            (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                              (@Nat.cast.{0} Int instNatCastInt k)))))
                                    (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                      (@instHSub.{0} (Fin m → Real)
                                        (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                          Real.instSub))
                                      (@Finset.sum.{0, 0} Nat (Fin m → Real)
                                        (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                          Real.instAddCommMonoid)
                                        (Finset.range count) fun (k : Nat) =>
                                        @HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                          (@instHSMul.{0, 0} Real (Fin m → Real)
                                            (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                              (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                                (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                                (@Algebra.id.{0} Real Real.instCommSemiring))))
                                          (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3}
                                            D inst m Point FacePoint inst_1 inst_2 inst_3 data
                                            (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                                              (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                                (@Nat.cast.{0} Int instNatCastInt k))))
                                          (current
                                            (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                                              (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                                (@Nat.cast.{0} Int instNatCastInt k)))))
                                      (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                        (@instHSMul.{0, 0} Real (Fin m → Real)
                                          (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                            (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                              (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                              (@Algebra.id.{0} Real Real.instCommSemiring))))
                                        dt
                                        (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                          (@instHSub.{0} (Fin m → Real)
                                            (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                              Real.instSub))
                                          (@NumStability.CoordinateLineBalance.normalFaceFlux.{u_1, 0} D (Fin m → Real)
                                            inst rule d dt current
                                            (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                                              (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                                (@Nat.cast.{0} Int instNatCastInt count))))
                                          (@NumStability.CoordinateLineBalance.normalFaceFlux.{u_1, 0} D (Fin m → Real)
                                            inst rule d dt current
                                            (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                                              start))))))
                                (And
                                  (∀ (other : (D → Int) → Fin m → Real) (base : (a : D) → Int),
                                    (∀ (j : Int),
                                        @Eq.{1} (Fin m → Real)
                                          (current (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j))
                                          (other
                                            (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j))) →
                                      ∀ (j : Int),
                                        @Eq.{1} (Fin m → Real)
                                          (@NumStability.CoordinateLineBalance.advance.{u_1, 0} D (Fin m → Real) inst
                                            (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                              fun (i : Fin m) => Real.instAddCommGroup)
                                            (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                                              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                                (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                                  (@Semiring.toNonUnitalSemiring.{0} Real
                                                    (@Ring.toSemiring.{0} Real Real.instRing))))
                                              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                        Real.normedCommRing))))
                                                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                          Real.normedCommRing))))
                                                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                                            (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2,
                                                  u_3}
                                              D inst m Point FacePoint inst_1 inst_2 inst_3 data)
                                            rule d dt current
                                            (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j))
                                          (@NumStability.CoordinateLineBalance.advance.{u_1, 0} D (Fin m → Real) inst
                                            (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                              fun (i : Fin m) => Real.instAddCommGroup)
                                            (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                                              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                                (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                                  (@Semiring.toNonUnitalSemiring.{0} Real
                                                    (@Ring.toSemiring.{0} Real Real.instRing))))
                                              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                        Real.normedCommRing))))
                                                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                          Real.normedCommRing))))
                                                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                                            (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2,
                                                  u_3}
                                              D inst m Point FacePoint inst_1 inst_2 inst_3 data)
                                            rule d dt other
                                            (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j)))
                                  (∀ (cell : D → Int),
                                    @LE.le.{0} Real Real.instLE
                                      (@Norm.norm.{0} (Fin m → Real)
                                        (@NormedRing.toNorm.{0} (Fin m → Real)
                                          (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                            fun (i : Fin m) =>
                                            @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                        (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                          (@instHSub.{0} (Fin m → Real)
                                            (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                              Real.instSub))
                                          (@NumStability.CoordinateLineBalance.advance.{u_1, 0} D (Fin m → Real) inst
                                            (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                              fun (i : Fin m) => Real.instAddCommGroup)
                                            (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                                              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                                (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                                  (@Semiring.toNonUnitalSemiring.{0} Real
                                                    (@Ring.toSemiring.{0} Real Real.instRing))))
                                              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                      (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                        Real.normedCommRing))))
                                                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                          Real.normedCommRing))))
                                                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                                            (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2,
                                                  u_3}
                                              D inst m Point FacePoint inst_1 inst_2 inst_3 data)
                                            rule d dt current cell)
                                          (@NumStability.DirectionalFiniteVolume.PhysicalData.cellMean.{u_1, u_2, u_3} D
                                            inst m Point FacePoint inst_1 inst_2 inst_3 data (reference before d dt)
                                            cell dt)))
                                      (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                                        (oldError before d dt cell)
                                        (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                          (@HDiv.hDiv.{0, 0, 0} Real Real Real
                                            (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid)) dt
                                            (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2,
                                                  u_3}
                                              D inst m Point FacePoint inst_1 inst_2 inst_3 data cell))
                                          (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                                            (faceError before d dt cell)
                                            (faceError before d dt
                                              (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst cell d
                                                (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
                                                  (cell d)
                                                  (@OfNat.ofNat.{0} Int (nat_lit 1)
                                                    (@instOfNat (nat_lit 1))))))))))))))))))
              (∀ (axes : D → NumStability.OneDimensionalFiniteVolumeGrid)
                (lineRule : D → (D → Int) → Real → (Int → Fin m → Real) → Fin m → Real),
                @Eq.{u_1 + 1} ((cell : D → Int) → Real)
                    (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst m Point
                      FacePoint inst_1 inst_2 inst_3 data)
                    (@NumStability.CartesianGrid.cellVolume.{u_1} D inst_4 axes) →
                  @Eq.{u_1 + 1} (D → (D → Int) → Real → (Int → Fin m → Real) → Fin m → Real) rule
                      (@NumStability.CartesianCoordinateUpdate.areaWeightedRule.{u_1} D inst_4 inst m axes lineRule) →
                    And
                      (∀ (cell : D → Int),
                        @Eq.{1} Real
                          (ENNReal.toReal
                            (@DFunLike.coe.{u_1 + 1, u_1 + 1, 1}
                              (@MeasureTheory.Measure.{u_1} (D → Real)
                                (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1} (D → Real)
                                  (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst_4 (fun (a : D) => Real) fun (i : D) =>
                                    Real.measureSpace)))
                              (Set.{u_1} (D → Real)) (fun (x : Set.{u_1} (D → Real)) => ENNReal)
                              (@MeasureTheory.Measure.instFunLike.{u_1} (D → Real)
                                (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1} (D → Real)
                                  (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst_4 (fun (a : D) => Real) fun (i : D) =>
                                    Real.measureSpace)))
                              (@MeasureTheory.MeasureSpace.volume.{u_1} (D → Real)
                                (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst_4 (fun (a : D) => Real) fun (i : D) =>
                                  Real.measureSpace))
                              (@NumStability.CartesianGrid.cellBox.{u_1} D axes cell)))
                          (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst m Point
                            FacePoint inst_1 inst_2 inst_3 data cell))
                      (And
                        (∀ (d : D) (cell : D → Int),
                          @Eq.{1} Real
                            (ENNReal.toReal
                              (@DFunLike.coe.{u_1 + 1, u_1 + 1, 1}
                                (@MeasureTheory.Measure.{u_1}
                                  ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
                                  (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1}
                                    ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
                                    (@MeasureTheory.MeasureSpace.pi.{u_1, 0}
                                      (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d)
                                      (@Subtype.fintype.{u_1} D (fun (e : D) => @Ne.{u_1 + 1} D e d)
                                        (fun (a : D) => @instDecidableNot (@Eq.{u_1 + 1} D a d) (inst a d)) inst_4)
                                      (fun (a : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real)
                                      fun (i : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) =>
                                      Real.measureSpace)))
                                (Set.{u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real))
                                (fun
                                    (x :
                                      Set.{u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)) =>
                                  ENNReal)
                                (@MeasureTheory.Measure.instFunLike.{u_1}
                                  ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
                                  (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1}
                                    ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
                                    (@MeasureTheory.MeasureSpace.pi.{u_1, 0}
                                      (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d)
                                      (@Subtype.fintype.{u_1} D (fun (e : D) => @Ne.{u_1 + 1} D e d)
                                        (fun (a : D) => @instDecidableNot (@Eq.{u_1 + 1} D a d) (inst a d)) inst_4)
                                      (fun (a : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real)
                                      fun (i : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) =>
                                      Real.measureSpace)))
                                (@MeasureTheory.MeasureSpace.volume.{u_1}
                                  ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
                                  (@MeasureTheory.MeasureSpace.pi.{u_1, 0}
                                    (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d)
                                    (@Subtype.fintype.{u_1} D (fun (e : D) => @Ne.{u_1 + 1} D e d)
                                      (fun (a : D) => @instDecidableNot (@Eq.{u_1 + 1} D a d) (inst a d)) inst_4)
                                    (fun (a : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real)
                                    fun (i : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) =>
                                    Real.measureSpace))
                                (@NumStability.CartesianGrid.tangentialFaceBox.{u_1} D axes d cell)))
                            (@NumStability.CartesianGrid.faceArea.{u_1} D inst_4 inst axes d cell))
                        (And
                          (∀ (d : D) (dt : Real) (state : (D → Int) → Fin m → Real) (base : (a : D) → Int),
                            @Eq.{1} ((j : Int) → Fin m → Real)
                              (fun (j : Int) =>
                                @NumStability.CoordinateLineBalance.advance.{u_1, 0} D (Fin m → Real) inst
                                  (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                    Real.instAddCommGroup)
                                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                                    (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                      (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                        (@Semiring.toNonUnitalSemiring.{0} Real
                                          (@Ring.toSemiring.{0} Real Real.instRing))))
                                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                                  (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst
                                    m Point FacePoint inst_1 inst_2 inst_3 data)
                                  rule d dt state (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j))
                              (@NumStability.riemannFiniteVolumeUpdate.{0} (Fin m) (axes d) dt
                                (fun (j : Int) =>
                                  state (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j))
                                fun (j : Int) =>
                                lineRule d (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j) dt
                                  fun (k : Int) =>
                                  state (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d k)))
                          (∀ (d : D) (flux : (Fin m → Real) → Fin m → Real) (q : Real → Real → Fin m → Real),
                            @NumStability.IsRectangleConservationLawSolution.{0} (Fin m → Real)
                                (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                  fun (i : Fin m) => Real.normedAddCommGroup)
                                (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real)
                                  (Fin.fintype m)
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
                                q flux →
                              ∀ (s t : Real),
                                @NumStability.DirectionalFiniteVolume.IsDirectionalReference.{u_1} D inst m
                                  (@NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume.{u_1, u_2, u_3} D inst
                                    m Point FacePoint inst_1 inst_2 inst_3 data)
                                  (fun (cell : D → Int) (τ : Real) =>
                                    @NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
                                      (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                        fun (i : Fin m) => Real.normedAddCommGroup)
                                      (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real)
                                        (Fin.fintype m)
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
                                      (axes d) (fun (x : Real) => q x τ) (cell d))
                                  (fun (cell : D → Int) (τ : Real) =>
                                    @HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                      (@instHSMul.{0, 0} Real (Fin m → Real)
                                        (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                          (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                            (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                            (@Algebra.id.{0} Real Real.instCommSemiring))))
                                      (@NumStability.CartesianGrid.faceArea.{u_1} D inst_4 inst axes d cell)
                                      (flux
                                        (q (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft (axes d) (cell d)) τ)))
                                  d s t)))))))))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalMethodSweep`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference` imports: `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReferenceError` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `Mathlib.MeasureTheory.Measure.Lebesgue.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.MeasureTheory.Integral.Average`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `Mathlib.Analysis.Calculus.FDeriv.Basic`, `Mathlib.LinearAlgebra.Matrix.ToLin`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting` imports: `Mathlib.Data.List.Basic`, `Mathlib.Data.Real.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalMethodSweep` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReferenceError`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.CartesianCoordinateUpdate.areaWeightedRule`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b8dd7d7810cc23616a121dd9c60ed72ba44bf78226201613020974d8e357f74f`

Type:

```lean
{D : Type u_1} →
  [Fintype D] →
    [DecidableEq D] →
      {m : Nat} →
        (D → NumStability.OneDimensionalFiniteVolumeGrid) →
          (D → (D → Int) → Real → (Int → Fin m → Real) → Fin m → Real) →
            D → (D → Int) → Real → (Int → Fin m → Real) → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  [Fintype.{u_1} D] →
    [DecidableEq.{u_1 + 1} D] →
      {m : Nat} →
        (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) →
          (rule : D → (D → Int) → Real → (Int → Fin m → Real) → Fin m → Real) →
            (d : D) → (cell : D → Int) → (dt : Real) → (old : Int → Fin m → Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [Fintype D] [DecidableEq D] {m} axes rule d cell dt old =>
  instHSMul.hSMul (NumStability.CartesianGrid.faceArea axes d cell) (rule d cell dt old)
```

### D002: `NumStability.CartesianGrid.cellBox`

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

### D003: `NumStability.CartesianGrid.cellVolume`

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

### D004: `NumStability.CartesianGrid.faceArea`

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

### D005: `NumStability.CartesianGrid.tangentialFaceBox`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D006: `NumStability.CoordinateLineBalance.advance`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e5ac63ef525014ab724c9fc67f684f045866fe2c9ac6a23f6843939e17ab7e45`

Type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq D] →
      [inst : AddCommGroup E] →
        [Module Real E] →
          ((D → Int) → Real) → (D → (D → Int) → Real → (Int → E) → E) → D → Real → ((D → Int) → E) → (D → Int) → E
```

Fully explicit type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq.{u_1 + 1} D] →
      [inst : AddCommGroup.{u_2} E] →
        [@Module.{0, u_2} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_2} E inst)] →
          (volume : (D → Int) → Real) →
            (rule : D → (D → Int) → Real → (Int → E) → E) →
              (d : D) → (dt : Real) → (state : (D → Int) → E) → (cell : D → Int) → E
```

Definition body (one-level semantic boundary):

```lean
fun {D} {E} [DecidableEq D] [AddCommGroup E] [Module Real E] volume rule d dt state cell =>
  NumStability.finiteVolumeCellAverageUpdate dt (volume cell) (state cell)
    (NumStability.CoordinateLineBalance.netOutwardFlux rule d dt state cell)
```

### D007: `NumStability.CoordinateLineBalance.netOutwardFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b85f363c52c36c38bf3473335002e31129e7717dad0159b1b3d2323f49375eb5`

Type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq D] →
      [AddCommGroup E] → (D → (D → Int) → Real → (Int → E) → E) → D → Real → ((D → Int) → E) → (D → Int) → E
```

Fully explicit type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq.{u_1 + 1} D] →
      [AddCommGroup.{u_2} E] →
        (rule : D → (D → Int) → Real → (Int → E) → E) →
          (d : D) → (dt : Real) → (state : (D → Int) → E) → (cell : D → Int) → E
```

Definition body (one-level semantic boundary):

```lean
fun {D} {E} [DecidableEq D] [AddCommGroup E] rule d dt state cell =>
  instHSub.hSub
    (NumStability.CoordinateLineBalance.normalFaceFlux rule d dt state
      (Function.update cell d (instHAdd.hAdd (cell d) 1)))
    (NumStability.CoordinateLineBalance.normalFaceFlux rule d dt state cell)
```

### D008: `NumStability.CoordinateLineBalance.normalFaceFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f74d0e36ad31edcaa449f83fcffde8ed8effa8ecd95db2f216c669d6d530e3da`

Type:

```lean
{D : Type u_1} →
  {E : Type u_2} → [DecidableEq D] → (D → (D → Int) → Real → (Int → E) → E) → D → Real → ((D → Int) → E) → (D → Int) → E
```

Fully explicit type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq.{u_1 + 1} D] →
      (rule : D → (D → Int) → Real → (Int → E) → E) →
        (d : D) → (dt : Real) → (state : (D → Int) → E) → (rightCell : D → Int) → E
```

Definition body (one-level semantic boundary):

```lean
fun {D} {E} [DecidableEq D] rule d dt state rightCell =>
  rule d rightCell dt fun j => state (Function.update rightCell d j)
```

### D009: `NumStability.CoordinateLineBalance.sweep`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `97b808f2bde942c4834c3d212d64538572a0718c98e45345f8c71041b30e0042`

Type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq D] →
      [inst : AddCommGroup E] →
        [Module Real E] →
          ((D → Int) → Real) →
            (D → (D → Int) → Real → (Int → E) → E) → List (Prod D Real) → ((D → Int) → E) → (D → Int) → E
```

Fully explicit type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq.{u_1 + 1} D] →
      [inst : AddCommGroup.{u_2} E] →
        [@Module.{0, u_2} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_2} E inst)] →
          (volume : (D → Int) → Real) →
            (rule : D → (D → Int) → Real → (Int → E) → E) →
              (stages : List.{u_1} (Prod.{u_1, 0} D Real)) → (state : (D → Int) → E) → (D → Int) → E
```

Definition body (one-level semantic boundary):

```lean
fun {D} {E} [DecidableEq D] [AddCommGroup E] [Module Real E] volume rule stages state =>
  NumStability.orderedOperatorSweep
    (List.map (fun stage => NumStability.CoordinateLineBalance.advance volume rule stage.fst stage.snd) stages) state
```

### D010: `NumStability.DirectionalFiniteVolume.IsDirectionalReference`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c688ad9dd04551d0c2f44e5b61301c71c4e7c19ff1eef30a0974db1ee814281f`

Type:

```lean
{D : Type u_1} →
  [DecidableEq D] →
    {m : Nat} →
      ((D → Int) → Real) →
        ((D → Int) → Real → Fin m → Real) → ((D → Int) → Real → Fin m → Real) → D → Real → Real → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  [DecidableEq.{u_1 + 1} D] →
    {m : Nat} →
      (cellVolume : (D → Int) → Real) →
        (mean physical : (D → Int) → Real → Fin m → Real) → (d : D) → (s t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {D} [DecidableEq D] {m} cellVolume mean physical d s t =>
  And (∀ (cell : D → Int), IntervalIntegrable (physical cell) Real.measureSpace.volume s t)
    (∀ (cell : D → Int),
      Eq (instHSMul.hSMul (cellVolume cell) (instHSub.hSub (mean cell t) (mean cell s)))
        (intervalIntegral
          (fun τ => instHSub.hSub (physical cell τ) (physical (Function.update cell d (instHAdd.hAdd (cell d) 1)) τ)) s
          t Real.measureSpace.volume))
```

### D011: `NumStability.DirectionalFiniteVolume.PhysicalData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `609d7de9fbc5b6a66f58bf93d41c849b09e6398706a9f646b736b9cacaad7fce`

Type:

```lean
(D : Type u_2) →
  (Point : Type u_3) →
    (FacePoint : Type u_4) →
      [DecidableEq D] →
        [MeasurableSpace Point] →
          [TopologicalSpace Point] → [MeasurableSpace FacePoint] → Nat → Type (max (max u_2 u_3) u_4)
```

Fully explicit type:

```lean
(D : Type u_2) →
  (Point : Type u_3) →
    (FacePoint : Type u_4) →
      [DecidableEq.{u_2 + 1} D] →
        [MeasurableSpace.{u_3} Point] →
          [TopologicalSpace.{u_3} Point] → [MeasurableSpace.{u_4} FacePoint] → (m : Nat) → Type (max (max u_2 u_3) u_4)
```

### D012: `NumStability.DirectionalFiniteVolume.PhysicalData.ReferenceOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `269543d30416f7fbb21a11a217495f5530c275b83c550dda1c06fe2241ca8449`

Type:

```lean
{D : Type u_1} →
  [inst : DecidableEq D] →
    {m : Nat} →
      {Point : Type u_2} →
        {FacePoint : Type u_3} →
          [inst_1 : MeasurableSpace Point] →
            [inst_2 : TopologicalSpace Point] →
              [inst_3 : MeasurableSpace FacePoint] →
                NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m →
                  D → (Point → Real → Fin m → Real) → Real → Real → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  [inst : DecidableEq.{u_1 + 1} D] →
    {m : Nat} →
      {Point : Type u_2} →
        {FacePoint : Type u_3} →
          [inst_1 : MeasurableSpace.{u_2} Point] →
            [inst_2 : TopologicalSpace.{u_2} Point] →
              [inst_3 : MeasurableSpace.{u_3} FacePoint] →
                (data :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_1, u_2, u_3} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  (d : D) → (q : Point → Real → Fin m → Real) → (s t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {D} [DecidableEq D] {m} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] data d q s t =>
  And
    (∀ (cell : D → Int) (τ : Real),
      Set.instMembership.mem (Set.uIcc s t) τ →
        MeasureTheory.IntegrableOn (fun x => q x τ) (data.cells.cellRegion cell) data.measure)
    (And
      (∀ (cell : D → Int) (τ : Real),
        Set.instMembership.mem (Set.uIcc s t) τ →
          MeasureTheory.Integrable (fun point => data.normalFlux d cell point (q (data.facePoint d cell point) τ))
            (data.faceMeasure d cell))
      (And
        (∀ (cell : D → Int) (point : FacePoint) (τ : Real),
          Set.instMembership.mem (Set.uIcc s t) τ →
            Set.instMembership.mem (data.admissibleStates d) (q (data.facePoint d cell point) τ))
        (And
          (∀ (x : Point),
            Set.instMembership.mem data.cells.domain x →
              ∀ (τ : Real),
                Set.instMembership.mem (Set.uIcc s t) τ → Set.instMembership.mem (data.admissibleStates d) (q x τ))
          (NumStability.DirectionalFiniteVolume.IsDirectionalReference data.cellVolume (data.cellMean q)
            (data.faceFlux d q) d s t))))
```

### D013: `NumStability.DirectionalFiniteVolume.PhysicalData.admissibleStates`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ea8d533ff7e18d581f72e845bd171faf79edac75677b7a8c7ea152e1489131f4`

Type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq D] →
        [inst_1 : MeasurableSpace Point] →
          [inst_2 : TopologicalSpace Point] →
            [inst_3 : MeasurableSpace FacePoint] →
              {m : Nat} → NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m → D → Set (Fin m → Real)
```

Fully explicit type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq.{u_2 + 1} D] →
        [inst_1 : MeasurableSpace.{u_3} Point] →
          [inst_2 : TopologicalSpace.{u_3} Point] →
            [inst_3 : MeasurableSpace.{u_4} FacePoint] →
              {m : Nat} →
                (self :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_2, u_3, u_4} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  D → Set.{0} (Fin m → Real)
```

Definition body (one-level semantic boundary):

```lean
fun D Point FacePoint [DecidableEq D] [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m
    self =>
  self.8
```

### D014: `NumStability.DirectionalFiniteVolume.PhysicalData.cellMean`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `531654b40246bc235e424329ae3a208ee6548a3ba31b3cb9cafb0f601abe9d62`

Type:

```lean
{D : Type u_1} →
  [inst : DecidableEq D] →
    {m : Nat} →
      {Point : Type u_2} →
        {FacePoint : Type u_3} →
          [inst_1 : MeasurableSpace Point] →
            [inst_2 : TopologicalSpace Point] →
              [inst_3 : MeasurableSpace FacePoint] →
                NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m →
                  (Point → Real → Fin m → Real) → (D → Int) → Real → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  [inst : DecidableEq.{u_1 + 1} D] →
    {m : Nat} →
      {Point : Type u_2} →
        {FacePoint : Type u_3} →
          [inst_1 : MeasurableSpace.{u_2} Point] →
            [inst_2 : TopologicalSpace.{u_2} Point] →
              [inst_3 : MeasurableSpace.{u_3} FacePoint] →
                (data :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_1, u_2, u_3} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  (q : Point → Real → Fin m → Real) → (cell : D → Int) → (t : Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [DecidableEq D] {m} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] data q cell t =>
  NumStability.cellVolumeAverage data.measure (data.cells.cellRegion cell) fun x => q x t
```

### D015: `NumStability.DirectionalFiniteVolume.PhysicalData.cellVolume`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ab42a6e13f8e5e782dba1d7b5060d1301bc477e23349e08b558ee1d63b705c48`

Type:

```lean
{D : Type u_1} →
  [inst : DecidableEq D] →
    {m : Nat} →
      {Point : Type u_2} →
        {FacePoint : Type u_3} →
          [inst_1 : MeasurableSpace Point] →
            [inst_2 : TopologicalSpace Point] →
              [inst_3 : MeasurableSpace FacePoint] →
                NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m → (D → Int) → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  [inst : DecidableEq.{u_1 + 1} D] →
    {m : Nat} →
      {Point : Type u_2} →
        {FacePoint : Type u_3} →
          [inst_1 : MeasurableSpace.{u_2} Point] →
            [inst_2 : TopologicalSpace.{u_2} Point] →
              [inst_3 : MeasurableSpace.{u_3} FacePoint] →
                (data :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_1, u_2, u_3} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  (cell : D → Int) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [DecidableEq D] {m} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] data cell =>
  (MeasureTheory.Measure.instFunLike.coe data.measure (data.cells.cellRegion cell)).toReal
```

### D016: `NumStability.DirectionalFiniteVolume.PhysicalData.faceFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e4eea6bdd25e8249f9ef66915511061f0b6cac5fd0cefc5c7335e9be92880887`

Type:

```lean
{D : Type u_1} →
  [inst : DecidableEq D] →
    {m : Nat} →
      {Point : Type u_2} →
        {FacePoint : Type u_3} →
          [inst_1 : MeasurableSpace Point] →
            [inst_2 : TopologicalSpace Point] →
              [inst_3 : MeasurableSpace FacePoint] →
                NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m →
                  D → (Point → Real → Fin m → Real) → (D → Int) → Real → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  [inst : DecidableEq.{u_1 + 1} D] →
    {m : Nat} →
      {Point : Type u_2} →
        {FacePoint : Type u_3} →
          [inst_1 : MeasurableSpace.{u_2} Point] →
            [inst_2 : TopologicalSpace.{u_2} Point] →
              [inst_3 : MeasurableSpace.{u_3} FacePoint] →
                (data :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_1, u_2, u_3} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  (d : D) → (q : Point → Real → Fin m → Real) → (cell : D → Int) → (t : Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [DecidableEq D] {m} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] data d q cell t =>
  MeasureTheory.integral (data.faceMeasure d cell) fun point =>
    data.normalFlux d cell point (q (data.facePoint d cell point) t)
```

### D017: `NumStability.DirectionalFiniteVolume.PhysicalData.faceMeasure`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a3d394b43a1bdbc875f59dae94fa044661b105af941017817bbc0b016415268e`

Type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq D] →
        [inst_1 : MeasurableSpace Point] →
          [inst_2 : TopologicalSpace Point] →
            [inst_3 : MeasurableSpace FacePoint] →
              {m : Nat} →
                NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m →
                  D → (D → Int) → MeasureTheory.Measure FacePoint
```

Fully explicit type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq.{u_2 + 1} D] →
        [inst_1 : MeasurableSpace.{u_3} Point] →
          [inst_2 : TopologicalSpace.{u_3} Point] →
            [inst_3 : MeasurableSpace.{u_4} FacePoint] →
              {m : Nat} →
                (self :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_2, u_3, u_4} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  D → (D → Int) → @MeasureTheory.Measure.{u_4} FacePoint inst_3
```

Definition body (one-level semantic boundary):

```lean
fun D Point FacePoint [DecidableEq D] [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m
    self =>
  self.5
```

### D018: `NumStability.DirectionalFiniteVolume.PhysicalData.normalFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `2f5697240a41d49b508ba2fab0caadbbea71d2237612eaa0eb438d4a16083af3`

Type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq D] →
        [inst_1 : MeasurableSpace Point] →
          [inst_2 : TopologicalSpace Point] →
            [inst_3 : MeasurableSpace FacePoint] →
              {m : Nat} →
                NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m →
                  D → (D → Int) → FacePoint → (Fin m → Real) → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq.{u_2 + 1} D] →
        [inst_1 : MeasurableSpace.{u_3} Point] →
          [inst_2 : TopologicalSpace.{u_3} Point] →
            [inst_3 : MeasurableSpace.{u_4} FacePoint] →
              {m : Nat} →
                (self :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_2, u_3, u_4} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  D → (D → Int) → FacePoint → (Fin m → Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun D Point FacePoint [DecidableEq D] [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m
    self =>
  self.9
```

### D019: `NumStability.DirectionalFiniteVolume.faceAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `19cc5d4f68809ea7b20a1c856d115b0c25abe617ae4c392630308f10f2900c63`

Type:

```lean
{D : Type u_1} → {m : Nat} → ((D → Int) → Real → Fin m → Real) → Real → Real → (D → Int) → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {m : Nat} → (physical : (D → Int) → Real → Fin m → Real) → (s t : Real) → (cell : D → Int) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {m} physical s t cell => NumStability.oneDimensionalCellAverage (physical cell) s t
```

### D020: `NumStability.IsHyperbolicFluxOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D021: `NumStability.IsRectangleConservationLawSolution`

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

### D022: `NumStability.OneDimensionalFiniteVolumeGrid`

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

### D023: `NumStability.OneDimensionalFiniteVolumeGrid.cellLeft`

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

### D024: `NumStability.finiteVolumeCellAverageOn`

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

### D025: `NumStability.riemannFiniteVolumeUpdate`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D026: `NumStability.DirectionalFiniteVolume.PhysicalData.cells`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `ad041525e1569797f1a4ad2512e622f2e93f623c56b582bdc9b0d6a12e3dca33`

Type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq D] →
        [inst_1 : MeasurableSpace Point] →
          [inst_2 : TopologicalSpace Point] →
            [inst_3 : MeasurableSpace FacePoint] →
              {m : Nat} →
                NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m →
                  NumStability.FiniteVolumeCellPartition (D → Int) Point
```

Fully explicit type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq.{u_2 + 1} D] →
        [inst_1 : MeasurableSpace.{u_3} Point] →
          [inst_2 : TopologicalSpace.{u_3} Point] →
            [inst_3 : MeasurableSpace.{u_4} FacePoint] →
              {m : Nat} →
                (self :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_2, u_3, u_4} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  @NumStability.FiniteVolumeCellPartition.{u_2, u_3} (D → Int) Point inst_1
```

Definition body (one-level semantic boundary):

```lean
fun D Point FacePoint [DecidableEq D] [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m
    self =>
  self.1
```

### D027: `NumStability.DirectionalFiniteVolume.PhysicalData.facePoint`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `154f77db9937b527dfdc82761a1c6ecafed2fbcbbcd38225fdfb3687531b4c34`

Type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq D] →
        [inst_1 : MeasurableSpace Point] →
          [inst_2 : TopologicalSpace Point] →
            [inst_3 : MeasurableSpace FacePoint] →
              {m : Nat} →
                NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m →
                  D → (D → Int) → FacePoint → Point
```

Fully explicit type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq.{u_2 + 1} D] →
        [inst_1 : MeasurableSpace.{u_3} Point] →
          [inst_2 : TopologicalSpace.{u_3} Point] →
            [inst_3 : MeasurableSpace.{u_4} FacePoint] →
              {m : Nat} →
                (self :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_2, u_3, u_4} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  D → (D → Int) → FacePoint → Point
```

Definition body (one-level semantic boundary):

```lean
fun D Point FacePoint [DecidableEq D] [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m
    self =>
  self.6
```

### D028: `NumStability.DirectionalFiniteVolume.PhysicalData.measure`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e735ce9a7d97f512cacb3cffbb28d2d6f2f6dca2cebb80ba56733f29b7eb6190`

Type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq D] →
        [inst_1 : MeasurableSpace Point] →
          [inst_2 : TopologicalSpace Point] →
            [inst_3 : MeasurableSpace FacePoint] →
              {m : Nat} →
                NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m → MeasureTheory.Measure Point
```

Fully explicit type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq.{u_2 + 1} D] →
        [inst_1 : MeasurableSpace.{u_3} Point] →
          [inst_2 : TopologicalSpace.{u_3} Point] →
            [inst_3 : MeasurableSpace.{u_4} FacePoint] →
              {m : Nat} →
                (self :
                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_2, u_3, u_4} D Point FacePoint inst inst_1
                      inst_2 inst_3 m) →
                  @MeasureTheory.Measure.{u_3} Point inst_1
```

Definition body (one-level semantic boundary):

```lean
fun D Point FacePoint [DecidableEq D] [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m
    self =>
  self.2
```

### D029: `NumStability.DirectionalFiniteVolume.PhysicalData.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `5441eb19c16c1cdc4b8aeaaca064bc80bbaff446cbf6cb0b3dc2a14ff8bf2c66`

Type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq D] →
        [inst_1 : MeasurableSpace Point] →
          [inst_2 : TopologicalSpace Point] →
            [inst_3 : MeasurableSpace FacePoint] →
              {m : Nat} →
                (cells : NumStability.FiniteVolumeCellPartition (D → Int) Point) →
                  (measure : MeasureTheory.Measure Point) →
                    (∀ (cell : D → Int), Ne (MeasureTheory.Measure.instFunLike.coe measure (cells.cellRegion cell)) 0) →
                      (∀ (cell : D → Int),
                          Ne (MeasureTheory.Measure.instFunLike.coe measure (cells.cellRegion cell))
                            instTopENNReal.top) →
                        (D → (D → Int) → MeasureTheory.Measure FacePoint) →
                          (facePoint : D → (D → Int) → FacePoint → Point) →
                            (∀ (d : D) (cell : D → Int) (point : FacePoint),
                                And
                                  (Set.instMembership.mem
                                    (closure (cells.cellRegion (Function.update cell d (instHSub.hSub (cell d) 1))))
                                    (facePoint d cell point))
                                  (Set.instMembership.mem (closure (cells.cellRegion cell)) (facePoint d cell point))) →
                              (admissibleStates : D → Set (Fin m → Real)) →
                                (normalFlux : D → (D → Int) → FacePoint → (Fin m → Real) → Fin m → Real) →
                                  (∀ (d : D) (cell : D → Int) (point : FacePoint),
                                      NumStability.IsHyperbolicFluxOn (normalFlux d cell point) (admissibleStates d)) →
                                    NumStability.DirectionalFiniteVolume.PhysicalData D Point FacePoint m
```

Fully explicit type:

```lean
{D : Type u_2} →
  {Point : Type u_3} →
    {FacePoint : Type u_4} →
      [inst : DecidableEq.{u_2 + 1} D] →
        [inst_1 : MeasurableSpace.{u_3} Point] →
          [inst_2 : TopologicalSpace.{u_3} Point] →
            [inst_3 : MeasurableSpace.{u_4} FacePoint] →
              {m : Nat} →
                (cells : @NumStability.FiniteVolumeCellPartition.{u_2, u_3} (D → Int) Point inst_1) →
                  (measure : @MeasureTheory.Measure.{u_3} Point inst_1) →
                    (positive :
                        ∀ (cell : D → Int),
                          @Ne.{1} ENNReal
                            (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst_1)
                              (Set.{u_3} Point) (fun (x : Set.{u_3} Point) => ENNReal)
                              (@MeasureTheory.Measure.instFunLike.{u_3} Point inst_1) measure
                              (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} (D → Int) Point inst_1
                                cells cell))
                            (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal))) →
                      (finite :
                          ∀ (cell : D → Int),
                            @Ne.{1} ENNReal
                              (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst_1)
                                (Set.{u_3} Point) (fun (x : Set.{u_3} Point) => ENNReal)
                                (@MeasureTheory.Measure.instFunLike.{u_3} Point inst_1) measure
                                (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} (D → Int) Point inst_1
                                  cells cell))
                              (@Top.top.{0} ENNReal instTopENNReal)) →
                        (faceMeasure : D → (D → Int) → @MeasureTheory.Measure.{u_4} FacePoint inst_3) →
                          (facePoint : D → (D → Int) → FacePoint → Point) →
                            (incidence :
                                ∀ (d : D) (cell : (a : D) → Int) (point : FacePoint),
                                  And
                                    (@Membership.mem.{u_3, u_3} Point (Set.{u_3} Point)
                                      (@Set.instMembership.{u_3} Point)
                                      (@closure.{u_3} Point inst_2
                                        (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} (D → Int) Point
                                          inst_1 cells
                                          (@Function.update.{u_2 + 1, 1} D (fun (a : D) => Int) inst cell d
                                            (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (cell d)
                                              (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))))
                                      (facePoint d cell point))
                                    (@Membership.mem.{u_3, u_3} Point (Set.{u_3} Point)
                                      (@Set.instMembership.{u_3} Point)
                                      (@closure.{u_3} Point inst_2
                                        (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} (D → Int) Point
                                          inst_1 cells cell))
                                      (facePoint d cell point))) →
                              (admissibleStates : D → Set.{0} (Fin m → Real)) →
                                (normalFlux : D → (D → Int) → FacePoint → (Fin m → Real) → Fin m → Real) →
                                  (hyperbolic :
                                      ∀ (d : D) (cell : D → Int) (point : FacePoint),
                                        @NumStability.IsHyperbolicFluxOn m (normalFlux d cell point)
                                          (admissibleStates d)) →
                                    @NumStability.DirectionalFiniteVolume.PhysicalData.{u_2, u_3, u_4} D Point FacePoint
                                      inst inst_1 inst_2 inst_3 m
```

### D030: `NumStability.FiniteVolumeCellPartition.cellRegion`

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

### D031: `NumStability.FiniteVolumeCellPartition.domain`

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

### D032: `NumStability.IsHyperbolicFluxAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D033: `NumStability.OneDimensionalFiniteVolumeGrid.cellRight`

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

### D034: `NumStability.OneDimensionalFiniteVolumeGrid.cellVolume`

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

### D035: `NumStability.OneDimensionalFiniteVolumeGrid.mk`

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

### D036: `NumStability.cellVolumeAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D037: `NumStability.finiteVolumeCellAverageUpdate`

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

### D038: `NumStability.oneDimensionalCellAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D039: `NumStability.orderedOperatorSweep`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D040: `NumStability.FiniteVolumeCellPartition`

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

### D041: `NumStability.IsHyperbolicFluxAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `theorem`
- Distance from target type: `3`
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

### D042: `NumStability.IsHyperbolicFluxAt._proof_2`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `theorem`
- Distance from target type: `3`
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

### D043: `NumStability.IsRealHyperbolicMatrix`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D044: `NumStability.FiniteVolumeCellPartition.mk`

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

### D045: `Algebra.id`

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

### D046: `Algebra.toSMul`

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

### D047: `And`

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

### D048: `CommSemiring.toSemiring`

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

### D049: `DFunLike.coe`

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

### D050: `DecidableEq`

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

### D051: `DivInvMonoid.toDiv`

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

### D052: `ENNReal`

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

### D053: `ENNReal.toReal`

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

### D054: `Eq`

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

### D055: `Exists`

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

### D056: `Fin`

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

### D057: `Fin.fintype`

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

### D058: `Finset.range`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Range`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D059: `Finset.sum`

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

### D060: `Fintype`

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

### D061: `Function.hasSMul`

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

### D062: `Function.update`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Function.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D063: `HAdd.hAdd`

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

### D064: `HAppend.hAppend`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f19ccdee2b2776c250a9c50188f1cf355ac1a7621d69c0ce7d1335bd5521b354`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAppend α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HAppend.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAppend α β γ] => self.1
```

### D065: `HDiv.hDiv`

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

### D066: `HMul.hMul`

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

### D067: `HSMul.hSMul`

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

### D068: `HSub.hSub`

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

### D069: `InnerProductSpace.toNormedSpace`

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

### D070: `Int`

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

### D071: `Int.instAdd`

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

### D072: `LE.le`

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

### D073: `LT.lt`

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

### D074: `List`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ec06a72bb009eecaedd9dbf6a3349bbea0bbc480e0a21179f4e21b3e219b952d`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

### D075: `List.cons`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `d4f0bc0954b11abbe9f8e60dd8762e7797f488b1975b155440101828c4c1ea14`

Type:

```lean
{α : Type u} → α → List α → List α
```

Fully explicit type:

```lean
{α : Type u} → (head : α) → (tail : List.{u} α) → List.{u} α
```

### D076: `List.instAppend`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a4e7aef57b0deffb52c21cc741e84fb942ab6344c5d119da717f5dc1d5ab086d`

Type:

```lean
{α : Type u} → Append (List α)
```

Fully explicit type:

```lean
{α : Type u} → Append.{u} (List.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { append := List.append }
```

### D077: `List.instMembership`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `51cf805fcbf00d4a64b4e72cb246d510950ce4cda54bc6c8a74110b6dc8a6a95`

Type:

```lean
{α : Type u} → Membership α (List α)
```

Fully explicit type:

```lean
{α : Type u} → Membership.{u, u} α (List.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { mem := fun l a => List.Mem a l }
```

### D078: `List.nil`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `6fc023f8c03f1dc78130598a9c55a666564e22fa908127753ee95d45e602196f`

Type:

```lean
{α : Type u} → List α
```

Fully explicit type:

```lean
{α : Type u} → List.{u} α
```

### D079: `MeasurableSpace`

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

### D080: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D081: `MeasureTheory.Measure`

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

### D082: `MeasureTheory.Measure.instFunLike`

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

### D083: `MeasureTheory.MeasureSpace.pi`

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

### D084: `MeasureTheory.MeasureSpace.toMeasurableSpace`

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

### D085: `MeasureTheory.MeasureSpace.volume`

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

### D086: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D087: `Membership.mem`

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

### D088: `Nat`

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

### D089: `Nat.cast`

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

### D090: `Ne`

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

### D091: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D092: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

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

### D093: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D094: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D095: `Norm.norm`

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

### D096: `NormedCommRing.toNormedRing`

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

### D097: `NormedCommRing.toSeminormedCommRing`

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

### D098: `NormedRing.toNorm`

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

### D099: `NormedSpace.toModule`

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

### D100: `OfNat.ofNat`

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

### D101: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D102: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D103: `Pi.addCommMonoid`

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

### D104: `Pi.instSub`

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

### D105: `Pi.normedAddCommGroup`

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

### D106: `Pi.normedRing`

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

### D107: `Pi.normedSpace`

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

### D108: `Pi.seminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D109: `Pi.topologicalSpace`

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

### D110: `Prod`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `3df3b0cff45fb04022db70edff8e5747def6cae602cd8c33e673abac1bb4e347`

Type:

```lean
Type u → Type v → Type (max u v)
```

Fully explicit type:

```lean
(α : Type u) → (β : Type v) → Type (max u v)
```

### D111: `Prod.mk`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `e42ba07a23655c2aae0502df1e03897313eaf034a0e84cfef98e91f6b4920097`

Type:

```lean
{α : Type u} → {β : Type v} → α → β → Prod α β
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (fst : α) → (snd : β) → Prod.{u, v} α β
```

### D112: `Prod.snd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a70aebf9da319c4b02023421b33923182c4d5164c2087035016589b80ed1191a`

Type:

```lean
{α : Type u} → {β : Type v} → Prod α β → β
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (self : Prod.{u, v} α β) → β
```

Definition body (one-level semantic boundary):

```lean
fun α β self => self.2
```

### D113: `PseudoMetricSpace.toUniformSpace`

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

### D114: `RCLike.toInnerProductSpaceReal`

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

### D115: `Real`

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

### D116: `Real.instAdd`

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

### D117: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D118: `Real.instAddCommMonoid`

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

### D119: `Real.instCommSemiring`

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

### D120: `Real.instDivInvMonoid`

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

### D121: `Real.instLE`

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

### D122: `Real.instLT`

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

### D123: `Real.instMul`

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

### D124: `Real.instRCLike`

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

### D125: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D126: `Real.instSub`

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

### D127: `Real.instZero`

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

### D128: `Real.measureSpace`

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

### D129: `Real.normedAddCommGroup`

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

### D130: `Real.normedCommRing`

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

### D131: `Real.normedField`

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

### D132: `Real.pseudoMetricSpace`

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

### D133: `Real.semiring`

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

### D134: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D135: `SeminormedAddCommGroup.toSeminormedAddGroup`

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

### D136: `SeminormedAddGroup.toContinuousENorm`

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

### D137: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

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

### D138: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D139: `Set`

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

### D140: `Set.instMembership`

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

### D141: `Subtype`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `3b0bb8433bd0c981dbdb4d6256bf74c50e9883207dae8d309dcb705135cf932c`

Type:

```lean
{α : Sort u} → (α → Prop) → Sort (max 1 u)
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Sort (max 1 u)
```

### D142: `Subtype.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Sets`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D143: `TopologicalSpace`

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

### D144: `UniformSpace.toTopologicalSpace`

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

### D145: `Zero.toOfNat0`

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

### D146: `instDecidableNot`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D147: `instHAdd`

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

### D148: `instHAppendOfAppend`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3c8b128f1a53b3c06845db74f34230cce2f5f789c5291dec5a81a12696c383f9`

Type:

```lean
{α : Type u_1} → [Append α] → HAppend α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Append.{u_1} α] → HAppend.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Append α] => { hAppend := fun a b => inst.append a b }
```

### D149: `instHDiv`

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

### D150: `instHMul`

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

### D151: `instHSMul`

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

### D152: `instHSub`

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

### D153: `instLTNat`

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

### D154: `instNatCastInt`

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

### D155: `instOfNat`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D156: `instOfNatNat`

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

### D157: `AddCommGroup`

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

### D158: `AddCommGroup.toAddCommMonoid`

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

### D159: `AddCommGroup.toAddGroup`

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

### D160: `AddGroup.toSubNegMonoid`

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

### D161: `Finset.erase`

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

### D162: `Finset.prod`

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

### D163: `Finset.univ`

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

### D164: `IntervalIntegrable`

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

### D165: `List.map`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D166: `MeasureTheory.IntegrableOn`

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

### D167: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

Fully explicit type:

```lean
(R : Type u) → (M : Type v) → [Semiring.{u} R] → [AddCommMonoid.{v} M] → Type (max u v)
```

### D168: `NormedAddCommGroup`

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

### D169: `NormedAddCommGroup.toNormedAddGroup`

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

### D170: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D171: `NormedAddGroup.toAddGroup`

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

### D172: `NormedAddGroup.toENormedAddMonoid`

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

### D173: `NormedSpace`

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

### D174: `Pi.normedAddGroup`

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

### D175: `Prod.fst`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `31dfcc70f250d68311839281cfb552859ef6a5cdd31e725091d6a2a2f7fb2165`

Type:

```lean
{α : Type u} → {β : Type v} → Prod α β → α
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (self : Prod.{u, v} α β) → α
```

Definition body (one-level semantic boundary):

```lean
fun α β self => self.1
```

### D176: `Real.instCommMonoid`

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

### D177: `Real.instPreorder`

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

### D178: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D179: `SeminormedAddCommGroup.toPseudoMetricSpace`

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

### D180: `Set.Ico`

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

### D181: `Set.pi`

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

### D182: `Set.uIcc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.UnorderedInterval`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D183: `Set.univ`

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

### D184: `SubNegMonoid.toSub`

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

### D185: `Subtype.val`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D186: `intervalIntegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D187: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D188: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D189: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D190: `ContinuousLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `inductive`
- Distance from target type: `3`
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

### D191: `ContinuousLinearMap.toLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D192: `DFinsupp.instEquivLikeLinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.DFinsupp`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D193: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D194: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D195: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D196: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D197: `ESeminormedAddCommMonoid.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D198: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D199: `ESeminormedAddMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D200: `EquivLike.toFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Equiv`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D201: `HasFDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.FDeriv.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D202: `Int.instSub`

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

### D203: `Inv.inv`

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

### D204: `LinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Equiv.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
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

### D205: `LinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
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

### D206: `LinearMap.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D207: `LinearMap.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D208: `LinearMap.toMatrix'`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.ToLin`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D209: `List.foldl`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D210: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D211: `Matrix.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D212: `Matrix.module`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D213: `MeasureTheory.Measure.restrict`

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

### D214: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D215: `NonAssocSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D216: `NormedAddCommGroup.toENormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D217: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D218: `Real.instInv`

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

### D219: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D220: `RingHom.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Hom.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D221: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D222: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D223: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D224: `SubNegMonoid.toAddMonoid`

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

### D225: `Top.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Notation`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D226: `closure`

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

### D227: `instDecidableEqFin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D228: `instTopENNReal`

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

### D229: `instZeroENNReal`

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

### D230: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D231: `CommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D232: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D233: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D234: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
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

### D235: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D236: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D237: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D238: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D239: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D240: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D241: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D242: `Real.commRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D243: `RingHomInvPair`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.CompTypeclasses`
- Declaration kind: `inductive`
- Distance from target type: `4`
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

### D244: `SMulCommClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `25ca5b6e5618ba5262412f36bda1bf0ec64f56ca37162dc1ff3be3719f8983c5`

Type:

```lean
(M : Type u_9) → (N : Type u_10) → (α : Type u_11) → [SMul M α] → [SMul N α] → Prop
```

Fully explicit type:

```lean
(M : Type u_9) → (N : Type u_10) → (α : Type u_11) → [SMul.{u_9, u_11} M α] → [SMul.{u_10, u_11} N α] → Prop
```

### D245: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D246: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D247: `CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra`

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

### D248: `CompleteBooleanAlgebra.toCompleteDistribLattice`

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

### D249: `CompleteBooleanAlgebra.toCompleteLattice`

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

### D250: `CompleteDistribLattice.toFrame`

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

### D251: `CompleteLattice.instOmegaCompletePartialOrder`

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

### D252: `Disjoint`

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

### D253: `HeytingAlgebra.toOrderBot`

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

### D254: `Iff`

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

### D255: `MeasurableSet`

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

### D256: `Nonempty`

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

### D257: `OmegaCompletePartialOrder.toPartialOrder`

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

### D258: `Order.Frame.toHeytingAlgebra`

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

### D259: `Set.instCompleteAtomicBooleanAlgebra`

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
