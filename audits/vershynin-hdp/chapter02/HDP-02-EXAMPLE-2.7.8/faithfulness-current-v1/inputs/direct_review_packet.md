# Declaration dossier for HDP-02-EXAMPLE-2.7.8

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem hdp_02_hexample_h2_d7_d8 :
    hdp_02_hexample_h2_d7_d8__contract_type
```

## Elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hexample_h2_d7_d8__contract_type
```

## Fully explicit elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hexample_h2_d7_d8__contract_type.{u_1, u_2}
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example08.Signature`
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
- `ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein` imports: `Mathlib.Probability.Independence.Integration`, `Mathlib.Probability.Moments.Basic`, `Mathlib.Probability.Moments.IntegrableExpMul`, `Mathlib.Analysis.Complex.ExponentialBounds`, `Mathlib.Tactic`, `ComputationalMathematics.HDP.Scalar.SubExponential`
- `ComputationalMathematics.HDP.Scalar.SubExponentialCharacterization` imports: `ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein`
- `ComputationalMathematics.HDP.Scalar.SubGaussianToSubExponential` imports: `ComputationalMathematics.HDP.Scalar.SubExponentialCharacterization`
- `ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw` imports: `Mathlib.Probability.Combinatorics.BinomialRandomGraph.Defs`, `Mathlib.Combinatorics.SimpleGraph.Finite`, `Mathlib.Probability.HasLaw`, `Mathlib.Probability.ProbabilityMassFunction.Binomial`, `Mathlib.Tactic`
- `ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff` imports: `Mathlib.Probability.Combinatorics.BinomialRandomGraph.Defs`, `Mathlib.Combinatorics.SimpleGraph.Finite`, `Mathlib.Probability.ProbabilityMassFunction.Integrals`, `Mathlib.Probability.HasLaw`, `Mathlib.Probability.Independence.Integration`, `Mathlib.Probability.Distributions.Poisson`, `Mathlib.MeasureTheory.Integral.Lebesgue.Countable`, `Mathlib.Analysis.Asymptotics.AsymptoticEquivalent`, `Mathlib.Analysis.SpecialFunctions.Stirling`, `Mathlib.Analysis.Complex.ExponentialBounds`, `Mathlib.Tactic`, `ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding`, `ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw`
- `ComputationalMathematics.HDP.Scalar.IndependentSums.PoissonChernoff` imports: `ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff`, `Mathlib.MeasureTheory.Integral.Bochner.Set`
- `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic` imports: `Mathlib.Probability.ProbabilityMassFunction.Binomial`, `Mathlib.Probability.ProbabilityMassFunction.Integrals`, `Mathlib.Probability.Distributions.Gaussian.Real`, `Mathlib.Probability.Distributions.Poisson`, `Mathlib.MeasureTheory.Function.ConvergenceInDistribution`, `Mathlib.Probability.StrongLaw`, `Mathlib.Tactic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.Equation05.Contract` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.PoissonDistribution.Contract` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter01.VarianceOfSum.Contract` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- `ComputationalMathematics.HDP.Scalar.LimitTheorems` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`, `ComputationalMathematics.Source.Vershynin.Chapter01.Equation05.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.PoissonDistribution.Contract`, `ComputationalMathematics.Source.Vershynin.Chapter01.VarianceOfSum.Contract`
- `ComputationalMathematics.HDP.Scalar.CentralLimit` imports: `ComputationalMathematics.HDP.Scalar.LimitTheorems`, `Mathlib.Analysis.Calculus.Taylor`, `Mathlib.MeasureTheory.Measure.CharacteristicFunction`, `Mathlib.MeasureTheory.Measure.Prokhorov`, `Mathlib.MeasureTheory.Measure.TightNormed`, `Mathlib.Probability.Independence.CharacteristicFunction`
- `ComputationalMathematics.HDP.Scalar.PoissonLimit` imports: `ComputationalMathematics.HDP.Scalar.CentralLimit`, `ComputationalMathematics.HDP.Scalar.Preliminaries`, `Mathlib.Analysis.SpecialFunctions.Complex.LogBounds`
- `ComputationalMathematics.HDP.Scalar.PoissonNormal` imports: `ComputationalMathematics.HDP.Scalar.IndependentSums.PoissonChernoff`, `ComputationalMathematics.HDP.Scalar.PoissonLimit`, `Mathlib.Probability.HasLawExists`
- `ComputationalMathematics.Analysis.FiniteProbability` imports: `Mathlib.Data.Real.Basic`, `Mathlib.Analysis.Calculus.Deriv.MeanValue`, `Mathlib.Analysis.Convex.Jensen`, `Mathlib.Analysis.SpecialFunctions.ExpDeriv`, `Mathlib.Analysis.SpecialFunctions.Log.Basic`, `Mathlib.Analysis.SpecialFunctions.Log.Deriv`, `Mathlib.Algebra.BigOperators.Group.Finset.Basic`, `Mathlib.Algebra.Order.BigOperators.Group.Finset`, `Mathlib.Tactic.FieldSimp`, `Mathlib.Tactic.Linarith`, `Mathlib.Tactic.Ring`
- `ComputationalMathematics.HDP.Scalar.SubExponentialExamples` imports: `ComputationalMathematics.HDP.Scalar.SubExponential`, `ComputationalMathematics.HDP.Scalar.PoissonNormal`, `ComputationalMathematics.Analysis.FiniteProbability`
- `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example08.Signature` imports: `ComputationalMathematics.HDP.Scalar.SubGaussianToSubExponential`, `ComputationalMathematics.HDP.Scalar.SubExponentialExamples`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Contract.hdp_02_hexample_h2_d7_d8__contract_type`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example08.Signature`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `554a728f60df253ecf78cc2e796e0232e9ab5ab7221a5676f910eeb16e9e7f06`

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
And
  (∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] {μ : MeasureTheory.Measure Ω} [MeasureTheory.IsProbabilityMeasure μ]
    {X : Ω → Real},
    (Exists fun i =>
        And (Ne i NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF)
          (Exists fun K =>
            And (Real.instLT.lt 0 K) (NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K))) →
      Exists fun K =>
        And (Real.instLT.lt 0 K)
          (NumStability.HDP.Scalar.SubExponential.SubExponentialProperty μ X
            NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment K))
  (And
    (∀ {Ω : Type u_2} [inst : MeasurableSpace Ω] {μ : MeasureTheory.Measure Ω} {X : Ω → Real},
      Measurable X →
        And
          (Iff
            (ENNReal.instPartialOrder.lt
              (NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ fun ω => instHPow.hPow (X ω) 2) instTopENNReal.top)
            (ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X) instTopENNReal.top))
          (Eq (NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ fun ω => instHPow.hPow (X ω) 2)
            (instHPow.hPow (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X) 2)))
    (And
      (∀ (lambda : Real),
        Real.instLT.lt 0 lambda →
          And (Eq (MeasureTheory.integral (ProbabilityTheory.expMeasure lambda) fun x => x) (instHDiv.hDiv 1 lambda))
            (And
              (Eq (ProbabilityTheory.variance (fun x => x) (ProbabilityTheory.expMeasure lambda))
                (instHDiv.hDiv 1 (instHPow.hPow lambda 2)))
              (Eq (NumStability.HDP.Scalar.SubExponential.PsiOneGauge (ProbabilityTheory.expMeasure lambda) fun x => x)
                (ENNReal.ofReal (instHDiv.hDiv 2 lambda)))))
      (∀ (rate : NNReal),
        ENNReal.instPartialOrder.lt
          (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
            (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate) fun x => x)
          instTopENNReal.top)))
```

### D002: `NumStability.HDP.Contract.hdp_02_hexample_h2_d7_d8__contract_type._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example08.Signature`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `f13204b278de727fedcf9321d46d43e8ad7f502087875c544503ae9d8653984f`

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

### D003: `NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.PoissonLimit`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6abc90cc45ef5a768567bccf8acec8c7c624533cd1c6934ff378b394e5e6e2db`

Type:

```lean
NNReal → MeasureTheory.Measure Real
```

Fully explicit type:

```lean
(rate : NNReal) → @MeasureTheory.Measure.{0} Real Real.measurableSpace
```

Definition body (one-level semantic boundary):

```lean
fun rate => MeasureTheory.Measure.map (fun k => k.cast) (NumStability.HDP.Scalar.LimitTheorems.poissonLaw rate)
```

### D004: `NumStability.HDP.Scalar.SubExponential.PsiOneGauge`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3d859747551c6ef18201963a8406b806380f89fcd58184ee9c6d96dae97b7bf4`

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
    (setOf fun t => NumStability.HDP.Scalar.SubExponential.PsiOneAdmissible μ X t)
```

### D005: `NumStability.HDP.Scalar.SubExponential.SubExponentialProperty`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e3f3c6631a38c943eaf45e54fecd04d8bf04074de5a238c6b7e0da748de671d4`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    MeasureTheory.Measure Ω →
      (Ω → Real) → NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
      (X : Ω → Real) → NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X x =>
  NumStability.HDP.Scalar.SubExponential.SubExponentialProperty.match_1 (fun x => Real → Prop) x
    (fun _ => NumStability.HDP.Scalar.SubExponential.SubExponentialTailBound μ X)
    (fun _ => NumStability.HDP.Scalar.SubExponential.SubExponentialMomentBound μ X)
    (fun _ => NumStability.HDP.Scalar.SubExponential.SubExponentialAbsoluteMGFLocal μ X) fun _ =>
    NumStability.HDP.Scalar.SubExponential.SubExponentialOnePointMGF μ X
```

### D006: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `8b992d2356f005258e7e4083f1ce0d146d478e7006f7446ab61d86db7bb5ee85`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

### D007: `NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `c81a60a904843ef883b553397d53b96fedc04c2aeefd9d5412e0840155eb0b48`

Hash-verified prior declaration review:

- Reuse SHA-256: `3b1f2a16983fbca03426d42cdf52e91ff4d676d3bb52ad2fae341722c567ea90`
- Reviewed interpretation: The psi_2 gauge is the infimum of all admissible extended-nonnegative scales.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D008: `NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9af80f41e98a57fc68d89265bdc9d76b7d9db03197c96b4974bd8aa1c88cfd5b`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    MeasureTheory.Measure Ω → (Ω → Real) → NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
      (X : Ω → Real) → NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind → Real → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X x =>
  NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty.match_1 (fun x => Real → Prop) x
    (fun _ => NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBound μ X)
    (fun _ => NumStability.HDP.Scalar.SubGaussian.SubGaussianMomentBound μ X)
    (fun _ => NumStability.HDP.Scalar.SubGaussian.SubGaussianSquareWindow μ X)
    (fun _ => NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePoint μ X) fun _ =>
    NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ X
```

### D009: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `3d62ece3e0d569f5f4b53f6b80af09f322581777aa3b3bea81e4c045b2cd06f3`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D010: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `92e98114b0fdd0314006b45b43da4acd769668c69ebdae52751074f7d7a479bc`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D011: `NumStability.HDP.Scalar.LimitTheorems.poissonLaw`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2055aecc7628f3c712e0ded569de464eac96aed637780dc60ad0dd362a55595b`

Type:

```lean
NNReal → MeasureTheory.Measure Nat
```

Fully explicit type:

```lean
(rate : NNReal) → @MeasureTheory.Measure.{0} Nat Nat.instMeasurableSpace
```

Definition body (one-level semantic boundary):

```lean
fun rate => ProbabilityTheory.poissonMeasure rate
```

### D012: `NumStability.HDP.Scalar.SubExponential.PsiOneAdmissible`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ea01b81abef7c041f7ae6dc9fe8bf139864e4d775796da1b34b401a1dd7fe7a0`

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
        (And (MeasureTheory.Integrable (fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) t.toReal)) μ)
          (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) t.toReal)) 2))))
```

### D013: `NumStability.HDP.Scalar.SubExponential.SubExponentialAbsoluteMGFLocal`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5571acb71e16670b8738120db74a53bfa0a88d4cba391bd27062dee6c029603c`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
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

### D014: `NumStability.HDP.Scalar.SubExponential.SubExponentialMomentBound`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `096fcdf2438a87d986e02a93fd3b08ea17b47b9ac2acd469d8e344d80b9100aa`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X) (And (Real.instLT.lt 0 K) (NumStability.HDP.Scalar.SubExponential.LpMomentGrowth μ X K))
```

### D015: `NumStability.HDP.Scalar.SubExponential.SubExponentialOnePointMGF`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `928b93dfd114c2ff5dd79dad80848588a78524cacf664bbcc60bb1568d075ae2`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X)
    (And (Real.instLT.lt 0 K)
      (And (MeasureTheory.Integrable (fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) K)) μ)
        (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHDiv.hDiv (abs (X ω)) K)) 2)))
```

### D016: `NumStability.HDP.Scalar.SubExponential.SubExponentialProperty.match_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `53f3f1aad66ac2692b26bbc30e146143cd99b0495818c924286acd3e9024219e`

Type:

```lean
(motive : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind → Sort u_1) →
  (x : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind) →
    (Unit → motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.tail) →
      (Unit → motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment) →
        (Unit → motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.absoluteMGF) →
          (Unit → motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.onePoint) → motive x
```

Fully explicit type:

```lean
(motive : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind → Sort u_1) →
  (x : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind) →
    (h_1 : (a : Unit) → motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.tail) →
      (h_2 : (a : Unit) → motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment) →
        (h_3 : (a : Unit) → motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.absoluteMGF) →
          (h_4 : (a : Unit) → motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.onePoint) →
            motive x
```

Definition body (one-level semantic boundary):

```lean
fun motive x h_1 h_2 h_3 h_4 =>
  NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.casesOn x (h_1 Unit.unit) (h_2 Unit.unit)
    (h_3 Unit.unit) (h_4 Unit.unit)
```

### D017: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `0d27bdcf20c59f88781ed5441a4d84bc1cbf9c7a346af3d5a4bc15cfc173b80c`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D018: `NumStability.HDP.Scalar.SubExponential.SubExponentialTailBound`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `99219b2ffe314561a5cca0399ebd56204dabc64a608e062e0645ebc960c8f0b5`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
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

### D019: `NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4f1687485723a974ed9cab43fdef69a8440eb7a69d4115c1e0c81c855ba7a04a`

Hash-verified prior declaration review:

- Reuse SHA-256: `6bbeb56dcced2584c0d567947b2940fce64139f6b9d84e38289f13850df8b964`
- Reviewed interpretation: A scale t is admissible when X is measurable, t is neither zero nor infinity, exp(X^2/t^2) is integrable, and its integral is at most 2.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D020: `NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a413a1f0073031463d7097ee7fe27c565b8ce5f37779f8af8c1d0e59c5108529`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
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

### D021: `NumStability.HDP.Scalar.SubGaussian.SubGaussianMomentBound`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `71835d61ff71ed629cd795901033d5d0cffb7980f12f4e2aa06e454275ca37fa`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ X K =>
  And (Measurable X) (And (Real.instLT.lt 0 K) (NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth μ X K))
```

### D022: `NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty.match_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `268fd1b5fb7c674b08009f2d1da25c11f97f760cd1bbfc296abcdbf12b44c2d8`

Type:

```lean
(motive : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind → Sort u_1) →
  (x : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind) →
    (Unit → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail) →
      (Unit → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment) →
        (Unit → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squareWindow) →
          (Unit → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint) →
            (Unit → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF) → motive x
```

Fully explicit type:

```lean
(motive : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind → Sort u_1) →
  (x : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind) →
    (h_1 : (a : Unit) → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail) →
      (h_2 : (a : Unit) → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment) →
        (h_3 : (a : Unit) → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squareWindow) →
          (h_4 : (a : Unit) → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint) →
            (h_5 : (a : Unit) → motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF) → motive x
```

Definition body (one-level semantic boundary):

```lean
fun motive x h_1 h_2 h_3 h_4 h_5 =>
  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.casesOn x (h_1 Unit.unit) (h_2 Unit.unit) (h_3 Unit.unit)
    (h_4 Unit.unit) (h_5 Unit.unit)
```

### D023: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `abcb039876ae2af0e95e3346a3c41120bed1276a4aeeaf4f0551d6108cc34c10`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D024: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `2a2a991a1479686aeaad7d7ed347f92342d5815ffd26815136b73d38cb6a9175`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D025: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squareWindow`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `50691cbacef241882eb7915a00d5314c980f3e5565ebc7d4aeff52861b905c9e`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D026: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `487c45f3c43f7ee3eaea19d51d787fc11ee88a618b376a38c47199913701b33f`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D027: `NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePoint`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `e2e89f5cadf98be6e7ecc8da0f387fae10ac3ec6df2f879655fa56b7c2b6cc62`

Hash-verified prior declaration review:

- Reuse SHA-256: `47d485883e72a2e92f308978ccf4f70ae7346bbde81f1808e14bbb1fc7d6ebe8`
- Reviewed interpretation: At a positive real scale K, X is measurable, exp(X^2/K^2) is integrable, and its integral is at most 2.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D028: `NumStability.HDP.Scalar.SubGaussian.SubGaussianSquareWindow`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `00cb4ab2711fbfc2672a769a68bec1c2aa94d7101c6798d9c1ad76f9d6af6314`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
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

### D029: `NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBound`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `87e4f6ed7b607804e5be8bd00afa44c9c28d579fc351d93f350e98ebdf3a86aa`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
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

### D030: `NumStability.HDP.Scalar.SubExponential.LpMomentGrowth`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `355ba4c74783fad6a07946e242d887b87f39b93ac077847c2a5f97c89c3009a9`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
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

### D031: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.absoluteMGF`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `3010e7755cd3eb0a263a72d165e512a8777997c3edbc0290017c0ea6cd47faf2`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

### D032: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.casesOn`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `26bcf8b2b149d4aaa06b72880a22286b74416a6879321f5b03860f0305c4d285`

Type:

```lean
{motive : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind → Sort u} →
  (t : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind) →
    motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.tail →
      motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment →
        motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.absoluteMGF →
          motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.onePoint → motive t
```

Fully explicit type:

```lean
{motive : (t : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind) → Sort u} →
  (t : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind) →
    (tail : motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.tail) →
      (moment : motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment) →
        (absoluteMGF : motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.absoluteMGF) →
          (onePoint : motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.onePoint) → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t tail moment absoluteMGF onePoint =>
  NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.rec tail moment absoluteMGF onePoint t
```

### D033: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.onePoint`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `4256a71721c795e42fa3a2de2f2af9a11e635f5c73859c930ce36aa4bc56a948`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

### D034: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.tail`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `b42ade2b9a413f3f3dc9cc836f3c06dc9102a6b71cc93e994d656e21e2447fe2`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

### D035: `NumStability.HDP.Scalar.SubExponential.SubExponentialTailBound._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `4934bbb512eccb02c1641f048c14b3ff39131d21c58e5b1cee312a6acea390f4`

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

### D036: `NumStability.HDP.Scalar.SubGaussian.EvenMomentBound._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `fef4d74723af9a6d7cf7c292c7b48e3b0af82ddf7aeae726a620f1d8bd2ee9db`

Hash-verified prior declaration review:

- Reuse SHA-256: `a18eaacb317eb01611bb6e3e9606f9e3e6407a313938d630ec418ff7db10e13f`
- Reviewed interpretation: A generated witness that the numeral 2 satisfies the at-least-two requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D037: `NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `27212c252b4cbc0c4077a27221ec6493869f40f2ee89b7ce691df61914f2d8ec`

Type:

```lean
{Ω : Type u_1} → [inst : MeasurableSpace Ω] → MeasureTheory.Measure Ω → (Ω → Real) → Real → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] → (μ : @MeasureTheory.Measure.{u_1} Ω inst) → (X : Ω → Real) → (K : Real) → Prop
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

### D038: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.casesOn`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `bd5f25a0c13561d8ecf28a958c6b4aa0848653d5532385076c3d4d0a9a996623`

Type:

```lean
{motive : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind → Sort u} →
  (t : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind) →
    motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail →
      motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment →
        motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squareWindow →
          motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint →
            motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF → motive t
```

Fully explicit type:

```lean
{motive : (t : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind) → Sort u} →
  (t : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind) →
    (tail : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail) →
      (moment : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment) →
        (squareWindow : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squareWindow) →
          (squarePoint : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint) →
            (linearMGF : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF) → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t tail moment squareWindow squarePoint linearMGF =>
  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.rec tail moment squareWindow squarePoint linearMGF t
```

### D039: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.rec`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `recursor`
- Distance from target type: `5`
- Semantic SHA-256: `0161f5200912949f7a6926576322453515b498ea8dfeeaf6763e615e7c9a2d41`

Type:

```lean
{motive : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind → Sort u} →
  motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.tail →
    motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment →
      motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.absoluteMGF →
        motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.onePoint →
          (t : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind) → motive t
```

Fully explicit type:

```lean
{motive : (t : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind) → Sort u} →
  (tail : motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.tail) →
    (moment : motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment) →
      (absoluteMGF : motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.absoluteMGF) →
        (onePoint : motive NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.onePoint) →
          (t : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind) → motive t
```

### D040: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.rec`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubGaussian`
- Declaration kind: `recursor`
- Distance from target type: `5`
- Semantic SHA-256: `63f2a8c086cb19398dee2a0114f6c7aca22876ff0a2ba59d6ee2494e579ed8f1`

Type:

```lean
{motive : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind → Sort u} →
  motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail →
    motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment →
      motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squareWindow →
        motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint →
          motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF →
            (t : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind) → motive t
```

Fully explicit type:

```lean
{motive : (t : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind) → Sort u} →
  (tail : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail) →
    (moment : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment) →
      (squareWindow : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squareWindow) →
        (squarePoint : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint) →
          (linearMGF : motive NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF) →
            (t : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind) → motive t
```

### D041: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `767713b03c1612093177953a6ddd8c7dc4a130e2de1bec4fe0fe575344b7e608`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{R : Type u} → [self : CommSemiring.{u} R] → Semiring.{u} R
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

- Reuse SHA-256: `9cdab2b073b99d25b1e748f871bce5d95b4ed951094c47e00f01ff5e39fce3c7`
- Reviewed interpretation: It supplies ordinary division from the real multiplicative structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D044: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5b8f4d61311ebccecf6a54ceca44191d394e0108c8596129a77f03c15a7e457f`

Hash-verified prior declaration review:

- Reuse SHA-256: `61340299af9df9fd2d28b8d594c463738b385605d8d58982d07d34782bb92950`
- Reviewed interpretation: The extended nonnegative reals, represented as nonnegative reals with a top element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
CommSemiring.{0} ENNReal
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

Fully explicit type:

```lean
PartialOrder.{0} ENNReal
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

- Reuse SHA-256: `e0984c163d5dd3ddc9f118b429252668738df703c49768648d3d25a571df88ef`
- Reviewed interpretation: It embeds the nonnegative part of a real into the extended nonnegative reals.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D048: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `8fa9a7bb65416926620e39ddb700cbe7c514457d9143f508b5c0f4ab080013b3`
- Reviewed interpretation: Propositional equality.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D049: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `a309a70e852aed7d4e79f8b81494cd0b8efa4c718f88eb61dc664ca710037e51`
- Reviewed interpretation: Existential quantification.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D050: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Hash-verified prior declaration review:

- Reuse SHA-256: `3dc0c7b70f2a890187b645fbdcca5409ae03959b9ecc680b62732f1f72890d3c`
- Reviewed interpretation: Heterogeneous division resolved here as ordinary real division.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D051: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6196b8cbb884c4f39841ba74b23d75f3c753fe0d044cc402bd6e4e3bd59d5cb8`

Hash-verified prior declaration review:

- Reuse SHA-256: `eef616f4825d5b3d4f9185fd12705f0ce95e80c8a3c79f412c2aa87779df6ca6`
- Reviewed interpretation: Heterogeneous exponentiation, resolved as natural powers for squares and real rpow for the lower factor.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D053: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `683435a8d27d50ec1482d74d23f541d52d05ff0411c60f88d16c32132aca9f3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `4b5c46361f6ef1ab1134b52404488a164bed446822161e8dff41c87f9e2aa969`
- Reviewed interpretation: Canonical extraction of a normed-space structure from an inner-product space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D054: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Hash-verified prior declaration review:

- Reuse SHA-256: `796fd6074ce9b60a750d874ef9b4773df8403e5bc5b2f5203cc01a49f653702e`
- Reviewed interpretation: The strict order relation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D055: `Measurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6d56983cd98232a62c5c1b4a0368519a8b381777b32b6e8301ade2ccd7f4c3a4`

Hash-verified prior declaration review:

- Reuse SHA-256: `7d40a01edf6953cfb3a434a7a42427ffa1f8cf29fb5f31e6076453bb219d38a0`
- Reviewed interpretation: Preimages of measurable sets are measurable.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D056: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Hash-verified prior declaration review:

- Reuse SHA-256: `45930f6256175f04bb99bb010f4b867b129ed6c41506e35585bfc0ce7d1b8ad2`
- Reviewed interpretation: A sigma-algebra structure on the sample type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D057: `MeasureTheory.IsProbabilityMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `f88b269cb95d165125e7553fd22f97d6e5f9b1b9bcdec7f6738a781dc674bf89`

Hash-verified prior declaration review:

- Reuse SHA-256: `7b47209f505ee8d7081283f39ac00ba7e05147485050ac409a24e5e9b1af1635`
- Reviewed interpretation: The measure of the whole space is one.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D058: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Hash-verified prior declaration review:

- Reuse SHA-256: `382d06e2dcf6ea820987ddca11190d07bfc931d8d2d6870c51af2c1d2c2c7e6f`
- Reviewed interpretation: A countably additive measure on a measurable space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D059: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `428563f3d6b771605a3267457bf33b62ec2efa91a42b57b96121b85c0269a9ab`

Hash-verified prior declaration review:

- Reuse SHA-256: `6ac0b22ef6faab7ee964483fd3e1d8c7879c78036e74585210e5b42f8bbf0fae`
- Reviewed interpretation: The Bochner integral with respect to mu.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D060: `Monoid.toNatPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5b7373fe2de26535c1cdbf1b953ce34faf30f68aac8abd83ade2e78e6ec65b8a`

Hash-verified prior declaration review:

- Reuse SHA-256: `63b695b6b667017a5a7f9b3f3a644f95f678bbcc6998ec7113e5851b058be40c`
- Reviewed interpretation: Natural-number exponentiation in a monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{M₀ : Type u} → [self : MonoidWithZero.{u} M₀] → Monoid.{u} M₀
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

Fully explicit type:

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

- Reuse SHA-256: `909bcc91658c7334e64fd3b4e2145cbdfcfca80f31e40d617b19340c4be36b1d`
- Reviewed interpretation: The natural numbers.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D064: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `635adc1f9e4a981a5c01b21338fdf89e637bd4ef0aa6911bda4dc03acfe9fba6`

Hash-verified prior declaration review:

- Reuse SHA-256: `04afbc1767e58873a2670763cbd904fd75c138997ec1219c6aa6c2cb09f0e827`
- Reviewed interpretation: Inequality, defined as negated equality.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D065: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7327759e5e9417c54393e7566584cd72d79c77b4ca018ea408c5d024667587be`

Hash-verified prior declaration review:

- Reuse SHA-256: `3086294a3f8c0d5c545ccf12778f761feb1451d33ab3e73184977e5dae8aa455`
- Reviewed interpretation: Canonical weakening of a normed additive group to a seminormed additive group.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D066: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `3cafc4a270b9550e157627e4b5fc2d09b5d165dfbf185c1855014e0349a997a3`
- Reviewed interpretation: Interpretation of natural-number literals in a target type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D067: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `cc544b5b2a2aabc84389a9fe2f052127dc6dae9964782b117b9b19b773e542d5`

Hash-verified prior declaration review:

- Reuse SHA-256: `b115d5beb417bcc1a9c8ddbb0d7bb5ad905c80575a609335edad1f591bf48e16`
- Reviewed interpretation: The canonical numeral-one instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{α : Type u_2} → [self : PartialOrder.{u_2} α] → Preorder.{u_2} α
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

Fully explicit type:

```lean
{α : Type u_2} → [self : Preorder.{u_2} α] → LT.{u_2} α
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

Fully explicit type:

```lean
(r : Real) → @MeasureTheory.Measure.{0} Real Real.measurableSpace
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

- Reuse SHA-256: `e5dab3c66f373c18d4615266bc314aa03d553f36df35901372feecae574159a9`
- Reviewed interpretation: The real value of the extended variance of a real random variable under mu.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D072: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f602276baee30d3dbe02bd6b756a9097f750d59a7f91ca7635dcfc935fd22981`

Hash-verified prior declaration review:

- Reuse SHA-256: `458b489e456ab3d7d3cdf949d156b6ee6094a8a2f762c591d53ce7f9d0018019`
- Reviewed interpretation: The canonical real inner-product structure on an RCLike scalar type, instantiated at Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D073: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `0862c747094f895c12ab64f70a21687d7e575dcf56e973506f927b497669ede3`
- Reviewed interpretation: The real number type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D074: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `166f2abb65bf1271e5e8d70fdb78c55672c7e366b30439e83b517f803cdefac3`

Hash-verified prior declaration review:

- Reuse SHA-256: `39bb4422c1edc871acaf081ec47aa5180e9f35909856336a7056064f2ebe6142`
- Reviewed interpretation: The ordinary real multiplication, inverse, and division structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D075: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Hash-verified prior declaration review:

- Reuse SHA-256: `57a2eba5df06d1d4a08ca0c4a2f83939152e325a94f9bc4e3fd712960e21ddc7`
- Reviewed interpretation: The usual strict order on reals.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D076: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Hash-verified prior declaration review:

- Reuse SHA-256: `00695de755231b26c50052aa9d21617f26e120d11065dfcd5d781c9f01e386d3`
- Reviewed interpretation: The multiplicative monoid structure of the reals.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D077: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5fc7a7becbc71d472fa1a28bd92d79b4c6ea4fdc643db7380031a2b890ca7e15`

Hash-verified prior declaration review:

- Reuse SHA-256: `8461649dcd0615ebe2f72b992c7b53909d78892c30b8b6fe324da3afe016af01`
- Reviewed interpretation: The canonical embedding of natural numbers into reals.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D078: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b4e24b050b7fb50c4c115c51d5cd4c1b180cae53633f58a38c7d5ce3ccf86c81`

Hash-verified prior declaration review:

- Reuse SHA-256: `9a44b3170a5c31239f6c01c238825eb4c0438573fce6760d83652d2ebb4822f1`
- Reviewed interpretation: The real multiplicative identity.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D079: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `d2fdb97b9d861fcf61e6dbea9993dfa0ca6aa16609742f215c35b3f7ddd16b8e`

Hash-verified prior declaration review:

- Reuse SHA-256: `cadc77a10c66f0c36a68182f007c772ce3e753fe1aa3cede08e053086633b441`
- Reviewed interpretation: The standard RCLike structure on the real numbers.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D080: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `9d60b3c494bbfffee9d104dd8454abd91ae3a4cee40bd1231ad2e8168f9cf838`
- Reviewed interpretation: The real additive identity.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D081: `Real.measurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `51b107725c4edbe40e50ff5651a2c7ee5a10037e341c2764964a6d6cc26d82a1`

Hash-verified prior declaration review:

- Reuse SHA-256: `e2a3c745a9534f8cce02f3991d022eb42c7d66077c2a9e3d2621c675992cbca3`
- Reviewed interpretation: The Borel measurable space on the reals.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D082: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9ff0d896c635e2a38531d689d24ee70cfffa41565354ce15f6ff59b51650bd93`

Hash-verified prior declaration review:

- Reuse SHA-256: `829d900d0cd18b5b4b54a5a85ee6997ffda322e5d792e6620ee9891d8abd3427`
- Reviewed interpretation: The usual normed additive commutative group of reals.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{α : Type u} → [self : Semiring.{u} α] → MonoidWithZero.{u} α
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

- Reuse SHA-256: `e9fa9bb452296a761fe25cd78758667924e0170952f7b672f7e436fff595fb5d`
- Reviewed interpretation: The greatest element of a type with top.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D085: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `3e6d8fa4935de097cfe574a72cc152b64527b919351e01dd6a0157c0b85836ed`
- Reviewed interpretation: The canonical numeral-zero instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D086: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Hash-verified prior declaration review:

- Reuse SHA-256: `a8d890fa93d105a46b83c751bb148ca3cc82a4613e7102e61f7df3827b00e562`
- Reviewed interpretation: It turns ordinary division into homogeneous heterogeneous division.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D087: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb300d353d84392c776cad5e356479f878030744a43f9a1584942a89d16350b4`

Hash-verified prior declaration review:

- Reuse SHA-256: `411d118a62349a59c287a31a2a6db5f2596c22df63ca35b5faf9ed0f79d95f90`
- Reviewed interpretation: It turns a power operation into overloaded exponentiation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D088: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `37355febc51d6fa8ff12fc8e7b429771db340390d46411d7608c566bdffd358d`

Hash-verified prior declaration review:

- Reuse SHA-256: `5dcdbefbbd0c7aae5368bf3fadafe447d28c44973b17f3fa34cfef16d2c0a8bb`
- Reviewed interpretation: It embeds a natural numeral at least two into a type with a natural-number cast.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D089: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `7018dea92aae8c272f3a065f25e2bedb9732a0b602c3d54b166fa0cf2ce1ea92`

Hash-verified prior declaration review:

- Reuse SHA-256: `7d6120f4b5bc35c13bf6fc189462539796270b0dc09a9a08cd19abd6bd09750f`
- Reviewed interpretation: The natural numeral n denotes n itself in Nat.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D090: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `fc363bb86fd9c29e754e22d842cff17acbad13559cb0e03d31f4863045cd3c07`

Hash-verified prior declaration review:

- Reuse SHA-256: `54d829ad79155b0ccbfcc15fac8d587ee4b3c997bca9f4ffabbbb74e00db9ef2`
- Reviewed interpretation: The top element of ENNReal is infinity.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D091: `CompleteLinearOrder.toConditionallyCompleteLinearOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2aa802d0a9c75bf33917e1e0dc266a90886d32f434f1d43521c53f0f2c3449d0`

Hash-verified prior declaration review:

- Reuse SHA-256: `6c231de92a6fb0512f96d67b0c1a003804df0130a4e830dd8511df3a26bec42b`
- Reviewed interpretation: Canonical conditionally complete order-with-bottom structure derived from a complete linear order.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D092: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `41576e47c21e72ff272622fb2a65e2858beda94a321ffdbc1128f58d338ee803`

Hash-verified prior declaration review:

- Reuse SHA-256: `dfefdb3bdbaa9d10a7e3336ddb9ed4ba429a10581f259a954b2e642fb583f8fe`
- Reviewed interpretation: Canonical partial-order view of a conditionally complete lattice.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D093: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e1dad077d30ec2d5da19d9c26f0e709993b8eda004ce89d1f4086cf5f98094d5`

Hash-verified prior declaration review:

- Reuse SHA-256: `f9eb063a498fc49daf105aa1d93d3ce670b6c404200b4fe70a961b5d1b4738de`
- Reviewed interpretation: Canonical lattice structure underlying a conditionally complete linear order.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D094: `ConditionallyCompleteLinearOrderBot.toConditionallyCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `b25be2d55c4d466d6295ab5ff23a5cc915072a7d1cbc04c476d877743ce32dd9`

Hash-verified prior declaration review:

- Reuse SHA-256: `bc965067603503450d6d918ec44a3e3fb9d9694305bf2c2dc49143f758d07ccc`
- Reviewed interpretation: Canonical forgetting of the bottom element from a conditionally complete linear order with bottom.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D095: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `50e56dbfc6cb715ad5708fddc559a96fd43e4d11b7a8a33061c6cf440f5fc10c`

Hash-verified prior declaration review:

- Reuse SHA-256: `eb431d7f209f0b7a361c6c4075550252134a692c68a4fae2d9214f76f19775a7`
- Reviewed interpretation: Canonical infimum-capable structure from a conditionally complete partial order.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D096: `ConditionallyCompletePartialOrderInf.toInfSet`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `182c2ddbb044a41025806b24afd62f570b4197b3450b566022615ea4646e06cd`

Hash-verified prior declaration review:

- Reuse SHA-256: `9a3326de32c0e8f143a9492b3fcc5d9e72db8214738737b0e8827ada9aac4e10`
- Reviewed interpretation: Extraction of the set-infimum operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D097: `ENNReal.instCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2436cc4a7fc332a26b2b8879178b290fffb6ceaad2c2210667170bdf3119d835`

Hash-verified prior declaration review:

- Reuse SHA-256: `e15a3f642d54c61a00f910aaf4d935c3fc72dd132d89342120686c6873ea8412`
- Reviewed interpretation: The complete linear order on extended nonnegative reals.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D098: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `91a8d957e28c0abe65ec245bd1e91d3945f826a97545a790078055ef8f73b3f2`
- Reviewed interpretation: Heterogeneous addition resolved here as ordinary addition.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D099: `InfSet.sInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.SetNotation`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `76c82ed45915e35439b105eb3ec239e1937b2a2eafff41b96f451468dd90c61d`

Hash-verified prior declaration review:

- Reuse SHA-256: `61c75191f1b40e4a7fe3fd284aaaccfea7b2c067f5e312b63799d7bbfa75e206`
- Reviewed interpretation: The infimum of a set.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{α : Type u_4} →
  {β : Type u_5} →
    [inst : MeasurableSpace.{u_4} α] →
      [inst_1 : MeasurableSpace.{u_5} β] →
        (f : α → β) → (μ : @MeasureTheory.Measure.{u_4} α inst) → @MeasureTheory.Measure.{u_5} β inst_1
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

- Reuse SHA-256: `19238c35e84c52899dfe09fdb90e85fdb969600a3d202bcda5cded99651438b0`
- Reviewed interpretation: A proposition witnessing that a natural number is at least two.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{R : Type u} → [NatCast.{u} R] → Nat → R
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

Fully explicit type:

```lean
MeasurableSpace.{0} Nat
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

Fully explicit type:

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

- Reuse SHA-256: `3f0e2c8437f1b554960924189d679d2193923a7aa8852e26d2540d114fa3aba6`
- Reviewed interpretation: Ordinary addition on natural numbers.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D106: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `a18001a6635681e01a607dc1e4c1d0a4ce496c831f18e6fc38109b05bf299515`
- Reviewed interpretation: It turns ordinary addition into homogeneous heterogeneous addition.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D107: `setOf`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `cee4433aebd78c308ec85f62ccd30489c00ec9cc23a98f4d2139c17f840f4988`

Hash-verified prior declaration review:

- Reuse SHA-256: `456fb2eda32bbd5fe2c3eb8cd35897443300a524ce7ed163cb2dd1698451bbe2`
- Reviewed interpretation: The set specified by a predicate.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D108: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `1aa070f54e8aff7a6558c977220472990963777ddc5f04c5284f49422c06b41f`

Hash-verified prior declaration review:

- Reuse SHA-256: `2a16efa1198c49071dce07d33288f2f8013bd82a27fb6ff42bcab8da7de442a5`
- Reviewed interpretation: It maps a finite extended nonnegative real to its real value and maps infinity by the library convention.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{α : Type u} → [LE.{u} α] → (a b : α) → Prop
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

- Reuse SHA-256: `3ac12a276f2cc9399d248911f0d0fdf982973177249b0d820a5bdf2e4de89472`
- Reviewed interpretation: Heterogeneous multiplication resolved here as ordinary real multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{α : Type u} → [self : Inv.{u} α] → α → α
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

- Reuse SHA-256: `25a8fdec0df1ba7eef8abf988efc0e55b77aacd7da1c96cf3be32d6cf8f86c00`
- Reviewed interpretation: The non-strict order relation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D113: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `51e5158e8f2f2a375463d510858200b96afa04fb8f33126da2c5d1c572a76165`

Hash-verified prior declaration review:

- Reuse SHA-256: `2c4e47c65c6dd4764e74fc6911d004986974d3805c046f7ad3cc43ac279c7e22`
- Reviewed interpretation: Strong almost-everywhere measurability together with finite integral norm.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{α : Type u_6} → {m : MeasurableSpace.{u_6} α} → (μ : @MeasureTheory.Measure.{u_6} α m) → (s : Set.{u_6} α) → Real
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

- Reuse SHA-256: `a4dbdbbfd25065974d8ac6d555a469f3fddab9eb16a375225f0b9ee3cbb14626`
- Reviewed interpretation: Ordinary additive negation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D116: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `b536eea8cdcaef63e99080282c4a177887e32982b19b63b9a9339dfd107c0eec`
- Reviewed interpretation: Canonical forgetting of commutativity in a seminormed ring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D117: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `3656864e7da0b21bdf668a1a2cba5e2983d006f79eb59c4f03e888a6a1f1897a`
- Reviewed interpretation: Canonical additive seminormed structure obtained from a seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D118: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `e69e399830931bdc7b36cd03b558bebd8bc5888f5c40ed5b8d7d1ee61d4847c1`
- Reviewed interpretation: Canonical weakening of a normed commutative ring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
(r : NNReal) → @MeasureTheory.Measure.{0} Nat Nat.instMeasurableSpace
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

- Reuse SHA-256: `32ef5645d2bd6d7e93d954a2b8dfec5d20dfd69cab45da7bcef972f8514b70e7`
- Reviewed interpretation: Canonical uniform structure associated to a pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D121: `Real.exp`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Complex.Exponential`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `69806b1af98b09fabed435ccc47a9f2f0840f9c5c140fb62cccc81a80761a984`

Hash-verified prior declaration review:

- Reuse SHA-256: `140ff9ecc832105d68fa8d64d462cad2c3db2240b3c84abedf3c358d7dcd1dbb`
- Reviewed interpretation: The ordinary real exponential function.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
AddGroup.{0} Real
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

Fully explicit type:

```lean
Inv.{0} Real
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

- Reuse SHA-256: `d5a63658e4caacf3e4e949c94168df5d2dfaf3940169bf33e44cb945c62eb15c`
- Reviewed interpretation: The usual non-strict order on reals.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D125: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Hash-verified prior declaration review:

- Reuse SHA-256: `844ce38f46238047f503eb15c210b7dba26075e3541e97a5d9100141d0fac973`
- Reviewed interpretation: Ordinary real multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D126: `Real.instNeg`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `000951397468b3d1f8a2a1cca1de3812bc024916ff842cfd5454811130093b41`

Hash-verified prior declaration review:

- Reuse SHA-256: `ca467407ca28aa1a5bcb596a4a6f6e0e83a1138327f6ea575267f425813a6997`
- Reviewed interpretation: Ordinary real negation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
Lattice.{0} Real
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

- Reuse SHA-256: `77bc6acd97718a68cf23d0b464abba2cd170987dde44b1d366b42999edfc49d6`
- Reviewed interpretation: The usual normed commutative ring structure on reals.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D129: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `4e2df2372bbb8ac9235d70eeecc66586f2f969fcd9d5990f2b8c1993cd8c816c`
- Reviewed interpretation: The usual metric structure induced by real absolute difference.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D130: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `8cf35215f509cdee10a3a95158cbaadd3c5fb584bc0d1f4fad6ecfc69b1bd205`

Hash-verified prior declaration review:

- Reuse SHA-256: `005d6744ab280330419830db22a5bfddeab962a64bd2684c54e1aaab8039a74c`
- Reviewed interpretation: Canonical forgetting of commutativity from a seminormed additive group.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D131: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `17a83cbf3059dd0bbaefd43c93ce329f1d6b760d440889322b3582a18b23a141`

Hash-verified prior declaration review:

- Reuse SHA-256: `1ba469ffd2a50eb023be368aa17ad887c1d7b8de7401f180c01900e0ed060b78`
- Reviewed interpretation: The extended norm is continuous on a seminormed additive group.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D132: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `e1a9ad181f643bc9a908590f41ddebb2776d1cc2ba16a636927297a505122660`
- Reviewed interpretation: Canonical weakening of a seminormed commutative ring structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D133: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Hash-verified prior declaration review:

- Reuse SHA-256: `a42c40cb34edaf145ae6f8ffaa2092957f93390e9b0cfd709242e41b6081eb80`
- Reviewed interpretation: The topology induced by a uniform space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

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

Fully explicit type:

```lean
{α : Type u_1} → [Lattice.{u_1} α] → [AddGroup.{u_1} α] → (a : α) → α
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

- Reuse SHA-256: `77e62ed623553517d2f8fa6027b7224629ff8d51bfac365d5e45b52f9174ad64`
- Reviewed interpretation: It turns ordinary multiplication into homogeneous heterogeneous multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D137: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `6e5878abb65d5809d3258e569c8ff0f08b39804b377a07fec18d700b4e3fea86`

Hash-verified prior declaration review:

- Reuse SHA-256: `70e074c7e5ed35a8619a29043c5d39e8a4802944d758c6dda4caa2d6929efffd`
- Reviewed interpretation: The zero element of ENNReal.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Fully explicit type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [MeasurableSpace.{u_2} β] →
      {_m : MeasurableSpace.{u_1} α} →
        (f : α → β) → (μ : autoParam.{u_1 + 1} (@MeasureTheory.Measure.{u_1} α _m) AEMeasurable._auto_1) → Prop
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

- Reuse SHA-256: `d754ee52bd2294a048097427a4ea414d447e403ea22a7142514683954ee382b8`
- Reviewed interpretation: Real exponentiation is Real.rpow.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D140: `Real.sqrt`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Sqrt`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `67f9248ae1acb851b5392be301057ebb8b8ef2fb20f76d2d53a2d07ec8f30553`

Hash-verified prior declaration review:

- Reuse SHA-256: `74299f13873a68650f3f0bf58f25e9b596791693e62110a2e7ed4f6c748267a1`
- Reviewed interpretation: The nonnegative real square root.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.
