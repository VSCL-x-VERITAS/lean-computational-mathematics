# Declaration dossier for LEV-CH01-ONE-STEP-METHOD-DEFINITION-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_oneStepMethod_iff_currentStateMap
    {Cell : Type*} {m : ℕ} (n : ℕ)
    (advance : (Fin (n + 1) → (Cell → Fin m → ℝ)) → (Cell → Fin m → ℝ)) :
    leveque01IsOneStepMethodAt n advance ↔
      ∃ step : (Cell → Fin m → ℝ) → (Cell → Fin m → ℝ),
        advance = step ∘ (fun history => history (Fin.last n))
```

## Elaborated target type

```lean
∀ {Cell : Type u_1} {m : Nat} (n : Nat)
  (advance : (Fin (instHAdd.hAdd n 1) → Cell → Fin m → Real) → Cell → Fin m → Real),
  Iff (NumStability.leveque01IsOneStepMethodAt n advance)
    (Exists fun step => Eq advance (Function.comp step fun history => history (Fin.last n)))
```

## Fully explicit elaborated target type

```lean
∀ {Cell : Type u_1} {m : Nat} (n : Nat)
  (advance :
    (Fin
          (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
            (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) →
        Cell → Fin m → Real) →
      Cell → Fin m → Real),
  Iff (@NumStability.leveque01IsOneStepMethodAt.{u_1} Cell m n advance)
    (@Exists.{u_1 + 1} ((Cell → Fin m → Real) → Cell → Fin m → Real)
      fun (step : (Cell → Fin m → Real) → Cell → Fin m → Real) =>
      @Eq.{u_1 + 1}
        ((Fin
              (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
                (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) →
            Cell → Fin m → Real) →
          Cell → Fin m → Real)
        advance
        (@Function.comp.{u_1 + 1, u_1 + 1, u_1 + 1}
          (Fin
              (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
                (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) →
            Cell → Fin m → Real)
          (Cell → Fin m → Real) (Cell → Fin m → Real) step
          fun
            (history :
              Fin
                  (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
                    (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) →
                Cell → Fin m → Real) =>
          history (Fin.last n)))
```

## Local import graph

- `AuditTarget` imports: `Mathlib.Data.Fin.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.Logic.Function.Basic`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.leveque01IsOneStepMethodAt`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8870f1101dc65d8b0c68c49a38f663184b2b93710482f5d63dc72959d48af5c1`

Type:

```lean
{Cell : Type u_1} →
  {m : Nat} → (n : Nat) → ((Fin (instHAdd.hAdd n 1) → Cell → Fin m → Real) → Cell → Fin m → Real) → Prop
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {m : Nat} →
    (n : Nat) →
      (advance :
          (Fin
                (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
                  (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))) →
              Cell → Fin m → Real) →
            Cell → Fin m → Real) →
        Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} {m} n advance => Function.FactorsThrough advance fun history => history (Fin.last n)
```

### D002: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `39e5d712f8b9aad981a3e0033fb34773c91d2d18aa78ceae215fff254098f57c`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D003: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `6359bd4891661a259e43b293071b870dfaf8d2663a00ef2b860ca97590591ec3`
- Reviewed interpretation: Existential quantification over a specified type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D004: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Hash-verified prior declaration review:

- Reuse SHA-256: `42f7e9d2dc9ef433c72f636953d97095440cad97655560bc45332db987086dc7`
- Reviewed interpretation: The standard finite index type of natural numbers below its parameter.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D005: `Fin.last`

- Role: `external-frontier`
- Owner module: `Init.Data.Fin.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b7cf2c761ad02a28a34dfdeee30ac4ec7bd4c3ff77700313e3ed2f37d473f5f2`

Type:

```lean
(n : Nat) → Fin (instHAdd.hAdd n 1)
```

Fully explicit type:

```lean
(n : Nat) →
  Fin
    (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
      (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
```

Definition body (one-level semantic boundary):

```lean
fun n => ⟨n, ⋯⟩
```

### D006: `Function.comp`

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

### D007: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `53176a5fdb3ab4aa2f268a561a58a549dc054913e8becee255de6c912d398329`
- Reviewed interpretation: Extracts the addition operation from the supplied HAdd instance.

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

### D009: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Hash-verified prior declaration review:

- Reuse SHA-256: `8ff28ee246e10f28be0ab7a8e23423d7b51e962a547cf5fe9c3cea6ce359a162`
- Reviewed interpretation: Natural numbers, including zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

### D012: `instAddNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D013: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `960f87c7c53933b2acf4803d94f9778313cfbc9ad9db91e0fb8010d571f48495`
- Reviewed interpretation: Uses the supplied homogeneous addition as heterogeneous addition with all types equal.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D014: `instOfNatNat`

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

### D015: `Function.FactorsThrough`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Function.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `929f34222497a270368cee65f4dd92ceb45c1ecb32b09372ed13ca5be7753930`

Type:

```lean
{α : Sort u_1} → {β : Sort u_2} → {γ : Sort u_3} → (α → γ) → (α → β) → Prop
```

Fully explicit type:

```lean
{α : Sort u_1} → {β : Sort u_2} → {γ : Sort u_3} → (g : α → γ) → (f : α → β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} {γ} g f => ∀ ⦃a b : α⦄, Eq (f a) (f b) → Eq (g a) (g b)
```
