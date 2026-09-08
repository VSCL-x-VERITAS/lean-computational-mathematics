# Declaration dossier for LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_linearFlux_specializesEquation01
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (x t : ℝ)
    (qx : Fin m → ℝ)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x) :
    leveque01_equation08_conservationLawAt q
        (constantLinearFlux coefficient) x t ↔
      leveque01_equation01_constantLinearSystemAt q coefficient x t
```

## Elaborated target type

```lean
∀ {m : Nat} (q : Real → Real → Fin m → Real) (coefficient : Matrix (Fin m) (Fin m) Real) (x t : Real)
  (qx : Fin m → Real),
  HasDerivAt (fun ξ => q ξ t) qx x →
    Iff (NumStability.leveque01_equation08_conservationLawAt q (NumStability.constantLinearFlux coefficient) x t)
      (NumStability.leveque01_equation01_constantLinearSystemAt q coefficient x t)
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} (q : Real → Real → Fin m → Real) (coefficient : Matrix.{0, 0, 0} (Fin m) (Fin m) Real) (x t : Real)
  (qx : Fin m → Real)
  (hqx :
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
          (@NormedField.toNormedSpace.{0} Real Real.normedField)))
      (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
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
        (Fin m) (fun (a : Fin m) => Real)
        (fun (i : Fin m) =>
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
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
                            (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)))))))))
            (@MulAction.toSemigroupAction.{0, 0} Real ((fun (a : Fin m) => Real) i)
              (@MonoidWithZero.toMonoid.{0} Real
                (@Semiring.toMonoidWithZero.{0} Real
                  (@DivisionSemiring.toSemiring.{0} Real
                    (@Semifield.toDivisionSemiring.{0} Real
                      (@Field.toSemifield.{0} Real
                        (@NormedField.toField.{0} Real
                          (@NontriviallyNormedField.toNormedField.{0} Real
                            (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
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
                                  (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
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
                                  (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
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
      (fun (ξ : Real) => q ξ t) qx x),
  Iff
    (@NumStability.leveque01_equation08_conservationLawAt m q
      (@NumStability.constantLinearFlux.{0} (Fin m) (Fin.fintype m) coefficient) x t)
    (@NumStability.leveque01_equation01_constantLinearSystemAt m q coefficient x t)
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01`, `ComputationalMathematics.Source.LeVeque.Chapter01.Equation08`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Equation08` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.constantLinearFlux`

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

### D002: `NumStability.leveque01_equation01_constantLinearSystemAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `285187d82c6a7a268d81e52e30d6e7f46daa63680859feefa2aa617e8f8ca4e0`

Type:

```lean
{m : Nat} → (Real → Real → Fin m → Real) → Matrix (Fin m) (Fin m) Real → Real → Real → Prop
```

Fully explicit type:

```lean
{m : Nat} →
  (q : Real → Real → Fin m → Real) → (coefficient : Matrix.{0, 0, 0} (Fin m) (Fin m) Real) → (x t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} q coefficient x t => NumStability.IsConstantCoefficientLinearSystemSolutionAt q coefficient x t
```

### D003: `NumStability.leveque01_equation08_conservationLawAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.LeVeque.Chapter01.Equation08`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a0e9ea4fafcbb42d80b3a8dd5bd255b8fbfea26fa72ca82cabfa2b19af4f7d49`

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

### D004: `NumStability.IsConservationLawSolutionAt`

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

### D005: `NumStability.IsConstantCoefficientLinearSystemSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9f446c6a55d9b32fb90ad5c7e8a268b2f8a27356a6502bbbe96f19a301dcb625`

Hash-verified prior declaration review:

- Reuse SHA-256: `af9d44f338cf37d016f385637a8fe0a769d3336204c1724aed5de2131576ccef`
- Reviewed interpretation: There exist time and space derivative vectors of the corresponding one-variable slices at t and x, whose sum qt + A qx is zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D006: `NumStability.IsConservationLawSolutionAt._proof_1`

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

### D007: `NumStability.IsConstantCoefficientLinearSystemSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `57490fb22b43764f68cb9cff131e2e74230fbaf0188d50d22f1fb4537dc5cfe8`

Hash-verified prior declaration review:

- Reuse SHA-256: `d8321c6a827f9411a900d2f1f382b3b341cb28f478df2fa0d6717c52e6294889`
- Reviewed interpretation: Real scalar multiplication on real-valued functions is continuous for the displayed pointwise action and product topology.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D008: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `98c22aec54da8e2278fb6c5ae1daeffb76abd7bad320de72096bec6a7046bc17`

Hash-verified prior declaration review:

- Reuse SHA-256: `fcdaa70a84c55c3200df10451f60525aca942367d666b685a5a88f217b85216b`
- Reviewed interpretation: Projects the underlying additive monoid without changing operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D009: `ContinuousMul.to_continuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `f0c5d378c0acb7a136cec4dc063f034495e42fd5022786b7c0b6595115d372ae`

Hash-verified prior declaration review:

- Reuse SHA-256: `94daec163426ce452c29df355bf3ae2b4330a730c82d0561aba714e6515e33e4`
- Reviewed interpretation: Continuous multiplication yields a continuous self scalar action using that multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D010: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Hash-verified prior declaration review:

- Reuse SHA-256: `23c01dae02efa88ab26024e3cdb54eec92b80153fc7b269f5d88a18ceeb44aa5`
- Reviewed interpretation: Retains the supplied normed field and establishes its nontrivial norm.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D011: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ea6124156f152313d3298dd94738351217f9626c6fc23cb2b63efa1528a4f9b9`

Hash-verified prior declaration review:

- Reuse SHA-256: `aec6e0020c7ea1d3aed9b01348a14f37dd970c6092bf9d073fc450e291572de4`
- Reviewed interpretation: Projects the multiplicative action from a distributive action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D012: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `587c80a71f9aa5749b5d6c35c97cdae1067fa669257c865951843b747c511934`

Hash-verified prior declaration review:

- Reuse SHA-256: `b679ca314d6a6c18e8f80584f4b521f8782e45f72ac46736927ad2b5ca72d31e`
- Reviewed interpretation: Projects the underlying semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D013: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9a6353c2087dc0f4123f4079d947842f8b7bc1fc0c77de170382c04e31608fd4`

Hash-verified prior declaration review:

- Reuse SHA-256: `2cbee07769ecb47a026cd07b7d2fb0feb6fd675ed4c151e4c6d1597b35a9108b`
- Reviewed interpretation: Builds the semifield structure using the field's existing arithmetic and inverse operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D014: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Hash-verified prior declaration review:

- Reuse SHA-256: `d38642e8c5ce951866f4b3ce84673e59775a1e9c24e69c271e8ad6a805c7202d`
- Reviewed interpretation: The standard finite index type of natural numbers below its parameter.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D015: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Hash-verified prior declaration review:

- Reuse SHA-256: `0ac54cfa645d971be8ea9379fa65adb0918ab09483ba6393babe5067b755b2f5`
- Reviewed interpretation: Enumerates Fin n using List.finRange n, with completeness and absence of duplicates.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D016: `HasDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.Deriv.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `425ec9578fd20d63923b9588cbb7761a6e92f281528630fe03d0dc3dc1bc60a2`

Hash-verified prior declaration review:

- Reuse SHA-256: `570810dde4498574c8fc23268c0c8d189e392e56dc07e05e98ad2dc097e7a795`
- Reviewed interpretation: Derivative assertion at a point, obtained from HasDerivAtFilter with the neighborhood filter in the varying argument and the fixed base point.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D017: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Hash-verified prior declaration review:

- Reuse SHA-256: `f1962fdf80e569f7c4abfdaf2bd72571be64ad15fee1c524fa707d72d37e048a`
- Reviewed interpretation: Logical equivalence.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D018: `IsTopologicalRing.toIsTopologicalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `f55163e46531cbf77c144d47ba02dbad1720a8a16e67de32af3e47419e5ccdb7`

Hash-verified prior declaration review:

- Reuse SHA-256: `da0c93b83cc16f1d4a1800a67f99d1813a59ebdc3a5ddae317d263b4bada4546`
- Reviewed interpretation: Transfers continuity properties to the underlying semiring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D019: `IsTopologicalSemiring.toContinuousMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `fd5dd952a3c3566c14b553c40684808260a448d4b7c6fa7c23e9084603af65f5`

Hash-verified prior declaration review:

- Reuse SHA-256: `9e035a1ba9a2840e5a285fc7905a6ed4b81fbea920e84a7a401b98000fa65edc`
- Reviewed interpretation: Extracts continuity of multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D020: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Hash-verified prior declaration review:

- Reuse SHA-256: `0cfe1730c087bf6edea335331b7d5952cf291f22e6c84d9673e2453c480a8e01`
- Reviewed interpretation: A matrix is a function from row indices to column indices to entries.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D021: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Hash-verified prior declaration review:

- Reuse SHA-256: `93763ce28a89ccfec0801a39663b9b34e83236443524a3a4758edcefece2ca07`
- Reviewed interpretation: Projects the distributive scalar action from a module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D022: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `136930a747dcd73895587cb4c7ea1df27360fed0a4adb57efb71bb8949f0fa71`

Hash-verified prior declaration review:

- Reuse SHA-256: `73bf30cb6ab2eb0514194b3476ecf9a0088b782ab616346aae4f57fdd369e44d`
- Reviewed interpretation: Projects the underlying semigroup.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D023: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Hash-verified prior declaration review:

- Reuse SHA-256: `44c70f108c9f07966cd5583a3e69e8f3dfbaed347966a3eb4e155ac6f3b81d6c`
- Reviewed interpretation: Projects the underlying multiplicative monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D024: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `2a4074e38a7cedd1ecdaf86a42d3be01ad9728988610178bf9a698f57a876516`

Hash-verified prior declaration review:

- Reuse SHA-256: `83810218b78bf9a5996fc0b4fdc98bb94bb3f9612169d5ee661d69de65e3b813`
- Reviewed interpretation: Projects the underlying semigroup action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D025: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Hash-verified prior declaration review:

- Reuse SHA-256: `9dabeb17cdefb8f6bac6a29c85fde60883982d4ea91081d39fb9cf6820c28203`
- Reviewed interpretation: Natural numbers, including zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D026: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Hash-verified prior declaration review:

- Reuse SHA-256: `b4a1a5e570f4c0bd88ab3b26c98f49942b734c4be180ef6b83999775a81d99c0`
- Reviewed interpretation: Retains the underlying ring operations while forgetting associativity structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D027: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Hash-verified prior declaration review:

- Reuse SHA-256: `61aaabf9143287ebcb06aa126ee1b9ed3010e95b45687d36d8d83239794100db`
- Reviewed interpretation: Projects the underlying nonassociative ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D028: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `027f72d066db6f10fd074fc3412655b2363d5a1b36ac5db6edaf5164d3ea0eb2`
- Reviewed interpretation: Builds a semiring structure with the original addition and multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D029: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Hash-verified prior declaration review:

- Reuse SHA-256: `cbe8eb0a627d102cde2ff16dba6b8040ea2b40a4d92a6b781db98b4f4e6e4dc9`
- Reviewed interpretation: Projects the additive commutative monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D030: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Hash-verified prior declaration review:

- Reuse SHA-256: `a737861082fb8ed262f2b1c29abba1a124b696d8ac9bfe261dbd8fe8f3c769e2`
- Reviewed interpretation: Retains ring operations and commutativity while dropping norm structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D031: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `94cbe5e0b93406dd0e40cd87bf17af720fa88d99c1a422a9323dcafda08a07ac`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D032: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `d368d936a1d6f72fa825eefefdfa7b45e2834ef0731a0decc42d0007c612f595`
- Reviewed interpretation: Retains the norm, additive group, and pseudometric of the supplied ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D033: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Hash-verified prior declaration review:

- Reuse SHA-256: `6e1ec60a7e5c1a4f290a7d0a3f673d24005e18cd6aa66271bea6aefca77b4965`
- Reviewed interpretation: Projects the underlying nonassociative semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D034: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `dc08b02d757cccbd21bce550b40d3f76d2ee704ec2cd7f5507023d827296474f`

Hash-verified prior declaration review:

- Reuse SHA-256: `f52712241eed4f4a43b9269e3c286f896c4ebb2b045d6b200d09e146510b1e37`
- Reviewed interpretation: Projects the supplied normed field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D035: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Hash-verified prior declaration review:

- Reuse SHA-256: `d5e7638b05005c85ab791dee04360b92511cce06d52f1b1739a74396c39309cc`
- Reviewed interpretation: Copies the norm, metric, and ring operations into the structure without a unit requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D036: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `1af06263ab38820b5060f92ebb7859239097fc45fd3dbab2cc9910d649635ab2`
- Reviewed interpretation: Retains the norm, ring, and induced pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D037: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ec9eab2d54099c52c160e626a54324e8c9a07675797f0926435031098f363e5f`

Hash-verified prior declaration review:

- Reuse SHA-256: `99ef073fb91f226e7fae9cb60a071f8120fe4214f3ce4734cde89a69aa28c400`
- Reviewed interpretation: Projects the underlying field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D038: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4aa3dba57859ca72552799005279a2b5a65b8c083980070fbbff11fd1de56dec`

Hash-verified prior declaration review:

- Reuse SHA-256: `bc2f9c7a69f2261aaa685e416e4febc33978f0cf26a2bf13fce1f168efa4068d`
- Reviewed interpretation: Retains the norm, ring, and metric of the field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D039: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Hash-verified prior declaration review:

- Reuse SHA-256: `158dc68b3617f5e6e246252203b249f047d579b04cfa684b7e8ac183eef0b412`
- Reviewed interpretation: A normed field acts on itself through its semiring module structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D040: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Hash-verified prior declaration review:

- Reuse SHA-256: `7deabc5dd1f8430efbffbc22736a81c12134f236a4a42d2d560aca3e2534dc69`
- Reviewed interpretation: Projects the underlying module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D041: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Hash-verified prior declaration review:

- Reuse SHA-256: `3058138564b12232764d365ceaae949624d9717c08e742cbafc8b98eea0f7308`
- Reviewed interpretation: Uses the product module on functions with fixed codomain.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D042: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Hash-verified prior declaration review:

- Reuse SHA-256: `91f6a3524d8f28b0b766be1e137e1a59a3a4c6bdcb54e375f989e01d82b6822e`
- Reviewed interpretation: Builds the additive commutative group of functions from coordinate additive groups.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D043: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a81381c20af462683322c70d792fc61454007e60d0781bb4fda6103a009c8abd`

Hash-verified prior declaration review:

- Reuse SHA-256: `4587eae11890de024e8ca96116c2972c1a0ae4fa2287c36512a7fa1933fad5ca`
- Reviewed interpretation: The product topology is constructed from the induced topologies of coordinate evaluations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D044: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Hash-verified prior declaration review:

- Reuse SHA-256: `e833db6a69c042afdf0a73c815950b9459ec5e43f01bcc58296ed6ca3535cd52`
- Reviewed interpretation: Projects the uniform space associated with the pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D045: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `ed296e37e30c9ea7ccf44045e2f669477bc3ae669f0121fe4ee610d3729b83be`
- Reviewed interpretation: The standard library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D046: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Hash-verified prior declaration review:

- Reuse SHA-256: `1ed3516693b3f4222da010bdd55c25ba51410c55c2e027594517c68c2df83767`
- Reviewed interpretation: Equips Real with its normed field and the dense-norm property.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D047: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Hash-verified prior declaration review:

- Reuse SHA-256: `e4049ab115cc8d18380416a197c858f98099ab54edd9db60c0566fce5d0114db`
- Reviewed interpretation: Supplies the standard inferred additive commutative group of Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D048: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Hash-verified prior declaration review:

- Reuse SHA-256: `0d213bb0417bb37f4568e8ca1f02345ed6b649439929ca0bf123651b7d54ce57`
- Reviewed interpretation: Selects Real.mul as real multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D049: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Hash-verified prior declaration review:

- Reuse SHA-256: `a94cddf7f81755d31068a188e5357983c821f69696e8803ec608acd87ecb75bf`
- Reviewed interpretation: Supplies the inferred ring structure on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D050: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Hash-verified prior declaration review:

- Reuse SHA-256: `8be14c2823edcc2a23434554606b49ca40a04b5514188bcf43f75fa3266769ea`
- Reviewed interpretation: Combines the real normed additive group and real commutative ring, retaining their operations and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D051: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Hash-verified prior declaration review:

- Reuse SHA-256: `1c86cc55abeefb81e698de73345c265a54691210486fc767edbff4c27b0a3c32`
- Reviewed interpretation: Combines the real field with its normed additive group and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D052: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `edc2b3367809554d5c4dde6c8b90a1199963c6c4d8403ea973b318c600d25d4b`
- Reviewed interpretation: The distance between x and y is abs(x - y).

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D053: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Hash-verified prior declaration review:

- Reuse SHA-256: `0926815a80211b2b0a90724de356b0d7b63e4be4c1b3dbb6098fd35e2678eb73`
- Reviewed interpretation: Projects the underlying semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D054: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a1b771abeff9bbbdcce988134973a1a367c44a340bcd29acb0cc44b8d6a2e55c`

Hash-verified prior declaration review:

- Reuse SHA-256: `9cf7f258247bfd7eb06edb7bd1444804e23232375e75d95e39d886e550818d0d`
- Reviewed interpretation: Retains arithmetic and inverses in the division-semiring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D055: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5a8783c66a2e56a4cc509bbb0651eda5b66e25c197307a42445cac31c4a4bb6c`

Hash-verified prior declaration review:

- Reuse SHA-256: `8ef02e9b7ae0f780a6e845c627d3447c8926921931841c35ef800b79f2fe40b5`
- Reviewed interpretation: Projects the scalar multiplication operation of an action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D056: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `d049c66332f50eab6768c212f031f99a55604a411026244eb6d600c5d0b3be3d`
- Reviewed interpretation: Retains norm, pseudometric, and ring operations while omitting unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D057: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e3cbc92d1d5e37d9eaeb1d595c83a78f7af7e3a8d249a700fa3676ab4e0c3d60`

Hash-verified prior declaration review:

- Reuse SHA-256: `6c2c8752285f441db534042adbfcaf35f171a7c60fc86362c8870efe964dd988`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D058: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e6ea9296e8643d5ae7cf334c065c9d6ebe4a95de22d3b0708a585db80e17322a`

Hash-verified prior declaration review:

- Reuse SHA-256: `36982d1542f4ce359fb272e8c78ad3340a357ea10b19d960086166942b175dc5`
- Reviewed interpretation: Projects the supplied pseudometric space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D059: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Hash-verified prior declaration review:

- Reuse SHA-256: `ea36894da13c6d7a23633d84f77743b2c92c86f80e9327d6b936363238e4020a`
- Reviewed interpretation: Retains multiplication, one, powers, and zero of the semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D060: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Hash-verified prior declaration review:

- Reuse SHA-256: `eae816b2308e1e5685a28f4a3be070f961a61897123a1ab49e69ace67af7e783`
- Reviewed interpretation: Projects the underlying semiring without unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D061: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Hash-verified prior declaration review:

- Reuse SHA-256: `e56b67751169d4adb3b1602af9af7c9d6bc189c40f92a624812f3418535404dc`
- Reviewed interpretation: Projects the underlying topology of a uniform space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D062: `instContinuousSMulForall`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `d3a31448b115a308914d59b4064d02d2b1d44ef7866e1b111c3a417657355fbb`

Hash-verified prior declaration review:

- Reuse SHA-256: `58b1a356df23c15a9038970489f1c2dcf659df9d63dc4d3e1ff3a1b8b0bdc5af`
- Reviewed interpretation: Coordinatewise continuous scalar actions induce a continuous action on the product.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D063: `instIsTopologicalRingReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Real`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `74697a527ce10426ad50966a34f3375374c3cde51367629721e2aa0850e2f618`

Hash-verified prior declaration review:

- Reuse SHA-256: `bcbb3ae2493e40e9ef0769d48f1a6d4b702383eb2ffc46a0196abb3a640bc296`
- Reviewed interpretation: The displayed standard real topology and ring form a topological ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D064: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Hash-verified prior declaration review:

- Reuse SHA-256: `937423338478d9e953b5bf1417b47081bee7f87e14bd42a8e6efb404a0ac1b5f`
- Reviewed interpretation: A finite enumeration structure on an index type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D065: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `715de3f0bd9e7bcf034726e1efbf1b4dad42a16e2ce790d4403774d16ed5b549`

Hash-verified prior declaration review:

- Reuse SHA-256: `64bd2e979505fd2d7f877de890a81edac63d81211d81a7fd144e7e8be786553a`
- Reviewed interpretation: At row i, takes the dot product of row M i with the input vector.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D066: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `75e9af633aaa1c97f2ced50c339c9b73eb5b9f8c80011d1ac098aff284efc21b`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D067: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `a66c2bc78aac3eac0584ed1f032430e8c981c1d230b7b0bfa7f30f306908e0d0`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D068: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `c369f5fb0715d2e2638386dde918250d18316cd9d092e28b699f7d86e0bc4f8a`
- Reviewed interpretation: Existential quantification over a specified type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D069: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `b109bdae342afc313db2ac35d31f42bdde3fb1e0b62457d54570e6409a3d0351`
- Reviewed interpretation: Extracts the addition operation from the supplied HAdd instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D070: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `cb7650dde5f9687c327caa079992a1aa9724544734ff58ada17bf099ca10a8c5`
- Reviewed interpretation: Extracts the value assigned to a natural-number literal by its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D071: `Pi.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `786aa93e85ac0acc746f4c8ee6aed957d52e0231f66623c2b8e478a794d15ce0`

Hash-verified prior declaration review:

- Reuse SHA-256: `18077d60fa9d155133217ab476e6032c00904037db3ff6b7cf572ec0f9c9e6c5`
- Reviewed interpretation: Adds functions by adding their values at each index.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D072: `Pi.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `eb5c70d9b813d7099537e8db11f59a65a3f5ad951da7314a1aa554471a122049`

Hash-verified prior declaration review:

- Reuse SHA-256: `0f4c720b4f5cf1c2ad8a7d975d62acee16b0fb7ac11afc3cba0632c2992464ae`
- Reviewed interpretation: The zero function takes the zero value at every index.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D073: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Hash-verified prior declaration review:

- Reuse SHA-256: `fef3ed9f7e9b142f9263ed7fa848efc125a92c3c8a142501ae25c75af00a5c43`
- Reviewed interpretation: Selects Real.add as real addition.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D074: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `437634a5c4666e0aaef37f36fbaf9d6e4c8b36c4a3b5f93f5048b78b16fe2029`
- Reviewed interpretation: Selects Real.zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D075: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `fd6f203a4e2f5402308806836f6504395f77e92829ec449b74ed6783b6f2ef18`
- Reviewed interpretation: Interprets the literal 0 as the supplied zero element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D076: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `b2861c0137d7014dc8f7ae32cee463496ed0d9cffe1609626ce0d77a87fa557a`
- Reviewed interpretation: Uses the supplied homogeneous addition as heterogeneous addition with all types equal.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D077: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Hash-verified prior declaration review:

- Reuse SHA-256: `e690dd1eab9effc9d3fec219f98f3c5dd8b2e234495fd839078cb2a64c461766`
- Reviewed interpretation: The proposition that the supplied scalar action is jointly continuous in the supplied topologies.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D078: `Pi.instSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `adba1d4e42926a50c2701c18af6f5749dd72a4d631113b924c96482924951276`

Hash-verified prior declaration review:

- Reuse SHA-256: `b86a23431c0ef3327d2e2ad37928352a557880ba29d3a0fdbfba27879a64de7c`
- Reviewed interpretation: Defines scalar multiplication on functions by scaling every coordinate value.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.
