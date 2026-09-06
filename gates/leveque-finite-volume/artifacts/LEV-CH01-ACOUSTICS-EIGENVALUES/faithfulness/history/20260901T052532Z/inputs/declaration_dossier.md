# Declaration dossier for LEV-CH01-ACOUSTICS-EIGENVALUES

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_acousticsMatrixEigenvalues
    {bulkModulus density : ℝ}
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    let soundSpeed
```

## Elaborated target type

```lean
∀ {bulkModulus density : Real},
  Real.instLT.lt 0 bulkModulus →
    Real.instLT.lt 0 density →
      have soundSpeed := (instHDiv.hDiv bulkModulus density).sqrt;
      And (Ne (NumStability.linearAcousticsLeftEigenvector density soundSpeed) 0)
        (And
          (Eq
            ((NumStability.linearAcousticsMatrix bulkModulus density).mulVec
              (NumStability.linearAcousticsLeftEigenvector density soundSpeed))
            (instHSMul.hSMul (Real.instNeg.neg soundSpeed)
              (NumStability.linearAcousticsLeftEigenvector density soundSpeed)))
          (And (Ne (NumStability.linearAcousticsRightEigenvector density soundSpeed) 0)
            (Eq
              ((NumStability.linearAcousticsMatrix bulkModulus density).mulVec
                (NumStability.linearAcousticsRightEigenvector density soundSpeed))
              (instHSMul.hSMul soundSpeed (NumStability.linearAcousticsRightEigenvector density soundSpeed)))))
```

## Fully explicit elaborated target type

```lean
∀ {bulkModulus density : Real}
  (hbulkModulus :
    @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) bulkModulus)
  (hdensity :
    @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) density),
  have soundSpeed : Real :=
    Real.sqrt
      (@HDiv.hDiv.{0, 0, 0} Real Real Real (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
        bulkModulus density);
  And
    (@Ne.{1} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
      (NumStability.linearAcousticsLeftEigenvector density soundSpeed)
      (@OfNat.ofNat.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real) (nat_lit 0)
        (@Zero.toOfNat0.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
          (@Pi.instZero.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))))
            (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))) => Real)
            fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))) => Real.instZero))))
    (And
      (@Eq.{1} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
        (@Matrix.mulVec.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))))
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))) Real
          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
          (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))))
          (NumStability.linearAcousticsMatrix bulkModulus density)
          (NumStability.linearAcousticsLeftEigenvector density soundSpeed))
        (@HSMul.hSMul.{0, 0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
          (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
          (@instHSMul.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
            (@Function.hasSMul.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))) Real Real
              (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                (@Algebra.id.{0} Real Real.instCommSemiring))))
          (@Neg.neg.{0} Real Real.instNeg soundSpeed) (NumStability.linearAcousticsLeftEigenvector density soundSpeed)))
      (And
        (@Ne.{1} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
          (NumStability.linearAcousticsRightEigenvector density soundSpeed)
          (@OfNat.ofNat.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real) (nat_lit 0)
            (@Zero.toOfNat0.{0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
              (@Pi.instZero.{0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))))
                (fun (a : Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))) => Real)
                fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))) => Real.instZero))))
        (@Eq.{1} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
          (@Matrix.mulVec.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))))
            (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))) Real
            (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
              (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                  (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                    (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
            (Fin.fintype (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))))
            (NumStability.linearAcousticsMatrix bulkModulus density)
            (NumStability.linearAcousticsRightEigenvector density soundSpeed))
          (@HSMul.hSMul.{0, 0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
            (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
            (@instHSMul.{0, 0} Real (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real)
              (@Function.hasSMul.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))) Real Real
                (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                  (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                  (@Algebra.id.{0} Real Real.instCommSemiring))))
            soundSpeed (NumStability.linearAcousticsRightEigenvector density soundSpeed)))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Source.LeVeque.Chapter01.Equation06`
- `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `NumStability.Source.LeVeque.Chapter01.Equation01` imports: `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics` imports: `Mathlib.LinearAlgebra.Matrix.Notation`, `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`, `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection`
- `NumStability.Source.LeVeque.Chapter01.Equation05` imports: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- `NumStability.Source.LeVeque.Chapter01.Equation06` imports: `NumStability.Source.LeVeque.Chapter01.Equation01`, `NumStability.Source.LeVeque.Chapter01.Equation05`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.linearAcousticsLeftEigenvector`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `830ead806864d29815db69cbb4e16a3234b0300b92eca2bb9a47f065c9caaa94`

Type:

```lean
Real → Real → Fin 2 → Real
```

Fully explicit type:

```lean
(density soundSpeed : Real) → Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real
```

Definition body (one-level semantic boundary):

```lean
fun density soundSpeed =>
  Matrix.vecCons (instHMul.hMul (Real.instNeg.neg density) soundSpeed) (Matrix.vecCons 1 Matrix.vecEmpty)
```

### D002: `NumStability.linearAcousticsMatrix`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `07df83dd87a01b81b25e45af9f90591ffff2cf9451e8d5e4ce0d240ca4115458`

Type:

```lean
Real → Real → Matrix (Fin 2) (Fin 2) Real
```

Fully explicit type:

```lean
(bulkModulus density : Real) →
  Matrix.{0, 0, 0} (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))))
    (Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))) Real
```

Definition body (one-level semantic boundary):

```lean
fun bulkModulus density =>
  EquivLike.toFunLike.coe Matrix.of
    (Matrix.vecCons (Matrix.vecCons 0 (Matrix.vecCons bulkModulus Matrix.vecEmpty))
      (Matrix.vecCons (Matrix.vecCons (Real.instInv.inv density) (Matrix.vecCons 0 Matrix.vecEmpty)) Matrix.vecEmpty))
```

### D003: `NumStability.linearAcousticsRightEigenvector`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c9c8456f8ca818bbc751520a02c59493f31544bea4d41c8a020a98dfd0ddb190`

Type:

```lean
Real → Real → Fin 2 → Real
```

Fully explicit type:

```lean
(density soundSpeed : Real) → Fin (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))) → Real
```

Definition body (one-level semantic boundary):

```lean
fun density soundSpeed => Matrix.vecCons (instHMul.hMul density soundSpeed) (Matrix.vecCons 1 Matrix.vecEmpty)
```

### D004: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5305322be4a562f24a6e568a2b0f4a4e3d7cf5ae9a842e07f0c4058c86e0fc14`

Type:

```lean
(R : Type u) → [inst : CommSemiring R] → Algebra R R
```

Fully explicit type:

```lean
(R : Type u) → [inst : CommSemiring.{u} R] → @Algebra.{u, u} R R inst (@CommSemiring.toSemiring.{u} R inst)
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

### D005: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7ed84d651a0f6a77f78d6fd14524fe110f2045971d1f824f15cc8f5b8071484f`

Type:

```lean
{R : Type u} → {A : Type v} → {inst : CommSemiring R} → {inst_1 : Semiring A} → [self : Algebra R A] → SMul R A
```

Fully explicit type:

```lean
{R : Type u} →
  {A : Type v} →
    {inst : CommSemiring.{u} R} → {inst_1 : Semiring.{v} A} → [self : @Algebra.{u, v} R A inst inst_1] → SMul.{u, v} R A
```

Definition body (one-level semantic boundary):

```lean
fun R A {inst} {inst_1} [self : Algebra R A] => self.1
```

### D006: `And`

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

### D007: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bcda2e78d6b7602d359ab954baf5c3bd0f6b2503b3ec9a72e1a21a48b9d18d89`

Type:

```lean
{R : Type u} → [self : CommSemiring R] → Semiring R
```

Fully explicit type:

```lean
{R : Type u} → [self : CommSemiring.{u} R] → Semiring.{u} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : CommSemiring R] => self.1
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

### D009: `Eq`

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

### D010: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

Fully explicit type:

```lean
(n : Nat) → Type
```

### D011: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Type:

```lean
(n : Nat) → Fintype (Fin n)
```

Fully explicit type:

```lean
(n : Nat) → Fintype.{0} (Fin n)
```

Definition body (one-level semantic boundary):

```lean
fun n => { elems := { val := Multiset.ofList (List.finRange n), nodup := ⋯ }, complete := ⋯ }
```

### D012: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0cc1e812ed29ffd61aa88cc157fd57b24a4728a006314eec34a80ac32a5f63`

Type:

```lean
{ι : Type u_1} → {M : Type u_2} → {α : Type u_7} → [SMul M α] → SMul M (ι → α)
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : Type u_2} → {α : Type u_7} → [SMul.{u_2, u_7} M α] → SMul.{u_2, max u_1 u_7} M (ι → α)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} {α} [SMul M α] => Pi.instSMul
```

### D013: `HDiv.hDiv`

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

### D014: `HSMul.hSMul`

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

### D015: `LT.lt`

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

### D016: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `715de3f0bd9e7bcf034726e1efbf1b4dad42a16e2ce790d4403774d16ed5b549`

Type:

```lean
{m : Type u_2} →
  {n : Type u_3} → {α : Type v} → [NonUnitalNonAssocSemiring α] → [Fintype n] → Matrix m n α → (n → α) → m → α
```

Fully explicit type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {α : Type v} →
      [NonUnitalNonAssocSemiring.{v} α] → [Fintype.{u_3} n] → (M : Matrix.{u_2, u_3, v} m n α) → (v : n → α) → m → α
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {α} [NonUnitalNonAssocSemiring α] [Fintype n] M v x =>
  have i := x;
  dotProduct (fun j => M i j) v
```

### D017: `Nat`

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

### D018: `Ne`

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

### D019: `Neg.neg`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D020: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Type:

```lean
{α : Type u} → [self : NonUnitalCommRing α] → NonUnitalNonAssocCommRing α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalCommRing.{u} α] → NonUnitalNonAssocCommRing.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalNonAssocRing := self.toNonUnitalNonAssocRing, mul_comm := ⋯ }
```

### D021: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing α] → NonUnitalNonAssocRing α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing.{u} α] → NonUnitalNonAssocRing.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocCommRing α] => self.1
```

### D022: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocRing α] → NonUnitalNonAssocSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocRing.{u} α] → NonUnitalNonAssocSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toAddMonoid := self.toAddMonoid, add_comm := ⋯, toMul := self.toMul, left_distrib := ⋯, right_distrib := ⋯,
    zero_mul := ⋯, mul_zero := ⋯ }
```

### D023: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing α] → NonUnitalCommRing α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing.{u_5} α] → NonUnitalCommRing.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalRing := self.toNonUnitalRing, mul_comm := ⋯ }
```

### D024: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → NonUnitalNormedCommRing α
```

Fully explicit type:

```lean
{α : Type u_2} → [β : NormedCommRing.{u_2} α] → NonUnitalNormedCommRing.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toMetricSpace := β.toMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D025: `OfNat.ofNat`

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

### D026: `Pi.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `eb5c70d9b813d7099537e8db11f59a65a3f5ad951da7314a1aa554471a122049`

Type:

```lean
{ι : Type u_1} → {M : ι → Type u_5} → [(i : ι) → Zero (M i)] → Zero ((i : ι) → M i)
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : ι → Type u_5} → [(i : ι) → Zero.{u_5} (M i)] → Zero.{max u_1 u_5} ((i : ι) → M i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [(i : ι) → Zero (M i)] => { zero := fun x => 0 }
```

### D027: `Real`

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

### D028: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `092dfdf642984bd4a336b502f7ac3f87adafd02a6236ba9033e90c0e1439ca7d`

Type:

```lean
CommSemiring Real
```

Fully explicit type:

```lean
CommSemiring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D029: `Real.instDivInvMonoid`

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

### D030: `Real.instLT`

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

### D031: `Real.instNeg`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D032: `Real.instZero`

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

### D033: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Type:

```lean
NormedCommRing Real
```

Fully explicit type:

```lean
NormedCommRing.{0} Real
```

Definition body (one-level semantic boundary):

```lean
let __src := Real.normedAddCommGroup;
let __src_1 := Real.commRing;
{ toNorm := __src.toNorm, toAddMonoid := __src.toAddMonoid, add_comm := Real.normedCommRing._proof_1,
  toMul := __src_1.toMul, left_distrib := Real.normedCommRing._proof_2, right_distrib := Real.normedCommRing._proof_3,
  zero_mul := Real.normedCommRing._proof_4, mul_zero := Real.normedCommRing._proof_5,
  mul_assoc := Real.normedCommRing._proof_6, toOne := __src_1.toOne, one_mul := Real.normedCommRing._proof_7,
  mul_one := Real.normedCommRing._proof_8, toNatCast := __src_1.toNatCast, natCast_zero := Real.normedCommRing._proof_9,
  natCast_succ := Real.normedCommRing._proof_10, npow := __src_1.npow, npow_zero := Real.normedCommRing._proof_11,
  npow_succ := Real.normedCommRing._proof_12, toNeg := __src.toNeg, toSub := __src.toSub,
  sub_eq_add_neg := Real.normedCommRing._proof_13, zsmul := __src.zsmul, zsmul_zero' := Real.normedCommRing._proof_14,
  zsmul_succ' := Real.normedCommRing._proof_15, zsmul_neg' := Real.normedCommRing._proof_16,
  neg_add_cancel := Real.normedCommRing._proof_17, toIntCast := __src_1.toIntCast,
  intCast_ofNat := Real.normedCommRing._proof_18, intCast_negSucc := Real.normedCommRing._proof_19,
  toMetricSpace := __src.toMetricSpace, dist_eq := ⋯, norm_mul_le := Real.normedCommRing._proof_20, mul_comm := ⋯ }
```

### D034: `Real.sqrt`

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

### D035: `Zero.toOfNat0`

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

### D036: `instHDiv`

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

### D037: `instHSMul`

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

### D038: `instOfNatNat`

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

### D039: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D040: `Equiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Equiv.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `d7f2b85e220b17e17ce92ad10d5015da5d4751cd914568e619a1f288341c64e3`

Type:

```lean
Sort u_1 → Sort u_2 → Sort (max (max 1 u_1) u_2)
```

Fully explicit type:

```lean
(α : Sort u_1) → (β : Sort u_2) → Sort (max (max 1 u_1) u_2)
```

### D041: `Equiv.instEquivLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Equiv.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D042: `EquivLike.toFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Equiv`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D043: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D044: `Inv.inv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `c3aea3c6e2edd31a7b2cf071814315808ef7d84fd01d8c9b719313846ebca438`

Type:

```lean
{α : Type u} → [self : Inv α] → α → α
```

Fully explicit type:

```lean
{α : Type u} → [self : Inv.{u} α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Inv α] => self.1
```

### D045: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Type:

```lean
Type u → Type u' → Type v → Type (max u u' v)
```

Fully explicit type:

```lean
(m : Type u) → (n : Type u') → (α : Type v) → Type (max u u' v)
```

Definition body (one-level semantic boundary):

```lean
fun m n α => m → n → α
```

### D046: `Matrix.of`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `2fd11c1f258b666a5be58a830ae21c93bc674ab3014a8a722530d141dddb3638`

Type:

```lean
{m : Type u_2} → {n : Type u_3} → {α : Type v} → Equiv (m → n → α) (Matrix m n α)
```

Fully explicit type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {α : Type v} →
      Equiv.{max (max (u_2 + 1) (u_3 + 1)) (v + 1), max (max (v + 1) (u_3 + 1)) (u_2 + 1)} (m → n → α)
        (Matrix.{u_2, u_3, v} m n α)
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {α} => Equiv.refl (m → n → α)
```

### D047: `Matrix.vecCons`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fin.VecNotation`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6d598529744fc7ed189026f2f83ca39c93930021427c51096eca547bc6750a25`

Type:

```lean
{α : Type u} → {n : Nat} → α → (Fin n → α) → Fin n.succ → α
```

Fully explicit type:

```lean
{α : Type u} → {n : Nat} → (h : α) → (t : Fin n → α) → Fin (Nat.succ n) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {n} h t => Fin.cons h t
```

### D048: `Matrix.vecEmpty`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fin.VecNotation`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `43307adb40ece2d70b6319d8e8f7f5551cf96af32e64c2288a2ca8610f456de1`

Type:

```lean
{α : Type u} → Fin 0 → α
```

Fully explicit type:

```lean
{α : Type u} → Fin (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} => Fin.elim0
```

### D049: `One.toOfNat1`

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

### D050: `Real.instInv`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `8996fd673a1e2289aaf761085a60a161bdafebda8cdd48d1efb3c89da1382980`

Type:

```lean
Inv Real
```

Fully explicit type:

```lean
Inv.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ inv := Real.inv'✝ }
```

### D051: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D052: `Real.instOne`

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

### D053: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

## Complete local imported sources

### `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`

Path: `NumStability/Analysis/PartialDifferentialEquations/ConstantCoefficientLinearSystem.lean`
SHA-256: `8e30275f872bc75df1944834277a7bfaa78b63ff1d0cb4fc617a22b8fb4d2526`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Data.Matrix.Basic

/-!
# Constant-coefficient first-order linear systems

Source-independent pointwise solution predicates for systems of the form
`q_t + A q_x = 0`, together with the canonical one-component matrix and state
used to recover scalar linear advection.
-/

namespace NumStability

/-- A function satisfies the constant-coefficient first-order system
`q_t + A q_x = 0` at a point. -/
def IsConstantCoefficientLinearSystemSolutionAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ)) (coefficient : Matrix ι ι ℝ)
    (x t : ℝ) : Prop :=
  ∃ qt qx : ι → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + coefficient.mulVec qx = 0

/-- A space-time state together with a proof that it solves one fixed
constant-coefficient linear system at every point. -/
structure ConstantCoefficientLinearSystemSolution
    {ι : Type*} [Fintype ι] (coefficient : Matrix ι ι ℝ) where
  state : ℝ → ℝ → (ι → ℝ)
  satisfies : ∀ x t,
    IsConstantCoefficientLinearSystemSolutionAt state coefficient x t

/-- The one-by-one matrix whose only coefficient is `speed`. -/
def constantCoefficientScalarMatrix (speed : ℝ) : Matrix (Fin 1) (Fin 1) ℝ :=
  fun _ _ => speed

/-- Regard a scalar space-time field as a one-component system state. -/
def scalarAsOneComponentSystem
    (q : ℝ → ℝ → ℝ) : ℝ → ℝ → (Fin 1 → ℝ) :=
  fun x t _ => q x t

end NumStability
```

### `NumStability.Source.LeVeque.Chapter01.Equation01`

Path: `NumStability/Source/LeVeque/Chapter01/Equation01.lean`
SHA-256: `bf433cf8ca84ad036a62f95a905663d4e218e0ada695211f3e2eb56d74f61188`

```lean
/-
SPDX-License-Identifier: MIT
-/

import NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem

/-!
# LeVeque Chapter 1, Equation (1.1)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 1 (raw PDF page 23), equation (1.1).
-/

namespace NumStability

/-- Equation (1.1): a real `m`-component field satisfies
`q_t + A q_x = 0` at `(x, t)` for a constant real `m`-by-`m` matrix `A`. -/
abbrev leveque01_equation01_constantLinearSystemAt
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (x t : ℝ) : Prop :=
  IsConstantCoefficientLinearSystemSolutionAt q coefficient x t

/-- The pointwise predicate for equation (1.1), expanded into its time
derivative, space derivative, and zero-residual clauses. -/
theorem leveque01_equation01_constantLinearSystemAt_iff
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (x t : ℝ) :
    leveque01_equation01_constantLinearSystemAt q coefficient x t ↔
      ∃ qt qx : Fin m → ℝ,
        HasDerivAt (fun τ => q x τ) qt t ∧
          HasDerivAt (fun ξ => q ξ t) qx x ∧
            qt + coefficient.mulVec qx = 0 :=
  Iff.rfl

/-- Equation (1.1): every proof-carrying constant-coefficient system asserts
the displayed PDE globally on `ℝ × ℝ`. This theorem is deliberately not a
definitional `P ↔ P`: its conclusion is the equation required of the system's
unknown state. -/
theorem leveque01_equation01_constantLinearSystem
    {m : ℕ} {coefficient : Matrix (Fin m) (Fin m) ℝ}
    (system : ConstantCoefficientLinearSystemSolution coefficient) :
    ∀ x t, ∃ qt qx : Fin m → ℝ,
      HasDerivAt (fun τ => system.state x τ) qt t ∧
        HasDerivAt (fun ξ => system.state ξ t) qx x ∧
          qt + coefficient.mulVec qx = 0 := by
  intro x t
  exact system.satisfies x t

end NumStability
```

### `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection`

Path: `NumStability/Analysis/PartialDifferentialEquations/LinearAdvection.lean`
SHA-256: `c81a4b5ce8d9936d51f9aae7a02bc34db770b4d7213ac8c6581f5b577d11efe2`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Constant-coefficient linear advection

Source-independent local solution predicates and traveling-wave solutions for
`q_t + a q_x = 0`, for profiles valued in a real normed vector space.
-/

namespace NumStability

/-- A profile translated at constant speed. -/
def travelingWave {E : Type*} (profile : ℝ → E) (speed x t : ℝ) : E :=
  profile (x - speed * t)

/-- The translated profile agrees with the original profile at time zero. -/
@[simp] theorem travelingWave_zero {E : Type*}
    (profile : ℝ → E) (speed x : ℝ) :
    travelingWave profile speed x 0 = profile x := by
  simp [travelingWave]

/-- The value initially at `x` is at `x + speed * t` at time `t`. -/
theorem travelingWave_at_translated_point {E : Type*}
    (profile : ℝ → E) (speed x t : ℝ) :
    travelingWave profile speed (x + speed * t) t = profile x := by
  simp [travelingWave]

section LinearAdvection

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- A function satisfies `q_t + speed q_x = 0` at a point. -/
def IsLinearAdvectionSolutionAt
    (q : ℝ → ℝ → E) (speed x t : ℝ) : Prop :=
  ∃ qt qx : E,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + speed • qx = 0

/-- Every differentiable translated profile solves linear advection at the
corresponding point. -/
theorem travelingWave_isLinearAdvectionSolutionAt
    {profile : ℝ → E} {profile' : E} (speed x t : ℝ)
    (hprofile : HasDerivAt profile profile' (x - speed * t)) :
    IsLinearAdvectionSolutionAt
      (travelingWave profile speed) speed x t := by
  refine ⟨(-speed) • profile', profile', ?_, ?_, ?_⟩
  · have ht : HasDerivAt (fun τ : ℝ => x - speed * τ) (-speed) t := by
      simpa using
        (hasDerivAt_const t x).sub ((hasDerivAt_id t).const_mul speed)
    simpa [travelingWave, Function.comp_def] using hprofile.scomp t ht
  · have hx : HasDerivAt (fun ξ : ℝ => ξ - speed * t) 1 x := by
      simpa using (hasDerivAt_id x).sub_const (speed * t)
    simpa [travelingWave, Function.comp_def] using hprofile.scomp x hx
  · simp

end LinearAdvection

end NumStability
```

### `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`

Path: `NumStability/Analysis/PartialDifferentialEquations/LinearAcoustics.lean`
SHA-256: `640863d597faf04d52966cfd27f8d7732373c9c9d5c216a87308d5345da9d8b3`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.LinearAlgebra.Matrix.Notation
import NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import NumStability.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# One-dimensional linear acoustics

Source-independent pointwise and global solution data for the constant
coefficient pressure--velocity system, together with its two-component matrix
representation.
-/

namespace NumStability

/-- Pressure and particle velocity satisfy the one-dimensional linear
acoustics system at `(x,t)`. -/
def IsLinearAcousticsSolutionAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) : Prop :=
  ∃ pt px ut ux : ℝ,
    HasDerivAt (fun τ => pressure x τ) pt t ∧
      HasDerivAt (fun ξ => pressure ξ t) px x ∧
        HasDerivAt (fun τ => velocity x τ) ut t ∧
          HasDerivAt (fun ξ => velocity ξ t) ux x ∧
            pt + bulkModulus * ux = 0 ∧
              ut + density⁻¹ * px = 0

/-- A pressure--velocity field together with a global proof of the linear
acoustics equations for fixed material coefficients. -/
structure LinearAcousticsSolution (bulkModulus density : ℝ) where
  density_ne_zero : density ≠ 0
  pressure : ℝ → ℝ → ℝ
  velocity : ℝ → ℝ → ℝ
  satisfies : ∀ x t,
    IsLinearAcousticsSolutionAt pressure velocity bulkModulus density x t

/-- Package pressure and velocity as the two-component acoustics state. -/
def linearAcousticsState
    (pressure velocity : ℝ → ℝ → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  fun x t => ![pressure x t, velocity x t]

/-- The constant coefficient matrix of the one-dimensional linear acoustics
system. -/
noncomputable def linearAcousticsMatrix
    (bulkModulus density : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![(0 : ℝ), bulkModulus; density⁻¹, 0]

/-- The right-going characteristic combination of pressure and velocity. -/
def linearAcousticsRightInvariant
    (pressure velocity : ℝ → ℝ → ℝ) (density soundSpeed : ℝ) :
    ℝ → ℝ → ℝ :=
  fun x t => pressure x t + density * soundSpeed * velocity x t

/-- The left-going characteristic combination of pressure and velocity. -/
def linearAcousticsLeftInvariant
    (pressure velocity : ℝ → ℝ → ℝ) (density soundSpeed : ℝ) :
    ℝ → ℝ → ℝ :=
  fun x t => pressure x t - density * soundSpeed * velocity x t

/-- A right eigenvector of the acoustics matrix when `K = ρ c²`. -/
def linearAcousticsRightEigenvector
    (density soundSpeed : ℝ) : Fin 2 → ℝ :=
  ![density * soundSpeed, 1]

/-- A left eigenvector of the acoustics matrix when `K = ρ c²`. -/
def linearAcousticsLeftEigenvector
    (density soundSpeed : ℝ) : Fin 2 → ℝ :=
  ![-density * soundSpeed, 1]

/-- The right acoustics vector has eigenvalue `c`. -/
theorem linearAcousticsMatrix_mulVec_rightEigenvector
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    (linearAcousticsMatrix bulkModulus density).mulVec
        (linearAcousticsRightEigenvector density soundSpeed) =
      soundSpeed • linearAcousticsRightEigenvector density soundSpeed := by
  funext i
  fin_cases i <;>
    simp [linearAcousticsMatrix, linearAcousticsRightEigenvector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_two, hmaterial, hdensity];
    ring

/-- The left acoustics vector has eigenvalue `-c`. -/
theorem linearAcousticsMatrix_mulVec_leftEigenvector
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    (linearAcousticsMatrix bulkModulus density).mulVec
        (linearAcousticsLeftEigenvector density soundSpeed) =
      (-soundSpeed) • linearAcousticsLeftEigenvector density soundSpeed := by
  funext i
  fin_cases i <;>
    simp [linearAcousticsMatrix, linearAcousticsLeftEigenvector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_two, hmaterial, hdensity];
    ring

/-- The right characteristic combination satisfies scalar advection at the
positive acoustic speed whenever `K = ρ c²`. -/
theorem linearAcousticsRightInvariant_isLinearAdvectionSolutionAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density soundSpeed x t : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2)
    (hsystem : IsLinearAcousticsSolutionAt
      pressure velocity bulkModulus density x t) :
    IsLinearAdvectionSolutionAt
      (linearAcousticsRightInvariant pressure velocity density soundSpeed)
      soundSpeed x t := by
  rcases hsystem with
    ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
  refine ⟨pt + density * soundSpeed * ut,
    px + density * soundSpeed * ux, ?_, ?_, ?_⟩
  · simpa [linearAcousticsRightInvariant, mul_assoc] using
      hpt.add (hut.const_mul (density * soundSpeed))
  · simpa [linearAcousticsRightInvariant, mul_assoc] using
      hpx.add (hux.const_mul (density * soundSpeed))
  · rw [hmaterial] at hpressure
    field_simp [hdensity] at hvelocity
    dsimp
    calc
      pt + density * soundSpeed * ut +
          soundSpeed * (px + density * soundSpeed * ux) =
        (pt + density * soundSpeed ^ 2 * ux) +
          soundSpeed * (ut * density + px) := by ring
      _ = 0 := by rw [hpressure, hvelocity]; ring

/-- The left characteristic combination satisfies scalar advection at speed
`-c` whenever `K = ρ c²`. -/
theorem linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density soundSpeed x t : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2)
    (hsystem : IsLinearAcousticsSolutionAt
      pressure velocity bulkModulus density x t) :
    IsLinearAdvectionSolutionAt
      (linearAcousticsLeftInvariant pressure velocity density soundSpeed)
      (-soundSpeed) x t := by
  rcases hsystem with
    ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
  refine ⟨pt - density * soundSpeed * ut,
    px - density * soundSpeed * ux, ?_, ?_, ?_⟩
  · simpa [linearAcousticsLeftInvariant, mul_assoc] using
      hpt.sub (hut.const_mul (density * soundSpeed))
  · simpa [linearAcousticsLeftInvariant, mul_assoc] using
      hpx.sub (hux.const_mul (density * soundSpeed))
  · rw [hmaterial] at hpressure
    field_simp [hdensity] at hvelocity
    dsimp
    calc
      pt - density * soundSpeed * ut +
          -soundSpeed * (px - density * soundSpeed * ux) =
        (pt + density * soundSpeed ^ 2 * ux) -
          soundSpeed * (ut * density + px) := by ring
      _ = 0 := by rw [hpressure, hvelocity]; ring

/-- The two scalar acoustics equations are exactly their two-component
constant-matrix system representation. -/
theorem linearAcoustics_matrixForm_iff
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) :
    IsConstantCoefficientLinearSystemSolutionAt
        (linearAcousticsState pressure velocity)
        (linearAcousticsMatrix bulkModulus density) x t ↔
      IsLinearAcousticsSolutionAt
        pressure velocity bulkModulus density x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    refine ⟨qt 0, qx 0, qt 1, qx 1, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp ht 0)
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp hx 0)
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp ht 1)
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp hx 1)
    · have hcomponent := congrFun hresidual (0 : Fin 2)
      simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two] using hcomponent
    · have hcomponent := congrFun hresidual (1 : Fin 2)
      simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two] using hcomponent
  · rintro ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
    refine ⟨![pt, ut], ![px, ux], ?_, ?_, ?_⟩
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · simpa [linearAcousticsState] using hpt
      · simpa [linearAcousticsState] using hut
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · simpa [linearAcousticsState] using hpx
      · simpa [linearAcousticsState] using hux
    · funext i
      fin_cases i
      · simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two, mul_comm] using hpressure
      · simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two, mul_comm] using hvelocity

end NumStability
```

### `NumStability.Source.LeVeque.Chapter01.Equation05`

Path: `NumStability/Source/LeVeque/Chapter01/Equation05.lean`
SHA-256: `426c914d7a53540185a3fa66a2e319285db30d9eaf81a8da28ee21b5ca0bf67b`

```lean
/-
SPDX-License-Identifier: MIT
-/

import NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# LeVeque Chapter 1, Equation (1.5)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), equation (1.5).
-/

namespace NumStability

/-- Equation (1.5), as a pointwise pressure--velocity residual. -/
abbrev leveque01_equation05_linearAcousticsAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) : Prop :=
  IsLinearAcousticsSolutionAt
    pressure velocity bulkModulus density x t

/-- Equation (1.5): a proof-carrying acoustic field has nonzero density and
satisfies both displayed equations globally. -/
theorem leveque01_equation05_linearAcoustics
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density) :
    density ≠ 0 ∧
      ∀ x t, ∃ pt px ut ux : ℝ,
        HasDerivAt (fun τ => system.pressure x τ) pt t ∧
          HasDerivAt (fun ξ => system.pressure ξ t) px x ∧
            HasDerivAt (fun τ => system.velocity x τ) ut t ∧
              HasDerivAt (fun ξ => system.velocity ξ t) ux x ∧
                pt + bulkModulus * ux = 0 ∧
                  ut + density⁻¹ * px = 0 := by
  refine ⟨system.density_ne_zero, ?_⟩
  intro x t
  exact system.satisfies x t

end NumStability
```

### `NumStability.Source.LeVeque.Chapter01.Equation06`

Path: `NumStability/Source/LeVeque/Chapter01/Equation06.lean`
SHA-256: `36551fdb0f45d1138ef4133a5c14e662e59999428c5098d3f603aa935e49ba9f`

```lean
/-
SPDX-License-Identifier: MIT
-/

import NumStability.Source.LeVeque.Chapter01.Equation01
import NumStability.Source.LeVeque.Chapter01.Equation05

/-!
# LeVeque Chapter 1, Equation (1.6)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), equations (1.5)--(1.6).
-/

namespace NumStability

/-- Equation (1.6): the pressure--velocity equations (1.5) are exactly the
constant-coefficient system with state `(p,u)` and matrix
`[[0,K],[1/ρ,0]]`. -/
theorem leveque01_equation06_acousticsMatrixForm
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) (_hdensity : density ≠ 0) :
    leveque01_equation01_constantLinearSystemAt
        (linearAcousticsState pressure velocity)
        (linearAcousticsMatrix bulkModulus density) x t ↔
      leveque01_equation05_linearAcousticsAt
        pressure velocity bulkModulus density x t :=
  linearAcoustics_matrixForm_iff
    pressure velocity bulkModulus density x t

end NumStability
```
