# Declaration dossier for LEV-CH01-RIEMANN-INTERFACE-FLUX

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_riemannInterfaceFlux
    {m : ℕ} (cellAverages : ℤ → (Fin m → ℝ))
    (valueAtOrigin : Fin m → ℝ)
    (riemannFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ))
    (i : ℤ) :
    leveque01Equation11RiemannData
        (adjacentCellRiemannData cellAverages valueAtOrigin i)
        (cellAverages (i - 1)) (cellAverages i) ∧
      riemannInterfaceFlux riemannFlux cellAverages i =
        riemannFlux (cellAverages (i - 1)) (cellAverages i)
```

## Elaborated target type

```lean
∀ {m : Nat} (cellAverages : Int → Fin m → Real) (valueAtOrigin : Fin m → Real)
  (riemannFlux : (Fin m → Real) → (Fin m → Real) → Fin m → Real) (i : Int),
  And
    (NumStability.leveque01Equation11RiemannData (NumStability.adjacentCellRiemannData cellAverages valueAtOrigin i)
      (cellAverages (instHSub.hSub i 1)) (cellAverages i))
    (Eq (NumStability.riemannInterfaceFlux riemannFlux cellAverages i)
      (riemannFlux (cellAverages (instHSub.hSub i 1)) (cellAverages i)))
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} (cellAverages : Int → Fin m → Real) (valueAtOrigin : Fin m → Real)
  (riemannFlux : (Fin m → Real) → (Fin m → Real) → Fin m → Real) (i : Int),
  And
    (@NumStability.leveque01Equation11RiemannData m
      (@NumStability.adjacentCellRiemannData.{0} (Fin m → Real) cellAverages valueAtOrigin i)
      (cellAverages
        (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
          (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
      (cellAverages i))
    (@Eq.{1} (Fin m → Real)
      (@NumStability.riemannInterfaceFlux.{0, 0} (Fin m → Real) (Fin m → Real) riemannFlux cellAverages i)
      (riemannFlux
        (cellAverages
          (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
            (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
        (cellAverages i)))
```

## Local import graph

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `NumStability.Source.LeVeque.Chapter01.Equation11`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `NumStability.Source.LeVeque.Chapter01.Equation11` imports: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.adjacentCellRiemannData`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `521570cd17b2211c2961b02e506645aa669796f4385b5f1fbc0ee66caab7025a`

Type:

```lean
{State : Type u_1} → (Int → State) → State → Int → Real → State
```

Fully explicit type:

```lean
{State : Type u_1} → (cellAverages : Int → State) → (valueAtOrigin : State) → (i : Int) → Real → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} cellAverages valueAtOrigin i =>
  NumStability.riemannData (cellAverages (instHSub.hSub i 1)) valueAtOrigin (cellAverages i)
```

### D002: `NumStability.leveque01Equation11RiemannData`

- Role: `local`
- Owner module: `NumStability.Source.LeVeque.Chapter01.Equation11`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `b978b1cc10be2f972be9fb6e49823139cd6e2661461c71d413daa940c16f399d`

Type:

```lean
{m : Nat} → (Real → Fin m → Real) → (Fin m → Real) → (Fin m → Real) → Prop
```

Fully explicit type:

```lean
{m : Nat} → (initialState : Real → Fin m → Real) → (leftState rightState : Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} initialState leftState rightState => NumStability.IsRiemannData initialState leftState rightState
```

### D003: `NumStability.riemannInterfaceFlux`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b736d1cc2312c3ff74241fa80b8df12f1da6d3b04bd23e7850d9e70a3300fc09`

Type:

```lean
{State : Type u_1} → {Flux : Type u_2} → (State → State → Flux) → (Int → State) → Int → Flux
```

Fully explicit type:

```lean
{State : Type u_1} →
  {Flux : Type u_2} → (riemannFlux : State → State → Flux) → (cellAverages : Int → State) → (i : Int) → Flux
```

Definition body (one-level semantic boundary):

```lean
fun {State} {Flux} riemannFlux cellAverages i => riemannFlux (cellAverages (instHSub.hSub i 1)) (cellAverages i)
```

### D004: `NumStability.IsRiemannData`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `58b9dfa376d4406a8d4dc526e48a9f62b8f14ef7da7e393be3aae2a0d1ead02a`

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

### D005: `NumStability.riemannData`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `fb57c54bf2e75c766e17efb76800f3dfb03b090dd84815b2084d7a10d5f48b36`

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

### D008: `Fin`

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

### D009: `HSub.hSub`

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

### D010: `Int`

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

### D011: `Int.instSub`

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

### D012: `Nat`

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

### D013: `OfNat.ofNat`

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

### D014: `Real`

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

### D015: `instHSub`

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

### D016: `instOfNat`

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

### D017: `LT.lt`

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

### D018: `Real.decidableLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D019: `Real.instLT`

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

### D020: `Real.instZero`

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

### D021: `Zero.toOfNat0`

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

### D022: `ite`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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
