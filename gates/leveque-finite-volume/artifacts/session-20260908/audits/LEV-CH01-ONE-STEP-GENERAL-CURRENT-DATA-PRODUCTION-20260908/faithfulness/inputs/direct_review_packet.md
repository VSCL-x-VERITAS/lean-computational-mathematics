# Declaration dossier for LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_oneStepMethod_iff_attainableCurrentDataMap
    {History : Sort*} {CurrentData : Type*} {NextData : Sort*}
    (current : History → CurrentData) (advance : History → NextData) :
    (∀ history₁ history₂, current history₁ = current history₂ →
      advance history₁ = advance history₂) ↔
      ∃ step : Set.range current → NextData,
        advance = step ∘ Set.rangeFactorization current
```

## Elaborated target type

```lean
∀ {History : Sort u_1} {CurrentData : Type u_2} {NextData : Sort u_3} (current : History → CurrentData)
  (advance : History → NextData),
  Iff
    (∀ (history₁ history₂ : History),
      Eq (current history₁) (current history₂) → Eq (advance history₁) (advance history₂))
    (Exists fun step => Eq advance (Function.comp step (Set.rangeFactorization current)))
```

## Fully explicit elaborated target type

```lean
∀ {History : Sort u_1} {CurrentData : Type u_2} {NextData : Sort u_3} (current : History → CurrentData)
  (advance : History → NextData),
  Iff
    (∀ (history₁ history₂ : History),
      @Eq.{u_2 + 1} CurrentData (current history₁) (current history₂) →
        @Eq.{u_3} NextData (advance history₁) (advance history₂))
    (@Exists.{imax (u_2 + 1) u_3}
      (@Set.Elem.{u_2} CurrentData (@Set.range.{u_2, u_1} CurrentData History current) → NextData)
      fun (step : @Set.Elem.{u_2} CurrentData (@Set.range.{u_2, u_1} CurrentData History current) → NextData) =>
      @Eq.{imax u_1 u_3} (History → NextData) advance
        (@Function.comp.{u_1, u_2 + 1, u_3} History
          (@Set.Elem.{u_2} CurrentData (@Set.range.{u_2, u_1} CurrentData History current)) NextData step
          (@Set.rangeFactorization.{u_2, u_1} CurrentData History current)))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Logic.Function.RangeFactorization`
- `ComputationalMathematics.Logic.Function.RangeFactorization` imports: `Mathlib.Data.Set.Operations`, `Mathlib.Logic.Function.Basic`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `63522a7f14c7909bdc3b74e40f3dff8106b1aeec727b838bb5857305fb16dbba`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D002: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `b8e037b7ee8454967abd5ede341767dc41b18fd412a2ea7e9d3856f010a1dd5f`
- Reviewed interpretation: Existential quantification over a specified type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D003: `Function.comp`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `0cee10cad7daccc2e737572bb186d4e7e6af6dcbe0fe4e13ecc99929689d81cd`

Type:

```lean
{α : Sort u} → {β : Sort v} → {δ : Sort w} → (β → δ) → (α → β) → α → δ
```

Fully explicit type:

```lean
{α : Sort u} → {β : Sort v} → {δ : Sort w} → (f : β → δ) → (g : α → β) → α → δ
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} {δ} f g x => f (g x)
```

### D004: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Hash-verified prior declaration review:

- Reuse SHA-256: `385655c0e31bfe0bd19fe9a99c72f90b960c605078ce507320f666f7270060f6`
- Reviewed interpretation: Logical equivalence.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D005: `Set.Elem`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.CoeSort`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `2fa7a863ddf7e954e2026c0d7547ac9d781f4a5cb94968d0c9ed2c720b524fdb`

Type:

```lean
{α : Type u} → Set α → Type u
```

Fully explicit type:

```lean
{α : Type u} → (s : Set.{u} α) → Type u
```

Definition body (one-level semantic boundary):

```lean
fun {α} s => Subtype fun x => Set.instMembership.mem s x
```

### D006: `Set.range`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Operations`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `85783c4cf857eb087b23ac8fe18ab901afaa196ccbca332e40a92bd4915afe59`

Type:

```lean
{α : Type u} → {ι : Sort u_1} → (ι → α) → Set α
```

Fully explicit type:

```lean
{α : Type u} → {ι : Sort u_1} → (f : ι → α) → Set.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {ι} f => setOf fun x => Exists fun y => Eq (f y) x
```

### D007: `Set.rangeFactorization`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Operations`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3390776f8db1bdf6312efcd770634e44fa5cc6b6c786c90e2b63d1cfd9054fa8`

Type:

```lean
{α : Type u} → {ι : Sort u_1} → (f : ι → α) → ι → (Set.range f).Elem
```

Fully explicit type:

```lean
{α : Type u} → {ι : Sort u_1} → (f : ι → α) → ι → @Set.Elem.{u} α (@Set.range.{u, u_1} α ι f)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {ι} f i => ⟨f i, ⋯⟩
```
