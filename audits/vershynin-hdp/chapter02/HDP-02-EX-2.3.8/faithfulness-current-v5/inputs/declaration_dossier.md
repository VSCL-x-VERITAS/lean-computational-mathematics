# Declaration dossier for HDP-02-EX-2.3.8

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem hdp_02_hex_h2_d3_d8 :
    Tendsto standardizedPoissonLaw atTop
      (𝓝 (⟨standardNormalLaw, inferInstance⟩ : ProbabilityMeasure ℝ))
```

## Elaborated target type

```lean
Filter.Tendsto NumStability.HDP.Scalar.PoissonNormal.standardizedPoissonLaw Filter.atTop
  (nhds ⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw, ⋯⟩)
```

## Fully explicit elaborated target type

```lean
@Filter.Tendsto.{0, 0} NNReal (@MeasureTheory.ProbabilityMeasure.{0} Real Real.measurableSpace)
  NumStability.HDP.Scalar.PoissonNormal.standardizedPoissonLaw
  (@Filter.atTop.{0} NNReal (@PartialOrder.toPreorder.{0} NNReal instPartialOrderNNReal))
  (@nhds.{0} (@MeasureTheory.ProbabilityMeasure.{0} Real Real.measurableSpace)
    (@MeasureTheory.ProbabilityMeasure.instTopologicalSpace.{0} Real Real.measurableSpace
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@BorelSpace.opensMeasurable.{0} Real
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        Real.measurableSpace Real.borelSpace))
    (@Subtype.mk.{1} (@MeasureTheory.Measure.{0} Real Real.measurableSpace)
      (fun (μ : @MeasureTheory.Measure.{0} Real Real.measurableSpace) =>
        @MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableSpace μ)
      NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw
      (@inferInstance.{0}
        (@MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableSpace
          NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw)
        NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw.isProbabilityMeasure)))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Source.Vershynin.Chapter02.Section03.Exercise08.Signature`
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
- `ComputationalMathematics.Source.Vershynin.Chapter02.Section03.Exercise08.Signature` imports: `ComputationalMathematics.HDP.Scalar.PoissonNormal`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D002: `NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw.isProbabilityMeasure`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `be788e1824737a1355c8611422a366790189c72aa64acb157ac2c31a7f46d9aa`

Type:

```lean
MeasureTheory.IsProbabilityMeasure NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw
```

Fully explicit type:

```lean
@MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableSpace
  NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw
```

### D003: `NumStability.HDP.Scalar.PoissonNormal.standardizedPoissonLaw`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.PoissonNormal`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `49b3dec9af79b2d5f9700fce24cfb41608baa146f2e5abb937000f27cba983b0`

Type:

```lean
NNReal → MeasureTheory.ProbabilityMeasure Real
```

Fully explicit type:

```lean
(rate : NNReal) → @MeasureTheory.ProbabilityMeasure.{0} Real Real.measurableSpace
```

Definition body (one-level semantic boundary):

```lean
fun rate => (NumStability.HDP.Scalar.LimitTheorems.poissonRealProbabilityMeasure rate).map ⋯
```

### D004: `NumStability.HDP.Scalar.LimitTheorems.poissonRealProbabilityMeasure`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.PoissonLimit`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5362a78888315e727a813ff11e276068ed9ac37def9fb9cc2594fd9ed69c0fa2`

Type:

```lean
NNReal → MeasureTheory.ProbabilityMeasure Real
```

Fully explicit type:

```lean
(rate : NNReal) → @MeasureTheory.ProbabilityMeasure.{0} Real Real.measurableSpace
```

Definition body (one-level semantic boundary):

```lean
fun rate => ⟨NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate, ⋯⟩
```

### D005: `NumStability.HDP.Scalar.PoissonNormal.standardizedPoissonLaw._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.PoissonNormal`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `04346c53b0c91d63fcbf6292c19533aa9d99f741fe7bd4805aa456e03bb726bb`

Type:

```lean
∀ (rate : NNReal),
  AEMeasurable (fun x => instHMul.hMul (Real.instInv.inv rate.toReal.sqrt) (instHSub.hSub x rate.toReal))
    (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
```

Fully explicit type:

```lean
∀ (rate : NNReal),
  @AEMeasurable.{0, 0} Real Real Real.measurableSpace Real.measurableSpace
    (fun (x : Real) =>
      @HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
        (@Inv.inv.{0} Real Real.instInv (Real.sqrt (NNReal.toReal rate)))
        (@HSub.hSub.{0, 0, 0} Real Real Real (@instHSub.{0} Real Real.instSub) x (NNReal.toReal rate)))
    (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
```

### D006: `NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.PoissonLimit`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D007: `NumStability.HDP.Scalar.LimitTheorems.poissonRealProbabilityMeasure._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.PoissonLimit`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `f1af8b1ff9771cf4fa8c892feb2f33cc85136a93a82ffb48f0df70e7c32be426`

Type:

```lean
∀ (rate : NNReal), MeasureTheory.IsProbabilityMeasure (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
```

Fully explicit type:

```lean
∀ (rate : NNReal),
  @MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableSpace
    (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
```

### D008: `NumStability.HDP.Scalar.LimitTheorems.poissonLaw`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D009: `BorelSpace.opensMeasurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `6acf938e6357ef89d1bc3f75010c362bb331dde9c914e666f35c8e03dfc213ae`

Type:

```lean
∀ {α : Type u_6} [inst : TopologicalSpace α] [inst_1 : MeasurableSpace α] [BorelSpace α], OpensMeasurableSpace α
```

Fully explicit type:

```lean
∀ {α : Type u_6} [inst : TopologicalSpace.{u_6} α] [inst_1 : MeasurableSpace.{u_6} α] [@BorelSpace.{u_6} α inst inst_1],
  @OpensMeasurableSpace.{u_6} α inst inst_1
```

### D010: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D011: `Filter.atTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.AtTopBot.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D012: `MeasureTheory.IsProbabilityMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `f88b269cb95d165125e7553fd22f97d6e5f9b1b9bcdec7f6738a781dc674bf89`

Type:

```lean
{α : Type u_1} → {m0 : MeasurableSpace α} → MeasureTheory.Measure α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → {m0 : MeasurableSpace.{u_1} α} → (μ : @MeasureTheory.Measure.{u_1} α m0) → Prop
```

### D013: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

Fully explicit type:

```lean
(α : Type u_6) → [MeasurableSpace.{u_6} α] → Type u_6
```

### D014: `MeasureTheory.ProbabilityMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.ProbabilityMeasure`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `251bef2162749e0bcb67a1413765bc7556e9854c7a23036b986ada6a2e2958be`

Type:

```lean
(Ω : Type u_1) → [MeasurableSpace Ω] → Type u_1
```

Fully explicit type:

```lean
(Ω : Type u_1) → [MeasurableSpace.{u_1} Ω] → Type u_1
```

Definition body (one-level semantic boundary):

```lean
fun Ω [MeasurableSpace Ω] => Subtype fun μ => MeasureTheory.IsProbabilityMeasure μ
```

### D015: `MeasureTheory.ProbabilityMeasure.instTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.ProbabilityMeasure`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `1aa8a4788dac1eb1c7c37593eda0879e084867fd50c0929b411566ea03e51bfa`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    [inst_1 : TopologicalSpace Ω] → [OpensMeasurableSpace Ω] → TopologicalSpace (MeasureTheory.ProbabilityMeasure Ω)
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    [inst_1 : TopologicalSpace.{u_1} Ω] →
      [@OpensMeasurableSpace.{u_1} Ω inst_1 inst] →
        TopologicalSpace.{u_1} (@MeasureTheory.ProbabilityMeasure.{u_1} Ω inst)
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] [TopologicalSpace Ω] [OpensMeasurableSpace Ω] =>
  TopologicalSpace.induced MeasureTheory.ProbabilityMeasure.toFiniteMeasure inferInstance
```

### D016: `NNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.NNReal.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D017: `PartialOrder.toPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D018: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D019: `Real`

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

### D020: `Real.borelSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `c91eb70c9d98cdf73caa24b59211b7c41a3e77da5268598192e93a3c27346f6b`

Type:

```lean
BorelSpace Real
```

Fully explicit type:

```lean
@BorelSpace.{0} Real
  (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
  Real.measurableSpace
```

### D021: `Real.measurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D022: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D023: `Subtype.mk`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `488ac61b6d3c07fb9a2f54a03a39e6001a4c7cedfd07515f0f9865e7fef9ef51`

Type:

```lean
{α : Sort u} → {p : α → Prop} → (val : α) → p val → Subtype p
```

Fully explicit type:

```lean
{α : Sort u} → {p : α → Prop} → (val : α) → (property : p val) → @Subtype.{u} α p
```

### D024: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D025: `inferInstance`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a035e8579f88a0c5ce0a542c50396cd8f34aa652df8abeec2eb80c43a343b97b`

Type:

```lean
{α : Sort u} → [i : α] → α
```

Fully explicit type:

```lean
{α : Sort u} → [i : α] → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [i : α] => i
```

### D026: `instPartialOrderNNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.NNReal.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f4a763f4ba425a9513216d6fa2ff1928b1eb5120c77749230299df64cb590bb5`

Type:

```lean
PartialOrder NNReal
```

Fully explicit type:

```lean
PartialOrder.{0} NNReal
```

Definition body (one-level semantic boundary):

```lean
Subtype.partialOrder fun r => Real.instLE.le 0 r
```

### D027: `nhds`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8eb445823f4b15a765f7e0cd634f73196d36b4f09054d2aef43a69d3138c6ce8`

Type:

```lean
{X : Type u_3} → [TopologicalSpace X] → X → Filter X
```

Fully explicit type:

```lean
{X : Type u_3} → [TopologicalSpace.{u_3} X] → (x : X) → Filter.{u_3} X
```

Definition body (one-level semantic boundary):

```lean
wrapped✝.1
```

### D028: `HMul.hMul`

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

### D029: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D030: `Inv.inv`

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

### D031: `MeasureTheory.ProbabilityMeasure.map`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.ProbabilityMeasure`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `de45462ae98dbf7cf190c2eb3e9716470e0819afef6b4dfe783604f1c5b92867`

Type:

```lean
{Ω : Type u_1} →
  {Ω' : Type u_2} →
    [inst : MeasurableSpace Ω] →
      [inst_1 : MeasurableSpace Ω'] →
        (ν : MeasureTheory.ProbabilityMeasure Ω) →
          {f : Ω → Ω'} → AEMeasurable f ν.toMeasure → MeasureTheory.ProbabilityMeasure Ω'
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  {Ω' : Type u_2} →
    [inst : MeasurableSpace.{u_1} Ω] →
      [inst_1 : MeasurableSpace.{u_2} Ω'] →
        (ν : @MeasureTheory.ProbabilityMeasure.{u_1} Ω inst) →
          {f : Ω → Ω'} →
            (f_aemble :
                @AEMeasurable.{u_1, u_2} Ω Ω' inst_1 inst f
                  (@MeasureTheory.ProbabilityMeasure.toMeasure.{u_1} Ω inst ν)) →
              @MeasureTheory.ProbabilityMeasure.{u_2} Ω' inst_1
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} {Ω'} [MeasurableSpace Ω] [MeasurableSpace Ω'] ν {f} f_aemble => ⟨MeasureTheory.Measure.map f ν.toMeasure, ⋯⟩
```

### D032: `NNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.NNReal.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b78a80825150cf81a49e8914dd12c5dfb7e284ed0e70b3449011ac3d3f49dc66`

Type:

```lean
NNReal → Real
```

Fully explicit type:

```lean
NNReal → Real
```

Definition body (one-level semantic boundary):

```lean
Subtype.val
```

### D033: `OfNat.ofNat`

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

### D034: `One.toOfNat1`

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

### D035: `ProbabilityTheory.gaussianReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Distributions.Gaussian.Real`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D036: `Real.instInv`

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

### D037: `Real.instMul`

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

### D038: `Real.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D039: `Real.instZero`

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

### D040: `Real.sqrt`

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

### D041: `Zero.toOfNat0`

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

### D042: `instHMul`

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

### D043: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D044: `instOneNNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.NNReal.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D045: `AEMeasurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D046: `MeasureTheory.Measure.map`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Map`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D047: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D048: `Nat.cast`

- Role: `external-frontier`
- Owner module: `Init.Data.Cast`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D049: `Nat.instMeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Instances`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D050: `Real.instNatCast`

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

### D051: `ProbabilityTheory.poissonMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Distributions.Poisson`
- Declaration kind: `def`
- Distance from target type: `5`
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

## Complete local imported sources

### `ComputationalMathematics.HDP.Scalar.Preliminaries.Basic`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/Preliminaries/Basic.lean`
SHA-256: `01ddc83b097f7cc42f6b36266f7c80ddb8738d225f060e1d64546c41bffbab30`

```lean
import Mathlib.Probability.Moments.Variance
import Mathlib.Probability.CDF
import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Mathlib.MeasureTheory.Function.LpSpace.Complete
import Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm
import Mathlib.MeasureTheory.Function.LpSeminorm.Indicator
import Mathlib.Probability.UniformOn
import Mathlib.Analysis.Convex.Integral
import Mathlib.Analysis.Convex.Continuous
import Mathlib.MeasureTheory.Integral.Bochner.Set
import Mathlib.MeasureTheory.Integral.Lebesgue.Markov
import Mathlib.MeasureTheory.Integral.Layercake
import Mathlib.MeasureTheory.Measure.Lebesgue.Integral
import Mathlib.Probability.Distributions.Cauchy
import Mathlib.Analysis.SpecialFunctions.NonIntegrable
import Mathlib.Analysis.SpecialFunctions.Pow.Integral
import Mathlib.Tactic

/-!
# Expectation and variance

This module gives the Chapter 1, Section 1.1 source-facing bridge.  The
underlying expectation is the Bochner integral, while variance is the
expectation of the squared centered variable.  Integrability is made explicit
in the centered-variable API, since the textbook suppresses it.
-/

noncomputable section

open MeasureTheory
open Probability

namespace NumStability.HDP.Scalar.Preliminaries

/-- The distribution (pushforward law) of `X` under `μ`. -/
noncomputable def distribution {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : Measure ℝ :=
  Measure.map X μ

/-- The extended-real CDF of `X`, evaluated at `t`. -/
noncomputable def cdf {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ) : ENNReal :=
  distribution μ X (Set.Iic t)

/-- The extended-real upper tail probability of `X` at `t`. -/
noncomputable def upperTail {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ) : ENNReal :=
  distribution μ X (Set.Ioi t)

/-- The source-facing distribution, CDF, and upper-tail interface. -/
structure CDFTailModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) where
  /-- The stored real measure. -/
  distribution : Measure ℝ
  /-- The stored extended-real-valued CDF candidate. -/
  cdf : ℝ → ENNReal
  /-- The stored extended-real-valued upper-tail candidate. -/
  upperTail : ℝ → ENNReal

/-- Package the distribution, CDF, and upper-tail definitions for `X`. -/
noncomputable def cdfTailModel
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : CDFTailModelData μ X :=
  { distribution := distribution μ X
    cdf := cdf μ X
    upperTail := upperTail μ X }

/-- A measurable random variable pushes a probability measure to a probability law. -/
theorem distribution_isProbabilityMeasure
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : AEMeasurable X μ) :
    IsProbabilityMeasure (distribution μ X) := by
  exact Measure.isProbabilityMeasure_map hX

/-- The CDF is the probability of the corresponding lower half-line. -/
theorem cdf_eq_measure_preimage
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : AEMeasurable X μ) (t : ℝ) :
    cdf μ X t = μ (X ⁻¹' Set.Iic t) := by
  rw [cdf, distribution, Measure.map_apply_of_aemeasurable hX measurableSet_Iic]

/-- The upper tail is one minus the CDF under a probability measure. -/
theorem upperTail_eq_one_sub_cdf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : AEMeasurable X μ) (t : ℝ) :
    upperTail μ X t = 1 - cdf μ X t := by
  letI : IsProbabilityMeasure (distribution μ X) :=
    distribution_isProbabilityMeasure hX
  unfold upperTail cdf
  rw [← Set.compl_Iic]
  exact prob_compl_eq_one_sub measurableSet_Iic

/-- The CDF is monotone in its threshold. -/
theorem monotone_cdf
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    Monotone (cdf μ X) := by
  intro s t hst
  exact measure_mono (Set.Iic_subset_Iic.2 hst)

/-! The CDF uniqueness bridge for real probability laws. -/
theorem cdfDeterminesLaw
    {μ ν : Measure ℝ} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν] :
    (∀ t : ℝ, μ (Set.Iic t) = ν (Set.Iic t)) ↔ μ = ν := by
  constructor
  · intro h
    apply Measure.eq_of_cdf μ ν
    ext t
    rw [ProbabilityTheory.cdf_eq_real, ProbabilityTheory.cdf_eq_real]
    simpa [measureReal_def] using congrArg ENNReal.toReal (h t)
  · intro h t
    rw [h]

/-- The book's mean notation, represented by the Bochner integral. -/
def expectation {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ :=
  ∫ ω, X ω ∂μ

/-- The source notation `1_E`, represented as the real-valued indicator. -/
def indicatorFunction {Ω : Type*} [MeasurableSpace Ω]
    (E : Set Ω) : Ω → ℝ :=
  Set.indicator E (fun _ => 1)

/- The expectation identity is stated with `Measure.real`, the real-valued
  form of a measure, because the Bochner integral is real-valued. -/
theorem indicatorExpectation
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (E : Set Ω) (hE : MeasurableSet E) :
    expectation μ (indicatorFunction E) = μ.real E := by
  unfold expectation indicatorFunction
  exact integral_indicator_one hE

/-- Raw moments are restricted to natural exponents. -/
def rawMoment
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (n : ℕ) : ℝ :=
  expectation μ (fun ω => X ω ^ n)

/-- Positive-real moments use the absolute value before real exponentiation. -/
def absoluteMoment
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (p : ℝ) : ENNReal :=
  ∫⁻ ω, ENNReal.ofReal (Real.rpow |X ω| p) ∂μ

/-! The representative and quotient-level `Lᵖ` interface. -/
/-- Representative norms, membership, and quotient data for an `Lᵖ` space. -/
structure LpNormSpaceModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (p : ENNReal) where
  /-- The extended `Lᵖ` norm on representatives. -/
  representativeNorm : (Ω → ℝ) → ENNReal
  representativeNorm_eq : ∀ X, representativeNorm X = eLpNorm X p μ
  /-- The `MemLp` predicate on representatives. -/
  representativeMember : (Ω → ℝ) → Prop
  representativeMember_iff : ∀ X, representativeMember X ↔ MemLp X p μ
  /-- The Mathlib `Lᵖ` quotient carrier. -/
  quotient : AddSubgroup (Ω →ₘ[μ] ℝ)
  quotient_eq : quotient = MeasureTheory.Lp ℝ p μ

/-- Construct the canonical `Lᵖ` representative-and-quotient model. -/
def lpNormSpaceModel
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (p : ENNReal) : LpNormSpaceModelData μ p :=
  { representativeNorm := fun X => eLpNorm X p μ
    representativeNorm_eq := fun _ => rfl
    representativeMember := fun X => MemLp X p μ
    representativeMember_iff := fun _ => Iff.rfl
    quotient := MeasureTheory.Lp ℝ p μ
    quotient_eq := rfl }

/-- Finite raw moment predicate for a natural exponent. -/
def HasFiniteRawMoment
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (n : ℕ) : Prop :=
  Integrable (fun ω => X ω ^ n) μ

/-- Finite absolute moment predicate for a positive real exponent. -/
def HasFiniteAbsoluteMoment
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (p : ℝ) : Prop :=
  absoluteMoment μ X p < (⊤ : ENNReal)

/-- The nonnegative exponential integrand used by the extended MGF. -/
def exponentialIntegrand
    {α : Type*} (X : α → ℝ) (t : ℝ) : α → ℝ :=
  fun x => Real.exp (t * X x)

/-- The unconditional, extended-real moment generating function. -/
def mgf
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ) : ENNReal :=
  ∫⁻ ω, ENNReal.ofReal (exponentialIntegrand X t ω) ∂μ

/-- The parameter values at which the extended MGF is finite. -/
def mgfDomain
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : Set ℝ :=
  {t | mgf μ X t < (⊤ : ENNReal)}

/-- Exponential integrability permits the usual real-valued MGF notation. -/
def HasExponentialIntegrability
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ) : Prop :=
  Integrable (exponentialIntegrand X t) μ

/-- The real-valued MGF on an explicitly integrable parameter. -/
def realMgf
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ) : ℝ :=
  expectation μ (exponentialIntegrand X t)

/-- Source-facing extended and finite-real MGF interfaces. -/
structure MGFModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) where
  measurable : AEMeasurable X μ
  /-- The extended-real moment generating function. -/
  extended : ℝ → ENNReal
  extended_eq : ∀ t, extended t = mgf μ X t
  /-- The parameters where the extended MGF is finite. -/
  domain : Set ℝ
  domain_eq : domain = mgfDomain μ X
  /-- The real-valued MGF on its integrability domain. -/
  real : ℝ → ℝ
  real_eq : ∀ t, real t = realMgf μ X t
  real_domain : ∀ t, t ∈ domain → HasExponentialIntegrability μ X t

theorem no_real_square_root_neg_one :
    ¬ ∃ y : ℝ, y ^ 2 = -1 := by
  rintro ⟨y, hy⟩
  nlinarith [sq_nonneg y]

/-- Corrected raw/absolute moment interface, including the printed obstruction. -/
structure MomentModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) where
  /-- The sequence of raw natural moments. -/
  raw : ℕ → ℝ
  raw_eq : ∀ n, raw n = rawMoment μ X n
  /-- The extended-real absolute moments. -/
  absolute : ℝ → ENNReal
  absolute_eq : ∀ p, absolute p = absoluteMoment μ X p
  finite_raw : ∀ n, HasFiniteRawMoment μ X n
  finite_absolute : ∀ p, 0 < p → HasFiniteAbsoluteMoment μ X p
  source_obstruction : ¬ ∃ y : ℝ, y ^ 2 = -1

/-- Build the corrected raw/absolute moment interface. -/
def momentModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ)
    (hraw : ℕ → ℝ)
    (hraw_eq : ∀ n, hraw n = rawMoment μ X n)
    (habsolute : ℝ → ENNReal)
    (habsolute_eq : ∀ p, habsolute p = absoluteMoment μ X p)
    (hfinite_raw : ∀ n, HasFiniteRawMoment μ X n)
    (hfinite_absolute : ∀ p, 0 < p → HasFiniteAbsoluteMoment μ X p) :
    MomentModelData μ X where
  raw := hraw
  raw_eq := hraw_eq
  absolute := habsolute
  absolute_eq := habsolute_eq
  finite_raw := hfinite_raw
  finite_absolute := hfinite_absolute
  source_obstruction := no_real_square_root_neg_one

/-- Whole-domain convexity interface reused by Jensen's inequality. -/
def convexFunctionInterface (φ : ℝ → ℝ) : Prop :=
  ConvexOn ℝ Set.univ φ

theorem convexFunction_sublevel_convex
    {φ : ℝ → ℝ} (hφ : convexFunctionInterface φ) (r : ℝ) :
    Convex ℝ {x : ℝ | x ∈ (Set.univ : Set ℝ) ∧ φ x ≤ r} := by
  exact hφ.convex_le r

/-! Jensen's inequality for a whole-domain real convex function. -/
theorem jensenIntegral
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {φ : ℝ → ℝ}
    (hφ : ConvexOn ℝ Set.univ φ)
    (hX : Integrable X μ)
    (hφX : Integrable (fun ω => φ (X ω)) μ) :
    φ (expectation μ X) ≤ expectation μ (fun ω => φ (X ω)) := by
  have h := hφ.map_integral_le (s := (Set.univ : Set ℝ))
    (f := X) (g := φ) (hφ.continuousOn isOpen_univ) isClosed_univ
    (Filter.Eventually.of_forall (fun _ => Set.mem_univ _)) hX hφX
  simpa [expectation, Function.comp_def] using h

/-- The book's variance, represented by the centered second moment. -/
def variance {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ :=
  expectation μ (fun ω => (X ω - expectation μ X) ^ 2)

/-!
  Representative-level real `L²` geometry.  The formulas stay in the
  chapter's Bochner-expectation convention; quotient-space identification is
  delegated to Mathlib's `MeasureTheory.Lp`.
-/
/-- The representative-level real `L²` inner product. -/
def l2InnerProduct {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) : ℝ :=
  expectation μ (fun ω => X ω * Y ω)

/-- The representative-level real `L²` norm. -/
noncomputable def l2Norm {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ :=
  Real.sqrt (expectation μ (fun ω => (X ω) ^ 2))

/-- The source-facing standard deviation, with the square root made explicit. -/
def standardDeviation {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ :=
  Real.sqrt (variance μ X)

/-- The representative-level covariance of two real random variables. -/
def covariance {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) : ℝ :=
  expectation μ (fun ω =>
    (X ω - expectation μ X) * (Y ω - expectation μ Y))

/-! The two geometric identities from Remark 1.1.1 are definitional once the
source quantities are represented by the centered expectation formulas. -/
theorem stdevCovarianceIdentities
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) :
    (l2Norm μ (fun ω => X ω - expectation μ X) = standardDeviation μ X) ∧
      (covariance μ X Y =
        l2InnerProduct μ
          (fun ω => X ω - expectation μ X)
          (fun ω => Y ω - expectation μ Y)) := by
  constructor
  · rfl
  · rfl

/-- The inner product and norms of two representatives in real `L²`. -/
structure L2GeometryModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) where
  /-- The `L²` inner product of `X` and `Y`. -/
  inner_product : ℝ
  inner_product_eq : inner_product = l2InnerProduct μ X Y
  /-- The `L²` norm of `X`. -/
  x_norm : ℝ
  x_norm_eq : x_norm = l2Norm μ X
  /-- The `L²` norm of `Y`. -/
  y_norm : ℝ
  y_norm_eq : y_norm = l2Norm μ Y

/-- Construct the representative-level real `L²` geometry model. -/
def l2GeometryModel
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) :
    L2GeometryModelData μ X Y :=
  { inner_product := l2InnerProduct μ X Y
    inner_product_eq := rfl
    x_norm := l2Norm μ X
    x_norm_eq := rfl
    y_norm := l2Norm μ Y
    y_norm_eq := rfl }

/-- The centered variable has zero expectation under the book's probability assumptions. -/
theorem expectation_centered
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Integrable X μ) :
    expectation μ (fun ω => X ω - expectation μ X) = 0 := by
  unfold expectation
  change (∫ ω, X ω - expectation μ X ∂μ) = 0
  rw [integral_sub hX (integrable_const (expectation μ X))]
  simp [expectation]

/-- Variance is definitionally the expectation of the squared centered variable. -/
theorem variance_eq_centered_expectation
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    variance μ X = expectation μ (fun ω => (X ω - expectation μ X) ^ 2) :=
  rfl

/-! The pointwise layer-cake identity used in the proof of Lemma 1.2.1. -/
theorem layerCakePointwise {x : ℝ} (hx : 0 ≤ x) :
    x = (∫ _t in Set.Ioc 0 x, (1 : ℝ) ∂volume) ∧
      ENNReal.ofReal x =
        ∫⁻ t in Set.Ioi 0,
          (Set.Iio x).indicator (fun _ => (1 : ENNReal)) t ∂volume := by
  have hset : Set.Iio x ∩ Set.Ioi 0 = Set.Ioo 0 x := by
    ext t
    simp [and_comm]
  constructor
  · rw [MeasureTheory.setIntegral_const]
    simp [Real.volume_real_Ioc_of_le hx]
  · calc
      ENNReal.ofReal x = ENNReal.ofReal (x - 0) := by simp
      _ = volume (Set.Ioo 0 x) := by rw [Real.volume_Ioo]
      _ = ∫⁻ t in Set.Ioo 0 x, (1 : ENNReal) ∂volume := by
        rw [MeasureTheory.setLIntegral_one]
      _ = ∫⁻ t in Set.Iio x ∩ Set.Ioi 0, (1 : ENNReal) ∂volume := by
        rw [hset]
      _ = ∫⁻ t in Set.Ioi 0,
          (Set.Iio x).indicator (fun _ => (1 : ENNReal)) t ∂volume := by
        symm
        rw [MeasureTheory.setLIntegral_indicator measurableSet_Iio]

/-! The expectation/tail identity from Lemma 1.2.1. -/
theorem layerCakeExpectationExtended
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ ω, 0 ≤ X ω) :
    (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) =
      ∫⁻ t in Set.Ioi 0, μ {ω | t < X ω} := by
  exact MeasureTheory.lintegral_eq_lintegral_meas_lt μ
    (Filter.Eventually.of_forall hNonneg) hX.aemeasurable

theorem layerCakeExpectationFinite
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ ω, 0 ≤ X ω) (hInt : Integrable X μ) :
    expectation μ X =
      ∫ t in Set.Ioi 0, μ.real {ω | t < X ω} := by
  have hInt' : Integrable X μ :=
    ⟨hX.aestronglyMeasurable, hInt.hasFiniteIntegral⟩
  exact hInt'.integral_eq_integral_meas_lt
    (Filter.Eventually.of_forall hNonneg)

theorem layerCakeExpectation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ ω, 0 ≤ X ω) :
    ((∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < X ω}) ∧
      (∀ hInt : Integrable X μ,
        expectation μ X =
          ∫ t in Set.Ioi 0, μ.real {ω | t < X ω}) := by
  refine ⟨layerCakeExpectationExtended hX hNonneg, ?_⟩
  intro hInt
  exact layerCakeExpectationFinite hX hNonneg hInt

/-! The corrected positive/negative-part form of Exercise 1.2.2.  The
    textbook's signed tail subtraction is only used after integrability has
    made both real integrals finite; the two extended identities remain
    separate nonnegative statements. -/
theorem exercise122PositiveNegativeLayerCake
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    (∫⁻ ω, ENNReal.ofReal (max (X ω) 0) ∂μ =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < max (X ω) 0}) ∧
      (∫⁻ ω, ENNReal.ofReal (max (-X ω) 0) ∂μ =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < max (-X ω) 0}) := by
  have hpos : Measurable (fun ω => max (X ω) 0) := hX.max measurable_const
  have hneg : Measurable (fun ω => max (-X ω) 0) :=
    (hX.neg).max measurable_const
  exact ⟨layerCakeExpectationExtended hpos
      (fun ω => le_max_right (X ω) 0),
    layerCakeExpectationExtended hneg
      (fun ω => le_max_right (-X ω) 0)⟩

theorem exercise122CorrectedSignedTailFormula
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) (hInt : Integrable X μ) :
    ∫ ω, X ω ∂μ =
      (∫ t in Set.Ioi 0, μ.real {a | t < X a}) -
        (∫ t in Set.Iio 0, μ.real {a | X a < t}) := by
  have hInt' : Integrable X μ :=
    ⟨hX.aestronglyMeasurable, hInt.hasFiniteIntegral⟩
  have hintpos : Integrable (fun ω => max (X ω) 0) μ := by
    have h' := hInt'.real_toNNReal
    convert h' using 1
  have hintneg : Integrable (fun ω => max (-X ω) 0) μ := by
    have h' := hInt'.neg.real_toNNReal
    convert h' using 1
  have hfinitepos := hintpos.integral_eq_integral_meas_lt
    (Filter.Eventually.of_forall (fun ω => le_max_right (X ω) 0))
  rw [integral_eq_integral_pos_part_sub_integral_neg_part hInt']
  have hpos_eq : (fun ω => (Real.toNNReal (X ω) : ℝ)) =
      (fun ω => max (X ω) 0) := by
    funext ω
    by_cases hx : 0 ≤ X ω
    · rw [Real.toNNReal_of_nonneg hx]
      simp [max_eq_left hx]
    · have hx' : X ω ≤ 0 := le_of_not_ge hx
      rw [Real.toNNReal_of_nonpos hx']
      simp [max_eq_right hx']
  have hneg_eq : (fun ω => (Real.toNNReal (-X ω) : ℝ)) =
      (fun ω => max (-X ω) 0) := by
    funext ω
    by_cases hx : 0 ≤ -X ω
    · rw [Real.toNNReal_of_nonneg hx]
      simp [max_eq_left hx]
    · have hx' : -X ω ≤ 0 := le_of_not_ge hx
      rw [Real.toNNReal_of_nonpos hx']
      simp [max_eq_right hx']
  rw [hpos_eq, hneg_eq, hfinitepos]
  have hfinneg := hintneg.integral_eq_integral_meas_lt
    (Filter.Eventually.of_forall (fun ω => le_max_right (-X ω) 0))
  rw [hfinneg]
  have hpos_tail :
      (∫ t in Set.Ioi 0, μ.real {a | t < max (X a) 0}) =
        ∫ t in Set.Ioi 0, μ.real {a | t < X a} := by
    apply setIntegral_congr_fun measurableSet_Ioi
    intro t ht
    apply congrArg μ.real
    ext a
    change (t < max (X a) 0) ↔ t < X a
    constructor
    · intro h
      exact (lt_max_iff.mp h).resolve_right (not_lt_of_ge ht.le)
    · intro h
      exact lt_max_iff.mpr (Or.inl h)
  have hneg_tail :
      (∫ t in Set.Ioi 0, μ.real {a | t < max (-X a) 0}) =
        ∫ t in Set.Iio 0, μ.real {a | X a < t} := by
    calc
      (∫ t in Set.Ioi 0, μ.real {a | t < max (-X a) 0}) =
          ∫ t in Set.Ioi 0, μ.real {a | X a < -t} := by
            apply setIntegral_congr_fun measurableSet_Ioi
            intro t ht
            apply congrArg μ.real
            ext a
            change (t < max (-X a) 0) ↔ X a < -t
            constructor
            · intro h
              have h' := (lt_max_iff.mp h).resolve_right
                (not_lt_of_ge ht.le)
              linarith
            · intro h
              exact lt_max_iff.mpr (Or.inl (by linarith))
      _ = ∫ t in Set.Iic 0, μ.real {a | X a < t} := by
        simpa only [neg_zero] using
          (integral_comp_neg_Ioi 0
            (fun t : ℝ => μ.real {a | X a < t}))
      _ = ∫ t in Set.Iio 0, μ.real {a | X a < t} :=
        integral_Iic_eq_integral_Iio
  convert congrArg₂ (· - ·) hpos_tail hneg_tail using 1

theorem exercise122Corrected
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    ((∫⁻ ω, ENNReal.ofReal (max (X ω) 0) ∂μ =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < max (X ω) 0}) ∧
      (∫⁻ ω, ENNReal.ofReal (max (-X ω) 0) ∂μ =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < max (-X ω) 0})) ∧
      (∀ hInt : Integrable X μ,
        (∫ ω, X ω ∂μ) =
          (∫ t in Set.Ioi 0, μ.real {a | t < X a}) -
            (∫ t in Set.Iio 0, μ.real {a | X a < t})) := by
  exact ⟨exercise122PositiveNegativeLayerCake hX,
    fun hInt => exercise122CorrectedSignedTailFormula hX hInt⟩

/-! The source-level Cauchy obstruction for the unqualified signed formula. -/
lemma not_integrable_cauchy_pos :
    ¬ Integrable (fun x : ℝ => max x 0) (cauchyMeasure 0 1) := by
  intro h
  have hlin :
      (∫⁻ x, ENNReal.ofReal (max x 0) ∂cauchyMeasure 0 1) ≠ ⊤ := by
    apply (MeasureTheory.lintegral_ofReal_ne_top_iff_integrable
      ((measurable_id.max measurable_const).aestronglyMeasurable)
      (Filter.Eventually.of_forall (fun x => by positivity))).2
    exact h
  have hc : cauchyMeasure (0 : ℝ) (1 : NNReal) =
      volume.withDensity (cauchyPDF (0 : ℝ) (1 : NNReal)) :=
    cauchyMeasure_of_scale_ne_zero (0 : ℝ) (γ := (1 : NNReal)) one_ne_zero
  rw [hc] at hlin
  have hwd := MeasureTheory.lintegral_withDensity_eq_lintegral_mul₀
    (μ := (volume : Measure ℝ)) (f := cauchyPDF (0 : ℝ) (1 : NNReal))
    (g := fun x : ℝ => ENNReal.ofReal (max x 0))
    (measurable_cauchyPDF (0 : ℝ) (1 : NNReal)).aemeasurable
    ((measurable_id.max measurable_const).ennreal_ofReal).aemeasurable
  rw [hwd] at hlin
  have hprod :
      (∫⁻ x, ENNReal.ofReal
        (max x 0 * cauchyPDFReal 0 1 x) ∂volume) ≠ ⊤ := by
    have hpoint (x : ℝ) :
        (cauchyPDF (0 : ℝ) (1 : NNReal) x) * ENNReal.ofReal (max x 0) =
          ENNReal.ofReal (max x 0 * cauchyPDFReal 0 1 x) := by
      rw [cauchyPDF]
      calc
        ENNReal.ofReal (cauchyPDFReal 0 1 x) * ENNReal.ofReal (max x 0) =
            ENNReal.ofReal (cauchyPDFReal 0 1 x * max x 0) :=
          (ENNReal.ofReal_mul
            (cauchyPDF_pos (0 : ℝ) (by simp : (1 : NNReal) ≠ 0) x).le).symm
        _ = ENNReal.ofReal (max x 0 * cauchyPDFReal 0 1 x) := by
          rw [mul_comm]
    simpa only [Pi.mul_apply, hpoint] using hlin
  have hreal : Integrable
      (fun x : ℝ => max x 0 * cauchyPDFReal 0 1 x) volume := by
    apply (MeasureTheory.lintegral_ofReal_ne_top_iff_integrable (by fun_prop)
      (Filter.Eventually.of_forall (fun x =>
        mul_nonneg (by positivity)
          (cauchyPDF_pos (0 : ℝ) (by simp : (1 : NNReal) ≠ 0) x).le))).1
    exact hprod
  have htail : Integrable
      (fun x : ℝ => (2 * Real.pi) * (max x 0 * cauchyPDFReal 0 1 x))
      (volume.restrict (Set.Ioi 1)) := by
    apply (hreal.const_mul (2 * Real.pi)).mono_measure
    exact Measure.restrict_le_self
  have hinv : Integrable (fun x : ℝ => x⁻¹) (volume.restrict (Set.Ioi 1)) := by
    apply htail.mono' (by fun_prop)
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
    have hx1 : 1 < x := hx
    have hx0 : 0 < x := lt_trans zero_lt_one hx1
    rw [Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hx0),
      max_eq_left (show (0 : ℝ) ≤ x from hx0.le), Probability.cauchyPDFReal_def]
    norm_num
    field_simp
    nlinarith [sq_nonneg x, Real.pi_pos]
  exact not_integrableOn_Ioi_inv (a := 1) hinv

lemma cauchy_pos_lintegral_top :
    (∫⁻ x, ENNReal.ofReal (max x 0) ∂cauchyMeasure 0 1) = ⊤ := by
  by_contra htop
  apply not_integrable_cauchy_pos
  apply (MeasureTheory.lintegral_ofReal_ne_top_iff_integrable
    ((measurable_id.max measurable_const).aestronglyMeasurable)
    (Filter.Eventually.of_forall (fun x => by positivity))).1
  exact htop

lemma cauchy_pos_tail_top :
    (∫⁻ t in Set.Ioi 0,
      cauchyMeasure 0 1 {x | t < x}) = ⊤ := by
  have hcake := NumStability.HDP.Scalar.Preliminaries.layerCakeExpectationExtended
    (μ := cauchyMeasure 0 1) (X := fun x : ℝ => max x 0)
    (measurable_id.max measurable_const)
    (fun x => le_max_right x 0)
  have hset :
      (∫⁻ t in Set.Ioi 0,
        cauchyMeasure 0 1 {x | t < max x 0}) =
        ∫⁻ t in Set.Ioi 0,
          cauchyMeasure 0 1 {x | t < x} := by
    apply setLIntegral_congr_fun measurableSet_Ioi
    intro t ht
    have ht0 : 0 < t := ht
    apply congrArg (cauchyMeasure 0 1)
    ext x
    constructor
    · intro h
      change t < max x 0 at h
      exact (lt_max_iff.mp h).resolve_right (not_lt_of_ge ht0.le)
    · intro h
      change t < x at h
      exact lt_max_iff.mpr (Or.inl h)
  calc
    (∫⁻ t in Set.Ioi 0, cauchyMeasure 0 1 {x | t < x}) =
        ∫⁻ t in Set.Ioi 0,
          cauchyMeasure 0 1 {x | t < max x 0} := hset.symm
    _ = ∫⁻ x, ENNReal.ofReal (max x 0) ∂cauchyMeasure 0 1 :=
      hcake.symm
    _ = ⊤ := cauchy_pos_lintegral_top

lemma not_integrable_cauchy_neg :
    ¬ Integrable (fun x : ℝ => max (-x) 0) (cauchyMeasure 0 1) := by
  intro h
  have hlin :
      (∫⁻ x, ENNReal.ofReal (max (-x) 0) ∂cauchyMeasure 0 1) ≠ ⊤ := by
    apply (MeasureTheory.lintegral_ofReal_ne_top_iff_integrable
      ((measurable_neg.max measurable_const).aestronglyMeasurable)
      (Filter.Eventually.of_forall (fun x => by positivity))).2
    exact h
  have hc : cauchyMeasure (0 : ℝ) (1 : NNReal) =
      volume.withDensity (cauchyPDF (0 : ℝ) (1 : NNReal)) :=
    cauchyMeasure_of_scale_ne_zero (0 : ℝ) (γ := (1 : NNReal)) one_ne_zero
  rw [hc] at hlin
  have hwd := MeasureTheory.lintegral_withDensity_eq_lintegral_mul₀
    (μ := (volume : Measure ℝ)) (f := cauchyPDF (0 : ℝ) (1 : NNReal))
    (g := fun x : ℝ => ENNReal.ofReal (max (-x) 0))
    (measurable_cauchyPDF (0 : ℝ) (1 : NNReal)).aemeasurable
    ((measurable_neg.max measurable_const).ennreal_ofReal).aemeasurable
  rw [hwd] at hlin
  have hprod :
      (∫⁻ x, ENNReal.ofReal
        (max (-x) 0 * cauchyPDFReal 0 1 x) ∂volume) ≠ ⊤ := by
    have hpoint (x : ℝ) :
        (cauchyPDF (0 : ℝ) (1 : NNReal) x) * ENNReal.ofReal (max (-x) 0) =
          ENNReal.ofReal (max (-x) 0 * cauchyPDFReal 0 1 x) := by
      rw [cauchyPDF]
      calc
        ENNReal.ofReal (cauchyPDFReal 0 1 x) * ENNReal.ofReal (max (-x) 0) =
            ENNReal.ofReal (cauchyPDFReal 0 1 x * max (-x) 0) :=
          (ENNReal.ofReal_mul
            (cauchyPDF_pos (0 : ℝ) (by simp : (1 : NNReal) ≠ 0) x).le).symm
        _ = ENNReal.ofReal (max (-x) 0 * cauchyPDFReal 0 1 x) := by
          rw [mul_comm]
    simpa only [Pi.mul_apply, hpoint] using hlin
  have hreal : Integrable
      (fun x : ℝ => max (-x) 0 * cauchyPDFReal 0 1 x) volume := by
    apply (MeasureTheory.lintegral_ofReal_ne_top_iff_integrable (by fun_prop)
      (Filter.Eventually.of_forall (fun x =>
        mul_nonneg (by positivity)
          (cauchyPDF_pos (0 : ℝ) (by simp : (1 : NNReal) ≠ 0) x).le))).1
    exact hprod
  have htail : Integrable
      (fun x : ℝ => (2 * Real.pi) * (max (-x) 0 * cauchyPDFReal 0 1 x))
      (volume.restrict (Set.Iio (-1))) := by
    apply (hreal.const_mul (2 * Real.pi)).mono_measure
    exact Measure.restrict_le_self
  have hinvneg : Integrable (fun x : ℝ => (-x)⁻¹)
      (volume.restrict (Set.Iio (-1))) := by
    apply htail.mono' (measurable_neg.inv.aestronglyMeasurable)
    filter_upwards [ae_restrict_mem measurableSet_Iio] with x hx
    have hx1 : x < -1 := hx
    have hx0 : x < 0 := lt_trans hx1 (by norm_num)
    rw [Real.norm_eq_abs, abs_of_pos (inv_pos.mpr (neg_pos.mpr hx0)),
      max_eq_left (neg_nonneg.mpr hx0.le), Probability.cauchyPDFReal_def]
    simp only [sub_zero, NNReal.coe_one, one_pow, mul_one]
    have hbasic : (-x)⁻¹ ≤ 2 * (-x) / ((-x) ^ 2 + 1) := by
      rw [inv_eq_one_div]
      apply (div_le_iff₀ (neg_pos.mpr hx0)).2
      have hmult : 1 ≤ (2 * (-x) * (-x)) / ((-x) ^ 2 + 1) := by
        apply (le_div_iff₀ (by positivity : 0 < (-x) ^ 2 + 1)).2
        nlinarith [sq_nonneg (x + 1)]
      convert hmult using 1; ring
    calc
      (-x)⁻¹ ≤ 2 * (-x) / (x ^ 2 + 1) := by
        convert hbasic using 1; ring
      _ = 2 * Real.pi * (-(x) * (Real.pi⁻¹ * (x ^ 2 + 1)⁻¹)) := by
        field_simp [Real.pi_ne_zero, ne_of_lt hx0]
  have hpos : IntegrableOn (fun x : ℝ => x⁻¹) (Set.Ioi 1) volume := by
    have hinvneg_on : IntegrableOn (fun x : ℝ => x⁻¹) (Set.Iio (-1)) volume := by
      change Integrable (fun x : ℝ => x⁻¹) (volume.restrict (Set.Iio (-1)))
      exact hinvneg.neg.congr (Filter.Eventually.of_forall (fun x => by
        simp [inv_neg]))
    have hcomp : IntegrableOn ((fun y : ℝ => y⁻¹) ∘ Neg.neg)
        (Neg.neg ⁻¹' Set.Iio (-1)) volume :=
      ((Measure.measurePreserving_neg (volume : Measure ℝ)).integrableOn_comp_preimage
        measurableEmbedding_neg).2 hinvneg_on
    have hcomp_neg : Integrable (fun x : ℝ => -(x⁻¹))
        (volume.restrict (Set.Ioi 1)) := by
      simpa [IntegrableOn, Function.comp_def, inv_neg] using hcomp
    change IntegrableOn (fun x : ℝ => x⁻¹) (Set.Ioi 1) volume
    change Integrable (fun x : ℝ => x⁻¹) (volume.restrict (Set.Ioi 1))
    exact hcomp_neg.neg.congr (Filter.Eventually.of_forall (fun x => by
      simp))
  exact not_integrableOn_Ioi_inv (a := 1) hpos

lemma cauchy_neg_lintegral_top :
    (∫⁻ x, ENNReal.ofReal (max (-x) 0) ∂cauchyMeasure 0 1) = ⊤ := by
  by_contra htop
  apply not_integrable_cauchy_neg
  apply (MeasureTheory.lintegral_ofReal_ne_top_iff_integrable
    ((measurable_neg.max measurable_const).aestronglyMeasurable)
    (Filter.Eventually.of_forall (fun x => by positivity))).1
  exact htop

lemma cauchy_neg_tail_top :
    (∫⁻ t in Set.Iio 0,
      cauchyMeasure 0 1 {x | x < t}) = ⊤ := by
  have hcake := NumStability.HDP.Scalar.Preliminaries.layerCakeExpectationExtended
    (μ := cauchyMeasure 0 1) (X := fun x : ℝ => max (-x) 0)
    (measurable_neg.max measurable_const)
    (fun x => le_max_right (-x) 0)
  have hset :
      (∫⁻ t in Set.Ioi 0,
        cauchyMeasure 0 1 {x | t < max (-x) 0}) =
        ∫⁻ t in Set.Iio 0,
          cauchyMeasure 0 1 {x | x < t} := by
    calc
      (∫⁻ t in Set.Ioi 0,
          cauchyMeasure 0 1 {x | t < max (-x) 0}) =
          ∫⁻ t in Set.Ioi 0,
            cauchyMeasure 0 1 {x | x < -t} := by
              apply setLIntegral_congr_fun measurableSet_Ioi
              intro t ht
              have ht0 : 0 < t := ht
              apply congrArg (cauchyMeasure 0 1)
              ext x
              constructor
              · intro h
                change t < max (-x) 0 at h
                have h' : t < -x :=
                  (lt_max_iff.mp h).resolve_right (not_lt_of_ge ht0.le)
                simpa using (neg_lt_neg h')
              · intro h
                change x < -t at h
                have h' : t < -x := by
                  simpa using (neg_lt_neg h)
                exact lt_max_iff.mpr (Or.inl h')
      _ = ∫⁻ t in Set.Iio 0,
          cauchyMeasure 0 1 {x | x < t} := by
            have hmp : MeasurePreserving (Neg.neg : ℝ → ℝ)
                (volume.restrict (Set.Ioi 0))
                (volume.restrict (Set.Iio 0)) := by
              have hmp' :=
                (Measure.measurePreserving_neg (volume : Measure ℝ)).restrict_preimage_emb
                  measurableEmbedding_neg (Set.Iio 0)
              have hpre : (Neg.neg : ℝ → ℝ) ⁻¹' Set.Iio 0 = Set.Ioi 0 := by
                ext x
                simp
              rw [hpre] at hmp'
              exact hmp'
            have hchange := MeasurePreserving.lintegral_comp_emb hmp
                measurableEmbedding_neg
                (fun t : ℝ => cauchyMeasure 0 1 {x | x < t})
            simpa [Function.comp_def] using hchange
  calc
    (∫⁻ t in Set.Iio 0,
        cauchyMeasure 0 1 {x | x < t}) =
        ∫⁻ t in Set.Ioi 0,
          cauchyMeasure 0 1 {x | t < max (-x) 0} := hset.symm
    _ = ∫⁻ x, ENNReal.ofReal (max (-x) 0) ∂cauchyMeasure 0 1 :=
      hcake.symm
    _ = ⊤ := cauchy_neg_lintegral_top

theorem exercise122CauchyObstruction :
    ((∫⁻ t in Set.Ioi 0,
        cauchyMeasure 0 1 {x | t < x}) = ⊤) ∧
      ((∫⁻ t in Set.Iio 0,
        cauchyMeasure 0 1 {x | x < t}) = ⊤) := by
  exact ⟨cauchy_pos_tail_top, cauchy_neg_tail_top⟩

theorem exercise122CorrectedWithCauchy
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    (
      (((∫⁻ ω, ENNReal.ofReal (max (X ω) 0) ∂μ =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < max (X ω) 0}) ∧
      (∫⁻ ω, ENNReal.ofReal (max (-X ω) 0) ∂μ =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < max (-X ω) 0})) ∧
      (∀ hInt : Integrable X μ,
        (∫ ω, X ω ∂μ) =
          (∫ t in Set.Ioi 0, μ.real {a | t < X a}) -
            (∫ t in Set.Iio 0, μ.real {a | X a < t})))
      ∧
        ((∫⁻ t in Set.Ioi 0,
          cauchyMeasure 0 1 {x | t < x}) = ⊤) ∧
        ((∫⁻ t in Set.Iio 0,
          cauchyMeasure 0 1 {x | x < t}) = ⊤)
    ) := by
  exact ⟨exercise122Corrected hX, exercise122CauchyObstruction⟩

/-! The weighted layer-cake identity for positive real moments. -/
theorem momentTailFormula
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) {p : ℝ} (hp : 0 < p) :
    (absoluteMoment μ X p =
        ENNReal.ofReal p *
          ∫⁻ t in Set.Ioi 0,
            μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) ∧
      (∀ hfinite :
          absoluteMoment μ X p < (⊤ : ENNReal) ∨
            ENNReal.ofReal p *
                ∫⁻ t in Set.Ioi 0,
                  μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1)) <
              (⊤ : ENNReal),
        (absoluteMoment μ X p).toReal =
          (ENNReal.ofReal p *
            ∫⁻ t in Set.Ioi 0,
              μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))).toReal) := by
  have hnonneg : 0 ≤ᵐ[μ] (fun ω => |X ω|) :=
    Filter.Eventually.of_forall (fun ω => abs_nonneg _)
  have hmeas : AEMeasurable (fun ω => |X ω|) μ :=
    (hX.norm).aemeasurable
  have hformula :=
    MeasureTheory.lintegral_rpow_eq_lintegral_meas_lt_mul
      (μ := μ) hnonneg hmeas hp
  constructor
  · simpa [absoluteMoment, Real.norm_eq_abs] using hformula
  · intro _
    exact congrArg ENNReal.toReal (by
      simpa [absoluteMoment, Real.norm_eq_abs] using hformula)

/-! The pointwise indicator inequality used in the proof of Markov's bound. -/
theorem markovIndicatorBound {x t : ℝ} (hx : 0 ≤ x) (ht : 0 < t) :
    t * Set.indicator (Set.Ici t) (fun _ => (1 : ℝ)) x ≤ x := by
  by_cases hxt : t ≤ x
  · have hmem : x ∈ Set.Ici t := hxt
    rw [Set.indicator_of_mem hmem]
    simpa using hxt
  · have htx : x < t := lt_of_not_ge hxt
    simp [Set.indicator, not_le.mpr htx]
    exact hx

/-! The extended and finite forms of Markov's inequality. -/
theorem markovInequalityExtended
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ᵐ ω ∂μ, 0 ≤ X ω) {t : ℝ} (ht : 0 < t) :
    μ (X ⁻¹' Set.Ici t) ≤
      (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal t := by
  have hmarkov :=
    MeasureTheory.meas_ge_le_lintegral_div
      (μ := μ) (f := fun ω => ENNReal.ofReal (X ω))
      hX.ennreal_ofReal.aemeasurable (ENNReal.ofReal_pos.mpr ht).ne'
      ENNReal.ofReal_ne_top
  have hsubset : X ⁻¹' Set.Ici t ⊆
      {ω | ENNReal.ofReal t ≤ ENNReal.ofReal (X ω)} := by
    intro ω hω
    exact ENNReal.ofReal_le_ofReal hω
  exact (measure_mono hsubset).trans hmarkov

theorem markovInequalityFinite
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ᵐ ω ∂μ, 0 ≤ X ω) (hInt : Integrable X μ)
    {t : ℝ} (ht : 0 < t) :
    μ.real (X ⁻¹' Set.Ici t) ≤ expectation μ X / t := by
  have hext := markovInequalityExtended hX hNonneg ht
  have hIntegralTop :
      (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) ≠ (⊤ : ENNReal) :=
    hInt.lintegral_lt_top.ne
  have hDenPos : 0 < ENNReal.ofReal t := ENNReal.ofReal_pos.mpr ht
  have hRightTop :
      (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal t ≠ (⊤ : ENNReal) :=
    ENNReal.div_ne_top hIntegralTop hDenPos.ne'
  have hLeftTop : μ (X ⁻¹' Set.Ici t) ≠ (⊤ : ENNReal) :=
    ne_top_of_le_ne_top hRightTop hext
  have hreal :=
    (ENNReal.toReal_le_toReal hLeftTop hRightTop).2 hext
  have hIntegral :
      (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) =
        ENNReal.ofReal (expectation μ X) := by
    symm
    exact ofReal_integral_eq_lintegral_ofReal hInt hNonneg
  have hExpectationNonneg : 0 ≤ expectation μ X := by
    exact integral_nonneg_of_ae hNonneg
  change (μ (X ⁻¹' Set.Ici t)).toReal ≤ expectation μ X / t
  rw [hIntegral, ENNReal.toReal_div,
    ENNReal.toReal_ofReal hExpectationNonneg,
    ENNReal.toReal_ofReal ht.le] at hreal
  exact hreal

theorem markovInequality
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ᵐ ω ∂μ, 0 ≤ X ω) (hInt : Integrable X μ)
    {t : ℝ} (ht : 0 < t) :
    (μ.real (X ⁻¹' Set.Ici t) ≤ expectation μ X / t) ∧
      (μ (X ⁻¹' Set.Ici t) ≤
        (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal t) := by
  have hmarkov :=
    MeasureTheory.meas_ge_le_lintegral_div
      (μ := μ) (f := fun ω => ENNReal.ofReal (X ω))
      hX.ennreal_ofReal.aemeasurable (ENNReal.ofReal_pos.mpr ht).ne'
      ENNReal.ofReal_ne_top
  have hsubset : X ⁻¹' Set.Ici t ⊆
      {ω | ENNReal.ofReal t ≤ ENNReal.ofReal (X ω)} := by
    intro ω hω
    exact ENNReal.ofReal_le_ofReal hω
  have hext : μ (X ⁻¹' Set.Ici t) ≤
      (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal t :=
    (measure_mono hsubset).trans hmarkov
  have hIntegralTop :
      (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) ≠ (⊤ : ENNReal) :=
    hInt.lintegral_lt_top.ne
  have hDenPos : 0 < ENNReal.ofReal t := ENNReal.ofReal_pos.mpr ht
  have hRightTop :
      (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal t ≠ (⊤ : ENNReal) :=
    ENNReal.div_ne_top hIntegralTop hDenPos.ne'
  have hLeftTop : μ (X ⁻¹' Set.Ici t) ≠ (⊤ : ENNReal) :=
    ne_top_of_le_ne_top hRightTop hext
  have hreal :=
    (ENNReal.toReal_le_toReal hLeftTop hRightTop).2 hext
  have hIntegral :
      (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) =
        ENNReal.ofReal (expectation μ X) := by
    symm
    exact ofReal_integral_eq_lintegral_ofReal hInt hNonneg
  have hExpectationNonneg : 0 ≤ expectation μ X := by
    exact integral_nonneg_of_ae hNonneg
  have hfinite : μ.real (X ⁻¹' Set.Ici t) ≤ expectation μ X / t := by
    change (μ (X ⁻¹' Set.Ici t)).toReal ≤ expectation μ X / t
    rw [hIntegral, ENNReal.toReal_div,
      ENNReal.toReal_ofReal hExpectationNonneg,
      ENNReal.toReal_ofReal ht.le] at hreal
    exact hreal
  exact ⟨hfinite, hext⟩

/-! The squared-deviation derivation of Chebyshev's bound. -/
theorem chebyshevEventBound
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hInt : Integrable X μ)
    (hSqInt : Integrable (fun ω => (X ω - expectation μ X) ^ 2) μ)
    {t : ℝ} (ht : 0 < t) :
    μ.real {ω | |X ω - expectation μ X| ≥ t} ≤ variance μ X / t ^ 2 := by
  have hY : Measurable (fun ω => (X ω - expectation μ X) ^ 2) :=
    (hX.sub measurable_const).pow_const 2
  have hMarkov :=
    markovInequalityFinite (X := fun ω => (X ω - expectation μ X) ^ 2)
      hY (ae_of_all μ (fun ω => sq_nonneg _)) hSqInt (sq_pos_of_pos ht)
  have hEvent :
      (fun ω => (X ω - expectation μ X) ^ 2) ⁻¹' Set.Ici (t ^ 2) =
        {ω | |X ω - expectation μ X| ≥ t} := by
    ext ω
    constructor
    · intro hω
      have hs : t ^ 2 ≤ (X ω - expectation μ X) ^ 2 := hω
      have hs' : |t| ≤ |X ω - expectation μ X| := (sq_le_sq).mp hs
      simpa [abs_of_pos ht] using hs'
    · intro hω
      have habs : t ≤ |X ω - expectation μ X| := hω
      have hs' : |t| ≤ |X ω - expectation μ X| := by
        simpa [abs_of_pos ht] using habs
      exact (sq_le_sq).mpr hs'
  rw [← hEvent]
  simpa [variance, expectation] using hMarkov

/-! The source-facing Minkowski bridge reuses Mathlib's `eLpNorm` API. -/
theorem minkowskiEpnorm
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {p : ENNReal}
    (hX : AEStronglyMeasurable X μ) (hY : AEStronglyMeasurable Y μ)
    (hp : 1 ≤ p) :
    eLpNorm (X + Y) p μ ≤ eLpNorm X p μ + eLpNorm Y p μ := by
  exact eLpNorm_add_le hX hY hp

/-! The corrected positive-exponent form of the chapter's Lp monotonicity
  claim.  Mathlib's representative-level eLpNorm is used directly, so the
  endpoint q = ∞ is included.  The printed p = 0 endpoint is excluded:
  under the pinned API eLpNorm X 0 μ = 0, which is not an L0 norm. -/
theorem lpNormMonoProbability
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {p q : ENNReal}
    (hpq : p ≤ q) (hX : AEStronglyMeasurable X μ) :
    eLpNorm X p μ ≤ eLpNorm X q μ := by
  simpa using
    (eLpNorm_le_eLpNorm_mul_rpow_measure_univ (f := X) hpq hX)

theorem lpNormExponentZero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    eLpNorm X 0 μ = 0 := by
  simp

/-! The source-facing Hölder inequality and its two endpoint branches. -/
theorem holderIntegralBound
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {p q : ℝ}
    (hpq : p.HolderConjugate q)
    (hX : MemLp X (ENNReal.ofReal p) μ)
    (hY : MemLp Y (ENNReal.ofReal q) μ) :
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
      (∫ ω, ‖X ω‖ ^ p ∂μ) ^ (1 / p) *
        (∫ ω, ‖Y ω‖ ^ q ∂μ) ^ (1 / q) := by
  calc
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
        ∫ ω, ‖X ω * Y ω‖ ∂μ := by
      exact norm_integral_le_integral_norm _
    _ = ∫ ω, ‖X ω‖ * ‖Y ω‖ ∂μ := by
      apply integral_congr_ae
      filter_upwards with ω
      rw [norm_mul]
    _ ≤ (∫ ω, ‖X ω‖ ^ p ∂μ) ^ (1 / p) *
        (∫ ω, ‖Y ω‖ ^ q ∂μ) ^ (1 / q) :=
      integral_mul_norm_le_Lp_mul_Lq hpq hX hY

theorem holderEndpointOneTop
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ}
    (hX : MemLp X 1 μ) (hY : MemLp Y (⊤ : ENNReal) μ) :
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
      (eLpNorm X 1 μ).toReal * (eLpNorm Y (⊤ : ENNReal) μ).toReal := by
  letI : ENNReal.HolderConjugate 1 (⊤ : ENNReal) := inferInstance
  have hprod : MemLp (fun ω => X ω * Y ω) 1 μ := by
    exact hY.mul' hX
  calc
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
        ∫ ω, ‖X ω * Y ω‖ ∂μ := by
      exact norm_integral_le_integral_norm _
    _ = (eLpNorm (fun ω => X ω * Y ω) 1 μ).toReal := by
      rw [eLpNorm_one_eq_lintegral_enorm]
      rw [integral_eq_lintegral_of_nonneg_ae]
      · simp only [ofReal_norm_eq_enorm]
      · exact Filter.Eventually.of_forall (fun ω => norm_nonneg _)
      · exact hprod.1.norm
    _ ≤ (eLpNorm X 1 μ * eLpNorm Y (⊤ : ENNReal) μ).toReal := by
      exact ENNReal.toReal_mono (ENNReal.mul_ne_top hX.eLpNorm_ne_top hY.eLpNorm_ne_top)
        (by
          simpa using
            (eLpNorm_le_eLpNorm_mul_eLpNorm_top 1 hX.1 Y (fun x y => x * y) 1
              (.of_forall fun _ => by simp)))
    _ = (eLpNorm X 1 μ).toReal * (eLpNorm Y (⊤ : ENNReal) μ).toReal := by
      simp only [ENNReal.toReal_mul]

theorem holderEndpointTopOne
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ}
    (hX : MemLp X (⊤ : ENNReal) μ) (hY : MemLp Y 1 μ) :
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
      (eLpNorm X (⊤ : ENNReal) μ).toReal * (eLpNorm Y 1 μ).toReal := by
  simpa [mul_comm] using holderEndpointOneTop (μ := μ) (X := Y) (Y := X) hY hX

/-- The interior and endpoint forms of Hölder's inequality. -/
structure HolderModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) where
  interior : ∀ {p q : ℝ}, p.HolderConjugate q →
    MemLp X (ENNReal.ofReal p) μ → MemLp Y (ENNReal.ofReal q) μ →
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
      (∫ ω, ‖X ω‖ ^ p ∂μ) ^ (1 / p) *
        (∫ ω, ‖Y ω‖ ^ q ∂μ) ^ (1 / q)
  one_top : MemLp X 1 μ → MemLp Y (⊤ : ENNReal) μ →
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
      (eLpNorm X 1 μ).toReal * (eLpNorm Y (⊤ : ENNReal) μ).toReal
  top_one : MemLp X (⊤ : ENNReal) μ → MemLp Y 1 μ →
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
      (eLpNorm X (⊤ : ENNReal) μ).toReal * (eLpNorm Y 1 μ).toReal

/-- Package the proved forms of Hölder's inequality. -/
def holderModel
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) : HolderModelData μ X Y :=
  { interior := fun hpq hX hY => holderIntegralBound hpq hX hY
    one_top := holderEndpointOneTop
    top_one := holderEndpointTopOne }

/-! The real `L²` Cauchy--Schwarz representative-level interface. -/
theorem cauchySchwarzIntegralBound
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ}
    (hX : MemLp X 2 μ) (hY : MemLp Y 2 μ) :
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
      (eLpNorm X 2 μ).toReal * (eLpNorm Y 2 μ).toReal := by
  letI : ENNReal.HolderConjugate 2 2 := inferInstance
  have hprod : MemLp (fun ω => X ω * Y ω) 1 μ := by
    exact hY.mul' hX
  calc
    ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
        ∫ ω, ‖X ω * Y ω‖ ∂μ := by
      exact norm_integral_le_integral_norm _
    _ = (eLpNorm (fun ω => X ω * Y ω) 1 μ).toReal := by
      rw [eLpNorm_one_eq_lintegral_enorm]
      rw [integral_eq_lintegral_of_nonneg_ae]
      · simp only [ofReal_norm_eq_enorm]
      · exact Filter.Eventually.of_forall (fun ω => norm_nonneg _)
      · exact hprod.1.norm
    _ ≤ (eLpNorm X 2 μ * eLpNorm Y 2 μ).toReal := by
      apply ENNReal.toReal_mono
        (ENNReal.mul_ne_top hX.eLpNorm_ne_top hY.eLpNorm_ne_top)
      simpa using eLpNorm_le_eLpNorm_mul_eLpNorm_of_nnnorm
        (p := (2 : ENNReal)) (q := 2) (r := 1) hX.1 hY.1
        (fun x y => x * y) 1 (.of_forall fun _ => by simp)
    _ = (eLpNorm X 2 μ).toReal * (eLpNorm Y 2 μ).toReal := by
      simp only [ENNReal.toReal_mul]

/-! The pinned representative L2 norm agrees with the chapter's
  square-root-of-second-moment representative norm. -/
theorem eLpNormTwoToL2Norm
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {Z : Ω → ℝ}
    (hZ : MemLp Z 2 μ) :
    (eLpNorm Z 2 μ).toReal = l2Norm μ Z := by
  rw [toReal_eLpNorm hZ.1]
  rw [lpNorm_eq_integral_norm_rpow_toReal (by norm_num) (by norm_num) hZ.1]
  simp [l2Norm, expectation, Real.sqrt_eq_rpow, Real.norm_eq_abs, ← sq_abs]

/-- Centering contracts the real `L²` seminorm. This is Equation (2.19) in
Vershynin, *High-Dimensional Probability*. -/
theorem centered_eLpNorm_two_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : MemLp X 2 μ) :
    eLpNorm (fun ω => X ω - ∫ x, X x ∂μ) 2 μ ≤ eLpNorm X 2 μ := by
  rw [eLpNorm_eq_lintegral_rpow_enorm_toReal two_ne_zero ENNReal.ofNat_ne_top,
    eLpNorm_eq_lintegral_rpow_enorm_toReal two_ne_zero ENNReal.ofNat_ne_top]
  norm_num only [ENNReal.toReal_ofNat]
  apply ENNReal.rpow_le_rpow ?_ (by norm_num)
  have hvariance :
      ProbabilityTheory.evariance X μ ≤ ∫⁻ ω, ‖X ω‖ₑ ^ 2 ∂μ := by
    rw [ProbabilityTheory.evariance_def' hX.1]
    exact tsub_le_self
  simpa only [ProbabilityTheory.evariance, ENNReal.rpow_two] using hvariance

/-! Remark 1.1.1: covariance is controlled by the product of the two
  centered L2 norms, hence by the product of the source standard deviations. -/
theorem covarianceCauchySchwarzBound
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℝ}
    (hX : MemLp X 2 μ) (hY : MemLp Y 2 μ) :
    ‖covariance μ X Y‖ ≤ standardDeviation μ X * standardDeviation μ Y := by
  have hXc : MemLp (fun ω => X ω - expectation μ X) 2 μ := by
    simpa using hX.sub (memLp_const (expectation μ X))
  have hYc : MemLp (fun ω => Y ω - expectation μ Y) 2 μ := by
    simpa using hY.sub (memLp_const (expectation μ Y))
  have hbound := cauchySchwarzIntegralBound hXc hYc
  have hnormX := eLpNormTwoToL2Norm hXc
  have hnormY := eLpNormTwoToL2Norm hYc
  calc
    ‖covariance μ X Y‖ =
        ‖expectation μ (fun ω =>
          (X ω - expectation μ X) * (Y ω - expectation μ Y))‖ := by
      rfl
    _ ≤
        (eLpNorm (fun ω => X ω - expectation μ X) 2 μ).toReal *
          (eLpNorm (fun ω => Y ω - expectation μ Y) 2 μ).toReal := hbound
    _ = l2Norm μ (fun ω => X ω - expectation μ X) *
          l2Norm μ (fun ω => Y ω - expectation μ Y) := by
      rw [hnormX, hnormY]
    _ = standardDeviation μ X * standardDeviation μ Y := by
      rw [(stdevCovarianceIdentities μ X Y).1]
      rw [(stdevCovarianceIdentities μ Y X).1]

/-! A concrete two-point witness that the displayed `Lᵖ` functional need not
be subadditive below one. -/
theorem twoPointLpTriangleFailure :
    ∃ (μ : Measure (Fin 2)) (f g : Fin 2 → ℝ),
      IsProbabilityMeasure μ ∧
        ¬ eLpNorm (f + g) (1 / 2 : ENNReal) μ ≤
          eLpNorm f (1 / 2 : ENNReal) μ + eLpNorm g (1 / 2 : ENNReal) μ := by
  let μ : Measure (Fin 2) := ProbabilityTheory.uniformOn Set.univ
  let f : Fin 2 → ℝ := Set.indicator ({0} : Set (Fin 2)) (fun _ => 1)
  let g : Fin 2 → ℝ := Set.indicator ({1} : Set (Fin 2)) (fun _ => 1)
  have hμ : IsProbabilityMeasure μ := by
    dsimp [μ]
    infer_instance
  have hμ0 : μ ({0} : Set (Fin 2)) = (1 / 2 : ENNReal) := by
    dsimp [μ]
    rw [ProbabilityTheory.uniformOn_univ]
    simp [Measure.count_apply]
  have hμ1 : μ ({1} : Set (Fin 2)) = (1 / 2 : ENNReal) := by
    dsimp [μ]
    rw [ProbabilityTheory.uniformOn_univ]
    simp [Measure.count_apply]
  refine ⟨μ, f, g, hμ, ?_⟩
  have hf : eLpNorm f (1 / 2 : ENNReal) μ = (2 : ENNReal)⁻¹ ^ 2 := by
    dsimp [f]
    rw [eLpNorm_indicator_const (s := ({0} : Set (Fin 2)))
      (c := (1 : ℝ)) (measurableSet_singleton (0 : Fin 2)) (by norm_num) (by norm_num)]
    rw [hμ0]
    norm_num
  have hg : eLpNorm g (1 / 2 : ENNReal) μ = (2 : ENNReal)⁻¹ ^ 2 := by
    dsimp [g]
    rw [eLpNorm_indicator_const (s := ({1} : Set (Fin 2)))
      (c := (1 : ℝ)) (measurableSet_singleton (1 : Fin 2)) (by norm_num) (by norm_num)]
    rw [hμ1]
    norm_num
  have hsum : f + g = (fun _ : Fin 2 => (1 : ℝ)) := by
    funext x
    fin_cases x <;> simp [f, g]
  rw [hsum, eLpNorm_const _ (by norm_num) (by simp [μ]), hf, hg]
  simp [hμ.measure_univ]
  have hquarter : (2 : ENNReal)⁻¹ ^ 2 < (2 : ENNReal)⁻¹ := by
    rw [pow_two]
    calc
      (2 : ENNReal)⁻¹ * 2⁻¹ < 1 * 2⁻¹ :=
        ENNReal.mul_lt_mul_left (by norm_num) (by norm_num)
          ENNReal.one_half_lt_one
      _ = (2 : ENNReal)⁻¹ := one_mul _
  calc
    (2 : ENNReal)⁻¹ ^ 2 + 2⁻¹ ^ 2 < 2⁻¹ + 2⁻¹ :=
      ENNReal.add_lt_add hquarter hquarter
    _ = 1 := ENNReal.inv_two_add_inv_two

/-! The `p ≥ 1` branch of the source-facing Banach-space statement. -/
/-- Banach-space data for the `Lᵖ` quotient when `p ≥ 1`. -/
structure LpQuotientBanachModelData
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) (p : ENNReal)
    [Fact (1 ≤ p)] : Prop where
  normed : Nonempty (NormedAddCommGroup (MeasureTheory.Lp ℝ p μ))
  complete : Nonempty (CompleteSpace (MeasureTheory.Lp ℝ p μ))
  counterexample :
    ∃ (μ : Measure (Fin 2)) (f g : Fin 2 → ℝ),
      IsProbabilityMeasure μ ∧
        ¬ eLpNorm (f + g) (1 / 2 : ENNReal) μ ≤
          eLpNorm f (1 / 2 : ENNReal) μ + eLpNorm g (1 / 2 : ENNReal) μ

theorem lpQuotientBanach
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (p : ENNReal) [Fact (1 ≤ p)] :
    LpQuotientBanachModelData μ p :=
  { normed := ⟨inferInstance⟩
    complete := ⟨inferInstance⟩
    counterexample := twoPointLpTriangleFailure }

/-- A source-facing package of mean, variance, and the centered-variable fact. -/
structure ExpectationVarianceModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Integrable X μ) where
  /-- The expectation of `X`. -/
  mean : ℝ
  /-- The variance of `X`. -/
  variance : ℝ
  mean_eq : mean = expectation μ X
  variance_eq : variance = Preliminaries.variance μ X
  centered_mean : expectation μ (fun ω => X ω - mean) = 0

/-- The Chapter 1 expectation/variance interface for an integrable random variable. -/
def expectationVarianceModel
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Integrable X μ) :
    ExpectationVarianceModelData μ X hX :=
  { mean := expectation μ X
    variance := variance μ X
    mean_eq := rfl
    variance_eq := rfl
    centered_mean := by
      simpa using expectation_centered hX }

end NumStability.HDP.Scalar.Preliminaries
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.ConvexFunction.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/ConvexFunction/Contract.lean`
SHA-256: `76f49c677e6d34e15f21ac7bd15e5b70d55b3f31d058d1267dd61bd3f8940a43`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable source-facing contract for the convex-function definition in
Section 1.2, footnote 3. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.Preliminaries

/-- Original sublevel-set consequence exported for the convex-function row. -/
theorem hdp_01_hdef_hconvex_hfunction
    {φ : ℝ → ℝ} (hφ : convexFunctionInterface φ) (r : ℝ) :
    Convex ℝ {x : ℝ | x ∈ (Set.univ : Set ℝ) ∧ φ x ≤ r} :=
  convexFunction_sublevel_convex hφ r

/-- A real function is convex exactly when it satisfies the book's displayed
two-point inequality for every interpolation parameter in `[0,1]`. -/
theorem hdp_01_hdef_hconvex_hfunction_spec (φ : ℝ → ℝ) :
    convexFunctionInterface φ ↔
      ∀ (t : ℝ), 0 ≤ t → t ≤ 1 → ∀ x y : ℝ,
        φ (t * x + (1 - t) * y) ≤
          t * φ x + (1 - t) * φ y := by
  constructor
  · rintro ⟨_, hφ⟩ t ht0 ht1 x y
    simpa [smul_eq_mul] using
      hφ (Set.mem_univ x) (Set.mem_univ y) ht0
        (sub_nonneg.mpr ht1) (by ring)
  · intro h
    refine ⟨convex_univ, ?_⟩
    intro x _ y _ a b ha hb hab
    have hb_eq : b = 1 - a := by linarith
    subst b
    simpa [smul_eq_mul] using h a ha (by linarith) x y

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.DistributionDetermined.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/DistributionDetermined/Contract.lean`
SHA-256: `3b403646fd0a5a97c966a06079248a3f5fec9d53d447076152b84a39bbedffb9`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Source-facing contract for uniqueness of a real law from its CDF. -/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Original Chapter 1 forwarding alias for CDF determination. -/
theorem hdp_01_hthm_hcdf_hdetermines_hlaw
    {μ ν : Measure ℝ} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν] :
    (∀ t : ℝ, μ (Set.Iic t) = ν (Set.Iic t)) ↔ μ = ν :=
  NumStability.HDP.Scalar.Preliminaries.cdfDeterminesLaw

/-- Two real probability laws agree exactly when their cumulative distribution
functions agree at every threshold. -/
theorem hdp_01_hclaim_hdistribution_hdetermined_spec
    {μ ν : Measure ℝ} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν] :
    (∀ t : ℝ, μ (Set.Iic t) = ν (Set.Iic t)) ↔ μ = ν :=
  NumStability.HDP.Scalar.Preliminaries.cdfDeterminesLaw

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Equation03.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Equation03/Contract.lean`
SHA-256: `c8dace75dc9eaddd1cd21674e4d7c08df3e9e37330fab3a02dac2906bd8e4843`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Source-facing contracts for Equation (1.3), including its printed
zero-exponent obstruction and the corrected positive-exponent theorem. -/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-! Compatibility aliases for the original corrected Equation (1.3) surface. -/
theorem hdp_01_hcor_hlp_hmonotone
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {p q : ENNReal}
    (hpq : p ≤ q) (hX : AEStronglyMeasurable X μ) :
    eLpNorm X p μ ≤ eLpNorm X q μ :=
  lpNormMonoProbability hpq hX

theorem hdp_01_hcor_hlp_hmonotone_zero :
    ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ},
      eLpNorm X 0 μ = 0 :=
  fun {_} {_} {_} => lpNormExponentZero

/-- The printed finite-`p` formula uses the exponent `1 / p`; at the stated
endpoint `p = 0`, no real reciprocal can satisfy its defining equation. -/
theorem hdp_01_heq_h1_d3_source_obstruction :
    ¬ ∃ r : ℝ, (0 : ℝ) * r = 1 := by
  norm_num

/-- Mathlib totalizes the separate `eLpNorm` zero-exponent branch as zero;
this records the available model without identifying it with the book's
undefined `1 / 0` formula. -/
theorem hdp_01_heq_h1_d3_zero_model
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    eLpNorm X 0 μ = 0 :=
  lpNormExponentZero

/-- Corrected form of Equation (1.3): on a probability space, the extended
`L^p` norm is monotone for nonzero exponents, including the `q = ∞` endpoint. -/
theorem hdp_01_heq_h1_d3_corrected
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {p q : ENNReal}
    (_hp : p ≠ 0) (hpq : p ≤ q)
    (hX : AEStronglyMeasurable X μ) :
    eLpNorm X p μ ≤ eLpNorm X q μ :=
  lpNormMonoProbability hpq hX

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.HolderInequality.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/HolderInequality/Contract.lean`
SHA-256: `1abb382cf87978c39025b463e3820e763b6152279011583f68c9ee28478567c1`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Source-facing exhaustive contract for the Chapter 1 Hölder inequality. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- Original bundled Hölder-model forwarding alias. -/
theorem hdp_01_hthm_hholder
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) :
    HolderModelData μ X Y :=
  holderModel μ X Y

/-- Hölder's inequality on the book's probability-space `L^p` classes.  The
first conjunct covers finite conjugate exponents; the other two retain the
`(1, ∞)` and `(∞, 1)` endpoints explicitly. -/
theorem hdp_01_hthm_hholder_spec
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℝ} :
    (∀ {p q : ℝ}, p.HolderConjugate q →
      MemLp X (ENNReal.ofReal p) μ →
      MemLp Y (ENNReal.ofReal q) μ →
      ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
        (∫ ω, ‖X ω‖ ^ p ∂μ) ^ (1 / p) *
          (∫ ω, ‖Y ω‖ ^ q ∂μ) ^ (1 / q)) ∧
    (MemLp X 1 μ → MemLp Y (⊤ : ENNReal) μ →
      ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
        (eLpNorm X 1 μ).toReal * (eLpNorm Y (⊤ : ENNReal) μ).toReal) ∧
    (MemLp X (⊤ : ENNReal) μ → MemLp Y 1 μ →
      ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
        (eLpNorm X (⊤ : ENNReal) μ).toReal * (eLpNorm Y 1 μ).toReal) := by
  exact ⟨fun hpq hX hY => holderIntegralBound hpq hX hY,
    holderEndpointOneTop, holderEndpointTopOne⟩

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Indicator.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Indicator/Contract.lean`
SHA-256: `1d4ca10a87719d84cbf9f54fa6e12f9e978a5b1917965660b2c38bf54a2d0ab0`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable Chapter 1 contract for the indicator-function definition. -/

noncomputable section

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.Preliminaries

/-- The source's indicator `1_E` is one on `E` and zero off `E`. -/
theorem hdp_01_hdef_hindicator
    {Ω : Type*} [MeasurableSpace Ω] (E : Set Ω) (ω : Ω) :
    (ω ∈ E → indicatorFunction E ω = 1) ∧
      (ω ∉ E → indicatorFunction E ω = 0) := by
  constructor <;> intro hω <;> simp [indicatorFunction, hω]

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.JensenInequality.Signature`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/JensenInequality/Signature.lean`
SHA-256: `43e482b9ae3ac23493bf0e52c65ae85b476a21caf0a00ed339369eee2773e435`

```lean
import Mathlib.Analysis.Convex.Integral

/-! Frozen proof-free signature for Jensen's inequality. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_01_hthm_hjensen__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {φ : ℝ → ℝ}
    (hφ : ConvexOn ℝ Set.univ φ)
    (hX : Integrable X μ)
    (hφX : Integrable (fun ω => φ (X ω)) μ),
    φ (∫ ω, X ω ∂μ) ≤
      ∫ ω, φ (X ω) ∂μ

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.JensenInequality.Contract.Theorem`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/JensenInequality/Contract/Theorem.lean`
SHA-256: `aa9aba9a0a27d484f673003b33dc01aab32a1be09a3b9338e2095f0da55dc432`

```lean
import ComputationalMathematics.Source.Vershynin.Chapter01.JensenInequality.Signature
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Stable Chapter 1 forwarding module for Jensen's inequality.

Section 1.2 prints the inequality for a convex function `φ` as

  `φ(E X) ≤ E φ(X)`,

with no exceptional-value convention for the two ordinary expectations it
displays.  Following the module-owned finite-Lebesgue-integral definability
convention in `module/instructions.md`, this contract carries exactly the two
premises that make those displayed expectations well-defined real numbers,
`Integrable X μ` and `Integrable (fun ω => φ (X ω)) μ`.  They are the declared
meaning conditions of the printed statement, not proof conveniences, and no
hypothesis beyond them is imposed: convexity is taken on all of `ℝ`, as printed.
-/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- Chapter 1 source-facing Jensen inequality, stated on the declared
finite-integral definability domain. -/
theorem hdp_01_hthm_hjensen
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {φ : ℝ → ℝ}
    (hφ : ConvexOn ℝ Set.univ φ)
    (hX : Integrable X μ)
    (hφX : Integrable (fun ω => φ (X ω)) μ) :
    φ (expectation μ X) ≤ expectation μ (fun ω => φ (X ω)) :=
  jensenIntegral hφ hX hφX

/-- The frozen proof-free Jensen signature, discharged by the source-facing
wrapper above. -/
theorem hdp_01_hthm_hjensen__contract
    : hdp_01_hthm_hjensen__contract_type := by
  intro Ω instΩ μ instμ X φ hφ hX hφX
  exact hdp_01_hthm_hjensen hφ hX hφX

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.LayerCakePointwise.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/LayerCakePointwise/Contract.lean`
SHA-256: `6e5eac86f26a925a1ae2e76967f811324ed6e0ebade5a4f55ab1afa990f5c646`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable Chapter 1 contract for the pointwise identity in the proof of Lemma 1.2.1. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory

/-- A nonnegative real is the length of `[0,x]`, equivalently the integral of
the strict-threshold indicator over positive thresholds. -/
theorem hdp_01_hlem_hlayer_hcake_hpointwise {x : ℝ} (hx : 0 ≤ x) :
    x = (∫ _t in Set.Ioc 0 x, (1 : ℝ) ∂volume) ∧
      ENNReal.ofReal x =
        ∫⁻ t in Set.Ioi 0,
          (Set.Iio x).indicator (fun _ => (1 : ENNReal)) t ∂volume :=
  NumStability.HDP.Scalar.Preliminaries.layerCakePointwise hx

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.LpBanachSpace.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/LpBanachSpace/Contract.lean`
SHA-256: `a1a0f3680f3ad9187ebc50ac6716b94895c60dea0624c5ddfa03eced1f82618a`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Cross-split stable API for `HDP-01-THM-LP-BANACH`.

The source-facing theorem isolates the `p ∈ [1,∞]` normed and complete-space
claim from the reusable model's separate `p < 1` counterexample.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Compatibility source alias for the bundled Chapter 1 `L^p` model. -/
theorem hdp_01_hthm_hlp_hbanach_hquasinorm
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (p : ENNReal) [Fact (1 ≤ p)] :
    NumStability.HDP.Scalar.Preliminaries.LpQuotientBanachModelData μ p :=
  NumStability.HDP.Scalar.Preliminaries.lpQuotientBanach μ p

/-- For every exponent `p ∈ [1,∞]`, the `L^p` quotient has its normed additive
group structure and is complete. -/
theorem hdp_01_hthm_hlp_hbanach_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (p : ENNReal) [Fact (1 ≤ p)] :
    Nonempty (NormedAddCommGroup (MeasureTheory.Lp ℝ p μ)) ∧
      Nonempty (NormedSpace ℝ (MeasureTheory.Lp ℝ p μ)) ∧
      (∀ f : MeasureTheory.Lp ℝ p μ,
        ‖f‖ = ENNReal.toReal (eLpNorm f p μ)) ∧
      IsComplete (Set.univ : Set (MeasureTheory.Lp ℝ p μ)) := by
  exact
    ⟨⟨inferInstance⟩, ⟨inferInstance⟩,
      fun f => MeasureTheory.Lp.norm_def f, complete_univ⟩

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.LpNormedSpace.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/LpNormedSpace/Contract.lean`
SHA-256: `32ae987b90c1c9745c539a51a3966ef8c5fd9f49e01621c249835fd1b3f82fc1`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Cross-split stable API for `HDP-01-DEF-LP-NORM` and
`HDP-01-DEF-LP-SPACE`.

The reusable producer owns Mathlib's representative seminorm, membership
predicate, and almost-everywhere quotient.  This leaf owns the book alias and
the displayed finite-exponent and essential-supremum endpoint formulas.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Stable source-facing representative and quotient `L^p` interface. -/
noncomputable def hdp_01_hdef_hlp_hnorm_hspace
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (p : ENNReal) :
    NumStability.HDP.Scalar.Preliminaries.LpNormSpaceModelData μ p :=
  NumStability.HDP.Scalar.Preliminaries.lpNormSpaceModel μ p

/-- The finite positive-exponent formula for the extended `L^p` norm. -/
theorem hdp_01_hdef_hlp_hnorm_finite_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (p : ENNReal) (hp0 : p ≠ 0) (hpTop : p ≠ ⊤) :
    eLpNorm X p μ =
      (∫⁻ ω, ‖X ω‖ₑ ^ p.toReal ∂μ) ^ (1 / p.toReal) := by
  exact eLpNorm_eq_lintegral_rpow_enorm_toReal hp0 hpTop

/-- The `p = ∞` extension is the essential supremum of the pointwise norm. -/
theorem hdp_01_hdef_hlp_hnorm_infty_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) :
    eLpNorm X (⊤ : ENNReal) μ = eLpNormEssSup X μ := by
  exact eLpNorm_exponent_top

/-- The two displayed `L^p` norm clauses, packaged for a single source audit. -/
theorem hdp_01_hdef_hlp_hnorm_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) :
    (∀ p : ENNReal, p ≠ 0 → p ≠ ⊤ →
      eLpNorm X p μ =
        (∫⁻ ω, ‖X ω‖ₑ ^ p.toReal ∂μ) ^ (1 / p.toReal)) ∧
      eLpNorm X (⊤ : ENNReal) μ = eLpNormEssSup X μ := by
  constructor
  · intro p hp0 hpTop
    exact hdp_01_hdef_hlp_hnorm_finite_spec μ X p hp0 hpTop
  · exact hdp_01_hdef_hlp_hnorm_infty_spec μ X

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.LpQuasinorm.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/LpQuasinorm/Contract.lean`
SHA-256: `53111e13c03ee8457267e6f4e0e0c1d05ee809e409879cc6c07d913d408fa181`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Cross-split stable API for `HDP-01-CLAIM-LP-QUASINORM`.

The source asserts failure of the triangle inequality for every exponent
`0 < p < 1`.  The two-point probability space supplies one uniform witness
family for the whole range.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- The original fixed-exponent Chapter 1 counterexample alias. -/
theorem hdp_01_hthm_hlp_hbanach_hquasinorm_counterexample :
    ∃ (μ : Measure (Fin 2)) (f g : Fin 2 → ℝ),
      IsProbabilityMeasure μ ∧
        ¬ eLpNorm (f + g) (1 / 2 : ENNReal) μ ≤
          eLpNorm f (1 / 2 : ENNReal) μ + eLpNorm g (1 / 2 : ENNReal) μ :=
  NumStability.HDP.Scalar.Preliminaries.twoPointLpTriangleFailure

/-- For every `0 < p < 1`, two disjoint singleton indicators on the uniform
two-point probability space violate the `L^p` triangle inequality. -/
theorem hdp_01_hclaim_hlp_hquasinorm_spec
    (p : ENNReal) (hp0 : 0 < p) (hp1 : p < 1) :
    ∃ (μ : Measure (Fin 2)) (f g : Fin 2 → ℝ),
      IsProbabilityMeasure μ ∧
        ¬ eLpNorm (f + g) p μ ≤ eLpNorm f p μ + eLpNorm g p μ := by
  let μ : Measure (Fin 2) := ProbabilityTheory.uniformOn Set.univ
  let f : Fin 2 → ℝ := Set.indicator ({0} : Set (Fin 2)) (fun _ => 1)
  let g : Fin 2 → ℝ := Set.indicator ({1} : Set (Fin 2)) (fun _ => 1)
  have hμ : IsProbabilityMeasure μ := by
    dsimp [μ]
    infer_instance
  have hμ0 : μ ({0} : Set (Fin 2)) = (1 / 2 : ENNReal) := by
    dsimp [μ]
    rw [ProbabilityTheory.uniformOn_univ]
    simp [Measure.count_apply]
  have hμ1 : μ ({1} : Set (Fin 2)) = (1 / 2 : ENNReal) := by
    dsimp [μ]
    rw [ProbabilityTheory.uniformOn_univ]
    simp [Measure.count_apply]
  have hp_ne_zero : p ≠ 0 := ne_of_gt hp0
  have hp_ne_top : p ≠ ⊤ := ne_of_lt (lt_of_lt_of_le hp1 le_top)
  have hp_toReal_pos : 0 < p.toReal := ENNReal.toReal_pos hp_ne_zero hp_ne_top
  have hp_toReal_lt_one : p.toReal < 1 := by
    simpa using (ENNReal.toReal_lt_toReal hp_ne_top ENNReal.one_ne_top).2 hp1
  have hexponent : 1 < 1 / p.toReal := one_lt_one_div hp_toReal_pos hp_toReal_lt_one
  refine ⟨μ, f, g, hμ, ?_⟩
  have hf : eLpNorm f p μ = (2 : ENNReal)⁻¹ ^ (1 / p.toReal) := by
    dsimp [f]
    rw [eLpNorm_indicator_const (s := ({0} : Set (Fin 2)))
      (c := (1 : ℝ)) (measurableSet_singleton (0 : Fin 2)) hp_ne_zero hp_ne_top]
    rw [hμ0]
    norm_num
  have hg : eLpNorm g p μ = (2 : ENNReal)⁻¹ ^ (1 / p.toReal) := by
    dsimp [g]
    rw [eLpNorm_indicator_const (s := ({1} : Set (Fin 2)))
      (c := (1 : ℝ)) (measurableSet_singleton (1 : Fin 2)) hp_ne_zero hp_ne_top]
    rw [hμ1]
    norm_num
  have hsum : f + g = (fun _ : Fin 2 => (1 : ℝ)) := by
    funext x
    fin_cases x <;> simp [f, g]
  rw [hsum, eLpNorm_const _ hp_ne_zero (by simp [μ]), hf, hg]
  simp [hμ.measure_univ]
  have hhalf : (2 : ENNReal)⁻¹ ^ (1 / p.toReal) < (2 : ENNReal)⁻¹ := by
    have := ENNReal.rpow_lt_rpow_of_exponent_gt
      (x := (2 : ENNReal)⁻¹) (y := 1 / p.toReal) (z := 1)
      (by norm_num) ENNReal.one_half_lt_one hexponent
    simpa using this
  calc
    (2 : ENNReal)⁻¹ ^ p.toReal⁻¹ + 2⁻¹ ^ p.toReal⁻¹ < 2⁻¹ + 2⁻¹ :=
      ENNReal.add_lt_add (by simpa [one_div] using hhalf) (by simpa [one_div] using hhalf)
    _ = 1 := ENNReal.inv_two_add_inv_two

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.MinkowskiInequality.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/MinkowskiInequality/Contract.lean`
SHA-256: `8eb759802cfc31cf8a30dccf8d411a5724c1e28219c013474176d17eac326c1f`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable source-facing forwarding declaration for Minkowski's inequality. -/

namespace NumStability.HDP.Contract

open MeasureTheory

theorem hdp_01_hthm_hminkowski
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {p : ENNReal}
    (hX : AEStronglyMeasurable X μ) (hY : AEStronglyMeasurable Y μ)
    (hp : 1 ≤ p) :
    eLpNorm (X + Y) p μ ≤ eLpNorm X p μ + eLpNorm Y p μ :=
  NumStability.HDP.Scalar.Preliminaries.minkowskiEpnorm hX hY hp

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.MomentGeneratingFunction.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/MomentGeneratingFunction/Contract.lean`
SHA-256: `ebd4528fcdaedbea49642d42eb55841e678a0de2a1bd43c230927e32ea4b9e57`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Cross-split stable API for `HDP-01-DEF-MGF`.

The reusable producer owns the extended nonnegative integral, its finite
domain, and the finite-real interface.  This contract leaf owns the book alias
and the displayed definition.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Stable source-facing extended and finite-real MGF interface. -/
def hdp_01_hdef_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    Type :=
  NumStability.HDP.Scalar.Preliminaries.MGFModelData μ X

/-- The book's displayed formula `M_X(t) = E exp(tX)`, represented by the
nonnegative Lebesgue integral so that no unstated finiteness convention is
required. -/
theorem hdp_01_hdef_hmgf_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (_hX : Measurable X) (t : ℝ) :
    NumStability.HDP.Scalar.Preliminaries.mgf μ X t =
      ∫⁻ ω, ENNReal.ofReal (Real.exp (t * X ω)) ∂μ := by
  rfl

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Moments.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Moments/Contract.lean`
SHA-256: `19f38fbdf90417e27052cd24b8efdd9477dfcce494699e87e5acb5b5371c6220`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Cross-split stable API for `HDP-01-DEF-MOMENTS`.

The printed raw real-power formula is not real-valued for every real random
variable and every positive real exponent.  This leaf records a concrete
square-root obstruction and exposes the corrected natural-raw/real-absolute
split; the reusable producer owns the underlying definitions.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Stable source-facing corrected moment interface. -/
def hdp_01_hdef_hmoments
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    Type :=
  NumStability.HDP.Scalar.Preliminaries.MomentModelData μ X

/-- There is no real-valued square-root operation on all real inputs, the
`p = 1/2`, `X = -1` obstruction to the printed raw real-power formula. -/
theorem hdp_01_hdef_hmoments_source_obstruction :
    ¬ ∃ sqrtLike : ℝ → ℝ, ∀ x : ℝ, (sqrtLike x) ^ 2 = x := by
  rintro ⟨sqrtLike, hsqrt⟩
  exact NumStability.HDP.Scalar.Preliminaries.no_real_square_root_neg_one
    ⟨sqrtLike (-1), by simpa using hsqrt (-1)⟩

/-- Corrected formulas: raw moments use natural powers, while positive-real
absolute moments use the nonnegative extended Lebesgue integral. -/
theorem hdp_01_hdef_hmoments_corrected
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ)
    (n : ℕ) (p : ℝ) (_hp : 0 < p) :
    NumStability.HDP.Scalar.Preliminaries.rawMoment μ X n =
        NumStability.HDP.Scalar.Preliminaries.expectation μ
          (fun ω => X ω ^ n) ∧
      NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p =
        ∫⁻ ω, ENNReal.ofReal (Real.rpow |X ω| p) ∂μ := by
  constructor <;> rfl

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Section01.Remark01.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Section01/Remark01/Contract.lean`
SHA-256: `478f5d74d8421ddcd91dd70667101db7955e4efb792cb43bdd7ef83ac72a3389`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Compatibility leaf for the original Remark 1.1.1 covariance-bound alias. -/

namespace NumStability.HDP.Contract

open MeasureTheory

theorem hdp_01_hrem_h1_d1_d1
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℝ}
    (hX : MemLp X 2 μ) (hY : MemLp Y 2 μ) :
    ‖NumStability.HDP.Scalar.Preliminaries.covariance μ X Y‖ ≤
      NumStability.HDP.Scalar.Preliminaries.standardDeviation μ X *
        NumStability.HDP.Scalar.Preliminaries.standardDeviation μ Y :=
  NumStability.HDP.Scalar.Preliminaries.covarianceCauchySchwarzBound hX hY

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Corollary05.Contract.Theorem`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Section02/Corollary05/Contract/Theorem.lean`
SHA-256: `ccca610de3b07521f07da24ac0186e47682f5b94226858f06950d4a9c46995c1`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable Chapter 1 forwarding module for Corollary 1.2.5. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Chebyshev's inequality for a real random variable with finite centered
second moment. -/
theorem hdp_01_hcor_h1_d2_d5
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hInt : Integrable X μ)
    (hSqInt : Integrable
      (fun ω => (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) μ)
    {t : ℝ} (ht : 0 < t) :
    μ.real {ω | |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t} ≤
      NumStability.HDP.Scalar.Preliminaries.variance μ X / t ^ 2 :=
  NumStability.HDP.Scalar.Preliminaries.chebyshevEventBound hX hInt hSqInt ht

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise02.Contract.Theorem`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Section02/Exercise02/Contract/Theorem.lean`
SHA-256: `94db374b4e168430b9bd057e9f51f8f2d86026459ac5f8011efc6daf8baa068f`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable Chapter 1 forwarding module for the corrected form of
    Exercise 1.2.2. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory

/-! Stable Chapter 1 alias for the corrected signed-tail statement and its
standard-Cauchy obstruction in Exercise 1.2.2. -/
theorem hdp_01_hex_h1_d2_d2
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    (
      (((∫⁻ ω, ENNReal.ofReal (max (X ω) 0) ∂μ =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < max (X ω) 0}) ∧
      (∫⁻ ω, ENNReal.ofReal (max (-X ω) 0) ∂μ =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < max (-X ω) 0})) ∧
      (∀ hInt : Integrable X μ,
        (∫ ω, X ω ∂μ) =
          (∫ t in Set.Ioi 0, μ.real {a | t < X a}) -
            (∫ t in Set.Iio 0, μ.real {a | X a < t})))
      ∧
        ((∫⁻ t in Set.Ioi 0,
          Probability.cauchyMeasure 0 1 {x | t < x}) = ⊤) ∧
        ((∫⁻ t in Set.Iio 0,
          Probability.cauchyMeasure 0 1 {x | x < t}) = ⊤)
    ) := by
  exact NumStability.HDP.Scalar.Preliminaries.exercise122CorrectedWithCauchy hX

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise03.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Section02/Exercise03/Contract.lean`
SHA-256: `00f0db809947abfd2a12b89bcabc69e0b371f35b221375eb2158064c92de722a`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Source-facing contract for Exercise 1.2.3, the tail formula for positive
absolute moments. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory

/-- The positive `p)-th absolute moment is the weighted integral of the
strict tail probabilities. The second conjunct exposes the corresponding
finite-real equality whenever either extended side is finite. -/
theorem hdp_01_hex_h1_d2_d3
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) {p : ℝ} (hp : 0 < p) :
    (NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p =
        ENNReal.ofReal p *
          ∫⁻ t in Set.Ioi 0,
            μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) ∧
      (∀ hfinite :
          NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p <
              (⊤ : ENNReal) ∨
            ENNReal.ofReal p *
                ∫⁻ t in Set.Ioi 0,
                  μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1)) <
              (⊤ : ENNReal),
        (NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p).toReal =
          (ENNReal.ofReal p *
            ∫⁻ t in Set.Ioi 0,
              μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))).toReal) :=
  NumStability.HDP.Scalar.Preliminaries.momentTailFormula hX hp

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise06.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Section02/Exercise06/Contract.lean`
SHA-256: `9a0a6f90c1e8a808ba3e19ec922b064a3aafad84fb7a23fbe2769ff1b365b84c`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable Chapter 1 source-facing declaration for Exercise 1.2.6. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory

/-- The Chebyshev bound obtained by applying Markov's inequality to the
squared centered random variable. -/
theorem hdp_01_hex_h1_d2_d6
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hInt : Integrable X μ)
    (hSqInt : Integrable
      (fun ω => (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) μ)
    {t : ℝ} (ht : 0 < t) :
    μ.real {ω | |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t} ≤
      NumStability.HDP.Scalar.Preliminaries.variance μ X / t ^ 2 :=
  NumStability.HDP.Scalar.Preliminaries.chebyshevEventBound hX hInt hSqInt ht

/-- Exercise 1.2.6 with its requested derivation exposed propositionally: the
absolute-deviation event is the threshold event for the squared centered
variable, Markov applies at threshold `t²`, and the resulting expectation is
the variance. -/
theorem hdp_01_hex_h1_d2_d6_derivation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hInt : Integrable X μ)
    (hSqInt : Integrable
      (fun ω => (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) μ)
    {t : ℝ} (ht : 0 < t) :
    let Y := fun ω =>
      (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2
    (Y ⁻¹' Set.Ici (t ^ 2) =
        {ω | |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t}) ∧
      (μ.real (Y ⁻¹' Set.Ici (t ^ 2)) ≤
        NumStability.HDP.Scalar.Preliminaries.expectation μ Y / t ^ 2) ∧
      (NumStability.HDP.Scalar.Preliminaries.expectation μ Y =
        NumStability.HDP.Scalar.Preliminaries.variance μ X) ∧
      (μ.real {ω |
          |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t} ≤
        NumStability.HDP.Scalar.Preliminaries.variance μ X / t ^ 2) := by
  dsimp only
  have hY : Measurable
      (fun ω => (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) :=
    (hX.sub measurable_const).pow_const 2
  have hMarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
      (X := fun ω =>
        (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2)
      hY (ae_of_all μ (fun ω => sq_nonneg _)) hSqInt (sq_pos_of_pos ht)
  have hEvent :
      (fun ω =>
        (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) ⁻¹'
          Set.Ici (t ^ 2) =
        {ω | |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t} := by
    ext ω
    constructor
    · intro hω
      have hs : t ^ 2 ≤
          (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2 := hω
      have hs' : |t| ≤
          |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| :=
        (sq_le_sq).mp hs
      simpa [abs_of_pos ht] using hs'
    · intro hω
      have habs : t ≤
          |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| := hω
      have hs' : |t| ≤
          |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| := by
        simpa [abs_of_pos ht] using habs
      exact (sq_le_sq).mpr hs'
  refine ⟨hEvent, ?_, rfl, hdp_01_hex_h1_d2_d6 hX hInt hSqInt ht⟩
  simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hMarkov

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Lemma01.Contract.Theorem`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Section02/Lemma01/Contract/Theorem.lean`
SHA-256: `d1fcdf321fc2ac8a513d552c6efbeae6827c9dfa28bef1f7acc7f195323c6ddf`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Stable Chapter 1 forwarding module for Lemma 1.2.1 (the layer-cake identity).

The semantic producer is `layerCakeExpectation`; this leaf exposes the single
source-facing alias for the numbered row. A second, byte-identical alias
(`hdp_01_hlem_h1_d2_d1`) previously stood alongside the one below with the same
statement and the same proof term; it had no consumer anywhere in the
repository and was removed as a duplicate semantic wrapper, leaving one
canonical producer and one source-facing wrapper.
-/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- The complete nonnegative layer-cake identity: an always-defined extended
identity together with its finite real-expectation specialization. -/
theorem hdp_01_hlem_h1_d2_d1_spec
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ ω, 0 ≤ X ω) :
    ((∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < X ω}) ∧
      (∀ hInt : Integrable X μ,
        expectation μ X = ∫ t in Set.Ioi 0, μ.real {ω | t < X ω}) :=
  layerCakeExpectation hX hNonneg

/-- The historical layer-cake theorem retained from main. -/
theorem hdp_01_hlem_h1_d2_d1
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hNonneg : ∀ ω, 0 ≤ X ω) :
    ((∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) =
        ∫⁻ t in Set.Ioi 0, μ {ω | t < X ω}) ∧
      (∀ hInt : Integrable X μ,
        NumStability.HDP.Scalar.Preliminaries.expectation μ X =
          ∫ t in Set.Ioi 0, μ.real {ω | t < X ω}) :=
  NumStability.HDP.Scalar.Preliminaries.layerCakeExpectation hX hNonneg

end NumStability.HDP.Contract
```

### `ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Proposition04.Decomposition.Contract`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter01/Section02/Proposition04/Decomposition/Contract.lean`
SHA-256: `cd47d7d9804ab4d9396bf53f5467fc81c355d2db060dfe9922b7139675c0d893`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable Chapter 1 contract for the pointwise decomposition in Markov's proof. -/

namespace NumStability.HDP.Contract

/-- The indicator lower bound used in the source proof of Markov's inequality. -/
theorem hdp_01_hlem_hmarkov_hindicator_hbound {x t : ℝ}
    (hx : 0 ≤ x) (ht : 0 < t) :
    t * Set.indicator (Set.Ici t) (fun _ => (1 : ℝ)) x ≤ x :=
  NumStability.HDP.Scalar.Preliminaries.markovIndicatorBound hx ht

/-- A real number splits across the complementary events `x ≥ t` and `x < t`. -/
theorem hdp_01_hprop_h1_d2_d4_hdecomposition_spec (x t : ℝ) :
    x = x * (if t ≤ x then 1 else 0) +
      x * (if x < t then 1 else 0) := by
  by_cases h : t ≤ x
  · simp [h, not_lt_of_ge h]
  · have h' : x < t := lt_of_not_ge h
    simp [h, h']

end NumStability.HDP.Contract
```

### `ComputationalMathematics.HDP.Scalar.Preliminaries`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/Preliminaries.lean`
SHA-256: `be07a3677f709766c44501c44048bf5651a74a8299b9a2f92792c84ec9859230`

```lean
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic
import ComputationalMathematics.Source.Vershynin.Chapter01.ConvexFunction.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.DistributionDetermined.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.Equation03.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.HolderInequality.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.Indicator.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.JensenInequality.Contract.Theorem
import ComputationalMathematics.Source.Vershynin.Chapter01.LayerCakePointwise.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.LpBanachSpace.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.LpNormedSpace.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.LpQuasinorm.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.MinkowskiInequality.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.MomentGeneratingFunction.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.Moments.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.Section01.Remark01.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Corollary05.Contract.Theorem
import ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise02.Contract.Theorem
import ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise03.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Exercise06.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Lemma01.Contract.Theorem
import ComputationalMathematics.Source.Vershynin.Chapter01.Section02.Proposition04.Decomposition.Contract

/-!
# Public preliminary probability interfaces

This import-only facade preserves the historical scalar import surface. Its
semantic definitions and proofs are owned by `Basic`; the imported Vershynin
contract leaves own the Chapter 1 aliases and their source specifications.
-/
```

### `ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/IndependentSums/Hoeffding.lean`
SHA-256: `9997a435d5364764d314614b4b2a4ab28c72f3083b43f373cc4f179132063f9f`

```lean
import Mathlib.Probability.Independence.Integration
import Mathlib.Probability.Moments.Basic
import Mathlib.Probability.Moments.SubGaussian
import Mathlib.Probability.ProbabilityMassFunction.Constructions
import Mathlib.Probability.ProbabilityMassFunction.Integrals
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Series
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals
import Mathlib.Tactic
import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
# MGF tensorization for independent sums

This module records the finite mutual-independence bridge behind the MGF
calculation in Chapter 2.  The exponential integrability hypotheses keep the
real-valued expectation interface honest; the weighted form includes the
unweighted sum by taking every coefficient to be one.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-! The symmetric Bernoulli/Rademacher law from Definition 2.2.1. -/

/-- The affine encoding of a Boolean outcome as a Rademacher value. -/
def rademacherValue : Bool → ℝ := fun b => if b then 1 else -1

/-- The corresponding `{0,1}`-valued Bernoulli indicator. -/
def bernoulliIndicator : Bool → ℝ := fun b => if b then 1 else 0

/-- The fair Bernoulli law used by the canonical coupling. -/
noncomputable def fairBernoulliPMF : PMF Bool :=
  PMF.bernoulli (1 / 2 : ℝ≥0) (by norm_num)

/-- The symmetric Bernoulli/Rademacher law on `{-1,1}`. -/
noncomputable def rademacherPMF : PMF ℝ :=
  fairBernoulliPMF.map rademacherValue

/-- Pointwise, the Rademacher encoding is `2X-1` for a fair indicator. -/
theorem rademacherValue_eq_affine (b : Bool) :
    rademacherValue b = 2 * bernoulliIndicator b - 1 := by
  cases b
  · norm_num [rademacherValue, bernoulliIndicator]
  · norm_num [rademacherValue, bernoulliIndicator]; rfl

/-- The affine map which sends the usual Bernoulli support `{0, 1}` to the
Rademacher support `{-1, 1}`. -/
def affineBernoulliValue (x : ℝ) : ℝ := 2 * x - 1

/-- The inverse affine map from the Rademacher scale to the usual Bernoulli
scale. -/
def inverseAffineBernoulliValue (z : ℝ) : ℝ := (z + 1) / 2

/-- The fair usual Bernoulli law, represented on the real support `{0, 1}`. -/
noncomputable def fairBernoulliRealPMF : PMF ℝ :=
  fairBernoulliPMF.map bernoulliIndicator

/-- A real-valued law is the usual fair Bernoulli law exactly when its affine
image under `x ↦ 2x - 1` is the symmetric Bernoulli/Rademacher law.  This is
the arbitrary-law form of the equivalence following Definition 2.2.1. -/
theorem affineLawIsRademacherIff (q : PMF ℝ) :
    q.map affineBernoulliValue = rademacherPMF ↔
      q = fairBernoulliRealPMF := by
  constructor
  · intro h
    have h' := congrArg (fun law : PMF ℝ =>
      law.map inverseAffineBernoulliValue) h
    unfold rademacherPMF at h'
    change (q.map affineBernoulliValue).map inverseAffineBernoulliValue =
      (fairBernoulliPMF.map rademacherValue).map
        inverseAffineBernoulliValue at h'
    rw [PMF.map_comp, PMF.map_comp] at h'
    have hinv : inverseAffineBernoulliValue ∘ affineBernoulliValue = id := by
      funext x
      simp only [Function.comp_apply, affineBernoulliValue,
        inverseAffineBernoulliValue, id_eq]
      ring
    have hbool : inverseAffineBernoulliValue ∘ rademacherValue =
        bernoulliIndicator := by
      funext b
      cases b <;> norm_num [Function.comp_apply, inverseAffineBernoulliValue,
        rademacherValue, bernoulliIndicator]
    rw [hinv, hbool, PMF.map_id] at h'
    exact h'
  · intro h
    subst q
    unfold fairBernoulliRealPMF rademacherPMF
    rw [PMF.map_comp]
    congr 1
    funext b
    cases b <;> norm_num [Function.comp_apply, affineBernoulliValue,
      rademacherValue, bernoulliIndicator]
    rfl

/-- An arbitrary real probability measure is the ordinary fair Bernoulli law
exactly when its affine image under `x ↦ 2x - 1` is the Rademacher law.  Unlike
the PMF specialization, this theorem retains the source sentence's full law
domain and does not assume discreteness in advance. -/
theorem affineMeasureIsRademacherIff (mu : Measure ℝ) :
    Measure.map affineBernoulliValue mu = rademacherPMF.toMeasure ↔
      mu = fairBernoulliRealPMF.toMeasure := by
  have hAffine : Measurable affineBernoulliValue := by
    unfold affineBernoulliValue
    fun_prop
  have hInverse : Measurable inverseAffineBernoulliValue := by
    unfold inverseAffineBernoulliValue
    fun_prop
  have hinv : inverseAffineBernoulliValue ∘ affineBernoulliValue = id := by
    funext x
    simp only [Function.comp_apply, affineBernoulliValue,
      inverseAffineBernoulliValue, id_eq]
    ring
  have hbool : inverseAffineBernoulliValue ∘ rademacherValue =
      bernoulliIndicator := by
    funext b
    cases b <;> norm_num [Function.comp_apply, inverseAffineBernoulliValue,
      rademacherValue, bernoulliIndicator]
  have href : Measure.map inverseAffineBernoulliValue
      rademacherPMF.toMeasure = fairBernoulliRealPMF.toMeasure := by
    rw [PMF.toMeasure_map inverseAffineBernoulliValue rademacherPMF hInverse]
    congr 1
    unfold rademacherPMF fairBernoulliRealPMF
    rw [PMF.map_comp, hbool]
  constructor
  · intro h
    have h' := congrArg (Measure.map inverseAffineBernoulliValue) h
    change Measure.map inverseAffineBernoulliValue
        (Measure.map affineBernoulliValue mu) =
      Measure.map inverseAffineBernoulliValue rademacherPMF.toMeasure at h'
    rw [Measure.map_map hInverse hAffine, hinv,
      Measure.map_id, href] at h'
    exact h'
  · intro h
    subst mu
    rw [PMF.toMeasure_map affineBernoulliValue fairBernoulliRealPMF hAffine]
    exact congrArg PMF.toMeasure
      ((affineLawIsRademacherIff fairBernoulliRealPMF).2 rfl)

@[simp]
theorem rademacherPMF_mass_one : rademacherPMF 1 = 1 / 2 := by
  simp [rademacherPMF, fairBernoulliPMF, rademacherValue, PMF.map_apply,
    PMF.bernoulli_apply]
  norm_num

@[simp]
theorem rademacherPMF_mass_neg_one : rademacherPMF (-1) = 1 / 2 := by
  simp [rademacherPMF, fairBernoulliPMF, rademacherValue, PMF.map_apply,
    PMF.bernoulli_apply]
  norm_num

theorem rademacherPMF_mean :
    ∫ x : ℝ, x ∂rademacherPMF.toMeasure = 0 := by
  let f : Bool → ℝ := rademacherValue
  have hf : Measurable f := measurable_of_countable f
  unfold rademacherPMF
  rw [← PMF.toMeasure_map f]
  · change (∫ y : ℝ, id y ∂Measure.map f
      fairBernoulliPMF.toMeasure) = 0
    rw [MeasureTheory.integral_map hf.aemeasurable
      (continuous_id.aestronglyMeasurable)]
    rw [PMF.integral_eq_sum]
    simp [f, fairBernoulliPMF, rademacherValue, PMF.bernoulli_apply]
    norm_num
  · exact hf

theorem rademacherPMF_variance :
    ∫ x : ℝ, (x - 0) ^ 2 ∂rademacherPMF.toMeasure = 1 := by
  let f : Bool → ℝ := rademacherValue
  have hf : Measurable f := measurable_of_countable f
  unfold rademacherPMF
  rw [← PMF.toMeasure_map f]
  · change (∫ y : ℝ, (id y - 0) ^ 2 ∂Measure.map f
      fairBernoulliPMF.toMeasure) = 1
    rw [MeasureTheory.integral_map hf.aemeasurable
      (((continuous_id.sub continuous_const).pow 2).aestronglyMeasurable)]
    rw [PMF.integral_eq_sum]
    simp [f, fairBernoulliPMF, rademacherValue, PMF.bernoulli_apply]
  · exact hf

theorem rademacherPMF_abs :
    ∫ x : ℝ, |x| ∂rademacherPMF.toMeasure = 1 := by
  let f : Bool → ℝ := rademacherValue
  have hf : Measurable f := measurable_of_countable f
  unfold rademacherPMF
  rw [← PMF.toMeasure_map f]
  · change (∫ y : ℝ, |y| ∂Measure.map f
      fairBernoulliPMF.toMeasure) = 1
    rw [MeasureTheory.integral_map hf.aemeasurable
      (continuous_abs.aestronglyMeasurable)]
    rw [PMF.integral_eq_sum]
    simp [f, fairBernoulliPMF, rademacherValue, PMF.bernoulli_apply]
  · exact hf

/-- The affine Bernoulli coupling is Rademacher exactly at the fair parameter. -/
theorem affineBernoulliIsRademacherIff {p : ℝ≥0} (hp : p ≤ 1) :
    PMF.map rademacherValue (PMF.bernoulli p hp) = rademacherPMF ↔
      p = (1 / 2 : ℝ≥0) := by
  constructor
  · intro h
    have h1 := congrArg (fun q : PMF ℝ => q 1) h
    have hneq : (1 : ℝ) ≠ -1 := by norm_num
    have h1simp : (p : ℝ≥0∞) = (1 / 2 : ℝ≥0∞) := by
      simpa [rademacherPMF, fairBernoulliPMF, PMF.map_apply,
        rademacherValue, PMF.bernoulli_apply, hneq] using h1
    have h1nn : (p : ℝ≥0∞) = ((1 / 2 : ℝ≥0) : ℝ≥0∞) := by
      convert h1simp using 1; norm_num
    exact_mod_cast h1nn
  · intro hp'
    subst p
    rfl

/-- The complete source-facing package for Definition 2.2.1. -/
structure RademacherModelData where
  /-- The symmetric two-point probability mass function. -/
  law : PMF ℝ
  mass_one : law 1 = 1 / 2
  mass_neg_one : law (-1) = 1 / 2
  affine_bernoulli_iff :
    ∀ {p : ℝ≥0} (hp : p ≤ 1),
      PMF.map rademacherValue (PMF.bernoulli p hp) = law ↔
        p = (1 / 2 : ℝ≥0)
  mean : ∫ x : ℝ, x ∂law.toMeasure = 0
  variance : ∫ x : ℝ, (x - 0) ^ 2 ∂law.toMeasure = 1
  abs_mean : ∫ x : ℝ, |x| ∂law.toMeasure = 1

/-- Canonical Rademacher law and its defining Bernoulli coupling and moments. -/
noncomputable def rademacherModel : RademacherModelData :=
  { law := rademacherPMF
    mass_one := rademacherPMF_mass_one
    mass_neg_one := rademacherPMF_mass_neg_one
    affine_bernoulli_iff := fun hp => affineBernoulliIsRademacherIff hp
    mean := rademacherPMF_mean
    variance := rademacherPMF_variance
    abs_mean := rademacherPMF_abs }

/-- The MGF of a weighted finite sum factors under mutual independence. -/
theorem mgfIndependentSum
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} (lam : ℝ) (a : ι → ℝ)
    (hX : iIndepFun X μ)
    (hExp : ∀ i, Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ) :
    ∫ ω, Real.exp (lam * ∑ i, a i * X i ω) ∂μ =
      ∏ i, ∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ := by
  let Y : ι → Ω → ℝ := fun i ω => Real.exp (lam * (a i * X i ω))
  have hY : iIndepFun Y μ := by
    let g : ∀ i, ℝ → ℝ := fun i x => Real.exp (lam * (a i * x))
    have hg : ∀ i, Measurable (g i) := by
      intro i
      fun_prop
    have h := hX.comp g hg
    simpa [Y, g, Function.comp_def] using h
  have hY_meas : ∀ i, AEStronglyMeasurable (Y i) μ := by
    intro i
    exact (hExp i).aestronglyMeasurable
  calc
    ∫ ω, Real.exp (lam * ∑ i, a i * X i ω) ∂μ =
        ∫ ω, ∏ i, Y i ω ∂μ := by
          apply integral_congr_ae
          filter_upwards [] with ω
          simp only [Y]
          rw [Finset.mul_sum, Real.exp_sum]
    _ = ∏ i, ∫ ω, Y i ω ∂μ := by
      simpa only [Finset.prod_apply] using
        hY.integral_prod_eq_prod_integral hY_meas
    _ = ∏ i, ∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ := by
      rfl

/-- The centered bounded-variable Hoeffding lemma, with all real MGF
parameters bundled by Mathlib's sub-Gaussian interface. -/
theorem hoeffdingBoundedMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {a b : ℝ}
    (hX : AEMeasurable X μ)
    (hbound : ∀ᵐ ω ∂μ, X ω ∈ Set.Icc a b)
    (hmean : ∫ ω, X ω ∂μ = 0) :
    HasSubgaussianMGF X ((‖b - a‖₊ / 2) ^ 2) μ :=
  ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero
    hX hbound hmean

/-- The noncentered bounded-variable form, obtained by subtracting the mean. -/
theorem hoeffdingCenteredMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {a b : ℝ}
    (hX : AEMeasurable X μ)
    (hbound : ∀ᵐ ω ∂μ, X ω ∈ Set.Icc a b) :
    HasSubgaussianMGF (fun ω => X ω - ∫ y, X y ∂μ)
      ((‖b - a‖₊ / 2) ^ 2) μ :=
  ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc hX hbound

/-! The one-variable quadratic optimization used by the Hoeffding tail proof. -/
theorem hoeffdingOptimization {v t : ℝ} (hv : 0 < v) (ht : 0 ≤ t) :
    (∀ u : ℝ, 0 ≤ u →
      -t ^ 2 / (2 * v) ≤ -u * t + u ^ 2 * v / 2) ∧
      (-(t / v) * t + (t / v) ^ 2 * v / 2 = -t ^ 2 / (2 * v)) := by
  constructor
  · intro u hu
    have hsq : 0 ≤ (u * v - t) ^ 2 := sq_nonneg (u * v - t)
    field_simp
    nlinarith
  · field_simp
    ring

/-! The coefficientwise hyperbolic-cosine estimate used by Rademacher MGF bounds. -/
theorem coshLeExpHalfSq (x : ℝ) :
    Real.cosh x ≤ Real.exp (x ^ 2 / 2) :=
  Real.cosh_le_exp_half_sq x

/-! The one-sided finite exponential-Markov upper tail bound. -/
theorem exponentialMarkovUpper
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {S : Ω → ℝ} (hS : Measurable S)
    {lam t : ℝ} (hlam : 0 < lam)
    (hExp : Integrable (fun ω => Real.exp (lam * S ω)) μ) :
    μ.real (S ⁻¹' Set.Ici t) ≤
      Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * S ω) ∂μ) := by
  let Y : Ω → ℝ := fun ω => Real.exp (lam * S ω)
  have hY : Measurable Y := by
    simpa [Y] using (hS.const_mul lam).exp
  have hY_nonneg : ∀ᵐ ω ∂μ, 0 ≤ Y ω :=
    Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _))
  have hY_int : Integrable Y μ := by
    simpa [Y] using hExp
  have hY_markov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
      hY hY_nonneg hY_int (Real.exp_pos (lam * t))
  have measureReal_mono_prob {A B : Set Ω} (hAB : A ⊆ B) :
      μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  have hsubset : S ⁻¹' Set.Ici t ⊆
      Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
    intro ω hω
    change t ≤ S ω at hω
    change Real.exp (lam * t) ≤ Real.exp (lam * S ω)
    exact (Real.exp_le_exp).2 (mul_le_mul_of_nonneg_left hω hlam.le)
  calc
    μ.real (S ⁻¹' Set.Ici t) ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (lam * t))) :=
      measureReal_mono_prob hsubset
    _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (lam * t) := by
      simpa [Preliminaries.expectation] using hY_markov
    _ = Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * S ω) ∂μ) := by
      simp [Y, Real.exp_neg, div_eq_mul_inv]
      ring

/-! The exact one-coordinate MGF of a Rademacher law. -/
theorem rademacherWeightedMGFEqCosh
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hLaw : Measure.map X μ = rademacherPMF.toMeasure)
    (lam a : ℝ) :
    (∫ ω, Real.exp (lam * (a * X ω)) ∂μ) = Real.cosh (lam * a) := by
  let f : ℝ → ℝ := fun x => Real.exp (lam * (a * x))
  have hf : Measurable f := by fun_prop
  have hmap_integral :
      (∫ ω, Real.exp (lam * (a * X ω)) ∂μ) =
        ∫ x : ℝ, Real.exp (lam * (a * x)) ∂Measure.map X μ := by
    symm
    rw [MeasureTheory.integral_map hX.aemeasurable hf.aestronglyMeasurable]
  rw [hmap_integral, hLaw]
  unfold rademacherPMF
  rw [← PMF.toMeasure_map rademacherValue]
  · rw [MeasureTheory.integral_map
      (measurable_of_countable rademacherValue).aemeasurable
      hf.aestronglyMeasurable]
    rw [PMF.integral_eq_sum]
    simp [f, fairBernoulliPMF, rademacherValue, PMF.bernoulli_apply]
    calc
      2⁻¹ * Real.exp (lam * a) +
          (1 - 2⁻¹) * Real.exp (-(lam * a)) =
          (Real.exp (lam * a) + Real.exp (-(lam * a))) / 2 := by ring
      _ = Real.cosh (lam * a) := by rw [Real.cosh_eq]
  · exact measurable_of_countable rademacherValue

/-! The one-coordinate MGF estimate for a Rademacher law. -/
theorem rademacherWeightedMGFLe
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hLaw : Measure.map X μ = rademacherPMF.toMeasure)
    (lam a : ℝ) :
    (∫ ω, Real.exp (lam * (a * X ω)) ∂μ) ≤
      Real.exp ((lam * a) ^ 2 / 2) := by
  calc
    (∫ ω, Real.exp (lam * (a * X ω)) ∂μ) = Real.cosh (lam * a) :=
      rademacherWeightedMGFEqCosh hX hLaw lam a
    _ ≤ Real.exp ((lam * a) ^ 2 / 2) := coshLeExpHalfSq (lam * a)

/-! One-sided Rademacher Hoeffding, with the positive coefficient-energy branch
made explicit so the optimized exponent never divides by zero. -/
theorem integrable_exp_mul_rademacher
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X)
    (hLaw : Measure.map X μ = rademacherPMF.toMeasure)
    (lam a : ℝ) :
    Integrable (fun ω => Real.exp (lam * (a * X ω))) μ := by
  let f : ℝ → ℝ := fun x => Real.exp (lam * (a * x))
  have hf_rademacher : Integrable f rademacherPMF.toMeasure := by
    unfold rademacherPMF
    rw [← PMF.toMeasure_map]
    · rw [integrable_map_measure (by fun_prop)
          (measurable_of_countable rademacherValue).aemeasurable]
      exact Integrable.of_finite
    · exact measurable_of_countable rademacherValue
  have hf_map : Integrable f (Measure.map X μ) := by
    rw [hLaw]
    exact hf_rademacher
  simpa [f, Function.comp_def] using hf_map.comp_measurable hX

theorem rademacherHoeffding
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {a : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hLaw : ∀ i, Measure.map (X i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ)
    (ht : 0 ≤ t) (hv : 0 < ∑ i, (a i) ^ 2) :
    μ.real {ω | ∑ i, a i * X i ω ≥ t} ≤
      Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) := by
  let v : ℝ := ∑ i, (a i) ^ 2
  let S : Ω → ℝ := fun ω => ∑ i, a i * X i ω
  have hS_meas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ
      (fun i _ => (hX i).const_mul (a i))
  have hS_exp (lam : ℝ) :
      Integrable (fun ω => Real.exp (lam * S ω)) μ := by
    let Y : ι → Ω → ℝ := fun i ω => a i * X i ω
    have hY_meas : ∀ i, Measurable (Y i) := by
      intro i
      simpa [Y] using (hX i).const_mul (a i)
    have hY_indep : iIndepFun Y μ := by
      have hcomp := hIndep.comp (fun i x => a i * x)
        (fun _ => by fun_prop)
      simpa [Y, Function.comp_def] using hcomp
    have hY_exp : ∀ i, Integrable (fun ω => Real.exp (lam * Y i ω)) μ := by
      intro i
      simpa [Y] using hExp lam i
    have h := hY_indep.integrable_exp_mul_sum hY_meas
      (s := Finset.univ) (fun i _ => hY_exp i)
    simpa [S, Y] using h
  have hmgf (lam : ℝ) :
      (∫ ω, Real.exp (lam * S ω) ∂μ) =
        ∏ i, ∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ := by
    simpa [S] using
      (mgfIndependentSum (μ := μ) (X := X) lam a hIndep (hExp lam))
  have hfactor (lam : ℝ) (i : ι) :
      (∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ) ≤
        Real.exp ((lam * a i) ^ 2 / 2) :=
    rademacherWeightedMGFLe (hX i) (hLaw i) lam (a i)
  by_cases ht0 : t = 0
  · rw [ht0]
    have hprob : μ.real {ω | ∑ i, a i * X i ω ≥ 0} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    simpa [v] using hprob
  · have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm ht0)
    let lam : ℝ := t / v
    have hlam : 0 < lam := div_pos htpos (by simpa [v] using hv)
    have hupper := exponentialMarkovUpper hS_meas (lam := lam) (t := t)
      hlam (hS_exp lam)
    have hprod :
        (∏ i, ∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ) ≤
          ∏ i, Real.exp ((lam * a i) ^ 2 / 2) := by
      apply Finset.prod_le_prod
      · intro i hi
        exact MeasureTheory.integral_nonneg (fun ω => Real.exp_nonneg _)
      · intro i hi
        exact hfactor lam i
    have hmgf_upper :
        (∫ ω, Real.exp (lam * S ω) ∂μ) ≤
          Real.exp (lam ^ 2 * v / 2) := by
      rw [hmgf lam]
      calc
        (∏ i, ∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ) ≤
            ∏ i, Real.exp ((lam * a i) ^ 2 / 2) := hprod
        _ = Real.exp (lam ^ 2 * v / 2) := by
          rw [← Real.exp_sum]
          congr 1
          dsimp [v]
          ring_nf
          rw [Finset.mul_sum, Finset.sum_mul]
    calc
      μ.real {ω | ∑ i, a i * X i ω ≥ t} =
          μ.real (S ⁻¹' Set.Ici t) := by rfl
      _ ≤ Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * S ω) ∂μ) := by
        simpa using hupper
      _ ≤ Real.exp (-(lam * t)) * Real.exp (lam ^ 2 * v / 2) :=
        mul_le_mul_of_nonneg_left hmgf_upper (Real.exp_nonneg _)
      _ = Real.exp (-t ^ 2 / (2 * v)) := by
        rw [← Real.exp_add]
        congr 1
        dsimp [lam]
        field_simp [ne_of_gt (by simpa [v] using hv)]
        ring
      _ = Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) := by rfl

/-- Source-form one-sided Rademacher Hoeffding.  The exponential moments are
automatic from the Rademacher laws, and the zero-energy branch has right-hand
side one under the real-division convention. -/
theorem rademacherHoeffdingAll
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {a : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hLaw : ∀ i, Measure.map (X i) μ = rademacherPMF.toMeasure)
    (ht : 0 ≤ t) :
    μ.real {ω | ∑ i, a i * X i ω ≥ t} ≤
      Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) := by
  have hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ := by
    intro lam i
    exact integrable_exp_mul_rademacher (hX i) (hLaw i) lam (a i)
  by_cases hv : 0 < ∑ i, (a i) ^ 2
  · exact rademacherHoeffding hX hIndep hLaw hExp ht hv
  · have hv_nonneg : 0 ≤ ∑ i, (a i) ^ 2 :=
      Finset.sum_nonneg fun i _ => sq_nonneg (a i)
    have hv_zero : ∑ i, (a i) ^ 2 = 0 :=
      le_antisymm (le_of_not_gt hv) hv_nonneg
    have hprob : μ.real {ω | ∑ i, a i * X i ω ≥ t} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    simpa [hv_zero] using hprob

/-- Zero coefficient energy is the deterministic zero-sum branch. -/
theorem rademacherHoeffdingZero
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {a : ι → ℝ} {t : ℝ}
    (ha : ∀ i, a i = 0) (ht : 0 < t) :
    μ.real {ω | ∑ i, a i * X i ω ≥ t} = 0 := by
  have hevent : {ω | ∑ i, a i * X i ω ≥ t} = (∅ : Set Ω) := by
    ext ω
    simp [ha, ht]
  rw [hevent]
  simp

/-! Two-sided Rademacher Hoeffding, using the explicit sign-symmetry law. -/
theorem rademacherTwoSidedHoeffding
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {a : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hLaw : ∀ i, Measure.map (X i) μ = rademacherPMF.toMeasure)
    (hNegLaw : ∀ i, Measure.map (fun ω => -X i ω) μ = rademacherPMF.toMeasure)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ)
    (ht : 0 < t) (hv : 0 < ∑ i, (a i) ^ 2) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) := by
  let S : Ω → ℝ := fun ω => ∑ i, a i * X i ω
  let A : Set Ω := {ω | S ω ≥ t}
  let B : Set Ω := {ω | -S ω ≥ t}
  have hupper := rademacherHoeffding hX hIndep hLaw hExp ht.le hv
  let Y : ι → Ω → ℝ := fun i ω => -X i ω
  have hY_meas : ∀ i, Measurable (Y i) := by
    intro i
    simpa [Y] using (hX i).neg
  have hY_indep : iIndepFun Y μ := by
    have hcomp := hIndep.comp (fun _ x => -x) (fun _ => by fun_prop)
    simpa [Y, Function.comp_def] using hcomp
  have hY_exp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (a i * Y i ω))) μ := by
    intro lam i
    simpa [Y, mul_assoc, mul_left_comm, mul_comm] using hExp (-lam) i
  have hY_law : ∀ i, Measure.map (Y i) μ = rademacherPMF.toMeasure := by
    intro i
    simpa [Y] using hNegLaw i
  have hlower := rademacherHoeffding hY_meas hY_indep hY_law hY_exp ht.le hv
  have measureReal_mono_prob {C D : Set Ω} (hCD : C ⊆ D) :
      μ.real C ≤ μ.real D := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ D) (measure_mono hCD)
  have hsubset : {ω | |S ω| ≥ t} ⊆ A ∪ B := by
    intro ω hω
    change t ≤ |S ω| at hω
    change t ≤ S ω ∨ t ≤ -S ω
    by_cases hupperS : t ≤ S ω
    · exact Or.inl hupperS
    · right
      have hSlt : S ω < t := lt_of_not_ge hupperS
      by_contra hnot
      have hneglt : -S ω < t := lt_of_not_ge hnot
      exact (not_lt_of_ge hω) ((abs_lt).2 (by constructor <;> linarith))
  have hmeasure_union : μ.real (A ∪ B) ≤ μ.real A + μ.real B := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      (μ (A ∪ B)).toReal ≤ (μ A + μ B).toReal := by
        apply ENNReal.toReal_mono
        · exact ENNReal.add_ne_top.mpr ⟨measure_ne_top μ A, measure_ne_top μ B⟩
        · exact measure_union_le A B
      _ = (μ A).toReal + (μ B).toReal :=
        ENNReal.toReal_add (measure_ne_top μ A) (measure_ne_top μ B)
  have hupperA : μ.real A ≤
      Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) := by
    simpa [A, S] using hupper
  have hlowerB : μ.real B ≤
      Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) := by
    simpa [B, S, Y, Finset.sum_neg_distrib] using hlower
  calc
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} = μ.real {ω | |S ω| ≥ t} := by rfl
    _ ≤ μ.real (A ∪ B) := measureReal_mono_prob hsubset
    _ ≤ μ.real A + μ.real B := hmeasure_union
    _ ≤ Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) +
        Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) :=
      add_le_add hupperA hlowerB
    _ = 2 * Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) := by ring

/-! The fair-coin application before Remark 2.2.4. -/
theorem fairCoinHoeffding
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (hB : ∀ i, Measurable (B i))
    (hIndep : iIndepFun B μ)
    (hLaw : ∀ i, Measure.map (B i) μ = fairBernoulliPMF.toMeasure)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * rademacherValue (B i ω))) μ)
    (hN : 0 < Fintype.card ι) :
    μ.real {ω | ∑ i, bernoulliIndicator (B i ω) ≥
      (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} ≤
      Real.exp (-(Fintype.card ι : ℝ) / 8) := by
  let R : ι → Ω → ℝ := fun i ω => rademacherValue (B i ω)
  have hR : ∀ i, Measurable (R i) := by
    intro i
    simpa [R, Function.comp_def] using
      (measurable_of_countable rademacherValue).comp (hB i)
  have hR_indep : iIndepFun R μ := by
    have hcomp := hIndep.comp (fun _ b => rademacherValue b)
      (fun _ => measurable_of_countable rademacherValue)
    simpa [R, Function.comp_def] using hcomp
  have hR_law : ∀ i, Measure.map (R i) μ = rademacherPMF.toMeasure := by
    intro i
    rw [show R i = rademacherValue ∘ B i by rfl]
    rw [← MeasureTheory.Measure.map_map
      (measurable_of_countable rademacherValue) (hB i)]
    rw [hLaw i]
    change Measure.map rademacherValue fairBernoulliPMF.toMeasure =
      (PMF.map rademacherValue fairBernoulliPMF).toMeasure
    exact PMF.toMeasure_map rademacherValue fairBernoulliPMF
      (measurable_of_countable rademacherValue)
  have hR_exp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (1 * R i ω))) μ := by
    intro lam i
    simpa [R] using hExp lam i
  have htail := rademacherHoeffding (X := R) (a := fun _ => (1 : ℝ))
    (t := (Fintype.card ι : ℝ) / 2) hR hR_indep hR_law hR_exp
    (by positivity) (by simpa using hN)
  let A : Set Ω := {ω | ∑ i, bernoulliIndicator (B i ω) ≥
    (3 / 4 : ℝ) * (Fintype.card ι : ℝ)}
  let C : Set Ω := {ω | ∑ i, R i ω ≥ (Fintype.card ι : ℝ) / 2}
  have hAC : A ⊆ C := by
    intro ω hω
    have hsum : ∑ i, R i ω =
        2 * ∑ i, bernoulliIndicator (B i ω) - (Fintype.card ι : ℝ) := by
      simp_rw [R, rademacherValue_eq_affine]
      rw [Finset.sum_sub_distrib, ← Finset.mul_sum]
      simp
    change (Fintype.card ι : ℝ) / 2 ≤ ∑ i, R i ω
    rw [hsum]
    change (3 / 4 : ℝ) * (Fintype.card ι : ℝ) ≤
      ∑ i, bernoulliIndicator (B i ω) at hω
    linarith
  have hmeasure : μ.real A ≤ μ.real C := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ C) (measure_mono hAC)
  calc
    μ.real {ω | ∑ i, bernoulliIndicator (B i ω) ≥
        (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} = μ.real A := by rfl
    _ ≤ μ.real C := hmeasure
    _ ≤ Real.exp (-((Fintype.card ι : ℝ) / 2) ^ 2 /
        (2 * ∑ i, (1 : ℝ) ^ 2)) := by
      simpa [C] using htail
    _ = Real.exp (-(Fintype.card ι : ℝ) / 8) := by
      congr 1
      have hNreal : 0 < (Fintype.card ι : ℝ) := by exact_mod_cast hN
      simp only [one_pow]
      rw [show (∑ i : ι, (1 : ℝ)) = (Fintype.card ι : ℝ) by simp]
      field_simp [ne_of_gt hNreal]
      ring

/-! The positive-total-width branch of the bounded-variable Hoeffding theorem. -/
theorem boundedIndependentHoeffding
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i))
    (ht : 0 < t) (hv : 0 < ∑ i, ‖M i - m i‖ ^ 2) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
      Real.exp (-2 * t ^ 2 / (∑ i, ‖M i - m i‖ ^ 2)) := by
  let b : ι → ℝ := fun i => ∫ y, X i y ∂μ
  let Y : ι → Ω → ℝ := fun i ω => X i ω - b i
  let S : Ω → ℝ := fun ω => ∑ i, Y i ω
  let v : ℝ := ∑ i, ‖M i - m i‖ ^ 2
  have hY_meas : ∀ i, Measurable (Y i) := by
    intro i
    simpa [Y, b] using (hX i).sub measurable_const
  have hY_indep : iIndepFun Y μ := by
    have hcomp := hIndep.comp (fun i x => x - b i)
      (fun _ => by fun_prop)
    simpa [Y, b, Function.comp_def] using hcomp
  have hY_sub : ∀ i, HasSubgaussianMGF (Y i)
      ((‖M i - m i‖₊ / 2) ^ 2) μ := by
    intro i
    simpa [Y, b] using
      (hoeffdingCenteredMGF (μ := μ) (X := X i) (a := m i) (b := M i)
        (hX i).aemeasurable (hbound i))
  have hY_exp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * Y i ω)) μ := by
    intro lam i
    simpa using (hY_sub i).integrable_exp_mul lam
  have hS_meas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ => hY_meas i)
  have hS_exp (lam : ℝ) :
      Integrable (fun ω => Real.exp (lam * S ω)) μ := by
    have h := hY_indep.integrable_exp_mul_sum hY_meas
      (s := Finset.univ) (fun i _ => hY_exp lam i)
    simpa [S] using h
  have hmgf (lam : ℝ) :
      (∫ ω, Real.exp (lam * S ω) ∂μ) =
        ∏ i, ∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ := by
    simpa [S] using
      (mgfIndependentSum (μ := μ) (X := Y) lam (fun _ => (1 : ℝ))
        hY_indep (fun i => by simpa using hY_exp lam i))
  have hfactor (lam : ℝ) (i : ι) :
      (∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) ≤
        Real.exp ((lam * ‖M i - m i‖) ^ 2 / 8) := by
    have hle := (hY_sub i).mgf_le lam
    convert hle using 1 <;>
      simp [ProbabilityTheory.mgf, Y, b, div_eq_mul_inv]
    ring
  have hmgf_upper (lam : ℝ) :
      (∫ ω, Real.exp (lam * S ω) ∂μ) ≤
        Real.exp (lam ^ 2 * v / 8) := by
    have hprod :
        (∏ i, ∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) ≤
          ∏ i, Real.exp ((lam * ‖M i - m i‖) ^ 2 / 8) := by
      apply Finset.prod_le_prod
      · intro i hi
        exact MeasureTheory.integral_nonneg (fun ω => Real.exp_nonneg _)
      · intro i hi
        exact hfactor lam i
    rw [hmgf]
    calc
      (∏ i, ∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) ≤
          ∏ i, Real.exp ((lam * ‖M i - m i‖) ^ 2 / 8) := hprod
      _ = Real.exp (lam ^ 2 * v / 8) := by
        rw [← Real.exp_sum]
        congr 1
        dsimp [v]
        ring_nf
        rw [Finset.mul_sum, Finset.sum_mul]
  have hupper (lam : ℝ) (hlam : 0 < lam) :
      μ.real (S ⁻¹' Set.Ici t) ≤
        Real.exp (-(lam * t)) * Real.exp (lam ^ 2 * v / 8) := by
    calc
      μ.real (S ⁻¹' Set.Ici t) ≤
          Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * S ω) ∂μ) :=
        exponentialMarkovUpper hS_meas hlam (hS_exp lam)
      _ ≤ Real.exp (-(lam * t)) * Real.exp (lam ^ 2 * v / 8) :=
        mul_le_mul_of_nonneg_left (hmgf_upper lam) (Real.exp_nonneg _)
  have hv' : 0 < v := by simpa [v] using hv
  let lam : ℝ := 4 * t / v
  have hlam : 0 < lam := div_pos (by positivity) hv'
  have hupper' := hupper lam hlam
  calc
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} =
        μ.real (S ⁻¹' Set.Ici t) := by rfl
    _ ≤ Real.exp (-(lam * t)) * Real.exp (lam ^ 2 * v / 8) := hupper'
    _ = Real.exp (-2 * t ^ 2 / v) := by
      rw [← Real.exp_add]
      congr 1
      dsimp [lam]
      field_simp [ne_of_gt hv']
      ring
    _ = Real.exp (-2 * t ^ 2 / (∑ i, ‖M i - m i‖ ^ 2)) := by rfl

/-! Deterministic zero-width companion for the bounded-variable theorem. -/
theorem boundedIndependentHoeffdingZero
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m : ι → ℝ} {t : ℝ}
    (hconst : ∀ i ω, X i ω = m i) (ht : 0 < t) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} = 0 := by
  have hevent : {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} = (∅ : Set Ω) := by
    ext ω
    simp [hconst, ht]
  rw [hevent]
  simp

/-! Majority-vote amplification from the bounded Hoeffding theorem. -/
theorem majorityVoteHoeffding
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {W : ι → Ω → ℝ} {δ ε : ℝ}
    (hW : ∀ i, Measurable (W i))
    (hIndep : iIndepFun W μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, W i ω ∈ Set.Icc 0 1)
    (hmean : ∀ i, (∫ y, W i y ∂μ) ≤ 1 / 2 - δ)
    (hδ : 0 < δ) (hε0 : 0 < ε) (hε1 : ε < 1)
    (hN : 0 < Fintype.card ι)
    (hNlarge : Real.log (1 / ε) / (2 * δ ^ 2) ≤ (Fintype.card ι : ℝ)) :
    μ.real {ω | ∑ i, W i ω ≥ (Fintype.card ι : ℝ) / 2} ≤ ε := by
  let N : ℝ := Fintype.card ι
  let A : Set Ω := {ω | ∑ i, W i ω ≥ N / 2}
  let C : Set Ω := {ω | ∑ i, (W i ω - ∫ y, W i y ∂μ) ≥ N * δ}
  have hNpos : 0 < N := by simpa [N] using hN
  have htail := boundedIndependentHoeffding (X := W)
    (m := fun _ => (0 : ℝ)) (M := fun _ => (1 : ℝ)) (t := N * δ)
    hW hIndep hbound (by positivity)
    (by simpa [N] using hN)
  have hsum_mean : ∑ i, (∫ y, W i y ∂μ) ≤ N * (1 / 2 - δ) := by
    calc
      ∑ i, (∫ y, W i y ∂μ) ≤ ∑ i, (1 / 2 - δ) := by
        exact Finset.sum_le_sum (fun i hi => hmean i)
      _ = N * (1 / 2 - δ) := by simp [N]; ring
  have hAC : A ⊆ C := by
    intro ω hω
    have hsum : ∑ i, (W i ω - ∫ y, W i y ∂μ) =
        (∑ i, W i ω) - ∑ i, (∫ y, W i y ∂μ) := by
      rw [Finset.sum_sub_distrib]
    change N * δ ≤ ∑ i, (W i ω - ∫ y, W i y ∂μ)
    rw [hsum]
    change N / 2 ≤ ∑ i, W i ω at hω
    linarith
  have hmeasure : μ.real A ≤ μ.real C := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ C) (measure_mono hAC)
  have htailC : μ.real C ≤ Real.exp (-2 * (N * δ) ^ 2 / N) := by
    simpa [C, N] using htail
  have htailN : μ.real C ≤ Real.exp (-2 * N * δ ^ 2) := by
    calc
      μ.real C ≤ Real.exp (-2 * (N * δ) ^ 2 / N) := htailC
      _ = Real.exp (-2 * N * δ ^ 2) := by
        congr 1
        field_simp [ne_of_gt hNpos]
  have hlog_bound : -2 * N * δ ^ 2 ≤ Real.log ε := by
    have hden : 0 < 2 * δ ^ 2 := by positivity
    have hscaled := (div_le_iff₀ hden).1 hNlarge
    have hscaled' : -Real.log ε ≤ N * (2 * δ ^ 2) := by
      simpa [N, one_div, Real.log_inv] using hscaled
    linarith
  have hexp : Real.exp (-2 * N * δ ^ 2) ≤ ε := by
    calc
      Real.exp (-2 * N * δ ^ 2) ≤ Real.exp (Real.log ε) :=
        (Real.exp_le_exp).2 hlog_bound
      _ = ε := Real.exp_log hε0
  calc
    μ.real {ω | ∑ i, W i ω ≥ (Fintype.card ι : ℝ) / 2} = μ.real A := by rfl
    _ ≤ μ.real C := hmeasure
    _ ≤ Real.exp (-2 * N * δ ^ 2) := htailN
    _ ≤ ε := hexp

/-- A probability density supported on the nonnegative half-line and bounded by one. -/
structure BoundedDensityOnNonnegative (f : ℝ → ℝ) : Prop where
  nonnegative : ∀ᵐ x ∂(volume : Measure ℝ), 0 ≤ f x
  supported : ∀ᵐ x ∂(volume : Measure ℝ), x < 0 → f x = 0
  bounded : ∀ᵐ x ∂(volume : Measure ℝ), 0 ≤ x → f x ≤ 1
  integrable : Integrable f volume
  normalized : ∫ x, f x ∂volume = 1

/-- The Laplace transform of a nonnegative density bounded by one is at most `1 / t`. -/
theorem laplaceTransformLeInv {f : ℝ → ℝ}
    (hf : BoundedDensityOnNonnegative f) {t : ℝ} (ht : 0 < t) :
    ∫ x, Real.exp (-t * x) * f x ∂(volume : Measure ℝ) ≤ 1 / t := by
  let g : ℝ → ℝ := Set.indicator (Set.Ioi 0) (fun x => Real.exp (-t * x))
  have hg_on : IntegrableOn (fun x : ℝ => Real.exp (-t * x)) (Set.Ioi 0) := by
    simpa [mul_comm] using
      (integrableOn_exp_mul_Ioi (a := -t) (by linarith) (0 : ℝ))
  have hg : Integrable g (volume : Measure ℝ) :=
    hg_on.integrable_indicator measurableSet_Ioi
  have hnonneg : 0 ≤ᵐ[(volume : Measure ℝ)] fun x => Real.exp (-t * x) * f x := by
    filter_upwards [hf.nonnegative] with x hfx
    exact mul_nonneg (Real.exp_nonneg _) hfx
  have hle : (fun x => Real.exp (-t * x) * f x) ≤ᵐ[(volume : Measure ℝ)] g := by
    filter_upwards [hf.supported, hf.bounded, (volume : Measure ℝ).ae_ne 0] with x hs hb hx0
    by_cases hx : 0 ≤ x
    · have hx' : 0 < x := lt_of_le_of_ne hx (Ne.symm hx0)
      rw [show g x = Real.exp (-t * x) by simp [g, Set.mem_Ioi.mpr hx']]
      simpa using mul_le_mul_of_nonneg_left (hb hx) (Real.exp_nonneg (-t * x))
    · have hx' : x < 0 := lt_of_not_ge hx
      rw [show g x = 0 by simp [g, Set.mem_Ioi, not_lt.mpr (le_of_lt hx')], hs hx', mul_zero]
  calc
    ∫ x, Real.exp (-t * x) * f x ∂(volume : Measure ℝ)
        ≤ ∫ x, g x ∂(volume : Measure ℝ) :=
      integral_mono_of_nonneg hnonneg hg hle
    _ = ∫ x in Set.Ioi 0, Real.exp (-t * x) ∂(volume : Measure ℝ) := by
      simp [g, integral_indicator measurableSet_Ioi]
    _ = -Real.exp ((-t) * 0) / (-t) :=
      integral_exp_mul_Ioi (by linarith) 0
    _ = 1 / t := by simp

/-! The finite exponential-Markov upper and lower tail bounds. -/
theorem exponentialMarkov
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {S : Ω → ℝ} (hS : Measurable S)
    {lam t : ℝ} (hlam : 0 < lam)
    (hExp : Integrable (fun ω => Real.exp (lam * S ω)) μ)
    (hExpNeg : Integrable (fun ω => Real.exp (lam * (-S ω))) μ) :
    (μ.real (S ⁻¹' Set.Ici t) ≤
        Real.exp (-(lam * t)) *
          (∫ ω, Real.exp (lam * S ω) ∂μ)) ∧
      (μ.real ((fun ω => -S ω) ⁻¹' Set.Ici t) ≤
        Real.exp (-(lam * t)) *
          (∫ ω, Real.exp (lam * (-S ω)) ∂μ)) := by
  let Y : Ω → ℝ := fun ω => Real.exp (lam * S ω)
  have hY : Measurable Y := by
    simpa [Y] using (hS.const_mul lam).exp
  have hY_nonneg : ∀ᵐ ω ∂μ, 0 ≤ Y ω :=
    Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _))
  have hY_int : Integrable Y μ := by
    simpa [Y] using hExp
  have hY_markov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
      hY hY_nonneg hY_int (Real.exp_pos (lam * t))
  have measureReal_mono_prob {A B : Set Ω} (hAB : A ⊆ B) :
      μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  have hupper_subset : S ⁻¹' Set.Ici t ⊆
      Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
    intro ω hω
    change t ≤ S ω at hω
    change Real.exp (lam * t) ≤ Real.exp (lam * S ω)
    exact (Real.exp_le_exp).2 (mul_le_mul_of_nonneg_left hω hlam.le)
  have hupper : μ.real (S ⁻¹' Set.Ici t) ≤
      Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * S ω) ∂μ) := by
    calc
      μ.real (S ⁻¹' Set.Ici t) ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (lam * t))) :=
        measureReal_mono_prob hupper_subset
      _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (lam * t) := by
        simpa [Preliminaries.expectation] using hY_markov
      _ = Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * S ω) ∂μ) := by
        simp [Y, Real.exp_neg, div_eq_mul_inv]
        ring
  let Z : Ω → ℝ := fun ω => -S ω
  let W : Ω → ℝ := fun ω => Real.exp (lam * Z ω)
  have hZ : Measurable Z := by
    simpa [Z] using hS.neg
  have hW : Measurable W := by
    simpa [W] using (hZ.const_mul lam).exp
  have hW_nonneg : ∀ᵐ ω ∂μ, 0 ≤ W ω :=
    Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _))
  have hW_int : Integrable W μ := by
    simpa [W, Z] using hExpNeg
  have hW_markov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
      hW hW_nonneg hW_int (Real.exp_pos (lam * t))
  have hlower_subset : Z ⁻¹' Set.Ici t ⊆
      W ⁻¹' Set.Ici (Real.exp (lam * t)) := by
    intro ω hω
    change t ≤ Z ω at hω
    change Real.exp (lam * t) ≤ Real.exp (lam * Z ω)
    exact (Real.exp_le_exp).2 (mul_le_mul_of_nonneg_left hω hlam.le)
  have hlower : μ.real (Z ⁻¹' Set.Ici t) ≤
      Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * (-S ω)) ∂μ) := by
    calc
      μ.real (Z ⁻¹' Set.Ici t) ≤ μ.real (W ⁻¹' Set.Ici (Real.exp (lam * t))) :=
        measureReal_mono_prob hlower_subset
      _ ≤ (∫ ω, W ω ∂μ) / Real.exp (lam * t) := by
        simpa [Preliminaries.expectation] using hW_markov
      _ = Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * (-S ω)) ∂μ) := by
        simp [W, Z, Real.exp_neg, div_eq_mul_inv]
        ring
  exact ⟨hupper, hlower⟩

/-! The finite independent-sum small-ball estimate from Exercise 2.2.10(b). -/
theorem smallBallProbability
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {ε : ℝ} (hε : 0 < ε)
    (hX : ∀ i, Measurable (X i)) (hIndep : iIndepFun X μ)
    (hLaplace : ∀ i,
      Integrable (fun ω => Real.exp (-(1 / ε) * X i ω)) μ ∧
        (∫ ω, Real.exp (-(1 / ε) * X i ω) ∂μ) ≤ ε) :
    μ.real {ω | ∑ i, X i ω ≤ ε * (Fintype.card ι : ℝ)} ≤
      (Real.exp 1 * ε) ^ Fintype.card ι := by
  let a : ι → ℝ := fun _ => -(1 / ε)
  let Z : ι → Ω → ℝ := fun i ω => a i * X i ω
  let S : Ω → ℝ := fun ω => ∑ i, Z i ω
  have ha_meas : ∀ i, Measurable (fun x : ℝ => a i * x) := by
    intro i
    fun_prop
  have hZ_meas : ∀ i, Measurable (Z i) := by
    intro i
    simpa [Z] using (hX i).const_mul (a i)
  have hZ_indep : iIndepFun Z μ := by
    simpa [Z, Function.comp_def] using hIndep.comp (fun i x => a i * x) ha_meas
  have hZ_exp : ∀ i, Integrable (fun ω => Real.exp (Z i ω)) μ := by
    intro i
    simpa [Z, a] using (hLaplace i).1
  have hS_meas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ => hZ_meas i)
  have hS_exp : Integrable (fun ω => Real.exp (S ω)) μ := by
    simpa [S] using
      (hZ_indep.integrable_exp_mul_sum (t := (1 : ℝ)) hZ_meas
        (s := Finset.univ) (fun i _ => by simpa using hZ_exp i))
  have hmgf := mgfIndependentSum (μ := μ) (X := X) 1 a hIndep (by
    intro i
    simpa [Z, a] using hZ_exp i)
  have hupper := exponentialMarkovUpper hS_meas (lam := (1 : ℝ))
    (t := -(Fintype.card ι : ℝ)) one_pos (by simpa using hS_exp)
  have hS_formula : ∀ ω, S ω = -(∑ i, X i ω) / ε := by
    intro ω
    dsimp [S, Z, a]
    rw [← Finset.mul_sum]
    field_simp
  have hevent :
      {ω | ∑ i, X i ω ≤ ε * (Fintype.card ι : ℝ)} =
        S ⁻¹' Set.Ici (-(Fintype.card ι : ℝ)) := by
    ext ω
    rw [Set.mem_setOf_eq, Set.mem_preimage, Set.mem_Ici]
    rw [hS_formula]
    constructor
    · intro h
      apply (le_div_iff₀ hε).2
      linarith
    · intro h
      have h' := (le_div_iff₀ hε).1 h
      linarith
  have hmgfS :
      (∫ ω, Real.exp (S ω) ∂μ) =
        ∏ i, ∫ ω, Real.exp (a i * X i ω) ∂μ := by
    calc
      (∫ ω, Real.exp (S ω) ∂μ) =
          ∫ ω, Real.exp (1 * ∑ i, a i * X i ω) ∂μ := by
            simp [S, Z]
      _ = ∏ i, ∫ ω, Real.exp (1 * (a i * X i ω)) ∂μ := hmgf
      _ = ∏ i, ∫ ω, Real.exp (a i * X i ω) ∂μ := by
        simp
  have hprod :
      (∏ i, ∫ ω, Real.exp (a i * X i ω) ∂μ) ≤ ε ^ Fintype.card ι := by
    calc
      (∏ i, ∫ ω, Real.exp (a i * X i ω) ∂μ) ≤
          ∏ i, ε := Finset.prod_le_prod
            (fun i _ => integral_nonneg_of_ae
              (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _))))
            (fun i _ => by simpa [a] using (hLaplace i).2)
      _ = ε ^ Fintype.card ι := by simp
  rw [hevent]
  calc
    μ.real (S ⁻¹' Set.Ici (-(Fintype.card ι : ℝ))) ≤
        Real.exp (Fintype.card ι : ℝ) * (∫ ω, Real.exp (S ω) ∂μ) := by
      simpa using hupper
    _ = Real.exp (Fintype.card ι : ℝ) *
        (∏ i, ∫ ω, Real.exp (a i * X i ω) ∂μ) := by rw [hmgfS]
    _ ≤ Real.exp (Fintype.card ι : ℝ) * ε ^ Fintype.card ι :=
      mul_le_mul_of_nonneg_left hprod (le_of_lt (Real.exp_pos _))
    _ = (Real.exp 1 * ε) ^ Fintype.card ι := by
      rw [mul_pow]
      congr 1
      rw [← Real.exp_nat_mul]
      norm_num

end NumStability.HDP.Scalar.IndependentSums.Hoeffding

namespace NumStability.HDP.Contract

/-! Stable source-facing alias for Theorem 2.2.2. -/
theorem hdp_02_hthm_h2_d2_d2
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {a : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hLaw : ∀ i, Measure.map (X i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure)
    (ht : 0 ≤ t) :
    μ.real {ω | ∑ i, a i * X i ω ≥ t} ≤
      Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherHoeffdingAll
    hX hIndep hLaw ht

/-! Stable source-facing alias for Theorem 2.2.5. -/
theorem hdp_02_hthm_h2_d2_d5
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {a : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hLaw : ∀ i, Measure.map (X i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure)
    (hNegLaw : ∀ i, Measure.map (fun ω => -X i ω) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ)
    (ht : 0 < t) (hv : 0 < ∑ i, (a i) ^ 2) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherTwoSidedHoeffding
    hX hIndep hLaw hNegLaw hExp ht hv

/-! Stable Chapter 2 alias for the fair-coin Hoeffding application. -/
theorem hdp_02_hex_hfair_hcoin_hhoeffding
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (hB : ∀ i, Measurable (B i))
    (hIndep : iIndepFun B μ)
    (hLaw : ∀ i, Measure.map (B i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairBernoulliPMF.toMeasure)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam *
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue (B i ω))) μ)
    (hN : 0 < Fintype.card ι) :
    μ.real {ω | ∑ i,
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.bernoulliIndicator (B i ω) ≥
      (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} ≤
      Real.exp (-(Fintype.card ι : ℝ) / 8) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairCoinHoeffding
    hB hIndep hLaw hExp hN

/-! Stable Chapter 2 alias for the bounded-variable Hoeffding theorem. -/
theorem hdp_02_hthm_h2_d2_d6
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i))
    (ht : 0 < t) (hv : 0 < ∑ i, ‖M i - m i‖ ^ 2) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
      Real.exp (-2 * t ^ 2 / (∑ i, ‖M i - m i‖ ^ 2)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.boundedIndependentHoeffding
    hX hIndep hbound ht hv

/-! Stable Chapter 2 alias for the bounded-variable proof exercise. -/
theorem hdp_02_hex_h2_d2_d7
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i))
    (ht : 0 < t) (hv : 0 < ∑ i, ‖M i - m i‖ ^ 2) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
      Real.exp (-2 * t ^ 2 / (∑ i, ‖M i - m i‖ ^ 2)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.boundedIndependentHoeffding
    hX hIndep hbound ht hv

/-! Stable Chapter 2 alias for the majority-vote amplification exercise. -/
theorem hdp_02_hex_h2_d2_d8
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {W : ι → Ω → ℝ} {δ ε : ℝ}
    (hW : ∀ i, Measurable (W i))
    (hIndep : iIndepFun W μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, W i ω ∈ Set.Icc 0 1)
    (hmean : ∀ i, (∫ y, W i y ∂μ) ≤ 1 / 2 - δ)
    (hδ : 0 < δ) (hε0 : 0 < ε) (hε1 : ε < 1)
    (hN : 0 < Fintype.card ι)
    (hNlarge : Real.log (1 / ε) / (2 * δ ^ 2) ≤ (Fintype.card ι : ℝ)) :
    μ.real {ω | ∑ i, W i ω ≥ (Fintype.card ι : ℝ) / 2} ≤ ε :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.majorityVoteHoeffding
    hW hIndep hbound hmean hδ hε0 hε1 hN hNlarge

/-- Stable Chapter 2 alias for the centered bounded-variable Hoeffding lemma. -/
theorem hdp_02_hlem_hhoeffding_hbounded_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {a b : ℝ}
    (hX : AEMeasurable X μ)
    (hbound : ∀ᵐ ω ∂μ, X ω ∈ Set.Icc a b)
    (hmean : ∫ ω, X ω ∂μ = 0) :
    HasSubgaussianMGF X ((‖b - a‖₊ / 2) ^ 2) μ :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.hoeffdingBoundedMGF
    hX hbound hmean

theorem hdp_02_hlem_hhoeffding_hoptimization {v t : ℝ} (hv : 0 < v)
    (ht : 0 ≤ t) :
    (∀ u : ℝ, 0 ≤ u →
      -t ^ 2 / (2 * v) ≤ -u * t + u ^ 2 * v / 2) ∧
      (-(t / v) * t + (t / v) ^ 2 * v / 2 = -t ^ 2 / (2 * v)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.hoeffdingOptimization hv ht

/-- Stable Chapter 2 alias for Exercise 2.2.3. -/
theorem hdp_02_hex_h2_d2_d3 (x : ℝ) :
    Real.cosh x ≤ Real.exp (x ^ 2 / 2) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.coshLeExpHalfSq x

/-- Stable Chapter 2 alias for Exercise 2.2.10(a). -/
theorem hdp_02_hex_h2_d2_d10a {f : ℝ → ℝ}
    (hf : NumStability.HDP.Scalar.IndependentSums.Hoeffding.BoundedDensityOnNonnegative f)
    {t : ℝ} (ht : 0 < t) :
    ∫ x, Real.exp (-t * x) * f x ∂(volume : Measure ℝ) ≤ 1 / t :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.laplaceTransformLeInv hf ht

end NumStability.HDP.Contract
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

### `ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/IndependentSums/Chernoff.lean`
SHA-256: `5225f6ef016c100e3481a93872f891a01a69663c96c8fdf640511bec7c07fa31`

```lean
import Mathlib.Probability.Combinatorics.BinomialRandomGraph.Defs
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Probability.ProbabilityMassFunction.Integrals
import Mathlib.Probability.HasLaw
import Mathlib.Probability.Independence.Integration
import Mathlib.Probability.Distributions.Poisson
import Mathlib.MeasureTheory.Integral.Lebesgue.Countable
import Mathlib.Analysis.Asymptotics.AsymptoticEquivalent
import Mathlib.Analysis.SpecialFunctions.Stirling
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Tactic
import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding
import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw

/-!
# The Erdős--Rényi random graph interface

This module uses Mathlib's canonical binomial random graph law on finite simple
graphs and exposes the vertex-degree observable used by the Chapter 2
application.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators
open scoped ENNReal
open scoped NNReal
open scoped Asymptotics

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

theorem bernoulliMgfExact (p : ℝ≥0) (hp : p ≤ 1) (lam : ℝ) :
    (∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
      (PMF.bernoulli p hp).toMeasure) =
      1 + (Real.exp lam - 1) * (p : ℝ) := by
  rw [PMF.integral_eq_sum]
  simp [PMF.bernoulli_apply]
  rw [NNReal.coe_sub hp]
  norm_num
  ring

theorem bernoulliMgfBound (p : ℝ≥0) (hp : p ≤ 1) (lam : ℝ) :
    ((∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
        (PMF.bernoulli p hp).toMeasure) =
        1 + (Real.exp lam - 1) * (p : ℝ)) ∧
      (1 + (Real.exp lam - 1) * (p : ℝ) ≤
        Real.exp ((Real.exp lam - 1) * (p : ℝ))) := by
  refine ⟨bernoulliMgfExact p hp lam, ?_⟩
  simpa [add_comm] using Real.add_one_le_exp ((Real.exp lam - 1) * (p : ℝ))

theorem poissonBinomialMgfBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (lam : ℝ)
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ) :
    (∫ ω, Real.exp (lam * ∑ i, (if B i ω then 1 else 0)) ∂μ) ≤
      Real.exp ((Real.exp lam - 1) * ∑ i, (p i : ℝ)) := by
  let Y : ι → Ω → ℝ := fun i ω => if B i ω then 1 else 0
  have hY : iIndepFun Y μ := by
    let g : ∀ _ : ι, Bool → ℝ := fun _ b => if b then 1 else 0
    have h := hB.comp g (fun _ => by fun_prop)
    simpa [Y, g, Function.comp_def] using h
  have hExpY : ∀ i, Integrable (fun ω => Real.exp (lam * (1 * Y i ω))) μ := by
    intro i
    simpa [Y, one_mul] using hExp i
  have hFactor : ∀ i, (∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) ≤
      Real.exp ((Real.exp lam - 1) * (p i : ℝ)) := by
    intro i
    have hcomp := (hLaw i).integral_comp
      (f := fun b : Bool => Real.exp (lam * (if b then 1 else 0))) (by fun_prop)
    calc
      (∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) =
          ∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
            (PMF.bernoulli (p i) (hp i)).toMeasure := by
        simpa [Y, Function.comp_def] using hcomp
      _ = 1 + (Real.exp lam - 1) * (p i : ℝ) := bernoulliMgfExact (p i) (hp i) lam
      _ ≤ Real.exp ((Real.exp lam - 1) * (p i : ℝ)) :=
        (bernoulliMgfBound (p i) (hp i) lam).2
  calc
    (∫ ω, Real.exp (lam * ∑ i, (if B i ω then 1 else 0)) ∂μ) =
        ∏ i, ∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ := by
      simpa [Y] using
          (NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
          (μ := μ) (X := Y) lam (fun _ => 1) hY hExpY)
    _ ≤ ∏ i, Real.exp ((Real.exp lam - 1) * (p i : ℝ)) := by
      apply Finset.prod_le_prod
      · intro i _
        exact integral_nonneg (fun _ => Real.exp_nonneg _)
      · intro i _
        exact hFactor i
    _ = Real.exp ((Real.exp lam - 1) * ∑ i, (p i : ℝ)) := by
      rw [← Real.exp_sum]
      congr 1
      rw [Finset.mul_sum]

theorem poissonBinomialChernoffBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ}
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp (Real.log (t / (∑ i, (p i : ℝ))) *
        (if B i ω then 1 else 0))) μ)
    (ht : ∑ i, (p i : ℝ) < t)
    (hμ : 0 < ∑ i, (p i : ℝ))
    (hExpS : Integrable
      (fun ω => Real.exp (Real.log (t / (∑ i, (p i : ℝ))) *
        ∑ i, (if B i ω then 1 else 0))) μ) :
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
  let S : Ω → ℝ := fun ω => ∑ i, (if B i ω then 1 else 0)
  have hS : Measurable S := by
    dsimp [S]
    refine Finset.measurable_fun_sum Finset.univ ?_
    intro i hi
    exact Measurable.ite
      (measurableSet_preimage (hMeas i) (measurableSet_singleton (true : Bool)))
      measurable_const measurable_const
  have hlogpos : 0 < Real.log (t / (∑ i, (p i : ℝ))) := by
    apply Real.log_pos
    rw [one_lt_div hμ]
    exact ht
  have hmgf := poissonBinomialMgfBound hp hB hLaw
    (Real.log (t / (∑ i, (p i : ℝ)))) hExp
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (lam := Real.log (t / (∑ i, (p i : ℝ)))) (t := t) hS hlogpos hExpS
  have hbound :
      (∫ ω, Real.exp (Real.log (t / (∑ i, (p i : ℝ))) * S ω) ∂μ) ≤
        Real.exp ((Real.exp (Real.log (t / (∑ i, (p i : ℝ)))) - 1) *
          (∑ i, (p i : ℝ))) := by
    simpa [S] using hmgf
  have hmul :
      Real.exp (-(Real.log (t / (∑ i, (p i : ℝ))) * t)) *
          (∫ ω, Real.exp (Real.log (t / (∑ i, (p i : ℝ))) * S ω) ∂μ) ≤
        Real.exp (-(Real.log (t / (∑ i, (p i : ℝ))) * t)) *
          Real.exp ((Real.exp (Real.log (t / (∑ i, (p i : ℝ)))) - 1) *
            (∑ i, (p i : ℝ))) :=
    mul_le_mul_of_nonneg_left hbound (Real.exp_nonneg _)
  calc
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} =
        μ.real (S ⁻¹' Set.Ici t) := by
      rfl
    _ ≤ Real.exp (-(Real.log (t / (∑ i, (p i : ℝ))) * t)) *
        (∫ ω, Real.exp (Real.log (t / (∑ i, (p i : ℝ))) * S ω) ∂μ) := by
      simpa [S, mul_comm] using hmarkov
    _ ≤ Real.exp (-(Real.log (t / (∑ i, (p i : ℝ))) * t)) *
        Real.exp ((Real.exp (Real.log (t / (∑ i, (p i : ℝ)))) - 1) *
          (∑ i, (p i : ℝ))) := hmul
    _ = Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
      have ht0 : 0 < t := lt_trans hμ ht
      have hratio : 0 < t / (∑ i, (p i : ℝ)) := div_pos ht0 hμ
      have hbase : 0 < Real.exp 1 * (∑ i, (p i : ℝ)) / t :=
        div_pos (mul_pos (Real.exp_pos _) hμ) ht0
      rw [Real.exp_log hratio]
      rw [Real.rpow_def_of_pos hbase]
      rw [Real.log_div (mul_ne_zero (ne_of_gt (Real.exp_pos (1 : ℝ)))
        (ne_of_gt hμ)) (ne_of_gt ht0)]
      rw [Real.log_mul (ne_of_gt (Real.exp_pos (1 : ℝ))) (ne_of_gt hμ)]
      rw [Real.log_exp]
      rw [← Real.exp_add]
      rw [← Real.exp_add]
      congr 1
      rw [Real.log_div (ne_of_gt (lt_trans hμ ht)) (ne_of_gt hμ)]
      field_simp
      ring

theorem poissonBinomialLowerChernoffBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ}
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp ((-Real.log ((∑ i, (p i : ℝ)) / t)) *
        (if B i ω then 1 else 0))) μ)
    (ht : 0 < t)
    (htμ : t < ∑ i, (p i : ℝ))
    (hExpS : Integrable
      (fun ω => Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) *
        (-∑ i, (if B i ω then 1 else 0)))) μ) :
    μ.real {ω | ∑ i, (if B i ω then 1 else 0) ≤ t} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
  let S : Ω → ℝ := fun ω => ∑ i, (if B i ω then 1 else 0)
  have hS : Measurable S := by
    dsimp [S]
    refine Finset.measurable_fun_sum Finset.univ ?_
    intro i hi
    exact Measurable.ite
      (measurableSet_preimage (hMeas i) (measurableSet_singleton (true : Bool)))
      measurable_const measurable_const
  have hμpos : 0 < ∑ i, (p i : ℝ) := lt_trans ht htμ
  have hratio : 0 < (∑ i, (p i : ℝ)) / t := div_pos hμpos ht
  have hlogpos : 0 < Real.log ((∑ i, (p i : ℝ)) / t) := by
    apply Real.log_pos
    rw [one_lt_div ht]
    exact htμ
  have hmgf := poissonBinomialMgfBound hp hB hLaw
    (-Real.log ((∑ i, (p i : ℝ)) / t)) hExp
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (S := fun ω => -S ω)
      (lam := Real.log ((∑ i, (p i : ℝ)) / t)) (t := -t)
      hS.neg hlogpos hExpS
  have hbound :
      (∫ ω, Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * (-S ω)) ∂μ) ≤
        Real.exp ((Real.exp (-Real.log ((∑ i, (p i : ℝ)) / t)) - 1) *
          (∑ i, (p i : ℝ))) := by
    simpa [S, mul_neg] using hmgf
  have hmul :
      Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * t) *
          (∫ ω, Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * (-S ω)) ∂μ) ≤
        Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * t) *
          Real.exp ((Real.exp (-Real.log ((∑ i, (p i : ℝ)) / t)) - 1) *
            (∑ i, (p i : ℝ))) :=
    mul_le_mul_of_nonneg_left hbound (Real.exp_nonneg _)
  calc
    μ.real {ω | ∑ i, (if B i ω then 1 else 0) ≤ t} =
        μ.real ((fun ω => -S ω) ⁻¹' Set.Ici (-t)) := by
      congr 1
      ext ω
      simp [S, le_neg]
    _ ≤ Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * t) *
        (∫ ω, Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * (-S ω)) ∂μ) := by
      simpa [mul_neg, mul_comm] using hmarkov
    _ ≤ Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) * t) *
        Real.exp ((Real.exp (-Real.log ((∑ i, (p i : ℝ)) / t)) - 1) *
          (∑ i, (p i : ℝ))) := hmul
    _ = Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
      have hμpos : 0 < ∑ i, (p i : ℝ) := lt_trans ht htμ
      have hbase : 0 < Real.exp 1 * (∑ i, (p i : ℝ)) / t :=
        div_pos (mul_pos (Real.exp_pos _) hμpos) ht
      rw [Real.exp_neg, Real.exp_log hratio]
      rw [Real.rpow_def_of_pos hbase]
      rw [Real.log_div (mul_ne_zero (ne_of_gt (Real.exp_pos (1 : ℝ)))
        (ne_of_gt hμpos)) (ne_of_gt ht)]
      rw [Real.log_mul (ne_of_gt (Real.exp_pos (1 : ℝ))) (ne_of_gt hμpos)]
      rw [Real.log_exp]
      rw [← Real.exp_add]
      rw [← Real.exp_add]
      congr 1
      rw [Real.log_div (ne_of_gt hμpos) (ne_of_gt ht)]
      field_simp
      ring

theorem poissonBinomialChernoffZeroCase
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {t : ℝ}
    (ht : 0 < t)
    (hZero : ∀ ω, ∑ i, (if B i ω then (1 : ℝ) else 0) = 0) :
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} = 0 := by
  have hset : {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} = (∅ : Set Ω) := by
    ext ω
    simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false]
    intro hω
    have hω' : t ≤ 0 := by
      calc
        t ≤ ∑ i, (if B i ω then 1 else 0) := hω
        _ = 0 := hZero ω
    exact (not_le_of_gt ht) hω'
  rw [hset]
  simp

private lemma poissonMeasure_mass (rate : ℝ≥0) (k : ℕ) :
    ProbabilityTheory.poissonMeasure rate {k} =
      ENNReal.ofReal (ProbabilityTheory.poissonPMFReal rate k) := by
  rw [ProbabilityTheory.poissonMeasure,
    PMF.toMeasure_apply_singleton _ k (measurableSet_singleton k)]
  rfl

private lemma poisson_add_fiber (n x : ℕ) :
    Prod.mk x ⁻¹' ((fun p : ℕ × ℕ => p.1 + p.2) ⁻¹' ({n} : Set ℕ)) =
      if x ≤ n then ({n - x} : Set ℕ) else ∅ := by
  by_cases h : x ≤ n
  · ext y
    simp only [Set.mem_preimage, Set.mem_singleton_iff]
    rw [if_pos h]
    constructor
    · intro heq
      exact Nat.eq_sub_of_add_eq (by simpa [Nat.add_comm] using heq)
    · intro heq
      rw [heq]
      exact Nat.add_sub_of_le h
  · ext y
    simp only [Set.mem_preimage, Set.mem_singleton_iff]
    rw [if_neg h]
    constructor
    · intro heq
      exact False.elim (h (by rw [← heq]; exact Nat.le_add_right x y))
    · intro heq
      exact False.elim heq

private lemma finite_tsum_of_support_le (n : ℕ) (f : ℕ → ℝ≥0∞)
    (hf : ∀ x, x > n → f x = 0) :
    (∑' x : ℕ, f x) = ∑ x ∈ Finset.range (n + 1), f x := by
  have hsupp : Function.support f ⊆ (↑(Finset.range (n + 1)) : Set ℕ) := by
    intro x hx
    simp only [Finset.mem_coe, Finset.mem_range]
    by_contra hxn
    apply hx
    exact hf x (Nat.le_of_not_gt hxn)
  rw [← tsum_subtype_eq_of_support_subset hsupp]
  exact Finset.tsum_subtype' (Finset.range (n + 1)) f

/-- The convolution of two Poisson measures is Poisson with the summed rate. -/
theorem poissonMeasure_conv_poissonMeasure (r s : ℝ≥0) :
    ProbabilityTheory.poissonMeasure r ∗ ProbabilityTheory.poissonMeasure s =
      ProbabilityTheory.poissonMeasure (r + s) := by
  apply Measure.ext_of_singleton
  intro n
  rw [Measure.conv, Measure.map_apply measurable_add (measurableSet_singleton n)]
  rw [Measure.prod_apply]
  rw [lintegral_countable']
  have hinner (x : ℕ) :
      ProbabilityTheory.poissonMeasure s
          (Prod.mk x ⁻¹' ((fun p : ℕ × ℕ => p.1 + p.2) ⁻¹' ({n} : Set ℕ))) =
        if x ≤ n then ENNReal.ofReal (ProbabilityTheory.poissonPMFReal s (n - x))
        else 0 := by
    rw [poisson_add_fiber]
    split_ifs with h
    · rw [poissonMeasure_mass]
    · simp
  simp_rw [hinner, poissonMeasure_mass]
  let f : ℕ → ℝ≥0∞ := fun x =>
    (if x ≤ n then ENNReal.ofReal (ProbabilityTheory.poissonPMFReal s (n - x)) else 0) *
      ENNReal.ofReal (ProbabilityTheory.poissonPMFReal r x)
  have hfinite : (∑' x : ℕ, f x) = ∑ x ∈ Finset.range (n + 1), f x := by
    apply finite_tsum_of_support_le
    intro x hx
    simp [f, Nat.not_le_of_gt hx]
  change (∑' x : ℕ, f x) = _
  rw [hfinite]
  have hsum_nonneg (x : ℕ) (hx : x ∈ Finset.range (n + 1)) :
      0 ≤ ProbabilityTheory.poissonPMFReal s (n - x) *
        ProbabilityTheory.poissonPMFReal r x :=
    mul_nonneg ProbabilityTheory.poissonPMFReal_nonneg
      ProbabilityTheory.poissonPMFReal_nonneg
  have hsum :
      (∑ x ∈ Finset.range (n + 1), f x) =
        ENNReal.ofReal
          (∑ x ∈ Finset.range (n + 1),
            ProbabilityTheory.poissonPMFReal s (n - x) *
              ProbabilityTheory.poissonPMFReal r x) := by
    rw [ENNReal.ofReal_sum_of_nonneg hsum_nonneg]
    apply Finset.sum_congr rfl
    intro x hx
    have hxn : x ≤ n := Nat.le_of_lt_succ (Finset.mem_range.1 hx)
    simp only [f, if_pos hxn]
    rw [← ENNReal.ofReal_mul ProbabilityTheory.poissonPMFReal_nonneg]
  rw [hsum]
  apply congrArg ENNReal.ofReal
  calc
    (∑ x ∈ Finset.range (n + 1),
        ProbabilityTheory.poissonPMFReal s (n - x) *
          ProbabilityTheory.poissonPMFReal r x) =
      ∑ x ∈ Finset.range (n + 1),
        Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
          (n.choose x : ℝ) * (↑s : ℝ) ^ (n - x) * (↑r : ℝ) ^ x := by
        apply Finset.sum_congr rfl
        intro x hx
        have hxn : x ≤ n := Nat.le_of_lt_succ (Finset.mem_range.1 hx)
        have hfac_nat := Nat.choose_mul_factorial_mul_factorial hxn
        have hfac : (n.choose x : ℝ) * (x.factorial : ℝ) *
            ((n - x).factorial : ℝ) = (n.factorial : ℝ) := by
          exact_mod_cast hfac_nat
        simp only [ProbabilityTheory.poissonPMFReal]
        have hexp : Real.exp (-↑s) * Real.exp (-↑r) =
            Real.exp (-(↑r + ↑s)) := by
          rw [← Real.exp_add]
          congr 1
          ring
        field_simp [Nat.factorial_ne_zero, Real.exp_ne_zero]
        calc
          _ = Real.exp (-↑s) * Real.exp (-↑r) * (↑s : ℝ) ^ (n - x) *
              (↑r : ℝ) ^ x * (n.factorial : ℝ) := by ring
          _ = _ := by
            rw [hexp]
            rw [← hfac]
            ring
    _ = Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) * (↑r + ↑s) ^ n := by
      calc
        (∑ x ∈ Finset.range (n + 1),
            Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
              (n.choose x : ℝ) * (↑s : ℝ) ^ (n - x) * (↑r : ℝ) ^ x) =
          Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
            ∑ x ∈ Finset.range (n + 1),
              (n.choose x : ℝ) * (↑s : ℝ) ^ (n - x) * (↑r : ℝ) ^ x := by
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro x hx
            ring
        _ = Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) * (↑r + ↑s) ^ n := by
          have hbin := add_pow (↑r : ℝ) (↑s : ℝ) n
          calc
            Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
                ∑ x ∈ Finset.range (n + 1),
                  (n.choose x : ℝ) * (↑s : ℝ) ^ (n - x) * (↑r : ℝ) ^ x =
              Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) *
                ∑ x ∈ Finset.range (n + 1),
                  (↑r : ℝ) ^ x * (↑s : ℝ) ^ (n - x) * (n.choose x : ℝ) := by
                    apply congrArg (fun z => Real.exp (-(↑r + ↑s)) /
                      (n.factorial : ℝ) * z)
                    apply Finset.sum_congr rfl
                    intro x hx
                    ring
            _ = Real.exp (-(↑r + ↑s)) / (n.factorial : ℝ) * (↑r + ↑s) ^ n := by
              rw [hbin]
    _ = ProbabilityTheory.poissonPMFReal (r + s) n := by
      simp only [ProbabilityTheory.poissonPMFReal, NNReal.coe_add]
      ring
  all_goals exact measurableSet_preimage measurable_add (measurableSet_singleton n)

private lemma exp_add_half_le (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := δ / 2) (by
    calc
      |δ / 2| = δ / 2 := abs_of_nonneg (by positivity)
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (δ / 2) - 1 - δ / 2 ≤ (δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

private lemma exp_neg_half_le (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := -δ / 2) (by
    calc
      |-δ / 2| = δ / 2 := by
        rw [abs_of_nonpos (by linarith)]
        ring
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (-δ / 2) - 1 - (-δ / 2) ≤ (-δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

/-! Exercise 2.3.5: the optimized Poisson-binomial Chernoff bounds imply a
quadratic two-sided estimate.  We use the non-optimized parameter `δ/2`; the
second-order exponential remainder gives the explicit universal constant
`c = 1/4` uniformly for `0 < δ ≤ 1`. -/
theorem poissonBinomialTwoSidedQuadraticBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {δ : ℝ} (hδ0 : 0 < δ) (hδ1 : δ ≤ 1)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ)
    (hExpS : ∀ (lam : ℝ),
      Integrable (fun ω => Real.exp (lam * ∑ i, (if B i ω then 1 else 0))) μ) :
    μ.real {ω |
        δ * (∑ i, (p i : ℝ)) ≤
          |(∑ i, (if B i ω then 1 else 0)) - ∑ i, (p i : ℝ)|} ≤
      2 * Real.exp (-(∑ i, (p i : ℝ)) * δ ^ 2 / 4) := by
  let S : Ω → ℝ := fun ω => ∑ i, (if B i ω then 1 else 0)
  let m : ℝ := ∑ i, (p i : ℝ)
  have hm : 0 ≤ m := by
    dsimp [m]
    exact Finset.sum_nonneg (fun i _ => by positivity)
  have hS : Measurable S := by
    dsimp [S]
    refine Finset.measurable_fun_sum Finset.univ ?_
    intro i hi
    exact Measurable.ite
      (measurableSet_preimage (hMeas i) (measurableSet_singleton (true : Bool)))
      measurable_const measurable_const
  have hupper_mgf := poissonBinomialMgfBound hp hB hLaw (δ / 2) (by
    intro i
    exact hExp (δ / 2) i)
  have hlower_mgf := poissonBinomialMgfBound hp hB hLaw (-δ / 2) (by
    intro i
    exact hExp (-δ / 2) i)
  have hupper_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (t := (1 + δ) * m) hS (by linarith) (hExpS (δ / 2))
  have hlower_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := fun ω => -S ω) (lam := δ / 2) (t := -(1 - δ) * m)
      hS.neg (by linarith)
    (by
      have hEq :
          (fun ω => Real.exp (δ / 2 * (fun ω => -S ω) ω)) =
            (fun ω => Real.exp ((-δ / 2) * ∑ i, (if B i ω then 1 else 0))) := by
        funext ω
        dsimp [S]
        congr 1
        ring
      rw [hEq]
      exact hExpS (-δ / 2))
  have hupper_exp : Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 :=
    exp_add_half_le δ hδ0.le hδ1
  have hlower_exp : Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 :=
    exp_neg_half_le δ hδ0.le hδ1
  have hupper_coeff :
      -(δ / 2 * ((1 + δ) * m)) + (Real.exp (δ / 2) - 1) * m ≤
        -(m * δ ^ 2 / 4) := by
    have hcoeff :
        -(δ / 2 * (1 + δ)) + (Real.exp (δ / 2) - 1) ≤ -(δ ^ 2 / 4) := by
      nlinarith [hupper_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hlower_coeff :
      -(δ / 2 * (-(1 - δ) * m)) + (Real.exp (-δ / 2) - 1) * m ≤
        -(m * δ ^ 2 / 4) := by
    have hcoeff :
        (δ / 2) * (1 - δ) + (Real.exp (-δ / 2) - 1) ≤ -(δ ^ 2 / 4) := by
      nlinarith [hlower_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hupper_raw : μ.real (S ⁻¹' Set.Ici ((1 + δ) * m)) ≤
      Real.exp (-(δ / 2 * ((1 + δ) * m))) *
        Real.exp ((Real.exp (δ / 2) - 1) * m) := by
    apply le_trans hupper_markov
    apply mul_le_mul_of_nonneg_left _ (Real.exp_nonneg _)
    simpa [S, m, mul_assoc] using hupper_mgf
  have hlower_raw : μ.real ((fun ω => -S ω) ⁻¹' Set.Ici (-(1 - δ) * m)) ≤
      Real.exp (-(δ / 2 * (-(1 - δ) * m))) *
        Real.exp ((Real.exp (-δ / 2) - 1) * m) := by
    apply le_trans hlower_markov
    apply mul_le_mul_of_nonneg_left _ (Real.exp_nonneg _)
    have hEq :
        (fun ω => Real.exp (δ / 2 * (fun ω => -S ω) ω)) =
          (fun ω => Real.exp ((-δ / 2) * ∑ i, (if B i ω then 1 else 0))) := by
      funext ω
      dsimp [S]
      congr 1
      ring
    rw [hEq]
    simpa [m] using hlower_mgf
  have hupper : μ.real {ω | (1 + δ) * m ≤ S ω} ≤
      Real.exp (-(m * δ ^ 2 / 4)) := by
    rw [show {ω | (1 + δ) * m ≤ S ω} = S ⁻¹' Set.Ici ((1 + δ) * m) by rfl]
    refine hupper_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hupper_coeff
  have hlower : μ.real {ω | S ω ≤ (1 - δ) * m} ≤
      Real.exp (-(m * δ ^ 2 / 4)) := by
    have hset : {ω | S ω ≤ (1 - δ) * m} =
        (fun ω => -S ω) ⁻¹' Set.Ici (-(1 - δ) * m) := by
      ext ω
      simp only [Set.mem_setOf_eq, Set.mem_preimage, Set.mem_Ici]
      constructor <;> intro h <;> linarith
    rw [hset]
    refine hlower_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hlower_coeff
  let U : Set Ω := {ω | (1 + δ) * m ≤ S ω}
  let L : Set Ω := {ω | S ω ≤ (1 - δ) * m}
  have hsubset : {ω | δ * m ≤ |S ω - m|} ⊆ U ∪ L := by
    intro ω hω
    change δ * m ≤ |S ω - m| at hω
    by_cases hupper : (1 + δ) * m ≤ S ω
    · exact Or.inl hupper
    · right
      have hnotupper : S ω < (1 + δ) * m := lt_of_not_ge hupper
      by_contra hnotlower
      have hlower' : (1 - δ) * m < S ω := lt_of_not_ge hnotlower
      have habs : |S ω - m| < δ * m := by
        rw [abs_lt]
        constructor <;> linarith
      exact (not_lt_of_ge hω) habs
  have hmono {A B : Set Ω} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  have hunion : μ.real (U ∪ L) ≤ μ.real U + μ.real L := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      (μ (U ∪ L)).toReal ≤ (μ U + μ L).toReal := by
        apply ENNReal.toReal_mono
        · exact ENNReal.add_ne_top.mpr ⟨measure_ne_top μ U, measure_ne_top μ L⟩
        · exact measure_union_le U L
      _ = (μ U).toReal + (μ L).toReal :=
        ENNReal.toReal_add (measure_ne_top μ U) (measure_ne_top μ L)
  have hfinal : μ.real {ω | δ * m ≤ |S ω - m|} ≤
      2 * Real.exp (-m * δ ^ 2 / 4) := by
    calc
      μ.real {ω | δ * m ≤ |S ω - m|} ≤ μ.real (U ∪ L) := hmono hsubset
      _ ≤ μ.real U + μ.real L := hunion
      _ ≤ Real.exp (-(m * δ ^ 2 / 4)) + Real.exp (-(m * δ ^ 2 / 4)) :=
        add_le_add (by simpa [U] using hupper) (by simpa [L] using hlower)
      _ = 2 * Real.exp (-m * δ ^ 2 / 4) := by ring
  simpa [S, m] using hfinal

/-! The sum of independent Poisson variables has the Poisson law with summed rate. -/
theorem poissonAddLaw
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℕ} {r s : ℝ≥0}
    (hX : HasLaw X (ProbabilityTheory.poissonMeasure r) μ)
    (hY : HasLaw Y (ProbabilityTheory.poissonMeasure s) μ)
    (hXY : X ⟂ᵢ[μ] Y) :
    HasLaw (X + Y) (ProbabilityTheory.poissonMeasure (r + s)) μ := by
  have h := hXY.hasLaw_add hX hY
  rw [poissonMeasure_conv_poissonMeasure] at h
  exact h

/-! The point-mass sharpness calculation from Remark 2.3.4.  We state the
asymptotic with its exact Stirling normalization; the book's `≍` notation is
the corresponding two-sided constant-factor consequence. -/
theorem poissonPointMass_isEquivalent_stirling (rate : ℝ≥0) (hrate : 0 < rate) :
    (fun k : ℕ => ProbabilityTheory.poissonPMFReal rate k) ~[Filter.atTop]
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) *
          (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k /
            Real.sqrt (2 * (k : ℝ) * Real.pi)) := by
  have _hrate_real : 0 < (rate : ℝ) := by exact_mod_cast hrate
  have hfactorial := Stirling.factorial_isEquivalent_stirling
  have hnumerator :
      (fun k : ℕ => Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k) ~[Filter.atTop]
        (fun k : ℕ => Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k) :=
    Asymptotics.IsEquivalent.refl
  have hinverse :
      (fun k : ℕ => ((k.factorial : ℝ)⁻¹)) ~[Filter.atTop]
        (fun k : ℕ =>
          (Real.sqrt (2 * (k : ℝ) * Real.pi) *
          ((k : ℝ) / Real.exp 1) ^ k)⁻¹) := by
    simpa only [Pi.inv_apply] using hfactorial.inv
  have hproduct :
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k *
          ((k.factorial : ℝ)⁻¹)) ~[Filter.atTop]
        (fun k : ℕ =>
          Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k *
            (Real.sqrt (2 * (k : ℝ) * Real.pi) *
            ((k : ℝ) / Real.exp 1) ^ k)⁻¹) := by
    simpa only [Pi.mul_apply] using hnumerator.mul hinverse
  have hleft :
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k *
          ((k.factorial : ℝ)⁻¹)) =ᶠ[Filter.atTop]
        (fun k : ℕ => ProbabilityTheory.poissonPMFReal rate k) := by
    filter_upwards [] with k
    simp [ProbabilityTheory.poissonPMFReal, div_eq_mul_inv]
  have hright :
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k *
          (Real.sqrt (2 * (k : ℝ) * Real.pi) *
            ((k : ℝ) / Real.exp 1) ^ k)⁻¹) =ᶠ[Filter.atTop]
        (fun k : ℕ =>
          Real.exp (-(rate : ℝ)) *
            (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k /
              Real.sqrt (2 * (k : ℝ) * Real.pi)) := by
    have hlarge : ∀ᶠ k : ℕ in Filter.atTop, 1 ≤ k :=
      Filter.eventually_atTop.2 ⟨1, fun _ hk => hk⟩
    filter_upwards [hlarge] with k hk
    have hk0 : (k : ℝ) ≠ 0 := by
      exact_mod_cast (Nat.ne_of_gt hk)
    have hscale : Real.sqrt (2 * (k : ℝ) * Real.pi) ≠ 0 := by
      positivity
    rw [div_pow, div_pow]
    field_simp [hk0, hscale, Real.exp_ne_zero]
    rw [mul_pow]
  exact (hproduct.congr_left hleft).congr_right hright

/-- The scalar Bernoulli MGF identity and its finite independent-product bound. -/
structure BernoulliMgfModelData : Prop where
  scalar : ∀ (p : ℝ≥0), (hp : p ≤ 1) → ∀ lam : ℝ,
    ((∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
        (PMF.bernoulli p hp).toMeasure) =
        1 + (Real.exp lam - 1) * (p : ℝ)) ∧
      (1 + (Real.exp lam - 1) * (p : ℝ) ≤
        Real.exp ((Real.exp lam - 1) * (p : ℝ)))
  tensor : ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0},
    (hp : ∀ i, p i ≤ 1) →
    iIndepFun B μ →
    (∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ) →
    ∀ lam : ℝ,
    (∀ i, Integrable
      (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ) →
    (∫ ω, Real.exp (lam * ∑ i, (if B i ω then 1 else 0)) ∂μ) ≤
      Real.exp ((Real.exp lam - 1) * ∑ i, (p i : ℝ))

theorem bernoulliMgfModel : BernoulliMgfModelData :=
  { scalar := fun p hp lam => bernoulliMgfBound p hp lam
    tensor := fun hp hB hLaw lam hExp => poissonBinomialMgfBound hp hB hLaw lam hExp }

/-- The source-facing data for `G(n,p)` and its vertex-degree observable. -/
structure ErdosRenyiModelData (n : ℕ) (p : Set.Icc (0 : ℝ) 1) where
  /-- The stored measure on graphs. -/
  graphLaw : Measure (SimpleGraph (Fin n))
  /-- The stored natural-valued observable for each vertex and graph. -/
  degree : Fin n → SimpleGraph (Fin n) → ℕ

/-- The Erdős--Rényi model on `Fin n`, with independent edge indicators. -/
noncomputable def erdosRenyiModel (n : ℕ) (p : Set.Icc (0 : ℝ) 1) :
    ErdosRenyiModelData n p :=
  { graphLaw := SimpleGraph.binomialRandom (Fin n) p
    degree := fun v G =>
      @SimpleGraph.degree (Fin n) G v (Fintype.ofFinite (G.neighborSet v)) }

theorem erdosRenyiModel_degree_eq_graphDegreeSum
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) (G : SimpleGraph (Fin n)) :
    (erdosRenyiModel n p).degree v G = graphDegreeSum v G := by
  dsimp [erdosRenyiModel]
  letI : Fintype (G.neighborSet v) := Fintype.ofFinite _
  calc
    @SimpleGraph.degree (Fin n) G v (Fintype.ofFinite (G.neighborSet v)) =
        Fintype.card (G.neighborSet v) :=
      (SimpleGraph.card_neighborSet_eq_degree G v).symm
    _ = (G.neighborSet v).ncard := by
      rw [Set.ncard_eq_toFinset_card', Set.toFinset_card]
    _ = graphDegreeSum v G := (graphDegreeSum_eq_graphDegree v G).symm

/-- The fixed set of possible edges incident to a vertex.  This is the finite
edge-coordinate index set used when reducing a random-graph degree to a
Bernoulli product observable. -/
def potentialIncidentEdges {V : Type*} (v : V) : Set (Sym2 V) :=
  (⊤ : SimpleGraph V).incidenceSet v

/-- Count the selected edges in the fixed potential incidence set. -/
def incidentEdgeCount {V : Type*} [Fintype V] (v : V) (G : SimpleGraph V) : ℕ :=
  (potentialIncidentEdges v ∩ G.edgeSet).ncard

theorem potentialIncidentEdges_inter_edgeSet {V : Type*} [Fintype V]
    (v : V) (G : SimpleGraph V) :
    potentialIncidentEdges v ∩ G.edgeSet = G.incidenceSet v := by
  classical
  ext e
  constructor
  · rintro ⟨⟨_, hv⟩, he⟩
    exact ⟨he, hv⟩
  · rintro ⟨he, hv⟩
    have heTop : e ∈ (⊤ : SimpleGraph V).edgeSet := by
      simpa [SimpleGraph.edgeSet] using G.not_isDiag_of_mem_edgeSet he
    exact ⟨⟨heTop, hv⟩, he⟩

theorem incidentEdgeCount_eq_degree {V : Type*} [Fintype V]
    (v : V) (G : SimpleGraph V) :
    incidentEdgeCount v G = @SimpleGraph.degree V G v (Fintype.ofFinite (G.neighborSet v)) := by
  classical
  letI : Fintype (G.neighborSet v) := Fintype.ofFinite _
  rw [incidentEdgeCount, potentialIncidentEdges_inter_edgeSet]
  simp [Set.ncard_eq_toFinset_card']

/-- The canonical Erdős--Rényi law is a probability measure. -/
instance erdosRenyiModel.isProbabilityMeasure
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) :
    IsProbabilityMeasure (erdosRenyiModel n p).graphLaw := by
  dsimp [erdosRenyiModel]
  infer_instance

theorem erdosRenyiDegreeLaw
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) :
    HasLaw ((erdosRenyiModel n p).degree v)
      (graphBinomialLaw n p)
      (erdosRenyiModel n p).graphLaw := by
  have h := graphDegreeSum_hasLaw p v
  have hcongr :
      (erdosRenyiModel n p).degree v = graphDegreeSum v := by
    funext G
    exact erdosRenyiModel_degree_eq_graphDegreeSum n p v G
  have h' := h.congr (Filter.Eventually.of_forall (fun G => congrFun hcongr G))
  simpa [erdosRenyiModel] using h'

/-! The exact finite MGF of Mathlib's canonical binomial PMF. -/
theorem binomialMgfExact (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (lam : ℝ) :
    (∫ k : Fin (n + 1), Real.exp (lam * (k : ℝ)) ∂
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) n).toMeasure) =
      (1 - (p : ℝ) + (p : ℝ) * Real.exp lam) ^ n := by
  rw [PMF.integral_eq_sum]
  simp only [smul_eq_mul, PMF.binomial_apply]
  rw [Finset.sum_fin_eq_sum_range]
  have hpNN : unitInterval.toNNReal p ≤ 1 := by
    change (p : ℝ) ≤ 1
    exact p.2.2
  have hq :
      (1 - (unitInterval.toNNReal p : ℝ≥0∞)).toReal = 1 - (p : ℝ) := by
    rw [ENNReal.toReal_sub_of_le (by exact_mod_cast hpNN) ENNReal.one_ne_top]
    rfl
  rw [show 1 - (p : ℝ) + (p : ℝ) * Real.exp lam =
      ((p : ℝ) * Real.exp lam) + (1 - (p : ℝ)) by ring]
  rw [add_pow]
  apply Finset.sum_congr rfl
  intro x hx
  have hxn : x ≤ n := Nat.le_of_lt_succ (Finset.mem_range.mp hx)
  have hexp : Real.exp (lam * (x : ℝ)) = Real.exp lam ^ x := by
    rw [mul_comm, Real.exp_nat_mul]
  simp only [dif_pos (Nat.lt_succ_of_le hxn)]
  simp [hq, ENNReal.toReal_mul, hexp]
  ring

theorem binomialMgfBound (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (lam : ℝ) :
    (∫ k : Fin (n + 1), Real.exp (lam * (k : ℝ)) ∂
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) n).toMeasure) ≤
      Real.exp ((Real.exp lam - 1) * (n * (p : ℝ))) := by
  rw [binomialMgfExact]
  have hbase : 1 + (Real.exp lam - 1) * (p : ℝ) ≤
      Real.exp ((Real.exp lam - 1) * (p : ℝ)) := by
    simpa [add_comm] using
      Real.add_one_le_exp ((Real.exp lam - 1) * (p : ℝ))
  have hpow :
      (1 + (Real.exp lam - 1) * (p : ℝ)) ^ n ≤
        Real.exp ((Real.exp lam - 1) * (p : ℝ)) ^ n :=
    pow_le_pow_left₀ (by
      have hp0 : 0 ≤ (p : ℝ) := p.2.1
      have hp1 : (p : ℝ) ≤ 1 := p.2.2
      have hprod : -(p : ℝ) ≤ (Real.exp lam - 1) * (p : ℝ) := by
        have he : 0 ≤ Real.exp lam := (Real.exp_pos lam).le
        nlinarith [mul_le_mul_of_nonneg_right (by linarith) hp0]
      linarith [hp1, hprod]) hbase n
  calc
    (1 - (p : ℝ) + (p : ℝ) * Real.exp lam) ^ n =
        (1 + (Real.exp lam - 1) * (p : ℝ)) ^ n := by
      congr 1
      ring
    _ ≤ Real.exp ((Real.exp lam - 1) * (p : ℝ)) ^ n := hpow
    _ = Real.exp ((Real.exp lam - 1) * (n * (p : ℝ))) := by
      rw [← Real.exp_nat_mul]
      congr 1
      ring

private lemma exp_add_half_le_graph (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := δ / 2) (by
    calc
      |δ / 2| = δ / 2 := abs_of_nonneg (by positivity)
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (δ / 2) - 1 - δ / 2 ≤ (δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

private lemma exp_neg_half_le_graph (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := -δ / 2) (by
    calc
      |-δ / 2| = δ / 2 := by
        rw [abs_of_nonpos (by linarith)]
        ring
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (-δ / 2) - 1 - (-δ / 2) ≤ (-δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

theorem binomialTwoSidedBound (m : ℕ) (p : Set.Icc (0 : ℝ) 1) {δ : ℝ}
    (hδ0 : 0 < δ) (hδ1 : δ ≤ 1) :
    let μ : Measure (Fin (m + 1)) :=
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
    μ.real {k |
        δ * (m * (p : ℝ)) ≤ |(k : ℝ) - m * (p : ℝ)|} ≤
      2 * Real.exp (-(m * (p : ℝ)) * δ ^ 2 / 4) := by
  dsimp
  let μ : Measure (Fin (m + 1)) :=
    (PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
  let S : Fin (m + 1) → ℝ := fun k => (k : ℝ)
  let mr : ℝ := m * (p : ℝ)
  have hm : 0 ≤ mr := by
    dsimp [mr]
    exact mul_nonneg (by positivity) p.2.1
  have hS : Measurable S := by
    dsimp [S]
    exact measurable_of_finite _
  have hupper_mgf :
      (∫ k, Real.exp ((δ / 2) * S k) ∂μ) ≤
        Real.exp ((Real.exp (δ / 2) - 1) * mr) := by
    simpa [S, mr, μ] using binomialMgfBound m p (δ / 2)
  have hlower_mgf :
      (∫ k, Real.exp ((-δ / 2) * S k) ∂μ) ≤
        Real.exp ((Real.exp (-δ / 2) - 1) * mr) := by
    simpa [S, mr, μ] using binomialMgfBound m p (-δ / 2)
  have hupper_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := S) (lam := δ / 2) (t := (1 + δ) * mr) hS (by linarith)
      (by exact Integrable.of_finite)
  have hlower_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := fun k => -S k) (lam := δ / 2)
      (t := -(1 - δ) * mr) hS.neg (by linarith)
      (by exact Integrable.of_finite)
  have hupper_exp : Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 :=
    exp_add_half_le_graph δ hδ0.le hδ1
  have hlower_exp : Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 :=
    exp_neg_half_le_graph δ hδ0.le hδ1
  have hupper_coeff :
      -(δ / 2 * ((1 + δ) * mr)) + (Real.exp (δ / 2) - 1) * mr ≤
        -(mr * δ ^ 2 / 4) := by
    have hcoeff :
        -(δ / 2 * (1 + δ)) + (Real.exp (δ / 2) - 1) ≤ -(δ ^ 2 / 4) := by
      nlinarith [hupper_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hlower_coeff :
      -(δ / 2 * (-(1 - δ) * mr)) + (Real.exp (-δ / 2) - 1) * mr ≤
        -(mr * δ ^ 2 / 4) := by
    have hcoeff :
        (δ / 2) * (1 - δ) + (Real.exp (-δ / 2) - 1) ≤ -(δ ^ 2 / 4) := by
      nlinarith [hlower_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hupper_raw : μ.real (S ⁻¹' Set.Ici ((1 + δ) * mr)) ≤
      Real.exp (-(δ / 2 * ((1 + δ) * mr))) *
        Real.exp ((Real.exp (δ / 2) - 1) * mr) := by
    apply le_trans hupper_markov
    apply mul_le_mul_of_nonneg_left _ (Real.exp_nonneg _)
    simpa [S, mr] using hupper_mgf
  have hlower_raw : μ.real ((fun k => -S k) ⁻¹' Set.Ici (-(1 - δ) * mr)) ≤
      Real.exp (-(δ / 2 * (-(1 - δ) * mr))) *
        Real.exp ((Real.exp (-δ / 2) - 1) * mr) := by
    apply le_trans hlower_markov
    apply mul_le_mul_of_nonneg_left _ (Real.exp_nonneg _)
    convert hlower_mgf using 1
    all_goals simp [S]
    all_goals ring
  have hupper : μ.real {k | (1 + δ) * mr ≤ S k} ≤
      Real.exp (-(mr * δ ^ 2 / 4)) := by
    rw [show {k | (1 + δ) * mr ≤ S k} = S ⁻¹' Set.Ici ((1 + δ) * mr) by rfl]
    refine hupper_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hupper_coeff
  have hlower : μ.real {k | S k ≤ (1 - δ) * mr} ≤
      Real.exp (-(mr * δ ^ 2 / 4)) := by
    have hset : {k | S k ≤ (1 - δ) * mr} =
        (fun k => -S k) ⁻¹' Set.Ici (-(1 - δ) * mr) := by
      ext k
      simp only [Set.mem_setOf_eq, Set.mem_preimage, Set.mem_Ici]
      constructor <;> intro h <;> linarith
    rw [hset]
    refine hlower_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hlower_coeff
  let U : Set (Fin (m + 1)) := {k | (1 + δ) * mr ≤ S k}
  let L : Set (Fin (m + 1)) := {k | S k ≤ (1 - δ) * mr}
  have hsubset : {k | δ * mr ≤ |S k - mr|} ⊆ U ∪ L := by
    intro k h
    change δ * mr ≤ |S k - mr| at h
    by_cases hu : (1 + δ) * mr ≤ S k
    · exact Or.inl hu
    · right
      have hnu : S k < (1 + δ) * mr := lt_of_not_ge hu
      by_contra hnl
      have hnl' : (1 - δ) * mr < S k := lt_of_not_ge hnl
      have habs : |S k - mr| < δ * mr := by
        rw [abs_lt]
        constructor <;> linarith
      exact (not_lt_of_ge h) habs
  have hmono {A B : Set (Fin (m + 1))} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  have hunion : μ.real (U ∪ L) ≤ μ.real U + μ.real L := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      (μ (U ∪ L)).toReal ≤ (μ U + μ L).toReal := by
        apply ENNReal.toReal_mono
        · exact ENNReal.add_ne_top.mpr ⟨measure_ne_top μ U, measure_ne_top μ L⟩
        · exact measure_union_le U L
      _ = (μ U).toReal + (μ L).toReal :=
        ENNReal.toReal_add (measure_ne_top μ U) (measure_ne_top μ L)
  have hfinal : μ.real {k | δ * mr ≤ |S k - mr|} ≤
      2 * Real.exp (-mr * δ ^ 2 / 4) := by
    calc
      μ.real {k | δ * mr ≤ |S k - mr|} ≤ μ.real (U ∪ L) := hmono hsubset
      _ ≤ μ.real U + μ.real L := hunion
      _ ≤ Real.exp (-(mr * δ ^ 2 / 4)) + Real.exp (-(mr * δ ^ 2 / 4)) :=
        add_le_add (by simpa [U] using hupper) (by simpa [L] using hlower)
      _ = 2 * Real.exp (-mr * δ ^ 2 / 4) := by ring
  simpa [S, mr, μ] using hfinal

set_option maxHeartbeats 4000000 in
theorem erdosRenyiDegreeDeviationBound
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) {δ : ℝ}
    (hδ0 : 0 < δ) (hδ1 : δ ≤ 1) :
    (erdosRenyiModel n p).graphLaw.real {G |
        δ * ((n - 1) * (p : ℝ)) ≤
          |((erdosRenyiModel n p).degree v G : ℝ) - (n - 1) * (p : ℝ)|} ≤
      2 * Real.exp (-((n - 1) * (p : ℝ)) * δ ^ 2 / 4) := by
  let A : Set ℕ := {k |
    δ * ((n - 1) * (p : ℝ)) ≤ |(k : ℝ) - (n - 1) * (p : ℝ)|}
  have hA : MeasurableSet A := by
    exact (Set.to_countable A).measurableSet
  have hLaw := erdosRenyiDegreeLaw n p v
  have hn0 : n ≠ 0 := by
    intro hn0
    subst n
    exact Nat.not_lt_zero _ v.isLt
  have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn0
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hgraph :
      (erdosRenyiModel n p).graphLaw.real
          ((erdosRenyiModel n p).degree v ⁻¹' A) =
        (graphBinomialLaw n p).real A := by
    rw [Measure.real_def, Measure.real_def, ← hLaw.map_eq,
      Measure.map_apply_of_aemeasurable hLaw.aemeasurable hA]
  rw [show {G |
      δ * ((n - 1) * (p : ℝ)) ≤
        |((erdosRenyiModel n p).degree v G : ℝ) - (n - 1) * (p : ℝ)|} =
      ((erdosRenyiModel n p).degree v ⁻¹' A) by
        ext G
        rfl]
  rw [hgraph]
  rw [graphBinomialLaw]
  have hpmf :
      ((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
          (PMF.binomial (unitInterval.toNNReal p)
            (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure).real A =
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure.real
          ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A) := by
    change (((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure A).toReal) =
      ((PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure
        ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A)).toReal
    rw [PMF.toMeasure_map_apply (p := PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))
      (f := fun i : Fin (n - 1 + 1) => (i : ℕ))
      A (measurable_of_countable _) hA]
  rw [hpmf]
  have hpre :
      (fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A =
        {i : Fin (n - 1 + 1) | δ * ((n - 1) * (p : ℝ)) ≤
          |((i : ℕ) : ℝ) - (n - 1) * (p : ℝ)|} := by
    ext i
    rfl
  rw [hpre]
  simpa [hsub] using (binomialTwoSidedBound (n - 1) p hδ0 hδ1)

theorem binomialUpperTailBound (m : ℕ) (p : Set.Icc (0 : ℝ) 1) {t : ℝ} :
    let μ : Measure (Fin (m + 1)) :=
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
    μ.real {k | t ≤ (k : ℝ)} ≤
      Real.exp (-t + 2 * (m * (p : ℝ))) := by
  dsimp
  let μ : Measure (Fin (m + 1)) :=
    (PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
  let S : Fin (m + 1) → ℝ := fun k => (k : ℝ)
  have hS : Measurable S := by
    dsimp [S]
    exact measurable_of_finite _
  have hmgf :
      (∫ k, Real.exp (S k) ∂μ) ≤
        Real.exp ((Real.exp 1 - 1) * (m * (p : ℝ))) := by
    simpa [S, μ, one_mul] using binomialMgfBound m p 1
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := S) (lam := 1) (t := t) hS (by norm_num)
      (by exact Integrable.of_finite)
  have hraw : μ.real (S ⁻¹' Set.Ici t) ≤
      Real.exp (-t) * Real.exp ((Real.exp 1 - 1) * (m * (p : ℝ))) := by
    calc
      μ.real (S ⁻¹' Set.Ici t) ≤
          Real.exp (-t) * (∫ k, Real.exp (S k) ∂μ) := by
        simpa [S, one_mul] using hmarkov
      _ ≤ Real.exp (-t) *
          Real.exp ((Real.exp 1 - 1) * (m * (p : ℝ))) :=
        mul_le_mul_of_nonneg_left hmgf (Real.exp_nonneg _)
  calc
    μ.real {k | t ≤ (k : ℝ)} = μ.real (S ⁻¹' Set.Ici t) := by rfl
    _ ≤ Real.exp (-t) *
        Real.exp ((Real.exp 1 - 1) * (m * (p : ℝ))) := hraw
    _ = Real.exp (-t + (Real.exp 1 - 1) * (m * (p : ℝ))) := by
      rw [← Real.exp_add]
    _ ≤ Real.exp (-t + 2 * (m * (p : ℝ))) := by
      apply Real.exp_le_exp.2
      have hμ : 0 ≤ (m : ℝ) * (p : ℝ) :=
        mul_nonneg (Nat.cast_nonneg _) p.2.1
      have hexp : Real.exp 1 - 1 < 2 := by
        linarith [Real.exp_one_lt_three]
      nlinarith

theorem erdosRenyiDegreeUpperBound
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) {t : ℝ} :
    (erdosRenyiModel n p).graphLaw.real {G |
        t ≤ ((erdosRenyiModel n p).degree v G : ℝ)} ≤
      Real.exp (-t + 2 * ((n - 1) * (p : ℝ))) := by
  let A : Set ℕ := {k | t ≤ (k : ℝ)}
  have hA : MeasurableSet A := by
    exact (Set.to_countable A).measurableSet
  have hLaw := erdosRenyiDegreeLaw n p v
  have hn0 : n ≠ 0 := by
    intro hn0
    subst n
    exact Nat.not_lt_zero _ v.isLt
  have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn0
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hgraph :
      (erdosRenyiModel n p).graphLaw.real
          ((erdosRenyiModel n p).degree v ⁻¹' A) =
        (graphBinomialLaw n p).real A := by
    rw [Measure.real_def, Measure.real_def, ← hLaw.map_eq,
      Measure.map_apply_of_aemeasurable hLaw.aemeasurable hA]
  rw [show {G |
      t ≤ ((erdosRenyiModel n p).degree v G : ℝ)} =
      ((erdosRenyiModel n p).degree v ⁻¹' A) by
        ext G
        rfl]
  rw [hgraph, graphBinomialLaw]
  have hpmf :
      ((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
          (PMF.binomial (unitInterval.toNNReal p)
            (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure).real A =
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure.real
          ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A) := by
    change (((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure A).toReal) =
      ((PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure
        ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A)).toReal
    rw [PMF.toMeasure_map_apply (p := PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))
      (f := fun i : Fin (n - 1 + 1) => (i : ℕ))
      A (measurable_of_countable _) hA]
  rw [hpmf]
  have hpre :
      (fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A =
        {i : Fin (n - 1 + 1) | t ≤ ((i : ℕ) : ℝ)} := by
    ext i
    rfl
  rw [hpre]
  simpa [hsub] using (binomialUpperTailBound (n - 1) p (t := t))

theorem binomialUpperTailMgfBound (m : ℕ) (p : Set.Icc (0 : ℝ) 1)
    {t lam : ℝ} (hlam : 0 < lam) :
    let μ : Measure (Fin (m + 1)) :=
      (PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
    μ.real {k | t ≤ (k : ℝ)} ≤
      Real.exp (-lam * t + (Real.exp lam - 1) * (m * (p : ℝ))) := by
  dsimp
  let μ : Measure (Fin (m + 1)) :=
    (PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) m).toMeasure
  let S : Fin (m + 1) → ℝ := fun k => (k : ℝ)
  have hS : Measurable S := by
    dsimp [S]
    exact measurable_of_finite _
  have hmgf :
      (∫ k, Real.exp (lam * S k) ∂μ) ≤
        Real.exp ((Real.exp lam - 1) * (m * (p : ℝ))) := by
    simpa [S, μ] using binomialMgfBound m p lam
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := μ) (S := S) (lam := lam) (t := t) hS hlam
      (by exact Integrable.of_finite)
  calc
    μ.real {k | t ≤ (k : ℝ)} = μ.real (S ⁻¹' Set.Ici t) := by rfl
    _ ≤ Real.exp (-lam * t) * (∫ k, Real.exp (lam * S k) ∂μ) := by
      simpa [S] using hmarkov
    _ ≤ Real.exp (-lam * t) *
        Real.exp ((Real.exp lam - 1) * (m * (p : ℝ))) :=
      mul_le_mul_of_nonneg_left hmgf (Real.exp_nonneg _)
    _ = Real.exp (-lam * t + (Real.exp lam - 1) * (m * (p : ℝ))) := by
      rw [← Real.exp_add]

theorem erdosRenyiDegreeUpperBoundAt
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n)
    {t lam : ℝ} (hlam : 0 < lam) :
    (erdosRenyiModel n p).graphLaw.real {G |
        t ≤ ((erdosRenyiModel n p).degree v G : ℝ)} ≤
      Real.exp (-lam * t + (Real.exp lam - 1) * ((n - 1) * (p : ℝ))) := by
  let A : Set ℕ := {k | t ≤ (k : ℝ)}
  have hA : MeasurableSet A := by
    exact (Set.to_countable A).measurableSet
  have hLaw := erdosRenyiDegreeLaw n p v
  have hn0 : n ≠ 0 := by
    intro hn0
    subst n
    exact Nat.not_lt_zero _ v.isLt
  have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn0
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hgraph :
      (erdosRenyiModel n p).graphLaw.real
          ((erdosRenyiModel n p).degree v ⁻¹' A) =
        (graphBinomialLaw n p).real A := by
    rw [Measure.real_def, Measure.real_def, ← hLaw.map_eq,
      Measure.map_apply_of_aemeasurable hLaw.aemeasurable hA]
  rw [show {G |
      t ≤ ((erdosRenyiModel n p).degree v G : ℝ)} =
      ((erdosRenyiModel n p).degree v ⁻¹' A) by
        ext G
        rfl]
  rw [hgraph, graphBinomialLaw]
  have hpmf :
      ((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
          (PMF.binomial (unitInterval.toNNReal p)
            (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure).real A =
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure.real
          ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A) := by
    change (((PMF.map (fun i : Fin (n - 1 + 1) => (i : ℕ))
        (PMF.binomial (unitInterval.toNNReal p)
          (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))).toMeasure A).toReal) =
      ((PMF.binomial (unitInterval.toNNReal p)
        (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).toMeasure
        ((fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A)).toReal
    rw [PMF.toMeasure_map_apply (p := PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1))
      (f := fun i : Fin (n - 1 + 1) => (i : ℕ))
      A (measurable_of_countable _) hA]
  rw [hpmf]
  have hpre :
      (fun i : Fin (n - 1 + 1) => (i : ℕ)) ⁻¹' A =
        {i : Fin (n - 1 + 1) | t ≤ ((i : ℕ) : ℝ)} := by
    ext i
    rfl
  rw [hpre]
  simpa [hsub] using (binomialUpperTailMgfBound (n - 1) p (t := t) hlam)

set_option maxHeartbeats 4000000 in
theorem erdosRenyiAlmostRegular
    (n : ℕ) (hn : 2 ≤ n) (p : Set.Icc (0 : ℝ) 1)
    (hd : 4000 * Real.log (n : ℝ) ≤ (n - 1) * (p : ℝ)) :
    (erdosRenyiModel n p).graphLaw.real {G |
        ∀ v : Fin n,
          |((erdosRenyiModel n p).degree v G : ℝ) - (n - 1) * (p : ℝ)| <
            ((n - 1) * (p : ℝ)) / 10} ≥ (9 : ℝ) / 10 := by
  let d : ℝ := (n - 1) * (p : ℝ)
  let P : Measure (SimpleGraph (Fin n)) := (erdosRenyiModel n p).graphLaw
  let Bad : Fin n → Set (SimpleGraph (Fin n)) := fun v =>
    {G | (1 / 10 : ℝ) * d ≤
      |((erdosRenyiModel n p).degree v G : ℝ) - d|}
  let Good : Set (SimpleGraph (Fin n)) := {G |
    ∀ v : Fin n,
      |((erdosRenyiModel n p).degree v G : ℝ) - d| < d / 10}
  have hbad_meas : ∀ v : Fin n, MeasurableSet (Bad v) := by
    intro v
    have heq : Bad v = {G |
        (1 / 10 : ℝ) * d ≤ |(graphDegreeSum v G : ℝ) - d|} := by
      ext G
      simp only [Bad, Set.mem_setOf_eq]
      rw [erdosRenyiModel_degree_eq_graphDegreeSum]
    rw [heq]
    have hcast : Measurable (fun k : ℕ => (k : ℝ)) := measurable_of_countable _
    have hmeas : Measurable (fun G : SimpleGraph (Fin n) =>
        |(graphDegreeSum v G : ℝ) - d|) := by
      exact ((hcast.comp (measurable_graphDegreeSum v)).sub measurable_const).abs
    exact hmeas (measurableSet_Ici)
  have hbad_each : ∀ v : Fin n, P.real (Bad v) ≤
      2 * Real.exp (-d / 400) := by
    intro v
    dsimp [P, Bad, d]
    convert erdosRenyiDegreeDeviationBound n p v
      (δ := (1 : ℝ) / 10) (by norm_num) (by norm_num) using 1; ring
  have hbad_union : P.real (⋃ v, Bad v) ≤
      2 * (n : ℝ) * Real.exp (-d / 400) := by
    calc
      P.real (⋃ v, Bad v) ≤ ∑ v, P.real (Bad v) :=
        measureReal_iUnion_fintype_le (μ := P) Bad
      _ ≤ ∑ _v : Fin n, 2 * Real.exp (-d / 400) := by
        exact Finset.sum_le_sum (fun v _ => hbad_each v)
      _ = 2 * (n : ℝ) * Real.exp (-d / 400) := by
        simp
        ring
  have hnpos : 0 < (n : ℝ) := by
    exact_mod_cast (Nat.zero_lt_of_lt hn)
  have hn2 : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hdexp : Real.exp (-d / 400) ≤
      Real.exp (-10 * Real.log (n : ℝ)) := by
    apply Real.exp_le_exp.2
    dsimp [d]
    nlinarith [hd]
  have hexp : Real.exp (-10 * Real.log (n : ℝ)) =
      ((n : ℝ) ^ 10)⁻¹ := by
    have hpow : Real.exp (10 * Real.log (n : ℝ)) = (n : ℝ) ^ 10 := by
      calc
        Real.exp (10 * Real.log (n : ℝ)) =
            Real.exp (Real.log (n : ℝ)) ^ 10 := by
          convert Real.exp_nat_mul (Real.log (n : ℝ)) 10 using 1
        _ = (n : ℝ) ^ 10 := by rw [Real.exp_log hnpos]
    rw [show -10 * Real.log (n : ℝ) = -(10 * Real.log (n : ℝ)) by ring,
      Real.exp_neg, hpow]
  have hpow9 : (2 : ℝ) ^ 9 ≤ (n : ℝ) ^ 9 :=
    pow_le_pow_left₀ (by norm_num) hn2 9
  have h20 : 20 * (n : ℝ) ≤ (n : ℝ) ^ 10 := by
    have hmul := mul_le_mul_of_nonneg_left hpow9 hnpos.le
    calc
      20 * (n : ℝ) ≤ 512 * (n : ℝ) := by nlinarith
      _ = (n : ℝ) * (2 : ℝ) ^ 9 := by ring
      _ ≤ (n : ℝ) * (n : ℝ) ^ 9 := hmul
      _ = (n : ℝ) ^ 10 := by ring
  have hsmall : 2 * (n : ℝ) * Real.exp (-d / 400) ≤ (1 : ℝ) / 10 := by
    have hpowpos : 0 < (n : ℝ) ^ 10 := by positivity
    have hdiv : 2 * (n : ℝ) / (n : ℝ) ^ 10 ≤ (1 : ℝ) / 10 := by
      rw [div_le_iff₀ hpowpos]
      nlinarith [h20]
    calc
      2 * (n : ℝ) * Real.exp (-d / 400) ≤
          2 * (n : ℝ) * Real.exp (-10 * Real.log (n : ℝ)) :=
        mul_le_mul_of_nonneg_left hdexp (by positivity)
      _ = 2 * (n : ℝ) / (n : ℝ) ^ 10 := by
        rw [hexp]
        simp [div_eq_mul_inv]
      _ ≤ (1 : ℝ) / 10 := hdiv
  have hbad_small : P.real (⋃ v, Bad v) ≤ (1 : ℝ) / 10 :=
    hbad_union.trans hsmall
  have hgood_eq : Good = (⋃ v, Bad v)ᶜ := by
    ext G
    simp only [Good, Bad, Set.mem_compl_iff, Set.mem_iUnion, Set.mem_setOf_eq]
    constructor
    · intro hG hbad
      rcases hbad with ⟨v, hv⟩
      exact (not_le_of_gt (hG v)) (by
        convert hv using 1; ring)
    · intro hG v
      have hnot : ¬ (1 / 10 : ℝ) * d ≤
          |((erdosRenyiModel n p).degree v G : ℝ) - d| := by
        intro hv
        exact hG ⟨v, hv⟩
      exact (lt_of_not_ge (by
        convert hnot using 1; ring))
  have hUmeas : MeasurableSet (⋃ v, Bad v) := by
    exact MeasurableSet.iUnion hbad_meas
  have hgoodprob : P.real Good ≥ (9 : ℝ) / 10 := by
    rw [hgood_eq, measureReal_compl hUmeas]
    have hP : P.real Set.univ = 1 := by
      simp [P]
    rw [hP]
    linarith
  simpa [P, Good, d] using hgoodprob

theorem erdosRenyiSparseMaxDegreeLogBound
    (p : ℕ → Set.Icc (0 : ℝ) 1) (C : ℝ) (hC : 0 ≤ C)
    (hbound : ∀ᶠ n in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C * Real.log (n : ℝ)) :
    ∀ᶠ n in Filter.atTop,
      (erdosRenyiModel n (p n)).graphLaw.real {G |
        ∀ v : Fin n,
          ((erdosRenyiModel n (p n)).degree v G : ℝ) <
            (2 * C + 5) * Real.log (n : ℝ)} ≥ (9 : ℝ) / 10 := by
  filter_upwards [hbound,
    Filter.eventually_atTop.2 ⟨3, fun n hn => hn⟩] with n hdn hn3
  let d : ℝ := ((n - 1 : ℕ) : ℝ) * (p n : ℝ)
  let T : ℝ := (2 * C + 5) * Real.log (n : ℝ)
  let P : Measure (SimpleGraph (Fin n)) := (erdosRenyiModel n (p n)).graphLaw
  let Bad : Fin n → Set (SimpleGraph (Fin n)) := fun v =>
    {G | T ≤ ((erdosRenyiModel n (p n)).degree v G : ℝ)}
  let Good : Set (SimpleGraph (Fin n)) := {G |
    ∀ v : Fin n,
      ((erdosRenyiModel n (p n)).degree v G : ℝ) < T}
  have hnpos : 0 < (n : ℝ) := by
    exact_mod_cast (Nat.zero_lt_of_lt hn3)
  have hn2 : (2 : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast (show 2 ≤ n by omega)
  have hn1 : 1 ≤ n := by omega
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hlogpos : 0 < Real.log (n : ℝ) := by
    apply Real.log_pos
    exact_mod_cast (show 1 < n by omega)
  have hdn' : d ≤ C * Real.log (n : ℝ) := by
    simpa [d] using hdn
  have hbad_meas : ∀ v : Fin n, MeasurableSet (Bad v) := by
    intro v
    have heq : Bad v = {G |
        T ≤ (graphDegreeSum v G : ℝ)} := by
      ext G
      simp only [Bad, Set.mem_setOf_eq]
      rw [erdosRenyiModel_degree_eq_graphDegreeSum]
    rw [heq]
    have hcast : Measurable (fun k : ℕ => (k : ℝ)) := measurable_of_countable _
    have hmeas : Measurable (fun G : SimpleGraph (Fin n) =>
        (graphDegreeSum v G : ℝ)) := by
      exact hcast.comp (measurable_graphDegreeSum v)
    exact hmeas (measurableSet_Ici)
  have hbad_each : ∀ v : Fin n, P.real (Bad v) ≤
      Real.exp (-T + 2 * d) := by
    intro v
    dsimp [P, Bad, T, d]
    simpa [hsub] using (erdosRenyiDegreeUpperBound n (p n) v
      (t := (2 * C + 5) * Real.log (n : ℝ)))
  have hbad_union : P.real (⋃ v, Bad v) ≤
      (n : ℝ) * Real.exp (-T + 2 * d) := by
    calc
      P.real (⋃ v, Bad v) ≤ ∑ v, P.real (Bad v) :=
        measureReal_iUnion_fintype_le (μ := P) Bad
      _ ≤ ∑ _v : Fin n, Real.exp (-T + 2 * d) := by
        exact Finset.sum_le_sum (fun v _ => hbad_each v)
      _ = (n : ℝ) * Real.exp (-T + 2 * d) := by
        simp
  have hexp_tail : Real.exp (-T + 2 * d) ≤
      Real.exp (-5 * Real.log (n : ℝ)) := by
    apply Real.exp_le_exp.2
    dsimp [T]
    nlinarith [hdn']
  have hpow : Real.exp (5 * Real.log (n : ℝ)) = (n : ℝ) ^ 5 := by
    calc
      Real.exp (5 * Real.log (n : ℝ)) =
          Real.exp (Real.log (n : ℝ)) ^ 5 := by
        convert Real.exp_nat_mul (Real.log (n : ℝ)) 5 using 1
      _ = (n : ℝ) ^ 5 := by rw [Real.exp_log hnpos]
  have hexp5 : Real.exp (-5 * Real.log (n : ℝ)) =
      ((n : ℝ) ^ 5)⁻¹ := by
    rw [show -5 * Real.log (n : ℝ) = -(5 * Real.log (n : ℝ)) by ring,
      Real.exp_neg, hpow]
  have hpow4 : (2 : ℝ) ^ 4 ≤ (n : ℝ) ^ 4 :=
    pow_le_pow_left₀ (by norm_num) hn2 4
  have hpow4' : (16 : ℝ) ≤ (n : ℝ) ^ 4 := by
    norm_num at hpow4 ⊢
    exact hpow4
  have hten : 10 * (n : ℝ) ≤ (n : ℝ) ^ 5 := by
    have hmul := mul_le_mul_of_nonneg_left hpow4' hnpos.le
    calc
      10 * (n : ℝ) ≤ 16 * (n : ℝ) := by nlinarith
      _ ≤ (n : ℝ) * (n : ℝ) ^ 4 := by simpa [mul_comm] using hmul
      _ = (n : ℝ) ^ 5 := by ring
  have hsmall : (n : ℝ) * Real.exp (-5 * Real.log (n : ℝ)) ≤
      (1 : ℝ) / 10 := by
    have hpowpos : 0 < (n : ℝ) ^ 5 := by positivity
    have hdiv : (n : ℝ) / (n : ℝ) ^ 5 ≤ (1 : ℝ) / 10 := by
      rw [div_le_iff₀ hpowpos]
      nlinarith [hten]
    rw [hexp5]
    simpa [div_eq_mul_inv] using hdiv
  have hbad_small : P.real (⋃ v, Bad v) ≤ (1 : ℝ) / 10 :=
    hbad_union.trans <| by
      calc
        (n : ℝ) * Real.exp (-T + 2 * d) ≤
            (n : ℝ) * Real.exp (-5 * Real.log (n : ℝ)) :=
          mul_le_mul_of_nonneg_left hexp_tail hnpos.le
        _ ≤ (1 : ℝ) / 10 := hsmall
  have hgood_eq : Good = (⋃ v, Bad v)ᶜ := by
    ext G
    simp only [Good, Bad, Set.mem_compl_iff, Set.mem_iUnion, Set.mem_setOf_eq]
    constructor
    · intro hG hbad
      rcases hbad with ⟨v, hv⟩
      exact (not_le_of_gt (hG v)) hv
    · intro hG v
      exact lt_of_not_ge (fun hv => hG ⟨v, hv⟩)
  have hUmeas : MeasurableSet (⋃ v, Bad v) := by
    exact MeasurableSet.iUnion hbad_meas
  have hgoodprob : P.real Good ≥ (9 : ℝ) / 10 := by
    rw [hgood_eq, measureReal_compl hUmeas]
    have hP : P.real Set.univ = 1 := by
      simp [P]
    rw [hP]
    linarith
  simpa [P, Good, T] using hgoodprob

theorem erdosRenyiVerySparseMaxDegreeLogLogBound
    (p : ℕ → Set.Icc (0 : ℝ) 1) (C : ℝ) (hC : 0 ≤ C)
    (hbound : ∀ᶠ n in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C) :
    ∀ᶠ n in Filter.atTop,
      (erdosRenyiModel n (p n)).graphLaw.real {G |
        ∀ v : Fin n,
          ((erdosRenyiModel n (p n)).degree v G : ℝ) <
            (C + 5) * Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))} ≥
      (9 : ℝ) / 10 := by
  filter_upwards [hbound,
    Filter.eventually_atTop.2 ⟨16, fun n hn => hn⟩] with n hdn hn16
  let d : ℝ := ((n - 1 : ℕ) : ℝ) * (p n : ℝ)
  let L : ℝ := Real.log (n : ℝ)
  let LL : ℝ := Real.log L
  let T : ℝ := (C + 5) * L / LL
  let lambda : ℝ := LL
  let P : Measure (SimpleGraph (Fin n)) := (erdosRenyiModel n (p n)).graphLaw
  let Bad : Fin n → Set (SimpleGraph (Fin n)) := fun v =>
    {G | T ≤ ((erdosRenyiModel n (p n)).degree v G : ℝ)}
  let Good : Set (SimpleGraph (Fin n)) := {G |
    ∀ v : Fin n,
      ((erdosRenyiModel n (p n)).degree v G : ℝ) < T}
  have hnpos : 0 < (n : ℝ) := by
    exact_mod_cast (Nat.zero_lt_of_lt hn16)
  have hn2 : (2 : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast (show 2 ≤ n by omega)
  have hn3 : (3 : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast (show 3 ≤ n by omega)
  have hn1 : 1 ≤ n := by omega
  have hsub : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [Nat.cast_sub hn1]
    norm_num
  have hLpos : 0 < L := by
    dsimp [L]
    exact Real.log_pos (by exact_mod_cast (show 1 < n by omega))
  have hL1 : 1 < L := by
    dsimp [L]
    apply (Real.lt_log_iff_exp_lt hnpos).2
    exact lt_of_lt_of_le Real.exp_one_lt_three hn3
  have hLLpos : 0 < LL := by
    dsimp [LL]
    exact Real.log_pos hL1
  have hLLne : LL ≠ 0 := ne_of_gt hLLpos
  have hlam : 0 < lambda := by simpa [lambda] using hLLpos
  have hdn' : d ≤ C := by
    simpa [d] using hdn
  have hexpLambda : Real.exp lambda = L := by
    dsimp [lambda]
    rw [Real.exp_log hLpos]
  have hLLne' : Real.log (Real.log (n : ℝ)) ≠ 0 := by
    simpa [LL, L] using hLLne
  have hlambdaT : lambda * T = (C + 5) * L := by
    dsimp [lambda, T]
    field_simp [hLLne']
  have hdnonneg : 0 ≤ d := by
    dsimp [d]
    exact mul_nonneg (Nat.cast_nonneg _) (p n).2.1
  have hmul : (L - 1) * d ≤ (L - 1) * C := by
    apply mul_le_mul_of_nonneg_left hdn'
    linarith
  have hstep : (L - 1) * C ≤ L * C := by
    nlinarith [hC]
  have htail : -lambda * T + (Real.exp lambda - 1) * d ≤ -5 * L := by
    rw [show -lambda * T = -(lambda * T) by ring, hlambdaT, hexpLambda]
    nlinarith [hmul, hstep]
  have hbad_meas : ∀ v : Fin n, MeasurableSet (Bad v) := by
    intro v
    have heq : Bad v = {G |
        T ≤ (graphDegreeSum v G : ℝ)} := by
      ext G
      simp only [Bad, Set.mem_setOf_eq]
      rw [erdosRenyiModel_degree_eq_graphDegreeSum]
    rw [heq]
    have hcast : Measurable (fun k : ℕ => (k : ℝ)) := measurable_of_countable _
    have hmeas : Measurable (fun G : SimpleGraph (Fin n) =>
        (graphDegreeSum v G : ℝ)) := by
      exact hcast.comp (measurable_graphDegreeSum v)
    exact hmeas (measurableSet_Ici)
  have hbad_each : ∀ v : Fin n, P.real (Bad v) ≤
      Real.exp (-lambda * T + (Real.exp lambda - 1) * d) := by
    intro v
    dsimp [P, Bad, T, lambda, d, L, LL]
    simpa [hsub] using (erdosRenyiDegreeUpperBoundAt n (p n) v
      (t := (C + 5) * Real.log (n : ℝ) / Real.log (Real.log (n : ℝ)))
      (lam := Real.log (Real.log (n : ℝ))) hlam)
  have hbad_union : P.real (⋃ v, Bad v) ≤
      (n : ℝ) * Real.exp (-lambda * T + (Real.exp lambda - 1) * d) := by
    calc
      P.real (⋃ v, Bad v) ≤ ∑ v, P.real (Bad v) :=
        measureReal_iUnion_fintype_le (μ := P) Bad
      _ ≤ ∑ _v : Fin n,
          Real.exp (-lambda * T + (Real.exp lambda - 1) * d) := by
        exact Finset.sum_le_sum (fun v _ => hbad_each v)
      _ = (n : ℝ) * Real.exp (-lambda * T +
          (Real.exp lambda - 1) * d) := by
        simp
  have hexp_tail : Real.exp (-lambda * T + (Real.exp lambda - 1) * d) ≤
      Real.exp (-5 * L) := by
    exact Real.exp_le_exp.2 htail
  have hpow : Real.exp (5 * L) = (n : ℝ) ^ 5 := by
    dsimp [L]
    calc
      Real.exp (5 * Real.log (n : ℝ)) =
          Real.exp (Real.log (n : ℝ)) ^ 5 := by
        convert Real.exp_nat_mul (Real.log (n : ℝ)) 5 using 1
      _ = (n : ℝ) ^ 5 := by rw [Real.exp_log hnpos]
  have hexp5 : Real.exp (-5 * L) = ((n : ℝ) ^ 5)⁻¹ := by
    rw [show -5 * L = -(5 * L) by ring, Real.exp_neg, hpow]
  have hpow4 : (2 : ℝ) ^ 4 ≤ (n : ℝ) ^ 4 :=
    pow_le_pow_left₀ (by norm_num) hn2 4
  have hpow4' : (16 : ℝ) ≤ (n : ℝ) ^ 4 := by
    norm_num at hpow4 ⊢
    exact hpow4
  have hten : 10 * (n : ℝ) ≤ (n : ℝ) ^ 5 := by
    have hmul' := mul_le_mul_of_nonneg_left hpow4' hnpos.le
    calc
      10 * (n : ℝ) ≤ 16 * (n : ℝ) := by nlinarith
      _ ≤ (n : ℝ) * (n : ℝ) ^ 4 := by simpa [mul_comm] using hmul'
      _ = (n : ℝ) ^ 5 := by ring
  have hsmall : (n : ℝ) * Real.exp (-5 * L) ≤ (1 : ℝ) / 10 := by
    have hpowpos : 0 < (n : ℝ) ^ 5 := by positivity
    have hdiv : (n : ℝ) / (n : ℝ) ^ 5 ≤ (1 : ℝ) / 10 := by
      rw [div_le_iff₀ hpowpos]
      nlinarith [hten]
    rw [hexp5]
    simpa [div_eq_mul_inv] using hdiv
  have hbad_small : P.real (⋃ v, Bad v) ≤ (1 : ℝ) / 10 :=
    hbad_union.trans <| by
      calc
        (n : ℝ) * Real.exp (-lambda * T + (Real.exp lambda - 1) * d) ≤
            (n : ℝ) * Real.exp (-5 * L) :=
          mul_le_mul_of_nonneg_left hexp_tail hnpos.le
        _ ≤ (1 : ℝ) / 10 := hsmall
  have hgood_eq : Good = (⋃ v, Bad v)ᶜ := by
    ext G
    simp only [Good, Bad, Set.mem_compl_iff, Set.mem_iUnion, Set.mem_setOf_eq]
    constructor
    · intro hG hbad
      rcases hbad with ⟨v, hv⟩
      exact (not_le_of_gt (hG v)) hv
    · intro hG v
      exact lt_of_not_ge (fun hv => hG ⟨v, hv⟩)
  have hUmeas : MeasurableSet (⋃ v, Bad v) := by
    exact MeasurableSet.iUnion hbad_meas
  have hgoodprob : P.real Good ≥ (9 : ℝ) / 10 := by
    rw [hgood_eq, measureReal_compl hUmeas]
    have hP : P.real Set.univ = 1 := by
      simp [P]
    rw [hP]
    linarith
  simpa [P, Good, T, L, LL] using hgoodprob

end NumStability.HDP.Scalar.IndependentSums.Chernoff

namespace NumStability.HDP.Contract

theorem hdp_02_hlem_hpoisson_hadd
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℕ} {r s : ℝ≥0}
    (hX : HasLaw X (ProbabilityTheory.poissonMeasure r) μ)
    (hY : HasLaw Y (ProbabilityTheory.poissonMeasure s) μ)
    (hXY : X ⟂ᵢ[μ] Y) :
    HasLaw (X + Y) (ProbabilityTheory.poissonMeasure (r + s)) μ :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonAddLaw hX hY hXY

theorem hdp_02_hrem_h2_d3_d4 (rate : ℝ≥0) (hrate : 0 < rate) :
    (fun k : ℕ => ProbabilityTheory.poissonPMFReal rate k) ~[Filter.atTop]
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) *
          (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k /
            Real.sqrt (2 * (k : ℝ) * Real.pi)) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonPointMass_isEquivalent_stirling
    rate hrate

theorem hdp_02_hthm_h2_d3_d1
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ}
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp (Real.log (t / (∑ i, (p i : ℝ))) *
        (if B i ω then 1 else 0))) μ)
    (ht : ∑ i, (p i : ℝ) < t)
    (hμ : 0 < ∑ i, (p i : ℝ))
    (hExpS : Integrable
      (fun ω => Real.exp (Real.log (t / (∑ i, (p i : ℝ))) *
        ∑ i, (if B i ω then 1 else 0))) μ) :
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomialChernoffBound
    hp hB hLaw hMeas hExp ht hμ hExpS

theorem hdp_02_hex_h2_d3_d2
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ}
    (hExp : ∀ i, Integrable
      (fun ω => Real.exp ((-Real.log ((∑ i, (p i : ℝ)) / t)) *
        (if B i ω then 1 else 0))) μ)
    (ht : 0 < t)
    (htμ : t < ∑ i, (p i : ℝ))
    (hExpS : Integrable
      (fun ω => Real.exp (Real.log ((∑ i, (p i : ℝ)) / t) *
        (-∑ i, (if B i ω then 1 else 0)))) μ) :
    μ.real {ω | ∑ i, (if B i ω then 1 else 0) ≤ t} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomialLowerChernoffBound
    hp hB hLaw hMeas hExp ht htμ hExpS

theorem hdp_02_hlem_hbernoulli_hmgf_hbound :
    NumStability.HDP.Scalar.IndependentSums.Chernoff.BernoulliMgfModelData :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.bernoulliMgfModel

theorem hdp_02_hlem_hbernoulli_hmgf_hbound_scalar
    (p : ℝ≥0) (hp : p ≤ 1) (lam : ℝ) :
    ((∫ b : Bool, Real.exp (lam * (if b then 1 else 0)) ∂
        (PMF.bernoulli p hp).toMeasure) =
        1 + (Real.exp lam - 1) * (p : ℝ)) ∧
      (1 + (Real.exp lam - 1) * (p : ℝ) ≤
        Real.exp ((Real.exp lam - 1) * (p : ℝ))) :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.bernoulliMgfBound p hp lam

theorem hdp_02_hlem_her_hdegree_hlaw
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n) :
    HasLaw ((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).degree v)
      (NumStability.HDP.Scalar.IndependentSums.Chernoff.graphBinomialLaw n p)
      (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).graphLaw :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiDegreeLaw n p v

theorem hdp_02_hprop_h2_d4_d1
    (n : ℕ) (hn : 2 ≤ n) (p : Set.Icc (0 : ℝ) 1)
    (hd : 4000 * Real.log (n : ℝ) ≤ (n - 1) * (p : ℝ)) :
    (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).graphLaw.real
        {G |
          ∀ v : Fin n,
            |((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).degree v G : ℝ) -
                (n - 1) * (p : ℝ)| <
              ((n - 1) * (p : ℝ)) / 10} ≥ (9 : ℝ) / 10 :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiAlmostRegular n hn p hd

theorem hdp_02_hex_h2_d4_d2
    (p : ℕ → Set.Icc (0 : ℝ) 1) (C : ℝ) (hC : 0 ≤ C)
    (hbound : ∀ᶠ n in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C * Real.log (n : ℝ)) :
    ∀ᶠ n in Filter.atTop,
      (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n (p n)).graphLaw.real
        {G |
          ∀ v : Fin n,
            ((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n (p n)).degree v G : ℝ) <
              (2 * C + 5) * Real.log (n : ℝ)} ≥ (9 : ℝ) / 10 :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiSparseMaxDegreeLogBound
    p C hC hbound

theorem hdp_02_hex_h2_d4_d3
    (p : ℕ → Set.Icc (0 : ℝ) 1) (C : ℝ) (hC : 0 ≤ C)
    (hbound : ∀ᶠ n in Filter.atTop,
      ((n - 1 : ℕ) : ℝ) * (p n : ℝ) ≤ C) :
    ∀ᶠ n in Filter.atTop,
      (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n (p n)).graphLaw.real
        {G |
          ∀ v : Fin n,
            ((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n (p n)).degree v G : ℝ) <
              (C + 5) * Real.log (n : ℝ) / Real.log (Real.log (n : ℝ))} ≥
        (9 : ℝ) / 10 :=
  NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiVerySparseMaxDegreeLogLogBound
    p C hC hbound

end NumStability.HDP.Contract
```

### `ComputationalMathematics.HDP.Scalar.IndependentSums.PoissonChernoff`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/IndependentSums/PoissonChernoff.lean`
SHA-256: `d1a21067b528cb5f0e4de2f412834b2619119f3f8130df274fe12f4b62ba27df`

```lean
import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-! Chernoff foundations for the Poisson law. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Scalar.IndependentSums.PoissonChernoff

lemma poissonMeasureReal_singleton (rate : ℝ≥0) (n : ℕ) :
    (ProbabilityTheory.poissonMeasure rate).real {n} =
      ProbabilityTheory.poissonPMFReal rate n := by
  rw [Measure.real_def, ProbabilityTheory.poissonMeasure,
    PMF.toMeasure_apply_singleton _ n (measurableSet_singleton n)]
  rw [ProbabilityTheory.poissonPMF]
  exact ENNReal.toReal_ofReal ProbabilityTheory.poissonPMFReal_nonneg

theorem integrable_exp_nat_poisson (rate : ℝ≥0) (s : ℝ) :
    Integrable (fun n : ℕ => Real.exp (s * (n : ℝ)))
      (ProbabilityTheory.poissonMeasure rate) := by
  let f : ℕ → ℝ := fun n => Real.exp (s * (n : ℝ))
  have hsingle : ∀ n : ℕ, IntegrableOn f {n}
      (ProbabilityTheory.poissonMeasure rate) := by
    intro n
    exact integrableOn_singleton
  have hseries : Summable (fun n : ℕ =>
      Real.exp (-(rate : ℝ)) *
        (((rate : ℝ) * Real.exp s) ^ n / (Nat.factorial n : ℝ))) := by
    exact Summable.mul_left _
      (NormedSpace.expSeries_div_hasSum_exp ((rate : ℝ) * Real.exp s)).summable
  have hnorm : Summable (fun n : ℕ =>
      ∫ x : ℕ in ({n} : Set ℕ), ‖f x‖ ∂
        (ProbabilityTheory.poissonMeasure rate)) := by
    apply hseries.congr
    intro n
    rw [integral_singleton, poissonMeasureReal_singleton]
    simp only [smul_eq_mul, f, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    rw [ProbabilityTheory.poissonPMFReal]
    have hexp : Real.exp (s * (n : ℝ)) = Real.exp s ^ n := by
      rw [mul_comm, Real.exp_nat_mul]
    rw [hexp, mul_pow]
    ring
  have hunion : (⋃ n : ℕ, ({n} : Set ℕ)) = Set.univ := by
    ext n
    simp
  have h := integrableOn_iUnion_of_summable_integral_norm hsingle hnorm
  simpa [hunion, integrableOn_univ, f] using h

/-- The exact moment-generating function of a Poisson random variable. -/
theorem poissonMgfExact (rate : ℝ≥0) (s : ℝ) :
    (∫ n : ℕ, Real.exp (s * (n : ℝ)) ∂
        (ProbabilityTheory.poissonMeasure rate)) =
      Real.exp ((rate : ℝ) * (Real.exp s - 1)) := by
  rw [ProbabilityTheory.poissonMeasure]
  rw [PMF.integral_eq_tsum _ _ (integrable_exp_nat_poisson rate s)]
  simp_rw [smul_eq_mul]
  have hpmf (n : ℕ) :
      ((ProbabilityTheory.poissonPMF rate) n).toReal =
        ProbabilityTheory.poissonPMFReal rate n := by
    rw [ProbabilityTheory.poissonPMF]
    exact ENNReal.toReal_ofReal ProbabilityTheory.poissonPMFReal_nonneg
  simp_rw [hpmf]
  have hterm (n : ℕ) :
      ProbabilityTheory.poissonPMFReal rate n * Real.exp (s * (n : ℝ)) =
        Real.exp (-(rate : ℝ)) *
          (((rate : ℝ) * Real.exp s) ^ n / (Nat.factorial n : ℝ)) := by
    rw [ProbabilityTheory.poissonPMFReal]
    have hexp : Real.exp (s * (n : ℝ)) = Real.exp s ^ n := by
      rw [mul_comm, Real.exp_nat_mul]
    rw [hexp, mul_pow]
    ring
  calc
    (∑' n : ℕ, ProbabilityTheory.poissonPMFReal rate n *
        Real.exp (s * (n : ℝ))) =
        ∑' n : ℕ, Real.exp (-(rate : ℝ)) *
          (((rate : ℝ) * Real.exp s) ^ n / (Nat.factorial n : ℝ)) :=
      tsum_congr hterm
    _ = Real.exp (-(rate : ℝ)) *
        ∑' n : ℕ, (((rate : ℝ) * Real.exp s) ^ n /
          (Nat.factorial n : ℝ)) := tsum_mul_left
    _ = Real.exp (-(rate : ℝ)) *
        Real.exp ((rate : ℝ) * Real.exp s) := by
      congr 1
      exact
        (NormedSpace.expSeries_div_hasSum_exp
          ((rate : ℝ) * Real.exp s)).tsum_eq.trans
          (congr_fun Real.exp_eq_exp_ℝ ((rate : ℝ) * Real.exp s)).symm
    _ = Real.exp ((rate : ℝ) * (Real.exp s - 1)) := by
      rw [← Real.exp_add]
      congr 1
      ring

/-- Chernoff's upper-tail bound for a Poisson random variable. -/
theorem poissonChernoffUpper
    (rate : ℝ≥0) {t : ℝ} (ht : (rate : ℝ) < t) :
    (ProbabilityTheory.poissonMeasure rate).real {n : ℕ | t ≤ (n : ℝ)} ≤
      Real.exp (-(rate : ℝ)) *
        ((Real.exp 1 * (rate : ℝ) / t) ^ t) := by
  have ht0 : 0 < t := lt_of_le_of_lt (NNReal.coe_nonneg rate) ht
  by_cases hr0 : rate = 0
  · subst rate
    have hsub : {n : ℕ | t ≤ (n : ℝ)} ⊆ ({0} : Set ℕ)ᶜ := by
      intro n hn hn0
      simp only [Set.mem_singleton_iff] at hn0
      subst n
      norm_num at hn
      linarith
    have hmass0 :
        (ProbabilityTheory.poissonMeasure (0 : ℝ≥0)).real ({0} : Set ℕ) = 1 := by
      simpa [ProbabilityTheory.poissonPMFReal] using
        poissonMeasureReal_singleton (0 : ℝ≥0) 0
    have hcomp :
        (ProbabilityTheory.poissonMeasure (0 : ℝ≥0)).real ({0} : Set ℕ)ᶜ = 0 := by
      rw [probReal_compl_eq_one_sub (measurableSet_singleton 0), hmass0]
      norm_num
    have hevent :
        (ProbabilityTheory.poissonMeasure (0 : ℝ≥0)).real
          {n : ℕ | t ≤ (n : ℝ)} = 0 := by
      apply le_antisymm
      · exact (measureReal_mono hsub).trans_eq hcomp
      · positivity
    rw [hevent]
    positivity
  have hr : 0 < (rate : ℝ) := lt_of_le_of_ne (NNReal.coe_nonneg rate)
    (by exact_mod_cast Ne.symm hr0)
  let s : ℝ := Real.log (t / (rate : ℝ))
  have hs : 0 < s := by
    dsimp [s]
    apply Real.log_pos
    rw [one_lt_div hr]
    exact ht
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := ProbabilityTheory.poissonMeasure rate)
      (S := fun n : ℕ => (n : ℝ)) (lam := s) (t := t)
      (measurable_of_countable _) hs (integrable_exp_nat_poisson rate s)
  calc
    (ProbabilityTheory.poissonMeasure rate).real {n : ℕ | t ≤ (n : ℝ)} ≤
        Real.exp (-(s * t)) *
          (∫ n : ℕ, Real.exp (s * (n : ℝ)) ∂
            (ProbabilityTheory.poissonMeasure rate)) := by
      exact hmarkov
    _ = Real.exp (-(s * t)) *
        Real.exp ((rate : ℝ) * (Real.exp s - 1)) := by
      rw [poissonMgfExact]
    _ = Real.exp (-(rate : ℝ)) *
        ((Real.exp 1 * (rate : ℝ) / t) ^ t) := by
      have hratio : 0 < t / (rate : ℝ) := div_pos ht0 hr
      have hbase : 0 < Real.exp 1 * (rate : ℝ) / t :=
        div_pos (mul_pos (Real.exp_pos _) hr) ht0
      dsimp [s]
      rw [Real.exp_log hratio]
      rw [Real.rpow_def_of_pos hbase]
      rw [Real.log_div (mul_ne_zero (ne_of_gt (Real.exp_pos (1 : ℝ)))
        (ne_of_gt hr)) (ne_of_gt ht0)]
      rw [Real.log_mul (ne_of_gt (Real.exp_pos (1 : ℝ))) (ne_of_gt hr)]
      rw [Real.log_exp]
      rw [← Real.exp_add]
      rw [← Real.exp_add]
      congr 1
      rw [Real.log_div (ne_of_gt ht0) (ne_of_gt hr)]
      field_simp
      ring

private lemma exp_add_half_le (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := δ / 2) (by
    calc
      |δ / 2| = δ / 2 := abs_of_nonneg (by positivity)
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (δ / 2) - 1 - δ / 2 ≤ (δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

private lemma exp_neg_half_le (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ ≤ 1) :
    Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 := by
  have hrem := Real.abs_exp_sub_one_sub_id_le (x := -δ / 2) (by
    calc
      |-δ / 2| = δ / 2 := by
        rw [abs_of_nonpos (by linarith)]
        ring
      _ ≤ 1 := by linarith)
  have hrem' : Real.exp (-δ / 2) - 1 - (-δ / 2) ≤ (-δ / 2) ^ 2 :=
    (le_abs_self _).trans hrem
  linarith

/-- A two-sided quadratic concentration bound for a Poisson law, with the
explicit universal constant `1 / 4`. -/
theorem poissonTwoSidedQuadraticBound
    (rate : ℝ≥0) {δ : ℝ} (hδ0 : 0 < δ) (hδ1 : δ ≤ 1) :
    (ProbabilityTheory.poissonMeasure rate).real
        {n : ℕ | δ * (rate : ℝ) ≤ |(n : ℝ) - (rate : ℝ)|} ≤
      2 * Real.exp (-(rate : ℝ) * δ ^ 2 / 4) := by
  let m : ℝ := rate
  have hm : 0 ≤ m := by positivity
  have hupper_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := ProbabilityTheory.poissonMeasure rate)
      (S := fun n : ℕ => (n : ℝ)) (lam := δ / 2) (t := (1 + δ) * m)
      (measurable_of_countable _) (by linarith)
      (integrable_exp_nat_poisson rate (δ / 2))
  have hlower_markov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (μ := ProbabilityTheory.poissonMeasure rate)
      (S := fun n : ℕ => -(n : ℝ)) (lam := δ / 2) (t := -(1 - δ) * m)
      (measurable_of_countable _) (by linarith)
      (by
        convert integrable_exp_nat_poisson rate (-δ / 2) using 1
        ext n
        congr 1
        ring)
  have hupper_exp : Real.exp (δ / 2) ≤ 1 + δ / 2 + (δ / 2) ^ 2 :=
    exp_add_half_le δ hδ0.le hδ1
  have hlower_exp : Real.exp (-δ / 2) ≤ 1 - δ / 2 + (δ / 2) ^ 2 :=
    exp_neg_half_le δ hδ0.le hδ1
  have hupper_coeff :
      -(δ / 2 * ((1 + δ) * m)) + (Real.exp (δ / 2) - 1) * m ≤
        -(m * δ ^ 2 / 4) := by
    have hcoeff :
        -(δ / 2 * (1 + δ)) + (Real.exp (δ / 2) - 1) ≤
          -(δ ^ 2 / 4) := by
      nlinarith [hupper_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hlower_coeff :
      -(δ / 2 * (-(1 - δ) * m)) + (Real.exp (-δ / 2) - 1) * m ≤
        -(m * δ ^ 2 / 4) := by
    have hcoeff :
        (δ / 2) * (1 - δ) + (Real.exp (-δ / 2) - 1) ≤
          -(δ ^ 2 / 4) := by
      nlinarith [hlower_exp]
    have := mul_le_mul_of_nonneg_right hcoeff hm
    nlinarith
  have hupper_raw :
      (ProbabilityTheory.poissonMeasure rate).real
          ((fun n : ℕ => (n : ℝ)) ⁻¹' Set.Ici ((1 + δ) * m)) ≤
        Real.exp (-(δ / 2 * ((1 + δ) * m))) *
          Real.exp ((Real.exp (δ / 2) - 1) * m) := by
    refine hupper_markov.trans_eq ?_
    rw [poissonMgfExact]
    congr 2
    dsimp [m]
    ring
  have hlower_raw :
      (ProbabilityTheory.poissonMeasure rate).real
          ((fun n : ℕ => -(n : ℝ)) ⁻¹' Set.Ici (-(1 - δ) * m)) ≤
        Real.exp (-(δ / 2 * (-(1 - δ) * m))) *
          Real.exp ((Real.exp (-δ / 2) - 1) * m) := by
    refine hlower_markov.trans_eq ?_
    have hint :
        (∫ n : ℕ, Real.exp (δ / 2 * -(n : ℝ)) ∂
            (ProbabilityTheory.poissonMeasure rate)) =
          Real.exp ((rate : ℝ) * (Real.exp (-δ / 2) - 1)) := by
      have hfun : (fun n : ℕ => Real.exp (δ / 2 * -(n : ℝ))) =
          (fun n : ℕ => Real.exp ((-δ / 2) * (n : ℝ))) := by
        funext n
        congr 1
        ring
      rw [hfun, poissonMgfExact]
    rw [hint]
    congr 2
    dsimp [m]
    ring
  have hupper :
      (ProbabilityTheory.poissonMeasure rate).real
          {n : ℕ | (1 + δ) * m ≤ (n : ℝ)} ≤
        Real.exp (-(m * δ ^ 2 / 4)) := by
    refine hupper_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hupper_coeff
  have hlower :
      (ProbabilityTheory.poissonMeasure rate).real
          {n : ℕ | (n : ℝ) ≤ (1 - δ) * m} ≤
        Real.exp (-(m * δ ^ 2 / 4)) := by
    have hset : {n : ℕ | (n : ℝ) ≤ (1 - δ) * m} =
        (fun n : ℕ => -(n : ℝ)) ⁻¹' Set.Ici (-(1 - δ) * m) := by
      ext n
      simp only [Set.mem_setOf_eq, Set.mem_preimage, Set.mem_Ici]
      constructor <;> intro h <;> linarith
    rw [hset]
    refine hlower_raw.trans ?_
    rw [← Real.exp_add]
    exact Real.exp_le_exp.2 hlower_coeff
  let U : Set ℕ := {n | (1 + δ) * m ≤ (n : ℝ)}
  let L : Set ℕ := {n | (n : ℝ) ≤ (1 - δ) * m}
  have hsubset : {n : ℕ | δ * m ≤ |(n : ℝ) - m|} ⊆ U ∪ L := by
    intro n hn
    by_cases hu : (1 + δ) * m ≤ (n : ℝ)
    · exact Or.inl hu
    · right
      have hnotupper : (n : ℝ) < (1 + δ) * m := lt_of_not_ge hu
      by_contra hnotlower
      have hlower' : (1 - δ) * m < (n : ℝ) := lt_of_not_ge hnotlower
      have habs : |(n : ℝ) - m| < δ * m := by
        rw [abs_lt]
        constructor <;> linarith
      exact (not_lt_of_ge hn) habs
  have hmono {A B : Set ℕ} (hAB : A ⊆ B) :
      (ProbabilityTheory.poissonMeasure rate).real A ≤
        (ProbabilityTheory.poissonMeasure rate).real B := by
    exact measureReal_mono hAB
  have hunion :
      (ProbabilityTheory.poissonMeasure rate).real (U ∪ L) ≤
        (ProbabilityTheory.poissonMeasure rate).real U +
          (ProbabilityTheory.poissonMeasure rate).real L := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      ((ProbabilityTheory.poissonMeasure rate) (U ∪ L)).toReal ≤
          ((ProbabilityTheory.poissonMeasure rate) U +
            (ProbabilityTheory.poissonMeasure rate) L).toReal := by
        apply ENNReal.toReal_mono
        · exact ENNReal.add_ne_top.mpr
            ⟨measure_ne_top _ U, measure_ne_top _ L⟩
        · exact measure_union_le U L
      _ = ((ProbabilityTheory.poissonMeasure rate) U).toReal +
          ((ProbabilityTheory.poissonMeasure rate) L).toReal :=
        ENNReal.toReal_add (measure_ne_top _ U) (measure_ne_top _ L)
  calc
    (ProbabilityTheory.poissonMeasure rate).real
        {n : ℕ | δ * (rate : ℝ) ≤ |(n : ℝ) - (rate : ℝ)|} ≤
        (ProbabilityTheory.poissonMeasure rate).real (U ∪ L) := by
      simpa [m] using hmono hsubset
    _ ≤ (ProbabilityTheory.poissonMeasure rate).real U +
        (ProbabilityTheory.poissonMeasure rate).real L := hunion
    _ ≤ Real.exp (-(m * δ ^ 2 / 4)) + Real.exp (-(m * δ ^ 2 / 4)) :=
      add_le_add (by simpa [U] using hupper) (by simpa [L] using hlower)
    _ = 2 * Real.exp (-(rate : ℝ) * δ ^ 2 / 4) := by
      dsimp [m]
      ring

/-! Exact foundations for the endpoint and sharpness discussion in Remark 2.3.4. -/

/-- The Stirling equivalent for a Poisson point mass also holds at rate zero.
At that endpoint both sides vanish eventually. -/
theorem poissonPointMass_isEquivalent_stirling_all (rate : ℝ≥0) :
    Asymptotics.IsEquivalent Filter.atTop
      (fun k : ℕ => ProbabilityTheory.poissonPMFReal rate k)
      (fun k : ℕ =>
        Real.exp (-(rate : ℝ)) *
          (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k /
            Real.sqrt (2 * (k : ℝ) * Real.pi)) := by
  rcases eq_or_lt_of_le (zero_le rate) with hrate | hrate
  · subst rate
    have hleft : (fun _ : ℕ => (0 : ℝ)) =ᶠ[Filter.atTop]
        (fun k : ℕ => ProbabilityTheory.poissonPMFReal (0 : ℝ≥0) k) := by
      filter_upwards [Filter.eventually_atTop.2
        ⟨1, fun _ hk => hk⟩] with k hk
      have hk0 : k ≠ 0 := Nat.ne_of_gt (lt_of_lt_of_le Nat.zero_lt_one hk)
      simp [ProbabilityTheory.poissonPMFReal, hk0]
    have hright : (fun _ : ℕ => (0 : ℝ)) =ᶠ[Filter.atTop]
        (fun k : ℕ =>
          Real.exp (-((0 : ℝ≥0) : ℝ)) *
            (Real.exp 1 * ((0 : ℝ≥0) : ℝ) / (k : ℝ)) ^ k /
              Real.sqrt (2 * (k : ℝ) * Real.pi)) := by
      filter_upwards [Filter.eventually_atTop.2
        ⟨1, fun _ hk => hk⟩] with k hk
      have hk0 : k ≠ 0 := Nat.ne_of_gt (lt_of_lt_of_le Nat.zero_lt_one hk)
      simp [hk0]
    exact (Asymptotics.IsEquivalent.refl.congr_left hleft).congr_right hright
  · exact
      NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonPointMass_isEquivalent_stirling
        rate hrate

/-- A Poisson upper tail contains its first point mass and is bounded by the
matching Chernoff profile.  Together with Stirling's formula this is the exact
tail-versus-point comparison used to justify sharpness up to a square-root
factor. -/
theorem poissonPointMass_le_upperTail_le_chernoffProfile
    (rate : ℝ≥0) {k : ℕ} (hk : (rate : ℝ) < (k : ℝ)) :
    ProbabilityTheory.poissonPMFReal rate k ≤
        (ProbabilityTheory.poissonMeasure rate).real
          {n : ℕ | (k : ℝ) ≤ (n : ℝ)} ∧
      (ProbabilityTheory.poissonMeasure rate).real
          {n : ℕ | (k : ℝ) ≤ (n : ℝ)} ≤
        Real.exp (-(rate : ℝ)) *
          (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k := by
  constructor
  · rw [← poissonMeasureReal_singleton]
    apply measureReal_mono
    intro n hn
    have hn' : n = k := by
      simpa only [Set.mem_singleton_iff] using hn
    subst n
    change (k : ℝ) ≤ (k : ℝ)
    exact le_rfl
    · exact measure_ne_top _ _
  · simpa only [Real.rpow_natCast] using
      poissonChernoffUpper rate (t := (k : ℝ)) hk

end NumStability.HDP.Scalar.IndependentSums.PoissonChernoff
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

### `ComputationalMathematics.HDP.Scalar.CentralLimit`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/CentralLimit.lean`
SHA-256: `0aa8ba3639ef975843b3ec70143a405265052201e0659e1f8e6e0f28440a9c1e`

```lean
import ComputationalMathematics.HDP.Scalar.LimitTheorems
import Mathlib.Analysis.Calculus.Taylor
import Mathlib.MeasureTheory.Measure.CharacteristicFunction
import Mathlib.MeasureTheory.Measure.Prokhorov
import Mathlib.MeasureTheory.Measure.TightNormed
import Mathlib.Probability.Independence.CharacteristicFunction

/-!
# Characteristic-function foundations for scalar limit theorems

Reusable bridge lemmas for the Chapter 1 central-limit and Poisson-limit
targets. This module is deliberately separate from `LimitTheorems` so later
CLT work does not invalidate completed audits of the earlier source contracts.
-/

noncomputable section

open MeasureTheory Filter Set Function

open scoped Topology

namespace NumStability.HDP.Scalar.LimitTheorems

/-- The characteristic function of a pushforward probability law is the
expectation of the usual complex exponential of the original random variable. -/
theorem charFun_probabilityLaw
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : AEMeasurable X μ) (t : ℝ) :
    MeasureTheory.charFun (probabilityLaw X hX : Measure ℝ) t =
      ∫ ω, Complex.exp (t * X ω * Complex.I) ∂μ := by
  rw [MeasureTheory.charFun_apply_real]
  change (∫ x : ℝ, Complex.exp (t * x * Complex.I) ∂Measure.map X μ) = _
  rw [MeasureTheory.integral_map hX (by fun_prop)]

/-- The characteristic function of the standard normal law is
`t ↦ exp (-t² / 2)`. -/
theorem standardNormalLaw_charFun (t : ℝ) :
    MeasureTheory.charFun standardNormalLaw t =
      Complex.exp (-(t : ℂ) ^ 2 / 2) := by
  rw [standardNormalLaw, ProbabilityTheory.charFun_gaussianReal]
  congr 1
  push_cast
  ring

/-- A global quadratic domination for the second-order remainder of the
imaginary-axis complex exponential. This is the integrable bound needed for
the finite-variance dominated-convergence step in the CLT proof. -/
theorem norm_cexp_mul_I_sub_one_sub_linear_le (y : ℝ) :
    ‖Complex.exp ((y : ℂ) * Complex.I) - 1 - (y : ℂ) * Complex.I‖ ≤
      3 * y ^ 2 := by
  by_cases hy : |y| ≤ 1
  · have hz : ‖(y : ℂ) * Complex.I‖ ≤ 1 := by
      simpa [Complex.norm_mul, Real.norm_eq_abs] using hy
    calc
      ‖Complex.exp ((y : ℂ) * Complex.I) - 1 - (y : ℂ) * Complex.I‖ ≤
          ‖(y : ℂ) * Complex.I‖ ^ 2 :=
        Complex.norm_exp_sub_one_sub_id_le hz
      _ = y ^ 2 := by simp [Real.norm_eq_abs, sq_abs]
      _ ≤ 3 * y ^ 2 := by nlinarith [sq_nonneg y]
  · have hy1 : 1 < |y| := lt_of_not_ge hy
    calc
      ‖Complex.exp ((y : ℂ) * Complex.I) - 1 - (y : ℂ) * Complex.I‖ ≤
          ‖Complex.exp ((y : ℂ) * Complex.I) - 1‖ +
            ‖(y : ℂ) * Complex.I‖ := norm_sub_le _ _
      _ ≤ (‖Complex.exp ((y : ℂ) * Complex.I)‖ + ‖(1 : ℂ)‖) +
            ‖(y : ℂ) * Complex.I‖ := by
        gcongr
        exact norm_sub_le _ _
      _ = 2 + |y| := by
        norm_num [Complex.norm_exp_ofReal_mul_I, Complex.norm_mul,
          Real.norm_eq_abs]
      _ ≤ 3 * y ^ 2 := by
        rw [← sq_abs]
        nlinarith [abs_nonneg y]

/-- After division by the square of a nonzero scale, the exponential
remainder is dominated by the square of the underlying value, independently
of the scale. This is the pointwise majorant used in the CLT Taylor step. -/
theorem norm_cexp_scaled_remainder_div_sq_le
    (u x : ℝ) (hu : u ≠ 0) :
    ‖(Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * x : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2‖ ≤
      3 * x ^ 2 := by
  have h := norm_cexp_mul_I_sub_one_sub_linear_le (u * x)
  calc
    ‖(Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * x : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2‖ =
        ‖Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * x : ℝ) : ℂ) * Complex.I‖ / |u| ^ 2 := by
      rw [norm_div, norm_pow]
      simp [Real.norm_eq_abs]
    _ ≤ (3 * (u * x) ^ 2) / |u| ^ 2 :=
      div_le_div_of_nonneg_right h (sq_nonneg |u|)
    _ = 3 * x ^ 2 := by
      rw [mul_pow, sq_abs]
      field_simp

/-- The order-two Taylor polynomial, along the real scale parameter, of the
imaginary-axis exponential used by characteristic functions. -/
theorem taylorWithinEval_cexp_mul_I_order_two (x u : ℝ) :
    taylorWithinEval
        (fun v : ℝ => Complex.exp (((v * x : ℝ) : ℂ) * Complex.I))
        2 Set.univ 0 u =
      1 + ((u * x : ℝ) : ℂ) * Complex.I -
        (((u * x) ^ 2 : ℝ) : ℂ) / 2 := by
  let c : ℂ := (x : ℂ) * Complex.I
  let f : ℝ → ℂ := fun v => Complex.exp ((v : ℂ) * c)
  have hf1 : ∀ v : ℝ,
      HasDerivAt f (Complex.exp ((v : ℂ) * c) * c) v := by
    intro v
    have hc : HasDerivAt (fun z : ℂ => z * c) c (v : ℂ) := by
      simpa only [id_eq, one_mul] using
        (hasDerivAt_id (v : ℂ)).mul_const c
    exact ((Complex.hasDerivAt_exp _).comp (v : ℂ) hc).comp_ofReal
  have hdf : deriv f = fun v : ℝ => Complex.exp ((v : ℂ) * c) * c := by
    funext v
    exact (hf1 v).deriv
  have h0 : iteratedDerivWithin 0 f Set.univ 0 = 1 := by
    simp [f]
  have h1 : iteratedDerivWithin 1 f Set.univ 0 = c := by
    rw [show 1 = 0 + 1 by norm_num, iteratedDerivWithin_succ']
    simp [derivWithin_univ, hdf]
  have h2 : iteratedDerivWithin 2 f Set.univ 0 = c * c := by
    rw [show 2 = 1 + 1 by norm_num, iteratedDerivWithin_succ']
    rw [show iteratedDerivWithin 1 (derivWithin f Set.univ) Set.univ 0 =
      derivWithin (derivWithin f Set.univ) Set.univ 0 by
        rw [show 1 = 0 + 1 by norm_num, iteratedDerivWithin_succ']
        simp]
    rw [derivWithin_univ, derivWithin_univ, hdf]
    simpa [f] using ((hf1 0).mul_const c).deriv
  have h0' : iteratedDeriv 0 f 0 = 1 := by
    rw [← iteratedDerivWithin_univ]
    exact h0
  have h1' : iteratedDeriv 1 f 0 = c := by
    rw [← iteratedDerivWithin_univ]
    exact h1
  have h2' : iteratedDeriv 2 f 0 = c * c := by
    rw [← iteratedDerivWithin_univ]
    exact h2
  have ht : taylorWithinEval f 2 Set.univ 0 u =
      1 + (u : ℂ) * c + ((u : ℂ) ^ 2 / 2) * (c * c) := by
    rw [taylor_within_apply]
    simp [Finset.sum_range_succ, h0', h1', h2']
    change 1 + algebraMap ℝ ℂ u * c +
      algebraMap ℝ ℂ (2⁻¹ * u ^ 2) * (c * c) = _
    rw [Complex.coe_algebraMap]
    push_cast
    ring
  have hfun :
      (fun v : ℝ => Complex.exp (((v * x : ℝ) : ℂ) * Complex.I)) = f := by
    funext v
    dsimp [f, c]
    congr 1
    push_cast
    ring
  rw [hfun]
  calc
    taylorWithinEval f 2 Set.univ 0 u =
        1 + (u : ℂ) * c + ((u : ℂ) ^ 2 / 2) * (c * c) := ht
    _ = 1 + ((u * x : ℝ) : ℂ) * Complex.I -
        (((u * x) ^ 2 : ℝ) : ℂ) / 2 := by
      dsimp [c]
      push_cast
      ring_nf
      rw [Complex.I_sq]
      ring

/-- The scaled characteristic-function integrand has its expected
second-order pointwise limit. The punctured neighborhood matches the quotient
appearing in dominated convergence; the value at zero is immaterial. -/
theorem tendsto_cexp_scaled_remainder_div_sq (x : ℝ) :
    Filter.Tendsto
      (fun u : ℝ =>
        (Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * x : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2)
      (𝓝[≠] 0) (𝓝 (-((x : ℂ) ^ 2) / 2)) := by
  let f : ℝ → ℂ := fun u =>
    Complex.exp (((u * x : ℝ) : ℂ) * Complex.I)
  have hf : ContDiff ℝ 2 f := by
    have hg : ContDiff ℝ 2
        (fun u : ℝ => Complex.ofRealCLM (u * x) * Complex.I) := by
      fun_prop
    simpa only [f, Function.comp_apply, Complex.ofRealCLM_apply] using
      (Complex.contDiff_exp (𝕜 := ℝ)).comp hg
  have ht := taylor_tendsto (f := f) (n := 2) (s := Set.univ)
    (x₀ := 0) convex_univ (Set.mem_univ 0) hf.contDiffOn
  rw [nhdsWithin_univ] at ht
  have hlim : Filter.Tendsto
      (fun u : ℝ => ((u - 0) ^ 2)⁻¹ •
        (f u - taylorWithinEval f 2 Set.univ 0 u) -
          ((x : ℂ) ^ 2) / 2)
      (𝓝 0) (𝓝 (-((x : ℂ) ^ 2) / 2)) := by
    simpa only [zero_sub, neg_div] using
      ht.sub_const (((x : ℂ) ^ 2) / 2)
  refine (tendsto_nhdsWithin_of_tendsto_nhds hlim).congr' ?_
  filter_upwards [self_mem_nhdsWithin] with u hu
  have hu0 : u ≠ 0 := by simpa using hu
  have huc : (u : ℂ) ≠ 0 := by exact_mod_cast hu0
  rw [taylorWithinEval_cexp_mul_I_order_two]
  dsimp [f]
  change algebraMap ℝ ℂ (((u - 0) ^ 2)⁻¹) *
      (Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) -
        (1 + ((u * x : ℝ) : ℂ) * Complex.I -
          (((u * x) ^ 2 : ℝ) : ℂ) / 2)) -
        ((x : ℂ) ^ 2) / 2 = _
  rw [Complex.coe_algebraMap]
  push_cast
  field_simp [huc]
  ring

/-- Dominated convergence passes the pointwise second-order exponential
remainder limit through expectation under a finite second moment. -/
theorem tendsto_integral_cexp_scaled_remainder_div_sq
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    (X : Ω → ℝ) (hX : AEMeasurable X μ)
    (hX2 : Integrable (fun ω => (X ω) ^ 2) μ) :
    Filter.Tendsto
      (fun u : ℝ => ∫ ω,
        (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * X ω : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2 ∂μ)
      (𝓝[≠] 0)
      (𝓝 (∫ ω, -((X ω : ℂ) ^ 2) / 2 ∂μ)) := by
  let F : ℝ → Ω → ℂ := fun u ω =>
    (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
      ((u * X ω : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2
  refine tendsto_integral_filter_of_dominated_convergence
    (F := F) (f := fun ω => -((X ω : ℂ) ^ 2) / 2)
    (fun ω => 3 * (X ω) ^ 2) ?_ ?_ ?_ ?_
  · filter_upwards [self_mem_nhdsWithin] with u hu
    have hu0 : u ≠ 0 := by simpa using hu
    have hmeas : AEMeasurable (F u) μ := by
      dsimp [F]
      fun_prop
    exact hmeas.aestronglyMeasurable
  · filter_upwards [self_mem_nhdsWithin] with u hu
    have hu0 : u ≠ 0 := by simpa using hu
    exact ae_of_all μ fun ω =>
      norm_cexp_scaled_remainder_div_sq_le u (X ω) hu0
  · exact hX2.const_mul 3
  · exact ae_of_all μ fun ω =>
      tendsto_cexp_scaled_remainder_div_sq (X ω)

/-- For a centered, unit-second-moment real random variable, the
characteristic-function integral has the classical quadratic expansion at
zero. -/
theorem tendsto_centered_unitSecondMoment_charFun_remainder_div_sq
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : MemLp X 2 μ)
    (hMean : ∫ ω, X ω ∂μ = 0)
    (hSecond : ∫ ω, (X ω) ^ 2 ∂μ = 1) :
    Filter.Tendsto
      (fun u : ℝ =>
        ((∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) ∂μ) - 1) /
          (u : ℂ) ^ 2)
      (𝓝[≠] 0) (𝓝 (-(1 : ℂ) / 2)) := by
  have hDCT := tendsto_integral_cexp_scaled_remainder_div_sq
    X hX.aemeasurable hX.integrable_sq
  have hlimit :
      (∫ ω, -((X ω : ℂ) ^ 2) / 2 ∂μ) = -(1 : ℂ) / 2 := by
    calc
      (∫ ω, -((X ω : ℂ) ^ 2) / 2 ∂μ) =
          (∫ ω, -((X ω : ℂ) ^ 2) ∂μ) / (2 : ℂ) := integral_div _ _
      _ = -(∫ ω, (X ω : ℂ) ^ 2 ∂μ) / 2 := by
        rw [integral_neg]
      _ = -(1 : ℂ) / 2 := by
        have hpow : (fun ω => (X ω : ℂ) ^ 2) =
            (fun ω => (((X ω) ^ 2 : ℝ) : ℂ)) := by
          funext ω
          push_cast
          rfl
        rw [hpow]
        have hc : (∫ ω, (((X ω) ^ 2 : ℝ) : ℂ) ∂μ) =
            ((∫ ω, (X ω) ^ 2 ∂μ : ℝ) : ℂ) := integral_complex_ofReal
        rw [hc, hSecond]
        norm_num
  rw [hlimit] at hDCT
  refine hDCT.congr' ?_
  filter_upwards [self_mem_nhdsWithin] with u hu
  have hu0 : u ≠ 0 := by simpa using hu
  have hXint : Integrable X μ := hX.integrable (by norm_num)
  have hAmeas : AEMeasurable
      (fun ω => Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I)) μ := by
    fun_prop
  have hAint : Integrable
      (fun ω => Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I)) μ := by
    refine Integrable.of_bound hAmeas.aestronglyMeasurable 1 ?_
    exact ae_of_all μ fun ω => by
      simp only [Complex.norm_exp_ofReal_mul_I]
      norm_num
  have hOne : Integrable (fun _ : Ω => (1 : ℂ)) μ := integrable_const 1
  have hLin : Integrable
      (fun ω => ((u * X ω : ℝ) : ℂ) * Complex.I) μ :=
    ((hXint.const_mul u).ofReal).mul_const Complex.I
  have hLinZero :
      (∫ ω, ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) = 0 := by
    calc
      (∫ ω, ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) =
          (∫ ω, ((u * X ω : ℝ) : ℂ) ∂μ) * Complex.I :=
        integral_mul_const _ _
      _ = ((∫ ω, u * X ω ∂μ : ℝ) : ℂ) * Complex.I := by
        have hcu : (∫ ω, ((u * X ω : ℝ) : ℂ) ∂μ) =
            ((∫ ω, u * X ω ∂μ : ℝ) : ℂ) := integral_complex_ofReal
        rw [hcu]
      _ = ((u * ∫ ω, X ω ∂μ : ℝ) : ℂ) * Complex.I := by
        rw [integral_const_mul]
      _ = 0 := by rw [hMean]; simp
  have hsubA :
      (∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 ∂μ) =
        (∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) ∂μ) -
          (∫ _ : Ω, (1 : ℂ) ∂μ) := integral_sub hAint hOne
  have hsubLin :
      (∫ ω, (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1) -
        ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) =
        (∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 ∂μ) -
          (∫ ω, ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) :=
    integral_sub (hAint.sub hOne) hLin
  calc
    (∫ ω, (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
        ((u * X ω : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2 ∂μ) =
      (∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
        ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) / (u : ℂ) ^ 2 :=
      integral_div _ _
    _ = ((∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) ∂μ) - 1) /
        (u : ℂ) ^ 2 := by
      rw [hsubLin, hsubA, hLinZero]
      simp [integral_const]

/-- Pointwise convergence of the characteristic-function powers for iid
normalized sums, expressed first at the level of a single centered,
unit-second-moment law. -/
theorem tendsto_centered_unitSecondMoment_charFun_pow_sqrt
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : MemLp X 2 μ)
    (hMean : ∫ ω, X ω ∂μ = 0)
    (hSecond : ∫ ω, (X ω) ^ 2 ∂μ = 1) (t : ℝ) :
    Filter.Tendsto
      (fun n : ℕ =>
        (∫ ω, Complex.exp
          ((((t / Real.sqrt n) * X ω : ℝ) : ℂ) * Complex.I) ∂μ) ^ n)
      atTop (𝓝 (Complex.exp (-(t : ℂ) ^ 2 / 2))) := by
  by_cases ht : t = 0
  · subst t
    simp [integral_const]
  · let φ : ℝ → ℂ := fun u =>
      ∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) ∂μ
    let u : ℕ → ℝ := fun n => t / Real.sqrt n
    let g : ℕ → ℂ := fun n => φ (u n) - 1
    have hsqrt : Filter.Tendsto
        (fun n : ℕ => Real.sqrt (n : ℝ)) atTop atTop :=
      Real.tendsto_sqrt_atTop.comp tendsto_natCast_atTop_atTop
    have hu : Filter.Tendsto u atTop (𝓝 0) := by
      exact tendsto_const_nhds.div_atTop hsqrt
    have hune : ∀ᶠ n : ℕ in atTop, u n ≠ 0 := by
      filter_upwards [eventually_gt_atTop 0] with n hn
      exact div_ne_zero ht
        (Real.sqrt_ne_zero'.mpr (Nat.cast_pos.mpr hn))
    have huWithin : Filter.Tendsto u atTop (𝓝[≠] 0) :=
      tendsto_nhdsWithin_iff.mpr ⟨hu, by simpa using hune⟩
    have hquot : Filter.Tendsto
        (fun n => (φ (u n) - 1) / (u n : ℂ) ^ 2)
        atTop (𝓝 (-(1 : ℂ) / 2)) := by
      exact (tendsto_centered_unitSecondMoment_charFun_remainder_div_sq
        X hX hMean hSecond).comp huWithin
    have hscale : Filter.Tendsto
        (fun n : ℕ => (n : ℂ) * (u n : ℂ) ^ 2)
        atTop (𝓝 ((t : ℂ) ^ 2)) := by
      refine tendsto_const_nhds.congr' ?_
      filter_upwards [eventually_gt_atTop 0] with n hn
      have hsqrt_sq : (Real.sqrt (n : ℝ)) ^ 2 = (n : ℝ) :=
        Real.sq_sqrt (Nat.cast_nonneg n)
      have hsqrt_sq_c :
          (Real.sqrt (n : ℝ) : ℂ) ^ 2 = (n : ℂ) := by
        exact_mod_cast hsqrt_sq
      have hnc : (n : ℂ) ≠ 0 := by
        exact_mod_cast (Nat.ne_of_gt hn)
      dsimp [u]
      push_cast
      rw [div_pow, hsqrt_sq_c]
      field_simp [hnc]
    have hng : Filter.Tendsto (fun n : ℕ => (n : ℂ) * g n)
        atTop (𝓝 (-((t : ℂ) ^ 2) / 2)) := by
      have hprod := hquot.mul hscale
      have hprod' : Filter.Tendsto
          (fun n : ℕ => ((φ (u n) - 1) / (u n : ℂ) ^ 2) *
            ((n : ℂ) * (u n : ℂ) ^ 2))
          atTop (𝓝 (-((t : ℂ) ^ 2) / 2)) := by
        convert hprod using 1
        ring
      refine hprod'.congr' ?_
      filter_upwards [hune] with n hun
      dsimp [g]
      have hunc : (u n : ℂ) ≠ 0 := by exact_mod_cast hun
      field_simp [hunc]
    have hpow := Complex.tendsto_one_add_pow_exp_of_tendsto hng
    simpa [g, φ, u] using hpow

/-- Joint independence factors the characteristic function of a finite sum
into the product of the summands' characteristic functions. -/
theorem charFun_probabilityLaw_sum_eq_prod
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (hX : ∀ i, AEMeasurable (X i) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ) (t : ℝ) :
    MeasureTheory.charFun
        (probabilityLaw (∑ i, X i) (by fun_prop) : Measure ℝ) t =
      ∏ i, MeasureTheory.charFun
        (probabilityLaw (X i) (hX i) : Measure ℝ) t := by
  change MeasureTheory.charFun (μ.map (∑ i, X i)) t =
    ∏ i, MeasureTheory.charFun (μ.map (X i)) t
  simpa only [Finset.prod_apply] using
    congrFun (hIndep.charFun_map_sum_eq_prod hX) t

/-- Scaling a real random variable scales the argument of its characteristic
function. -/
theorem charFun_probabilityLaw_const_mul
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : AEMeasurable X μ) (a t : ℝ) :
    MeasureTheory.charFun
        (probabilityLaw (fun ω => a * X ω) (hX.const_mul a) : Measure ℝ) t =
      MeasureTheory.charFun (probabilityLaw X hX : Measure ℝ) (a * t) := by
  rw [charFun_probabilityLaw, charFun_probabilityLaw]
  congr with ω
  congr 1
  push_cast
  ring

/-- Centering a real random variable multiplies its characteristic function by
the deterministic phase corresponding to the subtracted center. -/
theorem charFun_probabilityLaw_sub_const
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : AEMeasurable X μ) (m t : ℝ) :
    MeasureTheory.charFun
        (probabilityLaw (fun ω => X ω - m) (by fun_prop) : Measure ℝ) t =
      MeasureTheory.charFun (probabilityLaw X hX : Measure ℝ) t *
        Complex.exp (-((t : ℂ) * (m : ℂ)) * Complex.I) := by
  rw [charFun_probabilityLaw, charFun_probabilityLaw]
  calc
    (∫ ω, Complex.exp ((t : ℂ) * ((X ω - m : ℝ) : ℂ) * Complex.I) ∂μ) =
        ∫ ω, Complex.exp (t * X ω * Complex.I) *
          Complex.exp (-((t : ℂ) * (m : ℂ)) * Complex.I) ∂μ := by
      apply integral_congr_ae
      filter_upwards with ω
      rw [← Complex.exp_add]
      congr 1
      push_cast
      ring
    _ = (∫ ω, Complex.exp (t * X ω * Complex.I) ∂μ) *
        Complex.exp (-((t : ℂ) * (m : ℂ)) * Complex.I) := by
      exact integral_mul_const _ _

/-- For a finite identically distributed independent family, the
characteristic function of the sum is the corresponding characteristic
function raised to the family cardinality. -/
theorem charFun_map_iid_sum_eq_pow
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (i₀ : ι)
    (hX : ∀ i, AEMeasurable (X i) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X i₀) μ μ)
    (t : ℝ) :
    MeasureTheory.charFun (μ.map (∑ i, X i)) t =
      MeasureTheory.charFun (μ.map (X i₀)) t ^ Fintype.card ι := by
  calc
    MeasureTheory.charFun (μ.map (∑ i, X i)) t =
        ∏ i, MeasureTheory.charFun (μ.map (X i)) t := by
      simpa only [Finset.prod_apply] using
        congrFun (hIndep.charFun_map_sum_eq_prod hX) t
    _ = MeasureTheory.charFun (μ.map (X i₀)) t ^ Fintype.card ι := by
      simp_rw [fun i => (hIdent i).map_eq]
      simp

/-- Exact characteristic-function formula for a finite centered and uniformly
scaled iid sum. This is the algebraic reduction used before the Taylor-limit
step in the classical characteristic-function proof of the CLT. -/
theorem charFun_map_centered_scaled_iid_sum_eq_pow
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (i₀ : ι)
    (hX : ∀ i, AEMeasurable (X i) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X i₀) μ μ)
    (m a t : ℝ) :
    MeasureTheory.charFun
        (μ.map (∑ i, fun ω => a * (X i ω - m))) t =
      (MeasureTheory.charFun (μ.map (X i₀)) (a * t) *
        Complex.exp (-(((a * t : ℝ) : ℂ) * (m : ℂ)) * Complex.I)) ^
          Fintype.card ι := by
  let Y : ι → Ω → ℝ := fun i ω => a * (X i ω - m)
  have hY : ∀ i, AEMeasurable (Y i) μ := by
    intro i
    dsimp [Y]
    fun_prop
  have hIndepY : ProbabilityTheory.iIndepFun Y μ := by
    have h := hIndep.comp (fun (_ : ι) (x : ℝ) => a * (x - m))
      (fun _ => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have hIdentY : ∀ i, ProbabilityTheory.IdentDistrib (Y i) (Y i₀) μ μ := by
    intro i
    have h := (hIdent i).comp (by fun_prop : Measurable fun x : ℝ => a * (x - m))
    simpa [Y, Function.comp_def] using h
  have hsum := charFun_map_iid_sum_eq_pow Y i₀ hY hIndepY hIdentY t
  change MeasureTheory.charFun (μ.map (∑ i, Y i)) t = _ at hsum
  rw [hsum]
  congr 1
  have hCentered : AEMeasurable (fun ω => X i₀ ω - m) μ := by fun_prop
  have hscale := charFun_probabilityLaw_const_mul
    (fun ω => X i₀ ω - m) hCentered a t
  change MeasureTheory.charFun (μ.map (Y i₀)) t =
    MeasureTheory.charFun (μ.map (fun ω => X i₀ ω - m)) (a * t) at hscale
  rw [hscale]
  exact charFun_probabilityLaw_sub_const (X i₀) (hX i₀) m (a * t)

/-- The centered, unit-variance iid normalization, indexed by `N + 1` so the
denominator is never zero. -/
noncomputable def normalizedCenteredIidSum
    {Ω : Type*} (X : ℕ → Ω → ℝ) (N : ℕ) : Ω → ℝ :=
  fun ω => (Real.sqrt (N + 1 : ℝ))⁻¹ *
    ∑ i : Fin (N + 1), X i.1 ω

/-- The iid normalization with common mean `m` and positive standard
deviation `σ`, again indexed by the first `N + 1` variables. -/
noncomputable def normalizedIidSum
    {Ω : Type*} (X : ℕ → Ω → ℝ) (m σ : ℝ) (N : ℕ) : Ω → ℝ :=
  fun ω => (σ * Real.sqrt (N + 1 : ℝ))⁻¹ *
    ∑ i : Fin (N + 1), (X i.1 ω - m)

theorem normalizedCenteredIidSum_memLp
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ) (N : ℕ) :
    MemLp (normalizedCenteredIidSum X N) 2 μ := by
  have hs : MemLp (fun ω => ∑ i : Fin (N + 1), X i.1 ω) 2 μ :=
    memLp_finset_sum Finset.univ (fun i _ => hX i.1)
  exact hs.const_mul (Real.sqrt (N + 1 : ℝ))⁻¹

theorem normalizedIidSum_memLp
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (m σ : ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) (N : ℕ) :
    MemLp (normalizedIidSum X m σ N) 2 μ := by
  have hs : MemLp
      (fun ω => ∑ i : Fin (N + 1), (X i.1 ω - m)) 2 μ :=
    memLp_finset_sum Finset.univ
      (fun i _ => (hX i.1).sub (memLp_const m))
  exact hs.const_mul (σ * Real.sqrt (N + 1 : ℝ))⁻¹

theorem integral_normalizedCenteredIidSum_eq_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = 0) (N : ℕ) :
    ∫ ω, normalizedCenteredIidSum X N ω ∂μ = 0 := by
  unfold normalizedCenteredIidSum
  rw [integral_const_mul, integral_finset_sum]
  · simp_rw [fun i : Fin (N + 1) => (hIdent i.1).integral_eq, hMean]
    simp
  · intro i _
    exact (hX i.1).integrable (by norm_num)

theorem variance_normalizedCenteredIidSum_eq_one
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = 0)
    (hSecond : ∫ ω, (X 0 ω) ^ 2 ∂μ = 1) (N : ℕ) :
    ProbabilityTheory.variance (normalizedCenteredIidSum X N) μ = 1 := by
  have hvar0 : ProbabilityTheory.variance (X 0) μ = 1 := by
    rw [ProbabilityTheory.variance_eq_integral (hX 0).aemeasurable, hMean]
    simpa using hSecond
  have hpair : Pairwise
      ((fun f g => ProbabilityTheory.IndepFun f g μ) on
        fun i : Fin (N + 1) => X i.1) := by
    intro i j hij
    exact hIndep.indepFun (Fin.val_injective.ne hij)
  have hsum := independentVarianceSum
    (fun i : Fin (N + 1) => hX i.1) hpair
  unfold normalizedCenteredIidSum
  rw [ProbabilityTheory.variance_const_mul]
  have hfun : (fun ω => ∑ i : Fin (N + 1), X i.1 ω) =
      ∑ i : Fin (N + 1), X i.1 := by
    funext ω
    simp
  rw [hfun, hsum]
  simp_rw [fun i : Fin (N + 1) => (hIdent i.1).variance_eq, hvar0]
  rw [Finset.sum_const, Finset.card_fin]
  simp only [nsmul_eq_mul, mul_one]
  have hsqrt : Real.sqrt (N + 1 : ℝ) ^ 2 = (N + 1 : ℝ) :=
    Real.sq_sqrt (by positivity)
  have hsqrt0 : Real.sqrt (N + 1 : ℝ) ≠ 0 := by positivity
  field_simp [hsqrt0]
  simpa [Nat.cast_add, Nat.cast_one] using hsqrt.symm

/-- Characteristic function of the normalized centered iid sum, expressed as
the `(N + 1)`-st power of the common one-variable characteristic function. -/
theorem charFun_probabilityLaw_normalizedCenteredIidSum
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (N : ℕ) (t : ℝ) :
    MeasureTheory.charFun
        (probabilityLaw (normalizedCenteredIidSum X N)
          (normalizedCenteredIidSum_memLp X hX N).aemeasurable : Measure ℝ) t =
      (∫ ω, Complex.exp
        (((t / Real.sqrt (N + 1 : ℝ) * X 0 ω : ℝ) : ℂ) * Complex.I) ∂μ) ^
          (N + 1) := by
  let i₀ : Fin (N + 1) := ⟨0, Nat.succ_pos N⟩
  have hIndepFin : ProbabilityTheory.iIndepFun
      (fun i : Fin (N + 1) => X i.1) μ :=
    hIndep.precomp Fin.val_injective
  have hIdentFin : ∀ i : Fin (N + 1),
      ProbabilityTheory.IdentDistrib (X i.1) (X i₀.1) μ μ := by
    intro i
    simpa [i₀] using hIdent i.1
  have hf := charFun_map_centered_scaled_iid_sum_eq_pow
    (fun i : Fin (N + 1) => X i.1) i₀
    (fun i => (hX i.1).aemeasurable) hIndepFin hIdentFin
    0 (Real.sqrt (N + 1 : ℝ))⁻¹ t
  change MeasureTheory.charFun (μ.map (normalizedCenteredIidSum X N)) t = _
  rw [show normalizedCenteredIidSum X N =
      ∑ i : Fin (N + 1),
        fun ω => (Real.sqrt (N + 1 : ℝ))⁻¹ * (X i.1 ω - 0) by
    funext ω
    simp [normalizedCenteredIidSum, Finset.mul_sum]]
  rw [hf]
  have hcf := charFun_probabilityLaw (X 0) (hX 0).aemeasurable
    ((Real.sqrt (N + 1 : ℝ))⁻¹ * t)
  change MeasureTheory.charFun (μ.map (X 0)) _ = _ at hcf
  rw [hcf]
  simp only [mul_zero, Complex.ofReal_zero, zero_mul, neg_zero,
    Complex.exp_zero, mul_one, Fintype.card_fin]
  congr 2
  funext ω
  congr 1
  push_cast
  ring

/-- Probability laws whose identity random variables are centered and have
variance uniformly bounded by one form a tight family. -/
theorem isTight_probabilityMeasure_range_of_variance_le_one
    {ι : Type*} (P : ι → ProbabilityMeasure ℝ)
    (hLp : ∀ n, MemLp (fun x : ℝ => x) 2 (P n : Measure ℝ))
    (hMean : ∀ n, ∫ x : ℝ, x ∂(P n : Measure ℝ) = 0)
    (hVar : ∀ n,
      ProbabilityTheory.variance (fun x : ℝ => x) (P n : Measure ℝ) ≤ 1) :
    IsTightMeasureSet
      {((p : ProbabilityMeasure ℝ) : Measure ℝ) | p ∈ Set.range P} := by
  rw [isTightMeasureSet_iff_exists_isCompact_measure_compl_le]
  intro ε hε
  obtain ⟨n, hn⟩ := ENNReal.exists_inv_nat_lt hε.ne'
  have hn0 : n ≠ 0 := by
    intro hnz
    subst n
    simp at hn
  have hnNat : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn0
  have hnR : (0 : ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn0
  have hnOneR : (1 : ℝ) ≤ n := by exact_mod_cast hnNat
  refine ⟨Set.Icc (-(n : ℝ)) n, isCompact_Icc, ?_⟩
  intro ν hν
  rcases hν with ⟨p, ⟨k, rfl⟩, rfl⟩
  have hcheb := ProbabilityTheory.meas_ge_le_variance_div_sq
    (hLp k) hnR
  calc
    (P k : Measure ℝ) (Set.Icc (-(n : ℝ)) n)ᶜ ≤
        (P k : Measure ℝ)
          {x | (n : ℝ) ≤ |x - ∫ y : ℝ, y ∂(P k : Measure ℝ)|} := by
      apply measure_mono
      intro x hx
      simp only [Set.mem_compl_iff, Set.mem_Icc, Set.mem_setOf_eq,
        hMean, sub_zero] at hx ⊢
      rw [not_and_or, not_le, not_le] at hx
      rcases hx with hx | hx
      · nlinarith [neg_le_abs x]
      · nlinarith [le_abs_self x]
    _ ≤ ENNReal.ofReal
        (ProbabilityTheory.variance (fun x : ℝ => x) (P k : Measure ℝ) /
          (n : ℝ) ^ 2) := hcheb
    _ ≤ ENNReal.ofReal (1 / (n : ℝ) ^ 2) := by
      apply ENNReal.ofReal_le_ofReal
      exact div_le_div_of_nonneg_right (hVar k) (sq_nonneg (n : ℝ))
    _ ≤ ENNReal.ofReal (1 / (n : ℝ)) := by
      apply ENNReal.ofReal_le_ofReal
      have hnSq : (n : ℝ) ≤ (n : ℝ) ^ 2 := by nlinarith
      exact one_div_le_one_div_of_le hnR hnSq
    _ = (n : ENNReal)⁻¹ := by
      rw [one_div, ENNReal.ofReal_inv_of_pos hnR]
      simp
    _ ≤ ε := hn.le

/-- The probability laws of the normalized centered iid sums form a tight
family. -/
theorem isTight_probabilityLaw_normalizedCenteredIidSum
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = 0)
    (hSecond : ∫ ω, (X 0 ω) ^ 2 ∂μ = 1) :
    IsTightMeasureSet {((p : ProbabilityMeasure ℝ) : Measure ℝ) |
      p ∈ Set.range (fun n => probabilityLaw (normalizedCenteredIidSum X n)
        (normalizedCenteredIidSum_memLp X hX n).aemeasurable)} := by
  let P : ℕ → ProbabilityMeasure ℝ := fun n =>
    probabilityLaw (normalizedCenteredIidSum X n)
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable
  apply isTight_probabilityMeasure_range_of_variance_le_one P
  · intro n
    change MemLp (fun x : ℝ => x) 2
      (Measure.map (normalizedCenteredIidSum X n) μ)
    rw [memLp_map_measure_iff (g := fun x : ℝ => x)
      continuous_id.aestronglyMeasurable
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable]
    simpa [Function.comp_def] using normalizedCenteredIidSum_memLp X hX n
  · intro n
    change (∫ x : ℝ, x ∂Measure.map (normalizedCenteredIidSum X n) μ) = 0
    have hiMap := integral_map
      (μ := μ) (φ := normalizedCenteredIidSum X n) (f := fun x : ℝ => x)
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable
      continuous_id.aestronglyMeasurable
    rw [hiMap]
    exact integral_normalizedCenteredIidSum_eq_zero X hX hIdent hMean n
  · intro n
    change ProbabilityTheory.variance (fun x : ℝ => x)
      (Measure.map (normalizedCenteredIidSum X n) μ) ≤ 1
    rw [ProbabilityTheory.variance_map (X := fun x : ℝ => x)
      measurable_id.aemeasurable
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable]
    simpa [Function.comp_def] using
      (variance_normalizedCenteredIidSum_eq_one
        X hX hIndep hIdent hMean hSecond n).le

/-- A tight sequence of real probability laws converges weakly when all of its
characteristic functions converge pointwise to the characteristic function of
the proposed limit law. This is the tightness-assisted form of Lévy's
continuity theorem needed by the finite-variance CLT. -/
theorem tendsto_probabilityMeasure_of_charFun_tendsto_of_tight
    {ι : Type*} [Preorder ι] [IsDirectedOrder ι] [Nonempty ι]
    (P : ι → ProbabilityMeasure ℝ) (Q : ProbabilityMeasure ℝ)
    (hTight : IsTightMeasureSet
      {((p : ProbabilityMeasure ℝ) : Measure ℝ) | p ∈ Set.range P})
    (hchar : ∀ t : ℝ, Tendsto
      (fun n => MeasureTheory.charFun (P n : Measure ℝ) t)
      atTop (𝓝 (MeasureTheory.charFun (Q : Measure ℝ) t))) :
    Tendsto P atTop (𝓝 Q) := by
  let S : Set (ProbabilityMeasure ℝ) := Set.range P
  have hcompact : IsCompact (closure S) :=
    isCompact_closure_of_isTightMeasureSet hTight
  refine hcompact.tendsto_nhds_of_unique_mapClusterPt ?_ ?_
  · exact Eventually.of_forall fun n => subset_closure ⟨n, rfl⟩
  · intro p hp hcluster
    apply ProbabilityMeasure.toMeasure_injective
    apply Measure.ext_of_charFun
    funext t
    have hc : Continuous
        (fun q : ProbabilityMeasure ℝ =>
          MeasureTheory.charFun (q : Measure ℝ) t) := by
      have hi : Continuous
          (fun q : ProbabilityMeasure ℝ =>
            ∫ x, BoundedContinuousFunction.innerProbChar t x ∂(q : Measure ℝ)) := by
        rw [continuous_iff_continuousAt]
        intro q
        exact (ProbabilityMeasure.tendsto_iff_forall_integral_rclike_tendsto ℂ).1
          continuousAt_id (BoundedContinuousFunction.innerProbChar t)
      simpa only [MeasureTheory.charFun_eq_integral_innerProbChar] using hi
    have hcluster_char : MapClusterPt
        (MeasureTheory.charFun (p : Measure ℝ) t) atTop
        (fun n => MeasureTheory.charFun (P n : Measure ℝ) t) :=
      hcluster.continuousAt_comp hc.continuousAt
    rw [mapClusterPt_iff_ultrafilter] at hcluster_char
    obtain ⟨U, hU, hUt⟩ := hcluster_char
    exact tendsto_nhds_unique hUt ((hchar t).mono_left hU)

/-- Lindeberg–Lévy for a centered unit-variance iid real sequence. The
normalization uses the first `N + 1` variables. -/
theorem tendsto_probabilityLaw_normalizedCenteredIidSum
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = 0)
    (hSecond : ∫ ω, (X 0 ω) ^ 2 ∂μ = 1) :
    Tendsto (fun n => probabilityLaw (normalizedCenteredIidSum X n)
        (normalizedCenteredIidSum_memLp X hX n).aemeasurable)
      atTop (𝓝 (⟨standardNormalLaw, inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  let P : ℕ → ProbabilityMeasure ℝ := fun n =>
    probabilityLaw (normalizedCenteredIidSum X n)
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable
  let Q : ProbabilityMeasure ℝ := ⟨standardNormalLaw, inferInstance⟩
  change Tendsto P atTop (𝓝 Q)
  apply tendsto_probabilityMeasure_of_charFun_tendsto_of_tight P Q
  · exact isTight_probabilityLaw_normalizedCenteredIidSum
      X hX hIndep hIdent hMean hSecond
  · intro t
    have hbase := tendsto_centered_unitSecondMoment_charFun_pow_sqrt
      (X 0) (hX 0) hMean hSecond t
    have hsucc : Tendsto (fun n : ℕ => n + 1) atTop atTop :=
      Filter.tendsto_atTop_mono (fun n => Nat.le_succ n) tendsto_id
    have hlim := hbase.comp hsucc
    have hformula : ∀ n,
        MeasureTheory.charFun (P n : Measure ℝ) t =
          (∫ ω, Complex.exp
            (((t / Real.sqrt (n + 1 : ℝ) * X 0 ω : ℝ) : ℂ) * Complex.I) ∂μ) ^
              (n + 1) := by
      intro n
      exact charFun_probabilityLaw_normalizedCenteredIidSum
        X hX hIndep hIdent n t
    have hlimP : Tendsto
        (fun n => MeasureTheory.charFun (P n : Measure ℝ) t) atTop
        (𝓝 (Complex.exp (-(t : ℂ) ^ 2 / 2))) := by
      apply hlim.congr'
      filter_upwards with n
      symm
      simpa [P, Nat.cast_add, Nat.cast_one] using hformula n
    simpa [Q, standardNormalLaw_charFun] using hlimP

/-- Lindeberg–Lévy for iid real variables with common mean `m` and
variance `σ²`, with `σ > 0`. -/
theorem tendsto_probabilityLaw_normalizedIidSum
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (m σ : ℝ) (hσ : 0 < σ)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = m)
    (hVariance : ProbabilityTheory.variance (X 0) μ = σ ^ 2) :
    Tendsto (fun n => probabilityLaw (normalizedIidSum X m σ n)
        (normalizedIidSum_memLp X m σ hX n).aemeasurable)
      atTop (𝓝 (⟨standardNormalLaw, inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  let Y : ℕ → Ω → ℝ := fun i ω => σ⁻¹ * (X i ω - m)
  have hY : ∀ i, MemLp (Y i) 2 μ := by
    intro i
    exact ((hX i).sub (memLp_const m)).const_mul σ⁻¹
  have hIndepY : ProbabilityTheory.iIndepFun Y μ := by
    have h := hIndep.comp
      (fun _ (x : ℝ) => σ⁻¹ * (x - m)) (fun _ => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have hIdentY : ∀ i, ProbabilityTheory.IdentDistrib (Y i) (Y 0) μ μ := by
    intro i
    have h := (hIdent i).comp
      (by fun_prop : Measurable fun x : ℝ => σ⁻¹ * (x - m))
    simpa [Y, Function.comp_def] using h
  have hMeanY : ∫ ω, Y 0 ω ∂μ = 0 := by
    dsimp [Y]
    rw [integral_const_mul,
      integral_sub ((hX 0).integrable (by norm_num)) (integrable_const m), hMean]
    simp
  have hSecondY : ∫ ω, (Y 0 ω) ^ 2 ∂μ = 1 := by
    have hc : (∫ ω, (X 0 ω - m) ^ 2 ∂μ) = σ ^ 2 := by
      calc
        (∫ ω, (X 0 ω - m) ^ 2 ∂μ) =
            ProbabilityTheory.variance (X 0) μ := by
          rw [ProbabilityTheory.variance_eq_integral (hX 0).aemeasurable, hMean]
        _ = σ ^ 2 := hVariance
    dsimp [Y]
    calc
      (∫ ω, (σ⁻¹ * (X 0 ω - m)) ^ 2 ∂μ) =
          ∫ ω, σ⁻¹ ^ 2 * (X 0 ω - m) ^ 2 ∂μ := by
        congr 1
        funext ω
        ring
      _ = σ⁻¹ ^ 2 * ∫ ω, (X 0 ω - m) ^ 2 ∂μ :=
        integral_const_mul _ _
      _ = 1 := by
        rw [hc]
        field_simp [hσ.ne']
  have hEq (N : ℕ) :
      normalizedCenteredIidSum Y N = normalizedIidSum X m σ N := by
    funext ω
    simp only [normalizedCenteredIidSum, normalizedIidSum, Y]
    rw [← Finset.mul_sum Finset.univ
      (fun i : Fin (N + 1) => X i.1 ω - m) σ⁻¹]
    rw [← mul_assoc]
    apply congrArg
      (fun c : ℝ => c * ∑ i : Fin (N + 1), (X i.1 ω - m))
    rw [mul_inv_rev]
  have hclt := tendsto_probabilityLaw_normalizedCenteredIidSum
    Y hY hIndepY hIdentY hMeanY hSecondY
  apply hclt.congr'
  filter_upwards with n
  simp only [hEq n]

end NumStability.HDP.Scalar.LimitTheorems
```

### `ComputationalMathematics.HDP.Scalar.PoissonLimit`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/PoissonLimit.lean`
SHA-256: `a568a4190e773a43bee3f3594292ac480cb36b9bd6e5967b0c9b5d5c879c9e58`

```lean
import ComputationalMathematics.HDP.Scalar.CentralLimit
import ComputationalMathematics.HDP.Scalar.Preliminaries
import Mathlib.Analysis.SpecialFunctions.Complex.LogBounds

/-!
# Poisson-limit foundations

Reusable deterministic estimates for triangular arrays of rare-event
parameters.  These isolate the first analytic reduction in the Poisson limit
theorem: the maximum-probability and total-mean hypotheses force the sum of
squared probabilities to vanish.
-/

noncomputable section

open Filter
open scoped Topology BigOperators NNReal

namespace NumStability.HDP.Scalar.LimitTheorems

/-- The characteristic function of the canonical real Bernoulli law. -/
theorem bernoulliRealPMF_charFun
    (p : ℝ≥0) (hp : p ≤ 1) (t : ℝ) :
    MeasureTheory.charFun (bernoulliRealPMF p hp).toMeasure t =
      1 + (p : ℂ) * (Complex.exp ((t : ℂ) * Complex.I) - 1) := by
  rw [MeasureTheory.charFun_apply_real, bernoulliRealPMF,
    ← PMF.toMeasure_map (cond · (1 : ℝ) 0) (PMF.bernoulli p hp) (by fun_prop)]
  rw [MeasureTheory.integral_map (measurable_of_countable _).aemeasurable (by fun_prop)]
  rw [PMF.integral_eq_sum]
  simp [PMF.bernoulli_apply, NNReal.coe_sub hp]
  have hmod :
      (instInnerProductSpaceRealComplex.toNormedSpace.toModule : Module ℝ ℂ) =
        Module.complexToReal ℂ := by
    apply Module.ext
    funext r z
    apply Complex.ext <;> rfl
  rw [hmod]
  rw [← Complex.coe_smul, ← Complex.coe_smul]
  simp [smul_eq_mul]
  ring

/-- The Poisson law, transported from the natural numbers to the real line. -/
noncomputable def poissonRealLaw (rate : ℝ≥0) : MeasureTheory.Measure ℝ :=
  (poissonLaw rate).map (fun k : ℕ => (k : ℝ))

instance poissonRealLaw.isProbabilityMeasure (rate : ℝ≥0) :
    MeasureTheory.IsProbabilityMeasure (poissonRealLaw rate) := by
  unfold poissonRealLaw
  exact MeasureTheory.Measure.isProbabilityMeasure_map
    (measurable_of_countable _).aemeasurable

/-- The real Poisson law bundled as a probability measure. -/
noncomputable def poissonRealProbabilityMeasure
    (rate : ℝ≥0) : MeasureTheory.ProbabilityMeasure ℝ :=
  ⟨poissonRealLaw rate, inferInstance⟩

/-- The characteristic function of the real Poisson law is
`exp (rate * (exp (t * I) - 1))`. -/
theorem poissonRealLaw_charFun (rate : ℝ≥0) (t : ℝ) :
    MeasureTheory.charFun (poissonRealLaw rate) t =
      Complex.exp ((rate : ℂ) * (Complex.exp ((t : ℂ) * Complex.I) - 1)) := by
  rw [MeasureTheory.charFun_apply_real, poissonRealLaw,
    MeasureTheory.integral_map (measurable_of_countable _).aemeasurable (by fun_prop)]
  rw [poissonLaw, ProbabilityTheory.poissonMeasure]
  have hInt :
      MeasureTheory.Integrable
        (fun k : ℕ => Complex.exp ((t : ℂ) * (k : ℝ) * Complex.I))
        (ProbabilityTheory.poissonPMF rate).toMeasure := by
    apply
      (MeasureTheory.integrable_const
        (μ := (ProbabilityTheory.poissonPMF rate).toMeasure) (1 : ℂ)).mono
    · fun_prop
    · filter_upwards
      intro k
      rw [Complex.norm_exp]
      simp [Complex.mul_re]
  rw [PMF.integral_eq_tsum _ _ hInt]
  have hmod :
      (instInnerProductSpaceRealComplex.toNormedSpace.toModule : Module ℝ ℂ) =
        Module.complexToReal ℂ := by
    apply Module.ext
    funext r z
    apply Complex.ext <;> rfl
  rw [hmod]
  simp_rw [← Complex.coe_smul, smul_eq_mul]
  have hpmf (a : ℕ) :
      ((ProbabilityTheory.poissonPMF rate) a).toReal =
        ProbabilityTheory.poissonPMFReal rate a := by
    rw [ProbabilityTheory.poissonPMF]
    exact ENNReal.toReal_ofReal ProbabilityTheory.poissonPMFReal_nonneg
  simp_rw [hpmf]
  have hterm (a : ℕ) :
      (ProbabilityTheory.poissonPMFReal rate a : ℂ) *
          Complex.exp ((t : ℂ) * (a : ℝ) * Complex.I) =
        Complex.exp (-(rate : ℂ)) *
          (((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I)) ^ a /
            (Nat.factorial a : ℂ)) := by
    rw [ProbabilityTheory.poissonPMFReal]
    push_cast
    have hexp :
        Complex.exp ((t : ℂ) * (a : ℂ) * Complex.I) =
          Complex.exp ((t : ℂ) * Complex.I) ^ a := by
      rw [← Complex.exp_nat_mul]
      congr 1
      ring

    rw [hexp, mul_pow]
    ring
  calc
    (∑' a : ℕ, (ProbabilityTheory.poissonPMFReal rate a : ℂ) *
        Complex.exp ((t : ℂ) * (a : ℝ) * Complex.I)) =
      ∑' a : ℕ, Complex.exp (-(rate : ℂ)) *
        (((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I)) ^ a /
          (Nat.factorial a : ℂ)) := tsum_congr hterm
    _ = Complex.exp (-(rate : ℂ)) *
        ∑' a : ℕ, (((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I)) ^ a /
          (Nat.factorial a : ℂ)) := tsum_mul_left
    _ = Complex.exp (-(rate : ℂ)) *
        Complex.exp ((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I)) := by
      congr 1
      exact
        (NormedSpace.expSeries_div_hasSum_exp
          ((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I))).tsum_eq.trans
          (congr_fun Complex.exp_eq_exp_ℂ
            ((rate : ℂ) * Complex.exp ((t : ℂ) * Complex.I))).symm
    _ = Complex.exp ((rate : ℂ) * (Complex.exp ((t : ℂ) * Complex.I) - 1)) := by
      rw [← Complex.exp_add]
      congr 1
      ring

/-! ## Heterogeneous Bernoulli rows -/

/-- The product weight of a Boolean realization of one heterogeneous
Bernoulli row. -/
private def poissonBernoulliRowWeight
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ)
    (f : Fin (N + 1) → Bool) : ENNReal :=
  ∏ i, if f i then (p N i : ENNReal)
    else ((1 : ENNReal) - (p N i : ENNReal))

theorem poissonBernoulliRowWeight_sum_eq_one
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    (∑ f : Fin (N + 1) → Bool, poissonBernoulliRowWeight p N f) = 1 := by
  classical
  calc
    (∑ f : Fin (N + 1) → Bool, poissonBernoulliRowWeight p N f) =
        ∏ i : Fin (N + 1), ∑ b : Bool,
          (if b then (p N i : ENNReal)
            else ((1 : ENNReal) - (p N i : ENNReal))) := by
      exact (Fintype.prod_sum fun i (b : Bool) =>
        if b then (p N i : ENNReal)
        else ((1 : ENNReal) - (p N i : ENNReal))).symm
    _ = 1 := by
      apply Finset.prod_eq_one
      intro i hi
      have hsub : (p N i : ENNReal) +
          ((1 : ENNReal) - (p N i : ENNReal)) = 1 := by
        norm_cast
        exact add_tsub_cancel_of_le (hp N i)
      simp [hsub]

/-- The product probability mass function of one heterogeneous Bernoulli
row. -/
def poissonBernoulliRowVectorPMF
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) : PMF (Fin (N + 1) → Bool) :=
  PMF.ofFintype (poissonBernoulliRowWeight p N)
    (poissonBernoulliRowWeight_sum_eq_one p hp N)

/-- The real-valued number of successes in a Boolean Bernoulli row. -/
def poissonBernoulliRowCount
    (N : ℕ) (f : Fin (N + 1) → Bool) : ℝ :=
  ∑ i, if f i then 1 else 0

/-- The law of the sum of a heterogeneous row of independent Bernoulli
variables. -/
def poissonBernoulliRowPMF
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) : PMF ℝ :=
  (poissonBernoulliRowVectorPMF p hp N).map
    (poissonBernoulliRowCount N)

/-- A canonical heterogeneous Bernoulli row-sum law bundled as a probability
measure. -/
noncomputable def poissonBernoulliRowProbabilityMeasure
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    MeasureTheory.ProbabilityMeasure ℝ :=
  ⟨(poissonBernoulliRowPMF p hp N).toMeasure, inferInstance⟩

/-- The mean of one coordinate of the canonical heterogeneous Bernoulli row
is its success parameter. -/
theorem poissonBernoulliRow_coordinate_mean
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) (i : Fin (N + 1)) :
    ∫ f, (if f i then 1 else 0 : ℝ)
      ∂(poissonBernoulliRowVectorPMF p hp N).toMeasure = (p N i : ℝ) := by
  classical
  let q : Fin (N + 1) → Bool → ℝ := fun j b =>
    if b then (p N j : ℝ) else 1 - (p N j : ℝ)
  have hw (f : Fin (N + 1) → Bool) :
      ((poissonBernoulliRowVectorPMF p hp N) f).toReal =
        ∏ j, q j (f j) := by
    rw [poissonBernoulliRowVectorPMF, PMF.ofFintype_apply,
      poissonBernoulliRowWeight, ENNReal.toReal_prod]
    apply Finset.prod_congr rfl
    intro j hj
    by_cases hfj : f j
    · simp [q, hfj]
    · simp [q, hfj]
      rw [ENNReal.toReal_sub_of_le]
      · simp
      · exact_mod_cast hp N j
      · simp
  rw [PMF.integral_eq_sum]
  simp_rw [hw]
  simp only [smul_eq_mul]
  let r : Fin (N + 1) → Bool → ℝ := fun j b =>
    if j = i then q j b * (if b then 1 else 0) else q j b
  have hterm (f : Fin (N + 1) → Bool) :
      (∏ j, q j (f j)) * (if f i then 1 else 0) =
        ∏ j, r j (f j) := by
    by_cases hfi : f i
    · rw [if_pos hfi, mul_one]
      apply Finset.prod_congr rfl
      intro j hj
      by_cases hji : j = i
      · subst j
        simp [r, hfi]
      · simp [r, hji]
    · rw [if_neg hfi, mul_zero]
      symm
      apply Finset.prod_eq_zero (Finset.mem_univ i)
      simp [r, hfi]
  calc
    (∑ f : Fin (N + 1) → Bool,
        (∏ j, q j (f j)) * (if f i then 1 else 0)) =
        ∑ f : Fin (N + 1) → Bool, ∏ j, r j (f j) := by
          exact Finset.sum_congr rfl fun f _ => hterm f
    _ = ∏ j : Fin (N + 1), ∑ b : Bool, r j b :=
      (Fintype.prod_sum r).symm
    _ = p N i := by
      have hq (j : Fin (N + 1)) : q j true + q j false = 1 := by
        simp [q]
      calc
        (∏ j : Fin (N + 1), ∑ b : Bool, r j b) =
            ∑ b : Bool, r i b := by
          exact Finset.prod_eq_single i
            (fun j _ hji => by
              rw [Fintype.sum_bool]
              simp [r, hji, hq]) (by simp)
        _ = p N i := by
          rw [Fintype.sum_bool]
          simp [r, q]

/-- The characteristic function of the heterogeneous Bernoulli row sum is
the product of its Bernoulli characteristic-function factors. -/
theorem poissonBernoulliRowPMF_charFun
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) (t : ℝ) :
    MeasureTheory.charFun (poissonBernoulliRowPMF p hp N).toMeasure t =
      ∏ i : Fin (N + 1), (1 + (p N i : ℂ) *
        (Complex.exp ((t : ℂ) * Complex.I) - 1)) := by
  classical
  rw [MeasureTheory.charFun_apply_real, poissonBernoulliRowPMF,
    ← PMF.toMeasure_map (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N) (measurable_of_countable _)]
  rw [MeasureTheory.integral_map (measurable_of_countable _).aemeasurable
    (by fun_prop)]
  rw [PMF.integral_eq_sum]
  have hterm (f : Fin (N + 1) → Bool) :
      ((poissonBernoulliRowVectorPMF p hp N) f).toReal •
          Complex.exp ((t : ℂ) * (poissonBernoulliRowCount N f : ℂ) *
            Complex.I) =
        ∏ i : Fin (N + 1),
          ((((if f i then (p N i : ENNReal)
              else ((1 : ENNReal) - (p N i : ENNReal))).toReal : ℂ) *
            Complex.exp ((t : ℂ) *
              ((if f i then 1 else 0 : ℝ) : ℂ) * Complex.I))) := by
    rw [poissonBernoulliRowVectorPMF, PMF.ofFintype_apply]
    have hw : (poissonBernoulliRowWeight p N f).toReal =
        ∏ i : Fin (N + 1),
          ((if f i then (p N i : ENNReal)
            else ((1 : ENNReal) - (p N i : ENNReal))).toReal) :=
      ENNReal.toReal_prod
    rw [hw]
    have hexp :
        Complex.exp ((t : ℂ) * (poissonBernoulliRowCount N f : ℂ) *
          Complex.I) =
          ∏ i : Fin (N + 1),
            (Complex.exp ((t : ℂ) *
              ((if f i then 1 else 0 : ℝ) : ℂ) * Complex.I)) := by
      rw [show (t : ℂ) * (poissonBernoulliRowCount N f : ℂ) * Complex.I =
          ∑ i : Fin (N + 1),
            ((t : ℂ) * ((if f i then 1 else 0 : ℝ) : ℂ) * Complex.I) by
        unfold poissonBernoulliRowCount
        push_cast
        rw [Finset.mul_sum, Finset.sum_mul]]
      exact Complex.exp_sum _ _
    rw [hexp]
    simp only [Complex.real_smul]
    push_cast
    rw [Finset.prod_mul_distrib]
  calc
    (∑ a : Fin (N + 1) → Bool,
        ((poissonBernoulliRowVectorPMF p hp N) a).toReal •
          Complex.exp ((t : ℂ) *
            (poissonBernoulliRowCount N a : ℂ) * Complex.I)) =
        ∑ f : Fin (N + 1) → Bool, ∏ i : Fin (N + 1),
          ((((if f i then (p N i : ENNReal)
              else ((1 : ENNReal) - (p N i : ENNReal))).toReal : ℂ) *
            Complex.exp ((t : ℂ) *
              ((if f i then 1 else 0 : ℝ) : ℂ) * Complex.I))) := by
          exact Finset.sum_congr rfl fun f _ => hterm f
    _ = ∏ i : Fin (N + 1), ∑ b : Bool,
          ((((if b then (p N i : ENNReal)
              else ((1 : ENNReal) - (p N i : ENNReal))).toReal : ℂ) *
            Complex.exp ((t : ℂ) *
              ((if b then 1 else 0 : ℝ) : ℂ) * Complex.I))) := by
      exact (Fintype.prod_sum fun i (b : Bool) =>
        (((if b then (p N i : ENNReal)
          else ((1 : ENNReal) - (p N i : ENNReal))).toReal : ℂ) *
        Complex.exp ((t : ℂ) *
          ((if b then 1 else 0 : ℝ) : ℂ) * Complex.I))).symm
    _ = ∏ i : Fin (N + 1), (1 + (p N i : ℂ) *
          (Complex.exp ((t : ℂ) * Complex.I) - 1)) := by
      apply Finset.prod_congr rfl
      intro i hi
      have hsub : ((1 : ENNReal) - (p N i : ENNReal)).toReal =
          1 - (p N i : ℝ) := by
        rw [ENNReal.toReal_sub_of_le]
        · simp
        · exact_mod_cast hp N i
        · simp
      rw [Fintype.sum_bool]
      simp [hsub]
      ring

/-- Uniformly integrable nonnegative laws with bounded first moments form a
tight sequence. -/
theorem isTight_probabilityMeasure_range_of_nonneg_expectation_le
    (P : ℕ → MeasureTheory.ProbabilityMeasure ℝ)
    (hInt : ∀ n, MeasureTheory.Integrable (fun x : ℝ => x)
      (P n : MeasureTheory.Measure ℝ))
    (hNonneg : ∀ n,
      0 ≤ᵐ[(P n : MeasureTheory.Measure ℝ)] (fun x : ℝ => x))
    (C : ℝ) (hC : 0 ≤ C)
    (hMean : ∀ n, ∫ x : ℝ, x ∂(P n : MeasureTheory.Measure ℝ) ≤ C) :
    MeasureTheory.IsTightMeasureSet
      {((q : MeasureTheory.ProbabilityMeasure ℝ) : MeasureTheory.Measure ℝ) |
        q ∈ Set.range P} := by
  rw [MeasureTheory.isTightMeasureSet_iff_exists_isCompact_measure_compl_le]
  intro ε hε
  obtain ⟨n, hn⟩ := ENNReal.exists_inv_nat_lt hε.ne'
  have hn0 : n ≠ 0 := by
    intro hnz
    subst n
    simp at hn
  have hnR : (0 : ℝ) < n := by
    exact_mod_cast Nat.pos_of_ne_zero hn0
  have hnE0 : (n : ENNReal) ≠ 0 := by
    exact_mod_cast hn0
  have hnET : (n : ENNReal) ≠ ⊤ := by simp
  have hCp : 0 < C + 1 := by linarith
  let R : ℝ := (n : ℝ) * (C + 1)
  have hR : 0 < R := mul_pos hnR hCp
  refine ⟨Set.Icc (-R) R, isCompact_Icc, ?_⟩
  intro ν hν
  rcases hν with ⟨q, ⟨k, rfl⟩, rfl⟩
  have hmono : (P k : MeasureTheory.Measure ℝ) (Set.Icc (-R) R)ᶜ ≤
      (P k : MeasureTheory.Measure ℝ)
        ((fun x : ℝ => x) ⁻¹' Set.Ici R) := by
    apply MeasureTheory.measure_mono_ae
    filter_upwards [hNonneg k] with x hx
    change (0 : ℝ) ≤ x at hx
    intro hxc
    change R ≤ x
    by_contra hnot
    apply hxc
    exact ⟨by linarith, by linarith⟩
  refine hmono.trans ?_
  have hmarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityExtended
      (μ := (P k : MeasureTheory.Measure ℝ)) (X := fun x : ℝ => x)
      measurable_id (hNonneg k) hR
  refine hmarkov.trans ?_
  have hlin :
      (∫⁻ x : ℝ, ENNReal.ofReal x ∂(P k : MeasureTheory.Measure ℝ)) =
        ENNReal.ofReal
          (∫ x : ℝ, x ∂(P k : MeasureTheory.Measure ℝ)) := by
    exact (MeasureTheory.ofReal_integral_eq_lintegral_ofReal
      (hInt k) (hNonneg k)).symm
  rw [hlin]
  calc
    ENNReal.ofReal (∫ x : ℝ, x ∂(P k : MeasureTheory.Measure ℝ)) /
          ENNReal.ofReal R ≤ ENNReal.ofReal C / ENNReal.ofReal R := by
      gcongr
      exact hMean k
    _ ≤ (n : ENNReal)⁻¹ := by
      rw [show ENNReal.ofReal R =
          (n : ENNReal) * ENNReal.ofReal (C + 1) by
        simp [R, ENNReal.ofReal_mul hnR.le]]
      rw [ENNReal.div_eq_inv_mul,
        ENNReal.mul_inv (Or.inl hnE0) (Or.inl hnET)]
      calc
        (n : ENNReal)⁻¹ * (ENNReal.ofReal (C + 1))⁻¹ *
            ENNReal.ofReal C =
          (n : ENNReal)⁻¹ *
            ((ENNReal.ofReal (C + 1))⁻¹ * ENNReal.ofReal C) := by ac_rfl
        _ ≤ (n : ENNReal)⁻¹ * 1 := by
          gcongr
          exact (mul_le_mul_right
            (ENNReal.ofReal_le_ofReal (by linarith : C ≤ C + 1))
            (ENNReal.ofReal (C + 1))⁻¹).trans
              (ENNReal.inv_mul_le_one (ENNReal.ofReal (C + 1)))
        _ = (n : ENNReal)⁻¹ := mul_one _
    _ ≤ ε := hn.le

/-- The largest rare-event probability in row `N`, using `N + 1` entries so
the row is nonempty at every natural index. -/
def poissonRowMax
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ) : ℝ≥0 :=
  Finset.univ.sup (p N)

/-- The total mean of a row of Bernoulli parameters. -/
def poissonRowSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ) : ℝ :=
  ∑ i, (p N i : ℝ)

/-- The identity is integrable under every canonical Bernoulli row-sum law. -/
theorem integrable_id_poissonBernoulliRowPMF
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    MeasureTheory.Integrable (fun x : ℝ => x)
      (poissonBernoulliRowPMF p hp N).toMeasure := by
  rw [poissonBernoulliRowPMF,
    ← PMF.toMeasure_map (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N) (measurable_of_countable _)]
  have hcount : AEMeasurable (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N).toMeasure :=
    (show Measurable (poissonBernoulliRowCount N) from
      measurable_of_countable _).aemeasurable
  refine (MeasureTheory.integrable_map_measure
    (f := poissonBernoulliRowCount N) (g := fun x : ℝ => x)
    continuous_id.aestronglyMeasurable hcount).2 ?_
  change MeasureTheory.Integrable (poissonBernoulliRowCount N)
    (poissonBernoulliRowVectorPMF p hp N).toMeasure
  rw [← MeasureTheory.integrableOn_univ]
  exact MeasureTheory.IntegrableOn.of_finite Set.finite_univ

/-- Every canonical Bernoulli row-sum law is supported on the nonnegative
real line. -/
theorem ae_nonneg_poissonBernoulliRowPMF
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    0 ≤ᵐ[(poissonBernoulliRowPMF p hp N).toMeasure]
      (fun x : ℝ => x) := by
  rw [poissonBernoulliRowPMF,
    ← PMF.toMeasure_map (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N) (measurable_of_countable _)]
  have hcount : AEMeasurable (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N).toMeasure :=
    (show Measurable (poissonBernoulliRowCount N) from
      measurable_of_countable _).aemeasurable
  apply (MeasureTheory.ae_map_iff hcount measurableSet_Ici).2
  filter_upwards with f
  change 0 ≤ poissonBernoulliRowCount N f
  exact Finset.sum_nonneg fun _ _ => by positivity

/-- The mean of a canonical heterogeneous Bernoulli row sum is the sum of
its success parameters. -/
theorem poissonBernoulliRowPMF_mean
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (N : ℕ) :
    ∫ x : ℝ, x ∂(poissonBernoulliRowPMF p hp N).toMeasure =
      poissonRowSum p N := by
  rw [poissonBernoulliRowPMF,
    ← PMF.toMeasure_map (poissonBernoulliRowCount N)
      (poissonBernoulliRowVectorPMF p hp N) (measurable_of_countable _)]
  have hiMap := MeasureTheory.integral_map
    (μ := (poissonBernoulliRowVectorPMF p hp N).toMeasure)
    (φ := poissonBernoulliRowCount N) (f := fun x : ℝ => x)
    (measurable_of_countable _).aemeasurable
    continuous_id.aestronglyMeasurable
  rw [hiMap]
  unfold poissonBernoulliRowCount poissonRowSum
  rw [MeasureTheory.integral_finset_sum Finset.univ]
  · exact Finset.sum_congr rfl fun i _ =>
      poissonBernoulliRow_coordinate_mean p hp N i
  · intro i hi
    rw [← MeasureTheory.integrableOn_univ]
    exact MeasureTheory.IntegrableOn.of_finite Set.finite_univ

/-- The sum of squared probabilities in a row. -/
def poissonRowSqSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ) : ℝ :=
  ∑ i, (p N i : ℝ) ^ 2

/-- The elementary estimate `Σ pᵢ² ≤ (max pᵢ) Σ pᵢ`. -/
theorem poissonRowSqSum_le_max_mul_sum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (N : ℕ) :
    poissonRowSqSum p N ≤ (poissonRowMax p N : ℝ) * poissonRowSum p N := by
  unfold poissonRowSqSum poissonRowMax poissonRowSum
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro i hi
  rw [pow_two]
  apply mul_le_mul_of_nonneg_right _ (NNReal.coe_nonneg _)
  exact_mod_cast (Finset.le_sup (f := p N) (Finset.mem_univ i))

/-- If the maximum row probability tends to zero while the row sums converge
to a finite limit, then the sum of squared row probabilities tends to zero. -/
theorem tendsto_poissonRowSqSum_zero
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (rate : ℝ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 rate)) :
    Tendsto (poissonRowSqSum p) atTop (𝓝 0) := by
  apply squeeze_zero
  · intro N
    exact Finset.sum_nonneg fun _ _ => sq_nonneg _
  · exact poissonRowSqSum_le_max_mul_sum p
  · simpa using hmax.mul hsum

/-- A convenient quadratic form of the complex logarithm remainder estimate on
the closed half ball. -/
theorem norm_log_one_add_sub_self_le_sq
    {z : ℂ} (hz : ‖z‖ ≤ (1 : ℝ) / 2) :
    ‖Complex.log (1 + z) - z‖ ≤ ‖z‖ ^ 2 := by
  have hzlt : ‖z‖ < (1 : ℝ) := lt_of_le_of_lt hz (by norm_num)
  refine (Complex.norm_log_one_add_sub_self_le hzlt).trans ?_
  have hden : (1 - ‖z‖)⁻¹ ≤ (2 : ℝ) := by
    rw [inv_le_comm₀ (sub_pos.mpr hzlt) (by norm_num)]
    linarith
  calc
    ‖z‖ ^ 2 * (1 - ‖z‖)⁻¹ / 2
        ≤ ‖z‖ ^ 2 * 2 / 2 := by gcongr
    _ = ‖z‖ ^ 2 := by ring

/-- The accumulated logarithm remainder for finitely many rare-event
probabilities is controlled by their squared sum. -/
theorem norm_sum_log_one_add_sub_le
    {ι : Type*} [Fintype ι] (q : ι → ℝ≥0) (z : ℂ)
    (hsmall : ∀ i, ‖(q i : ℂ) * z‖ ≤ (1 : ℝ) / 2) :
    ‖∑ i, (Complex.log (1 + (q i : ℂ) * z) - (q i : ℂ) * z)‖
      ≤ ‖z‖ ^ 2 * ∑ i, (q i : ℝ) ^ 2 := by
  calc
    ‖∑ i, (Complex.log (1 + (q i : ℂ) * z) - (q i : ℂ) * z)‖
        ≤ ∑ i, ‖Complex.log (1 + (q i : ℂ) * z) - (q i : ℂ) * z‖ :=
      norm_sum_le _ _
    _ ≤ ∑ i, ‖(q i : ℂ) * z‖ ^ 2 := by
      apply Finset.sum_le_sum
      intro i hi
      exact norm_log_one_add_sub_self_le_sq (hsmall i)
    _ = ‖z‖ ^ 2 * ∑ i, (q i : ℝ) ^ 2 := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i hi
      have hqnorm : ‖(q i : ℂ)‖ = (q i : ℝ) := by
        exact Complex.norm_of_nonneg (NNReal.coe_nonneg _)
      rw [norm_mul, hqnorm, mul_pow]
      ring

/-- The logarithm remainder after subtracting the linearized rare-event
contribution in a triangular-array row. -/
def poissonLogRemainder
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ) : ℂ :=
  (∑ i, Complex.log (1 + (p N i : ℂ) * z)) -
    (poissonRowSum p N : ℂ) * z

theorem norm_poissonLogRemainder_le
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ)
    (hsmall : ∀ i, ‖(p N i : ℂ) * z‖ ≤ (1 : ℝ) / 2) :
    ‖poissonLogRemainder p z N‖ ≤ ‖z‖ ^ 2 * poissonRowSqSum p N := by
  unfold poissonLogRemainder poissonRowSum poissonRowSqSum
  have hlinear :
      ((∑ i, (p N i : ℝ) : ℝ) : ℂ) * z = ∑ i, (p N i : ℂ) * z := by
    push_cast
    rw [Finset.sum_mul]
  rw [hlinear, ← Finset.sum_sub_distrib]
  exact norm_sum_log_one_add_sub_le (p N) z hsmall

/-- Vanishing squared probabilities make the accumulated logarithm remainder
vanish, once every row factor is eventually in the logarithm's half ball. -/
theorem tendsto_poissonLogRemainder_zero
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ)
    (hsq : Tendsto (poissonRowSqSum p) atTop (𝓝 0))
    (hsmall : ∀ᶠ N in atTop, ∀ i, ‖(p N i : ℂ) * z‖ ≤ (1 : ℝ) / 2) :
    Tendsto (poissonLogRemainder p z) atTop (𝓝 0) := by
  apply squeeze_zero_norm'
  · filter_upwards [hsmall] with N hN
    exact norm_poissonLogRemainder_le p z N hN
  · simpa using (tendsto_const_nhds.mul hsq)

theorem eventually_norm_poissonFactor_le_half
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0)) :
    ∀ᶠ N in atTop, ∀ i, ‖(p N i : ℂ) * z‖ ≤ (1 : ℝ) / 2 := by
  have hbound :
      ∀ᶠ N in atTop,
        (poissonRowMax p N : ℝ) * ‖z‖ ≤ (1 : ℝ) / 2 :=
    (hmax.mul_const ‖z‖).eventually_le_const (by norm_num)
  filter_upwards [hbound] with N hN
  intro i
  have hpmax : (p N i : ℝ) ≤ (poissonRowMax p N : ℝ) := by
    exact_mod_cast (Finset.le_sup (f := p N) (Finset.mem_univ i))
  have hqnorm : ‖(p N i : ℂ)‖ = (p N i : ℝ) :=
    Complex.norm_of_nonneg (NNReal.coe_nonneg _)
  rw [norm_mul, hqnorm]
  exact (mul_le_mul_of_nonneg_right hpmax (norm_nonneg z)).trans hN

theorem tendsto_poissonLogRemainder_zero_of_row_limits
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (rate : ℝ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 rate)) :
    Tendsto (poissonLogRemainder p z) atTop (𝓝 0) := by
  exact tendsto_poissonLogRemainder_zero p z
    (tendsto_poissonRowSqSum_zero p rate hmax hsum)
    (eventually_norm_poissonFactor_le_half p z hmax)

/-- The sum of logarithms of the Bernoulli characteristic-function factors. -/
def poissonLogSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ) : ℂ :=
  ∑ i, Complex.log (1 + (p N i : ℂ) * z)

/-- The rowwise logarithms converge to the linear Poisson exponent. -/
theorem tendsto_poissonLogSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (rate : ℝ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 rate)) :
    Tendsto (poissonLogSum p z) atTop (𝓝 ((rate : ℂ) * z)) := by
  have hrem := tendsto_poissonLogRemainder_zero_of_row_limits p z rate hmax hsum
  have hlin :
      Tendsto (fun N => (poissonRowSum p N : ℂ) * z) atTop
        (𝓝 ((rate : ℂ) * z)) :=
    hsum.ofReal.mul_const z
  convert hrem.add hlin using 1
  · funext N
    simp only [poissonLogRemainder, poissonLogSum]
    ring
  · ring

/-- The product of the rowwise Bernoulli characteristic-function factors. -/
def poissonFactorProduct
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ) : ℂ :=
  ∏ i, (1 + (p N i : ℂ) * z)

theorem poissonFactorProduct_eq_exp_logSum
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (N : ℕ)
    (hsmall : ∀ i, ‖(p N i : ℂ) * z‖ ≤ (1 : ℝ) / 2) :
    poissonFactorProduct p z N = Complex.exp (poissonLogSum p z N) := by
  unfold poissonFactorProduct poissonLogSum
  calc
    (∏ i, (1 + (p N i : ℂ) * z))
        = ∏ i, Complex.exp (Complex.log (1 + (p N i : ℂ) * z)) := by
      apply Finset.prod_congr rfl
      intro i hi
      symm
      apply Complex.exp_log
      intro hzero
      have ha : (p N i : ℂ) * z = -1 := by
        calc
          (p N i : ℂ) * z = (1 + (p N i : ℂ) * z) - 1 := by ring
          _ = -1 := by rw [hzero]; ring
      have hnorm : ‖(p N i : ℂ) * z‖ = (1 : ℝ) := by rw [ha]; simp
      linarith [hsmall i]
    _ = Complex.exp (∑ i, Complex.log (1 + (p N i : ℂ) * z)) := by
      simpa using
        (Complex.exp_sum (Finset.univ : Finset (Fin (N + 1)))
          (fun i => Complex.log (1 + (p N i : ℂ) * z))).symm

/-- The Bernoulli factor products converge to the exponential of the Poisson
linear exponent under the two source row-limit assumptions. -/
theorem tendsto_poissonFactorProduct
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0) (z : ℂ) (rate : ℝ)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 rate)) :
    Tendsto (poissonFactorProduct p z) atTop
      (𝓝 (Complex.exp ((rate : ℂ) * z))) := by
  have hlog := tendsto_poissonLogSum p z rate hmax hsum
  have hexp := (Complex.continuous_exp.tendsto ((rate : ℂ) * z)).comp hlog
  apply hexp.congr'
  filter_upwards [eventually_norm_poissonFactor_le_half p z hmax] with N hN
  exact (poissonFactorProduct_eq_exp_logSum p z N hN).symm

/-- **Poisson limit theorem.** If the largest success probability in each
heterogeneous Bernoulli row tends to zero and the total row mean tends to a
finite nonnegative rate, then the row-sum laws converge weakly to the Poisson
law with that rate. -/
theorem tendsto_poissonBernoulliRowProbabilityMeasure
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (rate : ℝ≥0)
    (hmax : Tendsto (fun N => (poissonRowMax p N : ℝ)) atTop (𝓝 0))
    (hsum : Tendsto (poissonRowSum p) atTop (𝓝 (rate : ℝ))) :
    Tendsto (poissonBernoulliRowProbabilityMeasure p hp) atTop
      (𝓝 (poissonRealProbabilityMeasure rate)) := by
  let P : ℕ → MeasureTheory.ProbabilityMeasure ℝ :=
    poissonBernoulliRowProbabilityMeasure p hp
  let Q : MeasureTheory.ProbabilityMeasure ℝ :=
    poissonRealProbabilityMeasure rate
  change Tendsto P atTop (𝓝 Q)
  apply tendsto_probabilityMeasure_of_charFun_tendsto_of_tight P Q
  · rcases hsum.bddAbove_range with ⟨C, hC⟩
    have hbound : ∀ N, poissonRowSum p N ≤ C :=
      fun N => hC ⟨N, rfl⟩
    have hC0 : 0 ≤ C :=
      (Finset.sum_nonneg fun _ _ => NNReal.coe_nonneg (p 0 _)).trans
        (hbound 0)
    apply isTight_probabilityMeasure_range_of_nonneg_expectation_le P
      (fun N => integrable_id_poissonBernoulliRowPMF p hp N)
      (fun N => ae_nonneg_poissonBernoulliRowPMF p hp N) C hC0
    intro N
    rw [show (P N : MeasureTheory.Measure ℝ) =
        (poissonBernoulliRowPMF p hp N).toMeasure by rfl,
      poissonBernoulliRowPMF_mean]
    exact hbound N
  · intro t
    have hlim := tendsto_poissonFactorProduct p
      (Complex.exp ((t : ℂ) * Complex.I) - 1) (rate : ℝ) hmax hsum
    change Tendsto
      (fun N => MeasureTheory.charFun
        (poissonBernoulliRowPMF p hp N).toMeasure t)
      atTop (𝓝 (MeasureTheory.charFun (poissonRealLaw rate) t))
    rw [poissonRealLaw_charFun]
    apply hlim.congr'
    filter_upwards with N
    exact (poissonBernoulliRowPMF_charFun p hp N t).symm

end NumStability.HDP.Scalar.LimitTheorems
```

### `ComputationalMathematics.HDP.Scalar.PoissonNormal`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/PoissonNormal.lean`
SHA-256: `5b2f3d38bd948328e461e46b7e543208b10150f6e3db9459090bfdd8dedaa056`

```lean
import ComputationalMathematics.HDP.Scalar.IndependentSums.PoissonChernoff
import ComputationalMathematics.HDP.Scalar.PoissonLimit
import Mathlib.Probability.HasLawExists

/-!
# Poisson moment foundations for normal approximation

Exact first and second moments, square integrability, and variance for the
real-valued Poisson law. These results provide the moment data needed to feed
the reusable i.i.d. central limit theorem into Poisson normal approximation.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Filter
open scoped ENNReal NNReal BigOperators Topology

namespace NumStability.HDP.Scalar.PoissonNormal

open NumStability.HDP.Scalar.IndependentSums.PoissonChernoff

/-- The probability-weighted first-moment series of a Poisson law sums to its
rate. -/
theorem poissonPMFReal_firstMoment_hasSum (rate : ℝ≥0) :
    HasSum (fun n : ℕ => (n : ℝ) * poissonPMFReal rate n) (rate : ℝ) := by
  let f : ℕ → ℝ := fun n => (n : ℝ) * poissonPMFReal rate n
  have hshift : HasSum (fun n : ℕ => f (n + 1)) (rate : ℝ) := by
    convert (poissonPMFRealSum rate).mul_left (rate : ℝ) using 1
    ext n
    dsimp [f]
    rw [poissonPMFReal, poissonPMFReal, Nat.factorial_succ, pow_succ]
    push_cast
    field_simp
    ring_nf
  apply (hasSum_nat_add_iff' (f := f) 1).mp
  simpa [f] using hshift

/-- The probability-weighted raw second-moment series of a Poisson law sums
to `rate ^ 2 + rate`. -/
theorem poissonPMFReal_secondMoment_hasSum (rate : ℝ≥0) :
    HasSum (fun n : ℕ => (n : ℝ) ^ 2 * poissonPMFReal rate n)
      ((rate : ℝ) ^ 2 + (rate : ℝ)) := by
  let f : ℕ → ℝ := fun n => (n : ℝ) ^ 2 * poissonPMFReal rate n
  have hplus : HasSum
      (fun n : ℕ => ((n : ℝ) + 1) * poissonPMFReal rate n)
      ((rate : ℝ) + 1) := by
    simpa [add_mul] using
      (poissonPMFReal_firstMoment_hasSum rate).add (poissonPMFRealSum rate)
  have hshift : HasSum (fun n : ℕ => f (n + 1))
      ((rate : ℝ) * ((rate : ℝ) + 1)) := by
    convert hplus.mul_left (rate : ℝ) using 1
    ext n
    dsimp [f]
    rw [poissonPMFReal, poissonPMFReal, Nat.factorial_succ, pow_succ]
    push_cast
    field_simp
    ring
  apply (hasSum_nat_add_iff' (f := f) 1).mp
  convert hshift using 1
  simp [f]
  ring

/-- The squared natural-number coordinate is integrable under every Poisson
law. -/
theorem integrable_sq_nat_poisson (rate : ℝ≥0) :
    Integrable (fun n : ℕ => (n : ℝ) ^ 2) (poissonMeasure rate) := by
  apply (integrable_exp_nat_poisson rate 2).mono'
  · fun_prop
  · filter_upwards with n
    change ‖(n : ℝ) ^ 2‖ ≤ Real.exp (2 * (n : ℝ))
    rw [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg _)]
    have hn : 0 ≤ (n : ℝ) := Nat.cast_nonneg n
    have h := Real.quadratic_le_exp_of_nonneg
      (show 0 ≤ 2 * (n : ℝ) by positivity)
    nlinarith

/-- Conversion of the Poisson PMF value from `ENNReal` to its defining real
mass. -/
lemma poissonPMF_toReal (rate : ℝ≥0) (n : ℕ) :
    ((poissonPMF rate) n).toReal = poissonPMFReal rate n := by
  rw [poissonPMF]
  exact ENNReal.toReal_ofReal poissonPMFReal_nonneg

/-- The mean of the real-valued Poisson law equals its rate. -/
theorem integral_id_poissonRealLaw (rate : ℝ≥0) :
    ∫ x : ℝ, x ∂NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate =
      (rate : ℝ) := by
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw,
    integral_map (φ := fun n : ℕ => (n : ℝ)) (f := fun x : ℝ => x)
      (measurable_of_countable _).aemeasurable
      continuous_id.aestronglyMeasurable,
      NumStability.HDP.Scalar.LimitTheorems.poissonLaw]
  rw [ProbabilityTheory.poissonMeasure]
  rw [PMF.integral_eq_tsum]
  · simp_rw [poissonPMF_toReal]
    simpa [smul_eq_mul, mul_comm] using
      (poissonPMFReal_firstMoment_hasSum rate).tsum_eq
  · apply (integrable_exp_nat_poisson rate 1).mono'
    · fun_prop
    · filter_upwards with n
      simp only [one_mul]
      change ‖(n : ℝ)‖ ≤ Real.exp (n : ℝ)
      rw [Real.norm_eq_abs, abs_of_nonneg (Nat.cast_nonneg n)]
      have h := Real.quadratic_le_exp_of_nonneg (Nat.cast_nonneg n)
      nlinarith [sq_nonneg (n : ℝ)]

/-- The raw second moment of the real-valued Poisson law is
`rate ^ 2 + rate`. -/
theorem integral_sq_poissonRealLaw (rate : ℝ≥0) :
    ∫ x : ℝ, x ^ 2 ∂NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate =
      (rate : ℝ) ^ 2 + (rate : ℝ) := by
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw,
    integral_map (φ := fun n : ℕ => (n : ℝ)) (f := fun x : ℝ => x ^ 2)
      (measurable_of_countable _).aemeasurable
      (continuous_id.pow 2).aestronglyMeasurable,
      NumStability.HDP.Scalar.LimitTheorems.poissonLaw]
  rw [ProbabilityTheory.poissonMeasure]
  rw [PMF.integral_eq_tsum _ _ (integrable_sq_nat_poisson rate)]
  simp_rw [poissonPMF_toReal]
  simpa [smul_eq_mul, mul_comm] using
    (poissonPMFReal_secondMoment_hasSum rate).tsum_eq

/-- The identity random variable belongs to `L²` under every real-valued
Poisson law. -/
theorem memLp_id_poissonRealLaw (rate : ℝ≥0) :
    MemLp (fun x : ℝ => x) 2
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate) := by
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw]
  rw [memLp_map_measure_iff (g := fun x : ℝ => x)
    (f := fun n : ℕ => (n : ℝ)) continuous_id.aestronglyMeasurable
      (measurable_of_countable _).aemeasurable]
  change MemLp (fun n : ℕ => (n : ℝ)) 2
    (NumStability.HDP.Scalar.LimitTheorems.poissonLaw rate)
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonLaw]
  exact (memLp_two_iff_integrable_sq
    (measurable_of_countable _).aestronglyMeasurable).2
      (integrable_sq_nat_poisson rate)

/-- The variance of the real-valued Poisson law equals its rate. -/
theorem variance_id_poissonRealLaw (rate : ℝ≥0) :
    Var[fun x : ℝ => x;
      NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate] =
        (rate : ℝ) := by
  let μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate
  have hId : Integrable (fun x : ℝ => x) μ :=
    (memLp_id_poissonRealLaw rate).integrable (by norm_num)
  have hSq : Integrable (fun x : ℝ => x ^ 2) μ :=
    (memLp_id_poissonRealLaw rate).integrable_sq
  have hConst : Integrable (fun _ : ℝ => (rate : ℝ) ^ 2) μ :=
    integrable_const _
  have hLin : Integrable (fun x : ℝ => (2 * (rate : ℝ)) * x) μ :=
    hId.const_mul _
  rw [variance_eq_integral (memLp_id_poissonRealLaw rate).aemeasurable,
    integral_id_poissonRealLaw]
  calc
    (∫ x : ℝ, (x - (rate : ℝ)) ^ 2 ∂μ) =
        ∫ x : ℝ, x ^ 2 - (2 * (rate : ℝ)) * x + (rate : ℝ) ^ 2 ∂μ := by
      congr 1
      funext x
      ring
    _ = (∫ x : ℝ, x ^ 2 ∂μ) -
          (2 * (rate : ℝ)) * (∫ x : ℝ, x ∂μ) + (rate : ℝ) ^ 2 := by
      have hfun :
          (fun x : ℝ => x ^ 2 - (2 * (rate : ℝ)) * x + (rate : ℝ) ^ 2) =
            (fun x : ℝ => x ^ 2) -
              (fun x : ℝ => (2 * (rate : ℝ)) * x) +
                (fun _ : ℝ => (rate : ℝ) ^ 2) := rfl
      rw [hfun]
      change (∫ x : ℝ,
          (((fun y : ℝ => y ^ 2) -
            (fun y : ℝ => (2 * (rate : ℝ)) * y)) x) +
            (fun _ : ℝ => (rate : ℝ) ^ 2) x ∂μ) = _
      rw [integral_add (hSq.sub hLin) hConst]
      simp only [Pi.sub_apply]
      rw [integral_sub hSq hLin, integral_const_mul]
      simp [μ]
    _ = (rate : ℝ) := by
      rw [show (∫ x : ℝ, x ^ 2 ∂μ) = (rate : ℝ) ^ 2 + (rate : ℝ) by
        exact integral_sq_poissonRealLaw rate,
        show (∫ x : ℝ, x ∂μ) = (rate : ℝ) by
          exact integral_id_poissonRealLaw rate]
      ring

/-- A finite sum of independent real-valued Poisson variables is Poisson with
the sum of the rates. This is the finite-sum law bridge between the reusable
Poisson and i.i.d. central-limit APIs. -/
theorem hasLaw_sum_poissonRealLaw
    {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (rate : ι → ℝ≥0)
    (hX : ∀ i, HasLaw (X i)
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw (rate i)) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ) :
    HasLaw (fun ω => ∑ i, X i ω)
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw (∑ i, rate i)) μ := by
  have hMeas : ∀ i, AEMeasurable (X i) μ := fun i => (hX i).aemeasurable
  have hsum_eq : (∑ i, X i) = fun ω => ∑ i, X i ω := by
    funext ω
    simp
  refine { aemeasurable := ?_, map_eq := ?_ }
  · exact Finset.univ.aemeasurable_fun_sum fun i _ => hMeas i
  · rw [← hsum_eq]
    apply Measure.ext_of_charFun
    calc
      MeasureTheory.charFun (μ.map (∑ i, X i)) =
          ∏ i, MeasureTheory.charFun (μ.map (X i)) := by
        exact hIndep.charFun_map_sum_eq_prod hMeas
      _ = ∏ i, MeasureTheory.charFun
          (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw (rate i)) := by
        congr 1
        funext i
        rw [(hX i).map_eq]
      _ = MeasureTheory.charFun
          (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw (∑ i, rate i)) := by
        funext t
        simp only [Finset.prod_apply]
        simp_rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw_charFun]
        rw [← Complex.exp_sum]
        congr 1
        push_cast
        rw [Finset.sum_mul]

/-- The reusable i.i.d. CLT specialized to a sequence of rate-one real
Poisson variables. -/
theorem tendsto_probabilityLaw_normalized_poissonOne_iid
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ)
    (hX : ∀ i, HasLaw (X i)
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw 1) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ) :
    Tendsto (fun n => NumStability.HDP.Scalar.LimitTheorems.probabilityLaw
        (NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum X 1 1 n)
        (NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum_memLp
          X 1 1 (fun i => by
            have hp := memLp_id_poissonRealLaw 1
            rw [← (hX i).map_eq] at hp
            simpa [Function.comp_def] using
              (memLp_map_measure_iff continuous_id.aestronglyMeasurable
                (hX i).aemeasurable).1 hp) n).aemeasurable)
      atTop
      (𝓝 (⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw,
        inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  have hMem : ∀ i, MemLp (X i) 2 μ := by
    intro i
    have hp := memLp_id_poissonRealLaw 1
    rw [← (hX i).map_eq] at hp
    simpa [Function.comp_def] using
      (memLp_map_measure_iff continuous_id.aestronglyMeasurable
        (hX i).aemeasurable).1 hp
  have hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ :=
    fun i => (hX i).identDistrib (hX 0)
  have hMean : ∫ ω, X 0 ω ∂μ = (1 : ℝ) := by
    rw [(hX 0).integral_eq, integral_id_poissonRealLaw]
    norm_num
  have hVariance : Var[X 0; μ] = (1 : ℝ) ^ 2 := by
    rw [(hX 0).variance_eq]
    change Var[(fun x : ℝ => x);
      NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw 1] = (1 : ℝ) ^ 2
    rw [variance_id_poissonRealLaw]
    norm_num
  simpa only using
    (NumStability.HDP.Scalar.LimitTheorems.tendsto_probabilityLaw_normalizedIidSum
      X 1 1 (by norm_num) hMem hIndep hIdent hMean hVariance)

/-- The standardized real Poisson law at a nonnegative rate. At rate zero the
normalizing map is identically zero; that endpoint is irrelevant to the
`atTop` limit. -/
noncomputable def standardizedPoissonLaw (rate : ℝ≥0) : ProbabilityMeasure ℝ :=
  (NumStability.HDP.Scalar.LimitTheorems.poissonRealProbabilityMeasure
    rate).map (by fun_prop : AEMeasurable
      (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw
        rate))

/-- Exact characteristic function of the standardized real Poisson law. -/
theorem standardizedPoissonLaw_charFun (rate : ℝ≥0) (t : ℝ) :
    MeasureTheory.charFun (standardizedPoissonLaw rate : Measure ℝ) t =
      Complex.exp ((rate : ℂ) *
        (Complex.exp ((((t / Real.sqrt (rate : ℝ)) : ℝ) : ℂ) * Complex.I) - 1 -
          (((t / Real.sqrt (rate : ℝ)) : ℝ) : ℂ) * Complex.I)) := by
  let a : ℝ := (Real.sqrt (rate : ℝ))⁻¹
  have hscale :=
    NumStability.HDP.Scalar.LimitTheorems.charFun_probabilityLaw_const_mul
      (μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      (fun x : ℝ => x - (rate : ℝ)) (by fun_prop) a t
  have hcenter :=
    NumStability.HDP.Scalar.LimitTheorems.charFun_probabilityLaw_sub_const
      (μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      id (by fun_prop) (rate : ℝ) (a * t)
  change MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => a * (x - (rate : ℝ)))) t =
    MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => x - (rate : ℝ))) (a * t) at hscale
  change MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => x - (rate : ℝ))) (a * t) =
    MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map id) (a * t) *
        Complex.exp (-(((a * t : ℝ) : ℂ) * (rate : ℂ)) * Complex.I) at hcenter
  change MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))) t = _
  rw [show (Real.sqrt (rate : ℝ))⁻¹ = a by rfl, hscale, hcenter]
  simp only [Measure.map_id, NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw_charFun]
  rw [← Complex.exp_add]
  congr 1
  dsimp [a]
  push_cast
  ring_nf

/-- The family of all standardized Poisson laws is tight. -/
theorem isTight_standardizedPoissonLaw :
    IsTightMeasureSet
      {((p : ProbabilityMeasure ℝ) : Measure ℝ) |
        p ∈ Set.range standardizedPoissonLaw} := by
  apply
    NumStability.HDP.Scalar.LimitTheorems.isTight_probabilityMeasure_range_of_variance_le_one
      standardizedPoissonLaw
  · intro rate
    change MemLp (fun x : ℝ => x) 2
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ))))
    rw [memLp_map_measure_iff
      (f := fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))
      (g := fun x : ℝ => x) continuous_id.aestronglyMeasurable (by fun_prop)]
    simpa [Function.comp_def] using
      ((memLp_id_poissonRealLaw rate).sub (memLp_const (rate : ℝ))).const_mul
        (Real.sqrt (rate : ℝ))⁻¹
  · intro rate
    change ∫ x : ℝ,
      x ∂((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))) = 0
    rw [integral_map
      (μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      (φ := fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))
      (f := fun x : ℝ => x) (by fun_prop) continuous_id.aestronglyMeasurable]
    have hInt : Integrable (fun x : ℝ => x)
        (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate) :=
      (memLp_id_poissonRealLaw rate).integrable (by norm_num)
    rw [integral_const_mul, integral_sub hInt (integrable_const _),
      integral_id_poissonRealLaw]
    simp
  · intro rate
    change Var[(fun x : ℝ => x);
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))] ≤ 1
    change Var[id;
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))] ≤ 1
    rw [variance_id_map
      (X := fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))
      (μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      (by fun_prop)]
    rw [variance_const_mul]
    rw [show Var[(fun x : ℝ => x - (rate : ℝ));
        NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate] =
      Var[(fun x : ℝ => x);
        NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate] by
      exact variance_sub_const continuous_id.aestronglyMeasurable (rate : ℝ)]
    rw [variance_id_poissonRealLaw]
    by_cases hr : rate = 0
    · simp [hr]
    · have hrp : 0 < (rate : ℝ) := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hr)
      have hs : (Real.sqrt (rate : ℝ)) ^ 2 = (rate : ℝ) :=
        Real.sq_sqrt hrp.le
      rw [inv_pow]
      field_simp [Real.sqrt_ne_zero'.mpr hrp]
      nlinarith

/-- Pointwise convergence of the characteristic functions of standardized
Poisson laws to the standard normal characteristic function. -/
theorem tendsto_standardizedPoissonLaw_charFun (t : ℝ) :
    Tendsto (fun rate : ℝ≥0 =>
      MeasureTheory.charFun (standardizedPoissonLaw rate : Measure ℝ) t)
      atTop (𝓝 (Complex.exp (-(t : ℂ) ^ 2 / 2))) := by
  by_cases ht : t = 0
  · subst t
    simp
  · let u : ℝ≥0 → ℝ := fun rate => t / Real.sqrt (rate : ℝ)
    have hcoe : Tendsto (fun rate : ℝ≥0 => (rate : ℝ)) atTop atTop :=
      NNReal.tendsto_coe_atTop.mpr tendsto_id
    have hsqrt : Tendsto (fun rate : ℝ≥0 => Real.sqrt (rate : ℝ)) atTop atTop :=
      Real.tendsto_sqrt_atTop.comp hcoe
    have hu : Tendsto u atTop (𝓝 0) :=
      tendsto_const_nhds.div_atTop hsqrt
    have hune : ∀ᶠ rate : ℝ≥0 in atTop, u rate ≠ 0 := by
      filter_upwards [eventually_gt_atTop (0 : ℝ≥0)] with rate hrate
      exact div_ne_zero ht
        (Real.sqrt_ne_zero'.mpr (NNReal.coe_pos.mpr hrate))
    have huWithin : Tendsto u atTop (𝓝[≠] 0) :=
      tendsto_nhdsWithin_iff.mpr ⟨hu, by simpa using hune⟩
    have hquot : Tendsto
        (fun rate : ℝ≥0 =>
          (Complex.exp (((u rate : ℝ) : ℂ) * Complex.I) - 1 -
            ((u rate : ℝ) : ℂ) * Complex.I) / ((u rate : ℝ) : ℂ) ^ 2)
        atTop (𝓝 (-(1 : ℂ) / 2)) := by
      simpa using
        (NumStability.HDP.Scalar.LimitTheorems.tendsto_cexp_scaled_remainder_div_sq
          1).comp huWithin
    have hscale : Tendsto
        (fun rate : ℝ≥0 => (rate : ℂ) * ((u rate : ℝ) : ℂ) ^ 2)
        atTop (𝓝 ((t : ℂ) ^ 2)) := by
      refine tendsto_const_nhds.congr' ?_
      filter_upwards [eventually_gt_atTop (0 : ℝ≥0)] with rate hrate
      have hsqrt_sq : (Real.sqrt (rate : ℝ)) ^ 2 = (rate : ℝ) :=
        Real.sq_sqrt (NNReal.coe_nonneg rate)
      have hsqrt_sq_c : (Real.sqrt (rate : ℝ) : ℂ) ^ 2 = (rate : ℂ) := by
        exact_mod_cast hsqrt_sq
      have hratec : (rate : ℂ) ≠ 0 := by
        exact_mod_cast (pos_iff_ne_zero.mp hrate)
      dsimp [u]
      push_cast
      rw [div_pow, hsqrt_sq_c]
      field_simp [hratec]
    have hprod := hquot.mul hscale
    have hexponent : Tendsto
        (fun rate : ℝ≥0 => (rate : ℂ) *
          (Complex.exp (((u rate : ℝ) : ℂ) * Complex.I) - 1 -
            ((u rate : ℝ) : ℂ) * Complex.I))
        atTop (𝓝 (-((t : ℂ) ^ 2) / 2)) := by
      have hprod' : Tendsto
          (fun rate : ℝ≥0 =>
            ((Complex.exp (((u rate : ℝ) : ℂ) * Complex.I) - 1 -
                ((u rate : ℝ) : ℂ) * Complex.I) /
              ((u rate : ℝ) : ℂ) ^ 2) *
            ((rate : ℂ) * ((u rate : ℝ) : ℂ) ^ 2))
          atTop (𝓝 (-((t : ℂ) ^ 2) / 2)) := by
        convert hprod using 1
        ring
      refine hprod'.congr' ?_
      filter_upwards [hune] with rate hurate
      have huratec : ((u rate : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hurate
      field_simp [huratec]
    have hexp :=
      (Complex.continuous_exp.tendsto (-((t : ℂ) ^ 2) / 2)).comp hexponent
    simpa only [standardizedPoissonLaw_charFun] using hexp

/-- **Poisson normal approximation.** As the real Poisson rate tends to
infinity, the centered and variance-normalized laws converge weakly to the
standard normal law. -/
theorem tendsto_standardizedPoissonLaw :
    Tendsto standardizedPoissonLaw atTop
      (𝓝 (⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw,
        inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  let Q : ProbabilityMeasure ℝ :=
    ⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw, inferInstance⟩
  apply
    NumStability.HDP.Scalar.LimitTheorems.tendsto_probabilityMeasure_of_charFun_tendsto_of_tight
      standardizedPoissonLaw Q isTight_standardizedPoissonLaw
  intro t
  simpa [Q, NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw_charFun] using
    tendsto_standardizedPoissonLaw_charFun t

/-- The standardized Poisson law along positive natural-number rates. -/
noncomputable def standardizedPoissonNaturalLaw (n : ℕ) : ProbabilityMeasure ℝ :=
  standardizedPoissonLaw ((n + 1 : ℕ) : ℝ≥0)

/-- The standardized Poisson laws at positive natural rates converge weakly
to the standard normal law, by the i.i.d. central limit theorem. -/
theorem tendsto_standardizedPoissonNaturalLaw :
    Tendsto standardizedPoissonNaturalLaw atTop
      (𝓝 (⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw,
        inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  classical
  obtain ⟨Ω, mΩ, μ, X, hXmeas, hXlaw, hIndep, hμ⟩ :=
    ProbabilityTheory.exists_iid ℕ
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw 1)
  letI : MeasurableSpace Ω := mΩ
  letI : IsProbabilityMeasure μ := hμ
  have hclt := tendsto_probabilityLaw_normalized_poissonOne_iid X hXlaw hIndep
  apply hclt.congr'
  filter_upwards with n
  have hsum : HasLaw (fun ω => ∑ i : Fin (n + 1), X i.1 ω)
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw
        ((n + 1 : ℕ) : ℝ≥0)) μ := by
    simpa using hasLaw_sum_poissonRealLaw
      (fun i : Fin (n + 1) => X i.1) (fun _ => (1 : ℝ≥0))
      (fun i => hXlaw i.1)
      (hIndep.precomp (g := fun i : Fin (n + 1) => i.1) Fin.val_injective)
  let f : ℝ → ℝ := fun x =>
    (Real.sqrt (n + 1 : ℝ))⁻¹ * (x - (n + 1 : ℝ))
  have hnorm :
      NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum X 1 1 n =
        f ∘ (fun ω => ∑ i : Fin (n + 1), X i.1 ω) := by
    funext ω
    simp only [NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum, f,
      Function.comp_apply, one_mul, Finset.sum_sub_distrib, Finset.sum_const,
      Finset.card_fin, nsmul_eq_mul]
    push_cast
    ring
  apply ProbabilityMeasure.toMeasure_injective
  simp only [NumStability.HDP.Scalar.LimitTheorems.probabilityLaw,
    standardizedPoissonNaturalLaw, standardizedPoissonLaw,
    NumStability.HDP.Scalar.LimitTheorems.poissonRealProbabilityMeasure,
    ProbabilityMeasure.map, ProbabilityMeasure.coe_mk]
  rw [show (fun x : ℝ =>
      (Real.sqrt ((((n + 1 : ℕ) : ℝ≥0) : ℝ)))⁻¹ *
        (x - ((((n + 1 : ℕ) : ℝ≥0) : ℝ)))) = f by
    funext x
    dsimp [f]
    norm_num]
  rw [hnorm, ← AEMeasurable.map_map_of_aemeasurable
    (by fun_prop : AEMeasurable f
      (μ.map (fun ω => ∑ i : Fin (n + 1), X i.1 ω))) hsum.aemeasurable,
    hsum.map_eq]

end NumStability.HDP.Scalar.PoissonNormal
```

### `ComputationalMathematics.Source.Vershynin.Chapter02.Section03.Exercise08.Signature`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter02/Section03/Exercise08/Signature.lean`
SHA-256: `73c601863ce15f5ee7f2088f4e99037d7b272545967d45b3e86ca2d3900edaf8`

```lean
import ComputationalMathematics.HDP.Scalar.PoissonNormal

/-!
# Frozen contract signature for Exercise 2.3.8

The source asks for the normal approximation to a Poisson variable as its
nonnegative real rate tends to infinity.
-/

noncomputable section

open MeasureTheory Filter
open scoped Topology NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.PoissonNormal

def hdp_02_hex_h2_d3_d8__contract_type : Prop :=
  Tendsto standardizedPoissonLaw atTop
    (𝓝 (⟨standardNormalLaw, inferInstance⟩ : ProbabilityMeasure ℝ))

end NumStability.HDP.Contract
```
