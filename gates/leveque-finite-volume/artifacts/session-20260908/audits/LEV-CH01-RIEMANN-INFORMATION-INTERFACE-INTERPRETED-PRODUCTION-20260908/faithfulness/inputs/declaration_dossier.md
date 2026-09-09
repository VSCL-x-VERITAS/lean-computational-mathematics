# Declaration dossier for LEV-CH01-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
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
      let problem
```

## Elaborated target type

```lean
∀ {m : Nat},
  instLTNat.lt 0 m →
    ∀ (grid : NumStability.OneDimensionalFiniteVolumeGrid)
      {law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)}
      {Result : NumStability.HyperbolicRiemannProblem law → Type u_1} {Information : Type u_2}
      (method : NumStability.RiemannInformationFluxMethod law Result Information) (old : Int → Fin m → Real)
      (hdomain : ∀ (j : Int), method.domain (NumStability.adjacentCellRiemannProblem law old j))
      {q : Real → Real → Fin m → Real},
      NumStability.IsRectangleConservationLawSolution q law.physicalFlux →
        ∀ {s t : Real},
          Real.instLT.lt s t →
            And (instLTNat.lt 0 m)
              (And
                (∀ (a b : Real),
                  Filter.Eventually
                    (fun τ =>
                      HasDerivAt (fun r => intervalIntegral (fun x => q x r) a b Real.measureSpace.volume)
                        (instHSub.hSub (law.physicalFlux (q a τ)) (law.physicalFlux (q b τ))) τ)
                    (MeasureTheory.ae Real.measureSpace.volume))
                (And
                  (∀ (state : Fin m → Real) (j : Int),
                    Eq (method.interfaceFlux (fun x => state) ⋯ j) (law.physicalFlux state))
                  (And
                    (∀ (j : Int),
                      let problem := NumStability.adjacentCellRiemannProblem law old j;
                      have result := method.solve problem ⋯;
                      And (Eq (grid.cellRight (instHSub.hSub j 1)) (grid.cellLeft j))
                        (And (Eq problem.leftState (old (instHSub.hSub j 1)))
                          (And (Eq problem.rightState (old j))
                            (And (Eq (method.selectedResult old hdomain j) result)
                              (Eq (method.interfaceFlux old hdomain j)
                                (method.numericalFlux (method.extract result)))))))
                    (∀ (i : Int),
                      And
                        (NumStability.IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
                          (NumStability.finiteVolumeCellAverageOn grid (fun x => q x s) i))
                        (And
                          (NumStability.IsOneDimensionalCellAverage (fun x => q x t) (grid.cellLeft i)
                            (grid.cellRight i) (NumStability.finiteVolumeCellAverageOn grid (fun x => q x t) i))
                          (And
                            (Eq (NumStability.finiteVolumeCellAverageOn grid (fun x => q x s) i)
                              (NumStability.cellVolumeAverage Real.measureSpace.volume
                                (Set.Ioc (grid.cellLeft i) (grid.cellRight i)) fun x => q x s))
                            (And
                              (NumStability.IsOneDimensionalCellAverage
                                (fun τ => law.physicalFlux (q (grid.cellLeft i) τ)) s t
                                (NumStability.timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i))
                              (And
                                (Eq (NumStability.timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i)
                                  (NumStability.cellVolumeAverage Real.measureSpace.volume (Set.Ioc s t) fun τ =>
                                    law.physicalFlux (q (grid.cellLeft i) τ)))
                                (And
                                  (Eq
                                    (NumStability.riemannFiniteVolumeUpdate grid (instHSub.hSub t s) old
                                      (method.interfaceFlux old hdomain) i)
                                    (instHSub.hSub (old i)
                                      (instHSMul.hSMul (instHDiv.hDiv (instHSub.hSub t s) (grid.cellVolume i))
                                        (instHSub.hSub (method.interfaceFlux old hdomain (instHAdd.hAdd i 1))
                                          (method.interfaceFlux old hdomain i)))))
                                  (And
                                    (Eq
                                      (instHSMul.hSMul (grid.cellVolume i)
                                        (instHSub.hSub
                                          (NumStability.riemannFiniteVolumeUpdate grid (instHSub.hSub t s) old
                                            (method.interfaceFlux old hdomain) i)
                                          (NumStability.finiteVolumeCellAverageOn grid (fun x => q x t) i)))
                                      (instHAdd.hAdd
                                        (instHSMul.hSMul (grid.cellVolume i)
                                          (instHSub.hSub (old i)
                                            (NumStability.finiteVolumeCellAverageOn grid (fun x => q x s) i)))
                                        (instHSMul.hSMul (instHSub.hSub t s)
                                          (instHSub.hSub
                                            (instHSub.hSub (method.interfaceFlux old hdomain i)
                                              (NumStability.timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i))
                                            (instHSub.hSub (method.interfaceFlux old hdomain (instHAdd.hAdd i 1))
                                              (NumStability.timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t
                                                (instHAdd.hAdd i 1)))))))
                                    (∀ (oldBound leftBound rightBound : Real),
                                      Real.instLE.le
                                          (Pi.normedRing.norm
                                            (instHSub.hSub (old i)
                                              (NumStability.finiteVolumeCellAverageOn grid (fun x => q x s) i)))
                                          oldBound →
                                        Real.instLE.le
                                            (Pi.normedRing.norm
                                              (instHSub.hSub (method.interfaceFlux old hdomain i)
                                                (NumStability.timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t
                                                  i)))
                                            leftBound →
                                          Real.instLE.le
                                              (Pi.normedRing.norm
                                                (instHSub.hSub (method.interfaceFlux old hdomain (instHAdd.hAdd i 1))
                                                  (NumStability.timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t
                                                    (instHAdd.hAdd i 1))))
                                              rightBound →
                                            Real.instLE.le
                                              (Pi.normedRing.norm
                                                (instHSub.hSub
                                                  (NumStability.riemannFiniteVolumeUpdate grid (instHSub.hSub t s) old
                                                    (method.interfaceFlux old hdomain) i)
                                                  (NumStability.finiteVolumeCellAverageOn grid (fun x => q x t) i)))
                                              (instHAdd.hAdd oldBound
                                                (instHMul.hMul (instHDiv.hDiv (instHSub.hSub t s) (grid.cellVolume i))
                                                  (instHAdd.hAdd leftBound rightBound))))))))))))))
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} (hm : @LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
  (grid : NumStability.OneDimensionalFiniteVolumeGrid)
  {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)}
  {Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1} {Information : Type u_2}
  (method : @NumStability.RiemannInformationFluxMethod.{u_1, u_2} m law Result Information) (old : Int → Fin m → Real)
  (hdomain :
    ∀ (j : Int),
      @NumStability.RiemannInformationFluxMethod.domain.{u_1, u_2} m law Result Information method
        (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law old j))
  {q : Real → Real → Fin m → Real}
  (hq :
    @NumStability.IsRectangleConservationLawSolution.{0} (Fin m → Real)
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
      q (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m) (Fin.fintype m) law))
  {s t : Real} (hst : @LT.lt.{0} Real Real.instLT s t),
  And (@LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
    (And
      (∀ (a b : Real),
        @Filter.Eventually.{0} Real
          (fun (τ : Real) =>
            @HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)
              (Fin m → Real)
              (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommGroup)
              (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real
                (@DivisionSemiring.toSemiring.{0} Real
                  (@Semifield.toDivisionSemiring.{0} Real
                    (@Field.toSemifield.{0} Real
                      (@NormedField.toField.{0} Real
                        (@NontriviallyNormedField.toNormedField.{0} Real
                          (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))
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
              (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                @UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@instContinuousSMulForall.{0, 0, 0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real
                    (@SeminormedRing.toPseudoMetricSpace.{0} Real
                      (@SeminormedCommRing.toSeminormedRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real
                          (@NormedField.toNormedCommRing.{0} Real
                            (@NontriviallyNormedField.toNormedField.{0} Real
                              (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
                (Fin m) (fun (a : Fin m) => Real)
                (fun (i : Fin m) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (fun (i : Fin m) =>
                  @SemigroupAction.toSMul.{0, 0} Real ((fun (a : Fin m) => Real) i)
                    (@Monoid.toSemigroup.{0} Real
                      (@MonoidWithZero.toMonoid.{0} Real
                        (@Semiring.toMonoidWithZero.{0} Real
                          (@DivisionSemiring.toSemiring.{0} Real
                            (@Semifield.toDivisionSemiring.{0} Real
                              (@Field.toSemifield.{0} Real
                                (@NormedField.toField.{0} Real
                                  (@NontriviallyNormedField.toNormedField.{0} Real
                                    (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                      Real.denselyNormedField)))))))))
                    (@MulAction.toSemigroupAction.{0, 0} Real ((fun (a : Fin m) => Real) i)
                      (@MonoidWithZero.toMonoid.{0} Real
                        (@Semiring.toMonoidWithZero.{0} Real
                          (@DivisionSemiring.toSemiring.{0} Real
                            (@Semifield.toDivisionSemiring.{0} Real
                              (@Field.toSemifield.{0} Real
                                (@NormedField.toField.{0} Real
                                  (@NontriviallyNormedField.toNormedField.{0} Real
                                    (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                      Real.denselyNormedField))))))))
                      ((fun (i : Fin m) =>
                          @DistribMulAction.toMulAction.{0, 0} Real ((fun (a : Fin m) => Real) i)
                            (@MonoidWithZero.toMonoid.{0} Real
                              (@Semiring.toMonoidWithZero.{0} Real
                                (@DivisionSemiring.toSemiring.{0} Real
                                  (@Semifield.toDivisionSemiring.{0} Real
                                    (@Field.toSemifield.{0} Real
                                      (@NormedField.toField.{0} Real
                                        (@NontriviallyNormedField.toNormedField.{0} Real
                                          (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                            Real.denselyNormedField))))))))
                            ((fun (i : Fin m) =>
                                @AddCommMonoid.toAddMonoid.{0} ((fun (a : Fin m) => Real) i)
                                  ((fun (i : Fin m) =>
                                      @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                        (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                          (@Semiring.toNonUnitalSemiring.{0} Real
                                            (@Ring.toSemiring.{0} Real Real.instRing))))
                                    i))
                              i)
                            ((fun (i : Fin m) =>
                                @Module.toDistribMulAction.{0, 0} Real ((fun (a : Fin m) => Real) i)
                                  (@DivisionSemiring.toSemiring.{0} Real
                                    (@Semifield.toDivisionSemiring.{0} Real
                                      (@Field.toSemifield.{0} Real
                                        (@NormedField.toField.{0} Real
                                          (@NontriviallyNormedField.toNormedField.{0} Real
                                            (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                              Real.denselyNormedField))))))
                                  ((fun (i : Fin m) =>
                                      @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                        (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                          (@Semiring.toNonUnitalSemiring.{0} Real
                                            (@Ring.toSemiring.{0} Real Real.instRing))))
                                    i)
                                  ((fun (i : Fin m) =>
                                      @NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                        (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                                    i))
                              i))
                        i)))
                fun (i : Fin m) =>
                @IsModuleTopology.toContinuousSMul.{0, 0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real Real.instAdd
                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring Real.semiring
                    (@Algebra.id.{0} Real Real.instCommSemiring))
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@IsTopologicalSemiring.toIsModuleTopology.{0} Real Real.semiring
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal)))
              (fun (r : Real) =>
                @intervalIntegral.{0} (Fin m → Real)
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
                  (fun (x : Real) => q x r) a b (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace))
              (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                (@instHSub.{0} (Fin m → Real)
                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m) (Fin.fintype m) law
                  (q a τ))
                (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m) (Fin.fintype m) law
                  (q b τ)))
              τ)
          (@MeasureTheory.ae.{0, 0} Real
            (@MeasureTheory.Measure.{0} Real (@MeasureTheory.MeasureSpace.toMeasurableSpace.{0} Real Real.measureSpace))
            (@MeasureTheory.Measure.instFunLike.{0} Real
              (@MeasureTheory.MeasureSpace.toMeasurableSpace.{0} Real Real.measureSpace))
            (@MeasureTheory.Measure.instOuterMeasureClass.{0} Real
              (@MeasureTheory.MeasureSpace.toMeasurableSpace.{0} Real Real.measureSpace))
            (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)))
      (And
        (∀ (state : Fin m → Real) (j : Int),
          @Eq.{1} (Fin m → Real)
            (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law Result Information method
              (fun (x : Int) => state)
              (fun (x : Int) =>
                @NumStability.RiemannInformationFluxMethod.constants_in_domain.{u_1, u_2} m law Result Information
                  method state)
              j)
            (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m) (Fin.fintype m) law state))
        (And
          (∀ (j : Int),
            let problem : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law :=
              @NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law old j;
            have result : Result problem :=
              @NumStability.RiemannInformationFluxMethod.solve.{u_1, u_2} m law Result Information method problem
                (hdomain j);
            And
              (@Eq.{1} Real
                (NumStability.OneDimensionalFiniteVolumeGrid.cellRight grid
                  (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) j
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft grid j))
              (And
                (@Eq.{1} (Fin m → Real)
                  (@NumStability.HyperbolicRiemannProblem.leftState.{0} (Fin m) (Fin.fintype m) law problem)
                  (old
                    (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) j
                      (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))
                (And
                  (@Eq.{1} (Fin m → Real)
                    (@NumStability.HyperbolicRiemannProblem.rightState.{0} (Fin m) (Fin.fintype m) law problem) (old j))
                  (And
                    (@Eq.{u_1 + 1}
                      (Result (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law old j))
                      (@NumStability.RiemannInformationFluxMethod.selectedResult.{u_1, u_2} m law Result Information
                        method old hdomain j)
                      result)
                    (@Eq.{1} (Fin m → Real)
                      (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law Result Information
                        method old hdomain j)
                      (@NumStability.RiemannInformationFluxMethod.numericalFlux.{u_1, u_2} m law Result Information
                        method
                        (@NumStability.RiemannInformationFluxMethod.extract.{u_1, u_2} m law Result Information method
                          problem result)))))))
          (∀ (i : Int),
            And
              (@NumStability.IsOneDimensionalCellAverage.{0} (Fin m → Real)
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
                (fun (x : Real) => q x s) (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft grid i)
                (NumStability.OneDimensionalFiniteVolumeGrid.cellRight grid i)
                (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
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
                  grid (fun (x : Real) => q x s) i))
              (And
                (@NumStability.IsOneDimensionalCellAverage.{0} (Fin m → Real)
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
                  (fun (x : Real) => q x t) (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft grid i)
                  (NumStability.OneDimensionalFiniteVolumeGrid.cellRight grid i)
                  (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
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
                    grid (fun (x : Real) => q x t) i))
                (And
                  (@Eq.{1} (Fin m → Real)
                    (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
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
                      grid (fun (x : Real) => q x s) i)
                    (@NumStability.cellVolumeAverage.{0, 0} Real (Fin m → Real)
                      (@MeasureTheory.MeasureSpace.toMeasurableSpace.{0} Real Real.measureSpace)
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
                      (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)
                      (@Set.Ioc.{0} Real Real.instPreorder (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft grid i)
                        (NumStability.OneDimensionalFiniteVolumeGrid.cellRight grid i))
                      fun (x : Real) => q x s))
                  (And
                    (@NumStability.IsOneDimensionalCellAverage.{0} (Fin m → Real)
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
                      (fun (τ : Real) =>
                        @NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m) (Fin.fintype m)
                          law (q (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft grid i) τ))
                      s t
                      (@NumStability.timeAveragedPhysicalFaceFlux m grid q
                        (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m) (Fin.fintype m)
                          law)
                        s t i))
                    (And
                      (@Eq.{1} (Fin m → Real)
                        (@NumStability.timeAveragedPhysicalFaceFlux m grid q
                          (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m)
                            (Fin.fintype m) law)
                          s t i)
                        (@NumStability.cellVolumeAverage.{0, 0} Real (Fin m → Real)
                          (@MeasureTheory.MeasureSpace.toMeasurableSpace.{0} Real Real.measureSpace)
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
                          (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)
                          (@Set.Ioc.{0} Real Real.instPreorder s t) fun (τ : Real) =>
                          @NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m) (Fin.fintype m)
                            law (q (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft grid i) τ)))
                      (And
                        (@Eq.{1} (Fin m → Real)
                          (@NumStability.riemannFiniteVolumeUpdate.{0} (Fin m) grid
                            (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s) old
                            (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law Result
                              Information method old hdomain)
                            i)
                          (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                            (@instHSub.{0} (Fin m → Real)
                              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                            (old i)
                            (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                              (@instHSMul.{0, 0} Real (Fin m → Real)
                                (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                    (@Algebra.id.{0} Real Real.instCommSemiring))))
                              (@HDiv.hDiv.{0, 0, 0} Real Real Real
                                (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                                (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
                                (NumStability.OneDimensionalFiniteVolumeGrid.cellVolume grid i))
                              (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                (@instHSub.{0} (Fin m → Real)
                                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                    Real.instSub))
                                (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law Result
                                  Information method old hdomain
                                  (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) i
                                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                                (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law Result
                                  Information method old hdomain i)))))
                        (And
                          (@Eq.{1} (Fin m → Real)
                            (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                              (@instHSMul.{0, 0} Real (Fin m → Real)
                                (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                    (@Algebra.id.{0} Real Real.instCommSemiring))))
                              (NumStability.OneDimensionalFiniteVolumeGrid.cellVolume grid i)
                              (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                (@instHSub.{0} (Fin m → Real)
                                  (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                    Real.instSub))
                                (@NumStability.riemannFiniteVolumeUpdate.{0} (Fin m) grid
                                  (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s) old
                                  (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law Result
                                    Information method old hdomain)
                                  i)
                                (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
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
                                  grid (fun (x : Real) => q x t) i)))
                            (@HAdd.hAdd.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                              (@instHAdd.{0} (Fin m → Real)
                                (@Pi.instAdd.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAdd))
                              (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                (@instHSMul.{0, 0} Real (Fin m → Real)
                                  (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                    (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                      (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                      (@Algebra.id.{0} Real Real.instCommSemiring))))
                                (NumStability.OneDimensionalFiniteVolumeGrid.cellVolume grid i)
                                (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                  (@instHSub.{0} (Fin m → Real)
                                    (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                      Real.instSub))
                                  (old i)
                                  (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
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
                                    grid (fun (x : Real) => q x s) i)))
                              (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                (@instHSMul.{0, 0} Real (Fin m → Real)
                                  (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                    (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                      (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                      (@Algebra.id.{0} Real Real.instCommSemiring))))
                                (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
                                (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                  (@instHSub.{0} (Fin m → Real)
                                    (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                      Real.instSub))
                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                    (@instHSub.{0} (Fin m → Real)
                                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                        Real.instSub))
                                    (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law Result
                                      Information method old hdomain i)
                                    (@NumStability.timeAveragedPhysicalFaceFlux m grid q
                                      (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m)
                                        (Fin.fintype m) law)
                                      s t i))
                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                    (@instHSub.{0} (Fin m → Real)
                                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                        Real.instSub))
                                    (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law Result
                                      Information method old hdomain
                                      (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) i
                                        (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                                    (@NumStability.timeAveragedPhysicalFaceFlux m grid q
                                      (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m)
                                        (Fin.fintype m) law)
                                      s t
                                      (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) i
                                        (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))))))
                          (∀ (oldBound leftBound rightBound : Real),
                            @LE.le.{0} Real Real.instLE
                                (@Norm.norm.{0} (Fin m → Real)
                                  (@NormedRing.toNorm.{0} (Fin m → Real)
                                    (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                      fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                    (@instHSub.{0} (Fin m → Real)
                                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                        Real.instSub))
                                    (old i)
                                    (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
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
                                      grid (fun (x : Real) => q x s) i)))
                                oldBound →
                              @LE.le.{0} Real Real.instLE
                                  (@Norm.norm.{0} (Fin m → Real)
                                    (@NormedRing.toNorm.{0} (Fin m → Real)
                                      (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                        fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                    (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                      (@instHSub.{0} (Fin m → Real)
                                        (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                          Real.instSub))
                                      (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law Result
                                        Information method old hdomain i)
                                      (@NumStability.timeAveragedPhysicalFaceFlux m grid q
                                        (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m)
                                          (Fin.fintype m) law)
                                        s t i)))
                                  leftBound →
                                @LE.le.{0} Real Real.instLE
                                    (@Norm.norm.{0} (Fin m → Real)
                                      (@NormedRing.toNorm.{0} (Fin m → Real)
                                        (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                          fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                      (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                        (@instHSub.{0} (Fin m → Real)
                                          (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                            Real.instSub))
                                        (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law
                                          Result Information method old hdomain
                                          (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) i
                                            (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                                        (@NumStability.timeAveragedPhysicalFaceFlux m grid q
                                          (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0}
                                            (Fin m) (Fin.fintype m) law)
                                          s t
                                          (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) i
                                            (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))))
                                    rightBound →
                                  @LE.le.{0} Real Real.instLE
                                    (@Norm.norm.{0} (Fin m → Real)
                                      (@NormedRing.toNorm.{0} (Fin m → Real)
                                        (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                          fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                      (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                        (@instHSub.{0} (Fin m → Real)
                                          (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                            Real.instSub))
                                        (@NumStability.riemannFiniteVolumeUpdate.{0} (Fin m) grid
                                          (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
                                          old
                                          (@NumStability.RiemannInformationFluxMethod.interfaceFlux.{u_1, u_2} m law
                                            Result Information method old hdomain)
                                          i)
                                        (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
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
                                          grid (fun (x : Real) => q x t) i)))
                                    (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd) oldBound
                                      (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                        (@HDiv.hDiv.{0, 0, 0} Real Real Real
                                          (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                                          (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) t s)
                                          (NumStability.OneDimensionalFiniteVolumeGrid.cellVolume grid i))
                                        (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd) leftBound
                                          rightBound))))))))))))))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.MeasureTheory.Integral.Average`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalFluxAverage` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference` imports: `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateError` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalFluxAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateError`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- `ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiationThm`, `Mathlib.MeasureTheory.SpecificCodomains.Pi`, `Mathlib.Analysis.Calculus.Deriv.Prod`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`, `ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HyperbolicRiemannProblem`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ef94dbe7341f421784d8b34d4523d9de830fbcdb2525e47718ca5d89eeb6e2fa`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] → NumStability.OneDimensionalHyperbolicConservationLaw Component → Type u_1
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (_law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst) → Type u_1
```

### D002: `NumStability.HyperbolicRiemannProblem.leftState`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `34f07343b7d88ae80f17bc569a25c144ea62ce8e15e46bc7a6a2bdf9556ea71a`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {_law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      NumStability.HyperbolicRiemannProblem _law → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {_law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      (self : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst _law) → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] _law self => self.1
```

### D003: `NumStability.HyperbolicRiemannProblem.rightState`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5c0b21b126c5177fcabe9b75b65bddbe73bf9436d65b364982678e91820e6803`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {_law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      NumStability.HyperbolicRiemannProblem _law → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {_law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      (self : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst _law) → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] _law self => self.2
```

### D004: `NumStability.IsOneDimensionalCellAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ac4875f1788587b8337fca28f0d4ec0e9a076fe45ed035a31c5cd8fdac11ff`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → E → Prop
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (field : Real → E) → (left right : Real) → (average : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] field left right average =>
  And (Real.instLT.lt left right)
    (And (IntervalIntegrable field Real.measureSpace.volume left right)
      (Eq average (NumStability.oneDimensionalCellAverage field left right)))
```

### D005: `NumStability.IsRectangleConservationLawSolution`

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

### D006: `NumStability.OneDimensionalFiniteVolumeGrid`

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

### D007: `NumStability.OneDimensionalFiniteVolumeGrid.cellLeft`

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

### D008: `NumStability.OneDimensionalFiniteVolumeGrid.cellRight`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D009: `NumStability.OneDimensionalFiniteVolumeGrid.cellVolume`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D010: `NumStability.OneDimensionalHyperbolicConservationLaw`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2d256393d65a30707d17543757fdaf16f312e530ad830b462498f9a004f47d13`

Type:

```lean
(Component : Type u_1) → [Fintype Component] → Type u_1
```

Fully explicit type:

```lean
(Component : Type u_1) → [Fintype.{u_1} Component] → Type u_1
```

### D011: `NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `38e8edada8c0a662e811fec59ac2b9f5ec90a5208b05e306b00d9cadf14503fa`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    NumStability.OneDimensionalHyperbolicConservationLaw Component → (Component → Real) → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (self : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst) →
      (Component → Real) → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] self => self.1
```

### D012: `NumStability.RiemannInformationFluxMethod`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `53604fc405085cd8ce103bf0bb73c32a8082f2b85e3f73c460df9608edafa8ce`

Type:

```lean
{m : Nat} →
  (law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)) →
    (NumStability.HyperbolicRiemannProblem law → Type u_1) → Type u_2 → Type (max u_1 u_2)
```

Fully explicit type:

```lean
{m : Nat} →
  (law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)) →
    (Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1) →
      (Information : Type u_2) → Type (max u_1 u_2)
```

### D013: `NumStability.RiemannInformationFluxMethod.constants_in_domain`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `489edc3220aa4bc00812557050e603d67c35df2fac255f8bd45828344cfe2ee2`

Type:

```lean
∀ {m : Nat} {law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)}
  {Result : NumStability.HyperbolicRiemannProblem law → Type u_1} {Information : Type u_2}
  (self : NumStability.RiemannInformationFluxMethod law Result Information) (state : Fin m → Real),
  self.domain { leftState := state, rightState := state }
```

Fully explicit type:

```lean
∀ {m : Nat} {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)}
  {Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1} {Information : Type u_2}
  (self : @NumStability.RiemannInformationFluxMethod.{u_1, u_2} m law Result Information) (state : Fin m → Real),
  @NumStability.RiemannInformationFluxMethod.domain.{u_1, u_2} m law Result Information self
    (@NumStability.HyperbolicRiemannProblem.mk.{0} (Fin m) (Fin.fintype m) law state state)
```

### D014: `NumStability.RiemannInformationFluxMethod.domain`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cde1506394adccc3efb0a4d1915c28e9587e019aa197509a668d1bfd0c36e278`

Type:

```lean
{m : Nat} →
  {law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)} →
    {Result : NumStability.HyperbolicRiemannProblem law → Type u_1} →
      {Information : Type u_2} →
        NumStability.RiemannInformationFluxMethod law Result Information →
          NumStability.HyperbolicRiemannProblem law → Prop
```

Fully explicit type:

```lean
{m : Nat} →
  {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)} →
    {Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1} →
      {Information : Type u_2} →
        (self : @NumStability.RiemannInformationFluxMethod.{u_1, u_2} m law Result Information) →
          @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Prop
```

Definition body (one-level semantic boundary):

```lean
fun m law Result Information self => self.1
```

### D015: `NumStability.RiemannInformationFluxMethod.extract`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3b9ebcc20939f6405411cc6cdbaee21dc6b3f96ddec04e1f159f245b75b35321`

Type:

```lean
{m : Nat} →
  {law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)} →
    {Result : NumStability.HyperbolicRiemannProblem law → Type u_1} →
      {Information : Type u_2} →
        NumStability.RiemannInformationFluxMethod law Result Information →
          {problem : NumStability.HyperbolicRiemannProblem law} → Result problem → Information
```

Fully explicit type:

```lean
{m : Nat} →
  {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)} →
    {Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1} →
      {Information : Type u_2} →
        (self : @NumStability.RiemannInformationFluxMethod.{u_1, u_2} m law Result Information) →
          {problem : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law} →
            Result problem → Information
```

Definition body (one-level semantic boundary):

```lean
fun m law Result Information self => self.3
```

### D016: `NumStability.RiemannInformationFluxMethod.interfaceFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8e8a9e4f628f6a0b59e1235532f4a95d3e8927240a3b8f5c007eee36a62d1d5b`

Type:

```lean
{m : Nat} →
  {law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)} →
    {Result : NumStability.HyperbolicRiemannProblem law → Type u_1} →
      {Information : Type u_2} →
        (method : NumStability.RiemannInformationFluxMethod law Result Information) →
          (old : Int → Fin m → Real) →
            (∀ (j : Int), method.domain (NumStability.adjacentCellRiemannProblem law old j)) → Int → Fin m → Real
```

Fully explicit type:

```lean
{m : Nat} →
  {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)} →
    {Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1} →
      {Information : Type u_2} →
        (method : @NumStability.RiemannInformationFluxMethod.{u_1, u_2} m law Result Information) →
          (old : Int → Fin m → Real) →
            (hdomain :
                ∀ (j : Int),
                  @NumStability.RiemannInformationFluxMethod.domain.{u_1, u_2} m law Result Information method
                    (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law old j)) →
              (j : Int) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {m} {law} {Result} {Information} method old hdomain j =>
  method.numericalFlux (method.extract (method.selectedResult old hdomain j))
```

### D017: `NumStability.RiemannInformationFluxMethod.numericalFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `94d4e89e2f4b998b714dad282197cd82641fd42885ec72bb42ba19d8e7acc90c`

Type:

```lean
{m : Nat} →
  {law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)} →
    {Result : NumStability.HyperbolicRiemannProblem law → Type u_1} →
      {Information : Type u_2} →
        NumStability.RiemannInformationFluxMethod law Result Information → Information → Fin m → Real
```

Fully explicit type:

```lean
{m : Nat} →
  {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)} →
    {Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1} →
      {Information : Type u_2} →
        (self : @NumStability.RiemannInformationFluxMethod.{u_1, u_2} m law Result Information) →
          Information → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m law Result Information self => self.4
```

### D018: `NumStability.RiemannInformationFluxMethod.selectedResult`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `963a49256ce35ba7db6dc5e85751624a8ca3fc27cc315989c459f9b713e6a517`

Type:

```lean
{m : Nat} →
  {law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)} →
    {Result : NumStability.HyperbolicRiemannProblem law → Type u_1} →
      {Information : Type u_2} →
        (method : NumStability.RiemannInformationFluxMethod law Result Information) →
          (old : Int → Fin m → Real) →
            (∀ (j : Int), method.domain (NumStability.adjacentCellRiemannProblem law old j)) →
              (j : Int) → Result (NumStability.adjacentCellRiemannProblem law old j)
```

Fully explicit type:

```lean
{m : Nat} →
  {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)} →
    {Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1} →
      {Information : Type u_2} →
        (method : @NumStability.RiemannInformationFluxMethod.{u_1, u_2} m law Result Information) →
          (old : Int → Fin m → Real) →
            (hdomain :
                ∀ (j : Int),
                  @NumStability.RiemannInformationFluxMethod.domain.{u_1, u_2} m law Result Information method
                    (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law old j)) →
              (j : Int) → Result (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law old j)
```

Definition body (one-level semantic boundary):

```lean
fun {m} {law} {Result} {Information} method old hdomain j =>
  method.solve (NumStability.adjacentCellRiemannProblem law old j) ⋯
```

### D019: `NumStability.RiemannInformationFluxMethod.solve`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `d7018bf7b85be4fac6258383c021d32b9edc76710050878fbf13036949eb514c`

Type:

```lean
{m : Nat} →
  {law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)} →
    {Result : NumStability.HyperbolicRiemannProblem law → Type u_1} →
      {Information : Type u_2} →
        (self : NumStability.RiemannInformationFluxMethod law Result Information) →
          (problem : NumStability.HyperbolicRiemannProblem law) → self.domain problem → Result problem
```

Fully explicit type:

```lean
{m : Nat} →
  {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)} →
    {Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1} →
      {Information : Type u_2} →
        (self : @NumStability.RiemannInformationFluxMethod.{u_1, u_2} m law Result Information) →
          (problem : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law) →
            @NumStability.RiemannInformationFluxMethod.domain.{u_1, u_2} m law Result Information self problem →
              Result problem
```

Definition body (one-level semantic boundary):

```lean
fun m law Result Information self => self.2
```

### D020: `NumStability.adjacentCellRiemannProblem`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `56780f75b263e1f0d30a97d1fcf699bf801f6e3354096e62a8a4196cd271cd61`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (law : NumStability.OneDimensionalHyperbolicConservationLaw Component) →
      (Int → Component → Real) → Int → NumStability.HyperbolicRiemannProblem law
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst) →
      (cellAverages : Int → Component → Real) →
        (i : Int) → @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law
```

Definition body (one-level semantic boundary):

```lean
fun {Component} [Fintype Component] law cellAverages i =>
  { leftState := cellAverages (instHSub.hSub i 1), rightState := cellAverages i }
```

### D021: `NumStability.cellVolumeAverage`

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

### D022: `NumStability.finiteVolumeCellAverageOn`

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

### D023: `NumStability.riemannFiniteVolumeUpdate`

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

### D024: `NumStability.timeAveragedPhysicalFaceFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalFluxAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `83078488fe62c4477a38b4c39ac012b5946fb06715d9a9e3945d2d47c666e19b`

Type:

```lean
{m : Nat} →
  NumStability.OneDimensionalFiniteVolumeGrid →
    (Real → Real → Fin m → Real) → ((Fin m → Real) → Fin m → Real) → Real → Real → Int → Fin m → Real
```

Fully explicit type:

```lean
{m : Nat} →
  (grid : NumStability.OneDimensionalFiniteVolumeGrid) →
    (q : Real → Real → Fin m → Real) → (flux : (Fin m → Real) → Fin m → Real) → (s t : Real) → (j : Int) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {m} grid q flux s t j => NumStability.oneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft j) τ)) s t
```

### D025: `NumStability.HyperbolicRiemannProblem.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `5f2a16f85d2b80003fb80ed3245e4ce1b46cef93c017e75ebf4e2d8c42303cc8`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {_law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      (Component → Real) → (Component → Real) → NumStability.HyperbolicRiemannProblem _law
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {_law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      (leftState rightState : Component → Real) → @NumStability.HyperbolicRiemannProblem.{u_1} Component inst _law
```

### D026: `NumStability.OneDimensionalFiniteVolumeGrid.mk`

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

### D027: `NumStability.OneDimensionalHyperbolicConservationLaw.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `5716f52b65018ff9f19eddfb7cda99a4810b6558b57e23cf0e8bda3ba9150ca4`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (physicalFlux : (Component → Real) → Component → Real) →
      (fluxDerivative :
          (Component → Real) → ContinuousLinearMap (RingHom.id Real) (Component → Real) (Component → Real)) →
        (fluxJacobian : (Component → Real) → Matrix Component Component Real) →
          (∀ (state : Component → Real), HasFDerivAt physicalFlux (fluxDerivative state) state) →
            (∀ (state direction : Component → Real),
                Eq (ContinuousLinearMap.funLike.coe (fluxDerivative state) direction)
                  ((fluxJacobian state).mulVec direction)) →
              (∀ (state : Component → Real), NumStability.IsRealHyperbolicMatrix (fluxJacobian state)) →
                NumStability.OneDimensionalHyperbolicConservationLaw Component
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (physicalFlux : (Component → Real) → Component → Real) →
      (fluxDerivative :
          (Component → Real) →
            @ContinuousLinearMap.{0, 0, u_1, u_1} Real Real Real.semiring Real.semiring
              (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)) (Component → Real)
              (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                @UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                Real.instAddCommMonoid)
              (Component → Real)
              (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                @UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
              (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))) →
        (fluxJacobian : (Component → Real) → Matrix.{u_1, u_1, 0} Component Component Real) →
          (hasFDerivAt_physicalFlux :
              ∀ (state : Component → Real),
                @HasFDerivAt.{0, u_1, u_1} Real
                  (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField) (Component → Real)
                  (@Pi.addCommGroup.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                    Real.instAddCommGroup)
                  (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                  (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (Component → Real)
                  (@Pi.addCommGroup.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                    Real.instAddCommGroup)
                  (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                  (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  physicalFlux (fluxDerivative state) state) →
            (fluxDerivative_eq_jacobian_mulVec :
                ∀ (state direction : Component → Real),
                  @Eq.{u_1 + 1} (Component → Real)
                    (@DFunLike.coe.{u_1 + 1, u_1 + 1, u_1 + 1}
                      (@ContinuousLinearMap.{0, 0, u_1, u_1} Real Real Real.semiring Real.semiring
                        (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)) (Component → Real)
                        (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                          Real.instAddCommMonoid)
                        (Component → Real)
                        (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                          Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                        (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                      (Component → Real) (fun (x : Component → Real) => Component → Real)
                      (@ContinuousLinearMap.funLike.{0, 0, u_1, u_1} Real Real Real.semiring Real.semiring
                        (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)) (Component → Real)
                        (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                          Real.instAddCommMonoid)
                        (Component → Real)
                        (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                          Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                        (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                      (fluxDerivative state) direction)
                    (@Matrix.mulVec.{0, u_1, u_1} Component Component Real
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      inst (fluxJacobian state) direction)) →
              (jacobian_hyperbolic :
                  ∀ (state : Component → Real),
                    @NumStability.IsRealHyperbolicMatrix.{u_1} Component inst (fluxJacobian state)) →
                @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst
```

### D028: `NumStability.RiemannInformationFluxMethod.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `d15b01d18f74a3ff3c725d44aa9fb8042393b65e39c446b5f29850a5bfbe0641`

Type:

```lean
{m : Nat} →
  {law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m)} →
    {Result : NumStability.HyperbolicRiemannProblem law → Type u_1} →
      {Information : Type u_2} →
        (domain : NumStability.HyperbolicRiemannProblem law → Prop) →
          (solve : (problem : NumStability.HyperbolicRiemannProblem law) → domain problem → Result problem) →
            (extract : {problem : NumStability.HyperbolicRiemannProblem law} → Result problem → Information) →
              (numericalFlux : Information → Fin m → Real) →
                (constants_in_domain : ∀ (state : Fin m → Real), domain { leftState := state, rightState := state }) →
                  (∀ (state : Fin m → Real),
                      Eq (numericalFlux (extract (solve { leftState := state, rightState := state } ⋯)))
                        (law.physicalFlux state)) →
                    NumStability.RiemannInformationFluxMethod law Result Information
```

Fully explicit type:

```lean
{m : Nat} →
  {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m)} →
    {Result : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Type u_1} →
      {Information : Type u_2} →
        (domain : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law → Prop) →
          (solve :
              (problem : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law) →
                domain problem → Result problem) →
            (extract :
                {problem : @NumStability.HyperbolicRiemannProblem.{0} (Fin m) (Fin.fintype m) law} →
                  Result problem → Information) →
              (numericalFlux : Information → Fin m → Real) →
                (constants_in_domain :
                    ∀ (state : Fin m → Real),
                      domain (@NumStability.HyperbolicRiemannProblem.mk.{0} (Fin m) (Fin.fintype m) law state state)) →
                  (consistent :
                      ∀ (state : Fin m → Real),
                        @Eq.{1} (Fin m → Real)
                          (numericalFlux
                            (@extract
                              (@NumStability.HyperbolicRiemannProblem.mk.{0} (Fin m) (Fin.fintype m) law state state)
                              (solve
                                (@NumStability.HyperbolicRiemannProblem.mk.{0} (Fin m) (Fin.fintype m) law state state)
                                (constants_in_domain state))))
                          (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m)
                            (Fin.fintype m) law state)) →
                    @NumStability.RiemannInformationFluxMethod.{u_1, u_2} m law Result Information
```

### D029: `NumStability.oneDimensionalCellAverage`

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

### D030: `NumStability.IsRealHyperbolicMatrix`

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

### D031: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D032: `Algebra.id`

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

### D033: `Algebra.toSMul`

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

### D034: `And`

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

### D035: `CommSemiring.toSemiring`

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

### D036: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D037: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D038: `DivInvMonoid.toDiv`

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

### D039: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `587c80a71f9aa5749b5d6c35c97cdae1067fa669257c865951843b747c511934`

Type:

```lean
{K : Type u_2} → [self : DivisionSemiring K] → Semiring K
```

Fully explicit type:

```lean
{K : Type u_2} → [self : DivisionSemiring.{u_2} K] → Semiring.{u_2} K
```

Definition body (one-level semantic boundary):

```lean
fun K [self : DivisionSemiring K] => self.1
```

### D040: `Eq`

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

### D041: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9a6353c2087dc0f4123f4079d947842f8b7bc1fc0c77de170382c04e31608fd4`

Type:

```lean
{K : Type u_1} → [Field K] → Semifield K
```

Fully explicit type:

```lean
{K : Type u_1} → [Field.{u_1} K] → Semifield.{u_1} K
```

Definition body (one-level semantic boundary):

```lean
fun {K} [inst : Field K] =>
  let __src := inst;
  { toSemiring := __src.toSemiring, mul_comm := ⋯, toInv := __src.toInv, toDiv := __src.toDiv, div_eq_mul_inv := ⋯,
    zpow := __src.zpow, zpow_zero' := ⋯, zpow_succ' := ⋯, zpow_neg' := ⋯, toNontrivial := ⋯, inv_zero := ⋯,
    mul_inv_cancel := ⋯, toNNRatCast := __src.toNNRatCast, nnratCast_def := ⋯, nnqsmul := __src.nnqsmul,
    nnqsmul_def := ⋯ }
```

### D042: `Filter.Eventually`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D043: `Fin`

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

### D044: `Fin.fintype`

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

### D045: `Function.hasSMul`

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

### D046: `HAdd.hAdd`

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

### D047: `HDiv.hDiv`

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

### D048: `HMul.hMul`

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

### D049: `HSMul.hSMul`

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

### D050: `HSub.hSub`

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

### D051: `HasDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.Deriv.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `425ec9578fd20d63923b9588cbb7761a6e92f281528630fe03d0dc3dc1bc60a2`

Type:

```lean
{𝕜 : Type u} →
  [inst : NontriviallyNormedField 𝕜] →
    {F : Type v} →
      [inst_1 : AddCommGroup F] →
        [inst_2 : Module 𝕜 F] → [inst_3 : TopologicalSpace F] → [ContinuousSMul 𝕜 F] → (𝕜 → F) → F → 𝕜 → Prop
```

Fully explicit type:

```lean
{𝕜 : Type u} →
  [inst : NontriviallyNormedField.{u} 𝕜] →
    {F : Type v} →
      [inst_1 : AddCommGroup.{v} F] →
        [inst_2 :
            @Module.{u, v} 𝕜 F
              (@DivisionSemiring.toSemiring.{u} 𝕜
                (@Semifield.toDivisionSemiring.{u} 𝕜
                  (@Field.toSemifield.{u} 𝕜
                    (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
              (@AddCommGroup.toAddCommMonoid.{v} F inst_1)] →
          [inst_3 : TopologicalSpace.{v} F] →
            [@ContinuousSMul.{u, v} 𝕜 F
                  (@SMulZeroClass.toSMul.{u, v} 𝕜 F
                    (@AddZero.toZero.{v} F
                      (@AddZeroClass.toAddZero.{v} F
                        (@AddMonoid.toAddZeroClass.{v} F
                          (@SubNegMonoid.toAddMonoid.{v} F
                            (@AddGroup.toSubNegMonoid.{v} F (@AddCommGroup.toAddGroup.{v} F inst_1))))))
                    (@DistribSMul.toSMulZeroClass.{u, v} 𝕜 F
                      (@AddMonoid.toAddZeroClass.{v} F
                        (@SubNegMonoid.toAddMonoid.{v} F
                          (@AddGroup.toSubNegMonoid.{v} F (@AddCommGroup.toAddGroup.{v} F inst_1))))
                      (@DistribMulAction.toDistribSMul.{u, v} 𝕜 F
                        (@MonoidWithZero.toMonoid.{u} 𝕜
                          (@Semiring.toMonoidWithZero.{u} 𝕜
                            (@DivisionSemiring.toSemiring.{u} 𝕜
                              (@Semifield.toDivisionSemiring.{u} 𝕜
                                (@Field.toSemifield.{u} 𝕜
                                  (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                        (@SubNegMonoid.toAddMonoid.{v} F
                          (@AddGroup.toSubNegMonoid.{v} F (@AddCommGroup.toAddGroup.{v} F inst_1)))
                        (@Module.toDistribMulAction.{u, v} 𝕜 F
                          (@DivisionSemiring.toSemiring.{u} 𝕜
                            (@Semifield.toDivisionSemiring.{u} 𝕜
                              (@Field.toSemifield.{u} 𝕜
                                (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                          (@AddCommGroup.toAddCommMonoid.{v} F inst_1) inst_2))))
                  (@UniformSpace.toTopologicalSpace.{u} 𝕜
                    (@PseudoMetricSpace.toUniformSpace.{u} 𝕜
                      (@SeminormedRing.toPseudoMetricSpace.{u} 𝕜
                        (@SeminormedCommRing.toSeminormedRing.{u} 𝕜
                          (@NormedCommRing.toSeminormedCommRing.{u} 𝕜
                            (@NormedField.toNormedCommRing.{u} 𝕜
                              (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                  inst_3] →
              (f : 𝕜 → F) → (f' : F) → (x : 𝕜) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NontriviallyNormedField 𝕜] {F} [AddCommGroup F] [Module 𝕜 F] [TopologicalSpace F] [ContinuousSMul 𝕜 F] f f'
    x =>
  HasDerivAtFilter f f' (Filter.instSProd.sprod (nhds x) (Filter.instPure.pure x))
```

### D052: `InnerProductSpace.toNormedSpace`

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

### D053: `Int`

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

### D054: `Int.instAdd`

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

### D055: `Int.instSub`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D056: `IsModuleTopology.toContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.ModuleTopology`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `d742338ba9a91c51f3d8c85587b499f80fa45f760f44b816c28c581c8ce98bce`

Type:

```lean
∀ (R : Type u_1) [inst : TopologicalSpace R] (A : Type u_2) [inst_1 : Add A] [inst_2 : SMul R A]
  [inst_3 : TopologicalSpace A] [IsModuleTopology R A], ContinuousSMul R A
```

Fully explicit type:

```lean
∀ (R : Type u_1) [inst : TopologicalSpace.{u_1} R] (A : Type u_2) [inst_1 : Add.{u_2} A] [inst_2 : SMul.{u_1, u_2} R A]
  [inst_3 : TopologicalSpace.{u_2} A] [@IsModuleTopology.{u_1, u_2} R inst A inst_1 inst_2 inst_3],
  @ContinuousSMul.{u_1, u_2} R A inst_2 inst inst_3
```

### D057: `IsTopologicalRing.toIsTopologicalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `f55163e46531cbf77c144d47ba02dbad1720a8a16e67de32af3e47419e5ccdb7`

Type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace R} {inst_1 : NonUnitalNonAssocRing R} [self : IsTopologicalRing R],
  IsTopologicalSemiring R
```

Fully explicit type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace.{u_1} R} {inst_1 : NonUnitalNonAssocRing.{u_1} R}
  [self : @IsTopologicalRing.{u_1} R inst inst_1],
  @IsTopologicalSemiring.{u_1} R inst (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R inst_1)
```

### D058: `IsTopologicalSemiring.toIsModuleTopology`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.ModuleTopology`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `6658e003840ad10e8620755a49c3db4e3608593c5a679d085f0f988542346d79`

Type:

```lean
∀ (R : Type u_1) [inst : Semiring R] [τR : TopologicalSpace R] [IsTopologicalSemiring R], IsModuleTopology R R
```

Fully explicit type:

```lean
∀ (R : Type u_1) [inst : Semiring.{u_1} R] [τR : TopologicalSpace.{u_1} R]
  [@IsTopologicalSemiring.{u_1} R τR
      (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R inst))],
  @IsModuleTopology.{u_1, u_1} R τR R
    (@Distrib.toAdd.{u_1} R
      (@NonUnitalNonAssocSemiring.toDistrib.{u_1} R
        (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R inst))))
    (@SMulZeroClass.toSMul.{u_1, u_1} R R
      (@AddZero.toZero.{u_1} R
        (@AddZeroClass.toAddZero.{u_1} R
          (@AddMonoid.toAddZeroClass.{u_1} R
            (@AddMonoidWithOne.toAddMonoid.{u_1} R
              (@AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} R
                (@NonAssocSemiring.toAddCommMonoidWithOne.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R inst)))))))
      (@DistribSMul.toSMulZeroClass.{u_1, u_1} R R
        (@AddMonoid.toAddZeroClass.{u_1} R
          (@AddMonoidWithOne.toAddMonoid.{u_1} R
            (@AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} R
              (@NonAssocSemiring.toAddCommMonoidWithOne.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R inst)))))
        (@instDistribSMul.{u_1} R
          (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R inst)))))
    τR
```

### D059: `LE.le`

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

### D060: `LT.lt`

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

### D061: `MeasureTheory.Measure`

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

### D062: `MeasureTheory.Measure.instFunLike`

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

### D063: `MeasureTheory.Measure.instOuterMeasureClass`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `theorem`
- Distance from target type: `1`
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

### D064: `MeasureTheory.MeasureSpace.toMeasurableSpace`

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

### D065: `MeasureTheory.MeasureSpace.volume`

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

### D066: `MeasureTheory.ae`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.OuterMeasure.AE`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D067: `Module.toDistribMulAction`

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

### D068: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D069: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D070: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D071: `Nat`

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

### D072: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D073: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D074: `NonUnitalNonAssocSemiring.toAddCommMonoid`

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

### D075: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing α] → NonUnitalCommRing α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing.{u_5} α] → NonUnitalCommRing.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalRing := self.toNonUnitalRing, mul_comm := ⋯ }
```

### D076: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

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

### D077: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D078: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

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

### D079: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D080: `Norm.norm`

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

### D081: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → NonUnitalNormedCommRing α
```

Fully explicit type:

```lean
{α : Type u_2} → [β : NormedCommRing.{u_2} α] → NonUnitalNormedCommRing.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toMetricSpace := β.toMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D082: `NormedCommRing.toNormedRing`

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

### D083: `NormedCommRing.toSeminormedCommRing`

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

### D084: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ec9eab2d54099c52c160e626a54324e8c9a07675797f0926435031098f363e5f`

Type:

```lean
{α : Type u_5} → [self : NormedField α] → Field α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NormedField.{u_5} α] → Field.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedField α] => self.2
```

### D085: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4aa3dba57859ca72552799005279a2b5a65b8c083980070fbbff11fd1de56dec`

Type:

```lean
{α : Type u_2} → [NormedField α] → NormedCommRing α
```

Fully explicit type:

```lean
{α : Type u_2} → [NormedField.{u_2} α] → NormedCommRing.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : NormedField α] =>
  let __src := inst;
  { toNorm := __src.toNorm, toRing := __src.toRing, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯,
    norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D086: `NormedRing.toNorm`

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

### D087: `NormedSpace.toModule`

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

### D088: `OfNat.ofNat`

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

### D089: `Pi.Function.module`

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

### D090: `Pi.addCommGroup`

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

### D091: `Pi.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `786aa93e85ac0acc746f4c8ee6aed957d52e0231f66623c2b8e478a794d15ce0`

Type:

```lean
{ι : Type u_1} → {M : ι → Type u_5} → [(i : ι) → Add (M i)] → Add ((i : ι) → M i)
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : ι → Type u_5} → [(i : ι) → Add.{u_5} (M i)] → Add.{max u_1 u_5} ((i : ι) → M i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [(i : ι) → Add (M i)] => { add := fun f g i => instHAdd.hAdd (f i) (g i) }
```

### D092: `Pi.instSub`

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

### D093: `Pi.normedAddCommGroup`

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

### D094: `Pi.normedRing`

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

### D095: `Pi.normedSpace`

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

### D096: `Pi.topologicalSpace`

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

### D097: `PseudoMetricSpace.toUniformSpace`

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

### D098: `RCLike.toInnerProductSpaceReal`

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

### D099: `Real`

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

### D100: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D101: `Real.instAdd`

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

### D102: `Real.instAddCommGroup`

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

### D103: `Real.instCommSemiring`

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

### D104: `Real.instDivInvMonoid`

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

### D105: `Real.instLE`

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

### D106: `Real.instLT`

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

### D107: `Real.instMul`

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

### D108: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D109: `Real.instRCLike`

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

### D110: `Real.instRing`

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

### D111: `Real.instSub`

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

### D112: `Real.measureSpace`

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

### D113: `Real.normedAddCommGroup`

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

### D114: `Real.normedCommRing`

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

### D115: `Real.normedField`

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

### D116: `Real.pseudoMetricSpace`

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

### D117: `Real.semiring`

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

### D118: `Ring.toSemiring`

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

### D119: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a1b771abeff9bbbdcce988134973a1a367c44a340bcd29acb0cc44b8d6a2e55c`

Type:

```lean
{K : Type u_2} → [self : Semifield K] → DivisionSemiring K
```

Fully explicit type:

```lean
{K : Type u_2} → [self : Semifield.{u_2} K] → DivisionSemiring.{u_2} K
```

Definition body (one-level semantic boundary):

```lean
fun K self =>
  { toSemiring := self.toSemiring, toInv := self.toInv, toDiv := self.toDiv, div_eq_mul_inv := ⋯, zpow := self.zpow,
    zpow_zero' := ⋯, zpow_succ' := ⋯, zpow_neg' := ⋯, toNontrivial := ⋯, inv_zero := ⋯, mul_inv_cancel := ⋯,
    toNNRatCast := self.toNNRatCast, nnratCast_def := ⋯, nnqsmul := self.nnqsmul, nnqsmul_def := ⋯ }
```

### D120: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D121: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

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

### D122: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e3cbc92d1d5e37d9eaeb1d595c83a78f7af7e3a8d249a700fa3676ab4e0c3d60`

Type:

```lean
{α : Type u_5} → [self : SeminormedCommRing α] → SeminormedRing α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : SeminormedCommRing.{u_5} α] → SeminormedRing.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : SeminormedCommRing α] => self.1
```

### D123: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e6ea9296e8643d5ae7cf334c065c9d6ebe4a95de22d3b0708a585db80e17322a`

Type:

```lean
{α : Type u_5} → [self : SeminormedRing α] → PseudoMetricSpace α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : SeminormedRing.{u_5} α] → PseudoMetricSpace.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : SeminormedRing α] => self.3
```

### D124: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D125: `Semiring.toNonUnitalSemiring`

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

### D126: `Set.Ioc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ff05a5eaafe9ff8d3ce7c60e46836b8850e9f73e10712fccf83973114737c089`

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
fun {α} [inst : Preorder α] a b => setOf fun x => And (inst.lt a x) (inst.le x b)
```

### D127: `UniformSpace.toTopologicalSpace`

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

### D128: `instContinuousSMulForall`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `d3a31448b115a308914d59b4064d02d2b1d44ef7866e1b111c3a417657355fbb`

Type:

```lean
∀ {M : Type u_1} [inst : TopologicalSpace M] {ι : Type u_5} {γ : ι → Type u_6}
  [inst_1 : (i : ι) → TopologicalSpace (γ i)] [inst_2 : (i : ι) → SMul M (γ i)] [∀ (i : ι), ContinuousSMul M (γ i)],
  ContinuousSMul M ((i : ι) → γ i)
```

Fully explicit type:

```lean
∀ {M : Type u_1} [inst : TopologicalSpace.{u_1} M] {ι : Type u_5} {γ : ι → Type u_6}
  [inst_1 : (i : ι) → TopologicalSpace.{u_6} (γ i)] [inst_2 : (i : ι) → SMul.{u_1, u_6} M (γ i)]
  [∀ (i : ι), @ContinuousSMul.{u_1, u_6} M (γ i) (inst_2 i) inst (inst_1 i)],
  @ContinuousSMul.{u_1, max u_5 u_6} M ((i : ι) → γ i) (@Pi.instSMul.{u_5, u_1, u_6} ι M γ inst_2) inst
    (@Pi.topologicalSpace.{u_6, u_5} ι γ inst_1)
```

### D129: `instHAdd`

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

### D130: `instHDiv`

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

### D131: `instHMul`

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

### D132: `instHSMul`

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

### D133: `instHSub`

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

### D134: `instIsTopologicalRingReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Real`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `74697a527ce10426ad50966a34f3375374c3cde51367629721e2aa0850e2f618`

Type:

```lean
IsTopologicalRing Real
```

Fully explicit type:

```lean
@IsTopologicalRing.{0} Real
  (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real (@CommRing.toNonUnitalCommRing.{0} Real Real.commRing)))
```

### D135: `instLTNat`

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

### D136: `instOfNat`

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

### D137: `instOfNatNat`

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

### D138: `intervalIntegral`

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

### D139: `AddGroup.toSubNegMonoid`

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

### D140: `AddMonoid.toAddZeroClass`

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

### D141: `AddZero.toZero`

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

### D142: `AddZeroClass.toAddZero`

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

### D143: `DFunLike.coe`

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

### D144: `DistribMulAction.toDistribSMul`

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

### D145: `DistribSMul.toSMulZeroClass`

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

### D146: `ENNReal`

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

### D147: `ENNReal.toReal`

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

### D148: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

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

### D149: `ESeminormedAddCommMonoid.toAddCommMonoid`

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

### D150: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

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

### D151: `ESeminormedAddMonoid.toAddMonoid`

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

### D152: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Type:

```lean
Type u_4 → Type u_4
```

Fully explicit type:

```lean
(α : Type u_4) → Type u_4
```

### D153: `IntervalIntegrable`

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

### D154: `Inv.inv`

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

### D155: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

Fully explicit type:

```lean
(α : Type u_7) → Type u_7
```

### D156: `MeasureTheory.Measure.restrict`

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

### D157: `MeasureTheory.integral`

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

### D158: `NormedAddCommGroup`

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

### D159: `NormedAddCommGroup.toENormedAddCommMonoid`

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

### D160: `NormedAddCommGroup.toNormedAddGroup`

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

### D161: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D162: `NormedAddGroup.toAddGroup`

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

### D163: `NormedAddGroup.toENormedAddMonoid`

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

### D164: `NormedSpace`

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

### D165: `Real.instInv`

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

### D166: `Real.instMonoid`

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

### D167: `SMulZeroClass.toSMul`

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

### D168: `SeminormedAddCommGroup.toPseudoMetricSpace`

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

### D169: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D170: `SubNegMonoid.toSub`

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

### D171: `ContinuousLinearMap`

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

### D172: `ContinuousLinearMap.funLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `323d1f39018754b45ba5ba40d3379411a46e1a73045c0b02095e694919f7e9a7`

Type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} →
    [inst : Semiring R₁] →
      [inst_1 : Semiring R₂] →
        {σ₁₂ : RingHom R₁ R₂} →
          {M₁ : Type u_4} →
            [inst_2 : TopologicalSpace M₁] →
              [inst_3 : AddCommMonoid M₁] →
                {M₂ : Type u_6} →
                  [inst_4 : TopologicalSpace M₂] →
                    [inst_5 : AddCommMonoid M₂] →
                      [inst_6 : Module R₁ M₁] → [inst_7 : Module R₂ M₂] → FunLike (ContinuousLinearMap σ₁₂ M₁ M₂) M₁ M₂
```

Fully explicit type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} →
    [inst : Semiring.{u_1} R₁] →
      [inst_1 : Semiring.{u_2} R₂] →
        {σ₁₂ :
            @RingHom.{u_1, u_2} R₁ R₂ (@Semiring.toNonAssocSemiring.{u_1} R₁ inst)
              (@Semiring.toNonAssocSemiring.{u_2} R₂ inst_1)} →
          {M₁ : Type u_4} →
            [inst_2 : TopologicalSpace.{u_4} M₁] →
              [inst_3 : AddCommMonoid.{u_4} M₁] →
                {M₂ : Type u_6} →
                  [inst_4 : TopologicalSpace.{u_6} M₂] →
                    [inst_5 : AddCommMonoid.{u_6} M₂] →
                      [inst_6 : @Module.{u_1, u_4} R₁ M₁ inst inst_3] →
                        [inst_7 : @Module.{u_2, u_6} R₂ M₂ inst_1 inst_5] →
                          FunLike.{max (u_6 + 1) (u_4 + 1), u_4 + 1, u_6 + 1}
                            (@ContinuousLinearMap.{u_1, u_2, u_4, u_6} R₁ R₂ inst inst_1 σ₁₂ M₁ inst_2 inst_3 M₂ inst_4
                              inst_5 inst_6 inst_7)
                            M₁ M₂
```

Definition body (one-level semantic boundary):

```lean
fun {R₁} {R₂} [Semiring R₁] [Semiring R₂] {σ₁₂} {M₁} [TopologicalSpace M₁] [AddCommMonoid M₁] {M₂} [TopologicalSpace M₂]
    [AddCommMonoid M₂] [Module R₁ M₁] [Module R₂ M₂] =>
  { coe := fun f => LinearMap.instFunLike.coe f.toLinearMap, coe_injective' := ⋯ }
```

### D173: `HasFDerivAt`

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

### D174: `Matrix`

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

### D175: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D176: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D177: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D178: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D179: `RingHom.id`

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

### D180: `Semiring.toNonAssocSemiring`

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

### D181: `CommRing.toNonUnitalCommRing`

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

### D182: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Prop
```

### D183: `Module.Basis`

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

### D184: `Module.Basis.instFunLike`

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

### D185: `Real.commRing`

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

### D186: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

## Complete local imported sources

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean`
SHA-256: `eec0a71127f26258c319639629e9d6fe274b706c4f77ae09fb877a14e2c367ff`

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
  /-- The spatial region covered by the modeled partition. -/
  domain : Set Point
  /-- The measurable spatial region assigned to each cell. -/
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
  /-- The effective material parameter assigned after cell averaging. -/
  averagedParameter : Parameter

/-- A model-indexed rule for averaging material parameters over finite-volume
cells.  The rule is deliberately not fixed to an arithmetic, harmonic, or
tensor mean.  Its two laws capture the source-independent content of being a
cell average: changing a field outside the cell has no effect, and constant
fields are reproduced on positive finite-volume cells. -/
structure CellMaterialAveragingRule
    (Model Cell Point Parameter : Type*) [MeasurableSpace Point]
    (cellRegion : Cell → Set Point) where
  /-- Compute an effective parameter from a model, measure, cell, and
  spatially varying parameter field. -/
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

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellVolumeAverage.lean`
SHA-256: `343415f6cffff46d0ec308dbeb8c005c42a3306456619a984057bf94e51d6400`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.MeasureTheory.Integral.Average

/-!
# Normalized volume-average laws and assignments

The existing cell average agrees with Mathlib set averaging, is local,
reproduces constants, and gives unique assignments on measured cells.
-/

open MeasureTheory

namespace NumStability

variable {Point E Cell : Type*} [MeasurableSpace Point]
  [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Bridge to the existing Mathlib average; no new averaging operator. -/
theorem cellVolumeAverage_eq_setAverage (μ : Measure Point)
    (region : Set Point) (field : Point → E) :
    cellVolumeAverage μ region field = ⨍ point in region, field point ∂μ := by
  rw [MeasureTheory.setAverage_eq]
  rfl

/-- Equality almost everywhere inside a cell suffices for locality. -/
theorem cellVolumeAverage_congr_ae (μ : Measure Point) (region : Set Point)
    {field other : Point → E} (h : field =ᵐ[μ.restrict region] other) :
    cellVolumeAverage μ region field = cellVolumeAverage μ region other := by
  simp only [cellVolumeAverage_eq_setAverage]
  exact MeasureTheory.average_congr h

/-- Changing a field outside the cell has no effect. -/
theorem cellVolumeAverage_congr (μ : Measure Point) {region : Set Point}
    (hs : MeasurableSet region) {field other : Point → E}
    (h : Set.EqOn field other region) :
    cellVolumeAverage μ region field = cellVolumeAverage μ region other := by
  simp only [cellVolumeAverage_eq_setAverage]
  exact MeasureTheory.setAverage_congr_fun hs (Filter.Eventually.of_forall h)

/-- Finite positive volume gives exact reproduction of constants. -/
theorem cellVolumeAverage_const [CompleteSpace E] (μ : Measure Point) (region : Set Point)
    (hpositive : μ region ≠ 0) (hfinite : μ region ≠ ⊤) (value : E) :
    cellVolumeAverage μ region (fun _ => value) = value := by
  rw [cellVolumeAverage_eq_setAverage]
  exact MeasureTheory.setAverage_const hpositive hfinite value

/-- An integrable field has a unique normalized assignment on the supplied
measurable cells. Different cells may have equal or different values. -/
theorem existsUnique_cellVolumeAssignment
    (grid : FiniteVolumeCellPartition Cell Point) (μ : Measure Point)
    (field : Point → E)
    (hpositive : ∀ cell, μ (grid.cellRegion cell) ≠ 0)
    (hfinite : ∀ cell, μ (grid.cellRegion cell) ≠ ⊤)
    (hintegrable : ∀ cell, IntegrableOn field (grid.cellRegion cell) μ) :
    ∃! assigned : Cell → E,
      ∀ cell, IsCellVolumeAverage μ (grid.cellRegion cell) field (assigned cell) := by
  refine ⟨fun cell => cellVolumeAverage μ (grid.cellRegion cell) field, ?_, ?_⟩
  · intro cell
    exact cellVolumeAverage_isCellVolumeAverage μ _ field
      (hpositive cell) (hfinite cell) (hintegrable cell)
  · intro assigned hassigned
    funext cell
    exact (hassigned cell).2.2.2

/-- The existing multidimensional volume operator agrees with the existing
interval operator on a positively oriented real interval. -/
theorem cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage
    (field : ℝ → E) {left right : ℝ} (h : left < right) :
    cellVolumeAverage volume (Set.Ioc left right) field =
      oneDimensionalCellAverage field left right := by
  rw [cellVolumeAverage, Real.volume_Ioc, ENNReal.toReal_ofReal (sub_nonneg.mpr h.le),
    ← intervalIntegral.integral_of_le h.le]
  rfl

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/LinearAdvection.lean`
SHA-256: `c81a4b5ce8d9936d51f9aae7a02bc34db770b4d7213ac8c6581f5b577d11efe2`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Constant-coefficient linear advection

Source-independent local solution predicates and traveling-wave solutions for
`q_t + a q_x = 0`, for profiles valued in a real normed vector space.
-/

namespace NumStability

/-- A profile translated at constant speed. -/
def travelingWave {E : Type*} (profile : ℝ → E) (speed x t : ℝ) : E :=
  profile (x - speed * t)

/-- The translated profile agrees with the original profile at time zero. -/
@[simp] theorem travelingWave_zero {E : Type*}
    (profile : ℝ → E) (speed x : ℝ) :
    travelingWave profile speed x 0 = profile x := by
  simp [travelingWave]

/-- The value initially at `x` is at `x + speed * t` at time `t`. -/
theorem travelingWave_at_translated_point {E : Type*}
    (profile : ℝ → E) (speed x t : ℝ) :
    travelingWave profile speed (x + speed * t) t = profile x := by
  simp [travelingWave]

section LinearAdvection

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- A function satisfies `q_t + speed q_x = 0` at a point. -/
def IsLinearAdvectionSolutionAt
    (q : ℝ → ℝ → E) (speed x t : ℝ) : Prop :=
  ∃ qt qx : E,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + speed • qx = 0

/-- Every differentiable translated profile solves linear advection at the
corresponding point. -/
theorem travelingWave_isLinearAdvectionSolutionAt
    {profile : ℝ → E} {profile' : E} (speed x t : ℝ)
    (hprofile : HasDerivAt profile profile' (x - speed * t)) :
    IsLinearAdvectionSolutionAt
      (travelingWave profile speed) speed x t := by
  refine ⟨(-speed) • profile', profile', ?_, ?_, ?_⟩
  · have ht : HasDerivAt (fun τ : ℝ => x - speed * τ) (-speed) t := by
      simpa using
        (hasDerivAt_const t x).sub ((hasDerivAt_id t).const_mul speed)
    simpa [travelingWave, Function.comp_def] using hprofile.scomp t ht
  · have hx : HasDerivAt (fun ξ : ℝ => ξ - speed * t) 1 x := by
      simpa using (hasDerivAt_id x).sub_const (speed * t)
    simpa [travelingWave, Function.comp_def] using hprofile.scomp x hx
  · simp

end LinearAdvection

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean`
SHA-256: `c99c3c0c2440026a290addd1535c41bc73c3832155c20c3e844d7c3af76bb296`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Conservation on oriented space-time rectangles

Time-integrated conservation records spatial and boundary-flux integrability.
Locally integrable translated profiles satisfy this balance, including discontinuous profiles.
-/

open MeasureTheory

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Time-integrated balance over every oriented space-time rectangle. -/
def IsRectangleConservationLawSolution
    (q : ℝ → ℝ → E) (flux : E → E) : Prop :=
  (∀ a b t, IntervalIntegrable (fun x => q x t) volume a b) ∧
  (∀ x s t, IntervalIntegrable (fun τ => flux (q x τ)) volume s t) ∧
  ∀ a b s t,
    (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      ∫ τ in s..t, (flux (q a τ) - flux (q b τ))

/-- Change of variables and interval additivity give transport balance even
for discontinuous locally integrable profiles. -/
theorem travelingWave_intervalBalance (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed a b s t : ℝ) :
    (∫ x in a..b, travelingWave profile speed x t) -
        (∫ x in a..b, travelingWave profile speed x s) =
      speed • (∫ τ in s..t, travelingWave profile speed a τ) -
        speed • (∫ τ in s..t, travelingWave profile speed b τ) := by
  simp only [travelingWave, intervalIntegral.integral_comp_sub_right,
    intervalIntegral.smul_integral_comp_sub_mul]
  exact intervalIntegral.integral_interval_sub_interval_comm
    (hprofile _ _) (hprofile _ _) (hprofile _ _)

omit [NormedSpace ℝ E] in
theorem travelingWave_intervalIntegrable_space (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed a b t : ℝ) :
    IntervalIntegrable (fun x => travelingWave profile speed x t) volume a b := by
  simpa only [travelingWave, sub_add_cancel] using
    (hprofile (a - speed * t) (b - speed * t)).comp_sub_right (speed * t)

omit [NormedSpace ℝ E] in
theorem travelingWave_intervalIntegrable_time (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed x s t : ℝ) :
    IntervalIntegrable (fun τ => travelingWave profile speed x τ) volume s t := by
  by_cases hc : speed = 0
  · simp only [travelingWave, hc, zero_mul, sub_zero]
    exact intervalIntegrable_const
  have hsub := (hprofile (x - speed * s) (x - speed * t)).comp_sub_left x
  have hmul := hsub.comp_mul_left (c := speed)
  simpa only [travelingWave, sub_sub_cancel, mul_div_cancel_left₀ _ hc] using hmul

theorem travelingWave_isRectangleConservationLawSolution (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b) (speed : ℝ) :
    IsRectangleConservationLawSolution (travelingWave profile speed)
      (fun state => speed • state) := by
  refine ⟨travelingWave_intervalIntegrable_space profile hprofile speed, ?_, ?_⟩
  · intro x s t
    exact (travelingWave_intervalIntegrable_time profile hprofile speed x s t).smul speed
  · intro a b s t
    calc
      _ = speed • (∫ τ in s..t, travelingWave profile speed a τ) -
          speed • (∫ τ in s..t, travelingWave profile speed b τ) :=
        travelingWave_intervalBalance profile hprofile speed a b s t
      _ = _ := by
        simpa only [Pi.smul_apply, intervalIntegral.integral_smul] using
          (intervalIntegral.integral_sub
            ((travelingWave_intervalIntegrable_time profile hprofile speed a s t).smul speed)
            ((travelingWave_intervalIntegrable_time profile hprofile speed b s t).smul speed)).symm


end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/Hyperbolicity.lean`
SHA-256: `f5ca138c081a318a3a5186927d0f2ae2af35d3ed9171f685b7f8bf450e6ae33e`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Real hyperbolicity of constant coefficient matrices

Source-independent finite-dimensional hyperbolicity for a real square matrix.
The defining data are real eigenvalues and a basis of corresponding right
eigenvectors.  This is equivalent to having a full linearly independent family
of real eigenvectors, and the basis supplies unique characteristic
coordinates for every state.
-/

open scoped BigOperators

namespace NumStability

/-- A real square matrix is hyperbolic when it has a basis of real right
eigenvectors with real eigenvalues. -/
def IsRealHyperbolicMatrix {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ) : Prop :=
  ∃ (eigenvalues : ι → ℝ)
      (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
    ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p

/-- In a square real coordinate space, the eigenbasis definition of
hyperbolicity is equivalent to a full linearly independent family of real
eigenvectors. -/
theorem isRealHyperbolicMatrix_iff_independent_real_eigenvectors
    {ι : Type*} [Fintype ι] (coefficient : Matrix ι ι ℝ) :
    IsRealHyperbolicMatrix coefficient ↔
      ∃ (eigenvalues : ι → ℝ) (eigenvectors : ι → (ι → ℝ)),
        LinearIndependent ℝ eigenvectors ∧
          ∀ p, coefficient.mulVec (eigenvectors p) =
            eigenvalues p • eigenvectors p := by
  constructor
  · rintro ⟨eigenvalues, eigenbasis, heigen⟩
    exact ⟨eigenvalues, eigenbasis, eigenbasis.linearIndependent, heigen⟩
  · rintro ⟨eigenvalues, eigenvectors, hindependent, heigen⟩
    letI : Decidable (Nonempty ι) := Classical.dec (Nonempty ι)
    let eigenbasis := basisOfPiSpaceOfLinearIndependent hindependent
    refine ⟨eigenvalues, eigenbasis, ?_⟩
    intro p
    change coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p
    rw [show (eigenbasis : ι → (ι → ℝ)) = eigenvectors by
      exact coe_basisOfPiSpaceOfLinearIndependent hindependent]
    exact heigen p

/-- Hyperbolic eigendata give every state a unique expansion in the real
eigenbasis. -/
theorem IsRealHyperbolicMatrix.exists_unique_eigenbasis_decomposition
    {ι : Type*} [Fintype ι] {coefficient : Matrix ι ι ℝ}
    (hcoefficient : IsRealHyperbolicMatrix coefficient) :
    ∃ (eigenvalues : ι → ℝ)
        (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
      (∀ p, coefficient.mulVec (eigenbasis p) =
        eigenvalues p • eigenbasis p) ∧
      ∀ q : ι → ℝ,
        ∃! amplitudes : ι → ℝ,
          ∑ p, amplitudes p • eigenbasis p = q := by
  rcases hcoefficient with ⟨eigenvalues, eigenbasis, heigen⟩
  refine ⟨eigenvalues, eigenbasis, heigen, fun q => ?_⟩
  refine ⟨eigenbasis.equivFun q, ?_, ?_⟩
  · change ∑ p, (eigenbasis.equivFun q) p • eigenbasis p = q
    rw [← eigenbasis.equivFun_symm_apply]
    exact eigenbasis.equivFun.symm_apply_apply q
  · intro amplitudes hamplitudes
    apply eigenbasis.equivFun.symm.injective
    rw [eigenbasis.equivFun.symm_apply_apply]
    rw [eigenbasis.equivFun_symm_apply]
    exact hamplitudes

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConstantCoefficientLinearSystem.lean`
SHA-256: `626e45fe5554994975bbe19775b9bdcb6cbcd62a713dfef1568986958459a4ef`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Data.Matrix.Basic

/-!
# Constant-coefficient first-order linear systems

Source-independent pointwise solution predicates for systems of the form
`q_t + A q_x = 0`, together with the canonical one-component matrix and state
used to recover scalar linear advection.
-/

namespace NumStability

/-- A function satisfies the constant-coefficient first-order system
`q_t + A q_x = 0` at a point. -/
def IsConstantCoefficientLinearSystemSolutionAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ)) (coefficient : Matrix ι ι ℝ)
    (x t : ℝ) : Prop :=
  ∃ qt qx : ι → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + coefficient.mulVec qx = 0

/-- A space-time state together with a proof that it solves one fixed
constant-coefficient linear system at every point. -/
structure ConstantCoefficientLinearSystemSolution
    {ι : Type*} [Fintype ι] (coefficient : Matrix ι ι ℝ) where
  /-- The component-valued state as a function of space and time. -/
  state : ℝ → ℝ → (ι → ℝ)
  satisfies : ∀ x t,
    IsConstantCoefficientLinearSystemSolutionAt state coefficient x t

/-- The one-by-one matrix whose only coefficient is `speed`. -/
def constantCoefficientScalarMatrix (speed : ℝ) : Matrix (Fin 1) (Fin 1) ℝ :=
  fun _ _ => speed

/-- Regard a scalar space-time field as a one-component system state. -/
def scalarAsOneComponentSystem
    (q : ℝ → ℝ → ℝ) : ℝ → ℝ → (Fin 1 → ℝ) :=
  fun x t _ => q x t

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw.lean`
SHA-256: `933db56e0899e4a226cd14ce0be8cdc20646a2a0b33dc66fb501704f6f01a8f0`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Pi
import Mathlib.Data.Matrix.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem

/-!
# One-dimensional conservation laws

Source-independent pointwise predicates for classical one-dimensional
conservation laws, their quasilinear form, and constant linear fluxes.
-/

namespace NumStability

/-- A state satisfies the classical conservation-law residual
`q_t + (flux(q))_x = 0` at `(x,t)`. -/
def IsConservationLawSolutionAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ)) (x t : ℝ) : Prop :=
  ∃ qt fluxx : ι → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => flux (q ξ t)) fluxx x ∧
        qt + fluxx = 0

/-- A state satisfies the quasilinear equation
`q_t + Dflux(q) q_x = 0` at `(x,t)`. -/
def IsQuasilinearConservationLawSolutionAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (fluxDerivative :
      (ι → ℝ) → ((ι → ℝ) →L[ℝ] (ι → ℝ)))
    (x t : ℝ) : Prop :=
  ∃ qt qx : ι → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + fluxDerivative (q x t) qx = 0

/-- Under the explicit differentiability hypotheses needed for the chain
rule, the conservation residual and its quasilinear form are equivalent. -/
theorem conservationLaw_iff_quasilinearAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ))
    (fluxDerivative :
      (ι → ℝ) → ((ι → ℝ) →L[ℝ] (ι → ℝ)))
    (x t : ℝ) (qx : ι → ℝ)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x)
    (hflux : HasFDerivAt flux (fluxDerivative (q x t)) (q x t)) :
    IsConservationLawSolutionAt q flux x t ↔
      IsQuasilinearConservationLawSolutionAt q fluxDerivative x t := by
  have hchain :
      HasDerivAt (fun ξ => flux (q ξ t))
        (fluxDerivative (q x t) qx) x := by
    simpa only [Function.comp_apply, ContinuousLinearMap.comp_apply,
      ContinuousLinearMap.toSpanSingleton_apply, one_smul] using
      (hflux.comp x hqx.hasFDerivAt).hasDerivAt
  constructor
  · rintro ⟨qt, fluxx, hqt, hfluxx, hresidual⟩
    have hfluxx_unique : fluxx = fluxDerivative (q x t) qx :=
      hfluxx.unique hchain
    subst fluxx
    exact ⟨qt, qx, hqt, hqx, hresidual⟩
  · rintro ⟨qt, qx', hqt, hqx', hresidual⟩
    have hchain' :
        HasDerivAt (fun ξ => flux (q ξ t))
          (fluxDerivative (q x t) qx') x := by
      simpa only [Function.comp_apply, ContinuousLinearMap.comp_apply,
        ContinuousLinearMap.toSpanSingleton_apply, one_smul] using
        (hflux.comp x hqx'.hasFDerivAt).hasDerivAt
    exact ⟨qt, fluxDerivative (q x t) qx', hqt, hchain', hresidual⟩

/-- The constant linear flux `state ↦ A state`. -/
def constantLinearFlux
    {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ) (state : ι → ℝ) : ι → ℝ :=
  coefficient.mulVec state

/-- Along a differentiable state curve, the derivative of a constant linear
flux is the same matrix applied to the state derivative. -/
theorem hasDerivAt_constantLinearFlux_comp
    {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ)
    (state : ℝ → (ι → ℝ)) (stateDerivative : ι → ℝ) (x : ℝ)
    (hstate : HasDerivAt state stateDerivative x) :
    HasDerivAt (fun ξ => constantLinearFlux coefficient (state ξ))
      (coefficient.mulVec stateDerivative) x := by
  rw [hasDerivAt_pi] at hstate ⊢
  intro i
  simp only [constantLinearFlux, Matrix.mulVec, dotProduct]
  exact HasDerivAt.fun_sum fun j _ => (hstate j).const_mul (coefficient i j)

/-- A conservation law with constant linear flux `f(q) = A q` is exactly the
constant-coefficient first-order system `q_t + A q_x = 0`. -/
theorem conservationLaw_constantLinearFlux_iff
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ)) (coefficient : Matrix ι ι ℝ)
    (x t : ℝ) (qx : ι → ℝ)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x) :
    IsConservationLawSolutionAt q (constantLinearFlux coefficient) x t ↔
      IsConstantCoefficientLinearSystemSolutionAt q coefficient x t := by
  constructor
  · rintro ⟨qt, fluxx, hqt, hfluxx, hresidual⟩
    have hlinear := hasDerivAt_constantLinearFlux_comp
      coefficient (fun ξ => q ξ t) qx x hqx
    have hfluxx_unique : fluxx = coefficient.mulVec qx :=
      hfluxx.unique hlinear
    subst fluxx
    exact ⟨qt, qx, hqt, hqx, hresidual⟩
  · rintro ⟨qt, qx', hqt, hqx', hresidual⟩
    refine ⟨qt, coefficient.mulVec qx', hqt, ?_, hresidual⟩
    exact hasDerivAt_constantLinearFlux_comp
      coefficient (fun ξ => q ξ t) qx' x hqx'

/-- Every solution of a constant-coefficient system is a conservation-law
solution for the corresponding linear flux. -/
theorem constantCoefficientLinearSystem_isConservationLaw
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ)) (coefficient : Matrix ι ι ℝ)
    (x t : ℝ)
    (hsystem : IsConstantCoefficientLinearSystemSolutionAt
      q coefficient x t) :
    IsConservationLawSolutionAt q (constantLinearFlux coefficient) x t := by
  rcases hsystem with ⟨qt, qx, hqt, hqx, hresidual⟩
  refine ⟨qt, coefficient.mulVec qx, hqt, ?_, hresidual⟩
  exact hasDerivAt_constantLinearFlux_comp
    coefficient (fun ξ => q ξ t) qx x hqx

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/IntegralConservationLaw.lean`
SHA-256: `1f8c29ed60aa56008c79a38acf7ff702b5f701fa60eae02733ebe824a0dd8800`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw

/-!
# Integral and differential forms of one-dimensional conservation laws

The integral formulation records the time derivative of every oriented cell
integral.  A separate theorem derives the classical pointwise residual under
explicit differentiation-under-the-integral and spatial smoothness hypotheses.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The integral conservation law: the rate of change of the state between
any two endpoints is the incoming flux minus the outgoing flux. -/
def IsIntegralConservationLawSolution
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ)) : Prop :=
  ∀ a b t,
    IntervalIntegrable (fun x => q x t) volume a b ∧
      HasDerivAt (fun τ => ∫ x in a..b, q x τ)
        (flux (q a t) - flux (q b t)) t

/-- A continuous function whose integral on every oriented interval is zero
vanishes pointwise. -/
theorem continuous_eq_zero_of_intervalIntegral_eq_zero
    {ι : Type*} [Fintype ι]
    (g : ℝ → (ι → ℝ)) (hcontinuous : Continuous g)
    (hintegral : ∀ a b, ∫ x in a..b, g x = 0) :
    ∀ x, g x = 0 := by
  intro x
  have hderiv := intervalIntegral.integral_hasDerivAt_right
    (hcontinuous.intervalIntegrable 0 x)
    hcontinuous.aestronglyMeasurable.stronglyMeasurableAtFilter
    hcontinuous.continuousAt
  have hzeroDerivative : HasDerivAt (fun _ : ℝ => 0) (g x) x :=
    hderiv.congr_of_eventuallyEq
      (Filter.Eventually.of_forall fun b => (hintegral 0 b).symm)
  exact hzeroDerivative.unique (hasDerivAt_const x 0)

/-- Under explicit classical smoothness and interchange hypotheses, the
integral balance implies the differential conservation-law residual. -/
theorem integralConservationLaw_implies_pointwise
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ))
    (qt fluxx : ℝ → (ι → ℝ)) (t : ℝ)
    (hintegralLaw : IsIntegralConservationLawSolution q flux)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hfluxx : ∀ x,
      HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : ∀ a b, IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : ∀ a b, IntervalIntegrable fluxx volume a b)
    (hinterchange : ∀ a b,
      HasDerivAt (fun τ => ∫ x in a..b, q x τ)
        (∫ x in a..b, qt x) t)
    (hresidualContinuous : Continuous fun x => qt x + fluxx x) :
    ∀ x, IsConservationLawSolutionAt q flux x t := by
  have hqtIntegral (a b : ℝ) :
      ∫ x in a..b, qt x = flux (q a t) - flux (q b t) :=
    (hinterchange a b).unique (hintegralLaw a b t).2
  have hfluxxIntegral (a b : ℝ) :
      ∫ x in a..b, fluxx x = flux (q b t) - flux (q a t) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun x _ => hfluxx x) (hfluxxIntegrable a b)
  have hresidualIntegral (a b : ℝ) :
      ∫ x in a..b, (qt x + fluxx x) = 0 := by
    rw [intervalIntegral.integral_add
      (hqtIntegrable a b) (hfluxxIntegrable a b),
      hqtIntegral a b, hfluxxIntegral a b]
    abel
  have hpointwise := continuous_eq_zero_of_intervalIntegral_eq_zero
    (fun x => qt x + fluxx x) hresidualContinuous hresidualIntegral
  intro x
  exact ⟨qt x, fluxx x, hqt x, hfluxx x, hpointwise x⟩

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean`
SHA-256: `35ab3a9c610ddbc90dec920888d39ff4bd36c54e7fe093e1bc4ace131950c3da`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# One-dimensional Riemann data

Source-independent definitions for piecewise constant initial data with one
jump at the origin.  The predicate intentionally imposes no condition at the
origin, and `riemannData` exposes that free value as an explicit parameter.
-/

namespace NumStability

/-- A field has left state `leftState` on `x < 0` and right state `rightState`
on `x > 0`.  Its value at `x = 0` is deliberately unspecified. -/
def IsRiemannData
    {State : Type*} (data : ℝ → State)
    (leftState rightState : State) : Prop :=
  (∀ x : ℝ, x < 0 → data x = leftState) ∧
    (∀ x : ℝ, 0 < x → data x = rightState)

/-- Riemann data with an explicit, freely chosen value at the jump point. -/
noncomputable def riemannData
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    ℝ → State :=
  fun x =>
    if x < 0 then leftState
    else if 0 < x then rightState
    else valueAtOrigin

/-- The parameterized construction satisfies the Riemann-data predicate. -/
theorem riemannData_isRiemannData
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    IsRiemannData
      (riemannData leftState valueAtOrigin rightState)
      leftState rightState := by
  constructor
  · intro x hx
    simp [riemannData, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt_of_ge (le_of_lt hx)
    simp [riemannData, hx, hnotLeft]

/-- The value of `riemannData` at the jump is exactly its free parameter. -/
@[simp]
theorem riemannData_zero
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    riemannData leftState valueAtOrigin rightState 0 = valueAtOrigin := by
  simp [riemannData]

/-- The Riemann-data predicate characterizes exactly the functions obtained by
choosing an arbitrary value at the origin. -/
theorem isRiemannData_iff_exists_valueAtOrigin
    {State : Type*} (data : ℝ → State)
    (leftState rightState : State) :
    IsRiemannData data leftState rightState ↔
      ∃ valueAtOrigin,
        data = riemannData leftState valueAtOrigin rightState := by
  constructor
  · rintro ⟨hleft, hright⟩
    refine ⟨data 0, funext ?_⟩
    intro x
    rcases lt_trichotomy x 0 with hx | hx | hx
    · simpa [riemannData, hx] using hleft x hx
    · subst x
      simp
    · have hnotLeft : ¬ x < 0 := not_lt_of_ge (le_of_lt hx)
      simpa [riemannData, hx, hnotLeft] using hright x hx
  · rintro ⟨valueAtOrigin, rfl⟩
    exact riemannData_isRiemannData leftState valueAtOrigin rightState

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInterface.lean`
SHA-256: `1e457fa9277414332e1ca729bca1b989c28b88f5d753225e2dfb89d55b75bbea`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData

/-!
# Certified Riemann solves at finite-volume interfaces

This file supplies source-independent semantics for the local construction
used by one-dimensional finite-volume methods.  Integer-indexed cells are
actual adjacent intervals, their states are normalized interval integrals,
and a solver result carries a proof that its space-time field solves the
hyperbolic Riemann problem.  Numerical-flux information is extracted from
that certified solution before it is used in a conservative time update.

No formula for an approximate Riemann solver or numerical flux is imposed.
Instead, a flux procedure must at least be consistent on constant Riemann
problems; this leaves exact and suitably approximate interface procedures in
scope while excluding functions wholly unrelated to the physical flux.
-/

open MeasureTheory

namespace NumStability

/-- An integer-indexed one-dimensional finite-volume grid.  Cell `i - 1` and
cell `i` are genuinely adjacent: the right endpoint of the former is the left
endpoint of the latter. -/
structure OneDimensionalFiniteVolumeGrid where
  /-- The left endpoint of each integer-indexed cell. -/
  cellLeft : ℤ → ℝ
  /-- The right endpoint of each integer-indexed cell. -/
  cellRight : ℤ → ℝ
  cell_nonempty : ∀ i, cellLeft i < cellRight i
  adjacent : ∀ i, cellRight (i - 1) = cellLeft i

namespace OneDimensionalFiniteVolumeGrid

/-- The positive volume (length) of a one-dimensional finite-volume cell. -/
def cellVolume (grid : OneDimensionalFiniteVolumeGrid) (i : ℤ) : ℝ :=
  grid.cellRight i - grid.cellLeft i

/-- Every cell in a one-dimensional finite-volume grid has positive volume. -/
theorem cellVolume_pos (grid : OneDimensionalFiniteVolumeGrid) (i : ℤ) :
    0 < grid.cellVolume i :=
  sub_pos.mpr (grid.cell_nonempty i)

end OneDimensionalFiniteVolumeGrid

/-- The state stored in cell `i`: the normalized integral of the underlying
state field over the actual interval occupied by that cell. -/
noncomputable def finiteVolumeCellAverageOn
    {State : Type*} [NormedAddCommGroup State] [NormedSpace ℝ State]
    (grid : OneDimensionalFiniteVolumeGrid) (state : ℝ → State)
    (i : ℤ) : State :=
  oneDimensionalCellAverage state (grid.cellLeft i) (grid.cellRight i)

/-- The canonical grid value is a genuine cell integral divided by the
positive volume of its cell. -/
theorem finiteVolumeCellAverageOn_spec
    {State : Type*} [NormedAddCommGroup State] [NormedSpace ℝ State]
    (grid : OneDimensionalFiniteVolumeGrid) (state : ℝ → State)
    (hintegrable : ∀ i, IntervalIntegrable state volume
      (grid.cellLeft i) (grid.cellRight i)) (i : ℤ) :
    IsOneDimensionalCellAverage state (grid.cellLeft i) (grid.cellRight i)
      (finiteVolumeCellAverageOn grid state i) :=
  oneDimensionalCellAverage_isCellAverage state
    (grid.cell_nonempty i) (hintegrable i)

/-- A differentiable one-dimensional conservation law whose flux Jacobian is
hyperbolic at every state.  `fluxDerivative_eq_jacobian_mulVec` ties the
matrix used by the hyperbolicity condition to the actual derivative of the
physical flux. -/
structure OneDimensionalHyperbolicConservationLaw
    (Component : Type*) [Fintype Component] where
  /-- The physical flux as a function of the conserved state. -/
  physicalFlux : (Component → ℝ) → (Component → ℝ)
  /-- The Fréchet derivative of the physical flux at each state. -/
  fluxDerivative :
    (Component → ℝ) → ((Component → ℝ) →L[ℝ] (Component → ℝ))
  /-- The matrix representing the flux derivative in component coordinates. -/
  fluxJacobian : (Component → ℝ) → Matrix Component Component ℝ
  hasFDerivAt_physicalFlux : ∀ state,
    HasFDerivAt physicalFlux (fluxDerivative state) state
  fluxDerivative_eq_jacobian_mulVec : ∀ state direction,
    fluxDerivative state direction = (fluxJacobian state).mulVec direction
  jacobian_hyperbolic : ∀ state, IsRealHyperbolicMatrix (fluxJacobian state)

/-- The local hyperbolic Riemann problem determined by ordered left and right
states.  Its initial data are understood through `IsRiemannData`, so the value
at the jump itself remains immaterial. -/
structure HyperbolicRiemannProblem
    {Component : Type*} [Fintype Component]
    (_law : OneDimensionalHyperbolicConservationLaw Component) where
  /-- The constant initial state to the left of the jump. -/
  leftState : Component → ℝ
  /-- The constant initial state to the right of the jump. -/
  rightState : Component → ℝ

/-- A space-time field solves a hyperbolic Riemann problem when its initial
trace has the prescribed ordered piecewise-constant states and it satisfies
the integral conservation law for the problem's physical flux. -/
def IsHyperbolicRiemannSolution
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (problem : HyperbolicRiemannProblem law)
    (solution : ℝ → ℝ → (Component → ℝ)) : Prop :=
  IsRiemannData (fun x ↦ solution x 0)
      problem.leftState problem.rightState ∧
    IsIntegralConservationLawSolution solution law.physicalFlux

/-- A solver result paired with a mathematical certificate that it solves the
particular Riemann problem from which it was obtained. -/
structure CertifiedHyperbolicRiemannSolution
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (problem : HyperbolicRiemannProblem law) where
  /-- The space-time field proposed as the solution of `problem`. -/
  solution : ℝ → ℝ → (Component → ℝ)
  solves : IsHyperbolicRiemannSolution law problem solution

/-- A Riemann-interface procedure.  It solves each ordered local problem,
extracts method-specific information from the certified solution, and turns
that information into a numerical flux.  Constant-state consistency provides
the minimum physical qualification without prescribing a formula or error
metric for nonconstant exact or approximate fluxes. -/
structure RiemannInterfaceFluxMethod
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (Information : Type*) where
  /-- Solve an ordered Riemann problem and certify the resulting field. -/
  solve : (problem : HyperbolicRiemannProblem law) →
    CertifiedHyperbolicRiemannSolution law problem
  /-- Extract the method-specific information used to form an interface
  flux from a certified Riemann solution. -/
  extractInformation : {problem : HyperbolicRiemannProblem law} →
    CertifiedHyperbolicRiemannSolution law problem → Information
  /-- Convert extracted Riemann information into a numerical flux vector. -/
  numericalFluxFromInformation : Information → (Component → ℝ)
  consistent_on_constant_states : ∀ state,
    numericalFluxFromInformation
        (extractInformation
          (solve ({ leftState := state, rightState := state } :
            HyperbolicRiemannProblem law))) =
      law.physicalFlux state

/-- The Riemann problem at interface `i`, oriented from cell `i - 1` to cell
`i`. -/
def adjacentCellRiemannProblem
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (cellAverages : ℤ → (Component → ℝ)) (i : ℤ) :
    HyperbolicRiemannProblem law :=
  { leftState := cellAverages (i - 1)
    rightState := cellAverages i }

/-- Information extracted from the certified Riemann solution at interface
`i`. -/
def adjacentCellRiemannInformation
    {Component Information : Type*} [Fintype Component]
    {law : OneDimensionalHyperbolicConservationLaw Component}
    (method : RiemannInterfaceFluxMethod law Information)
    (cellAverages : ℤ → (Component → ℝ)) (i : ℤ) : Information :=
  method.extractInformation
    (method.solve (adjacentCellRiemannProblem law cellAverages i))

/-- A numerical interface flux computed from information extracted from the
certified adjacent-cell Riemann solution. -/
def riemannInterfaceFlux
    {Component Information : Type*} [Fintype Component]
    {law : OneDimensionalHyperbolicConservationLaw Component}
    (method : RiemannInterfaceFluxMethod law Information)
    (cellAverages : ℤ → (Component → ℝ)) (i : ℤ) : Component → ℝ :=
  method.numericalFluxFromInformation
    (adjacentCellRiemannInformation method cellAverages i)

/-- One conservative time-step update using the numerical fluxes supplied by
the adjacent-cell Riemann solutions.  The scale is the actual positive cell
volume rather than an unrelated global parameter. -/
noncomputable def riemannFiniteVolumeUpdate
    {Component : Type*}
    (grid : OneDimensionalFiniteVolumeGrid) (timeStep : ℝ)
    (cellAverages edgeFlux : ℤ → (Component → ℝ)) (i : ℤ) :
    Component → ℝ :=
  cellAverages i -
    (timeStep / grid.cellVolume i) • (edgeFlux (i + 1) - edgeFlux i)

/-- Riemann initial data formed from the two cells adjacent to interface `i`.
This elementary constructor is retained for equation-level statements whose
value at the jump is chosen explicitly. -/
noncomputable def adjacentCellRiemannData
    {State : Type*} (cellAverages : ℤ → State)
    (valueAtOrigin : State) (i : ℤ) : ℝ → State :=
  riemannData (cellAverages (i - 1)) valueAtOrigin (cellAverages i)

/-- The adjacent-cell construction has the intended left and right states. -/
theorem adjacentCellRiemannData_isRiemannData
    {State : Type*} (cellAverages : ℤ → State)
    (valueAtOrigin : State) (i : ℤ) :
    IsRiemannData (adjacentCellRiemannData cellAverages valueAtOrigin i)
      (cellAverages (i - 1)) (cellAverages i) :=
  riemannData_isRiemannData _ _ _

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalFluxAverage`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/PhysicalFluxAverage.lean`
SHA-256: `9f8e66ac994cc2ebd614639bc9e1eb75991b65c4a666472e1130c60190b0997a`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface

/-!
# Time-averaged physical face fluxes

The physical reference is a time average at an actual grid face. Rectangle
conservation gives the exact mass change of a cell between two times.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

variable {m : ℕ}

/-- Physical flux through the left face of cell `j`, averaged in time. -/
noncomputable def timeAveragedPhysicalFaceFlux (grid : OneDimensionalFiniteVolumeGrid)
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (s t : ℝ) (j : ℤ) : Fin m → ℝ :=
  oneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft j) τ)) s t

/-- Temporal integrability and positive duration certify the face average. -/
theorem timeAveragedPhysicalFaceFlux_isCellAverage (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux) {s t : ℝ} (hst : s < t)
    (j : ℤ) :
    IsOneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft j) τ)) s t
      (timeAveragedPhysicalFaceFlux grid q flux s t j) :=
  oneDimensionalCellAverage_isCellAverage _ hst (hq.2.1 _ _ _)

/-- Duration times the physical face average is its time integral. -/
theorem timeStep_smul_timeAveragedPhysicalFaceFlux (grid : OneDimensionalFiniteVolumeGrid)
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (j : ℤ) :
    (t - s) • timeAveragedPhysicalFaceFlux grid q flux s t j =
      ∫ τ in s..t, flux (q (grid.cellLeft j) τ) :=
  cellWidth_smul_oneDimensionalCellAverage _ hst

/-- Exact cell mass changes by the integrated left-minus-right physical flux. -/
theorem finiteVolumeCellAverageOn_mass_balance (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux) {s t : ℝ} (hst : s < t)
    (i : ℤ) :
    grid.cellVolume i • finiteVolumeCellAverageOn grid (fun x => q x t) i -
        grid.cellVolume i • finiteVolumeCellAverageOn grid (fun x => q x s) i =
      (t - s) • (timeAveragedPhysicalFaceFlux grid q flux s t i -
        timeAveragedPhysicalFaceFlux grid q flux s t (i + 1)) := by
  have hadj : grid.cellLeft (i + 1) = grid.cellRight i := by
    simpa using (grid.adjacent (i + 1)).symm
  rw [smul_sub, timeStep_smul_timeAveragedPhysicalFaceFlux grid q flux hst,
    timeStep_smul_timeAveragedPhysicalFaceFlux grid q flux hst, hadj]
  change (grid.cellRight i - grid.cellLeft i) •
      oneDimensionalCellAverage (fun x => q x t) _ _ -
      (grid.cellRight i - grid.cellLeft i) •
        oneDimensionalCellAverage (fun x => q x s) _ _ = _
  rw [cellWidth_smul_oneDimensionalCellAverage _ (grid.cell_nonempty i),
    cellWidth_smul_oneDimensionalCellAverage _ (grid.cell_nonempty i),
    hq.2.2, intervalIntegral.integral_sub (hq.2.1 _ _ _) (hq.2.1 _ _ _)]

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalFluxBalance.lean`
SHA-256: `122237fad4f0702f50721b2a425de8e814b73feef02b81025021835545655ae1`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
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
  /-- The cell designated as the left side of each oriented interface. -/
  leftCell : Interface → Cell
  /-- The cell designated as the right side of each oriented interface. -/
  rightCell : Interface → Cell
  leftCell_ne_rightCell : ∀ interface,
    leftCell interface ≠ rightCell interface
  /-- The physical point at which each interface is located. -/
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

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FluxDifference.lean`
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

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateError`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FluxUpdateError.lean`
SHA-256: `e899912a12d85b1ede3d136d466ba55cbb26ed53cc0528061510772c8a6a5b5c`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalFluxAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference

/-!
# Exact finite-volume error identities

Numerical arrays are independent of exact cell averages. An arbitrary
time-dependent full-array flux rule gives a local weighted error identity;
finite contiguous blocks retain only their two exterior face errors.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

variable {m : ℕ}

private theorem cellVolume_smul_riemannFiniteVolumeUpdate_fromRule (grid : OneDimensionalFiniteVolumeGrid)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    (s t : ℝ) (old : ℤ → (Fin m → ℝ)) (i : ℤ) :
    grid.cellVolume i • riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i =
      grid.cellVolume i • old i -
        (t - s) • (rule s t old (i + 1) - rule s t old i) :=
  cellVolume_smul_finiteVolumeCellAverageUpdate (t - s) (grid.cellVolume i)
    (old i) (rule s t old (i + 1) - rule s t old i)
    (ne_of_gt (grid.cellVolume_pos i))

/-- Old numerical error and numerical-minus-physical face errors give the exact new error. -/
theorem riemannFiniteVolumeUpdate_weighted_error (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (i : ℤ) :
    grid.cellVolume i • (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
        finiteVolumeCellAverageOn grid (fun x => q x t) i) =
      grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
        (t - s) • ((rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i) -
          (rule s t old (i + 1) - timeAveragedPhysicalFaceFlux grid q flux s t (i + 1))) := by
  have hexact := finiteVolumeCellAverageOn_mass_balance grid hq hst i
  have htime := eq_add_of_sub_eq hexact
  rw [smul_sub, cellVolume_smul_riemannFiniteVolumeUpdate_fromRule, htime]
  module

/-- Interior flux errors cancel on every finite contiguous block, including nonuniform cells. -/
theorem riemannFiniteVolumeUpdate_block_error (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (start : ℤ) (count : ℕ) :
    (∑ k ∈ Finset.range count,
      grid.cellVolume (start + k) • (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) (start + k) -
        finiteVolumeCellAverageOn grid (fun x => q x t) (start + k))) =
      (∑ k ∈ Finset.range count,
        grid.cellVolume (start + k) • (old (start + k) -
          finiteVolumeCellAverageOn grid (fun x => q x s) (start + k))) +
      (t - s) • ((rule s t old start - timeAveragedPhysicalFaceFlux grid q flux s t start) -
        (rule s t old (start + count) - timeAveragedPhysicalFaceFlux grid q flux s t (start + count))) := by
  let oldError : ℕ → (Fin m → ℝ) := fun k =>
    grid.cellVolume (start + k) • (old (start + k) -
      finiteVolumeCellAverageOn grid (fun x => q x s) (start + k))
  let edgeError : ℕ → (Fin m → ℝ) := fun k =>
    rule s t old (start + k) - timeAveragedPhysicalFaceFlux grid q flux s t (start + k)
  calc
    _ = ∑ k ∈ Finset.range count,
        conservativeFluxDifferenceUpdate (t - s) oldError edgeError k := by
      apply Finset.sum_congr rfl
      intro k hk
      rw [riemannFiniteVolumeUpdate_weighted_error grid hq rule hst old]
      simp only [conservativeFluxDifferenceUpdate, oldError, edgeError,
        Nat.cast_add, Nat.cast_one, add_assoc]
      module
    _ = (∑ k ∈ Finset.range count, oldError k) -
        (t - s) • (edgeError count - edgeError 0) :=
      sum_conservativeFluxDifferenceUpdate _ _ _ _
    _ = _ := by
      simp only [oldError, edgeError, Nat.cast_zero, add_zero]
      module

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FluxUpdateErrorBounds.lean`
SHA-256: `5c8d03f4c30c38c0624a9bdba6c57c68d822402f124945bb5c8828f27acf5727`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateError

/-!
# Conditional finite-volume error bounds

Bounds on old cell errors and face-flux errors imply next-step bounds.
The block estimate controls the norm of total mass error, allowing
cancellation; it is not a sum of absolute new cell errors.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

private theorem norm_le_of_weighted_balance {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    {width dt oldBound leftBound rightBound : ℝ} (hw : 0 < width) (hdt : 0 ≤ dt)
    {nextError oldError leftError rightError : E}
    (hbalance : width • nextError = width • oldError + dt • (leftError - rightError))
    (hold : ‖oldError‖ ≤ oldBound) (hleft : ‖leftError‖ ≤ leftBound)
    (hright : ‖rightError‖ ≤ rightBound) :
    ‖nextError‖ ≤ oldBound + dt / width * (leftBound + rightBound) := by
  have hnorm : width * ‖nextError‖ ≤
      width * ‖oldError‖ + dt * (‖leftError‖ + ‖rightError‖) := by
    calc
      _ = ‖width • nextError‖ := by simp [norm_smul, abs_of_pos hw]
      _ = ‖width • oldError + dt • (leftError - rightError)‖ := congrArg norm hbalance
      _ ≤ ‖width • oldError‖ + ‖dt • (leftError - rightError)‖ := norm_add_le _ _
      _ ≤ _ := by
        simp only [norm_smul, Real.norm_eq_abs, abs_of_pos hw, abs_of_nonneg hdt]
        exact add_le_add le_rfl (mul_le_mul_of_nonneg_left (norm_sub_le leftError rightError) hdt)
  apply (mul_le_mul_iff_right₀ hw).mp
  calc
    width * ‖nextError‖ ≤ width * oldBound + dt * (leftBound + rightBound) :=
      hnorm.trans (add_le_add (mul_le_mul_of_nonneg_left hold hw.le)
        (mul_le_mul_of_nonneg_left (add_le_add hleft hright) hdt))
    _ = width * (oldBound + dt / width * (leftBound + rightBound)) := by
      field_simp

/-- Input error and the two face-flux error bounds control the new cell-average error. -/
theorem riemannFiniteVolumeUpdate_error_le {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (i : ℤ)
    {oldBound leftBound rightBound : ℝ}
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound)
    (hleft : ‖rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i‖ ≤ leftBound)
    (hright : ‖rule s t old (i + 1) -
      timeAveragedPhysicalFaceFlux grid q flux s t (i + 1)‖ ≤ rightBound) :
    ‖riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
      finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
      oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound) :=
  norm_le_of_weighted_balance (grid.cellVolume_pos i) (sub_nonneg.mpr hst.le)
    (riemannFiniteVolumeUpdate_weighted_error grid hq rule hst old i) hold hleft hright

/-- Old cell-error bounds and the exterior flux-error bounds control total block mass error. -/
theorem riemannFiniteVolumeUpdate_block_mass_error_le {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (start : ℤ) (count : ℕ)
    (oldBound : ℕ → ℝ) {leftBound rightBound : ℝ}
    (hold : ∀ k ∈ Finset.range count,
      ‖old (start + k) - finiteVolumeCellAverageOn grid (fun x => q x s) (start + k)‖ ≤ oldBound k)
    (hleft : ‖rule s t old start - timeAveragedPhysicalFaceFlux grid q flux s t start‖ ≤ leftBound)
    (hright : ‖rule s t old (start + count) -
      timeAveragedPhysicalFaceFlux grid q flux s t (start + count)‖ ≤ rightBound) :
    ‖∑ k ∈ Finset.range count, grid.cellVolume (start + k) •
      (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) (start + k) -
        finiteVolumeCellAverageOn grid (fun x => q x t) (start + k))‖ ≤
      (∑ k ∈ Finset.range count, grid.cellVolume (start + k) * oldBound k) +
        (t - s) * (leftBound + rightBound) := by
  have hsum : ‖∑ k ∈ Finset.range count, grid.cellVolume (start + k) •
      (old (start + k) - finiteVolumeCellAverageOn grid (fun x => q x s) (start + k))‖ ≤
      ∑ k ∈ Finset.range count, grid.cellVolume (start + k) * oldBound k := by
    apply (norm_sum_le _ _).trans
    apply Finset.sum_le_sum
    intro k hk
    rw [norm_smul, Real.norm_eq_abs, abs_of_pos (grid.cellVolume_pos _)]
    exact mul_le_mul_of_nonneg_left (hold k hk) (grid.cellVolume_pos _).le
  have hbalance := riemannFiniteVolumeUpdate_block_error grid hq rule hst old start count
  have h := norm_le_of_weighted_balance (E := Fin m → ℝ) (width := 1)
    (by norm_num) (sub_nonneg.mpr hst.le) (by simpa using hbalance) hsum hleft hright
  simpa using h

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInformationFluxMethod.lean`
SHA-256: `12ed4b1f17aefd9b4d6d21e9730260ded49a46c5533131bc399aacbe76a6e6de`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface

/-!
# Riemann routines returning information

A routine on an explicit problem domain returns a dependent result, extracts
information and computes a constant-consistent flux. No returned field or PDE
certificate is required. Consistency alone does not assert physical accuracy.
-/

namespace NumStability

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}

structure RiemannInformationFluxMethod (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (Result : HyperbolicRiemannProblem law → Type*) (Information : Type*) where
  domain : HyperbolicRiemannProblem law → Prop
  solve : (problem : HyperbolicRiemannProblem law) → domain problem → Result problem
  extract : {problem : HyperbolicRiemannProblem law} → Result problem → Information
  numericalFlux : Information → (Fin m → ℝ)
  constants_in_domain : ∀ state,
    domain ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
  consistent : ∀ state, numericalFlux (extract (solve
    ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
    (constants_in_domain state))) = law.physicalFlux state

namespace RiemannInformationFluxMethod

variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

def selectedResult (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    Result (adjacentCellRiemannProblem law old j) :=
  method.solve (adjacentCellRiemannProblem law old j) (hdomain j)

def interfaceFlux (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    Fin m → ℝ :=
  method.numericalFlux (method.extract (selectedResult method old hdomain j))

/-- The ordered input and information belong to this selected result. No
physical solution, returned field or accuracy property is concluded. -/
theorem interface_execution (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    let problem := adjacentCellRiemannProblem law old j
    let result := method.solve problem (hdomain j)
    problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
    selectedResult method old hdomain j = result ∧
    interfaceFlux method old hdomain j = method.numericalFlux (method.extract result) :=
  ⟨rfl, rfl, rfl, rfl⟩

theorem interfaceFlux_constant (method : RiemannInformationFluxMethod law Result Information) (state : Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law (fun _ => state) j)) (j : ℤ) :
    interfaceFlux method (fun _ => state) hdomain j = law.physicalFlux state := by
  exact method.consistent state

end RiemannInformationFluxMethod
end NumStability
```

### `ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation`

Path: `ComputationalMathematics/MeasureTheory/Integral/IntervalIntegral/LebesgueDifferentiation.lean`
SHA-256: `a816ba384ecf034f9f6f158cefc7b40d360ef225b94c005c3e43cb03c2e681f7`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiationThm
import Mathlib.MeasureTheory.SpecificCodomains.Pi
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Almost-everywhere differentiation of finite-vector interval integrals

Scalar Lebesgue differentiation lifts coordinatewise to finite real vectors.
The exceptional null set is independent of the lower integration endpoint.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

theorem ae_hasDerivAt_intervalIntegral_pi {ι : Type*} [Fintype ι]
    (f : ℝ → ι → ℝ) (hf : ∀ a b, IntervalIntegrable f volume a b) :
    ∀ᵐ t, ∀ c, HasDerivAt (fun s => ∫ r in c..s, f r) (f t) t := by
  have hlocal (i : ι) : LocallyIntegrable (fun t => f t i) volume := by
    intro t
    refine ⟨Ioc (t - 1) (t + 1), Ioc_mem_nhds (by linarith) (by linarith), ?_⟩
    exact (hf (t - 1) (t + 1)).1.eval i
  have hall : ∀ᵐ t, ∀ i, ∀ c,
      HasDerivAt (fun s => ∫ r in c..s, f r i) (f t i) t :=
    ae_all_iff.mpr fun i => LocallyIntegrable.ae_hasDerivAt_integral (hlocal i)
  filter_upwards [hall] with t ht
  intro c
  apply hasDerivAt_pi.mpr
  intro i
  have heq : (fun s => (∫ r in c..s, f r) i) =
      (fun s => ∫ r in c..s, f r i) := by
    funext s
    exact (ContinuousLinearMap.intervalIntegral_comp_comm
      (ContinuousLinearMap.proj (R := ℝ) i) (hf c s)).symm
  rw [heq]
  exact ht i c

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/TemporalDerivative.lean`
SHA-256: `67d72a21b6d9981f3bd3865d1f9db6de90616be340cfbd56762d76c72330cd25`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation

/-!
# Temporal mass derivatives from rectangle conservation

For any finite real state space and flux, rectangle conservation gives the
mass-rate identity almost everywhere in time on each fixed spatial interval.
The exceptional null set may depend on that spatial interval.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

theorem IsRectangleConservationLawSolution.hasDerivAt_mass_ae
    {ι : Type*} [Fintype ι] {q : ℝ → ℝ → ι → ℝ}
    {flux : (ι → ℝ) → ι → ℝ}
    (h : IsRectangleConservationLawSolution q flux) (a b : ℝ) :
    ∀ᵐ t, HasDerivAt (fun s => ∫ x in a..b, q x s)
      (flux (q a t) - flux (q b t)) t := by
  have hflux (s t : ℝ) :
      IntervalIntegrable (fun r => flux (q a r) - flux (q b r)) volume s t :=
    (h.2.1 a s t).sub (h.2.1 b s t)
  filter_upwards [ae_hasDerivAt_intervalIntegral_pi _ hflux] with t ht
  have heq : (fun s => ∫ x in a..b, q x s) =
      (fun s => (∫ r in (0 : ℝ)..s, flux (q a r) - flux (q b r)) +
        (∫ x in a..b, q x 0)) := by
    funext s
    exact sub_eq_iff_eq_add.mp (h.2.2 a b 0 s)
  rw [heq]
  exact (ht 0).add_const _

end NumStability
```
