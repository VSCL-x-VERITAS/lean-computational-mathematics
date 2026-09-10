# Declaration dossier for HDP-02-EXAMPLE-2.7.13

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem hdp_02_hexample_h2_d7_d13_exact :
    hdp_02_hexample_h2_d7_d13__contract_type
```

## Elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hexample_h2_d7_d13__contract_type
```

## Fully explicit elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hexample_h2_d7_d13__contract_type.{u_1}
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example13.Signature`
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
- `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example13.Signature` imports: `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `ComputationalMathematics.HDP.Scalar.SubExponential`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Contract.hdp_02_hexample_h2_d7_d13__contract_type`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example13.Signature`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a864b697660ab9ea333a5a62d67ad7efd06da28d0a71bf8a21a7c9f38a4a3981`

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
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] {μ : MeasureTheory.Measure Ω} [MeasureTheory.IsProbabilityMeasure μ]
  {X : Ω → Real},
  Measurable X →
    Iff
      (NumStability.HDP.Scalar.SubExponential.orliczMember NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction μ
        X)
      (ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X) instTopENNReal.top)
```

### D002: `NumStability.HDP.Scalar.SubExponential.orliczMember`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b7ca54e0994c3aae90446a89b8ac1e846f5a1e9cb29636080d559b718b6374ba`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    NumStability.HDP.Scalar.SubExponential.OrliczFunction → MeasureTheory.Measure Ω → (Ω → Real) → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ X =>
  ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubExponential.orliczGauge ψ μ X) instTopENNReal.top
```

### D003: `NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e6feed341428ed34b0175addc4838d2e39a130e9f049d3fb14764e495ef7b045`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.OrliczFunction
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubExponential.OrliczFunction
```

Definition body (one-level semantic boundary):

```lean
{ toFun := fun x => instHSub.hSub (Real.exp (instHPow.hPow x 2)) 1,
  nonnegative := NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_1,
  convexOn_nonneg := NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_2,
  monotoneOn_nonneg := NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_3,
  map_zero := NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_4,
  tendsto_atTop := NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_5 }
```

### D004: `NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c81a60a904843ef883b553397d53b96fedc04c2aeefd9d5412e0840155eb0b48`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal
```

Fully explicit type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X =>
  ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf.sInf
    (setOf fun t => NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X t)
```

### D005: `NumStability.HDP.Scalar.SubExponential.OrliczFunction`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `7011593b6be51e53abae7670f8e51ffcf4631eae3446444623021b95101eeff6`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D006: `NumStability.HDP.Scalar.SubExponential.OrliczFunction.mk`

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

### D007: `NumStability.HDP.Scalar.SubExponential.orliczGauge`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `934176762a9437fa55669c03194f1af7b845fd410ffe54b39c592e720fee35e8`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    NumStability.HDP.Scalar.SubExponential.OrliczFunction → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ X =>
  ConditionallyCompleteLattice.toConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf.sInf
    (setOf fun t => NumStability.HDP.Scalar.SubExponential.orliczAdmissible ψ μ X t)
```

### D008: `NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `2ccf4f0ca16c61dc6ec6c4d448d4be938d1f496e8d947f26d4ca8dca09ddb1f7`

Type:

```lean
∀ (x : Real), Real.instLE.le 0 x → Real.linearOrder.le 0 (instHSub.hSub (Real.exp (instHPow.hPow x 2)) 1)
```

Fully explicit type:

```lean
∀ (x : Real)
  (hx : @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) x),
  @LE.le.{0} Real
    (@Preorder.toLE.{0} Real
      (@PartialOrder.toPreorder.{0} Real (@LinearOrder.toPartialOrder.{0} Real Real.linearOrder)))
    (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
    (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub)
      (Real.exp
        (@HPow.hPow.{0, 0, 0} Real Nat Real (@instHPow.{0, 0} Real Nat (@Monoid.toNatPow.{0} Real Real.instMonoid)) x
          (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))))
      (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
```

### D009: `NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_2`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `cfe5cfda7152060dbbba59f73bc2685880d22a5893d396ae2b0ff651962cb83a`

Type:

```lean
And (Convex Real (Set.Ici 0))
  (∀ ⦃x : Real⦄,
    Set.instMembership.mem (Set.Ici 0) x →
      ∀ ⦃y : Real⦄,
        Set.instMembership.mem (Set.Ici 0) y →
          ∀ ⦃a b : Real⦄,
            Real.partialOrder.le 0 a →
              Real.partialOrder.le 0 b →
                Eq (instHAdd.hAdd a b) 1 →
                  Real.partialOrder.le
                    (instHSub.hSub
                      (Real.exp (instHPow.hPow (instHAdd.hAdd (instHSMul.hSMul a x) (instHSMul.hSMul b y)) 2)) 1)
                    (instHAdd.hAdd (instHSMul.hSMul a (instHSub.hSub (Real.exp (instHPow.hPow x 2)) 1))
                      (instHSMul.hSMul b (instHSub.hSub (Real.exp (instHPow.hPow y 2)) 1))))
```

Fully explicit type:

```lean
And
  (@Convex.{0, 0} Real Real Real.semiring Real.partialOrder Real.instAddCommMonoid
    (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
      (@Algebra.id.{0} Real Real.instCommSemiring))
    (@Set.Ici.{0} Real Real.instPreorder (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))))
  (∀ ⦃x : Real⦄,
    @Membership.mem.{0, 0} Real (Set.{0} Real) (@Set.instMembership.{0} Real)
        (@Set.Ici.{0} Real Real.instPreorder
          (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
        x →
      ∀ ⦃y : Real⦄,
        @Membership.mem.{0, 0} Real (Set.{0} Real) (@Set.instMembership.{0} Real)
            (@Set.Ici.{0} Real Real.instPreorder
              (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
            y →
          ∀ ⦃a b : Real⦄,
            @LE.le.{0} Real (@Preorder.toLE.{0} Real (@PartialOrder.toPreorder.{0} Real Real.partialOrder))
                (@OfNat.ofNat.{0} Real (nat_lit 0)
                  (@Zero.toOfNat0.{0} Real
                    (@MulZeroClass.toZero.{0} Real
                      (@NonUnitalNonAssocSemiring.toMulZeroClass.{0} Real
                        (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                          (@Semiring.toNonAssocSemiring.{0} Real Real.semiring))))))
                a →
              @LE.le.{0} Real (@Preorder.toLE.{0} Real (@PartialOrder.toPreorder.{0} Real Real.partialOrder))
                  (@OfNat.ofNat.{0} Real (nat_lit 0)
                    (@Zero.toOfNat0.{0} Real
                      (@MulZeroClass.toZero.{0} Real
                        (@NonUnitalNonAssocSemiring.toMulZeroClass.{0} Real
                          (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                            (@Semiring.toNonAssocSemiring.{0} Real Real.semiring))))))
                  b →
                @Eq.{1} Real
                    (@HAdd.hAdd.{0, 0, 0} Real Real Real
                      (@instHAdd.{0} Real
                        (@Distrib.toAdd.{0} Real
                          (@NonUnitalNonAssocSemiring.toDistrib.{0} Real
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                              (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)))))
                      a b)
                    (@OfNat.ofNat.{0} Real (nat_lit 1)
                      (@One.toOfNat1.{0} Real
                        (@AddMonoidWithOne.toOne.{0} Real
                          (@AddCommMonoidWithOne.toAddMonoidWithOne.{0} Real
                            (@NonAssocSemiring.toAddCommMonoidWithOne.{0} Real
                              (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)))))) →
                  @LE.le.{0} Real (@Preorder.toLE.{0} Real (@PartialOrder.toPreorder.{0} Real Real.partialOrder))
                    (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub)
                      (Real.exp
                        (@HPow.hPow.{0, 0, 0} Real Nat Real
                          (@instHPow.{0, 0} Real Nat (@Monoid.toNatPow.{0} Real Real.instMonoid))
                          (@HAdd.hAdd.{0, 0, 0} Real Real Real
                            (@instHAdd.{0} Real
                              (@AddCommMagma.toAdd.{0} Real
                                (@AddCommSemigroup.toAddCommMagma.{0} Real
                                  (@AddCommMonoid.toAddCommSemigroup.{0} Real Real.instAddCommMonoid))))
                            (@HSMul.hSMul.{0, 0, 0} Real Real Real
                              (@instHSMul.{0, 0} Real Real
                                (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                  (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                  (@Algebra.id.{0} Real Real.instCommSemiring)))
                              a x)
                            (@HSMul.hSMul.{0, 0, 0} Real Real Real
                              (@instHSMul.{0, 0} Real Real
                                (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                  (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                  (@Algebra.id.{0} Real Real.instCommSemiring)))
                              b y))
                          (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))))
                      (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
                    (@HAdd.hAdd.{0, 0, 0} Real Real Real
                      (@instHAdd.{0} Real
                        (@AddCommMagma.toAdd.{0} Real
                          (@AddCommSemigroup.toAddCommMagma.{0} Real
                            (@AddCommMonoid.toAddCommSemigroup.{0} Real Real.instAddCommMonoid))))
                      (@HSMul.hSMul.{0, 0, 0} Real Real Real
                        (@instHSMul.{0, 0} Real Real
                          (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                            (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                            (@Algebra.id.{0} Real Real.instCommSemiring)))
                        a
                        (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub)
                          (Real.exp
                            (@HPow.hPow.{0, 0, 0} Real Nat Real
                              (@instHPow.{0, 0} Real Nat (@Monoid.toNatPow.{0} Real Real.instMonoid)) x
                              (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))))
                          (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))))
                      (@HSMul.hSMul.{0, 0, 0} Real Real Real
                        (@instHSMul.{0, 0} Real Real
                          (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                            (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                            (@Algebra.id.{0} Real Real.instCommSemiring)))
                        b
                        (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub)
                          (Real.exp
                            (@HPow.hPow.{0, 0, 0} Real Nat Real
                              (@instHPow.{0, 0} Real Nat (@Monoid.toNatPow.{0} Real Real.instMonoid)) y
                              (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))))
                          (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))))))
```

### D010: `NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_3`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `1539b7249475d3cb62c71f58c3381f809dfbbaa7768f3f5ee2667e10c5ccb3ab`

Type:

```lean
∀ ⦃x : Real⦄,
  Set.instMembership.mem (Set.Ici 0) x →
    ∀ ⦃y : Real⦄,
      Set.instMembership.mem (Set.Ici 0) y →
        Real.instPreorder.le x y →
          Real.instPreorder.le (instHSub.hSub (Real.exp (instHPow.hPow x 2)) 1)
            (instHSub.hSub (Real.exp (instHPow.hPow y 2)) 1)
```

Fully explicit type:

```lean
∀ ⦃x : Real⦄
  (hx :
    @Membership.mem.{0, 0} Real (Set.{0} Real) (@Set.instMembership.{0} Real)
      (@Set.Ici.{0} Real Real.instPreorder (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
      x)
  ⦃y : Real⦄
  (hy :
    @Membership.mem.{0, 0} Real (Set.{0} Real) (@Set.instMembership.{0} Real)
      (@Set.Ici.{0} Real Real.instPreorder (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
      y)
  (hxy : @LE.le.{0} Real (@Preorder.toLE.{0} Real Real.instPreorder) x y),
  @LE.le.{0} Real (@Preorder.toLE.{0} Real Real.instPreorder)
    (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub)
      (Real.exp
        (@HPow.hPow.{0, 0, 0} Real Nat Real (@instHPow.{0, 0} Real Nat (@Monoid.toNatPow.{0} Real Real.instMonoid)) x
          (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))))
      (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
    (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub)
      (Real.exp
        (@HPow.hPow.{0, 0, 0} Real Nat Real (@instHPow.{0, 0} Real Nat (@Monoid.toNatPow.{0} Real Real.instMonoid)) y
          (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))))
      (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
```

### D011: `NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_4`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `fe19a2a55f70f3bb4ac2ece3bbade7d49c4ba6ae4032f549c1653927f63a90bd`

Type:

```lean
Eq (instHSub.hSub (Real.exp (instHPow.hPow 0 2)) 1) 0
```

Fully explicit type:

```lean
@Eq.{1} Real
  (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub)
    (Real.exp
      (@HPow.hPow.{0, 0, 0} Real Nat Real (@instHPow.{0, 0} Real Nat (@Monoid.toNatPow.{0} Real Real.instMonoid))
        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
        (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))))
    (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
  (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
```

### D012: `NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction._proof_5`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `afca12ca14c44e714b4fa1d1039ee4cb9046130e43a1b4c5595121249aa53d14`

Type:

```lean
Filter.Tendsto (fun x => instHSub.hSub (Real.exp (instHPow.hPow x 2)) 1) Filter.atTop Filter.atTop
```

Fully explicit type:

```lean
@Filter.Tendsto.{0, 0} Real Real
  (fun (x : Real) =>
    @HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub)
      (Real.exp
        (@HPow.hPow.{0, 0, 0} Real Nat Real (@instHPow.{0, 0} Real Nat (@Monoid.toNatPow.{0} Real Real.instMonoid)) x
          (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2)))))
      (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)))
  (@Filter.atTop.{0} Real Real.instPreorder) (@Filter.atTop.{0} Real Real.instPreorder)
```

### D013: `NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4f1687485723a974ed9cab43fdef69a8440eb7a69d4115c1e0c81c855ba7a04a`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (t : ENNReal) → Prop
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

### D014: `NumStability.HDP.Scalar.SubExponential.orliczAdmissible`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f65d65c4bb2bc6af96f31133b7108a7cd6da39bc62235826b3414cb3acebc2aa`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    NumStability.HDP.Scalar.SubExponential.OrliczFunction → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (t : ENNReal) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ X t =>
  And (Ne t 0)
    (And (Ne t instTopENNReal.top)
      (ENNReal.instPartialOrder.le (NumStability.HDP.Scalar.SubExponential.orliczIntegral ψ μ X t) 1))
```

### D015: `NumStability.HDP.Scalar.SubGaussian.EvenMomentBound._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `fef4d74723af9a6d7cf7c292c7b48e3b0af82ddf7aeae726a620f1d8bd2ee9db`

Type:

```lean
(instHAdd.hAdd 1 1).AtLeastTwo
```

Fully explicit type:

```lean
Nat.AtLeastTwo
  (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat)
    (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))
    (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
```

### D016: `NumStability.HDP.Scalar.SubExponential.orliczIntegral`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `1e58bed46a5006c5764654d44fa3890b54901b3fa56b0da0b7297fcfce6f2bb9`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    NumStability.HDP.Scalar.SubExponential.OrliczFunction → MeasureTheory.Measure Ω → (Ω → Real) → ENNReal → ENNReal
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (t : ENNReal) → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ X t =>
  MeasureTheory.lintegral μ fun ω => ENNReal.ofReal (ψ.toFun (instHDiv.hDiv (abs (X ω)) t.toReal))
```

### D017: `NumStability.HDP.Scalar.SubExponential.OrliczFunction.toFun`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D018: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5b8f4d61311ebccecf6a54ceca44191d394e0108c8596129a77f03c15a7e457f`

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
WithTop NNReal
```

### D019: `ENNReal.instPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f07a664eb470c37e8c5abcad62d27fe4145f686c6a6a132fa775fdf14e92b68e`

Type:

```lean
PartialOrder ENNReal
```

Fully explicit type:

```lean
PartialOrder.{0} ENNReal
```

Definition body (one-level semantic boundary):

```lean
inferInstanceAs (PartialOrder (WithTop NNReal))
```

### D020: `Iff`

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

### D021: `LT.lt`

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

### D022: `Measurable`

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

### D023: `MeasurableSpace`

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

### D024: `MeasureTheory.IsProbabilityMeasure`

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

### D025: `MeasureTheory.Measure`

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

### D026: `PartialOrder.toPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `079686fa1ec6d596bcdb475c56a12b7f5a0594bf346c64220c2c992e0f0aae3b`

Type:

```lean
{α : Type u_2} → [self : PartialOrder α] → Preorder α
```

Fully explicit type:

```lean
{α : Type u_2} → [self : PartialOrder.{u_2} α] → Preorder.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PartialOrder α] => self.1
```

### D027: `Preorder.toLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `8fcf5a8f5a8899408a8cdc310bc44f6f7b84a21905a114103fbc65083f779a43`

Type:

```lean
{α : Type u_2} → [self : Preorder α] → LT α
```

Fully explicit type:

```lean
{α : Type u_2} → [self : Preorder.{u_2} α] → LT.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Preorder α] => self.2
```

### D028: `Real`

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

### D029: `Real.measurableSpace`

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

### D030: `Top.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Notation`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `32c978930b5eb9164add86b32aeacdc99d2d10df09b4b1989d12a6e346774504`

Type:

```lean
{α : Type u_1} → [self : Top α] → α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : Top.{u_1} α] → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Top α] => self.1
```

### D031: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `fc363bb86fd9c29e754e22d842cff17acbad13559cb0e03d31f4863045cd3c07`

Type:

```lean
Top ENNReal
```

Fully explicit type:

```lean
Top.{0} ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.top
```

### D032: `CompleteLinearOrder.toConditionallyCompleteLinearOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2aa802d0a9c75bf33917e1e0dc266a90886d32f434f1d43521c53f0f2c3449d0`

Type:

```lean
{α : Type u_5} → [h : CompleteLinearOrder α] → ConditionallyCompleteLinearOrderBot α
```

Fully explicit type:

```lean
{α : Type u_5} → [h : CompleteLinearOrder.{u_5} α] → ConditionallyCompleteLinearOrderBot.{u_5} α
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

### D033: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `41576e47c21e72ff272622fb2a65e2858beda94a321ffdbc1128f58d338ee803`

Type:

```lean
{α : Type u_1} → [ConditionallyCompleteLattice α] → ConditionallyCompletePartialOrder α
```

Fully explicit type:

```lean
{α : Type u_1} → [ConditionallyCompleteLattice.{u_1} α] → ConditionallyCompletePartialOrder.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : ConditionallyCompleteLattice α] =>
  { toPartialOrder := inst.toSemilatticeInf.toPartialOrder, toSupSet := inst.toSupSet, isLUB_csSup_of_directed := ⋯,
    toInfSet := inst.toInfSet, isGLB_csInf_of_directed := ⋯ }
```

### D034: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e1dad077d30ec2d5da19d9c26f0e709993b8eda004ce89d1f4086cf5f98094d5`

Type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrder α] → ConditionallyCompleteLattice α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrder.{u_5} α] → ConditionallyCompleteLattice.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompleteLinearOrder α] => self.1
```

### D035: `ConditionallyCompleteLinearOrderBot.toConditionallyCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `b25be2d55c4d466d6295ab5ff23a5cc915072a7d1cbc04c476d877743ce32dd9`

Type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrderBot α] → ConditionallyCompleteLinearOrder α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : ConditionallyCompleteLinearOrderBot.{u_5} α] → ConditionallyCompleteLinearOrder.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompleteLinearOrderBot α] => self.1
```

### D036: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `50e56dbfc6cb715ad5708fddc559a96fd43e4d11b7a8a33061c6cf440f5fc10c`

Type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrder α] → ConditionallyCompletePartialOrderInf α
```

Fully explicit type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrder.{u_3} α] → ConditionallyCompletePartialOrderInf.{u_3} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toPartialOrder := self.toPartialOrder, toInfSet := self.toInfSet, isGLB_csInf_of_directed := ⋯ }
```

### D037: `ConditionallyCompletePartialOrderInf.toInfSet`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `182c2ddbb044a41025806b24afd62f570b4197b3450b566022615ea4646e06cd`

Type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrderInf α] → InfSet α
```

Fully explicit type:

```lean
{α : Type u_3} → [self : ConditionallyCompletePartialOrderInf.{u_3} α] → InfSet.{u_3} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : ConditionallyCompletePartialOrderInf α] => self.2
```

### D038: `ENNReal.instCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2436cc4a7fc332a26b2b8879178b290fffb6ceaad2c2210667170bdf3119d835`

Type:

```lean
CompleteLinearOrder ENNReal
```

Fully explicit type:

```lean
CompleteLinearOrder.{0} ENNReal
```

Definition body (one-level semantic boundary):

```lean
inferInstanceAs (CompleteLinearOrder (WithTop NNReal))
```

### D039: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D040: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D041: `InfSet.sInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.SetNotation`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `76c82ed45915e35439b105eb3ec239e1937b2a2eafff41b96f451468dd90c61d`

Type:

```lean
{α : Type u_1} → [self : InfSet α] → Set α → α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : InfSet.{u_1} α] → Set.{u_1} α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : InfSet α] => self.1
```

### D042: `Monoid.toNatPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D043: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D044: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D045: `One.toOfNat1`

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

### D046: `Real.exp`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Complex.Exponential`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `69806b1af98b09fabed435ccc47a9f2f0840f9c5c140fb62cccc81a80761a984`

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
fun x => (Complex.exp (Complex.ofReal x)).re
```

### D047: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D048: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D049: `Real.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `926d9e8fcca2819a885d446e168b20c7c8aac2e542d59ed2b48e32c9a4659a36`

Type:

```lean
Sub Real
```

Fully explicit type:

```lean
Sub.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ sub := fun a b => instHAdd.hAdd a (Real.instNeg.neg b) }
```

### D050: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D051: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D052: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D053: `setOf`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `cee4433aebd78c308ec85f62ccd30489c00ec9cc23a98f4d2139c17f840f4988`

Type:

```lean
{α : Type u} → (α → Prop) → Set α
```

Fully explicit type:

```lean
{α : Type u} → (p : α → Prop) → Set.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} p => p
```

### D054: `AddCommMagma.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `78a12fabc3611bc39705a2dcf3fa82ed1f226d804e888d57546b885fefae4453`

Type:

```lean
{G : Type u} → [self : AddCommMagma G] → Add G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommMagma.{u} G] → Add.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : AddCommMagma G] => self.1
```

### D055: `AddCommMonoid.toAddCommSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `dc7cae9f3611bf7a48fc6ba815db5cffeba3ac95ae33d26bec77b827bd041f26`

Type:

```lean
{M : Type u} → [self : AddCommMonoid M] → AddCommSemigroup M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddCommMonoid.{u} M] → AddCommSemigroup.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toAddSemigroup := self.toAddSemigroup, add_comm := ⋯ }
```

### D056: `AddCommMonoidWithOne.toAddMonoidWithOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `07f48d3cfc3c7c30b6298df8531409d9844ab8c7e0ba94dea2a3fd29879320af`

Type:

```lean
{R : Type u_2} → [self : AddCommMonoidWithOne R] → AddMonoidWithOne R
```

Fully explicit type:

```lean
{R : Type u_2} → [self : AddCommMonoidWithOne.{u_2} R] → AddMonoidWithOne.{u_2} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : AddCommMonoidWithOne R] => self.1
```

### D057: `AddCommSemigroup.toAddCommMagma`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `78f90c6bc01ad86e28d84a9011670656947204c6d8963785407a1b8eb54844ab`

Type:

```lean
{G : Type u} → [self : AddCommSemigroup G] → AddCommMagma G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommSemigroup.{u} G] → AddCommMagma.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toAdd := self.toAdd, add_comm := ⋯ }
```

### D058: `AddMonoidWithOne.toOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `2ee638fd7292dbcf1e4adb85b14bbd0f304e8a260316e61621bf8eac03f03f6d`

Type:

```lean
{R : Type u_2} → [self : AddMonoidWithOne R] → One R
```

Fully explicit type:

```lean
{R : Type u_2} → [self : AddMonoidWithOne.{u_2} R] → One.{u_2} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : AddMonoidWithOne R] => self.3
```

### D059: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D060: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D061: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D062: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D063: `Convex`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Convex.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `2238e1a5ca2c20cf2395c6094aa639851a95e2eb264bd3cb7469e76faabca38c`

Type:

```lean
(𝕜 : Type u_1) → {E : Type u_2} → [Semiring 𝕜] → [PartialOrder 𝕜] → [AddCommMonoid E] → [SMul 𝕜 E] → Set E → Prop
```

Fully explicit type:

```lean
(𝕜 : Type u_1) →
  {E : Type u_2} →
    [Semiring.{u_1} 𝕜] →
      [PartialOrder.{u_1} 𝕜] → [AddCommMonoid.{u_2} E] → [SMul.{u_1, u_2} 𝕜 E] → (s : Set.{u_2} E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 {E} [Semiring 𝕜] [PartialOrder 𝕜] [AddCommMonoid E] [SMul 𝕜 E] s =>
  ∀ ⦃x : E⦄, Set.instMembership.mem s x → StarConvex 𝕜 x s
```

### D064: `ConvexOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Convex.Function`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D065: `Distrib.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `cf0362fc4cebf4743d0430077ad4081a1de510a75cfe1b4e6adc97f21271a3ba`

Type:

```lean
{R : Type u_1} → [self : Distrib R] → Add R
```

Fully explicit type:

```lean
{R : Type u_1} → [self : Distrib.{u_1} R] → Add.{u_1} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Distrib R] => self.2
```

### D066: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D067: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `1aa070f54e8aff7a6558c977220472990963777ddc5f04c5284f49422c06b41f`

Type:

```lean
ENNReal → Real
```

Fully explicit type:

```lean
(a : ENNReal) → Real
```

Definition body (one-level semantic boundary):

```lean
fun a => a.toNNReal.toReal
```

### D068: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

Fully explicit type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D069: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D070: `Filter.atTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.AtTopBot.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D071: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAdd α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HAdd.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAdd α β γ] => self.1
```

### D072: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D073: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D074: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D075: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D076: `LinearOrder.toPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.LinearOrder`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `5ec22f8a95e43df1b8411d4bb55670f23b3856a01ee60f251ae3929b5badc979`

Type:

```lean
{α : Type u_2} → [self : LinearOrder α] → PartialOrder α
```

Fully explicit type:

```lean
{α : Type u_2} → [self : LinearOrder.{u_2} α] → PartialOrder.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : LinearOrder α] => self.1
```

### D077: `MeasureTheory.Integrable`

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

### D078: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D079: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `941ea3346e809f919727c21bfcdeea342714a6b83f1cf871d648aa2cb14d6e9e`

Type:

```lean
{α : outParam (Type u)} → {γ : Type v} → [self : Membership α γ] → γ → α → Prop
```

Fully explicit type:

```lean
{α : outParam.{u + 2} (Type u)} → {γ : Type v} → [self : Membership.{u, v} α γ] → γ → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} γ [self : Membership α γ] => self.1
```

### D080: `MonotoneOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Monotone.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D081: `MulZeroClass.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `a3f3ff8a43fb45098d9029196fe0a081ace6a8cc0c485317c7c17e719ec29c60`

Type:

```lean
{M₀ : Type u} → [self : MulZeroClass M₀] → Zero M₀
```

Fully explicit type:

```lean
{M₀ : Type u} → [self : MulZeroClass.{u} M₀] → Zero.{u} M₀
```

Definition body (one-level semantic boundary):

```lean
fun M₀ [self : MulZeroClass M₀] => self.2
```

### D082: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D083: `NonAssocSemiring.toAddCommMonoidWithOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `6e4c898b19286580a5053df0525278998daaf3b1687c7526ed8df20324dc7aa0`

Type:

```lean
{α : Type u} → [self : NonAssocSemiring α] → AddCommMonoidWithOne α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonAssocSemiring.{u} α] → AddCommMonoidWithOne.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toNatCast := self.toNatCast, toAddMonoid := self.toAddMonoid, toOne := self.toOne, natCast_zero := ⋯,
    natCast_succ := ⋯, add_comm := ⋯ }
```

### D084: `NonAssocSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `1674e66231d0f66dfe9fae191c7ae33207a78635bcf5490a9cfbb402d16f9bc0`

Type:

```lean
{α : Type u} → [self : NonAssocSemiring α] → NonUnitalNonAssocSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonAssocSemiring.{u} α] → NonUnitalNonAssocSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonAssocSemiring α] => self.1
```

### D085: `NonUnitalNonAssocSemiring.toDistrib`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `5b49ec28e539eea6192ab07a9aee6da537ed1b5e017f2b9ef44d3a0ae51d79c6`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → Distrib α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring.{u} α] → Distrib.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toMul := self.toMul, toAdd := self.toAdd, left_distrib := ⋯, right_distrib := ⋯ }
```

### D086: `NonUnitalNonAssocSemiring.toMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `87ddc8012963f013675a2d3b6dbd069bd2e6eeeafa9e7aff6d92bfbf7d848152`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → MulZeroClass α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring.{u} α] → MulZeroClass.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toMul := self.toMul, toZero := self.toZero, zero_mul := ⋯, mul_zero := ⋯ }
```

### D087: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D088: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D089: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D090: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D091: `Preorder.toLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `a2229e231e0928e24fffee5432201e35fadad80e7f6e4738e0d251c3c01a4676`

Type:

```lean
{α : Type u_2} → [self : Preorder α] → LE α
```

Fully explicit type:

```lean
{α : Type u_2} → [self : Preorder.{u_2} α] → LE.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Preorder α] => self.1
```

### D092: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D093: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D094: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D095: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D096: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D097: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D098: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D099: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D100: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D101: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D102: `Real.linearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f9047b32ccb57072950d165d85fa407659039ec6ac3d859d4f35ab0efe02a4d9`

Type:

```lean
LinearOrder Real
```

Fully explicit type:

```lean
LinearOrder.{0} Real
```

Definition body (one-level semantic boundary):

```lean
Lattice.toLinearOrder Real
```

### D103: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D104: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D105: `Real.partialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D106: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D107: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D108: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D109: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D110: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D111: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `33076e5ce1b65d0dacdacdea942f424abbe54f3ff639c158f37c0f533984f227`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonAssocSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : Semiring.{u} α] → NonAssocSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toNonUnitalNonAssocSemiring := self.toNonUnitalNonAssocSemiring, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯,
    toNatCast := self.toNatCast, natCast_zero := ⋯, natCast_succ := ⋯ }
```

### D112: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `a6e551515032966c16e4f42e4548ff1854c2dce05ffe51e98b66943caecc78ec`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

Definition body (one-level semantic boundary):

```lean
fun α => α → Prop
```

### D113: `Set.Ici`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D114: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `5858be77d319c5a0e238602f16818ed6fb2e2b52a81ff7edb07bc219d652f201`

Type:

```lean
{α : Type u} → Membership α (Set α)
```

Fully explicit type:

```lean
{α : Type u} → Membership.{u, u} α (Set.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { mem := Set.Mem }
```

### D115: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D116: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D117: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Type:

```lean
{α : Type u_1} → [Add α] → HAdd α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Add.{u_1} α] → HAdd.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Add α] => { hAdd := fun a b => inst.add a b }
```

### D118: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D119: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D120: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `37355febc51d6fa8ff12fc8e7b429771db340390d46411d7608c566bdffd358d`

Type:

```lean
{R : Type u_1} → {n : Nat} → [NatCast R] → [n.AtLeastTwo] → OfNat R n
```

Fully explicit type:

```lean
{R : Type u_1} → {n : Nat} → [NatCast.{u_1} R] → [Nat.AtLeastTwo n] → OfNat.{u_1} R n
```

Definition body (one-level semantic boundary):

```lean
fun {R} {n} [NatCast R] [n.AtLeastTwo] => { ofNat := n.cast }
```

### D121: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `6e5878abb65d5809d3258e569c8ff0f08b39804b377a07fec18d700b4e3fea86`

Type:

```lean
Zero ENNReal
```

Fully explicit type:

```lean
Zero.{0} ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.zero
```

### D122: `Nat.AtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Init`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `318e11b8f9340f2f451d638786dd4fca470dece62824f4adc3bd18b5289aa911`

Type:

```lean
Nat → Prop
```

Fully explicit type:

```lean
(n : Nat) → Prop
```

### D123: `instAddCommMonoidWithOneENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `31d9551885e3007e5d1368365622cfd7638ea41cc6d885234041621de873f55c`

Type:

```lean
AddCommMonoidWithOne ENNReal
```

Fully explicit type:

```lean
AddCommMonoidWithOne.{0} ENNReal
```

Definition body (one-level semantic boundary):

```lean
WithTop.addCommMonoidWithOne
```

### D124: `instAddNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `a1534bcd3e1888406ac787d30eeff8a284cb6688c23f5e8de09351dda91a280c`

Type:

```lean
Add Nat
```

Fully explicit type:

```lean
Add.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
{ add := Nat.add }
```

### D125: `ENNReal.ofReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `ed3ef7ee60e47d07da43d414f4f32aa69df50f614988267eebc1025b2bef657d`

Type:

```lean
Real → ENNReal
```

Fully explicit type:

```lean
(r : Real) → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun r => ENNReal.ofNNReal r.toNNReal
```

### D126: `MeasureTheory.lintegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Lebesgue.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `e34294e65599ea3bdb2f1120ae912ae07a22313a7b238e200c71ae3b882cdb09`

Type:

```lean
{α : Type u_4} → {m : MeasurableSpace α} → MeasureTheory.Measure α → (α → ENNReal) → ENNReal
```

Fully explicit type:

```lean
{α : Type u_4} → {m : MeasurableSpace.{u_4} α} → (μ : @MeasureTheory.Measure.{u_4} α m) → (f : α → ENNReal) → ENNReal
```

Definition body (one-level semantic boundary):

```lean
MeasureTheory.wrapped✝.1
```

### D127: `Real.instAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `f0de8cbc2c873a19be749cd9b2d3cc9a6edb9ebc92020a1877714a50c23d9dc0`

Type:

```lean
AddGroup Real
```

Fully explicit type:

```lean
AddGroup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D128: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `5bccf78d647cf08233ff548c19523f80b1d1bf11b5a76aa50396199e2c0c7510`

Type:

```lean
Lattice Real
```

Fully explicit type:

```lean
Lattice.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D129: `abs`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Group.Unbundled.Abs`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `8ec55bade8dee4d49822a9bdbd84db24c019b8d568452329d9766390229a9c1b`

Type:

```lean
{α : Type u_1} → [Lattice α] → [AddGroup α] → α → α
```

Fully explicit type:

```lean
{α : Type u_1} → [Lattice.{u_1} α] → [AddGroup.{u_1} α] → (a : α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Lattice α] [AddGroup α] a =>
  SemilatticeSup.toMax.max a (SubtractionMonoid.toSubNegZeroMonoid.toNegZeroClass.neg a)
```
