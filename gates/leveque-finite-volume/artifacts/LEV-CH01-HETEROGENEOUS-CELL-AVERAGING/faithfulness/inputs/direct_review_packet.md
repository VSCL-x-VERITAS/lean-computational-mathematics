# Declaration dossier for LEV-CH01-HETEROGENEOUS-CELL-AVERAGING

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_heterogeneousMaterialCellAverage_sourceContract
    {Model Cell Point Parameter : Type*} [MeasurableSpace Point]
    (grid : FiniteVolumeCellPartition Cell Point)
    (volumeMeasure : Measure Point)
    (averagingRule : CellMaterialAveragingRule
      Model Cell Point Parameter grid.cellRegion)
    (model : Model)
    (materialParameters : Point → Parameter)
    (hpositive : ∀ cell, volumeMeasure (grid.cellRegion cell) ≠ 0)
    (hfinite : ∀ cell, volumeMeasure (grid.cellRegion cell) ≠ ⊤)
    (hdifferentCellAverages : ∃ cell₁ cell₂,
      averagingRule.averageParameter model volumeMeasure cell₁
          materialParameters ≠
        averagingRule.averageParameter model volumeMeasure cell₂
          materialParameters) :
    ∃ assignedCellProperties : Cell →
        CellAveragedMaterialProperty Parameter,
      (∀ cell,
        (assignedCellProperties cell).averagedParameter =
          averagingRule.averageParameter model volumeMeasure cell
            materialParameters) ∧
      (∀ cell alternativeParameters,
        Set.EqOn materialParameters alternativeParameters
            (grid.cellRegion cell) →
          (assignedCellProperties cell).averagedParameter =
            averagingRule.averageParameter model volumeMeasure cell
              alternativeParameters) ∧
      (∀ cell parameter,
        averagingRule.averageParameter model volumeMeasure cell
            (fun _ => parameter) = parameter) ∧
      ∃ cell₁ cell₂,
        assignedCellProperties cell₁ ≠ assignedCellProperties cell₂
```

## Elaborated target type

```lean
∀ {Model : Type u_1} {Cell : Type u_2} {Point : Type u_3} {Parameter : Type u_4} [inst : MeasurableSpace Point]
  (grid : NumStability.FiniteVolumeCellPartition Cell Point) (volumeMeasure : MeasureTheory.Measure Point)
  (averagingRule : NumStability.CellMaterialAveragingRule Model Cell Point Parameter grid.cellRegion) (model : Model)
  (materialParameters : Point → Parameter),
  (∀ (cell : Cell), Ne (MeasureTheory.Measure.instFunLike.coe volumeMeasure (grid.cellRegion cell)) 0) →
    (∀ (cell : Cell),
        Ne (MeasureTheory.Measure.instFunLike.coe volumeMeasure (grid.cellRegion cell)) instTopENNReal.top) →
      (Exists fun cell₁ =>
          Exists fun cell₂ =>
            Ne (averagingRule.averageParameter model volumeMeasure cell₁ materialParameters)
              (averagingRule.averageParameter model volumeMeasure cell₂ materialParameters)) →
        Exists fun assignedCellProperties =>
          And
            (∀ (cell : Cell),
              Eq (assignedCellProperties cell).averagedParameter
                (averagingRule.averageParameter model volumeMeasure cell materialParameters))
            (And
              (∀ (cell : Cell) (alternativeParameters : Point → Parameter),
                Set.EqOn materialParameters alternativeParameters (grid.cellRegion cell) →
                  Eq (assignedCellProperties cell).averagedParameter
                    (averagingRule.averageParameter model volumeMeasure cell alternativeParameters))
              (And
                (∀ (cell : Cell) (parameter : Parameter),
                  Eq (averagingRule.averageParameter model volumeMeasure cell fun x => parameter) parameter)
                (Exists fun cell₁ =>
                  Exists fun cell₂ => Ne (assignedCellProperties cell₁) (assignedCellProperties cell₂))))
```

## Fully explicit elaborated target type

```lean
∀ {Model : Type u_1} {Cell : Type u_2} {Point : Type u_3} {Parameter : Type u_4} [inst : MeasurableSpace.{u_3} Point]
  (grid : @NumStability.FiniteVolumeCellPartition.{u_2, u_3} Cell Point inst)
  (volumeMeasure : @MeasureTheory.Measure.{u_3} Point inst)
  (averagingRule :
    @NumStability.CellMaterialAveragingRule.{u_1, u_2, u_3, u_4} Model Cell Point Parameter inst
      (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid))
  (model : Model) (materialParameters : Point → Parameter)
  (hpositive :
    ∀ (cell : Cell),
      @Ne.{1} ENNReal
        (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
          (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) volumeMeasure
          (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell))
        (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal)))
  (hfinite :
    ∀ (cell : Cell),
      @Ne.{1} ENNReal
        (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
          (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) volumeMeasure
          (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell))
        (@Top.top.{0} ENNReal instTopENNReal))
  (hdifferentCellAverages :
    @Exists.{u_2 + 1} Cell fun (cell₁ : Cell) =>
      @Exists.{u_2 + 1} Cell fun (cell₂ : Cell) =>
        @Ne.{u_4 + 1} Parameter
          (@NumStability.CellMaterialAveragingRule.averageParameter.{u_1, u_2, u_3, u_4} Model Cell Point Parameter inst
            (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid) averagingRule model
            volumeMeasure cell₁ materialParameters)
          (@NumStability.CellMaterialAveragingRule.averageParameter.{u_1, u_2, u_3, u_4} Model Cell Point Parameter inst
            (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid) averagingRule model
            volumeMeasure cell₂ materialParameters)),
  @Exists.{max (u_2 + 1) (u_4 + 1)} (Cell → NumStability.CellAveragedMaterialProperty.{u_4} Parameter)
    fun (assignedCellProperties : Cell → NumStability.CellAveragedMaterialProperty.{u_4} Parameter) =>
    And
      (∀ (cell : Cell),
        @Eq.{u_4 + 1} Parameter
          (@NumStability.CellAveragedMaterialProperty.averagedParameter.{u_4} Parameter (assignedCellProperties cell))
          (@NumStability.CellMaterialAveragingRule.averageParameter.{u_1, u_2, u_3, u_4} Model Cell Point Parameter inst
            (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid) averagingRule model
            volumeMeasure cell materialParameters))
      (And
        (∀ (cell : Cell) (alternativeParameters : Point → Parameter),
          @Set.EqOn.{u_3, u_4} Point Parameter materialParameters alternativeParameters
              (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell) →
            @Eq.{u_4 + 1} Parameter
              (@NumStability.CellAveragedMaterialProperty.averagedParameter.{u_4} Parameter
                (assignedCellProperties cell))
              (@NumStability.CellMaterialAveragingRule.averageParameter.{u_1, u_2, u_3, u_4} Model Cell Point Parameter
                inst (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid) averagingRule
                model volumeMeasure cell alternativeParameters))
        (And
          (∀ (cell : Cell) (parameter : Parameter),
            @Eq.{u_4 + 1} Parameter
              (@NumStability.CellMaterialAveragingRule.averageParameter.{u_1, u_2, u_3, u_4} Model Cell Point Parameter
                inst (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid) averagingRule
                model volumeMeasure cell fun (x : Point) => parameter)
              parameter)
          (@Exists.{u_2 + 1} Cell fun (cell₁ : Cell) =>
            @Exists.{u_2 + 1} Cell fun (cell₂ : Cell) =>
              @Ne.{u_4 + 1} (NumStability.CellAveragedMaterialProperty.{u_4} Parameter) (assignedCellProperties cell₁)
                (assignedCellProperties cell₂))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.Analysis.SpecialFunctions.Integrals.Basic`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.CellAveragedMaterialProperty`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `3127a24cb66b8cfeb64d8758c113bb032f5f9bde2818f81077227a75f8b33fdf`

Type:

```lean
Type u_1 → Type u_1
```

Fully explicit type:

```lean
(Parameter : Type u_1) → Type u_1
```

### D002: `NumStability.CellAveragedMaterialProperty.averagedParameter`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3b70abf26b2bc4825c6a510c8db0879703c3e27ec4092ce4d545d53d24ec1d76`

Type:

```lean
{Parameter : Type u_1} → NumStability.CellAveragedMaterialProperty Parameter → Parameter
```

Fully explicit type:

```lean
{Parameter : Type u_1} → (self : NumStability.CellAveragedMaterialProperty.{u_1} Parameter) → Parameter
```

Definition body (one-level semantic boundary):

```lean
fun Parameter self => self.1
```

### D003: `NumStability.CellMaterialAveragingRule`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `decf7df6d388b6984152c3530053487e349ae5207df2040bc57d78710f26ea90`

Type:

```lean
Type u_1 →
  (Cell : Type u_2) →
    (Point : Type u_3) →
      Type u_4 → [MeasurableSpace Point] → (Cell → Set Point) → Type (max (max (max u_1 u_2) u_3) u_4)
```

Fully explicit type:

```lean
(Model : Type u_1) →
  (Cell : Type u_2) →
    (Point : Type u_3) →
      (Parameter : Type u_4) →
        [MeasurableSpace.{u_3} Point] → (cellRegion : Cell → Set.{u_3} Point) → Type (max (max (max u_1 u_2) u_3) u_4)
```

### D004: `NumStability.CellMaterialAveragingRule.averageParameter`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ef24a2f4a402f6dfca84bf0c1e9c80c36a6e479da16f0c530e920a14ad6f3caf`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        [inst : MeasurableSpace Point] →
          {cellRegion : Cell → Set Point} →
            NumStability.CellMaterialAveragingRule Model Cell Point Parameter cellRegion →
              Model → MeasureTheory.Measure Point → Cell → (Point → Parameter) → Parameter
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        [inst : MeasurableSpace.{u_3} Point] →
          {cellRegion : Cell → Set.{u_3} Point} →
            (self :
                @NumStability.CellMaterialAveragingRule.{u_1, u_2, u_3, u_4} Model Cell Point Parameter inst
                  cellRegion) →
              Model → @MeasureTheory.Measure.{u_3} Point inst → Cell → (Point → Parameter) → Parameter
```

Definition body (one-level semantic boundary):

```lean
fun Model Cell Point Parameter [MeasurableSpace Point] cellRegion self => self.1
```

### D005: `NumStability.FiniteVolumeCellPartition`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `541ff72eb500f2f48d4d8c6c3232a3e3b60e8177b3d5bbbddde2e2791cebff03`

Type:

```lean
Type u_1 → (Point : Type u_2) → [MeasurableSpace Point] → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Cell : Type u_1) → (Point : Type u_2) → [MeasurableSpace.{u_2} Point] → Type (max u_1 u_2)
```

### D006: `NumStability.FiniteVolumeCellPartition.cellRegion`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `d0c5faafb12ba37fe6caa6161268436881416f82881f38a2a4b79e450af0089e`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace Point] → NumStability.FiniteVolumeCellPartition Cell Point → Cell → Set Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace.{u_2} Point] →
      (self : @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst) → Cell → Set.{u_2} Point
```

Definition body (one-level semantic boundary):

```lean
fun Cell Point [MeasurableSpace Point] self => self.2
```

### D007: `NumStability.CellAveragedMaterialProperty.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `5c804a5d7cd09bffdc8bdb11dfdc722c6f46e7397086d638f679f51b665e693e`

Type:

```lean
{Parameter : Type u_1} → Parameter → NumStability.CellAveragedMaterialProperty Parameter
```

Fully explicit type:

```lean
{Parameter : Type u_1} → (averagedParameter : Parameter) → NumStability.CellAveragedMaterialProperty.{u_1} Parameter
```

### D008: `NumStability.CellMaterialAveragingRule.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `0545b61edbc407848733de2321173ab40c77a0e6181a1ee4f6f8ac3cbeef3e16`

Type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        [inst : MeasurableSpace Point] →
          {cellRegion : Cell → Set Point} →
            (averageParameter : Model → MeasureTheory.Measure Point → Cell → (Point → Parameter) → Parameter) →
              (∀ (model : Model) (volumeMeasure : MeasureTheory.Measure Point) (cell : Cell)
                  (field₁ field₂ : Point → Parameter),
                  Set.EqOn field₁ field₂ (cellRegion cell) →
                    Eq (averageParameter model volumeMeasure cell field₁)
                      (averageParameter model volumeMeasure cell field₂)) →
                (∀ (model : Model) (volumeMeasure : MeasureTheory.Measure Point) (cell : Cell) (parameter : Parameter),
                    Ne (MeasureTheory.Measure.instFunLike.coe volumeMeasure (cellRegion cell)) 0 →
                      Ne (MeasureTheory.Measure.instFunLike.coe volumeMeasure (cellRegion cell)) instTopENNReal.top →
                        Eq (averageParameter model volumeMeasure cell fun x => parameter) parameter) →
                  NumStability.CellMaterialAveragingRule Model Cell Point Parameter cellRegion
```

Fully explicit type:

```lean
{Model : Type u_1} →
  {Cell : Type u_2} →
    {Point : Type u_3} →
      {Parameter : Type u_4} →
        [inst : MeasurableSpace.{u_3} Point] →
          {cellRegion : Cell → Set.{u_3} Point} →
            (averageParameter :
                Model → @MeasureTheory.Measure.{u_3} Point inst → Cell → (Point → Parameter) → Parameter) →
              (local_congr :
                  ∀ (model : Model) (volumeMeasure : @MeasureTheory.Measure.{u_3} Point inst) (cell : Cell)
                    (field₁ field₂ : Point → Parameter),
                    @Set.EqOn.{u_3, u_4} Point Parameter field₁ field₂ (cellRegion cell) →
                      @Eq.{u_4 + 1} Parameter (averageParameter model volumeMeasure cell field₁)
                        (averageParameter model volumeMeasure cell field₂)) →
                (preserves_constants :
                    ∀ (model : Model) (volumeMeasure : @MeasureTheory.Measure.{u_3} Point inst) (cell : Cell)
                      (parameter : Parameter),
                      @Ne.{1} ENNReal
                          (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst)
                            (Set.{u_3} Point) (fun (x : Set.{u_3} Point) => ENNReal)
                            (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) volumeMeasure (cellRegion cell))
                          (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal)) →
                        @Ne.{1} ENNReal
                            (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst)
                              (Set.{u_3} Point) (fun (x : Set.{u_3} Point) => ENNReal)
                              (@MeasureTheory.Measure.instFunLike.{u_3} Point inst) volumeMeasure (cellRegion cell))
                            (@Top.top.{0} ENNReal instTopENNReal) →
                          @Eq.{u_4 + 1} Parameter
                            (averageParameter model volumeMeasure cell fun (x : Point) => parameter) parameter) →
                  @NumStability.CellMaterialAveragingRule.{u_1, u_2, u_3, u_4} Model Cell Point Parameter inst
                    cellRegion
```

### D009: `NumStability.FiniteVolumeCellPartition.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `70af43774fd5d6cca8bcbb4d47e87ca7c602c3cd2ed577cb1ccdab58fb896810`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace Point] →
      (domain : Set Point) →
        (cellRegion : Cell → Set Point) →
          Nonempty Cell →
            (∀ (cell : Cell), MeasurableSet (cellRegion cell)) →
              (∀ {cell₁ cell₂ : Cell}, Ne cell₁ cell₂ → Disjoint (cellRegion cell₁) (cellRegion cell₂)) →
                (∀ (point : Point),
                    Iff (Set.instMembership.mem domain point)
                      (Exists fun cell => Set.instMembership.mem (cellRegion cell) point)) →
                  NumStability.FiniteVolumeCellPartition Cell Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace.{u_2} Point] →
      (domain : Set.{u_2} Point) →
        (cellRegion : Cell → Set.{u_2} Point) →
          (cells_nonempty : Nonempty.{u_1 + 1} Cell) →
            (measurable_cell : ∀ (cell : Cell), @MeasurableSet.{u_2} Point inst (cellRegion cell)) →
              (disjoint_cells :
                  ∀ {cell₁ cell₂ : Cell},
                    @Ne.{u_1 + 1} Cell cell₁ cell₂ →
                      @Disjoint.{u_2} (Set.{u_2} Point)
                        (@OmegaCompletePartialOrder.toPartialOrder.{u_2} (Set.{u_2} Point)
                          (@CompleteLattice.instOmegaCompletePartialOrder.{u_2} (Set.{u_2} Point)
                            (@CompleteBooleanAlgebra.toCompleteLattice.{u_2} (Set.{u_2} Point)
                              (@CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra.{u_2} (Set.{u_2} Point)
                                (@Set.instCompleteAtomicBooleanAlgebra.{u_2} Point)))))
                        (@HeytingAlgebra.toOrderBot.{u_2} (Set.{u_2} Point)
                          (@Order.Frame.toHeytingAlgebra.{u_2} (Set.{u_2} Point)
                            (@CompleteDistribLattice.toFrame.{u_2} (Set.{u_2} Point)
                              (@CompleteBooleanAlgebra.toCompleteDistribLattice.{u_2} (Set.{u_2} Point)
                                (@CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra.{u_2} (Set.{u_2} Point)
                                  (@Set.instCompleteAtomicBooleanAlgebra.{u_2} Point))))))
                        (cellRegion cell₁) (cellRegion cell₂)) →
                (covers_domain :
                    ∀ (point : Point),
                      Iff
                        (@Membership.mem.{u_2, u_2} Point (Set.{u_2} Point) (@Set.instMembership.{u_2} Point) domain
                          point)
                        (@Exists.{u_1 + 1} Cell fun (cell : Cell) =>
                          @Membership.mem.{u_2, u_2} Point (Set.{u_2} Point) (@Set.instMembership.{u_2} Point)
                            (cellRegion cell) point)) →
                  @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst
```

### D010: `And`

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

### D011: `DFunLike.coe`

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

### D012: `ENNReal`

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

### D013: `Eq`

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

### D014: `Exists`

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

### D015: `MeasurableSpace`

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

### D016: `MeasureTheory.Measure`

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

### D017: `MeasureTheory.Measure.instFunLike`

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

### D018: `Ne`

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

### D019: `OfNat.ofNat`

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

### D020: `Set`

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

### D021: `Set.EqOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Operations`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `88b1d8f315765b4f906b7dc15f6306e2a1fc00845d751cfe72cf1217abf8ca3d`

Type:

```lean
{α : Type u} → {β : Type v} → (α → β) → (α → β) → Set α → Prop
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (f₁ f₂ : α → β) → (s : Set.{u} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f₁ f₂ s => ∀ ⦃x : α⦄, Set.instMembership.mem s x → Eq (f₁ x) (f₂ x)
```

### D022: `Top.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Notation`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `32c978930b5eb9164add86b32aeacdc99d2d10df09b4b1989d12a6e346774504`

Type:

```lean
{α : Type u_1} → [self : Top α] → α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : Top.{u_1} α] → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Top α] => self.1
```

### D023: `Zero.toOfNat0`

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

### D024: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `fc363bb86fd9c29e754e22d842cff17acbad13559cb0e03d31f4863045cd3c07`

Type:

```lean
Top ENNReal
```

Fully explicit type:

```lean
Top.{0} ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.top
```

### D025: `instZeroENNReal`

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

### D026: `CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `3a25d65eea18eac65c870b595439bf5f5b25e6d990cea7e3a635eb81bad4a258`

Type:

```lean
{α : Type u} → [self : CompleteAtomicBooleanAlgebra α] → CompleteBooleanAlgebra α
```

Fully explicit type:

```lean
{α : Type u} → [self : CompleteAtomicBooleanAlgebra.{u} α] → CompleteBooleanAlgebra.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompleteAtomicBooleanAlgebra α] => self.1
```

### D027: `CompleteBooleanAlgebra.toCompleteDistribLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5b7b6334d9d65401dbf1e65d1fba2f464f54b88cbfb541ea9f6fe64419b9d357`

Type:

```lean
{α : Type u} → [CompleteBooleanAlgebra α] → CompleteDistribLattice α
```

Fully explicit type:

```lean
{α : Type u} → [CompleteBooleanAlgebra.{u} α] → CompleteDistribLattice.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : CompleteBooleanAlgebra α] =>
  let __spread.0 := inst;
  let __spread.1 := BooleanAlgebra.toBiheytingAlgebra;
  { toCompleteLattice := __spread.0.toCompleteLattice, toHImp := __spread.0.toHImp, le_himp_iff := ⋯,
    toCompl := __spread.0.toCompl, himp_bot := ⋯, toSDiff := __spread.0.toSDiff, sdiff_le_iff := ⋯,
    toHNot := __spread.1.toHNot, top_sdiff := ⋯ }
```

### D028: `CompleteBooleanAlgebra.toCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ef39a255ef10c0230be1cee558369fc7eb1b981c98d0e640e56097b98344a675`

Type:

```lean
{α : Type u_1} → [self : CompleteBooleanAlgebra α] → CompleteLattice α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : CompleteBooleanAlgebra.{u_1} α] → CompleteLattice.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompleteBooleanAlgebra α] => self.1
```

### D029: `CompleteDistribLattice.toFrame`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `9575e3922b928b13137e39541f6916c83a8c3d846f283ef286612bada2e926b1`

Type:

```lean
{α : Type u_1} → [self : CompleteDistribLattice α] → Order.Frame α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : CompleteDistribLattice.{u_1} α] → Order.Frame.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompleteDistribLattice α] => self.1
```

### D030: `CompleteLattice.instOmegaCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a588686a2b08b742c60791d874ae481ba89fc2f75533682f87dbe461bb89639e`

Type:

```lean
{α : Type u_2} → [CompleteLattice α] → OmegaCompletePartialOrder α
```

Fully explicit type:

```lean
{α : Type u_2} → [CompleteLattice.{u_2} α] → OmegaCompletePartialOrder.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : CompleteLattice α] =>
  { toPartialOrder := inst.toCompleteSemilatticeInf.toPartialOrder,
    ωSup := fun c => iSup fun i => OmegaCompletePartialOrder.Chain.instFunLikeNat.coe c i, le_ωSup := ⋯, ωSup_le := ⋯ }
```

### D031: `Disjoint`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Disjoint`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b3c1a3f72029bdabf392b01ef59e09df14985ee45c8304a6e3013b31345ac3bb`

Type:

```lean
{α : Type u_1} → [inst : PartialOrder α] → [OrderBot α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} →
  [inst : PartialOrder.{u_1} α] →
    [@OrderBot.{u_1} α (@Preorder.toLE.{u_1} α (@PartialOrder.toPreorder.{u_1} α inst))] → (a b : α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : PartialOrder α] [inst_1 : OrderBot α] a b => ∀ ⦃x : α⦄, inst.le x a → inst.le x b → inst.le x inst_1.bot
```

### D032: `HeytingAlgebra.toOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Heyting.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `2ee82a12c7227f6741bb957fb8033ec6bd4dc5696e0118ba976cd5cc433ce74c`

Type:

```lean
{α : Type u_4} → [self : HeytingAlgebra α] → OrderBot α
```

Fully explicit type:

```lean
{α : Type u_4} →
  [self : HeytingAlgebra.{u_4} α] →
    @OrderBot.{u_4} α
      (@Preorder.toLE.{u_4} α
        (@PartialOrder.toPreorder.{u_4} α
          (@SemilatticeSup.toPartialOrder.{u_4} α
            (@Lattice.toSemilatticeSup.{u_4} α
              (@GeneralizedHeytingAlgebra.toLattice.{u_4} α
                (@HeytingAlgebra.toGeneralizedHeytingAlgebra.{u_4} α self))))))
```

Definition body (one-level semantic boundary):

```lean
fun α [self : HeytingAlgebra α] => self.2
```

### D033: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D034: `MeasurableSet`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2e9235174f4747f2e37b86692acc96182e23810c202fe6e159a326c4a72cf4ff`

Type:

```lean
{α : Type u_1} → [MeasurableSpace α] → Set α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → [MeasurableSpace.{u_1} α] → (s : Set.{u_1} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : MeasurableSpace α] s => inst.MeasurableSet' s
```

### D035: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D036: `Nonempty`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `37c79de378d44cb9dc334502b161bb140da0544579086aded2cf83ff99c462c7`

Type:

```lean
Sort u → Prop
```

Fully explicit type:

```lean
(α : Sort u) → Prop
```

### D037: `OmegaCompletePartialOrder.toPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `04c999d7f177b80a86d128413a961873b394ba8a928e9f40ec1711b6050fc2de`

Type:

```lean
{α : Type u_6} → [self : OmegaCompletePartialOrder α] → PartialOrder α
```

Fully explicit type:

```lean
{α : Type u_6} → [self : OmegaCompletePartialOrder.{u_6} α] → PartialOrder.{u_6} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : OmegaCompletePartialOrder α] => self.1
```

### D038: `Order.Frame.toHeytingAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `d4cf848cdacfde27a40baabeb09bc470dcfcc4d195ff7dedbad201a5ff6a03ab`

Type:

```lean
{α : Type u_1} → [self : Order.Frame α] → HeytingAlgebra α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : Order.Frame.{u_1} α] → HeytingAlgebra.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toLattice := self.toLattice, toOrderTop := self.toOrderTop, toHImp := self.toHImp, le_himp_iff := ⋯,
    toOrderBot := self.toOrderBot, toCompl := self.toCompl, himp_bot := ⋯ }
```

### D039: `Set.instCompleteAtomicBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.BooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5ebef163c77bbddf9cd7439ed0b00fe337f343e5a1bbb203a126211604f9e398`

Type:

```lean
{α : Type u_1} → CompleteAtomicBooleanAlgebra (Set α)
```

Fully explicit type:

```lean
{α : Type u_1} → CompleteAtomicBooleanAlgebra.{u_1} (Set.{u_1} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} =>
  let __src := Set.instBooleanAlgebra;
  { toLattice := __src.toLattice, toSupSet := Set.instSupSet, le_sSup := ⋯, sSup_le := ⋯, toInfSet := Set.instInfSet,
    sInf_le := ⋯, le_sInf := ⋯, toTop := __src.toTop, le_top := ⋯, toBot := __src.toBot, bot_le := ⋯, le_sup_inf := ⋯,
    toCompl := __src.toCompl, toSDiff := __src.toSDiff, toHImp := __src.toHImp, inf_compl_le_bot := ⋯,
    top_le_sup_compl := ⋯, sdiff_eq := ⋯, himp_eq := ⋯, iInf_iSup_eq := ⋯ }
```

### D040: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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
