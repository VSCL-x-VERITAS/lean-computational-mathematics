# Declaration dossier for LEV-CH01-DIMENSIONAL-SPLITTING

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_dimensionalSplitting_sourceContract :
    (∀ {Direction Cell E : Type*} [AddCommGroup E] [Module ℝ E]
      (grid : CoordinateFiniteVolumeGrid Direction Cell)
      (methods : Direction →
        HighResolutionCoordinateFiniteVolumeMethod Direction E)
      (directionOrder : List Direction)
      (hmethodDirection : ∀ direction,
        (methods direction).direction = direction)
      (horder : directionOrder.Perm grid.coordinateDirections),
      (grid.geometry = .rectangular ∨
          grid.geometry = .logicallyRectangular) ∧
        grid.coordinateDirections.Nodup ∧
        (∃ first ∈ grid.coordinateDirections,
          ∃ second ∈ grid.coordinateDirections, first ≠ second) ∧
        (∀ direction ∈ grid.coordinateDirections,
          direction ∈ directionOrder ∧
            (methods direction).direction = direction ∧
            0 < (methods direction).timeStepOverCellWidth) ∧
        (∀ direction cellAverages cell,
          coordinateFiniteVolumeAdvance grid (methods direction)
              cellAverages cell =
            cellAverages cell -
              (methods direction).timeStepOverCellWidth •
                ((methods direction).numericalFlux
                    (cellAverages cell)
                    (cellAverages
                      (grid.rightNeighbor
                        (methods direction).direction cell)) -
                  (methods direction).numericalFlux
                    (cellAverages
                      (grid.leftNeighbor
                        (methods direction).direction cell))
                    (cellAverages cell))) ∧
        (∀ direction state,
          coordinateFiniteVolumeAdvance grid (methods direction)
              (fun _ => state) = fun _ => state) ∧
        (∀ cellAverages,
          coordinateFiniteVolumeSweep grid methods directionOrder
              cellAverages =
            orderedOperatorSweep
              (directionOrder.map fun direction =>
                coordinateFiniteVolumeAdvance grid (methods direction))
              cellAverages)) ∧
    (let splitAdvance
```

## Elaborated target type

```lean
And
  (∀ {Direction : Type u_1} {Cell : Type u_2} {E : Type u_3} [inst : AddCommGroup E] [inst_1 : Module Real E]
    (grid : NumStability.CoordinateFiniteVolumeGrid Direction Cell)
    (methods : Direction → NumStability.HighResolutionCoordinateFiniteVolumeMethod Direction E)
    (directionOrder : List Direction),
    (∀ (direction : Direction), Eq (methods direction).direction direction) →
      directionOrder.Perm grid.coordinateDirections →
        And
          (Or (Eq grid.geometry NumStability.CoordinateGridGeometry.rectangular)
            (Eq grid.geometry NumStability.CoordinateGridGeometry.logicallyRectangular))
          (And grid.coordinateDirections.Nodup
            (And
              (Exists fun first =>
                And (List.instMembership.mem grid.coordinateDirections first)
                  (Exists fun second =>
                    And (List.instMembership.mem grid.coordinateDirections second) (Ne first second)))
              (And
                (∀ (direction : Direction),
                  List.instMembership.mem grid.coordinateDirections direction →
                    And (List.instMembership.mem directionOrder direction)
                      (And (Eq (methods direction).direction direction)
                        (Real.instLT.lt 0 (methods direction).timeStepOverCellWidth)))
                (And
                  (∀ (direction : Direction) (cellAverages : Cell → E) (cell : Cell),
                    Eq (NumStability.coordinateFiniteVolumeAdvance grid (methods direction) cellAverages cell)
                      (instHSub.hSub (cellAverages cell)
                        (instHSMul.hSMul (methods direction).timeStepOverCellWidth
                          (instHSub.hSub
                            ((methods direction).numericalFlux (cellAverages cell)
                              (cellAverages (grid.rightNeighbor (methods direction).direction cell)))
                            ((methods direction).numericalFlux
                              (cellAverages (grid.leftNeighbor (methods direction).direction cell))
                              (cellAverages cell))))))
                  (And
                    (∀ (direction : Direction) (state : E),
                      Eq (NumStability.coordinateFiniteVolumeAdvance grid (methods direction) fun x => state) fun x =>
                        state)
                    (∀ (cellAverages : Cell → E),
                      Eq (NumStability.coordinateFiniteVolumeSweep grid methods directionOrder cellAverages)
                        (NumStability.orderedOperatorSweep
                          (List.map
                            (fun direction => NumStability.coordinateFiniteVolumeAdvance grid (methods direction))
                            directionOrder)
                          cellAverages))))))))
  (have splitAdvance :=
    NumStability.coordinateFiniteVolumeSweep NumStability.leveque01CartesianGrid
      NumStability.leveque01CoordinateUpwindMethod (List.cons Bool.false (List.cons Bool.true List.nil));
  have diagonalReference := fun cellAverages cell =>
    cellAverages { fst := instHSub.hSub cell.fst 1, snd := instHSub.hSub cell.snd 1 };
  And (NumStability.SplitMatchesReferenceOn splitAdvance diagonalReference Set.univ)
    (NumStability.RequiresFullyMultidimensionalAt splitAdvance NumStability.leveque01CoupledReferenceAdvance fun cell =>
      instHMul.hMul cell.fst.cast cell.snd.cast))
```

## Fully explicit elaborated target type

```lean
And
  (∀ {Direction : Type u_1} {Cell : Type u_2} {E : Type u_3} [inst : AddCommGroup.{u_3} E]
    [inst_1 : @Module.{0, u_3} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_3} E inst)]
    (grid : NumStability.CoordinateFiniteVolumeGrid.{u_1, u_2} Direction Cell)
    (methods : Direction → NumStability.HighResolutionCoordinateFiniteVolumeMethod.{u_1, u_3} Direction E)
    (directionOrder : List.{u_1} Direction)
    (hmethodDirection :
      ∀ (direction : Direction),
        @Eq.{u_1 + 1} Direction
          (@NumStability.HighResolutionCoordinateFiniteVolumeMethod.direction.{u_1, u_3} Direction E
            (methods direction))
          direction)
    (horder :
      @List.Perm.{u_1} Direction directionOrder
        (@NumStability.CoordinateFiniteVolumeGrid.coordinateDirections.{u_1, u_2} Direction Cell grid)),
    And
      (Or
        (@Eq.{1} NumStability.CoordinateGridGeometry
          (@NumStability.CoordinateFiniteVolumeGrid.geometry.{u_1, u_2} Direction Cell grid)
          NumStability.CoordinateGridGeometry.rectangular)
        (@Eq.{1} NumStability.CoordinateGridGeometry
          (@NumStability.CoordinateFiniteVolumeGrid.geometry.{u_1, u_2} Direction Cell grid)
          NumStability.CoordinateGridGeometry.logicallyRectangular))
      (And
        (@List.Nodup.{u_1} Direction
          (@NumStability.CoordinateFiniteVolumeGrid.coordinateDirections.{u_1, u_2} Direction Cell grid))
        (And
          (@Exists.{u_1 + 1} Direction fun (first : Direction) =>
            And
              (@Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                (@NumStability.CoordinateFiniteVolumeGrid.coordinateDirections.{u_1, u_2} Direction Cell grid) first)
              (@Exists.{u_1 + 1} Direction fun (second : Direction) =>
                And
                  (@Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                    (@NumStability.CoordinateFiniteVolumeGrid.coordinateDirections.{u_1, u_2} Direction Cell grid)
                    second)
                  (@Ne.{u_1 + 1} Direction first second)))
          (And
            (∀ (direction : Direction),
              @Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                  (@NumStability.CoordinateFiniteVolumeGrid.coordinateDirections.{u_1, u_2} Direction Cell grid)
                  direction →
                And
                  (@Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                    directionOrder direction)
                  (And
                    (@Eq.{u_1 + 1} Direction
                      (@NumStability.HighResolutionCoordinateFiniteVolumeMethod.direction.{u_1, u_3} Direction E
                        (methods direction))
                      direction)
                    (@LT.lt.{0} Real Real.instLT
                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                      (@NumStability.HighResolutionCoordinateFiniteVolumeMethod.timeStepOverCellWidth.{u_1, u_3}
                        Direction E (methods direction)))))
            (And
              (∀ (direction : Direction) (cellAverages : Cell → E) (cell : Cell),
                @Eq.{u_3 + 1} E
                  (@NumStability.coordinateFiniteVolumeAdvance.{u_1, u_2, u_3} Direction Cell E inst inst_1 grid
                    (methods direction) cellAverages cell)
                  (@HSub.hSub.{u_3, u_3, u_3} E E E
                    (@instHSub.{u_3} E
                      (@SubNegMonoid.toSub.{u_3} E
                        (@AddGroup.toSubNegMonoid.{u_3} E (@AddCommGroup.toAddGroup.{u_3} E inst))))
                    (cellAverages cell)
                    (@HSMul.hSMul.{0, u_3, u_3} Real E E
                      (@instHSMul.{0, u_3} Real E
                        (@SMulZeroClass.toSMul.{0, u_3} Real E
                          (@AddZero.toZero.{u_3} E
                            (@AddZeroClass.toAddZero.{u_3} E
                              (@AddMonoid.toAddZeroClass.{u_3} E
                                (@SubNegMonoid.toAddMonoid.{u_3} E
                                  (@AddGroup.toSubNegMonoid.{u_3} E (@AddCommGroup.toAddGroup.{u_3} E inst))))))
                          (@DistribSMul.toSMulZeroClass.{0, u_3} Real E
                            (@AddMonoid.toAddZeroClass.{u_3} E
                              (@SubNegMonoid.toAddMonoid.{u_3} E
                                (@AddGroup.toSubNegMonoid.{u_3} E (@AddCommGroup.toAddGroup.{u_3} E inst))))
                            (@DistribMulAction.toDistribSMul.{0, u_3} Real E Real.instMonoid
                              (@SubNegMonoid.toAddMonoid.{u_3} E
                                (@AddGroup.toSubNegMonoid.{u_3} E (@AddCommGroup.toAddGroup.{u_3} E inst)))
                              (@Module.toDistribMulAction.{0, u_3} Real E Real.semiring
                                (@AddCommGroup.toAddCommMonoid.{u_3} E inst) inst_1)))))
                      (@NumStability.HighResolutionCoordinateFiniteVolumeMethod.timeStepOverCellWidth.{u_1, u_3}
                        Direction E (methods direction))
                      (@HSub.hSub.{u_3, u_3, u_3} E E E
                        (@instHSub.{u_3} E
                          (@SubNegMonoid.toSub.{u_3} E
                            (@AddGroup.toSubNegMonoid.{u_3} E (@AddCommGroup.toAddGroup.{u_3} E inst))))
                        (@NumStability.HighResolutionCoordinateFiniteVolumeMethod.numericalFlux.{u_1, u_3} Direction E
                          (methods direction) (cellAverages cell)
                          (cellAverages
                            (@NumStability.CoordinateFiniteVolumeGrid.rightNeighbor.{u_1, u_2} Direction Cell grid
                              (@NumStability.HighResolutionCoordinateFiniteVolumeMethod.direction.{u_1, u_3} Direction E
                                (methods direction))
                              cell)))
                        (@NumStability.HighResolutionCoordinateFiniteVolumeMethod.numericalFlux.{u_1, u_3} Direction E
                          (methods direction)
                          (cellAverages
                            (@NumStability.CoordinateFiniteVolumeGrid.leftNeighbor.{u_1, u_2} Direction Cell grid
                              (@NumStability.HighResolutionCoordinateFiniteVolumeMethod.direction.{u_1, u_3} Direction E
                                (methods direction))
                              cell))
                          (cellAverages cell))))))
              (And
                (∀ (direction : Direction) (state : E),
                  @Eq.{max (u_2 + 1) (u_3 + 1)} ((cell : Cell) → E)
                    (@NumStability.coordinateFiniteVolumeAdvance.{u_1, u_2, u_3} Direction Cell E inst inst_1 grid
                      (methods direction) fun (x : Cell) => state)
                    fun (x : Cell) => state)
                (∀ (cellAverages : Cell → E),
                  @Eq.{max (u_2 + 1) (u_3 + 1)} (Cell → E)
                    (@NumStability.coordinateFiniteVolumeSweep.{u_1, u_2, u_3} Direction Cell E inst inst_1 grid methods
                      directionOrder cellAverages)
                    (@NumStability.orderedOperatorSweep.{max u_3 u_2} (Cell → E)
                      (@List.map.{u_1, max u_3 u_2} Direction ((Cell → E) → Cell → E)
                        (fun (direction : Direction) =>
                          @NumStability.coordinateFiniteVolumeAdvance.{u_1, u_2, u_3} Direction Cell E inst inst_1 grid
                            (methods direction))
                        directionOrder)
                      cellAverages))))))))
  (have splitAdvance : (cellAverages : Prod.{0, 0} Int Int → Real) → Prod.{0, 0} Int Int → Real :=
    @NumStability.coordinateFiniteVolumeSweep.{0, 0, 0} Bool (Prod.{0, 0} Int Int) Real Real.instAddCommGroup
      (@Semiring.toModule.{0} Real Real.semiring) NumStability.leveque01CartesianGrid
      NumStability.leveque01CoordinateUpwindMethod
      (@List.cons.{0} Bool Bool.false (@List.cons.{0} Bool Bool.true (@List.nil.{0} Bool)));
  have diagonalReference : (cellAverages : Prod.{0, 0} Int Int → Real) → (cell : Prod.{0, 0} Int Int) → Real :=
    fun (cellAverages : Prod.{0, 0} Int Int → Real) (cell : Prod.{0, 0} Int Int) =>
    cellAverages
      (@Prod.mk.{0, 0} Int Int
        (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.fst.{0, 0} Int Int cell)
          (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
        (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.snd.{0, 0} Int Int cell)
          (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))));
  And
    (@NumStability.SplitMatchesReferenceOn.{0} (Prod.{0, 0} Int Int → Real) splitAdvance diagonalReference
      (@Set.univ.{0} (Prod.{0, 0} Int Int → Real)))
    (@NumStability.RequiresFullyMultidimensionalAt.{0} (Prod.{0, 0} Int Int → Real) splitAdvance
      NumStability.leveque01CoupledReferenceAdvance fun (cell : Prod.{0, 0} Int Int) =>
      @HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
        (@Int.cast.{0} Real Real.instIntCast (@Prod.fst.{0, 0} Int Int cell))
        (@Int.cast.{0} Real Real.instIntCast (@Prod.snd.{0, 0} Int Int cell))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting` imports: `Mathlib.Data.List.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.Algebra.Module.Basic`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.CoordinateFiniteVolumeGrid`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `e0d3a64e031453ef560ebd39cb2ff7a148a80e6f00035235e8aeeaf53c0bfb12`

Type:

```lean
Type u_1 → Type u_2 → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Direction : Type u_1) → (Cell : Type u_2) → Type (max u_1 u_2)
```

### D002: `NumStability.CoordinateFiniteVolumeGrid.coordinateDirections`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e3af1e932972493f24b49e7b8f40583be4d21d1706ee49a78930788b4f0ff144`

Type:

```lean
{Direction : Type u_1} → {Cell : Type u_2} → NumStability.CoordinateFiniteVolumeGrid Direction Cell → List Direction
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} → (self : NumStability.CoordinateFiniteVolumeGrid.{u_1, u_2} Direction Cell) → List.{u_1} Direction
```

Definition body (one-level semantic boundary):

```lean
fun Direction Cell self => self.2
```

### D003: `NumStability.CoordinateFiniteVolumeGrid.geometry`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f7a0a412c3f9316bac5e5b811bb2c13a844d9774f5b4f1e1b3b5f76426c3dabf`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} → NumStability.CoordinateFiniteVolumeGrid Direction Cell → NumStability.CoordinateGridGeometry
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    (self : NumStability.CoordinateFiniteVolumeGrid.{u_1, u_2} Direction Cell) → NumStability.CoordinateGridGeometry
```

Definition body (one-level semantic boundary):

```lean
fun Direction Cell self => self.1
```

### D004: `NumStability.CoordinateFiniteVolumeGrid.leftNeighbor`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c30f1460091f9723ad59a61add8fd1b78f6d4035ae9acbfcfcf1c294e79dc874`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} → NumStability.CoordinateFiniteVolumeGrid Direction Cell → Direction → Cell → Cell
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    (self : NumStability.CoordinateFiniteVolumeGrid.{u_1, u_2} Direction Cell) → Direction → Cell → Cell
```

Definition body (one-level semantic boundary):

```lean
fun Direction Cell self => self.5
```

### D005: `NumStability.CoordinateFiniteVolumeGrid.rightNeighbor`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cbb69c0bd863581991b42ace34660e08aa17a28f82ab3f26e278570bf23fa7ff`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} → NumStability.CoordinateFiniteVolumeGrid Direction Cell → Direction → Cell → Cell
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    (self : NumStability.CoordinateFiniteVolumeGrid.{u_1, u_2} Direction Cell) → Direction → Cell → Cell
```

Definition body (one-level semantic boundary):

```lean
fun Direction Cell self => self.6
```

### D006: `NumStability.CoordinateGridGeometry`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `6709762b34247eec95815b5f08998c20055ae988ea9e0db192ae2e92b1a3eea4`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D007: `NumStability.CoordinateGridGeometry.logicallyRectangular`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `74b7ead516753662ffb7aeb22333911ab1f806bc120cfa8589dce8e7460164b4`

Type:

```lean
NumStability.CoordinateGridGeometry
```

Fully explicit type:

```lean
NumStability.CoordinateGridGeometry
```

### D008: `NumStability.CoordinateGridGeometry.rectangular`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `c905510d138a03e17680947789aea7a4b77e7311c26a14acbda1668fad850d12`

Type:

```lean
NumStability.CoordinateGridGeometry
```

Fully explicit type:

```lean
NumStability.CoordinateGridGeometry
```

### D009: `NumStability.HighResolutionCoordinateFiniteVolumeMethod`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `1b1e693c46a5ff259ccb133ab2f578addc7e2fa19ea74bd92411498a12d2c21c`

Type:

```lean
Type u_1 → Type u_2 → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Direction : Type u_1) → (E : Type u_2) → Type (max u_1 u_2)
```

### D010: `NumStability.HighResolutionCoordinateFiniteVolumeMethod.direction`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c4273445ce10e6ab9005872dbfb0de80d57027e2bacc816ce52675a76f7e6575`

Type:

```lean
{Direction : Type u_1} →
  {E : Type u_2} → NumStability.HighResolutionCoordinateFiniteVolumeMethod Direction E → Direction
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {E : Type u_2} → (self : NumStability.HighResolutionCoordinateFiniteVolumeMethod.{u_1, u_2} Direction E) → Direction
```

Definition body (one-level semantic boundary):

```lean
fun Direction E self => self.1
```

### D011: `NumStability.HighResolutionCoordinateFiniteVolumeMethod.numericalFlux`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `88a819028e75f1eeed96d516885a6aba5c2903a3c0e15a4e6150007c062109c2`

Type:

```lean
{Direction : Type u_1} →
  {E : Type u_2} → NumStability.HighResolutionCoordinateFiniteVolumeMethod Direction E → E → E → E
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {E : Type u_2} → (self : NumStability.HighResolutionCoordinateFiniteVolumeMethod.{u_1, u_2} Direction E) → E → E → E
```

Definition body (one-level semantic boundary):

```lean
fun Direction E self => self.5
```

### D012: `NumStability.HighResolutionCoordinateFiniteVolumeMethod.timeStepOverCellWidth`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ea91d440020f83a1f958ad02c9bca6921aa33a13bb65a06ab29b1feceea30348`

Type:

```lean
{Direction : Type u_1} → {E : Type u_2} → NumStability.HighResolutionCoordinateFiniteVolumeMethod Direction E → Real
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {E : Type u_2} → (self : NumStability.HighResolutionCoordinateFiniteVolumeMethod.{u_1, u_2} Direction E) → Real
```

Definition body (one-level semantic boundary):

```lean
fun Direction E self => self.2
```

### D013: `NumStability.RequiresFullyMultidimensionalAt`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b882738b11017e2b32b9420d272ca41b999b6a1fdb4057333f6a31fb967060fa`

Type:

```lean
{State : Type u_1} → (State → State) → (State → State) → State → Prop
```

Fully explicit type:

```lean
{State : Type u_1} → (splitAdvance referenceAdvance : State → State) → (state : State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} splitAdvance referenceAdvance state => Ne (splitAdvance state) (referenceAdvance state)
```

### D014: `NumStability.SplitMatchesReferenceOn`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8bb139805bf3b4d0bbc0868c928ade01d67f04ac62ac016a45cb065900340e9e`

Type:

```lean
{State : Type u_1} → (State → State) → (State → State) → Set State → Prop
```

Fully explicit type:

```lean
{State : Type u_1} → (splitAdvance referenceAdvance : State → State) → (problemFamily : Set.{u_1} State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} splitAdvance referenceAdvance problemFamily =>
  ∀ (state : State), Set.instMembership.mem problemFamily state → Eq (splitAdvance state) (referenceAdvance state)
```

### D015: `NumStability.coordinateFiniteVolumeAdvance`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `790cb714e3c06f4ead646ab2b93023ef8e6f0a3bec7618ed015361f6dfb1cbd9`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {E : Type u_3} →
      [inst : AddCommGroup E] →
        [Module Real E] →
          NumStability.CoordinateFiniteVolumeGrid Direction Cell →
            NumStability.HighResolutionCoordinateFiniteVolumeMethod Direction E → (Cell → E) → Cell → E
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {E : Type u_3} →
      [inst : AddCommGroup.{u_3} E] →
        [@Module.{0, u_3} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_3} E inst)] →
          (grid : NumStability.CoordinateFiniteVolumeGrid.{u_1, u_2} Direction Cell) →
            (method : NumStability.HighResolutionCoordinateFiniteVolumeMethod.{u_1, u_3} Direction E) →
              (cellAverages : Cell → E) → (cell : Cell) → E
```

Definition body (one-level semantic boundary):

```lean
fun {Direction} {Cell} {E} [AddCommGroup E] [Module Real E] grid method cellAverages cell =>
  instHSub.hSub (cellAverages cell)
    (instHSMul.hSMul method.timeStepOverCellWidth
      (instHSub.hSub
        (method.numericalFlux (cellAverages cell) (cellAverages (grid.rightNeighbor method.direction cell)))
        (method.numericalFlux (cellAverages (grid.leftNeighbor method.direction cell)) (cellAverages cell))))
```

### D016: `NumStability.coordinateFiniteVolumeSweep`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f03807e033aef18c6909bc562ce4cfb7031af7ea754bfd41384c1e0d677d13f1`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {E : Type u_3} →
      [inst : AddCommGroup E] →
        [Module Real E] →
          NumStability.CoordinateFiniteVolumeGrid Direction Cell →
            (Direction → NumStability.HighResolutionCoordinateFiniteVolumeMethod Direction E) →
              List Direction → (Cell → E) → Cell → E
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    {E : Type u_3} →
      [inst : AddCommGroup.{u_3} E] →
        [@Module.{0, u_3} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_3} E inst)] →
          (grid : NumStability.CoordinateFiniteVolumeGrid.{u_1, u_2} Direction Cell) →
            (methods : Direction → NumStability.HighResolutionCoordinateFiniteVolumeMethod.{u_1, u_3} Direction E) →
              (directionOrder : List.{u_1} Direction) → (cellAverages : Cell → E) → Cell → E
```

Definition body (one-level semantic boundary):

```lean
fun {Direction} {Cell} {E} [AddCommGroup E] [Module Real E] grid methods directionOrder cellAverages =>
  NumStability.orderedOperatorSweep
    (List.map (fun direction => NumStability.coordinateFiniteVolumeAdvance grid (methods direction)) directionOrder)
    cellAverages
```

### D017: `NumStability.leveque01CartesianGrid`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `fd08ccf4acc232d4e1e7ebabbfb0768d6f6fc7c999d75e2a6fe047b2bffada32`

Type:

```lean
NumStability.CoordinateFiniteVolumeGrid Bool (Prod Int Int)
```

Fully explicit type:

```lean
NumStability.CoordinateFiniteVolumeGrid.{0, 0} Bool (Prod.{0, 0} Int Int)
```

Definition body (one-level semantic boundary):

```lean
{ geometry := NumStability.CoordinateGridGeometry.rectangular,
  coordinateDirections := List.cons Bool.false (List.cons Bool.true List.nil),
  directionsNodup := NumStability.leveque01CartesianGrid._proof_1,
  hasTwoDirections := NumStability.leveque01CartesianGrid._proof_2,
  leftNeighbor := fun direction cell =>
    NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
      (fun _ => { fst := instHSub.hSub cell.fst 1, snd := cell.snd }) fun _ =>
      { fst := cell.fst, snd := instHSub.hSub cell.snd 1 },
  rightNeighbor := fun direction cell =>
    NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
      (fun _ => { fst := instHAdd.hAdd cell.fst 1, snd := cell.snd }) fun _ =>
      { fst := cell.fst, snd := instHAdd.hAdd cell.snd 1 },
  right_left := NumStability.leveque01CartesianGrid._proof_3,
  left_right := NumStability.leveque01CartesianGrid._proof_4 }
```

### D018: `NumStability.leveque01CoordinateUpwindMethod`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `eb5680f5107dafd574ac7864092f86c69cc06f3dba012e7ac9b10095c426c857`

Type:

```lean
Bool → NumStability.HighResolutionCoordinateFiniteVolumeMethod Bool Real
```

Fully explicit type:

```lean
(direction : Bool) → NumStability.HighResolutionCoordinateFiniteVolumeMethod.{0, 0} Bool Real
```

Definition body (one-level semantic boundary):

```lean
fun direction =>
  { direction := direction, timeStepOverCellWidth := 1,
    positiveTimeStep := NumStability.leveque01CoordinateUpwindMethod._proof_1, physicalFlux := id,
    numericalFlux := fun leftState x => leftState, consistent := ⋯ }
```

### D019: `NumStability.leveque01CoupledReferenceAdvance`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f9d50d4372a965cf493c4afd22bbff638741c07f82371a057223ddbefaa4ecf1`

Type:

```lean
(Prod Int Int → Real) → Prod Int Int → Real
```

Fully explicit type:

```lean
(cellAverages : Prod.{0, 0} Int Int → Real) → (cell : Prod.{0, 0} Int Int) → Real
```

Definition body (one-level semantic boundary):

```lean
fun cellAverages cell =>
  instHSub.hSub
    (instHAdd.hAdd (cellAverages { fst := instHSub.hSub cell.fst 1, snd := cell.snd })
      (cellAverages { fst := cell.fst, snd := instHSub.hSub cell.snd 1 }))
    (cellAverages cell)
```

### D020: `NumStability.orderedOperatorSweep`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ded45e00fdb66124e4e954b7ce67fe13eb968f075d545f753830c16122d18920`

Type:

```lean
{State : Type u_1} → List (State → State) → State → State
```

Fully explicit type:

```lean
{State : Type u_1} → (operators : List.{u_1} (State → State)) → (state : State) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} operators state => List.foldl (fun current step => step current) state operators
```

### D021: `NumStability.CoordinateFiniteVolumeGrid.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `1f5192b0ea0f8a9d1d2178bddf2c9d484249be5e9f23e0408a4acee1b09ced5a`

Type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    NumStability.CoordinateGridGeometry →
      (coordinateDirections : List Direction) →
        coordinateDirections.Nodup →
          (Exists fun first =>
              And (List.instMembership.mem coordinateDirections first)
                (Exists fun second => And (List.instMembership.mem coordinateDirections second) (Ne first second))) →
            (leftNeighbor rightNeighbor : Direction → Cell → Cell) →
              (∀ (direction : Direction) (cell : Cell),
                  Eq (rightNeighbor direction (leftNeighbor direction cell)) cell) →
                (∀ (direction : Direction) (cell : Cell),
                    Eq (leftNeighbor direction (rightNeighbor direction cell)) cell) →
                  NumStability.CoordinateFiniteVolumeGrid Direction Cell
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {Cell : Type u_2} →
    (geometry : NumStability.CoordinateGridGeometry) →
      (coordinateDirections : List.{u_1} Direction) →
        (directionsNodup : @List.Nodup.{u_1} Direction coordinateDirections) →
          (hasTwoDirections :
              @Exists.{u_1 + 1} Direction fun (first : Direction) =>
                And
                  (@Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                    coordinateDirections first)
                  (@Exists.{u_1 + 1} Direction fun (second : Direction) =>
                    And
                      (@Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction)
                        (@List.instMembership.{u_1} Direction) coordinateDirections second)
                      (@Ne.{u_1 + 1} Direction first second))) →
            (leftNeighbor rightNeighbor : Direction → Cell → Cell) →
              (right_left :
                  ∀ (direction : Direction) (cell : Cell),
                    @Eq.{u_2 + 1} Cell (rightNeighbor direction (leftNeighbor direction cell)) cell) →
                (left_right :
                    ∀ (direction : Direction) (cell : Cell),
                      @Eq.{u_2 + 1} Cell (leftNeighbor direction (rightNeighbor direction cell)) cell) →
                  NumStability.CoordinateFiniteVolumeGrid.{u_1, u_2} Direction Cell
```

### D022: `NumStability.HighResolutionCoordinateFiniteVolumeMethod.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `c1e34b858ae662866665f80e9c6be1b849d3a563b5929aa703dc53ace63e6509`

Type:

```lean
{Direction : Type u_1} →
  {E : Type u_2} →
    Direction →
      (timeStepOverCellWidth : Real) →
        Real.instLT.lt 0 timeStepOverCellWidth →
          (physicalFlux : E → E) →
            (numericalFlux : E → E → E) →
              (∀ (state : E), Eq (numericalFlux state state) (physicalFlux state)) →
                NumStability.HighResolutionCoordinateFiniteVolumeMethod Direction E
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {E : Type u_2} →
    (direction : Direction) →
      (timeStepOverCellWidth : Real) →
        (positiveTimeStep :
            @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
              timeStepOverCellWidth) →
          (physicalFlux : E → E) →
            (numericalFlux : E → E → E) →
              (consistent : ∀ (state : E), @Eq.{u_2 + 1} E (numericalFlux state state) (physicalFlux state)) →
                NumStability.HighResolutionCoordinateFiniteVolumeMethod.{u_1, u_2} Direction E
```

### D023: `NumStability.leveque01CartesianGrid._proof_1`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `dfa162060f477bb38227507d9771a36cbc0ec5c1dfa8c7495c7917c789ff7bbd`

Type:

```lean
(List.cons Bool.false (List.cons Bool.true List.nil)).Nodup
```

Fully explicit type:

```lean
@List.Nodup.{0} Bool (@List.cons.{0} Bool Bool.false (@List.cons.{0} Bool Bool.true (@List.nil.{0} Bool)))
```

### D024: `NumStability.leveque01CartesianGrid._proof_2`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `5ffe7505f3a0823a896e11af2a388536f1ce99b7d3639d97caa7f8508311076b`

Type:

```lean
Exists fun first =>
  And (List.instMembership.mem (List.cons Bool.false (List.cons Bool.true List.nil)) first)
    (Exists fun second =>
      And (List.instMembership.mem (List.cons Bool.false (List.cons Bool.true List.nil)) second) (Ne first second))
```

Fully explicit type:

```lean
@Exists.{1} Bool fun (first : Bool) =>
  And
    (@Membership.mem.{0, 0} Bool (List.{0} Bool) (@List.instMembership.{0} Bool)
      (@List.cons.{0} Bool Bool.false (@List.cons.{0} Bool Bool.true (@List.nil.{0} Bool))) first)
    (@Exists.{1} Bool fun (second : Bool) =>
      And
        (@Membership.mem.{0, 0} Bool (List.{0} Bool) (@List.instMembership.{0} Bool)
          (@List.cons.{0} Bool Bool.false (@List.cons.{0} Bool Bool.true (@List.nil.{0} Bool))) second)
        (@Ne.{1} Bool first second))
```

### D025: `NumStability.leveque01CartesianGrid._proof_3`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `3d9e4f552808a8803fb944e26710f96c059cba3d125b792fb3194ffbc280550e`

Type:

```lean
∀ (direction : Bool) (cell : Prod Int Int),
  Eq
    (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
      (fun _ =>
        {
          fst :=
            instHAdd.hAdd
              (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
                  (fun _ => { fst := instHSub.hSub cell.fst 1, snd := cell.snd }) fun _ =>
                  { fst := cell.fst, snd := instHSub.hSub cell.snd 1 }).fst
              1,
          snd :=
            (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
                (fun _ => { fst := instHSub.hSub cell.fst 1, snd := cell.snd }) fun _ =>
                { fst := cell.fst, snd := instHSub.hSub cell.snd 1 }).snd })
      fun _ =>
      {
        fst :=
          (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
              (fun _ => { fst := instHSub.hSub cell.fst 1, snd := cell.snd }) fun _ =>
              { fst := cell.fst, snd := instHSub.hSub cell.snd 1 }).fst,
        snd :=
          instHAdd.hAdd
            (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
                (fun _ => { fst := instHSub.hSub cell.fst 1, snd := cell.snd }) fun _ =>
                { fst := cell.fst, snd := instHSub.hSub cell.snd 1 }).snd
            1 })
    cell
```

Fully explicit type:

```lean
∀ (direction : Bool) (cell : Prod.{0, 0} Int Int),
  @Eq.{1} (Prod.{0, 0} Int Int)
    (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
      (fun (_ : Unit) =>
        @Prod.mk.{0, 0} Int Int
          (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
            (@Prod.fst.{0, 0} Int Int
              (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
                (fun (_ : Unit) =>
                  @Prod.mk.{0, 0} Int Int
                    (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.fst.{0, 0} Int Int cell)
                      (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
                    (@Prod.snd.{0, 0} Int Int cell))
                fun (_ : Unit) =>
                @Prod.mk.{0, 0} Int Int (@Prod.fst.{0, 0} Int Int cell)
                  (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.snd.{0, 0} Int Int cell)
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))
            (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
          (@Prod.snd.{0, 0} Int Int
            (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
              (fun (_ : Unit) =>
                @Prod.mk.{0, 0} Int Int
                  (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.fst.{0, 0} Int Int cell)
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
                  (@Prod.snd.{0, 0} Int Int cell))
              fun (_ : Unit) =>
              @Prod.mk.{0, 0} Int Int (@Prod.fst.{0, 0} Int Int cell)
                (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.snd.{0, 0} Int Int cell)
                  (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))))
      fun (_ : Unit) =>
      @Prod.mk.{0, 0} Int Int
        (@Prod.fst.{0, 0} Int Int
          (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
            (fun (_ : Unit) =>
              @Prod.mk.{0, 0} Int Int
                (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.fst.{0, 0} Int Int cell)
                  (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
                (@Prod.snd.{0, 0} Int Int cell))
            fun (_ : Unit) =>
            @Prod.mk.{0, 0} Int Int (@Prod.fst.{0, 0} Int Int cell)
              (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.snd.{0, 0} Int Int cell)
                (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))
        (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
          (@Prod.snd.{0, 0} Int Int
            (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
              (fun (_ : Unit) =>
                @Prod.mk.{0, 0} Int Int
                  (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.fst.{0, 0} Int Int cell)
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
                  (@Prod.snd.{0, 0} Int Int cell))
              fun (_ : Unit) =>
              @Prod.mk.{0, 0} Int Int (@Prod.fst.{0, 0} Int Int cell)
                (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) (@Prod.snd.{0, 0} Int Int cell)
                  (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))
          (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
    cell
```

### D026: `NumStability.leveque01CartesianGrid._proof_4`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `2cf978c67987f159459fc945b407873447521b4a8a8b564e8836e3d1a8a489c1`

Type:

```lean
∀ (direction : Bool) (cell : Prod Int Int),
  Eq
    (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
      (fun _ =>
        {
          fst :=
            instHSub.hSub
              (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
                  (fun _ => { fst := instHAdd.hAdd cell.fst 1, snd := cell.snd }) fun _ =>
                  { fst := cell.fst, snd := instHAdd.hAdd cell.snd 1 }).fst
              1,
          snd :=
            (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
                (fun _ => { fst := instHAdd.hAdd cell.fst 1, snd := cell.snd }) fun _ =>
                { fst := cell.fst, snd := instHAdd.hAdd cell.snd 1 }).snd })
      fun _ =>
      {
        fst :=
          (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
              (fun _ => { fst := instHAdd.hAdd cell.fst 1, snd := cell.snd }) fun _ =>
              { fst := cell.fst, snd := instHAdd.hAdd cell.snd 1 }).fst,
        snd :=
          instHSub.hSub
            (NumStability.leveque01CartesianGrid.match_1 (fun direction => Prod Int Int) direction
                (fun _ => { fst := instHAdd.hAdd cell.fst 1, snd := cell.snd }) fun _ =>
                { fst := cell.fst, snd := instHAdd.hAdd cell.snd 1 }).snd
            1 })
    cell
```

Fully explicit type:

```lean
∀ (direction : Bool) (cell : Prod.{0, 0} Int Int),
  @Eq.{1} (Prod.{0, 0} Int Int)
    (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
      (fun (_ : Unit) =>
        @Prod.mk.{0, 0} Int Int
          (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub)
            (@Prod.fst.{0, 0} Int Int
              (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
                (fun (_ : Unit) =>
                  @Prod.mk.{0, 0} Int Int
                    (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (@Prod.fst.{0, 0} Int Int cell)
                      (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
                    (@Prod.snd.{0, 0} Int Int cell))
                fun (_ : Unit) =>
                @Prod.mk.{0, 0} Int Int (@Prod.fst.{0, 0} Int Int cell)
                  (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (@Prod.snd.{0, 0} Int Int cell)
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))
            (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
          (@Prod.snd.{0, 0} Int Int
            (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
              (fun (_ : Unit) =>
                @Prod.mk.{0, 0} Int Int
                  (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (@Prod.fst.{0, 0} Int Int cell)
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
                  (@Prod.snd.{0, 0} Int Int cell))
              fun (_ : Unit) =>
              @Prod.mk.{0, 0} Int Int (@Prod.fst.{0, 0} Int Int cell)
                (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (@Prod.snd.{0, 0} Int Int cell)
                  (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))))
      fun (_ : Unit) =>
      @Prod.mk.{0, 0} Int Int
        (@Prod.fst.{0, 0} Int Int
          (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
            (fun (_ : Unit) =>
              @Prod.mk.{0, 0} Int Int
                (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (@Prod.fst.{0, 0} Int Int cell)
                  (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
                (@Prod.snd.{0, 0} Int Int cell))
            fun (_ : Unit) =>
            @Prod.mk.{0, 0} Int Int (@Prod.fst.{0, 0} Int Int cell)
              (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (@Prod.snd.{0, 0} Int Int cell)
                (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))
        (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub)
          (@Prod.snd.{0, 0} Int Int
            (NumStability.leveque01CartesianGrid.match_1.{1} (fun (direction : Bool) => Prod.{0, 0} Int Int) direction
              (fun (_ : Unit) =>
                @Prod.mk.{0, 0} Int Int
                  (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (@Prod.fst.{0, 0} Int Int cell)
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))
                  (@Prod.snd.{0, 0} Int Int cell))
              fun (_ : Unit) =>
              @Prod.mk.{0, 0} Int Int (@Prod.fst.{0, 0} Int Int cell)
                (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (@Prod.snd.{0, 0} Int Int cell)
                  (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))
          (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
    cell
```

### D027: `NumStability.leveque01CartesianGrid.match_1`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `3c78c3c6978224ca4bb83db9f91f0c909fd156c7d90272fe8c2721d328551c13`

Type:

```lean
(motive : Bool → Sort u_1) →
  (direction : Bool) → (Unit → motive Bool.false) → (Unit → motive Bool.true) → motive direction
```

Fully explicit type:

```lean
(motive : Bool → Sort u_1) →
  (direction : Bool) → (h_1 : (a : Unit) → motive Bool.false) → (h_2 : (a : Unit) → motive Bool.true) → motive direction
```

Definition body (one-level semantic boundary):

```lean
fun motive direction h_1 h_2 => Bool.casesOn direction (h_1 Unit.unit) (h_2 Unit.unit)
```

### D028: `NumStability.leveque01CoordinateUpwindMethod._proof_1`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `7b750c7c15b7f31af2cdcf7124270745188e87f0a9a94ae5e76d4441d6930556`

Type:

```lean
Real.partialOrder.lt 0 1
```

Fully explicit type:

```lean
@LT.lt.{0} Real (@Preorder.toLT.{0} Real (@PartialOrder.toPreorder.{0} Real Real.partialOrder))
  (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
  (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
```

### D029: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(G : Type u) → Type u
```

### D030: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f727c3f01db957bd004eab61d742db6d02c6f9b2cdad465fa6f0ac214e09ccfd`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddCommMonoid G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommGroup.{u} G] → AddCommMonoid.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D031: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7f49725cf4bc16610110860af8f38e6d0fe472c7c1af93721407bad8c7375729`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddGroup G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommGroup.{u} G] → AddGroup.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : AddCommGroup G] => self.1
```

### D032: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8c0fca6ee264d934b25c679f16be6b83bb2a2f7c58a8ac0afab0c146219e16a1`

Type:

```lean
{A : Type u} → [self : AddGroup A] → SubNegMonoid A
```

Fully explicit type:

```lean
{A : Type u} → [self : AddGroup.{u} A] → SubNegMonoid.{u} A
```

Definition body (one-level semantic boundary):

```lean
fun A [self : AddGroup A] => self.1
```

### D033: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D034: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D035: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D036: `And`

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

### D037: `Bool`

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

### D038: `Bool.false`

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

### D039: `Bool.true`

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

### D040: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D041: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D042: `Eq`

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

### D043: `Exists`

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

### D044: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4e00447a4a8ef4c2ce13e307c56a1fbcd7fa8c732fe039a452b42477a50df2c6`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HMul α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HMul.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HMul α β γ] => self.1
```

### D045: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D046: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D047: `Int`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `257bf50f640447b541733c8fd9c6bcca584fc9dd85c221eb4f37888655c88e08`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D048: `Int.cast`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3347681a56db726f3d5ec40fea35e331466578d6194deeb554a0c70ba5189971`

Type:

```lean
{R : Type u} → [IntCast R] → Int → R
```

Fully explicit type:

```lean
{R : Type u} → [IntCast.{u} R] → Int → R
```

Definition body (one-level semantic boundary):

```lean
fun {R} [inst : IntCast R] => inst.intCast
```

### D049: `Int.instSub`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cdec027f4b1a52ca9841248e8efbabc901ed4e9b4220aa4074044d4c9537c68c`

Type:

```lean
Sub Int
```

Fully explicit type:

```lean
Sub.{0} Int
```

Definition body (one-level semantic boundary):

```lean
{ sub := Int.sub }
```

### D050: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D051: `List`

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

### D052: `List.Nodup`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D053: `List.Perm`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `79e469f11e60f9ed9276c0e4efbcc7c80aee352853d45e3af7490595f02b8d91`

Type:

```lean
{α : Type u} → List α → List α → Prop
```

Fully explicit type:

```lean
{α : Type u} → List.{u} α → List.{u} α → Prop
```

### D054: `List.cons`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `d4f0bc0954b11abbe9f8e60dd8762e7797f488b1975b155440101828c4c1ea14`

Type:

```lean
{α : Type u} → α → List α → List α
```

Fully explicit type:

```lean
{α : Type u} → (head : α) → (tail : List.{u} α) → List.{u} α
```

### D055: `List.instMembership`

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

### D056: `List.map`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D057: `List.nil`

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

### D058: `Membership.mem`

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

### D059: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

Fully explicit type:

```lean
(R : Type u) → (M : Type v) → [Semiring.{u} R] → [AddCommMonoid.{v} M] → Type (max u v)
```

### D060: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D061: `Ne`

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

### D062: `OfNat.ofNat`

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

### D063: `Or`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `de438fb54053199506d3db7df89e4ed6f1bc296d2e49a7e63e7a4b73a1b23d7e`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D064: `Prod`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `3df3b0cff45fb04022db70edff8e5747def6cae602cd8c33e673abac1bb4e347`

Type:

```lean
Type u → Type v → Type (max u v)
```

Fully explicit type:

```lean
(α : Type u) → (β : Type v) → Type (max u v)
```

### D065: `Prod.fst`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `31dfcc70f250d68311839281cfb552859ef6a5cdd31e725091d6a2a2f7fb2165`

Type:

```lean
{α : Type u} → {β : Type v} → Prod α β → α
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (self : Prod.{u, v} α β) → α
```

Definition body (one-level semantic boundary):

```lean
fun α β self => self.1
```

### D066: `Prod.mk`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `e42ba07a23655c2aae0502df1e03897313eaf034a0e84cfef98e91f6b4920097`

Type:

```lean
{α : Type u} → {β : Type v} → α → β → Prod α β
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (fst : α) → (snd : β) → Prod.{u, v} α β
```

### D067: `Prod.snd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a70aebf9da319c4b02023421b33923182c4d5164c2087035016589b80ed1191a`

Type:

```lean
{α : Type u} → {β : Type v} → Prod α β → β
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (self : Prod.{u, v} α β) → β
```

Definition body (one-level semantic boundary):

```lean
fun α β self => self.2
```

### D068: `Real`

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

### D069: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Type:

```lean
AddCommGroup Real
```

Fully explicit type:

```lean
AddCommGroup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D070: `Real.instIntCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7ad2826677bdd498c1fca7a01f5af78c74e38b65a4f1e767cdf3670649eac222`

Type:

```lean
IntCast Real
```

Fully explicit type:

```lean
IntCast.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ intCast := fun z => { cauchy := z.cast } }
```

### D071: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D072: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D073: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Type:

```lean
Mul Real
```

Fully explicit type:

```lean
Mul.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ mul := Real.mul✝ }
```

### D074: `Real.instZero`

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

### D075: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D076: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D077: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ff102bae4edee1f1bb819368914caf0ac2ec810b7e80210cd357fd643729a472`

Type:

```lean
{R : Type u_1} → [inst : Semiring R] → Module R R
```

Fully explicit type:

```lean
{R : Type u_1} →
  [inst : Semiring.{u_1} R] →
    @Module.{u_1, u_1} R R inst
      (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
        (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R inst)))
```

Definition body (one-level semantic boundary):

```lean
fun {R} [Semiring R] =>
  { toMulAction := (MonoidWithZero.toMulActionWithZero R).toMulAction, smul_zero := ⋯, smul_add := ⋯, add_smul := ⋯,
    zero_smul := ⋯ }
```

### D078: `Set.univ`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4a477fd0b844ae25dae2fe8488226265a7c6b23c8087f3feda3f6197172b13e7`

Type:

```lean
{α : Type u} → Set α
```

Fully explicit type:

```lean
{α : Type u} → Set.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} => setOf fun _a => True
```

### D079: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9e6f6ef922e3c39bdc8dcf74fa873f2e393c916c08aa49739c9dcafb3f96877b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → AddMonoid G
```

Fully explicit type:

```lean
{G : Type u} → [self : SubNegMonoid.{u} G] → AddMonoid.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.1
```

### D080: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f60885ee7a5e97dbc3d343ecb54849b15ae9ca7cc989f350d3b7fee2d2d0724b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → Sub G
```

Fully explicit type:

```lean
{G : Type u} → [self : SubNegMonoid.{u} G] → Sub.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.3
```

### D081: `Zero.toOfNat0`

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

### D082: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1fd375514ac68e29e7941c94ba308ea936395db23d0fee63a5c69dcccd3b2bdc`

Type:

```lean
{α : Type u_1} → [Mul α] → HMul α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Mul.{u_1} α] → HMul.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Mul α] => { hMul := fun a b => inst.mul a b }
```

### D083: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D084: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D085: `instOfNat`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d01cf83431e28a96433c57a624e20a771e5e0ddc02355969c5044adf1ba168a5`

Type:

```lean
{n : Nat} → OfNat Int n
```

Fully explicit type:

```lean
{n : Nat} → OfNat.{0} Int n
```

Definition body (one-level semantic boundary):

```lean
fun {n} => { ofNat := Int.ofNat n }
```

### D086: `Eq.refl`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `62d4020b7012db70e44624c7d64dd267524e7e75e4b869680e0c95d2231c85d1`

Type:

```lean
∀ {α : Sort u_1} (a : α), Eq a a
```

Fully explicit type:

```lean
∀ {α : Sort u_1} (a : α), @Eq.{u_1} α a a
```

### D087: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D088: `Int.instAdd`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f3fe827ffb6fc81658773a6ada6451aeb9c1a54d32b216d8dede8eae9142825b`

Type:

```lean
Add Int
```

Fully explicit type:

```lean
Add.{0} Int
```

Definition body (one-level semantic boundary):

```lean
{ add := Int.add }
```

### D089: `List.foldl`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `528cbed637e4ef546b621011d5cf13a5a950202dac919ee6cff2046010954d44`

Type:

```lean
{α : Type u} → {β : Type v} → (α → β → α) → α → List β → α
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (f : α → β → α) → (init : α) → List.{v} β → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f x x_1 =>
  List.brecOn (motive := fun x => α → α) x_1
    (fun x f_1 x_2 =>
      List.foldl.match_1 (fun x x_3 => List.below (motive := fun x => α → α) x_3 → α) x_2 x (fun a x => a)
        (fun a b l x => x.1 (f a b)) f_1)
    x
```

### D090: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D091: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Type:

```lean
Add Real
```

Fully explicit type:

```lean
Add.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ add := Real.add✝ }
```

### D092: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D093: `Real.instSub`

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

### D094: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D095: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D096: `Unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8544f990089bb705329f8e13de94d6583865877bcb1ebec4f8c096524a17581e`

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
PUnit
```

### D097: `id`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `dbf7c9f75c53aa3b4f811b7fd8038f2d2ab775571e37341e9514361b972c4868`

Type:

```lean
{α : Sort u} → α → α
```

Fully explicit type:

```lean
{α : Sort u} → (a : α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} a => a
```

### D098: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D099: `Bool.casesOn`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `98d460e4da0ec8a7ca3d02bf4c338e01aafaa4536c4a8f107307135e07b476c6`

Type:

```lean
{motive : Bool → Sort u} → (t : Bool) → motive Bool.false → motive Bool.true → motive t
```

Fully explicit type:

```lean
{motive : (t : Bool) → Sort u} → (t : Bool) → (false : motive Bool.false) → (true : motive Bool.true) → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t false true => Bool.rec false true t
```

### D100: `PartialOrder.toPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `079686fa1ec6d596bcdb475c56a12b7f5a0594bf346c64220c2c992e0f0aae3b`

Type:

```lean
{α : Type u_2} → [self : PartialOrder α] → Preorder α
```

Fully explicit type:

```lean
{α : Type u_2} → [self : PartialOrder.{u_2} α] → Preorder.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PartialOrder α] => self.1
```

### D101: `Preorder.toLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8fcf5a8f5a8899408a8cdc310bc44f6f7b84a21905a114103fbc65083f779a43`

Type:

```lean
{α : Type u_2} → [self : Preorder α] → LT α
```

Fully explicit type:

```lean
{α : Type u_2} → [self : Preorder.{u_2} α] → LT.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Preorder α] => self.2
```

### D102: `Real.partialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `c230e4cc01baeb2fcfa7d957f7e912e6e79376f736b5b58965ca7da585e8d66a`

Type:

```lean
PartialOrder Real
```

Fully explicit type:

```lean
PartialOrder.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toLE := Real.instLE, toLT := Real.instLT, le_refl := ⋯, le_trans := ⋯, lt_iff_le_not_ge := ⋯, le_antisymm := ⋯ }
```

### D103: `Unit.unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e5d4ec6d7dbc312235968b914130d2d6ec344f051fd5f7c0276905a3c63cc953`

Type:

```lean
Unit
```

Fully explicit type:

```lean
Unit
```

Definition body (one-level semantic boundary):

```lean
PUnit.unit
```
