# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
∀ {m : Nat} (timeStepOverCellWidth : Real) (numericalFlux : (Nat → Fin m → Real) → Nat → Fin m → Real)
  (cellAverages : Nat → Fin m → Real) (cellCount : Nat),
  Eq
    ((Finset.range cellCount).sum fun i =>
      LocalDef001 timeStepOverCellWidth numericalFlux cellAverages i)
    (instHSub.hSub ((Finset.range cellCount).sum fun i => cellAverages i)
      (instHSMul.hSMul timeStepOverCellWidth
        (instHSub.hSub (numericalFlux cellAverages cellCount) (numericalFlux cellAverages 0))))
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} (timeStepOverCellWidth : Real) (numericalFlux : (Nat → Fin m → Real) → Nat → Fin m → Real)
  (cellAverages : Nat → Fin m → Real) (cellCount : Nat),
  @Eq.{1} (Fin m → Real)
    (@Finset.sum.{0, 0} Nat (Fin m → Real)
      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
      (Finset.range cellCount) fun (i : Nat) =>
      @LocalDef001 m timeStepOverCellWidth numericalFlux cellAverages i)
    (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
      (@instHSub.{0} (Fin m → Real)
        (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
      (@Finset.sum.{0, 0} Nat (Fin m → Real)
        (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
        (Finset.range cellCount) fun (i : Nat) => cellAverages i)
      (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
        (@instHSMul.{0, 0} Real (Fin m → Real)
          (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
            (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
              (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring) (@Algebra.id.{0} Real Real.instCommSemiring))))
        timeStepOverCellWidth
        (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
          (@instHSub.{0} (Fin m → Real)
            (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
          (numericalFlux cellAverages cellCount)
          (numericalFlux cellAverages (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))))))
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cb6b79e35e9b543dc472aeb8beb0f73a767b2764fe7baeba9b4a8bbb529401a6`

Type:

```lean
{m : Nat} → Real → ((Nat → Fin m → Real) → Nat → Fin m → Real) → (Nat → Fin m → Real) → Nat → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {m} timeStepOverCellWidth numericalFlux cellAverages i =>
  LocalDef002 timeStepOverCellWidth cellAverages (numericalFlux cellAverages) i
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `4b8334148a30ee079386cf09e1581b8d61570643264df0416b8e158b5f2343fc`

Type:

```lean
{E : Type u_1} → [inst : AddCommGroup E] → [Module Real E] → Real → (Nat → E) → (Nat → E) → Nat → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [AddCommGroup E] [Module Real E] timeStepOverCellWidth cellAverages edgeFlux i =>
  instHSub.hSub (cellAverages i)
    (instHSMul.hSMul timeStepOverCellWidth (instHSub.hSub (edgeFlux (instHAdd.hAdd i 1)) (edgeFlux i)))
```

### D003: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5305322be4a562f24a6e568a2b0f4a4e3d7cf5ae9a842e07f0c4058c86e0fc14`

Type:

```lean
(R : Type u) → [inst : CommSemiring R] → Algebra R R
```

Definition body (one-level semantic boundary):

```lean
fun R [CommSemiring R] =>
  let __spread.0 :=
    (have __src := RingHom.id R;
      { toFun := fun x => x, map_one' := ⋯, map_mul' := ⋯, map_zero' := ⋯, map_add' := ⋯ }).toAlgebra;
  let __SMul := instSMulOfMul;
  { toSMul := __SMul, algebraMap := __spread.0.algebraMap, commutes' := ⋯, smul_def' := ⋯ }
```

### D004: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7ed84d651a0f6a77f78d6fd14524fe110f2045971d1f824f15cc8f5b8071484f`

Type:

```lean
{R : Type u} → {A : Type v} → {inst : CommSemiring R} → {inst_1 : Semiring A} → [self : Algebra R A] → SMul R A
```

Definition body (one-level semantic boundary):

```lean
fun R A {inst} {inst_1} [self : Algebra R A] => self.1
```

### D005: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bcda2e78d6b7602d359ab954baf5c3bd0f6b2503b3ec9a72e1a21a48b9d18d89`

Type:

```lean
{R : Type u} → [self : CommSemiring R] → Semiring R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : CommSemiring R] => self.1
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

### D007: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

### D008: `Finset.range`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Range`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `0d8947d3b91a57604f7b7be615f2ff236f2058a47281af31ea2498635666e9e7`

Type:

```lean
Nat → Finset Nat
```

Definition body (one-level semantic boundary):

```lean
fun n => { val := Multiset.range n, nodup := ⋯ }
```

### D009: `Finset.sum`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.BigOperators.Group.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `931ceac4e9efb5833f58970d10ced4621362e020ea1119492a8d379b7e692372`

Type:

```lean
{ι : Type u_1} → {M : Type u_3} → [AddCommMonoid M] → Finset ι → (ι → M) → M
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [AddCommMonoid M] s f => (Multiset.map f s.val).sum
```

### D010: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0cc1e812ed29ffd61aa88cc157fd57b24a4728a006314eec34a80ac32a5f63`

Type:

```lean
{ι : Type u_1} → {M : Type u_2} → {α : Type u_7} → [SMul M α] → SMul M (ι → α)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} {α} [SMul M α] => Pi.instSMul
```

### D011: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f1757307432fadbd23925bbf0a318b8da57d17711478e1073a19ce64c21d55f4`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSMul α β γ] => self.1
```

### D012: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `98025b38d523c0eadea77ba4961a20b2a913b23c079c4bfeba24a7bfaa24a4bc`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSub α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSub α β γ] => self.1
```

### D013: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

### D014: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Type:

```lean
{α : Type u} → (x : Nat) → [self : OfNat α x] → α
```

Definition body (one-level semantic boundary):

```lean
fun α x [self : OfNat α x] => self.1
```

### D015: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9b57724ac626ed82a5e3b9060068391fe112af839994c2304c9990493e8e9fbc`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommMonoid (f i)] → AddCommMonoid ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommMonoid (f i)] =>
  let __src := Pi.addMonoid;
  have __src_1 := Pi.addCommSemigroup;
  { toAddMonoid := __src, add_comm := ⋯ }
```

### D016: `Pi.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5deaec32b4deac749a5db5453affea1938386e569380df7daeec26aee3cfd7c2`

Type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [(i : ι) → Sub (G i)] → Sub ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [(i : ι) → Sub (G i)] => { sub := fun f g i => instHSub.hSub (f i) (g i) }
```

### D017: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D018: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `11a549e6c9caa007a4627570dd86aea756ada755f141da0356b8766788f2eef7`

Type:

```lean
AddCommMonoid Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D019: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `092dfdf642984bd4a336b502f7ac3f87adafd02a6236ba9033e90c0e1439ca7d`

Type:

```lean
CommSemiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D020: `Real.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `926d9e8fcca2819a885d446e168b20c7c8aac2e542d59ed2b48e32c9a4659a36`

Type:

```lean
Sub Real
```

Definition body (one-level semantic boundary):

```lean
{ sub := fun a b => instHAdd.hAdd a (Real.instNeg.neg b) }
```

### D021: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `04ea7c06812eccb8531b763b7aa28fd8f968befff069e74166ff1b406f7512e3`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [SMul α β] → HSMul α β β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : SMul α β] => { hSMul := inst.smul }
```

### D022: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `aa782f2b5af3d068f4c5340de4b32b193fece2c659a45582cc3024a19b550c87`

Type:

```lean
{α : Type u_1} → [Sub α] → HSub α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Sub α] => { hSub := fun a b => inst.sub a b }
```

### D023: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7018dea92aae8c272f3a065f25e2bedb9732a0b602c3d54b166fa0cf2ce1ea92`

Type:

```lean
(n : Nat) → OfNat Nat n
```

Definition body (one-level semantic boundary):

```lean
fun n => { ofNat := n }
```

### D024: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → AddCommMonoid α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocSemiring α] => self.1
```

### D025: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Type:

```lean
{α : Type u} → [self : NonUnitalSemiring α] → NonUnitalNonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSemiring α] => self.1
```

### D026: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Type:

```lean
(I : Type u) →
  (α : Type u_1) → (β : Type u_2) → [inst : Semiring α] → [inst_1 : AddCommMonoid β] → [Module α β] → Module α (I → β)
```

Definition body (one-level semantic boundary):

```lean
fun I α β [Semiring α] [AddCommMonoid β] [Module α β] => Pi.module I (fun a => β) α
```

### D027: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommGroup (f i)] → AddCommGroup ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommGroup (f i)] =>
  let __src := Pi.addGroup;
  have __src_1 := Pi.addCommMonoid;
  { toAddGroup := __src, add_comm := ⋯ }
```

### D028: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Type:

```lean
AddCommGroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D029: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Type:

```lean
Ring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D030: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Type:

```lean
Semiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D031: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Type:

```lean
{R : Type u} → [self : Ring R] → Semiring R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Ring R] => self.1
```

### D032: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `ff102bae4edee1f1bb819368914caf0ac2ec810b7e80210cd357fd643729a472`

Type:

```lean
{R : Type u_1} → [inst : Semiring R] → Module R R
```

Definition body (one-level semantic boundary):

```lean
fun {R} [Semiring R] =>
  { toMulAction := (MonoidWithZero.toMulActionWithZero R).toMulAction, smul_zero := ⋯, smul_add := ⋯, add_smul := ⋯,
    zero_smul := ⋯ }
```

### D033: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonUnitalSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Semiring α] => self.1
```

### D034: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

### D035: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `f727c3f01db957bd004eab61d742db6d02c6f9b2cdad465fa6f0ac214e09ccfd`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddCommMonoid G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D036: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `7f49725cf4bc16610110860af8f38e6d0fe472c7c1af93721407bad8c7375729`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddGroup G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : AddCommGroup G] => self.1
```

### D037: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8c0fca6ee264d934b25c679f16be6b83bb2a2f7c58a8ac0afab0c146219e16a1`

Type:

```lean
{A : Type u} → [self : AddGroup A] → SubNegMonoid A
```

Definition body (one-level semantic boundary):

```lean
fun A [self : AddGroup A] => self.1
```

### D038: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4b5cfcaa0e3b1157089b486d5bfd51b9d15b881ea9cad302a6c8f701cae9ef1a`

Type:

```lean
{M : Type u} → [self : AddMonoid M] → AddZeroClass M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toZero := self.toZero, toAdd := self.toAdd, zero_add := ⋯, add_zero := ⋯ }
```

### D039: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `aa06299f9d38f11e9dad40701d7541d8eba2a4ac673c643f4c5f5ce1369490cc`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Zero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.1
```

### D040: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8f64c653a96443ff67b52a5edb3fc264d279905b936c7303e9dd2469af000213`

Type:

```lean
{M : Type u} → [self : AddZeroClass M] → AddZero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZeroClass M] => self.1
```

### D041: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `17a3c7e66a4c2897891d468da70a58e73aa0b8e044ea0cc90d8d6e9e51c08f02`

Type:

```lean
{M : Type u_1} → {A : Type u_7} → [inst : Monoid M] → [inst_1 : AddMonoid A] → [DistribMulAction M A] → DistribSMul M A
```

Definition body (one-level semantic boundary):

```lean
fun {M} {A} [Monoid M] [AddMonoid A] [inst_2 : DistribMulAction M A] =>
  let __src := inst_2;
  { toSMul := __src.toSMul, smul_zero := ⋯, smul_add := ⋯ }
```

### D042: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `f640928ea31b161891006aaf9950d636ac5e1fbda413a7712f36546c938b3fdf`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : AddZeroClass A} → [self : DistribSMul M A] → SMulZeroClass M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : DistribSMul M A] => self.1
```

### D043: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D044: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

### D045: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Type:

```lean
{R : Type u} →
  {M : Type v} → {inst : Semiring R} → {inst_1 : AddCommMonoid M} → [self : Module R M] → DistribMulAction R M
```

Definition body (one-level semantic boundary):

```lean
fun R M {inst} {inst_1} [self : Module R M] => self.1
```

### D046: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Type:

```lean
Monoid Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D047: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `a8cadadddb0c9fd4a7bcb7c57401fafb43a1f330afa35fdacacb6d0e82d0bcf6`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : Zero A} → [self : SMulZeroClass M A] → SMul M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : SMulZeroClass M A] => self.1
```

### D048: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `9e6f6ef922e3c39bdc8dcf74fa873f2e393c916c08aa49739c9dcafb3f96877b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → AddMonoid G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.1
```

### D049: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `f60885ee7a5e97dbc3d343ecb54849b15ae9ca7cc989f350d3b7fee2d2d0724b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → Sub G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.3
```

### D050: `instAddNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a1534bcd3e1888406ac787d30eeff8a284cb6688c23f5e8de09351dda91a280c`

Type:

```lean
Add Nat
```

Definition body (one-level semantic boundary):

```lean
{ add := Nat.add }
```

### D051: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```
