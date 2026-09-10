# Declaration dossier for HDP-02-EX-2.5.11

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem hdp_02_hex_h2_d5_d11 :
    hdp_02_hex_h2_d5_d11__contract_type
```

## Elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hex_h2_d5_d11__contract_type
```

## Fully explicit elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hex_h2_d5_d11__contract_type.{u_1}
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Exercise11.Signature`
- `ComputationalMathematics.Analysis.Probability.Gaussian.AbsoluteMoment` imports: `Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral`, `Mathlib.MeasureTheory.Integral.Gamma`, `Mathlib.Probability.Distributions.Gaussian.Real`, `Mathlib.Probability.Independence.Basic`
- `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic` imports: `Mathlib.Probability.ProbabilityMassFunction.Binomial`, `Mathlib.Probability.ProbabilityMassFunction.Integrals`, `Mathlib.Probability.Distributions.Gaussian.Real`, `Mathlib.Probability.Distributions.Poisson`, `Mathlib.MeasureTheory.Function.ConvergenceInDistribution`, `Mathlib.Probability.StrongLaw`, `Mathlib.Tactic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Equation05.Contract` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.PoissonDistribution.Contract` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.VarianceOfSum.Contract` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- `ComputationalMathematics.HDP.Scalar.LimitTheorems` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`, `ComputationalMathematics.Source.Vershynin.Chapter01.Equation05.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.PoissonDistribution.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.VarianceOfSum.Contract`
- `ComputationalMathematics.HDP.Scalar.GaussianTails` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems`
- `ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw` imports: `Mathlib.Probability.Combinatorics.BinomialRandomGraph.Defs`, `Mathlib.Combinatorics.SimpleGraph.Finite`, `Mathlib.Probability.HasLaw`, `Mathlib.Probability.ProbabilityMassFunction.Binomial`, `Mathlib.Tactic`
- `ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeDecoupling` imports: `ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw`, `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`, `Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics`, `Mathlib.Data.Nat.Choose.Bounds`, `Mathlib.Probability.Independence.InfinitePi`
- `ComputationalMathematics.HDP.Scalar.GaussianMaxima` imports: `ComputationalMathematics.Analysis.Probability.Gaussian.AbsoluteMoment`, `ComputationalMathematics.HDP.Scalar.GaussianTails`, `ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeDecoupling`, `Mathlib.Probability.Independence.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Exercise11.Signature` imports: `ComputationalMathematics.HDP.Scalar.GaussianMaxima`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Contract.hdp_02_hex_h2_d5_d11__contract_type`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Exercise11.Signature`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7478b98ae6d5f03de97a15a2847de511bfcb5dc9dd94ad6cd59c2d1e5869a1dd`

Type:

```lean
Prop
```

Fully explicit type:

```lean
Prop
```

Definition body (one-level semantic boundary):

```lean
Exists fun c =>
  And (Real.instLT.lt 0 c)
    (∀ (Ω : Type u_1) [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω) [MeasureTheory.IsProbabilityMeasure μ]
      (X : Nat → Ω → Real) (N : Nat),
      instLTNat.lt 0 N →
        (∀ (i : Fin N), Measurable (X i.val)) →
          (∀ (i : Fin N),
              ProbabilityTheory.HasLaw (X i.val) NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw μ) →
            ProbabilityTheory.iIndepFun (fun i => X i.val) μ →
              And (MeasureTheory.Integrable (NumStability.HDP.Scalar.GaussianMaxima.prefixMaximum X N) μ)
                (Real.instLE.le (instHMul.hMul c (Real.log N.cast).sqrt)
                  (MeasureTheory.integral μ fun ω => NumStability.HDP.Scalar.GaussianMaxima.prefixMaximum X N ω)))
```

### D002: `NumStability.HDP.Scalar.GaussianMaxima.prefixMaximum`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.GaussianMaxima`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `16b4e5a05980e611247daed5bbf0830e0a2554b6a8b054e32a8e4b571cf8aa78`

Type:

```lean
{Ω : Type u_1} → (Nat → Ω → Real) → Nat → Ω → Real
```

Fully explicit type:

```lean
{Ω : Type u_1} → (X : Nat → Ω → Real) → (N : Nat) → Ω → Real
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} X N =>
  if hN : instLTNat.lt 0 N then NumStability.HDP.Scalar.GaussianMaxima.finiteMaximum fun i => X i.val else fun x => 0
```

### D003: `NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e1fdded5042237a84d8f9ac5d692a0a71dd0e07c7799b57297139308b26ad442`

Type:

```lean
MeasureTheory.Measure Real
```

Fully explicit type:

```lean
@MeasureTheory.Measure.{0} Real Real.measurableSpace
```

Definition body (one-level semantic boundary):

```lean
ProbabilityTheory.gaussianReal 0 1
```

### D004: `NumStability.HDP.Scalar.GaussianMaxima.finiteMaximum`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.GaussianMaxima`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `3ba590229bc0ae65b16cd93854944e518b21600c7d9b11c76f4ef5ece5033d0b`

Type:

```lean
{ι : Type u_1} → {Ω : Type u_2} → [Fintype ι] → [Nonempty ι] → (ι → Ω → Real) → Ω → Real
```

Fully explicit type:

```lean
{ι : Type u_1} → {Ω : Type u_2} → [Fintype.{u_1} ι] → [Nonempty.{u_1 + 1} ι] → (X : ι → Ω → Real) → Ω → Real
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {Ω} [Fintype ι] [Nonempty ι] X => Finset.univ.sup' ⋯ X
```

### D005: `NumStability.HDP.Scalar.GaussianMaxima.prefixMaximum._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.GaussianMaxima`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `83d92dfcb73b06468cc6aafdc957a9e20f848c1afefe7383a34331c0fcf85e65`

Type:

```lean
∀ (N : Nat), instLTNat.lt 0 N → Nonempty (Fin N)
```

Fully explicit type:

```lean
∀ (N : Nat) (hN : @LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) N),
  Nonempty.{1} (Fin N)
```

### D006: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D007: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Prop
```

### D008: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

Fully explicit type:

```lean
(n : Nat) → Type
```

### D009: `Fin.val`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `74cc6296b3a13207507ec372ef420f5e52b6935895dd25bcc6331abde2a4b328`

Type:

```lean
{n : Nat} → Fin n → Nat
```

Fully explicit type:

```lean
{n : Nat} → (self : Fin n) → Nat
```

Definition body (one-level semantic boundary):

```lean
fun n self => self.1
```

### D010: `HMul.hMul`

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

### D011: `InnerProductSpace.toNormedSpace`

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

Fully explicit type:

```lean
{𝕜 : Type u_4} →
  {E : Type u_5} →
    {inst : RCLike.{u_4} 𝕜} →
      {inst_1 : SeminormedAddCommGroup.{u_5} E} →
        [self : @InnerProductSpace.{u_4, u_5} 𝕜 E inst inst_1] →
          @NormedSpace.{u_4, u_5} 𝕜 E
            (@DenselyNormedField.toNormedField.{u_4} 𝕜 (@RCLike.toDenselyNormedField.{u_4} 𝕜 inst)) inst_1
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : InnerProductSpace 𝕜 E] => self.1
```

### D012: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `54a32f2661f788eb2b860006c4d1e8031e126febafe1c8d03ce50529b773dc48`

Type:

```lean
{α : Type u} → [self : LE α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u} → [self : LE.{u} α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LE α] => self.1
```

### D013: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D014: `Measurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6d56983cd98232a62c5c1b4a0368519a8b381777b32b6e8301ade2ccd7f4c3a4`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → [MeasurableSpace α] → [MeasurableSpace β] → (α → β) → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → [MeasurableSpace.{u_1} α] → [MeasurableSpace.{u_2} β] → (f : α → β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [MeasurableSpace α] [MeasurableSpace β] f =>
  ∀ ⦃t : Set β⦄, MeasurableSet t → MeasurableSet (Set.preimage f t)
```

### D015: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

Fully explicit type:

```lean
(α : Type u_7) → Type u_7
```

### D016: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `51e5158e8f2f2a375463d510858200b96afa04fb8f33126da2c5d1c572a76165`

Type:

```lean
{ε : Type u_5} →
  [inst : TopologicalSpace ε] →
    [ContinuousENorm ε] →
      {α : Type u_8} →
        {x : MeasurableSpace α} → (α → ε) → autoParam (MeasureTheory.Measure α) MeasureTheory.Integrable._auto_1 → Prop
```

Fully explicit type:

```lean
{ε : Type u_5} →
  [inst : TopologicalSpace.{u_5} ε] →
    [@ContinuousENorm.{u_5} ε inst] →
      {α : Type u_8} →
        {x : MeasurableSpace.{u_8} α} →
          (f : α → ε) →
            (μ : autoParam.{u_8 + 1} (@MeasureTheory.Measure.{u_8} α x) MeasureTheory.Integrable._auto_1) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ε} [TopologicalSpace ε] [ContinuousENorm ε] {α} {x} f μ =>
  And (MeasureTheory.AEStronglyMeasurable f μ) (MeasureTheory.HasFiniteIntegral f μ)
```

### D017: `MeasureTheory.IsProbabilityMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `f88b269cb95d165125e7553fd22f97d6e5f9b1b9bcdec7f6738a781dc674bf89`

Type:

```lean
{α : Type u_1} → {m0 : MeasurableSpace α} → MeasureTheory.Measure α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → {m0 : MeasurableSpace.{u_1} α} → (μ : @MeasureTheory.Measure.{u_1} α m0) → Prop
```

### D018: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

Fully explicit type:

```lean
(α : Type u_6) → [MeasurableSpace.{u_6} α] → Type u_6
```

### D019: `MeasureTheory.integral`

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

Fully explicit type:

```lean
{α : Type u_6} →
  {G : Type u_7} →
    [inst : NormedAddCommGroup.{u_7} G] →
      [@NormedSpace.{0, u_7} Real G Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_7} G inst)] →
        {x : MeasurableSpace.{u_6} α} → (μ : @MeasureTheory.Measure.{u_6} α x) → (f : α → G) → G
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.wrapped✝.1
```

### D020: `Nat`

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

### D021: `Nat.cast`

- Role: `external-frontier`
- Owner module: `Init.Data.Cast`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6e24327ea908b1837083bb15aef27d593e950a2ff8ade81d8aa94bfe33b64450`

Type:

```lean
{R : Type u} → [NatCast R] → Nat → R
```

Fully explicit type:

```lean
{R : Type u} → [NatCast.{u} R] → Nat → R
```

Definition body (one-level semantic boundary):

```lean
fun {R} [inst : NatCast R] => inst.natCast
```

### D022: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing α] → NonUnitalSeminormedRing α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NonUnitalSeminormedCommRing.{u_5} α] → NonUnitalSeminormedRing.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSeminormedCommRing α] => self.1
```

### D023: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Type:

```lean
{α : Type u_2} → [NonUnitalSeminormedRing α] → SeminormedAddCommGroup α
```

Fully explicit type:

```lean
{α : Type u_2} → [NonUnitalSeminormedRing.{u_2} α] → SeminormedAddCommGroup.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : NonUnitalSeminormedRing α] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D024: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → SeminormedAddCommGroup E
```

Fully explicit type:

```lean
{E : Type u_5} → [NormedAddCommGroup.{u_5} E] → SeminormedAddCommGroup.{u_5} E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D025: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → SeminormedCommRing α
```

Fully explicit type:

```lean
{α : Type u_2} → [β : NormedCommRing.{u_2} α] → SeminormedCommRing.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toRing := β.toRing, toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯,
    norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D026: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D027: `ProbabilityTheory.HasLaw`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.HasLaw`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `b66448329d53bdea7204a60f6d944b6a9eb06e2e4257d8be3c0b23a303d6159a`

Type:

```lean
{Ω : Type u_1} →
  {𝓧 : Type u_2} →
    {mΩ : MeasurableSpace Ω} →
      {m𝓧 : MeasurableSpace 𝓧} →
        (Ω → 𝓧) → MeasureTheory.Measure 𝓧 → autoParam (MeasureTheory.Measure Ω) ProbabilityTheory.HasLaw._auto_1 → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  {𝓧 : Type u_2} →
    {mΩ : MeasurableSpace.{u_1} Ω} →
      {m𝓧 : MeasurableSpace.{u_2} 𝓧} →
        (X : Ω → 𝓧) →
          (μ : @MeasureTheory.Measure.{u_2} 𝓧 m𝓧) →
            (P : autoParam.{u_1 + 1} (@MeasureTheory.Measure.{u_1} Ω mΩ) ProbabilityTheory.HasLaw._auto_1) → Prop
```

### D028: `ProbabilityTheory.iIndepFun`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Independence.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `fc42c9fb6cb6d72ada8e7605b71644561e188fc9c555246dd3ef51d84fa13130`

Type:

```lean
{Ω : Type u_1} →
  {ι : Type u_2} →
    {_mΩ : MeasurableSpace Ω} →
      {β : ι → Type u_6} →
        [m : (x : ι) → MeasurableSpace (β x)] →
          ((x : ι) → Ω → β x) → autoParam (MeasureTheory.Measure Ω) ProbabilityTheory.iIndepFun._auto_1 → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  {ι : Type u_2} →
    {_mΩ : MeasurableSpace.{u_1} Ω} →
      {β : ι → Type u_6} →
        [m : (x : ι) → MeasurableSpace.{u_6} (β x)] →
          (f : (x : ι) → Ω → β x) →
            (μ : autoParam.{u_1 + 1} (@MeasureTheory.Measure.{u_1} Ω _mΩ) ProbabilityTheory.iIndepFun._auto_1) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} {ι} {_mΩ} {β} [(x : ι) → MeasurableSpace (β x)] f μ =>
  ProbabilityTheory.Kernel.iIndepFun f (ProbabilityTheory.Kernel.const Unit μ) (MeasureTheory.Measure.dirac Unit.unit)
```

### D029: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → UniformSpace α
```

Fully explicit type:

```lean
{α : Type u} → [self : PseudoMetricSpace.{u} α] → UniformSpace.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.7
```

### D030: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f602276baee30d3dbe02bd6b756a9097f750d59a7f91ca7635dcfc935fd22981`

Type:

```lean
{𝕜 : Type u_1} → [inst : RCLike 𝕜] → InnerProductSpace Real 𝕜
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : RCLike.{u_1} 𝕜] →
    @InnerProductSpace.{0, u_1} Real 𝕜 Real.instRCLike
      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{u_1} 𝕜
        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{u_1} 𝕜
          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{u_1} 𝕜
            (@NormedCommRing.toSeminormedCommRing.{u_1} 𝕜
              (@NormedField.toNormedCommRing.{u_1} 𝕜
                (@DenselyNormedField.toNormedField.{u_1} 𝕜 (@RCLike.toDenselyNormedField.{u_1} 𝕜 inst)))))))
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [RCLike 𝕜] =>
  let __spread.0 := Inner.rclikeToReal 𝕜 𝕜;
  { toNormedSpace := NormedAlgebra.toNormedSpace 𝕜, toInner := __spread.0, norm_sq_eq_re_inner := ⋯,
    conj_inner_symm := ⋯, add_left := ⋯, smul_left := ⋯ }
```

### D031: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D032: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `144d825fc543455e17044e843560e0415f8e4e9da60afb52f34edb809b7c34d3`

Type:

```lean
LE Real
```

Fully explicit type:

```lean
LE.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ le := Real.le✝ }
```

### D033: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D034: `Real.instMul`

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

### D035: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5fc7a7becbc71d472fa1a28bd92d79b4c6ea4fdc643db7380031a2b890ca7e15`

Type:

```lean
NatCast Real
```

Fully explicit type:

```lean
NatCast.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ natCast := fun n => { cauchy := n.cast } }
```

### D036: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `d2fdb97b9d861fcf61e6dbea9993dfa0ca6aa16609742f215c35b3f7ddd16b8e`

Type:

```lean
RCLike Real
```

Fully explicit type:

```lean
RCLike.{0} Real
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

### D037: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D038: `Real.log`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.SpecialFunctions.Log.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `0fc1548c4e035ffc98e6286d9013e4f3ecf2a9759ac9b01e450f593e258ae39a`

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
fun x => if hx : Eq x 0 then 0 else (instFunLikeOrderIso (Set.Ioi 0).Elem Real).coe Real.expOrderIso.symm ⟨abs x, ⋯⟩
```

### D039: `Real.measurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `51b107725c4edbe40e50ff5651a2c7ee5a10037e341c2764964a6d6cc26d82a1`

Type:

```lean
MeasurableSpace Real
```

Fully explicit type:

```lean
MeasurableSpace.{0} Real
```

Definition body (one-level semantic boundary):

```lean
borel Real
```

### D040: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Type:

```lean
NormedAddCommGroup Real
```

Fully explicit type:

```lean
NormedAddCommGroup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toNorm := Real.norm, toAddCommGroup := Real.instAddCommGroup, toMetricSpace := Real.metricSpace, dist_eq := ⋯ }
```

### D041: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D042: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Type:

```lean
PseudoMetricSpace Real
```

Fully explicit type:

```lean
PseudoMetricSpace.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ dist := fun x y => abs (instHSub.hSub x y), dist_self := Real.pseudoMetricSpace._proof_1, dist_comm := ⋯,
  dist_triangle := ⋯, edist_dist := Real.pseudoMetricSpace._proof_2, uniformity_dist := Real.pseudoMetricSpace._proof_3,
  cobounded_sets := Real.pseudoMetricSpace._proof_4 }
```

### D043: `Real.sqrt`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Sqrt`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D044: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `8cf35215f509cdee10a3a95158cbaadd3c5fb584bc0d1f4fad6ecfc69b1bd205`

Type:

```lean
{E : Type u_5} → [SeminormedAddCommGroup E] → SeminormedAddGroup E
```

Fully explicit type:

```lean
{E : Type u_5} → [SeminormedAddCommGroup.{u_5} E] → SeminormedAddGroup.{u_5} E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : SeminormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    dist_eq := ⋯ }
```

### D045: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `17a83cbf3059dd0bbaefd43c93ce329f1d6b760d440889322b3582a18b23a141`

Type:

```lean
{E : Type u_4} → [inst : SeminormedAddGroup E] → ContinuousENorm E
```

Fully explicit type:

```lean
{E : Type u_4} →
  [inst : SeminormedAddGroup.{u_4} E] →
    @ContinuousENorm.{u_4} E
      (@UniformSpace.toTopologicalSpace.{u_4} E
        (@PseudoMetricSpace.toUniformSpace.{u_4} E (@SeminormedAddGroup.toPseudoMetricSpace.{u_4} E inst)))
```

Definition body (one-level semantic boundary):

```lean
fun {E} [SeminormedAddGroup E] => { toENorm := NNNorm.toENorm, continuous_enorm := ⋯ }
```

### D046: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Type:

```lean
{α : Type u_2} → [β : SeminormedCommRing α] → NonUnitalSeminormedCommRing α
```

Fully explicit type:

```lean
{α : Type u_2} → [β : SeminormedCommRing.{u_2} α] → NonUnitalSeminormedCommRing.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : SeminormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toPseudoMetricSpace := β.toPseudoMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D047: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Type:

```lean
{α : Type u} → [self : UniformSpace α] → TopologicalSpace α
```

Fully explicit type:

```lean
{α : Type u} → [self : UniformSpace.{u} α] → TopologicalSpace.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : UniformSpace α] => self.1
```

### D048: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D049: `instHMul`

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

### D050: `instLTNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `4054f2341fdda887b2040c624c0867866ab56eabf3441d6ffc9451c94ae1663c`

Type:

```lean
LT Nat
```

Fully explicit type:

```lean
LT.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
{ lt := Nat.lt }
```

### D051: `instOfNatNat`

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

### D052: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D053: `NNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.NNReal.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `490ebc1f72b3ced8506e1bcbd0016d4c351adf097644509fd1dd17a93c4e950f`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

Definition body (one-level semantic boundary):

```lean
Subtype fun r => Real.instLE.le 0 r
```

### D054: `Nat.decLt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `652ffb54717682f55eafca6c2b47fca31dfea599c9898709ba2f56fbc9113d99`

Type:

```lean
(n m : Nat) → Decidable (instLTNat.lt n m)
```

Fully explicit type:

```lean
(n m : Nat) → Decidable (@LT.lt.{0} Nat instLTNat n m)
```

Definition body (one-level semantic boundary):

```lean
fun n m => n.succ.decLe m
```

### D055: `Not`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `0bfdacbe07f6cbb8995b354e36299fd742f29398c188d7cc23dedcdc47f57a9a`

Type:

```lean
Prop → Prop
```

Fully explicit type:

```lean
(a : Prop) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun a => a → False
```

### D056: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D057: `ProbabilityTheory.gaussianReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Distributions.Gaussian.Real`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `640e905d8e9530cec4dfeaf3d53f9e2b0e193d42ec6b75a24f451a6c1e866b28`

Type:

```lean
Real → NNReal → MeasureTheory.Measure Real
```

Fully explicit type:

```lean
(μ : Real) → (v : NNReal) → @MeasureTheory.Measure.{0} Real Real.measurableSpace
```

Definition body (one-level semantic boundary):

```lean
fun μ v =>
  ite (Eq v 0) (MeasureTheory.Measure.dirac μ)
    (Real.measureSpace.volume.withDensity (ProbabilityTheory.gaussianPDF μ v))
```

### D058: `dite`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a2551097d29bac847f3c59e8213b5882afd4a95e9247c2382e8bce33011974b5`

Type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → (c → α) → (Not c → α) → α
```

Fully explicit type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → (t : c → α) → (e : Not c → α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} c [h : Decidable c] t e => Decidable.casesOn h e t
```

### D059: `instOneNNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.NNReal.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `be1ba7c9e9b4395e59c17c7a89b726801d594c6c78763ffff9bb49c61ecf93a2`

Type:

```lean
One NNReal
```

Fully explicit type:

```lean
One.{0} NNReal
```

Definition body (one-level semantic boundary):

```lean
Nonneg.one
```

### D060: `Finset.sup'`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Lattice.Fold`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f60aa2669fe61f525e27954772ac7266c71b507a2bf91aaf68fc80f020ef7def`

Type:

```lean
{α : Type u_2} → {β : Type u_3} → [SemilatticeSup α] → (s : Finset β) → s.Nonempty → (β → α) → α
```

Fully explicit type:

```lean
{α : Type u_2} →
  {β : Type u_3} → [SemilatticeSup.{u_2} α] → (s : Finset.{u_3} β) → (H : @Finset.Nonempty.{u_3} β s) → (f : β → α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [SemilatticeSup α] s H f => (s.sup (Function.comp WithBot.some f)).unbot ⋯
```

### D061: `Finset.univ`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `194413a784fbc0b27d0cb6b1ab67ed060210172bf16ba24045aa439e58f9a8c7`

Type:

```lean
{α : Type u_1} → [Fintype α] → Finset α
```

Fully explicit type:

```lean
{α : Type u_1} → [Fintype.{u_1} α] → Finset.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Fintype α] => inst.elems
```

### D062: `Finset.univ_nonempty`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.BooleanAlgebra`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `5ce7d81f1c6b63af17d2ef522ad495952acf1df72e2166abea9aadcaa573ae61`

Type:

```lean
∀ {α : Type u_1} [inst : Fintype α] [Nonempty α], Finset.univ.Nonempty
```

Fully explicit type:

```lean
∀ {α : Type u_1} [inst : Fintype.{u_1} α] [Nonempty.{u_1 + 1} α], @Finset.Nonempty.{u_1} α (@Finset.univ.{u_1} α inst)
```

### D063: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Type:

```lean
Type u_4 → Type u_4
```

Fully explicit type:

```lean
(α : Type u_4) → Type u_4
```

### D064: `Nonempty`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `37c79de378d44cb9dc334502b161bb140da0544579086aded2cf83ff99c462c7`

Type:

```lean
Sort u → Prop
```

Fully explicit type:

```lean
(α : Sort u) → Prop
```

### D065: `Pi.instSemilatticeSup`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Lattice`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `0a2f3dd0603575f7619d0e6df709d8f7c49d58be272487fd1d07daa554f82ec2`

Type:

```lean
{ι : Type u_1} → {α' : ι → Type u_2} → [(i : ι) → SemilatticeSup (α' i)] → SemilatticeSup ((i : ι) → α' i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {α' : ι → Type u_2} → [(i : ι) → SemilatticeSup.{u_2} (α' i)] → SemilatticeSup.{max u_1 u_2} ((i : ι) → α' i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {α'} [(i : ι) → SemilatticeSup (α' i)] =>
  { toPartialOrder := Pi.partialOrder, sup := fun x y i => SemilatticeSup.toMax.max (x i) (y i), le_sup_left := ⋯,
    le_sup_right := ⋯, sup_le := ⋯ }
```

### D066: `Real.instSemilatticeSup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `b9cb05dd18ecf54b95e91d974c1dc2bfabef3e742078517441d99c93e4ad6426`

Type:

```lean
SemilatticeSup Real
```

Fully explicit type:

```lean
SemilatticeSup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

## Complete local imported sources

### `ComputationalMathematics.Analysis.Probability.Gaussian.AbsoluteMoment`

Path: `lean-computational-mathematics/ComputationalMathematics/Analysis/Probability/Gaussian/AbsoluteMoment.lean`
SHA-256: `9fc995867b9358875a9ec7630828e6d9b7f353a48f130ac375d473b66c91406b`

```lean
/-
Copyright (c) 2026 QED. All rights reserved.
Released under Apache 2.0 license as described in LICENSES/Apache-2.0.txt.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.
Authors: QED
-/
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.MeasureTheory.Integral.Gamma
import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Probability.Independence.Basic

/-!
# Gaussian absolute moments

Scalar first absolute moments for real Gaussian measures, including the exact
moment of the difference of two independent standard Gaussians.
-/

namespace NumStability

open MeasureTheory ProbabilityTheory Set Real

/-- The unnormalized first absolute Gaussian moment. -/
theorem integral_abs_mul_exp_neg_mul_sq (b : ℝ) (hb : 0 < b) :
    (∫ x : ℝ, |x| * Real.exp (-b * x ^ 2)) = 1 / b := by
  let f : ℝ → ℝ := fun x => x * Real.exp (-b * x ^ 2)
  have hcomp : (fun x : ℝ => |x| * Real.exp (-b * x ^ 2)) =
      fun x => f |x| := by
    funext x
    simp only [f]
    rw [sq_abs]
  rw [hcomp, integral_comp_abs]
  have hgamma := integral_rpow_mul_exp_neg_mul_rpow
    (p := (2 : ℝ)) (q := (1 : ℝ)) (b := b) (by norm_num) (by norm_num) hb
  have hIoi : (∫ x : ℝ in Ioi 0, f x) = b⁻¹ / 2 := by
    rw [show (∫ x : ℝ in Ioi 0, f x) =
        ∫ x : ℝ in Ioi 0, x ^ (1 : ℝ) * Real.exp (-b * x ^ (2 : ℝ)) by
      apply setIntegral_congr_fun measurableSet_Ioi
      intro x hx
      simp [f, Real.rpow_one]]
    rw [hgamma]
    have hG : Real.Gamma (((1 : ℝ) + 1) / 2) = 1 := by
      norm_num
      exact Real.Gamma_one
    rw [hG]
    norm_num [Real.rpow_neg_one]
    ring
  rw [hIoi]
  field_simp

/-- The first absolute moment of the standard real Gaussian, in the
normalization used by `gaussianPDFReal`. -/
theorem integral_abs_mul_standardGaussianPDF :
    (∫ x : ℝ, |x| * gaussianPDFReal 0 1 x) =
      2 / Real.sqrt (2 * Real.pi) := by
  have hpoint : (fun x : ℝ => |x| * gaussianPDFReal 0 1 x) =
      fun x => (1 / Real.sqrt (2 * Real.pi)) *
        (|x| * Real.exp (-(1 / 2 : ℝ) * x ^ 2)) := by
    funext x
    simp [gaussianPDFReal]
    ring_nf
  rw [hpoint, integral_const_mul,
    integral_abs_mul_exp_neg_mul_sq (1 / 2) (by norm_num)]
  ring

theorem two_div_sqrt_two_mul_pi :
    2 / Real.sqrt (2 * Real.pi) = Real.sqrt (2 / Real.pi) := by
  rw [Real.sqrt_mul (by norm_num : (0 : ℝ) ≤ 2),
    Real.sqrt_div (by norm_num : (0 : ℝ) ≤ 2)]
  have hsqrtTwo : Real.sqrt (2 : ℝ) ≠ 0 := by positivity
  have hsqrtPi : Real.sqrt Real.pi ≠ 0 := by positivity
  have hsqrtTwoSq : Real.sqrt (2 : ℝ) ^ 2 = 2 :=
    Real.sq_sqrt (by norm_num)
  field_simp
  nlinarith

/-- Familiar `sqrt (2 / π)` form of the standard Gaussian first absolute
moment. -/
theorem integral_abs_mul_standardGaussianPDF_eq_sqrt :
    (∫ x : ℝ, |x| * gaussianPDFReal 0 1 x) =
      Real.sqrt (2 / Real.pi) := by
  rw [integral_abs_mul_standardGaussianPDF, two_div_sqrt_two_mul_pi]

/-- First absolute moment of a centered Gaussian of variance two. -/
theorem integral_abs_mul_gaussianPDFReal_zero_two :
    (∫ x : ℝ, |x| * gaussianPDFReal 0 2 x) =
      4 / Real.sqrt (2 * Real.pi * 2) := by
  have hpoint : (fun x : ℝ => |x| * gaussianPDFReal 0 2 x) =
      fun x => (1 / Real.sqrt (2 * Real.pi * 2)) *
        (|x| * Real.exp (-(1 / 4 : ℝ) * x ^ 2)) := by
    funext x
    simp [gaussianPDFReal]
    ring_nf
  rw [hpoint, integral_const_mul,
    integral_abs_mul_exp_neg_mul_sq (1 / 4) (by norm_num)]
  ring

theorem integral_abs_mul_gaussianPDFReal_zero_two_eq :
    (∫ x : ℝ, |x| * gaussianPDFReal 0 2 x) =
      2 / Real.sqrt Real.pi := by
  rw [integral_abs_mul_gaussianPDFReal_zero_two]
  rw [show (2 : ℝ) * Real.pi * 2 = 4 * Real.pi by ring,
    Real.sqrt_mul (by norm_num : (0 : ℝ) ≤ 4)]
  have hsqrtFour : Real.sqrt (4 : ℝ) = 2 := by
    rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.sqrt_sq_eq_abs]
    norm_num
  rw [hsqrtFour]
  ring

/-- The difference of two independent standard real Gaussians is centered
Gaussian with variance two. -/
theorem gaussianReal_prod_map_sub :
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).map
        (fun p : ℝ × ℝ => p.1 - p.2) = gaussianReal 0 2 := by
  let μ : Measure ℝ := gaussianReal 0 1
  have hInd : IndepFun (fun p : ℝ × ℝ => p.1) (fun p : ℝ × ℝ => p.2)
      (μ.prod μ) := indepFun_prod measurable_id measurable_id
  have hfst : (μ.prod μ).map (fun p : ℝ × ℝ => p.1) = gaussianReal 0 1 := by
    simp [μ]
  have hsndNeg :
      (μ.prod μ).map (fun p : ℝ × ℝ => -p.2) = gaussianReal 0 1 := by
    rw [show (fun p : ℝ × ℝ => -p.2) =
      (fun x : ℝ => -x) ∘ Prod.snd by rfl]
    rw [← Measure.map_map measurable_neg measurable_snd]
    simp [μ, gaussianReal_map_neg]
  have hadd := gaussianReal_add_gaussianReal_of_indepFun
    hInd.neg_right hfst hsndNeg
  change (μ.prod μ).map ((fun p : ℝ × ℝ => p.1) +
    -(fun p : ℝ × ℝ => p.2)) = gaussianReal 0 2
  convert hadd using 1
  all_goals norm_num

/-- Exact absolute first moment of the difference of two independent
standard real Gaussians. -/
theorem integral_abs_standardGaussian_difference :
    (∫ p : ℝ × ℝ, |p.1 - p.2|
        ∂((gaussianReal 0 1).prod (gaussianReal 0 1))) =
      2 / Real.sqrt Real.pi := by
  let μ : Measure (ℝ × ℝ) :=
    (gaussianReal 0 1).prod (gaussianReal 0 1)
  let sub : ℝ × ℝ → ℝ := fun p => p.1 - p.2
  have hsub : AEMeasurable sub μ :=
    (measurable_fst.sub measurable_snd).aemeasurable
  calc
    (∫ p : ℝ × ℝ, |p.1 - p.2| ∂μ) =
        ∫ x : ℝ, |x| ∂μ.map sub := by
      rw [integral_map hsub measurable_abs.aestronglyMeasurable]
    _ = ∫ x : ℝ, |x| ∂gaussianReal 0 2 := by
      rw [show μ.map sub = gaussianReal 0 2 by
        simpa [μ, sub] using gaussianReal_prod_map_sub]
    _ = ∫ x : ℝ, gaussianPDFReal 0 2 x • |x| := by
      rw [integral_gaussianReal_eq_integral_smul
        (v := (2 : NNReal)) (by norm_num)]
    _ = 2 / Real.sqrt Real.pi := by
      simpa [smul_eq_mul, mul_comm] using
        integral_abs_mul_gaussianPDFReal_zero_two_eq

end NumStability
```

### `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/LimitTheorems/Basic.lean`
SHA-256: `6d92f1e4e16db93c92072bdadba640e101c8a7c805376eca4bd13ca5b33ae48e`

```lean
import Mathlib.Probability.ProbabilityMassFunction.Binomial
import Mathlib.Probability.ProbabilityMassFunction.Integrals
import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Probability.Distributions.Poisson
import Mathlib.MeasureTheory.Function.ConvergenceInDistribution
import Mathlib.Probability.StrongLaw
import Mathlib.Tactic

/-!
# Bernoulli and binomial laws

This is the first current-main port from the archival Vershynin formalization.
The source target is Chapter 1, Section 1.3, p. 10.  The canonical laws are
Mathlib PMFs; the natural-valued Bernoulli law is the pushforward of the Bool
Bernoulli PMF, and the binomial law is the pushforward of Mathlib's finite
binomial PMF.
-/

noncomputable section

open MeasureTheory Filter
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Scalar.LimitTheorems

/-- The probability law of an almost-everywhere measurable real random variable. -/
noncomputable def probabilityLaw
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : AEMeasurable X μ) :
    MeasureTheory.ProbabilityMeasure ℝ :=
  ⟨Measure.map X μ, Measure.isProbabilityMeasure_map hX⟩

/-- Convergence in distribution as weak convergence of pushforward probability laws. -/
noncomputable def convergenceInDistribution
    {Ω ι : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (l : Filter ι) (Z : Ω → ℝ)
    (hX : ∀ i, AEMeasurable (X i) μ) (hZ : AEMeasurable Z μ) : Prop :=
  Filter.Tendsto (fun i => probabilityLaw (X i) (hX i)) l
    (nhds (probabilityLaw Z hZ))

/-! The local foundation helper that closes the strong-law prerequisite. -/
theorem foundation_ext_slln
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ℕ → Ω → ℝ}
    (hInt : Integrable (X 0) μ)
    (hIndep : Pairwise ((· ⟂ᵢ[μ] ·) on X))
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    ∀ᵐ ω ∂μ, Tendsto
      (fun n : ℕ => (∑ i ∈ Finset.range n, X i ω) / n) atTop
      (nhds (∫ ω, X 0 ω ∂μ)) := by
  exact ProbabilityTheory.strong_law_ae_real X hInt hIndep hIdent

/-! Chapter 1's strong law of large numbers. -/
theorem strongLaw
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ℕ → Ω → ℝ}
    (hInt : Integrable (X 0) μ)
    (hIndep : Pairwise ((· ⟂ᵢ[μ] ·) on X))
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    ∀ᵐ ω ∂μ, Tendsto
      (fun n : ℕ => (∑ i ∈ Finset.range n, X i ω) / n) atTop
      (nhds (∫ ω, X 0 ω ∂μ)) := by
  exact foundation_ext_slln hInt hIndep hIdent

/-! ## Variance of a finite independent sum -/

theorem independentVarianceSum
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ]
    {X : ι → Ω → ℝ} (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : Pairwise ((· ⟂ᵢ[μ] ·) on X)) :
    Var[∑ i, X i; μ] = ∑ i, Var[X i; μ] := by
  simpa using (ProbabilityTheory.IndepFun.variance_sum
    (μ := μ) (X := X) (s := Finset.univ)
    (fun i _ => hX i) (by
      intro i hi j hj hij
      exact hIndep hij))

/-! ## Variance of an iid sample mean -/

/--
The finite-sample variance identity from Chapter 1, equation (1.5).
The explicit `Fin N` index and `0 < N` hypothesis make the textbook's
`N ≥ 1` condition and the distinguished reference sample unambiguous.
-/
theorem iidSampleMeanVariance
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ]
    (N : ℕ) (hN : 0 < N)
    {X : Fin N → Ω → ℝ}
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : Pairwise ((· ⟂ᵢ[μ] ·) on X))
    (hIdent : ∀ i, IdentDistrib (X i) (X ⟨0, hN⟩) μ μ) :
    Var[fun ω => (N : ℝ)⁻¹ * ∑ i, X i ω; μ] =
      (N : ℝ)⁻¹ * Var[X ⟨0, hN⟩; μ] := by
  have hsum := independentVarianceSum hX hIndep
  have hscale := ProbabilityTheory.variance_const_mul
    (μ := μ) (N : ℝ)⁻¹ (fun ω => ∑ i, X i ω)
  calc
    Var[fun ω => (N : ℝ)⁻¹ * ∑ i, X i ω; μ] =
        (N : ℝ)⁻¹ ^ 2 * Var[fun ω => ∑ i, X i ω; μ] := by
          simpa using hscale
    _ = (N : ℝ)⁻¹ ^ 2 * ∑ i, Var[X i; μ] := by
      have hfun : (fun ω => ∑ i, X i ω) = ∑ i, X i := by
        funext ω
        simp
      rw [hfun, hsum]
    _ = (N : ℝ)⁻¹ * Var[X ⟨0, hN⟩; μ] := by
      simp_rw [fun i => (hIdent i).variance_eq]
      rw [Finset.sum_const, Finset.card_fin]
      field_simp
      simp [nsmul_eq_mul]

/-! ## Expected absolute deviation of an iid sample mean -/

/-- On a probability space, the first absolute moment is bounded by the square
root of the second moment. -/
theorem expectedAbs_le_sqrt_secondMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {Y : Ω → ℝ} (hY : MemLp Y 2 μ) :
    ∫ ω, |Y ω| ∂μ ≤ Real.sqrt (∫ ω, (Y ω) ^ 2 ∂μ) := by
  have hf : MemLp (fun ω => |Y ω|) (ENNReal.ofReal (2 : ℝ)) μ := by
    simpa [Real.norm_eq_abs] using hY.norm
  have hg : MemLp (fun _ω : Ω => (1 : ℝ))
      (ENNReal.ofReal (2 : ℝ)) μ := memLp_const (1 : ℝ)
  have hcs := integral_mul_le_Lp_mul_Lq_of_nonneg
    (μ := μ) (f := fun ω => |Y ω|) (g := fun _ => 1)
    (by
      rw [Real.holderConjugate_iff]
      norm_num : (2 : ℝ).HolderConjugate 2)
    (ae_of_all _ fun _ => abs_nonneg _)
    (ae_of_all _ fun _ => by norm_num) hf hg
  have hcs' :
      ∫ ω, |Y ω| ∂μ ≤
        (∫ ω, |Y ω| ^ (2 : ℝ) ∂μ) ^ ((1 : ℝ) / 2) *
          (∫ _ω : Ω, (1 : ℝ) ^ (2 : ℝ) ∂μ) ^ ((1 : ℝ) / 2) := by
    simpa using hcs
  norm_num only [Real.rpow_two] at hcs'
  have huniv : (∫ _ω : Ω, (1 : ℝ) ∂μ) = 1 := by simp
  rw [huniv] at hcs'
  simpa [Real.sqrt_eq_rpow, sq_abs] using hcs'

/-- The exact finite-sample estimate underlying Exercise 1.3.3. -/
theorem iidSampleMeanExpectedAbsDeviation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (N : ℕ) (hN : 0 < N)
    {X : Fin N → Ω → ℝ}
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : Pairwise ((· ⟂ᵢ[μ] ·) on X))
    (hIdent : ∀ i, IdentDistrib (X i) (X ⟨0, hN⟩) μ μ) :
    ∫ ω, |(N : ℝ)⁻¹ * ∑ i, X i ω -
        ∫ ω, X ⟨0, hN⟩ ω ∂μ| ∂μ ≤
      Real.sqrt ((N : ℝ)⁻¹ * Var[X ⟨0, hN⟩; μ]) := by
  let M : Ω → ℝ := fun ω => (N : ℝ)⁻¹ * ∑ i, X i ω
  have hM : MemLp M 2 μ := by
    dsimp [M]
    exact (memLp_finset_sum Finset.univ (fun i _ => hX i)).const_mul (N : ℝ)⁻¹
  have hMean : (∫ ω, M ω ∂μ) = ∫ ω, X ⟨0, hN⟩ ω ∂μ := by
    dsimp [M]
    rw [integral_const_mul, integral_finset_sum]
    · simp_rw [fun i => (hIdent i).integral_eq]
      rw [Finset.sum_const, Finset.card_fin]
      field_simp
      simp [nsmul_eq_mul]
    · intro i _
      exact (hX i).integrable (by norm_num)
  have hCentered :
      MemLp (fun ω => M ω - ∫ ω, X ⟨0, hN⟩ ω ∂μ) 2 μ :=
    hM.sub (memLp_const _)
  have hbound := expectedAbs_le_sqrt_secondMoment hCentered
  have hsecond :
      (∫ ω, (M ω - ∫ ω, X ⟨0, hN⟩ ω ∂μ) ^ 2 ∂μ) = Var[M; μ] := by
    rw [variance_eq_integral hM.aemeasurable, hMean]
  rw [hsecond] at hbound
  have hvariance := iidSampleMeanVariance N hN hX hIndep hIdent
  change Var[M; μ] = _ at hvariance
  rw [hvariance] at hbound
  change (∫ ω, |M ω - ∫ ω, X ⟨0, hN⟩ ω ∂μ| ∂μ) ≤ _
  exact hbound

/-! ## The standard normal law -/

/--
The standard normal law from Chapter 1, equation (1.6).  Mathlib's
`gaussianReal` is parameterized by mean and variance, so the source law is the
specialization `(μ, v) = (0, 1)`.
-/
noncomputable def standardNormalLaw : Measure ℝ :=
  ProbabilityTheory.gaussianReal 0 1

/-- A random variable has the Chapter 1 standard-normal law. -/
def HasStandardNormalLaw {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : Prop :=
  ProbabilityTheory.HasLaw X standardNormalLaw μ

/-- The standard normal law is a probability measure. -/
instance standardNormalLaw.isProbabilityMeasure :
    IsProbabilityMeasure standardNormalLaw := by
  dsimp [standardNormalLaw]
  infer_instance

/-- The real density of `standardNormalLaw` is the density printed in (1.6). -/
theorem standardNormalLaw_pdf :
    ProbabilityTheory.gaussianPDFReal 0 1 =
      fun x : ℝ => (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x ^ 2) / 2) := by
  funext x
  simp only [ProbabilityTheory.gaussianPDFReal, NNReal.coe_one, sub_zero]
  congr 1
  · congr 1
    ring
  · ring

/-! ## The Poisson law -/

/--
The Poisson law from Chapter 1, equation (1.8).  The nonnegative rate is
represented by Mathlib's `NNReal` parameter, and the law is supported on
`ℕ`.
-/
noncomputable def poissonLaw (rate : ℝ≥0) : Measure ℕ :=
  ProbabilityTheory.poissonMeasure rate

/-- A random variable has the Chapter 1 Poisson law with rate `λ`. -/
def HasPoissonLaw {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℕ) (rate : ℝ≥0) : Prop :=
  ProbabilityTheory.HasLaw X (poissonLaw rate) μ

/-- The Poisson law is a probability measure. -/
instance poissonLaw.isProbabilityMeasure (rate : ℝ≥0) :
    IsProbabilityMeasure (poissonLaw rate) := by
  dsimp [poissonLaw]
  infer_instance

/-- The point mass of `poissonLaw` is the mass printed in (1.8). -/
theorem poissonLaw_mass (rate : ℝ≥0) (k : ℕ) :
    poissonLaw rate {k} =
      ENNReal.ofReal (Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k / Nat.factorial k) := by
  rw [poissonLaw, ProbabilityTheory.poissonMeasure,
    PMF.toMeasure_apply_singleton _ k (measurableSet_singleton k)]
  rfl

/-! ## Canonical laws -/

/-- The `{0,1}`-valued Bernoulli PMF on `ℕ`. -/
def bernoulliNatPMF (p : ℝ≥0) (hp : p ≤ 1) : PMF ℕ :=
  (PMF.bernoulli p hp).map fun b => if b then 1 else 0

/-- The binomial PMF on `ℕ`, obtained from Mathlib's finite-support law. -/
def binomialNatPMF (p : ℝ≥0) (hp : p ≤ 1) (N : ℕ) : PMF ℕ :=
  (PMF.binomial p hp N).map fun i : Fin (N + 1) => (i : ℕ)

/-- The real-valued Bernoulli PMF, used for expectation and variance. -/
def bernoulliRealPMF (p : ℝ≥0) (hp : p ≤ 1) : PMF ℝ :=
  (PMF.bernoulli p hp).map (cond · 1 0)

@[simp]
theorem bernoulliNatPMF_apply_one {p : ℝ≥0} {hp : p ≤ 1} :
    bernoulliNatPMF p hp 1 = p := by
  simp [bernoulliNatPMF, PMF.map_apply, PMF.bernoulli_apply]

@[simp]
theorem bernoulliNatPMF_apply_zero {p : ℝ≥0} {hp : p ≤ 1} :
    bernoulliNatPMF p hp 0 = 1 - p := by
  simp [bernoulliNatPMF, PMF.map_apply, PMF.bernoulli_apply]

@[simp]
theorem bernoulliNatPMF_apply_of_ne_zero_one
    {p : ℝ≥0} {hp : p ≤ 1} {k : ℕ}
    (hk0 : k ≠ 0) (hk1 : k ≠ 1) :
    bernoulliNatPMF p hp k = 0 := by
  simp [bernoulliNatPMF, PMF.map_apply, PMF.bernoulli_apply, hk0, hk1]

@[simp]
theorem bernoulliRealPMF_apply_zero {p : ℝ≥0} {hp : p ≤ 1} :
    bernoulliRealPMF p hp 0 = 1 - p := by
  simp [bernoulliRealPMF, PMF.map_apply, PMF.bernoulli_apply]

@[simp]
theorem bernoulliRealPMF_apply_one {p : ℝ≥0} {hp : p ≤ 1} :
    bernoulliRealPMF p hp 1 = p := by
  simp [bernoulliRealPMF, PMF.map_apply, PMF.bernoulli_apply]

/-! ## Mean and variance -/

/-- The mean of the real Bernoulli law is its parameter. -/
theorem bernoulliRealPMF_mean (p : ℝ≥0) (hp : p ≤ 1) :
    ∫ x, x ∂(bernoulliRealPMF p hp).toMeasure = p.toReal := by
  unfold bernoulliRealPMF
  rw [← PMF.toMeasure_map]
  · rw [MeasureTheory.integral_map]
    · exact PMF.bernoulli_expectation hp
    · exact (measurable_of_countable _).aemeasurable
    · exact continuous_id.aestronglyMeasurable
  · exact measurable_of_countable _

/-- The second moment of the real Bernoulli law is its parameter. -/
theorem bernoulliRealPMF_second_moment (p : ℝ≥0) (hp : p ≤ 1) :
    ∫ x, x ^ 2 ∂(bernoulliRealPMF p hp).toMeasure = p.toReal := by
  unfold bernoulliRealPMF
  rw [← PMF.toMeasure_map]
  · rw [MeasureTheory.integral_map]
    · rw [PMF.integral_eq_sum]
      simp [PMF.bernoulli_apply]
    · exact (measurable_of_countable _).aemeasurable
    · exact (continuous_id.pow 2).aestronglyMeasurable
  · exact measurable_of_countable _

/-- The variance of the real Bernoulli law is `p (1-p)`. -/
theorem bernoulliRealPMF_variance (p : ℝ≥0) (hp : p ≤ 1) :
    ∫ x, (x - p.toReal) ^ 2 ∂(bernoulliRealPMF p hp).toMeasure =
      p.toReal * (1 - p.toReal) := by
  unfold bernoulliRealPMF
  rw [← PMF.toMeasure_map]
  · rw [MeasureTheory.integral_map]
    · rw [PMF.integral_eq_sum]
      simp [PMF.bernoulli_apply]
      rw [NNReal.coe_sub hp]
      norm_num
      ring_nf
    · exact (measurable_of_countable _).aemeasurable
    · exact ((continuous_id.sub continuous_const).pow 2).aestronglyMeasurable
  · exact measurable_of_countable _

/-! ## The binomial law as a Bernoulli-sum law -/

private def bernoulliTrialWeight (p : ℝ≥0) (N : ℕ) (f : Fin N → Bool) :
    ℝ≥0∞ :=
  ∏ i : Fin N, if f i then (p : ℝ≥0∞) else (1 - p : ℝ≥0∞)

theorem bernoulliTrialWeight_sum_eq_one
    (p : ℝ≥0) (hp : p ≤ 1) (N : ℕ) :
    (∑ f : Fin N → Bool, bernoulliTrialWeight p N f) = 1 := by
  classical
  calc
    (∑ f : Fin N → Bool, bernoulliTrialWeight p N f) =
        ∏ _i : Fin N, ∑ b : Bool,
          (if b then (p : ℝ≥0∞) else (1 - p : ℝ≥0∞)) := by
      exact (Fintype.prod_sum fun (_i : Fin N) (b : Bool) =>
        if b then (p : ℝ≥0∞) else (1 - p : ℝ≥0∞)).symm
    _ = 1 := by
      have hsub : (p : ℝ≥0∞) + (1 - p : ℝ≥0∞) = 1 := by
        norm_cast
        exact add_tsub_cancel_of_le hp
      simp [hsub]

/-- The product Bernoulli PMF on Boolean vectors indexed by `Fin N`. -/
def bernoulliTrialVectorPMF
    (p : ℝ≥0) (hp : p ≤ 1) (N : ℕ) : PMF (Fin N → Bool) :=
  PMF.ofFintype (bernoulliTrialWeight p N)
    (bernoulliTrialWeight_sum_eq_one p hp N)

/-- The number of true coordinates in a Boolean trial vector. -/
def bernoulliSuccessCount (N : ℕ) (f : Fin N → Bool) : ℕ :=
  (Finset.univ.filter fun i => f i).card

private def bernoulliSuccessCountFin (N : ℕ) (f : Fin N → Bool) :
    Fin (N + 1) :=
  ⟨bernoulliSuccessCount N f, by
    unfold bernoulliSuccessCount
    exact Nat.lt_succ_of_le (by simpa [Fintype.card_fin] using
      (Finset.card_le_univ (Finset.univ.filter fun i : Fin N => f i)))⟩

private theorem bernoulliTrialWeight_eq_successCount
    (p : ℝ≥0) (N : ℕ) (f : Fin N → Bool) :
    bernoulliTrialWeight p N f =
      (p : ℝ≥0∞) ^ bernoulliSuccessCount N f *
        (1 - p : ℝ≥0∞) ^ (N - bernoulliSuccessCount N f) := by
  classical
  unfold bernoulliTrialWeight bernoulliSuccessCount
  rw [Finset.prod_ite]
  have hcard :
      (Finset.univ.filter fun i : Fin N => f i = false).card =
        N - (Finset.univ.filter fun i : Fin N => f i).card := by
    have h := Finset.card_filter_add_card_filter_not
      (s := (Finset.univ : Finset (Fin N))) (p := fun i => f i = true)
    have hsum :
        (Finset.univ.filter fun i : Fin N => f i = true).card +
            (Finset.univ.filter fun i : Fin N => f i = false).card = N := by
      simpa using h
    omega
  simp [hcard]

theorem bernoulliSuccessCount_fiber_card (N k : ℕ) :
    Fintype.card {f : Fin N → Bool // bernoulliSuccessCount N f = k} =
      N.choose k := by
  classical
  unfold bernoulliSuccessCount
  let e :
      {f : Fin N → Bool // (Finset.univ.filter fun i => f i).card = k} ≃
        {s : Finset (Fin N) // s.card = k} :=
    { toFun := fun f => ⟨Finset.univ.filter fun i => f.1 i, f.2⟩
      invFun := fun s => ⟨fun i => i ∈ s.1, by
        have hfilter :
            (Finset.univ.filter fun i : Fin N => i ∈ s.1) = s.1 := by
          ext i
          simp
        simpa [hfilter] using s.2⟩
      left_inv := by
        intro f
        apply Subtype.ext
        funext i
        simp
      right_inv := by
        intro s
        apply Subtype.ext
        ext i
        simp }
  calc
    Fintype.card {f : Fin N → Bool //
        (Finset.univ.filter fun i => f i).card = k} =
        Fintype.card {s : Finset (Fin N) // s.card = k} :=
      Fintype.card_congr e
    _ = N.choose k := by
      rw [Fintype.card_finset_len]
      simp

theorem bernoulliTrialVectorPMF_map_successCountFin_eq_binomial
    (p : ℝ≥0) (hp : p ≤ 1) (N : ℕ) :
    (bernoulliTrialVectorPMF p hp N).map (bernoulliSuccessCountFin N) =
      PMF.binomial p hp N := by
  classical
  ext i
  rw [bernoulliTrialVectorPMF, PMF.map_ofFintype]
  simp only [PMF.ofFintype_apply]
  rw [PMF.binomial_apply]
  have hfiber_const :
      ∀ f : Fin N → Bool,
        bernoulliSuccessCountFin N f = i →
          bernoulliTrialWeight p N f =
            (p : ℝ≥0∞) ^ (i : ℕ) *
              (1 - p : ℝ≥0∞) ^ (N - (i : ℕ)) := by
    intro f hf
    have hcount : bernoulliSuccessCount N f = (i : ℕ) :=
      congrArg Fin.val hf
    rw [bernoulliTrialWeight_eq_successCount, hcount]
  have hsum :
      (∑ f with bernoulliSuccessCountFin N f = i,
          bernoulliTrialWeight p N f) =
        ((Finset.univ.filter fun f : Fin N → Bool =>
          bernoulliSuccessCountFin N f = i).card : ℕ) •
          ((p : ℝ≥0∞) ^ (i : ℕ) *
            (1 - p : ℝ≥0∞) ^ (N - (i : ℕ))) := by
    calc
      (∑ f with bernoulliSuccessCountFin N f = i,
          bernoulliTrialWeight p N f) =
        ∑ f with bernoulliSuccessCountFin N f = i,
          ((p : ℝ≥0∞) ^ (i : ℕ) *
            (1 - p : ℝ≥0∞) ^ (N - (i : ℕ))) := by
              refine Finset.sum_congr rfl ?_
              intro f hf
              exact hfiber_const f (by simpa using hf)
      _ = ((Finset.univ.filter fun f : Fin N → Bool =>
          bernoulliSuccessCountFin N f = i).card : ℕ) •
          ((p : ℝ≥0∞) ^ (i : ℕ) *
            (1 - p : ℝ≥0∞) ^ (N - (i : ℕ))) := by
              rw [Finset.sum_const]
  have hcard :
      (Finset.univ.filter fun f : Fin N → Bool =>
          bernoulliSuccessCountFin N f = i).card = N.choose (i : ℕ) := by
    have hfilter :
        (Finset.univ.filter fun f : Fin N → Bool =>
            bernoulliSuccessCountFin N f = i) =
          (Finset.univ.filter fun f : Fin N → Bool =>
            bernoulliSuccessCount N f = (i : ℕ)) := by
      ext f
      simp only [Finset.mem_filter, Finset.mem_univ, true_and]
      constructor
      · intro h
        exact congrArg Fin.val h
      · intro h
        apply Fin.ext
        exact h
    rw [hfilter]
    have hcardSubtype := bernoulliSuccessCount_fiber_card N (i : ℕ)
    rwa [Fintype.card_subtype] at hcardSubtype
  have htarget :
      ((Finset.univ.filter fun f : Fin N → Bool =>
          bernoulliSuccessCountFin N f = i).card : ℕ) •
          ((p : ℝ≥0∞) ^ (i : ℕ) *
            (1 - p : ℝ≥0∞) ^ (N - (i : ℕ))) =
        (p : ℝ≥0∞) ^ (i : ℕ) *
          (1 - p : ℝ≥0∞) ^ (N - (i : ℕ)) *
            (N.choose (i : ℕ) : ℝ≥0∞) := by
    rw [hcard]
    simp [nsmul_eq_mul, mul_comm, mul_left_comm]
  convert hsum.trans htarget using 1
  refine Finset.sum_congr ?_ fun _ _ => rfl
  ext x
  simp

/-- The natural-valued sum of `N` iid Bernoulli trials has the binomial law.

The `iIndepFun` and marginal-law theorem below is the source-facing bridge
used by later CLT and Poisson-limit targets. -/
theorem bernoulliSumPMF_eq_binomialNatPMF
    (p : ℝ≥0) (hp : p ≤ 1) (N : ℕ) :
    (bernoulliTrialVectorPMF p hp N).map (bernoulliSuccessCount N) =
      binomialNatPMF p hp N := by
  unfold binomialNatPMF
  have hcomp :
      ((fun i : Fin (N + 1) => (i : ℕ)) ∘ bernoulliSuccessCountFin N) =
        bernoulliSuccessCount N := by
    funext f
    rfl
  rw [← hcomp]
  rw [← PMF.map_comp]
  rw [bernoulliTrialVectorPMF_map_successCountFin_eq_binomial]

/-- The source-facing Bernoulli/binomial package, including its defining facts. -/
structure BernoulliBinomialModelData (p : ℝ≥0) (hp : p ≤ 1) (N : ℕ) where
  /-- The stored natural-valued Bernoulli PMF. -/
  bernoulli : PMF ℕ
  /-- The stored `N`-trial binomial PMF. -/
  binomial : PMF ℕ
  mean : ∫ x : ℝ, x ∂(bernoulliRealPMF p hp).toMeasure = p.toReal
  variance :
    ∫ x : ℝ, (x - p.toReal) ^ 2 ∂(bernoulliRealPMF p hp).toMeasure =
      p.toReal * (1 - p.toReal)
  sum_law :
    (bernoulliTrialVectorPMF p hp N).map (bernoulliSuccessCount N) =
      binomialNatPMF p hp N

/-- A Bernoulli-sum model packages the two canonical source laws and their facts. -/
def bernoulliBinomialModel (p : ℝ≥0) (hp : p ≤ 1) (N : ℕ) :
    BernoulliBinomialModelData p hp N :=
  { bernoulli := bernoulliNatPMF p hp
    binomial := binomialNatPMF p hp N
    mean := bernoulliRealPMF_mean p hp
    variance := bernoulliRealPMF_variance p hp
    sum_law := bernoulliSumPMF_eq_binomialNatPMF p hp N }

end NumStability.HDP.Scalar.LimitTheorems
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Equation05.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Equation05/Contract.lean`
SHA-256: `fdcf3bf957d8988f91f0de24c96b8f5486828f4afce314cb353c8bfb83271f76`

```lean
import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic

/-! Stable source-facing contract for Equation (1.5), sample-mean variance. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

/-- Stable source-facing alias for the iid sample-mean variance identity. -/
theorem hdp_01_heq_h1_d5
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ]
    (N : ℕ) (hN : 0 < N)
    {X : Fin N → Ω → ℝ}
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ∀ ⦃i j : Fin N⦄, i ≠ j → IndepFun (X i) (X j) μ)
    (hIdent : ∀ i, IdentDistrib (X i) (X ⟨0, hN⟩) μ μ) :
    Var[fun ω => (N : ℝ)⁻¹ * ∑ i, X i ω; μ] =
      (N : ℝ)⁻¹ * Var[X ⟨0, hN⟩; μ] :=
  NumStability.HDP.Scalar.LimitTheorems.iidSampleMeanVariance
    N hN hX hIndep hIdent

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.PoissonDistribution.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/PoissonDistribution/Contract.lean`
SHA-256: `79f5497914775466ba8bffadc8e354d30f590aa6df412215fbc300bd37471d56`

```lean
import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic

/-! Stable source-facing contract for the Chapter 1 Poisson-law definition. -/

noncomputable section

open MeasureTheory
open scoped NNReal

namespace NumStability.HDP.Contract

/-- Stable source-facing alias for the local Poisson law interface. -/
noncomputable def hdp_01_hdef_hpoisson (rate : ℝ≥0) : Measure ℕ :=
  NumStability.HDP.Scalar.LimitTheorems.poissonLaw rate

/-- Equation (1.8): the point mass of the Poisson law with rate `rate`. -/
theorem hdp_01_heq_h1_d8 (rate : ℝ≥0) (k : ℕ) :
    hdp_01_hdef_hpoisson rate {k} =
      ENNReal.ofReal
        (Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k / Nat.factorial k) := by
  exact NumStability.HDP.Scalar.LimitTheorems.poissonLaw_mass rate k

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.VarianceOfSum.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/VarianceOfSum/Contract.lean`
SHA-256: `70eda4080f528a6abd3b5f8ab90a463785c17cf410ed95a1558caac4f3b97490`

```lean
import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic

/-! Stable source-facing contract for the independent finite-sum variance identity. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

theorem hdp_01_hlem_hindependent_hvariance_hsum
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ]
    {X : ι → Ω → ℝ} (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ∀ ⦃i j : ι⦄, i ≠ j → IndepFun (X i) (X j) μ) :
    Var[∑ i, X i; μ] = ∑ i, Var[X i; μ] :=
  NumStability.HDP.Scalar.LimitTheorems.independentVarianceSum hX hIndep

end NumStability.HDP.Contract
```

### `ComputationalMathematics.HDP.Scalar.LimitTheorems`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/LimitTheorems.lean`
SHA-256: `c083edc41fca0ba342011895c49e41c213a5a5009c66a124a6e3b4e7b753fb27`

```lean
import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic
import ComputationalMathematics.Source.Vershynin.Chapter01.Equation05.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.PoissonDistribution.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.VarianceOfSum.Contract

/-!
# Public scalar limit-theorem interfaces

This import-only facade preserves the historical scalar import surface. Its
semantic definitions and proofs are owned by `Basic`; the imported Vershynin
contract leaves own the Chapter 1 aliases and their source specifications.
-/
```

### `ComputationalMathematics.HDP.Scalar.GaussianTails`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/GaussianTails.lean`
SHA-256: `0ea5ad432ce3cb883dea16afa062abb2770e6c3f2ceea9330f2e9d649b96eac0`

```lean
import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
# Standard-normal tail estimates

Density and calculus foundations for the two-sided Mills-ratio estimate in
Proposition 2.1.2.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set Filter
open scoped ENNReal NNReal Topology

namespace NumStability.HDP.Scalar.GaussianTails

open NumStability.HDP.Scalar.LimitTheorems

/-- The upper tail of the standard-normal law is the integral of its printed
density over the open ray.  The endpoint does not matter because Lebesgue
measure has no atoms. -/
theorem standardNormalTail_eq_densityIntegral (t : ℝ) :
    standardNormalLaw.real (Ici t) =
      (Real.sqrt (2 * Real.pi))⁻¹ *
        ∫ x in Ioi t, Real.exp (-(x ^ 2) / 2) := by
  rw [Measure.real_def, standardNormalLaw,
    gaussianReal_apply_eq_integral 0 (by norm_num : (1 : ℝ≥0) ≠ 0) (Ici t)]
  rw [ENNReal.toReal_ofReal (integral_nonneg fun x ↦ gaussianPDFReal_nonneg 0 1 x)]
  rw [standardNormalLaw_pdf, integral_const_mul]
  rw [integral_Ici_eq_integral_Ioi]

/-- The elementary antiderivative identity used in the upper Gaussian-tail
bound. -/
theorem integral_Ioi_mul_exp_neg_sq_div_two (t : ℝ) :
    ∫ x in Ioi t, x * Real.exp (-(x ^ 2) / 2) =
      Real.exp (-(t ^ 2) / 2) := by
  let f : ℝ → ℝ := fun x ↦ -Real.exp (-(x ^ 2) / 2)
  let f' : ℝ → ℝ := fun x ↦ x * Real.exp (-(x ^ 2) / 2)
  have hderiv : ∀ x : ℝ, HasDerivAt f (f' x) x := by
    intro x
    have h := ((hasDerivAt_pow 2 x).const_mul (-(1 / 2 : ℝ))).exp.neg
    dsimp [f, f']
    convert h using 1
    · ext y
      congr 1
      ring
    · simp
      ring
  have hint : IntegrableOn f' (Ioi t) := by
    have h : IntegrableOn (fun x : ℝ ↦ x * Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        (Ioi t) := (integrable_mul_exp_neg_mul_sq
          (by norm_num : (0 : ℝ) < 1 / 2)).integrableOn
    apply h.congr
    filter_upwards [] with x
    dsimp [f']
    congr 1
    ring
  have htend : Tendsto f atTop (𝓝 0) := by
    have hpow : Tendsto (fun x : ℝ ↦ x ^ 2) atTop atTop :=
      tendsto_pow_atTop (by norm_num)
    have hinner : Tendsto (fun x : ℝ ↦ -(1 / 2 : ℝ) * x ^ 2) atTop atBot :=
      hpow.const_mul_atTop_of_neg (by norm_num)
    have hexp : Tendsto (fun x : ℝ ↦ Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        atTop (𝓝 0) := Real.tendsto_exp_atBot.comp hinner
    convert hexp.neg using 1
    · ext x
      dsimp [f]
      congr 2
      ring
    · simp
  have hftc := integral_Ioi_of_hasDerivAt_of_tendsto'
    (fun x _ ↦ hderiv x) hint htend
  simpa only [f, f', zero_sub, neg_neg] using hftc

/-- Integration by parts for the unnormalized second moment on a Gaussian
upper tail.  This is the calculus identity behind Exercise 2.1.4. -/
theorem integral_Ioi_sq_mul_exp_neg_sq_div_two (t : ℝ) (ht : 0 < t) :
    (∫ x in Ioi t, x ^ 2 * Real.exp (-(x ^ 2) / 2)) =
      t * Real.exp (-(t ^ 2) / 2) +
        ∫ x in Ioi t, Real.exp (-(x ^ 2) / 2) := by
  have hgauss : IntegrableOn (fun x : ℝ ↦ Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
    have h : IntegrableOn (fun x : ℝ ↦ Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        (Ioi t) := (integrable_exp_neg_mul_sq
          (by norm_num : (0 : ℝ) < 1 / 2)).integrableOn
    apply h.congr
    filter_upwards [] with x
    apply congrArg Real.exp
    ring
  have hsq : IntegrableOn
      (fun x : ℝ ↦ x ^ 2 * Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
    have hraw := integrableOn_rpow_mul_exp_neg_mul_sq
      (b := (1 / 2 : ℝ)) (s := (2 : ℝ)) (by norm_num) (by norm_num)
    have hsub : Ioi t ⊆ Ioi (0 : ℝ) := Ioi_subset_Ioi ht.le
    apply (hraw.mono_set hsub).congr
    filter_upwards [] with x
    rw [Real.rpow_two]
    congr 2
    ring
  let f : ℝ → ℝ := fun x ↦ -(x * Real.exp (-(x ^ 2) / 2))
  let f' : ℝ → ℝ := fun x ↦ (x ^ 2 - 1) * Real.exp (-(x ^ 2) / 2)
  have hderiv : ∀ x : ℝ, HasDerivAt f (f' x) x := by
    intro x
    have hexp := ((hasDerivAt_pow 2 x).const_mul (-(1 / 2 : ℝ))).exp
    dsimp [f, f']
    convert ((hasDerivAt_id x).mul hexp).neg using 1
    · ext y
      congr 2
      ring
    · simp
      ring
  have hf'int : IntegrableOn f' (Ioi t) := by
    apply (hsq.sub hgauss).congr
    filter_upwards [] with x
    dsimp [f']
    ring
  have htend : Tendsto f atTop (𝓝 0) := by
    have hdecay : Tendsto
        (fun x : ℝ ↦ x ^ (1 : ℝ) * Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        atTop (𝓝 0) :=
      (rpow_mul_exp_neg_mul_sq_isLittleO_exp_neg
        (by norm_num : (0 : ℝ) < 1 / 2) 1).tendsto_zero_of_tendsto
        (Real.tendsto_exp_atBot.comp
          (tendsto_id.const_mul_atTop_of_neg (by norm_num : -(1 / 2 : ℝ) < 0)))
    have hmul : Tendsto
        (fun x : ℝ ↦ x * Real.exp (-(x ^ 2) / 2)) atTop (𝓝 0) := by
      apply hdecay.congr'
      filter_upwards [eventually_gt_atTop 0] with x hx
      rw [Real.rpow_one]
      congr 2
      ring
    simpa only [f, neg_zero] using hmul.neg
  have hmain :
      (∫ x in Ioi t, (x ^ 2 - 1) * Real.exp (-(x ^ 2) / 2)) =
        t * Real.exp (-(t ^ 2) / 2) := by
    have hftc := integral_Ioi_of_hasDerivAt_of_tendsto'
      (fun x _ ↦ hderiv x) hf'int htend
    simpa only [f, f', zero_sub, neg_neg] using hftc
  calc
    (∫ x in Ioi t, x ^ 2 * Real.exp (-(x ^ 2) / 2)) =
        ∫ x in Ioi t,
          (x ^ 2 - 1) * Real.exp (-(x ^ 2) / 2) +
            Real.exp (-(x ^ 2) / 2) := by
      apply integral_congr_ae
      filter_upwards [] with x
      ring
    _ = (∫ x in Ioi t, (x ^ 2 - 1) * Real.exp (-(x ^ 2) / 2)) +
          ∫ x in Ioi t, Real.exp (-(x ^ 2) / 2) :=
      integral_add hf'int hgauss
    _ = t * Real.exp (-(t ^ 2) / 2) +
          ∫ x in Ioi t, Real.exp (-(x ^ 2) / 2) := by rw [hmain]

/-- The upper half of the unnormalized Mills-ratio estimate. -/
theorem gaussianIntegral_Ioi_le (t : ℝ) (ht : 0 < t) :
    (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) ≤
      (1 / t) * Real.exp (-(t ^ 2) / 2) := by
  have hgauss : IntegrableOn (fun x : ℝ ↦ Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
    have h : IntegrableOn (fun x : ℝ ↦ Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        (Ioi t) := (integrable_exp_neg_mul_sq
          (by norm_num : (0 : ℝ) < 1 / 2)).integrableOn
    apply h.congr
    filter_upwards [] with x
    apply congrArg Real.exp
    ring
  have hscaled : IntegrableOn
      (fun x : ℝ ↦ (1 / t) * (x * Real.exp (-(x ^ 2) / 2))) (Ioi t) := by
    have hmul : IntegrableOn (fun x : ℝ ↦ x * Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
      have h : IntegrableOn (fun x : ℝ ↦ x * Real.exp (-(1 / 2 : ℝ) * x ^ 2))
          (Ioi t) := (integrable_mul_exp_neg_mul_sq
            (by norm_num : (0 : ℝ) < 1 / 2)).integrableOn
      apply h.congr
      filter_upwards [] with x
      congr 2
      ring
    exact hmul.const_mul _
  calc
    (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) ≤
        ∫ x in Ioi t, (1 / t) * (x * Real.exp (-(x ^ 2) / 2)) := by
      apply setIntegral_mono_on hgauss hscaled measurableSet_Ioi
      intro x hx
      have hratio : 1 ≤ (1 / t) * x := by
        have h' : 1 ≤ x / t := (le_div_iff₀ ht).2 (by simpa using le_of_lt hx)
        simpa [div_eq_mul_inv, mul_comm] using h'
      nlinarith [Real.exp_pos (-(x ^ 2) / 2)]
    _ = (1 / t) * ∫ x in Ioi t, x * Real.exp (-(x ^ 2) / 2) := by
      rw [integral_const_mul]
    _ = (1 / t) * Real.exp (-(t ^ 2) / 2) := by
      rw [integral_Ioi_mul_exp_neg_sq_div_two]

/-- Integration by parts with `x ↦ exp (-x² / 2) / x`.  This identity gives a
slightly stronger lower Mills-ratio bound than the one printed in Proposition
2.1.2. -/
theorem integral_Ioi_one_add_inv_sq_mul_exp_neg_sq_div_two (t : ℝ) (ht : 0 < t) :
    (∫ x in Ioi t, (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)) =
      (1 / t) * Real.exp (-(t ^ 2) / 2) := by
  let f : ℝ → ℝ := fun x ↦ -(x⁻¹ * Real.exp (-(x ^ 2) / 2))
  let f' : ℝ → ℝ := fun x ↦ (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)
  have hderiv : ∀ x ∈ Ici t, HasDerivAt f (f' x) x := by
    intro x hx
    have hxpos : 0 < x := ht.trans_le hx
    have hexp := ((hasDerivAt_pow 2 x).const_mul (-(1 / 2 : ℝ))).exp
    have hinv := hasDerivAt_inv hxpos.ne'
    dsimp [f, f']
    convert (hinv.mul hexp).neg using 1
    · ext y
      congr 2
      ring
    · field_simp
      ring
  have hnonneg : ∀ x ∈ Ioi t, 0 ≤ f' x := by
    intro x hx
    dsimp [f']
    positivity
  have htend : Tendsto f atTop (𝓝 0) := by
    have hpow : Tendsto (fun x : ℝ ↦ x ^ 2) atTop atTop :=
      tendsto_pow_atTop (by norm_num)
    have hinner : Tendsto (fun x : ℝ ↦ -(1 / 2 : ℝ) * x ^ 2) atTop atBot :=
      hpow.const_mul_atTop_of_neg (by norm_num)
    have hexp : Tendsto (fun x : ℝ ↦ Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        atTop (𝓝 0) := Real.tendsto_exp_atBot.comp hinner
    have hprod := (tendsto_inv_atTop_zero :
      Tendsto (fun x : ℝ ↦ x⁻¹) atTop (𝓝 0)).mul hexp
    convert hprod.neg using 1
    · ext x
      dsimp [f]
      congr 3
      ring
    · simp
  have hftc := integral_Ioi_of_hasDerivAt_of_nonneg' hderiv hnonneg htend
  simpa only [f, f', zero_sub, neg_neg, one_div] using hftc

/-- The lower half of the unnormalized Mills-ratio estimate, in the exact form
printed in Proposition 2.1.2. -/
theorem gaussianIntegral_Ioi_ge (t : ℝ) (ht : 0 < t) :
    (1 / t - 1 / t ^ 3) * Real.exp (-(t ^ 2) / 2) ≤
      ∫ x in Ioi t, Real.exp (-(x ^ 2) / 2) := by
  have hgauss : IntegrableOn (fun x : ℝ ↦ Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
    have h : IntegrableOn (fun x : ℝ ↦ Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        (Ioi t) := (integrable_exp_neg_mul_sq
          (by norm_num : (0 : ℝ) < 1 / 2)).integrableOn
    apply h.congr
    filter_upwards [] with x
    apply congrArg Real.exp
    ring
  let c : ℝ := 1 + 1 / t ^ 2
  have hcpos : 0 < c := by
    dsimp [c]
    positivity
  have hscaled : IntegrableOn
      (fun x : ℝ ↦ c * Real.exp (-(x ^ 2) / 2)) (Ioi t) := hgauss.const_mul c
  have hpoint : ∀ x ∈ Ioi t,
      (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2) ≤
        c * Real.exp (-(x ^ 2) / 2) := by
    intro x hx
    have hxpos : 0 < x := ht.trans hx
    have hsq : t ^ 2 ≤ x ^ 2 :=
      (sq_le_sq₀ ht.le hxpos.le).2 (le_of_lt hx)
    have hinv : 1 / x ^ 2 ≤ 1 / t ^ 2 :=
      one_div_le_one_div_of_le (sq_pos_of_pos ht) hsq
    exact mul_le_mul_of_nonneg_right (by simpa [c] using add_le_add_left hinv 1)
      (Real.exp_pos _).le
  have hleft : IntegrableOn
      (fun x : ℝ ↦ (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
    apply Integrable.mono hscaled
    · have hcont : ContinuousOn
          (fun x : ℝ ↦ (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
        intro x hx
        have hx0 : x ≠ 0 := (ht.trans hx).ne'
        have hinvcont : ContinuousAt (fun y : ℝ ↦ 1 / y ^ 2) x :=
          continuousAt_const.div₀ (continuousAt_id.pow 2) (pow_ne_zero 2 hx0)
        have hexpcont : ContinuousAt (fun y : ℝ ↦ Real.exp (-(y ^ 2) / 2)) x :=
          Real.continuous_exp.continuousAt.comp
            ((continuousAt_id.pow 2).neg.div_const (2 : ℝ))
        exact ((continuousAt_const.add hinvcont).mul hexpcont).continuousWithinAt
      exact hcont.aestronglyMeasurable measurableSet_Ioi
    · filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
      simp only [Real.norm_eq_abs]
      rw [abs_of_nonneg (by positivity :
        0 ≤ (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)),
        abs_of_nonneg (by positivity : 0 ≤ c * Real.exp (-(x ^ 2) / 2))]
      exact hpoint x hx
  have hmain : (1 / t) * Real.exp (-(t ^ 2) / 2) ≤
      c * (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) := by
    rw [← integral_const_mul]
    rw [← integral_Ioi_one_add_inv_sq_mul_exp_neg_sq_div_two t ht]
    exact setIntegral_mono_on hleft hscaled measurableSet_Ioi hpoint
  apply (mul_le_mul_iff_left₀ hcpos).mp
  calc
    ((1 / t - 1 / t ^ 3) * Real.exp (-(t ^ 2) / 2)) * c =
        ((1 / t - 1 / t ^ 3) * c) * Real.exp (-(t ^ 2) / 2) := by ring
    _ ≤ (1 / t) * Real.exp (-(t ^ 2) / 2) := by
      apply mul_le_mul_of_nonneg_right
      · dsimp [c]
        have hnonneg : 0 ≤ t⁻¹ ^ 5 := by positivity
        field_simp
        nlinarith
      · positivity
    _ ≤ c * (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) := hmain
    _ = (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) * c := by ring

/-- Proposition 2.1.2: the standard-normal upper tail lies between the two
printed Mills-ratio expressions. -/
theorem standardNormalTail_bounds (t : ℝ) (ht : 0 < t) :
    (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t - 1 / t ^ 3) * Real.exp (-(t ^ 2) / 2)) ≤
        standardNormalLaw.real (Ici t) ∧
      standardNormalLaw.real (Ici t) ≤
        (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t) * Real.exp (-(t ^ 2) / 2)) := by
  rw [standardNormalTail_eq_densityIntegral]
  constructor
  · exact mul_le_mul_of_nonneg_left (gaussianIntegral_Ioi_ge t ht) (by positivity)
  · exact mul_le_mul_of_nonneg_left (gaussianIntegral_Ioi_le t ht) (by positivity)

/-- Equation (2.3): above threshold one, the standard-normal upper tail is at
most the density evaluated at the threshold. -/
theorem standardNormalTail_le_density (t : ℝ) (ht : 1 ≤ t) :
    standardNormalLaw.real (Ici t) ≤
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) := by
  have htpos : 0 < t := zero_lt_one.trans_le ht
  have hinv : 1 / t ≤ 1 := (div_le_one htpos).2 ht
  calc
    standardNormalLaw.real (Ici t) ≤
        (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t) * Real.exp (-(t ^ 2) / 2)) := (standardNormalTail_bounds t htpos).2
    _ ≤ (Real.sqrt (2 * Real.pi))⁻¹ *
          (1 * Real.exp (-(t ^ 2) / 2)) := by
      exact mul_le_mul_of_nonneg_left
        (mul_le_mul_of_nonneg_right hinv (Real.exp_pos _).le) (by positivity)
    _ = (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) := by ring

/-- Equation (2.10): the standard normal has the usual two-sided Gaussian
tail bound. -/
theorem standardNormal_twoSidedTail_le (t : ℝ) (ht : 0 ≤ t) :
    standardNormalLaw.real {x : ℝ | |x| ≥ t} ≤
      2 * Real.exp (-(t ^ 2) / 2) := by
  by_cases ht1 : 1 ≤ t
  · have hset : {x : ℝ | |x| ≥ t} = Ici t ∪ Iic (-t) := by
      ext x
      simp only [mem_setOf_eq, mem_union, mem_Iic, mem_Ici]
      constructor
      · intro h
        rcases (le_abs.mp h) with h | h
        · exact Or.inl h
        · exact Or.inr (by linarith)
      · rintro (h | h)
        · exact le_abs.mpr (Or.inl h)
        · exact le_abs.mpr (Or.inr (by linarith))
    have hmap : standardNormalLaw.map (fun x : ℝ => -x) = standardNormalLaw := by
      simpa [standardNormalLaw] using
        (ProbabilityTheory.gaussianReal_map_neg (μ := (0 : ℝ)) (v := (1 : ℝ≥0)))
    have hsym : standardNormalLaw.real (Iic (-t)) =
        standardNormalLaw.real (Ici t) := by
      calc
        standardNormalLaw.real (Iic (-t)) =
            (standardNormalLaw.map (fun x : ℝ => -x)).real (Iic (-t)) := by rw [hmap]
        _ = standardNormalLaw.real (Ici t) := by
          simp only [Measure.real_def,
            Measure.map_apply (by fun_prop : Measurable (fun x : ℝ => -x)) measurableSet_Iic,
            neg_preimage, neg_Iic, neg_neg]
    have hc : (Real.sqrt (2 * Real.pi))⁻¹ ≤ 1 := by
      have hpi : 1 ≤ 2 * Real.pi := by nlinarith [Real.two_le_pi]
      have hsqrt : 1 ≤ Real.sqrt (2 * Real.pi) := by
        rw [← Real.sqrt_one]
        exact Real.sqrt_le_sqrt hpi
      exact (inv_le_one₀ (by positivity)).2 hsqrt
    rw [hset]
    calc
      standardNormalLaw.real (Ici t ∪ Iic (-t)) ≤
          standardNormalLaw.real (Ici t) +
            standardNormalLaw.real (Iic (-t)) := measureReal_union_le _ _
      _ = 2 * standardNormalLaw.real (Ici t) := by rw [hsym]; ring
      _ ≤ 2 * ((Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-(t ^ 2) / 2)) := by
        gcongr
        exact standardNormalTail_le_density t ht1
      _ ≤ 2 * Real.exp (-(t ^ 2) / 2) := by
        gcongr
        simpa only [one_mul] using
          mul_le_mul_of_nonneg_right hc (Real.exp_pos (-(t ^ 2) / 2)).le
  · have htlt : t < 1 := lt_of_not_ge ht1
    have hprob : standardNormalLaw.real {x : ℝ | |x| ≥ t} ≤ 1 := by
      calc
        standardNormalLaw.real {x : ℝ | |x| ≥ t} ≤
            standardNormalLaw.real Set.univ := by
          simp only [Measure.real_def]
          exact ENNReal.toReal_mono (measure_ne_top standardNormalLaw Set.univ)
            (measure_mono (Set.subset_univ _))
        _ = 1 := probReal_univ
    have hsquare : t ^ 2 ≤ 1 := by nlinarith [sq_nonneg t]
    have hexp_half : (1 / 2 : ℝ) ≤ Real.exp (-(1 : ℝ) / 2) := by
      have h := Real.add_one_le_exp (-(1 : ℝ) / 2)
      norm_num at h ⊢
      exact h
    have hexp : Real.exp (-(1 : ℝ) / 2) ≤ Real.exp (-(t ^ 2) / 2) := by
      exact Real.exp_le_exp.mpr (by linarith)
    calc
      standardNormalLaw.real {x : ℝ | |x| ≥ t} ≤ 1 := hprob
      _ ≤ 2 * Real.exp (-(1 : ℝ) / 2) := by linarith
      _ ≤ 2 * Real.exp (-(t ^ 2) / 2) := by gcongr

/-- The standard-normal second moment above `t` equals a boundary density term
plus the upper-tail probability. -/
theorem standardNormal_truncatedSecondMoment_eq (t : ℝ) (ht : 0 < t) :
    (∫ x in Ioi t, x ^ 2 ∂standardNormalLaw) =
      t * (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) +
        standardNormalLaw.real (Ici t) := by
  let c : ℝ := (Real.sqrt (2 * Real.pi))⁻¹
  have hconvert :
      (∫ x in Ioi t, x ^ 2 ∂standardNormalLaw) =
        c * ∫ x in Ioi t, x ^ 2 * Real.exp (-(x ^ 2) / 2) := by
    rw [← integral_indicator measurableSet_Ioi]
    rw [standardNormalLaw,
      ProbabilityTheory.integral_gaussianReal_eq_integral_smul
        (by norm_num : (1 : ℝ≥0) ≠ 0)]
    calc
      (∫ x, ProbabilityTheory.gaussianPDFReal 0 1 x •
          (Ioi t).indicator (fun x : ℝ ↦ x ^ 2) x) =
          ∫ x, c * (Ioi t).indicator
            (fun x : ℝ ↦ x ^ 2 * Real.exp (-(x ^ 2) / 2)) x := by
        apply integral_congr_ae
        filter_upwards [] with x
        rw [standardNormalLaw_pdf]
        by_cases hx : x ∈ Ioi t <;> simp [hx, c]
        ring
      _ = c * ∫ x, (Ioi t).indicator
          (fun x : ℝ ↦ x ^ 2 * Real.exp (-(x ^ 2) / 2)) x := by
        rw [integral_const_mul]
      _ = c * ∫ x in Ioi t, x ^ 2 * Real.exp (-(x ^ 2) / 2) := by
        rw [integral_indicator measurableSet_Ioi]
  rw [hconvert, integral_Ioi_sq_mul_exp_neg_sq_div_two t ht, mul_add]
  rw [← standardNormalTail_eq_densityIntegral t]
  dsimp [c]
  ring

/-- Exercise 2.1.4: the exact truncated-second-moment identity and the bound
obtained by applying the upper Mills estimate. -/
theorem standardNormal_truncatedSecondMoment (t : ℝ) (ht : 1 ≤ t) :
    (∫ x in Ioi t, x ^ 2 ∂standardNormalLaw) =
        t * (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) +
          standardNormalLaw.real (Ici t) ∧
      (∫ x in Ioi t, x ^ 2 ∂standardNormalLaw) ≤
        (t + 1 / t) * (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-(t ^ 2) / 2) := by
  have htpos : 0 < t := zero_lt_one.trans_le ht
  have heq := standardNormal_truncatedSecondMoment_eq t htpos
  refine ⟨heq, ?_⟩
  rw [heq]
  calc
    t * (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) +
          standardNormalLaw.real (Ici t) ≤
        t * (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) +
          (Real.sqrt (2 * Real.pi))⁻¹ *
            ((1 / t) * Real.exp (-(t ^ 2) / 2)) := by
      gcongr
      exact (standardNormalTail_bounds t htpos).2
    _ = (t + 1 / t) * (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-(t ^ 2) / 2) := by ring

end NumStability.HDP.Scalar.GaussianTails
```

### `ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/IndependentSums/GraphDegreeLaw.lean`
SHA-256: `d868c85d1ae1893fc87a4fe602cfee9d91115df6b4469394bd0cba599c4a4d82`

```lean
import Mathlib.Probability.Combinatorics.BinomialRandomGraph.Defs
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Probability.HasLaw
import Mathlib.Probability.ProbabilityMassFunction.Binomial
import Mathlib.Tactic

/-!
# Vertex-degree law for binomial random graphs

This reusable support module identifies the degree of a fixed vertex in
Mathlib's binomial random graph with the corresponding binomial law. It is
kept separate from the source-facing Chernoff applications so the finite-event
and measurability lemmas can be reused independently.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

/-- The unordered pairs formed by `v` and the vertices in `S`. -/
def graphStarEdgeFinset {V : Type*} (v : V) (S : Finset V) : Finset (Sym2 V) :=
  S.map (Sym2.mkEmbedding v)

@[simp] theorem graphStarEdgeFinset_card {V : Type*} (v : V) (S : Finset V) :
    (graphStarEdgeFinset v S).card = S.card := by
  simp [graphStarEdgeFinset]

/-- Subsets whose membership agrees with `T` on the finite coordinate set `E`. -/
def setBernoulliFinsetExactEvent {ι : Type*} (E T : Finset ι) : Set (Set ι) :=
  {s | ∀ e ∈ E, (e ∈ s ↔ e ∈ T)}

lemma finset_prod_ite_mem_eq_pow_mul_pow {α M : Type*}
    [DecidableEq α] [CommMonoid M] (E T : Finset α) (hT : T ⊆ E)
    (a b : M) :
    (∏ e ∈ E, if e ∈ T then a else b) =
      a ^ T.card * b ^ (E.card - T.card) := by
  classical
  have hfilter : E.filter (fun e => e ∈ T) = T := by
    ext e
    constructor
    · intro h
      exact (Finset.mem_filter.mp h).2
    · intro heT
      exact Finset.mem_filter.mpr ⟨hT heT, heT⟩
  have hfilterNot : E.filter (fun e => e ∉ T) = E \ T := by
    ext e
    simp
  calc
    (∏ e ∈ E, if e ∈ T then a else b) =
        (∏ e ∈ E.filter (fun e => e ∈ T), if e ∈ T then a else b) *
          (∏ e ∈ E.filter (fun e => e ∉ T), if e ∈ T then a else b) := by
      rw [← Finset.prod_filter_mul_prod_filter_not
        (s := E) (p := fun e => e ∈ T)
        (f := fun e => if e ∈ T then a else b)]
    _ = (∏ _e ∈ T, a) * (∏ _e ∈ E \ T, b) := by
      rw [hfilter, hfilterNot]
      congr 1
      · exact Finset.prod_congr rfl fun e he => by simp [he]
      · refine Finset.prod_congr rfl fun e he => ?_
        have hnot : e ∉ T := (Finset.mem_sdiff.mp he).2
        simp [hnot]
    _ = a ^ T.card * b ^ (E.card - T.card) := by
      simp [Finset.card_sdiff_of_subset hT]

lemma setBernoulliFinsetExactEvent_probability
    {ι : Type*} [DecidableEq ι] (u : Set ι) (p : Set.Icc (0 : ℝ) 1)
    (E T : Finset ι) (hE : (E : Set ι) ⊆ u) (hT : T ⊆ E) :
    setBer(u, p) (setBernoulliFinsetExactEvent E T) =
      (unitInterval.toNNReal p : ℝ≥0∞) ^ T.card *
        (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^
          (E.card - T.card) := by
  classical
  rw [ProbabilityTheory.setBernoulli_apply']
  have hpre :
      ((fun q : ι → Prop => {i | q i}) ⁻¹'
          setBernoulliFinsetExactEvent E T) =
        Set.pi (E : Set ι)
          (fun e => if e ∈ T then ({True} : Set Prop) else ({False} : Set Prop)) := by
    ext f
    simp only [Set.mem_preimage, setBernoulliFinsetExactEvent,
      Set.mem_setOf_eq, Set.mem_pi, Finset.mem_coe]
    constructor
    · intro h e heE
      by_cases heT : e ∈ T
      · simp [heT, (h e heE).2 heT]
      · have hnot : ¬ f e := fun hf => heT ((h e heE).1 hf)
        simp [heT, hnot]
    · intro h e heE
      have he := h e heE
      by_cases heT : e ∈ T
      · simp [heT] at he
        exact ⟨fun _ => heT, fun _ => he⟩
      · simp [heT] at he
        exact ⟨fun hf => (he hf).elim, fun hmem => False.elim (heT hmem)⟩
  rw [hpre, Measure.infinitePi_pi]
  · calc
      (∏ e ∈ E,
          (unitInterval.toNNReal p • Measure.dirac (e ∈ u) +
              unitInterval.toNNReal (unitInterval.symm p) • Measure.dirac False)
            (if e ∈ T then ({True} : Set Prop) else ({False} : Set Prop))) =
        ∏ e ∈ E, if e ∈ T then
          (unitInterval.toNNReal p : ℝ≥0∞) else
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) := by
            refine Finset.prod_congr rfl ?_
            intro e heE
            have heu : e ∈ u := hE (by simpa using heE)
            by_cases heT : e ∈ T <;>
              simp [heT, heu, ENNReal.smul_def]
      _ = (unitInterval.toNNReal p : ℝ≥0∞) ^ T.card *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^
            (E.card - T.card) :=
          finset_prod_ite_mem_eq_pow_mul_pow E T hT _ _
  · intro e _he
    by_cases heT : e ∈ T <;> simp [heT]

/-- Graphs whose adjacency to `v` agrees with membership in `T` on `S`. -/
def graphStarExactEvent {V : Type*} (v : V) (S T : Finset V) : Set (SimpleGraph V) :=
  {G | ∀ w ∈ S, (G.Adj v w ↔ w ∈ T)}

lemma graphStarEdgeFinset_subset_diag_compl {V : Type*} {v : V} {S : Finset V}
    (hvS : v ∉ S) :
    (graphStarEdgeFinset v S : Set (Sym2 V)) ⊆ Sym2.diagSetᶜ := by
  intro e he
  rcases Finset.mem_map.mp he with ⟨w, hw, rfl⟩
  change s(v, w) ∈ Sym2.diagSetᶜ
  rw [Set.mem_compl_iff, Sym2.mem_diagSet, Sym2.mk_isDiag_iff]
  intro hvw
  exact hvS (by simpa [hvw] using hw)

/-- Graphs whose edge membership on `E` agrees exactly with `T`. -/
def graphEdgesExactFinsetEvent {V : Type*} (E T : Finset (Sym2 V)) :
    Set (SimpleGraph V) :=
  {G | ∀ e ∈ E, (e ∈ G.edgeSet ↔ e ∈ T)}

lemma measurableSet_graphEdgesExactFinsetEvent {V : Type*}
    [DecidableEq (Sym2 V)] (E T : Finset (Sym2 V)) :
    MeasurableSet (graphEdgesExactFinsetEvent E T) := by
  classical
  rw [show graphEdgesExactFinsetEvent E T =
      ⋂ e ∈ E,
        if e ∈ T then {G : SimpleGraph V | e ∈ G.edgeSet}
        else {G : SimpleGraph V | e ∉ G.edgeSet} by
    ext G
    simp only [Set.mem_iInter, graphEdgesExactFinsetEvent, Set.mem_setOf_eq]
    constructor
    · intro h e heE
      by_cases heT : e ∈ T
      · simp [heT, (h e heE).2 heT]
      · have hnot : e ∉ G.edgeSet := fun hmem => heT ((h e heE).1 hmem)
        simp [heT, hnot]
    · intro h e heE
      have he := h e heE
      by_cases heT : e ∈ T
      · simp [heT] at he
        exact ⟨fun _ => heT, fun _ => he⟩
      · simp [heT] at he
        exact ⟨fun hmem => (he hmem).elim,
          fun hmemT => False.elim (heT hmemT)⟩]
  exact E.measurableSet_biInter fun e _he => by
    by_cases heT : e ∈ T
    · simpa only [heT, if_true] using
        (measurableSet_mem e).preimage SimpleGraph.measurable_edgeSet
    · simpa only [heT, if_false] using
        ((measurableSet_mem e).preimage SimpleGraph.measurable_edgeSet).compl

lemma graphStarExactEvent_eq_graphEdgesExactFinsetEvent
    {V : Type*} {v : V} {S T : Finset V} (hvS : v ∉ S) :
    graphStarExactEvent v S T =
      graphEdgesExactFinsetEvent (graphStarEdgeFinset v S)
        (graphStarEdgeFinset v T) := by
  ext G
  simp [graphStarExactEvent, graphEdgesExactFinsetEvent,
    graphStarEdgeFinset, SimpleGraph.mem_edgeSet]
  constructor
  · intro h a haS
    have hmem : (∃ b ∈ T, b = a ∨ v = a ∧ b = v) ↔ a ∈ T := by
      constructor
      · rintro ⟨b, hbT, hba | ⟨hva, _hbv⟩⟩
        · simpa [hba] using hbT
        · exact False.elim (hvS (by simpa [hva] using haS))
      · intro haT
        exact ⟨a, haT, Or.inl rfl⟩
    exact (h a haS).trans hmem.symm
  · intro h a haS
    have hmem : (∃ b ∈ T, b = a ∨ v = a ∧ b = v) ↔ a ∈ T := by
      constructor
      · rintro ⟨b, hbT, hba | ⟨hva, _hbv⟩⟩
        · simpa [hba] using hbT
        · exact False.elim (hvS (by simpa [hva] using haS))
      · intro haT
        exact ⟨a, haT, Or.inl rfl⟩
    exact (h a haS).trans hmem

lemma binomialRandom_graphStarExactEvent_probability
    {V : Type*} [Countable V] [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {v : V} {S T : Finset V} (hvS : v ∉ S) (hT : T ⊆ S) :
    SimpleGraph.binomialRandom V p (graphStarExactEvent v S T) =
      (unitInterval.toNNReal p : ℝ≥0∞) ^ T.card *
        (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^
          (S.card - T.card) := by
  rw [graphStarExactEvent_eq_graphEdgesExactFinsetEvent hvS]
  rw [SimpleGraph.binomialRandom_eq_map]
  rw [Measure.map_apply SimpleGraph.measurable_fromEdgeSet]
  · have hpre :
        SimpleGraph.fromEdgeSet ⁻¹'
            (graphEdgesExactFinsetEvent (graphStarEdgeFinset v S)
              (graphStarEdgeFinset v T)) =
          setBernoulliFinsetExactEvent (graphStarEdgeFinset v S)
            (graphStarEdgeFinset v T) := by
      ext s
      simp only [Set.mem_preimage, graphEdgesExactFinsetEvent,
        setBernoulliFinsetExactEvent, Set.mem_setOf_eq]
      constructor
      · intro hs e heE
        have hnotdiag : e ∈ Sym2.diagSetᶜ :=
          graphStarEdgeFinset_subset_diag_compl hvS (by simpa using heE)
        have hnotdiag' : ¬ e.IsDiag := by simpa [Sym2.mem_diagSet] using hnotdiag
        rw [SimpleGraph.edgeSet_fromEdgeSet] at hs
        have hiff := hs e heE
        simpa [hnotdiag'] using hiff
      · intro hs e heE
        have hnotdiag : e ∈ Sym2.diagSetᶜ :=
          graphStarEdgeFinset_subset_diag_compl hvS (by simpa using heE)
        have hnotdiag' : ¬ e.IsDiag := by simpa [Sym2.mem_diagSet] using hnotdiag
        rw [SimpleGraph.edgeSet_fromEdgeSet]
        simp [hnotdiag', hs e heE]
    rw [hpre]
    simpa [graphStarEdgeFinset] using (setBernoulliFinsetExactEvent_probability
      (u := Sym2.diagSetᶜ) (p := p)
      (E := graphStarEdgeFinset v S) (T := graphStarEdgeFinset v T)
      (graphStarEdgeFinset_subset_diag_compl hvS)
      (by simpa [graphStarEdgeFinset] using hT))
  · exact measurableSet_graphEdgesExactFinsetEvent _ _

lemma measurableSet_graphStarExactEvent
    {V : Type*} [DecidableEq (Sym2 V)] {v : V} {S T : Finset V}
    (hvS : v ∉ S) : MeasurableSet (graphStarExactEvent v S T) := by
  rw [graphStarExactEvent_eq_graphEdgesExactFinsetEvent hvS]
  exact measurableSet_graphEdgesExactFinsetEvent _ _

/-- Graphs in which `v` has exactly `k` neighbors in `S`. -/
def graphStarExactCardEvent {V : Type*} (v : V) (S : Finset V) (k : ℕ) :
    Set (SimpleGraph V) :=
  ⋃ T ∈ S.powersetCard k, graphStarExactEvent v S T

lemma measurableSet_graphStarExactCardEvent
    {V : Type*} [DecidableEq (Sym2 V)] {v : V} {S : Finset V}
    (hvS : v ∉ S) (k : ℕ) :
    MeasurableSet (graphStarExactCardEvent v S k) := by
  classical
  exact (S.powersetCard k).measurableSet_biUnion fun T _hT =>
    measurableSet_graphStarExactEvent hvS

lemma graphStarExactEvent_disjoint_of_ne
    {V : Type*} {v : V} {S T U : Finset V}
    (hT : T ⊆ S) (hU : U ⊆ S) (hne : T ≠ U) :
    Disjoint (graphStarExactEvent v S T) (graphStarExactEvent v S U) := by
  rw [Set.disjoint_left]
  intro G hGT hGU
  exact hne (by
    ext w
    by_cases hwS : w ∈ S
    · constructor
      · intro hwT
        exact (hGU w hwS).1 ((hGT w hwS).2 hwT)
      · intro hwU
        exact (hGT w hwS).1 ((hGU w hwS).2 hwU)
    · constructor
      · intro hwT
        exact False.elim (hwS (hT hwT))
      · intro hwU
        exact False.elim (hwS (hU hwU)))

lemma binomialRandom_graphStarExactCardEvent_probability_real
    {V : Type*} [Fintype V] [Countable V] [DecidableEq (Sym2 V)]
    (p : Set.Icc (0 : ℝ) 1) {v : V} {S : Finset V} (hvS : v ∉ S) (k : ℕ) :
    (SimpleGraph.binomialRandom V p).real
        (graphStarExactCardEvent v S k) =
      (Nat.choose S.card k : ℝ) * (unitInterval.toNNReal p : ℝ) ^ k *
        (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k) := by
  classical
  let C : Finset (Finset V) := S.powersetCard k
  let A : Finset V → Set (SimpleGraph V) :=
    fun T => graphStarExactEvent v S T
  have hpd : (↑C : Set (Finset V)).PairwiseDisjoint A := by
    intro T hTC U hUC hne
    exact graphStarExactEvent_disjoint_of_ne
      (Finset.mem_powersetCard.mp hTC).1
      (Finset.mem_powersetCard.mp hUC).1 hne
  have hmeas : ∀ T ∈ C, MeasurableSet (A T) := by
    intro T _hT
    exact measurableSet_graphStarExactEvent hvS
  have hUnionReal :
      (SimpleGraph.binomialRandom V p).real (⋃ T ∈ C, A T) =
        ∑ T ∈ C, (SimpleGraph.binomialRandom V p).real (A T) := by
    exact MeasureTheory.measureReal_biUnion_finset (μ := SimpleGraph.binomialRandom V p)
      hpd hmeas
  calc
    (SimpleGraph.binomialRandom V p).real
        (graphStarExactCardEvent v S k) =
      (SimpleGraph.binomialRandom V p).real (⋃ T ∈ C, A T) := by rfl
    _ = ∑ T ∈ C, (SimpleGraph.binomialRandom V p).real (A T) := hUnionReal
    _ = ∑ _T ∈ C,
        ((unitInterval.toNNReal p : ℝ) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k)) := by
      apply Finset.sum_congr rfl
      intro T hTC
      dsimp [A]
      rw [measureReal_def, binomialRandom_graphStarExactEvent_probability
        (p := p) hvS (Finset.mem_powersetCard.mp hTC).1]
      rw [(Finset.mem_powersetCard.mp hTC).2]
      simp
    _ = (C.card : ℝ) *
        ((unitInterval.toNNReal p : ℝ) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k)) := by
      simp
    _ = (Nat.choose S.card k : ℝ) *
        ((unitInterval.toNNReal p : ℝ) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k)) := by
      simp [C, Finset.card_powersetCard]
    _ = (Nat.choose S.card k : ℝ) * (unitInterval.toNNReal p : ℝ) ^ k *
        (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k) := by
      ring

lemma binomialRandom_graphStarExactCardEvent_probability
    {V : Type*} [Fintype V] [Countable V] [DecidableEq (Sym2 V)]
    (p : Set.Icc (0 : ℝ) 1) {v : V} {S : Finset V} (hvS : v ∉ S) (k : ℕ) :
    SimpleGraph.binomialRandom V p (graphStarExactCardEvent v S k) =
      (Nat.choose S.card k : ℝ≥0∞) *
        (unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k) := by
  classical
  let C : Finset (Finset V) := S.powersetCard k
  let A : Finset V → Set (SimpleGraph V) :=
    fun T => graphStarExactEvent v S T
  have hpd : (↑C : Set (Finset V)).PairwiseDisjoint A := by
    intro T hTC U hUC hne
    exact graphStarExactEvent_disjoint_of_ne
      (Finset.mem_powersetCard.mp hTC).1
      (Finset.mem_powersetCard.mp hUC).1 hne
  have hmeas : ∀ T ∈ C, MeasurableSet (A T) := by
    intro T _hT
    exact measurableSet_graphStarExactEvent hvS
  calc
    SimpleGraph.binomialRandom V p (graphStarExactCardEvent v S k) =
        SimpleGraph.binomialRandom V p (⋃ T ∈ C, A T) := by rfl
    _ = ∑ T ∈ C, SimpleGraph.binomialRandom V p (A T) :=
      MeasureTheory.measure_biUnion_finset (μ := SimpleGraph.binomialRandom V p) hpd hmeas
    _ = ∑ _T ∈ C,
        ((unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k)) := by
      apply Finset.sum_congr rfl
      intro T hTC
      dsimp [A]
      rw [binomialRandom_graphStarExactEvent_probability
        (p := p) hvS (Finset.mem_powersetCard.mp hTC).1]
      rw [(Finset.mem_powersetCard.mp hTC).2]
    _ = (C.card : ℝ≥0∞) *
        ((unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k)) := by
      simp
    _ = (Nat.choose S.card k : ℝ≥0∞) *
        ((unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k)) := by
      simp [C, Finset.card_powersetCard]
    _ = (Nat.choose S.card k : ℝ≥0∞) *
        (unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k) := by
      ring

/-- The `Set.ncard` of the neighbor set of `v`, hence zero when that set is infinite. -/
def graphDegree {V : Type*} (v : V) (G : SimpleGraph V) : ℕ :=
  (G.neighborSet v).ncard

/-- The degree of `v` written as a finite sum of adjacency indicators. -/
noncomputable def graphDegreeSum {V : Type*} [Fintype V] (v : V) (G : SimpleGraph V) : ℕ := by
  classical
  exact ∑ w : V, if G.Adj v w then 1 else 0

lemma graphDegreeSum_eq_graphDegree {V : Type*} [Fintype V]
    (v : V) (G : SimpleGraph V) :
    graphDegreeSum v G = graphDegree v G := by
  classical
  unfold graphDegreeSum graphDegree
  rw [Finset.sum_boole]
  simp only [SimpleGraph.neighborSet]
  rw [Set.ncard_eq_toFinset_card']
  simp

lemma measurable_graphDegreeSum {V : Type*} [Fintype V] (v : V) :
    Measurable (graphDegreeSum v) := by
  unfold graphDegreeSum
  refine Finset.measurable_fun_sum Finset.univ ?_
  intro w hw
  have hAdj : Measurable (fun G : SimpleGraph V => G.Adj v w) := by
    fun_prop
  have hset : MeasurableSet {G : SimpleGraph V | G.Adj v w} := by
    convert hAdj (measurableSet_singleton True) using 1
    ext G
    simp
  exact Measurable.ite hset measurable_const measurable_const

lemma graphStarExactCardEvent_eq_preimage_graphDegree
    {V : Type*} [Fintype V] [DecidableEq V] {v : V} (k : ℕ) :
    graphStarExactCardEvent v (Finset.univ.erase v) k =
      graphDegree v ⁻¹' ({k} : Set ℕ) := by
  classical
  ext G
  constructor
  · intro hG
    simp only [graphStarExactCardEvent, Set.mem_iUnion] at hG
    rcases hG with ⟨T, hTC, hGT⟩
    have hTsub : T ⊆ Finset.univ.erase v :=
      (Finset.mem_powersetCard.mp hTC).1
    have hTcard : T.card = k := (Finset.mem_powersetCard.mp hTC).2
    have hneighbors : G.neighborSet v = (T : Set V) := by
      ext w
      constructor
      · intro hw
        have hwS : w ∈ (Finset.univ.erase v : Set V) := by
          simp only [Finset.mem_coe, Finset.mem_erase, Finset.mem_univ]
          exact ⟨by
            intro hwv
            subst w
            simp at hw, trivial⟩
        exact (hGT w hwS).1 (by simpa using hw)
      · intro hwT
        have hwS : w ∈ (Finset.univ.erase v : Set V) := hTsub (by simpa using hwT)
        exact (by simpa using (hGT w hwS).2 (by simpa using hwT))
    change (G.neighborSet v).ncard = k
    rw [hneighbors, Set.ncard_coe_finset]
    exact hTcard
  · intro hG
    have hdeg : graphDegree v G = k := by simpa using hG
    let T : Finset V := (G.neighborSet v).toFinset
    have hTsub : T ⊆ Finset.univ.erase v := by
      intro w hw
      have hwN : w ∈ G.neighborSet v := by simpa [T] using hw
      have hwv : w ≠ v := by
        intro hwv
        subst w
        simp at hwN
      simp [hwv]
    have hTcard : T.card = k := by
      calc
        T.card = (G.neighborSet v).ncard := by
          simp [T, Set.ncard_eq_toFinset_card']
        _ = graphDegree v G := rfl
        _ = k := hdeg
    have hGT : G ∈ graphStarExactEvent v (Finset.univ.erase v) T := by
      intro w hwS
      constructor
      · intro hwAdj
        have hwN : w ∈ G.neighborSet v := by simpa using hwAdj
        simpa [T] using hwN
      · intro hwT
        have hwN : w ∈ G.neighborSet v := by simpa [T] using hwT
        simpa using hwN
    simp only [graphStarExactCardEvent, Set.mem_iUnion]
    exact ⟨T, Finset.mem_powersetCard.mpr ⟨hTsub, hTcard⟩, hGT⟩

lemma graphStarExactCardEvent_eq_preimage_graphDegreeSum
    {V : Type*} [Fintype V] [DecidableEq V] {v : V} (k : ℕ) :
    graphStarExactCardEvent v (Finset.univ.erase v) k =
      graphDegreeSum v ⁻¹' ({k} : Set ℕ) := by
  rw [graphStarExactCardEvent_eq_preimage_graphDegree k]
  ext G
  simp [graphDegreeSum_eq_graphDegree]

/-- The natural-valued pushforward of the binomial law with `n - 1` trials. -/
noncomputable def graphBinomialLaw (n : ℕ) (p : Set.Icc (0 : ℝ) 1) : Measure ℕ :=
  ((PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).map
      (fun i : Fin (n - 1 + 1) => (i : ℕ))).toMeasure

lemma graphBinomialLaw_apply_of_lt (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (k : ℕ)
    (hk : k < n - 1 + 1) :
    graphBinomialLaw n p {k} =
      ↑((unitInterval.toNNReal p) ^ k *
        (1 - unitInterval.toNNReal p) ^ ((n - 1) - k) *
          ((n - 1).choose k : ℕ) : ℝ≥0∞) := by
  rw [graphBinomialLaw, PMF.toMeasure_apply_singleton _ k (measurableSet_singleton k)]
  rw [PMF.map_apply, tsum_fintype]
  simp only [PMF.binomial_apply]
  rw [Finset.sum_eq_single (⟨k, hk⟩ : Fin (n - 1 + 1))]
  · simp
  · intro b _hb hbk
    by_cases h : k = (b : ℕ)
    · exfalso
      apply hbk
      apply Fin.ext
      exact h.symm
    · simp [h]
  · simp

theorem graphDegreeSum_map_apply {n : ℕ} (p : Set.Icc (0 : ℝ) 1) (v : Fin n) (k : ℕ) :
    (SimpleGraph.binomialRandom (Fin n) p).map (graphDegreeSum v) {k} =
      graphBinomialLaw n p {k} := by
  rw [Measure.map_apply (measurable_graphDegreeSum v) (measurableSet_singleton k)]
  rw [← graphStarExactCardEvent_eq_preimage_graphDegreeSum k]
  rw [binomialRandom_graphStarExactCardEvent_probability
    (p := p) (v := v) (S := Finset.univ.erase v) (by simp) k]
  rw [graphBinomialLaw, PMF.toMeasure_apply_singleton _ k (measurableSet_singleton k)]
  rw [PMF.map_apply, tsum_fintype]
  by_cases hk : k < n - 1 + 1
  · rw [Finset.sum_eq_single (⟨k, hk⟩ : Fin (n - 1 + 1))]
    · have hq : 1 - unitInterval.toNNReal p =
          unitInterval.toNNReal (unitInterval.symm p) := by
        exact (eq_tsub_of_add_eq (unitInterval.toNNReal_symm_add_toNNReal p)).symm
      have hpNN : unitInterval.toNNReal p ≤ 1 := by
        change (p : ℝ) ≤ 1
        exact p.2.2
      have hqE : (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) =
          1 - (unitInterval.toNNReal p : ℝ≥0∞) := by
        calc
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) =
              (1 - unitInterval.toNNReal p : ℝ≥0∞) :=
            congrArg (fun x : ℝ≥0 => (x : ℝ≥0∞)) hq.symm
          _ = 1 - (unitInterval.toNNReal p : ℝ≥0∞) := by
            rfl
      simp [PMF.binomial_apply, Finset.card_erase_of_mem, hqE]
      ring
    · intro b _hb hbk
      by_cases h : k = (b : ℕ)
      · exfalso
        apply hbk
        apply Fin.ext
        exact h.symm
      · simp [h]
    · simp
  · have hk' : n - 1 + 1 ≤ k := Nat.le_of_not_gt hk
    simp only [PMF.binomial_apply]
    have hlt : n - 1 < k := by omega
    have hne : ∀ b : Fin (n - 1 + 1), k ≠ (b : ℕ) := by
      intro b h
      omega
    simp [Finset.card_erase_of_mem, Nat.choose_eq_zero_of_lt hlt, hne]

theorem graphDegreeSum_hasLaw {n : ℕ} (p : Set.Icc (0 : ℝ) 1) (v : Fin n) :
    HasLaw (graphDegreeSum v) (graphBinomialLaw n p)
      (SimpleGraph.binomialRandom (Fin n) p) := by
  refine { aemeasurable := (measurable_graphDegreeSum v).aemeasurable, map_eq := ?_ }
  apply Measure.ext_of_singleton
  intro k
  exact graphDegreeSum_map_apply p v k

end NumStability.HDP.Scalar.IndependentSums.Chernoff
```

### `ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeDecoupling`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/IndependentSums/GraphDegreeDecoupling.lean`
SHA-256: `a9378cdd2182f30fda0f73795103bac9989ba7219c9752db6be8b0ee2034e52d`

```lean
import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw
import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics
import Mathlib.Data.Nat.Choose.Bounds
import Mathlib.Probability.Independence.InfinitePi

/-!
# Restricted degrees in binomial random graphs

This module starts the decoupling infrastructure for sparse random-graph lower
bounds.  A vertex is tested only against a prescribed finite set of possible
neighbors.  Its restricted degree has the canonical binomial law with one
trial per vertex in that set.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Topology

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

/-- Independence is preserved when a flat independent family is grouped into
disjoint dependent-product blocks. -/
lemma iIndepFun_group_sigma
    {I Ω : Type*} {J : I → Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : (i : I) → (j : J i) → Ω → Prop}
    (hX : ∀ i j, Measurable (X i j))
    (hflat : iIndepFun (fun p : (i : I) × J i ↦ X p.1 p.2) μ) :
    iIndepFun (fun i ω j ↦ X i j ω) μ := by
  have hrow (i : I) : iIndepFun (X i) μ := by
    exact hflat.precomp (g := fun j ↦ ⟨i, j⟩) (by
      intro j k hjk
      simpa using hjk)
  have : ∀ i j, IsProbabilityMeasure (μ.map (X i j)) :=
    fun i j ↦ Measure.isProbabilityMeasure_map (hX i j).aemeasurable
  rw [iIndepFun_iff_map_fun_eq_infinitePi_map (by fun_prop)]
  have hcurry :
      (fun ω i j ↦ X i j ω) =
        (MeasurableEquiv.piCurry (fun i j ↦ Prop)) ∘
          (fun ω (p : (i : I) × J i) ↦ X p.1 p.2 ω) := by
    funext ω i j
    rfl
  rw [hcurry, ← Measure.map_map (by fun_prop) (by fun_prop)]
  rw [(iIndepFun_iff_map_fun_eq_infinitePi_map (by
    intro p
    exact hX p.1 p.2)).1 hflat]
  rw [Measure.infinitePi_map_piCurry
    (X := fun _ _ ↦ Prop) (μ := fun i j ↦ μ.map (X i j))]
  congrm Measure.infinitePi fun i ↦ ?_
  exact ((iIndepFun_iff_map_fun_eq_infinitePi_map (hX i)).1 (hrow i)).symm

/-- Pulling a measurable family back along a measurable random element turns
independence under the pushforward law into independence on the original
space. -/
lemma iIndepFun_map_iff
    {I Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
    {μ : Measure Ω} {F : Ω → Ω'} {X : I → Ω' → Prop}
    (hF : Measurable F) (hX : ∀ i, Measurable (X i)) :
    iIndepFun X (μ.map F) ↔ iIndepFun (fun i ↦ X i ∘ F) μ := by
  rw [iIndepFun_iff_measure_inter_preimage_eq_mul,
    iIndepFun_iff_measure_inter_preimage_eq_mul]
  constructor
  · intro h S sets hsets
    have hInter : MeasurableSet (⋂ i ∈ S, X i ⁻¹' sets i) :=
      S.measurableSet_biInter fun i hi ↦ (hsets i hi).preimage (hX i)
    calc
      μ (⋂ i ∈ S, (X i ∘ F) ⁻¹' sets i) =
          μ (F ⁻¹' (⋂ i ∈ S, X i ⁻¹' sets i)) := by
        congr 1
        ext ω
        simp [Function.comp_def]
      _ = (μ.map F) (⋂ i ∈ S, X i ⁻¹' sets i) :=
        (Measure.map_apply hF hInter).symm
      _ = ∏ i ∈ S, (μ.map F) (X i ⁻¹' sets i) := h S hsets
      _ = ∏ i ∈ S, μ (F ⁻¹' (X i ⁻¹' sets i)) := by
        apply Finset.prod_congr rfl
        intro i hi
        rw [Measure.map_apply hF ((hsets i hi).preimage (hX i))]
      _ = ∏ i ∈ S, μ ((X i ∘ F) ⁻¹' sets i) := by
        congr 1
  · intro h S sets hsets
    have hInter : MeasurableSet (⋂ i ∈ S, X i ⁻¹' sets i) :=
      S.measurableSet_biInter fun i hi ↦ (hsets i hi).preimage (hX i)
    calc
      (μ.map F) (⋂ i ∈ S, X i ⁻¹' sets i) =
          μ (F ⁻¹' (⋂ i ∈ S, X i ⁻¹' sets i)) :=
        Measure.map_apply hF hInter
      _ = μ (⋂ i ∈ S, (X i ∘ F) ⁻¹' sets i) := by
        congr 1
        ext ω
        simp [Function.comp_def]
      _ = ∏ i ∈ S, μ ((X i ∘ F) ⁻¹' sets i) := h S hsets
      _ = ∏ i ∈ S, (μ.map F) (X i ⁻¹' sets i) := by
        apply Finset.prod_congr rfl
        intro i hi
        rw [Measure.map_apply hF ((hsets i hi).preimage (hX i))]
        rfl

/-- Membership of each coordinate is a mutually independent family under a
set-Bernoulli product law. -/
lemma iIndepFun_setBernoulli_mem {I : Type*} (u : Set I)
    (p : Set.Icc (0 : ℝ) 1) :
    iIndepFun (fun i (s : Set I) ↦ i ∈ s) (setBer(u, p)) := by
  rw [ProbabilityTheory.setBernoulli_eq_map]
  apply (iIndepFun_map_iff (F := fun q : I → Prop ↦ {i | q i})
    (by fun_prop) (by intro i; fun_prop)).2
  simpa [Function.comp_def] using
    (iIndepFun_infinitePi
      (P := fun i : I ↦
        unitInterval.toNNReal p • Measure.dirac (i ∈ u) +
          unitInterval.toNNReal (unitInterval.symm p) • Measure.dirac False)
      (X := fun _ (q : Prop) ↦ q) (by intro i; fun_prop))

/-- Edge-membership coordinates are mutually independent under Mathlib's
binomial random-graph law. -/
lemma iIndepFun_binomialRandom_edgeMem {V : Type*} [Countable V]
    (p : Set.Icc (0 : ℝ) 1) :
    iIndepFun (fun e : Sym2 V ↦ fun G : SimpleGraph V ↦ e ∈ G.edgeSet)
      (SimpleGraph.binomialRandom V p) := by
  rw [SimpleGraph.binomialRandom_eq_map]
  apply (iIndepFun_map_iff (F := SimpleGraph.fromEdgeSet)
    SimpleGraph.measurable_fromEdgeSet (by intro e; fun_prop)).2
  have hmem := iIndepFun_setBernoulli_mem (I := Sym2 V) (u := Sym2.diagSetᶜ) p
  have hcomp := hmem.comp
    (fun e (q : Prop) ↦ q ∧ ¬ e.IsDiag) (by intro e; fun_prop)
  simpa [Function.comp_def, SimpleGraph.edgeSet_fromEdgeSet] using hcomp

lemma graphCrossEdge_injective {V : Type*} [DecidableEq V]
    {A B : Finset V} (hAB : Disjoint A B) :
    Function.Injective
      (fun q : (↑A × ↑B) ↦ s(q.1.1, q.2.1)) := by
  intro q r hqr
  rcases Sym2.eq_iff.mp hqr with h | h
  · apply Prod.ext
    · exact Subtype.ext h.1
    · exact Subtype.ext h.2
  · exfalso
    have hqB : q.1.1 ∈ B := by
      rw [h.1]
      exact r.2.2
    exact (Finset.disjoint_left.mp hAB q.1.2 hqB).elim

/-- If the centers `A` and possible neighbors `B` are disjoint, the adjacency
indicator vectors from each center into `B` are mutually independent. -/
lemma iIndepFun_graphCrossAdjacency_of_disjoint
    {V : Type*} [Countable V] [DecidableEq V]
    (p : Set.Icc (0 : ℝ) 1) {A B : Finset V} (hAB : Disjoint A B) :
    iIndepFun
      (fun a : ↑A ↦ fun G : SimpleGraph V ↦ fun b : ↑B ↦ G.Adj a.1 b.1)
      (SimpleGraph.binomialRandom V p) := by
  apply iIndepFun_group_sigma (by intro a b; fun_prop)
  have hflat := (iIndepFun_binomialRandom_edgeMem p).precomp
    (graphCrossEdge_injective hAB)
  have hflat' := hflat.precomp (Equiv.sigmaEquivProd ↑A ↑B).injective
  simpa [SimpleGraph.mem_edgeSet] using hflat'

/-- The number of neighbors of `v` belonging to the finite vertex set `S`. -/
noncomputable def graphRestrictedDegree {V : Type*}
    (v : V) (S : Finset V) (G : SimpleGraph V) : ℕ := by
  classical
  exact ∑ w ∈ S, if G.Adj v w then 1 else 0

/-- The first half of `Fin n`, used as independent degree-test centers. -/
def graphDegreeTestCenters (n : ℕ) : Finset (Fin n) :=
  Finset.univ.filter fun v => v.val < n / 2

/-- The complementary half of `Fin n`, used as possible neighbors of the
degree-test centers. -/
def graphDegreeTestNeighbors (n : ℕ) : Finset (Fin n) :=
  Finset.univ.filter fun v => ¬ v.val < n / 2

/-- A quarter-power-sized center count.  The `min` only handles the empty
graph uniformly; for every positive `n` it is the natural floor of
`exp (log n / 4)`. -/
noncomputable def graphDegreeExactTestCenterCount (n : ℕ) : ℕ :=
  min n ⌊Real.exp (Real.log (n : ℝ) / 4)⌋₊

/-- Sparse test centers used to turn exact restricted degree into exact full
degree while making internal center edges negligible. -/
noncomputable def graphDegreeExactTestCenters (n : ℕ) : Finset (Fin n) :=
  Finset.univ.filter fun v => v.val < graphDegreeExactTestCenterCount n

/-- Every vertex outside the sparse exact-degree test-center set. -/
noncomputable def graphDegreeExactTestNeighbors (n : ℕ) : Finset (Fin n) :=
  Finset.univ \ graphDegreeExactTestCenters n

@[simp] lemma card_graphDegreeTestCenters (n : ℕ) :
    (graphDegreeTestCenters n).card = n / 2 := by
  rw [graphDegreeTestCenters, Fin.card_filter_val_lt]
  exact min_eq_right (Nat.div_le_self n 2)

@[simp] lemma card_graphDegreeTestNeighbors (n : ℕ) :
    (graphDegreeTestNeighbors n).card = n - n / 2 := by
  have hsum := Finset.card_filter_add_card_filter_not
    (s := (Finset.univ : Finset (Fin n))) (fun v => v.val < n / 2)
  have hsum' : (graphDegreeTestCenters n).card +
      (graphDegreeTestNeighbors n).card = n := by
    simpa [graphDegreeTestCenters, graphDegreeTestNeighbors] using hsum
  rw [card_graphDegreeTestCenters] at hsum'
  omega

lemma graphDegreeTestCenters_disjoint_graphDegreeTestNeighbors (n : ℕ) :
    Disjoint (graphDegreeTestCenters n) (graphDegreeTestNeighbors n) := by
  rw [Finset.disjoint_left]
  simp [graphDegreeTestCenters, graphDegreeTestNeighbors]

@[simp] lemma card_graphDegreeExactTestCenters (n : ℕ) :
    (graphDegreeExactTestCenters n).card = graphDegreeExactTestCenterCount n := by
  rw [graphDegreeExactTestCenters, Fin.card_filter_val_lt]
  exact min_eq_right (min_le_left n
    ⌊Real.exp (Real.log (n : ℝ) / 4)⌋₊)

@[simp] lemma card_graphDegreeExactTestNeighbors (n : ℕ) :
    (graphDegreeExactTestNeighbors n).card =
      n - graphDegreeExactTestCenterCount n := by
  rw [graphDegreeExactTestNeighbors,
    Finset.card_sdiff_of_subset (Finset.subset_univ _)]
  simp

lemma graphDegreeExactTestCenters_disjoint_graphDegreeExactTestNeighbors (n : ℕ) :
    Disjoint (graphDegreeExactTestCenters n) (graphDegreeExactTestNeighbors n) := by
  rw [Finset.disjoint_left]
  simp [graphDegreeExactTestNeighbors]

lemma graphDegreeExactTestCenterCount_eq_natFloor (n : ℕ) (hn : 1 ≤ n) :
    graphDegreeExactTestCenterCount n =
      ⌊Real.exp (Real.log (n : ℝ) / 4)⌋₊ := by
  rw [graphDegreeExactTestCenterCount, min_eq_right]
  apply Nat.floor_le_of_le
  have hnR : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hlog0 : 0 ≤ Real.log (n : ℝ) := Real.log_nonneg hnR
  calc
    Real.exp (Real.log (n : ℝ) / 4) ≤ Real.exp (Real.log (n : ℝ)) := by
      apply Real.exp_le_exp.mpr
      linarith
    _ = (n : ℝ) := Real.exp_log (by positivity)

lemma two_mul_graphDegreeExactTestCenterCount_le (n : ℕ) (hn : 16 ≤ n) :
    2 * graphDegreeExactTestCenterCount n ≤ n := by
  let x : ℝ := Real.exp (Real.log (n : ℝ) / 4)
  have hnpos : (0 : ℝ) < (n : ℝ) := by positivity
  have hcountFloor : graphDegreeExactTestCenterCount n ≤ ⌊x⌋₊ :=
    min_le_right _ _
  have hfloor : (⌊x⌋₊ : ℝ) ≤ x := Nat.floor_le (by positivity)
  have hcount : (graphDegreeExactTestCenterCount n : ℝ) ≤ x := by
    have hcountCast : (graphDegreeExactTestCenterCount n : ℝ) ≤ (⌊x⌋₊ : ℝ) := by
      exact_mod_cast hcountFloor
    exact hcountCast.trans hfloor
  have hlog : Real.log (16 : ℝ) ≤ Real.log (n : ℝ) := by
    apply Real.strictMonoOn_log.monotoneOn
    · norm_num
    · exact hnpos
    · exact_mod_cast hn
  have hx2 : (2 : ℝ) ≤ x := by
    have hlog2 : Real.log (2 : ℝ) = Real.log (16 : ℝ) / 4 := by
      rw [show (16 : ℝ) = 2 ^ 4 by norm_num, Real.log_pow]
      norm_num
    calc
      (2 : ℝ) = Real.exp (Real.log 2) :=
        (Real.exp_log (by norm_num)).symm
      _ = Real.exp (Real.log 16 / 4) := by rw [hlog2]
      _ ≤ Real.exp (Real.log (n : ℝ) / 4) := by
        apply Real.exp_le_exp.mpr
        linarith
      _ = x := rfl
  have hx4 : x ^ 4 = (n : ℝ) := by
    dsimp [x]
    rw [show Real.exp (Real.log (n : ℝ) / 4) ^ 4 =
      Real.exp (4 * (Real.log (n : ℝ) / 4)) by
        simpa using (Real.exp_nat_mul (Real.log (n : ℝ) / 4) 4).symm]
    have hexponent : 4 * (Real.log (n : ℝ) / 4) = Real.log (n : ℝ) := by
      ring
    rw [hexponent, Real.exp_log hnpos]
  have hx3 : (2 : ℝ) ≤ x ^ 3 := by
    calc
      (2 : ℝ) ≤ 2 ^ 3 := by norm_num
      _ ≤ x ^ 3 := pow_le_pow_left₀ (by norm_num) hx2 3
  have h2x : (2 : ℝ) * x ≤ (n : ℝ) := by
    have := mul_le_mul_of_nonneg_right hx3 (by positivity : 0 ≤ x)
    rw [← hx4]
    nlinarith
  have hcast : (2 : ℝ) * (graphDegreeExactTestCenterCount n : ℝ) ≤
      (n : ℝ) := (mul_le_mul_of_nonneg_left hcount (by norm_num)).trans h2x
  exact_mod_cast hcast

/-- A restricted degree never exceeds the full degree. -/
lemma graphRestrictedDegree_le_graphDegreeSum
    {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) (v : V) (S : Finset V) :
    graphRestrictedDegree v S G ≤ graphDegreeSum v G := by
  classical
  rw [graphRestrictedDegree, graphDegreeSum]
  exact Finset.sum_le_sum_of_subset (Finset.subset_univ S)

/-- If `v` lies in `A` and there are no edges from `v` to another member of
`A`, then counting neighbors in the complement of `A` gives its full degree. -/
lemma graphRestrictedDegree_compl_eq_graphDegreeSum_of_no_internal
    {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) {A : Finset V} {v : V}
    (hno : ∀ w ∈ A, ¬ G.Adj v w) :
    graphRestrictedDegree v (Finset.univ \ A) G = graphDegreeSum v G := by
  classical
  unfold graphRestrictedDegree graphDegreeSum
  rw [Finset.sum_subset (Finset.sdiff_subset)]
  intro w hwU hwNot
  have hwA : w ∈ A := by
    by_contra hwA
    exact hwNot (by simp [hwA])
  simp [hno w hwA]

/-- A single adjacency event has probability at most the edge parameter.  The
diagonal case is empty; off the diagonal its probability is exactly `p`. -/
lemma binomialRandom_graphAdjEvent_real_le
    {V : Type*} [Countable V] [DecidableEq V] [DecidableEq (Sym2 V)]
    (p : Set.Icc (0 : ℝ) 1) (v w : V) :
    (SimpleGraph.binomialRandom V p).real {G | G.Adj v w} ≤ (p : ℝ) := by
  classical
  by_cases hvw : v = w
  · subst w
    simp
    exact p.2.1
  · have hevent : {G : SimpleGraph V | G.Adj v w} =
        graphStarExactEvent v {w} {w} := by
      ext G
      simp [graphStarExactEvent]
    rw [hevent, Measure.real_def,
      binomialRandom_graphStarExactEvent_probability p (by simp [hvw]) (by simp)]
    simp

/-- A union bound for the event that the induced graph on `A` contains an
edge.  Ordered pairs deliberately overcount, which keeps the bound elementary. -/
theorem binomialRandom_exists_internalAdj_probability_le
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1) (A : Finset V) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, ∃ b : ↑A, G.Adj a.1 b.1} ≤
      (A.card : ℝ) ^ 2 * (p : ℝ) := by
  classical
  let P : Measure (SimpleGraph V) := SimpleGraph.binomialRandom V p
  let Bad : ↑A → ↑A → Set (SimpleGraph V) :=
    fun a b ↦ {G | G.Adj a.1 b.1}
  have hevent : {G : SimpleGraph V | ∃ a : ↑A, ∃ b : ↑A,
      G.Adj a.1 b.1} = ⋃ a, ⋃ b, Bad a b := by
    ext G
    simp [Bad]
  rw [hevent]
  calc
    P.real (⋃ a, ⋃ b, Bad a b) ≤
        ∑ a, P.real (⋃ b, Bad a b) :=
      measureReal_iUnion_fintype_le (fun a ↦ ⋃ b, Bad a b)
    _ ≤ ∑ a, ∑ b, P.real (Bad a b) := by
      exact Finset.sum_le_sum fun a _ha ↦
        measureReal_iUnion_fintype_le (Bad a)
    _ ≤ ∑ _a : ↑A, ∑ _b : ↑A, (p : ℝ) := by
      exact Finset.sum_le_sum fun a _ha ↦
        Finset.sum_le_sum fun b _hb ↦ by
          simpa [P, Bad] using binomialRandom_graphAdjEvent_real_le p a.1 b.1
    _ = (A.card : ℝ) ^ 2 * (p : ℝ) := by
      simp
      ring

lemma measurable_graphRestrictedDegree {V : Type*} (v : V) (S : Finset V) :
    Measurable (graphRestrictedDegree v S) := by
  unfold graphRestrictedDegree
  refine Finset.measurable_fun_sum S ?_
  intro w hw
  have hAdj : Measurable (fun G : SimpleGraph V => G.Adj v w) := by
    fun_prop
  have hset : MeasurableSet {G : SimpleGraph V | G.Adj v w} := by
    convert hAdj (measurableSet_singleton True) using 1
    ext G
    simp
  exact Measurable.ite hset measurable_const measurable_const

/-- Restricted degrees from disjoint centers into one complementary vertex
set form a mutually independent family. -/
theorem iIndepFun_graphRestrictedDegree_of_disjoint
    {V : Type*} [Countable V] [DecidableEq V]
    (p : Set.Icc (0 : ℝ) 1) {A B : Finset V} (hAB : Disjoint A B) :
    iIndepFun (fun a : ↑A ↦ graphRestrictedDegree a.1 B)
      (SimpleGraph.binomialRandom V p) := by
  classical
  have hcross := iIndepFun_graphCrossAdjacency_of_disjoint p hAB
  have hsum := hcross.comp
    (fun _ f ↦ ∑ b : ↑B, if f b then 1 else 0) (by intro a; fun_prop)
  apply hsum.congr
  intro a
  filter_upwards with G
  change (∑ b : ↑B, if G.Adj a.1 b.1 then 1 else 0) =
    graphRestrictedDegree a.1 B G
  unfold graphRestrictedDegree
  exact (Finset.sum_subtype B (fun _ ↦ Iff.rfl)
    (fun w ↦ if G.Adj a.1 w then 1 else 0)).symm

lemma graphStarExactCardEvent_eq_preimage_graphRestrictedDegree
    {V : Type*} [DecidableEq V] {v : V} {S : Finset V} (k : ℕ) :
    graphStarExactCardEvent v S k =
      graphRestrictedDegree v S ⁻¹' ({k} : Set ℕ) := by
  classical
  ext G
  rw [Set.mem_preimage, Set.mem_singleton_iff]
  unfold graphRestrictedDegree
  rw [Finset.sum_boole]
  constructor
  · intro hG
    simp only [graphStarExactCardEvent, Set.mem_iUnion] at hG
    rcases hG with ⟨T, hTC, hGT⟩
    have hTsub : T ⊆ S := (Finset.mem_powersetCard.mp hTC).1
    have hfilter : S.filter (fun w => G.Adj v w) = T := by
      ext w
      by_cases hwS : w ∈ S
      · simp [hwS, (hGT w hwS)]
      · have hwT : w ∉ T := fun h => hwS (hTsub h)
        simp [hwS, hwT]
    rw [hfilter]
    exact (Finset.mem_powersetCard.mp hTC).2
  · intro hcard
    let T : Finset V := S.filter fun w => G.Adj v w
    have hTsub : T ⊆ S := Finset.filter_subset _ _
    have hGT : G ∈ graphStarExactEvent v S T := by
      intro w hwS
      simp [T, hwS]
    simp only [graphStarExactCardEvent, Set.mem_iUnion]
    exact ⟨T, Finset.mem_powersetCard.mpr ⟨hTsub, hcard⟩, hGT⟩

/-- The canonical natural-valued binomial law for a restricted degree. -/
noncomputable def graphRestrictedBinomialLaw
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) : Measure ℕ :=
  (LimitTheorems.binomialNatPMF (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) S.card).toMeasure

lemma graphRestrictedBinomialLaw_eq_graphBinomialLaw
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) :
    graphRestrictedBinomialLaw S p = graphBinomialLaw (S.card + 1) p := by
  simp [graphRestrictedBinomialLaw, graphBinomialLaw,
    LimitTheorems.binomialNatPMF]

lemma graphRestrictedBinomialLaw_real_singleton_of_le
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) (k : ℕ) (hk : k ≤ S.card) :
    (graphRestrictedBinomialLaw S p).real {k} =
      (Nat.choose S.card k : ℝ) * (unitInterval.toNNReal p : ℝ) ^ k *
        (1 - (unitInterval.toNNReal p : ℝ)) ^ (S.card - k) := by
  rw [graphRestrictedBinomialLaw_eq_graphBinomialLaw, Measure.real_def,
    graphBinomialLaw_apply_of_lt]
  · have hp1 : (unitInterval.toNNReal p : ℝ≥0∞) ≤ 1 := by
      exact_mod_cast p.2.2
    rw [ENNReal.toReal_mul, ENNReal.toReal_mul, ENNReal.toReal_pow,
      ENNReal.toReal_pow, ENNReal.toReal_sub_of_le hp1 (by simp),
      ENNReal.toReal_natCast]
    simp
    ring
  · omega

/-- A convenient lower bound for a binomial coefficient.  The ratio form is
chosen so it combines directly with the success-probability power in a
binomial point mass. -/
lemma choose_cast_ge_sub_ratio_pow (m k : ℕ) :
    (((m + 1 - k : ℕ) : ℝ) / (k : ℝ)) ^ k ≤ (Nat.choose m k : ℝ) := by
  rw [div_pow]
  calc
    ((m + 1 - k : ℕ) : ℝ) ^ k / (k : ℝ) ^ k ≤
        ((m + 1 - k : ℕ) : ℝ) ^ k / (k.factorial : ℝ) := by
      apply div_le_div_of_nonneg_left (by positivity) (by positivity)
      exact_mod_cast Nat.factorial_le_pow k
    _ ≤ (Nat.choose m k : ℝ) := Nat.pow_le_choose k m

/-- Lower-bound a restricted-degree point mass by replacing the binomial
coefficient with its elementary ratio bound. -/
lemma graphRestrictedBinomialLaw_real_singleton_ge_ratio_pow
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) (k : ℕ) (hk : k ≤ S.card) :
    ((((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        (1 - (unitInterval.toNNReal p : ℝ)) ^ (S.card - k) ≤
      (graphRestrictedBinomialLaw S p).real {k} := by
  rw [graphRestrictedBinomialLaw_real_singleton_of_le S p k hk]
  have hchoose : (((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) ^ k ≤
      (Nat.choose S.card k : ℝ) := choose_cast_ge_sub_ratio_pow S.card k
  have hp0 : 0 ≤ (unitInterval.toNNReal p : ℝ) := by positivity
  have hq0 : 0 ≤ 1 - (unitInterval.toNNReal p : ℝ) := by
    change 0 ≤ 1 - (p : ℝ)
    linarith [p.2.2]
  rw [mul_pow]
  exact mul_le_mul_of_nonneg_right
    (mul_le_mul_of_nonneg_right hchoose (pow_nonneg hp0 k))
    (pow_nonneg hq0 (S.card - k))

/-- On the interval `[0, 1/2]`, the logarithm of a Bernoulli failure
probability is bounded below by the first-order estimate `-2p`. -/
lemma log_one_sub_ge_neg_two_mul {p : ℝ} (hp0 : 0 ≤ p) (hp : p ≤ 1 / 2) :
    -(2 * p) ≤ Real.log (1 - p) := by
  have h1p : 0 < 1 - p := by linarith
  have h := Real.log_le_sub_one_of_pos (inv_pos.mpr h1p)
  rw [Real.log_inv] at h
  have hinv : (1 - p)⁻¹ - 1 = p / (1 - p) := by
    field_simp
    ring
  rw [hinv] at h
  have hfrac : p / (1 - p) ≤ 2 * p := by
    rw [div_le_iff₀ h1p]
    nlinarith
  linarith

/-- The Bernoulli failure power is bounded below by an exponential when the
success probability is at most one half. -/
lemma exp_neg_two_mul_le_one_sub_pow {p : ℝ} (hp0 : 0 ≤ p) (hp : p ≤ 1 / 2)
    (m : ℕ) :
    Real.exp (-(2 * (m : ℝ) * p)) ≤ (1 - p) ^ m := by
  have h1p : 0 < 1 - p := by linarith
  have hlog : -(2 * p) ≤ Real.log (1 - p) :=
    log_one_sub_ge_neg_two_mul hp0 hp
  calc
    Real.exp (-(2 * (m : ℝ) * p)) =
        Real.exp ((m : ℝ) * (-(2 * p))) := by ring_nf
    _ ≤ Real.exp ((m : ℝ) * Real.log (1 - p)) := by
      apply Real.exp_le_exp.mpr
      exact mul_le_mul_of_nonneg_left hlog (by positivity)
    _ = Real.exp (Real.log ((1 - p) ^ m)) := by rw [Real.log_pow]
    _ = (1 - p) ^ m := Real.exp_log (pow_pos h1p m)

/-- If an integer scale is little-oh of `log n`, then a fixed exponential
penalty in that scale is eventually dominated by the size of half of `Fin n`.
The numerical constants are tailored to the sparse-graph point-mass bound. -/
lemma eventually_log_ten_le_half_card_mul_exp_of_log_ratio_tendsto_zero
    (k : ℕ → ℕ)
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    ∀ᶠ n in Filter.atTop,
      Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
        Real.exp (-((k n : ℝ) * (Real.log 40 + 1 / 4))) := by
  let C : ℝ := Real.log 40 + 1 / 4
  have hlog40 : 0 < Real.log 40 := Real.log_pos (by norm_num)
  have hC : 0 < C := by dsimp [C]; positivity
  let ε : ℝ := 1 / (2 * C)
  have hε : 0 < ε := by dsimp [ε]; positivity
  rcases (Metric.tendsto_atTop.mp hsmall) ε hε with ⟨N, hN⟩
  refine Filter.eventually_atTop.2 ⟨max N 400, ?_⟩
  intro n hn
  have hnN : N ≤ n := (le_max_left N 400).trans hn
  have hn400 : 400 ≤ n := (le_max_right N 400).trans hn
  have hnpos : 0 < (n : ℝ) := by positivity
  have hn1 : 1 < (n : ℝ) := by exact_mod_cast (show 1 < n by omega)
  have hlogn : 0 < Real.log (n : ℝ) := Real.log_pos hn1
  have hratio0 : 0 ≤ (k n : ℝ) / Real.log (n : ℝ) :=
    div_nonneg (by positivity) hlogn.le
  have hdist := hN n hnN
  rw [Real.dist_eq, sub_zero, abs_of_nonneg hratio0] at hdist
  rw [div_lt_iff₀ hlogn] at hdist
  have hscaled := mul_lt_mul_of_pos_right hdist hC
  have heq : ε * Real.log (n : ℝ) * C = Real.log (n : ℝ) / 2 := by
    dsimp [ε]
    field_simp
  rw [heq] at hscaled
  have hlog400 : Real.log ((20 : ℝ) ^ 2) ≤ Real.log (n : ℝ) := by
    apply Real.strictMonoOn_log.monotoneOn
    · norm_num
    · exact hnpos
    · norm_num at hn400 ⊢
      exact hn400
  have hlog20 : Real.log 20 ≤ Real.log (n : ℝ) / 2 := by
    rw [Real.log_pow] at hlog400
    norm_num at hlog400 ⊢
    linarith
  have hbudget : (k n : ℝ) * C ≤ Real.log (n : ℝ) - Real.log 20 := by
    linarith
  have hexp : 20 / (n : ℝ) ≤ Real.exp (-((k n : ℝ) * C)) := by
    calc
      20 / (n : ℝ) = Real.exp (Real.log 20) / Real.exp (Real.log (n : ℝ)) := by
        rw [Real.exp_log (by norm_num), Real.exp_log hnpos]
      _ = Real.exp (Real.log 20 - Real.log (n : ℝ)) := (Real.exp_sub _ _).symm
      _ ≤ Real.exp (-((k n : ℝ) * C)) := by
        apply Real.exp_le_exp.mpr
        linarith
  have hhalf : (n : ℝ) - 1 ≤ 2 * ((n / 2 : ℕ) : ℝ) := by
    rw [← Nat.cast_one, ← Nat.cast_sub (show 1 ≤ n by omega)]
    exact_mod_cast (show n - 1 ≤ 2 * (n / 2) by omega)
  have hfactor : (9 : ℝ) ≤ ((n / 2 : ℕ) : ℝ) * (20 / (n : ℝ)) := by
    have hn10 : (10 : ℝ) ≤ (n : ℝ) := by exact_mod_cast (show 10 ≤ n by omega)
    rw [show ((n / 2 : ℕ) : ℝ) * (20 / (n : ℝ)) =
      (((n / 2 : ℕ) : ℝ) * 20) / (n : ℝ) by ring, le_div_iff₀ hnpos]
    nlinarith
  have hlog10 : Real.log (10 : ℝ) ≤ 9 := by
    nlinarith [Real.log_le_sub_one_of_pos (show (0 : ℝ) < 10 by norm_num)]
  calc
    Real.log 10 ≤ 9 := hlog10
    _ ≤ ((n / 2 : ℕ) : ℝ) * (20 / (n : ℝ)) := hfactor
    _ ≤ ((n / 2 : ℕ) : ℝ) * Real.exp (-((k n : ℝ) * C)) :=
      mul_le_mul_of_nonneg_left hexp (by positivity)
    _ = ((n / 2 : ℕ) : ℝ) *
        Real.exp (-((k n : ℝ) * (Real.log 40 + 1 / 4))) := by rfl

/-- The quarter-power center set still contains exponentially many trials on
the `k` scale whenever `k = o(log n)`. -/
lemma eventually_log_twenty_le_exact_center_card_mul_exp_of_log_ratio_tendsto_zero
    (k : ℕ → ℕ)
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    ∀ᶠ n in Filter.atTop,
      Real.log 20 ≤ (graphDegreeExactTestCenterCount n : ℝ) *
        Real.exp (-((k n : ℝ) * (Real.log 40 + 1 / 4))) := by
  let C : ℝ := Real.log 40 + 1 / 4
  have hlog40 : 0 < Real.log 40 := Real.log_pos (by norm_num)
  have hC : 0 < C := by dsimp [C]; positivity
  let ε : ℝ := 1 / (8 * C)
  have hε : 0 < ε := by dsimp [ε]; positivity
  rcases (Metric.tendsto_atTop.mp hsmall) ε hε with ⟨N, hN⟩
  have hscaled : ∀ᶠ n : ℕ in Filter.atTop,
      (k n : ℝ) * C ≤ Real.log (n : ℝ) / 8 := by
    refine Filter.eventually_atTop.2 ⟨max N 2, ?_⟩
    intro n hn
    have hnN : N ≤ n := (le_max_left N 2).trans hn
    have hn2 : 2 ≤ n := (le_max_right N 2).trans hn
    have hlogn : 0 < Real.log (n : ℝ) :=
      Real.log_pos (by exact_mod_cast (show 1 < n by omega))
    have hratio0 : 0 ≤ (k n : ℝ) / Real.log (n : ℝ) :=
      div_nonneg (by positivity) hlogn.le
    have hdist := hN n hnN
    rw [Real.dist_eq, sub_zero, abs_of_nonneg hratio0,
      div_lt_iff₀ hlogn] at hdist
    have hmul := mul_lt_mul_of_pos_right hdist hC
    have heq : ε * Real.log (n : ℝ) * C = Real.log (n : ℝ) / 8 := by
      dsimp [ε]
      field_simp
    rw [heq] at hmul
    exact hmul.le
  have hlogNat : Filter.Tendsto (fun n : ℕ => Real.log (n : ℝ))
      Filter.atTop Filter.atTop :=
    Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop
  have hquarter : Filter.Tendsto
      (fun n : ℕ => Real.log (n : ℝ) / 4) Filter.atTop Filter.atTop :=
    hlogNat.atTop_div_const (by norm_num)
  have heighth : Filter.Tendsto
      (fun n : ℕ => Real.log (n : ℝ) / 8) Filter.atTop Filter.atTop :=
    hlogNat.atTop_div_const (by norm_num)
  have hquarterExp : Filter.Tendsto
      (fun n : ℕ => Real.exp (Real.log (n : ℝ) / 4))
        Filter.atTop Filter.atTop := Real.tendsto_exp_atTop.comp hquarter
  have heighthExp : Filter.Tendsto
      (fun n : ℕ => Real.exp (Real.log (n : ℝ) / 8))
        Filter.atTop Filter.atTop := Real.tendsto_exp_atTop.comp heighth
  filter_upwards [hscaled, hquarterExp.eventually_ge_atTop 2,
    heighthExp.eventually_gt_atTop (2 * Real.log 20),
    Filter.eventually_atTop.2 ⟨1, fun n hn => hn⟩] with n hkn hx2 hlarge hn1
  let x : ℝ := Real.exp (Real.log (n : ℝ) / 4)
  have hcount : graphDegreeExactTestCenterCount n = ⌊x⌋₊ := by
    simpa [x] using graphDegreeExactTestCenterCount_eq_natFloor n hn1
  have hfloorlt : x < (⌊x⌋₊ : ℝ) + 1 := Nat.lt_floor_add_one x
  have hfloorlower : x / 2 ≤ (graphDegreeExactTestCenterCount n : ℝ) := by
    rw [hcount]
    dsimp [x] at hx2 ⊢
    nlinarith
  have hexp : Real.exp (-(Real.log (n : ℝ) / 8)) ≤
      Real.exp (-((k n : ℝ) * C)) := by
    apply Real.exp_le_exp.mpr
    exact neg_le_neg hkn
  calc
    Real.log 20 ≤ Real.exp (Real.log (n : ℝ) / 8) / 2 := by linarith
    _ = (x / 2) * Real.exp (-(Real.log (n : ℝ) / 8)) := by
      dsimp [x]
      rw [div_mul_eq_mul_div, ← Real.exp_add]
      congr 2
      ring
    _ ≤ (graphDegreeExactTestCenterCount n : ℝ) *
        Real.exp (-((k n : ℝ) * C)) :=
      mul_le_mul hfloorlower hexp (Real.exp_nonneg _) (by positivity)
    _ = (graphDegreeExactTestCenterCount n : ℝ) *
        Real.exp (-((k n : ℝ) * (Real.log 40 + 1 / 4))) := by rfl

/-- The finite arithmetic linking the expected-degree identity to the
balanced point-mass estimate. -/
lemma balanced_ratio_mass_bound_of_degree_relation
    (n k : ℕ) (p : Set.Icc (0 : ℝ) 1)
    (hn : 10 ≤ n) (hkpos : 0 < k) (hksmall : 4 * k ≤ n)
    (hrel : (k : ℝ) = 10 * ((n - 1 : ℕ) : ℝ) * (p : ℝ))
    (hlog : Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
      Real.exp (-((k : ℝ) * (Real.log 40 + 1 / 4)))) :
    k ≤ n - n / 2 ∧ (p : ℝ) ≤ 1 / 2 ∧
      Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
        ((((((n - n / 2 : ℕ) + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
            (unitInterval.toNNReal p : ℝ)) ^ k *
          Real.exp (-(2 * ((n - n / 2 : ℕ) : ℝ) * (p : ℝ)))) := by
  have hn1 : 1 ≤ n := by omega
  have hkB : k ≤ n - n / 2 := by omega
  have h4k : (4 : ℝ) * (k : ℝ) ≤ (n : ℝ) := by exact_mod_cast hksmall
  have hnR : (10 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have h20 : (n : ℝ) ≤ 20 * ((n - 1 : ℕ) : ℝ) := by
    rw [Nat.cast_sub hn1]
    norm_num
    nlinarith
  let B : ℕ := n - n / 2
  let q : ℝ := p
  have hq : q = (p : ℝ) := rfl
  have hnsubpos : (0 : ℝ) < ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast (show 0 < n - 1 by omega)
  have hden : 0 < 10 * ((n - 1 : ℕ) : ℝ) := by positivity
  have hpform : q = (k : ℝ) / (10 * ((n - 1 : ℕ) : ℝ)) := by
    rw [eq_div_iff (ne_of_gt hden)]
    rw [hq]
    nlinarith [hrel]
  have hp : (p : ℝ) ≤ 1 / 2 := by
    rw [← hq, hpform, div_le_iff₀ hden]
    nlinarith
  refine ⟨hkB, hp, ?_⟩
  have hnumNat : n ≤ 4 * (B + 1 - k) := by
    dsimp [B]
    omega
  have hnum : (n : ℝ) ≤ 4 * ((B + 1 - k : ℕ) : ℝ) := by
    exact_mod_cast hnumNat
  have hnsub_le : ((n - 1 : ℕ) : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast Nat.sub_le n 1
  have hbase : (1 : ℝ) / 40 ≤
      (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q := by
    have hkR : (0 : ℝ) < (k : ℝ) := by positivity
    rw [hpform]
    have heq : (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
        ((k : ℝ) / (10 * ((n - 1 : ℕ) : ℝ))) =
        ((B + 1 - k : ℕ) : ℝ) / (10 * ((n - 1 : ℕ) : ℝ)) := by
      field_simp
    rw [heq, le_div_iff₀ hden]
    nlinarith [hnsub_le]
  have hcoefNat : 4 * B ≤ 5 * (n - 1) := by
    dsimp [B]
    omega
  have hcoef : (4 : ℝ) * (B : ℝ) ≤ 5 * ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast hcoefNat
  have hcoefq := mul_le_mul_of_nonneg_right hcoef p.2.1
  have hexponent : 2 * (B : ℝ) * q ≤ (k : ℝ) / 4 := by
    rw [hq]
    nlinarith [hrel]
  have hbasePow : ((1 : ℝ) / 40) ^ k ≤
      ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k :=
    pow_le_pow_left₀ (by norm_num) hbase k
  have hexp : Real.exp (-((k : ℝ) / 4)) ≤
      Real.exp (-(2 * (B : ℝ) * q)) := by
    apply Real.exp_le_exp.mpr
    exact neg_le_neg hexponent
  have hlower : Real.exp (-((k : ℝ) * (Real.log 40 + 1 / 4))) ≤
      ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
        Real.exp (-(2 * (B : ℝ) * q)) := by
    have hpowid : ((1 : ℝ) / 40) ^ k =
        Real.exp (-((k : ℝ) * Real.log 40)) := by
      calc
        ((1 : ℝ) / 40) ^ k =
            (Real.exp (Real.log ((1 : ℝ) / 40))) ^ k := by
              rw [Real.exp_log (by norm_num)]
        _ = Real.exp ((k : ℝ) * Real.log ((1 : ℝ) / 40)) :=
          (Real.exp_nat_mul _ k).symm
        _ = Real.exp (-((k : ℝ) * Real.log 40)) := by
          rw [show (1 : ℝ) / 40 = (40 : ℝ)⁻¹ by ring, Real.log_inv]
          ring_nf
    calc
      Real.exp (-((k : ℝ) * (Real.log 40 + 1 / 4))) =
          ((1 : ℝ) / 40) ^ k * Real.exp (-((k : ℝ) / 4)) := by
        rw [hpowid, ← Real.exp_add]
        congr 1
        ring
      _ ≤ ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
          Real.exp (-(2 * (B : ℝ) * q)) :=
        mul_le_mul hbasePow hexp (Real.exp_nonneg _)
          (pow_nonneg ((by norm_num : (0 : ℝ) ≤ 1 / 40).trans hbase) k)
  change Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
    (((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
      Real.exp (-(2 * (B : ℝ) * q)))
  exact hlog.trans (mul_le_mul_of_nonneg_left hlower (by positivity))

/-- The expected-degree identity supplies the same explicit point-mass lower
bound for the sparse quarter-power center set and its complement. -/
lemma exact_center_ratio_mass_bound_of_degree_relation
    (n k : ℕ) (p : Set.Icc (0 : ℝ) 1)
    (hn : 16 ≤ n) (hkpos : 0 < k) (hksmall : 4 * k ≤ n)
    (hrel : (k : ℝ) = 10 * ((n - 1 : ℕ) : ℝ) * (p : ℝ))
    (hlog : Real.log 20 ≤ (graphDegreeExactTestCenterCount n : ℝ) *
      Real.exp (-((k : ℝ) * (Real.log 40 + 1 / 4)))) :
    k ≤ n - graphDegreeExactTestCenterCount n ∧ (p : ℝ) ≤ 1 / 2 ∧
      Real.log 20 ≤ (graphDegreeExactTestCenterCount n : ℝ) *
        ((((((n - graphDegreeExactTestCenterCount n : ℕ) + 1 - k : ℕ) : ℝ) /
              (k : ℝ)) * (unitInterval.toNNReal p : ℝ)) ^ k *
          Real.exp (-(2 * ((n - graphDegreeExactTestCenterCount n : ℕ) : ℝ) *
            (p : ℝ)))) := by
  let m : ℕ := graphDegreeExactTestCenterCount n
  let B : ℕ := n - m
  let q : ℝ := p
  have hmhalf : 2 * m ≤ n := by
    simpa [m] using two_mul_graphDegreeExactTestCenterCount_le n hn
  have hkB : k ≤ B := by dsimp [B]; omega
  have hn1 : 1 ≤ n := by omega
  have h4k : (4 : ℝ) * (k : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast hksmall
  have hnR : (16 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have h20 : (n : ℝ) ≤ 20 * ((n - 1 : ℕ) : ℝ) := by
    rw [Nat.cast_sub hn1]
    norm_num
    nlinarith
  have hnsubpos : (0 : ℝ) < ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast (show 0 < n - 1 by omega)
  have hden : 0 < 10 * ((n - 1 : ℕ) : ℝ) := by positivity
  have hpform : q = (k : ℝ) / (10 * ((n - 1 : ℕ) : ℝ)) := by
    rw [eq_div_iff (ne_of_gt hden)]
    dsimp [q]
    nlinarith [hrel]
  have hp : (p : ℝ) ≤ 1 / 2 := by
    change q ≤ 1 / 2
    rw [hpform, div_le_iff₀ hden]
    nlinarith
  refine ⟨by simpa [B, m] using hkB, hp, ?_⟩
  have hnumNat : n ≤ 4 * (B + 1 - k) := by
    dsimp [B]
    omega
  have hnum : (n : ℝ) ≤ 4 * ((B + 1 - k : ℕ) : ℝ) := by
    exact_mod_cast hnumNat
  have hnsub_le : ((n - 1 : ℕ) : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast Nat.sub_le n 1
  have hbase : (1 : ℝ) / 40 ≤
      (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q := by
    have hkR : (0 : ℝ) < (k : ℝ) := by positivity
    rw [hpform]
    have heq : (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
        ((k : ℝ) / (10 * ((n - 1 : ℕ) : ℝ))) =
        ((B + 1 - k : ℕ) : ℝ) / (10 * ((n - 1 : ℕ) : ℝ)) := by
      field_simp
    rw [heq, le_div_iff₀ hden]
    nlinarith [hnsub_le]
  have hcoefNat : 4 * B ≤ 5 * (n - 1) := by
    dsimp [B]
    omega
  have hcoef : (4 : ℝ) * (B : ℝ) ≤ 5 * ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast hcoefNat
  have hcoefq := mul_le_mul_of_nonneg_right hcoef p.2.1
  have hexponent : 2 * (B : ℝ) * q ≤ (k : ℝ) / 4 := by
    dsimp [q] at hcoefq ⊢
    nlinarith [hrel]
  have hbasePow : ((1 : ℝ) / 40) ^ k ≤
      ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k :=
    pow_le_pow_left₀ (by norm_num) hbase k
  have hexp : Real.exp (-((k : ℝ) / 4)) ≤
      Real.exp (-(2 * (B : ℝ) * q)) := by
    apply Real.exp_le_exp.mpr
    exact neg_le_neg hexponent
  have hlower : Real.exp (-((k : ℝ) * (Real.log 40 + 1 / 4))) ≤
      ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
        Real.exp (-(2 * (B : ℝ) * q)) := by
    have hpowid : ((1 : ℝ) / 40) ^ k =
        Real.exp (-((k : ℝ) * Real.log 40)) := by
      calc
        ((1 : ℝ) / 40) ^ k =
            (Real.exp (Real.log ((1 : ℝ) / 40))) ^ k := by
              rw [Real.exp_log (by norm_num)]
        _ = Real.exp ((k : ℝ) * Real.log ((1 : ℝ) / 40)) :=
          (Real.exp_nat_mul _ k).symm
        _ = Real.exp (-((k : ℝ) * Real.log 40)) := by
          rw [show (1 : ℝ) / 40 = (40 : ℝ)⁻¹ by ring, Real.log_inv]
          ring_nf
    calc
      Real.exp (-((k : ℝ) * (Real.log 40 + 1 / 4))) =
          ((1 : ℝ) / 40) ^ k * Real.exp (-((k : ℝ) / 4)) := by
        rw [hpowid, ← Real.exp_add]
        congr 1
        ring
      _ ≤ ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
          Real.exp (-(2 * (B : ℝ) * q)) :=
        mul_le_mul hbasePow hexp (Real.exp_nonneg _)
          (pow_nonneg ((by norm_num : (0 : ℝ) ≤ 1 / 40).trans hbase) k)
  change Real.log 20 ≤ (m : ℝ) *
    (((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
      Real.exp (-(2 * (B : ℝ) * q)))
  simpa [m] using hlog.trans (mul_le_mul_of_nonneg_left hlower (by positivity))

/-- An integer sequence that is little-oh of `log n` is eventually at most
one quarter of `n`. -/
lemma eventually_four_mul_le_of_log_ratio_tendsto_zero
    (k : ℕ → ℕ)
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    ∀ᶠ n in Filter.atTop, 4 * k n ≤ n := by
  have hlogdiv : Filter.Tendsto
      (fun n : ℕ => Real.log (n : ℝ) / (n : ℝ)) Filter.atTop (nhds 0) := by
    have h := Real.isLittleO_log_id_atTop.comp_tendsto
      (tendsto_natCast_atTop_atTop : Filter.Tendsto
        (fun n : ℕ => (n : ℝ)) Filter.atTop Filter.atTop)
    simpa [Function.comp_def] using h.tendsto_div_nhds_zero
  have hprod := hsmall.mul hlogdiv
  have hkn : Filter.Tendsto
      (fun n : ℕ => (k n : ℝ) / (n : ℝ)) Filter.atTop (nhds 0) := by
    have heq : (fun n : ℕ =>
        (k n : ℝ) / Real.log (n : ℝ) * (Real.log (n : ℝ) / (n : ℝ))) =ᶠ[Filter.atTop]
        (fun n : ℕ => (k n : ℝ) / (n : ℝ)) := by
      filter_upwards [Filter.eventually_atTop.2 ⟨2, fun n hn => hn⟩] with n hn
      have hn0 : (n : ℝ) ≠ 0 := by positivity
      have hlog0 : Real.log (n : ℝ) ≠ 0 := ne_of_gt <|
        Real.log_pos (by exact_mod_cast (show 1 < n by omega))
      field_simp
    simpa using hprod.congr' heq
  rcases (Metric.tendsto_atTop.mp hkn) ((1 : ℝ) / 5) (by norm_num) with ⟨N, hN⟩
  refine Filter.eventually_atTop.2 ⟨max N 2, ?_⟩
  intro n hn
  have hnN : N ≤ n := (le_max_left N 2).trans hn
  have hn2 : 2 ≤ n := (le_max_right N 2).trans hn
  have hnpos : 0 < (n : ℝ) := by positivity
  have hratio0 : 0 ≤ (k n : ℝ) / (n : ℝ) := by positivity
  have hdist := hN n hnN
  rw [Real.dist_eq, sub_zero, abs_of_nonneg hratio0, div_lt_iff₀ hnpos] at hdist
  have hcast : (4 : ℝ) * (k n : ℝ) ≤ (n : ℝ) := by nlinarith
  exact_mod_cast hcast

/-- Composing `k/log n → 0` with the standard `log n = o(n¹ᐟ²)` estimate
gives the square-root-scale estimate needed for the sparse center set. -/
lemma tendsto_k_div_exp_half_of_log_ratio_tendsto_zero
    (k : ℕ → ℕ)
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    Filter.Tendsto
      (fun n => (k n : ℝ) / Real.exp (Real.log (n : ℝ) / 2))
      Filter.atTop (nhds 0) := by
  have hlogdiv : Filter.Tendsto
      (fun n : ℕ => Real.log (n : ℝ) / (n : ℝ) ^ (1 / 2 : ℝ))
      Filter.atTop (nhds 0) := by
    have h := (isLittleO_log_rpow_atTop
      (r := (1 / 2 : ℝ)) (by norm_num)).comp_tendsto
        (tendsto_natCast_atTop_atTop : Filter.Tendsto
          (fun n : ℕ => (n : ℝ)) Filter.atTop Filter.atTop)
    simpa [Function.comp_def] using h.tendsto_div_nhds_zero
  have hprod := hsmall.mul hlogdiv
  have heq : (fun n : ℕ =>
      (k n : ℝ) / Real.log (n : ℝ) *
        (Real.log (n : ℝ) / (n : ℝ) ^ (1 / 2 : ℝ))) =ᶠ[Filter.atTop]
      (fun n : ℕ => (k n : ℝ) /
        Real.exp (Real.log (n : ℝ) / 2)) := by
    filter_upwards [Filter.eventually_atTop.2 ⟨2, fun n hn => hn⟩] with n hn
    have hnpos : (0 : ℝ) < (n : ℝ) := by positivity
    have hlog0 : Real.log (n : ℝ) ≠ 0 := ne_of_gt <|
      Real.log_pos (by exact_mod_cast (show 1 < n by omega))
    have hrpow : (n : ℝ) ^ (1 / 2 : ℝ) =
        Real.exp (Real.log (n : ℝ) / 2) := by
      rw [Real.rpow_def_of_pos hnpos]
      congr 1
      ring
    rw [← hrpow]
    have hrpow0 : (n : ℝ) ^ (1 / 2 : ℝ) ≠ 0 :=
      ne_of_gt (Real.rpow_pos_of_pos hnpos _)
    field_simp
  simpa only [zero_mul] using hprod.congr' heq

/-- For the quarter-power center set, the union-bound probability of an
internal center edge is eventually at most `0.05`. -/
lemma eventually_exact_center_internal_mass_le_of_degree_relation
    (p : ℕ → Set.Icc (0 : ℝ) 1) (k : ℕ → ℕ)
    (hrel : ∀ n, (k n : ℝ) =
      10 * ((n - 1 : ℕ) : ℝ) * (p n : ℝ))
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    ∀ᶠ n in Filter.atTop,
      (graphDegreeExactTestCenterCount n : ℝ) ^ 2 * (p n : ℝ) ≤
        (1 : ℝ) / 20 := by
  have hsqrt := tendsto_k_div_exp_half_of_log_ratio_tendsto_zero k hsmall
  rcases (Metric.tendsto_atTop.mp hsqrt) ((1 : ℝ) / 4) (by norm_num) with ⟨N, hN⟩
  refine Filter.eventually_atTop.2 ⟨max N 2, ?_⟩
  intro n hn
  have hnN : N ≤ n := (le_max_left N 2).trans hn
  have hn2 : 2 ≤ n := (le_max_right N 2).trans hn
  have hnpos : (0 : ℝ) < (n : ℝ) := by positivity
  let s : ℝ := Real.exp (Real.log (n : ℝ) / 2)
  let x : ℝ := Real.exp (Real.log (n : ℝ) / 4)
  have hspos : 0 < s := by dsimp [s]; positivity
  have hratio0 : 0 ≤ (k n : ℝ) / s := by positivity
  have hdist := hN n hnN
  change dist ((k n : ℝ) / s) 0 < (1 : ℝ) / 4 at hdist
  rw [Real.dist_eq, sub_zero, abs_of_nonneg hratio0,
    div_lt_iff₀ hspos] at hdist
  have hsquare : s ^ 2 = (n : ℝ) := by
    dsimp [s]
    rw [pow_two, ← Real.exp_add]
    have hexponent : Real.log (n : ℝ) / 2 + Real.log (n : ℝ) / 2 =
        Real.log (n : ℝ) := by ring
    rw [hexponent, Real.exp_log hnpos]
  have hxSquare : x ^ 2 = s := by
    dsimp [x, s]
    rw [pow_two, ← Real.exp_add]
    congr 1
    ring
  have hcountFloor : graphDegreeExactTestCenterCount n ≤ ⌊x⌋₊ := by
    exact min_le_right _ _
  have hfloor : (⌊x⌋₊ : ℝ) ≤ x := Nat.floor_le (by positivity)
  have hcount : (graphDegreeExactTestCenterCount n : ℝ) ≤ x := by
    have hcountCast : (graphDegreeExactTestCenterCount n : ℝ) ≤ (⌊x⌋₊ : ℝ) := by
      exact_mod_cast hcountFloor
    exact hcountCast.trans hfloor
  have hcountSq : (graphDegreeExactTestCenterCount n : ℝ) ^ 2 ≤ s := by
    rw [← hxSquare]
    exact pow_le_pow_left₀ (by positivity) hcount 2
  have hsk : s * (k n : ℝ) ≤ (n : ℝ) / 4 := by
    have hmul := mul_le_mul_of_nonneg_left hdist.le hspos.le
    nlinarith [hsquare]
  have hnsubpos : (0 : ℝ) < ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast (show 0 < n - 1 by omega)
  have hden : 0 < 10 * ((n - 1 : ℕ) : ℝ) := by positivity
  have hpform : (p n : ℝ) =
      (k n : ℝ) / (10 * ((n - 1 : ℕ) : ℝ)) := by
    rw [eq_div_iff (ne_of_gt hden)]
    nlinarith [hrel n]
  have hsprob : s * (p n : ℝ) ≤ (1 : ℝ) / 20 := by
    rw [hpform, show s * ((k n : ℝ) /
      (10 * ((n - 1 : ℕ) : ℝ))) =
        (s * (k n : ℝ)) / (10 * ((n - 1 : ℕ) : ℝ)) by ring,
      div_le_iff₀ hden]
    have hnCast : (n : ℝ) ≤ 2 * ((n - 1 : ℕ) : ℝ) := by
      exact_mod_cast (show n ≤ 2 * (n - 1) by omega)
    nlinarith
  exact (mul_le_mul_of_nonneg_right hcountSq (p n).2.1).trans hsprob

/-- An explicit exponential lower bound for a restricted binomial point mass.
This is the finite analytic estimate used by the sparse-graph specialization. -/
lemma graphRestrictedBinomialLaw_real_singleton_ge_ratio_pow_mul_exp
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) (k : ℕ) (hk : k ≤ S.card)
    (hp : (p : ℝ) ≤ 1 / 2) :
    ((((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * (S.card : ℝ) * (p : ℝ))) ≤
      (graphRestrictedBinomialLaw S p).real {k} := by
  let x : ℝ := unitInterval.toNNReal p
  have hx : x = (p : ℝ) := rfl
  have hx0 : 0 ≤ x := by positivity
  have hpow : Real.exp (-(2 * ((S.card - k : ℕ) : ℝ) * x)) ≤
      (1 - x) ^ (S.card - k) := by
    exact exp_neg_two_mul_le_one_sub_pow hx0 (by simpa [hx] using hp) _
  have hexp : Real.exp (-(2 * (S.card : ℝ) * (p : ℝ))) ≤
      Real.exp (-(2 * ((S.card - k : ℕ) : ℝ) * x)) := by
    apply Real.exp_le_exp.mpr
    rw [hx]
    have hcast : ((S.card - k : ℕ) : ℝ) ≤ (S.card : ℝ) := by
      exact_mod_cast Nat.sub_le S.card k
    nlinarith [p.1]
  calc
    ((((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * (S.card : ℝ) * (p : ℝ))) ≤
        ((((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
            (1 - (unitInterval.toNNReal p : ℝ)) ^ (S.card - k) := by
      apply mul_le_mul_of_nonneg_left (hexp.trans (by simpa [x] using hpow))
      positivity
    _ ≤ (graphRestrictedBinomialLaw S p).real {k} :=
      graphRestrictedBinomialLaw_real_singleton_ge_ratio_pow S p k hk

lemma graphRestrictedDegree_map_apply
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {v : V} {S : Finset V} (hvS : v ∉ S) (k : ℕ) :
    (SimpleGraph.binomialRandom V p).map (graphRestrictedDegree v S) {k} =
      graphRestrictedBinomialLaw S p {k} := by
  rw [Measure.map_apply (measurable_graphRestrictedDegree v S)
    (measurableSet_singleton k)]
  rw [← graphStarExactCardEvent_eq_preimage_graphRestrictedDegree k]
  rw [binomialRandom_graphStarExactCardEvent_probability (p := p) hvS k]
  rw [graphRestrictedBinomialLaw,
    PMF.toMeasure_apply_singleton _ k (measurableSet_singleton k)]
  unfold LimitTheorems.binomialNatPMF
  rw [PMF.map_apply, tsum_fintype]
  by_cases hk : k < S.card + 1
  · rw [Finset.sum_eq_single (⟨k, hk⟩ : Fin (S.card + 1))]
    · have hq : 1 - unitInterval.toNNReal p =
          unitInterval.toNNReal (unitInterval.symm p) := by
        exact (eq_tsub_of_add_eq (unitInterval.toNNReal_symm_add_toNNReal p)).symm
      have hqE : (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) =
          1 - (unitInterval.toNNReal p : ℝ≥0∞) := by
        calc
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) =
              (1 - unitInterval.toNNReal p : ℝ≥0∞) :=
            congrArg (fun x : ℝ≥0 => (x : ℝ≥0∞)) hq.symm
          _ = 1 - (unitInterval.toNNReal p : ℝ≥0∞) := by rfl
      simp [PMF.binomial_apply, hqE]
      ring
    · intro b _hb hbk
      by_cases h : k = (b : ℕ)
      · exfalso
        apply hbk
        apply Fin.ext
        exact h.symm
      · simp [h]
    · simp
  · have hlt : S.card < k := by omega
    have hne : ∀ b : Fin (S.card + 1), k ≠ (b : ℕ) := by
      intro b h
      omega
    simp [Nat.choose_eq_zero_of_lt hlt, hne]

theorem graphRestrictedDegree_hasLaw
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {v : V} {S : Finset V} (hvS : v ∉ S) :
    HasLaw (graphRestrictedDegree v S) (graphRestrictedBinomialLaw S p)
      (SimpleGraph.binomialRandom V p) := by
  refine {
    aemeasurable := (measurable_graphRestrictedDegree v S).aemeasurable
    map_eq := ?_ }
  apply Measure.ext_of_singleton
  intro k
  exact graphRestrictedDegree_map_apply p hvS k

/-- The exact decoupling package used in sparse random-graph lower bounds:
centers in `A`, counted only against the disjoint set `B`, have mutually
independent `Binomial(|B|, p)` restricted degrees. -/
theorem graphRestrictedDegrees_independent_binomial
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) :
    iIndepFun (fun a : ↑A ↦ graphRestrictedDegree a.1 B)
        (SimpleGraph.binomialRandom V p) ∧
      ∀ a : ↑A,
        HasLaw (graphRestrictedDegree a.1 B) (graphRestrictedBinomialLaw B p)
          (SimpleGraph.binomialRandom V p) := by
  refine ⟨iIndepFun_graphRestrictedDegree_of_disjoint p hAB, ?_⟩
  intro a
  exact graphRestrictedDegree_hasLaw p
    (Finset.disjoint_left.mp hAB a.2)

/-- Exact maximum-tail probability for the decoupled restricted degrees.  It
turns the graph event into the complement of a power of one binomial lower
tail. -/
theorem binomialRandom_exists_restrictedDegree_ge_probability
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} =
      1 - (graphRestrictedBinomialLaw B p).real {j | j < k} ^ A.card := by
  let P : Measure (SimpleGraph V) := SimpleGraph.binomialRandom V p
  change P.real {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} = _
  let Low : Set (SimpleGraph V) :=
    {G | ∀ a : ↑A, graphRestrictedDegree a.1 B G < k}
  have hpack := graphRestrictedDegrees_independent_binomial p hAB
  have hLowEq : Low =
      ⋂ a : ↑A, graphRestrictedDegree a.1 B ⁻¹' {j | j < k} := by
    ext G
    simp [Low]
  have hLowMeas : MeasurableSet Low := by
    rw [hLowEq]
    exact MeasurableSet.iInter fun a ↦
      (measurableSet_Iio.preimage (measurable_graphRestrictedDegree a.1 B))
  have hprod :
      P (⋂ a : ↑A, graphRestrictedDegree a.1 B ⁻¹' {j | j < k}) =
        ∏ a : ↑A, P (graphRestrictedDegree a.1 B ⁻¹' {j | j < k}) := by
    simpa [P] using hpack.1.measure_inter_preimage_eq_mul
      Finset.univ (sets := fun _ : ↑A ↦ {j : ℕ | j < k})
        (fun _ _ ↦ measurableSet_Iio)
  have hsingle (a : ↑A) :
      P.real (graphRestrictedDegree a.1 B ⁻¹' {j | j < k}) =
        (graphRestrictedBinomialLaw B p).real {j | j < k} := by
    dsimp [P]
    rw [Measure.real_def, Measure.real_def]
    change ((SimpleGraph.binomialRandom V p)
      (graphRestrictedDegree a.1 B ⁻¹' Set.Iio k)).toReal =
        ((graphRestrictedBinomialLaw B p) (Set.Iio k)).toReal
    have hmap := Measure.map_apply_of_aemeasurable
      (hpack.2 a).aemeasurable (measurableSet_Iio : MeasurableSet {j : ℕ | j < k})
    rw [← hmap, (hpack.2 a).map_eq]
  have hLowReal :
      P.real Low =
        (graphRestrictedBinomialLaw B p).real {j | j < k} ^ A.card := by
    rw [Measure.real_def, hLowEq, hprod, ENNReal.toReal_prod]
    simp_rw [← Measure.real_def, hsingle]
    simp
  have hHighEq :
      {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} = Lowᶜ := by
    ext G
    simp [Low, not_lt]
  rw [hHighEq, measureReal_compl hLowMeas, hLowReal]
  simp

/-- Exact point-mass occurrence probability for the decoupled restricted
degrees.  This is the equality-event counterpart of
`binomialRandom_exists_restrictedDegree_ge_probability`. -/
theorem binomialRandom_exists_restrictedDegree_eq_probability
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k} =
      1 - (1 - (graphRestrictedBinomialLaw B p).real {k}) ^ A.card := by
  let P : Measure (SimpleGraph V) := SimpleGraph.binomialRandom V p
  let ν : Measure ℕ := graphRestrictedBinomialLaw B p
  haveI : IsProbabilityMeasure ν := by
    dsimp [ν, graphRestrictedBinomialLaw]
    infer_instance
  change P.real {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k} = _
  let Avoid : Set (SimpleGraph V) :=
    {G | ∀ a : ↑A, graphRestrictedDegree a.1 B G ≠ k}
  have hpack := graphRestrictedDegrees_independent_binomial p hAB
  have hAvoidEq : Avoid =
      ⋂ a : ↑A, graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ := by
    ext G
    simp [Avoid]
  have hAvoidMeas : MeasurableSet Avoid := by
    rw [hAvoidEq]
    exact MeasurableSet.iInter fun a ↦
      (measurableSet_singleton k).compl.preimage
        (measurable_graphRestrictedDegree a.1 B)
  have hprod :
      P (⋂ a : ↑A, graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) =
        ∏ a : ↑A, P (graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) := by
    simpa [P] using hpack.1.measure_inter_preimage_eq_mul
      Finset.univ (sets := fun _ : ↑A ↦ ({k} : Set ℕ)ᶜ)
        (fun _ _ ↦ (measurableSet_singleton k).compl)
  have hsingle (a : ↑A) :
      P.real (graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) =
        1 - ν.real {k} := by
    have hmap := Measure.map_apply_of_aemeasurable
      (hpack.2 a).aemeasurable ((measurableSet_singleton k).compl)
    have heq :
        P (graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) =
          ν (({k} : Set ℕ)ᶜ) := by
      rw [← hmap, (hpack.2 a).map_eq]
    have hrealeq :
        P.real (graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) =
          ν.real (({k} : Set ℕ)ᶜ) := by
      simpa only [Measure.real_def] using congrArg ENNReal.toReal heq
    rw [hrealeq, measureReal_compl (measurableSet_singleton k)]
    simp
  have hAvoidReal :
      P.real Avoid = (1 - ν.real {k}) ^ A.card := by
    rw [Measure.real_def, hAvoidEq, hprod, ENNReal.toReal_prod]
    simp_rw [← Measure.real_def, hsingle]
    simp
  have hHitEq :
      {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k} = Avoidᶜ := by
    ext G
    simp [Avoid]
  rw [hHitEq, measureReal_compl hAvoidMeas, hAvoidReal]
  simp [ν]

lemma one_sub_pow_le_exp_neg_nat_mul {r : ℝ} (hr1 : r ≤ 1)
    (m : ℕ) :
    (1 - r) ^ m ≤ Real.exp (-((m : ℝ) * r)) := by
  calc
    (1 - r) ^ m ≤ Real.exp (-r) ^ m :=
      pow_le_pow_left₀ (sub_nonneg.mpr hr1) (Real.one_sub_le_exp_neg r) m
    _ = Real.exp ((m : ℝ) * (-r)) := (Real.exp_nat_mul (-r) m).symm
    _ = Real.exp (-((m : ℝ) * r)) := by ring_nf

/-- If the expected number of exact restricted-degree hits dominates
`log 20`, then an exact hit occurs with probability at least `0.95`. -/
theorem binomialRandom_exists_restrictedDegree_eq_probability_ge_nineteen_twentieths
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ)
    (hmass : Real.log 20 ≤ (A.card : ℝ) *
      (graphRestrictedBinomialLaw B p).real {k}) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k} ≥
      (19 : ℝ) / 20 := by
  let ν : Measure ℕ := graphRestrictedBinomialLaw B p
  haveI : IsProbabilityMeasure ν := by
    dsimp [ν, graphRestrictedBinomialLaw]
    infer_instance
  let r : ℝ := ν.real {k}
  have hr1 : r ≤ 1 := by
    simpa [r] using measureReal_le_one (μ := ν) (s := ({k} : Set ℕ))
  have hpow : (1 - r) ^ A.card ≤ (1 : ℝ) / 20 := by
    calc
      (1 - r) ^ A.card ≤ Real.exp (-((A.card : ℝ) * r)) :=
        one_sub_pow_le_exp_neg_nat_mul hr1 A.card
      _ ≤ Real.exp (-Real.log 20) := by
        apply Real.exp_le_exp.mpr
        exact neg_le_neg (by simpa [r, ν] using hmass)
      _ = (1 : ℝ) / 20 := by
        rw [Real.exp_neg, Real.exp_log (by norm_num : (0 : ℝ) < 20)]
        norm_num
  rw [binomialRandom_exists_restrictedDegree_eq_probability p hAB k]
  change (19 : ℝ) / 20 ≤ 1 - (1 - r) ^ A.card
  linarith

/-- Exact restricted-degree occurrence transfers to exact full degree when
internal edges among the test centers have probability at most `0.05`. -/
theorem binomialRandom_exists_degree_eq_probability_ge_nine_tenths
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    (A : Finset V) (k : ℕ)
    (hmass : Real.log 20 ≤ (A.card : ℝ) *
      (graphRestrictedBinomialLaw (Finset.univ \ A) p).real {k})
    (hinternal : (A.card : ℝ) ^ 2 * (p : ℝ) ≤ (1 : ℝ) / 20) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ v : V, graphDegreeSum v G = k} ≥ (9 : ℝ) / 10 := by
  classical
  let P : Measure (SimpleGraph V) := SimpleGraph.binomialRandom V p
  let B : Finset V := Finset.univ \ A
  let Hit : Set (SimpleGraph V) :=
    {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k}
  let Bad : Set (SimpleGraph V) :=
    {G | ∃ a : ↑A, ∃ b : ↑A, G.Adj a.1 b.1}
  let Full : Set (SimpleGraph V) := {G | ∃ v : V, graphDegreeSum v G = k}
  have hAB : Disjoint A B := by
    rw [Finset.disjoint_left]
    simp [B]
  have hHit : (19 : ℝ) / 20 ≤ P.real Hit := by
    simpa [P, B, Hit] using
      binomialRandom_exists_restrictedDegree_eq_probability_ge_nineteen_twentieths
        p hAB k hmass
  have hBad : P.real Bad ≤ (1 : ℝ) / 20 := by
    have hBad' : P.real Bad ≤ (A.card : ℝ) ^ 2 * (p : ℝ) := by
      simpa [P, Bad] using
        (binomialRandom_exists_internalAdj_probability_le p A)
    exact hBad'.trans hinternal
  have hsubset : Hit \ Bad ⊆ Full := by
    intro G hG
    rcases hG.1 with ⟨a, ha⟩
    refine ⟨a.1, ?_⟩
    have hno : ∀ w ∈ A, ¬ G.Adj a.1 w := by
      intro w hw hadj
      exact hG.2 ⟨a, ⟨w, hw⟩, hadj⟩
    have heq := graphRestrictedDegree_compl_eq_graphDegreeSum_of_no_internal
      G (A := A) (v := a.1) hno
    exact heq.symm.trans ha
  have hdiff : P.real Hit - P.real Bad ≤ P.real (Hit \ Bad) :=
    le_measureReal_diff
  have hmono : P.real (Hit \ Bad) ≤ P.real Full :=
    measureReal_mono hsubset
  change (9 : ℝ) / 10 ≤ P.real Full
  linarith

/-- Fully explicit exact-degree criterion, using the reusable lower bound for
one restricted binomial point mass. -/
theorem binomialRandom_exists_degree_eq_probability_ge_nine_tenths_of_ratio_pow
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    (A : Finset V) (k : ℕ) (hk : k ≤ (Finset.univ \ A).card)
    (hp : (p : ℝ) ≤ 1 / 2)
    (hmass : Real.log 20 ≤ (A.card : ℝ) *
      ((((((Finset.univ \ A).card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * ((Finset.univ \ A).card : ℝ) * (p : ℝ)))))
    (hinternal : (A.card : ℝ) ^ 2 * (p : ℝ) ≤ (1 : ℝ) / 20) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ v : V, graphDegreeSum v G = k} ≥ (9 : ℝ) / 10 := by
  apply binomialRandom_exists_degree_eq_probability_ge_nine_tenths p A k
  · exact hmass.trans (mul_le_mul_of_nonneg_left
      (graphRestrictedBinomialLaw_real_singleton_ge_ratio_pow_mul_exp
        (Finset.univ \ A) p k hk hp) (by positivity))
  · exact hinternal

/-- A finite point-mass criterion ensuring that one of the independent
restricted degrees reaches `k` with probability at least `0.9`. -/
theorem binomialRandom_exists_restrictedDegree_ge_probability_ge_nine_tenths
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ)
    (hmass : Real.log 10 ≤ (A.card : ℝ) *
      (graphRestrictedBinomialLaw B p).real {k}) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} ≥
      (9 : ℝ) / 10 := by
  let ν : Measure ℕ := graphRestrictedBinomialLaw B p
  let q : ℝ := ν.real {j | j < k}
  let r : ℝ := ν.real {k}
  haveI : IsProbabilityMeasure ν := by
    dsimp [ν, graphRestrictedBinomialLaw]
    infer_instance
  have hdisj : Disjoint ({j : ℕ | j < k} : Set ℕ) {k} := by
    rw [Set.disjoint_left]
    intro j hj hk
    simp only [Set.mem_setOf_eq] at hj
    simp only [Set.mem_singleton_iff] at hk
    omega
  have hadd :
      ν.real (({j : ℕ | j < k} : Set ℕ) ∪ {k}) = q + r := by
    simpa [q, r] using
      (measureReal_union (μ := ν) hdisj (measurableSet_singleton k)
        (measure_ne_top _ _) (measure_ne_top _ _))
  have hunion : ν.real (({j : ℕ | j < k} : Set ℕ) ∪ {k}) ≤ 1 := by
    calc
      ν.real (({j : ℕ | j < k} : Set ℕ) ∪ {k}) ≤ ν.real Set.univ :=
        measureReal_mono (by intro j hj; trivial)
      _ = 1 := by simp
  have hq_le : q ≤ 1 - r := by linarith [hadd.symm.trans_le hunion]
  have hq0 : 0 ≤ q := measureReal_nonneg
  have hr1 : r ≤ 1 := by
    have := measureReal_le_one (μ := ν) (s := ({k} : Set ℕ))
    simpa [r] using this
  have hpow : q ^ A.card ≤ (1 : ℝ) / 10 := by
    calc
      q ^ A.card ≤ (1 - r) ^ A.card :=
        pow_le_pow_left₀ hq0 hq_le A.card
      _ ≤ Real.exp (-((A.card : ℝ) * r)) :=
        one_sub_pow_le_exp_neg_nat_mul hr1 A.card
      _ ≤ Real.exp (-Real.log 10) := by
        apply Real.exp_le_exp.mpr
        exact neg_le_neg (by simpa [r, ν] using hmass)
      _ = (1 : ℝ) / 10 := by
        rw [Real.exp_neg, Real.exp_log (by norm_num : (0 : ℝ) < 10)]
        norm_num
  rw [binomialRandom_exists_restrictedDegree_ge_probability p hAB k]
  change (9 : ℝ) / 10 ≤ 1 - q ^ A.card
  linarith

/-- A fully explicit finite criterion for the decoupled maximum to reach `k`
with probability at least `0.9`. -/
theorem binomialRandom_exists_restrictedDegree_ge_probability_ge_nine_tenths_of_ratio_pow
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ) (hk : k ≤ B.card)
    (hp : (p : ℝ) ≤ 1 / 2)
    (hmass : Real.log 10 ≤ (A.card : ℝ) *
      (((((B.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * (B.card : ℝ) * (p : ℝ))))) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} ≥
      (9 : ℝ) / 10 := by
  apply binomialRandom_exists_restrictedDegree_ge_probability_ge_nine_tenths
    p hAB k
  exact hmass.trans (mul_le_mul_of_nonneg_left
    (graphRestrictedBinomialLaw_real_singleton_ge_ratio_pow_mul_exp B p k hk hp)
    (by positivity))

/-- Transfer the explicit restricted-degree lower bound to the full maximum
degree of the graph. -/
theorem binomialRandom_exists_degree_ge_probability_ge_nine_tenths_of_ratio_pow
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ) (hk : k ≤ B.card)
    (hp : (p : ℝ) ≤ 1 / 2)
    (hmass : Real.log 10 ≤ (A.card : ℝ) *
      (((((B.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * (B.card : ℝ) * (p : ℝ))))) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ v : V, k ≤ graphDegreeSum v G} ≥
      (9 : ℝ) / 10 := by
  have hrestricted :=
    binomialRandom_exists_restrictedDegree_ge_probability_ge_nine_tenths_of_ratio_pow
      p hAB k hk hp hmass
  have hmono : (SimpleGraph.binomialRandom V p).real
      {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} ≤
      (SimpleGraph.binomialRandom V p).real
        {G | ∃ v : V, k ≤ graphDegreeSum v G} := by
    apply measureReal_mono
    intro G hG
    rcases hG with ⟨a, ha⟩
    exact ⟨a.1, ha.trans (graphRestrictedDegree_le_graphDegreeSum G a.1 B)⟩
    exact measure_ne_top _ _
  exact hrestricted.trans hmono

/-- The explicit finite lower bound specialized to the canonical balanced
split of `Fin n`. -/
theorem binomialRandom_exists_degree_ge_probability_ge_nine_tenths_balanced
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (k : ℕ)
    (hk : k ≤ n - n / 2) (hp : (p : ℝ) ≤ 1 / 2)
    (hmass : Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
      ((((((n - n / 2 : ℕ) + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * ((n - n / 2 : ℕ) : ℝ) * (p : ℝ))))) :
    (SimpleGraph.binomialRandom (Fin n) p).real
        {G | ∃ v : Fin n, k ≤ graphDegreeSum v G} ≥
      (9 : ℝ) / 10 := by
  apply binomialRandom_exists_degree_ge_probability_ge_nine_tenths_of_ratio_pow
    p (graphDegreeTestCenters_disjoint_graphDegreeTestNeighbors n) k
  · simpa using hk
  · exact hp
  · simpa using hmass

/-- In the sparse regime, if the integer threshold is ten times the expected
degree and is little-oh of `log n`, then a vertex reaches that threshold with
probability at least `0.9` for all sufficiently large `n`. -/
theorem erdosRenyiSparseExistsDegreeTenExpectedEventually
    (p : ℕ → Set.Icc (0 : ℝ) 1) (k : ℕ → ℕ)
    (hrel : ∀ n, (k n : ℝ) =
      10 * ((n - 1 : ℕ) : ℝ) * (p n : ℝ))
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    ∀ᶠ n in Filter.atTop,
      (SimpleGraph.binomialRandom (Fin n) (p n)).real
        {G | ∃ v : Fin n, k n ≤ graphDegreeSum v G} ≥
      (9 : ℝ) / 10 := by
  filter_upwards
    [eventually_log_ten_le_half_card_mul_exp_of_log_ratio_tendsto_zero k hsmall,
      eventually_four_mul_le_of_log_ratio_tendsto_zero k hsmall,
      Filter.eventually_atTop.2 ⟨400, fun n hn => hn⟩] with n hlog h4 hn
  by_cases hk0 : k n = 0
  · have hevent : {G : SimpleGraph (Fin n) |
        ∃ v : Fin n, k n ≤ graphDegreeSum v G} = Set.univ := by
      ext G
      simp only [Set.mem_setOf_eq, Set.mem_univ, iff_true]
      exact ⟨⟨0, by omega⟩, by simp [hk0]⟩
    rw [hevent]
    simp
    norm_num
  · have harith := balanced_ratio_mass_bound_of_degree_relation n (k n) (p n)
      (by omega) (Nat.pos_of_ne_zero hk0) h4 (hrel n) hlog
    exact binomialRandom_exists_degree_ge_probability_ge_nine_tenths_balanced
      n (p n) (k n) harith.1 harith.2.1 harith.2.2

/-- Source-faithful exact-degree version of the sparse random-graph result:
when the integer `k` is ten times the expected degree and `k = o(log n)`, a
vertex of degree exactly `k` exists with probability at least `0.9`. -/
theorem erdosRenyiSparseExistsDegreeExactlyTenExpectedEventually
    (p : ℕ → Set.Icc (0 : ℝ) 1) (k : ℕ → ℕ)
    (hrel : ∀ n, (k n : ℝ) =
      10 * ((n - 1 : ℕ) : ℝ) * (p n : ℝ))
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    ∀ᶠ n in Filter.atTop,
      (SimpleGraph.binomialRandom (Fin n) (p n)).real
        {G | ∃ v : Fin n, graphDegreeSum v G = k n} ≥
      (9 : ℝ) / 10 := by
  filter_upwards
    [eventually_log_twenty_le_exact_center_card_mul_exp_of_log_ratio_tendsto_zero
      k hsmall,
      eventually_four_mul_le_of_log_ratio_tendsto_zero k hsmall,
      eventually_exact_center_internal_mass_le_of_degree_relation p k hrel hsmall,
      Filter.eventually_atTop.2 ⟨16, fun n hn => hn⟩] with n hlog h4 hinternal hn
  let A : Finset (Fin n) := graphDegreeExactTestCenters n
  have hinner : (A.card : ℝ) ^ 2 * (p n : ℝ) ≤ (1 : ℝ) / 20 := by
    simpa [A] using hinternal
  have hcardB : (Finset.univ \ A).card =
      n - graphDegreeExactTestCenterCount n := by
    dsimp [A]
    rw [Finset.card_sdiff_of_subset (Finset.subset_univ _)]
    simp
  by_cases hk0 : k n = 0
  · have hp0 : (p n : ℝ) = 0 := by
      have hnsubpos : (0 : ℝ) < ((n - 1 : ℕ) : ℝ) := by
        exact_mod_cast (show 0 < n - 1 by omega)
      have hrel_n := hrel n
      rw [hk0] at hrel_n
      norm_num at hrel_n
      rcases hrel_n with hzero | hpzero
      · omega
      · simpa using congrArg Subtype.val hpzero
    have hmass : Real.log 20 ≤ (A.card : ℝ) *
        ((((((Finset.univ \ A).card + 1 - k n : ℕ) : ℝ) / (k n : ℝ)) *
            (unitInterval.toNNReal (p n) : ℝ)) ^ k n *
          Real.exp (-(2 * ((Finset.univ \ A).card : ℝ) * (p n : ℝ)))) := by
      simpa [A, hk0, hp0] using hlog
    exact binomialRandom_exists_degree_eq_probability_ge_nine_tenths_of_ratio_pow
      (p n) A (k n) (by simp [hk0]) (by rw [hp0]; norm_num) hmass hinner
  · have harith := exact_center_ratio_mass_bound_of_degree_relation
      n (k n) (p n) hn (Nat.pos_of_ne_zero hk0) h4 (hrel n) hlog
    have hk : k n ≤ (Finset.univ \ A).card := by
      rw [hcardB]
      exact harith.1
    have hmass : Real.log 20 ≤ (A.card : ℝ) *
        ((((((Finset.univ \ A).card + 1 - k n : ℕ) : ℝ) / (k n : ℝ)) *
            (unitInterval.toNNReal (p n) : ℝ)) ^ k n *
          Real.exp (-(2 * ((Finset.univ \ A).card : ℝ) * (p n : ℝ)))) := by
      rw [hcardB]
      simpa [A] using harith.2.2
    exact binomialRandom_exists_degree_eq_probability_ge_nine_tenths_of_ratio_pow
      (p n) A (k n) hk harith.2.1 hmass hinner

end NumStability.HDP.Scalar.IndependentSums.Chernoff
```

### `ComputationalMathematics.HDP.Scalar.GaussianMaxima`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/GaussianMaxima.lean`
SHA-256: `fb09455c8d709d199ea7bf7480cdb3de6a2bf003cc6e043b4f354331fe8085a7`

```lean
import ComputationalMathematics.Analysis.Probability.Gaussian.AbsoluteMoment
import ComputationalMathematics.HDP.Scalar.GaussianTails
import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeDecoupling
import Mathlib.Probability.Independence.Basic

/-!
# Finite maxima and independent Gaussian samples

This file provides the reusable finite-maximum and exact product-event
infrastructure needed for lower bounds on maxima of independent Gaussian
variables.  The asymptotic Gaussian estimate is developed separately from
these order- and independence-theoretic foundations.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Scalar.GaussianMaxima

open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.GaussianTails

/-- The pointwise maximum of a nonempty finite family of real functions. -/
def finiteMaximum {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) : Ω → ℝ :=
  Finset.univ.sup' Finset.univ_nonempty X

/-- Every coordinate is bounded by the finite maximum. -/
lemma le_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (i : ι) (ω : Ω) :
    X i ω ≤ finiteMaximum X ω := by
  rw [finiteMaximum, Finset.sup'_apply]
  exact Finset.le_sup' (fun j => X j ω) (Finset.mem_univ i)

/-- A pointwise criterion for bounding a finite maximum from above. -/
lemma finiteMaximum_le
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) (a : ℝ)
    (h : ∀ i, X i ω ≤ a) :
    finiteMaximum X ω ≤ a := by
  rw [finiteMaximum, Finset.sup'_apply]
  exact Finset.sup'_le Finset.univ_nonempty _ (fun i _ => h i)

/-- The maximum of a finite family of measurable real functions is
measurable. -/
lemma measurable_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {X : ι → Ω → ℝ} (hX : ∀ i, Measurable (X i)) :
    Measurable (finiteMaximum X) := by
  unfold finiteMaximum
  exact Finset.measurable_sup' Finset.univ_nonempty (fun i _ => hX i)

/-- The maximum of a finite family of integrable real functions is
integrable. -/
lemma integrable_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hX : ∀ i, Integrable (X i) μ) :
    Integrable (finiteMaximum X) μ := by
  unfold finiteMaximum
  exact Finset.sup'_induction Finset.univ_nonempty X
    (p := fun f : Ω → ℝ => Integrable f μ)
    (fun _ hf _ hg => Integrable.sup hf hg) (fun i _ => hX i)

/-- A finite maximum is bounded above by the sum of the coordinate absolute
values. -/
lemma finiteMaximum_le_sum_abs
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) :
    finiteMaximum X ω ≤ ∑ i, |X i ω| := by
  rw [finiteMaximum, Finset.sup'_apply]
  apply Finset.sup'_le
  intro i hi
  calc
    X i ω ≤ |X i ω| := le_abs_self _
    _ ≤ ∑ j, |X j ω| := Finset.single_le_sum
      (s := Finset.univ) (f := fun j => |X j ω|)
      (fun _ _ => abs_nonneg _) hi

/-- The negative sum of the coordinate absolute values is a lower bound for
the finite maximum. -/
lemma neg_sum_abs_le_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) :
    -(∑ i, |X i ω|) ≤ finiteMaximum X ω := by
  let i : ι := Classical.choice inferInstance
  calc
    -(∑ j, |X j ω|) ≤ -|X i ω| := by
      exact neg_le_neg (Finset.single_le_sum
        (s := Finset.univ) (f := fun j => |X j ω|)
        (fun _ _ => abs_nonneg _) (Finset.mem_univ i))
    _ ≤ X i ω := neg_abs_le _
    _ ≤ finiteMaximum X ω := le_finiteMaximum X i ω

/-- Two-sided absolute-value control for the finite maximum. -/
lemma abs_finiteMaximum_le_sum_abs
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) :
    |finiteMaximum X ω| ≤ ∑ i, |X i ω| := by
  rw [abs_le]
  exact ⟨neg_sum_abs_le_finiteMaximum X ω,
    finiteMaximum_le_sum_abs X ω⟩

/-- A finite maximum lies below a threshold exactly when every coordinate
does. -/
lemma finiteMaximum_lt_iff
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) (t : ℝ) :
    finiteMaximum X ω < t ↔ ∀ i, X i ω < t := by
  simp [finiteMaximum, Finset.sup'_apply, Finset.sup'_lt_iff]

/-- Independence turns the lower-tail event of a finite maximum into the
product of its coordinate lower-tail probabilities. -/
lemma measure_finiteMaximum_lt_eq_prod
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ {ω | finiteMaximum X ω < t} =
      ∏ i, μ {ω | X i ω < t} := by
  have hEvent : {ω | finiteMaximum X ω < t} =
      ⋂ i, {ω | X i ω < t} := by
    ext ω
    simp only [Set.mem_setOf_eq, Set.mem_iInter]
    exact finiteMaximum_lt_iff X ω t
  rw [hEvent]
  apply hIndep.meas_iInter
  intro i
  exact MeasurableSpace.measurableSet_comap.2
    ⟨Set.Iio t, measurableSet_Iio, rfl⟩

/-- Exact lower-tail probability of the maximum of an independent finite
standard-normal family. -/
lemma measure_finiteMaximum_lt_of_standardNormal
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ {ω | finiteMaximum X ω < t} =
      standardNormalLaw (Set.Iio t) ^ Fintype.card ι := by
  rw [measure_finiteMaximum_lt_eq_prod hIndep t]
  have hOne : ∀ i, μ {ω | X i ω < t} = standardNormalLaw (Set.Iio t) := by
    intro i
    rw [← (hLaw i).map_eq,
      Measure.map_apply_of_aemeasurable (hLaw i).aemeasurable measurableSet_Iio]
    rfl
  simp_rw [hOne]
  rw [Finset.prod_const]
  simp

/-- Real-valued form of the exact standard-normal lower-tail product. -/
lemma measureReal_finiteMaximum_lt_of_standardNormal
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ.real {ω | finiteMaximum X ω < t} =
      standardNormalLaw.real (Set.Iio t) ^ Fintype.card ι := by
  have h := congrArg ENNReal.toReal
    (measure_finiteMaximum_lt_of_standardNormal hLaw hIndep t)
  simpa only [Measure.real, ENNReal.toReal_pow] using h

/-- Exact upper-tail probability of the maximum of an independent finite
standard-normal family. -/
lemma measureReal_finiteMaximum_ge_of_standardNormal
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : ι → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ.real {ω | t ≤ finiteMaximum X ω} =
      1 - (1 - standardNormalLaw.real (Set.Ici t)) ^ Fintype.card ι := by
  have hLowMeas : MeasurableSet {ω | finiteMaximum X ω < t} :=
    measurableSet_lt (measurable_finiteMaximum hX) measurable_const
  have hEvent : {ω | t ≤ finiteMaximum X ω} =
      {ω | finiteMaximum X ω < t}ᶜ := by
    ext ω
    simp
  rw [hEvent, measureReal_compl hLowMeas, probReal_univ,
    measureReal_finiteMaximum_lt_of_standardNormal hLaw hIndep t]
  have hTail : standardNormalLaw.real (Set.Iio t) =
      1 - standardNormalLaw.real (Set.Ici t) := by
    rw [← compl_Ici, measureReal_compl measurableSet_Ici, probReal_univ]
  rw [hTail]

/-- A one-threshold lower bound for the expectation of a finite maximum.  The
single-coordinate absolute moment controls every possible negative value of
the maximum. -/
lemma threshold_mul_measureReal_sub_integral_abs_le_integral_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ] {X : ι → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i))
    (hInt : ∀ i, Integrable (X i) μ) (i : ι) (t : ℝ) :
    t * μ.real {ω | t ≤ finiteMaximum X ω} -
        ∫ ω, |X i ω| ∂μ ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  let A : Set Ω := {ω | t ≤ finiteMaximum X ω}
  have hA : MeasurableSet A :=
    measurableSet_le measurable_const (measurable_finiteMaximum hMeas)
  have hLeftInt : Integrable
      (fun ω => A.indicator (fun _ => t) ω - |X i ω|) μ :=
    ((integrable_const t).indicator hA).sub (hInt i).abs
  have hMaxInt : Integrable (finiteMaximum X) μ :=
    integrable_finiteMaximum hInt
  have hPoint : ∀ ω, A.indicator (fun _ => t) ω - |X i ω| ≤
      finiteMaximum X ω := by
    intro ω
    by_cases hω : ω ∈ A
    · rw [Set.indicator_of_mem hω]
      exact (sub_le_self _ (abs_nonneg _)).trans hω
    · simp only [Set.indicator, hω, if_false, zero_sub]
      exact (neg_abs_le (X i ω)).trans (le_finiteMaximum X i ω)
  calc
    t * μ.real {ω | t ≤ finiteMaximum X ω} -
        ∫ ω, |X i ω| ∂μ =
        ∫ ω, A.indicator (fun _ => t) ω - |X i ω| ∂μ := by
      rw [integral_sub ((integrable_const t).indicator hA) (hInt i).abs,
        integral_indicator_const t hA]
      simp only [smul_eq_mul, A]
      ring
    _ ≤ ∫ ω, finiteMaximum X ω ∂μ :=
      integral_mono hLeftInt hMaxInt hPoint

/-- The absolute first moment of the standard-normal law. -/
def standardNormalAbsMean : ℝ :=
  ∫ x : ℝ, |x| ∂standardNormalLaw

lemma standardNormalAbsMean_nonneg : 0 ≤ standardNormalAbsMean := by
  unfold standardNormalAbsMean
  exact integral_nonneg_of_ae (ae_of_all _ fun x => abs_nonneg x)

/-- Integrability transported from the standard-normal law. -/
lemma integrable_of_hasLaw_standardNormal
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hX : Measurable X) (hLaw : HasLaw X standardNormalLaw μ) :
    Integrable X μ := by
  have hStd : Integrable (fun y : ℝ => y) standardNormalLaw := by
    rw [standardNormalLaw]
    have hm : MemLp (fun y : ℝ => y) (1 : ENNReal)
        (ProbabilityTheory.gaussianReal 0 1) := by
      simpa only [id_eq] using
        (ProbabilityTheory.memLp_id_gaussianReal
          (μ := (0 : ℝ)) (v := (1 : ℝ≥0)) (1 : ℝ≥0))
    exact hm.integrable (by norm_num)
  simpa only [Function.id_comp] using
    (hLaw.measurePreserving hX).integrable_comp_of_integrable hStd

/-- The absolute first moment is invariant under transport from a
standard-normal law. -/
lemma integral_abs_eq_standardNormalAbsMean
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hLaw : HasLaw X standardNormalLaw μ) :
    (∫ ω, |X ω| ∂μ) = standardNormalAbsMean := by
  simpa only [Function.comp_apply, standardNormalAbsMean] using
    hLaw.integral_comp (by fun_prop :
      AEStronglyMeasurable (fun x : ℝ => |x|) standardNormalLaw)

/-- The exact maximum-tail product converts the one-threshold expectation
bound into a standard-normal expression. -/
lemma standardNormalMaximum_expectation_ge_threshold
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : ι → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) (i : ι) (t : ℝ) :
    t * (1 - (1 - standardNormalLaw.real (Set.Ici t)) ^ Fintype.card ι) -
        standardNormalAbsMean ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  have hInt : ∀ j, Integrable (X j) μ := fun j =>
    integrable_of_hasLaw_standardNormal (hX j) (hLaw j)
  have h := threshold_mul_measureReal_sub_integral_abs_le_integral_finiteMaximum
    hX hInt i t
  rw [measureReal_finiteMaximum_ge_of_standardNormal hX hLaw hIndep t,
    integral_abs_eq_standardNormalAbsMean (hLaw i)] at h
  exact h

/-- A positive universal lower bound for the expected number of threshold
exceedances in the large-logarithm regime. -/
def gaussianMaximumTailConstant : ℝ :=
  (Real.sqrt (2 * Real.pi))⁻¹ / 2

lemma gaussianMaximumTailConstant_pos : 0 < gaussianMaximumTailConstant := by
  unfold gaussianMaximumTailConstant
  positivity

/-- Above threshold two, the lower Mills coefficient dominates half of its
leading reciprocal term. -/
lemma half_inv_le_millsCoefficient {t : ℝ} (ht : 2 ≤ t) :
    1 / (2 * t) ≤ 1 / t - 1 / t ^ 3 := by
  have ht0 : 0 < t := by linarith
  field_simp
  nlinarith

lemma sqrt_log_le_exp_half_log {N : ℕ} (hLog : 4 ≤ Real.log (N : ℝ)) :
    Real.sqrt (Real.log (N : ℝ)) ≤
      Real.exp (Real.log (N : ℝ) / 2) := by
  let t := Real.sqrt (Real.log (N : ℝ))
  have hLog0 : 0 ≤ Real.log (N : ℝ) := le_trans (by norm_num) hLog
  have htSq : t ^ 2 = Real.log (N : ℝ) := Real.sq_sqrt hLog0
  have hBase := Real.add_one_le_exp (t ^ 2 / 2)
  change t ≤ Real.exp (Real.log (N : ℝ) / 2)
  rw [← htSq]
  exact le_trans (by nlinarith [sq_nonneg (t - 1)]) hBase

/-- Proposition 2.1.2 implies that, at threshold `sqrt (log N)`, `N` times
the one-coordinate upper-tail probability stays above a positive universal
constant once `log N ≥ 4`. -/
lemma gaussianMaximumTailConstant_le_card_mul_tail
    {N : ℕ} (hLog : 4 ≤ Real.log (N : ℝ)) :
    gaussianMaximumTailConstant ≤
      (N : ℝ) * standardNormalLaw.real
        (Set.Ici (Real.sqrt (Real.log (N : ℝ)))) := by
  let t := Real.sqrt (Real.log (N : ℝ))
  have hLog0 : 0 ≤ Real.log (N : ℝ) := le_trans (by norm_num) hLog
  have htSq : t ^ 2 = Real.log (N : ℝ) := Real.sq_sqrt hLog0
  have ht : 2 ≤ t := by
    rw [show (2 : ℝ) = Real.sqrt 4 by norm_num]
    exact Real.sqrt_le_sqrt hLog
  have ht0 : 0 < t := by linarith
  have hNpos : 0 < (N : ℝ) := by
    by_contra h
    have hNzero : (N : ℝ) = 0 := le_antisymm (le_of_not_gt h) (by positivity)
    rw [hNzero, Real.log_zero] at hLog
    norm_num at hLog
  have hNexp : (N : ℝ) = Real.exp (t ^ 2) := by
    rw [htSq, Real.exp_log hNpos]
  have hRatio : 1 ≤ (N : ℝ) * (1 / t) * Real.exp (-(t ^ 2) / 2) := by
    have hExp : t ≤ Real.exp (t ^ 2 / 2) := by
      simpa only [t, htSq] using sqrt_log_le_exp_half_log hLog
    have hIdentity : t ^ 2 + (-(t ^ 2) / 2) = t ^ 2 / 2 := by ring
    calc
      1 ≤ Real.exp (t ^ 2 / 2) / t :=
        (le_div_iff₀ ht0).2 (by simpa using hExp)
      _ = Real.exp (t ^ 2 / 2) * (1 / t) := by ring
      _ = (Real.exp (t ^ 2) * Real.exp (-(t ^ 2) / 2)) *
          (1 / t) := by rw [← Real.exp_add, hIdentity]
      _ = (N : ℝ) * (1 / t) * Real.exp (-(t ^ 2) / 2) := by
        rw [hNexp]
        ring
  have hMills := (standardNormalTail_bounds t ht0).1
  have hCoeff :
      (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / (2 * t)) * Real.exp (-(t ^ 2) / 2)) ≤
        standardNormalLaw.real (Set.Ici t) := by
    exact (mul_le_mul_of_nonneg_left
      (mul_le_mul_of_nonneg_right (half_inv_le_millsCoefficient ht)
        (Real.exp_pos _).le) (by positivity)).trans hMills
  calc
    gaussianMaximumTailConstant =
        gaussianMaximumTailConstant * 1 := by ring
    _ ≤ gaussianMaximumTailConstant *
        ((N : ℝ) * (1 / t) * Real.exp (-(t ^ 2) / 2)) :=
      mul_le_mul_of_nonneg_left hRatio gaussianMaximumTailConstant_pos.le
    _ = (N : ℝ) *
        ((Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / (2 * t)) * Real.exp (-(t ^ 2) / 2))) := by
      unfold gaussianMaximumTailConstant
      ring
    _ ≤ (N : ℝ) * standardNormalLaw.real (Set.Ici t) := by
      exact mul_le_mul_of_nonneg_left hCoeff (by positivity)

/-- The fixed positive probability extracted from the threshold product. -/
def gaussianMaximumHitConstant : ℝ :=
  1 - Real.exp (-gaussianMaximumTailConstant)

lemma gaussianMaximumHitConstant_pos : 0 < gaussianMaximumHitConstant := by
  unfold gaussianMaximumHitConstant
  have hExp : Real.exp (-gaussianMaximumTailConstant) < 1 :=
    Real.exp_lt_one_iff.mpr (neg_neg_of_pos gaussianMaximumTailConstant_pos)
  linarith

/-- The probability that at least one coordinate exceeds `sqrt (log N)` is
bounded below by a positive universal constant in the large-logarithm
regime. -/
lemma gaussianMaximumHitConstant_le_tail_factor
    {N : ℕ} (hLog : 4 ≤ Real.log (N : ℝ)) :
    gaussianMaximumHitConstant ≤
      1 - (1 - standardNormalLaw.real
        (Set.Ici (Real.sqrt (Real.log (N : ℝ))))) ^ N := by
  let p : ℝ := standardNormalLaw.real
    (Set.Ici (Real.sqrt (Real.log (N : ℝ))))
  have hp1 : p ≤ 1 := by
    exact measureReal_le_one
  have hPow : (1 - p) ^ N ≤ Real.exp (-((N : ℝ) * p)) :=
    NumStability.HDP.Scalar.IndependentSums.Chernoff.one_sub_pow_le_exp_neg_nat_mul
      hp1 N
  have hNp : gaussianMaximumTailConstant ≤ (N : ℝ) * p :=
    gaussianMaximumTailConstant_le_card_mul_tail hLog
  have hExp : Real.exp (-((N : ℝ) * p)) ≤
      Real.exp (-gaussianMaximumTailConstant) :=
    Real.exp_le_exp.mpr (neg_le_neg hNp)
  unfold gaussianMaximumHitConstant
  dsimp [p] at hPow hExp ⊢
  linarith

/-- The expected maximum of two independent standard normals is exactly
`1 / sqrt π`. -/
lemma expectation_max_two_standardNormal
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X Y : Ω → ℝ}
    (hX : Measurable X) (hY : Measurable Y)
    (hLawX : HasLaw X standardNormalLaw μ)
    (hLawY : HasLaw Y standardNormalLaw μ)
    (hIndep : IndepFun X Y μ) :
    (∫ ω, max (X ω) (Y ω) ∂μ) = 1 / Real.sqrt Real.pi := by
  have hPair : HasLaw (fun ω => (X ω, Y ω))
      (standardNormalLaw.prod standardNormalLaw) μ := by
    refine ⟨(hX.prodMk hY).aemeasurable, ?_⟩
    rw [(indepFun_iff_map_prod_eq_prod_map_map
      hX.aemeasurable hY.aemeasurable).1 hIndep,
      hLawX.map_eq, hLawY.map_eq]
  have hMeanX : (∫ ω, X ω ∂μ) = 0 := by
    rw [hLawX.integral_eq, standardNormalLaw]
    exact ProbabilityTheory.integral_id_gaussianReal
  have hMeanY : (∫ ω, Y ω ∂μ) = 0 := by
    rw [hLawY.integral_eq, standardNormalLaw]
    exact ProbabilityTheory.integral_id_gaussianReal
  have hAbsDiff : (∫ ω, |X ω - Y ω| ∂μ) =
      2 / Real.sqrt Real.pi := by
    have h := hPair.integral_comp (by fun_prop :
      AEStronglyMeasurable (fun p : ℝ × ℝ => |p.1 - p.2|)
        (standardNormalLaw.prod standardNormalLaw))
    rw [standardNormalLaw, NumStability.integral_abs_standardGaussian_difference] at h
    simpa only [Function.comp_apply] using h
  have hXInt := integrable_of_hasLaw_standardNormal hX hLawX
  have hYInt := integrable_of_hasLaw_standardNormal hY hLawY
  have hDiffInt : Integrable (fun ω => |X ω - Y ω|) μ :=
    (hXInt.sub hYInt).abs
  calc
    (∫ ω, max (X ω) (Y ω) ∂μ) =
        ∫ ω, (1 / 2 : ℝ) * (X ω + Y ω + |X ω - Y ω|) ∂μ := by
      apply integral_congr_ae
      filter_upwards [] with ω
      rcases le_total (X ω) (Y ω) with hXY | hYX
      · rw [max_eq_right hXY, abs_of_nonpos (sub_nonpos.mpr hXY)]
        ring
      · rw [max_eq_left hYX, abs_of_nonneg (sub_nonneg.mpr hYX)]
        ring
    _ = (1 / 2 : ℝ) *
        ((∫ ω, X ω ∂μ) + (∫ ω, Y ω ∂μ) +
          ∫ ω, |X ω - Y ω| ∂μ) := by
      rw [integral_const_mul]
      congr 1
      let D : Ω → ℝ := fun ω => |X ω - Y ω|
      change (∫ ω, ((X + Y) + D) ω ∂μ) = _
      calc
        (∫ ω, ((X + Y) + D) ω ∂μ) =
            (∫ ω, (X + Y) ω ∂μ) + ∫ ω, D ω ∂μ := by
          simpa using integral_add (hXInt.add hYInt) hDiffInt
        _ = (∫ ω, X ω ∂μ) + (∫ ω, Y ω ∂μ) +
            ∫ ω, |X ω - Y ω| ∂μ := by
          rw [show (∫ ω, (X + Y) ω ∂μ) =
            (∫ ω, X ω ∂μ) + ∫ ω, Y ω ∂μ by
              simpa only [Pi.add_apply] using integral_add hXInt hYInt]
    _ = 1 / Real.sqrt Real.pi := by
      rw [hMeanX, hMeanY, hAbsDiff]
      ring

/-- Every finite standard-normal maximum with at least two coordinates
dominates the exact two-coordinate expected maximum. -/
lemma expectation_finiteMaximum_standardNormal_ge_pair
    {N : ℕ} [Nonempty (Fin N)] (hN : 2 ≤ N)
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Fin N → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) :
    1 / Real.sqrt Real.pi ≤ ∫ ω, finiteMaximum X ω ∂μ := by
  let i : Fin N := ⟨0, by omega⟩
  let j : Fin N := ⟨1, by omega⟩
  have hij : i ≠ j := by
    intro h
    have := congrArg Fin.val h
    norm_num [i, j] at this
  have hPairInt : Integrable (fun ω => max (X i ω) (X j ω)) μ :=
    (integrable_of_hasLaw_standardNormal (hX i) (hLaw i)).sup
      (integrable_of_hasLaw_standardNormal (hX j) (hLaw j))
  have hMaxInt : Integrable (finiteMaximum X) μ :=
    integrable_finiteMaximum (fun k =>
      integrable_of_hasLaw_standardNormal (hX k) (hLaw k))
  rw [← expectation_max_two_standardNormal (hX i) (hX j)
    (hLaw i) (hLaw j) (hIndep.indepFun hij)]
  apply integral_mono hPairInt hMaxInt
  intro ω
  exact max_le (le_finiteMaximum X i ω) (le_finiteMaximum X j ω)

/-- The large-logarithm estimate before absorbing the finite absolute-moment
loss. -/
lemma expectation_finiteMaximum_standardNormal_ge_affine
    {N : ℕ} [Nonempty (Fin N)]
    (hLog : 4 ≤ Real.log (N : ℝ))
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Fin N → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) :
    gaussianMaximumHitConstant * Real.sqrt (Real.log (N : ℝ)) -
        standardNormalAbsMean ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  let i : Fin N := Classical.choice inferInstance
  have hThreshold := standardNormalMaximum_expectation_ge_threshold
    hX hLaw hIndep i (Real.sqrt (Real.log (N : ℝ)))
  have hFactor := gaussianMaximumHitConstant_le_tail_factor hLog
  have hSqrt : 0 ≤ Real.sqrt (Real.log (N : ℝ)) := Real.sqrt_nonneg _
  rw [mul_comm gaussianMaximumHitConstant]
  exact (sub_le_sub_right
    (mul_le_mul_of_nonneg_left hFactor hSqrt) standardNormalAbsMean).trans
      (by simpa only [Fintype.card_fin] using hThreshold)

/-- A positive universal constant for the lower bound on independent
standard-normal maxima. -/
def gaussianMaximumLowerConstant : ℝ :=
  min ((1 / Real.sqrt Real.pi) / 2)
    (((1 / Real.sqrt Real.pi) * gaussianMaximumHitConstant) /
      ((1 / Real.sqrt Real.pi) + standardNormalAbsMean))

lemma gaussianMaximumLowerConstant_pos : 0 < gaussianMaximumLowerConstant := by
  let a : ℝ := 1 / Real.sqrt Real.pi
  have ha : 0 < a := by dsimp [a]; positivity
  have hb : 0 < gaussianMaximumHitConstant := gaussianMaximumHitConstant_pos
  have hd : 0 ≤ standardNormalAbsMean := standardNormalAbsMean_nonneg
  have hden : 0 < a + standardNormalAbsMean := by linarith
  unfold gaussianMaximumLowerConstant
  exact lt_min (div_pos ha (by norm_num)) (div_pos (mul_pos ha hb) hden)

/-- Sharp-order lower bound for the expected signed maximum of `N ≥ 2`
independent standard-normal variables. -/
theorem expectation_finiteMaximum_standardNormal_ge_sqrt_log
    {N : ℕ} [Nonempty (Fin N)] (hN : 2 ≤ N)
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Fin N → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) :
    gaussianMaximumLowerConstant * Real.sqrt (Real.log (N : ℝ)) ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  let x : ℝ := Real.sqrt (Real.log (N : ℝ))
  let a : ℝ := 1 / Real.sqrt Real.pi
  let b : ℝ := gaussianMaximumHitConstant
  let d : ℝ := standardNormalAbsMean
  have hx : 0 ≤ x := Real.sqrt_nonneg _
  have ha : 0 < a := by dsimp [a]; positivity
  have hb : 0 < b := by exact gaussianMaximumHitConstant_pos
  have hd : 0 ≤ d := by exact standardNormalAbsMean_nonneg
  have hden : 0 < a + d := by linarith
  have hBase : a ≤ ∫ ω, finiteMaximum X ω ∂μ := by
    exact expectation_finiteMaximum_standardNormal_ge_pair hN hX hLaw hIndep
  have hCsmall : gaussianMaximumLowerConstant ≤ a / 2 := by
    exact min_le_left _ _
  have hCmain : gaussianMaximumLowerConstant ≤ a * b / (a + d) := by
    exact min_le_right _ _
  by_cases hLog : 4 ≤ Real.log (N : ℝ)
  · have hAffine : b * x - d ≤ ∫ ω, finiteMaximum X ω ∂μ := by
      exact expectation_finiteMaximum_standardNormal_ge_affine hLog hX hLaw hIndep
    have hCombine : a * b / (a + d) * x ≤ max a (b * x - d) := by
      by_cases hbx : b * x ≤ a + d
      · calc
          a * b / (a + d) * x = a * (b * x) / (a + d) := by ring
          _ ≤ a := by
            apply (div_le_iff₀ hden).2
            exact mul_le_mul_of_nonneg_left hbx ha.le
          _ ≤ max a (b * x - d) := le_max_left _ _
      · have hbx' : a + d < b * x := lt_of_not_ge hbx
        have hprod : 0 ≤ d * (b * x - (a + d)) :=
          mul_nonneg hd (sub_nonneg.mpr hbx'.le)
        calc
          a * b / (a + d) * x = (a * b * x) / (a + d) := by ring
          _ ≤ b * x - d := by
            apply (div_le_iff₀ hden).2
            nlinarith
          _ ≤ max a (b * x - d) := le_max_right _ _
    calc
      gaussianMaximumLowerConstant * x ≤
          (a * b / (a + d)) * x :=
        mul_le_mul_of_nonneg_right hCmain hx
      _ ≤ max a (b * x - d) := hCombine
      _ ≤ ∫ ω, finiteMaximum X ω ∂μ := max_le hBase hAffine
  · have hLogLe : Real.log (N : ℝ) ≤ 4 := le_of_not_ge hLog
    have hxLe : x ≤ 2 := by
      dsimp [x]
      calc
        Real.sqrt (Real.log (N : ℝ)) ≤ Real.sqrt 4 :=
          Real.sqrt_le_sqrt hLogLe
        _ = 2 := by norm_num
    calc
      gaussianMaximumLowerConstant * x ≤ (a / 2) * x :=
        mul_le_mul_of_nonneg_right hCsmall hx
      _ ≤ a := by nlinarith
      _ ≤ ∫ ω, finiteMaximum X ω ∂μ := hBase

/-- Positive-cardinality form, including the source's trivial single-variable
endpoint. -/
theorem expectation_finiteMaximum_standardNormal_ge_sqrt_log_of_pos
    {N : ℕ} [Nonempty (Fin N)] (hN : 0 < N)
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Fin N → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) :
    gaussianMaximumLowerConstant * Real.sqrt (Real.log (N : ℝ)) ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  by_cases hOne : N = 1
  · subst N
    have hMax : finiteMaximum X = X 0 := by
      funext ω
      rw [finiteMaximum, Finset.sup'_apply]
      simp
    have hMean : (∫ ω, X 0 ω ∂μ) = 0 := by
      rw [(hLaw 0).integral_eq, standardNormalLaw]
      exact ProbabilityTheory.integral_id_gaussianReal
    rw [hMax, hMean]
    norm_num
  · exact expectation_finiteMaximum_standardNormal_ge_sqrt_log
      (by omega) hX hLaw hIndep

/-- The signed maximum of the first `N` members of a sequence, totalized by
zero only at the empty prefix. -/
def prefixMaximum {Ω : Type*} (X : ℕ → Ω → ℝ) (N : ℕ) : Ω → ℝ :=
  if hN : 0 < N then
    letI : Nonempty (Fin N) := ⟨⟨0, hN⟩⟩
    finiteMaximum (fun i : Fin N => X i)
  else
    fun _ => 0

lemma prefixMaximum_eq_finiteMaximum
    {Ω : Type*} (X : ℕ → Ω → ℝ) {N : ℕ} (hN : 0 < N) :
    letI : Nonempty (Fin N) := ⟨⟨0, hN⟩⟩
    prefixMaximum X N = finiteMaximum (fun i : Fin N => X i) := by
  simp [prefixMaximum, hN]

/-- Sequence-indexed form of the sharp-order lower bound. -/
theorem expectation_prefixMaximum_standardNormal_ge_sqrt_log
    {N : ℕ} (hN : 0 < N)
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : ℕ → Ω → ℝ}
    (hX : ∀ i : Fin N, Measurable (X i))
    (hLaw : ∀ i : Fin N, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun (fun i : Fin N => X i) μ) :
    gaussianMaximumLowerConstant * Real.sqrt (Real.log (N : ℝ)) ≤
      ∫ ω, prefixMaximum X N ω ∂μ := by
  letI : Nonempty (Fin N) := ⟨⟨0, hN⟩⟩
  rw [prefixMaximum_eq_finiteMaximum X hN]
  exact expectation_finiteMaximum_standardNormal_ge_sqrt_log_of_pos
    hN hX hLaw hIndep

end NumStability.HDP.Scalar.GaussianMaxima
```

### `ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Exercise11.Signature`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter02/Section05/Exercise11/Signature.lean`
SHA-256: `d85f966793bb02221b38b6b8f65af5c019b0cc89cf064029280c16d1c7bae63b`

```lean
import ComputationalMathematics.HDP.Scalar.GaussianMaxima

/-!
# Frozen contract signature for Exercise 2.5.11

The source indices `1, …, N` are represented by the first `N` zero-based
coordinates of a sequence.  The signed maximum is totalized only at the empty
prefix, which is excluded by the source's positive-cardinality hypothesis.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.GaussianMaxima
open NumStability.HDP.Scalar.LimitTheorems

def hdp_02_hex_h2_d5_d11__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ (Ω : Type*) [MeasurableSpace Ω]
      (μ : Measure Ω) [IsProbabilityMeasure μ]
      (X : ℕ → Ω → ℝ) (N : ℕ),
      0 < N →
      (∀ i : Fin N, Measurable (X i)) →
      (∀ i : Fin N, HasLaw (X i) standardNormalLaw μ) →
      iIndepFun (fun i : Fin N => X i) μ →
      Integrable (prefixMaximum X N) μ ∧
        c * Real.sqrt (Real.log (N : ℝ)) ≤
          ∫ ω, prefixMaximum X N ω ∂μ

end NumStability.HDP.Contract
```
