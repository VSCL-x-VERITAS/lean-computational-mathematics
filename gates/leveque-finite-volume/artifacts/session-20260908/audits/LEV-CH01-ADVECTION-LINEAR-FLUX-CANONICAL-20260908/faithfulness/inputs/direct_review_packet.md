# Declaration dossier for LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_advectionLinearFlux_fromMassConservation
    (q : ℝ → ℝ → ℝ) (speed t : ℝ)
    (qt qx fluxx : ℝ → (Fin 1 → ℝ))
    (hintegralMass : IsIntegralConservationLawSolution
      (scalarAsOneComponentSystem q)
      (constantLinearFlux (constantCoefficientScalarMatrix speed)))
    (hqt : ∀ x,
      HasDerivAt (fun τ => scalarAsOneComponentSystem q x τ) (qt x) t)
    (hqx : ∀ x,
      HasDerivAt (fun ξ => scalarAsOneComponentSystem q ξ t) (qx x) x)
    (hfluxx : ∀ x,
      HasDerivAt
        (fun ξ => constantLinearFlux
          (constantCoefficientScalarMatrix speed)
          (scalarAsOneComponentSystem q ξ t))
        (fluxx x) x)
    (hqtIntegrable : ∀ a b, IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : ∀ a b, IntervalIntegrable fluxx volume a b)
    (hinterchange : ∀ a b,
      HasDerivAt
        (fun τ => ∫ x in a..b, scalarAsOneComponentSystem q x τ)
        (∫ x in a..b, qt x) t)
    (hresidualContinuous : Continuous fun x => qt x + fluxx x) :
    (∀ state : Fin 1 → ℝ,
      constantLinearFlux (constantCoefficientScalarMatrix speed) state =
        fun _ => speed * state 0) ∧
      ∀ x, leveque01_equation02_scalarAdvectionAt q speed x t
```

## Elaborated target type

```lean
∀ (q : Real → Real → Real) (speed t : Real) (qt qx fluxx : Real → Fin 1 → Real),
  NumStability.IsIntegralConservationLawSolution (NumStability.scalarAsOneComponentSystem q)
      (NumStability.constantLinearFlux (NumStability.constantCoefficientScalarMatrix speed)) →
    (∀ (x : Real), HasDerivAt (fun τ => NumStability.scalarAsOneComponentSystem q x τ) (qt x) t) →
      (∀ (x : Real), HasDerivAt (fun ξ => NumStability.scalarAsOneComponentSystem q ξ t) (qx x) x) →
        (∀ (x : Real),
            HasDerivAt
              (fun ξ =>
                NumStability.constantLinearFlux (NumStability.constantCoefficientScalarMatrix speed)
                  (NumStability.scalarAsOneComponentSystem q ξ t))
              (fluxx x) x) →
          (∀ (a b : Real), IntervalIntegrable qt Real.measureSpace.volume a b) →
            (∀ (a b : Real), IntervalIntegrable fluxx Real.measureSpace.volume a b) →
              (∀ (a b : Real),
                  HasDerivAt
                    (fun τ =>
                      intervalIntegral (fun x => NumStability.scalarAsOneComponentSystem q x τ) a b
                        Real.measureSpace.volume)
                    (intervalIntegral (fun x => qt x) a b Real.measureSpace.volume) t) →
                (Continuous fun x => instHAdd.hAdd (qt x) (fluxx x)) →
                  And
                    (∀ (state : Fin 1 → Real),
                      Eq (NumStability.constantLinearFlux (NumStability.constantCoefficientScalarMatrix speed) state)
                        fun x => instHMul.hMul speed (state 0))
                    (∀ (x : Real), NumStability.leveque01_equation02_scalarAdvectionAt q speed x t)
```

## Fully explicit elaborated target type

```lean
∀ (q : Real → Real → Real) (speed t : Real)
  (qt qx fluxx : Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
  (hintegralMass :
    @NumStability.IsIntegralConservationLawSolution.{0}
      (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
      (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
      (NumStability.scalarAsOneComponentSystem q)
      (@NumStability.constantLinearFlux.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
        (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
        (NumStability.constantCoefficientScalarMatrix speed)))
  (hqt :
    ∀ (x : Real),
      @HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)
        (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@Pi.addCommGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.instAddCommGroup)
        (@Pi.Function.module.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) Real Real
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
        (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        (@instContinuousSMulForall.{0, 0, 0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real
              (@SeminormedRing.toPseudoMetricSpace.{0} Real
                (@SeminormedCommRing.toSeminormedRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                    (@NormedField.toNormedCommRing.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @SemigroupAction.toSMul.{0, 0} Real
              ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
              (@Monoid.toSemigroup.{0} Real
                (@MonoidWithZero.toMonoid.{0} Real
                  (@Semiring.toMonoidWithZero.{0} Real
                    (@DivisionSemiring.toSemiring.{0} Real
                      (@Semifield.toDivisionSemiring.{0} Real
                        (@Field.toSemifield.{0} Real
                          (@NormedField.toField.{0} Real
                            (@NontriviallyNormedField.toNormedField.{0} Real
                              (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)))))))))
              (@MulAction.toSemigroupAction.{0, 0} Real
                ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                (@MonoidWithZero.toMonoid.{0} Real
                  (@Semiring.toMonoidWithZero.{0} Real
                    (@DivisionSemiring.toSemiring.{0} Real
                      (@Semifield.toDivisionSemiring.{0} Real
                        (@Field.toSemifield.{0} Real
                          (@NormedField.toField.{0} Real
                            (@NontriviallyNormedField.toNormedField.{0} Real
                              (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
                ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                    @DistribMulAction.toMulAction.{0, 0} Real
                      ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                      (@MonoidWithZero.toMonoid.{0} Real
                        (@Semiring.toMonoidWithZero.{0} Real
                          (@DivisionSemiring.toSemiring.{0} Real
                            (@Semifield.toDivisionSemiring.{0} Real
                              (@Field.toSemifield.{0} Real
                                (@NormedField.toField.{0} Real
                                  (@NontriviallyNormedField.toNormedField.{0} Real
                                    (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                      Real.denselyNormedField))))))))
                      ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                          @AddCommMonoid.toAddMonoid.{0}
                            ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                                @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                              i))
                        i)
                      ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                          @Module.toDistribMulAction.{0, 0} Real
                            ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                            (@DivisionSemiring.toSemiring.{0} Real
                              (@Semifield.toDivisionSemiring.{0} Real
                                (@Field.toSemifield.{0} Real
                                  (@NormedField.toField.{0} Real
                                    (@NontriviallyNormedField.toNormedField.{0} Real
                                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                        Real.denselyNormedField))))))
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                                @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                              i)
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
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
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
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
        (fun (τ : Real) => NumStability.scalarAsOneComponentSystem q x τ) (qt x) t)
  (hqx :
    ∀ (x : Real),
      @HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)
        (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@Pi.addCommGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.instAddCommGroup)
        (@Pi.Function.module.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) Real Real
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
        (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        (@instContinuousSMulForall.{0, 0, 0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real
              (@SeminormedRing.toPseudoMetricSpace.{0} Real
                (@SeminormedCommRing.toSeminormedRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                    (@NormedField.toNormedCommRing.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @SemigroupAction.toSMul.{0, 0} Real
              ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
              (@Monoid.toSemigroup.{0} Real
                (@MonoidWithZero.toMonoid.{0} Real
                  (@Semiring.toMonoidWithZero.{0} Real
                    (@DivisionSemiring.toSemiring.{0} Real
                      (@Semifield.toDivisionSemiring.{0} Real
                        (@Field.toSemifield.{0} Real
                          (@NormedField.toField.{0} Real
                            (@NontriviallyNormedField.toNormedField.{0} Real
                              (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)))))))))
              (@MulAction.toSemigroupAction.{0, 0} Real
                ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                (@MonoidWithZero.toMonoid.{0} Real
                  (@Semiring.toMonoidWithZero.{0} Real
                    (@DivisionSemiring.toSemiring.{0} Real
                      (@Semifield.toDivisionSemiring.{0} Real
                        (@Field.toSemifield.{0} Real
                          (@NormedField.toField.{0} Real
                            (@NontriviallyNormedField.toNormedField.{0} Real
                              (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
                ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                    @DistribMulAction.toMulAction.{0, 0} Real
                      ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                      (@MonoidWithZero.toMonoid.{0} Real
                        (@Semiring.toMonoidWithZero.{0} Real
                          (@DivisionSemiring.toSemiring.{0} Real
                            (@Semifield.toDivisionSemiring.{0} Real
                              (@Field.toSemifield.{0} Real
                                (@NormedField.toField.{0} Real
                                  (@NontriviallyNormedField.toNormedField.{0} Real
                                    (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                      Real.denselyNormedField))))))))
                      ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                          @AddCommMonoid.toAddMonoid.{0}
                            ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                                @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                              i))
                        i)
                      ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                          @Module.toDistribMulAction.{0, 0} Real
                            ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                            (@DivisionSemiring.toSemiring.{0} Real
                              (@Semifield.toDivisionSemiring.{0} Real
                                (@Field.toSemifield.{0} Real
                                  (@NormedField.toField.{0} Real
                                    (@NontriviallyNormedField.toNormedField.{0} Real
                                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                        Real.denselyNormedField))))))
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                                @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                              i)
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
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
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
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
        (fun (ξ : Real) => NumStability.scalarAsOneComponentSystem q ξ t) (qx x) x)
  (hfluxx :
    ∀ (x : Real),
      @HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)
        (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@Pi.addCommGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.instAddCommGroup)
        (@Pi.Function.module.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) Real Real
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
        (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        (@instContinuousSMulForall.{0, 0, 0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real
              (@SeminormedRing.toPseudoMetricSpace.{0} Real
                (@SeminormedCommRing.toSeminormedRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                    (@NormedField.toNormedCommRing.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @SemigroupAction.toSMul.{0, 0} Real
              ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
              (@Monoid.toSemigroup.{0} Real
                (@MonoidWithZero.toMonoid.{0} Real
                  (@Semiring.toMonoidWithZero.{0} Real
                    (@DivisionSemiring.toSemiring.{0} Real
                      (@Semifield.toDivisionSemiring.{0} Real
                        (@Field.toSemifield.{0} Real
                          (@NormedField.toField.{0} Real
                            (@NontriviallyNormedField.toNormedField.{0} Real
                              (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)))))))))
              (@MulAction.toSemigroupAction.{0, 0} Real
                ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                (@MonoidWithZero.toMonoid.{0} Real
                  (@Semiring.toMonoidWithZero.{0} Real
                    (@DivisionSemiring.toSemiring.{0} Real
                      (@Semifield.toDivisionSemiring.{0} Real
                        (@Field.toSemifield.{0} Real
                          (@NormedField.toField.{0} Real
                            (@NontriviallyNormedField.toNormedField.{0} Real
                              (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
                ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                    @DistribMulAction.toMulAction.{0, 0} Real
                      ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                      (@MonoidWithZero.toMonoid.{0} Real
                        (@Semiring.toMonoidWithZero.{0} Real
                          (@DivisionSemiring.toSemiring.{0} Real
                            (@Semifield.toDivisionSemiring.{0} Real
                              (@Field.toSemifield.{0} Real
                                (@NormedField.toField.{0} Real
                                  (@NontriviallyNormedField.toNormedField.{0} Real
                                    (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                      Real.denselyNormedField))))))))
                      ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                          @AddCommMonoid.toAddMonoid.{0}
                            ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                                @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                              i))
                        i)
                      ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                          @Module.toDistribMulAction.{0, 0} Real
                            ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                            (@DivisionSemiring.toSemiring.{0} Real
                              (@Semifield.toDivisionSemiring.{0} Real
                                (@Field.toSemifield.{0} Real
                                  (@NormedField.toField.{0} Real
                                    (@NontriviallyNormedField.toNormedField.{0} Real
                                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                        Real.denselyNormedField))))))
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                                @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                              i)
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
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
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
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
        (fun (ξ : Real) =>
          @NumStability.constantLinearFlux.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
            (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
            (NumStability.constantCoefficientScalarMatrix speed) (NumStability.scalarAsOneComponentSystem q ξ t))
        (fluxx x) x)
  (hqtIntegrable :
    ∀ (a b : Real),
      @IntervalIntegrable.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        (@NormedAddGroup.toENormedAddMonoid.{0}
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
          (@Pi.normedAddGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
            (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
            (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
            fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
        qt (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) a b)
  (hfluxxIntegrable :
    ∀ (a b : Real),
      @IntervalIntegrable.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        (@NormedAddGroup.toENormedAddMonoid.{0}
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
          (@Pi.normedAddGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
            (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
            (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
            fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
        fluxx (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) a b)
  (hinterchange :
    ∀ (a b : Real),
      @HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)
        (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@Pi.addCommGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.instAddCommGroup)
        (@Pi.Function.module.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) Real Real
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
        (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        (@instContinuousSMulForall.{0, 0, 0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real
              (@SeminormedRing.toPseudoMetricSpace.{0} Real
                (@SeminormedCommRing.toSeminormedRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                    (@NormedField.toNormedCommRing.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @SemigroupAction.toSMul.{0, 0} Real
              ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
              (@Monoid.toSemigroup.{0} Real
                (@MonoidWithZero.toMonoid.{0} Real
                  (@Semiring.toMonoidWithZero.{0} Real
                    (@DivisionSemiring.toSemiring.{0} Real
                      (@Semifield.toDivisionSemiring.{0} Real
                        (@Field.toSemifield.{0} Real
                          (@NormedField.toField.{0} Real
                            (@NontriviallyNormedField.toNormedField.{0} Real
                              (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)))))))))
              (@MulAction.toSemigroupAction.{0, 0} Real
                ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                (@MonoidWithZero.toMonoid.{0} Real
                  (@Semiring.toMonoidWithZero.{0} Real
                    (@DivisionSemiring.toSemiring.{0} Real
                      (@Semifield.toDivisionSemiring.{0} Real
                        (@Field.toSemifield.{0} Real
                          (@NormedField.toField.{0} Real
                            (@NontriviallyNormedField.toNormedField.{0} Real
                              (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
                ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                    @DistribMulAction.toMulAction.{0, 0} Real
                      ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                      (@MonoidWithZero.toMonoid.{0} Real
                        (@Semiring.toMonoidWithZero.{0} Real
                          (@DivisionSemiring.toSemiring.{0} Real
                            (@Semifield.toDivisionSemiring.{0} Real
                              (@Field.toSemifield.{0} Real
                                (@NormedField.toField.{0} Real
                                  (@NontriviallyNormedField.toNormedField.{0} Real
                                    (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                      Real.denselyNormedField))))))))
                      ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                          @AddCommMonoid.toAddMonoid.{0}
                            ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                                @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                              i))
                        i)
                      ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                          @Module.toDistribMulAction.{0, 0} Real
                            ((fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real) i)
                            (@DivisionSemiring.toSemiring.{0} Real
                              (@Semifield.toDivisionSemiring.{0} Real
                                (@Field.toSemifield.{0} Real
                                  (@NormedField.toField.{0} Real
                                    (@NontriviallyNormedField.toNormedField.{0} Real
                                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real
                                        Real.denselyNormedField))))))
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
                                @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                                  (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                                    (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                              i)
                            ((fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
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
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
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
        (fun (τ : Real) =>
          @intervalIntegral.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
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
            (fun (x : Real) => NumStability.scalarAsOneComponentSystem q x τ) a b
            (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace))
        (@intervalIntegral.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
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
          (fun (x : Real) => qt x) a b (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace))
        t)
  (hresidualContinuous :
    @Continuous.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
        (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
        fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
        @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      fun (x : Real) =>
      @HAdd.hAdd.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@instHAdd.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
          (@Pi.instAdd.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
            (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
            fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.instAdd))
        (qt x) (fluxx x)),
  And
    (∀ (state : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real),
      @Eq.{1} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@NumStability.constantLinearFlux.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (NumStability.constantCoefficientScalarMatrix speed) state)
        fun (x : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
        @HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) speed
          (state
            (@OfNat.ofNat.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) (nat_lit 0)
              (@Fin.instOfNat (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))) (nat_lit 0)))))
    (∀ (x : Real), NumStability.leveque01_equation02_scalarAdvectionAt q speed x t)
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Source.LeVeque.Chapter01.Equation02`, `ComputationalMathematics.Source.LeVeque.Chapter01.LinearFluxSpecialization`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Equation02` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Equation08` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- `ComputationalMathematics.Source.LeVeque.Chapter01.LinearFluxSpecialization` imports: `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01`, `ComputationalMathematics.Source.LeVeque.Chapter01.Equation08`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsIntegralConservationLawSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `95016b6b494726bcc08ca5c4ecf0fa41440fe287d5f7637e2cd7c34c16b07491`

Type:

```lean
{ι : Type u_1} → [Fintype ι] → (Real → Real → ι → Real) → ((ι → Real) → ι → Real) → Prop
```

Fully explicit type:

```lean
{ι : Type u_1} → [Fintype.{u_1} ι] → (q : Real → Real → ι → Real) → (flux : (ι → Real) → ι → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] q flux =>
  ∀ (a b t : Real),
    And (IntervalIntegrable (fun x => q x t) Real.measureSpace.volume a b)
      (HasDerivAt (fun τ => intervalIntegral (fun x => q x τ) a b Real.measureSpace.volume)
        (instHSub.hSub (flux (q a t)) (flux (q b t))) t)
```

### D002: `NumStability.constantCoefficientScalarMatrix`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7acb10e326c38d4b4fe6611ff744c53c8f95f8051d02f1d7a2967f95c43f362e`

Type:

```lean
Real → Matrix (Fin 1) (Fin 1) Real
```

Fully explicit type:

```lean
(speed : Real) →
  Matrix.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
    (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) Real
```

Definition body (one-level semantic boundary):

```lean
fun speed x x_1 => speed
```

### D003: `NumStability.constantLinearFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `897e52e4522e610431c06c8b8ec55d86b855cda8e4aed7d55fe6fd1e70c2d9fa`

Type:

```lean
{ι : Type u_1} → [Fintype ι] → Matrix ι ι Real → (ι → Real) → ι → Real
```

Fully explicit type:

```lean
{ι : Type u_1} → [Fintype.{u_1} ι] → (coefficient : Matrix.{u_1, u_1, 0} ι ι Real) → (state : ι → Real) → ι → Real
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] coefficient state => coefficient.mulVec state
```

### D004: `NumStability.leveque01_equation02_scalarAdvectionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.LeVeque.Chapter01.Equation02`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4e3983532e0fa0daf8dc155b900857fd57e290643769823d189dda9c594769e3`

Type:

```lean
(Real → Real → Real) → Real → Real → Real → Prop
```

Fully explicit type:

```lean
(q : Real → Real → Real) → (speed x t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun q speed x t => NumStability.IsLinearAdvectionSolutionAt q speed x t
```

### D005: `NumStability.scalarAsOneComponentSystem`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `267ef63a30159d531280630f28f59a92fbb5c97d5bbae6226719acf6feacfd4e`

Type:

```lean
(Real → Real → Real) → Real → Real → Fin 1 → Real
```

Fully explicit type:

```lean
(q : Real → Real → Real) → Real → Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real
```

Definition body (one-level semantic boundary):

```lean
fun q x t x_1 => q x t
```

### D006: `NumStability.IsIntegralConservationLawSolution._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `aca9f3b25219000b9b2496ecf686bce9f7d1c6b8f813de7bee520fe0870cefbd`

Type:

```lean
∀ {ι : Type u_1}, ContinuousSMul Real (ι → Real)
```

Fully explicit type:

```lean
∀ {ι : Type u_1},
  @ContinuousSMul.{0, u_1} Real ((i : ι) → Real)
    (@Pi.instSMul.{u_1, 0, 0} ι Real (fun (a : ι) => Real) fun (i : ι) =>
      @SemigroupAction.toSMul.{0, 0} Real Real
        (@Monoid.toSemigroup.{0} Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real
              (@DivisionSemiring.toSemiring.{0} Real
                (@Semifield.toDivisionSemiring.{0} Real
                  (@Field.toSemifield.{0} Real
                    (@NormedField.toField.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)))))))))
        (@MulAction.toSemigroupAction.{0, 0} Real Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real
              (@DivisionSemiring.toSemiring.{0} Real
                (@Semifield.toDivisionSemiring.{0} Real
                  (@Field.toSemifield.{0} Real
                    (@NormedField.toField.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (@DistribMulAction.toMulAction.{0, 0} Real Real
            (@MonoidWithZero.toMonoid.{0} Real
              (@Semiring.toMonoidWithZero.{0} Real
                (@DivisionSemiring.toSemiring.{0} Real
                  (@Semifield.toDivisionSemiring.{0} Real
                    (@Field.toSemifield.{0} Real
                      (@NormedField.toField.{0} Real
                        (@NontriviallyNormedField.toNormedField.{0} Real
                          (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
            (@AddCommMonoid.toAddMonoid.{0} Real
              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                  (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing)))))
            (@Module.toDistribMulAction.{0, 0} Real Real
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))))
    (@UniformSpace.toTopologicalSpace.{0} Real
      (@PseudoMetricSpace.toUniformSpace.{0} Real
        (@SeminormedRing.toPseudoMetricSpace.{0} Real
          (@SeminormedCommRing.toSeminormedRing.{0} Real
            (@NormedCommRing.toSeminormedCommRing.{0} Real
              (@NormedField.toNormedCommRing.{0} Real
                (@NontriviallyNormedField.toNormedField.{0} Real
                  (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
    (@Pi.topologicalSpace.{0, u_1} ι (fun (a : ι) => Real) fun (i : ι) =>
      @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
```

### D007: `NumStability.IsLinearAdvectionSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `de66a86c2ecf305cf1671383f03d73969b60775294075abac7328c909216e754`

Hash-verified prior declaration review:

- Reuse SHA-256: `6ac97ffa3b30810242d0a50f1519409ad3686b150047f12ffd20b05fe526f18c`
- Reviewed interpretation: There exist actual time and space slice derivatives qt and qx satisfying qt+speed•qx=0.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D008: `NumStability.IsLinearAdvectionSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `627af0185f9dc545c0feb87577da62578e1f74ad79dcdc19dbbce58a2e697e79`

Hash-verified prior declaration review:

- Reuse SHA-256: `864627c748f3b3e8000a1d3c81b97f5344e352ddc3b6b8a397220bdb990f8655`
- Reviewed interpretation: For a real normed space, scalar multiplication is continuous in the displayed norm-induced topologies.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D009: `AddCommMonoid.toAddMonoid`

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

### D010: `Algebra.id`

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

### D011: `Algebra.toSMul`

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

### D012: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `97053d5625259d7021dbf1a3156ca221fd110582dcdbf28d86c4cdc037258b25`
- Reviewed interpretation: Logical conjunction of two propositions.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D013: `Continuous`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `41e87101d1e3ab731e44670f7054a7766128457a09c3102d86948d5fe60c8a01`

Type:

```lean
{X : Type u} → {Y : Type v} → [TopologicalSpace X] → [TopologicalSpace Y] → (X → Y) → Prop
```

Fully explicit type:

```lean
{X : Type u} → {Y : Type v} → [TopologicalSpace.{u} X] → [TopologicalSpace.{v} Y] → (f : X → Y) → Prop
```

### D014: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Hash-verified prior declaration review:

- Reuse SHA-256: `ee888d4bd275fec14581ae5cf62954f9bd233116f728e2e5064c2701fcdd1703`
- Reviewed interpretation: Retains the normed field and obtains nontrivial norm from norm density.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D015: `DistribMulAction.toMulAction`

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

### D016: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `587c80a71f9aa5749b5d6c35c97cdae1067fa669257c865951843b747c511934`

Hash-verified prior declaration review:

- Reuse SHA-256: `045cb3eb7f2580dcb87cdb31b1d8dab8bc1cb27b7f7e21e190079d118a140f63`
- Reviewed interpretation: Projects the underlying semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D017: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `dcf67355faeab7846b6e56e17bd3e478e8d6a8fb59a620746360e0dcc0f0e3dc`
- Reviewed interpretation: Equality of two terms of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D018: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9a6353c2087dc0f4123f4079d947842f8b7bc1fc0c77de170382c04e31608fd4`

Hash-verified prior declaration review:

- Reuse SHA-256: `a95c17a36f089e68a9602fbd5febdee2fb92dc64ab3a6e05f4e85b7af85675c5`
- Reviewed interpretation: Retains semiring, inverse, division, powers, and nontriviality from the field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D019: `Fin`

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

### D020: `Fin.fintype`

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

### D021: `Fin.instOfNat`

- Role: `external-frontier`
- Owner module: `Init.Data.Fin.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8f9c302902ae8c66b3f71728ffe02994a026b562f27b9df8d4f84793e455e26b`

Type:

```lean
{n : Nat} → [NeZero n] → {i : Nat} → OfNat (Fin n) i
```

Fully explicit type:

```lean
{n : Nat} → [@NeZero.{0} Nat (@Zero.ofOfNat0.{0} Nat (instOfNatNat (nat_lit 0))) n] → {i : Nat} → OfNat.{0} (Fin n) i
```

Definition body (one-level semantic boundary):

```lean
fun {n} [NeZero n] {i} => { ofNat := Fin.ofNat n i }
```

### D022: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `eefa5f16ebb547ce5b894187c0f0e13534a4e7556dd0c9fca226b514b63b359b`
- Reviewed interpretation: Projects the addition operation from its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D023: `HMul.hMul`

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

### D024: `HasDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.Deriv.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `425ec9578fd20d63923b9588cbb7761a6e92f281528630fe03d0dc3dc1bc60a2`

Hash-verified prior declaration review:

- Reuse SHA-256: `9a27d79405c9c0c46db1323a896fde4ae0b90fb82922dc1e3daa01acac09ae16`
- Reviewed interpretation: Derivative-at-point predicate defined through HasDerivAtFilter at the neighborhood of the point with fixed base point.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D025: `InnerProductSpace.toNormedSpace`

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

### D026: `IntervalIntegrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D027: `IsModuleTopology.toContinuousSMul`

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

### D028: `IsTopologicalRing.toIsTopologicalSemiring`

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

### D029: `IsTopologicalSemiring.toIsModuleTopology`

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

### D031: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Hash-verified prior declaration review:

- Reuse SHA-256: `fbd1681bf1061f41400f0c6f03191796ea3cdfba23cbd915614a3f6242ab6d1d`
- Reviewed interpretation: Projects the distributive scalar action of a module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D032: `Monoid.toSemigroup`

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

### D033: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Hash-verified prior declaration review:

- Reuse SHA-256: `a442f9c53375ff020a512041334c1ca05b288b0b5dc1b6f57b11a70dbda4ad01`
- Reviewed interpretation: Projects the multiplicative monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D034: `MulAction.toSemigroupAction`

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

### D035: `Nat`

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

### D036: `Nat.instNeZeroSucc`

- Role: `external-frontier`
- Owner module: `Init.Data.Nat.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `a0735a528184c05594c4c79312c1225bb4dcffcdf0df7eb1a50c5733047c85ad`

Type:

```lean
∀ {n : Nat}, NeZero (instHAdd.hAdd n 1)
```

Fully explicit type:

```lean
∀ {n : Nat},
  @NeZero.{0} Nat (@Zero.ofOfNat0.{0} Nat (instOfNatNat (nat_lit 0)))
    (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
      (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
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

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalCommRing.{u} α] → NonUnitalNonAssocCommRing.{u} α
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

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing.{u} α] → NonUnitalNonAssocRing.{u} α
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

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring.{u} α] → AddCommMonoid.{u} α
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

Fully explicit type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing.{u_5} α] → NonUnitalCommRing.{u_5} α
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

Hash-verified prior declaration review:

- Reuse SHA-256: `12f47fbd4e985cb53a9bfe38c32f9282e73c2fd4144aa51f1c8f18918b37006c`
- Reviewed interpretation: Projects the underlying nonunital seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D042: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `8deaa0020fd734778039be37289c4b214daa961fc5040deefa8d75591b733d47`
- Reviewed interpretation: Retains norm, additive group, and pseudometric from the ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalSemiring.{u} α] → NonUnitalNonAssocSemiring.{u} α
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

Hash-verified prior declaration review:

- Reuse SHA-256: `5d79d4c0d259b399c7e51890235756c0baa6fcc483a9088d2953b2c0d5f71726`
- Reviewed interpretation: Projects the underlying normed field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D045: `NormedAddCommGroup.toNormedAddGroup`

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

### D046: `NormedAddGroup.toENormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D047: `NormedCommRing.toNonUnitalNormedCommRing`

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

### D048: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `77cef33da737e40e6c141e9499e04206fca606d0445147651758a246dd89dd7c`
- Reviewed interpretation: Retains norm, ring, and pseudometric while forgetting separation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D049: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ec9eab2d54099c52c160e626a54324e8c9a07675797f0926435031098f363e5f`

Hash-verified prior declaration review:

- Reuse SHA-256: `9c21b042708c394cb5e0ca5a51f05eb835574978e5b6256ee1e733008ada65d2`
- Reviewed interpretation: Projects the underlying field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D050: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4aa3dba57859ca72552799005279a2b5a65b8c083980070fbbff11fd1de56dec`

Hash-verified prior declaration review:

- Reuse SHA-256: `3ac36f322bafd69896176075ca0f9f63180663278c99296088abdec958e17462`
- Reviewed interpretation: Retains norm, ring, and metric from a normed field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D051: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Hash-verified prior declaration review:

- Reuse SHA-256: `57851eb0b2e0d9dcd5035c4c6f73582bccbbe9bbcca03f55a96223a81eaeeadd`
- Reviewed interpretation: Projects the underlying module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D052: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `c0b918c706549b8a48c1a74b223c6c29674db0a8438dcbd23406755024d5b82d`
- Reviewed interpretation: Extracts the value of the specified numeral from its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D053: `Pi.Function.module`

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

### D054: `Pi.addCommGroup`

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

### D055: `Pi.instAdd`

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

### D057: `Pi.normedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D058: `Pi.normedSpace`

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

### D059: `Pi.topologicalSpace`

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

### D060: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Hash-verified prior declaration review:

- Reuse SHA-256: `ada878ba16e34644d34d4cff6ef7e26a99accd6f4993ec7309264a87092c59be`
- Reviewed interpretation: Projects the uniform-space field of the pseudometric structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D061: `RCLike.toInnerProductSpaceReal`

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

### D062: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `85d13e5bdc37f16871b05ca19d7a319f9a702006d350d945385ec72aa7f544cc`
- Reviewed interpretation: The library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D063: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Hash-verified prior declaration review:

- Reuse SHA-256: `5c846ef915abc52fb83c061a645e493b852af5344ad7bd082ac96f812ce813e0`
- Reviewed interpretation: The real normed field equipped with density of norm values.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D064: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Hash-verified prior declaration review:

- Reuse SHA-256: `6c1b3fd230a1404c788da86a4fc204178d39046f96fb9499fc2167ba1d789960`
- Reviewed interpretation: Selects real addition.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D065: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Hash-verified prior declaration review:

- Reuse SHA-256: `8c60bf8b10a1d9a133adf1551b1c602b50ae571cfb1e5cae678128cf9d92e08d`
- Reviewed interpretation: The inferred library additive commutative group on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
CommSemiring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D067: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Hash-verified prior declaration review:

- Reuse SHA-256: `d437329eff8eca44d57d128963bebf691e7ad14cfd12a1f6efe721162e6e8cd6`
- Reviewed interpretation: Selects real multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
Ring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D070: `Real.measureSpace`

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

### D071: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Hash-verified prior declaration review:

- Reuse SHA-256: `d2166bcd29dc42dd534c6b901f6b793fe904ff16f3316ea1d009832bbf238e71`
- Reviewed interpretation: Combines real addition, the real norm, and the real metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D072: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Hash-verified prior declaration review:

- Reuse SHA-256: `67fc73c5dd3bcc448e7131ecf3c865fda17fe2262b3d09453a7bbc7be58e4ef5`
- Reviewed interpretation: Combines the real commutative ring with the standard real norm and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D073: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Hash-verified prior declaration review:

- Reuse SHA-256: `e832574b994bc6cc5029605a5a968983b298f0e852405ed16f87030d3293de24`
- Reviewed interpretation: Combines the real field with the real norm and metric, retaining their operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D074: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `fc034a64d5707c4ec0d41008eb62b11d0fff30ac39f0eacaa7ca0315e8a139a6`
- Reviewed interpretation: Real distance is abs(x-y), with the corresponding metric uniformity.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D075: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Hash-verified prior declaration review:

- Reuse SHA-256: `cd35d9677b3c0e9e4a7432d9a01d749fe5f599863da877794c7040a923cb8521`
- Reviewed interpretation: The inferred library semiring structure on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D076: `Ring.toSemiring`

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

### D077: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a1b771abeff9bbbdcce988134973a1a367c44a340bcd29acb0cc44b8d6a2e55c`

Hash-verified prior declaration review:

- Reuse SHA-256: `87cbc4d6e5f2eb679f4a0cb857638b12e4c6231dd7fbd07d932c742412eeb13e`
- Reviewed interpretation: Retains semiring, inverse, division, powers, and their laws.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D078: `SemigroupAction.toSMul`

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

### D079: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `65a6f9d011d491bc8ca9a3e385969cfb1c0ec7e5a7d662dc02349bc307d8cba2`
- Reviewed interpretation: Retains norm, additive and multiplicative operations, and pseudometric while forgetting the unit requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D080: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e3cbc92d1d5e37d9eaeb1d595c83a78f7af7e3a8d249a700fa3676ab4e0c3d60`

Hash-verified prior declaration review:

- Reuse SHA-256: `b14022dd11afe7c0fe87179c76d2d4e4dd401f9e8f7ef83023a67f29c7431dfc`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D081: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e6ea9296e8643d5ae7cf334c065c9d6ebe4a95de22d3b0708a585db80e17322a`

Hash-verified prior declaration review:

- Reuse SHA-256: `793b33af7881049622628098d6bc154ee69ae033ae769db96e8695a3ac5824a9`
- Reviewed interpretation: Projects the pseudometric field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D082: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Hash-verified prior declaration review:

- Reuse SHA-256: `ea4fc72f7b9838f03cb04b60674ccad354ce160cd07fc473f8308c2498fdb6fa`
- Reviewed interpretation: Retains multiplication, one, powers, and zero from the semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D083: `Semiring.toNonUnitalSemiring`

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

### D084: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Hash-verified prior declaration review:

- Reuse SHA-256: `172eb01294b89577f83905b38214d2eab43fea6171950ba08a433bc6e6a08c01`
- Reviewed interpretation: Projects the underlying topology.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D085: `instContinuousSMulForall`

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

### D086: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `d7ec2194f28c46dc56562b0eb93904d32ed3e718db99ef931f479cec9dd72113`
- Reviewed interpretation: Lifts same-type addition to HAdd using the original addition operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D087: `instHMul`

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

### D088: `instIsTopologicalRingReal`

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

### D089: `instOfNatNat`

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

### D090: `intervalIntegral`

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

### D091: `Fintype`

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

### D092: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D093: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D094: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D095: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D096: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Hash-verified prior declaration review:

- Reuse SHA-256: `954b3df59bbac6942478649b74bd43434a9aebb20be437fccac6db571bcf5b38`
- Reviewed interpretation: Makes a normed field a normed space over itself using its multiplication-based module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D097: `Pi.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D098: `Real.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D099: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D100: `AddCommGroup.toDivisionAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `72951116f9ecb1048b235282fec669b8c3dfd809e3810c987dc6f18968d013d3`

Hash-verified prior declaration review:

- Reuse SHA-256: `3fafdbb74c795c91c09122d0ba8e472b84253cf090601b0e31e4174f3bf57dc3`
- Reviewed interpretation: Builds a commutative subtraction structure from the same additive-group operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D101: `AddCommMagma.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `78a12fabc3611bc39705a2dcf3fa82ed1f226d804e888d57546b885fefae4453`

Hash-verified prior declaration review:

- Reuse SHA-256: `cc3a0331eef8c52072c11d3f61a70982a66f7b0dbcd316f0c7566803109372c5`
- Reviewed interpretation: Projects the underlying addition structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D102: `AddCommMonoid.toAddCommSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `dc7cae9f3611bf7a48fc6ba815db5cffeba3ac95ae33d26bec77b827bd041f26`

Hash-verified prior declaration review:

- Reuse SHA-256: `9196dddb3d4f02167d39296235f68fa5b4d57de18af88b88d37243d2c76648be`
- Reviewed interpretation: Retains the underlying additive semigroup and commutativity.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D103: `AddCommSemigroup.toAddCommMagma`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `78f90c6bc01ad86e28d84a9011670656947204c6d8963785407a1b8eb54844ab`

Hash-verified prior declaration review:

- Reuse SHA-256: `f5785a3fba63f324f826bb9a6649120d800eb30c9d12863420ff7534fdf73c67`
- Reviewed interpretation: Retains the underlying addition and its commutativity.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D104: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4b5cfcaa0e3b1157089b486d5bfd51b9d15b881ea9cad302a6c8f701cae9ef1a`

Hash-verified prior declaration review:

- Reuse SHA-256: `e933cf26093da8fb959d92aa37cd53bbeb469c8ba8fd00006ad1b939a6cc632e`
- Reviewed interpretation: Retains the additive monoid's zero and addition.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D105: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `aa06299f9d38f11e9dad40701d7541d8eba2a4ac673c643f4c5f5ce1369490cc`

Hash-verified prior declaration review:

- Reuse SHA-256: `5cfecd299d21525d22a864d6c8566ef9d19e6d96b823420fcbbbebcaf89f8a1d`
- Reviewed interpretation: Projects the zero operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D106: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8f64c653a96443ff67b52a5edb3fc264d279905b936c7303e9dd2469af000213`

Hash-verified prior declaration review:

- Reuse SHA-256: `f86932278292ff77ca85d775b6dbc83f80ae9bdd25ad48a5777fb3cbb5c45685`
- Reviewed interpretation: Projects the underlying addition-with-zero structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D107: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Hash-verified prior declaration review:

- Reuse SHA-256: `fdb0131f30973d8ae3bced40daf0923a40f75729caeaa85ed73478ebb939821b`
- Reviewed interpretation: The library proposition asserting continuity of the specified scalar action in the specified topologies.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D108: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `17a3c7e66a4c2897891d468da70a58e73aa0b8e044ea0cc90d8d6e9e51c08f02`

Hash-verified prior declaration review:

- Reuse SHA-256: `c269d7f5ddc47cbe52f6a18d3883833a4d38d8401e75c69b977a445fc3e22973`
- Reviewed interpretation: Retains scalar multiplication and its zero and addition compatibility.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D109: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `f640928ea31b161891006aaf9950d636ac5e1fbda413a7712f36546c938b3fdf`

Hash-verified prior declaration review:

- Reuse SHA-256: `f873afc6df428576a410de6408a7b2588e73f1812c84cac0c868c7315e1c37ce`
- Reviewed interpretation: Projects the zero-preserving scalar action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D110: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `7d58c19063063d627291b91068fa4bf2bf5ff88679897376ac465b9f52e93642`

Hash-verified prior declaration review:

- Reuse SHA-256: `cc9a564d8a12eca7e09a3370ad1db5bb634d53967a31a7b38e57b72faa76ded6`
- Reviewed interpretation: Projects the underlying extended-seminormed additive structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D111: `ESeminormedAddCommMonoid.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `38db724db757c42f8e8affdaa0b60310db98b78e8ba320c452775788f7191220`

Hash-verified prior declaration review:

- Reuse SHA-256: `e436be89a15e6c57a693bc90e20cd2857d66111e645b899d48b50521ae3efef3`
- Reviewed interpretation: Retains the additive monoid and commutativity from the extended-seminormed structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D112: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ad2e3c6c509dab0e1668564037784368e6c01e3dc381545577f451993c8283a4`

Hash-verified prior declaration review:

- Reuse SHA-256: `1e590a88ea94f095927456f43ecd0a87cf2f004dfa69b3990b68013abb419cd9`
- Reviewed interpretation: Projects the underlying extended-seminormed additive monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D113: `ESeminormedAddMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `bf6ea4b699c55bfcdc7d32c89ca4d866413afa4dc5af86c3f4ff641d96cab901`

Hash-verified prior declaration review:

- Reuse SHA-256: `cb54e0b6aed12eeb88b381f2d30713f6ca16498623e7893de1412c977282c2b8`
- Reviewed interpretation: Projects its additive-monoid field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D114: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `4a47a498b3f2422bea44ac3aa046a828c03d76111f34db372b1565dd210e5d33`
- Reviewed interpretation: Existential quantification over a predicate's witness type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D115: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `f1757307432fadbd23925bbf0a318b8da57d17711478e1073a19ce64c21d55f4`

Hash-verified prior declaration review:

- Reuse SHA-256: `ebc0f958356e5c0d4071b9145252f16333e03d855220327642ce08199c373693`
- Reviewed interpretation: Projects the selected scalar multiplication operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D116: `NegZeroClass.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `881414a459dbdc250afc9bc468e98b17f776dfd31f2aa5eb9acee71a8d1543f7`

Hash-verified prior declaration review:

- Reuse SHA-256: `fde37ded74fe89148a3994108374f7e80a47aed207df0824c866eeda7554f3b1`
- Reviewed interpretation: Projects the zero operation from a negation-with-zero structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D117: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Hash-verified prior declaration review:

- Reuse SHA-256: `b6fb7d2b24582fcbb53b5a991cd662e863bc8a720cf95df14ba3b1263350030e`
- Reviewed interpretation: The library structure of a normed additive commutative group.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D118: `NormedAddCommGroup.toAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `c92bdde4376567f29ebdebaf4a7dd986bfb96211cd0306e14540b80cd23009d2`

Hash-verified prior declaration review:

- Reuse SHA-256: `159b26320e3510985278e6a8fbee257817685b0a86129a765cc4586783e79227`
- Reviewed interpretation: Projects the additive-group field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D119: `NormedAddCommGroup.toENormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `eac639a9ae15f19554f668c9811538a135f4f05df04330bd8145b300efe57cfb`

Hash-verified prior declaration review:

- Reuse SHA-256: `25099a6e15c0c3eacbf5ef00a3a154f5b3770026c21adcbff7fa587dc5a62c5f`
- Reviewed interpretation: Builds the extended-norm additive structure from the existing normed group and its induced topology.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D120: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Hash-verified prior declaration review:

- Reuse SHA-256: `19128b6f3cbd56f60581b5ea3b15c1ce9da601fab0c80366123647892bbc7ebb`
- Reviewed interpretation: Retains norm, additive group, and pseudometric while forgetting norm separation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D121: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Hash-verified prior declaration review:

- Reuse SHA-256: `aa2014f463cdaad5fcdc90d816ab1302ac7331a5d46c43105f0aa6e791d29cfa`
- Reviewed interpretation: The library normed-space structure over a normed field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D122: `Pi.instSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `adba1d4e42926a50c2701c18af6f5749dd72a4d631113b924c96482924951276`

Type:

```lean
{ι : Type u_1} → {α : Type u_2} → {M : ι → Type u_5} → [(i : ι) → SMul α (M i)] → SMul α ((i : ι) → M i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {α : Type u_2} → {M : ι → Type u_5} → [(i : ι) → SMul.{u_2, u_5} α (M i)] → SMul.{u_2, max u_1 u_5} α ((i : ι) → M i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {α} {M} [(i : ι) → SMul α (M i)] => { smul := fun a f i => instHSMul.hSMul a (f i) }
```

### D123: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Hash-verified prior declaration review:

- Reuse SHA-256: `1dfca65d7ddd6fffb3707eb4771db75c6105f4d1dd81ded1374e5a0dd2611292`
- Reviewed interpretation: The inferred library multiplicative monoid on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D124: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `a8cadadddb0c9fd4a7bcb7c57401fafb43a1f330afa35fdacacb6d0e82d0bcf6`

Hash-verified prior declaration review:

- Reuse SHA-256: `9f34cb8c014cfa202bbf3a4233bd93329142c60e7c282d3b876ca561e0275e7f`
- Reviewed interpretation: Projects the scalar multiplication operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D125: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `3f8499f7dfc2e8115a48b4ac0bec5328dd7223a18dd71fc0061e711fbd543126`

Hash-verified prior declaration review:

- Reuse SHA-256: `10022d3da8eadb1c61a6459f65fac7e52f6656a97550dea7f697c93b2ba79d7d`
- Reviewed interpretation: Projects the pseudometric field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D126: `SubNegZeroMonoid.toNegZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `0ca9c4737492ec2a9a5ab16ab065d00204507f2caf80997692c360afbf962577`

Hash-verified prior declaration review:

- Reuse SHA-256: `f320f4497b81077ca98d16bd74f6f65f7c7613afc1bd2e8c7438d1305aa165db`
- Reviewed interpretation: Retains the existing zero and negation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D127: `SubtractionCommMonoid.toSubtractionMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e56d8d718ddbe8a62b0e5b703adfd59bd19f46dac79c341b3d3742ed6ee462c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `22333f1ce69514ece3965a77e856df7d266288c4a393e115f9b336e20a6cfdae`
- Reviewed interpretation: Projects the underlying subtraction monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D128: `SubtractionMonoid.toSubNegZeroMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `700a470249543a704f0b5910309b7d1f4c918e3b645f806242c291c98eff4e28`

Hash-verified prior declaration review:

- Reuse SHA-256: `259b9d0e2a38d93e1782c492b17107d298aa13619bf230808763187d2abe6949`
- Reviewed interpretation: Retains the subtraction/negation monoid and supplies the negation-zero law.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D129: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `6238629e2336029ac8d0d72fe0a7c72d5668423f9902c65417fa42f59040ad1a`
- Reviewed interpretation: Constructs the numeral-zero instance from an existing zero operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D130: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `04ea7c06812eccb8531b763b7aa28fd8f968befff069e74166ff1b406f7512e3`

Hash-verified prior declaration review:

- Reuse SHA-256: `8edcadcaaf692e4c8f1765c0cac3eed1bf9c498266a5ef603ad9f069b38e0177`
- Reviewed interpretation: Lifts scalar multiplication to HSMul without changing the operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D131: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `f727c3f01db957bd004eab61d742db6d02c6f9b2cdad465fa6f0ac214e09ccfd`

Hash-verified prior declaration review:

- Reuse SHA-256: `9c9a78aca88ff654defd9bd9fce8169dd2b8314c2cb1e263ddabac070c890870`
- Reviewed interpretation: Retains the additive monoid and commutativity.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D132: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `7f49725cf4bc16610110860af8f38e6d0fe472c7c1af93721407bad8c7375729`

Hash-verified prior declaration review:

- Reuse SHA-256: `8e5116bd78ee582cc82596039084a3a7e4454eaa72c982163fc1ec9446ee914c`
- Reviewed interpretation: Projects the underlying additive group.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D133: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `8c0fca6ee264d934b25c679f16be6b83bb2a2f7c58a8ac0afab0c146219e16a1`

Hash-verified prior declaration review:

- Reuse SHA-256: `71c755cd74fd77e59d6217092296143c1f84295ed2f161c5042338a89db79462`
- Reviewed interpretation: Projects the underlying subtraction-and-negation structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D134: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `9e6f6ef922e3c39bdc8dcf74fa873f2e393c916c08aa49739c9dcafb3f96877b`

Hash-verified prior declaration review:

- Reuse SHA-256: `d877ae3c02e7cccd82334f1aa3093cc499f10c1d5025b8813554bee38f5019c3`
- Reviewed interpretation: Projects the additive monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.
