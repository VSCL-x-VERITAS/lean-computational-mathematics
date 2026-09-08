# Declaration dossier for LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_materialInterfaceRiemannData_iff {Material State : Type*}
    (medium : ℝ → Material) (initialState : ℝ → State)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) :
    IsRiemannData (fun x => (medium x, initialState x))
        (leftMaterial, leftState) (rightMaterial, rightState) ↔
      IsRiemannData medium leftMaterial rightMaterial ∧
        IsRiemannData initialState leftState rightState
```

## Elaborated target type

```lean
∀ {Material : Type u_1} {State : Type u_2} (medium : Real → Material) (initialState : Real → State)
  (leftMaterial rightMaterial : Material) (leftState rightState : State),
  Iff
    (NumStability.IsRiemannData (fun x => { fst := medium x, snd := initialState x })
      { fst := leftMaterial, snd := leftState } { fst := rightMaterial, snd := rightState })
    (And (NumStability.IsRiemannData medium leftMaterial rightMaterial)
      (NumStability.IsRiemannData initialState leftState rightState))
```

## Fully explicit elaborated target type

```lean
∀ {Material : Type u_1} {State : Type u_2} (medium : Real → Material) (initialState : Real → State)
  (leftMaterial rightMaterial : Material) (leftState rightState : State),
  Iff
    (@NumStability.IsRiemannData.{max u_2 u_1} (Prod.{u_1, u_2} Material State)
      (fun (x : Real) => @Prod.mk.{u_1, u_2} Material State (medium x) (initialState x))
      (@Prod.mk.{u_1, u_2} Material State leftMaterial leftState)
      (@Prod.mk.{u_1, u_2} Material State rightMaterial rightState))
    (And (@NumStability.IsRiemannData.{u_1} Material medium leftMaterial rightMaterial)
      (@NumStability.IsRiemannData.{u_2} State initialState leftState rightState))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsRiemannData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9986cca09fad513510d98d589879bd7b67d633458b39e176f9124be154775712`

Type:

```lean
{State : Type u_1} → (Real → State) → State → State → Prop
```

Fully explicit type:

```lean
{State : Type u_1} → (data : Real → State) → (leftState rightState : State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} data leftState rightState =>
  And (∀ (x : Real), Real.instLT.lt x 0 → Eq (data x) leftState)
    (∀ (x : Real), Real.instLT.lt 0 x → Eq (data x) rightState)
```

### D002: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `a29a7bc1772fa6c04b57a6149adac0a7e66ffcec9fdc5c09facb37f92d028de9`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D003: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Hash-verified prior declaration review:

- Reuse SHA-256: `8c207acb2f3c33282cddbf0d2acb94510339b3207855feaee362ff25d8f5828b`
- Reviewed interpretation: Logical equivalence.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D004: `Prod`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `3df3b0cff45fb04022db70edff8e5747def6cae602cd8c33e673abac1bb4e347`

Type:

```lean
Type u → Type v → Type (max u v)
```

Fully explicit type:

```lean
(α : Type u) → (β : Type v) → Type (max u v)
```

### D005: `Prod.mk`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `e42ba07a23655c2aae0502df1e03897313eaf034a0e84cfef98e91f6b4920097`

Type:

```lean
{α : Type u} → {β : Type v} → α → β → Prod α β
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (fst : α) → (snd : β) → Prod.{u, v} α β
```

### D006: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `7b102f9dd7960e48c346a659c3eea24e055508443883e0874890869abfaa0053`
- Reviewed interpretation: The standard library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D007: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `96b06d8f4a0b9d42c63d27deaa1fd88d8004070d2860a0975888569514ea8ca2`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D008: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D009: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `9e506b30a29cce8ac3e38881488c7146323b5d8f72f47345be81eedefe40ba35`
- Reviewed interpretation: Extracts the value assigned to a natural-number literal by its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D010: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D011: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `d08b7a921bef1d7898c11931c0180d5a572e70dc084be186e4224ab084bfd3dc`
- Reviewed interpretation: Selects Real.zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D012: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `4cab96c7d3ba85dcabaed043dad67f453ba7d4dc4468e28347312ff2b9cd876d`
- Reviewed interpretation: Interprets the literal 0 as the supplied zero element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.
