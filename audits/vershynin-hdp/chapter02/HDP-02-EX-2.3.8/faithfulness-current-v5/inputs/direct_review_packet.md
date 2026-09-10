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
