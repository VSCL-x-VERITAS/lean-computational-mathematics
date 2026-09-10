# Declaration dossier for HDP-02-DEF-2.7-ORLICZ-FUNCTION

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem hdp_02_hdef_horlicz_hfunction_exact :
    hdp_02_hdef_horlicz_hfunction__contract_type
```

## Elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hdef_horlicz_hfunction__contract_type
```

## Fully explicit elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hdef_horlicz_hfunction__contract_type
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczFunction.Signature`, `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczDefinitions`
- `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Remark09.Signature` imports: `Mathlib.Analysis.Calculus.Taylor`, `Mathlib.Analysis.SpecialFunctions.ImproperIntegrals`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap`, `Mathlib.MeasureTheory.Function.L1Space.Integrable`, `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`, `Mathlib.Probability.Distributions.Exponential`
- `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic` imports: `Mathlib.Probability.Moments.Variance`, `Mathlib.Probability.CDF`, `Mathlib.MeasureTheory.Function.LpSpace.Basic`, `Mathlib.MeasureTheory.Function.LpSpace.Complete`, `Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm`, `Mathlib.MeasureTheory.Function.LpSeminorm.Indicator`, `Mathlib.Probability.UniformOn`, `Mathlib.Analysis.Convex.Integral`, `Mathlib.Analysis.Convex.Continuous`, `Mathlib.MeasureTheory.Integral.Bochner.Set`, `Mathlib.MeasureTheory.Integral.Lebesgue.Markov`, `Mathlib.MeasureTheory.Integral.Layercake`, `Mathlib.MeasureTheory.Measure.Lebesgue.Integral`, `Mathlib.Probability.Distributions.Cauchy`, `Mathlib.Analysis.SpecialFunctions.NonIntegrable`, `Mathlib.Analysis.SpecialFunctions.Pow.Integral`, `Mathlib.Tactic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.ConvexFunction.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.DistributionDetermined.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Equation03.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.HolderInequality.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Indicator.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.JensenInequality.Signature` imports: `Mathlib.Analysis.Convex.Integral`
- `ComputationalMathematics.Source.Vershynin.Chapter01.JensenInequality.Contract.Theorem` imports: `ComputationalMathematics.Source.Vershynin.Chapter01.JensenInequality.Signature`, `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.LayerCakePointwise.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.LpBanachSpace.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.LpNormedSpace.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.LpQuasinorm.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.MinkowskiInequality.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.MomentGeneratingFunction.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Moments.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Section01.Remark01.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Corollary05.Contract.Theorem` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise02.Contract.Theorem` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise03.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise06.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Lemma01.Contract.Theorem` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Proposition04.Decomposition.Contract` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`
- `ComputationalMathematics.HDP.Scalar.Preliminaries` imports: `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`, `ComputationalMathematics.Source.Vershynin.Chapter01.ConvexFunction.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.DistributionDetermined.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.Equation03.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.HolderInequality.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.Indicator.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.JensenInequality.Contract.Theorem`, `ComputationalMathematics.Source.Vershynin.Chapter01.LayerCakePointwise.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.LpBanachSpace.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.LpNormedSpace.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.LpQuasinorm.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.MinkowskiInequality.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.MomentGeneratingFunction.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.Moments.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.Section01.Remark01.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Corollary05.Contract.Theorem`, `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise02.Contract.Theorem`, `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise03.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise06.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Lemma01.Contract.Theorem`, `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Proposition04.Decomposition.Contract`
- `ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding` imports: `Mathlib.Probability.Independence.Integration`, `Mathlib.Probability.Moments.Basic`, `Mathlib.Probability.Moments.SubGaussian`, `Mathlib.Probability.ProbabilityMassFunction.Constructions`, `Mathlib.Probability.ProbabilityMassFunction.Integrals`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.Series`, `Mathlib.Analysis.SpecialFunctions.ImproperIntegrals`, `Mathlib.Tactic`, `ComputationalMathematics.HDP.Scalar.Preliminaries`
- `ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise09.Signature` imports: `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- `ComputationalMathematics.HDP.Scalar.SubGaussian` imports: `Mathlib.Probability.Distributions.Gaussian.Real`, `Mathlib.Probability.Distributions.Gaussian.HasGaussianLaw.Independence`, `Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral`, `Mathlib.Analysis.SpecialFunctions.Gamma.Beta`, `Mathlib.Analysis.SpecialFunctions.Stirling`, `Mathlib.Analysis.Complex.ExponentialBounds`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.Series`, `Mathlib.Analysis.SpecificLimits.Basic`, `Mathlib.Analysis.Convex.SpecificFunctions.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Integral.Gamma`, `Mathlib.MeasureTheory.Function.L1Space.Integrable`, `Mathlib.Probability.Moments.IntegrableExpMul`, `Mathlib.Tactic`, `ComputationalMathematics.HDP.Scalar.Preliminaries`, `ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding`, `ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise09.Signature`
- `ComputationalMathematics.HDP.Scalar.SubExponential` imports: `Mathlib.Analysis.Convex.Function`, `Mathlib.Analysis.Calculus.Taylor`, `Mathlib.Topology.Algebra.Order.Field`, `Mathlib.Analysis.SpecialFunctions.Stirling`, `Mathlib.Analysis.Complex.ExponentialBounds`, `Mathlib.Analysis.SpecialFunctions.ImproperIntegrals`, `Mathlib.Analysis.SpecialFunctions.Pow.Real`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap`, `Mathlib.MeasureTheory.Function.L1Space.Integrable`, `Mathlib.Probability.Distributions.Exponential`, `Mathlib.Probability.Moments.IntegrableExpMul`, `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Remark09.Signature`, `ComputationalMathematics.HDP.Scalar.SubGaussian`, `Mathlib.Tactic`
- `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczFunction.Signature` imports: `ComputationalMathematics.HDP.Scalar.SubExponential`
- `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczDefinitions` imports: `ComputationalMathematics.HDP.Scalar.SubExponential`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Contract.hdp_02_hdef_horlicz_hfunction__contract_type`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczFunction.Signature`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `83fc78eee203a5e5415c3339da563124f72ef1e63924c6e1c1104b6c61859de4`

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
∀ (f : Real → Real),
  Iff (Exists fun ψ => Eq ψ.toFun f)
    (And (∀ (x : Real), Real.instLE.le 0 x → Real.instLE.le 0 (f x))
      (And (ConvexOn Real (Set.Ici 0) f)
        (And (MonotoneOn f (Set.Ici 0)) (And (Eq (f 0) 0) (Filter.Tendsto f Filter.atTop Filter.atTop)))))
```

### D002: `NumStability.HDP.Scalar.SubExponential.OrliczFunction`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `7011593b6be51e53abae7670f8e51ffcf4631eae3446444623021b95101eeff6`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D003: `NumStability.HDP.Scalar.SubExponential.OrliczFunction.toFun`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `f7ebf35ffacdd553408f1e68f130c86eee6335e55ae16df024ed061548f26449`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.OrliczFunction → Real → Real
```

Fully explicit type:

```lean
(self : NumStability.HDP.Scalar.SubExponential.OrliczFunction) → Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.1
```

### D004: `NumStability.HDP.Scalar.SubExponential.OrliczFunction.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `8938ffc6e0130d73d09ca649050bb05cf343ad8f7cd6dd3d48e6b808312d74e9`

Type:

```lean
(toFun : Real → Real) →
  (∀ (x : Real), Real.instLE.le 0 x → Real.instLE.le 0 (toFun x)) →
    ConvexOn Real (Set.Ici 0) toFun →
      MonotoneOn toFun (Set.Ici 0) →
        Eq (toFun 0) 0 →
          Filter.Tendsto toFun Filter.atTop Filter.atTop → NumStability.HDP.Scalar.SubExponential.OrliczFunction
```

Fully explicit type:

```lean
(toFun : Real → Real) →
  (nonnegative :
      ∀ (x : Real),
        @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) x →
          @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
            (toFun x)) →
    (convexOn_nonneg :
        @ConvexOn.{0, 0, 0} Real Real Real Real.semiring Real.partialOrder Real.instAddCommMonoid Real.instAddCommMonoid
          Real.partialOrder
          (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
            (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring) (@Algebra.id.{0} Real Real.instCommSemiring))
          (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
            (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring) (@Algebra.id.{0} Real Real.instCommSemiring))
          (@Set.Ici.{0} Real Real.instPreorder
            (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
          toFun) →
      (monotoneOn_nonneg :
          @MonotoneOn.{0, 0} Real Real Real.instPreorder Real.instPreorder toFun
            (@Set.Ici.{0} Real Real.instPreorder
              (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))) →
        (map_zero :
            @Eq.{1} Real (toFun (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
              (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))) →
          (tendsto_atTop :
              @Filter.Tendsto.{0, 0} Real Real toFun (@Filter.atTop.{0} Real Real.instPreorder)
                (@Filter.atTop.{0} Real Real.instPreorder)) →
            NumStability.HDP.Scalar.SubExponential.OrliczFunction
```

### D005: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D006: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D007: `And`

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

### D008: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D009: `ConvexOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Convex.Function`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `100cf68baf548a86a1438cee4c0e55bbe6f48a052cdb7f3cde5f2ed44cc70d23`

Type:

```lean
(𝕜 : Type u_1) →
  {E : Type u_2} →
    {β : Type u_5} →
      [Semiring 𝕜] →
        [PartialOrder 𝕜] →
          [AddCommMonoid E] → [AddCommMonoid β] → [PartialOrder β] → [SMul 𝕜 E] → [SMul 𝕜 β] → Set E → (E → β) → Prop
```

Fully explicit type:

```lean
(𝕜 : Type u_1) →
  {E : Type u_2} →
    {β : Type u_5} →
      [Semiring.{u_1} 𝕜] →
        [PartialOrder.{u_1} 𝕜] →
          [AddCommMonoid.{u_2} E] →
            [AddCommMonoid.{u_5} β] →
              [PartialOrder.{u_5} β] →
                [SMul.{u_1, u_2} 𝕜 E] → [SMul.{u_1, u_5} 𝕜 β] → (s : Set.{u_2} E) → (f : E → β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 {E} {β} [Semiring 𝕜] [inst_1 : PartialOrder 𝕜] [AddCommMonoid E] [AddCommMonoid β] [inst_4 : PartialOrder β]
    [SMul 𝕜 E] [SMul 𝕜 β] s f =>
  And (Convex 𝕜 s)
    (∀ ⦃x : E⦄,
      Set.instMembership.mem s x →
        ∀ ⦃y : E⦄,
          Set.instMembership.mem s y →
            ∀ ⦃a b : 𝕜⦄,
              inst_1.le 0 a →
                inst_1.le 0 b →
                  Eq (instHAdd.hAdd a b) 1 →
                    inst_4.le (f (instHAdd.hAdd (instHSMul.hSMul a x) (instHSMul.hSMul b y)))
                      (instHAdd.hAdd (instHSMul.hSMul a (f x)) (instHSMul.hSMul b (f y))))
```

### D010: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

Fully explicit type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D011: `Exists`

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

### D012: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7e5f54349644c32198960083c0e0eb6c033c80a8656d02a78b3eae9a4f5131f2`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → (α → β) → Filter α → Filter β → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → (f : α → β) → (l₁ : Filter.{u_1} α) → (l₂ : Filter.{u_2} β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f l₁ l₂ => Filter.instPartialOrder.le (Filter.map f l₁) l₂
```

### D013: `Filter.atTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.AtTopBot.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f743a11da6fe9e156755f41ec35f4d61b87ca4af4575ede456b477a74caa45f3`

Type:

```lean
{α : Type u_3} → [Preorder α] → Filter α
```

Fully explicit type:

```lean
{α : Type u_3} → [Preorder.{u_3} α] → Filter.{u_3} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Preorder α] => iInf fun a => Filter.principal (Set.Ici a)
```

### D014: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D015: `LE.le`

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

### D016: `MonotoneOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Monotone.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `81a612dcb914ff1895f07c02c9403bf6daf805789d8aec446d57f2cd6e179896`

Type:

```lean
{α : Type u} → {β : Type v} → [Preorder α] → [Preorder β] → (α → β) → Set α → Prop
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → [Preorder.{u} α] → [Preorder.{v} β] → (f : α → β) → (s : Set.{u} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [inst : Preorder α] [inst_1 : Preorder β] f s =>
  ∀ ⦃a : α⦄, Set.instMembership.mem s a → ∀ ⦃b : α⦄, Set.instMembership.mem s b → inst.le a b → inst_1.le (f a) (f b)
```

### D017: `OfNat.ofNat`

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

### D018: `Real`

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

### D019: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `11a549e6c9caa007a4627570dd86aea756ada755f141da0356b8766788f2eef7`

Type:

```lean
AddCommMonoid Real
```

Fully explicit type:

```lean
AddCommMonoid.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D020: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D021: `Real.instLE`

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

### D022: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `896bb94fc15867c0df82ea0f639eb6116e90a24819a66a54db9442e47cba7274`

Type:

```lean
Preorder Real
```

Fully explicit type:

```lean
Preorder.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D023: `Real.instZero`

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

### D024: `Real.partialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c230e4cc01baeb2fcfa7d957f7e912e6e79376f736b5b58965ca7da585e8d66a`

Type:

```lean
PartialOrder Real
```

Fully explicit type:

```lean
PartialOrder.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toLE := Real.instLE, toLT := Real.instLT, le_refl := ⋯, le_trans := ⋯, lt_iff_le_not_ge := ⋯, le_antisymm := ⋯ }
```

### D025: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c0106cafec59cbaa840a6e4c7ee72e629b4456feb6db98c6bf8c3085fcac475c`

Type:

```lean
Semiring Real
```

Fully explicit type:

```lean
Semiring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D026: `Set.Ici`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `32e9548f07a5e31843a500e07f11e2e04776466d0284c00e33d88066bc211711`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → (b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] b => setOf fun x => inst.le b x
```

### D027: `Zero.toOfNat0`

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
