# Declaration dossier for LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_nonconservation_requires_sourceTerm
    (q : ℝ → ℝ → (Fin 1 → ℝ)) (speed : ℝ)
    (qt qx : ℝ → (Fin 1 → ℝ)) (a b t : ℝ) (massRate : Fin 1 → ℝ)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hqx : ∀ x, HasDerivAt (fun ξ => q ξ t) (qx x) x)
    (hqtIntegrable : IntervalIntegrable qt volume a b)
    (hqxIntegrable : IntervalIntegrable qx volume a b)
    (hmassRate : HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t)
    (hinterchange : HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t)
    (hdefect : massRate ≠ speed • q a t - speed • q b t) :
    ∃ production : ℝ → (Fin 1 → ℝ),
      (∀ x, IsBalanceLawSolutionAt q (fun state => speed • state) (production x) x t) ∧
      IntervalIntegrable production volume a b ∧
      (∫ x in a..b, production x) = massRate - (speed • q a t - speed • q b t) ∧
      production ≠ 0 ∧ ¬ (∀ x, IsConservationLawSolutionAt q (fun state => speed • state) x t)
```

## Elaborated target type

```lean
∀ (q : Real → Real → Fin 1 → Real) (speed : Real) (qt qx : Real → Fin 1 → Real) (a b t : Real)
  (massRate : Fin 1 → Real),
  (∀ (x : Real), HasDerivAt (fun τ => q x τ) (qt x) t) →
    (∀ (x : Real), HasDerivAt (fun ξ => q ξ t) (qx x) x) →
      IntervalIntegrable qt Real.measureSpace.volume a b →
        IntervalIntegrable qx Real.measureSpace.volume a b →
          HasDerivAt (fun τ => intervalIntegral (fun x => q x τ) a b Real.measureSpace.volume) massRate t →
            HasDerivAt (fun τ => intervalIntegral (fun x => q x τ) a b Real.measureSpace.volume)
                (intervalIntegral (fun x => qt x) a b Real.measureSpace.volume) t →
              Ne massRate (instHSub.hSub (instHSMul.hSMul speed (q a t)) (instHSMul.hSMul speed (q b t))) →
                Exists fun production =>
                  And
                    (∀ (x : Real),
                      NumStability.IsBalanceLawSolutionAt q (fun state => instHSMul.hSMul speed state) (production x) x
                        t)
                    (And (IntervalIntegrable production Real.measureSpace.volume a b)
                      (And
                        (Eq (intervalIntegral (fun x => production x) a b Real.measureSpace.volume)
                          (instHSub.hSub massRate
                            (instHSub.hSub (instHSMul.hSMul speed (q a t)) (instHSMul.hSMul speed (q b t)))))
                        (And (Ne production 0)
                          (Not
                            (∀ (x : Real),
                              NumStability.IsConservationLawSolutionAt q (fun state => instHSMul.hSMul speed state) x
                                t)))))
```

## Fully explicit elaborated target type

```lean
∀ (q : Real → Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) (speed : Real)
  (qt qx : Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) (a b t : Real)
  (massRate : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
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
        (fun (τ : Real) => q x τ) (qt x) t)
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
        (fun (ξ : Real) => q ξ t) (qx x) x)
  (hqtIntegrable :
    @IntervalIntegrable.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
      (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
        (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
        fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
        @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@NormedAddGroup.toENormedAddMonoid.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@Pi.normedAddGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
          @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
      qt (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) a b)
  (hqxIntegrable :
    @IntervalIntegrable.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
      (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
        (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
        fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
        @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@NormedAddGroup.toENormedAddMonoid.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@Pi.normedAddGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
          (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
          fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
          @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
      qx (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) a b)
  (hmassRate :
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
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
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
          (fun (x : Real) => q x τ) a b (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace))
      massRate t)
  (hinterchange :
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
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
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
          (fun (x : Real) => q x τ) a b (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace))
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
  (hdefect :
    @Ne.{1} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) massRate
      (@HSub.hSub.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
        (@instHSub.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
          (@Pi.instSub.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
            (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
            fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.instSub))
        (@HSMul.hSMul.{0, 0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
          (@instHSMul.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
            (@Function.hasSMul.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) Real Real
              (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                (@Algebra.id.{0} Real Real.instCommSemiring))))
          speed (q a t))
        (@HSMul.hSMul.{0, 0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
          (@instHSMul.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
            (@Function.hasSMul.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) Real Real
              (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                (@Algebra.id.{0} Real Real.instCommSemiring))))
          speed (q b t)))),
  @Exists.{1} (Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
    fun (production : Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) =>
    And
      (∀ (x : Real),
        @NumStability.IsBalanceLawSolutionAt (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) q
          (fun (state : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) =>
            @HSMul.hSMul.{0, 0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
              (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
              (@instHSMul.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                (@Function.hasSMul.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) Real
                  Real
                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                    (@Algebra.id.{0} Real Real.instCommSemiring))))
              speed state)
          (production x) x t)
      (And
        (@IntervalIntegrable.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
          (@Pi.topologicalSpace.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
            (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
            fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
            @UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          (@NormedAddGroup.toENormedAddMonoid.{0}
            (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
            (@Pi.normedAddGroup.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
              (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
              (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
              fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) =>
              @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
          production (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) a b)
        (And
          (@Eq.{1} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
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
              (fun (x : Real) => production x) a b (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace))
            (@HSub.hSub.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
              (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
              (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
              (@instHSub.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                (@Pi.instSub.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                  (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
                  fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.instSub))
              massRate
              (@HSub.hSub.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                (@instHSub.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                  (@Pi.instSub.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                    (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
                    fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.instSub))
                (@HSMul.hSMul.{0, 0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                  (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                  (@instHSMul.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                    (@Function.hasSMul.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                      Real Real
                      (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                        (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                        (@Algebra.id.{0} Real Real.instCommSemiring))))
                  speed (q a t))
                (@HSMul.hSMul.{0, 0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                  (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                  (@instHSMul.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                    (@Function.hasSMul.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                      Real Real
                      (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                        (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                        (@Algebra.id.{0} Real Real.instCommSemiring))))
                  speed (q b t)))))
          (And
            (@Ne.{1} (Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) production
              (@OfNat.ofNat.{0} (Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                (nat_lit 0)
                (@Zero.toOfNat0.{0} (Real → Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                  (@Pi.instZero.{0, 0} Real
                    (fun (a : Real) => Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                    fun (i : Real) =>
                    @Pi.instZero.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                      (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real)
                      fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) => Real.instZero))))
            (Not
              (∀ (x : Real),
                @NumStability.IsConservationLawSolutionAt.{0}
                  (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                  (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) q
                  (fun (state : Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real) =>
                    @HSMul.hSMul.{0, 0, 0} Real
                      (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                      (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                      (@instHSMul.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) → Real)
                        (@Function.hasSMul.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                          Real Real
                          (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                            (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                            (@Algebra.id.{0} Real Real.instCommSemiring))))
                      speed state)
                  x t)))))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsBalanceLawSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5175f6ab2f4d6f5ff9ff230a9d3ecec5e8b85ed56c10708295132b1c62353d07`

Type:

```lean
{m : Nat} → (Real → Real → Fin m → Real) → ((Fin m → Real) → Fin m → Real) → (Fin m → Real) → Real → Real → Prop
```

Fully explicit type:

```lean
{m : Nat} →
  (q : Real → Real → Fin m → Real) →
    (flux : (Fin m → Real) → Fin m → Real) → (production : Fin m → Real) → (x t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} q flux production x t =>
  Exists fun qt =>
    Exists fun fluxx =>
      And (HasDerivAt (fun τ => q x τ) qt t)
        (And (HasDerivAt (fun ξ => flux (q ξ t)) fluxx x) (Eq (instHAdd.hAdd qt fluxx) production))
```

### D002: `NumStability.IsConservationLawSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `14ea7c8f12e6fa3f4bbb4d1ccb81ea3a4392f29698612d08bab8c50e6584b52f`

Type:

```lean
{ι : Type u_1} → [Fintype ι] → (Real → Real → ι → Real) → ((ι → Real) → ι → Real) → Real → Real → Prop
```

Fully explicit type:

```lean
{ι : Type u_1} → [Fintype.{u_1} ι] → (q : Real → Real → ι → Real) → (flux : (ι → Real) → ι → Real) → (x t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] q flux x t =>
  Exists fun qt =>
    Exists fun fluxx =>
      And (HasDerivAt (fun τ => q x τ) qt t)
        (And (HasDerivAt (fun ξ => flux (q ξ t)) fluxx x) (Eq (instHAdd.hAdd qt fluxx) 0))
```

### D003: `NumStability.IsBalanceLawSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `ab6f746388d20253823013c7e5013c60e0ca3dbbcb36229c03926c6b74b95d7e`

Type:

```lean
∀ {m : Nat}, ContinuousSMul Real (Fin m → Real)
```

Fully explicit type:

```lean
∀ {m : Nat},
  @ContinuousSMul.{0, 0} Real ((i : Fin m) → Real)
    (@Pi.instSMul.{0, 0, 0} (Fin m) Real (fun (a : Fin m) => Real) fun (i : Fin m) =>
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
    (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
      @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
```

### D004: `NumStability.IsConservationLawSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `82717d2b5b5fd49886ea128aa30080e1100361d110dea70258f6f0b567b868e7`

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
                (@NormedField.toNormedSpace.{0} Real Real.normedField))))))
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

### D005: `AddCommMonoid.toAddMonoid`

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

### D006: `Algebra.id`

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

### D007: `Algebra.toSMul`

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

### D008: `And`

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

### D009: `CommSemiring.toSemiring`

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

Fully explicit type:

```lean
{α : Type u_2} → [DenselyNormedField.{u_2} α] → NontriviallyNormedField.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : DenselyNormedField α] => { toNormedField := inst.toNormedField, non_trivial := ⋯ }
```

### D011: `DistribMulAction.toMulAction`

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

### D012: `DivisionSemiring.toSemiring`

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

### D013: `Eq`

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

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Prop
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

### D016: `Fin`

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

### D017: `Fin.fintype`

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

### D018: `Function.hasSMul`

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

### D019: `HSMul.hSMul`

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

### D020: `HSub.hSub`

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

### D021: `HasDerivAt`

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

### D022: `InnerProductSpace.toNormedSpace`

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

### D023: `IntervalIntegrable`

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

### D024: `IsModuleTopology.toContinuousSMul`

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

### D025: `IsTopologicalRing.toIsTopologicalSemiring`

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

### D026: `IsTopologicalSemiring.toIsModuleTopology`

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

### D027: `MeasureTheory.MeasureSpace.volume`

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

### D028: `Module.toDistribMulAction`

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

### D029: `Monoid.toSemigroup`

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

### D030: `MonoidWithZero.toMonoid`

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

### D031: `MulAction.toSemigroupAction`

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

### D032: `Nat`

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

### D033: `Ne`

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

### D034: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

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

### D035: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

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

### D036: `NonUnitalNonAssocSemiring.toAddCommMonoid`

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

### D037: `NonUnitalNormedCommRing.toNonUnitalCommRing`

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

### D038: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

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

### D039: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D040: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

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

### D041: `NontriviallyNormedField.toNormedField`

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

### D042: `NormedAddCommGroup.toNormedAddGroup`

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

### D043: `NormedAddGroup.toENormedAddMonoid`

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

### D044: `NormedCommRing.toNonUnitalNormedCommRing`

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

### D045: `NormedCommRing.toSeminormedCommRing`

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

### D046: `NormedField.toField`

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

### D047: `NormedField.toNormedCommRing`

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

### D048: `NormedSpace.toModule`

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

### D049: `Not`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D050: `OfNat.ofNat`

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

### D051: `Pi.Function.module`

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

### D052: `Pi.addCommGroup`

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

### D053: `Pi.instSub`

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

### D054: `Pi.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `eb5c70d9b813d7099537e8db11f59a65a3f5ad951da7314a1aa554471a122049`

Type:

```lean
{ι : Type u_1} → {M : ι → Type u_5} → [(i : ι) → Zero (M i)] → Zero ((i : ι) → M i)
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : ι → Type u_5} → [(i : ι) → Zero.{u_5} (M i)] → Zero.{max u_1 u_5} ((i : ι) → M i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [(i : ι) → Zero (M i)] => { zero := fun x => 0 }
```

### D055: `Pi.normedAddCommGroup`

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

### D056: `Pi.normedAddGroup`

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

Fully explicit type:

```lean
{ι : Type u_5} →
  {Y : ι → Type v} → [t₂ : (i : ι) → TopologicalSpace.{v} (Y i)] → TopologicalSpace.{max u_5 v} ((i : ι) → Y i)
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

Fully explicit type:

```lean
{α : Type u} → [self : PseudoMetricSpace.{u} α] → UniformSpace.{u} α
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

Fully explicit type:

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

Fully explicit type:

```lean
DenselyNormedField.{0} Real
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

Fully explicit type:

```lean
Add.{0} Real
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

Fully explicit type:

```lean
AddCommGroup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D065: `Real.instCommSemiring`

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

### D066: `Real.instRCLike`

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

### D067: `Real.instRing`

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

### D068: `Real.instSub`

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

### D069: `Real.instZero`

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

### D072: `Real.normedCommRing`

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

### D073: `Real.normedField`

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

### D074: `Real.pseudoMetricSpace`

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

### D075: `Real.semiring`

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

### D080: `SeminormedCommRing.toSeminormedRing`

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

### D081: `SeminormedRing.toPseudoMetricSpace`

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

### D082: `Semiring.toMonoidWithZero`

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

### D085: `Zero.toOfNat0`

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

### D086: `instContinuousSMulForall`

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

### D087: `instHSMul`

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

### D088: `instHSub`

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

### D089: `instIsTopologicalRingReal`

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

### D090: `instOfNatNat`

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

### D091: `intervalIntegral`

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

### D092: `Fintype`

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

### D093: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D094: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Type:

```lean
{𝕜 : Type u_1} → [inst : NormedField 𝕜] → NormedSpace 𝕜 𝕜
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : NormedField.{u_1} 𝕜] →
    @NormedSpace.{u_1, u_1} 𝕜 𝕜 inst
      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{u_1} 𝕜
        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{u_1} 𝕜
          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{u_1} 𝕜
            (@NormedCommRing.toSeminormedCommRing.{u_1} 𝕜 (@NormedField.toNormedCommRing.{u_1} 𝕜 inst)))))
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NormedField 𝕜] => { toModule := Semiring.toModule, norm_smul_le := ⋯ }
```

### D095: `Pi.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D096: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D097: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Type:

```lean
(M : Type u_1) → (X : Type u_2) → [SMul M X] → [TopologicalSpace M] → [TopologicalSpace X] → Prop
```

Fully explicit type:

```lean
(M : Type u_1) → (X : Type u_2) → [SMul.{u_1, u_2} M X] → [TopologicalSpace.{u_1} M] → [TopologicalSpace.{u_2} X] → Prop
```

### D098: `Pi.instSMul`

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

## Complete local imported sources

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

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/BalanceLaw.lean`
SHA-256: `b0abb7e9f724427ede6016bd0a5bb67cfa25cee56adc503ea305ca33faa198c7`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw

/-!
# Internal production and integral mass balance

Classical balance equations and the mass rate after subtracting boundary transport.
The differentiation-under-the-integral premise is explicit.
-/

open MeasureTheory

namespace NumStability

/-- A classical balance equation with a specified internal production vector. -/
def IsBalanceLawSolutionAt {m : ℕ}
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (production : Fin m → ℝ) (x t : ℝ) : Prop :=
  ∃ qt fluxx : Fin m → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => flux (q ξ t)) fluxx x ∧ qt + fluxx = production

theorem balanceLaw_source_eq_zero_of_conservationLaw {m : ℕ}
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    {production : Fin m → ℝ} {x t : ℝ}
    (hbalance : IsBalanceLawSolutionAt q flux production x t)
    (hconservation : IsConservationLawSolutionAt q flux x t) : production = 0 := by
  rcases hbalance with ⟨qt, fx, ht, hx, hsource⟩
  rcases hconservation with ⟨qt', fx', ht', hx', hzero⟩
  rw [ht.unique ht', hx.unique hx'] at hsource
  exact hsource.symm.trans hzero

theorem integral_internalProduction_eq_massDefect {m : ℕ}
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (qt fluxx : ℝ → (Fin m → ℝ)) (a b t : ℝ) (massRate : Fin m → ℝ)
    (hfluxx : ∀ x, HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : IntervalIntegrable fluxx volume a b)
    (hmassRate : HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t)
    (hinterchange : HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t) :
    (∫ x in a..b, qt x + fluxx x) = massRate - (flux (q a t) - flux (q b t)) := by
  rw [intervalIntegral.integral_add hqtIntegrable hfluxxIntegrable,
    hinterchange.unique hmassRate,
    intervalIntegral.integral_eq_sub_of_hasDerivAt (fun x _ => hfluxx x) hfluxxIntegrable]
  abel

/-- When the mass rate differs from net boundary inflow, the classical balance
requires nonzero internal production. Boundary transport is explicitly removed
before identifying production. -/
theorem nonconservation_requires_nonzero_source {m : ℕ}
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (qt fluxx : ℝ → (Fin m → ℝ)) (a b t : ℝ) (massRate : Fin m → ℝ)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hfluxx : ∀ x, HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : IntervalIntegrable fluxx volume a b)
    (hmassRate : HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t)
    (hinterchange : HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t)
    (hdefect : massRate ≠ flux (q a t) - flux (q b t)) :
    ∃ production : ℝ → (Fin m → ℝ),
      (∀ x, IsBalanceLawSolutionAt q flux (production x) x t) ∧
      IntervalIntegrable production volume a b ∧
      (∫ x in a..b, production x) = massRate - (flux (q a t) - flux (q b t)) ∧
      production ≠ 0 ∧ ¬ (∀ x, IsConservationLawSolutionAt q flux x t) := by
  let production := fun x => qt x + fluxx x
  have hbalance := integral_internalProduction_eq_massDefect q flux qt fluxx a b t massRate
    hfluxx hqtIntegrable hfluxxIntegrable hmassRate hinterchange
  have hpoint (x : ℝ) : IsBalanceLawSolutionAt q flux (production x) x t :=
    ⟨qt x, fluxx x, hqt x, hfluxx x, rfl⟩
  have hnonzero : production ≠ 0 := by
    intro hzero
    have hintegral : (∫ x in a..b, production x) = 0 := by rw [hzero]; simp
    exact hdefect (sub_eq_zero.mp (hbalance.symm.trans hintegral))
  refine ⟨production, hpoint, hqtIntegrable.add hfluxxIntegrable, hbalance, hnonzero, ?_⟩
  intro hconservation
  apply hnonzero
  funext x
  exact balanceLaw_source_eq_zero_of_conservationLaw (hpoint x) (hconservation x)

/-- Every source field giving the same actual balance equation has the same
net production, measured by the mass rate minus endpoint transport. -/
theorem integral_any_source_eq_massDefect {m : ℕ}
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (qt fluxx source : ℝ → (Fin m → ℝ)) (a b t : ℝ) (massRate : Fin m → ℝ)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hfluxx : ∀ x, HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : IntervalIntegrable fluxx volume a b)
    (hmassRate : HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t)
    (hinterchange : HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t)
    (hsource : ∀ x, IsBalanceLawSolutionAt q flux (source x) x t) :
    IntervalIntegrable source volume a b ∧
      (∫ x in a..b, source x) = massRate - (flux (q a t) - flux (q b t)) := by
  have heq : source = fun x => qt x + fluxx x := by
    funext x
    rcases hsource x with ⟨qt', fx', ht', hx', hs⟩
    rw [(hqt x).unique ht', (hfluxx x).unique hx']
    exact hs.symm
  rw [heq]
  exact ⟨hqtIntegrable.add hfluxxIntegrable,
    integral_internalProduction_eq_massDefect q flux qt fluxx a b t massRate
      hfluxx hqtIntegrable hfluxxIntegrable hmassRate hinterchange⟩

/-- Uniform production at unit rate is an explicit nonvacuous instance. The
transport velocity is zero, the mass in a unit cell grows at unit rate, and
the source is the actual PDE residual rather than an assumed certificate. -/
theorem uniform_unit_production_nonvacuity (t : ℝ) :
    (∀ x, IsBalanceLawSolutionAt
      (fun (_x : ℝ) (τ : ℝ) (_i : Fin 1) => τ)
      (fun (_state : Fin 1 → ℝ) => 0) (fun _ => 1) x t) ∧
    HasDerivAt (fun τ => ∫ _x in (0 : ℝ)..1, (fun _i : Fin 1 => τ))
      (fun _ => 1) t ∧
    (∫ _x in (0 : ℝ)..1, (fun _i : Fin 1 => (1 : ℝ))) ≠ 0 := by
  have htime : HasDerivAt (fun τ : ℝ => fun _i : Fin 1 => τ) (fun _ => 1) t :=
    hasDerivAt_pi.mpr fun _ => hasDerivAt_id t
  refine ⟨?_, ?_, ?_⟩
  · intro x
    refine ⟨fun _ => 1, 0, htime, hasDerivAt_const x 0, ?_⟩
    simp
  · simpa using htime
  · have hne : (fun _i : Fin 1 => (1 : ℝ)) ≠ 0 := by
      intro hzero
      exact one_ne_zero (congrFun hzero 0)
    simpa using hne


end NumStability
```
