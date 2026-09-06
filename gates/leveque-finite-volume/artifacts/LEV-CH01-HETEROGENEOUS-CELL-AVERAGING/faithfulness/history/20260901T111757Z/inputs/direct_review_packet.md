# Declaration dossier for LEV-CH01-HETEROGENEOUS-CELL-AVERAGING

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_heterogeneousMaterialCellAverage_sourceContract
    {Model Cell Point Parameter Property : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup Parameter] [NormedSpace ℝ Parameter]
    (grid : FiniteVolumeCellPartition Cell Point)
    (volumeMeasure : Measure Point) (model : Model)
    (materialParameters : Point → Parameter)
    (propertyFromAverage : Model → Parameter → Property)
    (isAppropriateForModel :
      Model → Measure Point → Set Point →
        (Point → Parameter) → Property → Prop)
    (hpositive : ∀ cell, volumeMeasure (grid.cellRegion cell) ≠ 0)
    (hfinite : ∀ cell, volumeMeasure (grid.cellRegion cell) ≠ ⊤)
    (hintegrable : ∀ cell,
      IntegrableOn materialParameters (grid.cellRegion cell) volumeMeasure)
    (hheterogeneous :
      ∃ point₁ ∈ grid.domain, ∃ point₂ ∈ grid.domain,
        materialParameters point₁ ≠ materialParameters point₂)
    (happropriate : ∀ cell,
      isAppropriateForModel model volumeMeasure (grid.cellRegion cell)
        materialParameters
        (propertyFromAverage model
          (cellVolumeAverage volumeMeasure (grid.cellRegion cell)
            materialParameters))) :
    (∃ point₁ ∈ grid.domain, ∃ point₂ ∈ grid.domain,
      materialParameters point₁ ≠ materialParameters point₂) ∧
      ∃ assignedCellProperties : Cell → Property,
        ∀ cell,
          IsCellVolumeAverage volumeMeasure (grid.cellRegion cell)
              materialParameters
              (cellVolumeAverage volumeMeasure (grid.cellRegion cell)
                materialParameters) ∧
            assignedCellProperties cell =
              propertyFromAverage model
                (cellVolumeAverage volumeMeasure (grid.cellRegion cell)
                  materialParameters) ∧
            isAppropriateForModel model volumeMeasure
              (grid.cellRegion cell) materialParameters
              (assignedCellProperties cell)
```

## Elaborated target type

```lean
∀ {Model : Type u_1} {Cell : Type u_2} {Point : Type u_3} {Parameter : Type u_4} {Property : Type u_5}
  [inst : MeasurableSpace Point] [inst_1 : NormedAddCommGroup Parameter] [inst_2 : NormedSpace Real Parameter]
  (grid : NumStability.FiniteVolumeCellPartition Cell Point) (volumeMeasure : MeasureTheory.Measure Point)
  (model : Model) (materialParameters : Point → Parameter) (propertyFromAverage : Model → Parameter → Property)
  (isAppropriateForModel : Model → MeasureTheory.Measure Point → Set Point → (Point → Parameter) → Property → Prop),
  (∀ (cell : Cell), Ne (MeasureTheory.Measure.instFunLike.coe volumeMeasure (grid.cellRegion cell)) 0) →
    (∀ (cell : Cell),
        Ne (MeasureTheory.Measure.instFunLike.coe volumeMeasure (grid.cellRegion cell)) instTopENNReal.top) →
      (∀ (cell : Cell), MeasureTheory.IntegrableOn materialParameters (grid.cellRegion cell) volumeMeasure) →
        (Exists fun point₁ =>
            And (Set.instMembership.mem grid.domain point₁)
              (Exists fun point₂ =>
                And (Set.instMembership.mem grid.domain point₂)
                  (Ne (materialParameters point₁) (materialParameters point₂)))) →
          (∀ (cell : Cell),
              isAppropriateForModel model volumeMeasure (grid.cellRegion cell) materialParameters
                (propertyFromAverage model
                  (NumStability.cellVolumeAverage volumeMeasure (grid.cellRegion cell) materialParameters))) →
            And
              (Exists fun point₁ =>
                And (Set.instMembership.mem grid.domain point₁)
                  (Exists fun point₂ =>
                    And (Set.instMembership.mem grid.domain point₂)
                      (Ne (materialParameters point₁) (materialParameters point₂))))
              (Exists fun assignedCellProperties =>
                ∀ (cell : Cell),
                  And
                    (NumStability.IsCellVolumeAverage volumeMeasure (grid.cellRegion cell) materialParameters
                      (NumStability.cellVolumeAverage volumeMeasure (grid.cellRegion cell) materialParameters))
                    (And
                      (Eq (assignedCellProperties cell)
                        (propertyFromAverage model
                          (NumStability.cellVolumeAverage volumeMeasure (grid.cellRegion cell) materialParameters)))
                      (isAppropriateForModel model volumeMeasure (grid.cellRegion cell) materialParameters
                        (assignedCellProperties cell))))
```

## Fully explicit elaborated target type

```lean
∀ {Model : Type u_1} {Cell : Type u_2} {Point : Type u_3} {Parameter : Type u_4} {Property : Type u_5}
  [inst : MeasurableSpace.{u_3} Point] [inst_1 : NormedAddCommGroup.{u_4} Parameter]
  [inst_2 :
    @NormedSpace.{0, u_4} Real Parameter Real.normedField
      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} Parameter inst_1)]
  (grid : @NumStability.FiniteVolumeCellPartition.{u_2, u_3} Cell Point inst)
  (volumeMeasure : @MeasureTheory.Measure.{u_3} Point inst) (model : Model) (materialParameters : Point → Parameter)
  (propertyFromAverage : Model → Parameter → Property)
  (isAppropriateForModel :
    Model → @MeasureTheory.Measure.{u_3} Point inst → Set.{u_3} Point → (Point → Parameter) → Property → Prop)
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
  (hintegrable :
    ∀ (cell : Cell),
      @MeasureTheory.IntegrableOn.{u_3, u_4} Point Parameter inst
        (@UniformSpace.toTopologicalSpace.{u_4} Parameter
          (@PseudoMetricSpace.toUniformSpace.{u_4} Parameter
            (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} Parameter
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} Parameter inst_1))))
        (@SeminormedAddGroup.toContinuousENorm.{u_4} Parameter
          (@SeminormedAddCommGroup.toSeminormedAddGroup.{u_4} Parameter
            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} Parameter inst_1)))
        materialParameters (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell)
        volumeMeasure)
  (hheterogeneous :
    @Exists.{u_3 + 1} Point fun (point₁ : Point) =>
      And
        (@Membership.mem.{u_3, u_3} Point (Set.{u_3} Point) (@Set.instMembership.{u_3} Point)
          (@NumStability.FiniteVolumeCellPartition.domain.{u_2, u_3} Cell Point inst grid) point₁)
        (@Exists.{u_3 + 1} Point fun (point₂ : Point) =>
          And
            (@Membership.mem.{u_3, u_3} Point (Set.{u_3} Point) (@Set.instMembership.{u_3} Point)
              (@NumStability.FiniteVolumeCellPartition.domain.{u_2, u_3} Cell Point inst grid) point₂)
            (@Ne.{u_4 + 1} Parameter (materialParameters point₁) (materialParameters point₂))))
  (happropriate :
    ∀ (cell : Cell),
      isAppropriateForModel model volumeMeasure
        (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell) materialParameters
        (propertyFromAverage model
          (@NumStability.cellVolumeAverage.{u_3, u_4} Point Parameter inst inst_1 inst_2 volumeMeasure
            (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell)
            materialParameters))),
  And
    (@Exists.{u_3 + 1} Point fun (point₁ : Point) =>
      And
        (@Membership.mem.{u_3, u_3} Point (Set.{u_3} Point) (@Set.instMembership.{u_3} Point)
          (@NumStability.FiniteVolumeCellPartition.domain.{u_2, u_3} Cell Point inst grid) point₁)
        (@Exists.{u_3 + 1} Point fun (point₂ : Point) =>
          And
            (@Membership.mem.{u_3, u_3} Point (Set.{u_3} Point) (@Set.instMembership.{u_3} Point)
              (@NumStability.FiniteVolumeCellPartition.domain.{u_2, u_3} Cell Point inst grid) point₂)
            (@Ne.{u_4 + 1} Parameter (materialParameters point₁) (materialParameters point₂))))
    (@Exists.{max (u_2 + 1) (u_5 + 1)} (Cell → Property) fun (assignedCellProperties : Cell → Property) =>
      ∀ (cell : Cell),
        And
          (@NumStability.IsCellVolumeAverage.{u_3, u_4} Point Parameter inst inst_1 inst_2 volumeMeasure
            (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell) materialParameters
            (@NumStability.cellVolumeAverage.{u_3, u_4} Point Parameter inst inst_1 inst_2 volumeMeasure
              (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell)
              materialParameters))
          (And
            (@Eq.{u_5 + 1} Property (assignedCellProperties cell)
              (propertyFromAverage model
                (@NumStability.cellVolumeAverage.{u_3, u_4} Point Parameter inst inst_1 inst_2 volumeMeasure
                  (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell)
                  materialParameters)))
            (isAppropriateForModel model volumeMeasure
              (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_3} Cell Point inst grid cell)
              materialParameters (assignedCellProperties cell))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.Analysis.SpecialFunctions.Integrals.Basic`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.FiniteVolumeCellPartition`

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

### D002: `NumStability.FiniteVolumeCellPartition.cellRegion`

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

### D003: `NumStability.FiniteVolumeCellPartition.domain`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9cec13ba10bda6041ed3e4634aaa21482936f2d3b181ddeca5a8018010a05b84`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} → [inst : MeasurableSpace Point] → NumStability.FiniteVolumeCellPartition Cell Point → Set Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace.{u_2} Point] →
      (self : @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst) → Set.{u_2} Point
```

Definition body (one-level semantic boundary):

```lean
fun Cell Point [MeasurableSpace Point] self => self.1
```

### D004: `NumStability.IsCellVolumeAverage`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `21cd05067505b36e256af0d1c214a5dcc2f714d4a719ef199a54075de31db284`

Type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace Point] →
      [inst_1 : NormedAddCommGroup E] →
        [NormedSpace Real E] → MeasureTheory.Measure Point → Set Point → (Point → E) → E → Prop
```

Fully explicit type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace.{u_1} Point] →
      [inst_1 : NormedAddCommGroup.{u_2} E] →
        [@NormedSpace.{0, u_2} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1)] →
          (μ : @MeasureTheory.Measure.{u_1} Point inst) →
            (region : Set.{u_1} Point) → (field : Point → E) → (average : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Point} {E} [MeasurableSpace Point] [NormedAddCommGroup E] [NormedSpace Real E] μ region field average =>
  And (Ne (MeasureTheory.Measure.instFunLike.coe μ region) 0)
    (And (Ne (MeasureTheory.Measure.instFunLike.coe μ region) instTopENNReal.top)
      (And (MeasureTheory.IntegrableOn field region μ) (Eq average (NumStability.cellVolumeAverage μ region field))))
```

### D005: `NumStability.cellVolumeAverage`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cf2e2e0d30c189de5352968f5369b343f70aa5ca34fa6e1ffb0e90675c639914`

Type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace Point] →
      [inst_1 : NormedAddCommGroup E] → [NormedSpace Real E] → MeasureTheory.Measure Point → Set Point → (Point → E) → E
```

Fully explicit type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace.{u_1} Point] →
      [inst_1 : NormedAddCommGroup.{u_2} E] →
        [@NormedSpace.{0, u_2} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1)] →
          (μ : @MeasureTheory.Measure.{u_1} Point inst) → (region : Set.{u_1} Point) → (field : Point → E) → E
```

Definition body (one-level semantic boundary):

```lean
fun {Point} {E} [MeasurableSpace Point] [NormedAddCommGroup E] [NormedSpace Real E] μ region field =>
  instHSMul.hSMul (Real.instInv.inv (MeasureTheory.Measure.instFunLike.coe μ region).toReal)
    (MeasureTheory.integral (μ.restrict region) fun point => field point)
```

### D006: `NumStability.FiniteVolumeCellPartition.mk`

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

### D007: `And`

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

### D008: `DFunLike.coe`

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

### D009: `ENNReal`

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

### D010: `Eq`

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

### D011: `Exists`

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

### D012: `MeasurableSpace`

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

### D013: `MeasureTheory.IntegrableOn`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntegrableOn`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `dabc1688ef0e599a1f54ac0aa2c596e2bf70ce60ba22c33b537a76452e7cb6ed`

Type:

```lean
{α : Type u_1} →
  {ε : Type u_3} →
    {mα : MeasurableSpace α} →
      [inst : TopologicalSpace ε] →
        [ContinuousENorm ε] →
          (α → ε) → Set α → autoParam (MeasureTheory.Measure α) MeasureTheory.IntegrableOn._auto_1 → Prop
```

Fully explicit type:

```lean
{α : Type u_1} →
  {ε : Type u_3} →
    {mα : MeasurableSpace.{u_1} α} →
      [inst : TopologicalSpace.{u_3} ε] →
        [@ContinuousENorm.{u_3} ε inst] →
          (f : α → ε) →
            (s : Set.{u_1} α) →
              (μ : autoParam.{u_1 + 1} (@MeasureTheory.Measure.{u_1} α mα) MeasureTheory.IntegrableOn._auto_1) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {ε} {mα} [TopologicalSpace ε] [ContinuousENorm ε] f s μ => MeasureTheory.Integrable f (μ.restrict s)
```

### D014: `MeasureTheory.Measure`

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

### D015: `MeasureTheory.Measure.instFunLike`

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

### D016: `Membership.mem`

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

### D017: `Ne`

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

### D018: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

Fully explicit type:

```lean
(E : Type u_8) → Type u_8
```

### D019: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → SeminormedAddCommGroup E
```

Fully explicit type:

```lean
{E : Type u_5} → [NormedAddCommGroup.{u_5} E] → SeminormedAddCommGroup.{u_5} E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D020: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

Fully explicit type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField.{u_6} 𝕜] → [SeminormedAddCommGroup.{u_7} E] → Type (max u_6 u_7)
```

### D021: `OfNat.ofNat`

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

### D022: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Fully explicit type:

```lean
{α : Type u} → [self : PseudoMetricSpace.{u} α] → UniformSpace.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D023: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D024: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Type:

```lean
NormedField Real
```

Fully explicit type:

```lean
NormedField.{0} Real
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

### D025: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3f8499f7dfc2e8115a48b4ac0bec5328dd7223a18dd71fc0061e711fbd543126`

Type:

```lean
{E : Type u_8} → [self : SeminormedAddCommGroup E] → PseudoMetricSpace E
```

Fully explicit type:

```lean
{E : Type u_8} → [self : SeminormedAddCommGroup.{u_8} E] → PseudoMetricSpace.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : SeminormedAddCommGroup E] => self.3
```

### D026: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8cf35215f509cdee10a3a95158cbaadd3c5fb584bc0d1f4fad6ecfc69b1bd205`

Type:

```lean
{E : Type u_5} → [SeminormedAddCommGroup E] → SeminormedAddGroup E
```

Fully explicit type:

```lean
{E : Type u_5} → [SeminormedAddCommGroup.{u_5} E] → SeminormedAddGroup.{u_5} E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : SeminormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D027: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `17a83cbf3059dd0bbaefd43c93ce329f1d6b760d440889322b3582a18b23a141`

Type:

```lean
{E : Type u_4} → [inst : SeminormedAddGroup E] → ContinuousENorm E
```

Fully explicit type:

```lean
{E : Type u_4} →
  [inst : SeminormedAddGroup.{u_4} E] →
    @ContinuousENorm.{u_4} E
      (@UniformSpace.toTopologicalSpace.{u_4} E
        (@PseudoMetricSpace.toUniformSpace.{u_4} E (@SeminormedAddGroup.toPseudoMetricSpace.{u_4} E inst)))
```

Definition body (one-level semantic boundary):

```lean
fun {E} [SeminormedAddGroup E] => { toENorm := NNNorm.toENorm, continuous_enorm := ⋯ }
```

### D028: `Set`

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

### D029: `Set.instMembership`

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

### D030: `Top.top`

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

### D031: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Fully explicit type:

```lean
{α : Type u} → [self : UniformSpace.{u} α] → TopologicalSpace.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
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

Fully explicit type:

```lean
{α : Type u_1} → [Zero.{u_1} α] → OfNat.{u_1} α (nat_lit 0)
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Zero α] => { ofNat := inst.zero }
```

### D033: `instTopENNReal`

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

### D034: `instZeroENNReal`

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

### D035: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `4b5cfcaa0e3b1157089b486d5bfd51b9d15b881ea9cad302a6c8f701cae9ef1a`

Type:

```lean
{M : Type u} → [self : AddMonoid M] → AddZeroClass M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddMonoid.{u} M] → AddZeroClass.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toZero := self.toZero, toAdd := self.toAdd, zero_add := ⋯, add_zero := ⋯ }
```

### D036: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `aa06299f9d38f11e9dad40701d7541d8eba2a4ac673c643f4c5f5ce1369490cc`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Zero M
```

Fully explicit type:

```lean
{M : Type u_2} → [self : AddZero.{u_2} M] → Zero.{u_2} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.1
```

### D037: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8f64c653a96443ff67b52a5edb3fc264d279905b936c7303e9dd2469af000213`

Type:

```lean
{M : Type u} → [self : AddZeroClass M] → AddZero M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddZeroClass.{u} M] → AddZero.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZeroClass M] => self.1
```

### D038: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `17a3c7e66a4c2897891d468da70a58e73aa0b8e044ea0cc90d8d6e9e51c08f02`

Type:

```lean
{M : Type u_1} → {A : Type u_7} → [inst : Monoid M] → [inst_1 : AddMonoid A] → [DistribMulAction M A] → DistribSMul M A
```

Fully explicit type:

```lean
{M : Type u_1} →
  {A : Type u_7} →
    [inst : Monoid.{u_1} M] →
      [inst_1 : AddMonoid.{u_7} A] →
        [@DistribMulAction.{u_1, u_7} M A inst inst_1] →
          @DistribSMul.{u_1, u_7} M A (@AddMonoid.toAddZeroClass.{u_7} A inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun {M} {A} [Monoid M] [AddMonoid A] [inst_2 : DistribMulAction M A] =>
  let __src := inst_2;
  { toSMul := __src.toSMul, smul_zero := ⋯, smul_add := ⋯ }
```

### D039: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f640928ea31b161891006aaf9950d636ac5e1fbda413a7712f36546c938b3fdf`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : AddZeroClass A} → [self : DistribSMul M A] → SMulZeroClass M A
```

Fully explicit type:

```lean
{M : Type u_12} →
  {A : Type u_13} →
    {inst : AddZeroClass.{u_13} A} →
      [self : @DistribSMul.{u_12, u_13} M A inst] →
        @SMulZeroClass.{u_12, u_13} M A (@AddZero.toZero.{u_13} A (@AddZeroClass.toAddZero.{u_13} A inst))
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : DistribSMul M A] => self.1
```

### D040: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1aa070f54e8aff7a6558c977220472990963777ddc5f04c5284f49422c06b41f`

Type:

```lean
ENNReal → Real
```

Fully explicit type:

```lean
(a : ENNReal) → Real
```

Definition body (one-level semantic boundary):

```lean
fun a => a.toNNReal.toReal
```

### D041: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `7d58c19063063d627291b91068fa4bf2bf5ff88679897376ac465b9f52e93642`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ENormedAddCommMonoid E] → ESeminormedAddCommMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} →
  {inst : TopologicalSpace.{u_8} E} →
    [self : @ENormedAddCommMonoid.{u_8} E inst] → @ESeminormedAddCommMonoid.{u_8} E inst
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ENormedAddCommMonoid E] => self.1
```

### D042: `ESeminormedAddCommMonoid.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `38db724db757c42f8e8affdaa0b60310db98b78e8ba320c452775788f7191220`

Type:

```lean
{E : Type u_8} → [inst : TopologicalSpace E] → [self : ESeminormedAddCommMonoid E] → AddCommMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} →
  [inst : TopologicalSpace.{u_8} E] → [self : @ESeminormedAddCommMonoid.{u_8} E inst] → AddCommMonoid.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [TopologicalSpace E] self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D043: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `ad2e3c6c509dab0e1668564037784368e6c01e3dc381545577f451993c8283a4`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddCommMonoid E] → ESeminormedAddMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} →
  {inst : TopologicalSpace.{u_8} E} →
    [self : @ESeminormedAddCommMonoid.{u_8} E inst] → @ESeminormedAddMonoid.{u_8} E inst
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddCommMonoid E] => self.1
```

### D044: `ESeminormedAddMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `bf6ea4b699c55bfcdc7d32c89ca4d866413afa4dc5af86c3f4ff641d96cab901`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddMonoid E] → AddMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} → {inst : TopologicalSpace.{u_8} E} → [self : @ESeminormedAddMonoid.{u_8} E inst] → AddMonoid.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddMonoid E] => self.2
```

### D045: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f1757307432fadbd23925bbf0a318b8da57d17711478e1073a19ce64c21d55f4`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSMul α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HSMul.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSMul α β γ] => self.1
```

### D046: `Inv.inv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `c3aea3c6e2edd31a7b2cf071814315808ef7d84fd01d8c9b719313846ebca438`

Type:

```lean
{α : Type u} → [self : Inv α] → α → α
```

Fully explicit type:

```lean
{α : Type u} → [self : Inv.{u} α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Inv α] => self.1
```

### D047: `MeasureTheory.Measure.restrict`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Restrict`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `63c4446a3ae02833cbb1104dcc4f2ea534c0eae36f5642bfa8858a6593aa11e8`

Type:

```lean
{α : Type u_2} → {_m0 : MeasurableSpace α} → MeasureTheory.Measure α → Set α → MeasureTheory.Measure α
```

Fully explicit type:

```lean
{α : Type u_2} →
  {_m0 : MeasurableSpace.{u_2} α} →
    (μ : @MeasureTheory.Measure.{u_2} α _m0) → (s : Set.{u_2} α) → @MeasureTheory.Measure.{u_2} α _m0
```

Definition body (one-level semantic boundary):

```lean
fun {α} {_m0} μ s => LinearMap.instFunLike.coe (MeasureTheory.Measure.restrictₗ s) μ
```

### D048: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `428563f3d6b771605a3267457bf33b62ec2efa91a42b57b96121b85c0269a9ab`

Type:

```lean
{α : Type u_6} →
  {G : Type u_7} →
    [inst : NormedAddCommGroup G] →
      [NormedSpace Real G] → {x : MeasurableSpace α} → MeasureTheory.Measure α → (α → G) → G
```

Fully explicit type:

```lean
{α : Type u_6} →
  {G : Type u_7} →
    [inst : NormedAddCommGroup.{u_7} G] →
      [@NormedSpace.{0, u_7} Real G Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_7} G inst)] →
        {x : MeasurableSpace.{u_6} α} → (μ : @MeasureTheory.Measure.{u_6} α x) → (f : α → G) → G
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.wrapped✝.1
```

### D049: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Type:

```lean
{R : Type u} →
  {M : Type v} → {inst : Semiring R} → {inst_1 : AddCommMonoid M} → [self : Module R M] → DistribMulAction R M
```

Fully explicit type:

```lean
{R : Type u} →
  {M : Type v} →
    {inst : Semiring.{u} R} →
      {inst_1 : AddCommMonoid.{v} M} →
        [self : @Module.{u, v} R M inst inst_1] →
          @DistribMulAction.{u, v} R M (@MonoidWithZero.toMonoid.{u} R (@Semiring.toMonoidWithZero.{u} R inst))
            (@AddCommMonoid.toAddMonoid.{v} M inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun R M {inst} {inst_1} [self : Module R M] => self.1
```

### D050: `NormedAddCommGroup.toENormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eac639a9ae15f19554f668c9811538a135f4f05df04330bd8145b300efe57cfb`

Type:

```lean
{E : Type u_4} → [inst : NormedAddCommGroup E] → ENormedAddCommMonoid E
```

Fully explicit type:

```lean
{E : Type u_4} →
  [inst : NormedAddCommGroup.{u_4} E] →
    @ENormedAddCommMonoid.{u_4} E
      (@UniformSpace.toTopologicalSpace.{u_4} E
        (@PseudoMetricSpace.toUniformSpace.{u_4} E
          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst))))
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  let __spread.0 := NormedAddGroup.toENormedAddMonoid;
  have __spread.1 := inst;
  { toESeminormedAddMonoid := __spread.0.toESeminormedAddMonoid, add_comm := ⋯, enorm_eq_zero := ⋯ }
```

### D051: `NormedSpace.toModule`

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

Fully explicit type:

```lean
{𝕜 : Type u_6} →
  {E : Type u_7} →
    {inst : NormedField.{u_6} 𝕜} →
      {inst_1 : SeminormedAddCommGroup.{u_7} E} →
        [self : @NormedSpace.{u_6, u_7} 𝕜 E inst inst_1] →
          @Module.{u_6, u_7} 𝕜 E
            (@DivisionSemiring.toSemiring.{u_6} 𝕜
              (@Semifield.toDivisionSemiring.{u_6} 𝕜 (@Field.toSemifield.{u_6} 𝕜 (@NormedField.toField.{u_6} 𝕜 inst))))
            (@AddCommGroup.toAddCommMonoid.{u_7} E (@SeminormedAddCommGroup.toAddCommGroup.{u_7} E inst_1))
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : NormedSpace 𝕜 E] => self.1
```

### D052: `Real.instInv`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `8996fd673a1e2289aaf761085a60a161bdafebda8cdd48d1efb3c89da1382980`

Type:

```lean
Inv Real
```

Fully explicit type:

```lean
Inv.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ inv := Real.inv'✝ }
```

### D053: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Type:

```lean
Monoid Real
```

Fully explicit type:

```lean
Monoid.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D054: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Type:

```lean
Semiring Real
```

Fully explicit type:

```lean
Semiring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D055: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `a8cadadddb0c9fd4a7bcb7c57401fafb43a1f330afa35fdacacb6d0e82d0bcf6`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : Zero A} → [self : SMulZeroClass M A] → SMul M A
```

Fully explicit type:

```lean
{M : Type u_12} →
  {A : Type u_13} → {inst : Zero.{u_13} A} → [self : @SMulZeroClass.{u_12, u_13} M A inst] → SMul.{u_12, u_13} M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : SMulZeroClass M A] => self.1
```

### D056: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `04ea7c06812eccb8531b763b7aa28fd8f968befff069e74166ff1b406f7512e3`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [SMul α β] → HSMul α β β
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → [SMul.{u_1, u_2} α β] → HSMul.{u_1, u_2, u_2} α β β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : SMul α β] => { hSMul := inst.smul }
```

### D057: `CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra`

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

### D058: `CompleteBooleanAlgebra.toCompleteDistribLattice`

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

### D059: `CompleteBooleanAlgebra.toCompleteLattice`

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

### D060: `CompleteDistribLattice.toFrame`

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

### D061: `CompleteLattice.instOmegaCompletePartialOrder`

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

### D062: `Disjoint`

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

### D063: `HeytingAlgebra.toOrderBot`

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

### D064: `Iff`

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

### D065: `MeasurableSet`

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

### D066: `Nonempty`

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

### D067: `OmegaCompletePartialOrder.toPartialOrder`

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

### D068: `Order.Frame.toHeytingAlgebra`

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

### D069: `Set.instCompleteAtomicBooleanAlgebra`

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
