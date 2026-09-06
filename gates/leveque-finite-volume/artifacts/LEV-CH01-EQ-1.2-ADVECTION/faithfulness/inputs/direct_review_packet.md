# Declaration dossier for LEV-CH01-EQ-1.2-ADVECTION

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_equation02_isOneDimensionalSpecialization
    (q : ℝ → ℝ → ℝ) (speed x t : ℝ) :
    leveque01_equation01_constantLinearSystemAt
        (scalarAsOneComponentSystem q)
        (constantCoefficientScalarMatrix speed) x t ↔
      leveque01_equation02_scalarAdvectionAt q speed x t
```

## Elaborated target type

```lean
∀ (q : Real → Real → Real) (speed x t : Real),
  Iff
    (NumStability.leveque01_equation01_constantLinearSystemAt (NumStability.scalarAsOneComponentSystem q)
      (NumStability.constantCoefficientScalarMatrix speed) x t)
    (NumStability.leveque01_equation02_scalarAdvectionAt q speed x t)
```

## Fully explicit elaborated target type

```lean
∀ (q : Real → Real → Real) (speed x t : Real),
  Iff
    (@NumStability.leveque01_equation01_constantLinearSystemAt
      (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))) (NumStability.scalarAsOneComponentSystem q)
      (NumStability.constantCoefficientScalarMatrix speed) x t)
    (NumStability.leveque01_equation02_scalarAdvectionAt q speed x t)
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection`, `NumStability.Source.LeVeque.Chapter01.Equation01`
- `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `NumStability.Source.LeVeque.Chapter01.Equation01` imports: `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.constantCoefficientScalarMatrix`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7a328d470fb64c7d8594b40b0737c6c604f2dd10c1fffc977d021fde46a78e8e`

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

### D002: `NumStability.leveque01_equation01_constantLinearSystemAt`

- Role: `local`
- Owner module: `NumStability.Source.LeVeque.Chapter01.Equation01`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a27936acd2e6d0e5f2ef8ddb0b98f44e8e9dea147991c886cb6a0a5b07adcfb4`

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

### D003: `NumStability.leveque01_equation02_scalarAdvectionAt`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `95f8ded9e973112de5f805cd5d672497232fbfae4cebd36eae6776aef93b03cb`

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

### D004: `NumStability.scalarAsOneComponentSystem`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `56e414d37f321fbc3fa3dec2b3483e57f5344645a029a681691c1e57eb4144de`

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

### D005: `NumStability.IsConstantCoefficientLinearSystemSolutionAt`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c32c28b7a2dae9938feccc0ce90bf358405ec0b6d1b5028c5120465e5c0c5bef`

Type:

```lean
{ι : Type u_1} → [Fintype ι] → (Real → Real → ι → Real) → Matrix ι ι Real → Real → Real → Prop
```

Fully explicit type:

```lean
{ι : Type u_1} →
  [Fintype.{u_1} ι] → (q : Real → Real → ι → Real) → (coefficient : Matrix.{u_1, u_1, 0} ι ι Real) → (x t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] q coefficient x t =>
  Exists fun qt =>
    Exists fun qx =>
      And (HasDerivAt (fun τ => q x τ) qt t)
        (And (HasDerivAt (fun ξ => q ξ t) qx x) (Eq (instHAdd.hAdd qt (coefficient.mulVec qx)) 0))
```

### D006: `NumStability.IsLinearAdvectionSolutionAt`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `97c7a69647b3a2322ef5ea1c6728b9a5bbe5251c4713ca8862f769d94278e59f`

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

### D007: `NumStability.IsConstantCoefficientLinearSystemSolutionAt._proof_1`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `094ac6a531f1369fb8b7c83c4b7960842b9dc3c0a1f19b3dc8d51cbe4af0afd1`

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

### D008: `NumStability.IsLinearAdvectionSolutionAt._proof_1`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `5755834deddec8e6120d2a9dd2edffeeb24acdeb37740789c52e2dfe4e84f6c6`

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

### D009: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D010: `Nat`

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

### D011: `OfNat.ofNat`

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

### D012: `Real`

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

### D013: `instOfNatNat`

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

### D014: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

Fully explicit type:

```lean
(n : Nat) → Type
```

### D015: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D016: `Matrix`

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

### D017: `NormedField.toNormedSpace`

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

### D018: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D019: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D020: `AddCommGroup.toDivisionAddCommMonoid`

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

### D021: `AddCommMagma.toAdd`

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

### D022: `AddCommMonoid.toAddCommSemigroup`

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

### D023: `AddCommSemigroup.toAddCommMagma`

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

### D024: `AddMonoid.toAddZeroClass`

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

### D025: `AddZero.toZero`

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

### D026: `AddZeroClass.toAddZero`

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

### D027: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D028: `DenselyNormedField.toNontriviallyNormedField`

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

### D029: `DistribMulAction.toDistribSMul`

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

### D030: `DistribSMul.toSMulZeroClass`

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

### D031: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D032: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

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

### D033: `ESeminormedAddCommMonoid.toAddCommMonoid`

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

### D034: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

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

### D035: `ESeminormedAddMonoid.toAddMonoid`

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

### D036: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

Fully explicit type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D037: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Prop
```

### D038: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D039: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Type:

```lean
Type u_4 → Type u_4
```

Fully explicit type:

```lean
(α : Type u_4) → Type u_4
```

### D040: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D041: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D042: `HasDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.Deriv.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D043: `Matrix.mulVec`

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

### D044: `Module.toDistribMulAction`

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

### D045: `NegZeroClass.toZero`

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

### D046: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D047: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D048: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

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

### D049: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D050: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D051: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D052: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D053: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D054: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D055: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

Fully explicit type:

```lean
(E : Type u_8) → Type u_8
```

### D056: `NormedAddCommGroup.toAddCommGroup`

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

### D057: `NormedAddCommGroup.toENormedAddCommMonoid`

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

### D058: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D059: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D060: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D061: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D062: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

Fully explicit type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField.{u_6} 𝕜] → [SeminormedAddCommGroup.{u_7} E] → Type (max u_6 u_7)
```

### D063: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D064: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D065: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D066: `Pi.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D067: `Pi.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D068: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D069: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D070: `Real.denselyNormedField`

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

### D071: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D072: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D073: `Real.instMonoid`

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

### D074: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D075: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D076: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D077: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D078: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D079: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D080: `SMulZeroClass.toSMul`

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

### D081: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D082: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D083: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D084: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D085: `SubNegZeroMonoid.toNegZeroClass`

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

### D086: `SubtractionCommMonoid.toSubtractionMonoid`

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

### D087: `SubtractionMonoid.toSubNegZeroMonoid`

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

### D088: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D089: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D090: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D091: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D092: `AddCommGroup.toAddCommMonoid`

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

### D093: `AddCommGroup.toAddGroup`

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

### D094: `AddCommMonoid.toAddMonoid`

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

### D095: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D096: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Type:

```lean
(M : Type u_1) → (X : Type u_2) → [SMul M X] → [TopologicalSpace M] → [TopologicalSpace X] → Prop
```

Fully explicit type:

```lean
(M : Type u_1) → (X : Type u_2) → [SMul.{u_1, u_2} M X] → [TopologicalSpace.{u_1} M] → [TopologicalSpace.{u_2} X] → Prop
```

### D097: `DistribMulAction.toMulAction`

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

### D098: `Monoid.toSemigroup`

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

### D099: `MonoidWithZero.toMonoid`

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

### D100: `MulAction.toSemigroupAction`

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

### D101: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D102: `Pi.instSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D103: `SemigroupAction.toSMul`

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

### D104: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D105: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D106: `Semiring.toMonoidWithZero`

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

### D107: `SubNegMonoid.toAddMonoid`

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
