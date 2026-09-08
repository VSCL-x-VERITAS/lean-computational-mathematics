# Declaration dossier for LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_riemannInitialConfiguration_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) :
    leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q ↔
      evolutionEquation q ∧
        (∀ x, x < 0 → q x 0 = leftState) ∧
        (∀ x, 0 < x → q x 0 = rightState)
```

## Elaborated target type

```lean
∀ {State : Type u_1} (evolutionEquation : (Real → Real → State) → Prop) (leftState rightState : State)
  (q : Real → Real → State),
  Iff (NumStability.leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q)
    (And (evolutionEquation q)
      (And (∀ (x : Real), Real.instLT.lt x 0 → Eq (q x 0) leftState)
        (∀ (x : Real), Real.instLT.lt 0 x → Eq (q x 0) rightState)))
```

## Fully explicit elaborated target type

```lean
∀ {State : Type u_1} (evolutionEquation : (Real → Real → State) → Prop) (leftState rightState : State)
  (q : Real → Real → State),
  Iff (@NumStability.leveque01RiemannInitialConfiguration.{u_1} State evolutionEquation leftState rightState q)
    (And (evolutionEquation q)
      (And
        (∀ (x : Real),
          @LT.lt.{0} Real Real.instLT x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) →
            @Eq.{u_1 + 1} State (q x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
              leftState)
        (∀ (x : Real),
          @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) x →
            @Eq.{u_1 + 1} State (q x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
              rightState)))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.leveque01RiemannInitialConfiguration`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8f87d6c5b06e6de2318c84dfd17928bd955594c3933e289741cf1e00a94098ce`

Type:

```lean
{State : Type u_1} → ((Real → Real → State) → Prop) → State → State → (Real → Real → State) → Prop
```

Fully explicit type:

```lean
{State : Type u_1} →
  (evolutionEquation : (Real → Real → State) → Prop) → (leftState rightState : State) → (q : Real → Real → State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} evolutionEquation leftState rightState q =>
  NumStability.IsRiemannInitialValueSolution evolutionEquation leftState rightState q
```

### D002: `NumStability.IsRiemannInitialValueSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `4641364719967a9001e26cda78154811debc5edbdcfe65d7f0408c9d5100a21b`

Type:

```lean
{State : Type u_1} → ((Real → Real → State) → Prop) → State → State → (Real → Real → State) → Prop
```

Fully explicit type:

```lean
{State : Type u_1} →
  (evolutionEquation : (Real → Real → State) → Prop) → (leftState rightState : State) → (q : Real → Real → State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} evolutionEquation leftState rightState q =>
  And (evolutionEquation q) (NumStability.IsRiemannData (fun x => q x 0) leftState rightState)
```

### D003: `NumStability.IsRiemannData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D004: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `b199a7e69311e8216b8b4f468ed884727e6d8559f5cdec1faad336786eed305c`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D005: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `9c613816364ccec5e992fe59677b51dad82b31ae633ce887e15f71063028918b`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D006: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Hash-verified prior declaration review:

- Reuse SHA-256: `093de33ba9a4b72c671c954b413d9f0a5c9989861a3b34eaf0d8685d68c2bfce`
- Reviewed interpretation: Logical equivalence.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D007: `LT.lt`

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

### D008: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `5ac7881a67db494c64e7cdf4f96fee04fd4707dcad7249b398ab1b2559f5947a`
- Reviewed interpretation: Extracts the value assigned to a natural-number literal by its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D009: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `f2e0f77a3eedec456e15a938719daab023ce83c38d78eaed190d7a193b4500f9`
- Reviewed interpretation: The standard library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D010: `Real.instLT`

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

### D011: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `d08b7a921bef1d7898c11931c0180d5a572e70dc084be186e4224ab084bfd3dc`
- Reviewed interpretation: Selects Real.zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D012: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `4cab96c7d3ba85dcabaed043dad67f453ba7d4dc4468e28347312ff2b9cd876d`
- Reviewed interpretation: Interprets the literal 0 as the supplied zero element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.
