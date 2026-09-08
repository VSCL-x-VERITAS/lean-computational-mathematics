# Declaration dossier for LEV-CH01-HYPERBOLIC-SYSTEM-SCALAR-DECOUPLING-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_hyperbolicSystem_scalarWaveDecomposition {m : ℕ}
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A) :
    ∃ (speeds : Fin m → ℝ) (b : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
      (∀ i, A.mulVec (b i) = speeds i • b i) ∧
      ∀ (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ),
        IsConstantCoefficientLinearSystemSolutionAt q A x t ↔
          ∀ i, IsLinearAdvectionSolutionAt
            (fun ξ τ => b.equivFun (q ξ τ) i) (speeds i) x t
```

## Elaborated target type

```lean
∀ {m : Nat} (A : Matrix (Fin m) (Fin m) Real),
  NumStability.IsRealHyperbolicMatrix A →
    Exists fun speeds =>
      Exists fun b =>
        And
          (∀ (i : Fin m),
            Eq (A.mulVec (Module.Basis.instFunLike.coe b i))
              (instHSMul.hSMul (speeds i) (Module.Basis.instFunLike.coe b i)))
          (∀ (q : Real → Real → Fin m → Real) (x t : Real),
            Iff (NumStability.IsConstantCoefficientLinearSystemSolutionAt q A x t)
              (∀ (i : Fin m),
                NumStability.IsLinearAdvectionSolutionAt (fun ξ τ => EquivLike.toFunLike.coe b.equivFun (q ξ τ) i)
                  (speeds i) x t))
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} (A : Matrix.{0, 0, 0} (Fin m) (Fin m) Real)
  (hA : @NumStability.IsRealHyperbolicMatrix.{0} (Fin m) (Fin.fintype m) A),
  @Exists.{1} (Fin m → Real) fun (speeds : Fin m → Real) =>
    @Exists.{1}
      (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
        (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
        (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
          (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
            (@NormedField.toNormedSpace.{0} Real Real.normedField))))
      fun
        (b :
          @Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
            (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
            (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@NormedField.toNormedSpace.{0} Real Real.normedField)))) =>
      And
        (∀ (i : Fin m),
          @Eq.{1} (Fin m → Real)
            (@Matrix.mulVec.{0, 0, 0} (Fin m) (Fin m) Real
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (Fin.fintype m) A
              (@DFunLike.coe.{1, 1, 1}
                (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                  (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                (Fin m) (fun (x : Fin m) => Fin m → Real)
                (@Module.Basis.instFunLike.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                  (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                b i))
            (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
              (@instHSMul.{0, 0} Real (Fin m → Real)
                (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                    (@Algebra.id.{0} Real Real.instCommSemiring))))
              (speeds i)
              (@DFunLike.coe.{1, 1, 1}
                (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                  (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                (Fin m) (fun (x : Fin m) => Fin m → Real)
                (@Module.Basis.instFunLike.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                  (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                b i)))
        (∀ (q : Real → Real → Fin m → Real) (x t : Real),
          Iff (@NumStability.IsConstantCoefficientLinearSystemSolutionAt.{0} (Fin m) (Fin.fintype m) q A x t)
            (∀ (i : Fin m),
              @NumStability.IsLinearAdvectionSolutionAt.{0} Real Real.normedAddCommGroup
                (@NormedField.toNormedSpace.{0} Real Real.normedField)
                (fun (ξ τ : Real) =>
                  @DFunLike.coe.{1, 1, 1}
                    (@LinearEquiv.{0, 0, 0, 0} Real Real Real.semiring Real.semiring
                      (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring))
                      (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring))
                      (@RingHomInvPair.ids.{0} Real Real.semiring) (@RingHomInvPair.ids.{0} Real Real.semiring)
                      (Fin m → Real) (Fin m → Real)
                      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        Real.instAddCommMonoid)
                      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                          (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                            (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)))
                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          (@NormedField.toNormedSpace.{0} Real Real.normedField)))
                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                        (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                          (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                            (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)))
                        (@Semiring.toModule.{0} Real Real.semiring)))
                    (Fin m → Real) (fun (x : Fin m → Real) => Fin m → Real)
                    (@EquivLike.toFunLike.{1, 1, 1}
                      (@LinearEquiv.{0, 0, 0, 0} Real Real Real.semiring Real.semiring
                        (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring))
                        (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring))
                        (@RingHomInvPair.ids.{0} Real Real.semiring) (@RingHomInvPair.ids.{0} Real Real.semiring)
                        (Fin m → Real) (Fin m → Real)
                        (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                          Real.instAddCommMonoid)
                        (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                          @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                              (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)))
                        (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                          (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                            (@NormedField.toNormedSpace.{0} Real Real.normedField)))
                        (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                              (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)))
                          (@Semiring.toModule.{0} Real Real.semiring)))
                      (Fin m → Real) (Fin m → Real)
                      (@DFinsupp.instEquivLikeLinearEquiv.{0, 0, 0, 0} Real Real Real.semiring Real.semiring
                        (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring))
                        (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring))
                        (@RingHomInvPair.ids.{0} Real Real.semiring) (@RingHomInvPair.ids.{0} Real Real.semiring)
                        (Fin m → Real) (Fin m → Real)
                        (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                          Real.instAddCommMonoid)
                        (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                          @NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                              (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)))
                        (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                          (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                            (@NormedField.toNormedSpace.{0} Real Real.normedField)))
                        (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                              (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)))
                          (@Semiring.toModule.{0} Real Real.semiring))))
                    (@Module.Basis.equivFun.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        Real.instAddCommMonoid)
                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          (@NormedField.toNormedSpace.{0} Real Real.normedField)))
                      (@Finite.of_fintype.{0} (Fin m) (Fin.fintype m)) b)
                    (q ξ τ) i)
                (speeds i) x t))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `Mathlib.Analysis.Calculus.FDeriv.Linear`, `Mathlib.Analysis.Normed.Module.FiniteDimension`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsConstantCoefficientLinearSystemSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9f446c6a55d9b32fb90ad5c7e8a268b2f8a27356a6502bbbe96f19a301dcb625`

Hash-verified prior declaration review:

- Reuse SHA-256: `19e415a12e1dcafde51b0f10f20a06dda7ff944ebe4d4cce1adcdb7e558a34b3`
- Reviewed interpretation: There exist time and space derivative vectors of the corresponding one-variable slices at t and x, whose sum qt + A qx is zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D002: `NumStability.IsLinearAdvectionSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `de66a86c2ecf305cf1671383f03d73969b60775294075abac7328c909216e754`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → Real → E) → Real → Real → Real → Prop
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (q : Real → Real → E) → (speed x t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] q speed x t =>
  Exists fun qt =>
    Exists fun qx =>
      And (HasDerivAt (fun τ => q x τ) qt t)
        (And (HasDerivAt (fun ξ => q ξ t) qx x) (Eq (instHAdd.hAdd qt (instHSMul.hSMul speed qx)) 0))
```

### D003: `NumStability.IsRealHyperbolicMatrix`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D004: `NumStability.IsConstantCoefficientLinearSystemSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `57490fb22b43764f68cb9cff131e2e74230fbaf0188d50d22f1fb4537dc5cfe8`

Hash-verified prior declaration review:

- Reuse SHA-256: `f5915f1105d3367ed94c1130d7cff01783708b78b87d0eead7ee9d00d69f65d6`
- Reviewed interpretation: Real scalar multiplication on real-valued functions is continuous for the displayed pointwise action and product topology.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D005: `NumStability.IsLinearAdvectionSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `627af0185f9dc545c0feb87577da62578e1f74ad79dcdc19dbbce58a2e697e79`

Type:

```lean
∀ {E : Type u_1} [inst : NormedAddCommGroup E] [inst_1 : NormedSpace Real E], ContinuousSMul Real E
```

Fully explicit type:

```lean
∀ {E : Type u_1} [inst : NormedAddCommGroup.{u_1} E]
  [inst_1 : @NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)],
  @ContinuousSMul.{0, u_1} Real E
    (@SMulZeroClass.toSMul.{0, u_1} Real E
      (@AddZero.toZero.{u_1} E
        (@AddZeroClass.toAddZero.{u_1} E
          (@AddMonoid.toAddZeroClass.{u_1} E
            (@SubNegMonoid.toAddMonoid.{u_1} E
              (@AddGroup.toSubNegMonoid.{u_1} E
                (@AddCommGroup.toAddGroup.{u_1} E (@NormedAddCommGroup.toAddCommGroup.{u_1} E inst)))))))
      (@DistribSMul.toSMulZeroClass.{0, u_1} Real E
        (@AddMonoid.toAddZeroClass.{u_1} E
          (@SubNegMonoid.toAddMonoid.{u_1} E
            (@AddGroup.toSubNegMonoid.{u_1} E
              (@AddCommGroup.toAddGroup.{u_1} E (@NormedAddCommGroup.toAddCommGroup.{u_1} E inst)))))
        (@DistribMulAction.toDistribSMul.{0, u_1} Real E
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real
              (@DivisionSemiring.toSemiring.{0} Real
                (@Semifield.toDivisionSemiring.{0} Real
                  (@Field.toSemifield.{0} Real
                    (@NormedField.toField.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (@SubNegMonoid.toAddMonoid.{u_1} E
            (@AddGroup.toSubNegMonoid.{u_1} E
              (@AddCommGroup.toAddGroup.{u_1} E (@NormedAddCommGroup.toAddCommGroup.{u_1} E inst))))
          (@Module.toDistribMulAction.{0, u_1} Real E
            (@DivisionSemiring.toSemiring.{0} Real
              (@Semifield.toDivisionSemiring.{0} Real
                (@Field.toSemifield.{0} Real
                  (@NormedField.toField.{0} Real
                    (@NontriviallyNormedField.toNormedField.{0} Real
                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))
            (@AddCommGroup.toAddCommMonoid.{u_1} E (@NormedAddCommGroup.toAddCommGroup.{u_1} E inst))
            (@NormedSpace.toModule.{0, u_1} Real E Real.normedField
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst) inst_1)))))
    (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
    (@UniformSpace.toTopologicalSpace.{u_1} E
      (@PseudoMetricSpace.toUniformSpace.{u_1} E
        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_1} E
          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst))))
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

Hash-verified prior declaration review:

- Reuse SHA-256: `17e5ffd270194c7dec4b2ddf0050297343cd3e6b928993588a137c9ed521a917`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

### D010: `DFinsupp.instEquivLikeLinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.DFinsupp`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D011: `DFunLike.coe`

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

### D012: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `4000f75012379631656a9631c0376965972a9369eefe53810504d81e7baf7b41`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D013: `EquivLike.toFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Equiv`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D014: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `bb4e088611b5f4df1a21b853f69df12f84eb8b00a888eafb6a59a2fdffa7fece`
- Reviewed interpretation: Existential quantification over a specified type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D015: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Hash-verified prior declaration review:

- Reuse SHA-256: `f43046a6ca48f8a759a2a2b1a1cf4ace1863f9e4b84801e4e15087483f88c63c`
- Reviewed interpretation: The standard finite index type of natural numbers below its parameter.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D016: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Hash-verified prior declaration review:

- Reuse SHA-256: `cf0e132db2333d75b949ee68e947e920af4b00ede2ec3c5638cd8dc1907bfc27`
- Reviewed interpretation: Enumerates Fin n using List.finRange n, with completeness and absence of duplicates.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D017: `Finite.of_fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.EquivFin`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `8a362cb92578339d2e0072cb2b7c96e4f74c5bef6c30d5cd088db22484affbce`

Type:

```lean
∀ (α : Type u_4) [Fintype α], Finite α
```

Fully explicit type:

```lean
∀ (α : Type u_4) [Fintype.{u_4} α], Finite.{u_4 + 1} α
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

### D020: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Hash-verified prior declaration review:

- Reuse SHA-256: `871bd320399b574d805803bc75f25e55684cd74fa2c2f5c3606d015f6c3dab74`
- Reviewed interpretation: Logical equivalence.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D021: `LinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Equiv.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
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

### D022: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Hash-verified prior declaration review:

- Reuse SHA-256: `e1d1f120dd54d2a9da5f5880b9d570d16f8b252832371f8347c91e8c24ac3b7d`
- Reviewed interpretation: A matrix is a function from row indices to column indices to entries.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D023: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `715de3f0bd9e7bcf034726e1efbf1b4dad42a16e2ce790d4403774d16ed5b549`

Hash-verified prior declaration review:

- Reuse SHA-256: `a650ead9e0e1e53236fd45f14bb80386d15d20f26d6d1ddd9c8b46aff9c234fe`
- Reviewed interpretation: At row i, takes the dot product of row M i with the input vector.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D024: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
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

### D025: `Module.Basis.equivFun`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `05c3bc81fc32094ac664c9365e161892cec28ee26504433f4636eed674f4bfee`

Type:

```lean
{ι : Type u_1} →
  {R : Type u_3} →
    {M : Type u_6} →
      [inst : Semiring R] →
        [inst_1 : AddCommMonoid M] →
          [inst_2 : Module R M] → [Finite ι] → Module.Basis ι R M → LinearEquiv (RingHom.id R) M (ι → R)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {R : Type u_3} →
    {M : Type u_6} →
      [inst : Semiring.{u_3} R] →
        [inst_1 : AddCommMonoid.{u_6} M] →
          [inst_2 : @Module.{u_3, u_6} R M inst inst_1] →
            [Finite.{u_1 + 1} ι] →
              (b : @Module.Basis.{u_1, u_3, u_6} ι R M inst inst_1 inst_2) →
                @LinearEquiv.{u_3, u_3, u_6, max u_1 u_3} R R inst inst
                  (@RingHom.id.{u_3} R (@Semiring.toNonAssocSemiring.{u_3} R inst))
                  (@RingHom.id.{u_3} R (@Semiring.toNonAssocSemiring.{u_3} R inst)) (@RingHomInvPair.ids.{u_3} R inst)
                  (@RingHomInvPair.ids.{u_3} R inst) M (ι → R) inst_1
                  (@Pi.addCommMonoid.{u_1, u_3} ι (fun (a : ι) => R) fun (i : ι) =>
                    @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_3} R
                      (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_3} R
                        (@Semiring.toNonAssocSemiring.{u_3} R inst)))
                  inst_2
                  (@Pi.Function.module.{u_1, u_3, u_3} ι R R inst
                    (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_3} R
                      (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_3} R
                        (@Semiring.toNonAssocSemiring.{u_3} R inst)))
                    (@Semiring.toModule.{u_3} R inst))
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {R} {M} [Semiring R] [AddCommMonoid M] [Module R M] [Finite ι] b =>
  b.repr.trans
    (let __src := Finsupp.equivFunOnFinite;
    { toFun := Finsupp.instFunLike.coe, map_add' := ⋯, map_smul' := ⋯, invFun := __src.invFun, left_inv := ⋯,
      right_inv := ⋯ })
```

### D026: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D027: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Hash-verified prior declaration review:

- Reuse SHA-256: `ad7c05ecc75427dbf992e5722af4bb3b15cb307191c388c4ce87db94cd45fef0`
- Reviewed interpretation: Natural numbers, including zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D028: `NonAssocSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D029: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Hash-verified prior declaration review:

- Reuse SHA-256: `6cbc4d58128eeaa6362775c3541af6311c23d2e773d4706749815411451d4d80`
- Reviewed interpretation: Retains the underlying ring operations while forgetting associativity structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D030: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Hash-verified prior declaration review:

- Reuse SHA-256: `2015dd70f3007bc688813ca165ec951d8833871b921c59587da16dd169c4f9de`
- Reviewed interpretation: Projects the underlying nonassociative ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D031: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `62e83c6fedababbe61b62d173ac5c6f6e290256dd1df326c7cd19869311983f8`
- Reviewed interpretation: Builds a semiring structure with the original addition and multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D032: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Hash-verified prior declaration review:

- Reuse SHA-256: `c7eeab7b7397b57825b9876f9befdf30e9f8ecb4f346459161d511df12fd1199`
- Reviewed interpretation: Projects the additive commutative monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D033: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Hash-verified prior declaration review:

- Reuse SHA-256: `7e5f55499883069c6c93475553739164506cba4d5b5f6ae0e1b7bc4e83ecad2f`
- Reviewed interpretation: Retains ring operations and commutativity while dropping norm structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D034: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `cb72a1b07c5721ad71dffb26948c4c52be5059b1e2e8987e1c069eecccfa239a`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D035: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `8e428916292a9b2a4bc3bf536e525c568f3d04e0e88164b3b9f0807afa81ce41`
- Reviewed interpretation: Retains the norm, additive group, and pseudometric of the supplied ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D036: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Hash-verified prior declaration review:

- Reuse SHA-256: `fb4a9ccbaf9847e2896be8eac99b456b12bfc53b1afaef24deb954fbca299167`
- Reviewed interpretation: Copies the norm, metric, and ring operations into the structure without a unit requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D037: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `b172764c02de70c0436581c995a725b4f856ed4c4f6879581c1695d2462feac8`
- Reviewed interpretation: Retains the norm, ring, and induced pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D038: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Hash-verified prior declaration review:

- Reuse SHA-256: `19c9b65bc17bb9aafc8dc4aaf30f77da2686a2cca5dd71a2f07d17fc321f8f3e`
- Reviewed interpretation: A normed field acts on itself through its semiring module structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D039: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Hash-verified prior declaration review:

- Reuse SHA-256: `0df0a3658a4f525b9b881dc4a35bf0461d262242f4eec76a79cf868a46caca71`
- Reviewed interpretation: Projects the underlying module.

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

### D041: `Pi.addCommMonoid`

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

### D042: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `d4ec78d5337e0d040dbcd79226effb344a2f5ff8c203dc715578f8f162929ebc`
- Reviewed interpretation: The standard library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D043: `Real.instAddCommMonoid`

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

### D044: `Real.instCommSemiring`

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

### D045: `Real.normedAddCommGroup`

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

### D046: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Hash-verified prior declaration review:

- Reuse SHA-256: `a22099cec7363f14dc4618169a02614c904db6888e5b48ee205f5285d6af569a`
- Reviewed interpretation: Combines the real normed additive group and real commutative ring, retaining their operations and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D047: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Hash-verified prior declaration review:

- Reuse SHA-256: `5e1943867892ca805d381a467966d1001662d7c500a6a4d7c1b886256409031b`
- Reviewed interpretation: Combines the real field with its normed additive group and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D048: `Real.semiring`

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

### D049: `RingHom.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Hom.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D050: `RingHomInvPair.ids`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.CompTypeclasses`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `75744d500e14f69cfc3fbf4fd4d295a518f1364aa4c594f245ffbf676740f3a1`

Type:

```lean
∀ {R₁ : Type u_1} [inst : Semiring R₁], RingHomInvPair (RingHom.id R₁) (RingHom.id R₁)
```

Fully explicit type:

```lean
∀ {R₁ : Type u_1} [inst : Semiring.{u_1} R₁],
  @RingHomInvPair.{u_1, u_1} R₁ R₁ inst inst (@RingHom.id.{u_1} R₁ (@Semiring.toNonAssocSemiring.{u_1} R₁ inst))
    (@RingHom.id.{u_1} R₁ (@Semiring.toNonAssocSemiring.{u_1} R₁ inst))
```

### D051: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `f5127a24c2bd42468edc21be404e494bd139e5ed3ac4e71607157f12152bd861`
- Reviewed interpretation: Retains norm, pseudometric, and ring operations while omitting unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D052: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D053: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D054: `instHSMul`

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

### D055: `AddCommGroup.toDivisionAddCommMonoid`

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

### D056: `AddCommMagma.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `78a12fabc3611bc39705a2dcf3fa82ed1f226d804e888d57546b885fefae4453`

Type:

```lean
{G : Type u} → [self : AddCommMagma G] → Add G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommMagma.{u} G] → Add.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : AddCommMagma G] => self.1
```

### D057: `AddCommMonoid.toAddCommSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `dc7cae9f3611bf7a48fc6ba815db5cffeba3ac95ae33d26bec77b827bd041f26`

Type:

```lean
{M : Type u} → [self : AddCommMonoid M] → AddCommSemigroup M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddCommMonoid.{u} M] → AddCommSemigroup.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toAddSemigroup := self.toAddSemigroup, add_comm := ⋯ }
```

### D058: `AddCommSemigroup.toAddCommMagma`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `78f90c6bc01ad86e28d84a9011670656947204c6d8963785407a1b8eb54844ab`

Type:

```lean
{G : Type u} → [self : AddCommSemigroup G] → AddCommMagma G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommSemigroup.{u} G] → AddCommMagma.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toAdd := self.toAdd, add_comm := ⋯ }
```

### D059: `AddMonoid.toAddZeroClass`

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

### D060: `AddZero.toZero`

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

### D061: `AddZeroClass.toAddZero`

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

### D062: `CommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D063: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Hash-verified prior declaration review:

- Reuse SHA-256: `ba068f9f071f1cc1143b56d3d85b68a77ce2f0a0be1b5e31f8fd378ae54ad3cf`
- Reviewed interpretation: Retains the supplied normed field and establishes its nontrivial norm.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D064: `DistribMulAction.toDistribSMul`

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

### D065: `DistribSMul.toSMulZeroClass`

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

### D066: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `587c80a71f9aa5749b5d6c35c97cdae1067fa669257c865951843b747c511934`

Hash-verified prior declaration review:

- Reuse SHA-256: `444b01f51eb0e3c83606ff50db9e432f9f608ed1e0eca1f1485f5c03c5868470`
- Reviewed interpretation: Projects the underlying semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D067: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

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

### D068: `ESeminormedAddCommMonoid.toAddCommMonoid`

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

### D069: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

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

### D070: `ESeminormedAddMonoid.toAddMonoid`

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

### D071: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9a6353c2087dc0f4123f4079d947842f8b7bc1fc0c77de170382c04e31608fd4`

Hash-verified prior declaration review:

- Reuse SHA-256: `1bb55b5ee18f1c041d3d9f01dc149ca0de8471bb698256ca8b6e858e6a7e05d4`
- Reviewed interpretation: Builds the semifield structure using the field's existing arithmetic and inverse operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D072: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Hash-verified prior declaration review:

- Reuse SHA-256: `66b439dba842d0d74323170ad9e6e1ce0d76c7ff87de8ce877d1cd64929fcc02`
- Reviewed interpretation: A finite enumeration structure on an index type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D073: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `10c5813e105516579d20241809ea8d5791151148a521e7ae020b0d584f37cc4e`
- Reviewed interpretation: Extracts the addition operation from the supplied HAdd instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D074: `HasDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.Deriv.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `425ec9578fd20d63923b9588cbb7761a6e92f281528630fe03d0dc3dc1bc60a2`

Hash-verified prior declaration review:

- Reuse SHA-256: `a7756d0af6e15c7f0bc435b1f4b7fd465855ece7a898d2a323ea8494685be605`
- Reviewed interpretation: Derivative assertion at a point, obtained from HasDerivAtFilter with the neighborhood filter in the varying argument and the fixed base point.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D075: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Hash-verified prior declaration review:

- Reuse SHA-256: `dccd2341d9980de473862ce23aa7f7f74eb39025a788559534b0ca64139d781a`
- Reviewed interpretation: Projects the distributive scalar action from a module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D076: `NegZeroClass.toZero`

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

### D077: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Hash-verified prior declaration review:

- Reuse SHA-256: `478c1f6bee04848f6eefe5367a774c1bf72b16aca665075b226c4989bcb82ac5`
- Reviewed interpretation: Projects the underlying nonassociative semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D078: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `dc08b02d757cccbd21bce550b40d3f76d2ee704ec2cd7f5507023d827296474f`

Hash-verified prior declaration review:

- Reuse SHA-256: `92453fea269fe9726f0a6d37abb0eeacb7bb3a824b731851065d82eb26e4a2ce`
- Reviewed interpretation: Projects the supplied normed field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D079: `NormedAddCommGroup`

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

### D080: `NormedAddCommGroup.toAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D081: `NormedAddCommGroup.toENormedAddCommMonoid`

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

### D082: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D083: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `ec9eab2d54099c52c160e626a54324e8c9a07675797f0926435031098f363e5f`

Hash-verified prior declaration review:

- Reuse SHA-256: `3a6a3c7cca5f35abd1c23189b4c053a94e3d9a3f064483eb2b0e72d92583d86b`
- Reviewed interpretation: Projects the underlying field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D084: `NormedSpace`

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

### D085: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `f2254a4f5183c923095df7513cabbe9bd75270bf1b4e4283233923d8e0c634dd`
- Reviewed interpretation: Extracts the value assigned to a natural-number literal by its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D086: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Hash-verified prior declaration review:

- Reuse SHA-256: `8aa06e5ff7ee66166da6b4c4a1edeb62e37fe2be9027bae6f151934f6fe05f00`
- Reviewed interpretation: Builds the additive commutative group of functions from coordinate additive groups.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D087: `Pi.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `786aa93e85ac0acc746f4c8ee6aed957d52e0231f66623c2b8e478a794d15ce0`

Hash-verified prior declaration review:

- Reuse SHA-256: `d5410486b740ade47036dca5438e8485b5bfaaeb5ce954d0f5486eb4f07481d1`
- Reviewed interpretation: Adds functions by adding their values at each index.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D088: `Pi.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb5c70d9b813d7099537e8db11f59a65a3f5ad951da7314a1aa554471a122049`

Hash-verified prior declaration review:

- Reuse SHA-256: `7be542126e16ceca6e6940e9e603d91ee682234b55d17ce7ac97a847d8f2ca7b`
- Reviewed interpretation: The zero function takes the zero value at every index.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D089: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `a81381c20af462683322c70d792fc61454007e60d0781bb4fda6103a009c8abd`

Hash-verified prior declaration review:

- Reuse SHA-256: `78be41fb4aad54230ad5e8109dcd0181eb1c346e25bf78f66db3b9ca892c2001`
- Reviewed interpretation: The product topology is constructed from the induced topologies of coordinate evaluations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D090: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Hash-verified prior declaration review:

- Reuse SHA-256: `a473e1d495b6df39c966b66346b94acb138308b4f6eaeac09b84b295a55391d1`
- Reviewed interpretation: Projects the uniform space associated with the pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D091: `Real.commRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D092: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Hash-verified prior declaration review:

- Reuse SHA-256: `88d146a624bdd0a2934a55af0a4dbef151f45a29cf2c3d86e5d550098dff727e`
- Reviewed interpretation: Equips Real with its normed field and the dense-norm property.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D093: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Hash-verified prior declaration review:

- Reuse SHA-256: `0de095891cee11bdd5f17463e8870481a798eacfd8d807112bd37f548efb0807`
- Reviewed interpretation: Selects Real.add as real addition.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D094: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Hash-verified prior declaration review:

- Reuse SHA-256: `97c87e2ca05acde5343583a352fd3c3d9f4eb98f15db87eb033f5f47088ed2cc`
- Reviewed interpretation: Supplies the standard inferred additive commutative group of Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D095: `Real.instMonoid`

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

### D096: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Hash-verified prior declaration review:

- Reuse SHA-256: `f047c06f9327cb71406a14ac4d9b7ba8146a2193b93238ad71dd4ee97d25ac0e`
- Reviewed interpretation: Supplies the inferred ring structure on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D097: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `640ce2f311f557bc43388a68140a7fc8c3ddd535f819543863ee7c9a137bb3f4`
- Reviewed interpretation: Selects Real.zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D098: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `51efb720a0b706147ddb3a3db48a916ac10099f58d340725de93e68981b515a1`
- Reviewed interpretation: The distance between x and y is abs(x - y).

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D099: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Hash-verified prior declaration review:

- Reuse SHA-256: `ea8231d9603326ef7a12fb04a13d45183f5ca4a00af6d83904889cf13a722ce4`
- Reviewed interpretation: Projects the underlying semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D100: `SMulZeroClass.toSMul`

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

### D101: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `a1b771abeff9bbbdcce988134973a1a367c44a340bcd29acb0cc44b8d6a2e55c`

Hash-verified prior declaration review:

- Reuse SHA-256: `89388a30ff10a156fd4a8ccb8b6096a733052e3c6d335b0c63579dfff16d9f63`
- Reviewed interpretation: Retains arithmetic and inverses in the division-semiring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D102: `SeminormedAddCommGroup.toPseudoMetricSpace`

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

### D103: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Hash-verified prior declaration review:

- Reuse SHA-256: `86e7a8a8da804f182999194680637c3e374fc9f2af81ac70e446d79ccb94c3c1`
- Reviewed interpretation: Projects the underlying semiring without unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D104: `SubNegZeroMonoid.toNegZeroClass`

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

### D105: `SubtractionCommMonoid.toSubtractionMonoid`

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

### D106: `SubtractionMonoid.toSubNegZeroMonoid`

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

### D107: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Hash-verified prior declaration review:

- Reuse SHA-256: `441c33420d0d0b87c37f83cffb6f5dbdce1d9e80205758c2f4dad7875ce8e34f`
- Reviewed interpretation: Projects the underlying topology of a uniform space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D108: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `f2d7dd078f0ae401fbc2ac8427dabceabf98115ae7db96ecb306f450ac67e002`
- Reviewed interpretation: Interprets the literal 0 as the supplied zero element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D109: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `9648f013ecf35efb66416b4f1ef7b262dc202826e8fb366cb59b368f03a55137`
- Reviewed interpretation: Uses the supplied homogeneous addition as heterogeneous addition with all types equal.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D110: `AddCommGroup.toAddCommMonoid`

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

### D111: `AddCommGroup.toAddGroup`

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

### D112: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `98c22aec54da8e2278fb6c5ae1daeffb76abd7bad320de72096bec6a7046bc17`

Hash-verified prior declaration review:

- Reuse SHA-256: `7c303dac5a25321a3fcd95d3e3559fc4e0081207f8fa717312b01519aa532f99`
- Reviewed interpretation: Projects the underlying additive monoid without changing operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D113: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D114: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Hash-verified prior declaration review:

- Reuse SHA-256: `6aecef9a9cfe3765f65990890fb2a292b822f8d1f640280f7747ea2fdd323169`
- Reviewed interpretation: The proposition that the supplied scalar action is jointly continuous in the supplied topologies.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D115: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ea6124156f152313d3298dd94738351217f9626c6fc23cb2b63efa1528a4f9b9`

Hash-verified prior declaration review:

- Reuse SHA-256: `776ed30714a90b57c0c8b534126cd1db28dec55c6d4869d631481a8710a9dafd`
- Reviewed interpretation: Projects the multiplicative action from a distributive action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D116: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `136930a747dcd73895587cb4c7ea1df27360fed0a4adb57efb71bb8949f0fa71`

Hash-verified prior declaration review:

- Reuse SHA-256: `83b659b939f302b495f15850e170b4170434718a104ef827b1bc1c5388ec5329`
- Reviewed interpretation: Projects the underlying semigroup.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D117: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Hash-verified prior declaration review:

- Reuse SHA-256: `ea5462f911bbf35c86737d0233cd6c7edb311ba3341350476d907f60b3118c4d`
- Reviewed interpretation: Projects the underlying multiplicative monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D118: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `2a4074e38a7cedd1ecdaf86a42d3be01ad9728988610178bf9a698f57a876516`

Hash-verified prior declaration review:

- Reuse SHA-256: `116a0c1c027d1a2f129069c7ae3f1dbc3dfe0f9e3116d20efe2ac8136aa9283d`
- Reviewed interpretation: Projects the underlying semigroup action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D119: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4aa3dba57859ca72552799005279a2b5a65b8c083980070fbbff11fd1de56dec`

Hash-verified prior declaration review:

- Reuse SHA-256: `fdf2729c8fb589ab3ca00d04e61de4b21321bffe481b33f75189060ecf67b26f`
- Reviewed interpretation: Retains the norm, ring, and metric of the field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D120: `Pi.instSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `adba1d4e42926a50c2701c18af6f5749dd72a4d631113b924c96482924951276`

Hash-verified prior declaration review:

- Reuse SHA-256: `2716779d9160f173589a00d6d6fc70dd7586f62acf0004d4e4bfb8f7df51bdce`
- Reviewed interpretation: Defines scalar multiplication on functions by scaling every coordinate value.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D121: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `5a8783c66a2e56a4cc509bbb0651eda5b66e25c197307a42445cac31c4a4bb6c`

Hash-verified prior declaration review:

- Reuse SHA-256: `04e2f60464b56d7bf364cd339eb49af8a7c34b5b8f32dfff8e082c36fbea182f`
- Reviewed interpretation: Projects the scalar multiplication operation of an action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D122: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e3cbc92d1d5e37d9eaeb1d595c83a78f7af7e3a8d249a700fa3676ab4e0c3d60`

Hash-verified prior declaration review:

- Reuse SHA-256: `bc47356114a14c38cdc484c7f48c148254c5d32b24c8d2442bdb508f5a2cb6c5`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D123: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e6ea9296e8643d5ae7cf334c065c9d6ebe4a95de22d3b0708a585db80e17322a`

Hash-verified prior declaration review:

- Reuse SHA-256: `5397ca75850aae275b2fdcb8312c4acd660be5d3e70c4bdb6b8bf901df2356b4`
- Reviewed interpretation: Projects the supplied pseudometric space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D124: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Hash-verified prior declaration review:

- Reuse SHA-256: `9371b6e645f0a48067ae94c9ab31207938a9cc6329dec6ade18536da264bf8a8`
- Reviewed interpretation: Retains multiplication, one, powers, and zero of the semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D125: `SubNegMonoid.toAddMonoid`

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
