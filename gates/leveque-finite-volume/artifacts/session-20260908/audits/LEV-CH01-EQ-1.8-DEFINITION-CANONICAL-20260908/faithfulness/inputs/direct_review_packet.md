# Declaration dossier for LEV-CH01-EQ-1.8-DEFINITION-CANONICAL-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_equation08_conservationLawAt_iff
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (x t : ℝ) :
    leveque01_equation08_conservationLawAt q flux x t ↔
      ∃ qt fluxx : Fin m → ℝ,
        HasDerivAt (fun τ => q x τ) qt t ∧
          HasDerivAt (fun ξ => flux (q ξ t)) fluxx x ∧
            qt + fluxx = 0
```

## Elaborated target type

```lean
∀ {m : Nat} (q : Real → Real → Fin m → Real) (flux : (Fin m → Real) → Fin m → Real) (x t : Real),
  Iff (NumStability.leveque01_equation08_conservationLawAt q flux x t)
    (Exists fun qt =>
      Exists fun fluxx =>
        And (HasDerivAt (fun τ => q x τ) qt t)
          (And (HasDerivAt (fun ξ => flux (q ξ t)) fluxx x) (Eq (instHAdd.hAdd qt fluxx) 0)))
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} (q : Real → Real → Fin m → Real) (flux : (Fin m → Real) → Fin m → Real) (x t : Real),
  Iff (@NumStability.leveque01_equation08_conservationLawAt m q flux x t)
    (@Exists.{1} (Fin m → Real) fun (qt : Fin m → Real) =>
      @Exists.{1} (Fin m → Real) fun (fluxx : Fin m → Real) =>
        And
          (@HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)
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
                (@NormedField.toNormedSpace.{0} Real Real.normedField)))
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
                                      (@NormedField.toNormedSpace.{0} Real Real.normedField))
                                  i))
                            i))
                      i)))
              fun (i : Fin m) =>
              @ContinuousMul.to_continuousSMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instMul
                (@IsTopologicalSemiring.toContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                  (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                    instIsTopologicalRingReal)))
            (fun (τ : Real) => q x τ) qt t)
          (And
            (@HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)
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
                  (@NormedField.toNormedSpace.{0} Real Real.normedField)))
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
                                        (@NormedField.toNormedSpace.{0} Real Real.normedField))
                                    i))
                              i))
                        i)))
                fun (i : Fin m) =>
                @ContinuousMul.to_continuousSMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instMul
                  (@IsTopologicalSemiring.toContinuousMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal)))
              (fun (ξ : Real) => flux (q ξ t)) fluxx x)
            (@Eq.{1} (Fin m → Real)
              (@HAdd.hAdd.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                (@instHAdd.{0} (Fin m → Real)
                  (@Pi.instAdd.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAdd))
                qt fluxx)
              (@OfNat.ofNat.{0} (Fin m → Real) (nat_lit 0)
                (@Zero.toOfNat0.{0} (Fin m → Real)
                  (@Pi.instZero.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instZero))))))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.leveque01_equation08_conservationLawAt`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `14df1535bf16f084ddcf0eadd1c453a51db67bce66f47f05c81faf82c4edcc9f`

Type:

```lean
{m : Nat} → (Real → Real → Fin m → Real) → ((Fin m → Real) → Fin m → Real) → Real → Real → Prop
```

Fully explicit type:

```lean
{m : Nat} → (q : Real → Real → Fin m → Real) → (flux : (Fin m → Real) → Fin m → Real) → (x t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} q flux x t => NumStability.IsConservationLawSolutionAt q flux x t
```

### D002: `NumStability.IsConservationLawSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D003: `NumStability.IsConservationLawSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- Declaration kind: `theorem`
- Distance from target type: `3`
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

### D004: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `98c22aec54da8e2278fb6c5ae1daeffb76abd7bad320de72096bec6a7046bc17`

Hash-verified prior declaration review:

- Reuse SHA-256: `978bf46ded8cb70970ddd2743b454739c798f2e271210d6f063c4362150ebf67`
- Reviewed interpretation: Projects the underlying additive monoid without changing operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D005: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `94e96d1a013e57386e57cd114e8941fbf0a07288f11d1a5476f8ead74a955410`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D006: `ContinuousMul.to_continuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `f0c5d378c0acb7a136cec4dc063f034495e42fd5022786b7c0b6595115d372ae`

Hash-verified prior declaration review:

- Reuse SHA-256: `0c32430ca45271386451c4a712910c5ab326d8ae1547480bce37997ae3e4cc02`
- Reviewed interpretation: Continuous multiplication yields a continuous self scalar action using that multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D007: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Hash-verified prior declaration review:

- Reuse SHA-256: `2b3f995daeabbff34366289ad0fe1d2f4a20fb874fb638214fda15c697ed04f0`
- Reviewed interpretation: Retains the supplied normed field and establishes its nontrivial norm.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D008: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ea6124156f152313d3298dd94738351217f9626c6fc23cb2b63efa1528a4f9b9`

Hash-verified prior declaration review:

- Reuse SHA-256: `5fddb4d66016fd78e62b65a2ddcb12e175a07c85dbef2c09bb6038ade0618b97`
- Reviewed interpretation: Projects the multiplicative action from a distributive action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D009: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `587c80a71f9aa5749b5d6c35c97cdae1067fa669257c865951843b747c511934`

Hash-verified prior declaration review:

- Reuse SHA-256: `49a8f468eaa08722f6fe9fcba54a341cc96c9f34fcb467cf7fab585c4885150b`
- Reviewed interpretation: Projects the underlying semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D010: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `05045c1c8a33751c0bdc7052eba52c723fef07c16e4bfbc9edc45fbeeab132f2`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D011: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `f3bebfe1772311ad06a19d1724c8817bcc8fb18711eec8fa67d484ca83165c8e`
- Reviewed interpretation: Existential quantification over a specified type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D012: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9a6353c2087dc0f4123f4079d947842f8b7bc1fc0c77de170382c04e31608fd4`

Hash-verified prior declaration review:

- Reuse SHA-256: `f20dcb30ea8bbb08e4e073f47b32fe3e0d8a36e3af1dabd595bd6149be2df52f`
- Reviewed interpretation: Builds the semifield structure using the field's existing arithmetic and inverse operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D013: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Hash-verified prior declaration review:

- Reuse SHA-256: `ae15c5a07847350f3a9b08283ee0bb335d7066a0b18b777496d1abf6df23f955`
- Reviewed interpretation: The standard finite index type of natural numbers below its parameter.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D014: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `c9b94b9ea6b1a161014f33bd1c3edcbb857fc0ac83557114aa2735604e9a3ca1`
- Reviewed interpretation: Extracts the addition operation from the supplied HAdd instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D015: `HasDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.Deriv.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `425ec9578fd20d63923b9588cbb7761a6e92f281528630fe03d0dc3dc1bc60a2`

Hash-verified prior declaration review:

- Reuse SHA-256: `236a3885c5f2b9b2c71c96fd3a0830d94730dce8bdaf5207840935434ad388c1`
- Reviewed interpretation: Derivative assertion at a point, obtained from HasDerivAtFilter with the neighborhood filter in the varying argument and the fixed base point.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D016: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Hash-verified prior declaration review:

- Reuse SHA-256: `1092f219abf1125bbfc9b187a05dc0742fa0d96d11819c687aa5fd6505817c3d`
- Reviewed interpretation: Logical equivalence.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D017: `IsTopologicalRing.toIsTopologicalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `f55163e46531cbf77c144d47ba02dbad1720a8a16e67de32af3e47419e5ccdb7`

Hash-verified prior declaration review:

- Reuse SHA-256: `64337e10e1bb0124674e260a49136866d146cd6e680ef376a3f1851a43e51265`
- Reviewed interpretation: Transfers continuity properties to the underlying semiring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D018: `IsTopologicalSemiring.toContinuousMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `fd5dd952a3c3566c14b553c40684808260a448d4b7c6fa7c23e9084603af65f5`

Hash-verified prior declaration review:

- Reuse SHA-256: `70d63ddff1c59cc54f5fa5875e8ff14ec4acd498581326149c1d4da3099a278e`
- Reviewed interpretation: Extracts continuity of multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D019: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Hash-verified prior declaration review:

- Reuse SHA-256: `aa58368da2bed53ee1e85928b9761de93691f80329feb14441a53ca19e2079bb`
- Reviewed interpretation: Projects the distributive scalar action from a module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D020: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `136930a747dcd73895587cb4c7ea1df27360fed0a4adb57efb71bb8949f0fa71`

Hash-verified prior declaration review:

- Reuse SHA-256: `d5da17b732809b3324e1b49e8ae16262274eea0707ef71e860b637de2a568ebc`
- Reviewed interpretation: Projects the underlying semigroup.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D021: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Hash-verified prior declaration review:

- Reuse SHA-256: `4bcf5d8742271ec87acc06cd7e77893aebfdb6249b456b7cd65d6a6f35dda6a3`
- Reviewed interpretation: Projects the underlying multiplicative monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D022: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `2a4074e38a7cedd1ecdaf86a42d3be01ad9728988610178bf9a698f57a876516`

Hash-verified prior declaration review:

- Reuse SHA-256: `772f6172c2f9d54b2ed4dbfb478e73ac9adbdfd8c847ca9276937e608e7b0709`
- Reviewed interpretation: Projects the underlying semigroup action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D023: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Hash-verified prior declaration review:

- Reuse SHA-256: `6a0f21fa632b8005bd5b219c8994ea3d40737abbe2548bb9e2419d917a909748`
- Reviewed interpretation: Natural numbers, including zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D024: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Hash-verified prior declaration review:

- Reuse SHA-256: `8ca92f5010616d227b86192d531ac39cc8e84182d6733c3834a11c69ce5bf4cd`
- Reviewed interpretation: Retains the underlying ring operations while forgetting associativity structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D025: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Hash-verified prior declaration review:

- Reuse SHA-256: `2aaf53d2f9cec3ac0309d9814beae9afae8200d907d0d2fe5370e7952d4345dc`
- Reviewed interpretation: Projects the underlying nonassociative ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D026: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `e5c4264e596742b10105432449b8707b9bc3fda7c0f7fc1373cd4b37643f2518`
- Reviewed interpretation: Builds a semiring structure with the original addition and multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D027: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Hash-verified prior declaration review:

- Reuse SHA-256: `83cd664848079ef3e8328668554f0dc47eb5f863185c6c5656e9bf3687182197`
- Reviewed interpretation: Projects the additive commutative monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D028: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Hash-verified prior declaration review:

- Reuse SHA-256: `f58340b0d2438174b461d405185bcc7e997ea0562b4bde2fa6103d4e3df57e1e`
- Reviewed interpretation: Retains ring operations and commutativity while dropping norm structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D029: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `f1bb09342196442cedb5dbc4ae9afb73af62e2b2e3c1352834ed787f9364edc6`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D030: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `7008f990b3138223bca008ab8e3b83356a61874059845b84ef708ad0ad29977a`
- Reviewed interpretation: Retains the norm, additive group, and pseudometric of the supplied ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D031: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Hash-verified prior declaration review:

- Reuse SHA-256: `5d076d7972bd9a4b5737b6464a9430c9d729791dc5f69255db998ce027b236bd`
- Reviewed interpretation: Projects the underlying nonassociative semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D032: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `dc08b02d757cccbd21bce550b40d3f76d2ee704ec2cd7f5507023d827296474f`

Hash-verified prior declaration review:

- Reuse SHA-256: `56f19478b39c62924b98a799ed70eefd1198a8e355c63ae48aaba0c0952d2b44`
- Reviewed interpretation: Projects the supplied normed field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D033: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Hash-verified prior declaration review:

- Reuse SHA-256: `a256672575532e649cc036971d1649e78cfacc892e78e16706e4c794422673c1`
- Reviewed interpretation: Copies the norm, metric, and ring operations into the structure without a unit requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D034: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `7ad82883254f6880fb9cdcfa7f9253eb3537456df7eb73cdd8ee6e326f8ff53f`
- Reviewed interpretation: Retains the norm, ring, and induced pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D035: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ec9eab2d54099c52c160e626a54324e8c9a07675797f0926435031098f363e5f`

Hash-verified prior declaration review:

- Reuse SHA-256: `3c992f62dcc3a42622f66168325584746d39917fece3d93ec55ad4d91f7636ed`
- Reviewed interpretation: Projects the underlying field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D036: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4aa3dba57859ca72552799005279a2b5a65b8c083980070fbbff11fd1de56dec`

Hash-verified prior declaration review:

- Reuse SHA-256: `899b6604c0b92f1dd4b6043fb5011762c1ddd54650223608967312cbb3f2bf71`
- Reviewed interpretation: Retains the norm, ring, and metric of the field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D037: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Hash-verified prior declaration review:

- Reuse SHA-256: `18079e0c5bf4a127a124af0efdae2d4f9fc2b96522a97779236ffe93e2b56719`
- Reviewed interpretation: A normed field acts on itself through its semiring module structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D038: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Hash-verified prior declaration review:

- Reuse SHA-256: `2eaa759932815ccfa8b8754916dee15cb38ef5b3ad68591d6270972e76afe032`
- Reviewed interpretation: Projects the underlying module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D039: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `9228afc6646359bb6a05b07d1ba12fa0b5cd48192bd478792be0eff44c6bdf50`
- Reviewed interpretation: Extracts the value assigned to a natural-number literal by its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D040: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Hash-verified prior declaration review:

- Reuse SHA-256: `e25c2321ea4d225012c883e6eac9a056c8312860b290278dc42f7c2c4e6df8b2`
- Reviewed interpretation: Uses the product module on functions with fixed codomain.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D041: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Hash-verified prior declaration review:

- Reuse SHA-256: `e510b4567296b5d39d1db32106d3a3e3c9ebcbfd8a0f2c9efcaf300b6b1d7bbf`
- Reviewed interpretation: Builds the additive commutative group of functions from coordinate additive groups.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D042: `Pi.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `786aa93e85ac0acc746f4c8ee6aed957d52e0231f66623c2b8e478a794d15ce0`

Hash-verified prior declaration review:

- Reuse SHA-256: `c4a557467ae0f1c482fdaa8e629cd26d57e71d5fd392bee997d198d4642a2c33`
- Reviewed interpretation: Adds functions by adding their values at each index.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D043: `Pi.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `eb5c70d9b813d7099537e8db11f59a65a3f5ad951da7314a1aa554471a122049`

Hash-verified prior declaration review:

- Reuse SHA-256: `5aba39fdae231ab776444d3772f55ccb8ba847c5dcccfc8e80ad7ff2b0cbd933`
- Reviewed interpretation: The zero function takes the zero value at every index.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D044: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a81381c20af462683322c70d792fc61454007e60d0781bb4fda6103a009c8abd`

Hash-verified prior declaration review:

- Reuse SHA-256: `98352bbc872b2743a9c707e11d6d7702a85b14bacecd03eaf127d7fed3ca6e53`
- Reviewed interpretation: The product topology is constructed from the induced topologies of coordinate evaluations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D045: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Hash-verified prior declaration review:

- Reuse SHA-256: `eaeddb156cf5332f4a5fd32fcccdbbea3dbb0c3db05fa939dc71053de0502918`
- Reviewed interpretation: Projects the uniform space associated with the pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D046: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `02ec8a7c32a5d439c47e2484dced22048019b98b0fd1c4703f548ca2175438e8`
- Reviewed interpretation: The standard library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D047: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Hash-verified prior declaration review:

- Reuse SHA-256: `c17bf9cf2b87e1bc685280fd6837bb1b4c108db188726cdf9aaa54daa66ef9cf`
- Reviewed interpretation: Equips Real with its normed field and the dense-norm property.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D048: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Hash-verified prior declaration review:

- Reuse SHA-256: `72cafc26597fc930160c78dc2efc888f921ef8aad1e9921a0ded1b20f3903973`
- Reviewed interpretation: Selects Real.add as real addition.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D049: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Hash-verified prior declaration review:

- Reuse SHA-256: `036bffb81dbdb095fb82dcd91ccf12964e8f45500f1342c459415b3d6f419a53`
- Reviewed interpretation: Supplies the standard inferred additive commutative group of Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D050: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Hash-verified prior declaration review:

- Reuse SHA-256: `8b75d6695cb63174cee6054697474a24408bc65cd39fa9b186af1d41dca6738d`
- Reviewed interpretation: Selects Real.mul as real multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D051: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Hash-verified prior declaration review:

- Reuse SHA-256: `e88b3e179e64e81dc2cce46b7fcd9ac4b2d0714b6db56d7d4a643c8fabb1ad09`
- Reviewed interpretation: Supplies the inferred ring structure on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D052: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `88db7d34ee4c2a575cc03d3cae926ae895441a22b1c32d2cccfea03dfcb14d0c`
- Reviewed interpretation: Selects Real.zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D053: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Hash-verified prior declaration review:

- Reuse SHA-256: `54e5e003c8dd512b3799f211681051bdc02b5b5e76b5cd3836ca1c8b832262d8`
- Reviewed interpretation: Combines the real normed additive group and real commutative ring, retaining their operations and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D054: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Hash-verified prior declaration review:

- Reuse SHA-256: `149ff816d763ae3b4d92d37f1bd2db24cf456b172d5d78407f15a78ec63e507d`
- Reviewed interpretation: Combines the real field with its normed additive group and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D055: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `2969bbcb885ce7c1fc758b708a2781fa204dbb3c84a1e2fce7c78f2358609e3c`
- Reviewed interpretation: The distance between x and y is abs(x - y).

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D056: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Hash-verified prior declaration review:

- Reuse SHA-256: `b320b379caf2e0d2b49e5a943f0729c178d809f922ac44d191ce6f9b9086b4ce`
- Reviewed interpretation: Projects the underlying semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D057: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a1b771abeff9bbbdcce988134973a1a367c44a340bcd29acb0cc44b8d6a2e55c`

Hash-verified prior declaration review:

- Reuse SHA-256: `f6f376b072f52112c3eab51063dd7c2b462225ac4e0602d4d7e36620a04f42e3`
- Reviewed interpretation: Retains arithmetic and inverses in the division-semiring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D058: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5a8783c66a2e56a4cc509bbb0651eda5b66e25c197307a42445cac31c4a4bb6c`

Hash-verified prior declaration review:

- Reuse SHA-256: `95fa466d2205e15a8a152eb1d0321611ad4806a609c5767ac70996d64cfdd460`
- Reviewed interpretation: Projects the scalar multiplication operation of an action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D059: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `9a18b52a6c32c07ff80418092d07686e3739d54d8bf6ccfa2100d1fac1900d09`
- Reviewed interpretation: Retains norm, pseudometric, and ring operations while omitting unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D060: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e3cbc92d1d5e37d9eaeb1d595c83a78f7af7e3a8d249a700fa3676ab4e0c3d60`

Hash-verified prior declaration review:

- Reuse SHA-256: `6a1b4ccec5662aeb7e47920d537a1d48682b72c3e6d09e469b6a14f58369cafb`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D061: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e6ea9296e8643d5ae7cf334c065c9d6ebe4a95de22d3b0708a585db80e17322a`

Hash-verified prior declaration review:

- Reuse SHA-256: `262e17303e716f9f6d620d16e657ce2861b7df8899387357e6a243d26dbee4f5`
- Reviewed interpretation: Projects the supplied pseudometric space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D062: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Hash-verified prior declaration review:

- Reuse SHA-256: `79b845ca00a8b75df03583a825aa38c2d34ce34fde1b2dde41386def7f61493f`
- Reviewed interpretation: Retains multiplication, one, powers, and zero of the semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D063: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Hash-verified prior declaration review:

- Reuse SHA-256: `1eeec591b2028ca46f8193d4004d20bec51e6e22d19605d7b78076236775104e`
- Reviewed interpretation: Projects the underlying semiring without unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D064: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Hash-verified prior declaration review:

- Reuse SHA-256: `780f5b6fdffb9e5416468ad4237e7d0905586ceef9eae89d1f76a75e55b6e16d`
- Reviewed interpretation: Projects the underlying topology of a uniform space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D065: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `6831406e3df07e887ff49bcb466034413d8378e74e852b18bb00b4ade1409160`
- Reviewed interpretation: Interprets the literal 0 as the supplied zero element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D066: `instContinuousSMulForall`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `d3a31448b115a308914d59b4064d02d2b1d44ef7866e1b111c3a417657355fbb`

Hash-verified prior declaration review:

- Reuse SHA-256: `6ed8ee0406e587a5bfa7f880310aeb048fcc94fc311a0ce700db2f6f9874c3a8`
- Reviewed interpretation: Coordinatewise continuous scalar actions induce a continuous action on the product.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D067: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `3ad6b14e72ee099f3d94bfaf114bf35f0617fc130e5953192cef01d18f5db1b9`
- Reviewed interpretation: Uses the supplied homogeneous addition as heterogeneous addition with all types equal.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D068: `instIsTopologicalRingReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Real`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `74697a527ce10426ad50966a34f3375374c3cde51367629721e2aa0850e2f618`

Hash-verified prior declaration review:

- Reuse SHA-256: `07932a8a7e5e2e823ed4136cc0d70d63763812998bb96a8886a40d74ed7e6a5f`
- Reviewed interpretation: The displayed standard real topology and ring form a topological ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D069: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Hash-verified prior declaration review:

- Reuse SHA-256: `359c9880e79896d2cc5a44d722b7936e43da67cdbff5218872cff339d68d1e7b`
- Reviewed interpretation: Enumerates Fin n using List.finRange n, with completeness and absence of duplicates.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D070: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Hash-verified prior declaration review:

- Reuse SHA-256: `76a88771f136a54bd64c4eda2c24020b47f52070ed5b77d85e072f6bd65b4426`
- Reviewed interpretation: A finite enumeration structure on an index type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D071: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Hash-verified prior declaration review:

- Reuse SHA-256: `050720ced7ede592e84eb49d47871d0d9010c84b012d6cad994f1ff141e9405c`
- Reviewed interpretation: The proposition that the supplied scalar action is jointly continuous in the supplied topologies.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D072: `Pi.instSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `adba1d4e42926a50c2701c18af6f5749dd72a4d631113b924c96482924951276`

Hash-verified prior declaration review:

- Reuse SHA-256: `1ea9c9bd5a32c7a447f4de6937b4b7f11b719276f370332d047582797f07f801`
- Reviewed interpretation: Defines scalar multiplication on functions by scaling every coordinate value.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.
