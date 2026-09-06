# Declaration dossier for LEV-CH01-SCALAR-HYPERBOLICITY

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_scalarEquation_isHyperbolic (speed : ℝ) :
    leveque01IsHyperbolicMatrix
      (constantCoefficientScalarMatrix speed)
```

## Elaborated target type

```lean
∀ (speed : Real), NumStability.leveque01IsHyperbolicMatrix (NumStability.constantCoefficientScalarMatrix speed)
```

## Fully explicit elaborated target type

```lean
∀ (speed : Real),
  @NumStability.leveque01IsHyperbolicMatrix (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
    (NumStability.constantCoefficientScalarMatrix speed)
```

## Local import graph

- `AuditTarget` imports: `NumStability.Source.LeVeque.Chapter01.Equation02`, `NumStability.Source.LeVeque.Chapter01.Hyperbolicity`
- `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `NumStability.Source.LeVeque.Chapter01.Equation01` imports: `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `NumStability.Source.LeVeque.Chapter01.Equation02` imports: `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection`, `NumStability.Source.LeVeque.Chapter01.Equation01`
- `NumStability.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `NumStability.Source.LeVeque.Chapter01.Hyperbolicity` imports: `NumStability.Analysis.PartialDifferentialEquations.Hyperbolicity`, `NumStability.Source.LeVeque.Chapter01.Equation01`

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

### D002: `NumStability.leveque01IsHyperbolicMatrix`

- Role: `local`
- Owner module: `NumStability.Source.LeVeque.Chapter01.Hyperbolicity`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9e3885b99144513069729a0230749db737cdfd58c1bc2b2f7d56e323d5bf3ce3`

Type:

```lean
{m : Nat} → Matrix (Fin m) (Fin m) Real → Prop
```

Fully explicit type:

```lean
{m : Nat} → (coefficient : Matrix.{0, 0, 0} (Fin m) (Fin m) Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} coefficient => NumStability.IsRealHyperbolicMatrix coefficient
```

### D003: `NumStability.IsRealHyperbolicMatrix`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9cede1eac13a686b98b189d96dae2dc6ee58d0cc2e1eed864ecf18e8425dd2fb`

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

### D004: `Nat`

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

### D005: `OfNat.ofNat`

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

### D006: `Real`

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

### D007: `instOfNatNat`

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

### D008: `Fin`

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

### D009: `Fin.fintype`

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

### D010: `Matrix`

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

### D011: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D012: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D013: `CommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D014: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D015: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D016: `Eq`

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

### D017: `Exists`

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

### D018: `Fintype`

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

### D019: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D020: `HSMul.hSMul`

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

### D021: `Matrix.mulVec`

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

### D022: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
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

### D023: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D024: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

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

### D025: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

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

### D026: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

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

### D027: `Pi.Function.module`

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

### D028: `Pi.addCommMonoid`

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

### D029: `Real.commRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D030: `Real.instAddCommMonoid`

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

### D031: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D032: `Real.semiring`

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

### D033: `Semiring.toModule`

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

### D034: `instHSMul`

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

## Complete local imported sources

### `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection`

Path: `NumStability/Analysis/PartialDifferentialEquations/LinearAdvection.lean`
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

### `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`

Path: `NumStability/Analysis/PartialDifferentialEquations/ConstantCoefficientLinearSystem.lean`
SHA-256: `8e30275f872bc75df1944834277a7bfaa78b63ff1d0cb4fc617a22b8fb4d2526`

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

### `NumStability.Source.LeVeque.Chapter01.Equation01`

Path: `NumStability/Source/LeVeque/Chapter01/Equation01.lean`
SHA-256: `bf433cf8ca84ad036a62f95a905663d4e218e0ada695211f3e2eb56d74f61188`

```lean
/-
SPDX-License-Identifier: MIT
-/

import NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem

/-!
# LeVeque Chapter 1, Equation (1.1)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 1 (raw PDF page 23), equation (1.1).
-/

namespace NumStability

/-- Equation (1.1): a real `m`-component field satisfies
`q_t + A q_x = 0` at `(x, t)` for a constant real `m`-by-`m` matrix `A`. -/
abbrev leveque01_equation01_constantLinearSystemAt
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (x t : ℝ) : Prop :=
  IsConstantCoefficientLinearSystemSolutionAt q coefficient x t

/-- The pointwise predicate for equation (1.1), expanded into its time
derivative, space derivative, and zero-residual clauses. -/
theorem leveque01_equation01_constantLinearSystemAt_iff
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (x t : ℝ) :
    leveque01_equation01_constantLinearSystemAt q coefficient x t ↔
      ∃ qt qx : Fin m → ℝ,
        HasDerivAt (fun τ => q x τ) qt t ∧
          HasDerivAt (fun ξ => q ξ t) qx x ∧
            qt + coefficient.mulVec qx = 0 :=
  Iff.rfl

/-- Equation (1.1): every proof-carrying constant-coefficient system asserts
the displayed PDE globally on `ℝ × ℝ`. This theorem is deliberately not a
definitional `P ↔ P`: its conclusion is the equation required of the system's
unknown state. -/
theorem leveque01_equation01_constantLinearSystem
    {m : ℕ} {coefficient : Matrix (Fin m) (Fin m) ℝ}
    (system : ConstantCoefficientLinearSystemSolution coefficient) :
    ∀ x t, ∃ qt qx : Fin m → ℝ,
      HasDerivAt (fun τ => system.state x τ) qt t ∧
        HasDerivAt (fun ξ => system.state ξ t) qx x ∧
          qt + coefficient.mulVec qx = 0 := by
  intro x t
  exact system.satisfies x t

end NumStability
```

### `NumStability.Source.LeVeque.Chapter01.Equation02`

Path: `NumStability/Source/LeVeque/Chapter01/Equation02.lean`
SHA-256: `f507a3cd5fc9be930e0f5e6c2b5ec2b28416b6c2b7cf575e6f6d2d37feaf5e89`

```lean
/-
SPDX-License-Identifier: MIT
-/

import NumStability.Analysis.PartialDifferentialEquations.LinearAdvection
import NumStability.Source.LeVeque.Chapter01.Equation01

/-!
# LeVeque Chapter 1, Equation (1.2)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 1 (raw PDF page 23), equations (1.1)-(1.2). Equation (1.2) is the
one-dimensional specialization of the constant-coefficient system (1.1).
-/

namespace NumStability

/-- Equation (1.2): scalar constant-speed linear advection at `(x, t)`. -/
abbrev leveque01_equation02_scalarAdvectionAt
    (q : ℝ → ℝ → ℝ) (speed x t : ℝ) : Prop :=
  IsLinearAdvectionSolutionAt q speed x t

/-- Equation (1.2) is exactly equation (1.1) for a one-component state and the
one-by-one coefficient matrix `[speed]`. -/
theorem leveque01_equation02_isOneDimensionalSpecialization
    (q : ℝ → ℝ → ℝ) (speed x t : ℝ) :
    leveque01_equation01_constantLinearSystemAt
        (scalarAsOneComponentSystem q)
        (constantCoefficientScalarMatrix speed) x t ↔
      leveque01_equation02_scalarAdvectionAt q speed x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    refine ⟨qt 0, qx 0, ?_, ?_, ?_⟩
    · simpa [scalarAsOneComponentSystem] using (hasDerivAt_pi.mp ht 0)
    · simpa [scalarAsOneComponentSystem] using (hasDerivAt_pi.mp hx 0)
    · have hcomponent := congrFun hresidual (0 : Fin 1)
      simpa [constantCoefficientScalarMatrix, Matrix.mulVec,
        dotProduct] using hcomponent
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    refine ⟨fun _ => qt, fun _ => qx, ?_, ?_, ?_⟩
    · rw [hasDerivAt_pi]
      intro i
      simpa [scalarAsOneComponentSystem] using ht
    · rw [hasDerivAt_pi]
      intro i
      simpa [scalarAsOneComponentSystem] using hx
    · funext i
      simpa [constantCoefficientScalarMatrix, Matrix.mulVec,
        dotProduct] using hresidual

end NumStability
```

### `NumStability.Analysis.PartialDifferentialEquations.Hyperbolicity`

Path: `NumStability/Analysis/PartialDifferentialEquations/Hyperbolicity.lean`
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

### `NumStability.Source.LeVeque.Chapter01.Hyperbolicity`

Path: `NumStability/Source/LeVeque/Chapter01/Hyperbolicity.lean`
SHA-256: `5bb5f8271d1ada27fc703cd969c821a5f724a7727f5517347301b422a6877bd5`

```lean
/-
SPDX-License-Identifier: MIT
-/

import NumStability.Analysis.PartialDifferentialEquations.Hyperbolicity
import NumStability.Source.LeVeque.Chapter01.Equation01

/-!
# LeVeque Chapter 1, hyperbolic constant-coefficient systems

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25).  A constant-coefficient system is called
hyperbolic when its real coefficient matrix has `m` linearly independent real
eigenvectors; these eigenvectors form a basis and hence give every state a
unique decomposition.
-/

open scoped BigOperators

namespace NumStability

/-- LeVeque's Chapter 1 hyperbolicity condition for the coefficient matrix in
equation (1.1). -/
abbrev leveque01IsHyperbolicMatrix {m : ℕ}
    (coefficient : Matrix (Fin m) (Fin m) ℝ) : Prop :=
  IsRealHyperbolicMatrix coefficient

/-- LeVeque's hyperbolicity definition is exactly the existence of `m`
linearly independent corresponding real eigenvectors. -/
theorem leveque01_hyperbolicMatrixDefinition {m : ℕ}
    (coefficient : Matrix (Fin m) (Fin m) ℝ) :
    leveque01IsHyperbolicMatrix coefficient ↔
      ∃ (eigenvalues : Fin m → ℝ)
          (eigenvectors : Fin m → (Fin m → ℝ)),
        LinearIndependent ℝ eigenvectors ∧
          ∀ p, coefficient.mulVec (eigenvectors p) =
            eigenvalues p • eigenvectors p :=
  isRealHyperbolicMatrix_iff_independent_real_eigenvectors coefficient

/-- For a hyperbolic coefficient matrix, every state has one and only one
linear decomposition in a corresponding real eigenbasis. -/
theorem leveque01_hyperbolicMatrix_uniqueEigenbasisDecomposition
    {m : ℕ} {coefficient : Matrix (Fin m) (Fin m) ℝ}
    (hcoefficient : leveque01IsHyperbolicMatrix coefficient) :
    ∃ (eigenvalues : Fin m → ℝ)
        (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
      (∀ p, coefficient.mulVec (eigenbasis p) =
        eigenvalues p • eigenbasis p) ∧
      ∀ q : Fin m → ℝ,
        ∃! amplitudes : Fin m → ℝ,
          ∑ p, amplitudes p • eigenbasis p = q :=
  hcoefficient.exists_unique_eigenbasis_decomposition

end NumStability
```
