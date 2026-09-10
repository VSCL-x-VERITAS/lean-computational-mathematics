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
LocalDef001.{u_1}
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c908f3b3d45215420590bd06893a6116320846c59de7775f4e559aa4b5c1857d`

Type:

```lean
Prop
```

Definition body (one-level semantic boundary):

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω) [MeasureTheory.IsProbabilityMeasure μ]
  (ψ : LocalDef006),
  And
    (∀ (X : Subtype fun x => SetLike.instMembership.mem (LocalDef007 ψ μ) x),
      Real.instLE.le 0 ((LocalDef008 ψ μ).norm X))
    (And
      (∀
        (X :
          Subtype fun x => SetLike.instMembership.mem (LocalDef007 ψ μ) x),
        Iff (Eq ((LocalDef008 ψ μ).norm X) 0) (Eq X 0))
      (And
        (∀
          (X Y :
            Subtype fun x => SetLike.instMembership.mem (LocalDef007 ψ μ) x),
          Real.instLE.le ((LocalDef008 ψ μ).norm (instHAdd.hAdd X Y))
            (instHAdd.hAdd ((LocalDef008 ψ μ).norm X)
              ((LocalDef008 ψ μ).norm Y)))
        (∀ (c : Real)
          (X :
            Subtype fun x => SetLike.instMembership.mem (LocalDef007 ψ μ) x),
          Eq ((LocalDef008 ψ μ).norm (instHSMul.hSMul c X))
            (instHMul.hMul (abs c) ((LocalDef008 ψ μ).norm X)))))
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `c43c754f42607042f15e8fdf8c72d643301fa05b12e2c821ac62beb67b76da90`

Type:

```lean
ContinuousAdd Real
```

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `6b4ae4f45b5939d789b17ccd2e9dacddafa340d3d1fef100ac7805284f026246`

Type:

```lean
ContinuousConstSMul Real Real
```

### D004: `LocalDef004`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `ba1484c56ae4cd2640905fdd38ea8034fe88d803c68175e42866ee8a9459d3a4`

Type:

```lean
ContinuousConstSMul Real Real
```

### D005: `LocalDef005`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `aa33b288dd0e9495169d66474ca7016acf493e8716589798d12807a6082bd537`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω),
  IsScalarTower Real Real (MeasureTheory.AEEqFun Ω Real μ)
```

### D006: `LocalDef006`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `7011593b6be51e53abae7670f8e51ffcf4631eae3446444623021b95101eeff6`

Type:

```lean
Type
```

### D007: `LocalDef007`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1285790c2cdcf9a1b59eb83fbc093c0e95678d300ee5f6b6896a6dfcd2771490`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    LocalDef006 →
      (μ : MeasureTheory.Measure Ω) → Submodule Real (MeasureTheory.AEEqFun Ω Real μ)
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ =>
  {
    carrier :=
      setOf fun X =>
        ENNReal.instPartialOrder.lt (LocalDef010 ψ μ X) instTopENNReal.top,
    add_mem' := ⋯, zero_mem' := ⋯, smul_mem' := ⋯ }
```

### D008: `LocalDef008`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `216a8146ba284f3c8ea0b12d1afc717fe627cdd0de926b99dc87b7f68ef7ad17`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (ψ : LocalDef006) →
      (μ : MeasureTheory.Measure Ω) →
        Norm
          (Subtype fun x => SetLike.instMembership.mem (LocalDef007 ψ μ) x)
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ =>
  { norm := fun X => (LocalDef010 ψ μ X.val).toReal }
```

### D009: `LocalDef009`

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
          Filter.Tendsto toFun Filter.atTop Filter.atTop → LocalDef006
```

### D010: `LocalDef010`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b9b973dce41ba92c94d5f6ad6f2438922f2db563899ffce8eb9c53695fe95d96`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    LocalDef006 →
      (μ : MeasureTheory.Measure Ω) → MeasureTheory.AEEqFun Ω Real μ → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ X => LocalDef016 ψ μ X.cast
```

### D011: `LocalDef011`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `9448c2f7924164a9468c0135a2accd62572da2dbcaae9a7d2d57a415e9a30be8`

Type:

```lean
ContinuousAdd Real
```

### D012: `LocalDef012`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `90dc1716d1a809cdb59795db115097fdcfd51707c731b56f2378022b702346df`

Type:

```lean
ContinuousConstSMul Real Real
```

### D013: `LocalDef013`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `321fa0ed042734db4c3975f4a2851444d4c1bb6705a54619b47bdcb3472d9f26`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : LocalDef006)
  (μ : MeasureTheory.Measure Ω) {X Y : MeasureTheory.AEEqFun Ω Real μ},
  Set.instMembership.mem
      (setOf fun X =>
        ENNReal.instPartialOrder.lt (LocalDef010 ψ μ X) instTopENNReal.top)
      X →
    Set.instMembership.mem
        (setOf fun X =>
          ENNReal.instPartialOrder.lt (LocalDef010 ψ μ X) instTopENNReal.top)
        Y →
      ENNReal.instPartialOrder.lt (LocalDef010 ψ μ (instHAdd.hAdd X Y))
        instTopENNReal.top
```

### D014: `LocalDef014`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `68ed4a294401cf21f2d1188da9964c9b0b465a46f5688ec3629164953235ce78`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : LocalDef006)
  (μ : MeasureTheory.Measure Ω),
  ENNReal.instPartialOrder.lt (LocalDef010 ψ μ 0) instTopENNReal.top
```

### D015: `LocalDef015`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `0b3e6a4a5e16c1421acdff2ad1d98fae329e69ee792035eb0edec9e65743291c`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : LocalDef006)
  (μ : MeasureTheory.Measure Ω) (c : Real) {X : MeasureTheory.AEEqFun Ω Real μ},
  Set.instMembership.mem
      (setOf fun X =>
        ENNReal.instPartialOrder.lt (LocalDef010 ψ μ X) instTopENNReal.top)
      X →
    Set.instMembership.mem
      (setOf fun X =>
        ENNReal.instPartialOrder.lt (LocalDef010 ψ μ X) instTopENNReal.top)
      (instHSMul.hSMul c X)
```

### D016: `LocalDef016`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `934176762a9437fa55669c03194f1af7b845fd410ffe54b39c592e720fee35e8`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    LocalDef006 → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ X =>
  ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf.sInf
    (setOf fun t => LocalDef017 ψ μ X t)
```

### D017: `LocalDef017`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `f65d65c4bb2bc6af96f31133b7108a7cd6da39bc62235826b3414cb3acebc2aa`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    LocalDef006 → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ X t =>
  And (Ne t 0)
    (And (Ne t instTopENNReal.top)
      (ENNReal.instPartialOrder.le (LocalDef018 ψ μ X t) 1))
```

### D018: `LocalDef018`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `1e58bed46a5006c5764654d44fa3890b54901b3fa56b0da0b7297fcfce6f2bb9`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    LocalDef006 → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ X t =>
  MeasureTheory.lintegral μ fun ω => ENNReal.ofReal (ψ.toFun (instHDiv.hDiv (abs (X ω)) t.toReal))
```

### D019: `LocalDef019`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `f7ebf35ffacdd553408f1e68f130c86eee6335e55ae16df024ed061548f26449`

Type:

```lean
LocalDef006 → Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.1
```

### D020: `Algebra.id`

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

### D021: `Algebra.toSMul`

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

### D022: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

### D023: `CommSemiring.toSemiring`

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

### D024: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D025: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D026: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `4e00447a4a8ef4c2ce13e307c56a1fbcd7fa8c732fe039a452b42477a50df2c6`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HMul α β γ] => self.1
```

### D027: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f1757307432fadbd23925bbf0a318b8da57d17711478e1073a19ce64c21d55f4`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSMul α β γ] => self.1
```

### D028: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

### D029: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D030: `LE.le`

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

### D031: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

### D032: `MeasureTheory.AEEqFun`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6617e69bba6f9e44b27a7929a11353f104ce0c7b079a276babaa71beeb73cdac`

Type:

```lean
(α : Type u_1) →
  (β : Type u_2) → [inst : MeasurableSpace α] → [TopologicalSpace β] → MeasureTheory.Measure α → Type (max u_1 u_2)
```

Definition body (one-level semantic boundary):

```lean
fun α β [MeasurableSpace α] [TopologicalSpace β] μ => Quotient (MeasureTheory.Measure.aeEqSetoid β μ)
```

### D033: `MeasureTheory.AEEqFun.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `723e40cc6af2d7702d1f5aaee1691acdff67abea06a0b4921e766a8a7c51aa53`

Type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} →
        [inst_1 : TopologicalSpace γ] →
          [inst_2 : AddCommMonoid γ] → [ContinuousAdd γ] → AddCommMonoid (MeasureTheory.AEEqFun α γ μ)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {γ} [MeasurableSpace α] {μ} [TopologicalSpace γ] [AddCommMonoid γ] [ContinuousAdd γ] =>
  Function.Injective.addCommMonoid MeasureTheory.AEEqFun.toGerm ⋯ ⋯ ⋯ ⋯
```

### D034: `MeasureTheory.AEEqFun.instModule`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `4296f275a87d76a3c3006fa92ecca5aea7c03a4fd399b294debcad0fd83be022`

Type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} →
        [inst_1 : TopologicalSpace γ] →
          {𝕜 : Type u_5} →
            [inst_2 : Semiring 𝕜] →
              [inst_3 : AddCommMonoid γ] →
                [inst_4 : ContinuousAdd γ] →
                  [inst_5 : Module 𝕜 γ] → [ContinuousConstSMul 𝕜 γ] → Module 𝕜 (MeasureTheory.AEEqFun α γ μ)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {γ} [MeasurableSpace α] {μ} [TopologicalSpace γ] {𝕜} [Semiring 𝕜] [AddCommMonoid γ] [ContinuousAdd γ]
    [Module 𝕜 γ] [ContinuousConstSMul 𝕜 γ] =>
  Function.Injective.module 𝕜 MeasureTheory.AEEqFun.toGermAddMonoidHom ⋯ ⋯
```

### D035: `MeasureTheory.AEEqFun.instSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `df789446af6cc71f28ecdaa2fb46628beb96bf85b91309f0f6cafa0c923af668`

Type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} →
        [inst_1 : TopologicalSpace γ] →
          {𝕜 : Type u_5} → [inst_2 : SMul 𝕜 γ] → [ContinuousConstSMul 𝕜 γ] → SMul 𝕜 (MeasureTheory.AEEqFun α γ μ)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {γ} [MeasurableSpace α] {μ} [TopologicalSpace γ] {𝕜} [SMul 𝕜 γ] [ContinuousConstSMul 𝕜 γ] =>
  { smul := fun c f => MeasureTheory.AEEqFun.comp (fun x => instHSMul.hSMul c x) ⋯ f }
```

### D036: `MeasureTheory.IsProbabilityMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `f88b269cb95d165125e7553fd22f97d6e5f9b1b9bcdec7f6738a781dc674bf89`

Type:

```lean
{α : Type u_1} → {m0 : MeasurableSpace α} → MeasureTheory.Measure α → Prop
```

### D037: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

### D038: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `941ea3346e809f919727c21bfcdeea342714a6b83f1cf871d648aa2cb14d6e9e`

Type:

```lean
{α : outParam (Type u)} → {γ : Type v} → [self : Membership α γ] → γ → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} γ [self : Membership α γ] => self.1
```

### D039: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing α] → NonUnitalSeminormedRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSeminormedCommRing α] => self.1
```

### D040: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D041: `Norm.norm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `25f5aa97df9bb1faeacd7e5e6446ecbd367452a7105f098063355423713fe15a`

Type:

```lean
{E : Type u_8} → [self : Norm E] → E → Real
```

Definition body (one-level semantic boundary):

```lean
fun E [self : Norm E] => self.1
```

### D042: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D043: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Type:

```lean
{𝕜 : Type u_6} →
  {E : Type u_7} → {inst : NormedField 𝕜} → {inst_1 : SeminormedAddCommGroup E} → [self : NormedSpace 𝕜 E] → Module 𝕜 E
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : NormedSpace 𝕜 E] => self.1
```

### D044: `OfNat.ofNat`

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

### D045: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D046: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D047: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D048: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Type:

```lean
Add Real
```

Definition body (one-level semantic boundary):

```lean
{ add := Real.add✝ }
```

### D049: `Real.instAddCommMonoid`

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

### D050: `Real.instAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f0de8cbc2c873a19be749cd9b2d3cc9a6edb9ebc92020a1877714a50c23d9dc0`

Type:

```lean
AddGroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D051: `Real.instCommSemiring`

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

### D052: `Real.instLE`

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

### D053: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Type:

```lean
Mul Real
```

Definition body (one-level semantic boundary):

```lean
{ mul := Real.mul✝ }
```

### D054: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D055: `Real.instZero`

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

### D056: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5bccf78d647cf08233ff548c19523f80b1d1bf11b5a76aa50396199e2c0c7510`

Type:

```lean
Lattice Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D057: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D058: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Type:

```lean
NormedField Real
```

Definition body (one-level semantic boundary):

```lean
let __src := Real.normedAddCommGroup;
let __src_1 := Real.instField;
{ toNorm := __src.toNorm, toAddMonoid := __src.toAddMonoid, add_comm := Real.normedField._proof_1,
  toMul := __src_1.toMul, left_distrib := Real.normedField._proof_2, right_distrib := Real.normedField._proof_3,
  zero_mul := Real.normedField._proof_4, mul_zero := Real.normedField._proof_5, mul_assoc := Real.normedField._proof_6,
  toOne := __src_1.toOne, one_mul := Real.normedField._proof_7, mul_one := Real.normedField._proof_8,
  toNatCast := __src_1.toNatCast, natCast_zero := Real.normedField._proof_9, natCast_succ := Real.normedField._proof_10,
  npow := __src_1.npow, npow_zero := Real.normedField._proof_11, npow_succ := Real.normedField._proof_12,
  toNeg := __src.toNeg, toSub := __src.toSub, sub_eq_add_neg := Real.normedField._proof_13, zsmul := __src.zsmul,
  zsmul_zero' := Real.normedField._proof_14, zsmul_succ' := Real.normedField._proof_15,
  zsmul_neg' := Real.normedField._proof_16, neg_add_cancel := Real.normedField._proof_17,
  toIntCast := __src_1.toIntCast, intCast_ofNat := Real.normedField._proof_18,
  intCast_negSucc := Real.normedField._proof_19, mul_comm := Real.normedField._proof_20, toInv := __src_1.toInv,
  toDiv := __src_1.toDiv, div_eq_mul_inv := ⋯, zpow := __src_1.zpow, zpow_zero' := ⋯, zpow_succ' := ⋯, zpow_neg' := ⋯,
  toNontrivial := ⋯, toNNRatCast := __src_1.toNNRatCast, toRatCast := __src_1.toRatCast, mul_inv_cancel := ⋯,
  inv_zero := ⋯, nnratCast_def := ⋯, nnqsmul := __src_1.nnqsmul, nnqsmul_def := ⋯, ratCast_def := ⋯,
  qsmul := __src_1.qsmul, qsmul_def := ⋯, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯, norm_mul := ⋯ }
```

### D059: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D060: `Real.semiring`

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

### D061: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D062: `SetLike.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.SetLike.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `47a75450bbb51c4e8fdd9e8881cc3fa741dfb5f1f186d952055686e285c081e4`

Type:

```lean
{A : Type u_1} → {B : Type u_2} → [i : SetLike A B] → Membership B A
```

Definition body (one-level semantic boundary):

```lean
fun {A} {B} [i : SetLike A B] => { mem := fun p x => Set.instMembership.mem (i.coe p) x }
```

### D063: `Submodule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `dc34d51ab2952b775b09278f439d1d0393daf90ed359c8f26aeec99b295179db`

Type:

```lean
(R : Type u) → (M : Type v) → [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [Module R M] → Type v
```

### D064: `Submodule.add`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `31330c71327149cd083c0b33ed8b59646bae3ce84dbd26c60d52b34d4f051a76`

Type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring R] →
      [inst_1 : AddCommMonoid M] →
        {module_M : Module R M} → (p : Submodule R M) → Add (Subtype fun x => SetLike.instMembership.mem p x)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Semiring R] [AddCommMonoid M] {module_M} p => { add := fun x y => ⟨instHAdd.hAdd x.val y.val, ⋯⟩ }
```

### D065: `Submodule.setLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb9ef22942558eec688655f5d38b6e84772742d6fe6ccb549666f024240be8a7`

Type:

```lean
{R : Type u} →
  {M : Type v} → [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [inst_2 : Module R M] → SetLike (Submodule R M) M
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Semiring R] [AddCommMonoid M] [Module R M] => { coe := fun s => s.carrier, coe_injective' := ⋯ }
```

### D066: `Submodule.smul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `0a4255b8b6b54fe976dba25d35e6a7d7466e22a9eb234fe9ea56279bbcd1790e`

Type:

```lean
{S : Type u'} →
  {R : Type u} →
    {M : Type v} →
      [inst : Semiring R] →
        [inst_1 : AddCommMonoid M] →
          {module_M : Module R M} →
            (p : Submodule R M) →
              [inst_2 : SMul S R] →
                [inst_3 : SMul S M] → [IsScalarTower S R M] → SMul S (Subtype fun x => SetLike.instMembership.mem p x)
```

Definition body (one-level semantic boundary):

```lean
fun {S} {R} {M} [Semiring R] [AddCommMonoid M] {module_M} p [SMul S R] [SMul S M] [IsScalarTower S R M] =>
  { smul := fun c x => ⟨instHSMul.hSMul c x.val, ⋯⟩ }
```

### D067: `Submodule.zero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7eed11cb94c31fff612dafd1fb5a06085a858b3cbbcfd8044f1726980978e117`

Type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring R] →
      [inst_1 : AddCommMonoid M] →
        {module_M : Module R M} → (p : Submodule R M) → Zero (Subtype fun x => SetLike.instMembership.mem p x)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Semiring R] [AddCommMonoid M] {module_M} p => { zero := ⟨0, ⋯⟩ }
```

### D068: `Subtype`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `3b0bb8433bd0c981dbdb4d6256bf74c50e9883207dae8d309dcb705135cf932c`

Type:

```lean
{α : Sort u} → (α → Prop) → Sort (max 1 u)
```

### D069: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
```

### D070: `Zero.toOfNat0`

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

### D071: `abs`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Group.Unbundled.Abs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D072: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D073: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1fd375514ac68e29e7941c94ba308ea936395db23d0fee63a5c69dcccd3b2bdc`

Type:

```lean
{α : Type u_1} → [Mul α] → HMul α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Mul α] => { hMul := fun a b => inst.mul a b }
```

### D074: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `04ea7c06812eccb8531b763b7aa28fd8f968befff069e74166ff1b406f7512e3`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [SMul α β] → HSMul α β β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : SMul α β] => { hSMul := inst.smul }
```

### D075: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `98c22aec54da8e2278fb6c5ae1daeffb76abd7bad320de72096bec6a7046bc17`

Type:

```lean
{M : Type u} → [self : AddCommMonoid M] → AddMonoid M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddCommMonoid M] => self.1
```

### D076: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4b5cfcaa0e3b1157089b486d5bfd51b9d15b881ea9cad302a6c8f701cae9ef1a`

Type:

```lean
{M : Type u} → [self : AddMonoid M] → AddZeroClass M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toZero := self.toZero, toAdd := self.toAdd, zero_add := ⋯, add_zero := ⋯ }
```

### D077: `AddSubmonoid.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Submonoid.Defs`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `029094d2c1b33f7004c39bc68e51ae7cc5630e6caf206cb18d7860d9a945cf9f`

Type:

```lean
{M : Type u_3} →
  [inst : AddZeroClass M] →
    (toAddSubsemigroup : AddSubsemigroup M) → Set.instMembership.mem toAddSubsemigroup.carrier 0 → AddSubmonoid M
```

### D078: `AddSubsemigroup.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Subsemigroup.Defs`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `6bcab16592637f3ad99a5376ebb4104d8c715e250ceca67f865101d72cf48cb1`

Type:

```lean
{M : Type u_3} →
  [inst : Add M] →
    (carrier : Set M) →
      (∀ {a b : M},
          Set.instMembership.mem carrier a →
            Set.instMembership.mem carrier b → Set.instMembership.mem carrier (instHAdd.hAdd a b)) →
        AddSubsemigroup M
```

### D079: `AddZero.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `aaf8ee0ca0ca4a6b33fb0806d024e8a202ba2d3af3b4f4f8214dfc947d3bf16a`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Add M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.2
```

### D080: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8f64c653a96443ff67b52a5edb3fc264d279905b936c7303e9dd2469af000213`

Type:

```lean
{M : Type u} → [self : AddZeroClass M] → AddZero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZeroClass M] => self.1
```

### D081: `ContinuousAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `44c7f6f7a51f3c30a91ca5d7893f82c6b3bde265d86991f75bca55c7d5619bdc`

Type:

```lean
(M : Type u_1) → [TopologicalSpace M] → [Add M] → Prop
```

### D082: `ContinuousConstSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.ConstMulAction`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `64bb493562027db04039f38b3ff75d4943825dfb4dc78774e9b54eb26a0ac9c9`

Type:

```lean
(Γ : Type u_1) → (T : Type u_2) → [TopologicalSpace T] → [SMul Γ T] → Prop
```

### D083: `Distrib.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `cf0362fc4cebf4743d0430077ad4081a1de510a75cfe1b4e6adc97f21271a3ba`

Type:

```lean
{R : Type u_1} → [self : Distrib R] → Add R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Distrib R] => self.2
```

### D084: `Distrib.toMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `1d05ddf657021fb5615c5054f46b4863aec4ca856ca48fbb75add25e1f0fe06f`

Type:

```lean
{R : Type u_1} → [self : Distrib R] → Mul R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Distrib R] => self.1
```

### D085: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ea6124156f152313d3298dd94738351217f9626c6fc23cb2b63efa1528a4f9b9`

Type:

```lean
{M : Type u_12} →
  {A : Type u_13} → {inst : Monoid M} → {inst_1 : AddMonoid A} → [self : DistribMulAction M A] → MulAction M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} {inst_1} [self : DistribMulAction M A] => self.1
```

### D086: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5b8f4d61311ebccecf6a54ceca44191d394e0108c8596129a77f03c15a7e457f`

Type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
WithTop NNReal
```

### D087: `ENNReal.instPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `f07a664eb470c37e8c5abcad62d27fe4145f686c6a6a132fa775fdf14e92b68e`

Type:

```lean
PartialOrder ENNReal
```

Definition body (one-level semantic boundary):

```lean
inferInstanceAs (PartialOrder (WithTop NNReal))
```

### D088: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `1aa070f54e8aff7a6558c977220472990963777ddc5f04c5284f49422c06b41f`

Type:

```lean
ENNReal → Real
```

Definition body (one-level semantic boundary):

```lean
fun a => a.toNNReal.toReal
```

### D089: `IsScalarTower`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `3dee0f3d96ef31a7c13b0d6a82b3b90e464660e0a92f6410188dc906eaca70b0`

Type:

```lean
(M : Type u_9) → (N : Type u_10) → (α : Type u_11) → [SMul M N] → [SMul N α] → [SMul M α] → Prop
```

### D090: `IsTopologicalRing.toIsTopologicalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `f55163e46531cbf77c144d47ba02dbad1720a8a16e67de32af3e47419e5ccdb7`

Type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace R} {inst_1 : NonUnitalNonAssocRing R} [self : IsTopologicalRing R],
  IsTopologicalSemiring R
```

### D091: `IsTopologicalSemiring.toContinuousAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `c684f7cd5bb6a4ef18e1af19cd9eee769dfa19bcd1b732073ca86a7a5f54e714`

Type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace R} {inst_1 : NonUnitalNonAssocSemiring R} [self : IsTopologicalSemiring R],
  ContinuousAdd R
```

### D092: `IsTopologicalSemiring.toContinuousMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `fd5dd952a3c3566c14b553c40684808260a448d4b7c6fa7c23e9084603af65f5`

Type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace R} {inst_1 : NonUnitalNonAssocSemiring R} [self : IsTopologicalSemiring R],
  ContinuousMul R
```

### D093: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Type:

```lean
{α : Type u} → [self : LT α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LT α] => self.1
```

### D094: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Type:

```lean
{R : Type u} →
  {M : Type v} → {inst : Semiring R} → {inst_1 : AddCommMonoid M} → [self : Module R M] → DistribMulAction R M
```

Definition body (one-level semantic boundary):

```lean
fun R M {inst} {inst_1} [self : Module R M] => self.1
```

### D095: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `136930a747dcd73895587cb4c7ea1df27360fed0a4adb57efb71bb8949f0fa71`

Type:

```lean
{M : Type u} → [self : Monoid M] → Semigroup M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : Monoid M] => self.1
```

### D096: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Type:

```lean
{M₀ : Type u} → [self : MonoidWithZero M₀] → Monoid M₀
```

Definition body (one-level semantic boundary):

```lean
fun M₀ [self : MonoidWithZero M₀] => self.1
```

### D097: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `2a4074e38a7cedd1ecdaf86a42d3be01ad9728988610178bf9a698f57a876516`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Monoid α} → [self : MulAction α β] → SemigroupAction α β
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : MulAction α β] => self.1
```

### D098: `NonAssocSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `1674e66231d0f66dfe9fae191c7ae33207a78635bcf5490a9cfbb402d16f9bc0`

Type:

```lean
{α : Type u} → [self : NonAssocSemiring α] → NonUnitalNonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonAssocSemiring α] => self.1
```

### D099: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Type:

```lean
{α : Type u} → [self : NonUnitalCommRing α] → NonUnitalNonAssocCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalNonAssocRing := self.toNonUnitalNonAssocRing, mul_comm := ⋯ }
```

### D100: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing α] → NonUnitalNonAssocRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocCommRing α] => self.1
```

### D101: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocRing α] → NonUnitalNonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toAddMonoid := self.toAddMonoid, add_comm := ⋯, toMul := self.toMul, left_distrib := ⋯, right_distrib := ⋯,
    zero_mul := ⋯, mul_zero := ⋯ }
```

### D102: `NonUnitalNonAssocSemiring.toDistrib`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `5b49ec28e539eea6192ab07a9aee6da537ed1b5e017f2b9ef44d3a0ae51d79c6`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → Distrib α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toMul := self.toMul, toAdd := self.toAdd, left_distrib := ⋯, right_distrib := ⋯ }
```

### D103: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing α] → NonUnitalCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalRing := self.toNonUnitalRing, mul_comm := ⋯ }
```

### D104: `Norm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `33e6ec5a75ead4030dc20f8726f780e34ae38f1e0ef70e2e38ecf6b1a7929334`

Type:

```lean
Type u_8 → Type u_8
```

### D105: `Norm.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `79aed13c12fa8b060c652a8ff648f1ba6b5f4df36fd5f3ce0bb20c3e006fbb10`

Type:

```lean
{E : Type u_8} → (E → Real) → Norm E
```

### D106: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → NonUnitalNormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toMetricSpace := β.toMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D107: `PartialOrder.toPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `079686fa1ec6d596bcdb475c56a12b7f5a0594bf346c64220c2c992e0f0aae3b`

Type:

```lean
{α : Type u_2} → [self : PartialOrder α] → Preorder α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PartialOrder α] => self.1
```

### D108: `Preorder.toLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8fcf5a8f5a8899408a8cdc310bc44f6f7b84a21905a114103fbc65083f779a43`

Type:

```lean
{α : Type u_2} → [self : Preorder α] → LT α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Preorder α] => self.2
```

### D109: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `5a8783c66a2e56a4cc509bbb0651eda5b66e25c197307a42445cac31c4a4bb6c`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Semigroup α} → [self : SemigroupAction α β] → SMul α β
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : SemigroupAction α β] => self.1
```

### D110: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Type:

```lean
{α : Type u} → [self : Semiring α] → MonoidWithZero α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toMul := self.toMul, mul_assoc := ⋯, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯, npow := self.npow,
    npow_zero := ⋯, npow_succ := ⋯, toZero := self.toZero, zero_mul := ⋯, mul_zero := ⋯ }
```

### D111: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `33076e5ce1b65d0dacdacdea942f424abbe54f3ff639c158f37c0f533984f227`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toNonUnitalNonAssocSemiring := self.toNonUnitalNonAssocSemiring, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯,
    toNatCast := self.toNatCast, natCast_zero := ⋯, natCast_succ := ⋯ }
```

### D112: `SeparatelyContinuousMul.to_continuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `56d971880101cd9c99ed5d35d19fabe9af4b696c1f8d38dacc04cc710d35a66d`

Type:

```lean
∀ {M : Type u_3} [inst : TopologicalSpace M] [inst_1 : Mul M] [SeparatelyContinuousMul M], ContinuousConstSMul M M
```

### D113: `Submodule.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `955d9798d39620305be807148fff4e08f84525b0b7a07381405fbf39c6d1a638`

Type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring R] →
      [inst_1 : AddCommMonoid M] →
        [inst_2 : Module R M] →
          (toAddSubmonoid : AddSubmonoid M) →
            (∀ (c : R) {x : M},
                Set.instMembership.mem toAddSubmonoid.carrier x →
                  Set.instMembership.mem toAddSubmonoid.carrier (instHSMul.hSMul c x)) →
              Submodule R M
```

### D114: `Subtype.val`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `69c61ab82498e5563eaf5f0313ea7f2164c284c3dc742024a30332372a46663d`

Type:

```lean
{α : Sort u} → {p : α → Prop} → Subtype p → α
```

Definition body (one-level semantic boundary):

```lean
fun α p self => self.1
```

### D115: `Top.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Notation`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `32c978930b5eb9164add86b32aeacdc99d2d10df09b4b1989d12a6e346774504`

Type:

```lean
{α : Type u_1} → [self : Top α] → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Top α] => self.1
```

### D116: `instIsTopologicalRingReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Real`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `74697a527ce10426ad50966a34f3375374c3cde51367629721e2aa0850e2f618`

Type:

```lean
IsTopologicalRing Real
```

### D117: `instSMulOfMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `9896d4ef6db28be63751378d3104f7d0bf051c852db6e004a221af252cfd12b5`

Type:

```lean
{α : Type u} → [Mul α] → SMul α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Mul α] => { smul := fun x y => inst.mul x y }
```

### D118: `instSeparatelyContinuousMulOfContinuousMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid.Defs`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `b61f370eb1b1bf65f3c5a695bbbf265462befc2bea34585e5aa5368dae562454`

Type:

```lean
∀ {M : Type u_1} [inst : TopologicalSpace M] [inst_1 : Mul M] [ContinuousMul M], SeparatelyContinuousMul M
```

### D119: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `fc363bb86fd9c29e754e22d842cff17acbad13559cb0e03d31f4863045cd3c07`

Type:

```lean
Top ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.top
```

### D120: `setOf`

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

### D121: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `aa06299f9d38f11e9dad40701d7541d8eba2a4ac673c643f4c5f5ce1369490cc`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Zero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.1
```

### D122: `ConvexOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Convex.Function`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D123: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `17a3c7e66a4c2897891d468da70a58e73aa0b8e044ea0cc90d8d6e9e51c08f02`

Type:

```lean
{M : Type u_1} → {A : Type u_7} → [inst : Monoid M] → [inst_1 : AddMonoid A] → [DistribMulAction M A] → DistribSMul M A
```

Definition body (one-level semantic boundary):

```lean
fun {M} {A} [Monoid M] [AddMonoid A] [inst_2 : DistribMulAction M A] =>
  let __src := inst_2;
  { toSMul := __src.toSMul, smul_zero := ⋯, smul_add := ⋯ }
```

### D124: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `f640928ea31b161891006aaf9950d636ac5e1fbda413a7712f36546c938b3fdf`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : AddZeroClass A} → [self : DistribSMul M A] → SMulZeroClass M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : DistribSMul M A] => self.1
```

### D125: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `7e5f54349644c32198960083c0e0eb6c033c80a8656d02a78b3eae9a4f5131f2`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → (α → β) → Filter α → Filter β → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f l₁ l₂ => Filter.instPartialOrder.le (Filter.map f l₁) l₂
```

### D126: `Filter.atTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.AtTopBot.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f743a11da6fe9e156755f41ec35f4d61b87ca4af4575ede456b477a74caa45f3`

Type:

```lean
{α : Type u_3} → [Preorder α] → Filter α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Preorder α] => iInf fun a => Filter.principal (Set.Ici a)
```

### D127: `MeasureTheory.AEEqFun.cast`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `47f8b3469b914314d78fa6c02f35722a915b0ae5c64f6641ae6c8885cfaf00b4`

Type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} → [inst_1 : TopologicalSpace β] → MeasureTheory.AEEqFun α β μ → α → β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [MeasurableSpace α] {μ} [TopologicalSpace β] f =>
  if h : Exists fun b => Eq f (MeasureTheory.AEEqFun.mk (Function.const α b) ⋯) then
    Function.const α (Classical.choose h)
  else MeasureTheory.AEStronglyMeasurable.mk (Quotient.out f).val ⋯
```

### D128: `MeasureTheory.AEEqFun.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `6e70f16b95ce3a32f774a48ddcc7d42f928c419c6bb4d5b6803a562acf11da68`

Type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} →
        [inst_1 : TopologicalSpace γ] → [inst_2 : Add γ] → [ContinuousAdd γ] → Add (MeasureTheory.AEEqFun α γ μ)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {γ} [MeasurableSpace α] {μ} [TopologicalSpace γ] [Add γ] [ContinuousAdd γ] =>
  { add := MeasureTheory.AEEqFun.comp₂ (fun x1 x2 => instHAdd.hAdd x1 x2) ⋯ }
```

### D129: `MonotoneOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Monotone.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D130: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `896bb94fc15867c0df82ea0f639eb6116e90a24819a66a54db9442e47cba7274`

Type:

```lean
Preorder Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D131: `Real.partialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `c230e4cc01baeb2fcfa7d957f7e912e6e79376f736b5b58965ca7da585e8d66a`

Type:

```lean
PartialOrder Real
```

Definition body (one-level semantic boundary):

```lean
{ toLE := Real.instLE, toLT := Real.instLT, le_refl := ⋯, le_trans := ⋯, lt_iff_le_not_ge := ⋯, le_antisymm := ⋯ }
```

### D132: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `a8cadadddb0c9fd4a7bcb7c57401fafb43a1f330afa35fdacacb6d0e82d0bcf6`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : Zero A} → [self : SMulZeroClass M A] → SMul M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : SMulZeroClass M A] => self.1
```

### D133: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `a6e551515032966c16e4f42e4548ff1854c2dce05ffe51e98b66943caecc78ec`

Type:

```lean
Type u → Type u
```

Definition body (one-level semantic boundary):

```lean
fun α => α → Prop
```

### D134: `Set.Ici`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `32e9548f07a5e31843a500e07f11e2e04776466d0284c00e33d88066bc211711`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → Set α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] b => setOf fun x => inst.le b x
```

### D135: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `5858be77d319c5a0e238602f16818ed6fb2e2b52a81ff7edb07bc219d652f201`

Type:

```lean
{α : Type u} → Membership α (Set α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { mem := Set.Mem }
```

### D136: `CompleteLinearOrder.toConditionallyCompleteLinearOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `2aa802d0a9c75bf33917e1e0dc266a90886d32f434f1d43521c53f0f2c3449d0`

Type:

```lean
{α : Type u_5} → [h : CompleteLinearOrder α] → ConditionallyCompleteLinearOrderBot α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [h : CompleteLinearOrder α] =>
  let __spread.0 := CompleteLattice.toConditionallyCompleteLattice;
  let __spread.1 := h;
  { toConditionallyCompleteLattice := __spread.0, toOrd := __spread.1.toOrd, le_total := ⋯,
    toDecidableLE := __spread.1.toDecidableLE, toDecidableEq := __spread.1.toDecidableEq,
    toDecidableLT := __spread.1.toDecidableLT, csSup_of_not_bddAbove := ⋯, csInf_of_not_bddBelow := ⋯,
    compare_eq_compareOfLessAndEq := ⋯, toOrderBot := __spread.1.toOrderBot, csSup_empty := ⋯ }
```

### D137: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `41576e47c21e72ff272622fb2a65e2858beda94a321ffdbc1128f58d338ee803`

Type:

```lean
{α : Type u_1} → [ConditionallyCompleteLattice α] → ConditionallyCompletePartialOrder α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : ConditionallyCompleteLattice α] =>
  { toPartialOrder := inst.toSemilatticeInf.toPartialOrder, toSupSet := inst.toSupSet, isLUB_csSup_of_directed := ⋯,
    toInfSet := inst.toInfSet, isGLB_csInf_of_directed := ⋯ }
```

### D138: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `e1dad077d30ec2d5da19d9c26f0e709993b8eda004ce89d1f4086cf5f98094d5`

Type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrder α] → ConditionallyCompleteLattice α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompleteLinearOrder α] => self.1
```

### D139: `ConditionallyCompleteLinearOrderBot.toConditionallyCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `b25be2d55c4d466d6295ab5ff23a5cc915072a7d1cbc04c476d877743ce32dd9`

Type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrderBot α] → ConditionallyCompleteLinearOrder α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompleteLinearOrderBot α] => self.1
```

### D140: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `50e56dbfc6cb715ad5708fddc559a96fd43e4d11b7a8a33061c6cf440f5fc10c`

Type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrder α] → ConditionallyCompletePartialOrderInf α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toPartialOrder := self.toPartialOrder, toInfSet := self.toInfSet, isGLB_csInf_of_directed := ⋯ }
```

### D141: `ConditionallyCompletePartialOrderInf.toInfSet`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `182c2ddbb044a41025806b24afd62f570b4197b3450b566022615ea4646e06cd`

Type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrderInf α] → InfSet α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompletePartialOrderInf α] => self.2
```

### D142: `ENNReal.instCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `2436cc4a7fc332a26b2b8879178b290fffb6ceaad2c2210667170bdf3119d835`

Type:

```lean
CompleteLinearOrder ENNReal
```

Definition body (one-level semantic boundary):

```lean
inferInstanceAs (CompleteLinearOrder (WithTop NNReal))
```

### D143: `InfSet.sInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.SetNotation`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `76c82ed45915e35439b105eb3ec239e1937b2a2eafff41b96f451468dd90c61d`

Type:

```lean
{α : Type u_1} → [self : InfSet α] → Set α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : InfSet α] => self.1
```

### D144: `AddCommMonoidWithOne.toAddMonoidWithOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `07f48d3cfc3c7c30b6298df8531409d9844ab8c7e0ba94dea2a3fd29879320af`

Type:

```lean
{R : Type u_2} → [self : AddCommMonoidWithOne R] → AddMonoidWithOne R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : AddCommMonoidWithOne R] => self.1
```

### D145: `AddMonoidWithOne.toOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `2ee638fd7292dbcf1e4adb85b14bbd0f304e8a260316e61621bf8eac03f03f6d`

Type:

```lean
{R : Type u_2} → [self : AddMonoidWithOne R] → One R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : AddMonoidWithOne R] => self.3
```

### D146: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `635adc1f9e4a981a5c01b21338fdf89e637bd4ef0aa6911bda4dc03acfe9fba6`

Type:

```lean
{α : Sort u} → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} a b => Not (Eq a b)
```

### D147: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `cc544b5b2a2aabc84389a9fe2f052127dc6dae9964782b117b9b19b773e542d5`

Type:

```lean
{α : Type u_1} → [One α] → OfNat α 1
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : One α] => { ofNat := inst.one }
```

### D148: `Preorder.toLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `a2229e231e0928e24fffee5432201e35fadad80e7f6e4738e0d251c3c01a4676`

Type:

```lean
{α : Type u_2} → [self : Preorder α] → LE α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Preorder α] => self.1
```

### D149: `instAddCommMonoidWithOneENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `31d9551885e3007e5d1368365622cfd7638ea41cc6d885234041621de873f55c`

Type:

```lean
AddCommMonoidWithOne ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.addCommMonoidWithOne
```

### D150: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `6e5878abb65d5809d3258e569c8ff0f08b39804b377a07fec18d700b4e3fea86`

Type:

```lean
Zero ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.zero
```

### D151: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D152: `ENNReal.ofReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `ed3ef7ee60e47d07da43d414f4f32aa69df50f614988267eebc1025b2bef657d`

Type:

```lean
Real → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun r => ENNReal.ofNNReal r.toNNReal
```

### D153: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D154: `MeasureTheory.lintegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Lebesgue.Basic`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `e34294e65599ea3bdb2f1120ae912ae07a22313a7b238e200c71ae3b882cdb09`

Type:

```lean
{α : Type u_4} → {m : MeasurableSpace α} → MeasureTheory.Measure α → (α → ENNReal) → ENNReal
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.wrapped✝.1
```

### D155: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `7`
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

### D156: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```
