# Declaration dossier for LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_riemannRayZeroValue_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State)
    (_hriemann : leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q)
    (hself : IsPositiveTimeSelfSimilar q) (value : State) :
    leveque01RiemannRayZeroValue q = value ↔ ∀ t, 0 < t → q 0 t = value
```

## Elaborated target type

```lean
∀ {State : Type u_1} (evolutionEquation : (Real → Real → State) → Prop) (leftState rightState : State)
  (q : Real → Real → State),
  NumStability.leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q →
    NumStability.IsPositiveTimeSelfSimilar q →
      ∀ (value : State),
        Iff (Eq (NumStability.leveque01RiemannRayZeroValue q) value)
          (∀ (t : Real), Real.instLT.lt 0 t → Eq (q 0 t) value)
```

## Fully explicit elaborated target type

```lean
∀ {State : Type u_1} (evolutionEquation : (Real → Real → State) → Prop) (leftState rightState : State)
  (q : Real → Real → State)
  (_hriemann : @NumStability.leveque01RiemannInitialConfiguration.{u_1} State evolutionEquation leftState rightState q)
  (hself : @NumStability.IsPositiveTimeSelfSimilar.{u_1} State q) (value : State),
  Iff (@Eq.{u_1 + 1} State (@NumStability.leveque01RiemannRayZeroValue.{u_1} State q) value)
    (∀ (t : Real),
      @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) t →
        @Eq.{u_1 + 1} State (q (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) t) value)
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity`, `ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity` imports: `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.FieldSimp`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsPositiveTimeSelfSimilar`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3f9212edfbae2cd597b277794f543250a75d57f0f5272e4f5b86002aeebf2398`

Type:

```lean
{State : Type u_1} → (Real → Real → State) → Prop
```

Fully explicit type:

```lean
{State : Type u_1} → (q : Real → Real → State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} q => ∀ (x : Real) {t : Real}, Real.instLT.lt 0 t → Eq (q x t) (q (instHDiv.hDiv x t) 1)
```

### D002: `NumStability.leveque01RiemannInitialConfiguration`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `654df1817dfda881498a9c73223b1b3fb9772f1f84239ae666e0088d949ced27`

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

### D003: `NumStability.leveque01RiemannRayZeroValue`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a5095364d8a6a8285a71479b9e99e6f261db284e2b9dfe5f488eb8acc9dd1f67`

Type:

```lean
{State : Type u_1} → (Real → Real → State) → State
```

Fully explicit type:

```lean
{State : Type u_1} → (q : Real → Real → State) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} q => NumStability.similarityRayValue q 0
```

### D004: `NumStability.IsRiemannInitialValueSolution`

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

### D005: `NumStability.similarityRayValue`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1fb87347d16ef6eb3cbf75317f8a2b9775d8677bf65685efa092d95adec0dcc1`

Type:

```lean
{State : Type u_1} → (Real → Real → State) → Real → State
```

Fully explicit type:

```lean
{State : Type u_1} → (q : Real → Real → State) → (ray : Real) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} q ray => q ray 1
```

### D006: `NumStability.IsRiemannData`

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

### D007: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `96b06d8f4a0b9d42c63d27deaa1fd88d8004070d2860a0975888569514ea8ca2`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D008: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Hash-verified prior declaration review:

- Reuse SHA-256: `9e39ec4853ddf029e9f8baacdc334db243e376c5cff18854e467480afbace6dd`
- Reviewed interpretation: Logical equivalence.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D009: `LT.lt`

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

### D010: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `f5569c7fe350971b4ea22c6995e80aebbff91bc37ff5dc40b33406c739e1a489`
- Reviewed interpretation: Extracts the value assigned to a natural-number literal by its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D011: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `0d347da13527e70df7c0618f099de0a3ba95c1b1982bbae9852c91d1c5a57d2d`
- Reviewed interpretation: The standard library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D012: `Real.instLT`

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

### D013: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `6f967ee1a490365434e6ef4657c5e7acc3d29f8c9780c5c99bd4924701f86db3`
- Reviewed interpretation: Selects Real.zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D014: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `affe843b5664d31651a8a5e9924c66224de4b89e018b132919ef97262b458be9`
- Reviewed interpretation: Interprets the literal 0 as the supplied zero element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D015: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Fully explicit type:

```lean
{G : Type u} → [self : DivInvMonoid.{u} G] → Div.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D016: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HDiv.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D017: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `cc544b5b2a2aabc84389a9fe2f052127dc6dae9964782b117b9b19b773e542d5`

Type:

```lean
{α : Type u_1} → [One α] → OfNat α 1
```

Fully explicit type:

```lean
{α : Type u_1} → [One.{u_1} α] → OfNat.{u_1} α (nat_lit 1)
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : One α] => { ofNat := inst.one }
```

### D018: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `166f2abb65bf1271e5e8d70fdb78c55672c7e366b30439e83b517f803cdefac3`

Type:

```lean
DivInvMonoid Real
```

Fully explicit type:

```lean
DivInvMonoid.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toMonoid := Real.instMonoid, toInv := Real.instInv, div := DivInvMonoid.div',
  div_eq_mul_inv := Real.instDivInvMonoid._proof_1, zpow := zpowRec, zpow_zero' := Real.instDivInvMonoid._proof_2,
  zpow_succ' := Real.instDivInvMonoid._proof_3, zpow_neg' := Real.instDivInvMonoid._proof_4 }
```

### D019: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b4e24b050b7fb50c4c115c51d5cd4c1b180cae53633f58a38c7d5ce3ccf86c81`

Type:

```lean
One Real
```

Fully explicit type:

```lean
One.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ one := Real.one✝ }
```

### D020: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Div.{u_1} α] → HDiv.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```

### D021: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `9f462478f386574fd7569e563d721a64f21c5295bfcf7cefd0155a3da4c98b53`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.
