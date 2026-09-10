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
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c81a60a904843ef883b553397d53b96fedc04c2aeefd9d5412e0840155eb0b48`

Hash-verified prior declaration review:

- Reuse SHA-256: `1019c8fddc76359c72808dc45dce131c53c4aaa4c2835be4f78f423a1ab0ac26`
- Reviewed meaning: The gauge is the infimum of all extended-real scales satisfying LocalDef010.

Independently determine this declaration's effect on the current proposition.

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
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4f1687485723a974ed9cab43fdef69a8440eb7a69d4115c1e0c81c855ba7a04a`

Hash-verified prior declaration review:

- Reuse SHA-256: `07d02181b5367d4c5e551f8842693393d297f3b1794f28d5118bb44819bfb6f8`
- Reviewed meaning: An extended-real scale t is admissible when X is measurable, t is neither zero nor infinity, exp(X^2/t.toReal^2) is integrable, and its expectation is at most 2.

Independently determine this declaration's effect on the current proposition.

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
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `e2e89f5cadf98be6e7ecc8da0f387fae10ac3ec6df2f879655fa56b7c2b6cc62`

Hash-verified prior declaration review:

- Reuse SHA-256: `d6a61864e6c2098677a7563f80343bbc69db6abba62c7d90d85e99a35c06f0b4`
- Reviewed meaning: At scale K>0, X is measurable, exp(X^2/K^2) is integrable, and its expectation is at most 2.

Independently determine this declaration's effect on the current proposition.

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
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `fef4d74723af9a6d7cf7c292c7b48e3b0af82ddf7aeae726a620f1d8bd2ee9db`

Hash-verified prior declaration review:

- Reuse SHA-256: `927b56de59bc46118e859aa00af78a976c2af7f7c1276bb89f79a8631ee23db9`
- Reviewed meaning: Another typeclass witness that the natural numeral 1+1 is at least two.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `c75443d7b6b5dd703381abb343241c0dbe39e99535304962e3f6f2dadf3a0439`
- Reviewed meaning: Logical conjunction.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `f238566fcac39a111f75063054f59a5b5210558269d20c3d677d285443c59ad0`
- Reviewed meaning: The division operation inherited from a division-inverse monoid.

Independently determine this declaration's effect on the current proposition.

### D044: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5b8f4d61311ebccecf6a54ceca44191d394e0108c8596129a77f03c15a7e457f`

Hash-verified prior declaration review:

- Reuse SHA-256: `b651661bc011acc82219122538c91c01d792ceee36f3f6ebb802ec67ba6c436c`
- Reviewed meaning: The nonnegative extended real numbers, including infinity.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `5aa2a3163b63753a99d32af441c80e80b2161cd43b4942457c96150716101fe6`
- Reviewed meaning: The nonnegative extended-real value associated to a real, truncating negative inputs to zero.

Independently determine this declaration's effect on the current proposition.

### D048: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `4b615e20b7b2d048738630ea55935ae4d63d781379ea47885e3e8fb479e9f629`
- Reviewed meaning: Equality.

Independently determine this declaration's effect on the current proposition.

### D049: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `07759c301f9c6e8cc0ac7ac79da84017cd80518ecbb4cbe643a78b1ea53c9319`
- Reviewed meaning: Existential quantification.

Independently determine this declaration's effect on the current proposition.

### D050: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Hash-verified prior declaration review:

- Reuse SHA-256: `3d084c2cba0d07a1e20c8f29a89d89c8a2ad9befa0bd734a479a9934e30f9690`
- Reviewed meaning: Overloaded division.

Independently determine this declaration's effect on the current proposition.

### D051: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6196b8cbb884c4f39841ba74b23d75f3c753fe0d044cc402bd6e4e3bd59d5cb8`

Hash-verified prior declaration review:

- Reuse SHA-256: `7c820639cf2699e6eefb2c0e1c687c227538d47aec9b827eb002730574e6e079`
- Reviewed meaning: Overloaded exponentiation.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `7f71e8f35c53af65038105239f78ee43a538938425e3adbbc59d22f97e73bd29`
- Reviewed meaning: The normed-space structure inherited from an inner-product space.

Independently determine this declaration's effect on the current proposition.

### D054: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Hash-verified prior declaration review:

- Reuse SHA-256: `ef39bee74ba4fb8409dc37397e4171c5a89e5fc47f2496253ce03a68150b5a59`
- Reviewed meaning: The strict less-than relation supplied by an order instance.

Independently determine this declaration's effect on the current proposition.

### D055: `Measurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6d56983cd98232a62c5c1b4a0368519a8b381777b32b6e8301ade2ccd7f4c3a4`

Hash-verified prior declaration review:

- Reuse SHA-256: `c8dc742c24fd4949a52b6984cc0cc18049c31aabba1a7c728b8b77742b7a4289`
- Reviewed meaning: A function pulls measurable sets back to measurable sets.

Independently determine this declaration's effect on the current proposition.

### D056: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Hash-verified prior declaration review:

- Reuse SHA-256: `2573a8cc1ef6aae7ab31bf437fcd81649851b4b425db078b102adf7ce6c35220`
- Reviewed meaning: A measurable-space structure on the sample type.

Independently determine this declaration's effect on the current proposition.

### D057: `MeasureTheory.IsProbabilityMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `f88b269cb95d165125e7553fd22f97d6e5f9b1b9bcdec7f6738a781dc674bf89`

Hash-verified prior declaration review:

- Reuse SHA-256: `5b2e15ad91b608ce8656726a2b56da4cf079f0640f8df69bb0e05535cfb92d27`
- Reviewed meaning: A measure has total mass one.

Independently determine this declaration's effect on the current proposition.

### D058: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Hash-verified prior declaration review:

- Reuse SHA-256: `1703a6aa8b98abeeda49878dd01d9bffdc7b4899cbc1ab81e974b091b90ef6ff`
- Reviewed meaning: A measure on a measurable space.

Independently determine this declaration's effect on the current proposition.

### D059: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `428563f3d6b771605a3267457bf33b62ec2efa91a42b57b96121b85c0269a9ab`

Hash-verified prior declaration review:

- Reuse SHA-256: `62c44ff335171afb32a0f2532e1e14d4a26270555241d1578e67afef137a2ac7`
- Reviewed meaning: The Bochner integral of a function against a measure.

Independently determine this declaration's effect on the current proposition.

### D060: `Monoid.toNatPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5b7373fe2de26535c1cdbf1b953ce34faf30f68aac8abd83ade2e78e6ec65b8a`

Hash-verified prior declaration review:

- Reuse SHA-256: `76ebde01a3eb7aad4f954d13f3730f2ea4d16bc9c492c403af3e1841a444e33f`
- Reviewed meaning: Natural-number exponentiation inherited from a monoid.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `d546bbf0bcc95145220cea99cfa38143a4daea1da7e802ccf1e33646a7219049`
- Reviewed meaning: The natural numbers.

Independently determine this declaration's effect on the current proposition.

### D064: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `635adc1f9e4a981a5c01b21338fdf89e637bd4ef0aa6911bda4dc03acfe9fba6`

Hash-verified prior declaration review:

- Reuse SHA-256: `0e8e90f77037ff6e173aafc24e241be411d9d7d398e13a2d086510a3c285bc9d`
- Reviewed meaning: Inequality, defined as negated equality.

Independently determine this declaration's effect on the current proposition.

### D065: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Hash-verified prior declaration review:

- Reuse SHA-256: `e2123fb1a5d2582f4e286d443e839a3921d8082b685934f8feef3904f939fce5`
- Reviewed meaning: The seminormed additive structure inherited from a normed additive commutative group.

Independently determine this declaration's effect on the current proposition.

### D066: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `ee9099fdd09a41e2b5beded1c891cf235380767179aaf20d53c2ab9c91def902`
- Reviewed meaning: Interpretation of a natural numeral in a target type.

Independently determine this declaration's effect on the current proposition.

### D067: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `cc544b5b2a2aabc84389a9fe2f052127dc6dae9964782b117b9b19b773e542d5`

Hash-verified prior declaration review:

- Reuse SHA-256: `26f32419bbe714dc62d58db9a2d45776f58b6327089242a88c32eae765cd4caf`
- Reviewed meaning: The numeral-one instance induced by a One structure.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `d42c29b45f693d290b06c77faf39654ff9f927be19c69cea1882351d00400315`
- Reviewed meaning: The real variance obtained from extended variance by conversion to a real.

Independently determine this declaration's effect on the current proposition.

### D072: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f602276baee30d3dbe02bd6b756a9097f750d59a7f91ca7635dcfc935fd22981`

Hash-verified prior declaration review:

- Reuse SHA-256: `5ffed0cbd857b4bf26054c5e79e92218bab82b7bb563215bcfc3a7d3c02eea62`
- Reviewed meaning: The real inner-product-space structure on an RCLike scalar type.

Independently determine this declaration's effect on the current proposition.

### D073: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `3e54220463bb90a5245084d27784cb4eb54af592478d767629005366d566a42e`
- Reviewed meaning: The real number type.

Independently determine this declaration's effect on the current proposition.

### D074: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `166f2abb65bf1271e5e8d70fdb78c55672c7e366b30439e83b517f803cdefac3`

Hash-verified prior declaration review:

- Reuse SHA-256: `3deb0433c35fc3fd076a30f6d2cf50b1a6d108a0060d2ff2a297ed90d9849bbf`
- Reviewed meaning: The division and inverse structure on the reals.

Independently determine this declaration's effect on the current proposition.

### D075: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Hash-verified prior declaration review:

- Reuse SHA-256: `f1c1abf7665104f2ed05777f723ac3a3cf3e6921706f6e025baacc76c5c85b92`
- Reviewed meaning: The standard strict order on the reals.

Independently determine this declaration's effect on the current proposition.

### D076: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Hash-verified prior declaration review:

- Reuse SHA-256: `14dfeacdb2c531230aab9d6c407968b5b2a063c5643a320272e8a431e90ddf73`
- Reviewed meaning: The multiplicative monoid structure on the reals.

Independently determine this declaration's effect on the current proposition.

### D077: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5fc7a7becbc71d472fa1a28bd92d79b4c6ea4fdc643db7380031a2b890ca7e15`

Hash-verified prior declaration review:

- Reuse SHA-256: `649ca2d324c7a6a33283d748d5ffa754e65ba2230999aae49e5fd73bd6e998fd`
- Reviewed meaning: Casting natural numbers into the reals.

Independently determine this declaration's effect on the current proposition.

### D078: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b4e24b050b7fb50c4c115c51d5cd4c1b180cae53633f58a38c7d5ce3ccf86c81`

Hash-verified prior declaration review:

- Reuse SHA-256: `1895cf63acffe5d4fae8e868c4fb288e4796efc65ff1cc7799012b732d878413`
- Reviewed meaning: The multiplicative identity on the reals.

Independently determine this declaration's effect on the current proposition.

### D079: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `d2fdb97b9d861fcf61e6dbea9993dfa0ca6aa16609742f215c35b3f7ddd16b8e`

Hash-verified prior declaration review:

- Reuse SHA-256: `ba4a6f8efb12044576927ea21ac267f7693eea5f1c3bd517deab7094282f77c4`
- Reviewed meaning: The RCLike analytic structure on the reals.

Independently determine this declaration's effect on the current proposition.

### D080: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `176f6db963262b2e26ccb87909dcbc821a02dce27ce627a92cde371b13125405`
- Reviewed meaning: The additive identity on the reals.

Independently determine this declaration's effect on the current proposition.

### D081: `Real.measurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `51b107725c4edbe40e50ff5651a2c7ee5a10037e341c2764964a6d6cc26d82a1`

Hash-verified prior declaration review:

- Reuse SHA-256: `8c1a0151c8a276b9c8069d8cba2180dceaaedf780c22141d4621bab7220af48c`
- Reviewed meaning: The Borel measurable-space structure on the reals.

Independently determine this declaration's effect on the current proposition.

### D082: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Hash-verified prior declaration review:

- Reuse SHA-256: `55e5ab9c9d2ae6c5e5bf0703f601eb59e33ac8048d87091c33bf8c92753f3b23`
- Reviewed meaning: The normed additive commutative group structure on the reals.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `8a1f45ca5dd6bae6ea8a0a477c0460575127dcc21f80702f129aaa8f7f945a14`
- Reviewed meaning: The greatest element supplied by a Top structure.

Independently determine this declaration's effect on the current proposition.

### D085: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `4268bca5d70e9e8c286f657f0304531d42ba7f164186b399631e17f550db9d08`
- Reviewed meaning: The numeral-zero instance induced by a Zero structure.

Independently determine this declaration's effect on the current proposition.

### D086: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Hash-verified prior declaration review:

- Reuse SHA-256: `b5f8635411708ba37591169f6dbe2815457170151dda805703583321c212a3ed`
- Reviewed meaning: Homogeneous overloaded division induced by ordinary division.

Independently determine this declaration's effect on the current proposition.

### D087: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb300d353d84392c776cad5e356479f878030744a43f9a1584942a89d16350b4`

Hash-verified prior declaration review:

- Reuse SHA-256: `6dd2b6325fb103059b568eb1f22fc3dda777a6e4facc0d44c9da2374d2ab644f`
- Reviewed meaning: Homogeneous overloaded exponentiation induced by a Pow instance.

Independently determine this declaration's effect on the current proposition.

### D088: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `37355febc51d6fa8ff12fc8e7b429771db340390d46411d7608c566bdffd358d`

Hash-verified prior declaration review:

- Reuse SHA-256: `c0bc05b5bc6ccb4c9907a42ea10db1dba8585d8c357dae10d6f8307cd606e208`
- Reviewed meaning: A numeral instance for values at least two obtained by natural-number casting.

Independently determine this declaration's effect on the current proposition.

### D089: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7018dea92aae8c272f3a065f25e2bedb9732a0b602c3d54b166fa0cf2ce1ea92`

Hash-verified prior declaration review:

- Reuse SHA-256: `81cea43af5a2a72096cd8f3a68ac2eae30c70c5d346e06f3b148379a8914c9de`
- Reviewed meaning: The canonical interpretation of a natural numeral as itself.

Independently determine this declaration's effect on the current proposition.

### D090: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `fc363bb86fd9c29e754e22d842cff17acbad13559cb0e03d31f4863045cd3c07`

Hash-verified prior declaration review:

- Reuse SHA-256: `657094e00dbf02105dfa47c4ca25d96c2c8257349551eb89c128614528f5864a`
- Reviewed meaning: The top element of ENNReal, namely infinity.

Independently determine this declaration's effect on the current proposition.

### D091: `CompleteLinearOrder.toConditionallyCompleteLinearOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2aa802d0a9c75bf33917e1e0dc266a90886d32f434f1d43521c53f0f2c3449d0`

Hash-verified prior declaration review:

- Reuse SHA-256: `c19ec2432fa5799b2b19d38f9075e45810fa3b375ea6a8b834502d6c3848034d`
- Reviewed meaning: A conditionally complete linear order with a bottom element inherited from a complete linear order.

Independently determine this declaration's effect on the current proposition.

### D092: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `41576e47c21e72ff272622fb2a65e2858beda94a321ffdbc1128f58d338ee803`

Hash-verified prior declaration review:

- Reuse SHA-256: `dc159aff4c30100e2ad5134c323f482c81a1c3370cb7745ce3f4b1475e6af0e3`
- Reviewed meaning: The conditionally complete partial order inherited from a conditionally complete lattice.

Independently determine this declaration's effect on the current proposition.

### D093: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e1dad077d30ec2d5da19d9c26f0e709993b8eda004ce89d1f4086cf5f98094d5`

Hash-verified prior declaration review:

- Reuse SHA-256: `f79dc6b6c311ae7c12b3673a0dc841e2c5bd4a05085ba574fad2e2d3b16f6ee3`
- Reviewed meaning: The conditionally complete lattice inherited from a conditionally complete linear order.

Independently determine this declaration's effect on the current proposition.

### D094: `ConditionallyCompleteLinearOrderBot.toConditionallyCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `b25be2d55c4d466d6295ab5ff23a5cc915072a7d1cbc04c476d877743ce32dd9`

Hash-verified prior declaration review:

- Reuse SHA-256: `3759bdf4dea79f9dc000356e033b8ca488ab40c3193f5ce03478ea4a3b35f4f5`
- Reviewed meaning: The conditionally complete linear order obtained by forgetting the bottom element.

Independently determine this declaration's effect on the current proposition.

### D095: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `50e56dbfc6cb715ad5708fddc559a96fd43e4d11b7a8a33061c6cf440f5fc10c`

Hash-verified prior declaration review:

- Reuse SHA-256: `98b40acc51c3c5d19e777630dc236eb247e6a91db4f6a786a937db722d958a63`
- Reviewed meaning: The infimum-bearing structure inherited from a conditionally complete partial order.

Independently determine this declaration's effect on the current proposition.

### D096: `ConditionallyCompletePartialOrderInf.toInfSet`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `182c2ddbb044a41025806b24afd62f570b4197b3450b566022615ea4646e06cd`

Hash-verified prior declaration review:

- Reuse SHA-256: `c6239076cd694b6a06c021c62e9fc8be603ab68cc8f01e2ccd338b93d4005907`
- Reviewed meaning: The arbitrary-infimum operation inherited from a conditionally complete partial order.

Independently determine this declaration's effect on the current proposition.

### D097: `ENNReal.instCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2436cc4a7fc332a26b2b8879178b290fffb6ceaad2c2210667170bdf3119d835`

Hash-verified prior declaration review:

- Reuse SHA-256: `26e5d5f23009082acf06e79bde8ce23c68d3857fdac1fa5d988f42205c5d8604`
- Reviewed meaning: The complete linear order instance on the nonnegative extended reals.

Independently determine this declaration's effect on the current proposition.

### D098: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `05fd3d5f020f01654fb10fac2d3dca3f6e2698160c3fd5d57620fd80a211a099`
- Reviewed meaning: Overloaded addition.

Independently determine this declaration's effect on the current proposition.

### D099: `InfSet.sInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.SetNotation`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `76c82ed45915e35439b105eb3ec239e1937b2a2eafff41b96f451468dd90c61d`

Hash-verified prior declaration review:

- Reuse SHA-256: `d08871f46b3ec046abcb256752a7de58cdb830c3969d4b15129100acda93ccc0`
- Reviewed meaning: The infimum of a set in a type with an InfSet structure.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `eda6ef8cc107e4694a9b6e927f26c0d552a860073d4c02285b347bbff4879101`
- Reviewed meaning: A proposition witnessing that a natural number is at least two.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `03dc12cf64bca67d0f56233cd3cb7f9d6ab334e4b8eb927b6edd0ab053de5b23`
- Reviewed meaning: Natural-number addition.

Independently determine this declaration's effect on the current proposition.

### D106: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `9025c9b0d1b3308f15a0184c3e83135cb98b14f23a1356e3b84262fa4642d70d`
- Reviewed meaning: Homogeneous overloaded addition induced by ordinary addition.

Independently determine this declaration's effect on the current proposition.

### D107: `setOf`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `cee4433aebd78c308ec85f62ccd30489c00ec9cc23a98f4d2139c17f840f4988`

Hash-verified prior declaration review:

- Reuse SHA-256: `f1fd1cce789b021880495d20bdb3d36b4c2eddcb2b9193aaec850a208c54baa5`
- Reviewed meaning: The set specified by a predicate.

Independently determine this declaration's effect on the current proposition.

### D108: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `1aa070f54e8aff7a6558c977220472990963777ddc5f04c5284f49422c06b41f`

Hash-verified prior declaration review:

- Reuse SHA-256: `f7be662e4fb63a460b227e7681f6581656b29ffbfe7a1ed4580a100c88b266a9`
- Reviewed meaning: Conversion from a nonnegative extended real to a real, sending infinity to zero.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `3f9bfae1a19475d2be5d4851bb7aaeade2de870ad3597755120e6e0d0f171d4a`
- Reviewed meaning: Overloaded multiplication.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `c0c8197a8d556a355e49bc36eedbbb9ca1a5033dce88b4b5890678770bf6123d`
- Reviewed meaning: The less-than-or-equal relation supplied by an order instance.

Independently determine this declaration's effect on the current proposition.

### D113: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `51e5158e8f2f2a375463d510858200b96afa04fb8f33126da2c5d1c572a76165`

Hash-verified prior declaration review:

- Reuse SHA-256: `e27f5dfe6ddcdf60d92c53532b79fb0498325f1f48f1ee64cc34c258b9d64cdf`
- Reviewed meaning: A function is almost-everywhere strongly measurable and has finite integral norm.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `25986570110f966e40f9b74734a741f98c330c2c0cce0afb638881effcd67d4f`
- Reviewed meaning: Unary negation.

Independently determine this declaration's effect on the current proposition.

### D116: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `e51060aca94e56df84e143ea2fe84f3e0b3abf61b3eb86bb538e1d1b19053f28`
- Reviewed meaning: A structural coercion forgetting commutativity.

Independently determine this declaration's effect on the current proposition.

### D117: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `90542f93eeef00b019ff0595846c74ebb373ef7a0f3766013035609aedcb6313`
- Reviewed meaning: The seminormed additive commutative group inherited from a seminormed ring.

Independently determine this declaration's effect on the current proposition.

### D118: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `6ebffc92d8978ee6bf110a9d44b75368806d003a8f778cc01c0f77984ab8aabd`
- Reviewed meaning: The seminormed commutative-ring structure inherited from a normed commutative ring.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `afad637755cde12dec8cd5f81c6554cfa918240ab1e623fdd80d6b0a2392daa3`
- Reviewed meaning: The uniform structure inherited from a pseudometric space.

Independently determine this declaration's effect on the current proposition.

### D121: `Real.exp`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Complex.Exponential`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `69806b1af98b09fabed435ccc47a9f2f0840f9c5c140fb62cccc81a80761a984`

Hash-verified prior declaration review:

- Reuse SHA-256: `8532b855b60dccd67322ececf452a8d1375c9ca19eb442e30acbfae9f006d06a`
- Reviewed meaning: The real exponential function.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `6dace5c3039e89b6c4ad7dbcbc69986e9d784c0622980e95c631e11edd021a88`
- Reviewed meaning: The standard non-strict order on the reals.

Independently determine this declaration's effect on the current proposition.

### D125: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Hash-verified prior declaration review:

- Reuse SHA-256: `ef4aaa35cb13b110d6f5fce8dda6f059a3bd30e493b564b93889c13c45ace9e3`
- Reviewed meaning: Real multiplication.

Independently determine this declaration's effect on the current proposition.

### D126: `Real.instNeg`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `000951397468b3d1f8a2a1cca1de3812bc024916ff842cfd5454811130093b41`

Hash-verified prior declaration review:

- Reuse SHA-256: `1a18949aeba5a514c9c4b71620257f5a4023ec195824bb9978a58db4ca5d382a`
- Reviewed meaning: Real negation.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `c5bd3fd8b0350a9a8801e483d0cf6c6532ed76219026000bcbe2d05d98040550`
- Reviewed meaning: The normed commutative-ring structure on the reals.

Independently determine this declaration's effect on the current proposition.

### D129: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `2de55732ff61049883e38d501335ba08526258455b6ae2d6ebe0c34c85c627f2`
- Reviewed meaning: The pseudometric structure on the reals induced by absolute difference.

Independently determine this declaration's effect on the current proposition.

### D130: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `8cf35215f509cdee10a3a95158cbaadd3c5fb584bc0d1f4fad6ecfc69b1bd205`

Hash-verified prior declaration review:

- Reuse SHA-256: `c9d1af6fae57b3701e3881b4a4ac0b00fe01b5d10c713d8e6ee3399f8b205f17`
- Reviewed meaning: A structural coercion forgetting commutativity of a seminormed additive group.

Independently determine this declaration's effect on the current proposition.

### D131: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `17a83cbf3059dd0bbaefd43c93ce329f1d6b760d440889322b3582a18b23a141`

Hash-verified prior declaration review:

- Reuse SHA-256: `88eed3c6ae634ca6279322db2280f4824f98f5d5bd372a89f7406da957cabeb1`
- Reviewed meaning: Continuity of the extended norm in a seminormed additive group.

Independently determine this declaration's effect on the current proposition.

### D132: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `8206dfab064534c2766b92e638acd94500658d5218cc5930ed2039341b894d4e`
- Reviewed meaning: A structural coercion forgetting the unit from a seminormed commutative ring.

Independently determine this declaration's effect on the current proposition.

### D133: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Hash-verified prior declaration review:

- Reuse SHA-256: `27efcde3c2eb16d9c33617cc2465e775f81233426effe8f2d621958021d2bee4`
- Reviewed meaning: The topology inherited from a uniform space.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `ba9d44567b40a22346f1b4c3eababf265f09ad9c9dea9bbb761e79d7e9bf5211`
- Reviewed meaning: Homogeneous overloaded multiplication induced by ordinary multiplication.

Independently determine this declaration's effect on the current proposition.

### D137: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `6e5878abb65d5809d3258e569c8ff0f08b39804b377a07fec18d700b4e3fea86`

Hash-verified prior declaration review:

- Reuse SHA-256: `dd64b75ae2d1f11a1606e715be8fd8b10886d2445fd795e102aea7ca3eb1356e`
- Reviewed meaning: The zero element of ENNReal.

Independently determine this declaration's effect on the current proposition.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `067fa6bdb8b15a89db34c8e47c214161a48e117cb5cbb09ddf83ceed3ee6ce55`
- Reviewed meaning: Real exponentiation by a real exponent, implemented by real rpow.

Independently determine this declaration's effect on the current proposition.

### D140: `Real.sqrt`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Sqrt`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `67f9248ae1acb851b5392be301057ebb8b8ef2fb20f76d2d53a2d07ec8f30553`

Hash-verified prior declaration review:

- Reuse SHA-256: `73ccf367e31338fa8bb944e7309a3c48f679d5ef27cecd2e71f57b37c10ef539`
- Reviewed meaning: The nonnegative real square root.

Independently determine this declaration's effect on the current proposition.
