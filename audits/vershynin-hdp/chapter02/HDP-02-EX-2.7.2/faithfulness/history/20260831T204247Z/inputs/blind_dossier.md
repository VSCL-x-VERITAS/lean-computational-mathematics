# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
Exists fun C =>
  And (Real.instLE.le 1 C)
    (∀ {Omega : Type u_1} [inst : MeasurableSpace Omega] {mu : MeasureTheory.Measure Omega}
      [MeasureTheory.IsProbabilityMeasure mu] {X : Omega → Real}
      (i j : LocalDef002) {Ki : Real},
      Real.instLT.lt 0 Ki →
        LocalDef001 mu X i Ki →
          Exists fun Kj =>
            And (Real.instLT.lt 0 Kj)
              (And (Real.instLE.le Kj (instHMul.hMul C Ki))
                (LocalDef001 mu X j Kj)))
```

## Fully explicit elaborated target type

```lean
@Exists.{1} Real fun (C : Real) =>
  And (@LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)) C)
    (∀ {Omega : Type u_1} [inst : MeasurableSpace.{u_1} Omega] {mu : @MeasureTheory.Measure.{u_1} Omega inst}
      [@MeasureTheory.IsProbabilityMeasure.{u_1} Omega inst mu] {X : Omega → Real}
      (i j : LocalDef002) {Ki : Real},
      @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) Ki →
        @LocalDef001.{u_1} Omega inst mu X i Ki →
          @Exists.{1} Real fun (Kj : Real) =>
            And
              (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                Kj)
              (And
                (@LE.le.{0} Real Real.instLE Kj
                  (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) C Ki))
                (@LocalDef001.{u_1} Omega inst mu X j Kj)))
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `39b569f1fc048d657846fa042cf52be499c0b4230f3298c3234fea6cdd5fc855`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    MeasureTheory.Measure Ω →
      (Ω → Real) → LocalDef002 → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X x =>
  LocalDef006 (fun x => Real → Prop) x
    (fun _ => LocalDef011 μ X)
    (fun _ => LocalDef004 μ X)
    (fun _ => LocalDef003 μ X) fun _ =>
    LocalDef005 μ X
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `dd8ec05e8403276e00781e6ce5cc1c0ddfb05fe1a1352280e847ef063774e005`

Type:

```lean
Type
```

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `d765e0f84d8252988df1880781bd9a2cd4513ce1939d9cbb53a85745d884ec5b`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (∀ (lam : Real),
        Real.instLE.le 0 lam →
          Real.instLE.le lam (Real.instInv.inv K) →
            And (MeasureTheory.Integrable (fun ω => Real.exp (instHMul.hMul lam (abs (X ω)))) μ)
              (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHMul.hMul lam (abs (X ω))))
                (Real.exp (instHMul.hMul K lam)))))
```

### D004: `LocalDef004`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `28484d21c7cb30ba7e5fdf35059da279aaf398fd4157cfbe3c6ab6ea764763e1`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X) (And (Real.instLT.lt 0 K) (LocalDef012 μ X K))
```

### D005: `LocalDef005`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `132c2042f51b72a898ecd8f3a27a7a687a91abecd66969b1c312f0d6f80ca77c`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (And (MeasureTheory.Integrable (fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) K)) μ)
        (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) K)) 2)))
```

### D006: `LocalDef006`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `098f7c708282b1faf14de95f5c9fe4a808a8d60b470e5c2350014b8653aa9e5c`

Type:

```lean
(motive : LocalDef002 → Sort u_1) →
  (x : LocalDef002) →
    (Unit → motive LocalDef010) →
      (Unit → motive LocalDef008) →
        (Unit → motive LocalDef007) →
          (Unit → motive LocalDef009) → motive x
```

Definition body (one-level semantic boundary):

```lean
fun motive x h_1 h_2 h_3 h_4 =>
  LocalDef013 x (h_1 Unit.unit) (h_2 Unit.unit)
    (h_3 Unit.unit) (h_4 Unit.unit)
```

### D007: `LocalDef007`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `cf6ea77e380b1d5b939cd5978e9a93432a562095a6d3b952a9b4539a555c8acf`

Type:

```lean
LocalDef002
```

### D008: `LocalDef008`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `31c065d2909e56c3975a717992695770377a1508faf5e8c6fdebd839980dd4cb`

Type:

```lean
LocalDef002
```

### D009: `LocalDef009`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `fd0113cd5f6057126392162ac81e9f1a7c78d7de9865d39de1d385eb6ebf3ec1`

Type:

```lean
LocalDef002
```

### D010: `LocalDef010`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `2ed10cea90b5f75dafa97644109faa397993804db100994fad59b350f7a10491`

Type:

```lean
LocalDef002
```

### D011: `LocalDef011`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6bdeae7b11467b2f1e46ea274a677f5fab6cb3769515eaa8d331aac1e7699381`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (∀ (t : Real),
        Real.instLE.le 0 t →
          Real.instLE.le (μ.real (setOf fun ω => GE.ge (abs (X ω)) t))
            (instHMul.hMul 2 (Real.exp (instHDiv.hDiv (Real.instNeg.neg t) K)))))
```

### D012: `LocalDef012`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `9ffe47a05f6be857182b323a0c7f88f52a77636f59cba2862ef9dace0f526795`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (AEMeasurable X μ)
    (∀ (p : Real),
      Real.instLE.le 1 p →
        And (MeasureTheory.Integrable (fun ω => instHPow.hPow (abs (X ω)) p) μ)
          (Real.instLE.le (MeasureTheory.integral μ fun ω => instHPow.hPow (abs (X ω)) p)
            (instHPow.hPow (instHMul.hMul K p) p)))
```

### D013: `LocalDef013`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `2044c7e51169627bd5e5bdb775888e13423534635280f8a49170e8e6ee89e0ea`

Type:

```lean
{motive : LocalDef002 → Sort u} →
  (t : LocalDef002) →
    motive LocalDef010 →
      motive LocalDef008 →
        motive LocalDef007 →
          motive LocalDef009 → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t tail moment absoluteMGF onePoint =>
  LocalDef015 tail moment absoluteMGF onePoint t
```

### D014: `LocalDef014`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `4dfa1be67ac90d2865df448f70c41581d162e3ce100f627913876bcb29084bfd`

Type:

```lean
(instHAdd.hAdd 1 1).AtLeastTwo
```

### D015: `LocalDef015`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `recursor`
- Distance from target type: `4`
- Semantic SHA-256: `a7763cee5a40c6e515576406cd0cb7608443ea9ac309de6e3af2abc1baeff041`

Type:

```lean
{motive : LocalDef002 → Sort u} →
  motive LocalDef010 →
    motive LocalDef008 →
      motive LocalDef007 →
        motive LocalDef009 →
          (t : LocalDef002) → motive t
```

### D016: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

### D017: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

### D018: `HMul.hMul`

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

### D019: `LE.le`

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

### D020: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Type:

```lean
{α : Type u} → [self : LT α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LT α] => self.1
```

### D021: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

### D022: `MeasureTheory.IsProbabilityMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `f88b269cb95d165125e7553fd22f97d6e5f9b1b9bcdec7f6738a781dc674bf89`

Type:

```lean
{α : Type u_1} → {m0 : MeasurableSpace α} → MeasureTheory.Measure α → Prop
```

### D023: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

### D024: `OfNat.ofNat`

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

### D025: `One.toOfNat1`

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

### D026: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D027: `Real.instLE`

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

### D028: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Type:

```lean
LT Real
```

Definition body (one-level semantic boundary):

```lean
{ lt := Real.lt✝ }
```

### D029: `Real.instMul`

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

### D030: `Real.instOne`

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

### D031: `Real.instZero`

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

### D032: `Zero.toOfNat0`

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

### D033: `instHMul`

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

### D034: `Unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8544f990089bb705329f8e13de94d6583865877bcb1ebec4f8c096524a17581e`

Type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
PUnit
```

### D035: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D036: `GE.ge`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `131874e93bc48da13f8ebac9085b31e74f8526201dea35f9078e764147586ec3`

Type:

```lean
{α : Type u} → [LE α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : LE α] a b => inst.le b a
```

### D037: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D038: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `683435a8d27d50ec1482d74d23f541d52d05ff0411c60f88d16c32132aca9f3e`

Type:

```lean
{𝕜 : Type u_4} →
  {E : Type u_5} →
    {inst : RCLike 𝕜} → {inst_1 : SeminormedAddCommGroup E} → [self : InnerProductSpace 𝕜 E] → NormedSpace 𝕜 E
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : InnerProductSpace 𝕜 E] => self.1
```

### D039: `Inv.inv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `c3aea3c6e2edd31a7b2cf071814315808ef7d84fd01d8c9b719313846ebca438`

Type:

```lean
{α : Type u} → [self : Inv α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Inv α] => self.1
```

### D040: `Measurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `6d56983cd98232a62c5c1b4a0368519a8b381777b32b6e8301ade2ccd7f4c3a4`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [MeasurableSpace α] → [MeasurableSpace β] → (α → β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [MeasurableSpace α] [MeasurableSpace β] f =>
  ∀ ⦃t : Set β⦄, MeasurableSet t → MeasurableSet (Set.preimage f t)
```

### D041: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `51e5158e8f2f2a375463d510858200b96afa04fb8f33126da2c5d1c572a76165`

Type:

```lean
{ε : Type u_5} →
  [inst : TopologicalSpace ε] →
    [ContinuousENorm ε] →
      {α : Type u_8} →
        {x : MeasurableSpace α} → (α → ε) → autoParam (MeasureTheory.Measure α) MeasureTheory.Integrable._auto_1 → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ε} [TopologicalSpace ε] [ContinuousENorm ε] {α} {x} f μ =>
  And (MeasureTheory.AEStronglyMeasurable f μ) (MeasureTheory.HasFiniteIntegral f μ)
```

### D042: `MeasureTheory.Measure.real`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4723537c549f4ae1a83b89820f96e884bcbc0bc734ccd6e543bbf82330bffc29`

Type:

```lean
{α : Type u_6} → {m : MeasurableSpace α} → MeasureTheory.Measure α → Set α → Real
```

Definition body (one-level semantic boundary):

```lean
fun {α} {m} μ s => (MeasureTheory.Measure.instFunLike.coe μ s).toReal
```

### D043: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `428563f3d6b771605a3267457bf33b62ec2efa91a42b57b96121b85c0269a9ab`

Type:

```lean
{α : Type u_6} →
  {G : Type u_7} →
    [inst : NormedAddCommGroup G] →
      [NormedSpace Real G] → {x : MeasurableSpace α} → MeasureTheory.Measure α → (α → G) → G
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.wrapped✝.1
```

### D044: `Neg.neg`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `0c56662a5d917c211c3cb741ca747b4a6710082af615cf071342ef70dee3a2c7`

Type:

```lean
{α : Type u} → [self : Neg α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Neg α] => self.1
```

### D045: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing α] → NonUnitalSeminormedRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSeminormedCommRing α] => self.1
```

### D046: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Type:

```lean
{α : Type u_2} → [NonUnitalSeminormedRing α] → SeminormedAddCommGroup α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : NonUnitalSeminormedRing α] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D047: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → SeminormedAddCommGroup E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D048: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → SeminormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toRing := β.toRing, toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯,
    norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D049: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D050: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `f602276baee30d3dbe02bd6b756a9097f750d59a7f91ca7635dcfc935fd22981`

Type:

```lean
{𝕜 : Type u_1} → [inst : RCLike 𝕜] → InnerProductSpace Real 𝕜
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [RCLike 𝕜] =>
  let __spread.0 := Inner.rclikeToReal 𝕜 𝕜;
  { toNormedSpace := NormedAlgebra.toNormedSpace 𝕜, toInner := __spread.0, norm_sq_eq_re_inner := ⋯,
    conj_inner_symm := ⋯, add_left := ⋯, smul_left := ⋯ }
```

### D051: `Real.exp`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Complex.Exponential`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `69806b1af98b09fabed435ccc47a9f2f0840f9c5c140fb62cccc81a80761a984`

Type:

```lean
Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun x => (Complex.exp (Complex.ofReal x)).re
```

### D052: `Real.instAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `f0de8cbc2c873a19be749cd9b2d3cc9a6edb9ebc92020a1877714a50c23d9dc0`

Type:

```lean
AddGroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D053: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D054: `Real.instInv`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `8996fd673a1e2289aaf761085a60a161bdafebda8cdd48d1efb3c89da1382980`

Type:

```lean
Inv Real
```

Definition body (one-level semantic boundary):

```lean
{ inv := Real.inv'✝ }
```

### D055: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5fc7a7becbc71d472fa1a28bd92d79b4c6ea4fdc643db7380031a2b890ca7e15`

Type:

```lean
NatCast Real
```

Definition body (one-level semantic boundary):

```lean
{ natCast := fun n => { cauchy := n.cast } }
```

### D056: `Real.instNeg`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `000951397468b3d1f8a2a1cca1de3812bc024916ff842cfd5454811130093b41`

Type:

```lean
Neg Real
```

Definition body (one-level semantic boundary):

```lean
{ neg := Real.neg✝ }
```

### D057: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `d2fdb97b9d861fcf61e6dbea9993dfa0ca6aa16609742f215c35b3f7ddd16b8e`

Type:

```lean
RCLike Real
```

Definition body (one-level semantic boundary):

```lean
{ toDenselyNormedField := Real.denselyNormedField, toStarRing := instStarRingReal,
  toNormedAlgebra := NormedAlgebra.id Real, toCompleteSpace := Real.instCompleteSpace, re := AddMonoidHom.id Real,
  im := 0, I := 0, I_re_ax := Real.instRCLike._proof_1, I_mul_I_ax := Real.instRCLike._proof_8, re_add_im_ax := ⋯,
  ofReal_re_ax := Real.instRCLike._proof_11, ofReal_im_ax := Real.instRCLike._proof_12, mul_re_ax := ⋯, mul_im_ax := ⋯,
  conj_re_ax := ⋯, conj_im_ax := ⋯, conj_I_ax := Real.instRCLike._proof_7, norm_sq_eq_def_ax := ⋯, mul_im_I_ax := ⋯,
  toPartialOrder := Real.partialOrder, le_iff_re_im := @Real.instRCLike._proof_13, toDecidableEq := Real.decidableEq }
```

### D058: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5bccf78d647cf08233ff548c19523f80b1d1bf11b5a76aa50396199e2c0c7510`

Type:

```lean
Lattice Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D059: `Real.measurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `51b107725c4edbe40e50ff5651a2c7ee5a10037e341c2764964a6d6cc26d82a1`

Type:

```lean
MeasurableSpace Real
```

Definition body (one-level semantic boundary):

```lean
borel Real
```

### D060: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Type:

```lean
NormedAddCommGroup Real
```

Definition body (one-level semantic boundary):

```lean
{ toNorm := Real.norm, toAddCommGroup := Real.instAddCommGroup, toMetricSpace := Real.metricSpace, dist_eq := ⋯ }
```

### D061: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Type:

```lean
NormedCommRing Real
```

Definition body (one-level semantic boundary):

```lean
let __src := Real.normedAddCommGroup;
let __src_1 := Real.commRing;
{ toNorm := __src.toNorm, toAddMonoid := __src.toAddMonoid, add_comm := Real.normedCommRing._proof_1,
  toMul := __src_1.toMul, left_distrib := Real.normedCommRing._proof_2, right_distrib := Real.normedCommRing._proof_3,
  zero_mul := Real.normedCommRing._proof_4, mul_zero := Real.normedCommRing._proof_5,
  mul_assoc := Real.normedCommRing._proof_6, toOne := __src_1.toOne, one_mul := Real.normedCommRing._proof_7,
  mul_one := Real.normedCommRing._proof_8, toNatCast := __src_1.toNatCast, natCast_zero := Real.normedCommRing._proof_9,
  natCast_succ := Real.normedCommRing._proof_10, npow := __src_1.npow, npow_zero := Real.normedCommRing._proof_11,
  npow_succ := Real.normedCommRing._proof_12, toNeg := __src.toNeg, toSub := __src.toSub,
  sub_eq_add_neg := Real.normedCommRing._proof_13, zsmul := __src.zsmul, zsmul_zero' := Real.normedCommRing._proof_14,
  zsmul_succ' := Real.normedCommRing._proof_15, zsmul_neg' := Real.normedCommRing._proof_16,
  neg_add_cancel := Real.normedCommRing._proof_17, toIntCast := __src_1.toIntCast,
  intCast_ofNat := Real.normedCommRing._proof_18, intCast_negSucc := Real.normedCommRing._proof_19,
  toMetricSpace := __src.toMetricSpace, dist_eq := ⋯, norm_mul_le := Real.normedCommRing._proof_20, mul_comm := ⋯ }
```

### D062: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D063: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `8cf35215f509cdee10a3a95158cbaadd3c5fb584bc0d1f4fad6ecfc69b1bd205`

Type:

```lean
{E : Type u_5} → [SeminormedAddCommGroup E] → SeminormedAddGroup E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : SeminormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D064: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `17a83cbf3059dd0bbaefd43c93ce329f1d6b760d440889322b3582a18b23a141`

Type:

```lean
{E : Type u_4} → [inst : SeminormedAddGroup E] → ContinuousENorm E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [SeminormedAddGroup E] => { toENorm := NNNorm.toENorm, continuous_enorm := ⋯ }
```

### D065: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Type:

```lean
{α : Type u_2} → [β : SeminormedCommRing α] → NonUnitalSeminormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : SeminormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D066: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
```

### D067: `Unit.unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e5d4ec6d7dbc312235968b914130d2d6ec344f051fd5f7c0276905a3c63cc953`

Type:

```lean
Unit
```

Definition body (one-level semantic boundary):

```lean
PUnit.unit
```

### D068: `abs`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Group.Unbundled.Abs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `8ec55bade8dee4d49822a9bdbd84db24c019b8d568452329d9766390229a9c1b`

Type:

```lean
{α : Type u_1} → [Lattice α] → [AddGroup α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Lattice α] [AddGroup α] a =>
  SemilatticeSup.toMax.max a (SubtractionMonoid.toSubNegZeroMonoid.toNegZeroClass.neg a)
```

### D069: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```

### D070: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `37355febc51d6fa8ff12fc8e7b429771db340390d46411d7608c566bdffd358d`

Type:

```lean
{R : Type u_1} → {n : Nat} → [NatCast R] → [n.AtLeastTwo] → OfNat R n
```

Definition body (one-level semantic boundary):

```lean
fun {R} {n} [NatCast R] [n.AtLeastTwo] => { ofNat := n.cast }
```

### D071: `setOf`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `cee4433aebd78c308ec85f62ccd30489c00ec9cc23a98f4d2139c17f840f4988`

Type:

```lean
{α : Type u} → (α → Prop) → Set α
```

Definition body (one-level semantic boundary):

```lean
fun {α} p => p
```

### D072: `AEMeasurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `6dc48478b911cadddc9129039bc8859282262cccd65bca8d46f3cdc5415a69cd`

Type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [MeasurableSpace β] →
      {_m : MeasurableSpace α} → (α → β) → autoParam (MeasureTheory.Measure α) AEMeasurable._auto_1 → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [MeasurableSpace β] {_m} f μ => Exists fun g => And (Measurable g) ((MeasureTheory.ae μ).EventuallyEq f g)
```

### D073: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D074: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `6196b8cbb884c4f39841ba74b23d75f3c753fe0d044cc402bd6e4e3bd59d5cb8`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HPow α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HPow α β γ] => self.1
```

### D075: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

### D076: `Nat.AtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Init`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `318e11b8f9340f2f451d638786dd4fca470dece62824f4adc3bd18b5289aa911`

Type:

```lean
Nat → Prop
```

### D077: `Real.instPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.SpecialFunctions.Pow.Real`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `d7348547260a6fa37dab6a95efbf0e3e5560a074d2443d0cb606f21bce228fe0`

Type:

```lean
Pow Real Real
```

Definition body (one-level semantic boundary):

```lean
{ pow := Real.rpow }
```

### D078: `instAddNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `a1534bcd3e1888406ac787d30eeff8a284cb6688c23f5e8de09351dda91a280c`

Type:

```lean
Add Nat
```

Definition body (one-level semantic boundary):

```lean
{ add := Nat.add }
```

### D079: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D080: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `eb300d353d84392c776cad5e356479f878030744a43f9a1584942a89d16350b4`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [Pow α β] → HPow α β α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : Pow α β] => { hPow := fun a b => inst.pow a b }
```

### D081: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `7018dea92aae8c272f3a065f25e2bedb9732a0b602c3d54b166fa0cf2ce1ea92`

Type:

```lean
(n : Nat) → OfNat Nat n
```

Definition body (one-level semantic boundary):

```lean
fun n => { ofNat := n }
```
