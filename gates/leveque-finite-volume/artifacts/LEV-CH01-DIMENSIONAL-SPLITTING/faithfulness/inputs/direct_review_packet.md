# Declaration dossier for LEV-CH01-DIMENSIONAL-SPLITTING

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_dimensionalSplitting_sourceContract
    {Cell Value : Type*} {Point Direction : Type u} [MeasurableSpace Point]
    (grid : CoordinateFiniteVolumeGrid Cell Point Direction)
    (method : CoordinateHighResolutionMethod Direction Cell Value)
    (initialState : FiniteVolumeCellState Cell Value) :
    ∃ schedule finalState trace,
      schedule =
        coordinateFractionalSchedule grid.coordinateDirections method ∧
      schedule ≠ [] ∧
      (∀ direction,
        ∃ step ∈ schedule,
          step.direction = direction ∧
          step.timeFraction = method.timeFraction direction ∧
          step.oneDimensionalSolve = method.solveDirection direction) ∧
      CoordinateSweepExecution schedule initialState finalState trace ∧
      trace.length = schedule.length + 1
```

## Elaborated target type

```lean
∀ {Cell : Type u_1} {Value : Type u_2} {Point Direction : Type u} [inst : MeasurableSpace Point]
  (grid : NumStability.CoordinateFiniteVolumeGrid Cell Point Direction)
  (method : NumStability.CoordinateHighResolutionMethod Direction Cell Value)
  (initialState : NumStability.FiniteVolumeCellState Cell Value),
  Exists fun schedule =>
    Exists fun finalState =>
      Exists fun trace =>
        And (Eq schedule (NumStability.coordinateFractionalSchedule grid.coordinateDirections method))
          (And (Ne schedule List.nil)
            (And
              (∀ (direction : Direction),
                Exists fun step =>
                  And (List.instMembership.mem schedule step)
                    (And (Eq step.direction direction)
                      (And (Eq step.timeFraction (method.timeFraction direction))
                        (Eq step.oneDimensionalSolve (method.solveDirection direction)))))
              (And (NumStability.CoordinateSweepExecution schedule initialState finalState trace)
                (Eq trace.length (instHAdd.hAdd schedule.length 1)))))
```

## Fully explicit elaborated target type

```lean
∀ {Cell : Type u_1} {Value : Type u_2} {Point Direction : Type u} [inst : MeasurableSpace.{u} Point]
  (grid : @NumStability.CoordinateFiniteVolumeGrid.{u, u_1} Cell Point Direction inst)
  (method : NumStability.CoordinateHighResolutionMethod.{u, u_1, u_2} Direction Cell Value)
  (initialState : NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value),
  @Exists.{max (max (u + 1) (u_1 + 1)) (u_2 + 1)}
    (List.{max (max u_2 u_1) u} (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value))
    fun
      (schedule :
        List.{max (max u_2 u_1) u} (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value)) =>
    @Exists.{max (u_1 + 1) (u_2 + 1)} (NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value)
      fun (finalState : NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value) =>
      @Exists.{max (u_1 + 1) (u_2 + 1)} (List.{max u_2 u_1} (NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value))
        fun (trace : List.{max u_2 u_1} (NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value)) =>
        And
          (@Eq.{max (max (u + 1) (u_1 + 1)) (u_2 + 1)}
            (List.{max (max u_2 u_1) u} (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value))
            schedule
            (@NumStability.coordinateFractionalSchedule.{u, u_1, u_2} Direction Cell Value
              (@NumStability.CoordinateFiniteVolumeGrid.coordinateDirections.{u, u_1} Cell Point Direction inst grid)
              method))
          (And
            (@Ne.{max (max (u + 1) (u_1 + 1)) (u_2 + 1)}
              (List.{max (max u_2 u_1) u} (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value))
              schedule
              (@List.nil.{max (max u u_1) u_2}
                (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value)))
            (And
              (∀ (direction : Direction),
                @Exists.{(max (max u u_1) u_2) + 1}
                  (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value)
                  fun (step : NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value) =>
                  And
                    (@Membership.mem.{max (max u u_1) u_2, max (max u u_1) u_2}
                      (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value)
                      (List.{max (max u_2 u_1) u}
                        (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value))
                      (@List.instMembership.{max (max u u_1) u_2}
                        (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value))
                      schedule step)
                    (And
                      (@Eq.{u + 1} Direction
                        (@NumStability.CoordinateFractionalStep.direction.{u, u_1, u_2} Direction Cell Value step)
                        direction)
                      (And
                        (@Eq.{1} Real
                          (@NumStability.CoordinateFractionalStep.timeFraction.{u, u_1, u_2} Direction Cell Value step)
                          (@NumStability.CoordinateHighResolutionMethod.timeFraction.{u, u_1, u_2} Direction Cell Value
                            method direction))
                        (@Eq.{max (u_1 + 1) (u_2 + 1)}
                          (NumStability.OneDimensionalHighResolutionFiniteVolumeSolve.{u_1, u_2} Cell Value)
                          (@NumStability.CoordinateFractionalStep.oneDimensionalSolve.{u, u_1, u_2} Direction Cell Value
                            step)
                          (@NumStability.CoordinateHighResolutionMethod.solveDirection.{u, u_1, u_2} Direction Cell
                            Value method direction)))))
              (And
                (@NumStability.CoordinateSweepExecution.{u, u_1, u_2} Direction Cell Value schedule initialState
                  finalState trace)
                (@Eq.{1} Nat
                  (@List.length.{max u_1 u_2} (NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value) trace)
                  (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat)
                    (@List.length.{max (max u u_1) u_2}
                      (NumStability.CoordinateFractionalStep.{u, u_1, u_2} Direction Cell Value) schedule)
                    (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting` imports: `Mathlib.Data.List.Basic`, `Mathlib.Data.Real.Basic`, `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.CoordinateFiniteVolumeGrid`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ed132d0dc47a03534bd52648113b7f68961e5c2f8a3e4101249f102fc5b6124b`

Type:

```lean
Type v → (Point : Type u) → Type u → [MeasurableSpace Point] → Type (max u v)
```

Fully explicit type:

```lean
(Cell : Type v) → (Point Direction : Type u) → [MeasurableSpace.{u} Point] → Type (max u v)
```

### D002: `NumStability.CoordinateFiniteVolumeGrid.coordinateDirections`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `891bb7dfd91738cb626e5e600b747eac868848d7cb39f0c228d68394f63ad930`

Type:

```lean
{Cell : Type v} →
  {Point Direction : Type u} →
    [inst : MeasurableSpace Point] →
      NumStability.CoordinateFiniteVolumeGrid Cell Point Direction → NumStability.CoordinateDirectionFamily Direction
```

Fully explicit type:

```lean
{Cell : Type v} →
  {Point Direction : Type u} →
    [inst : MeasurableSpace.{u} Point] →
      (self : @NumStability.CoordinateFiniteVolumeGrid.{u, v} Cell Point Direction inst) →
        NumStability.CoordinateDirectionFamily.{u} Direction
```

Definition body (one-level semantic boundary):

```lean
fun Cell Point Direction [MeasurableSpace Point] self => self.2
```

### D003: `NumStability.CoordinateFractionalStep`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `6db56c4ac4b6d6d8495bc2ccf127c7629472b483f38abe06ce676a27f1d2ed40`

Type:

```lean
Type u_1 → Type u_2 → Type u_3 → Type (max (max u_1 u_2) u_3)
```

Fully explicit type:

```lean
(Direction : Type u_1) → (Cell : Type u_2) → (Value : Type u_3) → Type (max (max u_1 u_2) u_3)
```

### D004: `NumStability.CoordinateFractionalStep.direction`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `afd864f7ae0df4777de16f38cdc3549ddb284e367d23021941dbf034c1aa8e71`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} → {Value : Type u_3} → NumStability.CoordinateFractionalStep Direction Cell Value → Direction
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} → (self : NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value) → Direction
```

Definition body (one-level semantic boundary):

```lean
fun Direction Cell Value self => self.1
```

### D005: `NumStability.CoordinateFractionalStep.oneDimensionalSolve`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `14379befd59f874c75b4d499de65cf88ba35ffd0f31951e612f4a9c6d7c0eed9`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      NumStability.CoordinateFractionalStep Direction Cell Value →
        NumStability.OneDimensionalHighResolutionFiniteVolumeSolve Cell Value
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      (self : NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value) →
        NumStability.OneDimensionalHighResolutionFiniteVolumeSolve.{u_2, u_3} Cell Value
```

Definition body (one-level semantic boundary):

```lean
fun Direction Cell Value self => self.5
```

### D006: `NumStability.CoordinateFractionalStep.timeFraction`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9f8ca3702bdc98ccd76819f841778526dfdfea6e2c93adb0e1c5ba491f5b0325`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} → {Value : Type u_3} → NumStability.CoordinateFractionalStep Direction Cell Value → Real
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} → (self : NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value) → Real
```

Definition body (one-level semantic boundary):

```lean
fun Direction Cell Value self => self.2
```

### D007: `NumStability.CoordinateHighResolutionMethod`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `1a88388053d2363b204524f699cba41aac8063822d44d9c3a10ecfa2fce3a352`

Type:

```lean
Type u_1 → Type u_2 → Type u_3 → Type (max (max u_1 u_2) u_3)
```

Fully explicit type:

```lean
(Direction : Type u_1) → (Cell : Type u_2) → (Value : Type u_3) → Type (max (max u_1 u_2) u_3)
```

### D008: `NumStability.CoordinateHighResolutionMethod.solveDirection`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `47232fea4039de92a56c4db25e86b4f980f9e5edbd66b70fe7f28d035d21d629`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      NumStability.CoordinateHighResolutionMethod Direction Cell Value →
        Direction → NumStability.OneDimensionalHighResolutionFiniteVolumeSolve Cell Value
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      (self : NumStability.CoordinateHighResolutionMethod.{u_1, u_2, u_3} Direction Cell Value) →
        Direction → NumStability.OneDimensionalHighResolutionFiniteVolumeSolve.{u_2, u_3} Cell Value
```

Definition body (one-level semantic boundary):

```lean
fun Direction Cell Value self => self.1
```

### D009: `NumStability.CoordinateHighResolutionMethod.timeFraction`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `125b5368e7d8b46c9ddf8aef62cf06fc5d8444f05892fd0e28b3f1427e2cdaa1`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} → NumStability.CoordinateHighResolutionMethod Direction Cell Value → Direction → Real
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      (self : NumStability.CoordinateHighResolutionMethod.{u_1, u_2, u_3} Direction Cell Value) → Direction → Real
```

Definition body (one-level semantic boundary):

```lean
fun Direction Cell Value self => self.2
```

### D010: `NumStability.CoordinateSweepExecution`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `534790a7c7e4e1a335b2ce43c7f036ac68c9f24a1d2ce2b24a9c9c2be2cd2650`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      List (NumStability.CoordinateFractionalStep Direction Cell Value) →
        NumStability.FiniteVolumeCellState Cell Value →
          NumStability.FiniteVolumeCellState Cell Value → List (NumStability.FiniteVolumeCellState Cell Value) → Prop
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      List.{max (max u_3 u_2) u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value) →
        NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value →
          NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value →
            List.{max u_3 u_2} (NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value) → Prop
```

### D011: `NumStability.FiniteVolumeCellState`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c9a30818c895da1fab05e06e8103040fcaa54f12e46cc7d45cb2742c81075b1e`

Type:

```lean
Type u_1 → Type u_2 → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Cell : Type u_1) → (Value : Type u_2) → Type (max u_1 u_2)
```

Definition body (one-level semantic boundary):

```lean
fun Cell Value => Cell → Value
```

### D012: `NumStability.OneDimensionalHighResolutionFiniteVolumeSolve`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `c2182c7388dc9424d3e58adf983aa4ce8fa08ca5a2aa3d7fea89eb2faa985174`

Type:

```lean
Type u_1 → Type u_2 → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Cell : Type u_1) → (Value : Type u_2) → Type (max u_1 u_2)
```

### D013: `NumStability.coordinateFractionalSchedule`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `6f05df8a287dfe45744b2838507ecbef33ff47c6e6c43aaa9f56f2e0b6447e4f`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      NumStability.CoordinateDirectionFamily Direction →
        NumStability.CoordinateHighResolutionMethod Direction Cell Value →
          List (NumStability.CoordinateFractionalStep Direction Cell Value)
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      (directions : NumStability.CoordinateDirectionFamily.{u_1} Direction) →
        (method : NumStability.CoordinateHighResolutionMethod.{u_1, u_2, u_3} Direction Cell Value) →
          List.{max (max u_3 u_2) u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value)
```

Definition body (one-level semantic boundary):

```lean
fun {Direction} {Cell} {Value} directions method => List.map method.fractionalStep directions.directions
```

### D014: `NumStability.CoordinateDirectionFamily`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `532df3dfeecf13970c75ec06f8e0161fcd19f6e7de2659cc9589dbf0fdb227be`

Type:

```lean
Type u_1 → Type u_1
```

Fully explicit type:

```lean
(Direction : Type u_1) → Type u_1
```

### D015: `NumStability.CoordinateDirectionFamily.directions`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `334289acb00e003903068d17583cd6a5657a696e01f2cfc07247d69e9eae102d`

Type:

```lean
{Direction : Type u_1} → NumStability.CoordinateDirectionFamily Direction → List Direction
```

Fully explicit type:

```lean
{Direction : Type u_1} → (self : NumStability.CoordinateDirectionFamily.{u_1} Direction) → List.{u_1} Direction
```

Definition body (one-level semantic boundary):

```lean
fun Direction self => self.1
```

### D016: `NumStability.CoordinateFiniteVolumeGrid.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `7b1eca62117cffab9a4ad0949ad3dff624d9c429a2112c9e2d2c891f9666ebc6`

Type:

```lean
{Cell : Type v} →
  {Point Direction : Type u} →
    [inst : MeasurableSpace Point] →
      (partition : NumStability.FiniteVolumeCellPartition Cell Point) →
        (coordinateDirections : NumStability.CoordinateDirectionFamily Direction) →
          (geometry : NumStability.CoordinateGridGeometry Point Direction) →
            (lowerFace upperFace : Cell → Direction → Real) →
              (∀ (cell : Cell) (direction : Direction),
                  Real.instLT.lt (lowerFace cell direction) (upperFace cell direction)) →
                (∀ (cell : Cell),
                    Eq (partition.cellRegion cell)
                      (NumStability.coordinateCellBox geometry coordinateDirections.directions (lowerFace cell)
                        (upperFace cell))) →
                  NumStability.CoordinateFiniteVolumeGrid Cell Point Direction
```

Fully explicit type:

```lean
{Cell : Type v} →
  {Point Direction : Type u} →
    [inst : MeasurableSpace.{u} Point] →
      (partition : @NumStability.FiniteVolumeCellPartition.{v, u} Cell Point inst) →
        (coordinateDirections : NumStability.CoordinateDirectionFamily.{u} Direction) →
          (geometry : NumStability.CoordinateGridGeometry.{u} Point Direction) →
            (lowerFace upperFace : Cell → Direction → Real) →
              (positive_coordinate_width :
                  ∀ (cell : Cell) (direction : Direction),
                    @LT.lt.{0} Real Real.instLT (lowerFace cell direction) (upperFace cell direction)) →
                (cellRegion_eq_coordinateBox :
                    ∀ (cell : Cell),
                      @Eq.{u + 1} (Set.{u} Point)
                        (@NumStability.FiniteVolumeCellPartition.cellRegion.{v, u} Cell Point inst partition cell)
                        (@NumStability.coordinateCellBox.{u} Point Direction geometry
                          (@NumStability.CoordinateDirectionFamily.directions.{u} Direction coordinateDirections)
                          (lowerFace cell) (upperFace cell))) →
                  @NumStability.CoordinateFiniteVolumeGrid.{u, v} Cell Point Direction inst
```

### D017: `NumStability.CoordinateFractionalStep.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `9ef0ac6c5225ae25c9d99b1dc20349b6c54a5254553be54a8ba8cc1c57a61942`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      Direction →
        (timeFraction : Real) →
          Real.instLT.lt 0 timeFraction →
            Real.instLE.le timeFraction 1 →
              NumStability.OneDimensionalHighResolutionFiniteVolumeSolve Cell Value →
                NumStability.CoordinateFractionalStep Direction Cell Value
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      (direction : Direction) →
        (timeFraction : Real) →
          (positive_timeFraction :
              @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                timeFraction) →
            (timeFraction_le_one :
                @LE.le.{0} Real Real.instLE timeFraction
                  (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))) →
              (oneDimensionalSolve : NumStability.OneDimensionalHighResolutionFiniteVolumeSolve.{u_2, u_3} Cell Value) →
                NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value
```

### D018: `NumStability.CoordinateHighResolutionMethod.fractionalStep`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e48ddde902c568f0b6bbc55bf015e1a966371e34d088fe872c426cd0f9a1d4e6`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      NumStability.CoordinateHighResolutionMethod Direction Cell Value →
        Direction → NumStability.CoordinateFractionalStep Direction Cell Value
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      (method : NumStability.CoordinateHighResolutionMethod.{u_1, u_2, u_3} Direction Cell Value) →
        (direction : Direction) → NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value
```

Definition body (one-level semantic boundary):

```lean
fun {Direction} {Cell} {Value} method direction =>
  { direction := direction, timeFraction := method.timeFraction direction, positive_timeFraction := ⋯,
    timeFraction_le_one := ⋯, oneDimensionalSolve := method.solveDirection direction }
```

### D019: `NumStability.CoordinateHighResolutionMethod.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `ef130f942efbceef3f245f11bb4ec3c9030479d87e2b7e46a0d7ddd37181ceaf`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      (Direction → NumStability.OneDimensionalHighResolutionFiniteVolumeSolve Cell Value) →
        (timeFraction : Direction → Real) →
          (∀ (direction : Direction), Real.instLT.lt 0 (timeFraction direction)) →
            (∀ (direction : Direction), Real.instLE.le (timeFraction direction) 1) →
              NumStability.CoordinateHighResolutionMethod Direction Cell Value
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      (solveDirection : Direction → NumStability.OneDimensionalHighResolutionFiniteVolumeSolve.{u_2, u_3} Cell Value) →
        (timeFraction : Direction → Real) →
          (positive_timeFraction :
              ∀ (direction : Direction),
                @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                  (timeFraction direction)) →
            (timeFraction_le_one :
                ∀ (direction : Direction),
                  @LE.le.{0} Real Real.instLE (timeFraction direction)
                    (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))) →
              NumStability.CoordinateHighResolutionMethod.{u_1, u_2, u_3} Direction Cell Value
```

### D020: `NumStability.CoordinateSweepExecution.cons`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `8f632236de35189c0214d2117f26a369463b44b7525476616b5276173bb49c4a`

Type:

```lean
∀ {Direction : Type u_1} {Cell : Type u_2} {Value : Type u_3}
  (step : NumStability.CoordinateFractionalStep Direction Cell Value)
  (steps : List (NumStability.CoordinateFractionalStep Direction Cell Value))
  (initial final : NumStability.FiniteVolumeCellState Cell Value)
  (tailTrace : List (NumStability.FiniteVolumeCellState Cell Value)),
  NumStability.CoordinateSweepExecution steps (step.advance initial) final tailTrace →
    NumStability.CoordinateSweepExecution (List.cons step steps) initial final (List.cons initial tailTrace)
```

Fully explicit type:

```lean
∀ {Direction : Type u_1} {Cell : Type u_2} {Value : Type u_3}
  (step : NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value)
  (steps : List.{max (max u_3 u_2) u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value))
  (initial final : NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value)
  (tailTrace : List.{max u_3 u_2} (NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value))
  (tailExecution :
    @NumStability.CoordinateSweepExecution.{u_1, u_2, u_3} Direction Cell Value steps
      (@NumStability.CoordinateFractionalStep.advance.{u_1, u_2, u_3} Direction Cell Value step initial) final
      tailTrace),
  @NumStability.CoordinateSweepExecution.{u_1, u_2, u_3} Direction Cell Value
    (@List.cons.{max (max u_1 u_2) u_3} (NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value)
      step steps)
    initial final
    (@List.cons.{max u_2 u_3} (NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value) initial tailTrace)
```

### D021: `NumStability.CoordinateSweepExecution.nil`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `fc401a129ffe659cf7b7c31be8dc289b9ca30aeda79152c4ac83dda0b5274313`

Type:

```lean
∀ {Direction : Type u_1} {Cell : Type u_2} {Value : Type u_3} (state : NumStability.FiniteVolumeCellState Cell Value),
  NumStability.CoordinateSweepExecution List.nil state state (List.cons state List.nil)
```

Fully explicit type:

```lean
∀ {Direction : Type u_1} {Cell : Type u_2} {Value : Type u_3}
  (state : NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value),
  @NumStability.CoordinateSweepExecution.{u_1, u_2, u_3} Direction Cell Value
    (@List.nil.{max (max u_1 u_2) u_3} (NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value))
    state state
    (@List.cons.{max u_2 u_3} (NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value) state
      (@List.nil.{max u_2 u_3} (NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value)))
```

### D022: `NumStability.OneDimensionalHighResolutionFiniteVolumeSolve.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `085241788c320cc17fb28ef904e62c10746c97608c992a97f9e1b0d084b8c0a6`

Type:

```lean
{Cell : Type u_1} →
  {Value : Type u_2} →
    (advanceCellAverages :
        Real → NumStability.FiniteVolumeCellState Cell Value → NumStability.FiniteVolumeCellState Cell Value) →
      (∀ (fraction : Real) (value : Value), Eq (advanceCellAverages fraction fun x => value) fun x => value) →
        NumStability.OneDimensionalHighResolutionFiniteVolumeSolve Cell Value
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Value : Type u_2} →
    (advanceCellAverages :
        Real →
          NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value →
            NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value) →
      (preserves_constant_states :
          ∀ (fraction : Real) (value : Value),
            @Eq.{max (u_1 + 1) (u_2 + 1)} (NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value)
              (advanceCellAverages fraction fun (x : Cell) => value) fun (x : Cell) => value) →
        NumStability.OneDimensionalHighResolutionFiniteVolumeSolve.{u_1, u_2} Cell Value
```

### D023: `NumStability.CoordinateDirectionFamily.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `e020619f9e88ba2a7c9914fb8699d50cf75fa04682d0da23523df2f50ded9e29`

Type:

```lean
{Direction : Type u_1} →
  (directions : List Direction) →
    Ne directions List.nil →
      directions.Nodup →
        (∀ (direction : Direction), List.instMembership.mem directions direction) →
          NumStability.CoordinateDirectionFamily Direction
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  (directions : List.{u_1} Direction) →
    (directions_nonempty : @Ne.{u_1 + 1} (List.{u_1} Direction) directions (@List.nil.{u_1} Direction)) →
      (directions_nodup : @List.Nodup.{u_1} Direction directions) →
        (directions_exhaustive :
            ∀ (direction : Direction),
              @Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                directions direction) →
          NumStability.CoordinateDirectionFamily.{u_1} Direction
```

### D024: `NumStability.CoordinateFractionalStep.advance`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `9a421874f455add4c9484ef770785936ef4dcb6cb3705925ad51d9ab20b74407`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      NumStability.CoordinateFractionalStep Direction Cell Value →
        NumStability.FiniteVolumeCellState Cell Value → NumStability.FiniteVolumeCellState Cell Value
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {Value : Type u_3} →
      (step : NumStability.CoordinateFractionalStep.{u_1, u_2, u_3} Direction Cell Value) →
        (state : NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value) →
          NumStability.FiniteVolumeCellState.{u_2, u_3} Cell Value
```

Definition body (one-level semantic boundary):

```lean
fun {Direction} {Cell} {Value} step state => step.oneDimensionalSolve.advanceCellAverages step.timeFraction state
```

### D025: `NumStability.CoordinateGridGeometry`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `e9f12241f20f7d26221b0177b4f7324a41c05b68f5dbd5a6680ce475c507f10e`

Type:

```lean
Type u → Type u → Type u
```

Fully explicit type:

```lean
(Point Direction : Type u) → Type u
```

### D026: `NumStability.CoordinateHighResolutionMethod.positive_timeFraction`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `53e0e52e62e7dfbd5349574569bfbcb7861aa0cdc84e2dff1c053432c4302342`

Type:

```lean
∀ {Direction : Type u_1} {Cell : Type u_2} {Value : Type u_3}
  (self : NumStability.CoordinateHighResolutionMethod Direction Cell Value) (direction : Direction),
  Real.instLT.lt 0 (self.timeFraction direction)
```

Fully explicit type:

```lean
∀ {Direction : Type u_1} {Cell : Type u_2} {Value : Type u_3}
  (self : NumStability.CoordinateHighResolutionMethod.{u_1, u_2, u_3} Direction Cell Value) (direction : Direction),
  @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
    (@NumStability.CoordinateHighResolutionMethod.timeFraction.{u_1, u_2, u_3} Direction Cell Value self direction)
```

### D027: `NumStability.CoordinateHighResolutionMethod.timeFraction_le_one`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `0ac18fc47dbbcf1dda1ea72db2f9b0ef7bd31b00ad8e574049c362859fccba88`

Type:

```lean
∀ {Direction : Type u_1} {Cell : Type u_2} {Value : Type u_3}
  (self : NumStability.CoordinateHighResolutionMethod Direction Cell Value) (direction : Direction),
  Real.instLE.le (self.timeFraction direction) 1
```

Fully explicit type:

```lean
∀ {Direction : Type u_1} {Cell : Type u_2} {Value : Type u_3}
  (self : NumStability.CoordinateHighResolutionMethod.{u_1, u_2, u_3} Direction Cell Value) (direction : Direction),
  @LE.le.{0} Real Real.instLE
    (@NumStability.CoordinateHighResolutionMethod.timeFraction.{u_1, u_2, u_3} Direction Cell Value self direction)
    (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
```

### D028: `NumStability.FiniteVolumeCellPartition`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `541ff72eb500f2f48d4d8c6c3232a3e3b60e8177b3d5bbbddde2e2791cebff03`

Type:

```lean
Type u_1 → (Point : Type u_2) → [MeasurableSpace Point] → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Cell : Type u_1) → (Point : Type u_2) → [MeasurableSpace.{u_2} Point] → Type (max u_1 u_2)
```

### D029: `NumStability.FiniteVolumeCellPartition.cellRegion`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D030: `NumStability.coordinateCellBox`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `d8103f5e7a9e9649135f7a3579281a7af2e409ccabf210b909d1eed865a4f4a5`

Type:

```lean
{Point Direction : Type u} →
  NumStability.CoordinateGridGeometry Point Direction →
    List Direction → (Direction → Real) → (Direction → Real) → Set Point
```

Fully explicit type:

```lean
{Point Direction : Type u} →
  (geometry : NumStability.CoordinateGridGeometry.{u} Point Direction) →
    (directions : List.{u} Direction) → (lowerFace upperFace : Direction → Real) → Set.{u} Point
```

Definition body (one-level semantic boundary):

```lean
fun {Point Direction} geometry directions lowerFace upperFace =>
  setOf fun point =>
    ∀ (direction : Direction),
      List.instMembership.mem directions direction →
        And (Real.instLE.le (lowerFace direction) (EquivLike.toFunLike.coe geometry.coordinates point direction))
          (Real.instLT.lt (EquivLike.toFunLike.coe geometry.coordinates point direction) (upperFace direction))
```

### D031: `NumStability.CoordinateGridGeometry.coordinates`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `de2f3f18f96b865e69cc75be4d2efb37cf7c5c9ae8859d17a6860e8689ba81be`

Type:

```lean
{Point Direction : Type u} → NumStability.CoordinateGridGeometry Point Direction → Equiv Point (Direction → Real)
```

Fully explicit type:

```lean
{Point Direction : Type u} →
  NumStability.CoordinateGridGeometry.{u} Point Direction → Equiv.{u + 1, u + 1} Point (Direction → Real)
```

Definition body (one-level semantic boundary):

```lean
fun {Point Direction} x =>
  NumStability.CoordinateGridGeometry.coordinates.match_1 (fun x => Equiv Point (Direction → Real)) x
    (fun physicalPointSpace => Equiv.cast physicalPointSpace) fun logicalCoordinates => logicalCoordinates
```

### D032: `NumStability.CoordinateGridGeometry.logicallyRectangular`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `fef26fc3ade1e19867bbb1efd17b7d5f72884a4963a8807c0c1d47a4b5c22b68`

Type:

```lean
{Point Direction : Type u} → Equiv Point (Direction → Real) → NumStability.CoordinateGridGeometry Point Direction
```

Fully explicit type:

```lean
{Point Direction : Type u} →
  (logicalCoordinates : Equiv.{u + 1, u + 1} Point (Direction → Real)) →
    NumStability.CoordinateGridGeometry.{u} Point Direction
```

### D033: `NumStability.CoordinateGridGeometry.rectangular`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `85a9f9ec47360d728a6520f694ea81598f2c1c66bd64824cf889fced416b112c`

Type:

```lean
{Point Direction : Type u} → Eq Point (Direction → Real) → NumStability.CoordinateGridGeometry Point Direction
```

Fully explicit type:

```lean
{Point Direction : Type u} →
  (physicalPointSpace : @Eq.{u + 2} (Type u) Point (Direction → Real)) →
    NumStability.CoordinateGridGeometry.{u} Point Direction
```

### D034: `NumStability.FiniteVolumeCellPartition.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `constructor`
- Distance from target type: `4`
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

### D035: `NumStability.OneDimensionalHighResolutionFiniteVolumeSolve.advanceCellAverages`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `f9d27e4f5a988586c6bf49ac3452b9d0add4d5d93547a51f7f6c257836ed6e22`

Type:

```lean
{Cell : Type u_1} →
  {Value : Type u_2} →
    NumStability.OneDimensionalHighResolutionFiniteVolumeSolve Cell Value →
      Real → NumStability.FiniteVolumeCellState Cell Value → NumStability.FiniteVolumeCellState Cell Value
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Value : Type u_2} →
    (self : NumStability.OneDimensionalHighResolutionFiniteVolumeSolve.{u_1, u_2} Cell Value) →
      Real →
        NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value →
          NumStability.FiniteVolumeCellState.{u_1, u_2} Cell Value
```

Definition body (one-level semantic boundary):

```lean
fun Cell Value self => self.1
```

### D036: `NumStability.CoordinateGridGeometry.coordinates.match_1`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `4ecbc38346184dd0049d00514e5979565fa0ac99600019e97ad235c51dc2b3f3`

Type:

```lean
{Point Direction : Type u_1} →
  (motive : NumStability.CoordinateGridGeometry Point Direction → Sort u_2) →
    (x : NumStability.CoordinateGridGeometry Point Direction) →
      ((physicalPointSpace : Eq Point (Direction → Real)) →
          motive (NumStability.CoordinateGridGeometry.rectangular physicalPointSpace)) →
        ((logicalCoordinates : Equiv Point (Direction → Real)) →
            motive (NumStability.CoordinateGridGeometry.logicallyRectangular logicalCoordinates)) →
          motive x
```

Fully explicit type:

```lean
{Point Direction : Type u_1} →
  (motive : NumStability.CoordinateGridGeometry.{u_1} Point Direction → Sort u_2) →
    (x : NumStability.CoordinateGridGeometry.{u_1} Point Direction) →
      (h_1 :
          (physicalPointSpace : @Eq.{u_1 + 2} (Type u_1) Point (Direction → Real)) →
            motive (@NumStability.CoordinateGridGeometry.rectangular.{u_1} Point Direction physicalPointSpace)) →
        (h_2 :
            (logicalCoordinates : Equiv.{u_1 + 1, u_1 + 1} Point (Direction → Real)) →
              motive
                (@NumStability.CoordinateGridGeometry.logicallyRectangular.{u_1} Point Direction logicalCoordinates)) →
          motive x
```

Definition body (one-level semantic boundary):

```lean
fun {Point Direction} motive x h_1 h_2 =>
  NumStability.CoordinateGridGeometry.casesOn x (fun physicalPointSpace => h_1 physicalPointSpace)
    fun logicalCoordinates => h_2 logicalCoordinates
```

### D037: `NumStability.CoordinateGridGeometry.casesOn`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `a9a7103b0f63d75b60224b7d64de2c3b47849833febf02bffaedeb41361bd375`

Type:

```lean
{Point Direction : Type u} →
  {motive : NumStability.CoordinateGridGeometry Point Direction → Sort u_1} →
    (t : NumStability.CoordinateGridGeometry Point Direction) →
      ((physicalPointSpace : Eq Point (Direction → Real)) →
          motive (NumStability.CoordinateGridGeometry.rectangular physicalPointSpace)) →
        ((logicalCoordinates : Equiv Point (Direction → Real)) →
            motive (NumStability.CoordinateGridGeometry.logicallyRectangular logicalCoordinates)) →
          motive t
```

Fully explicit type:

```lean
{Point Direction : Type u} →
  {motive : (t : NumStability.CoordinateGridGeometry.{u} Point Direction) → Sort u_1} →
    (t : NumStability.CoordinateGridGeometry.{u} Point Direction) →
      (rectangular :
          (physicalPointSpace : @Eq.{u + 2} (Type u) Point (Direction → Real)) →
            motive (@NumStability.CoordinateGridGeometry.rectangular.{u} Point Direction physicalPointSpace)) →
        (logicallyRectangular :
            (logicalCoordinates : Equiv.{u + 1, u + 1} Point (Direction → Real)) →
              motive
                (@NumStability.CoordinateGridGeometry.logicallyRectangular.{u} Point Direction logicalCoordinates)) →
          motive t
```

Definition body (one-level semantic boundary):

```lean
fun {Point Direction} {motive} t rectangular logicallyRectangular =>
  NumStability.CoordinateGridGeometry.rec (fun physicalPointSpace => rectangular physicalPointSpace)
    (fun logicalCoordinates => logicallyRectangular logicalCoordinates) t
```

### D038: `NumStability.CoordinateGridGeometry.rec`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `recursor`
- Distance from target type: `7`
- Semantic SHA-256: `61766bb9cc1474b46a1403090bd0c2ed831b1e9edbdf96c1927fae12dd3781b8`

Type:

```lean
{Point Direction : Type u} →
  {motive : NumStability.CoordinateGridGeometry Point Direction → Sort u_1} →
    ((physicalPointSpace : Eq Point (Direction → Real)) →
        motive (NumStability.CoordinateGridGeometry.rectangular physicalPointSpace)) →
      ((logicalCoordinates : Equiv Point (Direction → Real)) →
          motive (NumStability.CoordinateGridGeometry.logicallyRectangular logicalCoordinates)) →
        (t : NumStability.CoordinateGridGeometry Point Direction) → motive t
```

Fully explicit type:

```lean
{Point Direction : Type u} →
  {motive : (t : NumStability.CoordinateGridGeometry.{u} Point Direction) → Sort u_1} →
    (rectangular :
        (physicalPointSpace : @Eq.{u + 2} (Type u) Point (Direction → Real)) →
          motive (@NumStability.CoordinateGridGeometry.rectangular.{u} Point Direction physicalPointSpace)) →
      (logicallyRectangular :
          (logicalCoordinates : Equiv.{u + 1, u + 1} Point (Direction → Real)) →
            motive (@NumStability.CoordinateGridGeometry.logicallyRectangular.{u} Point Direction logicalCoordinates)) →
        (t : NumStability.CoordinateGridGeometry.{u} Point Direction) → motive t
```

### D039: `And`

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

### D040: `Eq`

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

### D041: `Exists`

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

### D042: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HAdd.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D043: `List`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ec06a72bb009eecaedd9dbf6a3349bbea0bbc480e0a21179f4e21b3e219b952d`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

### D044: `List.instMembership`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `51cf805fcbf00d4a64b4e72cb246d510950ce4cda54bc6c8a74110b6dc8a6a95`

Type:

```lean
{α : Type u} → Membership α (List α)
```

Fully explicit type:

```lean
{α : Type u} → Membership.{u, u} α (List.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { mem := fun l a => List.Mem a l }
```

### D045: `List.length`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `09af197d524608e712a6237d011ad9a2925b393e82bf17e1a554a0d325a138a8`

Type:

```lean
{α : Type u_1} → List α → Nat
```

Fully explicit type:

```lean
{α : Type u_1} → List.{u_1} α → Nat
```

Definition body (one-level semantic boundary):

```lean
fun {α} x =>
  List.brecOn x fun x f =>
    instDecidableEqList.match_1 (fun x => List.below x → Nat) x (fun _ x => 0) (fun head as x => instHAdd.hAdd x.1 1) f
```

### D046: `List.nil`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `6fc023f8c03f1dc78130598a9c55a666564e22fa908127753ee95d45e602196f`

Type:

```lean
{α : Type u} → List α
```

Fully explicit type:

```lean
{α : Type u} → List.{u} α
```

### D047: `MeasurableSpace`

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

### D048: `Membership.mem`

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

### D049: `Nat`

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

### D050: `Ne`

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

### D051: `OfNat.ofNat`

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

### D052: `Real`

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

### D053: `instAddNat`

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

### D054: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Add.{u_1} α] → HAdd.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D055: `instOfNatNat`

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

### D056: `List.map`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `509306b13208ac7c4830c43f93dc873d045ae0ae6b1984beea3ee3ecf89cb205`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → (α → β) → List α → List β
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → (f : α → β) → (l : List.{u_1} α) → List.{u_2} β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f x =>
  List.brecOn x fun x f_1 =>
    instDecidableEqList.match_1 (fun x => List.below x → List β) x (fun _ x => List.nil)
      (fun a as x => List.cons (f a) x.1) f_1
```

### D057: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `54a32f2661f788eb2b860006c4d1e8031e126febafe1c8d03ce50529b773dc48`

Type:

```lean
{α : Type u} → [self : LE α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u} → [self : LE.{u} α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LE α] => self.1
```

### D058: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D059: `List.cons`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `d4f0bc0954b11abbe9f8e60dd8762e7797f488b1975b155440101828c4c1ea14`

Type:

```lean
{α : Type u} → α → List α → List α
```

Fully explicit type:

```lean
{α : Type u} → (head : α) → (tail : List.{u} α) → List.{u} α
```

### D060: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D061: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `144d825fc543455e17044e843560e0415f8e4e9da60afb52f34edb809b7c34d3`

Type:

```lean
LE Real
```

Fully explicit type:

```lean
LE.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ le := Real.le✝ }
```

### D062: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D063: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D064: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D065: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D066: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D067: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D068: `Equiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Equiv.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `d7f2b85e220b17e17ce92ad10d5015da5d4751cd914568e619a1f288341c64e3`

Type:

```lean
Sort u_1 → Sort u_2 → Sort (max (max 1 u_1) u_2)
```

Fully explicit type:

```lean
(α : Sort u_1) → (β : Sort u_2) → Sort (max (max 1 u_1) u_2)
```

### D069: `Equiv.instEquivLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Equiv.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `c53ba65c6bd0e248eb34b05badc813675bd3ab80452ae652c8efe8beb0652559`

Type:

```lean
{α : Sort u} → {β : Sort v} → EquivLike (Equiv α β) α β
```

Fully explicit type:

```lean
{α : Sort u} → {β : Sort v} → EquivLike.{max (max 1 v) u, u, v} (Equiv.{u, v} α β) α β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} => { coe := Equiv.toFun, inv := Equiv.invFun, left_inv := ⋯, right_inv := ⋯, coe_injective' := ⋯ }
```

### D070: `EquivLike.toFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Equiv`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `0f60978070e976ff8040a5b974a5b08a27d74758a8f4361a6276a17c12a1d96a`

Type:

```lean
{E : Sort u_1} → {α : Sort u_3} → {β : Sort u_4} → [EquivLike E α β] → FunLike E α β
```

Fully explicit type:

```lean
{E : Sort u_1} → {α : Sort u_3} → {β : Sort u_4} → [EquivLike.{u_1, u_3, u_4} E α β] → FunLike.{u_1, u_3, u_4} E α β
```

Definition body (one-level semantic boundary):

```lean
fun {E} {α} {β} [inst : EquivLike E α β] => { coe := inst.coe, coe_injective' := ⋯ }
```

### D071: `List.Nodup`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `84dc3885594cf3709225a97e2835a2e9d6cb390608200c825d5f41a3590c6bb8`

Type:

```lean
{α : Type u} → List α → Prop
```

Fully explicit type:

```lean
{α : Type u} → List.{u} α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} => List.Pairwise fun x1 x2 => Ne x1 x2
```

### D072: `setOf`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `cee4433aebd78c308ec85f62ccd30489c00ec9cc23a98f4d2139c17f840f4988`

Type:

```lean
{α : Type u} → (α → Prop) → Set α
```

Fully explicit type:

```lean
{α : Type u} → (p : α → Prop) → Set.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} p => p
```

### D073: `CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D074: `CompleteBooleanAlgebra.toCompleteDistribLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D075: `CompleteBooleanAlgebra.toCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D076: `CompleteDistribLattice.toFrame`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D077: `CompleteLattice.instOmegaCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D078: `Disjoint`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Disjoint`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D079: `Equiv.cast`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Equiv.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `fd10f6109ad119e02737335618afd7d160774d5c10a87c8c15579abe6774ef70`

Type:

```lean
{α β : Sort u_1} → Eq α β → Equiv α β
```

Fully explicit type:

```lean
{α β : Sort u_1} → (h : @Eq.{u_1 + 1} (Sort u_1) α β) → Equiv.{u_1, u_1} α β
```

Definition body (one-level semantic boundary):

```lean
fun {α β} h => { toFun := cast h, invFun := cast ⋯, left_inv := ⋯, right_inv := ⋯ }
```

### D080: `HeytingAlgebra.toOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Heyting.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D081: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D082: `MeasurableSet`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D083: `Nonempty`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `37c79de378d44cb9dc334502b161bb140da0544579086aded2cf83ff99c462c7`

Type:

```lean
Sort u → Prop
```

Fully explicit type:

```lean
(α : Sort u) → Prop
```

### D084: `OmegaCompletePartialOrder.toPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D085: `Order.Frame.toHeytingAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D086: `Set.instCompleteAtomicBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.BooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D087: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
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
