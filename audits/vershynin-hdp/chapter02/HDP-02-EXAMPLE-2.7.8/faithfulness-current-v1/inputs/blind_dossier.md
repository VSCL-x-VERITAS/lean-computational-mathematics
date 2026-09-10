# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
LocalDef001
```

## Fully explicit elaborated target type

```lean
LocalDef001.{u_1, u_2}
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `LocalDef001`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `554a728f60df253ecf78cc2e796e0232e9ab5ab7221a5676f910eeb16e9e7f06`

Type:

```lean
Prop
```

Definition body (one-level semantic boundary):

```lean
And
  (∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] {μ : MeasureTheory.Measure Ω} [MeasureTheory.IsProbabilityMeasure μ]
    {X : Ω → Real},
    (Exists fun i =>
        And (Ne i LocalDef010)
          (Exists fun K =>
            And (Real.instLT.lt 0 K) (LocalDef008 μ X i K))) →
      Exists fun K =>
        And (Real.instLT.lt 0 K)
          (LocalDef005 μ X
            LocalDef006 K))
  (And
    (∀ {Ω : Type u_2} [inst : MeasurableSpace Ω] {μ : MeasureTheory.Measure Ω} {X : Ω → Real},
      Measurable X →
        And
          (Iff
            (ENNReal.instPartialOrder.lt
              (LocalDef004 μ fun ω => instHPow.hPow (X ω) 2) instTopENNReal.top)
            (ENNReal.instPartialOrder.lt (LocalDef007 μ X) instTopENNReal.top))
          (Eq (LocalDef004 μ fun ω => instHPow.hPow (X ω) 2)
            (instHPow.hPow (LocalDef007 μ X) 2)))
    (And
      (∀ (lambda : Real),
        Real.instLT.lt 0 lambda →
          And (Eq (MeasureTheory.integral (ProbabilityTheory.expMeasure lambda) fun x => x) (instHDiv.hDiv 1 lambda))
            (And
              (Eq (ProbabilityTheory.variance (fun x => x) (ProbabilityTheory.expMeasure lambda))
                (instHDiv.hDiv 1 (instHPow.hPow lambda 2)))
              (Eq (LocalDef004 (ProbabilityTheory.expMeasure lambda) fun x => x)
                (ENNReal.ofReal (instHDiv.hDiv 2 lambda)))))
      (∀ (rate : NNReal),
        ENNReal.instPartialOrder.lt
          (LocalDef004
            (LocalDef003 rate) fun x => x)
          instTopENNReal.top)))
```

### D002: `LocalDef002`

- Role: `local`
- Owner module: `LocalImport005`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `f13204b278de727fedcf9321d46d43e8ad7f502087875c544503ae9d8653984f`

Type:

```lean
(instHAdd.hAdd 1 1).AtLeastTwo
```

### D003: `LocalDef003`

- Role: `local`
- Owner module: `LocalImport002`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6abc90cc45ef5a768567bccf8acec8c7c624533cd1c6934ff378b394e5e6e2db`

Type:

```lean
NNReal → MeasureTheory.Measure Real
```

Definition body (one-level semantic boundary):

```lean
fun rate => MeasureTheory.Measure.map (fun k => k.cast) (LocalDef011 rate)
```

### D004: `LocalDef004`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3d859747551c6ef18201963a8406b806380f89fcd58184ee9c6d96dae97b7bf4`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X =>
  ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf.sInf
    (setOf fun t => LocalDef012 μ X t)
```

### D005: `LocalDef005`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e3f3c6631a38c943eaf45e54fecd04d8bf04074de5a238c6b7e0da748de671d4`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    MeasureTheory.Measure Ω →
      (Ω → Real) → LocalDef017 → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X x =>
  LocalDef016 (fun x => Real → Prop) x
    (fun _ => LocalDef018 μ X)
    (fun _ => LocalDef014 μ X)
    (fun _ => LocalDef013 μ X) fun _ =>
    LocalDef015 μ X
```

### D006: `LocalDef006`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `8b992d2356f005258e7e4083f1ce0d146d478e7006f7446ab61d86db7bb5ee85`

Type:

```lean
LocalDef017
```

### D007: `LocalDef007`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c81a60a904843ef883b553397d53b96fedc04c2aeefd9d5412e0840155eb0b48`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X =>
  ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf.sInf
    (setOf fun t => LocalDef019 μ X t)
```

### D008: `LocalDef008`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9af80f41e98a57fc68d89265bdc9d76b7d9db03197c96b4974bd8aa1c88cfd5b`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    MeasureTheory.Measure Ω → (Ω → Real) → LocalDef009 → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X x =>
  LocalDef022 (fun x => Real → Prop) x
    (fun _ => LocalDef029 μ X)
    (fun _ => LocalDef021 μ X)
    (fun _ => LocalDef028 μ X)
    (fun _ => LocalDef027 μ X) fun _ =>
    LocalDef020 μ X
```

### D009: `LocalDef009`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `3d62ece3e0d569f5f4b53f6b80af09f322581777aa3b3bea81e4c045b2cd06f3`

Type:

```lean
Type
```

### D010: `LocalDef010`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `92e98114b0fdd0314006b45b43da4acd769668c69ebdae52751074f7d7a479bc`

Type:

```lean
LocalDef009
```

### D011: `LocalDef011`

- Role: `local`
- Owner module: `LocalImport001`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2055aecc7628f3c712e0ded569de464eac96aed637780dc60ad0dd362a55595b`

Type:

```lean
NNReal → MeasureTheory.Measure Nat
```

Definition body (one-level semantic boundary):

```lean
fun rate => ProbabilityTheory.poissonMeasure rate
```

### D012: `LocalDef012`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ea01b81abef7c041f7ae6dc9fe8bf139864e4d775796da1b34b401a1dd7fe7a0`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X t =>
  And (Measurable X)
    (And (Ne t 0)
      (And (Ne t instTopENNReal.top)
        (And (MeasureTheory.Integrable (fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) t.toReal)) μ)
          (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) t.toReal)) 2))))
```

### D013: `LocalDef013`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5571acb71e16670b8738120db74a53bfa0a88d4cba391bd27062dee6c029603c`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (∀ (lam : Real),
        Real.instLE.le 0 lam →
          Real.instLE.le lam (Real.instInv.inv K) →
            And (MeasureTheory.Integrable (fun ω => Real.exp (instHMul.hMul lam (abs (X ω)))) μ)
              (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHMul.hMul lam (abs (X ω))))
                (Real.exp (instHMul.hMul K lam)))))
```

### D014: `LocalDef014`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `096fcdf2438a87d986e02a93fd3b08ea17b47b9ac2acd469d8e344d80b9100aa`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X) (And (Real.instLT.lt 0 K) (LocalDef030 μ X K))
```

### D015: `LocalDef015`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `928b93dfd114c2ff5dd79dad80848588a78524cacf664bbcc60bb1568d075ae2`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (And (MeasureTheory.Integrable (fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) K)) μ)
        (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) K)) 2)))
```

### D016: `LocalDef016`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `53f3f1aad66ac2692b26bbc30e146143cd99b0495818c924286acd3e9024219e`

Type:

```lean
(motive : LocalDef017 → Sort u_1) →
  (x : LocalDef017) →
    (Unit → motive LocalDef034) →
      (Unit → motive LocalDef006) →
        (Unit → motive LocalDef031) →
          (Unit → motive LocalDef033) → motive x
```

Definition body (one-level semantic boundary):

```lean
fun motive x h_1 h_2 h_3 h_4 =>
  LocalDef032 x (h_1 Unit.unit) (h_2 Unit.unit)
    (h_3 Unit.unit) (h_4 Unit.unit)
```

### D017: `LocalDef017`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `0d27bdcf20c59f88781ed5441a4d84bc1cbf9c7a346af3d5a4bc15cfc173b80c`

Type:

```lean
Type
```

### D018: `LocalDef018`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `99219b2ffe314561a5cca0399ebd56204dabc64a608e062e0645ebc960c8f0b5`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (∀ (t : Real),
        Real.instLE.le 0 t →
          Real.instLE.le (μ.real (setOf fun ω => GE.ge (abs (X ω)) t))
            (instHMul.hMul 2 (Real.exp (instHDiv.hDiv (Real.instNeg.neg t) K)))))
```

### D019: `LocalDef019`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4f1687485723a974ed9cab43fdef69a8440eb7a69d4115c1e0c81c855ba7a04a`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X t =>
  And (Measurable X)
    (And (Ne t 0)
      (And (Ne t instTopENNReal.top)
        (And
          (MeasureTheory.Integrable
            (fun ω => Real.exp (instHDiv.hDiv (instHPow.hPow (X ω) 2) (instHPow.hPow t.toReal 2))) μ)
          (Real.instLE.le
            (MeasureTheory.integral μ fun ω =>
              Real.exp (instHDiv.hDiv (instHPow.hPow (X ω) 2) (instHPow.hPow t.toReal 2)))
            2))))
```

### D020: `LocalDef020`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a413a1f0073031463d7097ee7fe27c565b8ce5f37779f8af8c1d0e59c5108529`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (And (MeasureTheory.Integrable X μ)
        (And (Eq (MeasureTheory.integral μ fun ω => X ω) 0)
          (∀ (lam : Real),
            And (MeasureTheory.Integrable (fun ω => Real.exp (instHMul.hMul lam (X ω))) μ)
              (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHMul.hMul lam (X ω)))
                (Real.exp (instHMul.hMul (instHPow.hPow K 2) (instHPow.hPow lam 2))))))))
```

### D021: `LocalDef021`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `71835d61ff71ed629cd795901033d5d0cffb7980f12f4e2aa06e454275ca37fa`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X) (And (Real.instLT.lt 0 K) (LocalDef037 μ X K))
```

### D022: `LocalDef022`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `268fd1b5fb7c674b08009f2d1da25c11f97f760cd1bbfc296abcdbf12b44c2d8`

Type:

```lean
(motive : LocalDef009 → Sort u_1) →
  (x : LocalDef009) →
    (Unit → motive LocalDef026) →
      (Unit → motive LocalDef023) →
        (Unit → motive LocalDef025) →
          (Unit → motive LocalDef024) →
            (Unit → motive LocalDef010) → motive x
```

Definition body (one-level semantic boundary):

```lean
fun motive x h_1 h_2 h_3 h_4 h_5 =>
  LocalDef038 x (h_1 Unit.unit) (h_2 Unit.unit) (h_3 Unit.unit)
    (h_4 Unit.unit) (h_5 Unit.unit)
```

### D023: `LocalDef023`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `abcb039876ae2af0e95e3346a3c41120bed1276a4aeeaf4f0551d6108cc34c10`

Type:

```lean
LocalDef009
```

### D024: `LocalDef024`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `2a2a991a1479686aeaad7d7ed347f92342d5815ffd26815136b73d38cb6a9175`

Type:

```lean
LocalDef009
```

### D025: `LocalDef025`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `50691cbacef241882eb7915a00d5314c980f3e5565ebc7d4aeff52861b905c9e`

Type:

```lean
LocalDef009
```

### D026: `LocalDef026`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `487c45f3c43f7ee3eaea19d51d787fc11ee88a618b376a38c47199913701b33f`

Type:

```lean
LocalDef009
```

### D027: `LocalDef027`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `e2e89f5cadf98be6e7ecc8da0f387fae10ac3ec6df2f879655fa56b7c2b6cc62`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (And (MeasureTheory.Integrable (fun ω => Real.exp (instHDiv.hDiv (instHPow.hPow (X ω) 2) (instHPow.hPow K 2))) μ)
        (Real.instLE.le
          (MeasureTheory.integral μ fun ω => Real.exp (instHDiv.hDiv (instHPow.hPow (X ω) 2) (instHPow.hPow K 2))) 2)))
```

### D028: `LocalDef028`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `00cb4ab2711fbfc2672a769a68bec1c2aa94d7101c6798d9c1ad76f9d6af6314`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (∀ (lam : Real),
        Real.instLE.le (abs lam) (Real.instInv.inv K) →
          And
            (MeasureTheory.Integrable (fun ω => Real.exp (instHMul.hMul (instHPow.hPow lam 2) (instHPow.hPow (X ω) 2)))
              μ)
            (Real.instLE.le
              (MeasureTheory.integral μ fun ω => Real.exp (instHMul.hMul (instHPow.hPow lam 2) (instHPow.hPow (X ω) 2)))
              (Real.exp (instHMul.hMul (instHPow.hPow K 2) (instHPow.hPow lam 2))))))
```

### D029: `LocalDef029`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `87e4f6ed7b607804e5be8bd00afa44c9c28d579fc351d93f350e98ebdf3a86aa`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (∀ (t : Real),
        Real.instLE.le 0 t →
          Real.instLE.le (μ.real (setOf fun ω => GE.ge (abs (X ω)) t))
            (instHMul.hMul 2 (Real.exp (instHDiv.hDiv (Real.instNeg.neg (instHPow.hPow t 2)) (instHPow.hPow K 2))))))
```

### D030: `LocalDef030`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `355ba4c74783fad6a07946e242d887b87f39b93ac077847c2a5f97c89c3009a9`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (AEMeasurable X μ)
    (∀ (p : Real),
      Real.instLE.le 1 p →
        And (MeasureTheory.Integrable (fun ω => instHPow.hPow (abs (X ω)) p) μ)
          (Real.instLE.le (MeasureTheory.integral μ fun ω => instHPow.hPow (abs (X ω)) p)
            (instHPow.hPow (instHMul.hMul K p) p)))
```

### D031: `LocalDef031`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `3010e7755cd3eb0a263a72d165e512a8777997c3edbc0290017c0ea6cd47faf2`

Type:

```lean
LocalDef017
```

### D032: `LocalDef032`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `26bcf8b2b149d4aaa06b72880a22286b74416a6879321f5b03860f0305c4d285`

Type:

```lean
{motive : LocalDef017 → Sort u} →
  (t : LocalDef017) →
    motive LocalDef034 →
      motive LocalDef006 →
        motive LocalDef031 →
          motive LocalDef033 → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t tail moment absoluteMGF onePoint =>
  LocalDef039 tail moment absoluteMGF onePoint t
```

### D033: `LocalDef033`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `4256a71721c795e42fa3a2de2f2af9a11e635f5c73859c930ce36aa4bc56a948`

Type:

```lean
LocalDef017
```

### D034: `LocalDef034`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `b42ade2b9a413f3f3dc9cc836f3c06dc9102a6b71cc93e994d656e21e2447fe2`

Type:

```lean
LocalDef017
```

### D035: `LocalDef035`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `4934bbb512eccb02c1641f048c14b3ff39131d21c58e5b1cee312a6acea390f4`

Type:

```lean
(instHAdd.hAdd 1 1).AtLeastTwo
```

### D036: `LocalDef036`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `fef4d74723af9a6d7cf7c292c7b48e3b0af82ddf7aeae726a620f1d8bd2ee9db`

Type:

```lean
(instHAdd.hAdd 1 1).AtLeastTwo
```

### D037: `LocalDef037`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `27212c252b4cbc0c4077a27221ec6493869f40f2ee89b7ce691df61914f2d8ec`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (AEMeasurable X μ)
    (∀ (p : Real),
      Real.instLE.le 1 p →
        And (MeasureTheory.Integrable (fun ω => instHPow.hPow (abs (X ω)) p) μ)
          (Real.instLE.le (MeasureTheory.integral μ fun ω => instHPow.hPow (abs (X ω)) p)
            (instHPow.hPow (instHMul.hMul K p.sqrt) p)))
```

### D038: `LocalDef038`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `bd5f25a0c13561d8ecf28a958c6b4aa0848653d5532385076c3d4d0a9a996623`

Type:

```lean
{motive : LocalDef009 → Sort u} →
  (t : LocalDef009) →
    motive LocalDef026 →
      motive LocalDef023 →
        motive LocalDef025 →
          motive LocalDef024 →
            motive LocalDef010 → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t tail moment squareWindow squarePoint linearMGF =>
  LocalDef040 tail moment squareWindow squarePoint linearMGF t
```

### D039: `LocalDef039`

- Role: `local`
- Owner module: `LocalImport003`
- Declaration kind: `recursor`
- Distance from target type: `5`
- Semantic SHA-256: `0161f5200912949f7a6926576322453515b498ea8dfeeaf6763e615e7c9a2d41`

Type:

```lean
{motive : LocalDef017 → Sort u} →
  motive LocalDef034 →
    motive LocalDef006 →
      motive LocalDef031 →
        motive LocalDef033 →
          (t : LocalDef017) → motive t
```

### D040: `LocalDef040`

- Role: `local`
- Owner module: `LocalImport004`
- Declaration kind: `recursor`
- Distance from target type: `5`
- Semantic SHA-256: `63f2a8c086cb19398dee2a0114f6c7aca22876ff0a2ba59d6ee2494e579ed8f1`

Type:

```lean
{motive : LocalDef009 → Sort u} →
  motive LocalDef026 →
    motive LocalDef023 →
      motive LocalDef025 →
        motive LocalDef024 →
          motive LocalDef010 →
            (t : LocalDef009) → motive t
```

### D041: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

### D042: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `bcda2e78d6b7602d359ab954baf5c3bd0f6b2503b3ec9a72e1a21a48b9d18d89`

Type:

```lean
{R : Type u} → [self : CommSemiring R] → Semiring R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : CommSemiring R] => self.1
```

### D043: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D044: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5b8f4d61311ebccecf6a54ceca44191d394e0108c8596129a77f03c15a7e457f`

Type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
WithTop NNReal
```

### D045: `ENNReal.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `0641453ddd31d2b679655d5c2b4fc302ecf7b88a815424716c8ac4e525cf14b8`

Type:

```lean
CommSemiring ENNReal
```

Definition body (one-level semantic boundary):

```lean
inferInstanceAs (CommSemiring (WithTop NNReal))
```

### D046: `ENNReal.instPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f07a664eb470c37e8c5abcad62d27fe4145f686c6a6a132fa775fdf14e92b68e`

Type:

```lean
PartialOrder ENNReal
```

Definition body (one-level semantic boundary):

```lean
inferInstanceAs (PartialOrder (WithTop NNReal))
```

### D047: `ENNReal.ofReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `ed3ef7ee60e47d07da43d414f4f32aa69df50f614988267eebc1025b2bef657d`

Type:

```lean
Real → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun r => ENNReal.ofNNReal r.toNNReal
```

### D048: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D049: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

### D050: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D051: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6196b8cbb884c4f39841ba74b23d75f3c753fe0d044cc402bd6e4e3bd59d5cb8`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HPow α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HPow α β γ] => self.1
```

### D052: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

### D053: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `683435a8d27d50ec1482d74d23f541d52d05ff0411c60f88d16c32132aca9f3e`

Type:

```lean
{𝕜 : Type u_4} →
  {E : Type u_5} →
    {inst : RCLike 𝕜} → {inst_1 : SeminormedAddCommGroup E} → [self : InnerProductSpace 𝕜 E] → NormedSpace 𝕜 E
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : InnerProductSpace 𝕜 E] => self.1
```

### D054: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Type:

```lean
{α : Type u} → [self : LT α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LT α] => self.1
```

### D055: `Measurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6d56983cd98232a62c5c1b4a0368519a8b381777b32b6e8301ade2ccd7f4c3a4`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [MeasurableSpace α] → [MeasurableSpace β] → (α → β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [MeasurableSpace α] [MeasurableSpace β] f =>
  ∀ ⦃t : Set β⦄, MeasurableSet t → MeasurableSet (Set.preimage f t)
```

### D056: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

### D057: `MeasureTheory.IsProbabilityMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `f88b269cb95d165125e7553fd22f97d6e5f9b1b9bcdec7f6738a781dc674bf89`

Type:

```lean
{α : Type u_1} → {m0 : MeasurableSpace α} → MeasureTheory.Measure α → Prop
```

### D058: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

### D059: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `428563f3d6b771605a3267457bf33b62ec2efa91a42b57b96121b85c0269a9ab`

Type:

```lean
{α : Type u_6} →
  {G : Type u_7} →
    [inst : NormedAddCommGroup G] →
      [NormedSpace Real G] → {x : MeasurableSpace α} → MeasureTheory.Measure α → (α → G) → G
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.wrapped✝.1
```

### D060: `Monoid.toNatPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5b7373fe2de26535c1cdbf1b953ce34faf30f68aac8abd83ade2e78e6ec65b8a`

Type:

```lean
{M : Type u_2} → [Monoid M] → Pow M Nat
```

Definition body (one-level semantic boundary):

```lean
fun {M} [inst : Monoid M] => { pow := fun x n => inst.npow n x }
```

### D061: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `c0f91ccdc0415c148969849b7a83ce67d87cf4c402704186fa19f6313928d90f`

Type:

```lean
{M₀ : Type u} → [self : MonoidWithZero M₀] → Monoid M₀
```

Definition body (one-level semantic boundary):

```lean
fun M₀ [self : MonoidWithZero M₀] => self.1
```

### D062: `NNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.NNReal.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `490ebc1f72b3ced8506e1bcbd0016d4c351adf097644509fd1dd17a93c4e950f`

Type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
Subtype fun r => Real.instLE.le 0 r
```

### D063: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

### D064: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `635adc1f9e4a981a5c01b21338fdf89e637bd4ef0aa6911bda4dc03acfe9fba6`

Type:

```lean
{α : Sort u} → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} a b => Not (Eq a b)
```

### D065: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → SeminormedAddCommGroup E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D066: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Type:

```lean
{α : Type u} → (x : Nat) → [self : OfNat α x] → α
```

Definition body (one-level semantic boundary):

```lean
fun α x [self : OfNat α x] => self.1
```

### D067: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `cc544b5b2a2aabc84389a9fe2f052127dc6dae9964782b117b9b19b773e542d5`

Type:

```lean
{α : Type u_1} → [One α] → OfNat α 1
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : One α] => { ofNat := inst.one }
```

### D068: `PartialOrder.toPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `079686fa1ec6d596bcdb475c56a12b7f5a0594bf346c64220c2c992e0f0aae3b`

Type:

```lean
{α : Type u_2} → [self : PartialOrder α] → Preorder α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PartialOrder α] => self.1
```

### D069: `Preorder.toLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8fcf5a8f5a8899408a8cdc310bc44f6f7b84a21905a114103fbc65083f779a43`

Type:

```lean
{α : Type u_2} → [self : Preorder α] → LT α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Preorder α] => self.2
```

### D070: `ProbabilityTheory.expMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Distributions.Exponential`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `acaf923427225322cc4e64eb72e9e80300c7137be7d7ba56db5b3337dfa3a531`

Type:

```lean
Real → MeasureTheory.Measure Real
```

Definition body (one-level semantic boundary):

```lean
fun r => ProbabilityTheory.gammaMeasure 1 r
```

### D071: `ProbabilityTheory.variance`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Moments.Variance`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `2eb32ed492bfdd1df3ad84f7e963b9d4f0347489111c9ee4dddf93da3947d3a2`

Type:

```lean
{Ω : Type u_1} → {mΩ : MeasurableSpace Ω} → (Ω → Real) → MeasureTheory.Measure Ω → Real
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} {mΩ} X μ => (ProbabilityTheory.evariance X μ).toReal
```

### D072: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f602276baee30d3dbe02bd6b756a9097f750d59a7f91ca7635dcfc935fd22981`

Type:

```lean
{𝕜 : Type u_1} → [inst : RCLike 𝕜] → InnerProductSpace Real 𝕜
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [RCLike 𝕜] =>
  let __spread.0 := Inner.rclikeToReal 𝕜 𝕜;
  { toNormedSpace := NormedAlgebra.toNormedSpace 𝕜, toInner := __spread.0, norm_sq_eq_re_inner := ⋯,
    conj_inner_symm := ⋯, add_left := ⋯, smul_left := ⋯ }
```

### D073: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D074: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `166f2abb65bf1271e5e8d70fdb78c55672c7e366b30439e83b517f803cdefac3`

Type:

```lean
DivInvMonoid Real
```

Definition body (one-level semantic boundary):

```lean
{ toMonoid := Real.instMonoid, toInv := Real.instInv, div := DivInvMonoid.div',
  div_eq_mul_inv := Real.instDivInvMonoid._proof_1, zpow := zpowRec, zpow_zero' := Real.instDivInvMonoid._proof_2,
  zpow_succ' := Real.instDivInvMonoid._proof_3, zpow_neg' := Real.instDivInvMonoid._proof_4 }
```

### D075: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Type:

```lean
LT Real
```

Definition body (one-level semantic boundary):

```lean
{ lt := Real.lt✝ }
```

### D076: `Real.instMonoid`

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

### D077: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5fc7a7becbc71d472fa1a28bd92d79b4c6ea4fdc643db7380031a2b890ca7e15`

Type:

```lean
NatCast Real
```

Definition body (one-level semantic boundary):

```lean
{ natCast := fun n => { cauchy := n.cast } }
```

### D078: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b4e24b050b7fb50c4c115c51d5cd4c1b180cae53633f58a38c7d5ce3ccf86c81`

Type:

```lean
One Real
```

Definition body (one-level semantic boundary):

```lean
{ one := Real.one✝ }
```

### D079: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `d2fdb97b9d861fcf61e6dbea9993dfa0ca6aa16609742f215c35b3f7ddd16b8e`

Type:

```lean
RCLike Real
```

Definition body (one-level semantic boundary):

```lean
{ toDenselyNormedField := Real.denselyNormedField, toStarRing := instStarRingReal,
  toNormedAlgebra := NormedAlgebra.id Real, toCompleteSpace := Real.instCompleteSpace, re := AddMonoidHom.id Real,
  im := 0, I := 0, I_re_ax := Real.instRCLike._proof_1, I_mul_I_ax := Real.instRCLike._proof_8, re_add_im_ax := ⋯,
  ofReal_re_ax := Real.instRCLike._proof_11, ofReal_im_ax := Real.instRCLike._proof_12, mul_re_ax := ⋯, mul_im_ax := ⋯,
  conj_re_ax := ⋯, conj_im_ax := ⋯, conj_I_ax := Real.instRCLike._proof_7, norm_sq_eq_def_ax := ⋯, mul_im_I_ax := ⋯,
  toPartialOrder := Real.partialOrder, le_iff_re_im := @Real.instRCLike._proof_13, toDecidableEq := Real.decidableEq }
```

### D080: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Type:

```lean
Zero Real
```

Definition body (one-level semantic boundary):

```lean
{ zero := Real.zero✝ }
```

### D081: `Real.measurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `51b107725c4edbe40e50ff5651a2c7ee5a10037e341c2764964a6d6cc26d82a1`

Type:

```lean
MeasurableSpace Real
```

Definition body (one-level semantic boundary):

```lean
borel Real
```

### D082: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Type:

```lean
NormedAddCommGroup Real
```

Definition body (one-level semantic boundary):

```lean
{ toNorm := Real.norm, toAddCommGroup := Real.instAddCommGroup, toMetricSpace := Real.metricSpace, dist_eq := ⋯ }
```

### D083: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `bf0d463c55fbfcd762eb28ad6f1672fe482a72dfed67d13a797c09f1f0431e64`

Type:

```lean
{α : Type u} → [self : Semiring α] → MonoidWithZero α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toMul := self.toMul, mul_assoc := ⋯, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯, npow := self.npow,
    npow_zero := ⋯, npow_succ := ⋯, toZero := self.toZero, zero_mul := ⋯, mul_zero := ⋯ }
```

### D084: `Top.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Notation`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `32c978930b5eb9164add86b32aeacdc99d2d10df09b4b1989d12a6e346774504`

Type:

```lean
{α : Type u_1} → [self : Top α] → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Top α] => self.1
```

### D085: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Type:

```lean
{α : Type u_1} → [Zero α] → OfNat α 0
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Zero α] => { ofNat := inst.zero }
```

### D086: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```

### D087: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb300d353d84392c776cad5e356479f878030744a43f9a1584942a89d16350b4`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [Pow α β] → HPow α β α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : Pow α β] => { hPow := fun a b => inst.pow a b }
```

### D088: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `37355febc51d6fa8ff12fc8e7b429771db340390d46411d7608c566bdffd358d`

Type:

```lean
{R : Type u_1} → {n : Nat} → [NatCast R] → [n.AtLeastTwo] → OfNat R n
```

Definition body (one-level semantic boundary):

```lean
fun {R} {n} [NatCast R] [n.AtLeastTwo] => { ofNat := n.cast }
```

### D089: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7018dea92aae8c272f3a065f25e2bedb9732a0b602c3d54b166fa0cf2ce1ea92`

Type:

```lean
(n : Nat) → OfNat Nat n
```

Definition body (one-level semantic boundary):

```lean
fun n => { ofNat := n }
```

### D090: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `fc363bb86fd9c29e754e22d842cff17acbad13559cb0e03d31f4863045cd3c07`

Type:

```lean
Top ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.top
```

### D091: `CompleteLinearOrder.toConditionallyCompleteLinearOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2aa802d0a9c75bf33917e1e0dc266a90886d32f434f1d43521c53f0f2c3449d0`

Type:

```lean
{α : Type u_5} → [h : CompleteLinearOrder α] → ConditionallyCompleteLinearOrderBot α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [h : CompleteLinearOrder α] =>
  let __spread.0 := CompleteLattice.toConditionallyCompleteLattice;
  let __spread.1 := h;
  { toConditionallyCompleteLattice := __spread.0, toOrd := __spread.1.toOrd, le_total := ⋯,
    toDecidableLE := __spread.1.toDecidableLE, toDecidableEq := __spread.1.toDecidableEq,
    toDecidableLT := __spread.1.toDecidableLT, csSup_of_not_bddAbove := ⋯, csInf_of_not_bddBelow := ⋯,
    compare_eq_compareOfLessAndEq := ⋯, toOrderBot := __spread.1.toOrderBot, csSup_empty := ⋯ }
```

### D092: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `41576e47c21e72ff272622fb2a65e2858beda94a321ffdbc1128f58d338ee803`

Type:

```lean
{α : Type u_1} → [ConditionallyCompleteLattice α] → ConditionallyCompletePartialOrder α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : ConditionallyCompleteLattice α] =>
  { toPartialOrder := inst.toSemilatticeInf.toPartialOrder, toSupSet := inst.toSupSet, isLUB_csSup_of_directed := ⋯,
    toInfSet := inst.toInfSet, isGLB_csInf_of_directed := ⋯ }
```

### D093: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e1dad077d30ec2d5da19d9c26f0e709993b8eda004ce89d1f4086cf5f98094d5`

Type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrder α] → ConditionallyCompleteLattice α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompleteLinearOrder α] => self.1
```

### D094: `ConditionallyCompleteLinearOrderBot.toConditionallyCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `b25be2d55c4d466d6295ab5ff23a5cc915072a7d1cbc04c476d877743ce32dd9`

Type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrderBot α] → ConditionallyCompleteLinearOrder α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompleteLinearOrderBot α] => self.1
```

### D095: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `50e56dbfc6cb715ad5708fddc559a96fd43e4d11b7a8a33061c6cf440f5fc10c`

Type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrder α] → ConditionallyCompletePartialOrderInf α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toPartialOrder := self.toPartialOrder, toInfSet := self.toInfSet, isGLB_csInf_of_directed := ⋯ }
```

### D096: `ConditionallyCompletePartialOrderInf.toInfSet`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `182c2ddbb044a41025806b24afd62f570b4197b3450b566022615ea4646e06cd`

Type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrderInf α] → InfSet α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompletePartialOrderInf α] => self.2
```

### D097: `ENNReal.instCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2436cc4a7fc332a26b2b8879178b290fffb6ceaad2c2210667170bdf3119d835`

Type:

```lean
CompleteLinearOrder ENNReal
```

Definition body (one-level semantic boundary):

```lean
inferInstanceAs (CompleteLinearOrder (WithTop NNReal))
```

### D098: `HAdd.hAdd`

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

### D099: `InfSet.sInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.SetNotation`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `76c82ed45915e35439b105eb3ec239e1937b2a2eafff41b96f451468dd90c61d`

Type:

```lean
{α : Type u_1} → [self : InfSet α] → Set α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : InfSet α] => self.1
```

### D100: `MeasureTheory.Measure.map`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Map`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `35d0f192bfc92d083756f0df86ca1ad37f0c1f0bfa39120f6adf90414c4a3b75`

Type:

```lean
{α : Type u_4} →
  {β : Type u_5} →
    [inst : MeasurableSpace α] →
      [inst_1 : MeasurableSpace β] → (α → β) → MeasureTheory.Measure α → MeasureTheory.Measure β
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.Measure.wrapped✝.1
```

### D101: `Nat.AtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Init`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `318e11b8f9340f2f451d638786dd4fca470dece62824f4adc3bd18b5289aa911`

Type:

```lean
Nat → Prop
```

### D102: `Nat.cast`

- Role: `external-frontier`
- Owner module: `Init.Data.Cast`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `6e24327ea908b1837083bb15aef27d593e950a2ff8ade81d8aa94bfe33b64450`

Type:

```lean
{R : Type u} → [NatCast R] → Nat → R
```

Definition body (one-level semantic boundary):

```lean
fun {R} [inst : NatCast R] => inst.natCast
```

### D103: `Nat.instMeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Instances`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `623443610c6e8558202d9a1a4c82df42c1b84ebc018228c1d827c7015bec880c`

Type:

```lean
MeasurableSpace Nat
```

Definition body (one-level semantic boundary):

```lean
MeasurableSpace.instCompleteLattice.top
```

### D104: `Unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8544f990089bb705329f8e13de94d6583865877bcb1ebec4f8c096524a17581e`

Type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
PUnit
```

### D105: `instAddNat`

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

### D106: `instHAdd`

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

### D107: `setOf`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `cee4433aebd78c308ec85f62ccd30489c00ec9cc23a98f4d2139c17f840f4988`

Type:

```lean
{α : Type u} → (α → Prop) → Set α
```

Definition body (one-level semantic boundary):

```lean
fun {α} p => p
```

### D108: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `1aa070f54e8aff7a6558c977220472990963777ddc5f04c5284f49422c06b41f`

Type:

```lean
ENNReal → Real
```

Definition body (one-level semantic boundary):

```lean
fun a => a.toNNReal.toReal
```

### D109: `GE.ge`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `131874e93bc48da13f8ebac9085b31e74f8526201dea35f9078e764147586ec3`

Type:

```lean
{α : Type u} → [LE α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : LE α] a b => inst.le b a
```

### D110: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `4e00447a4a8ef4c2ce13e307c56a1fbcd7fa8c732fe039a452b42477a50df2c6`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HMul α β γ] => self.1
```

### D111: `Inv.inv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `c3aea3c6e2edd31a7b2cf071814315808ef7d84fd01d8c9b719313846ebca438`

Type:

```lean
{α : Type u} → [self : Inv α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Inv α] => self.1
```

### D112: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `54a32f2661f788eb2b860006c4d1e8031e126febafe1c8d03ce50529b773dc48`

Type:

```lean
{α : Type u} → [self : LE α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LE α] => self.1
```

### D113: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `51e5158e8f2f2a375463d510858200b96afa04fb8f33126da2c5d1c572a76165`

Type:

```lean
{ε : Type u_5} →
  [inst : TopologicalSpace ε] →
    [ContinuousENorm ε] →
      {α : Type u_8} →
        {x : MeasurableSpace α} → (α → ε) → autoParam (MeasureTheory.Measure α) MeasureTheory.Integrable._auto_1 → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ε} [TopologicalSpace ε] [ContinuousENorm ε] {α} {x} f μ =>
  And (MeasureTheory.AEStronglyMeasurable f μ) (MeasureTheory.HasFiniteIntegral f μ)
```

### D114: `MeasureTheory.Measure.real`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `4723537c549f4ae1a83b89820f96e884bcbc0bc734ccd6e543bbf82330bffc29`

Type:

```lean
{α : Type u_6} → {m : MeasurableSpace α} → MeasureTheory.Measure α → Set α → Real
```

Definition body (one-level semantic boundary):

```lean
fun {α} {m} μ s => (MeasureTheory.Measure.instFunLike.coe μ s).toReal
```

### D115: `Neg.neg`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `0c56662a5d917c211c3cb741ca747b4a6710082af615cf071342ef70dee3a2c7`

Type:

```lean
{α : Type u} → [self : Neg α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Neg α] => self.1
```

### D116: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing α] → NonUnitalSeminormedRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSeminormedCommRing α] => self.1
```

### D117: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Type:

```lean
{α : Type u_2} → [NonUnitalSeminormedRing α] → SeminormedAddCommGroup α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : NonUnitalSeminormedRing α] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D118: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → SeminormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toRing := β.toRing, toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯,
    norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D119: `ProbabilityTheory.poissonMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Distributions.Poisson`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `7150e5d0f3083cbdf0dd761158b0755c70c54e0d064f6e442d38caee1ce640e7`

Type:

```lean
NNReal → MeasureTheory.Measure Nat
```

Definition body (one-level semantic boundary):

```lean
fun r => (ProbabilityTheory.poissonPMF r).toMeasure
```

### D120: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D121: `Real.exp`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Complex.Exponential`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `69806b1af98b09fabed435ccc47a9f2f0840f9c5c140fb62cccc81a80761a984`

Type:

```lean
Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun x => (Complex.exp (Complex.ofReal x)).re
```

### D122: `Real.instAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f0de8cbc2c873a19be749cd9b2d3cc9a6edb9ebc92020a1877714a50c23d9dc0`

Type:

```lean
AddGroup Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D123: `Real.instInv`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `8996fd673a1e2289aaf761085a60a161bdafebda8cdd48d1efb3c89da1382980`

Type:

```lean
Inv Real
```

Definition body (one-level semantic boundary):

```lean
{ inv := Real.inv'✝ }
```

### D124: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `144d825fc543455e17044e843560e0415f8e4e9da60afb52f34edb809b7c34d3`

Type:

```lean
LE Real
```

Definition body (one-level semantic boundary):

```lean
{ le := Real.le✝ }
```

### D125: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Type:

```lean
Mul Real
```

Definition body (one-level semantic boundary):

```lean
{ mul := Real.mul✝ }
```

### D126: `Real.instNeg`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `000951397468b3d1f8a2a1cca1de3812bc024916ff842cfd5454811130093b41`

Type:

```lean
Neg Real
```

Definition body (one-level semantic boundary):

```lean
{ neg := Real.neg✝ }
```

### D127: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `5bccf78d647cf08233ff548c19523f80b1d1bf11b5a76aa50396199e2c0c7510`

Type:

```lean
Lattice Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D128: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Type:

```lean
NormedCommRing Real
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

### D129: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Type:

```lean
PseudoMetricSpace Real
```

Definition body (one-level semantic boundary):

```lean
{ dist := fun x y => abs (instHSub.hSub x y), dist_self := Real.pseudoMetricSpace._proof_1, dist_comm := ⋯,
  dist_triangle := ⋯, edist_dist := Real.pseudoMetricSpace._proof_2, uniformity_dist := Real.pseudoMetricSpace._proof_3,
  cobounded_sets := Real.pseudoMetricSpace._proof_4 }
```

### D130: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `8cf35215f509cdee10a3a95158cbaadd3c5fb584bc0d1f4fad6ecfc69b1bd205`

Type:

```lean
{E : Type u_5} → [SeminormedAddCommGroup E] → SeminormedAddGroup E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : SeminormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D131: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `17a83cbf3059dd0bbaefd43c93ce329f1d6b760d440889322b3582a18b23a141`

Type:

```lean
{E : Type u_4} → [inst : SeminormedAddGroup E] → ContinuousENorm E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [SeminormedAddGroup E] => { toENorm := NNNorm.toENorm, continuous_enorm := ⋯ }
```

### D132: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Type:

```lean
{α : Type u_2} → [β : SeminormedCommRing α] → NonUnitalSeminormedCommRing α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : SeminormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D133: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
```

### D134: `Unit.unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `e5d4ec6d7dbc312235968b914130d2d6ec344f051fd5f7c0276905a3c63cc953`

Type:

```lean
Unit
```

Definition body (one-level semantic boundary):

```lean
PUnit.unit
```

### D135: `abs`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Group.Unbundled.Abs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `8ec55bade8dee4d49822a9bdbd84db24c019b8d568452329d9766390229a9c1b`

Type:

```lean
{α : Type u_1} → [Lattice α] → [AddGroup α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Lattice α] [AddGroup α] a =>
  SemilatticeSup.toMax.max a (SubtractionMonoid.toSubNegZeroMonoid.toNegZeroClass.neg a)
```

### D136: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `1fd375514ac68e29e7941c94ba308ea936395db23d0fee63a5c69dcccd3b2bdc`

Type:

```lean
{α : Type u_1} → [Mul α] → HMul α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Mul α] => { hMul := fun a b => inst.mul a b }
```

### D137: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `6e5878abb65d5809d3258e569c8ff0f08b39804b377a07fec18d700b4e3fea86`

Type:

```lean
Zero ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.zero
```

### D138: `AEMeasurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `6dc48478b911cadddc9129039bc8859282262cccd65bca8d46f3cdc5415a69cd`

Type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [MeasurableSpace β] →
      {_m : MeasurableSpace α} → (α → β) → autoParam (MeasureTheory.Measure α) AEMeasurable._auto_1 → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [MeasurableSpace β] {_m} f μ => Exists fun g => And (Measurable g) ((MeasureTheory.ae μ).EventuallyEq f g)
```

### D139: `Real.instPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.SpecialFunctions.Pow.Real`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `d7348547260a6fa37dab6a95efbf0e3e5560a074d2443d0cb606f21bce228fe0`

Type:

```lean
Pow Real Real
```

Definition body (one-level semantic boundary):

```lean
{ pow := Real.rpow }
```

### D140: `Real.sqrt`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Sqrt`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `67f9248ae1acb851b5392be301057ebb8b8ef2fb20f76d2d53a2d07ec8f30553`

Type:

```lean
Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun x => ((instFunLikeOrderIso NNReal NNReal).coe NNReal.sqrt x.toNNReal).toReal
```
