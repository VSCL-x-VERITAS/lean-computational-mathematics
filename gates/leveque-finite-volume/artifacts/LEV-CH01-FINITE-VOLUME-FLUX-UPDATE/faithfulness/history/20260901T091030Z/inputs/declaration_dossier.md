# Declaration dossier for LEV-CH01-FINITE-VOLUME-FLUX-UPDATE

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_finiteVolumeFluxUpdate_sourceContract
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (data : Leveque01FiniteVolumeFluxUpdateData E) :
    IsLeveque01FiniteVolumeFluxUpdate data ↔
      0 < data.fluxScale ∧
        (∀ edge,
          data.isPhysicalFluxApproximation
            (data.numericalFluxFromCellAverages data.cellAverages edge)
            (data.physicalEdgeFlux edge)) ∧
        ∀ i,
          data.updatedCellAverages i =
            conservativeFluxDifferenceUpdate data.fluxScale data.cellAverages
              (data.numericalFluxFromCellAverages data.cellAverages) i
```

## Elaborated target type

```lean
∀ {E : Type u_1} [inst : AddCommGroup E] [inst_1 : Module Real E]
  (data : NumStability.Leveque01FiniteVolumeFluxUpdateData E),
  Iff (NumStability.IsLeveque01FiniteVolumeFluxUpdate data)
    (And (Real.instLT.lt 0 data.fluxScale)
      (And
        (∀ (edge : Nat),
          data.isPhysicalFluxApproximation (data.numericalFluxFromCellAverages data.cellAverages edge)
            (data.physicalEdgeFlux edge))
        (∀ (i : Nat),
          Eq (data.updatedCellAverages i)
            (NumStability.conservativeFluxDifferenceUpdate data.fluxScale data.cellAverages
              (data.numericalFluxFromCellAverages data.cellAverages) i))))
```

## Fully explicit elaborated target type

```lean
∀ {E : Type u_1} [inst : AddCommGroup.{u_1} E]
  [inst_1 : @Module.{0, u_1} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_1} E inst)]
  (data : NumStability.Leveque01FiniteVolumeFluxUpdateData.{u_1} E),
  Iff (@NumStability.IsLeveque01FiniteVolumeFluxUpdate.{u_1} E inst inst_1 data)
    (And
      (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
        (@NumStability.Leveque01FiniteVolumeFluxUpdateData.fluxScale.{u_1} E data))
      (And
        (∀ (edge : Nat),
          @NumStability.Leveque01FiniteVolumeFluxUpdateData.isPhysicalFluxApproximation.{u_1} E data
            (@NumStability.Leveque01FiniteVolumeFluxUpdateData.numericalFluxFromCellAverages.{u_1} E data
              (@NumStability.Leveque01FiniteVolumeFluxUpdateData.cellAverages.{u_1} E data) edge)
            (@NumStability.Leveque01FiniteVolumeFluxUpdateData.physicalEdgeFlux.{u_1} E data edge))
        (∀ (i : Nat),
          @Eq.{u_1 + 1} E (@NumStability.Leveque01FiniteVolumeFluxUpdateData.updatedCellAverages.{u_1} E data i)
            (@NumStability.conservativeFluxDifferenceUpdate.{u_1} E inst inst_1
              (@NumStability.Leveque01FiniteVolumeFluxUpdateData.fluxScale.{u_1} E data)
              (@NumStability.Leveque01FiniteVolumeFluxUpdateData.cellAverages.{u_1} E data)
              (@NumStability.Leveque01FiniteVolumeFluxUpdateData.numericalFluxFromCellAverages.{u_1} E data
                (@NumStability.Leveque01FiniteVolumeFluxUpdateData.cellAverages.{u_1} E data))
              i))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference` imports: `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Module`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsLeveque01FiniteVolumeFluxUpdate`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b53ffb343d4ed3d20900e9efec549d047cbcd27143dc1dc3f2cca82a1f6d869e`

Type:

```lean
{E : Type u_1} → [inst : AddCommGroup E] → [Module Real E] → NumStability.Leveque01FiniteVolumeFluxUpdateData E → Prop
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : AddCommGroup.{u_1} E] →
    [@Module.{0, u_1} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_1} E inst)] →
      (data : NumStability.Leveque01FiniteVolumeFluxUpdateData.{u_1} E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [AddCommGroup E] [Module Real E] data =>
  And (Real.instLT.lt 0 data.fluxScale)
    (And
      (∀ (edge : Nat),
        data.isPhysicalFluxApproximation (data.numericalFluxFromCellAverages data.cellAverages edge)
          (data.physicalEdgeFlux edge))
      (∀ (i : Nat),
        Eq (data.updatedCellAverages i)
          (NumStability.conservativeFluxDifferenceUpdate data.fluxScale data.cellAverages
            (data.numericalFluxFromCellAverages data.cellAverages) i)))
```

### D002: `NumStability.Leveque01FiniteVolumeFluxUpdateData`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ce0260e4b7e04b70be054baeb0746e4a6430de4ee3a7094a753b9f8e3c6a85e5`

Type:

```lean
Type u_1 → Type u_1
```

Fully explicit type:

```lean
(E : Type u_1) → Type u_1
```

### D003: `NumStability.Leveque01FiniteVolumeFluxUpdateData.cellAverages`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6b57bdc5c8c7f2703d4d2e9316a8ce4dc7008f1edabfc0314a394dce0c9eb22c`

Type:

```lean
{E : Type u_1} → NumStability.Leveque01FiniteVolumeFluxUpdateData E → Nat → E
```

Fully explicit type:

```lean
{E : Type u_1} → (self : NumStability.Leveque01FiniteVolumeFluxUpdateData.{u_1} E) → Nat → E
```

Definition body (one-level semantic boundary):

```lean
fun E self => self.1
```

### D004: `NumStability.Leveque01FiniteVolumeFluxUpdateData.fluxScale`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0e8b9923b181d5c080374cd105e182c7d82a8c626b2abc30265de792a8dc5434`

Type:

```lean
{E : Type u_1} → NumStability.Leveque01FiniteVolumeFluxUpdateData E → Real
```

Fully explicit type:

```lean
{E : Type u_1} → (self : NumStability.Leveque01FiniteVolumeFluxUpdateData.{u_1} E) → Real
```

Definition body (one-level semantic boundary):

```lean
fun E self => self.5
```

### D005: `NumStability.Leveque01FiniteVolumeFluxUpdateData.isPhysicalFluxApproximation`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7039aeeff359669d1106fc56748dc0df35b2cc7f4e294f9e54b3ebb96e689851`

Type:

```lean
{E : Type u_1} → NumStability.Leveque01FiniteVolumeFluxUpdateData E → E → E → Prop
```

Fully explicit type:

```lean
{E : Type u_1} → (self : NumStability.Leveque01FiniteVolumeFluxUpdateData.{u_1} E) → E → E → Prop
```

Definition body (one-level semantic boundary):

```lean
fun E self => self.4
```

### D006: `NumStability.Leveque01FiniteVolumeFluxUpdateData.numericalFluxFromCellAverages`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7b1f26e40c1a1b94f9198636a1edf6b02a030195a4eeec970e4305c19d7e8af5`

Type:

```lean
{E : Type u_1} → NumStability.Leveque01FiniteVolumeFluxUpdateData E → (Nat → E) → Nat → E
```

Fully explicit type:

```lean
{E : Type u_1} → (self : NumStability.Leveque01FiniteVolumeFluxUpdateData.{u_1} E) → (Nat → E) → Nat → E
```

Definition body (one-level semantic boundary):

```lean
fun E self => self.3
```

### D007: `NumStability.Leveque01FiniteVolumeFluxUpdateData.physicalEdgeFlux`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9867052b066a0ba112b6807266a5ced1d8fc596941e3a6857b351ee47a20a45c`

Type:

```lean
{E : Type u_1} → NumStability.Leveque01FiniteVolumeFluxUpdateData E → Nat → E
```

Fully explicit type:

```lean
{E : Type u_1} → (self : NumStability.Leveque01FiniteVolumeFluxUpdateData.{u_1} E) → Nat → E
```

Definition body (one-level semantic boundary):

```lean
fun E self => self.2
```

### D008: `NumStability.Leveque01FiniteVolumeFluxUpdateData.updatedCellAverages`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `381a61ebc4bf8896353ca95b21acee38665ac16f01a9a587c47f51a9e2f1bc39`

Type:

```lean
{E : Type u_1} → NumStability.Leveque01FiniteVolumeFluxUpdateData E → Nat → E
```

Fully explicit type:

```lean
{E : Type u_1} → (self : NumStability.Leveque01FiniteVolumeFluxUpdateData.{u_1} E) → Nat → E
```

Definition body (one-level semantic boundary):

```lean
fun E self => self.6
```

### D009: `NumStability.conservativeFluxDifferenceUpdate`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4b8334148a30ee079386cf09e1581b8d61570643264df0416b8e158b5f2343fc`

Type:

```lean
{E : Type u_1} → [inst : AddCommGroup E] → [Module Real E] → Real → (Nat → E) → (Nat → E) → Nat → E
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : AddCommGroup.{u_1} E] →
    [@Module.{0, u_1} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_1} E inst)] →
      (timeStepOverCellWidth : Real) → (cellAverages edgeFlux : Nat → E) → (i : Nat) → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [AddCommGroup E] [Module Real E] timeStepOverCellWidth cellAverages edgeFlux i =>
  instHSub.hSub (cellAverages i)
    (instHSMul.hSMul timeStepOverCellWidth (instHSub.hSub (edgeFlux (instHAdd.hAdd i 1)) (edgeFlux i)))
```

### D010: `NumStability.Leveque01FiniteVolumeFluxUpdateData.mk`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `68f1193ac3183c1b1123fa63915f2b76026fef21b5a704402eafc94d5b855531`

Type:

```lean
{E : Type u_1} →
  (Nat → E) →
    (Nat → E) →
      ((Nat → E) → Nat → E) → (E → E → Prop) → Real → (Nat → E) → NumStability.Leveque01FiniteVolumeFluxUpdateData E
```

Fully explicit type:

```lean
{E : Type u_1} →
  (cellAverages physicalEdgeFlux : Nat → E) →
    (numericalFluxFromCellAverages : (Nat → E) → Nat → E) →
      (isPhysicalFluxApproximation : E → E → Prop) →
        (fluxScale : Real) → (updatedCellAverages : Nat → E) → NumStability.Leveque01FiniteVolumeFluxUpdateData.{u_1} E
```

### D011: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(G : Type u) → Type u
```

### D012: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D013: `And`

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

### D014: `Eq`

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

### D015: `Iff`

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

### D016: `LT.lt`

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

### D017: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

Fully explicit type:

```lean
(R : Type u) → (M : Type v) → [Semiring.{u} R] → [AddCommMonoid.{v} M] → Type (max u v)
```

### D018: `Nat`

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

### D019: `OfNat.ofNat`

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

### D020: `Real`

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

### D021: `Real.instLT`

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

### D022: `Real.instZero`

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

### D023: `Real.semiring`

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

### D024: `Zero.toOfNat0`

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

### D025: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D026: `AddGroup.toSubNegMonoid`

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

### D027: `AddMonoid.toAddZeroClass`

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

### D028: `AddZero.toZero`

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

### D029: `AddZeroClass.toAddZero`

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

### D030: `DistribMulAction.toDistribSMul`

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

### D031: `DistribSMul.toSMulZeroClass`

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

### D032: `HAdd.hAdd`

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

### D033: `HSMul.hSMul`

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

### D034: `HSub.hSub`

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

### D035: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D036: `Real.instMonoid`

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

### D037: `SMulZeroClass.toSMul`

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

### D038: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D039: `SubNegMonoid.toSub`

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

### D040: `instAddNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `a1534bcd3e1888406ac787d30eeff8a284cb6688c23f5e8de09351dda91a280c`

Type:

```lean
Add Nat
```

Fully explicit type:

```lean
Add.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
{ add := Nat.add }
```

### D041: `instHAdd`

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

### D042: `instHSMul`

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

### D043: `instHSub`

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

### D044: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

## Complete local imported sources

### `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`

Path: `NumStability/Analysis/PartialDifferentialEquations/FiniteVolume/FluxDifference.lean`
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
