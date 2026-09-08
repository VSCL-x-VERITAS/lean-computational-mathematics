# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
And
  (∀ (m : Nat) (q : Real → Real → Fin m → Real) (flux : (Fin m → Real) → Fin m → Real) (x t : Real),
    LocalDef002 q flux →
      Not (ContinuousAt (fun ξ => q ξ t) x) →
        And
          (∀ (a b : Real),
            Filter.Eventually
              (fun τ =>
                HasDerivAt (fun s => intervalIntegral (fun ξ => q ξ s) a b Real.measureSpace.volume)
                  (instHSub.hSub (flux (q a τ)) (flux (q b τ))) τ)
              (MeasureTheory.ae Real.measureSpace.volume))
          (And (∀ (qx : Fin m → Real), Not (HasDerivAt (fun ξ => q ξ t) qx x))
            (And (Not (DifferentiableAt Real (fun ξ => q ξ t) x))
              (∀
                (fluxDerivative : (Fin m → Real) → ContinuousLinearMap (RingHom.id Real) (Fin m → Real) (Fin m → Real)),
                Not (LocalDef001 q fluxDerivative x t)))))
  (Exists fun q =>
    Exists fun flux =>
      Exists fun x =>
        Exists fun t =>
          And (LocalDef002 q flux)
            (And (Real.instLT.lt 0 t) (Not (ContinuousAt (fun ξ => q ξ t) x))))
```

## Fully explicit elaborated target type

```lean
And
  (∀ (m : Nat) (q : Real → Real → Fin m → Real) (flux : (Fin m → Real) → Fin m → Real) (x t : Real),
    @LocalDef002.{0} (Fin m → Real)
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
        q flux →
      Not
          (@ContinuousAt.{0, 0} Real (Fin m → Real)
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            (fun (ξ : Real) => q ξ t) x) →
        And
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
                                  (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                    Real.denselyNormedField))))))))
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
                                                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                      Real.normedCommRing))))
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
                  (fun (s : Real) =>
                    @intervalIntegral.{0} (Fin m → Real)
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
                      (fun (ξ : Real) => q ξ s) a b (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace))
                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                    (@instHSub.{0} (Fin m → Real)
                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                    (flux (q a τ)) (flux (q b τ)))
                  τ)
              (@MeasureTheory.ae.{0, 0} Real
                (@MeasureTheory.Measure.{0} Real
                  (@MeasureTheory.MeasureSpace.toMeasurableSpace.{0} Real Real.measureSpace))
                (@MeasureTheory.Measure.instFunLike.{0} Real
                  (@MeasureTheory.MeasureSpace.toMeasurableSpace.{0} Real Real.measureSpace))
                (@MeasureTheory.Measure.instOuterMeasureClass.{0} Real
                  (@MeasureTheory.MeasureSpace.toMeasurableSpace.{0} Real Real.measureSpace))
                (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)))
          (And
            (∀ (qx : Fin m → Real),
              Not
                (@HasDerivAt.{0, 0} Real
                  (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField) (Fin m → Real)
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
                                  (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                    Real.denselyNormedField))))))))
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
                                                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                                                      Real.normedCommRing))))
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
                  (fun (ξ : Real) => q ξ t) qx x))
            (And
              (Not
                (@DifferentiableAt.{0, 0, 0} Real
                  (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField) Real
                  Real.instAddCommGroup
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
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
                  (fun (ξ : Real) => q ξ t) x))
              (∀
                (fluxDerivative :
                  (Fin m → Real) →
                    @ContinuousLinearMap.{0, 0, 0, 0} Real Real Real.semiring Real.semiring
                      (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)) (Fin m → Real)
                      (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        Real.instAddCommMonoid)
                      (Fin m → Real)
                      (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        Real.instAddCommMonoid)
                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
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
                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))),
                Not
                  (@LocalDef001.{0} (Fin m) (Fin.fintype m) q fluxDerivative x
                    t)))))
  (@Exists.{1} (Real → Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
    fun (q : Real → Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) =>
    @Exists.{1}
      ((Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) →
        Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
      fun
        (flux :
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) →
            Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) =>
      @Exists.{1} Real fun (x : Real) =>
        @Exists.{1} Real fun (t : Real) =>
          And
            (@LocalDef002.{0}
              (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
              (@Pi.normedAddCommGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
                (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.normedAddCommGroup)
              (@Pi.normedSpace.{0, 0, 0} Real Real.normedField
                (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
                (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                  @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
              q flux)
            (And
              (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                t)
              (Not
                (@ContinuousAt.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                    (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
                    fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (fun (ξ : Real) => q ξ t) x))))
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `96c347f7c9d9854a453dd782d7a47302e4e8681d15609bee4f2ee04995590712`

Type:

```lean
{ι : Type u_1} →
  [Fintype ι] →
    (Real → Real → ι → Real) →
      ((ι → Real) → ContinuousLinearMap (RingHom.id Real) (ι → Real) (ι → Real)) → Real → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] q fluxDerivative x t =>
  Exists fun qt =>
    Exists fun qx =>
      And (HasDerivAt (fun τ => q x τ) qt t)
        (And (HasDerivAt (fun ξ => q ξ t) qx x)
          (Eq (instHAdd.hAdd qt (ContinuousLinearMap.funLike.coe (fluxDerivative (q x t)) qx)) 0))
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `fbb14b5d2b7941d655b995775ba7559106550b42dada80ff310b1923062aded3`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → Real → E) → (E → E) → Prop
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

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `82717d2b5b5fd49886ea128aa30080e1100361d110dea70258f6f0b567b868e7`

Type:

```lean
∀ {ι : Type u_1}, ContinuousSMul Real (ι → Real)
```

### D004: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `98c22aec54da8e2278fb6c5ae1daeffb76abd7bad320de72096bec6a7046bc17`

Type:

```lean
{M : Type u} → [self : AddCommMonoid M] → AddMonoid M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddCommMonoid M] => self.1
```

### D005: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5305322be4a562f24a6e568a2b0f4a4e3d7cf5ae9a842e07f0c4058c86e0fc14`

Type:

```lean
(R : Type u) → [inst : CommSemiring R] → Algebra R R
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

### D006: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7ed84d651a0f6a77f78d6fd14524fe110f2045971d1f824f15cc8f5b8071484f`

Type:

```lean
{R : Type u} → {A : Type v} → {inst : CommSemiring R} → {inst_1 : Semiring A} → [self : Algebra R A] → SMul R A
```

Definition body (one-level semantic boundary):

```lean
fun R A {inst} {inst_1} [self : Algebra R A] => self.1
```

### D007: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

### D008: `ContinuousAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3c8b2955cfd1b5ec4313254503ce66a5505b003200b3b378f96770b19f854cf6`

Type:

```lean
{X : Type u_1} → {Y : Type u_2} → [TopologicalSpace X] → [TopologicalSpace Y] → (X → Y) → X → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {X} {Y} [TopologicalSpace X] [TopologicalSpace Y] f x => Filter.Tendsto f (nhds x) (nhds (f x))
```

### D009: `ContinuousLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `inductive`
- Distance from target type: `1`
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

### D010: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Type:

```lean
{α : Type u_2} → [DenselyNormedField α] → NontriviallyNormedField α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : DenselyNormedField α] => { toNormedField := inst.toNormedField, non_trivial := ⋯ }
```

### D011: `DifferentiableAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.FDeriv.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a46c89eb4d1ac373bebc42ce4f1152532def717446d73a1bb87314f63a7380d3`

Type:

```lean
(𝕜 : Type u_1) →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup E] →
        [Module 𝕜 E] →
          [TopologicalSpace E] →
            {F : Type u_3} → [inst_4 : AddCommGroup F] → [Module 𝕜 F] → [TopologicalSpace F] → (E → F) → E → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 [NontriviallyNormedField 𝕜] {E} [AddCommGroup E] [Module 𝕜 E] [TopologicalSpace E] {F} [AddCommGroup F]
    [Module 𝕜 F] [TopologicalSpace F] f x =>
  Exists fun f' => HasFDerivAt f f' x
```

### D012: `DistribMulAction.toMulAction`

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

Definition body (one-level semantic boundary):

```lean
fun M A {inst} {inst_1} [self : DistribMulAction M A] => self.1
```

### D013: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `587c80a71f9aa5749b5d6c35c97cdae1067fa669257c865951843b747c511934`

Type:

```lean
{K : Type u_2} → [self : DivisionSemiring K] → Semiring K
```

Definition body (one-level semantic boundary):

```lean
fun K [self : DivisionSemiring K] => self.1
```

### D014: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

### D015: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9a6353c2087dc0f4123f4079d947842f8b7bc1fc0c77de170382c04e31608fd4`

Type:

```lean
{K : Type u_1} → [Field K] → Semifield K
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

### D016: `Filter.Eventually`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `48c8fc03616b0f899835653f1d062e3de4f566255a80b15231ebdedcb0a5c4c4`

Type:

```lean
{α : Type u_1} → (α → Prop) → Filter α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} p f => Filter.instMembership.mem f (setOf fun x => p x)
```

### D017: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

### D018: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Type:

```lean
(n : Nat) → Fintype (Fin n)
```

Definition body (one-level semantic boundary):

```lean
fun n => { elems := { val := Multiset.ofList (List.finRange n), nodup := ⋯ }, complete := ⋯ }
```

### D019: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `98025b38d523c0eadea77ba4961a20b2a913b23c079c4bfeba24a7bfaa24a4bc`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSub α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSub α β γ] => self.1
```

### D020: `HasDerivAt`

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

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NontriviallyNormedField 𝕜] {F} [AddCommGroup F] [Module 𝕜 F] [TopologicalSpace F] [ContinuousSMul 𝕜 F] f f'
    x =>
  HasDerivAtFilter f f' (Filter.instSProd.sprod (nhds x) (Filter.instPure.pure x))
```

### D021: `InnerProductSpace.toNormedSpace`

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

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : InnerProductSpace 𝕜 E] => self.1
```

### D022: `IsModuleTopology.toContinuousSMul`

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

### D023: `IsTopologicalRing.toIsTopologicalSemiring`

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

### D024: `IsTopologicalSemiring.toIsModuleTopology`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.ModuleTopology`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `6658e003840ad10e8620755a49c3db4e3608593c5a679d085f0f988542346d79`

Type:

```lean
∀ (R : Type u_1) [inst : Semiring R] [τR : TopologicalSpace R] [IsTopologicalSemiring R], IsModuleTopology R R
```

### D025: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Type:

```lean
{α : Type u} → [self : LT α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LT α] => self.1
```

### D026: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

### D027: `MeasureTheory.Measure.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `94b2becf9230ce3d438e9b668f79f08e69dbe28c937b1aaca32d96e94b64a5b2`

Type:

```lean
{α : Type u_1} → [inst : MeasurableSpace α] → FunLike (MeasureTheory.Measure α) (Set α) ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {α} [MeasurableSpace α] =>
  { coe := fun μ => MeasureTheory.OuterMeasure.instFunLikeSetENNReal.coe μ.toOuterMeasure, coe_injective' := ⋯ }
```

### D028: `MeasureTheory.Measure.instOuterMeasureClass`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `12c72524345059262ce157fe3d4314569e2e86487366f251af8f57723dda88b7`

Type:

```lean
∀ {α : Type u_1} [inst : MeasurableSpace α], MeasureTheory.OuterMeasureClass (MeasureTheory.Measure α) α
```

### D029: `MeasureTheory.MeasureSpace.toMeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9fcb81af41d67aceded7670716064bc53819a6094bbccd3cb85d7a18952295d3`

Type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace α] → MeasurableSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : MeasureTheory.MeasureSpace α] => self.1
```

### D030: `MeasureTheory.MeasureSpace.volume`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8aa44f6be6ed612f15d809220aa22d43c0715b7383456cd968b96336c71bcb65`

Type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace α] → MeasureTheory.Measure α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : MeasureTheory.MeasureSpace α] => self.2
```

### D031: `MeasureTheory.ae`

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

Definition body (one-level semantic boundary):

```lean
fun {α} {F} [inst : FunLike F (Set α) ENNReal] [MeasureTheory.OuterMeasureClass F α] μ =>
  Filter.ofCountableUnion (fun x => Eq (inst.coe μ x) 0) ⋯ ⋯
```

### D032: `Module.toDistribMulAction`

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

Definition body (one-level semantic boundary):

```lean
fun R M {inst} {inst_1} [self : Module R M] => self.1
```

### D033: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `136930a747dcd73895587cb4c7ea1df27360fed0a4adb57efb71bb8949f0fa71`

Type:

```lean
{M : Type u} → [self : Monoid M] → Semigroup M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : Monoid M] => self.1
```

### D034: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Type:

```lean
{M₀ : Type u} → [self : MonoidWithZero M₀] → Monoid M₀
```

Definition body (one-level semantic boundary):

```lean
fun M₀ [self : MonoidWithZero M₀] => self.1
```

### D035: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `2a4074e38a7cedd1ecdaf86a42d3be01ad9728988610178bf9a698f57a876516`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Monoid α} → [self : MulAction α β] → SemigroupAction α β
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : MulAction α β] => self.1
```

### D036: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

### D037: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Type:

```lean
{α : Type u} → [self : NonUnitalCommRing α] → NonUnitalNonAssocCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalNonAssocRing := self.toNonUnitalNonAssocRing, mul_comm := ⋯ }
```

### D038: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing α] → NonUnitalNonAssocRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocCommRing α] => self.1
```

### D039: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → AddCommMonoid α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocSemiring α] => self.1
```

### D040: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing α] → NonUnitalCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalRing := self.toNonUnitalRing, mul_comm := ⋯ }
```

### D041: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing α] → NonUnitalSeminormedRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSeminormedCommRing α] => self.1
```

### D042: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Type:

```lean
{α : Type u_2} → [NonUnitalSeminormedRing α] → SeminormedAddCommGroup α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : NonUnitalSeminormedRing α] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D043: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Type:

```lean
{α : Type u} → [self : NonUnitalSemiring α] → NonUnitalNonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSemiring α] => self.1
```

### D044: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `dc08b02d757cccbd21bce550b40d3f76d2ee704ec2cd7f5507023d827296474f`

Type:

```lean
{α : Type u_5} → [self : NontriviallyNormedField α] → NormedField α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NontriviallyNormedField α] => self.1
```

### D045: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → NonUnitalNormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toMetricSpace := β.toMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D046: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → SeminormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toRing := β.toRing, toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯,
    norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D047: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ec9eab2d54099c52c160e626a54324e8c9a07675797f0926435031098f363e5f`

Type:

```lean
{α : Type u_5} → [self : NormedField α] → Field α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedField α] => self.2
```

### D048: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4aa3dba57859ca72552799005279a2b5a65b8c083980070fbbff11fd1de56dec`

Type:

```lean
{α : Type u_2} → [NormedField α] → NormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : NormedField α] =>
  let __src := inst;
  { toNorm := __src.toNorm, toRing := __src.toRing, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯,
    norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D049: `NormedSpace.toModule`

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

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : NormedSpace 𝕜 E] => self.1
```

### D050: `Not`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `0bfdacbe07f6cbb8995b354e36299fd742f29398c188d7cc23dedcdc47f57a9a`

Type:

```lean
Prop → Prop
```

Definition body (one-level semantic boundary):

```lean
fun a => a → False
```

### D051: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Type:

```lean
{α : Type u} → (x : Nat) → [self : OfNat α x] → α
```

Definition body (one-level semantic boundary):

```lean
fun α x [self : OfNat α x] => self.1
```

### D052: `Pi.Function.module`

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

Definition body (one-level semantic boundary):

```lean
fun I α β [Semiring α] [AddCommMonoid β] [Module α β] => Pi.module I (fun a => β) α
```

### D053: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommGroup (f i)] → AddCommGroup ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommGroup (f i)] =>
  let __src := Pi.addGroup;
  have __src_1 := Pi.addCommMonoid;
  { toAddGroup := __src, add_comm := ⋯ }
```

### D054: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9b57724ac626ed82a5e3b9060068391fe112af839994c2304c9990493e8e9fbc`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommMonoid (f i)] → AddCommMonoid ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommMonoid (f i)] =>
  let __src := Pi.addMonoid;
  have __src_1 := Pi.addCommSemigroup;
  { toAddMonoid := __src, add_comm := ⋯ }
```

### D055: `Pi.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5deaec32b4deac749a5db5453affea1938386e569380df7daeec26aee3cfd7c2`

Type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [(i : ι) → Sub (G i)] → Sub ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [(i : ι) → Sub (G i)] => { sub := fun f g i => instHSub.hSub (f i) (g i) }
```

### D056: `Pi.normedAddCommGroup`

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

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [Fintype ι] [(i : ι) → NormedAddCommGroup (G i)] =>
  let __src := Pi.seminormedAddGroup;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, add_comm := ⋯,
    toPseudoMetricSpace := __src.toPseudoMetricSpace, eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D057: `Pi.normedSpace`

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

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NormedField 𝕜] {ι} {E} [Fintype ι] [(i : ι) → SeminormedAddCommGroup (E i)] [(i : ι) → NormedSpace 𝕜 (E i)] =>
  { toModule := Pi.module ι E 𝕜, norm_smul_le := ⋯ }
```

### D058: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a81381c20af462683322c70d792fc61454007e60d0781bb4fda6103a009c8abd`

Type:

```lean
{ι : Type u_5} → {Y : ι → Type v} → [t₂ : (i : ι) → TopologicalSpace (Y i)] → TopologicalSpace ((i : ι) → Y i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {Y} [t₂ : (i : ι) → TopologicalSpace (Y i)] => iInf fun i => TopologicalSpace.induced (fun f => f i) (t₂ i)
```

### D059: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D060: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f602276baee30d3dbe02bd6b756a9097f750d59a7f91ca7635dcfc935fd22981`

Type:

```lean
{𝕜 : Type u_1} → [inst : RCLike 𝕜] → InnerProductSpace Real 𝕜
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [RCLike 𝕜] =>
  let __spread.0 := Inner.rclikeToReal 𝕜 𝕜;
  { toNormedSpace := NormedAlgebra.toNormedSpace 𝕜, toInner := __spread.0, norm_sq_eq_re_inner := ⋯,
    conj_inner_symm := ⋯, add_left := ⋯, smul_left := ⋯ }
```

### D061: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D062: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Type:

```lean
DenselyNormedField Real
```

Definition body (one-level semantic boundary):

```lean
{ toNormedField := Real.normedField, lt_norm_lt := Real.denselyNormedField._proof_1 }
```

### D063: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Type:

```lean
Add Real
```

Definition body (one-level semantic boundary):

```lean
{ add := Real.add✝ }
```

### D064: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Type:

```lean
AddCommGroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D065: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `11a549e6c9caa007a4627570dd86aea756ada755f141da0356b8766788f2eef7`

Type:

```lean
AddCommMonoid Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D066: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `092dfdf642984bd4a336b502f7ac3f87adafd02a6236ba9033e90c0e1439ca7d`

Type:

```lean
CommSemiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D067: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Type:

```lean
LT Real
```

Definition body (one-level semantic boundary):

```lean
{ lt := Real.lt✝ }
```

### D068: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d2fdb97b9d861fcf61e6dbea9993dfa0ca6aa16609742f215c35b3f7ddd16b8e`

Type:

```lean
RCLike Real
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

### D069: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Type:

```lean
Ring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D070: `Real.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `926d9e8fcca2819a885d446e168b20c7c8aac2e542d59ed2b48e32c9a4659a36`

Type:

```lean
Sub Real
```

Definition body (one-level semantic boundary):

```lean
{ sub := fun a b => instHAdd.hAdd a (Real.instNeg.neg b) }
```

### D071: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Type:

```lean
Zero Real
```

Definition body (one-level semantic boundary):

```lean
{ zero := Real.zero✝ }
```

### D072: `Real.measureSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Haar.OfBasis`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d9de6598dfa4dc9b2cc1dfbccf206b37d159db61f4b35cc745a68902fbc74b22`

Type:

```lean
MeasureTheory.MeasureSpace Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D073: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Type:

```lean
NormedAddCommGroup Real
```

Definition body (one-level semantic boundary):

```lean
{ toNorm := Real.norm, toAddCommGroup := Real.instAddCommGroup, toMetricSpace := Real.metricSpace, dist_eq := ⋯ }
```

### D074: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Type:

```lean
NormedCommRing Real
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

### D075: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Type:

```lean
NormedField Real
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

### D076: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Type:

```lean
PseudoMetricSpace Real
```

Definition body (one-level semantic boundary):

```lean
{ dist := fun x y => abs (instHSub.hSub x y), dist_self := Real.pseudoMetricSpace._proof_1, dist_comm := ⋯,
  dist_triangle := ⋯, edist_dist := Real.pseudoMetricSpace._proof_2, uniformity_dist := Real.pseudoMetricSpace._proof_3,
  cobounded_sets := Real.pseudoMetricSpace._proof_4 }
```

### D077: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Type:

```lean
Semiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D078: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Type:

```lean
{R : Type u} → [self : Ring R] → Semiring R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Ring R] => self.1
```

### D079: `RingHom.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Hom.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a6f90353b229eb95293a3c089ae20ade7711021afe852d8f78a4f79577dab479`

Type:

```lean
(α : Type u_5) → [inst : NonAssocSemiring α] → RingHom α α
```

Definition body (one-level semantic boundary):

```lean
fun α [NonAssocSemiring α] => { toFun := id, map_one' := ⋯, map_mul' := ⋯, map_zero' := ⋯, map_add' := ⋯ }
```

### D080: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a1b771abeff9bbbdcce988134973a1a367c44a340bcd29acb0cc44b8d6a2e55c`

Type:

```lean
{K : Type u_2} → [self : Semifield K] → DivisionSemiring K
```

Definition body (one-level semantic boundary):

```lean
fun K self =>
  { toSemiring := self.toSemiring, toInv := self.toInv, toDiv := self.toDiv, div_eq_mul_inv := ⋯, zpow := self.zpow,
    zpow_zero' := ⋯, zpow_succ' := ⋯, zpow_neg' := ⋯, toNontrivial := ⋯, inv_zero := ⋯, mul_inv_cancel := ⋯,
    toNNRatCast := self.toNNRatCast, nnratCast_def := ⋯, nnqsmul := self.nnqsmul, nnqsmul_def := ⋯ }
```

### D081: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5a8783c66a2e56a4cc509bbb0651eda5b66e25c197307a42445cac31c4a4bb6c`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Semigroup α} → [self : SemigroupAction α β] → SMul α β
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : SemigroupAction α β] => self.1
```

### D082: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Type:

```lean
{α : Type u_2} → [β : SeminormedCommRing α] → NonUnitalSeminormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : SeminormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D083: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e3cbc92d1d5e37d9eaeb1d595c83a78f7af7e3a8d249a700fa3676ab4e0c3d60`

Type:

```lean
{α : Type u_5} → [self : SeminormedCommRing α] → SeminormedRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : SeminormedCommRing α] => self.1
```

### D084: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e6ea9296e8643d5ae7cf334c065c9d6ebe4a95de22d3b0708a585db80e17322a`

Type:

```lean
{α : Type u_5} → [self : SeminormedRing α] → PseudoMetricSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : SeminormedRing α] => self.3
```

### D085: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Type:

```lean
{α : Type u} → [self : Semiring α] → MonoidWithZero α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toMul := self.toMul, mul_assoc := ⋯, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯, npow := self.npow,
    npow_zero := ⋯, npow_succ := ⋯, toZero := self.toZero, zero_mul := ⋯, mul_zero := ⋯ }
```

### D086: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `33076e5ce1b65d0dacdacdea942f424abbe54f3ff639c158f37c0f533984f227`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toNonUnitalNonAssocSemiring := self.toNonUnitalNonAssocSemiring, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯,
    toNatCast := self.toNatCast, natCast_zero := ⋯, natCast_succ := ⋯ }
```

### D087: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonUnitalSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Semiring α] => self.1
```

### D088: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
```

### D089: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Type:

```lean
{α : Type u_1} → [Zero α] → OfNat α 0
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Zero α] => { ofNat := inst.zero }
```

### D090: `instContinuousSMulForall`

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

### D091: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `aa782f2b5af3d068f4c5340de4b32b193fece2c659a45582cc3024a19b550c87`

Type:

```lean
{α : Type u_1} → [Sub α] → HSub α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Sub α] => { hSub := fun a b => inst.sub a b }
```

### D092: `instIsTopologicalRingReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Real`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `74697a527ce10426ad50966a34f3375374c3cde51367629721e2aa0850e2f618`

Type:

```lean
IsTopologicalRing Real
```

### D093: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7018dea92aae8c272f3a065f25e2bedb9732a0b602c3d54b166fa0cf2ce1ea92`

Type:

```lean
(n : Nat) → OfNat Nat n
```

Definition body (one-level semantic boundary):

```lean
fun n => { ofNat := n }
```

### D094: `intervalIntegral`

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

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] f a b μ =>
  instHSub.hSub (MeasureTheory.integral (μ.restrict (Set.Ioc a b)) fun x => f x)
    (MeasureTheory.integral (μ.restrict (Set.Ioc b a)) fun x => f x)
```

### D095: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8c0fca6ee264d934b25c679f16be6b83bb2a2f7c58a8ac0afab0c146219e16a1`

Type:

```lean
{A : Type u} → [self : AddGroup A] → SubNegMonoid A
```

Definition body (one-level semantic boundary):

```lean
fun A [self : AddGroup A] => self.1
```

### D096: `ContinuousLinearMap.funLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `def`
- Distance from target type: `2`
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

Definition body (one-level semantic boundary):

```lean
fun {R₁} {R₂} [Semiring R₁] [Semiring R₂] {σ₁₂} {M₁} [TopologicalSpace M₁] [AddCommMonoid M₁] {M₂} [TopologicalSpace M₂]
    [AddCommMonoid M₂] [Module R₁ M₁] [Module R₂ M₂] =>
  { coe := fun f => LinearMap.instFunLike.coe f.toLinearMap, coe_injective' := ⋯ }
```

### D097: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `9db5c150b3c86d10b50e19602d0c0af9e5012dfe5f13b0d7b57925729f2478f0`

Type:

```lean
{F : Sort u_1} → {α : outParam (Sort u_2)} → {β : outParam (α → Sort u_3)} → [self : DFunLike F α β] → F → (a : α) → β a
```

Definition body (one-level semantic boundary):

```lean
fun F {α} {β} [self : DFunLike F α β] => self.1
```

### D098: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D099: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Type:

```lean
Type u_4 → Type u_4
```

### D100: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D101: `IntervalIntegrable`

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

Definition body (one-level semantic boundary):

```lean
fun {ε} [TopologicalSpace ε] [ENormedAddMonoid ε] f μ a b =>
  And (MeasureTheory.IntegrableOn f (Set.Ioc a b) μ) (MeasureTheory.IntegrableOn f (Set.Ioc b a) μ)
```

### D102: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

### D103: `NormedAddCommGroup.toNormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `cdc7999c66248f7b0f68477de30ff4d9ea7a7f0df0bc6f092bc024f699d646fe`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → NormedAddGroup E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯ }
```

### D104: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → SeminormedAddCommGroup E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D105: `NormedAddGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `06ba17aab699c28aaa8877d0b107536ebd2aefd8bf59143b2357c84bb820d89e`

Type:

```lean
{E : Type u_8} → [self : NormedAddGroup E] → AddGroup E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : NormedAddGroup E] => self.2
```

### D106: `NormedAddGroup.toENormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c2e4373a88aee873807ebe0c84a9ad97e86c59f70ff5cf5af4d6497b3024e91a`

Type:

```lean
{F : Type u_7} → [inst : NormedAddGroup F] → ENormedAddMonoid F
```

Definition body (one-level semantic boundary):

```lean
fun {F} [inst : NormedAddGroup F] =>
  { toContinuousENorm := SeminormedAddGroup.toContinuousENorm, toAddMonoid := inst.toAddMonoid, enorm_zero := ⋯,
    enorm_add_le := ⋯, enorm_eq_zero := ⋯ }
```

### D107: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Type:

```lean
{𝕜 : Type u_1} → [inst : NormedField 𝕜] → NormedSpace 𝕜 𝕜
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NormedField 𝕜] => { toModule := Semiring.toModule, norm_smul_le := ⋯ }
```

### D108: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

### D109: `Pi.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `786aa93e85ac0acc746f4c8ee6aed957d52e0231f66623c2b8e478a794d15ce0`

Type:

```lean
{ι : Type u_1} → {M : ι → Type u_5} → [(i : ι) → Add (M i)] → Add ((i : ι) → M i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [(i : ι) → Add (M i)] => { add := fun f g i => instHAdd.hAdd (f i) (g i) }
```

### D110: `Pi.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb5c70d9b813d7099537e8db11f59a65a3f5ad951da7314a1aa554471a122049`

Type:

```lean
{ι : Type u_1} → {M : ι → Type u_5} → [(i : ι) → Zero (M i)] → Zero ((i : ι) → M i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [(i : ι) → Zero (M i)] => { zero := fun x => 0 }
```

### D111: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `3f8499f7dfc2e8115a48b4ac0bec5328dd7223a18dd71fc0061e711fbd543126`

Type:

```lean
{E : Type u_8} → [self : SeminormedAddCommGroup E] → PseudoMetricSpace E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : SeminormedAddCommGroup E] => self.3
```

### D112: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f60885ee7a5e97dbc3d343ecb54849b15ae9ca7cc989f350d3b7fee2d2d0724b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → Sub G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.3
```

### D113: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D114: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Type:

```lean
(M : Type u_1) → (X : Type u_2) → [SMul M X] → [TopologicalSpace M] → [TopologicalSpace X] → Prop
```

### D115: `Pi.instSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `adba1d4e42926a50c2701c18af6f5749dd72a4d631113b924c96482924951276`

Type:

```lean
{ι : Type u_1} → {α : Type u_2} → {M : ι → Type u_5} → [(i : ι) → SMul α (M i)] → SMul α ((i : ι) → M i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {α} {M} [(i : ι) → SMul α (M i)] => { smul := fun a f i => instHSMul.hSMul a (f i) }
```
