# Declaration dossier for LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908

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

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting` imports: `Mathlib.Data.List.Basic`, `Mathlib.Data.Real.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.CoordinateFiniteVolumeGrid`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a6ea44beee9561205413cd28ca1f5e9a195101bbbb3e7c74557b8ebcae485ff6`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6732969176c0783b0c66707dc1fada9282050c1245060bbc11c8b8da7449935c`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `01e42124fe81ea0b74d69ac811b65980d4c5930bf55e0da0ac12b26217f62c2f`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `062957174749876fc85a02f53a01621dab8e67cc76430f9c18fbffcf1fbdb82d`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e1867c3f3acbf0388c5c8dcf58531e920a1d76fb9326807c1c99430b359eeba4`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `b4a57f16fe63eebf24b0820e8ccfd598044b01e37a796514ea30dcc5cdd9a095`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `5c1103ec07c51262775b8f7a36f3408463c2544de37ec1909a4fe54d66c4f123`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e18d2fa34be7acee651b052f5e18441699dd3c0be56b5e8de1644232050d2e5b`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `73a5e129343ee41c67499d5c8589d4bb91c0270e98b3d501ae604a8ce860c929`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `53cdbe9fe7d1e59f7b10c230f4d53034ca7f079a273d072fab720d29298b37a4`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `95d632c78412ce6e02caa9a166e9cdd290e96b1bc089f0b4e09eb2c152ca2c3b`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `4b16c9a7974607d34cad2e772c6c5c5f2f54b608ba56b527eb900228c1e82a8e`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `58aad802a7da28004aabd5731f3e6a8dcb46d509d526f042215534ec578252c9`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `088ca2f8cea37db266761033bfc1dbdeda9ab646c464d651eb8eaba60c9ede83`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `aeb9ac446cf17ee44972cde66d79659d1ff25b0a33538144c34c6a5a69f9f969`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `abe90b9361c561cc67f3cdc20f92df5b4ca7262d2141dd2dfb54b78efceb0641`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `19a31f68dbc2487cd681e0302d2751570b2fbb34ccb148ec7a830859487d89b1`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1e7aac510550c3b737fb5bc556bf4ec66ab2ef834ea5cc0d9daed033679e1497`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `c63345cd3d7fd9054f54a0f5fe5b861e21dc58f0ab33078ddbb1c75ac727cbd3`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `7f348ba1266d1cb899bc015ffcf658c3d42ab1b38b41a58dbbe810162b93b080`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `103e5f060d659070c3c09ea965e2a2259fca2e4aef01df1b11d9f17f80417e7c`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `3280fb409e3cbf9bcf6fa35b15c37254bd3361b38328ad76c2a3a50ffe3e450b`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `302d078275b1978743181e6e6e537ccf1a79222534b4b49e1579adab111ea533`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `62198e0d140d7c027b6f49d4b7f67b01f93e05db2681e88b4fa1cbe3a209ae22`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `1e60dd30a4779aa2df6ffae24c87a33ac5a5ee967a444aeb8a9b18fe4b9c4cd6`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `7346db5ba97e1f85931540d8796eeb5278a7d4bb0bec48b8fc6843ca748e43a3`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `5282b217299be14a4a910646c609c77098d56f7e823b3df66dfe64406d0f5697`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `643d6beb37c358dd676e40a0ed44bb8a1161a339bf1a86fade7e9a749db8accc`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `32dd6b17c69eb1ad645253a6f164e371ce8f60b4e07173cb0964fefc72bfff00`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `dd6fd2da853052586bc215d03693db785a5c41d4b167c68567e18f0c8e8b6712`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `87b9c38fbdeab821aa3848b09ddde8175e5b9cd7a12410371ccc174ebf823a21`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `a507dc61fe85562dc284ac858ce9c2e97eaedc832f1746e04b40ba6570af627e`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `3ca85bbdaef691c71f18144eecc968cb1b50d71ca1d21711cbc4aa0edc090d89`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `739bab2b22ae879c4f9ff0943c6641c3a50b089aa099d9b3ca55f7e3dbb2945b`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `eb25b75e07d0390f11706723a052f45b69c996f3d8320644047975bbe1c6f8ea`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `d5da2e1beae7fe172fc9a3bab3de2856b19aa5516b473067e54f1c2a2160fd45`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `a8e5764fdada28f330530bb7ed8745f396ea4b595f6e75a2d9b676018e566952`

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
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `recursor`
- Distance from target type: `7`
- Semantic SHA-256: `16ee16e88da866f79d07d7592f26adac53b57ebd6d5977e4058fe7beae363b91`

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

Hash-verified prior declaration review:

- Reuse SHA-256: `83c2b2835e2c70e9de4ed8287da69e8528b9c02a736e1ffa1218a9b88cccd8cf`
- Reviewed interpretation: Negation of equality of its two arguments.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `5afb464ea638155c9233a0ef270e582be38648a0592bc2de4c98dfefad487def`
- Reviewed interpretation: Assigns the natural-number literal n the natural number n itself.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `b3b0f9c22d43e1045ec44f03e430d6c65241d4a3e14515560a15d671a99ebc54`
- Reviewed interpretation: Projects the function supplied by a DFunLike instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D068: `Equiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Equiv.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `d7f2b85e220b17e17ce92ad10d5015da5d4751cd914568e619a1f288341c64e3`

Hash-verified prior declaration review:

- Reuse SHA-256: `97ea4d0d004fc5f012c3beae4446e9b5a7e902f06b5be1670b183b6e17065efd`
- Reviewed interpretation: The library type of equivalences between two types, used here for Matrix.of.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D069: `Equiv.instEquivLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Equiv.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `c53ba65c6bd0e248eb34b05badc813675bd3ab80452ae652c8efe8beb0652559`

Hash-verified prior declaration review:

- Reuse SHA-256: `55a81f67644efac84e1e7e0d4069a0daf8f3b902be4ce84a1c35868751ceda2a`
- Reviewed interpretation: Uses an equivalence's toFun and invFun as its forward and inverse functions.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D070: `EquivLike.toFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Equiv`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `0f60978070e976ff8040a5b974a5b08a27d74758a8f4361a6276a17c12a1d96a`

Hash-verified prior declaration review:

- Reuse SHA-256: `42d3e10a239813e571f56888491c04a9dc77de773b423c9c7c1c8e58c782ebc7`
- Reviewed interpretation: Retains the forward coercion of an EquivLike instance in a FunLike instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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
