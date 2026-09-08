# Declaration dossier for LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_riemannInitialConfiguration_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) :
    leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q ↔
      evolutionEquation q ∧
        (∀ x, x < 0 → q x 0 = leftState) ∧
        (∀ x, 0 < x → q x 0 = rightState)
```

## Elaborated target type

```lean
∀ {State : Type u_1} (evolutionEquation : (Real → Real → State) → Prop) (leftState rightState : State)
  (q : Real → Real → State),
  Iff (NumStability.leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q)
    (And (evolutionEquation q)
      (And (∀ (x : Real), Real.instLT.lt x 0 → Eq (q x 0) leftState)
        (∀ (x : Real), Real.instLT.lt 0 x → Eq (q x 0) rightState)))
```

## Fully explicit elaborated target type

```lean
∀ {State : Type u_1} (evolutionEquation : (Real → Real → State) → Prop) (leftState rightState : State)
  (q : Real → Real → State),
  Iff (@NumStability.leveque01RiemannInitialConfiguration.{u_1} State evolutionEquation leftState rightState q)
    (And (evolutionEquation q)
      (And
        (∀ (x : Real),
          @LT.lt.{0} Real Real.instLT x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) →
            @Eq.{u_1 + 1} State (q x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
              leftState)
        (∀ (x : Real),
          @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) x →
            @Eq.{u_1 + 1} State (q x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
              rightState)))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.leveque01RiemannInitialConfiguration`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `8f87d6c5b06e6de2318c84dfd17928bd955594c3933e289741cf1e00a94098ce`

Type:

```lean
{State : Type u_1} → ((Real → Real → State) → Prop) → State → State → (Real → Real → State) → Prop
```

Fully explicit type:

```lean
{State : Type u_1} →
  (evolutionEquation : (Real → Real → State) → Prop) → (leftState rightState : State) → (q : Real → Real → State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} evolutionEquation leftState rightState q =>
  NumStability.IsRiemannInitialValueSolution evolutionEquation leftState rightState q
```

### D002: `NumStability.IsRiemannInitialValueSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `4641364719967a9001e26cda78154811debc5edbdcfe65d7f0408c9d5100a21b`

Type:

```lean
{State : Type u_1} → ((Real → Real → State) → Prop) → State → State → (Real → Real → State) → Prop
```

Fully explicit type:

```lean
{State : Type u_1} →
  (evolutionEquation : (Real → Real → State) → Prop) → (leftState rightState : State) → (q : Real → Real → State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} evolutionEquation leftState rightState q =>
  And (evolutionEquation q) (NumStability.IsRiemannData (fun x => q x 0) leftState rightState)
```

### D003: `NumStability.IsRiemannData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D005: `Eq`

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

### D006: `Iff`

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

### D007: `LT.lt`

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

### D008: `OfNat.ofNat`

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

### D009: `Real`

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

### D010: `Real.instLT`

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

### D011: `Real.instZero`

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

### D012: `Zero.toOfNat0`

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

## Complete local imported sources

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean`
SHA-256: `35ab3a9c610ddbc90dec920888d39ff4bd36c54e7fe093e1bc4ace131950c3da`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# One-dimensional Riemann data

Source-independent definitions for piecewise constant initial data with one
jump at the origin.  The predicate intentionally imposes no condition at the
origin, and `riemannData` exposes that free value as an explicit parameter.
-/

namespace NumStability

/-- A field has left state `leftState` on `x < 0` and right state `rightState`
on `x > 0`.  Its value at `x = 0` is deliberately unspecified. -/
def IsRiemannData
    {State : Type*} (data : ℝ → State)
    (leftState rightState : State) : Prop :=
  (∀ x : ℝ, x < 0 → data x = leftState) ∧
    (∀ x : ℝ, 0 < x → data x = rightState)

/-- Riemann data with an explicit, freely chosen value at the jump point. -/
noncomputable def riemannData
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    ℝ → State :=
  fun x =>
    if x < 0 then leftState
    else if 0 < x then rightState
    else valueAtOrigin

/-- The parameterized construction satisfies the Riemann-data predicate. -/
theorem riemannData_isRiemannData
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    IsRiemannData
      (riemannData leftState valueAtOrigin rightState)
      leftState rightState := by
  constructor
  · intro x hx
    simp [riemannData, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt_of_ge (le_of_lt hx)
    simp [riemannData, hx, hnotLeft]

/-- The value of `riemannData` at the jump is exactly its free parameter. -/
@[simp]
theorem riemannData_zero
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    riemannData leftState valueAtOrigin rightState 0 = valueAtOrigin := by
  simp [riemannData]

/-- The Riemann-data predicate characterizes exactly the functions obtained by
choosing an arbitrary value at the origin. -/
theorem isRiemannData_iff_exists_valueAtOrigin
    {State : Type*} (data : ℝ → State)
    (leftState rightState : State) :
    IsRiemannData data leftState rightState ↔
      ∃ valueAtOrigin,
        data = riemannData leftState valueAtOrigin rightState := by
  constructor
  · rintro ⟨hleft, hright⟩
    refine ⟨data 0, funext ?_⟩
    intro x
    rcases lt_trichotomy x 0 with hx | hx | hx
    · simpa [riemannData, hx] using hleft x hx
    · subst x
      simp
    · have hnotLeft : ¬ x < 0 := not_lt_of_ge (le_of_lt hx)
      simpa [riemannData, hx, hnotLeft] using hright x hx
  · rintro ⟨valueAtOrigin, rfl⟩
    exact riemannData_isRiemannData leftState valueAtOrigin rightState

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/Riemann.lean`
SHA-256: `9d07fe686b4dce6970394fe557a0dc492c51ac84ac0e52683f150019d23130fb`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData

/-!
# Riemann initial configurations

Two-state initial data is conjoined with an independently supplied evolution equation.
Product data describes a common material/state interface and leaves the origin value free.
-/

namespace NumStability

/-- Add Riemann initial data to an independently supplied evolution equation.
The equation predicate is retained unchanged; this definition introduces no
particular classical/weak solution convention or existence assertion. -/
def IsRiemannInitialValueSolution {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) : Prop :=
  evolutionEquation q ∧ IsRiemannData (fun x => q x 0) leftState rightState

/-- Equation plus two-state initial data, with no condition at the origin. -/
theorem isRiemannInitialValueSolution_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) :
    IsRiemannInitialValueSolution evolutionEquation leftState rightState q ↔
      evolutionEquation q ∧
        (∀ x, x < 0 → q x 0 = leftState) ∧
        (∀ x, 0 < x → q x 0 = rightState) := Iff.rfl

/-- Equivalently, the free origin parameter supplies the complete initial
field; the independently supplied equation remains a separate requirement. -/
theorem isRiemannInitialValueSolution_iff_exists_origin {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) :
    IsRiemannInitialValueSolution evolutionEquation leftState rightState q ↔
      evolutionEquation q ∧ ∃ origin,
        (fun x => q x 0) = riemannData leftState origin rightState := by
  exact and_congr_right' (isRiemannData_iff_exists_valueAtOrigin _ _ _)

/-- A simultaneous material/state jump means the two component fields have
their corresponding left and right data at the same spatial interface. -/
theorem isRiemannData_prod_iff {Material State : Type*}
    (medium : ℝ → Material) (initialState : ℝ → State)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) :
    IsRiemannData (fun x => (medium x, initialState x))
        (leftMaterial, leftState) (rightMaterial, rightState) ↔
      IsRiemannData medium leftMaterial rightMaterial ∧
        IsRiemannData initialState leftState rightState := by
  constructor
  · rintro ⟨hleft, hright⟩
    exact ⟨⟨fun x hx => congrArg Prod.fst (hleft x hx),
      fun x hx => congrArg Prod.fst (hright x hx)⟩,
      ⟨fun x hx => congrArg Prod.snd (hleft x hx),
      fun x hx => congrArg Prod.snd (hright x hx)⟩⟩
  · rintro ⟨⟨hml, hmr⟩, ⟨hql, hqr⟩⟩
    exact ⟨fun x hx => Prod.ext (hml x hx) (hql x hx),
      fun x hx => Prod.ext (hmr x hx) (hqr x hx)⟩

/-- Pairing two Riemann profiles gives exactly the joint profile, preserving
both freely selected origin values. -/
theorem riemannData_prod {Material State : Type*}
    (leftMaterial originMaterial rightMaterial : Material)
    (leftState originState rightState : State) :
    (fun x => (riemannData leftMaterial originMaterial rightMaterial x,
      riemannData leftState originState rightState x)) =
      riemannData (leftMaterial, leftState) (originMaterial, originState)
        (rightMaterial, rightState) := by
  funext x
  unfold riemannData
  split_ifs <;> rfl


end NumStability
```
