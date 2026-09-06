# Blind Lean declaration dossier

Translate only the mathematical proposition below. Source identity, task metadata,
theorem name, source declaration, proof, and repository commentary are excluded.
Do not use tools or inspect filesystem content.

## Elaborated target type

```lean
∀ (p : Real),
  Real.instLE.le 1 p →
    Eq (MeasureTheory.eLpNorm' (fun x => x) p (ProbabilityTheory.gaussianReal 0 1)).toReal
      (instHPow.hPow
        (instHDiv.hDiv
          (instHMul.hMul (instHPow.hPow 2 (instHDiv.hDiv p 2)) (Real.Gamma (instHDiv.hDiv (instHAdd.hAdd 1 p) 2)))
          (Real.Gamma (1 / 2)))
        (instHDiv.hDiv 1 p))
```

## Fully explicit elaborated target type

```lean
∀ (p : Real)
  (hp : @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)) p),
  @Eq.{1} Real
    (ENNReal.toReal
      (@MeasureTheory.eLpNorm'.{0, 0} Real Real
        (@ContinuousENorm.toENorm.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real
              (@SeminormedAddGroup.toPseudoMetricSpace.{0} Real
                (@SeminormedAddCommGroup.toSeminormedAddGroup.{0} Real
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))))))
          (@SeminormedAddGroup.toContinuousENorm.{0} Real
            (@SeminormedAddCommGroup.toSeminormedAddGroup.{0} Real
              (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                    (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing)))))))
        Real.measurableSpace (fun (x : Real) => x) p
        (ProbabilityTheory.gaussianReal (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
          (@OfNat.ofNat.{0} NNReal (nat_lit 1) (@One.toOfNat1.{0} NNReal instOneNNReal)))))
    (@HPow.hPow.{0, 0, 0} Real Real Real (@instHPow.{0, 0} Real Real Real.instPow)
      (@HDiv.hDiv.{0, 0, 0} Real Real Real (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
        (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
          (@HPow.hPow.{0, 0, 0} Real Real Real (@instHPow.{0, 0} Real Real Real.instPow)
            (@OfNat.ofNat.{0} Real (nat_lit 2)
              (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                  (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))))))
            (@HDiv.hDiv.{0, 0, 0} Real Real Real
              (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid)) p
              (@OfNat.ofNat.{0} Real (nat_lit 2)
                (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                  (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                    (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))))))))
          (Real.Gamma
            (@HDiv.hDiv.{0, 0, 0} Real Real Real
              (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
              (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)) p)
              (@OfNat.ofNat.{0} Real (nat_lit 2)
                (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                  (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                    (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))))))))))
        (Real.Gamma
          (@HDiv.hDiv.{0, 0, 0} Real Real Real (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
            (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
            (@OfNat.ofNat.{0} Real (nat_lit 2)
              (@instOfNatAtLeastTwo.{0} Real (nat_lit 2) Real.instNatCast
                (@Nat.instAtLeastTwoHAddOfNat (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
                  (@Nat.instNeZeroSucc (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))))))))))
      (@HDiv.hDiv.{0, 0, 0} Real Real Real (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
        (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)) p))
```

## Complete semantic dependency inventory

Return exactly one coverage record for every dependency ID, in order.

### D001: `ContinuousENorm.toENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `31fb1ad5ceaae342dc2fe1c1f2eba1b18e67d9d01a5451201d210b585bde97c0`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ContinuousENorm E] → ENorm E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ContinuousENorm E] => self.1
```

### D002: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Type:

```lean
{G : Type u} → [self : DivInvMonoid G] → Div G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : DivInvMonoid G] => self.3
```

### D003: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1aa070f54e8aff7a6558c977220472990963777ddc5f04c5284f49422c06b41f`

Type:

```lean
ENNReal → Real
```

Definition body (one-level semantic boundary):

```lean
fun a => a.toNNReal.toReal
```

### D004: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D005: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D006: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HDiv α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HDiv α β γ] => self.1
```

### D007: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4e00447a4a8ef4c2ce13e307c56a1fbcd7fa8c732fe039a452b42477a50df2c6`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HMul α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HMul α β γ] => self.1
```

### D008: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6196b8cbb884c4f39841ba74b23d75f3c753fe0d044cc402bd6e4e3bd59d5cb8`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HPow α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HPow α β γ] => self.1
```

### D009: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `54a32f2661f788eb2b860006c4d1e8031e126febafe1c8d03ce50529b773dc48`

Type:

```lean
{α : Type u} → [self : LE α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LE α] => self.1
```

### D010: `MeasureTheory.eLpNorm'`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.LpSeminorm.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a7bd7c40122abd67b3a66e836b5d68adef012633dfc7504d714074b70cb1c501`

Type:

```lean
{α : Type u_1} →
  {ε : Type u_2} → [ENorm ε] → {x : MeasurableSpace α} → (α → ε) → Real → MeasureTheory.Measure α → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {α} {ε} [inst : ENorm ε] {x} f q μ =>
  instHPow.hPow (MeasureTheory.lintegral μ fun a => instHPow.hPow (inst.enorm (f a)) q) (instHDiv.hDiv 1 q)
```

### D011: `NNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.NNReal.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `490ebc1f72b3ced8506e1bcbd0016d4c351adf097644509fd1dd17a93c4e950f`

Type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
Subtype fun r => Real.instLE.le 0 r
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

### D013: `Nat.instAtLeastTwoHAddOfNat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Init`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `309ef94c4b7cfbe2e668952e6915279353921d5d48b6123a30f90dd932dac3e6`

Type:

```lean
∀ (n : Nat) [NeZero n], (instHAdd.hAdd n 1).AtLeastTwo
```

### D014: `Nat.instNeZeroSucc`

- Role: `external-frontier`
- Owner module: `Init.Data.Nat.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `a0735a528184c05594c4c79312c1225bb4dcffcdf0df7eb1a50c5733047c85ad`

Type:

```lean
∀ {n : Nat}, NeZero (instHAdd.hAdd n 1)
```

### D015: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing α] → NonUnitalSeminormedRing α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSeminormedCommRing α] => self.1
```

### D016: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D017: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D018: `OfNat.ofNat`

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

### D019: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `cc544b5b2a2aabc84389a9fe2f052127dc6dae9964782b117b9b19b773e542d5`

Type:

```lean
{α : Type u_1} → [One α] → OfNat α 1
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : One α] => { ofNat := inst.one }
```

### D020: `ProbabilityTheory.gaussianReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Distributions.Gaussian.Real`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `640e905d8e9530cec4dfeaf3d53f9e2b0e193d42ec6b75a24f451a6c1e866b28`

Type:

```lean
Real → NNReal → MeasureTheory.Measure Real
```

Definition body (one-level semantic boundary):

```lean
fun μ v =>
  ite (Eq v 0) (MeasureTheory.Measure.dirac μ)
    (Real.measureSpace.volume.withDensity (ProbabilityTheory.gaussianPDF μ v))
```

### D021: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D022: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

### D023: `Real.Gamma`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.SpecialFunctions.Gamma.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7ac5601b1b9510a80be469d3b6fafaa27417cac292582637ccfb8a08541d7904`

Type:

```lean
Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun s => (Complex.Gamma (Complex.ofReal s)).re
```

### D024: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Type:

```lean
Add Real
```

Definition body (one-level semantic boundary):

```lean
{ add := Real.add✝ }
```

### D025: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D026: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `144d825fc543455e17044e843560e0415f8e4e9da60afb52f34edb809b7c34d3`

Type:

```lean
LE Real
```

Definition body (one-level semantic boundary):

```lean
{ le := Real.le✝ }
```

### D027: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Type:

```lean
Mul Real
```

Definition body (one-level semantic boundary):

```lean
{ mul := Real.mul✝ }
```

### D028: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5fc7a7becbc71d472fa1a28bd92d79b4c6ea4fdc643db7380031a2b890ca7e15`

Type:

```lean
NatCast Real
```

Definition body (one-level semantic boundary):

```lean
{ natCast := fun n => { cauchy := n.cast } }
```

### D029: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b4e24b050b7fb50c4c115c51d5cd4c1b180cae53633f58a38c7d5ce3ccf86c81`

Type:

```lean
One Real
```

Definition body (one-level semantic boundary):

```lean
{ one := Real.one✝ }
```

### D030: `Real.instPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.SpecialFunctions.Pow.Real`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d7348547260a6fa37dab6a95efbf0e3e5560a074d2443d0cb606f21bce228fe0`

Type:

```lean
Pow Real Real
```

Definition body (one-level semantic boundary):

```lean
{ pow := Real.rpow }
```

### D031: `Real.instZero`

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

### D032: `Real.measurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `51b107725c4edbe40e50ff5651a2c7ee5a10037e341c2764964a6d6cc26d82a1`

Type:

```lean
MeasurableSpace Real
```

Definition body (one-level semantic boundary):

```lean
borel Real
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

### D034: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D035: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `17a83cbf3059dd0bbaefd43c93ce329f1d6b760d440889322b3582a18b23a141`

Type:

```lean
{E : Type u_4} → [inst : SeminormedAddGroup E] → ContinuousENorm E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [SeminormedAddGroup E] => { toENorm := NNNorm.toENorm, continuous_enorm := ⋯ }
```

### D036: `SeminormedAddGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `d4043bb9912319b688406ba77c3a5b0fdd8f53ab605cf1962721b51314c66d3f`

Type:

```lean
{E : Type u_8} → [self : SeminormedAddGroup E] → PseudoMetricSpace E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : SeminormedAddGroup E] => self.3
```

### D037: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D038: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
```

### D039: `Zero.toOfNat0`

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

### D040: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D041: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Type:

```lean
{α : Type u_1} → [Div α] → HDiv α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Div α] => { hDiv := fun a b => inst.div a b }
```

### D042: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1fd375514ac68e29e7941c94ba308ea936395db23d0fee63a5c69dcccd3b2bdc`

Type:

```lean
{α : Type u_1} → [Mul α] → HMul α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Mul α] => { hMul := fun a b => inst.mul a b }
```

### D043: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `eb300d353d84392c776cad5e356479f878030744a43f9a1584942a89d16350b4`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [Pow α β] → HPow α β α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : Pow α β] => { hPow := fun a b => inst.pow a b }
```

### D044: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `37355febc51d6fa8ff12fc8e7b429771db340390d46411d7608c566bdffd358d`

Type:

```lean
{R : Type u_1} → {n : Nat} → [NatCast R] → [n.AtLeastTwo] → OfNat R n
```

Definition body (one-level semantic boundary):

```lean
fun {R} {n} [NatCast R] [n.AtLeastTwo] => { ofNat := n.cast }
```

### D045: `instOfNatNat`

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

### D046: `instOneNNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.NNReal.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `be1ba7c9e9b4395e59c17c7a89b726801d594c6c78763ffff9bb49c61ecf93a2`

Type:

```lean
One NNReal
```

Definition body (one-level semantic boundary):

```lean
Nonneg.one
```
