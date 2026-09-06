# Declaration dossier for LEV-CH01-DIMENSIONAL-SPLITTING

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_dimensionalSplitting_sourceContract
    {Direction State : Type*}
    (gridGeometry : CoordinateGridGeometry)
    (coordinateDirections : List Direction)
    (steps : List (CoordinateFractionalStep Direction State))
    (hcoverage : ∀ direction ∈ coordinateDirections,
      ∃ step ∈ steps, step.direction = direction)
    (state : State) :
    (gridGeometry = .rectangular ∨
        gridGeometry = .logicallyRectangular) ∧
      (∀ direction ∈ coordinateDirections,
        ∃ step ∈ steps, step.direction = direction) ∧
      coordinateFractionalSweep steps state =
        orderedOperatorSweep
          (steps.map fun step => step.oneDimensionalSolve) state
```

## Elaborated target type

```lean
∀ {Direction : Type u_1} {State : Type u_2} (gridGeometry : NumStability.CoordinateGridGeometry)
  (coordinateDirections : List Direction) (steps : List (NumStability.CoordinateFractionalStep Direction State)),
  (∀ (direction : Direction),
      List.instMembership.mem coordinateDirections direction →
        Exists fun step => And (List.instMembership.mem steps step) (Eq step.direction direction)) →
    ∀ (state : State),
      And
        (Or (Eq gridGeometry NumStability.CoordinateGridGeometry.rectangular)
          (Eq gridGeometry NumStability.CoordinateGridGeometry.logicallyRectangular))
        (And
          (∀ (direction : Direction),
            List.instMembership.mem coordinateDirections direction →
              Exists fun step => And (List.instMembership.mem steps step) (Eq step.direction direction))
          (Eq (NumStability.coordinateFractionalSweep steps state)
            (NumStability.orderedOperatorSweep (List.map (fun step => step.oneDimensionalSolve) steps) state)))
```

## Fully explicit elaborated target type

```lean
∀ {Direction : Type u_1} {State : Type u_2} (gridGeometry : NumStability.CoordinateGridGeometry)
  (coordinateDirections : List.{u_1} Direction)
  (steps : List.{max u_2 u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State))
  (hcoverage :
    ∀ (direction : Direction),
      @Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
          coordinateDirections direction →
        @Exists.{(max u_1 u_2) + 1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)
          fun (step : NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State) =>
          And
            (@Membership.mem.{max u_1 u_2, max u_1 u_2}
              (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)
              (List.{max u_2 u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State))
              (@List.instMembership.{max u_1 u_2} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State))
              steps step)
            (@Eq.{u_1 + 1} Direction (@NumStability.CoordinateFractionalStep.direction.{u_1, u_2} Direction State step)
              direction))
  (state : State),
  And
    (Or (@Eq.{1} NumStability.CoordinateGridGeometry gridGeometry NumStability.CoordinateGridGeometry.rectangular)
      (@Eq.{1} NumStability.CoordinateGridGeometry gridGeometry
        NumStability.CoordinateGridGeometry.logicallyRectangular))
    (And
      (∀ (direction : Direction),
        @Membership.mem.{u_1, u_1} Direction (List.{u_1} Direction) (@List.instMembership.{u_1} Direction)
            coordinateDirections direction →
          @Exists.{(max u_1 u_2) + 1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)
            fun (step : NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State) =>
            And
              (@Membership.mem.{max u_1 u_2, max u_1 u_2}
                (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)
                (List.{max u_2 u_1} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State))
                (@List.instMembership.{max u_1 u_2} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State))
                steps step)
              (@Eq.{u_1 + 1} Direction
                (@NumStability.CoordinateFractionalStep.direction.{u_1, u_2} Direction State step) direction))
      (@Eq.{u_2 + 1} State (@NumStability.coordinateFractionalSweep.{u_1, u_2} Direction State steps state)
        (@NumStability.orderedOperatorSweep.{u_2} State
          (@List.map.{max u_1 u_2, u_2} (NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State)
            (State → State)
            (fun (step : NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State) =>
              @NumStability.CoordinateFractionalStep.oneDimensionalSolve.{u_1, u_2} Direction State step)
            steps)
          state)))
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

### D003: `NumStability.CoordinateFractionalStep.oneDimensionalSolve`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e54c7aaebe6b348008c9e06f3fa94001f93ac8f3c92a5d4aa872743065294926`

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
fun Direction State self => self.5
```

### D004: `NumStability.CoordinateGridGeometry`

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

### D005: `NumStability.CoordinateGridGeometry.logicallyRectangular`

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

### D006: `NumStability.CoordinateGridGeometry.rectangular`

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

### D007: `NumStability.coordinateFractionalSweep`

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

### D008: `NumStability.orderedOperatorSweep`

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

### D009: `NumStability.CoordinateFractionalStep.mk`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `380e7c670bb7c7d6ad66073392939d286c4d8b56fc0789fa0413441e10986bd3`

Type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    Direction →
      (timeFraction : Real) →
        Real.instLT.lt 0 timeFraction →
          Real.instLE.le timeFraction 1 → (State → State) → NumStability.CoordinateFractionalStep Direction State
```

Fully explicit type:

```lean
{Direction : Type u_1} →
  {State : Type u_2} →
    (direction : Direction) →
      (timeFraction : Real) →
        (positive_timeFraction :
            @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
              timeFraction) →
          (timeFraction_le_one :
              @LE.le.{0} Real Real.instLE timeFraction
                (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))) →
            (oneDimensionalSolve : State → State) → NumStability.CoordinateFractionalStep.{u_1, u_2} Direction State
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

### D011: `Eq`

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

### D012: `Exists`

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

### D013: `List`

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

### D014: `List.instMembership`

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

### D015: `List.map`

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

### D017: `Or`

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

### D018: `List.foldl`

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

### D019: `LE.le`

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

### D020: `LT.lt`

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

### D021: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D022: `One.toOfNat1`

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

### D023: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D024: `Real.instLE`

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

### D025: `Real.instLT`

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

### D026: `Real.instOne`

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

### D027: `Real.instZero`

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

### D028: `Zero.toOfNat0`

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
