# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
LocalDef001
```

## Fully explicit elaborated target type

```lean
LocalDef001
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `83fc78eee203a5e5415c3339da563124f72ef1e63924c6e1c1104b6c61859de4`

Type:

```lean
Prop
```

Definition body (one-level semantic boundary):

```lean
∀ (f : Real → Real),
  Iff (Exists fun ψ => Eq ψ.toFun f)
    (And (∀ (x : Real), Real.instLE.le 0 x → Real.instLE.le 0 (f x))
      (And (ConvexOn Real (Set.Ici 0) f)
        (And (MonotoneOn f (Set.Ici 0)) (And (Eq (f 0) 0) (Filter.Tendsto f Filter.atTop Filter.atTop)))))
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `7011593b6be51e53abae7670f8e51ffcf4631eae3446444623021b95101eeff6`

Type:

```lean
Type
```

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f7ebf35ffacdd553408f1e68f130c86eee6335e55ae16df024ed061548f26449`

Type:

```lean
LocalDef002 → Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.1
```

### D004: `LocalDef004`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `8938ffc6e0130d73d09ca649050bb05cf343ad8f7cd6dd3d48e6b808312d74e9`

Type:

```lean
(toFun : Real → Real) →
  (∀ (x : Real), Real.instLE.le 0 x → Real.instLE.le 0 (toFun x)) →
    ConvexOn Real (Set.Ici 0) toFun →
      MonotoneOn toFun (Set.Ici 0) →
        Eq (toFun 0) 0 →
          Filter.Tendsto toFun Filter.atTop Filter.atTop → LocalDef002
```

### D005: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5305322be4a562f24a6e568a2b0f4a4e3d7cf5ae9a842e07f0c4058c86e0fc14`

Type:

```lean
(R : Type u) → [inst : CommSemiring R] → Algebra R R
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

### D006: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `7ed84d651a0f6a77f78d6fd14524fe110f2045971d1f824f15cc8f5b8071484f`

Type:

```lean
{R : Type u} → {A : Type v} → {inst : CommSemiring R} → {inst_1 : Semiring A} → [self : Algebra R A] → SMul R A
```

Definition body (one-level semantic boundary):

```lean
fun R A {inst} {inst_1} [self : Algebra R A] => self.1
```

### D007: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

### D008: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `bcda2e78d6b7602d359ab954baf5c3bd0f6b2503b3ec9a72e1a21a48b9d18d89`

Type:

```lean
{R : Type u} → [self : CommSemiring R] → Semiring R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : CommSemiring R] => self.1
```

### D009: `ConvexOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Convex.Function`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `100cf68baf548a86a1438cee4c0e55bbe6f48a052cdb7f3cde5f2ed44cc70d23`

Type:

```lean
(𝕜 : Type u_1) →
  {E : Type u_2} →
    {β : Type u_5} →
      [Semiring 𝕜] →
        [PartialOrder 𝕜] →
          [AddCommMonoid E] → [AddCommMonoid β] → [PartialOrder β] → [SMul 𝕜 E] → [SMul 𝕜 β] → Set E → (E → β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 {E} {β} [Semiring 𝕜] [inst_1 : PartialOrder 𝕜] [AddCommMonoid E] [AddCommMonoid β] [inst_4 : PartialOrder β]
    [SMul 𝕜 E] [SMul 𝕜 β] s f =>
  And (Convex 𝕜 s)
    (∀ ⦃x : E⦄,
      Set.instMembership.mem s x →
        ∀ ⦃y : E⦄,
          Set.instMembership.mem s y →
            ∀ ⦃a b : 𝕜⦄,
              inst_1.le 0 a →
                inst_1.le 0 b →
                  Eq (instHAdd.hAdd a b) 1 →
                    inst_4.le (f (instHAdd.hAdd (instHSMul.hSMul a x) (instHSMul.hSMul b y)))
                      (instHAdd.hAdd (instHSMul.hSMul a (f x)) (instHSMul.hSMul b (f y))))
```

### D010: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D011: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

### D012: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7e5f54349644c32198960083c0e0eb6c033c80a8656d02a78b3eae9a4f5131f2`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → (α → β) → Filter α → Filter β → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f l₁ l₂ => Filter.instPartialOrder.le (Filter.map f l₁) l₂
```

### D013: `Filter.atTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.AtTopBot.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f743a11da6fe9e156755f41ec35f4d61b87ca4af4575ede456b477a74caa45f3`

Type:

```lean
{α : Type u_3} → [Preorder α] → Filter α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Preorder α] => iInf fun a => Filter.principal (Set.Ici a)
```

### D014: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

### D015: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `54a32f2661f788eb2b860006c4d1e8031e126febafe1c8d03ce50529b773dc48`

Type:

```lean
{α : Type u} → [self : LE α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LE α] => self.1
```

### D016: `MonotoneOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Monotone.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `81a612dcb914ff1895f07c02c9403bf6daf805789d8aec446d57f2cd6e179896`

Type:

```lean
{α : Type u} → {β : Type v} → [Preorder α] → [Preorder β] → (α → β) → Set α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : Preorder α] [inst_1 : Preorder β] f s =>
  ∀ ⦃a : α⦄, Set.instMembership.mem s a → ∀ ⦃b : α⦄, Set.instMembership.mem s b → inst.le a b → inst_1.le (f a) (f b)
```

### D017: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Type:

```lean
{α : Type u} → (x : Nat) → [self : OfNat α x] → α
```

Definition body (one-level semantic boundary):

```lean
fun α x [self : OfNat α x] => self.1
```

### D018: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D019: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `11a549e6c9caa007a4627570dd86aea756ada755f141da0356b8766788f2eef7`

Type:

```lean
AddCommMonoid Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D020: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `092dfdf642984bd4a336b502f7ac3f87adafd02a6236ba9033e90c0e1439ca7d`

Type:

```lean
CommSemiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D021: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `144d825fc543455e17044e843560e0415f8e4e9da60afb52f34edb809b7c34d3`

Type:

```lean
LE Real
```

Definition body (one-level semantic boundary):

```lean
{ le := Real.le✝ }
```

### D022: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `896bb94fc15867c0df82ea0f639eb6116e90a24819a66a54db9442e47cba7274`

Type:

```lean
Preorder Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D023: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Type:

```lean
Zero Real
```

Definition body (one-level semantic boundary):

```lean
{ zero := Real.zero✝ }
```

### D024: `Real.partialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c230e4cc01baeb2fcfa7d957f7e912e6e79376f736b5b58965ca7da585e8d66a`

Type:

```lean
PartialOrder Real
```

Definition body (one-level semantic boundary):

```lean
{ toLE := Real.instLE, toLT := Real.instLT, le_refl := ⋯, le_trans := ⋯, lt_iff_le_not_ge := ⋯, le_antisymm := ⋯ }
```

### D025: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Type:

```lean
Semiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D026: `Set.Ici`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `32e9548f07a5e31843a500e07f11e2e04776466d0284c00e33d88066bc211711`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → Set α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] b => setOf fun x => inst.le b x
```

### D027: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Type:

```lean
{α : Type u_1} → [Zero α] → OfNat α 0
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Zero α] => { ofNat := inst.zero }
```
