# Declaration dossier for LEV-CH01-SECOND-ORDER-WAVE-HYPERBOLICITY-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_equation07_secondOrderHyperbolic
    (bulkModulus density : ℝ)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    (wavePrincipalPart (Real.sqrt (bulkModulus / density))).IsHyperbolic
```

## Elaborated target type

```lean
∀ (bulkModulus density : Real),
  Real.instLT.lt 0 bulkModulus →
    Real.instLT.lt 0 density → (NumStability.wavePrincipalPart (instHDiv.hDiv bulkModulus density).sqrt).IsHyperbolic
```

## Fully explicit elaborated target type

```lean
∀ (bulkModulus density : Real)
  (hbulkModulus :
    @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) bulkModulus)
  (hdensity :
    @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) density),
  NumStability.SecondOrderPrincipalPart.IsHyperbolic
    (NumStability.wavePrincipalPart
      (Real.sqrt
        (@HDiv.hDiv.{0, 0, 0} Real Real Real (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
          bulkModulus density)))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification`, `Mathlib.Data.Real.Sqrt`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification` imports: `Mathlib.Algebra.QuadraticDiscriminant`, `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Positivity`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.SecondOrderPrincipalPart.IsHyperbolic`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ab0e1174a1338c2d9e8c383c9e610cacabadd72a7fe0d73b33c70bae2ad46a33`

Type:

```lean
NumStability.SecondOrderPrincipalPart → Prop
```

Fully explicit type:

```lean
(part : NumStability.SecondOrderPrincipalPart) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun part => Real.instLT.lt 0 (discrim part.timeTime part.timeSpace part.spaceSpace)
```

### D002: `NumStability.wavePrincipalPart`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `90afdfe4e0d90f929f4cb53c0d44e6493610c44a7f8f89fa465098bb8a71f9ab`

Type:

```lean
Real → NumStability.SecondOrderPrincipalPart
```

Fully explicit type:

```lean
(c : Real) → NumStability.SecondOrderPrincipalPart
```

Definition body (one-level semantic boundary):

```lean
fun c => { timeTime := 1, timeSpace := 0, spaceSpace := Real.instNeg.neg (instHPow.hPow c 2) }
```

### D003: `NumStability.SecondOrderPrincipalPart`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `c21d007bf144f6f84fc7aa043016e851352eebe7effe60547950ec6fb670f6eb`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D004: `NumStability.SecondOrderPrincipalPart.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `a90c48a7922dca270312d576d90f8dc816b6429df8e61dd7ddd628cbb4765840`

Type:

```lean
Real → Real → Real → NumStability.SecondOrderPrincipalPart
```

Fully explicit type:

```lean
(timeTime timeSpace spaceSpace : Real) → NumStability.SecondOrderPrincipalPart
```

### D005: `NumStability.SecondOrderPrincipalPart.spaceSpace`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `d561ac6dc0628d806eadb3833b75d937468280c8c8958c2fe69703128e287e53`

Type:

```lean
NumStability.SecondOrderPrincipalPart → Real
```

Fully explicit type:

```lean
(self : NumStability.SecondOrderPrincipalPart) → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.3
```

### D006: `NumStability.SecondOrderPrincipalPart.timeSpace`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `ab590672c2e82efd4fe30d2d228221c6f1b3dbb58c12f9a68fb6e1f178bf0f88`

Type:

```lean
NumStability.SecondOrderPrincipalPart → Real
```

Fully explicit type:

```lean
(self : NumStability.SecondOrderPrincipalPart) → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.2
```

### D007: `NumStability.SecondOrderPrincipalPart.timeTime`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `16f22a65feed2d8ebfdd69bf02f2a2d1a2c63fdf0f22273dabca823c2b372f1b`

Type:

```lean
NumStability.SecondOrderPrincipalPart → Real
```

Fully explicit type:

```lean
(self : NumStability.SecondOrderPrincipalPart) → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.1
```

### D008: `DivInvMonoid.toDiv`

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

### D009: `HDiv.hDiv`

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

### D010: `LT.lt`

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

### D012: `Real`

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

### D013: `Real.instDivInvMonoid`

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

### D014: `Real.instLT`

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

### D015: `Real.instZero`

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

### D016: `Real.sqrt`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Sqrt`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `67f9248ae1acb851b5392be301057ebb8b8ef2fb20f76d2d53a2d07ec8f30553`

Type:

```lean
Real → Real
```

Fully explicit type:

```lean
(x : Real) → Real
```

Definition body (one-level semantic boundary):

```lean
fun x => ((instFunLikeOrderIso NNReal NNReal).coe NNReal.sqrt x.toNNReal).toReal
```

### D017: `Zero.toOfNat0`

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

### D018: `instHDiv`

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

### D019: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6196b8cbb884c4f39841ba74b23d75f3c753fe0d044cc402bd6e4e3bd59d5cb8`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HPow α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HPow.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HPow α β γ] => self.1
```

### D020: `Monoid.toNatPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5b7373fe2de26535c1cdbf1b953ce34faf30f68aac8abd83ade2e78e6ec65b8a`

Type:

```lean
{M : Type u_2} → [Monoid M] → Pow M Nat
```

Fully explicit type:

```lean
{M : Type u_2} → [Monoid.{u_2} M] → Pow.{u_2, 0} M Nat
```

Definition body (one-level semantic boundary):

```lean
fun {M} [inst : Monoid M] => { pow := fun x n => inst.npow n x }
```

### D021: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D022: `Neg.neg`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `0c56662a5d917c211c3cb741ca747b4a6710082af615cf071342ef70dee3a2c7`

Type:

```lean
{α : Type u} → [self : Neg α] → α → α
```

Fully explicit type:

```lean
{α : Type u} → [self : Neg.{u} α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Neg α] => self.1
```

### D023: `One.toOfNat1`

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

### D024: `Real.instMonoid`

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

### D025: `Real.instNeg`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `000951397468b3d1f8a2a1cca1de3812bc024916ff842cfd5454811130093b41`

Type:

```lean
Neg Real
```

Fully explicit type:

```lean
Neg.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ neg := Real.neg✝ }
```

### D026: `Real.instOne`

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

### D027: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Type:

```lean
Ring Real
```

Fully explicit type:

```lean
Ring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D028: `discrim`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.QuadraticDiscriminant`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `77440b74a511d0f2da71019cdc8129933e8218c25620c8f33aee511250ec6628`

Type:

```lean
{R : Type u_1} → [Ring R] → R → R → R → R
```

Fully explicit type:

```lean
{R : Type u_1} → [Ring.{u_1} R] → (a b c : R) → R
```

Definition body (one-level semantic boundary):

```lean
fun {R} [Ring R] a b c => instHSub.hSub (instHPow.hPow b 2) (instHMul.hMul (instHMul.hMul 4 a) c)
```

### D029: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb300d353d84392c776cad5e356479f878030744a43f9a1584942a89d16350b4`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [Pow α β] → HPow α β α
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → [Pow.{u_1, u_2} α β] → HPow.{u_1, u_2, u_1} α β α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : Pow α β] => { hPow := fun a b => inst.pow a b }
```

### D030: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

## Complete local imported sources

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/SecondOrder/Classification.lean`
SHA-256: `71e185e56b9e972517ad946769d322ac7457e825779f28b31436214134c75f56`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.QuadraticDiscriminant
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Positivity

/-!
# Classification of a two-variable second-order principal part

The mixed coefficient is the full coefficient of the mixed derivative.
Hyperbolicity means a positive quadratic discriminant.
-/

namespace NumStability

/-- Coefficients of a homogeneous two-variable second-order principal part:
`timeTime * p_tt + timeSpace * p_tx + spaceSpace * p_xx`. -/
structure SecondOrderPrincipalPart where
  timeTime : ℝ
  timeSpace : ℝ
  spaceSpace : ℝ

/-- Positive discriminant is the hyperbolic case of the two-variable
second-order principal-part classification. -/
def SecondOrderPrincipalPart.IsHyperbolic
    (part : SecondOrderPrincipalPart) : Prop :=
  0 < discrim part.timeTime part.timeSpace part.spaceSpace

/-- The principal part of `p_tt - c² p_xx = 0`. -/
def wavePrincipalPart (c : ℝ) : SecondOrderPrincipalPart :=
  ⟨1, 0, -(c ^ 2)⟩

/-- A positive-speed wave principal part has positive discriminant. -/
theorem wavePrincipalPart_isHyperbolic (c : ℝ) (hc : 0 < c) :
    (wavePrincipalPart c).IsHyperbolic := by
  change 0 < (0 : ℝ) ^ 2 - 4 * 1 * -(c ^ 2)
  simp only [zero_pow (by decide : (2 : ℕ) ≠ 0), mul_one, mul_neg, zero_sub, neg_neg]
  positivity

end NumStability
```
