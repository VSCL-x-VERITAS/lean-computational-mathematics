# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
∀ {Model : Type u_1} {Cell : Type u_2} {Point : Type u_3} {Parameter : Type u_4} {Property : Type u_5}
  [inst : MeasurableSpace Point]
  (data : LocalDef002 Model Cell Point Parameter Property),
  Iff (LocalDef001 data)
    (And (∀ (cell : Cell), Ne (MeasureTheory.Measure.instFunLike.coe data.volumeMeasure (data.cellRegion cell)) 0)
      (And
        (∀ (cell : Cell),
          And (Eq (data.assignedCellProperties cell) (data.cellVolumeAverage data.materialParameters cell))
            (data.isAppropriateForModel data.model data.volumeMeasure (data.cellRegion cell) data.materialParameters
              (data.assignedCellProperties cell)))
        (And
          (∀ (field₁ field₂ : Point → Parameter) (cell : Cell),
            (∀ (point : Point),
                Set.instMembership.mem (data.cellRegion cell) point → Eq (field₁ point) (field₂ point)) →
              Eq (data.cellVolumeAverage field₁ cell) (data.cellVolumeAverage field₂ cell))
          (Exists fun field =>
            Exists fun cell₁ =>
              Exists fun cell₂ => Ne (data.cellVolumeAverage field cell₁) (data.cellVolumeAverage field cell₂)))))
```

## Fully explicit elaborated target type

```lean
∀ {Model : Type u_1} {Cell : Type u_2} {Point : Type u_3} {Parameter : Type u_4} {Property : Type u_5}
  [inst : MeasurableSpace.{u_3} Point]
  (data :
    @LocalDef002.{u_1, u_2, u_3, u_4, u_5} Model Cell Point Parameter Property
      inst),
  Iff
    (@LocalDef001.{u_1, u_2, u_3, u_4, u_5} Model Cell Point Parameter Property
      inst data)
    (And
      (∀ (cell : Cell),
        @Ne.{1} ENNReal
          (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
            (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst)
            (@LocalDef009.{u_1, u_2, u_3, u_4, u_5} Model Cell
              Point Parameter Property inst data)
            (@LocalDef004.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
              Parameter Property inst data cell))
          (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal)))
      (And
        (∀ (cell : Cell),
          And
            (@Eq.{u_5 + 1} Property
              (@LocalDef003.{u_1, u_2, u_3, u_4, u_5}
                Model Cell Point Parameter Property inst data cell)
              (@LocalDef005.{u_1, u_2, u_3, u_4, u_5} Model
                Cell Point Parameter Property inst data
                (@LocalDef007.{u_1, u_2, u_3, u_4, u_5}
                  Model Cell Point Parameter Property inst data)
                cell))
            (@LocalDef006.{u_1, u_2, u_3, u_4, u_5} Model
              Cell Point Parameter Property inst data
              (@LocalDef008.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                Parameter Property inst data)
              (@LocalDef009.{u_1, u_2, u_3, u_4, u_5} Model Cell
                Point Parameter Property inst data)
              (@LocalDef004.{u_1, u_2, u_3, u_4, u_5} Model Cell
                Point Parameter Property inst data cell)
              (@LocalDef007.{u_1, u_2, u_3, u_4, u_5} Model
                Cell Point Parameter Property inst data)
              (@LocalDef003.{u_1, u_2, u_3, u_4, u_5}
                Model Cell Point Parameter Property inst data cell)))
        (And
          (∀ (field₁ field₂ : Point → Parameter) (cell : Cell),
            (∀ (point : Point),
                @Membership.mem.{u_3, u_3} Point (Set.{u_3} Point) (@Set.instMembership.{u_3} Point)
                    (@LocalDef004.{u_1, u_2, u_3, u_4, u_5} Model
                      Cell Point Parameter Property inst data cell)
                    point →
                  @Eq.{u_4 + 1} Parameter (field₁ point) (field₂ point)) →
              @Eq.{u_5 + 1} Property
                (@LocalDef005.{u_1, u_2, u_3, u_4, u_5} Model
                  Cell Point Parameter Property inst data field₁ cell)
                (@LocalDef005.{u_1, u_2, u_3, u_4, u_5} Model
                  Cell Point Parameter Property inst data field₂ cell))
          (@Exists.{max (u_3 + 1) (u_4 + 1)} (Point → Parameter) fun (field : Point → Parameter) =>
            @Exists.{u_2 + 1} Cell fun (cell₁ : Cell) =>
              @Exists.{u_2 + 1} Cell fun (cell₂ : Cell) =>
                @Ne.{u_5 + 1} Property
                  (@LocalDef005.{u_1, u_2, u_3, u_4, u_5}
                    Model Cell Point Parameter Property inst data field cell₁)
                  (@LocalDef005.{u_1, u_2, u_3, u_4, u_5}
                    Model Cell Point Parameter Property inst data field cell₂)))))
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `101300ac3c1d5d8a22658cab65aed9b53cc3fc8d3ff91276a4e8d73dec7af045`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace Point] →
            LocalDef002 Model Cell Point Parameter Property → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Model} {Cell} {Point} {Parameter} {Property} [MeasurableSpace Point] data =>
  And (∀ (cell : Cell), Ne (MeasureTheory.Measure.instFunLike.coe data.volumeMeasure (data.cellRegion cell)) 0)
    (And
      (∀ (cell : Cell),
        And (Eq (data.assignedCellProperties cell) (data.cellVolumeAverage data.materialParameters cell))
          (data.isAppropriateForModel data.model data.volumeMeasure (data.cellRegion cell) data.materialParameters
            (data.assignedCellProperties cell)))
      (And
        (∀ (field₁ field₂ : Point → Parameter) (cell : Cell),
          (∀ (point : Point), Set.instMembership.mem (data.cellRegion cell) point → Eq (field₁ point) (field₂ point)) →
            Eq (data.cellVolumeAverage field₁ cell) (data.cellVolumeAverage field₂ cell))
        (Exists fun field =>
          Exists fun cell₁ =>
            Exists fun cell₂ => Ne (data.cellVolumeAverage field cell₁) (data.cellVolumeAverage field cell₂))))
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `47809db5ae10a67b0e4c7272c2682115418564af3282ae14e616dfb2a5a1b22c`

Type:

```lean
Type u_1 →
  Type u_2 →
    (Point : Type u_3) →
      Type u_4 → Type u_5 → [MeasurableSpace Point] → Type (max (max (max (max u_1 u_2) u_3) u_4) u_5)
```

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ebeaae2ba2cd68c0d6ac129ba737ece7c298c6762d0140cb1a6f3dd95477c9fa`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace Point] →
            LocalDef002 Model Cell Point Parameter Property → Cell → Property
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.5
```

### D004: `LocalDef004`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `94e5ed7f4ad585a0eb8d661eda84a6176bf4bf456b09a6cf1dac4c3499cc38d7`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace Point] →
            LocalDef002 Model Cell Point Parameter Property → Cell → Set Point
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.2
```

### D005: `LocalDef005`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ebacb6aa03da35f46fb8af77e5c77b08ddd545710bae073d0bdb1956cdde80a5`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace Point] →
            LocalDef002 Model Cell Point Parameter Property →
              (Point → Parameter) → Cell → Property
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.6
```

### D006: `LocalDef006`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `52234e162fa626ae2258b7e8438e863aed5df52d078644a18882ff4f57d8e5ae`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace Point] →
            LocalDef002 Model Cell Point Parameter Property →
              Model → MeasureTheory.Measure Point → Set Point → (Point → Parameter) → Property → Prop
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.7
```

### D007: `LocalDef007`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c891e0d4c55691a85b4bfb54c91384ae568839ab94252b42ca305817c30c83a4`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace Point] →
            LocalDef002 Model Cell Point Parameter Property → Point → Parameter
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.4
```

### D008: `LocalDef008`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0f11c10354f0a786771204106489b1cb49ea2afa71e90062f3158a703a17e2dd`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace Point] →
            LocalDef002 Model Cell Point Parameter Property → Model
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.1
```

### D009: `LocalDef009`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a3f9f8a58a03d6f7ce9d1760af36cee61917bdc19c42e3d68405e3cfd9a4f41`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace Point] →
            LocalDef002 Model Cell Point Parameter Property →
              MeasureTheory.Measure Point
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.3
```

### D010: `LocalDef010`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `f1d3e2a59f27edfbbe0caaf42840c994207827b6d7ba73ff7c81e2e39033cc1c`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace Point] →
            Model →
              (Cell → Set Point) →
                MeasureTheory.Measure Point →
                  (Point → Parameter) →
                    (Cell → Property) →
                      ((Point → Parameter) → Cell → Property) →
                        (Model → MeasureTheory.Measure Point → Set Point → (Point → Parameter) → Property → Prop) →
                          LocalDef002 Model Cell Point Parameter Property
```

### D011: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

### D012: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9db5c150b3c86d10b50e19602d0c0af9e5012dfe5f13b0d7b57925729f2478f0`

Type:

```lean
{F : Sort u_1} → {α : outParam (Sort u_2)} → {β : outParam (α → Sort u_3)} → [self : DFunLike F α β] → F → (a : α) → β a
```

Definition body (one-level semantic boundary):

```lean
fun F {α} {β} [self : DFunLike F α β] => self.1
```

### D013: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5b8f4d61311ebccecf6a54ceca44191d394e0108c8596129a77f03c15a7e457f`

Type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
WithTop NNReal
```

### D014: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D015: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

### D016: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

### D017: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

### D018: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

### D019: `MeasureTheory.Measure.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `94b2becf9230ce3d438e9b668f79f08e69dbe28c937b1aaca32d96e94b64a5b2`

Type:

```lean
{α : Type u_1} → [inst : MeasurableSpace α] → FunLike (MeasureTheory.Measure α) (Set α) ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {α} [MeasurableSpace α] =>
  { coe := fun μ => MeasureTheory.OuterMeasure.instFunLikeSetENNReal.coe μ.toOuterMeasure, coe_injective' := ⋯ }
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

### D021: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `635adc1f9e4a981a5c01b21338fdf89e637bd4ef0aa6911bda4dc03acfe9fba6`

Type:

```lean
{α : Sort u} → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} a b => Not (Eq a b)
```

### D022: `OfNat.ofNat`

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

### D023: `Set`

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

### D024: `Set.instMembership`

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

### D025: `Zero.toOfNat0`

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

### D026: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `6e5878abb65d5809d3258e569c8ff0f08b39804b377a07fec18d700b4e3fea86`

Type:

```lean
Zero ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.zero
```
