# Declaration dossier for LEV-CH01-DIMENSIONAL-SPLITTING

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_dimensionalSplitting_sourceContract :
    (∀ {Direction State Problem : Type*}
      (data : Leveque01DimensionalSplittingData Direction State Problem),
      IsLeveque01DimensionalSplitting data ↔
        (data.gridGeometry = .rectangular ∨
          data.gridGeometry = .logicallyRectangular) ∧
        (∃ d₁ ∈ data.coordinateDirections,
          ∃ d₂ ∈ data.coordinateDirections, d₁ ≠ d₂) ∧
        (∀ step ∈ data.fractionalSteps,
          step.direction ∈ data.coordinateDirections ∧
            data.isFractionalTimeSubstep step.direction step.timeFraction ∧
            data.isHighResolutionOneDimensionalSolve
              step.direction step.oneDimensionalSolve) ∧
        (∀ direction ∈ data.coordinateDirections,
          ∃ step ∈ data.fractionalSteps, step.direction = direction) ∧
        data.advance =
          (fun state => coordinateFractionalSweep data.fractionalSteps state) ∧
        (∃ problem, data.effectiveInPractice problem) ∧
        ∃ problem, data.requiresFullyMultidimensional problem) ∧
    ∃ data : Leveque01DimensionalSplittingData Bool (ℝ × ℝ) Bool,
      IsLeveque01DimensionalSplitting data ∧
      data.gridGeometry = .rectangular ∧
      data.coordinateDirections = [false, true] ∧
      data.fractionalSteps =
        [ { direction
```

## Elaborated target type

```lean
And
  (∀ {Direction : Type u_1} {State : Type u_2} {Problem : Type u_3}
    (data : NumStability.Leveque01DimensionalSplittingData Direction State Problem),
    Iff (NumStability.IsLeveque01DimensionalSplitting data)
      (And
        (Or (Eq data.gridGeometry NumStability.CoordinateGridGeometry.rectangular)
          (Eq data.gridGeometry NumStability.CoordinateGridGeometry.logicallyRectangular))
        (And
          (Exists fun d₁ =>
            And (List.instMembership.mem data.coordinateDirections d₁)
              (Exists fun d₂ => And (List.instMembership.mem data.coordinateDirections d₂) (Ne d₁ d₂)))
          (And
            (∀ (step : NumStability.CoordinateFractionalStep Direction State),
              List.instMembership.mem data.fractionalSteps step →
                And (List.instMembership.mem data.coordinateDirections step.direction)
                  (And (data.isFractionalTimeSubstep step.direction step.timeFraction)
                    (data.isHighResolutionOneDimensionalSolve step.direction step.oneDimensionalSolve)))
            (And
              (∀ (direction : Direction),
                List.instMembership.mem data.coordinateDirections direction →
                  Exists fun step =>
                    And (List.instMembership.mem data.fractionalSteps step) (Eq step.direction direction))
              (And (Eq data.advance fun state => NumStability.coordinateFractionalSweep data.fractionalSteps state)
                (And (Exists fun problem => data.effectiveInPractice problem)
                  (Exists fun problem => data.requiresFullyMultidimensional problem))))))))
  (Exists fun data =>
    And (NumStability.IsLeveque01DimensionalSplitting data)
      (And (Eq data.gridGeometry NumStability.CoordinateGridGeometry.rectangular)
        (And (Eq data.coordinateDirections (List.cons Bool.false (List.cons Bool.true List.nil)))
          (And
            (Eq data.fractionalSteps
              (List.cons
                { direction := Bool.false, timeFraction := 1 / 2,
                  oneDimensionalSolve := fun state => { fst := instHAdd.hAdd state.fst 1, snd := state.snd } }
                (List.cons
                  { direction := Bool.true, timeFraction := 1 / 2,
                    oneDimensionalSolve := fun state => { fst := state.fst, snd := instHAdd.hAdd state.snd 1 } }
                  List.nil)))
            (And (Eq data.isFractionalTimeSubstep fun x fraction => Eq fraction (1 / 2))
              (And
                (Eq data.isHighResolutionOneDimensionalSolve fun direction solve =>
                  Or
                    (And (Eq direction Bool.false)
                      (Eq solve fun state => { fst := instHAdd.hAdd state.fst 1, snd := state.snd }))
                    (And (Eq direction Bool.true)
                      (Eq solve fun state => { fst := state.fst, snd := instHAdd.hAdd state.snd 1 })))
                (And
                  (∀ (state : Prod Real Real),
                    Eq (data.advance state) { fst := instHAdd.hAdd state.fst 1, snd := instHAdd.hAdd state.snd 1 })
                  (And (Eq data.effectiveInPractice fun problem => Eq problem Bool.false)
                    (And (Eq data.requiresFullyMultidimensional fun problem => Eq problem Bool.true)
                      (And (data.effectiveInPractice Bool.false)
                        (And (data.requiresFullyMultidimensional Bool.true)
                          (Not (data.requiresFullyMultidimensional Bool.false)))))))))))))
```

## Fully explicit elaborated target type

```lean
And
  (∀ {Direction : Type u_1} {State : Type u_2} {Problem : Type u_3}
    (data : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem),
    Iff (@NumStability.IsLeveque01DimensionalSplitting.{u_1, u_2, u_3} Direction State Problem data)
      (And
        (Or
          (@Eq.{1} NumStability.CoordinateGridGeometry
            (@NumStability.Leveque01DimensionalSplittingData.gridGeometry.{u_1, u_2, u_3} Direction State Problem data)
            NumStability.CoordinateGridGeometry.rectangular)
          (@Eq.{1} NumStability.CoordinateGridGeometry
            (@NumStability.Leveque01DimensionalSplittingData.gridGeometry.{u_1, u_2, u_3} Direction State Problem data)
            NumStability.CoordinateGridGeometry.logicallyRectangular))
        (And
          (@Exists.{u_1 + 1} Direction fun (d₁ : Direction) =>
            And
              (@Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                (@NumStability.Leveque01DimensionalSplittingData.coordinateDirections.{u_1, u_2, u_3} Direction State
                  Problem data)
                d₁)
              (@Exists.{u_1 + 1} Direction fun (d₂ : Direction) =>
                And
                  (@Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                    (@NumStability.Leveque01DimensionalSplittingData.coordinateDirections.{u_1, u_2, u_3} Direction
                      State Problem data)
                    d₂)
                  (@Ne.{u_1 + 1} Direction d₁ d₂)))
          (And
            (∀ (step : NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State),
              @Membership.mem.{max u_1 u_2, max u_1 u_2}
                  (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)
                  (List.{max u_2 u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State))
                  (@List.instMembership.{max u_1 u_2}
                    (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State))
                  (@NumStability.Leveque01DimensionalSplittingData.fractionalSteps.{u_1, u_2, u_3} Direction State
                    Problem data)
                  step →
                And
                  (@Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                    (@NumStability.Leveque01DimensionalSplittingData.coordinateDirections.{u_1, u_2, u_3} Direction
                      State Problem data)
                    (@NumStability.CoordinateFractionalStep.direction.{u_1, u_2} Direction State step))
                  (And
                    (@NumStability.Leveque01DimensionalSplittingData.isFractionalTimeSubstep.{u_1, u_2, u_3} Direction
                      State Problem data
                      (@NumStability.CoordinateFractionalStep.direction.{u_1, u_2} Direction State step)
                      (@NumStability.CoordinateFractionalStep.timeFraction.{u_1, u_2} Direction State step))
                    (@NumStability.Leveque01DimensionalSplittingData.isHighResolutionOneDimensionalSolve.{u_1, u_2, u_3}
                      Direction State Problem data
                      (@NumStability.CoordinateFractionalStep.direction.{u_1, u_2} Direction State step)
                      (@NumStability.CoordinateFractionalStep.oneDimensionalSolve.{u_1, u_2} Direction State step))))
            (And
              (∀ (direction : Direction),
                @Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
                    (@NumStability.Leveque01DimensionalSplittingData.coordinateDirections.{u_1, u_2, u_3} Direction
                      State Problem data)
                    direction →
                  @Exists.{(max u_1 u_2) + 1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)
                    fun (step : NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State) =>
                    And
                      (@Membership.mem.{max u_1 u_2, max u_1 u_2}
                        (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)
                        (List.{max u_2 u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State))
                        (@List.instMembership.{max u_1 u_2}
                          (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State))
                        (@NumStability.Leveque01DimensionalSplittingData.fractionalSteps.{u_1, u_2, u_3} Direction State
                          Problem data)
                        step)
                      (@Eq.{u_1 + 1} Direction
                        (@NumStability.CoordinateFractionalStep.direction.{u_1, u_2} Direction State step) direction))
              (And
                (@Eq.{u_2 + 1} (State → State)
                  (@NumStability.Leveque01DimensionalSplittingData.advance.{u_1, u_2, u_3} Direction State Problem data)
                  fun (state : State) =>
                  @NumStability.coordinateFractionalSweep.{u_1, u_2} Direction State
                    (@NumStability.Leveque01DimensionalSplittingData.fractionalSteps.{u_1, u_2, u_3} Direction State
                      Problem data)
                    state)
                (And
                  (@Exists.{u_3 + 1} Problem fun (problem : Problem) =>
                    @NumStability.Leveque01DimensionalSplittingData.effectiveInPractice.{u_1, u_2, u_3} Direction State
                      Problem data problem)
                  (@Exists.{u_3 + 1} Problem fun (problem : Problem) =>
                    @NumStability.Leveque01DimensionalSplittingData.requiresFullyMultidimensional.{u_1, u_2, u_3}
                      Direction State Problem data problem))))))))
  (@Exists.{1} (NumStability.Leveque01DimensionalSplittingData.{0, 0, 0} Bool (Prod.{0, 0} Real Real) Bool)
    fun (data : NumStability.Leveque01DimensionalSplittingData.{0, 0, 0} Bool (Prod.{0, 0} Real Real) Bool) =>
    And (@NumStability.IsLeveque01DimensionalSplitting.{0, 0, 0} Bool (Prod.{0, 0} Real Real) Bool data)
      (And
        (@Eq.{1} NumStability.CoordinateGridGeometry
          (@NumStability.Leveque01DimensionalSplittingData.gridGeometry.{0, 0, 0} Bool (Prod.{0, 0} Real Real) Bool
            data)
          NumStability.CoordinateGridGeometry.rectangular)
        (And
          (@Eq.{1} (List.{0} Bool)
            (@NumStability.Leveque01DimensionalSplittingData.coordinateDirections.{0, 0, 0} Bool (Prod.{0, 0} Real Real)
              Bool data)
            (@List.cons.{0} Bool Bool.false (@List.cons.{0} Bool Bool.true (@List.nil.{0} Bool))))
          (And
            (@Eq.{1} (List.{0} (NumStability.CoordinateFractionalStep.{0, 0} Bool (Prod.{0, 0} Real Real)))
              (@NumStability.Leveque01DimensionalSplittingData.fractionalSteps.{0, 0, 0} Bool (Prod.{0, 0} Real Real)
                Bool data)
              (@List.cons.{0} (NumStability.CoordinateFractionalStep.{0, 0} Bool (Prod.{0, 0} Real Real))
                (@NumStability.CoordinateFractionalStep.mk.{0, 0} Bool (Prod.{0, 0} Real Real) Bool.false
                  (@HDiv.hDiv.{0, 0, 0} Real Real Real
                    (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                    (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
                    (@OfNat.ofNat.{0} Real (nat_lit 2)
                      (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                        (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                          (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))))))))
                  fun (state : Prod.{0, 0} Real Real) =>
                  @Prod.mk.{0, 0} Real Real
                    (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                      (@Prod.fst.{0, 0} Real Real state)
                      (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
                    (@Prod.snd.{0, 0} Real Real state))
                (@List.cons.{0} (NumStability.CoordinateFractionalStep.{0, 0} Bool (Prod.{0, 0} Real Real))
                  (@NumStability.CoordinateFractionalStep.mk.{0, 0} Bool (Prod.{0, 0} Real Real) Bool.true
                    (@HDiv.hDiv.{0, 0, 0} Real Real Real
                      (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                      (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
                      (@OfNat.ofNat.{0} Real (nat_lit 2)
                        (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                          (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                            (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))))))))
                    fun (state : Prod.{0, 0} Real Real) =>
                    @Prod.mk.{0, 0} Real Real (@Prod.fst.{0, 0} Real Real state)
                      (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                        (@Prod.snd.{0, 0} Real Real state)
                        (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))))
                  (@List.nil.{0} (NumStability.CoordinateFractionalStep.{0, 0} Bool (Prod.{0, 0} Real Real))))))
            (And
              (@Eq.{1} (Bool → Real → Prop)
                (@NumStability.Leveque01DimensionalSplittingData.isFractionalTimeSubstep.{0, 0, 0} Bool
                  (Prod.{0, 0} Real Real) Bool data)
                fun (x : Bool) (fraction : Real) =>
                @Eq.{1} Real fraction
                  (@HDiv.hDiv.{0, 0, 0} Real Real Real
                    (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
                    (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
                    (@OfNat.ofNat.{0} Real (nat_lit 2)
                      (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                        (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                          (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))))))))
              (And
                (@Eq.{1} (Bool → (Prod.{0, 0} Real Real → Prod.{0, 0} Real Real) → Prop)
                  (@NumStability.Leveque01DimensionalSplittingData.isHighResolutionOneDimensionalSolve.{0, 0, 0} Bool
                    (Prod.{0, 0} Real Real) Bool data)
                  fun (direction : Bool) (solve : (state : Prod.{0, 0} Real Real) → Prod.{0, 0} Real Real) =>
                  Or
                    (And (@Eq.{1} Bool direction Bool.false)
                      (@Eq.{1} ((state : Prod.{0, 0} Real Real) → Prod.{0, 0} Real Real) solve
                        fun (state : Prod.{0, 0} Real Real) =>
                        @Prod.mk.{0, 0} Real Real
                          (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                            (@Prod.fst.{0, 0} Real Real state)
                            (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
                          (@Prod.snd.{0, 0} Real Real state)))
                    (And (@Eq.{1} Bool direction Bool.true)
                      (@Eq.{1} ((state : Prod.{0, 0} Real Real) → Prod.{0, 0} Real Real) solve
                        fun (state : Prod.{0, 0} Real Real) =>
                        @Prod.mk.{0, 0} Real Real (@Prod.fst.{0, 0} Real Real state)
                          (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                            (@Prod.snd.{0, 0} Real Real state)
                            (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))))))
                (And
                  (∀ (state : Prod.{0, 0} Real Real),
                    @Eq.{1} (Prod.{0, 0} Real Real)
                      (@NumStability.Leveque01DimensionalSplittingData.advance.{0, 0, 0} Bool (Prod.{0, 0} Real Real)
                        Bool data state)
                      (@Prod.mk.{0, 0} Real Real
                        (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                          (@Prod.fst.{0, 0} Real Real state)
                          (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
                        (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                          (@Prod.snd.{0, 0} Real Real state)
                          (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))))
                  (And
                    (@Eq.{1} (Bool → Prop)
                      (@NumStability.Leveque01DimensionalSplittingData.effectiveInPractice.{0, 0, 0} Bool
                        (Prod.{0, 0} Real Real) Bool data)
                      fun (problem : Bool) => @Eq.{1} Bool problem Bool.false)
                    (And
                      (@Eq.{1} (Bool → Prop)
                        (@NumStability.Leveque01DimensionalSplittingData.requiresFullyMultidimensional.{0, 0, 0} Bool
                          (Prod.{0, 0} Real Real) Bool data)
                        fun (problem : Bool) => @Eq.{1} Bool problem Bool.true)
                      (And
                        (@NumStability.Leveque01DimensionalSplittingData.effectiveInPractice.{0, 0, 0} Bool
                          (Prod.{0, 0} Real Real) Bool data Bool.false)
                        (And
                          (@NumStability.Leveque01DimensionalSplittingData.requiresFullyMultidimensional.{0, 0, 0} Bool
                            (Prod.{0, 0} Real Real) Bool data Bool.true)
                          (Not
                            (@NumStability.Leveque01DimensionalSplittingData.requiresFullyMultidimensional.{0, 0, 0}
                              Bool (Prod.{0, 0} Real Real) Bool data Bool.false)))))))))))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting` imports: `Mathlib.Data.List.Basic`, `Mathlib.Data.Real.Basic`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.CoordinateFractionalStep`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `33b3df8a122509c39e80a252a3e8b3ec646860f3137394ed38ae6d2b0ceb1c12`

Type:

```lean
Type u_1 → Type u_2 → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Direction : Type u_1) → (State : Type u_2) → Type (max u_1 u_2)
```

### D002: `NumStability.CoordinateFractionalStep.direction`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `58a93c6f4aff9277ff41d1acc199efb861b29b3428af025ac3bfa9daa5a19744`

Type:

```lean
{Direction : Type u_1} → {State : Type u_2} → NumStability.CoordinateFractionalStep Direction State → Direction
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} → (self : NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State) → Direction
```

Definition body (one-level semantic boundary):

```lean
fun Direction State self => self.1
```

### D003: `NumStability.CoordinateFractionalStep.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `45b3ee25bc78771c3a56a4db73886de7016f736c783f6bcb56f737c62cd6e3f8`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} → Direction → Real → (State → State) → NumStability.CoordinateFractionalStep Direction State
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    (direction : Direction) →
      (timeFraction : Real) →
        (oneDimensionalSolve : State → State) → NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State
```

### D004: `NumStability.CoordinateFractionalStep.oneDimensionalSolve`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `15f73fe81ff59da760e06fb490e0a6d3e4c194093cfe86f46afc928a906aac35`

Type:

```lean
{Direction : Type u_1} → {State : Type u_2} → NumStability.CoordinateFractionalStep Direction State → State → State
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} → (self : NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State) → State → State
```

Definition body (one-level semantic boundary):

```lean
fun Direction State self => self.3
```

### D005: `NumStability.CoordinateFractionalStep.timeFraction`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a78c7648a2c1dea7bdfea64c1fdb6171cf702d1ccb276c7f574aacc6bb253edd`

Type:

```lean
{Direction : Type u_1} → {State : Type u_2} → NumStability.CoordinateFractionalStep Direction State → Real
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} → (self : NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State) → Real
```

Definition body (one-level semantic boundary):

```lean
fun Direction State self => self.2
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

### D009: `NumStability.IsLeveque01DimensionalSplitting`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `edd69ca367baff457e69d6602039553dbe84b4437b47525980d8b3b1f532701b`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} → NumStability.Leveque01DimensionalSplittingData Direction State Problem → Prop
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (data : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Direction} {State} {Problem} data =>
  And
    (Or (Eq data.gridGeometry NumStability.CoordinateGridGeometry.rectangular)
      (Eq data.gridGeometry NumStability.CoordinateGridGeometry.logicallyRectangular))
    (And
      (Exists fun d₁ =>
        And (List.instMembership.mem data.coordinateDirections d₁)
          (Exists fun d₂ => And (List.instMembership.mem data.coordinateDirections d₂) (Ne d₁ d₂)))
      (And
        (∀ (step : NumStability.CoordinateFractionalStep Direction State),
          List.instMembership.mem data.fractionalSteps step →
            And (List.instMembership.mem data.coordinateDirections step.direction)
              (And (data.isFractionalTimeSubstep step.direction step.timeFraction)
                (data.isHighResolutionOneDimensionalSolve step.direction step.oneDimensionalSolve)))
        (And
          (∀ (direction : Direction),
            List.instMembership.mem data.coordinateDirections direction →
              Exists fun step => And (List.instMembership.mem data.fractionalSteps step) (Eq step.direction direction))
          (And (Eq data.advance fun state => NumStability.coordinateFractionalSweep data.fractionalSteps state)
            (And (Exists fun problem => data.effectiveInPractice problem)
              (Exists fun problem => data.requiresFullyMultidimensional problem))))))
```

### D010: `NumStability.Leveque01DimensionalSplittingData`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b8fa3682603034ef0982e0f143520300b28f051e35c0adc58b96daf0e636399a`

Type:

```lean
Type u_1 → Type u_2 → Type u_3 → Type (max (max u_1 u_2) u_3)
```

Fully explicit type:

```lean
(Direction : Type u_1) → (State : Type u_2) → (Problem : Type u_3) → Type (max (max u_1 u_2) u_3)
```

### D011: `NumStability.Leveque01DimensionalSplittingData.advance`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `91b2f08e734db1f64f6eab893ae6044bb9727778abfce7e2ee7f3100576e2483`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} → NumStability.Leveque01DimensionalSplittingData Direction State Problem → State → State
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (self : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem) → State → State
```

Definition body (one-level semantic boundary):

```lean
fun Direction State Problem self => self.6
```

### D012: `NumStability.Leveque01DimensionalSplittingData.coordinateDirections`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5c86b484e249d3eb00d859ea50f4e8c05dbc755036cbb2f6ecf76c3de70a9470`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} → NumStability.Leveque01DimensionalSplittingData Direction State Problem → List Direction
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (self : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem) →
        List.{u_1} Direction
```

Definition body (one-level semantic boundary):

```lean
fun Direction State Problem self => self.2
```

### D013: `NumStability.Leveque01DimensionalSplittingData.effectiveInPractice`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `40b52d7cd3b61cfef255207ce31b6279895bbbcb705e443127c40539738676a8`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} → NumStability.Leveque01DimensionalSplittingData Direction State Problem → Problem → Prop
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (self : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem) → Problem → Prop
```

Definition body (one-level semantic boundary):

```lean
fun Direction State Problem self => self.7
```

### D014: `NumStability.Leveque01DimensionalSplittingData.fractionalSteps`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c0e8dfc74d3d7ac13b01ad1725412da59034c914d4fb3f87fdbb4587c6c8185b`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      NumStability.Leveque01DimensionalSplittingData Direction State Problem →
        List (NumStability.CoordinateFractionalStep Direction State)
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (self : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem) →
        List.{max u_2 u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)
```

Definition body (one-level semantic boundary):

```lean
fun Direction State Problem self => self.3
```

### D015: `NumStability.Leveque01DimensionalSplittingData.gridGeometry`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7b287e18bfd46eec11317f953dcc28657185416b7d13d6b0f8054b5297434928`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      NumStability.Leveque01DimensionalSplittingData Direction State Problem → NumStability.CoordinateGridGeometry
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (self : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem) →
        NumStability.CoordinateGridGeometry
```

Definition body (one-level semantic boundary):

```lean
fun Direction State Problem self => self.1
```

### D016: `NumStability.Leveque01DimensionalSplittingData.isFractionalTimeSubstep`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e693a434c3d99b9dfc6ae63d7a4fbbb7dab8f204a9897d5982b885fda07db34b`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      NumStability.Leveque01DimensionalSplittingData Direction State Problem → Direction → Real → Prop
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (self : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem) →
        Direction → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun Direction State Problem self => self.4
```

### D017: `NumStability.Leveque01DimensionalSplittingData.isHighResolutionOneDimensionalSolve`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `41feec2b2dbc36230d085645f9fb51ebe2eb47f77e7c5ff41e204b635b9b045c`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      NumStability.Leveque01DimensionalSplittingData Direction State Problem → Direction → (State → State) → Prop
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (self : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem) →
        Direction → (State → State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun Direction State Problem self => self.5
```

### D018: `NumStability.Leveque01DimensionalSplittingData.requiresFullyMultidimensional`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8f867c4451a342388ca114be037a6dbb98bf55b3391b4739d29398bc69e967f3`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} → NumStability.Leveque01DimensionalSplittingData Direction State Problem → Problem → Prop
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (self : NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem) → Problem → Prop
```

Definition body (one-level semantic boundary):

```lean
fun Direction State Problem self => self.8
```

### D019: `NumStability.coordinateFractionalSweep`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8cfcce9e13398beafb1a96ce7d4ed9eaa99332078ca07bbfb0dfb2ae7ad1f38b`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} → List (NumStability.CoordinateFractionalStep Direction State) → State → State
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    (steps : List.{max u_2 u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)) →
      (state : State) → State
```

Definition body (one-level semantic boundary):

```lean
fun {Direction} {State} steps state =>
  NumStability.orderedOperatorSweep (List.map (fun step => step.oneDimensionalSolve) steps) state
```

### D020: `NumStability.Leveque01DimensionalSplittingData.mk`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `192ba484bba1ab5af0740657d7772749dcd4dd4a26eef7be7b68a70896cb8b82`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      NumStability.CoordinateGridGeometry →
        List Direction →
          List (NumStability.CoordinateFractionalStep Direction State) →
            (Direction → Real → Prop) →
              (Direction → (State → State) → Prop) →
                (State → State) →
                  (Problem → Prop) →
                    (Problem → Prop) → NumStability.Leveque01DimensionalSplittingData Direction State Problem
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    {Problem : Type u_3} →
      (gridGeometry : NumStability.CoordinateGridGeometry) →
        (coordinateDirections : List.{u_1} Direction) →
          (fractionalSteps : List.{max u_2 u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)) →
            (isFractionalTimeSubstep : Direction → Real → Prop) →
              (isHighResolutionOneDimensionalSolve : Direction → (State → State) → Prop) →
                (advance : State → State) →
                  (effectiveInPractice requiresFullyMultidimensional : Problem → Prop) →
                    NumStability.Leveque01DimensionalSplittingData.{u_1, u_2, u_3} Direction State Problem
```

### D021: `NumStability.orderedOperatorSweep`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D022: `And`

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

### D023: `Bool`

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

### D024: `Bool.false`

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

### D025: `Bool.true`

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

### D026: `DivInvMonoid.toDiv`

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

### D027: `Eq`

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

### D028: `Exists`

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

### D029: `HAdd.hAdd`

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

### D030: `HDiv.hDiv`

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

### D031: `Iff`

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

### D032: `List`

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

### D033: `List.cons`

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

### D034: `List.instMembership`

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

### D035: `List.nil`

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

### D036: `Membership.mem`

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

### D037: `Nat`

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

### D038: `Nat.instAtLeastTwoHAddOfNat`

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

### D039: `Nat.instNeZeroSucc`

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

### D040: `Ne`

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

### D041: `Not`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `0bfdacbe07f6cbb8995b354e36299fd742f29398c188d7cc23dedcdc47f57a9a`

Type:

```lean
Prop → Prop
```

Fully explicit type:

```lean
(a : Prop) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun a => a → False
```

### D042: `OfNat.ofNat`

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

### D043: `One.toOfNat1`

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

### D044: `Or`

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

### D045: `Prod`

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

### D046: `Prod.fst`

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

### D047: `Prod.mk`

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

### D048: `Prod.snd`

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

### D049: `Real`

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

### D050: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D051: `Real.instDivInvMonoid`

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

### D052: `Real.instNatCast`

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

### D053: `Real.instOne`

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

### D055: `instHDiv`

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

### D056: `instOfNatAtLeastTwo`

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

### D057: `instOfNatNat`

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

### D058: `List.map`

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

### D059: `List.foldl`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

## Complete local imported sources

### `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`

Path: `NumStability/Analysis/PartialDifferentialEquations/OperatorSplitting.lean`
SHA-256: `d20b4049103c49d481750d35fa5957e3bf2ed3811f5a993cc0cbdb65c0b7364e`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.List.Basic
import Mathlib.Data.Real.Basic

/-!
# Ordered operator splitting

An ordered sweep applies a finite list of one-direction update operators in
sequence.  The definition is independent of a grid or a particular PDE.
-/

namespace NumStability

/-- The grid geometries for which LeVeque presents dimensional splitting as
the simplest coordinate-direction extension. -/
inductive CoordinateGridGeometry where
  | rectangular
  | logicallyRectangular
deriving DecidableEq

/-- One coordinate-direction substep in a fractional-step sweep.  The time
fraction is data because Chapter 1 does not prescribe its value. -/
structure CoordinateFractionalStep (Direction State : Type*) where
  direction : Direction
  timeFraction : ℝ
  oneDimensionalSolve : State → State

/-- Apply update operators from left to right to an initial state. -/
def orderedOperatorSweep {State : Type*}
    (operators : List (State → State)) (state : State) : State :=
  operators.foldl (fun current step => step current) state

/-- Apply coordinate-direction fractional steps sequentially in their listed
order.  Repeated directions permit schedules such as symmetric splittings. -/
def coordinateFractionalSweep {Direction State : Type*}
    (steps : List (CoordinateFractionalStep Direction State))
    (state : State) : State :=
  orderedOperatorSweep (steps.map (fun step => step.oneDimensionalSolve)) state

@[simp] theorem orderedOperatorSweep_nil {State : Type*} (state : State) :
    orderedOperatorSweep ([] : List (State → State)) state = state :=
  rfl

/-- A two-direction sweep first applies the first operator and then the
second. -/
@[simp] theorem orderedOperatorSweep_two
    {State : Type*} (first second : State → State) (state : State) :
    orderedOperatorSweep [first, second] state = second (first state) :=
  rfl

end NumStability
```
