# Declaration dossier for LEV-CH01-RIEMANN-RAY-ZERO-VALUE-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_riemannRayZeroValue_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State)
    (_hriemann : leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q)
    (hself : IsPositiveTimeSelfSimilar q) (value : State) :
    leveque01RiemannRayZeroValue q = value ↔ ∀ t, 0 < t → q 0 t = value
```

## Elaborated target type

```lean
∀ {State : Type u_1} (evolutionEquation : (Real → Real → State) → Prop) (leftState rightState : State)
  (q : Real → Real → State),
  NumStability.leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q →
    NumStability.IsPositiveTimeSelfSimilar q →
      ∀ (value : State),
        Iff (Eq (NumStability.leveque01RiemannRayZeroValue q) value)
          (∀ (t : Real), Real.instLT.lt 0 t → Eq (q 0 t) value)
```

## Fully explicit elaborated target type

```lean
∀ {State : Type u_1} (evolutionEquation : (Real → Real → State) → Prop) (leftState rightState : State)
  (q : Real → Real → State)
  (_hriemann : @NumStability.leveque01RiemannInitialConfiguration.{u_1} State evolutionEquation leftState rightState q)
  (hself : @NumStability.IsPositiveTimeSelfSimilar.{u_1} State q) (value : State),
  Iff (@Eq.{u_1 + 1} State (@NumStability.leveque01RiemannRayZeroValue.{u_1} State q) value)
    (∀ (t : Real),
      @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) t →
        @Eq.{u_1 + 1} State (q (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) t) value)
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity`, `ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity` imports: `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.FieldSimp`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsPositiveTimeSelfSimilar`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3f9212edfbae2cd597b277794f543250a75d57f0f5272e4f5b86002aeebf2398`

Type:

```lean
{State : Type u_1} → (Real → Real → State) → Prop
```

Fully explicit type:

```lean
{State : Type u_1} → (q : Real → Real → State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} q => ∀ (x : Real) {t : Real}, Real.instLT.lt 0 t → Eq (q x t) (q (instHDiv.hDiv x t) 1)
```

### D002: `NumStability.leveque01RiemannInitialConfiguration`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `654df1817dfda881498a9c73223b1b3fb9772f1f84239ae666e0088d949ced27`

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

### D003: `NumStability.leveque01RiemannRayZeroValue`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a5095364d8a6a8285a71479b9e99e6f261db284e2b9dfe5f488eb8acc9dd1f67`

Type:

```lean
{State : Type u_1} → (Real → Real → State) → State
```

Fully explicit type:

```lean
{State : Type u_1} → (q : Real → Real → State) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} q => NumStability.similarityRayValue q 0
```

### D004: `NumStability.IsRiemannInitialValueSolution`

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

### D005: `NumStability.similarityRayValue`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1fb87347d16ef6eb3cbf75317f8a2b9775d8677bf65685efa092d95adec0dcc1`

Type:

```lean
{State : Type u_1} → (Real → Real → State) → Real → State
```

Fully explicit type:

```lean
{State : Type u_1} → (q : Real → Real → State) → (ray : Real) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} q ray => q ray 1
```

### D006: `NumStability.IsRiemannData`

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

### D007: `Eq`

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

### D008: `Iff`

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

### D009: `LT.lt`

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

### D010: `OfNat.ofNat`

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

### D011: `Real`

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

### D012: `Real.instLT`

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

### D013: `Real.instZero`

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

### D014: `Zero.toOfNat0`

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

### D015: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D016: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D017: `One.toOfNat1`

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

### D018: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D019: `Real.instOne`

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

### D020: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D021: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

## Complete local imported sources

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/SelfSimilarity.lean`
SHA-256: `e58b0bbd30300dc50b0e16454b358a43dd1e03a9483a02bc3f9e4b3c5596078a`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp

/-!
# Positive-time self-similarity and ray values

A selected self-similar field has a time-independent value along each positive-time ray.
This does not assert uniqueness between different selected fields or traces.
-/

namespace NumStability

/-- A field is self-similar at positive time when its value depends only on
the ray x/t. The time-one slice is the selected similarity profile. -/
def IsPositiveTimeSelfSimilar {State : Type*} (q : ℝ → ℝ → State) : Prop :=
  ∀ (x : ℝ) {t : ℝ}, 0 < t → q x t = q (x / t) 1

/-- Value of the selected similarity profile on a ray. -/
def similarityRayValue {State : Type*} (q : ℝ → ℝ → State) (ray : ℝ) : State :=
  q ray 1

theorem IsPositiveTimeSelfSimilar.on_ray {State : Type*} {q : ℝ → ℝ → State}
    (h : IsPositiveTimeSelfSimilar q) (ray : ℝ) {t : ℝ} (ht : 0 < t) :
    q (ray * t) t = similarityRayValue q ray := by
  simpa only [similarityRayValue, mul_div_cancel_right₀ _ ht.ne'] using h (ray * t) ht

/-- The time-one evaluation is the unique value taken on the selected
positive-time ray, including the ray zero used by Riemann flux notation. -/
theorem IsPositiveTimeSelfSimilar.rayValue_iff {State : Type*}
    {q : ℝ → ℝ → State} (h : IsPositiveTimeSelfSimilar q) (ray : ℝ) (value : State) :
    similarityRayValue q ray = value ↔ ∀ t, 0 < t → q (ray * t) t = value := by
  constructor
  · intro hvalue t ht
    exact (h.on_ray ray ht).trans hvalue
  · intro hvalue
    simpa only [similarityRayValue, mul_one] using hvalue 1 zero_lt_one

theorem IsPositiveTimeSelfSimilar.rayZero {State : Type*} {q : ℝ → ℝ → State}
    (h : IsPositiveTimeSelfSimilar q) {t : ℝ} (ht : 0 < t) :
    q 0 t = similarityRayValue q 0 := by
  simpa only [zero_mul] using h.on_ray 0 ht

/-- Any explicitly selected profile supplies a self-similar field. No
continuity or trace uniqueness between different profiles is asserted. -/
theorem ratioProfile_isPositiveTimeSelfSimilar {State : Type*} (profile : ℝ → State) :
    IsPositiveTimeSelfSimilar (fun x t => profile (x / t)) := by
  intro x t _ht
  simp


end NumStability
```

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

### `ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration`

Path: `ComputationalMathematics/Source/LeVeque/Chapter01/RiemannInitialConfiguration.lean`
SHA-256: `353e101df40a1692beb8d09afd4d77bd9b0d86f661a114317ec46f59c2cacf20`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann

/-!
# LeVeque Chapter 1, Riemann initial-value configuration

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 5 (raw PDF page 27).
-/

namespace NumStability

/-- Add the displayed two-state data to the selected hyperbolic evolution
equation. The equation is an independent predicate, so this definition retains
its solution convention and does not assert existence or choose a solver.
The same data construction is available for any equation predicate. -/
abbrev leveque01RiemannInitialConfiguration {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) : Prop :=
  IsRiemannInitialValueSolution evolutionEquation leftState rightState q

/-- A Riemann configuration is precisely the chosen equation together with
the left and right initial states. No origin value is prescribed. -/
theorem leveque01_riemannInitialConfiguration_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) :
    leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q ↔
      evolutionEquation q ∧
        (∀ x, x < 0 → q x 0 = leftState) ∧
        (∀ x, 0 < x → q x 0 = rightState) :=
  isRiemannInitialValueSolution_iff evolutionEquation leftState rightState q

end NumStability
```
