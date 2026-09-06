# Declaration dossier for LEV-CH01-HETEROGENEOUS-CELL-AVERAGING

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_heterogeneousMaterialCellAverage_sourceContract
    {Model Cell Point Parameter Property : Type*}
    [MeasurableSpace Point]
    (data : Leveque01HeterogeneousCellAveragingData
      Model Cell Point Parameter Property) :
    IsLeveque01HeterogeneousCellAveraging data ↔
      (∀ cell, data.volumeMeasure (data.cellRegion cell) ≠ 0) ∧
        (∀ cell,
          data.assignedCellProperties cell =
            data.cellVolumeAverage data.materialParameters cell ∧
          data.isAppropriateForModel data.model data.volumeMeasure
            (data.cellRegion cell) data.materialParameters
            (data.assignedCellProperties cell)) ∧
        (∀ field₁ field₂ cell,
          (∀ point, point ∈ data.cellRegion cell →
            field₁ point = field₂ point) →
            data.cellVolumeAverage field₁ cell =
              data.cellVolumeAverage field₂ cell) ∧
        ∃ field cell₁ cell₂,
          data.cellVolumeAverage field cell₁ ≠
            data.cellVolumeAverage field cell₂
```

## Elaborated target type

```lean
∀ {Model : Type u_1} {Cell : Type u_2} {Point : Type u_3} {Parameter : Type u_4} {Property : Type u_5}
  [inst : MeasurableSpace Point]
  (data : NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property),
  Iff (NumStability.IsLeveque01HeterogeneousCellAveraging data)
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
    @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point Parameter Property
      inst),
  Iff
    (@NumStability.IsLeveque01HeterogeneousCellAveraging.{u_1, u_2, u_3, u_4, u_5} Model Cell Point Parameter Property
      inst data)
    (And
      (∀ (cell : Cell),
        @Ne.{1} ENNReal
          (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
            (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst)
            (@NumStability.Leveque01HeterogeneousCellAveragingData.volumeMeasure.{u_1, u_2, u_3, u_4, u_5} Model Cell
              Point Parameter Property inst data)
            (@NumStability.Leveque01HeterogeneousCellAveragingData.cellRegion.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
              Parameter Property inst data cell))
          (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal)))
      (And
        (∀ (cell : Cell),
          And
            (@Eq.{u_5 + 1} Property
              (@NumStability.Leveque01HeterogeneousCellAveragingData.assignedCellProperties.{u_1, u_2, u_3, u_4, u_5}
                Model Cell Point Parameter Property inst data cell)
              (@NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage.{u_1, u_2, u_3, u_4, u_5} Model
                Cell Point Parameter Property inst data
                (@NumStability.Leveque01HeterogeneousCellAveragingData.materialParameters.{u_1, u_2, u_3, u_4, u_5}
                  Model Cell Point Parameter Property inst data)
                cell))
            (@NumStability.Leveque01HeterogeneousCellAveragingData.isAppropriateForModel.{u_1, u_2, u_3, u_4, u_5} Model
              Cell Point Parameter Property inst data
              (@NumStability.Leveque01HeterogeneousCellAveragingData.model.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                Parameter Property inst data)
              (@NumStability.Leveque01HeterogeneousCellAveragingData.volumeMeasure.{u_1, u_2, u_3, u_4, u_5} Model Cell
                Point Parameter Property inst data)
              (@NumStability.Leveque01HeterogeneousCellAveragingData.cellRegion.{u_1, u_2, u_3, u_4, u_5} Model Cell
                Point Parameter Property inst data cell)
              (@NumStability.Leveque01HeterogeneousCellAveragingData.materialParameters.{u_1, u_2, u_3, u_4, u_5} Model
                Cell Point Parameter Property inst data)
              (@NumStability.Leveque01HeterogeneousCellAveragingData.assignedCellProperties.{u_1, u_2, u_3, u_4, u_5}
                Model Cell Point Parameter Property inst data cell)))
        (And
          (∀ (field₁ field₂ : Point → Parameter) (cell : Cell),
            (∀ (point : Point),
                @Membership.mem.{u_3, u_3} Point (Set.{u_3} Point) (@Set.instMembership.{u_3} Point)
                    (@NumStability.Leveque01HeterogeneousCellAveragingData.cellRegion.{u_1, u_2, u_3, u_4, u_5} Model
                      Cell Point Parameter Property inst data cell)
                    point →
                  @Eq.{u_4 + 1} Parameter (field₁ point) (field₂ point)) →
              @Eq.{u_5 + 1} Property
                (@NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage.{u_1, u_2, u_3, u_4, u_5} Model
                  Cell Point Parameter Property inst data field₁ cell)
                (@NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage.{u_1, u_2, u_3, u_4, u_5} Model
                  Cell Point Parameter Property inst data field₂ cell))
          (@Exists.{max (u_3 + 1) (u_4 + 1)} (Point → Parameter) fun (field : Point → Parameter) =>
            @Exists.{u_2 + 1} Cell fun (cell₁ : Cell) =>
              @Exists.{u_2 + 1} Cell fun (cell₂ : Cell) =>
                @Ne.{u_5 + 1} Property
                  (@NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage.{u_1, u_2, u_3, u_4, u_5}
                    Model Cell Point Parameter Property inst data field cell₁)
                  (@NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage.{u_1, u_2, u_3, u_4, u_5}
                    Model Cell Point Parameter Property inst data field cell₂)))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsLeveque01HeterogeneousCellAveraging`

- Role: `local`
- Owner module: `AuditTarget`
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
            NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property → Prop
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            (data :
                @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                  Parameter Property inst) →
              Prop
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

### D002: `NumStability.Leveque01HeterogeneousCellAveragingData`

- Role: `local`
- Owner module: `AuditTarget`
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

Fully explicit type:

```lean
(Model : Type u_1) →
  (Cell : Type u_2) →
    (Point : Type u_3) →
      (Parameter : Type u_4) →
        (Property : Type u_5) → [MeasurableSpace.{u_3} Point] → Type (max (max (max (max u_1 u_2) u_3) u_4) u_5)
```

### D003: `NumStability.Leveque01HeterogeneousCellAveragingData.assignedCellProperties`

- Role: `local`
- Owner module: `AuditTarget`
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
            NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property → Cell → Property
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            (self :
                @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                  Parameter Property inst) →
              Cell → Property
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.5
```

### D004: `NumStability.Leveque01HeterogeneousCellAveragingData.cellRegion`

- Role: `local`
- Owner module: `AuditTarget`
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
            NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property → Cell → Set Point
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            (self :
                @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                  Parameter Property inst) →
              Cell → Set.{u_3} Point
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.2
```

### D005: `NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage`

- Role: `local`
- Owner module: `AuditTarget`
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
            NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property →
              (Point → Parameter) → Cell → Property
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            (self :
                @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                  Parameter Property inst) →
              (Point → Parameter) → Cell → Property
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.6
```

### D006: `NumStability.Leveque01HeterogeneousCellAveragingData.isAppropriateForModel`

- Role: `local`
- Owner module: `AuditTarget`
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
            NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property →
              Model → MeasureTheory.Measure Point → Set Point → (Point → Parameter) → Property → Prop
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            (self :
                @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                  Parameter Property inst) →
              Model → @MeasureTheory.Measure.{u_3} Point inst → Set.{u_3} Point → (Point → Parameter) → Property → Prop
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.7
```

### D007: `NumStability.Leveque01HeterogeneousCellAveragingData.materialParameters`

- Role: `local`
- Owner module: `AuditTarget`
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
            NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property → Point → Parameter
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            (self :
                @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                  Parameter Property inst) →
              Point → Parameter
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.4
```

### D008: `NumStability.Leveque01HeterogeneousCellAveragingData.model`

- Role: `local`
- Owner module: `AuditTarget`
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
            NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property → Model
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            (self :
                @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                  Parameter Property inst) →
              Model
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.1
```

### D009: `NumStability.Leveque01HeterogeneousCellAveragingData.volumeMeasure`

- Role: `local`
- Owner module: `AuditTarget`
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
            NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property →
              MeasureTheory.Measure Point
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            (self :
                @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                  Parameter Property inst) →
              @MeasureTheory.Measure.{u_3} Point inst
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter Property [MeasurableSpace Point] self => self.3
```

### D010: `NumStability.Leveque01HeterogeneousCellAveragingData.mk`

- Role: `local`
- Owner module: `AuditTarget`
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
                          NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        {Property : Type u_5} →
          [inst : MeasurableSpace.{u_3} Point] →
            (model : Model) →
              (cellRegion : Cell → Set.{u_3} Point) →
                (volumeMeasure : @MeasureTheory.Measure.{u_3} Point inst) →
                  (materialParameters : Point → Parameter) →
                    (assignedCellProperties : Cell → Property) →
                      (cellVolumeAverage : (Point → Parameter) → Cell → Property) →
                        (isAppropriateForModel :
                            Model →
                              @MeasureTheory.Measure.{u_3} Point inst →
                                Set.{u_3} Point → (Point → Parameter) → Property → Prop) →
                          @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell
                            Point Parameter Property inst
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

Fully explicit type:

```lean
(a b : Prop) → Prop
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

Fully explicit type:

```lean
{F : Sort u_1} →
  {α : outParam.{u_2 + 1} (Sort u_2)} →
    {β : outParam.{max u_2 (u_3 + 1)} (α → Sort u_3)} → [self : DFunLike.{u_1, u_2, u_3} F α β] → F → (a : α) → β a
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

Fully explicit type:

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

Fully explicit type:

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

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Prop
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

Fully explicit type:

```lean
(a b : Prop) → Prop
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

Fully explicit type:

```lean
(α : Type u_7) → Type u_7
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

Fully explicit type:

```lean
(α : Type u_6) → [MeasurableSpace.{u_6} α] → Type u_6
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

Fully explicit type:

```lean
{α : Type u_1} →
  [inst : MeasurableSpace.{u_1} α] →
    FunLike.{u_1 + 1, u_1 + 1, 1} (@MeasureTheory.Measure.{u_1} α inst) (Set.{u_1} α) ENNReal
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

Fully explicit type:

```lean
{α : outParam.{u + 2} (Type u)} → {γ : Type v} → [self : Membership.{u, v} α γ] → γ → α → Prop
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

Fully explicit type:

```lean
{α : Sort u} → (a b : α) → Prop
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

Fully explicit type:

```lean
{α : Type u} → (x : Nat) → [self : OfNat.{u} α x] → α
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

Fully explicit type:

```lean
(α : Type u) → Type u
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

Fully explicit type:

```lean
{α : Type u} → Membership.{u, u} α (Set.{u} α)
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

Fully explicit type:

```lean
{α : Type u_1} → [Zero.{u_1} α] → OfNat.{u_1} α (nat_lit 0)
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

Fully explicit type:

```lean
Zero.{0} ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.zero
```

## Complete local imported sources

### `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`

Path: `NumStability/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean`
SHA-256: `95da2da571f88e6ba3b73dd8816bad8e11a347f7650906603dafc699d62ccfd9`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# One-dimensional finite-volume cell averages

Source-independent definitions for the average of a Banach-space-valued field
over an ordered, nondegenerate one-dimensional cell.  The accompanying
predicate records both nondegeneracy and interval integrability explicitly.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The average of a field over the one-dimensional interval from `left` to
`right`: its Bochner integral divided by the cell width.

Use `IsOneDimensionalCellAverage` when the mathematical assertion must also
record that the interval is nondegenerate and the field is integrable there.
-/
noncomputable def oneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right : ℝ) : E :=
  (right - left)⁻¹ • ∫ x in left..right, field x

/-- `average` is the finite-volume average of `field` on an ordered,
nondegenerate cell, with interval integrability stated explicitly. -/
def IsOneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right : ℝ) (average : E) : Prop :=
  left < right ∧
    IntervalIntegrable field volume left right ∧
      average = oneDimensionalCellAverage field left right

/-- The canonical average satisfies the cell-average predicate whenever the
cell is ordered and the field is interval integrable. -/
theorem oneDimensionalCellAverage_isCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) {left right : ℝ}
    (hcell : left < right)
    (hfield : IntervalIntegrable field volume left right) :
    IsOneDimensionalCellAverage field left right
      (oneDimensionalCellAverage field left right) :=
  ⟨hcell, hfield, rfl⟩

/-- Multiplying a cell average by its positive width recovers the cell
integral. -/
theorem cellWidth_smul_oneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) {left right : ℝ} (hcell : left < right) :
    (right - left) • oneDimensionalCellAverage field left right =
      ∫ x in left..right, field x := by
  have hwidth : right - left ≠ 0 := sub_ne_zero.mpr (ne_of_gt hcell)
  simp [oneDimensionalCellAverage, smul_smul, hwidth]

end NumStability
```
