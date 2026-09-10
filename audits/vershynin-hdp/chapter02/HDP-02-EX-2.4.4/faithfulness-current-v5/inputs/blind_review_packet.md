# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
∀ (p : Nat → (Set.Icc 0 1).Elem) (k : Nat → Nat),
  (∀ (n : Nat), Eq (k n).cast (instHMul.hMul (instHMul.hMul 10 (instHSub.hSub n 1).cast) (p n).val)) →
    Filter.Tendsto (fun n => instHDiv.hDiv (k n).cast (Real.log n.cast)) Filter.atTop (nhds 0) →
      Filter.Eventually
        (fun n =>
          GE.ge
            ((LocalDef003 n (p n)).graphLaw.real
              (setOf fun G =>
                Exists fun v =>
                  instLENat.le (k n)
                    ((LocalDef003 n (p n)).degree v G)))
            (9 / 10))
        Filter.atTop
```

## Fully explicit elaborated target type

```lean
∀
  (p :
    Nat →
      @Set.Elem.{0} Real
        (@Set.Icc.{0} Real Real.instPreorder (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
          (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))))
  (k : Nat → Nat)
  (hrel :
    ∀ (n : Nat),
      @Eq.{1} Real (@Nat.cast.{0} Real Real.instNatCast (k n))
        (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
          (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
            (@OfNat.ofNat.{0} Real (nat_lit 10)
              (@instOfNatAtLeastTwo.{0} Real (nat_lit 10) Real.instNatCast
                (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 9) (instOfNatNat (nat_lit 9)))
                  (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 8) (instOfNatNat (nat_lit 8)))))))
            (@Nat.cast.{0} Real Real.instNatCast
              (@HSub.hSub.{0, 0, 0} Nat Nat Nat (@instHSub.{0} Nat instSubNat) n
                (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))))
          (@Subtype.val.{1} Real
            (fun (x : Real) =>
              @Membership.mem.{0, 0} Real (Set.{0} Real) (@Set.instMembership.{0} Real)
                (@Set.Icc.{0} Real Real.instPreorder
                  (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                  (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
                x)
            (p n))))
  (hsmall :
    @Filter.Tendsto.{0, 0} Nat Real
      (fun (n : Nat) =>
        @HDiv.hDiv.{0, 0, 0} Real Real Real (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
          (@Nat.cast.{0} Real Real.instNatCast (k n)) (Real.log (@Nat.cast.{0} Real Real.instNatCast n)))
      (@Filter.atTop.{0} Nat Nat.instPreorder)
      (@nhds.{0} Real
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))),
  @Filter.Eventually.{0} Nat
    (fun (n : Nat) =>
      @GE.ge.{0} Real Real.instLE
        (@MeasureTheory.Measure.real.{0} (SimpleGraph.{0} (Fin n)) (@SimpleGraph.instMeasurableSpace.{0} (Fin n))
          (@LocalDef002 n (p n)
            (LocalDef003 n (p n)))
          (@setOf.{0} (SimpleGraph.{0} (Fin n)) fun (G : SimpleGraph.{0} (Fin n)) =>
            @Exists.{1} (Fin n) fun (v : Fin n) =>
              @LE.le.{0} Nat instLENat (k n)
                (@LocalDef001 n (p n)
                  (LocalDef003 n (p n)) v G)))
        (@HDiv.hDiv.{0, 0, 0} Real Real Real (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
          (@OfNat.ofNat.{0} Real (nat_lit 9)
            (@instOfNatAtLeastTwo.{0} Real (nat_lit 9) Real.instNatCast
              (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 8) (instOfNatNat (nat_lit 8)))
                (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 7) (instOfNatNat (nat_lit 7)))))))
          (@OfNat.ofNat.{0} Real (nat_lit 10)
            (@instOfNatAtLeastTwo.{0} Real (nat_lit 10) Real.instNatCast
              (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 9) (instOfNatNat (nat_lit 9)))
                (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 8) (instOfNatNat (nat_lit 8)))))))))
    (@Filter.atTop.{0} Nat Nat.instPreorder)
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `d222eaf60a11b9ab67a28cb05ded6f2e2e64f5a4d2adbf5079efe70b8db5fbe2`

Type:

```lean
{n : Nat} →
  {p : (Set.Icc 0 1).Elem} →
    LocalDef004 n p → Fin n → SimpleGraph (Fin n) → Nat
```

Definition body (one-level semantic boundary):

```lean
fun n p self => self.2
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7c94ed170eb826d51afa83cb0031ff313479fb5e2b56b534a5b109682c9e7f8a`

Type:

```lean
{n : Nat} →
  {p : (Set.Icc 0 1).Elem} →
    LocalDef004 n p →
      MeasureTheory.Measure (SimpleGraph (Fin n))
```

Definition body (one-level semantic boundary):

```lean
fun n p self => self.1
```

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `56f3530612effc17bd7783526c7fd7b00e848268e34fee5efecf31582adfdb20`

Type:

```lean
(n : Nat) → (p : (Set.Icc 0 1).Elem) → LocalDef004 n p
```

Definition body (one-level semantic boundary):

```lean
fun n p => { graphLaw := SimpleGraph.binomialRandom (Fin n) p, degree := fun v G => G.degree v }
```

### D004: `LocalDef004`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ac86907f8eea13c0f931b10e9ca0927c07c1a2f8557baae03c7bf791d5889ff0`

Type:

```lean
Nat → (Set.Icc 0 1).Elem → Type
```

### D005: `LocalDef005`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `ce45441d3a262b63b9c813832dbbeb24027cd58b921daad3437c913cc8e888be`

Type:

```lean
{n : Nat} →
  {p : (Set.Icc 0 1).Elem} →
    MeasureTheory.Measure (SimpleGraph (Fin n)) →
      (Fin n → SimpleGraph (Fin n) → Nat) → LocalDef004 n p
```

### D006: `LocalDef006`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `154a4fb5e00cd9359ef9888d06149f50fb4d88f8208ce0042e97bd0338c70b0d`

Type:

```lean
∀ (n : Nat) (v : Fin n) (G : SimpleGraph (Fin n)), Finite (Subtype fun x => Set.instMembership.mem (G.neighborSet v) x)
```

### D007: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D008: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D009: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

### D010: `Filter.Eventually`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `48c8fc03616b0f899835653f1d062e3de4f566255a80b15231ebdedcb0a5c4c4`

Type:

```lean
{α : Type u_1} → (α → Prop) → Filter α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} p f => Filter.instMembership.mem f (setOf fun x => p x)
```

### D011: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7e5f54349644c32198960083c0e0eb6c033c80a8656d02a78b3eae9a4f5131f2`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → (α → β) → Filter α → Filter β → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f l₁ l₂ => Filter.instPartialOrder.le (Filter.map f l₁) l₂
```

### D012: `Filter.atTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.AtTopBot.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f743a11da6fe9e156755f41ec35f4d61b87ca4af4575ede456b477a74caa45f3`

Type:

```lean
{α : Type u_3} → [Preorder α] → Filter α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Preorder α] => iInf fun a => Filter.principal (Set.Ici a)
```

### D013: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

### D014: `GE.ge`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `131874e93bc48da13f8ebac9085b31e74f8526201dea35f9078e764147586ec3`

Type:

```lean
{α : Type u} → [LE α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : LE α] a b => inst.le b a
```

### D015: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D016: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4e00447a4a8ef4c2ce13e307c56a1fbcd7fa8c732fe039a452b42477a50df2c6`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HMul α β γ] => self.1
```

### D017: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `98025b38d523c0eadea77ba4961a20b2a913b23c079c4bfeba24a7bfaa24a4bc`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSub α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSub α β γ] => self.1
```

### D018: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `54a32f2661f788eb2b860006c4d1e8031e126febafe1c8d03ce50529b773dc48`

Type:

```lean
{α : Type u} → [self : LE α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LE α] => self.1
```

### D019: `MeasureTheory.Measure.real`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4723537c549f4ae1a83b89820f96e884bcbc0bc734ccd6e543bbf82330bffc29`

Type:

```lean
{α : Type u_6} → {m : MeasurableSpace α} → MeasureTheory.Measure α → Set α → Real
```

Definition body (one-level semantic boundary):

```lean
fun {α} {m} μ s => (MeasureTheory.Measure.instFunLike.coe μ s).toReal
```

### D020: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `941ea3346e809f919727c21bfcdeea342714a6b83f1cf871d648aa2cb14d6e9e`

Type:

```lean
{α : outParam (Type u)} → {γ : Type v} → [self : Membership α γ] → γ → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} γ [self : Membership α γ] => self.1
```

### D021: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

### D022: `Nat.cast`

- Role: `external-frontier`
- Owner module: `Init.Data.Cast`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `6e24327ea908b1837083bb15aef27d593e950a2ff8ade81d8aa94bfe33b64450`

Type:

```lean
{R : Type u} → [NatCast R] → Nat → R
```

Definition body (one-level semantic boundary):

```lean
fun {R} [inst : NatCast R] => inst.natCast
```

### D023: `Nat.instAtLeastTwoHAddOfNat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Init`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `309ef94c4b7cfbe2e668952e6915279353921d5d48b6123a30f90dd932dac3e6`

Type:

```lean
∀ (n : Nat) [NeZero n], (instHAdd.hAdd n 1).AtLeastTwo
```

### D024: `Nat.instNeZeroSucc`

- Role: `external-frontier`
- Owner module: `Init.Data.Nat.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `a0735a528184c05594c4c79312c1225bb4dcffcdf0df7eb1a50c5733047c85ad`

Type:

```lean
∀ {n : Nat}, NeZero (instHAdd.hAdd n 1)
```

### D025: `Nat.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5ea89e9915200c8782bc933f9184e28eb38f4c9610b00cf1310cc6e6435642d8`

Type:

```lean
Preorder Nat
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D026: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Type:

```lean
{α : Type u} → (x : Nat) → [self : OfNat α x] → α
```

Definition body (one-level semantic boundary):

```lean
fun α x [self : OfNat α x] => self.1
```

### D027: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cc544b5b2a2aabc84389a9fe2f052127dc6dae9964782b117b9b19b773e542d5`

Type:

```lean
{α : Type u_1} → [One α] → OfNat α 1
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : One α] => { ofNat := inst.one }
```

### D028: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D029: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D030: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `166f2abb65bf1271e5e8d70fdb78c55672c7e366b30439e83b517f803cdefac3`

Type:

```lean
DivInvMonoid Real
```

Definition body (one-level semantic boundary):

```lean
{ toMonoid := Real.instMonoid, toInv := Real.instInv, div := DivInvMonoid.div',
  div_eq_mul_inv := Real.instDivInvMonoid._proof_1, zpow := zpowRec, zpow_zero' := Real.instDivInvMonoid._proof_2,
  zpow_succ' := Real.instDivInvMonoid._proof_3, zpow_neg' := Real.instDivInvMonoid._proof_4 }
```

### D031: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `144d825fc543455e17044e843560e0415f8e4e9da60afb52f34edb809b7c34d3`

Type:

```lean
LE Real
```

Definition body (one-level semantic boundary):

```lean
{ le := Real.le✝ }
```

### D032: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Type:

```lean
Mul Real
```

Definition body (one-level semantic boundary):

```lean
{ mul := Real.mul✝ }
```

### D033: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5fc7a7becbc71d472fa1a28bd92d79b4c6ea4fdc643db7380031a2b890ca7e15`

Type:

```lean
NatCast Real
```

Definition body (one-level semantic boundary):

```lean
{ natCast := fun n => { cauchy := n.cast } }
```

### D034: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b4e24b050b7fb50c4c115c51d5cd4c1b180cae53633f58a38c7d5ce3ccf86c81`

Type:

```lean
One Real
```

Definition body (one-level semantic boundary):

```lean
{ one := Real.one✝ }
```

### D035: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `896bb94fc15867c0df82ea0f639eb6116e90a24819a66a54db9442e47cba7274`

Type:

```lean
Preorder Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D036: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Type:

```lean
Zero Real
```

Definition body (one-level semantic boundary):

```lean
{ zero := Real.zero✝ }
```

### D037: `Real.log`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.SpecialFunctions.Log.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `0fc1548c4e035ffc98e6286d9013e4f3ecf2a9759ac9b01e450f593e258ae39a`

Type:

```lean
Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun x => if hx : Eq x 0 then 0 else (instFunLikeOrderIso (Set.Ioi 0).Elem Real).coe Real.expOrderIso.symm ⟨abs x, ⋯⟩
```

### D038: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Type:

```lean
PseudoMetricSpace Real
```

Definition body (one-level semantic boundary):

```lean
{ dist := fun x y => abs (instHSub.hSub x y), dist_self := Real.pseudoMetricSpace._proof_1, dist_comm := ⋯,
  dist_triangle := ⋯, edist_dist := Real.pseudoMetricSpace._proof_2, uniformity_dist := Real.pseudoMetricSpace._proof_3,
  cobounded_sets := Real.pseudoMetricSpace._proof_4 }
```

### D039: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a6e551515032966c16e4f42e4548ff1854c2dce05ffe51e98b66943caecc78ec`

Type:

```lean
Type u → Type u
```

Definition body (one-level semantic boundary):

```lean
fun α => α → Prop
```

### D040: `Set.Elem`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.CoeSort`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `2fa7a863ddf7e954e2026c0d7547ac9d781f4a5cb94968d0c9ed2c720b524fdb`

Type:

```lean
{α : Type u} → Set α → Type u
```

Definition body (one-level semantic boundary):

```lean
fun {α} s => Subtype fun x => Set.instMembership.mem s x
```

### D041: `Set.Icc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5d4d1d0cca151d5f96eb45776025e642f79e9040e66fffcf889bd1224442ecc8`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → α → Set α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] a b => setOf fun x => And (inst.le a x) (inst.le x b)
```

### D042: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5858be77d319c5a0e238602f16818ed6fb2e2b52a81ff7edb07bc219d652f201`

Type:

```lean
{α : Type u} → Membership α (Set α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { mem := Set.Mem }
```

### D043: `SimpleGraph`

- Role: `external-frontier`
- Owner module: `Mathlib.Combinatorics.SimpleGraph.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `92c46e19c8ae5bf29037355fa37f1cf9366755f85b12432f800f3f3435c27fa6`

Type:

```lean
Type u → Type u
```

### D044: `SimpleGraph.instMeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.SimpleGraph`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `668769081f9d3ecc495649c7f45cb42c94814ab770e8c2edff7f16f9903000c7`

Type:

```lean
{V : Type u_1} → MeasurableSpace (SimpleGraph V)
```

Definition body (one-level semantic boundary):

```lean
fun {V} => MeasurableSpace.comap SimpleGraph.Adj inferInstance
```

### D045: `Subtype.val`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `69c61ab82498e5563eaf5f0313ea7f2164c284c3dc742024a30332372a46663d`

Type:

```lean
{α : Sort u} → {p : α → Prop} → Subtype p → α
```

Definition body (one-level semantic boundary):

```lean
fun α p self => self.1
```

### D046: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
```

### D047: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Type:

```lean
{α : Type u_1} → [Zero α] → OfNat α 0
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Zero α] => { ofNat := inst.zero }
```

### D048: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```

### D049: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1fd375514ac68e29e7941c94ba308ea936395db23d0fee63a5c69dcccd3b2bdc`

Type:

```lean
{α : Type u_1} → [Mul α] → HMul α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Mul α] => { hMul := fun a b => inst.mul a b }
```

### D050: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `aa782f2b5af3d068f4c5340de4b32b193fece2c659a45582cc3024a19b550c87`

Type:

```lean
{α : Type u_1} → [Sub α] → HSub α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Sub α] => { hSub := fun a b => inst.sub a b }
```

### D051: `instLENat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `002e628e28a06e89ab80e69408fa3be9fc3e200fafd33e0f71d9111a8944875e`

Type:

```lean
LE Nat
```

Definition body (one-level semantic boundary):

```lean
{ le := Nat.le }
```

### D052: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `37355febc51d6fa8ff12fc8e7b429771db340390d46411d7608c566bdffd358d`

Type:

```lean
{R : Type u_1} → {n : Nat} → [NatCast R] → [n.AtLeastTwo] → OfNat R n
```

Definition body (one-level semantic boundary):

```lean
fun {R} {n} [NatCast R] [n.AtLeastTwo] => { ofNat := n.cast }
```

### D053: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7018dea92aae8c272f3a065f25e2bedb9732a0b602c3d54b166fa0cf2ce1ea92`

Type:

```lean
(n : Nat) → OfNat Nat n
```

Definition body (one-level semantic boundary):

```lean
fun n => { ofNat := n }
```

### D054: `instSubNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5b0e20a4d2b3e0a67bd35de1b5c84cc60d6dc867658112d84cad483055804868`

Type:

```lean
Sub Nat
```

Definition body (one-level semantic boundary):

```lean
{ sub := Nat.sub }
```

### D055: `nhds`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8eb445823f4b15a765f7e0cd634f73196d36b4f09054d2aef43a69d3138c6ce8`

Type:

```lean
{X : Type u_3} → [TopologicalSpace X] → X → Filter X
```

Definition body (one-level semantic boundary):

```lean
wrapped✝.1
```

### D056: `setOf`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cee4433aebd78c308ec85f62ccd30489c00ec9cc23a98f4d2139c17f840f4988`

Type:

```lean
{α : Type u} → (α → Prop) → Set α
```

Definition body (one-level semantic boundary):

```lean
fun {α} p => p
```

### D057: `Fintype.ofFinite`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.EquivFin`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b1750c9a619b9b950014bf300edca8639934bfa9ec4fa4b387b3c0c752a0461b`

Type:

```lean
(α : Type u_4) → [Finite α] → Fintype α
```

Definition body (one-level semantic boundary):

```lean
fun α [Finite α] => ⋯.some
```

### D058: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

### D059: `SimpleGraph.binomialRandom`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Combinatorics.BinomialRandomGraph.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5d550211974c376aa5ced20f62a15496d1439400a62440076cc623e2f858ed99`

Type:

```lean
(V : Type u_1) → unitInterval.Elem → MeasureTheory.Measure (SimpleGraph V)
```

Definition body (one-level semantic boundary):

```lean
fun V p =>
  MeasureTheory.Measure.comap SimpleGraph.edgeSet (ProbabilityTheory.setBernoulli (Set.instCompl.compl Sym2.diagSet) p)
```

### D060: `SimpleGraph.degree`

- Role: `external-frontier`
- Owner module: `Mathlib.Combinatorics.SimpleGraph.Finite`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `ee55c1bc28f6cb2d8b2c398e9cf28ec1279efeec7656bd4e3a76ed825b3bc910`

Type:

```lean
{V : Type u_1} → (G : SimpleGraph V) → (v : V) → [Fintype (G.neighborSet v).Elem] → Nat
```

Definition body (one-level semantic boundary):

```lean
fun {V} G v [Fintype (G.neighborSet v).Elem] => (G.neighborFinset v).card
```

### D061: `SimpleGraph.neighborSet`

- Role: `external-frontier`
- Owner module: `Mathlib.Combinatorics.SimpleGraph.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `bf7238776e298f4c2764a44b104e97d7022a104357e30eff3633803645f8249b`

Type:

```lean
{V : Type u} → SimpleGraph V → V → Set V
```

Definition body (one-level semantic boundary):

```lean
fun {V} G v => setOf fun w => G.Adj v w
```

### D062: `Finite`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finite.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `537db26f6ac8c8862510b4e62d2075a1b3bc15b0d8f9ac538484e1258a3070a4`

Type:

```lean
Sort u_3 → Prop
```

### D063: `Subtype`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `3b0bb8433bd0c981dbdb4d6256bf74c50e9883207dae8d309dcb705135cf932c`

Type:

```lean
{α : Sort u} → (α → Prop) → Sort (max 1 u)
```
