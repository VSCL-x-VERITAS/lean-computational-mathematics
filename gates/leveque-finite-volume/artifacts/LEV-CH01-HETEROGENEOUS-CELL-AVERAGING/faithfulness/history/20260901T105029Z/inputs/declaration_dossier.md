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
    (IsLeveque01HeterogeneousCellAveraging data ↔
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
            data.cellVolumeAverage field cell₂) ∧
      ∃ (cellLeft cellRight assignedCellProperty : Bool → ℝ),
        cellLeft false = 0 ∧ cellRight false = 1 ∧
        cellLeft true = 1 ∧ cellRight true = 2 ∧
        (∀ cell,
          IsOneDimensionalCellAverage (fun x : ℝ => x)
            (cellLeft cell) (cellRight cell) (assignedCellProperty cell)) ∧
        (∀ (field₁ field₂ : ℝ → ℝ) cell,
          Set.EqOn field₁ field₂
              (Set.uIcc (cellLeft cell) (cellRight cell)) →
            oneDimensionalCellAverage field₁
                (cellLeft cell) (cellRight cell) =
              oneDimensionalCellAverage field₂
                (cellLeft cell) (cellRight cell)) ∧
        assignedCellProperty false = (1 : ℝ) / 2 ∧
        assignedCellProperty true = (3 : ℝ) / 2 ∧
        assignedCellProperty false ≠ assignedCellProperty true
```

## Elaborated target type

```lean
∀ {Model : Type u_1} {Cell : Type u_2} {Point : Type u_3} {Parameter : Type u_4} {Property : Type u_5}
  [inst : MeasurableSpace Point]
  (data : NumStability.Leveque01HeterogeneousCellAveragingData Model Cell Point Parameter Property),
  And
    (Iff (NumStability.IsLeveque01HeterogeneousCellAveraging data)
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
                Exists fun cell₂ => Ne (data.cellVolumeAverage field cell₁) (data.cellVolumeAverage field cell₂))))))
    (Exists fun cellLeft =>
      Exists fun cellRight =>
        Exists fun assignedCellProperty =>
          And (Eq (cellLeft Bool.false) 0)
            (And (Eq (cellRight Bool.false) 1)
              (And (Eq (cellLeft Bool.true) 1)
                (And (Eq (cellRight Bool.true) 2)
                  (And
                    (∀ (cell : Bool),
                      NumStability.IsOneDimensionalCellAverage (fun x => x) (cellLeft cell) (cellRight cell)
                        (assignedCellProperty cell))
                    (And
                      (∀ (field₁ field₂ : Real → Real) (cell : Bool),
                        Set.EqOn field₁ field₂ (Set.uIcc (cellLeft cell) (cellRight cell)) →
                          Eq (NumStability.oneDimensionalCellAverage field₁ (cellLeft cell) (cellRight cell))
                            (NumStability.oneDimensionalCellAverage field₂ (cellLeft cell) (cellRight cell)))
                      (And (Eq (assignedCellProperty Bool.false) (1 / 2))
                        (And (Eq (assignedCellProperty Bool.true) (3 / 2))
                          (Ne (assignedCellProperty Bool.false) (assignedCellProperty Bool.true))))))))))
```

## Fully explicit elaborated target type

```lean
∀ {Model : Type u_1} {Cell : Type u_2} {Point : Type u_3} {Parameter : Type u_4} {Property : Type u_5}
  [inst : MeasurableSpace.{u_3} Point]
  (data :
    @NumStability.Leveque01HeterogeneousCellAveragingData.{u_1, u_2, u_3, u_4, u_5} Model Cell Point Parameter Property
      inst),
  And
    (Iff
      (@NumStability.IsLeveque01HeterogeneousCellAveraging.{u_1, u_2, u_3, u_4, u_5} Model Cell Point Parameter Property
        inst data)
      (And
        (∀ (cell : Cell),
          @Ne.{1} ENNReal
            (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1} (@MeasureTheory.Measure.{u_3} Point inst) (Set.{u_3} Point)
              (fun (x : Set.{u_3} Point) => ENNReal) (@MeasureTheory.Measure.instFunLike.{u_3} Point inst)
              (@NumStability.Leveque01HeterogeneousCellAveragingData.volumeMeasure.{u_1, u_2, u_3, u_4, u_5} Model Cell
                Point Parameter Property inst data)
              (@NumStability.Leveque01HeterogeneousCellAveragingData.cellRegion.{u_1, u_2, u_3, u_4, u_5} Model Cell
                Point Parameter Property inst data cell))
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
              (@NumStability.Leveque01HeterogeneousCellAveragingData.isAppropriateForModel.{u_1, u_2, u_3, u_4, u_5}
                Model Cell Point Parameter Property inst data
                (@NumStability.Leveque01HeterogeneousCellAveragingData.model.{u_1, u_2, u_3, u_4, u_5} Model Cell Point
                  Parameter Property inst data)
                (@NumStability.Leveque01HeterogeneousCellAveragingData.volumeMeasure.{u_1, u_2, u_3, u_4, u_5} Model
                  Cell Point Parameter Property inst data)
                (@NumStability.Leveque01HeterogeneousCellAveragingData.cellRegion.{u_1, u_2, u_3, u_4, u_5} Model Cell
                  Point Parameter Property inst data cell)
                (@NumStability.Leveque01HeterogeneousCellAveragingData.materialParameters.{u_1, u_2, u_3, u_4, u_5}
                  Model Cell Point Parameter Property inst data)
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
                  (@NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage.{u_1, u_2, u_3, u_4, u_5}
                    Model Cell Point Parameter Property inst data field₁ cell)
                  (@NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage.{u_1, u_2, u_3, u_4, u_5}
                    Model Cell Point Parameter Property inst data field₂ cell))
            (@Exists.{max (u_3 + 1) (u_4 + 1)} (Point → Parameter) fun (field : Point → Parameter) =>
              @Exists.{u_2 + 1} Cell fun (cell₁ : Cell) =>
                @Exists.{u_2 + 1} Cell fun (cell₂ : Cell) =>
                  @Ne.{u_5 + 1} Property
                    (@NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage.{u_1, u_2, u_3, u_4, u_5}
                      Model Cell Point Parameter Property inst data field cell₁)
                    (@NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage.{u_1, u_2, u_3, u_4, u_5}
                      Model Cell Point Parameter Property inst data field cell₂))))))
    (@Exists.{1} (Bool → Real) fun (cellLeft : Bool → Real) =>
      @Exists.{1} (Bool → Real) fun (cellRight : Bool → Real) =>
        @Exists.{1} (Bool → Real) fun (assignedCellProperty : Bool → Real) =>
          And
            (@Eq.{1} Real (cellLeft Bool.false)
              (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
            (And
              (@Eq.{1} Real (cellRight Bool.false)
                (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
              (And
                (@Eq.{1} Real (cellLeft Bool.true)
                  (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
                (And
                  (@Eq.{1} Real (cellRight Bool.true)
                    (@OfNat.ofNat.{0} Real (nat_lit 2)
                      (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                        (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                          (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))))))))
                  (And
                    (∀ (cell : Bool),
                      @NumStability.IsOneDimensionalCellAverage.{0} Real Real.normedAddCommGroup
                        (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                        (fun (x : Real) => x) (cellLeft cell) (cellRight cell) (assignedCellProperty cell))
                    (And
                      (∀ (field₁ field₂ : Real → Real) (cell : Bool),
                        @Set.EqOn.{0, 0} Real Real field₁ field₂
                            (@Set.uIcc.{0} Real Real.lattice (cellLeft cell) (cellRight cell)) →
                          @Eq.{1} Real
                            (@NumStability.oneDimensionalCellAverage.{0} Real Real.normedAddCommGroup
                              (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                              field₁ (cellLeft cell) (cellRight cell))
                            (@NumStability.oneDimensionalCellAverage.{0} Real Real.normedAddCommGroup
                              (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                              field₂ (cellLeft cell) (cellRight cell)))
                      (And
                        (@Eq.{1} Real (assignedCellProperty Bool.false)
                          (@HDiv.hDiv.{0, 0, 0} Real Real Real
                            (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                            (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
                            (@OfNat.ofNat.{0} Real (nat_lit 2)
                              (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                                (@Nat.instAtLeastTwoHAddOfNat
                                  (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                                  (@Nat.instNeZeroSucc
                                    (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))))))))
                        (And
                          (@Eq.{1} Real (assignedCellProperty Bool.true)
                            (@HDiv.hDiv.{0, 0, 0} Real Real Real
                              (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                              (@OfNat.ofNat.{0} Real (nat_lit 3)
                                (@instOfNatAtLeastTwo.{0} Real (nat_lit 3) Real.instNatCast
                                  (@Nat.instAtLeastTwoHAddOfNat
                                    (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))
                                    (@Nat.instNeZeroSucc
                                      (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))))))
                              (@OfNat.ofNat.{0} Real (nat_lit 2)
                                (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                                  (@Nat.instAtLeastTwoHAddOfNat
                                    (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                                    (@Nat.instNeZeroSucc
                                      (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))))))))
                          (@Ne.{1} Real (assignedCellProperty Bool.false) (assignedCellProperty Bool.true))))))))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.Analysis.SpecialFunctions.Integrals.Basic`
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

### D002: `NumStability.IsOneDimensionalCellAverage`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f4a0581c0704466157ec8a594a746c19226d3df834e0562c22da5b848f18ab08`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → E → Prop
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (field : Real → E) → (left right : Real) → (average : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] field left right average =>
  And (Real.instLT.lt left right)
    (And (IntervalIntegrable field Real.measureSpace.volume left right)
      (Eq average (NumStability.oneDimensionalCellAverage field left right)))
```

### D003: `NumStability.Leveque01HeterogeneousCellAveragingData`

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

### D004: `NumStability.Leveque01HeterogeneousCellAveragingData.assignedCellProperties`

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

### D005: `NumStability.Leveque01HeterogeneousCellAveragingData.cellRegion`

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

### D006: `NumStability.Leveque01HeterogeneousCellAveragingData.cellVolumeAverage`

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

### D007: `NumStability.Leveque01HeterogeneousCellAveragingData.isAppropriateForModel`

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

### D008: `NumStability.Leveque01HeterogeneousCellAveragingData.materialParameters`

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

### D009: `NumStability.Leveque01HeterogeneousCellAveragingData.model`

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

### D010: `NumStability.Leveque01HeterogeneousCellAveragingData.volumeMeasure`

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

### D011: `NumStability.oneDimensionalCellAverage`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9823d7b63ed73636fd143d04671c624be21e1e858d0979ef885518aef0b04c64`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → E
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (field : Real → E) → (left right : Real) → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] field left right =>
  instHSMul.hSMul (Real.instInv.inv (instHSub.hSub right left))
    (intervalIntegral (fun x => field x) left right Real.measureSpace.volume)
```

### D012: `NumStability.Leveque01HeterogeneousCellAveragingData.mk`

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

### D013: `And`

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

### D014: `Bool`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `e95da6be35714acbe5505fa5c6ba913c979305a6d87f38e35096664b551ce829`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D015: `Bool.false`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `903a7293b3a1c2eca38e3f5e4346c7e732c386d96e6399ffb0cedaba068cd441`

Type:

```lean
Bool
```

Fully explicit type:

```lean
Bool
```

### D016: `Bool.true`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `97e763ea95d8452117cf5762fd67acddd549677f08ccfa348c4bf23db7eaa9d8`

Type:

```lean
Bool
```

Fully explicit type:

```lean
Bool
```

### D017: `DFunLike.coe`

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

### D018: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Fully explicit type:

```lean
{G : Type u} → [self : DivInvMonoid.{u} G] → Div.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D019: `ENNReal`

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

### D020: `Eq`

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

### D021: `Exists`

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

### D022: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HDiv.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D023: `Iff`

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

### D024: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `683435a8d27d50ec1482d74d23f541d52d05ff0411c60f88d16c32132aca9f3e`

Type:

```lean
{𝕜 : Type u_4} →
  {E : Type u_5} →
    {inst : RCLike 𝕜} → {inst_1 : SeminormedAddCommGroup E} → [self : InnerProductSpace 𝕜 E] → NormedSpace 𝕜 E
```

Fully explicit type:

```lean
{𝕜 : Type u_4} →
  {E : Type u_5} →
    {inst : RCLike.{u_4} 𝕜} →
      {inst_1 : SeminormedAddCommGroup.{u_5} E} →
        [self : @InnerProductSpace.{u_4, u_5} 𝕜 E inst inst_1] →
          @NormedSpace.{u_4, u_5} 𝕜 E
            (@DenselyNormedField.toNormedField.{u_4} 𝕜 (@RCLike.toDenselyNormedField.{u_4} 𝕜 inst)) inst_1
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : InnerProductSpace 𝕜 E] => self.1
```

### D025: `MeasurableSpace`

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

### D026: `MeasureTheory.Measure`

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

### D027: `MeasureTheory.Measure.instFunLike`

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

### D028: `Membership.mem`

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

### D029: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D030: `Nat.instAtLeastTwoHAddOfNat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Init`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `309ef94c4b7cfbe2e668952e6915279353921d5d48b6123a30f90dd932dac3e6`

Type:

```lean
∀ (n : Nat) [NeZero n], (instHAdd.hAdd n 1).AtLeastTwo
```

Fully explicit type:

```lean
∀ (n : Nat) [@NeZero.{0} Nat (@Zero.ofOfNat0.{0} Nat (instOfNatNat (nat_lit 0))) n],
  Nat.AtLeastTwo
    (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
      (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
```

### D031: `Nat.instNeZeroSucc`

- Role: `external-frontier`
- Owner module: `Init.Data.Nat.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `a0735a528184c05594c4c79312c1225bb4dcffcdf0df7eb1a50c5733047c85ad`

Type:

```lean
∀ {n : Nat}, NeZero (instHAdd.hAdd n 1)
```

Fully explicit type:

```lean
∀ {n : Nat},
  @NeZero.{0} Nat (@Zero.ofOfNat0.{0} Nat (instOfNatNat (nat_lit 0)))
    (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) n
      (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
```

### D032: `Ne`

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

### D033: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D034: `OfNat.ofNat`

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

### D035: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cc544b5b2a2aabc84389a9fe2f052127dc6dae9964782b117b9b19b773e542d5`

Type:

```lean
{α : Type u_1} → [One α] → OfNat α 1
```

Fully explicit type:

```lean
{α : Type u_1} → [One.{u_1} α] → OfNat.{u_1} α (nat_lit 1)
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : One α] => { ofNat := inst.one }
```

### D036: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f602276baee30d3dbe02bd6b756a9097f750d59a7f91ca7635dcfc935fd22981`

Type:

```lean
{𝕜 : Type u_1} → [inst : RCLike 𝕜] → InnerProductSpace Real 𝕜
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : RCLike.{u_1} 𝕜] →
    @InnerProductSpace.{0, u_1} Real 𝕜 Real.instRCLike
      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{u_1} 𝕜
        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{u_1} 𝕜
          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{u_1} 𝕜
            (@NormedCommRing.toSeminormedCommRing.{u_1} 𝕜
              (@NormedField.toNormedCommRing.{u_1} 𝕜
                (@DenselyNormedField.toNormedField.{u_1} 𝕜 (@RCLike.toDenselyNormedField.{u_1} 𝕜 inst)))))))
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [RCLike 𝕜] =>
  let __spread.0 := Inner.rclikeToReal 𝕜 𝕜;
  { toNormedSpace := NormedAlgebra.toNormedSpace 𝕜, toInner := __spread.0, norm_sq_eq_re_inner := ⋯,
    conj_inner_symm := ⋯, add_left := ⋯, smul_left := ⋯ }
```

### D037: `Real`

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

### D038: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `166f2abb65bf1271e5e8d70fdb78c55672c7e366b30439e83b517f803cdefac3`

Type:

```lean
DivInvMonoid Real
```

Fully explicit type:

```lean
DivInvMonoid.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toMonoid := Real.instMonoid, toInv := Real.instInv, div := DivInvMonoid.div',
  div_eq_mul_inv := Real.instDivInvMonoid._proof_1, zpow := zpowRec, zpow_zero' := Real.instDivInvMonoid._proof_2,
  zpow_succ' := Real.instDivInvMonoid._proof_3, zpow_neg' := Real.instDivInvMonoid._proof_4 }
```

### D039: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5fc7a7becbc71d472fa1a28bd92d79b4c6ea4fdc643db7380031a2b890ca7e15`

Type:

```lean
NatCast Real
```

Fully explicit type:

```lean
NatCast.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ natCast := fun n => { cauchy := n.cast } }
```

### D040: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b4e24b050b7fb50c4c115c51d5cd4c1b180cae53633f58a38c7d5ce3ccf86c81`

Type:

```lean
One Real
```

Fully explicit type:

```lean
One.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ one := Real.one✝ }
```

### D041: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d2fdb97b9d861fcf61e6dbea9993dfa0ca6aa16609742f215c35b3f7ddd16b8e`

Type:

```lean
RCLike Real
```

Fully explicit type:

```lean
RCLike.{0} Real
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

### D042: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Type:

```lean
Zero Real
```

Fully explicit type:

```lean
Zero.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ zero := Real.zero✝ }
```

### D043: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5bccf78d647cf08233ff548c19523f80b1d1bf11b5a76aa50396199e2c0c7510`

Type:

```lean
Lattice Real
```

Fully explicit type:

```lean
Lattice.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D044: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Type:

```lean
NormedAddCommGroup Real
```

Fully explicit type:

```lean
NormedAddCommGroup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toNorm := Real.norm, toAddCommGroup := Real.instAddCommGroup, toMetricSpace := Real.metricSpace, dist_eq := ⋯ }
```

### D045: `Set`

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

### D046: `Set.EqOn`

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

### D047: `Set.instMembership`

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

### D048: `Set.uIcc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.UnorderedInterval`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `53623b127289993b0a6b152099093b949fab395160dd4c87afcb2f3e4b86821e`

Type:

```lean
{α : Type u_1} → [Lattice α] → α → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Lattice.{u_1} α] → (a b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Lattice α] a b => Set.Icc (SemilatticeInf.toMin.min a b) (SemilatticeSup.toMax.max a b)
```

### D049: `Zero.toOfNat0`

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

### D050: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Div.{u_1} α] → HDiv.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```

### D051: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `37355febc51d6fa8ff12fc8e7b429771db340390d46411d7608c566bdffd358d`

Type:

```lean
{R : Type u_1} → {n : Nat} → [NatCast R] → [n.AtLeastTwo] → OfNat R n
```

Fully explicit type:

```lean
{R : Type u_1} → {n : Nat} → [NatCast.{u_1} R] → [Nat.AtLeastTwo n] → OfNat.{u_1} R n
```

Definition body (one-level semantic boundary):

```lean
fun {R} {n} [NatCast R] [n.AtLeastTwo] => { ofNat := n.cast }
```

### D052: `instOfNatNat`

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

### D053: `instZeroENNReal`

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

### D054: `AddMonoid.toAddZeroClass`

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

### D055: `AddZero.toZero`

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

### D056: `AddZeroClass.toAddZero`

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

### D057: `DistribMulAction.toDistribSMul`

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

### D058: `DistribSMul.toSMulZeroClass`

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

### D059: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

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

### D060: `ESeminormedAddCommMonoid.toAddCommMonoid`

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

### D061: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

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

### D062: `ESeminormedAddMonoid.toAddMonoid`

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

### D063: `HSMul.hSMul`

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

### D064: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `98025b38d523c0eadea77ba4961a20b2a913b23c079c4bfeba24a7bfaa24a4bc`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSub α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HSub.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSub α β γ] => self.1
```

### D065: `IntervalIntegrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `438d3df5ccfcf0ec98ba944c6cd9e02b599992e15f8bcb33aaf6cc91c6e2c352`

Type:

```lean
{ε : Type u_3} →
  [inst : TopologicalSpace ε] → [ENormedAddMonoid ε] → (Real → ε) → MeasureTheory.Measure Real → Real → Real → Prop
```

Fully explicit type:

```lean
{ε : Type u_3} →
  [inst : TopologicalSpace.{u_3} ε] →
    [@ENormedAddMonoid.{u_3} ε inst] →
      (f : Real → ε) → (μ : @MeasureTheory.Measure.{0} Real Real.measurableSpace) → (a b : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ε} [TopologicalSpace ε] [ENormedAddMonoid ε] f μ a b =>
  And (MeasureTheory.IntegrableOn f (Set.Ioc a b) μ) (MeasureTheory.IntegrableOn f (Set.Ioc b a) μ)
```

### D066: `Inv.inv`

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

### D067: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Type:

```lean
{α : Type u} → [self : LT α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u} → [self : LT.{u} α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LT α] => self.1
```

### D068: `MeasureTheory.MeasureSpace.volume`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8aa44f6be6ed612f15d809220aa22d43c0715b7383456cd968b96336c71bcb65`

Type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace α] → MeasureTheory.Measure α
```

Fully explicit type:

```lean
{α : Type u_6} →
  [self : MeasureTheory.MeasureSpace.{u_6} α] →
    @MeasureTheory.Measure.{u_6} α (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_6} α self)
```

Definition body (one-level semantic boundary):

```lean
fun α [self : MeasureTheory.MeasureSpace α] => self.2
```

### D069: `Module.toDistribMulAction`

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

### D070: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

Fully explicit type:

```lean
(E : Type u_8) → Type u_8
```

### D071: `NormedAddCommGroup.toENormedAddCommMonoid`

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

### D072: `NormedAddCommGroup.toNormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `cdc7999c66248f7b0f68477de30ff4d9ea7a7f0df0bc6f092bc024f699d646fe`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → NormedAddGroup E
```

Fully explicit type:

```lean
{E : Type u_5} → [NormedAddCommGroup.{u_5} E] → NormedAddGroup.{u_5} E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯ }
```

### D073: `NormedAddGroup.toENormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c2e4373a88aee873807ebe0c84a9ad97e86c59f70ff5cf5af4d6497b3024e91a`

Type:

```lean
{F : Type u_7} → [inst : NormedAddGroup F] → ENormedAddMonoid F
```

Fully explicit type:

```lean
{F : Type u_7} →
  [inst : NormedAddGroup.{u_7} F] →
    @ENormedAddMonoid.{u_7} F
      (@UniformSpace.toTopologicalSpace.{u_7} F
        (@PseudoMetricSpace.toUniformSpace.{u_7} F
          (@SeminormedAddGroup.toPseudoMetricSpace.{u_7} F (@NormedAddGroup.toSeminormedAddGroup.{u_7} F inst))))
```

Definition body (one-level semantic boundary):

```lean
fun {F} [inst : NormedAddGroup F] =>
  { toContinuousENorm := SeminormedAddGroup.toContinuousENorm, toAddMonoid := inst.toAddMonoid, enorm_zero := ⋯,
    enorm_add_le := ⋯, enorm_eq_zero := ⋯ }
```

### D074: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

Fully explicit type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField.{u_6} 𝕜] → [SeminormedAddCommGroup.{u_7} E] → Type (max u_6 u_7)
```

### D075: `NormedSpace.toModule`

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

### D076: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D077: `Real.instInv`

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

### D078: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Type:

```lean
LT Real
```

Fully explicit type:

```lean
LT.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ lt := Real.lt✝ }
```

### D079: `Real.instMonoid`

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

### D080: `Real.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `926d9e8fcca2819a885d446e168b20c7c8aac2e542d59ed2b48e32c9a4659a36`

Type:

```lean
Sub Real
```

Fully explicit type:

```lean
Sub.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ sub := fun a b => instHAdd.hAdd a (Real.instNeg.neg b) }
```

### D081: `Real.measureSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Haar.OfBasis`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `d9de6598dfa4dc9b2cc1dfbccf206b37d159db61f4b35cc745a68902fbc74b22`

Type:

```lean
MeasureTheory.MeasureSpace Real
```

Fully explicit type:

```lean
MeasureTheory.MeasureSpace.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D082: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D083: `Real.semiring`

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

### D084: `SMulZeroClass.toSMul`

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

### D085: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D086: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D087: `instHSMul`

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

### D088: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `aa782f2b5af3d068f4c5340de4b32b193fece2c659a45582cc3024a19b550c87`

Type:

```lean
{α : Type u_1} → [Sub α] → HSub α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Sub.{u_1} α] → HSub.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Sub α] => { hSub := fun a b => inst.sub a b }
```

### D089: `intervalIntegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e2e08df1f4ea189c5c8b18b5894e96ab72c9a6e408e68c9dbbb6462e003414b2`

Type:

```lean
{E : Type u_5} →
  [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → MeasureTheory.Measure Real → E
```

Fully explicit type:

```lean
{E : Type u_5} →
  [inst : NormedAddCommGroup.{u_5} E] →
    [@NormedSpace.{0, u_5} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_5} E inst)] →
      (f : Real → E) → (a b : Real) → (μ : @MeasureTheory.Measure.{0} Real Real.measurableSpace) → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] f a b μ =>
  instHSub.hSub (MeasureTheory.integral (μ.restrict (Set.Ioc a b)) fun x => f x)
    (MeasureTheory.integral (μ.restrict (Set.Ioc b a)) fun x => f x)
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
