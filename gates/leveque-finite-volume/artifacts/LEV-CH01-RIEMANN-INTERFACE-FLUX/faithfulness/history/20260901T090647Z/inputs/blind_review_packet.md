# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
∀ {m : Nat} {Information : Type u_1} (data : LocalDef002 m Information),
  Iff (LocalDef001 data)
    (And (Real.instLT.lt 0 data.fluxScale)
      (And
        (Or (Eq data.method.solverMode LocalDef015)
          (Eq data.method.solverMode LocalDef014))
        (And
          (∀ (i : Int),
            LocalDef018
              (LocalDef016 data.cellAverages (data.valueAtOrigin i) i)
              (data.cellAverages (instHSub.hSub i 1)) (data.cellAverages i))
          (And
            (∀ (i : Int),
              data.method.isSuitableSolverInformation data.method.solverMode (data.cellAverages (instHSub.hSub i 1))
                (data.cellAverages i) (data.method.solve (data.cellAverages (instHSub.hSub i 1)) (data.cellAverages i)))
            (And
              (∀ (i : Int),
                data.method.isPhysicalFluxApproximation (data.cellAverages (instHSub.hSub i 1)) (data.cellAverages i)
                  (data.method.fluxFromInformation
                    (data.method.solve (data.cellAverages (instHSub.hSub i 1)) (data.cellAverages i))))
              (∀ (i : Int),
                Eq (data.updatedCellAverages i)
                  (LocalDef017 data.fluxScale data.cellAverages
                    (fun j =>
                      data.method.fluxFromInformation
                        (data.method.solve (data.cellAverages (instHSub.hSub j 1)) (data.cellAverages j)))
                    i)))))))
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} {Information : Type u_1} (data : LocalDef002.{u_1} m Information),
  Iff (@LocalDef001.{u_1} m Information data)
    (And
      (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
        (@LocalDef004.{u_1} m Information data))
      (And
        (Or
          (@Eq.{1} LocalDef013
            (@LocalDef012.{0, u_1, 0} (Fin m → Real) Information (Fin m → Real)
              (@LocalDef005.{u_1} m Information data))
            LocalDef015)
          (@Eq.{1} LocalDef013
            (@LocalDef012.{0, u_1, 0} (Fin m → Real) Information (Fin m → Real)
              (@LocalDef005.{u_1} m Information data))
            LocalDef014))
        (And
          (∀ (i : Int),
            @LocalDef018 m
              (@LocalDef016.{0} (Fin m → Real)
                (@LocalDef003.{u_1} m Information data)
                (@LocalDef007.{u_1} m Information data i) i)
              (@LocalDef003.{u_1} m Information data
                (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                  (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
              (@LocalDef003.{u_1} m Information data i))
          (And
            (∀ (i : Int),
              @LocalDef010.{0, u_1, 0} (Fin m → Real)
                Information (Fin m → Real)
                (@LocalDef005.{u_1} m Information data)
                (@LocalDef012.{0, u_1, 0} (Fin m → Real) Information
                  (Fin m → Real) (@LocalDef005.{u_1} m Information data))
                (@LocalDef003.{u_1} m Information data
                  (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                (@LocalDef003.{u_1} m Information data i)
                (@LocalDef011.{0, u_1, 0} (Fin m → Real) Information (Fin m → Real)
                  (@LocalDef005.{u_1} m Information data)
                  (@LocalDef003.{u_1} m Information data
                    (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                      (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                  (@LocalDef003.{u_1} m Information data i)))
            (And
              (∀ (i : Int),
                @LocalDef009.{0, u_1, 0} (Fin m → Real)
                  Information (Fin m → Real)
                  (@LocalDef005.{u_1} m Information data)
                  (@LocalDef003.{u_1} m Information data
                    (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                      (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                  (@LocalDef003.{u_1} m Information data i)
                  (@LocalDef008.{0, u_1, 0} (Fin m → Real) Information
                    (Fin m → Real) (@LocalDef005.{u_1} m Information data)
                    (@LocalDef011.{0, u_1, 0} (Fin m → Real) Information
                      (Fin m → Real) (@LocalDef005.{u_1} m Information data)
                      (@LocalDef003.{u_1} m Information data
                        (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                          (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                      (@LocalDef003.{u_1} m Information data i))))
              (∀ (i : Int),
                @Eq.{1} (Fin m → Real)
                  (@LocalDef006.{u_1} m Information data i)
                  (@LocalDef017.{0} (Fin m → Real)
                    (@Pi.addCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommGroup)
                    (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring
                      (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                        (@NonUnitalSemiring.toNonUnitalNonAssocSemiring.{0} Real
                          (@Semiring.toNonUnitalSemiring.{0} Real (@Ring.toSemiring.{0} Real Real.instRing))))
                      (@Semiring.toModule.{0} Real Real.semiring))
                    (@LocalDef004.{u_1} m Information data)
                    (@LocalDef003.{u_1} m Information data)
                    (fun (j : Int) =>
                      @LocalDef008.{0, u_1, 0} (Fin m → Real)
                        Information (Fin m → Real)
                        (@LocalDef005.{u_1} m Information data)
                        (@LocalDef011.{0, u_1, 0} (Fin m → Real) Information
                          (Fin m → Real)
                          (@LocalDef005.{u_1} m Information data)
                          (@LocalDef003.{u_1} m Information data
                            (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) j
                              (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                          (@LocalDef003.{u_1} m Information data j)))
                    i)))))))
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b3e8fcdb7c6f2adba13597e33d4e096fdc675e82cbf91eaf5bce334b8ec3d566`

Type:

```lean
{m : Nat} → {Information : Type u_1} → LocalDef002 m Information → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} {Information} data =>
  And (Real.instLT.lt 0 data.fluxScale)
    (And
      (Or (Eq data.method.solverMode LocalDef015)
        (Eq data.method.solverMode LocalDef014))
      (And
        (∀ (i : Int),
          LocalDef018
            (LocalDef016 data.cellAverages (data.valueAtOrigin i) i)
            (data.cellAverages (instHSub.hSub i 1)) (data.cellAverages i))
        (And
          (∀ (i : Int),
            data.method.isSuitableSolverInformation data.method.solverMode (data.cellAverages (instHSub.hSub i 1))
              (data.cellAverages i) (data.method.solve (data.cellAverages (instHSub.hSub i 1)) (data.cellAverages i)))
          (And
            (∀ (i : Int),
              data.method.isPhysicalFluxApproximation (data.cellAverages (instHSub.hSub i 1)) (data.cellAverages i)
                (data.method.fluxFromInformation
                  (data.method.solve (data.cellAverages (instHSub.hSub i 1)) (data.cellAverages i))))
            (∀ (i : Int),
              Eq (data.updatedCellAverages i)
                (LocalDef017 data.fluxScale data.cellAverages
                  (fun j =>
                    data.method.fluxFromInformation
                      (data.method.solve (data.cellAverages (instHSub.hSub j 1)) (data.cellAverages j)))
                  i))))))
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `4bf9a6a119dc3dedff63778e5220fd6afbec735020aeb22bca63a49c333a1e41`

Type:

```lean
Nat → Type u_1 → Type u_1
```

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e3824042a3723a8b38a0aae6c8265a4c18e760590afd842b40117e88427070e0`

Type:

```lean
{m : Nat} → {Information : Type u_1} → LocalDef002 m Information → Int → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m Information self => self.1
```

### D004: `LocalDef004`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7e29117930a0238cabd4f522c9d9780b5aaacfbd3c24f2892a3a4ff423445c2b`

Type:

```lean
{m : Nat} → {Information : Type u_1} → LocalDef002 m Information → Real
```

Definition body (one-level semantic boundary):

```lean
fun m Information self => self.4
```

### D005: `LocalDef005`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4ee6a7ca09c3858b5e11bedeccc09fd28ba1aee92b994cd1653f3d808a9a9a6f`

Type:

```lean
{m : Nat} →
  {Information : Type u_1} →
    LocalDef002 m Information →
      LocalDef021 (Fin m → Real) Information (Fin m → Real)
```

Definition body (one-level semantic boundary):

```lean
fun m Information self => self.3
```

### D006: `LocalDef006`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5dca35a523bfdd835731b9854fd2b1c169daac76d7944d20cdb58e4029ee3df9`

Type:

```lean
{m : Nat} → {Information : Type u_1} → LocalDef002 m Information → Int → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m Information self => self.5
```

### D007: `LocalDef007`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `2ac671f0f1f60e4321079437999e7029fcf14a74ca4d8cfb662fac681cf79f41`

Type:

```lean
{m : Nat} → {Information : Type u_1} → LocalDef002 m Information → Int → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m Information self => self.2
```

### D008: `LocalDef008`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `d95e0557f05d367c6e7550d4943f1b81c7ebaad84de5e0a78bd78893c06134c7`

Type:

```lean
{State : Type u_1} →
  {Information : Type u_2} →
    {Flux : Type u_3} → LocalDef021 State Information Flux → Information → Flux
```

Definition body (one-level semantic boundary):

```lean
fun State Information Flux self => self.3
```

### D009: `LocalDef009`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `3963ee712f147937847316c39efdd3ebbf1331269bb56b0ea03efe93701aa3fa`

Type:

```lean
{State : Type u_1} →
  {Information : Type u_2} →
    {Flux : Type u_3} → LocalDef021 State Information Flux → State → State → Flux → Prop
```

Definition body (one-level semantic boundary):

```lean
fun State Information Flux self => self.5
```

### D010: `LocalDef010`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `7e97c9e6e1e0193c5c79f4368b3bb0c14ebb1a3caa35feae23c455411feaf08e`

Type:

```lean
{State : Type u_1} →
  {Information : Type u_2} →
    {Flux : Type u_3} →
      LocalDef021 State Information Flux →
        LocalDef013 → State → State → Information → Prop
```

Definition body (one-level semantic boundary):

```lean
fun State Information Flux self => self.4
```

### D011: `LocalDef011`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9147c5d9eac64c2040658c241111c6e69985a310c52f710451b33f3696d0a553`

Type:

```lean
{State : Type u_1} →
  {Information : Type u_2} →
    {Flux : Type u_3} → LocalDef021 State Information Flux → State → State → Information
```

Definition body (one-level semantic boundary):

```lean
fun State Information Flux self => self.2
```

### D012: `LocalDef012`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5fc28f1f7976b3798926b2e6f372152a682f65e7d5a2a018ae9ba42db61e57c5`

Type:

```lean
{State : Type u_1} →
  {Information : Type u_2} →
    {Flux : Type u_3} → LocalDef021 State Information Flux → LocalDef013
```

Definition body (one-level semantic boundary):

```lean
fun State Information Flux self => self.1
```

### D013: `LocalDef013`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `8c94bc5953043e8350e77f416a3c19a3c9310a222364dea4abd74c9176930bc2`

Type:

```lean
Type
```

### D014: `LocalDef014`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `43f40aa1805250d7be6b318714dfac996df6079f9852ebd1ed6ac05df095fea3`

Type:

```lean
LocalDef013
```

### D015: `LocalDef015`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `b6a75bd7bc49b7aa1aa839b5fe374fabd32d1f8ce6e32cb52ef185fba742a9d8`

Type:

```lean
LocalDef013
```

### D016: `LocalDef016`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `521570cd17b2211c2961b02e506645aa669796f4385b5f1fbc0ee66caab7025a`

Type:

```lean
{State : Type u_1} → (Int → State) → State → Int → Real → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} cellAverages valueAtOrigin i =>
  LocalDef022 (cellAverages (instHSub.hSub i 1)) valueAtOrigin (cellAverages i)
```

### D017: `LocalDef017`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `790ab7035414f0cd156bde75a2a24deb32ab243371caadac108f16dbd6a4a554`

Type:

```lean
{E : Type u_1} → [inst : AddCommGroup E] → [Module Real E] → Real → (Int → E) → (Int → E) → Int → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [AddCommGroup E] [Module Real E] timeStepOverCellWidth cellAverages edgeFlux i =>
  instHSub.hSub (cellAverages i)
    (instHSMul.hSMul timeStepOverCellWidth (instHSub.hSub (edgeFlux (instHAdd.hAdd i 1)) (edgeFlux i)))
```

### D018: `LocalDef018`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `b978b1cc10be2f972be9fb6e49823139cd6e2661461c71d413daa940c16f399d`

Type:

```lean
{m : Nat} → (Real → Fin m → Real) → (Fin m → Real) → (Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} initialState leftState rightState => LocalDef019 initialState leftState rightState
```

### D019: `LocalDef019`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `58b9dfa376d4406a8d4dc526e48a9f62b8f14ef7da7e393be3aae2a0d1ead02a`

Type:

```lean
{State : Type u_1} → (Real → State) → State → State → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} data leftState rightState =>
  And (∀ (x : Real), Real.instLT.lt x 0 → Eq (data x) leftState)
    (∀ (x : Real), Real.instLT.lt 0 x → Eq (data x) rightState)
```

### D020: `LocalDef020`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `415260a929703fadff3382c0829eef9bd8f6e4eaf9c22e7554c51f6e8dbfba3e`

Type:

```lean
{m : Nat} →
  {Information : Type u_1} →
    (Int → Fin m → Real) →
      (Int → Fin m → Real) →
        LocalDef021 (Fin m → Real) Information (Fin m → Real) →
          Real → (Int → Fin m → Real) → LocalDef002 m Information
```

### D021: `LocalDef021`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `fabea8d63fd31331535c1cb203c60640cf8f171023e068e408c37e3a693e03ba`

Type:

```lean
Type u_1 → Type u_2 → Type u_3 → Type (max (max u_1 u_2) u_3)
```

### D022: `LocalDef022`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `fb57c54bf2e75c766e17efb76800f3dfb03b090dd84815b2084d7a10d5f48b36`

Type:

```lean
{State : Type u_1} → State → State → State → Real → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} leftState valueAtOrigin rightState x =>
  ite (Real.instLT.lt x 0) leftState (ite (Real.instLT.lt 0 x) rightState valueAtOrigin)
```

### D023: `LocalDef023`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `7f51eaf225194ba5828f69236b8c0a5f4c7063243e167a23b544999602bf077e`

Type:

```lean
{State : Type u_1} →
  {Information : Type u_2} →
    {Flux : Type u_3} →
      LocalDef013 →
        (State → State → Information) →
          (Information → Flux) →
            (LocalDef013 → State → State → Information → Prop) →
              (State → State → Flux → Prop) → LocalDef021 State Information Flux
```

### D024: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

### D025: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D026: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

### D027: `HSub.hSub`

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

### D028: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

### D029: `Int`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `257bf50f640447b541733c8fd9c6bcca584fc9dd85c221eb4f37888655c88e08`

Type:

```lean
Type
```

### D030: `Int.instSub`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cdec027f4b1a52ca9841248e8efbabc901ed4e9b4220aa4074044d4c9537c68c`

Type:

```lean
Sub Int
```

Definition body (one-level semantic boundary):

```lean
{ sub := Int.sub }
```

### D031: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Type:

```lean
{α : Type u} → [self : LT α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LT α] => self.1
```

### D032: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

### D033: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → AddCommMonoid α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocSemiring α] => self.1
```

### D034: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Type:

```lean
{α : Type u} → [self : NonUnitalSemiring α] → NonUnitalNonAssocSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSemiring α] => self.1
```

### D035: `OfNat.ofNat`

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

### D036: `Or`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `de438fb54053199506d3db7df89e4ed6f1bc296d2e49a7e63e7a4b73a1b23d7e`

Type:

```lean
Prop → Prop → Prop
```

### D037: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D038: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D039: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D040: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Type:

```lean
AddCommGroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D041: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Type:

```lean
LT Real
```

Definition body (one-level semantic boundary):

```lean
{ lt := Real.lt✝ }
```

### D042: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Type:

```lean
Ring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D043: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Type:

```lean
Zero Real
```

Definition body (one-level semantic boundary):

```lean
{ zero := Real.zero✝ }
```

### D044: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Type:

```lean
Semiring Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D045: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Type:

```lean
{R : Type u} → [self : Ring R] → Semiring R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Ring R] => self.1
```

### D046: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D047: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonUnitalSemiring α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Semiring α] => self.1
```

### D048: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Type:

```lean
{α : Type u_1} → [Zero α] → OfNat α 0
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Zero α] => { ofNat := inst.zero }
```

### D049: `instHSub`

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

### D050: `instOfNat`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d01cf83431e28a96433c57a624e20a771e5e0ddc02355969c5044adf1ba168a5`

Type:

```lean
{n : Nat} → OfNat Int n
```

Definition body (one-level semantic boundary):

```lean
fun {n} => { ofNat := Int.ofNat n }
```

### D051: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

### D052: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f727c3f01db957bd004eab61d742db6d02c6f9b2cdad465fa6f0ac214e09ccfd`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddCommMonoid G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D053: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `7f49725cf4bc16610110860af8f38e6d0fe472c7c1af93721407bad8c7375729`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddGroup G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : AddCommGroup G] => self.1
```

### D054: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8c0fca6ee264d934b25c679f16be6b83bb2a2f7c58a8ac0afab0c146219e16a1`

Type:

```lean
{A : Type u} → [self : AddGroup A] → SubNegMonoid A
```

Definition body (one-level semantic boundary):

```lean
fun A [self : AddGroup A] => self.1
```

### D055: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `4b5cfcaa0e3b1157089b486d5bfd51b9d15b881ea9cad302a6c8f701cae9ef1a`

Type:

```lean
{M : Type u} → [self : AddMonoid M] → AddZeroClass M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toZero := self.toZero, toAdd := self.toAdd, zero_add := ⋯, add_zero := ⋯ }
```

### D056: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `aa06299f9d38f11e9dad40701d7541d8eba2a4ac673c643f4c5f5ce1369490cc`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Zero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.1
```

### D057: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8f64c653a96443ff67b52a5edb3fc264d279905b936c7303e9dd2469af000213`

Type:

```lean
{M : Type u} → [self : AddZeroClass M] → AddZero M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZeroClass M] => self.1
```

### D058: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D059: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f640928ea31b161891006aaf9950d636ac5e1fbda413a7712f36546c938b3fdf`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : AddZeroClass A} → [self : DistribSMul M A] → SMulZeroClass M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : DistribSMul M A] => self.1
```

### D060: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D061: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f1757307432fadbd23925bbf0a318b8da57d17711478e1073a19ce64c21d55f4`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HSMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HSMul α β γ] => self.1
```

### D062: `Int.instAdd`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f3fe827ffb6fc81658773a6ada6451aeb9c1a54d32b216d8dede8eae9142825b`

Type:

```lean
Add Int
```

Definition body (one-level semantic boundary):

```lean
{ add := Int.add }
```

### D063: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

### D064: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D065: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Type:

```lean
Monoid Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D066: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `a8cadadddb0c9fd4a7bcb7c57401fafb43a1f330afa35fdacacb6d0e82d0bcf6`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : Zero A} → [self : SMulZeroClass M A] → SMul M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : SMulZeroClass M A] => self.1
```

### D067: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `9e6f6ef922e3c39bdc8dcf74fa873f2e393c916c08aa49739c9dcafb3f96877b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → AddMonoid G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.1
```

### D068: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f60885ee7a5e97dbc3d343ecb54849b15ae9ca7cc989f350d3b7fee2d2d0724b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → Sub G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.3
```

### D069: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D070: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `04ea7c06812eccb8531b763b7aa28fd8f968befff069e74166ff1b406f7512e3`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [SMul α β] → HSMul α β β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : SMul α β] => { hSMul := inst.smul }
```

### D071: `Real.decidableLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `def93575a13821d7d42b557cb9b973eede26ae12bbb8b60b1f0a302bf95a5a42`

Type:

```lean
(a b : Real) → Decidable (Real.instLT.lt a b)
```

Definition body (one-level semantic boundary):

```lean
fun a b => inferInstance
```

### D072: `ite`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `3029bae29d2d16b5aeb879ad3c12a1b3c4e78998083bf1ab4614942fafdece0e`

Type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → α → α → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} c [h : Decidable c] t e => Decidable.casesOn h (fun x => e) fun x => t
```
