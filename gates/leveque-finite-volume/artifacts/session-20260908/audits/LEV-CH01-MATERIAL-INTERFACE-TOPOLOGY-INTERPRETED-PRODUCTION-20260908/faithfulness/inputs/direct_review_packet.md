# Declaration dossier for LEV-CH01-MATERIAL-INTERFACE-TOPOLOGY-INTERPRETED-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_materialInterfaceLocalRiemannData {Material State : Type*}
    [TopologicalSpace Material] [TopologicalSpace State]
    [T2Space Material] [T2Space State]
    {medium : ℝ → Material} {initialState : ℝ → State}
    {leftMaterial rightMaterial : Material} {leftState rightState : State}
    (hmedium : HasJumpAt medium 0 leftMaterial rightMaterial)
    (hstate : IsRiemannData initialState leftState rightState)
    (hdistinct : leftState ≠ rightState) :
    (HasJumpAt medium 0 leftMaterial rightMaterial ∧
      HasJumpAt initialState 0 leftState rightState) ∧
    (Tendsto (fun x => (medium x, initialState x)) (𝓝[<] 0)
        (𝓝 (leftMaterial, leftState)) ∧
      Tendsto (fun x => (medium x, initialState x)) (𝓝[>] 0)
        (𝓝 (rightMaterial, rightState)) ∧
      leftMaterial ≠ rightMaterial ∧ leftState ≠ rightState) ∧
    IsRiemannData initialState leftState rightState ∧
    ¬ ContinuousAt medium 0 ∧ ¬ ContinuousAt initialState 0 ∧
    (∃ originState, initialState = riemannData leftState originState rightState)
```

## Elaborated target type

```lean
∀ {Material : Type u_1} {State : Type u_2} [inst : TopologicalSpace Material] [inst_1 : TopologicalSpace State]
  [T2Space Material] [T2Space State] {medium : Real → Material} {initialState : Real → State}
  {leftMaterial rightMaterial : Material} {leftState rightState : State},
  NumStability.HasJumpAt medium 0 leftMaterial rightMaterial →
    NumStability.IsRiemannData initialState leftState rightState →
      Ne leftState rightState →
        And
          (And (NumStability.HasJumpAt medium 0 leftMaterial rightMaterial)
            (NumStability.HasJumpAt initialState 0 leftState rightState))
          (And
            (And
              (Filter.Tendsto (fun x => { fst := medium x, snd := initialState x }) (nhdsWithin 0 (Set.Iio 0))
                (nhds { fst := leftMaterial, snd := leftState }))
              (And
                (Filter.Tendsto (fun x => { fst := medium x, snd := initialState x }) (nhdsWithin 0 (Set.Ioi 0))
                  (nhds { fst := rightMaterial, snd := rightState }))
                (And (Ne leftMaterial rightMaterial) (Ne leftState rightState))))
            (And (NumStability.IsRiemannData initialState leftState rightState)
              (And (Not (ContinuousAt medium 0))
                (And (Not (ContinuousAt initialState 0))
                  (Exists fun originState =>
                    Eq initialState (NumStability.riemannData leftState originState rightState))))))
```

## Fully explicit elaborated target type

```lean
∀ {Material : Type u_1} {State : Type u_2} [inst : TopologicalSpace.{u_1} Material]
  [inst_1 : TopologicalSpace.{u_2} State] [@T2Space.{u_1} Material inst] [@T2Space.{u_2} State inst_1]
  {medium : Real → Material} {initialState : Real → State} {leftMaterial rightMaterial : Material}
  {leftState rightState : State}
  (hmedium :
    @NumStability.HasJumpAt.{u_1} Material inst medium
      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) leftMaterial rightMaterial)
  (hstate : @NumStability.IsRiemannData.{u_2} State initialState leftState rightState)
  (hdistinct : @Ne.{u_2 + 1} State leftState rightState),
  And
    (And
      (@NumStability.HasJumpAt.{u_1} Material inst medium
        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) leftMaterial rightMaterial)
      (@NumStability.HasJumpAt.{u_2} State inst_1 initialState
        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) leftState rightState))
    (And
      (And
        (@Filter.Tendsto.{0, max u_2 u_1} Real (Prod.{u_1, u_2} Material State)
          (fun (x : Real) => @Prod.mk.{u_1, u_2} Material State (medium x) (initialState x))
          (@nhdsWithin.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
            (@Set.Iio.{0} Real Real.instPreorder
              (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))))
          (@nhds.{max u_1 u_2} (Prod.{u_1, u_2} Material State)
            (@instTopologicalSpaceProd.{u_1, u_2} Material State inst inst_1)
            (@Prod.mk.{u_1, u_2} Material State leftMaterial leftState)))
        (And
          (@Filter.Tendsto.{0, max u_2 u_1} Real (Prod.{u_1, u_2} Material State)
            (fun (x : Real) => @Prod.mk.{u_1, u_2} Material State (medium x) (initialState x))
            (@nhdsWithin.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
              (@Set.Ioi.{0} Real Real.instPreorder
                (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))))
            (@nhds.{max u_1 u_2} (Prod.{u_1, u_2} Material State)
              (@instTopologicalSpaceProd.{u_1, u_2} Material State inst inst_1)
              (@Prod.mk.{u_1, u_2} Material State rightMaterial rightState)))
          (And (@Ne.{u_1 + 1} Material leftMaterial rightMaterial) (@Ne.{u_2 + 1} State leftState rightState))))
      (And (@NumStability.IsRiemannData.{u_2} State initialState leftState rightState)
        (And
          (Not
            (@ContinuousAt.{0, u_1} Real Material
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              inst medium (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))))
          (And
            (Not
              (@ContinuousAt.{0, u_2} Real State
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_1 initialState (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))))
            (@Exists.{u_2 + 1} State fun (originState : State) =>
              @Eq.{u_2 + 1} (Real → State) initialState
                (@NumStability.riemannData.{u_2} State leftState originState rightState))))))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataJump`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`, `Mathlib.Analysis.Calculus.Deriv.Basic`
- `ComputationalMathematics.Topology.Order.Jump` imports: `Mathlib.Topology.Constructions.SumProd`, `Mathlib.Topology.Instances.Real.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataJump` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity`, `ComputationalMathematics.Topology.Order.Jump`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HasJumpAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Topology.Order.Jump`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `aa534a048dc393a30a846ded197c7f76580bdf2258f12ca6f816679676f2c033`

Type:

```lean
{E : Type u_1} → [TopologicalSpace E] → (Real → E) → Real → E → E → Prop
```

Fully explicit type:

```lean
{E : Type u_1} → [TopologicalSpace.{u_1} E] → (data : Real → E) → (a : Real) → (left right : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [TopologicalSpace E] data a left right =>
  And (Filter.Tendsto data (nhdsWithin a (Set.Iio a)) (nhds left))
    (And (Filter.Tendsto data (nhdsWithin a (Set.Ioi a)) (nhds right)) (Ne left right))
```

### D002: `NumStability.IsRiemannData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9986cca09fad513510d98d589879bd7b67d633458b39e176f9124be154775712`

Type:

```lean
{State : Type u_1} → (Real → State) → State → State → Prop
```

Fully explicit type:

```lean
{State : Type u_1} → (data : Real → State) → (leftState rightState : State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} data leftState rightState =>
  And (∀ (x : Real), Real.instLT.lt x 0 → Eq (data x) leftState)
    (∀ (x : Real), Real.instLT.lt 0 x → Eq (data x) rightState)
```

### D003: `NumStability.riemannData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `26e08100ec1e5620a6544ddb3d82ba18df6987384db43d3096e56de6c1c46638`

Type:

```lean
{State : Type u_1} → State → State → State → Real → State
```

Fully explicit type:

```lean
{State : Type u_1} → (leftState valueAtOrigin rightState : State) → Real → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} leftState valueAtOrigin rightState x =>
  ite (Real.instLT.lt x 0) leftState (ite (Real.instLT.lt 0 x) rightState valueAtOrigin)
```

### D004: `And`

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

### D005: `ContinuousAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3c8b2955cfd1b5ec4313254503ce66a5505b003200b3b378f96770b19f854cf6`

Type:

```lean
{X : Type u_1} → {Y : Type u_2} → [TopologicalSpace X] → [TopologicalSpace Y] → (X → Y) → X → Prop
```

Fully explicit type:

```lean
{X : Type u_1} → {Y : Type u_2} → [TopologicalSpace.{u_1} X] → [TopologicalSpace.{u_2} Y] → (f : X → Y) → (x : X) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {X} {Y} [TopologicalSpace X] [TopologicalSpace Y] f x => Filter.Tendsto f (nhds x) (nhds (f x))
```

### D006: `Eq`

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

### D007: `Exists`

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

### D008: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7e5f54349644c32198960083c0e0eb6c033c80a8656d02a78b3eae9a4f5131f2`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → (α → β) → Filter α → Filter β → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → (f : α → β) → (l₁ : Filter.{u_1} α) → (l₂ : Filter.{u_2} β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f l₁ l₂ => Filter.instPartialOrder.le (Filter.map f l₁) l₂
```

### D009: `Ne`

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

### D010: `Not`

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

### D011: `OfNat.ofNat`

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

### D012: `Prod`

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

### D013: `Prod.mk`

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

### D014: `PseudoMetricSpace.toUniformSpace`

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

### D015: `Real`

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

### D016: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `896bb94fc15867c0df82ea0f639eb6116e90a24819a66a54db9442e47cba7274`

Type:

```lean
Preorder Real
```

Fully explicit type:

```lean
Preorder.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D017: `Real.instZero`

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

### D018: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Type:

```lean
PseudoMetricSpace Real
```

Fully explicit type:

```lean
PseudoMetricSpace.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ dist := fun x y => abs (instHSub.hSub x y), dist_self := Real.pseudoMetricSpace._proof_1, dist_comm := ⋯,
  dist_triangle := ⋯, edist_dist := Real.pseudoMetricSpace._proof_2, uniformity_dist := Real.pseudoMetricSpace._proof_3,
  cobounded_sets := Real.pseudoMetricSpace._proof_4 }
```

### D019: `Set.Iio`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7d2fb1f1a25e32137e405a3246c71735490bca2e04477240797df205bd739c7e`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → (b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] b => setOf fun x => inst.lt x b
```

### D020: `Set.Ioi`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad556a749b4ff2a341c66bd35e0369f79888567fa7730aab8ee2fdd700fbfd52`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → (b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] b => setOf fun x => inst.lt b x
```

### D021: `T2Space`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Separation.Hausdorff`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `08a54e5e65d34b76977bbc7266ee793dc9893b14c6b6492ae56b97fde6aba974`

Type:

```lean
(X : Type u) → [TopologicalSpace X] → Prop
```

Fully explicit type:

```lean
(X : Type u) → [TopologicalSpace.{u} X] → Prop
```

### D022: `TopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `c85328c9b77ed49bcba2dd67e9f87b53aaf251834d29c69856ef079a9ec4b57b`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(X : Type u) → Type u
```

### D023: `UniformSpace.toTopologicalSpace`

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

### D024: `Zero.toOfNat0`

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

### D025: `instTopologicalSpaceProd`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions.SumProd`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `52bf679916f23cac59489c5a99280e24c015508e91377d9dfa711ba64a31319c`

Type:

```lean
{X : Type u} → {Y : Type v} → [t₁ : TopologicalSpace X] → [t₂ : TopologicalSpace Y] → TopologicalSpace (Prod X Y)
```

Fully explicit type:

```lean
{X : Type u} →
  {Y : Type v} →
    [t₁ : TopologicalSpace.{u} X] → [t₂ : TopologicalSpace.{v} Y] → TopologicalSpace.{max v u} (Prod.{u, v} X Y)
```

Definition body (one-level semantic boundary):

```lean
fun {X} {Y} [t₁ : TopologicalSpace X] [t₂ : TopologicalSpace Y] =>
  SemilatticeInf.toMin.min (TopologicalSpace.induced Prod.fst t₁) (TopologicalSpace.induced Prod.snd t₂)
```

### D026: `nhds`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8eb445823f4b15a765f7e0cd634f73196d36b4f09054d2aef43a69d3138c6ce8`

Type:

```lean
{X : Type u_3} → [TopologicalSpace X] → X → Filter X
```

Fully explicit type:

```lean
{X : Type u_3} → [TopologicalSpace.{u_3} X] → (x : X) → Filter.{u_3} X
```

Definition body (one-level semantic boundary):

```lean
wrapped✝.1
```

### D027: `nhdsWithin`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ae7b5c1971244e63e32407fed747da989ad9fef3a4d9c3a64643427eaf071f05`

Type:

```lean
{X : Type u_1} → [TopologicalSpace X] → X → Set X → Filter X
```

Fully explicit type:

```lean
{X : Type u_1} → [TopologicalSpace.{u_1} X] → (x : X) → (s : Set.{u_1} X) → Filter.{u_1} X
```

Definition body (one-level semantic boundary):

```lean
fun {X} [TopologicalSpace X] x s => Filter.instInf.min (nhds x) (Filter.principal s)
```

### D028: `LT.lt`

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

### D029: `Real.decidableLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `def93575a13821d7d42b557cb9b973eede26ae12bbb8b60b1f0a302bf95a5a42`

Type:

```lean
(a b : Real) → Decidable (Real.instLT.lt a b)
```

Fully explicit type:

```lean
(a b : Real) → Decidable (@LT.lt.{0} Real Real.instLT a b)
```

Definition body (one-level semantic boundary):

```lean
fun a b => inferInstance
```

### D030: `Real.instLT`

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

### D031: `ite`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3029bae29d2d16b5aeb879ad3c12a1b3c4e78998083bf1ab4614942fafdece0e`

Type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → α → α → α
```

Fully explicit type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → (t e : α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} c [h : Decidable c] t e => Decidable.casesOn h (fun x => e) fun x => t
```
