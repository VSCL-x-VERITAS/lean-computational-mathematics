# Declaration dossier for LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_equation02_uniformTransportModel (speed : ℝ) :
    IsRealHyperbolicMatrix (constantCoefficientScalarMatrix speed) ∧
    (∀ q x t, leveque01_equation01_constantLinearSystemAt
        (scalarAsOneComponentSystem q) (constantCoefficientScalarMatrix speed) x t ↔
      leveque01_equation02_scalarAdvectionAt q speed x t) ∧
    ∀ q : ℝ → ℝ → ℝ, IsUniformAdvection q speed →
      (Differentiable ℝ (fun x => q x 0) → IsLinearAdvectionSolution q speed) ∧
      ((∀ a b, IntervalIntegrable (fun x => q x 0) volume a b) →
        IsRectangleConservationLawSolution q (fun state => speed * state))
```

## Elaborated target type

```lean
∀ (speed : Real),
  And (NumStability.IsRealHyperbolicMatrix (NumStability.constantCoefficientScalarMatrix speed))
    (And
      (∀ (q : Real → Real → Real) (x t : Real),
        Iff
          (NumStability.leveque01_equation01_constantLinearSystemAt (NumStability.scalarAsOneComponentSystem q)
            (NumStability.constantCoefficientScalarMatrix speed) x t)
          (NumStability.leveque01_equation02_scalarAdvectionAt q speed x t))
      (∀ (q : Real → Real → Real),
        NumStability.IsUniformAdvection q speed →
          And ((Differentiable Real fun x => q x 0) → NumStability.IsLinearAdvectionSolution q speed)
            ((∀ (a b : Real), IntervalIntegrable (fun x => q x 0) Real.measureSpace.volume a b) →
              NumStability.IsRectangleConservationLawSolution q fun state => instHMul.hMul speed state)))
```

## Fully explicit elaborated target type

```lean
∀ (speed : Real),
  And
    (@NumStability.IsRealHyperbolicMatrix.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
      (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
      (NumStability.constantCoefficientScalarMatrix speed))
    (And
      (∀ (q : Real → Real → Real) (x t : Real),
        Iff
          (@NumStability.leveque01_equation01_constantLinearSystemAt
            (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) (NumStability.scalarAsOneComponentSystem q)
            (NumStability.constantCoefficientScalarMatrix speed) x t)
          (NumStability.leveque01_equation02_scalarAdvectionAt q speed x t))
      (∀ (q : Real → Real → Real),
        @NumStability.IsUniformAdvection.{0} Real q speed →
          And
            ((@Differentiable.{0, 0, 0} Real
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
                Real Real.instAddCommGroup
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
                fun (x : Real) => q x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))) →
              @NumStability.IsLinearAdvectionSolution.{0} Real Real.normedAddCommGroup
                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                q speed)
            ((∀ (a b : Real),
                @IntervalIntegrable.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NormedAddGroup.toENormedAddMonoid.{0} Real
                    (@NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
                  (fun (x : Real) => q x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
                  (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace) a b) →
              @NumStability.IsRectangleConservationLawSolution.{0} Real Real.normedAddCommGroup
                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                q fun (state : Real) =>
                @HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) speed state)))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection`, `ComputationalMathematics.Source.LeVeque.Chapter01.Equation02`, `ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Equation02` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Hyperbolicity` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `ComputationalMathematics.Source.LeVeque.Chapter01.Equation01`
- `ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity` imports: `ComputationalMathematics.Source.LeVeque.Chapter01.Equation02`, `ComputationalMathematics.Source.LeVeque.Chapter01.Hyperbolicity`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsLinearAdvectionSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `79a0cf9417959e957322b7436b05d9fb88e0201cf847734963f750a6cb94d157`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → Real → E) → Real → Prop
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (q : Real → Real → E) → (speed : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] q speed =>
  ∀ (x t : Real), NumStability.IsLinearAdvectionSolutionAt q speed x t
```

### D002: `NumStability.IsRealHyperbolicMatrix`

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

### D003: `NumStability.IsRectangleConservationLawSolution`

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

### D004: `NumStability.IsUniformAdvection`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9f7c3e16c15fbe37c85dc936dab2863bed9f30a5c6be018a93936866e2decb44`

Type:

```lean
{E : Type u_1} → (Real → Real → E) → Real → Prop
```

Fully explicit type:

```lean
{E : Type u_1} → (q : Real → Real → E) → (speed : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} q speed => ∀ (x t : Real), Eq (q (instHAdd.hAdd x (instHMul.hMul speed t)) t) (q x 0)
```

### D005: `NumStability.constantCoefficientScalarMatrix`

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

### D006: `NumStability.leveque01_equation01_constantLinearSystemAt`

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

### D007: `NumStability.leveque01_equation02_scalarAdvectionAt`

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

### D008: `NumStability.scalarAsOneComponentSystem`

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

### D009: `NumStability.IsConstantCoefficientLinearSystemSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9f446c6a55d9b32fb90ad5c7e8a268b2f8a27356a6502bbbe96f19a301dcb625`

Hash-verified prior declaration review:

- Reuse SHA-256: `3ab60273bbed2a4a41d45c2805abedae6b69aa31986471916ea10514d5cae28f`
- Reviewed interpretation: There exist time and space derivative vectors of the corresponding one-variable slices at t and x, whose sum qt + A qx is zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D010: `NumStability.IsLinearAdvectionSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D011: `NumStability.IsConstantCoefficientLinearSystemSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `57490fb22b43764f68cb9cff131e2e74230fbaf0188d50d22f1fb4537dc5cfe8`

Hash-verified prior declaration review:

- Reuse SHA-256: `722382a9ccce9cae96a2cd573633f4b4eda1a2c6bf8555207d1738e2c97f3792`
- Reviewed interpretation: Real scalar multiplication on real-valued functions is continuous for the displayed pointwise action and product topology.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D012: `NumStability.IsLinearAdvectionSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`
- Declaration kind: `theorem`
- Distance from target type: `3`
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

### D013: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `a1e9d43ae07930c3e694c0aacb4e671e63d32e6695fe7fc7d5676578be94c3fb`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D014: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Hash-verified prior declaration review:

- Reuse SHA-256: `79578f1a12b299aaf7d11fa79fd772596f42b84d45b8453a6c7a67a66ecbd2c6`
- Reviewed interpretation: Retains the supplied normed field and establishes its nontrivial norm.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D015: `Differentiable`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.FDeriv.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a1dfc978188e8f9437f92dccd280e4b5bc02612d668ce5aa76797eaa27af40a8`

Type:

```lean
(𝕜 : Type u_1) →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup E] →
        [Module 𝕜 E] →
          [TopologicalSpace E] →
            {F : Type u_3} → [inst_4 : AddCommGroup F] → [Module 𝕜 F] → [TopologicalSpace F] → (E → F) → Prop
```

Fully explicit type:

```lean
(𝕜 : Type u_1) →
  [inst : NontriviallyNormedField.{u_1} 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup.{u_2} E] →
        [@Module.{u_1, u_2} 𝕜 E
              (@DivisionSemiring.toSemiring.{u_1} 𝕜
                (@Semifield.toDivisionSemiring.{u_1} 𝕜
                  (@Field.toSemifield.{u_1} 𝕜
                    (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
              (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1)] →
          [TopologicalSpace.{u_2} E] →
            {F : Type u_3} →
              [inst_4 : AddCommGroup.{u_3} F] →
                [@Module.{u_1, u_3} 𝕜 F
                      (@DivisionSemiring.toSemiring.{u_1} 𝕜
                        (@Semifield.toDivisionSemiring.{u_1} 𝕜
                          (@Field.toSemifield.{u_1} 𝕜
                            (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                      (@AddCommGroup.toAddCommMonoid.{u_3} F inst_4)] →
                  [TopologicalSpace.{u_3} F] → (f : E → F) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 [NontriviallyNormedField 𝕜] {E} [AddCommGroup E] [Module 𝕜 E] [TopologicalSpace E] {F} [AddCommGroup F]
    [Module 𝕜 F] [TopologicalSpace F] f =>
  ∀ (x : E), DifferentiableAt 𝕜 f x
```

### D016: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Hash-verified prior declaration review:

- Reuse SHA-256: `6642d4f94d76b844ea6a7f2beda672012d6a7046dc12d5fb3e8f65d4c6ff869e`
- Reviewed interpretation: The standard finite index type of natural numbers below its parameter.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D017: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Hash-verified prior declaration review:

- Reuse SHA-256: `51dd2633a8452f8b87915847e537e12c45105d62da36d6186f7c32522da2cf8d`
- Reviewed interpretation: Enumerates Fin n using List.finRange n, with completeness and absence of duplicates.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D018: `HMul.hMul`

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

### D019: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Hash-verified prior declaration review:

- Reuse SHA-256: `80f100ba45be2d793d601b20424617b958ad883100a9811456ef599fd5b519c0`
- Reviewed interpretation: Logical equivalence.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D020: `InnerProductSpace.toNormedSpace`

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

### D021: `IntervalIntegrable`

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

### D022: `MeasureTheory.MeasureSpace.volume`

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

### D024: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `dcf87408a31c8b6c2490c9be43895047d7deaf3bfce985b210544c1f2a3e4ff7`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D025: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `694681bda5ff7fb52a7a903920d62394860187b72521945afceea79f0c485d65`
- Reviewed interpretation: Retains the norm, additive group, and pseudometric of the supplied ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D026: `NormedAddCommGroup.toNormedAddGroup`

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

### D027: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D028: `NormedAddGroup.toENormedAddMonoid`

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

### D029: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `7bb9f66f94d46fdfbad9b82a90912aa1b2a48e375d1d8d9615493fe7950bb7a9`
- Reviewed interpretation: Retains the norm, ring, and induced pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D030: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Hash-verified prior declaration review:

- Reuse SHA-256: `c8db9d1c0a0cb1c556eb4fad5a3f04dcd88a1dec19cb106bdce05d20e02e831f`
- Reviewed interpretation: Projects the underlying module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D031: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `6e5a744902eaa16e902722279c37b66fb40c4b55dcf395d04345baf20a112f88`
- Reviewed interpretation: Extracts the value assigned to a natural-number literal by its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D032: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Hash-verified prior declaration review:

- Reuse SHA-256: `29260d4130c457e006d749da1a7a685e26cd3708968cc7dc6f8bad36ae292367`
- Reviewed interpretation: Projects the uniform space associated with the pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D033: `RCLike.toInnerProductSpaceReal`

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

### D034: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `2aa1a1632950ca1bf8655d828f2e298dffbc9327c0000d7b140e8bbd308ecc02`
- Reviewed interpretation: The standard library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D035: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Hash-verified prior declaration review:

- Reuse SHA-256: `f2bd9abd865934ec9bae1ebe31e051765679510322bd7bcea0556af25c1064bc`
- Reviewed interpretation: Equips Real with its normed field and the dense-norm property.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D036: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Hash-verified prior declaration review:

- Reuse SHA-256: `aceadaebc453ae9b6f097e11aaaf8d9b2ed44befeaa9ca679f67cdf2227e2f2c`
- Reviewed interpretation: Supplies the standard inferred additive commutative group of Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D037: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Hash-verified prior declaration review:

- Reuse SHA-256: `eeea30fab680ee0597ebf6dd77c33136f8a1dbc14ca0644bce1944ad0bc8ae80`
- Reviewed interpretation: Selects Real.mul as real multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D038: `Real.instRCLike`

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

### D039: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `0aaa281446d53896c9fa4d9b4d9f668ab56a85d4ca31f34242b6b6e29c0cce84`
- Reviewed interpretation: Selects Real.zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D040: `Real.measureSpace`

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

### D041: `Real.normedAddCommGroup`

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

### D042: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Hash-verified prior declaration review:

- Reuse SHA-256: `9d6634e36de3ea694c260d3f9eb7152c89dc603ac75ad23688118139c087e40c`
- Reviewed interpretation: Combines the real normed additive group and real commutative ring, retaining their operations and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D043: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Hash-verified prior declaration review:

- Reuse SHA-256: `522f37c0f2ef641aa7095d811ec47b1cda3b9f1322911dbd22cec8f6398ee23f`
- Reviewed interpretation: Combines the real field with its normed additive group and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D044: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `6d2a1b7c7cd7a3904ee0cdabd126aa5c872e543079e496495718548a290870d7`
- Reviewed interpretation: The distance between x and y is abs(x - y).

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D045: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `434472282d5e45ab3a1601c38728b245e8d0b1110d5955ad56d0f7c356ffdc26`
- Reviewed interpretation: Retains norm, pseudometric, and ring operations while omitting unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D046: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Hash-verified prior declaration review:

- Reuse SHA-256: `7ceb8fede74b139eb3ac93926abd01c31cb896225902798fb7655f6587b326d0`
- Reviewed interpretation: Projects the underlying topology of a uniform space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D047: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `1fe81c499a5348d0bd78dfe9fc813803ec434dc22ee1204515af15efebaf4a23`
- Reviewed interpretation: Interprets the literal 0 as the supplied zero element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D048: `instHMul`

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

### D049: `instOfNatNat`

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

### D050: `AddGroup.toSubNegMonoid`

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

### D051: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D052: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D053: `CommRing.toNonUnitalCommRing`

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

### D054: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D055: `DFunLike.coe`

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

### D056: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `0c793a3049e6682a08e9dcc5632447c24a719db33346cc4084923f72e2061806`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D057: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `561e2e3cbaa7d3373e39687d25c230d4259c4207137f74427b44697b49b3f6cb`
- Reviewed interpretation: Existential quantification over a specified type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D058: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Hash-verified prior declaration review:

- Reuse SHA-256: `c71c471e3cf1992b1c4a5023f9054e2c6f8a16068c04503efb461ffe7f6542fa`
- Reviewed interpretation: A finite enumeration structure on an index type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D059: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D060: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `34adf3db6cebb08fe62c976181eb54a3134bc28738af15db50df73fad719fc7b`
- Reviewed interpretation: Extracts the addition operation from the supplied HAdd instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D061: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D062: `HSub.hSub`

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

### D063: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Hash-verified prior declaration review:

- Reuse SHA-256: `30eaf4a17663752618d08e927cba466a56171183f435dd05eded6d7f7f43f816`
- Reviewed interpretation: A matrix is a function from row indices to column indices to entries.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D064: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `715de3f0bd9e7bcf034726e1efbf1b4dad42a16e2ce790d4403774d16ed5b549`

Hash-verified prior declaration review:

- Reuse SHA-256: `e10b4caca6e26ebf9e229ce3b67fba0529ab394c15865a22b28dae62d7692212`
- Reviewed interpretation: At row i, takes the dot product of row M i with the input vector.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D065: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
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

### D066: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D067: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Hash-verified prior declaration review:

- Reuse SHA-256: `7fa2f8ce8674d11e0db0d7cc253c4279388a27f0081b342eea836b4866b6e974`
- Reviewed interpretation: Retains the underlying ring operations while forgetting associativity structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D068: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Hash-verified prior declaration review:

- Reuse SHA-256: `d8bf879e987927aa134e8e06d2932dbeb9aac519cd0eaabcf729a30a64b55ed3`
- Reviewed interpretation: Projects the underlying nonassociative ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D069: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `5fa6b1466f37b32a1d029870ce89906f0c512f4dadaf00a5d1842a72395c1830`
- Reviewed interpretation: Builds a semiring structure with the original addition and multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D070: `NormedAddCommGroup`

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

### D071: `NormedAddGroup.toAddGroup`

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

### D072: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Hash-verified prior declaration review:

- Reuse SHA-256: `6a5b357a68caa00d7dc32d712f1b8c5104523b992f71f2914e5f73b302745baa`
- Reviewed interpretation: A normed field acts on itself through its semiring module structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D073: `NormedSpace`

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

### D074: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Hash-verified prior declaration review:

- Reuse SHA-256: `8a4a9898923965fc39eb265304fd5fb3d590000978e82f4b317c94be9140c488`
- Reviewed interpretation: Uses the product module on functions with fixed codomain.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D075: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D076: `Real.commRing`

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

### D077: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Hash-verified prior declaration review:

- Reuse SHA-256: `eb0653ae65a2f51b007444e665c04aad111c9d9c2fc7606b1482ca308344c7d1`
- Reviewed interpretation: Selects Real.add as real addition.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D078: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D079: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D080: `Real.semiring`

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

### D081: `SeminormedAddCommGroup.toPseudoMetricSpace`

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

### D082: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D083: `SubNegMonoid.toSub`

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

### D084: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `5fc0c612d0920e1834de2b7fb8362d69187f524afc53380dafb8141a620820f5`
- Reviewed interpretation: Uses the supplied homogeneous addition as heterogeneous addition with all types equal.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D085: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D086: `instHSub`

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

### D087: `intervalIntegral`

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

### D088: `AddCommGroup.toDivisionAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D089: `AddCommMagma.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D090: `AddCommMonoid.toAddCommSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D091: `AddCommSemigroup.toAddCommMagma`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D092: `AddMonoid.toAddZeroClass`

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

### D093: `AddZero.toZero`

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

### D094: `AddZeroClass.toAddZero`

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

### D095: `DistribMulAction.toDistribSMul`

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

### D096: `DistribSMul.toSMulZeroClass`

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

### D097: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `587c80a71f9aa5749b5d6c35c97cdae1067fa669257c865951843b747c511934`

Hash-verified prior declaration review:

- Reuse SHA-256: `36a676e1ca82e8d481a649d97aa1201cd34faaac226ebada2fb026bfcafeaf0f`
- Reviewed interpretation: Projects the underlying semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D098: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

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

### D099: `ESeminormedAddCommMonoid.toAddCommMonoid`

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

### D100: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

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

### D101: `ESeminormedAddMonoid.toAddMonoid`

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

### D102: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `9a6353c2087dc0f4123f4079d947842f8b7bc1fc0c77de170382c04e31608fd4`

Hash-verified prior declaration review:

- Reuse SHA-256: `9bfc6c754a3e27891935c82b0de7795c959b1164668aa4fe1ca28d05745d321c`
- Reviewed interpretation: Builds the semifield structure using the field's existing arithmetic and inverse operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D103: `HasDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.Deriv.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `425ec9578fd20d63923b9588cbb7761a6e92f281528630fe03d0dc3dc1bc60a2`

Hash-verified prior declaration review:

- Reuse SHA-256: `313dcd89c416ada81b3fbe6cac428f59a986f0c402493fe09722f36c365a6f0e`
- Reviewed interpretation: Derivative assertion at a point, obtained from HasDerivAtFilter with the neighborhood filter in the varying argument and the fixed base point.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D104: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Hash-verified prior declaration review:

- Reuse SHA-256: `a9d969e899718400b19d32e499a05476da7ee2225fb4583c24777baaad137e42`
- Reviewed interpretation: Projects the distributive scalar action from a module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D105: `NegZeroClass.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D106: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Hash-verified prior declaration review:

- Reuse SHA-256: `6441cb1b282829cb8af36dd4260912565bd57dc9097506810e45237c51ad0be5`
- Reviewed interpretation: Projects the additive commutative monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D107: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Hash-verified prior declaration review:

- Reuse SHA-256: `876f28b2cd6ef860e26e9f6e4d9143b233f9a162290d9635d5b15545e8d59f0c`
- Reviewed interpretation: Retains ring operations and commutativity while dropping norm structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D108: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Hash-verified prior declaration review:

- Reuse SHA-256: `5d9430b4f8744bab8e268bacde214b421c739bdb61b3740aeb926042c2f7fe1b`
- Reviewed interpretation: Projects the underlying nonassociative semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D109: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `dc08b02d757cccbd21bce550b40d3f76d2ee704ec2cd7f5507023d827296474f`

Hash-verified prior declaration review:

- Reuse SHA-256: `bf680d84a46eaf558569f40ea8cb643ee398f679efb2aff081caf04fbd934fd3`
- Reviewed interpretation: Projects the supplied normed field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D110: `NormedAddCommGroup.toAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D111: `NormedAddCommGroup.toENormedAddCommMonoid`

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

### D112: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Hash-verified prior declaration review:

- Reuse SHA-256: `76462468250e00812031ab58bd78bd79c9ed861dc6fcb52d8e6dd393e280f594`
- Reviewed interpretation: Copies the norm, metric, and ring operations into the structure without a unit requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D113: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ec9eab2d54099c52c160e626a54324e8c9a07675797f0926435031098f363e5f`

Hash-verified prior declaration review:

- Reuse SHA-256: `bb783c6ab3200399a05460e796486d4f4ccefad110eee4ad91a32e1a5e52b951`
- Reviewed interpretation: Projects the underlying field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D114: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Hash-verified prior declaration review:

- Reuse SHA-256: `e65ac477286b8128c95b9f2db4b83c589408ce9ae98ac1a1f2c2991883774c74`
- Reviewed interpretation: Builds the additive commutative group of functions from coordinate additive groups.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D115: `Pi.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `786aa93e85ac0acc746f4c8ee6aed957d52e0231f66623c2b8e478a794d15ce0`

Hash-verified prior declaration review:

- Reuse SHA-256: `5e741a2ac419a6d1170932125ea1efaef77d94f20e162ad0d186fccbc7e7920a`
- Reviewed interpretation: Adds functions by adding their values at each index.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D116: `Pi.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `eb5c70d9b813d7099537e8db11f59a65a3f5ad951da7314a1aa554471a122049`

Hash-verified prior declaration review:

- Reuse SHA-256: `474ebffacad51150935a9c1407f5bd7798e720bcac5e4ec51801039a36657c01`
- Reviewed interpretation: The zero function takes the zero value at every index.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D117: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a81381c20af462683322c70d792fc61454007e60d0781bb4fda6103a009c8abd`

Hash-verified prior declaration review:

- Reuse SHA-256: `b991572a6fdd6935c1e58b264d8c8090a9023744d2e134257fb4cf7da0dcec61`
- Reviewed interpretation: The product topology is constructed from the induced topologies of coordinate evaluations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D118: `Real.instMonoid`

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

### D119: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Hash-verified prior declaration review:

- Reuse SHA-256: `849c7c4dd1a0c00c9c9c9a47218376f69d16abd4281e88cf6b17dcb37c2f5958`
- Reviewed interpretation: Supplies the inferred ring structure on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D120: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Hash-verified prior declaration review:

- Reuse SHA-256: `4dee0d9022438ac03ee2d4fc6ff019d829b4c554e38f4b66c25ed67b6e847d23`
- Reviewed interpretation: Projects the underlying semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D121: `SMulZeroClass.toSMul`

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

### D122: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `a1b771abeff9bbbdcce988134973a1a367c44a340bcd29acb0cc44b8d6a2e55c`

Hash-verified prior declaration review:

- Reuse SHA-256: `9157b537e4e1bbe613c4e9e20a8a031ee828f82925a0ae0e3f095fd1e658f500`
- Reviewed interpretation: Retains arithmetic and inverses in the division-semiring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D123: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Hash-verified prior declaration review:

- Reuse SHA-256: `4188161721cc2e2215fa67122ed2f5aabd029b5ccd0bc4f78a3d3de4f326284f`
- Reviewed interpretation: Projects the underlying semiring without unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D124: `SubNegZeroMonoid.toNegZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D125: `SubtractionCommMonoid.toSubtractionMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D126: `SubtractionMonoid.toSubNegZeroMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D127: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D128: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D129: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `98c22aec54da8e2278fb6c5ae1daeffb76abd7bad320de72096bec6a7046bc17`

Hash-verified prior declaration review:

- Reuse SHA-256: `c744c1209fe414f2723198e0b7cb299965326672a72d97f82784ff0b48d4cc37`
- Reviewed interpretation: Projects the underlying additive monoid without changing operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D130: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Hash-verified prior declaration review:

- Reuse SHA-256: `906f9da34734aa722b96281c0699b798907538676de8dfa33d2f82588c946759`
- Reviewed interpretation: The proposition that the supplied scalar action is jointly continuous in the supplied topologies.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D131: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `ea6124156f152313d3298dd94738351217f9626c6fc23cb2b63efa1528a4f9b9`

Hash-verified prior declaration review:

- Reuse SHA-256: `d12716c7aa666f53026c45b16d228dc7afe6cbf6c2daec53d4976c2ad7e9bae4`
- Reviewed interpretation: Projects the multiplicative action from a distributive action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D132: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `136930a747dcd73895587cb4c7ea1df27360fed0a4adb57efb71bb8949f0fa71`

Hash-verified prior declaration review:

- Reuse SHA-256: `74a64af4ad7bc2b0a1b5ffe489f25f0849cd89ade39c076e3d483f12527d22a9`
- Reviewed interpretation: Projects the underlying semigroup.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D133: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Hash-verified prior declaration review:

- Reuse SHA-256: `ca61cb484c2cf7e2cec20930217148fd1347a9afbfb33137c9bab3daa930ff13`
- Reviewed interpretation: Projects the underlying multiplicative monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D134: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `2a4074e38a7cedd1ecdaf86a42d3be01ad9728988610178bf9a698f57a876516`

Hash-verified prior declaration review:

- Reuse SHA-256: `e3280968ff00c7bf65cd1792b8c949f0e31ebea830732b36c2cb8b4d3c45e3b3`
- Reviewed interpretation: Projects the underlying semigroup action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D135: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `4aa3dba57859ca72552799005279a2b5a65b8c083980070fbbff11fd1de56dec`

Hash-verified prior declaration review:

- Reuse SHA-256: `3e8c8de309cc9c3a421d8235bfe71c48ae4fcc6f8083577d58dd8b033f200cec`
- Reviewed interpretation: Retains the norm, ring, and metric of the field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D136: `Pi.instSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `adba1d4e42926a50c2701c18af6f5749dd72a4d631113b924c96482924951276`

Hash-verified prior declaration review:

- Reuse SHA-256: `7947a3a04559459b993dac917c8f010b149406ee0c6776d86a601e68b546a045`
- Reviewed interpretation: Defines scalar multiplication on functions by scaling every coordinate value.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D137: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `5a8783c66a2e56a4cc509bbb0651eda5b66e25c197307a42445cac31c4a4bb6c`

Hash-verified prior declaration review:

- Reuse SHA-256: `94dbad1c8c6b6d501c6820c9fa64cd25593af5bf0164c0153a24e53f7a9f7e58`
- Reviewed interpretation: Projects the scalar multiplication operation of an action.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D138: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `e3cbc92d1d5e37d9eaeb1d595c83a78f7af7e3a8d249a700fa3676ab4e0c3d60`

Hash-verified prior declaration review:

- Reuse SHA-256: `710c979dac5292fafdca5b96af5c9c0278238ded6d38f216019399fec528e828`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D139: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `e6ea9296e8643d5ae7cf334c065c9d6ebe4a95de22d3b0708a585db80e17322a`

Hash-verified prior declaration review:

- Reuse SHA-256: `030924e9bd68de51595eb4d172a75fbf4fdea6418b4e438d8032f341e0ab8a30`
- Reviewed interpretation: Projects the supplied pseudometric space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D140: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Hash-verified prior declaration review:

- Reuse SHA-256: `3fa8ba79ac4c3c45bdc39c5c844a4050212cb7ccaac5425f76931d004d7c4a3f`
- Reviewed interpretation: Retains multiplication, one, powers, and zero of the semiring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D141: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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
