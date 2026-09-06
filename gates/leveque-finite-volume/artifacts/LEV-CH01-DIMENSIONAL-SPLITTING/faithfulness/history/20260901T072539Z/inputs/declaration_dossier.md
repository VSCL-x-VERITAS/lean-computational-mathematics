# Declaration dossier for LEV-CH01-DIMENSIONAL-SPLITTING

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_dimensionalSplitting
    {State : Type*} (xDirectionSolve yDirectionSolve : State → State)
    (state : State) :
    orderedOperatorSweep [xDirectionSolve, yDirectionSolve] state =
      yDirectionSolve (xDirectionSolve state)
```

## Elaborated target type

```lean
∀ {State : Type u_1} (xDirectionSolve yDirectionSolve : State → State) (state : State),
  Eq (NumStability.orderedOperatorSweep (List.cons xDirectionSolve (List.cons yDirectionSolve List.nil)) state)
    (yDirectionSolve (xDirectionSolve state))
```

## Fully explicit elaborated target type

```lean
∀ {State : Type u_1} (xDirectionSolve yDirectionSolve : State → State) (state : State),
  @Eq.{u_1 + 1} State
    (@NumStability.orderedOperatorSweep.{u_1} State
      (@List.cons.{u_1} (State → State) xDirectionSolve
        (@List.cons.{u_1} (State → State) yDirectionSolve (@List.nil.{u_1} (State → State))))
      state)
    (yDirectionSolve (xDirectionSolve state))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting` imports: `Mathlib.Data.List.Basic`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.orderedOperatorSweep`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ded45e00fdb66124e4e954b7ce67fe13eb968f075d545f753830c16122d18920`

Type:

```lean
{State : Type u_1} → List (State → State) → State → State
```

Fully explicit type:

```lean
{State : Type u_1} → (operators : List.{u_1} (State → State)) → (state : State) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} operators state => List.foldl (fun current step => step current) state operators
```

### D002: `Eq`

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

### D003: `List.cons`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `d4f0bc0954b11abbe9f8e60dd8762e7797f488b1975b155440101828c4c1ea14`

Type:

```lean
{α : Type u} → α → List α → List α
```

Fully explicit type:

```lean
{α : Type u} → (head : α) → (tail : List.{u} α) → List.{u} α
```

### D004: `List.nil`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `6fc023f8c03f1dc78130598a9c55a666564e22fa908127753ee95d45e602196f`

Type:

```lean
{α : Type u} → List α
```

Fully explicit type:

```lean
{α : Type u} → List.{u} α
```

### D005: `List`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ec06a72bb009eecaedd9dbf6a3349bbea0bbc480e0a21179f4e21b3e219b952d`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

### D006: `List.foldl`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `528cbed637e4ef546b621011d5cf13a5a950202dac919ee6cff2046010954d44`

Type:

```lean
{α : Type u} → {β : Type v} → (α → β → α) → α → List β → α
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (f : α → β → α) → (init : α) → List.{v} β → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f x x_1 =>
  List.brecOn (motive := fun x => α → α) x_1
    (fun x f_1 x_2 =>
      List.foldl.match_1 (fun x x_3 => List.below (motive := fun x => α → α) x_3 → α) x_2 x (fun a x => a)
        (fun a b l x => x.1 (f a b)) f_1)
    x
```

## Complete local imported sources

### `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`

Path: `NumStability/Analysis/PartialDifferentialEquations/OperatorSplitting.lean`
SHA-256: `bc9540254e5f5de4e7780466ca1b7c99bfdda08aa77736385f2334216980809d`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.List.Basic

/-!
# Ordered operator splitting

An ordered sweep applies a finite list of one-direction update operators in
sequence.  The definition is independent of a grid or a particular PDE.
-/

namespace NumStability

/-- Apply update operators from left to right to an initial state. -/
def orderedOperatorSweep {State : Type*}
    (operators : List (State → State)) (state : State) : State :=
  operators.foldl (fun current step => step current) state

@[simp] theorem orderedOperatorSweep_nil {State : Type*} (state : State) :
    orderedOperatorSweep ([] : List (State → State)) state = state :=
  rfl

/-- A two-direction sweep first applies the first operator and then the
second. -/
@[simp] theorem orderedOperatorSweep_two
    {State : Type*} (first second : State → State) (state : State) :
    orderedOperatorSweep [first, second] state = second (first state) :=
  rfl

end NumStability
```
