# Declaration dossier for HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction :
    hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract_type
```

## Elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract_type
```

## Fully explicit elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract_type
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Source.Vershynin.Chapter02.Section08.NormalizedRegimes.Signature`
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
- `ComputationalMathematics.HDP.Scalar.SubExponentialCentering` imports: `ComputationalMathematics.HDP.Scalar.SubExponential`
- `ComputationalMathematics.HDP.Scalar.IndependentSums.NormalizedRegimesDiscrepancy` imports: `ComputationalMathematics.HDP.Scalar.SubExponentialExamples`, `ComputationalMathematics.HDP.Scalar.SubExponentialCentering`, `Mathlib.Probability.Independence.Basic`
- `ComputationalMathematics.Source.Vershynin.Chapter02.Section08.NormalizedRegimes.Signature` imports: `ComputationalMathematics.HDP.Scalar.IndependentSums.NormalizedRegimesDiscrepancy`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Contract.hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract_type`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section08.NormalizedRegimes.Signature`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `91a2db18766b0c759c31ec5e0b78f11e3aa61ef0a91173d49dbe6a36dfdb4e94`

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
And (MeasureTheory.IsProbabilityMeasure (ProbabilityTheory.expMeasure 1))
  (And (Measurable NumStability.HDP.Scalar.IndependentSums.Bernstein.centeredScaledExponential)
    (And
      (MeasureTheory.Integrable NumStability.HDP.Scalar.IndependentSums.Bernstein.centeredScaledExponential
        (ProbabilityTheory.expMeasure 1))
      (And
        (Eq
          (MeasureTheory.integral (ProbabilityTheory.expMeasure 1) fun x =>
            NumStability.HDP.Scalar.IndependentSums.Bernstein.centeredScaledExponential x)
          0)
        (And
          (ENNReal.instPartialOrder.lt
            (NumStability.HDP.Scalar.SubExponential.PsiOneGauge (ProbabilityTheory.expMeasure 1)
              NumStability.HDP.Scalar.IndependentSums.Bernstein.centeredScaledExponential)
            instTopENNReal.top)
          (And
            (ProbabilityTheory.iIndepFun
              (fun _u => NumStability.HDP.Scalar.IndependentSums.Bernstein.centeredScaledExponential)
              (ProbabilityTheory.expMeasure 1))
            (Not
              (Exists fun C =>
                And (Real.instLT.lt 0 C)
                  (∀ {t : Real},
                    Real.instLE.le 0 t →
                      Real.instLE.le C t →
                        Real.instLE.le
                          ((ProbabilityTheory.expMeasure 1).real
                            (setOf fun x =>
                              GE.ge (NumStability.HDP.Scalar.IndependentSums.Bernstein.centeredScaledExponential x) t))
                          (instHMul.hMul 2 (Real.exp (Real.instNeg.neg t)))))))))))
```

### D002: `NumStability.HDP.Contract.hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract_type._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section08.NormalizedRegimes.Signature`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `d47d036229f1403c22ff59ee3dd847fa05e158056c43357f447dc17821abd94a`

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

### D003: `NumStability.HDP.Scalar.IndependentSums.Bernstein.centeredScaledExponential`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.IndependentSums.NormalizedRegimesDiscrepancy`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `a1ce97c6b10b54037a0de0ef7312e32cc493909c7cdc041f27e09b57a8899c99`

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
fun x => instHSub.hSub (instHMul.hMul 2 x) 2
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

### D005: `NumStability.HDP.Scalar.IndependentSums.Bernstein.centeredScaledExponential._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.IndependentSums.NormalizedRegimesDiscrepancy`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `03a11e60abeb98652cb646889645c0452ab87c15d87ba770f26fb64c492a56dc`

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

### D006: `NumStability.HDP.Scalar.SubExponential.PsiOneAdmissible`

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

### D007: `NumStability.HDP.Scalar.SubExponential.SubExponentialTailBound._proof_1`

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

### D008: `And`

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

### D009: `ENNReal`

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

### D010: `ENNReal.instPartialOrder`

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

### D011: `Eq`

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

### D012: `Exists`

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

### D013: `GE.ge`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D014: `HMul.hMul`

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

### D015: `InnerProductSpace.toNormedSpace`

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

### D016: `LE.le`

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

### D017: `LT.lt`

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

### D018: `Measurable`

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

### D019: `MeasureTheory.Integrable`

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

### D020: `MeasureTheory.IsProbabilityMeasure`

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

### D021: `MeasureTheory.Measure.real`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D022: `MeasureTheory.integral`

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

### D023: `Neg.neg`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `0c56662a5d917c211c3cb741ca747b4a6710082af615cf071342ef70dee3a2c7`

Type:

```lean
{α : Type u} → [self : Neg α] → α → α
```

Fully explicit type:

```lean
{α : Type u} → [self : Neg.{u} α] → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Neg α] => self.1
```

### D024: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

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

### D025: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D026: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D027: `NormedCommRing.toSeminormedCommRing`

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

### D028: `Not`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D029: `OfNat.ofNat`

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

### D030: `One.toOfNat1`

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

### D031: `PartialOrder.toPreorder`

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

### D032: `Preorder.toLT`

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

### D033: `ProbabilityTheory.expMeasure`

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

### D034: `ProbabilityTheory.iIndepFun`

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

### D035: `PseudoMetricSpace.toUniformSpace`

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

### D036: `RCLike.toInnerProductSpaceReal`

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

### D037: `Real`

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

### D038: `Real.exp`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Complex.Exponential`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D039: `Real.instLE`

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

### D040: `Real.instLT`

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

### D041: `Real.instMul`

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

### D042: `Real.instNatCast`

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

### D043: `Real.instNeg`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `000951397468b3d1f8a2a1cca1de3812bc024916ff842cfd5454811130093b41`

Type:

```lean
Neg Real
```

Fully explicit type:

```lean
Neg.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ neg := Real.neg✝ }
```

### D044: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D045: `Real.instRCLike`

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

### D046: `Real.instZero`

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

### D047: `Real.measurableSpace`

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

### D048: `Real.normedAddCommGroup`

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

### D049: `Real.normedCommRing`

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

### D050: `Real.pseudoMetricSpace`

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

### D051: `SeminormedAddCommGroup.toSeminormedAddGroup`

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

### D052: `SeminormedAddGroup.toContinuousENorm`

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

### D053: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

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

### D054: `Top.top`

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

### D055: `UniformSpace.toTopologicalSpace`

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

### D056: `Unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D057: `Zero.toOfNat0`

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

### D058: `instHMul`

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

### D059: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D060: `instTopENNReal`

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

### D061: `setOf`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D062: `CompleteLinearOrder.toConditionallyCompleteLinearOrderBot`

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

### D063: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

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

### D064: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

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

### D065: `ConditionallyCompleteLinearOrderBot.toConditionallyCompleteLinearOrder`

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

### D066: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf`

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

### D067: `ConditionallyCompletePartialOrderInf.toInfSet`

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

### D068: `ENNReal.instCompleteLinearOrder`

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

### D069: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D070: `HSub.hSub`

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

### D071: `InfSet.sInf`

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

### D072: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

Fully explicit type:

```lean
(α : Type u_7) → Type u_7
```

### D073: `MeasureTheory.Measure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `ba8c23c70f3135407096406cee0b4d7d9f02d088e8b1d1a1e105071821a3a51b`

Type:

```lean
(α : Type u_6) → [MeasurableSpace α] → Type u_6
```

Fully explicit type:

```lean
(α : Type u_6) → [MeasurableSpace.{u_6} α] → Type u_6
```

### D074: `Nat`

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

### D075: `Nat.AtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Init`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `318e11b8f9340f2f451d638786dd4fca470dece62824f4adc3bd18b5289aa911`

Type:

```lean
Nat → Prop
```

Fully explicit type:

```lean
(n : Nat) → Prop
```

### D076: `Real.instSub`

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

### D077: `instAddNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D078: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D079: `instHSub`

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

### D080: `instOfNatNat`

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

### D081: `DivInvMonoid.toDiv`

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

### D082: `ENNReal.toReal`

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

### D083: `HDiv.hDiv`

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

### D084: `Ne`

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

### D085: `Real.instAddGroup`

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

### D086: `Real.instDivInvMonoid`

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

### D087: `Real.lattice`

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

### D088: `abs`

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

### D089: `instHDiv`

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

### D090: `instZeroENNReal`

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

## Complete local imported sources

### `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Remark09.Signature`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter02/Section07/Remark09/Signature.lean`
SHA-256: `35aeb4fb8becd629ae470b7192a5f98e5b3c8a43e7279bcaa0051f34ff08da15`

```lean
import Mathlib.Analysis.Calculus.Taylor
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.MeasureTheory.Measure.Typeclasses.Probability
import Mathlib.Probability.Distributions.Exponential

/-! Frozen proof-free signatures for Remark 2.7.9.

The exact source-facing signature quantifies over every bounded, centered,
unit-variance random variable.  The older two-point witness is retained below as
a compatibility contract for the declaration already exposed by the original
monolithic development.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open ProbabilityTheory
open scoped Topology

namespace NumStability.HDP.Contract

/-- Local analytic and exponential-counterexample clauses used by the complete
source-facing contract for Remark 2.7.9. -/
def hdp_02_hrem_h2_d7_d9_local__contract_type : Prop :=
  (∀ {Ω : Type*} [MeasurableSpace Ω]
      (μ : Measure Ω) [IsProbabilityMeasure μ]
      (X : Ω → ℝ),
      Measurable X →
      (∃ C : ℝ, ∀ ω, |X ω| ≤ C) →
      (∫ ω, X ω ∂μ) = 0 →
      (∫ ω, (X ω) ^ 2 ∂μ) = 1 →
      (fun lam : ℝ =>
        (∫ ω, Real.exp (lam * X ω) ∂μ) - 1 -
          lam * (∫ ω, X ω ∂μ) -
          lam ^ 2 / 2 * (∫ ω, (X ω) ^ 2 ∂μ)) =o[𝓝 (0 : ℝ)]
        (fun lam : ℝ => lam ^ 2)) ∧
  ((fun lam : ℝ => Real.exp (lam ^ 2 / 2) - (1 + lam ^ 2 / 2))
      =o[𝓝 (0 : ℝ)] (fun lam : ℝ => lam ^ 2)) ∧
  (∀ lam : ℝ, 1 ≤ lam →
    ¬ Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1))

/-- Compatibility contract predating the source-faithful universal wrapper. -/
def hdp_02_hrem_h2_d7_d9__contract_type : Prop :=
  ∃ (μ : Measure ℝ) (X : ℝ → ℝ),
    IsProbabilityMeasure μ ∧
    μ = (1 / 2 : ENNReal) • Measure.dirac (-1) +
      (1 / 2 : ENNReal) • Measure.dirac 1 ∧
    X = (fun x : ℝ => x) ∧
    (∫ x, X x ∂μ) = 0 ∧
    (∫ x, (X x) ^ 2 ∂μ) = 1 ∧
    (fun lam : ℝ =>
      (∫ x, Real.exp (lam * X x) ∂μ) - 1 -
        lam * (∫ x, X x ∂μ) -
        lam ^ 2 / 2 * (∫ x, (X x) ^ 2 ∂μ)) =o[𝓝 (0 : ℝ)]
      (fun lam : ℝ => lam ^ 2) ∧
    (∀ lam : ℝ, lam < 1 →
      Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1) ∧
        (∫ x, Real.exp (lam * x) ∂(expMeasure 1)) = (1 - lam)⁻¹) ∧
    (∀ lam : ℝ, 1 ≤ lam →
      ¬ Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1))

end NumStability.HDP.Contract
```

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

### `ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise09.Signature`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter02/Section06/Exercise09/Signature.lean`
SHA-256: `166ed9e0e50353b50e1c785467d3d39feb64961867d554f283b4196872b1066b`

```lean
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Measure.Typeclasses.Probability

/-! Frozen proof-free signature for Exercise 2.6.9.

The witness is the asymmetric two-point law with masses `999/1000` and
`1/1000`; the two `sInf` expressions are the finite-law `ψ₂` gauges. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d6_d9__contract_type : Prop :=
  ∃ (μ : Measure ℝ) (X : ℝ → ℝ),
    IsProbabilityMeasure μ ∧
    μ = (999 / 1000 : ENNReal) • Measure.dirac (-1) +
      (1 / 1000 : ENNReal) • Measure.dirac 4 ∧
    X = (fun x : ℝ => x) ∧
    (∫ x, X x ∂μ) = (999 / 1000 : ℝ) * (-1) + (1 / 1000 : ℝ) * 4 ∧
    sInf {t : ℝ | 0 < t ∧
      (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / t) ^ 2) +
        (1 / 1000 : ℝ) * Real.exp ((4 / t) ^ 2) ≤ 2} <
      sInf {t : ℝ | 0 < t ∧
        (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / 200 / t) ^ 2) +
          (1 / 1000 : ℝ) * Real.exp ((999 / 200 / t) ^ 2) ≤ 2}

end NumStability.HDP.Contract
```

### `ComputationalMathematics.HDP.Scalar.SubGaussian`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/SubGaussian.lean`
SHA-256: `8c6a030069da9c378615f334001a31853cd00dd06ca9f95d644569711ead0506`

```lean
import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Probability.Distributions.Gaussian.HasGaussianLaw.Independence
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.Analysis.SpecialFunctions.Gamma.Beta
import Mathlib.Analysis.SpecialFunctions.Stirling
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Series
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.Convex.SpecificFunctions.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Gamma
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.Probability.Moments.IntegrableExpMul
import Mathlib.Tactic
import ComputationalMathematics.HDP.Scalar.Preliminaries
import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding
import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise09.Signature

/-!
# Standard-normal MGF

This module proves the standard-normal moment-generating-function identity
used by the Chapter 2 sub-Gaussian development.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open Filter
open scoped Topology
open scoped BigOperators
open scoped NNReal ENNReal

namespace NumStability.HDP.Scalar.SubGaussian

/-- The standard-normal MGF is `exp (lam ^ 2 / 2)`. -/
theorem standardNormalMGF (lam : ℝ) :
    ∫ x, Real.exp (lam * x) ∂(gaussianReal 0 1) =
      Real.exp (lam ^ 2 / 2) := by
  rw [integral_gaussianReal_eq_integral_smul (μ := (0 : ℝ)) (v := (1 : NNReal))
    (f := fun x : ℝ => Real.exp (lam * x)) (by norm_num)]
  change (∫ x : ℝ, gaussianPDFReal 0 1 x * Real.exp (lam * x)) =
    Real.exp (lam ^ 2 / 2)
  have hpdf (x : ℝ) :
      gaussianPDFReal 0 1 x =
        (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
    simp [gaussianPDFReal]
  simp_rw [hpdf]
  have hshift :
      ∫ x : ℝ, Real.exp (-(x - lam) ^ 2 / 2) =
        ∫ x : ℝ, Real.exp (-x ^ 2 / 2) :=
    integral_sub_right_eq_self (fun x : ℝ => Real.exp (-x ^ 2 / 2)) lam
  have hpoint :
      (fun x : ℝ =>
        (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) *
          Real.exp (lam * x)) =
        (fun x : ℝ =>
          Real.exp (lam ^ 2 / 2) *
            ((Real.sqrt (2 * Real.pi))⁻¹ *
              Real.exp (-(x - lam) ^ 2 / 2))) := by
    funext x
    calc
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) * Real.exp (lam * x) =
          (Real.sqrt (2 * Real.pi))⁻¹ *
            (Real.exp (-x ^ 2 / 2) * Real.exp (lam * x)) := by ring
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
            Real.exp (-x ^ 2 / 2 + lam * x) := by
              rw [Real.exp_add]
      _ = Real.exp (lam ^ 2 / 2) *
            ((Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x - lam) ^ 2 / 2)) := by
              calc
                (Real.sqrt (2 * Real.pi))⁻¹ *
                    Real.exp (-x ^ 2 / 2 + lam * x) =
                    (Real.sqrt (2 * Real.pi))⁻¹ *
                      Real.exp (lam ^ 2 / 2 + (-(x - lam) ^ 2 / 2)) := by
                        congr 1
                        congr 1
                        nlinarith
                _ = Real.exp (lam ^ 2 / 2) *
                      ((Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x - lam) ^ 2 / 2)) := by
                        rw [Real.exp_add]
                        ring
  have hgauss :
      ∫ x : ℝ, Real.exp (-x ^ 2 / 2) = Real.sqrt (Real.pi / (1 / 2)) := by
    have hnorm := ProbabilityTheory.integral_gaussianPDFReal_eq_one (0 : ℝ)
      (v := (1 : NNReal)) (by norm_num)
    simp_rw [hpdf] at hnorm
    rw [integral_const_mul] at hnorm
    norm_num [Real.sqrt_eq_rpow] at hnorm ⊢
    field_simp at hnorm ⊢
    nlinarith
  rw [hpoint, integral_const_mul, integral_const_mul, hshift, hgauss]
  norm_num [Real.sqrt_eq_rpow]
  field_simp

private structure StandardNormalSquareMGFProviders where
  hVar : gaussianReal 0 1 = volume.withDensity (gaussianPDF 0 1)
  hPdfMeas : Measurable (gaussianPDF 0 1)
  hPdfTop : ∀ x : ℝ, gaussianPDF 0 1 x < ⊤
  hToReal : ∀ x : ℝ, (gaussianPDF 0 1 x).toReal = gaussianPDFReal 0 1 x
  hWithDensity : ∀ {g : ℝ → ℝ},
    Integrable g (volume.withDensity (gaussianPDF 0 1)) ↔
      Integrable (fun x => g x * (gaussianPDF 0 1 x).toReal) volume
  hIntegral : ∀ {f : ℝ → ℝ},
    (∫ x, f x ∂(gaussianReal 0 1)) =
      ∫ x, gaussianPDFReal 0 1 x * f x
  hConstMul : ∀ (r : ℝ) (f : ℝ → ℝ),
    (∫ x, r * f x) = r * (∫ x, f x)
  hExp : ∀ {b : ℝ}, 0 < b →
    Integrable (fun x : ℝ => Real.exp (-b * x ^ 2)) volume
  hGaussian : ∀ (b : ℝ),
    ∫ x : ℝ, Real.exp (-b * x ^ 2) = Real.sqrt (Real.pi / b)
  hIff : ∀ {b : ℝ},
    Integrable (fun x : ℝ => Real.exp (-b * x ^ 2)) volume ↔ 0 < b

private theorem standardNormalSquareMGF_integrable
    (lam : ℝ) (hsmall : |lam| < (Real.sqrt 2)⁻¹)
    (p : StandardNormalSquareMGFProviders) :
    Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) := by
  have hsq : lam ^ 2 < (1 / 2 : ℝ) := by
    have hinv : 0 ≤ (Real.sqrt 2)⁻¹ := by positivity
    have hsq' : lam ^ 2 < ((Real.sqrt 2)⁻¹) ^ 2 := by
      calc
        lam ^ 2 = |lam| ^ 2 := (sq_abs lam).symm
        _ < |(Real.sqrt 2)⁻¹| ^ 2 :=
          (sq_lt_sq₀ (abs_nonneg lam) (abs_nonneg ((Real.sqrt 2)⁻¹))).2
            (by simpa [abs_of_nonneg hinv] using hsmall)
        _ = ((Real.sqrt 2)⁻¹) ^ 2 := sq_abs _
    simpa [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)] using hsq'
  have hb : 0 < (1 / 2 : ℝ) - lam ^ 2 := sub_pos.mpr hsq
  rw [p.hVar]
  apply (p.hWithDensity (g := fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2))).2
  simp only [p.hToReal]
  have htarget : Integrable (fun x : ℝ => gaussianPDFReal 0 1 x *
      Real.exp (lam ^ 2 * x ^ 2)) volume := by
    rw [show (fun x : ℝ => gaussianPDFReal 0 1 x * Real.exp (lam ^ 2 * x ^ 2)) =
      (fun x => (Real.sqrt (2 * Real.pi))⁻¹ *
        Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2)) by
    funext x
    have hpdf (x : ℝ) : gaussianPDFReal 0 1 x =
        (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
      simp [gaussianPDFReal]
    rw [hpdf]
    calc
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) *
          Real.exp (lam ^ 2 * x ^ 2) =
          (Real.sqrt (2 * Real.pi))⁻¹ *
            (Real.exp (-x ^ 2 / 2) * Real.exp (lam ^ 2 * x ^ 2)) := by ring
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-x ^ 2 / 2 + lam ^ 2 * x ^ 2) := by rw [Real.exp_add]
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2) := by
            congr 2
            ring]
    exact (p.hExp hb).const_mul _
  simpa only [mul_comm] using htarget

private theorem standardNormalSquareMGF_value
    (lam : ℝ) (hsmall : |lam| < (Real.sqrt 2)⁻¹)
    (p : StandardNormalSquareMGFProviders) :
    ∫ x : ℝ, Real.exp (lam ^ 2 * x ^ 2) ∂(gaussianReal 0 1) =
      (Real.sqrt (1 - 2 * lam ^ 2))⁻¹ := by
  have hsq : lam ^ 2 < (1 / 2 : ℝ) := by
    have hinv : 0 ≤ (Real.sqrt 2)⁻¹ := by positivity
    have hsq' : lam ^ 2 < ((Real.sqrt 2)⁻¹) ^ 2 := by
      calc
        lam ^ 2 = |lam| ^ 2 := (sq_abs lam).symm
        _ < |(Real.sqrt 2)⁻¹| ^ 2 :=
          (sq_lt_sq₀ (abs_nonneg lam) (abs_nonneg ((Real.sqrt 2)⁻¹))).2
            (by simpa [abs_of_nonneg hinv] using hsmall)
        _ = ((Real.sqrt 2)⁻¹) ^ 2 := sq_abs _
    simpa [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)] using hsq'
  have hb : 0 < (1 / 2 : ℝ) - lam ^ 2 := sub_pos.mpr hsq
  have hq : 0 < 1 - 2 * lam ^ 2 := by nlinarith
  rw [p.hIntegral]
  have hpdf (x : ℝ) : gaussianPDFReal 0 1 x =
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
    simp [gaussianPDFReal]
  simp_rw [hpdf]
  rw [show (fun x : ℝ => (Real.sqrt (2 * Real.pi))⁻¹ *
      Real.exp (-x ^ 2 / 2) * Real.exp (lam ^ 2 * x ^ 2)) =
      (fun x => (Real.sqrt (2 * Real.pi))⁻¹ *
        Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2)) by
    funext x
    calc
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) *
          Real.exp (lam ^ 2 * x ^ 2) =
          (Real.sqrt (2 * Real.pi))⁻¹ *
            (Real.exp (-x ^ 2 / 2) * Real.exp (lam ^ 2 * x ^ 2)) := by ring
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-x ^ 2 / 2 + lam ^ 2 * x ^ 2) := by rw [Real.exp_add]
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2) := by
            congr 2
            ring]
  rw [p.hConstMul, p.hGaussian]
  apply (sq_eq_sq₀ (by positivity) (by positivity)).1
  rw [mul_pow]
  simp only [inv_pow]
  rw [Real.sq_sqrt (by positivity : (0 : ℝ) ≤ 2 * Real.pi),
    Real.sq_sqrt (div_nonneg (by positivity : (0 : ℝ) ≤ Real.pi) hb.le),
    Real.sq_sqrt hq.le]
  field_simp

private theorem standardNormalSquareMGF_not_integrable
    (lam : ℝ) (hlarge : (Real.sqrt 2)⁻¹ ≤ |lam|)
    (p : StandardNormalSquareMGFProviders) :
    ¬ Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) := by
  intro hInt
  rw [p.hVar] at hInt
  have hvol := (p.hWithDensity (g := fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2))).1 hInt
  simp only [p.hToReal] at hvol
  have hvol' : Integrable (fun x : ℝ => gaussianPDFReal 0 1 x *
      Real.exp (lam ^ 2 * x ^ 2)) volume := by
    simpa only [mul_comm] using hvol
  have hsq : (1 / 2 : ℝ) ≤ lam ^ 2 := by
    have hinv : 0 ≤ (Real.sqrt 2)⁻¹ := by positivity
    have hsq' : ((Real.sqrt 2)⁻¹) ^ 2 ≤ |lam| ^ 2 := by
      calc
        ((Real.sqrt 2)⁻¹) ^ 2 = |(Real.sqrt 2)⁻¹| ^ 2 := (sq_abs _).symm
        _ ≤ |lam| ^ 2 :=
          (sq_le_sq₀ (abs_nonneg ((Real.sqrt 2)⁻¹)) (abs_nonneg lam)).2
            (by simpa [abs_of_nonneg hinv] using hlarge)
    simpa [abs_sq, Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)] using hsq'
  have hrew : (fun x : ℝ => gaussianPDFReal 0 1 x * Real.exp (lam ^ 2 * x ^ 2)) =
      (fun x => (Real.sqrt (2 * Real.pi))⁻¹ *
        Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2)) := by
    funext x
    have hpdf (x : ℝ) : gaussianPDFReal 0 1 x =
        (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
      simp [gaussianPDFReal]
    rw [hpdf]
    calc
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) *
          Real.exp (lam ^ 2 * x ^ 2) =
          (Real.sqrt (2 * Real.pi))⁻¹ *
            (Real.exp (-x ^ 2 / 2) * Real.exp (lam ^ 2 * x ^ 2)) := by ring
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-x ^ 2 / 2 + lam ^ 2 * x ^ 2) := by rw [Real.exp_add]
      _ = (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2) := by
            congr 2
            ring
  rw [hrew] at hvol'
  have hbad : ¬ Integrable (fun x : ℝ =>
      Real.exp (-((1 / 2 : ℝ) - lam ^ 2) * x ^ 2)) := by
    rw [p.hIff]
    exact not_lt_of_ge (sub_nonpos.mpr hsq)
  have hc : (Real.sqrt (2 * Real.pi))⁻¹ ≠ 0 := by positivity
  exact hbad ((integrable_const_mul_iff (isUnit_iff_ne_zero.mpr hc) _).mp hvol')

/-! Exercise 2.5.5(a): the standard normal square-MGF is finite exactly on
the neighborhood `|lam| < 1 / sqrt 2`, where it equals the displayed inverse
square-root formula, and is non-integrable at and beyond the boundary. -/
theorem standardNormalSquareMGF (lam : ℝ) :
    (|lam| < (Real.sqrt 2)⁻¹ →
      Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) ∧
        (∫ x : ℝ, Real.exp (lam ^ 2 * x ^ 2) ∂(gaussianReal 0 1)) =
          (Real.sqrt (1 - 2 * lam ^ 2))⁻¹) ∧
    ((Real.sqrt 2)⁻¹ ≤ |lam| →
      ¬ Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1)) := by
  let p : StandardNormalSquareMGFProviders :=
    { hVar := ProbabilityTheory.gaussianReal_of_var_ne_zero 0 (by norm_num)
      hPdfMeas := ProbabilityTheory.measurable_gaussianPDF 0 1
      hPdfTop := fun x => ProbabilityTheory.gaussianPDF_lt_top
      hToReal := fun x => ProbabilityTheory.toReal_gaussianPDF x
      hWithDensity := by
        intro g
        exact (integrable_withDensity_iff
          (ProbabilityTheory.measurable_gaussianPDF 0 1)
          (ae_of_all _ (fun x => ProbabilityTheory.gaussianPDF_lt_top)))
      hIntegral := by
        intro f
        simpa only [smul_eq_mul] using
          (ProbabilityTheory.integral_gaussianReal_eq_integral_smul
            (μ := (0 : ℝ)) (v := (1 : NNReal)) (f := f) (by norm_num))
      hConstMul := MeasureTheory.integral_const_mul
      hExp := _root_.integrable_exp_neg_mul_sq
      hGaussian := _root_.integral_gaussian
      hIff := _root_.integrable_exp_neg_mul_sq_iff }
  constructor
  · intro hsmall
    exact ⟨standardNormalSquareMGF_integrable lam hsmall
        p,
      standardNormalSquareMGF_value lam hsmall p⟩
  · intro hlarge
    exact standardNormalSquareMGF_not_integrable lam hlarge p

/-! Exercise 2.5.1: exact standard-normal `Lᵖ` moments and a uniform
`O(√p)` estimate.  The norm statement uses Mathlib's root-free `eLpNorm'`
representation, while the growth companion exposes the equivalent real
integral form used by the source calculation. -/
theorem standardNormalLpNorm (p : ℝ) (hp : 1 ≤ p) :
    (eLpNorm' (fun x : ℝ => x) p (gaussianReal 0 1)).toReal =
      (2 ^ (p / 2) * Real.Gamma ((1 + p) / 2) / Real.Gamma (1 / 2)) ^ (1 / p) := by
  have hp0 : 0 < p := lt_of_lt_of_le zero_lt_one hp
  have hpm : 0 ≤ p := hp0.le
  have hInt : Integrable (fun x : ℝ => |x| ^ p) (gaussianReal 0 1) :=
    integrable_rpow_abs_of_integrable_exp_mul (t := (1 : ℝ)) one_ne_zero
      (integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) 1)
      (integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) (-1)) hpm
  have hnonneg : 0 ≤ᶠ[ae (gaussianReal 0 1)] (fun x : ℝ => |x| ^ p) :=
    Filter.Eventually.of_forall (fun x => Real.rpow_nonneg (abs_nonneg x) p)
  have hlin :
      (∫⁻ x : ℝ, ‖(fun y : ℝ => y) x‖ₑ ^ p ∂(gaussianReal 0 1)) =
        ENNReal.ofReal (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) := by
    calc
      (∫⁻ x : ℝ, ‖(fun y : ℝ => y) x‖ₑ ^ p ∂(gaussianReal 0 1)) =
          ∫⁻ x : ℝ, ENNReal.ofReal (|x| ^ p) ∂(gaussianReal 0 1) := by
            apply lintegral_congr
            intro x
            rw [Real.enorm_eq_ofReal_abs]
            rw [ENNReal.ofReal_rpow_of_nonneg (abs_nonneg x) hpm]
      _ = ENNReal.ofReal (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) :=
        (MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt hnonneg).symm
  rw [MeasureTheory.eLpNorm'_eq_lintegral_enorm, hlin, ← ENNReal.toReal_rpow,
    ENNReal.toReal_ofReal (integral_nonneg (fun x =>
      Real.rpow_nonneg (abs_nonneg x) p))]
  congr 1
  rw [ProbabilityTheory.integral_gaussianReal_eq_integral_smul (μ := (0 : ℝ))
    (v := (1 : NNReal)) (f := fun x : ℝ => |x| ^ p) (by norm_num)]
  simp_rw [smul_eq_mul]
  rw [show (fun x : ℝ =>
      gaussianPDFReal 0 1 x * |x| ^ p) =
      (fun x : ℝ =>
        (Real.sqrt (2 * Real.pi))⁻¹ *
          (|x| ^ p * Real.exp (-x ^ 2 / 2))) by
    funext x
    have hpdf :
        gaussianPDFReal 0 1 x =
          (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-x ^ 2 / 2) := by
      simp [gaussianPDFReal]
    rw [hpdf]
    ring]
  rw [integral_const_mul]
  have habs :
      (∫ x : ℝ, |x| ^ p * Real.exp (-x ^ 2 / 2)) =
        2 * ∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-x ^ 2 / 2) := by
    calc
      (∫ x : ℝ, |x| ^ p * Real.exp (-x ^ 2 / 2)) =
          ∫ x : ℝ, (|x| ^ p * Real.exp (-|x| ^ 2 / 2)) := by
            apply integral_congr_ae
            filter_upwards [] with x
            rw [sq_abs]
      _ = 2 * ∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-x ^ 2 / 2) := by
        exact integral_comp_abs (f := fun x : ℝ =>
          x ^ p * Real.exp (-x ^ 2 / 2))
  rw [habs]
  have hgamma := integral_rpow_mul_exp_neg_mul_rpow (p := (2 : ℝ))
    (q := p) (b := (1 / 2 : ℝ)) (by norm_num) (by linarith) (by norm_num)
  have hgamma' :
      ∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-x ^ 2 / 2) =
        (1 / 2) ^ (-(p + 1) / 2) * (1 / 2) * Real.Gamma ((p + 1) / 2) := by
    calc
      (∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-x ^ 2 / 2)) =
          ∫ x : ℝ in Set.Ioi 0, x ^ p * Real.exp (-(1 / 2) * x ^ 2) := by
            apply setIntegral_congr_fun measurableSet_Ioi
            intro x hx
            dsimp
            rw [show -x ^ 2 / 2 = -(1 / 2) * x ^ 2 by ring]
            have hx2 : x ^ (2 : ℝ) = x ^ (2 : ℕ) := by
              norm_num [Real.rpow_natCast]
            rw [hx2]
      _ = _ := hgamma
  rw [hgamma']
  have hsqrt : 0 < Real.sqrt (2 * Real.pi) := by positivity
  have hgamma0 : 0 < Real.Gamma (1 / 2) :=
    Real.Gamma_pos_of_pos (by norm_num)
  have hgammaP : 0 < Real.Gamma ((p + 1) / 2) :=
    Real.Gamma_pos_of_pos (by linarith)
  rw [show (1 + p) / 2 = (p + 1) / 2 by ring]
  have hpi : Real.Gamma (1 / 2) = Real.sqrt Real.pi := by
    exact Real.Gamma_one_half_eq
  rw [hpi]
  field_simp [hsqrt.ne', hgamma0.ne']
  rw [show (1 / 2 : ℝ) ^ (-((p + 1) / 2)) =
      2 ^ ((p + 1) / 2) by
    rw [show (1 / 2 : ℝ) = (2 : ℝ)⁻¹ by ring,
      Real.inv_rpow (by positivity : (0 : ℝ) ≤ 2),
      Real.rpow_neg (by positivity : (0 : ℝ) ≤ 2)]
    simp]
  rw [Real.sqrt_mul (by norm_num : (0 : ℝ) ≤ 2)]
  simp only [Real.sqrt_eq_rpow]
  rw [show (p + 1) / 2 = p / 2 + 1 / 2 by ring,
    Real.rpow_add (by norm_num : (0 : ℝ) < 2)]
  ring

theorem standardNormalLpNormGrowth :
    ∃ C : ℝ, 0 < C ∧
      ∀ p : ℝ, 1 ≤ p →
        (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) ^ (1 / p) ≤ C * Real.sqrt p := by
  refine ⟨2 * Real.exp 1, by positivity, ?_⟩
  intro p hp
  have hp0 : 0 < p := lt_of_lt_of_le zero_lt_one hp
  have hpm : 0 ≤ p := hp0.le
  have hq : 0 < Real.sqrt p := Real.sqrt_pos.2 hp0
  have hq2 : (Real.sqrt p) ^ 2 = p := Real.sq_sqrt hpm
  have hdiv : p / Real.sqrt p = Real.sqrt p := by
    apply (div_eq_iff hq.ne').2
    nlinarith [hq2]
  have hInt : Integrable (fun x : ℝ => |x| ^ p) (gaussianReal 0 1) :=
    integrable_rpow_abs_of_integrable_exp_mul (t := (1 : ℝ)) one_ne_zero
      (integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) 1)
      (integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) (-1)) hpm
  have hplus : Integrable (fun x : ℝ => Real.exp (Real.sqrt p * x))
      (gaussianReal 0 1) :=
    integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) _
  have hminus : Integrable (fun x : ℝ => Real.exp (-Real.sqrt p * x))
      (gaussianReal 0 1) :=
    integrable_exp_mul_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal)) _
  have hsum : Integrable (fun x : ℝ =>
      Real.exp (Real.sqrt p * x) + Real.exp (-Real.sqrt p * x))
      (gaussianReal 0 1) := hplus.add hminus
  have hpoint : ∀ x : ℝ, |x| ^ p ≤
      (p / Real.sqrt p) ^ p *
        (Real.exp (Real.sqrt p * x) + Real.exp (-Real.sqrt p * x)) := by
    intro x
    have h := rpow_abs_le_mul_max_exp x hpm hq.ne'
    rw [abs_of_pos hq] at h
    calc
      |x| ^ p ≤ (p / Real.sqrt p) ^ p *
          max (Real.exp (Real.sqrt p * x)) (Real.exp (-Real.sqrt p * x)) := by
            simpa using h
      _ ≤ (p / Real.sqrt p) ^ p *
          (Real.exp (Real.sqrt p * x) + Real.exp (-Real.sqrt p * x)) := by
            apply mul_le_mul_of_nonneg_left
            · exact max_le
                (le_add_of_nonneg_right (Real.exp_nonneg _))
                (le_add_of_nonneg_left (Real.exp_nonneg _))
            · positivity
  have hprod : Integrable (fun x : ℝ =>
      (p / Real.sqrt p) ^ p *
        (Real.exp (Real.sqrt p * x) + Real.exp (-Real.sqrt p * x)))
      (gaussianReal 0 1) := hsum.const_mul _
  have hbound := integral_mono_ae hInt hprod
    (Filter.Eventually.of_forall hpoint)
  have hsumEval :
      (∫ x : ℝ, Real.exp (Real.sqrt p * x) +
        Real.exp (-Real.sqrt p * x) ∂(gaussianReal 0 1)) =
        2 * Real.exp (p / 2) := by
    rw [integral_add hplus hminus, standardNormalMGF, standardNormalMGF]
    simp [hq2]
    ring
  have hbound' :
      (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) ≤
        (Real.sqrt p) ^ p * (2 * Real.exp (p / 2)) := by
    calc
      (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) ≤
          (p / Real.sqrt p) ^ p *
            (∫ x : ℝ, Real.exp (Real.sqrt p * x) +
              Real.exp (-Real.sqrt p * x) ∂(gaussianReal 0 1)) := by
        simpa [integral_const_mul] using hbound
      _ = (Real.sqrt p) ^ p * (2 * Real.exp (p / 2)) := by
        rw [hsumEval, hdiv]
  have hB : 2 * Real.exp (p / 2) ≤ (2 * Real.exp 1) ^ p := by
    have htwo : (2 : ℝ) ≤ 2 ^ p := by
      simpa using Real.rpow_le_rpow_of_exponent_le (x := (2 : ℝ))
        (y := (1 : ℝ)) (z := p) (by norm_num) hp
    have hexp : Real.exp (p / 2) ≤ Real.exp p := by
      exact Real.exp_le_exp.2 (by linarith)
    calc
      2 * Real.exp (p / 2) ≤ 2 ^ p * Real.exp p :=
        mul_le_mul htwo hexp (by positivity) (by positivity)
      _ = (2 * Real.exp 1) ^ p := by
        rw [Real.mul_rpow (by norm_num) (by positivity), Real.exp_one_rpow]
  have hroot := Real.rpow_le_rpow
    (integral_nonneg (fun x => Real.rpow_nonneg (abs_nonneg x) p)) hbound'
      (one_div_pos.mpr hp0).le
  calc
    (∫ x : ℝ, |x| ^ p ∂(gaussianReal 0 1)) ^ (1 / p) ≤
        ((Real.sqrt p) ^ p * (2 * Real.exp (p / 2))) ^ (1 / p) := hroot
    _ = Real.sqrt p * (2 * Real.exp (p / 2)) ^ (1 / p) := by
      rw [Real.mul_rpow (by positivity : (0 : ℝ) ≤ (Real.sqrt p) ^ p)
        (by positivity), ← Real.rpow_mul hq.le]
      congr 1
      field_simp
      simp
    _ ≤ 2 * Real.exp 1 * Real.sqrt p := by
      have hBroot : (2 * Real.exp (p / 2)) ^ (1 / p) ≤
          ((2 * Real.exp 1) ^ p) ^ (1 / p) :=
        Real.rpow_le_rpow (by positivity) hB (one_div_pos.mpr hp0).le
      have hCroot : ((2 * Real.exp 1) ^ p) ^ (1 / p) =
          2 * Real.exp 1 := by
        rw [← Real.rpow_mul (by positivity : (0 : ℝ) ≤ 2 * Real.exp 1)]
        field_simp
        simp
      rw [hCroot] at hBroot
      calc
        Real.sqrt p * (2 * Real.exp (p / 2)) ^ (1 / p) ≤
            Real.sqrt p * (2 * Real.exp 1) :=
          mul_le_mul_of_nonneg_left hBroot hq.le
        _ = 2 * Real.exp 1 * Real.sqrt p := by ring

/-! A coarse universal Gamma estimate used by the tail-to-moment conversion. -/
theorem gammaUpperBound {x : ℝ} (hx : 1 / 2 ≤ x) :
    Real.Gamma x ≤ 4 * x ^ x := by
  have hxpos : 0 < x := by linarith
  by_cases hx1 : x ≤ 1
  · have hgamma : Real.Gamma x ≤ Real.Gamma (1 / 2) :=
      Real.Gamma_strictAntiOn_Ioc.antitoneOn
        (by norm_num)
        (by exact ⟨hxpos, hx1⟩)
        hx
    have hpow : x ≤ x ^ x := by
      have h := Real.rpow_le_rpow_of_exponent_ge
        (x := x) (y := (1 : ℝ)) (z := x) hxpos hx1 hx1
      simpa [Real.rpow_one] using h
    rw [Real.Gamma_one_half_eq] at hgamma
    have hsqrt : Real.sqrt Real.pi ≤ 2 := by
      rw [Real.sqrt_le_iff]
      constructor <;> nlinarith [Real.pi_le_four]
    nlinarith
  · have hxgt : 1 < x := lt_of_not_ge hx1
    by_cases hx2 : x ≤ 2
    · have hconv : ConvexOn ℝ (Set.Ioi 0) Real.Gamma := Real.convexOn_Gamma
      rcases hconv with ⟨_, hineq⟩
      have h := hineq (x := (1 : ℝ)) (y := (2 : ℝ))
          (show (1 : ℝ) ∈ Set.Ioi 0 by norm_num)
          (show (2 : ℝ) ∈ Set.Ioi 0 by norm_num)
          (a := 2 - x) (b := x - 1)
          (by linarith) (by linarith) (by ring)
      have hgamma : Real.Gamma x ≤ 1 := by
        have harg : (2 - x) • (1 : ℝ) + (x - 1) • (2 : ℝ) = x := by
          simp [smul_eq_mul]
          ring
        have hrhs : (2 - x) • Real.Gamma (1 : ℝ) +
            (x - 1) • Real.Gamma (2 : ℝ) = 1 := by
          rw [Real.Gamma_one, Real.Gamma_two]
          simp [smul_eq_mul]
          ring
        rw [← harg]
        exact h.trans_eq hrhs
      have hpow : 1 ≤ x ^ x := Real.one_le_rpow (le_of_lt hxgt) (by positivity)
      nlinarith
    · have hxgt2 : 2 < x := lt_of_not_ge hx2
      let n : ℕ := Nat.floor x
      have hnle : (n : ℝ) ≤ x := by
        dsimp [n]
        exact Nat.floor_le hxpos.le
      have hxlt : x < (n : ℝ) + 1 := by
        dsimp [n]
        exact Nat.lt_floor_add_one x
      have hn2 : 2 ≤ n := by
        by_contra hn
        have hn1 : n ≤ 1 := by omega
        have hn1' : (n : ℝ) ≤ 1 := by exact_mod_cast hn1
        nlinarith
      have hconv : ConvexOn ℝ (Set.Ioi 0) Real.Gamma := Real.convexOn_Gamma
      rcases hconv with ⟨_, hineq⟩
      have h := hineq (x := (n : ℝ)) (y := (n : ℝ) + 1)
          (show (n : ℝ) ∈ Set.Ioi 0 by
            exact Set.mem_Ioi.mpr (by exact_mod_cast (show 0 < n by omega)))
          (show (n : ℝ) + 1 ∈ Set.Ioi 0 by
            exact Set.mem_Ioi.mpr (by positivity))
          (a := (n : ℝ) + 1 - x) (b := x - (n : ℝ))
          (by linarith) (by linarith) (by ring)
      have hmono : Real.Gamma (n : ℝ) ≤ Real.Gamma ((n : ℝ) + 1) := by
        apply Real.Gamma_strictMonoOn_Ici.monotoneOn
        · exact Set.mem_Ici.mpr (by exact_mod_cast hn2)
        · exact Set.mem_Ici.mpr (by exact_mod_cast (show 2 ≤ n + 1 by omega))
        · linarith
      have hgamma : Real.Gamma x ≤ Real.Gamma ((n : ℝ) + 1) := by
        calc
          Real.Gamma x ≤
              ((n : ℝ) + 1 - x) * Real.Gamma (n : ℝ) +
                (x - (n : ℝ)) * Real.Gamma ((n : ℝ) + 1) := by
            have harg : ((n : ℝ) + 1 - x) • (n : ℝ) +
                (x - (n : ℝ)) • ((n : ℝ) + 1) = x := by
              simp [smul_eq_mul]
              ring
            calc
              Real.Gamma x = Real.Gamma
                  (((n : ℝ) + 1 - x) • (n : ℝ) +
                    (x - (n : ℝ)) • ((n : ℝ) + 1)) := congrArg Real.Gamma harg.symm
              _ ≤ ((n : ℝ) + 1 - x) • Real.Gamma (n : ℝ) +
                    (x - (n : ℝ)) • Real.Gamma ((n : ℝ) + 1) := h
              _ = ((n : ℝ) + 1 - x) * Real.Gamma (n : ℝ) +
                    (x - (n : ℝ)) * Real.Gamma ((n : ℝ) + 1) := by
                simp [smul_eq_mul]
          _ ≤ ((n : ℝ) + 1 - x) * Real.Gamma ((n : ℝ) + 1) +
                (x - (n : ℝ)) * Real.Gamma ((n : ℝ) + 1) := by
            gcongr
            linarith
          _ = Real.Gamma ((n : ℝ) + 1) := by
            rw [← add_mul]
            ring
      rw [Real.Gamma_nat_eq_factorial n] at hgamma
      have hfac : (n.factorial : ℝ) ≤ (n : ℝ) ^ n := by
        exact_mod_cast Nat.factorial_le_pow n
      have hbase : (n : ℝ) ^ n ≤ x ^ n := by
        gcongr
      have hexp : x ^ (n : ℝ) ≤ x ^ x := by
        apply Real.rpow_le_rpow_of_exponent_le
        · linarith
        · exact hnle
      have hpow : (n : ℝ) ^ n ≤ x ^ x := by
        calc
          (n : ℝ) ^ n ≤ x ^ n := hbase
          _ = x ^ (n : ℝ) := by rw [Real.rpow_natCast]
          _ ≤ x ^ x := hexp
      nlinarith

/-- The root-free integral form of the usual `Lᵖ` moment-growth hypothesis. -/
def LpMomentGrowth {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (K : ℝ) : Prop :=
  AEMeasurable X μ ∧
    ∀ p : ℝ, 1 ≤ p →
      Integrable (fun ω => |X ω| ^ p) μ ∧
        (∫ ω, |X ω| ^ p ∂μ) ≤ (K * Real.sqrt p) ^ p

/-! The tail-to-moment direction of Proposition 2.5.2. -/
theorem tailToAbsoluteMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hTail : ∀ t : ℝ, 0 ≤ t →
      μ {ω | t < |X ω|} ≤ ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)))
    (p : ℝ) (hp : 1 ≤ p) :
    NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p ≤
      ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := by
  have hp0 : 0 < p := lt_of_lt_of_le zero_lt_one hp
  have hformula := NumStability.HDP.Scalar.Preliminaries.momentTailFormula
    (μ := μ) (X := X) hX hp0
  have hupper :
      (∫⁻ t in Set.Ioi 0,
        μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) ≤
        ∫⁻ t in Set.Ioi 0,
          ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
            ENNReal.ofReal (t ^ (p - 1)) := by
    apply MeasureTheory.setLIntegral_mono
    · fun_prop
    · intro t ht
      exact mul_le_mul_left (hTail t (le_of_lt (Set.mem_Ioi.mp ht))) _
  have hInt : IntegrableOn
      (fun t : ℝ => t ^ (p - 1) * Real.exp (-(K⁻¹ ^ 2) * t ^ 2)) (Set.Ioi 0) := by
    apply integrableOn_rpow_mul_exp_neg_mul_sq
    · positivity
    · linarith
  have hscale : ∀ t : ℝ,
      ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
          ENNReal.ofReal (t ^ (p - 1)) =
        ENNReal.ofReal (2 * (t ^ (p - 1) *
          Real.exp (-(K⁻¹ ^ 2) * t ^ 2))) := by
    intro t
    calc
      ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
          ENNReal.ofReal (t ^ (p - 1)) =
        ENNReal.ofReal ((2 * Real.exp (-t ^ 2 / K ^ 2)) *
          (t ^ (p - 1))) := (ENNReal.ofReal_mul (by positivity)).symm
      _ = ENNReal.ofReal (2 * (t ^ (p - 1) *
          Real.exp (-(K⁻¹ ^ 2) * t ^ 2))) := by
        congr 1
        field_simp
  have hInt2 : IntegrableOn
      (fun t : ℝ => 2 * (t ^ (p - 1) *
        Real.exp (-(K⁻¹ ^ 2) * t ^ 2))) (Set.Ioi 0) := hInt.const_mul _
  have hEq2 := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt2
    (by
      filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
      have ht0 : 0 < t := Set.mem_Ioi.mp ht
      positivity)
  have hGamma := integral_rpow_mul_exp_neg_mul_rpow
    (p := (2 : ℝ)) (q := p - 1) (b := K⁻¹ ^ 2) (by norm_num) (by linarith) (by positivity)
  have hIntEval :
      (∫ t in Set.Ioi 0,
        t ^ (p - 1) * Real.exp (-(K⁻¹ ^ 2) * t ^ 2)) =
        (K⁻¹ ^ 2) ^ (-p / 2) * (1 / 2) * Real.Gamma (p / 2) := by
    simpa [mul_comm] using hGamma
  have hupperEval :
      (∫⁻ t in Set.Ioi 0,
        ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
          ENNReal.ofReal (t ^ (p - 1))) ≤
        ENNReal.ofReal (2 * ((K⁻¹ ^ 2) ^ (-p / 2) *
          (1 / 2) * Real.Gamma (p / 2))) := by
    rw [MeasureTheory.setLIntegral_congr_fun measurableSet_Ioi
      (fun t _ => hscale t)]
    rw [← hEq2, MeasureTheory.integral_const_mul, hIntEval]
  have hGammaBound : Real.Gamma (p / 2) ≤ 4 * (p / 2) ^ (p / 2) :=
    gammaUpperBound (by linarith)
  have hcalc :
      ENNReal.ofReal p * ENNReal.ofReal
          (2 * ((K⁻¹ ^ 2) ^ (-p / 2) * (1 / 2) * Real.Gamma (p / 2))) ≤
        ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := by
    rw [← ENNReal.ofReal_mul (by positivity : 0 ≤ p)]
    apply ENNReal.ofReal_le_ofReal
    have hKpow : (K⁻¹ ^ 2) ^ (-p / 2) = K ^ p := by
      rw [← Real.rpow_natCast, ← Real.rpow_mul (by positivity : 0 ≤ K⁻¹)]
      rw [show (↑(2 : ℕ) : ℝ) * (-p / 2) = -p by norm_num; ring]
      rw [Real.inv_rpow (by positivity : 0 ≤ K)]
      rw [Real.rpow_neg (by positivity : 0 ≤ K)]
      simp
    rw [hKpow]
    have hexp : p ≤ Real.exp p := by
      nlinarith [Real.add_one_le_exp p]
    have hroot : 0 ≤ Real.sqrt p := by positivity
    have hgam : 0 ≤ Real.Gamma (p / 2) :=
      (Real.Gamma_pos_of_pos (by linarith)).le
    have hpowp : 0 ≤ p ^ (p / 2) := by positivity
    have hbase : (p / 2) ^ (p / 2) ≤ p ^ (p / 2) := by
      apply Real.rpow_le_rpow
      · positivity
      · linarith
      · positivity
    have hmulGamma : p * K ^ p * Real.Gamma (p / 2) ≤
        p * K ^ p * (4 * (p / 2) ^ (p / 2)) := by
      exact mul_le_mul_of_nonneg_left hGammaBound (by positivity)
    have hmulBase : 4 * p * K ^ p * (p / 2) ^ (p / 2) ≤
        4 * p * K ^ p * p ^ (p / 2) := by
      exact mul_le_mul_of_nonneg_left hbase (by positivity)
    have hcoef : 4 * p ≤ 8 * Real.exp p := by
      nlinarith [hexp, Real.exp_pos p]
    have hmulCoef : 4 * p * K ^ p * p ^ (p / 2) ≤
        8 * Real.exp p * K ^ p * p ^ (p / 2) := by
      exact mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_right hcoef (by positivity)) (by positivity)
    have hstep : 2 * p * (K ^ p * (1 / 2) * Real.Gamma (p / 2)) ≤
        8 * Real.exp p * K ^ p * p ^ (p / 2) := by
      calc
        2 * p * (K ^ p * (1 / 2) * Real.Gamma (p / 2)) =
            p * K ^ p * Real.Gamma (p / 2) := by ring
        _ ≤ p * K ^ p * (4 * (p / 2) ^ (p / 2)) := hmulGamma
        _ = 4 * p * K ^ p * (p / 2) ^ (p / 2) := by ring
        _ ≤ 4 * p * K ^ p * p ^ (p / 2) := hmulBase
        _ ≤ 8 * Real.exp p * K ^ p * p ^ (p / 2) := hmulCoef
    have hpnonneg : 0 ≤ p := by linarith
    have h8 : (8 : ℝ) ≤ (8 : ℝ) ^ p := by
      have h := Real.rpow_le_rpow_of_exponent_le
        (x := (8 : ℝ)) (y := (1 : ℝ)) (z := p) (by norm_num) hp
      simpa using h
    have hexprpow : Real.exp p = (Real.exp 1) ^ p := by
      rw [Real.rpow_def_of_pos (Real.exp_pos 1), Real.log_exp]
      congr 1
      ring
    have hconst0 : 8 * Real.exp p ≤ (8 * Real.exp 1) ^ p := by
      calc
        8 * Real.exp p ≤ 8 ^ p * Real.exp p :=
          mul_le_mul_of_nonneg_right h8 (Real.exp_pos p).le
        _ = 8 ^ p * (Real.exp 1) ^ p := by rw [hexprpow]
        _ = (8 * Real.exp 1) ^ p := by
          rw [Real.mul_rpow (by norm_num) (by positivity)]
    have hconst : 8 * Real.exp p * K ^ p * p ^ (p / 2) ≤
        (8 * Real.exp 1 * K * Real.sqrt p) ^ p := by
      have h8e : 0 ≤ (8 : ℝ) * Real.exp 1 := by positivity
      have h8eK : 0 ≤ (8 : ℝ) * Real.exp 1 * K := by positivity
      calc
        8 * Real.exp p * K ^ p * p ^ (p / 2) =
            (8 * Real.exp p) * (K ^ p * p ^ (p / 2)) := by ring
        _ ≤ (8 * Real.exp 1) ^ p * (K ^ p * p ^ (p / 2)) := by
          exact mul_le_mul_of_nonneg_right hconst0 (by positivity)
        _ = (8 * Real.exp 1) ^ p * (K ^ p * (Real.sqrt p) ^ p) := by
          rw [Real.sqrt_eq_rpow, ← Real.rpow_mul (by positivity : 0 ≤ p)]
          congr 2
          ring
        _ = (8 * Real.exp 1 * K * Real.sqrt p) ^ p := by
          rw [Real.mul_rpow h8eK (by positivity), Real.mul_rpow h8e (by positivity)]
          ring
    simpa [mul_assoc, mul_left_comm, mul_comm] using hstep.trans hconst
  calc
    NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p =
        ENNReal.ofReal p *
          (∫⁻ t in Set.Ioi 0,
            μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) := hformula.1
    _ ≤ ENNReal.ofReal p *
          (∫⁻ t in Set.Ioi 0,
            ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) *
              ENNReal.ofReal (t ^ (p - 1))) :=
      mul_le_mul_right hupper _
    _ ≤ ENNReal.ofReal p * ENNReal.ofReal
          (2 * ((K⁻¹ ^ 2) ^ (-p / 2) * (1 / 2) * Real.Gamma (p / 2))) :=
      mul_le_mul_right hupperEval _
    _ ≤ ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := hcalc

theorem tailToLpMomentGrowth
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hTail : ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2)) :
    LpMomentGrowth μ X (8 * Real.exp 1 * K) := by
  have hTail' : ∀ t : ℝ, 0 ≤ t →
      μ {ω | t < |X ω|} ≤ ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) := by
    intro t ht
    let A : Set Ω := {ω | t < |X ω|}
    let B : Set Ω := {ω | |X ω| ≥ t}
    have hAB : A ⊆ B := by
      intro ω hω
      change t < |X ω| at hω
      change t ≤ |X ω|
      exact le_of_lt hω
    have hB : μ B ≤ ENNReal.ofReal (2 * Real.exp (-t ^ 2 / K ^ 2)) := by
      rw [← ENNReal.ofReal_toReal (measure_ne_top μ B)]
      apply ENNReal.ofReal_le_ofReal
      simpa [B, MeasureTheory.measureReal_def] using hTail t ht
    exact (measure_mono hAB).trans hB
  refine ⟨hX.aemeasurable, ?_⟩
  intro p hp
  have hmoment := tailToAbsoluteMoment hX hK hTail' p hp
  have hfinite :
      NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p < (⊤ : ENNReal) :=
    lt_of_le_of_lt hmoment (by simp)
  have hmeas : AEMeasurable (fun ω => |X ω| ^ p) μ := by
    fun_prop
  have hInt : Integrable (fun ω => |X ω| ^ p) μ := by
    refine ⟨hmeas.aestronglyMeasurable, ?_⟩
    rw [hasFiniteIntegral_iff_norm]
    change (∫⁻ ω, ENNReal.ofReal ‖|X ω| ^ p‖ ∂μ) < (⊤ : ENNReal)
    convert hfinite using 1
    apply MeasureTheory.lintegral_congr_ae
    filter_upwards [] with ω
    rw [Real.norm_eq_abs, abs_of_nonneg (Real.rpow_nonneg (abs_nonneg _) _)]
    rfl
  constructor
  · exact hInt
  · have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
      (Filter.Eventually.of_forall (fun ω => by positivity))
    have hbound : ENNReal.ofReal (∫ ω, |X ω| ^ p ∂μ) ≤
        ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := by
      calc
        ENNReal.ofReal (∫ ω, |X ω| ^ p ∂μ) =
            NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p := by
          simpa [NumStability.HDP.Scalar.Preliminaries.absoluteMoment,
            Real.norm_eq_abs] using hEq
        _ ≤ ENNReal.ofReal ((8 * Real.exp 1 * K * Real.sqrt p) ^ p) := hmoment
    exact (ENNReal.ofReal_le_ofReal_iff (by positivity)).mp hbound

/-! The moment-to-square-MGF implication from Proposition 2.5.2. -/

/-- Bounds every positive even absolute moment at a sub-Gaussian scale. -/
def EvenMomentBound {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (K : ℝ) : Prop :=
  ∀ n : ℕ, 1 ≤ n →
    Integrable (fun ω => |X ω| ^ (2 * n)) μ ∧
      (∫ ω, |X ω| ^ (2 * n) ∂μ) ≤ K ^ (2 * n) * (2 * n : ℝ) ^ n

/-- The `n`th nonnegative term in the square-MGF power series. -/
def squareMGFTerm {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) : ENNReal :=
  ENNReal.ofReal (((lam ^ 2 * X ω ^ 2) ^ n) / (n.factorial : ℝ))

lemma squareMGFTerm_aemeasurable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hX : AEMeasurable X μ) (lam : ℝ) (n : ℕ) :
    AEMeasurable (squareMGFTerm X lam n) μ := by
  unfold squareMGFTerm
  fun_prop

lemma exp_series_pointwise (x : ℝ) (hx : 0 ≤ x) :
    ENNReal.ofReal (Real.exp x) =
      ∑' n : ℕ, ENNReal.ofReal (x ^ n / (n.factorial : ℝ)) := by
  rw [← ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity)
    (NormedSpace.expSeries_div_summable x)]
  rw [NormedSpace.expSeries_div_hasSum_exp x |>.tsum_eq]
  rw [← Real.exp_eq_exp_ℝ]

lemma geom_bound (q : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1 / 2) :
    (∑' n : ℕ, q ^ n) ≤ Real.exp (2 * q) := by
  have hqlt : q < 1 := lt_of_le_of_lt hq (by norm_num)
  have hsum := (hasSum_geometric_of_lt_one hq0 hqlt).tsum_eq
  rw [hsum]
  have hden : 0 < 1 - q := sub_pos.mpr hqlt
  have hrat : (1 - q)⁻¹ ≤ 1 + 2 * q := by
    rw [inv_eq_one_div]
    apply (div_le_iff₀ hden).2
    nlinarith [mul_nonneg hq0 (sub_nonneg.mpr (by linarith : q ≤ 1 / 2))]
  exact hrat.trans (by simpa [add_comm] using Real.add_one_le_exp (2 * q))

lemma factorial_ratio_bound (n : ℕ) (hn : 1 ≤ n) :
    ((2 * n : ℝ) ^ n) / (n.factorial : ℝ) ≤ (2 * Real.exp 1) ^ n := by
  have hfac := Stirling.le_factorial_stirling n
  have hroot : 1 ≤ Real.sqrt (2 * Real.pi * (n : ℝ)) := by
    rw [Real.one_le_sqrt]
    have hpi : (2 : ℝ) ≤ Real.pi := by
      nlinarith [Real.one_le_pi_div_two]
    have hnpos : (0 : ℝ) < (n : ℝ) := by
      exact_mod_cast (show 0 < n by omega)
    have hn1' : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    have hpn : 2 * (n : ℝ) ≤ Real.pi * n :=
      mul_le_mul_of_nonneg_right hpi (le_of_lt hnpos)
    have hn1 : (1 : ℝ) ≤ 2 * (n : ℝ) := by nlinarith
    have hprod : (1 : ℝ) ≤ Real.pi * n := hn1.trans hpn
    nlinarith [hprod]
  have hn0 : (0 : ℝ) ≤ n := Nat.cast_nonneg n
  have hepos : 0 < Real.exp 1 := Real.exp_pos _
  have hbase : 0 ≤ (n : ℝ) / Real.exp 1 := by positivity
  have hfac' : (n : ℝ) ^ n / (Real.exp 1) ^ n ≤ (n.factorial : ℝ) := by
    have hfac'' := (le_trans (mul_le_mul_of_nonneg_right hroot
      (by positivity : 0 ≤ ((n : ℝ) / Real.exp 1) ^ n)) hfac)
    simpa [div_pow] using hfac''
  have hmul : (n : ℝ) ^ n ≤ (n.factorial : ℝ) * (Real.exp 1) ^ n := by
    rw [← div_le_iff₀ (by positivity : 0 < (Real.exp 1) ^ n)]
    simpa [div_pow] using hfac'
  have hmul' : (2 * n : ℝ) ^ n ≤ (n.factorial : ℝ) * (2 * Real.exp 1) ^ n := by
    rw [mul_pow]
    calc
      2 ^ n * (n : ℝ) ^ n ≤ 2 ^ n * ((n.factorial : ℝ) * (Real.exp 1) ^ n) :=
        mul_le_mul_of_nonneg_left hmul (by positivity)
      _ = (n.factorial : ℝ) * (2 * Real.exp 1) ^ n := by
        rw [mul_pow]
        ring
  exact (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).2
    (by simpa [mul_comm] using hmul')

lemma squareMGFTerm_eq_mul
    {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) :
    squareMGFTerm X lam n ω =
      ENNReal.ofReal ((lam ^ 2) ^ n / (n.factorial : ℝ)) *
        ENNReal.ofReal (|X ω| ^ (2 * n)) := by
  unfold squareMGFTerm
  rw [← ENNReal.ofReal_mul (by positivity :
    0 ≤ (lam ^ 2) ^ n / (n.factorial : ℝ))]
  congr 1
  rw [mul_pow]
  have hXsq : X ω ^ 2 = |X ω| ^ 2 := (sq_abs _).symm
  rw [hXsq, ← pow_mul]
  ring

lemma evenMomentBound_of_lpMomentGrowth
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K : ℝ}
    (hLp : LpMomentGrowth μ X K) : EvenMomentBound μ X K := by
  intro n hn
  have hp := hLp.2 (2 * (n : ℝ)) (by
    have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
    nlinarith)
  have hpn : 2 * (n : ℝ) = ((2 * n : ℕ) : ℝ) := by norm_num
  have hfun : (fun ω => |X ω| ^ (2 * (n : ℝ))) =
      (fun ω => |X ω| ^ (2 * n : ℕ)) := by
    funext ω
    rw [hpn, Real.rpow_natCast]
  rw [hfun] at hp
  have heq : (K * Real.sqrt (2 * (n : ℝ))) ^ (2 * (n : ℕ)) =
      K ^ (2 * (n : ℕ)) * (2 * (n : ℝ)) ^ n := by
    rw [mul_pow, pow_mul, pow_mul]
    rw [Real.sq_sqrt (by positivity : (0 : ℝ) ≤ 2 * (n : ℝ))]
  constructor
  · exact hp.1
  · calc
      (∫ ω, |X ω| ^ (2 * n) ∂μ) ≤
          (K * Real.sqrt (2 * (n : ℝ))) ^ (2 * (n : ℝ)) := hp.2
      _ = (K * Real.sqrt (2 * (n : ℝ))) ^ (2 * n : ℕ) := by
        rw [hpn, Real.rpow_natCast]
      _ = K ^ (2 * n) * (2 * (n : ℝ)) ^ n := heq

lemma squareMGFTerm_lintegral_le_geom
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K lam : ℝ}
    (hMom : EvenMomentBound μ X K) {n : ℕ} (hn : 1 ≤ n) :
    (∫⁻ ω, squareMGFTerm X lam n ω ∂μ) ≤
      ENNReal.ofReal ((2 * Real.exp 1 * (lam * K) ^ 2) ^ n) := by
  have hm := hMom n hn
  have hterm := squareMGFTerm_eq_mul X lam n
  rw [lintegral_congr_ae (Filter.Eventually.of_forall (fun ω => hterm ω))]
  rw [lintegral_const_mul' _ _ (by simp)]
  rw [← ofReal_integral_eq_lintegral_ofReal hm.1
    (Filter.Eventually.of_forall (fun ω => by positivity))]
  have hscalar : 0 ≤ (lam ^ 2) ^ n / (n.factorial : ℝ) := by positivity
  have hbound := mul_le_mul_of_nonneg_left hm.2 hscalar
  rw [← ENNReal.ofReal_mul hscalar]
  apply ENNReal.ofReal_le_ofReal
  calc
    (lam ^ 2) ^ n / (n.factorial : ℝ) *
          (∫ ω, |X ω| ^ (2 * n) ∂μ) ≤
        (lam ^ 2) ^ n / (n.factorial : ℝ) *
          (K ^ (2 * n) * (2 * n : ℝ) ^ n) := hbound
    _ = ((lam * K) ^ (2 * n) * (2 * n : ℝ) ^ n) /
          (n.factorial : ℝ) := by ring
    _ ≤ (2 * Real.exp 1 * (lam * K) ^ 2) ^ n := by
      have hratio := factorial_ratio_bound n hn
      have hnonneg : 0 ≤ (lam * K) ^ (2 * n) := by
        rw [pow_mul]
        positivity
      apply (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).2
      have hratio' : (2 * n : ℝ) ^ n ≤ (2 * Real.exp 1) ^ n * (n.factorial : ℝ) :=
        (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).mp hratio
      calc
        (lam * K) ^ (2 * n) * (2 * n : ℝ) ^ n ≤
            (lam * K) ^ (2 * n) * ((2 * Real.exp 1) ^ n * (n.factorial : ℝ)) := by
              gcongr
        _ = (2 * Real.exp 1 * (lam * K) ^ 2) ^ n * (n.factorial : ℝ) := by
              calc
                (lam * K) ^ (2 * n) * ((2 * Real.exp 1) ^ n * (n.factorial : ℝ)) =
                    ((lam * K) ^ 2) ^ n * (2 * Real.exp 1) ^ n * (n.factorial : ℝ) := by
                      rw [pow_mul]
                      ring
                _ = (2 * Real.exp 1 * (lam * K) ^ 2) ^ n * (n.factorial : ℝ) := by
                      rw [← mul_pow]
                      ring

lemma squareMGF_lintegral_le
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K lam : ℝ}
    (hX : AEMeasurable X μ) (hK : 0 ≤ K)
    (hMom : EvenMomentBound μ X K) (hsmall : |lam| * K ≤ 1 / 4) :
    (∫⁻ ω, ENNReal.ofReal (Real.exp (lam ^ 2 * X ω ^ 2)) ∂μ) ≤
      ENNReal.ofReal (Real.exp (4 * Real.exp 1 * (lam * K) ^ 2)) := by
  let q : ℝ := 2 * Real.exp 1 * (lam * K) ^ 2
  have hprod : |lam * K| ≤ 1 / 4 := by
    rw [abs_mul, abs_of_nonneg hK]
    exact hsmall
  have hsq : (lam * K) ^ 2 ≤ (1 / 4 : ℝ) ^ 2 := by
    apply (sq_le_sq (a := lam * K) (b := (1 / 4 : ℝ))).2
    simpa using hprod
  have hq0 : 0 ≤ q := by positivity
  have hqhalf : q ≤ 1 / 2 := by
    have hfirst : q ≤ 2 * Real.exp 1 * (1 / 4 : ℝ) ^ 2 := by
      dsimp [q]
      exact mul_le_mul_of_nonneg_left hsq (by positivity)
    have hexp : Real.exp 1 ≤ 3 := Real.exp_one_lt_three.le
    nlinarith [hfirst]
  have hqsum : Summable (fun n : ℕ => q ^ n) := by
    exact (hasSum_geometric_of_lt_one hq0
      (lt_of_le_of_lt hqhalf (by norm_num))).summable
  have hterm_sum :
      (∑' n : ℕ, ∫⁻ ω, squareMGFTerm X lam n ω ∂μ) ≤
        ∑' n : ℕ, ENNReal.ofReal (q ^ n) := by
    apply ENNReal.tsum_le_tsum
    intro n
    cases n with
    | zero => simp [squareMGFTerm]
    | succ n =>
        simpa [q] using
          (squareMGFTerm_lintegral_le_geom hMom (n := n + 1) (by omega))
  calc
    (∫⁻ ω, ENNReal.ofReal (Real.exp (lam ^ 2 * X ω ^ 2)) ∂μ) =
        ∫⁻ ω, ∑' n : ℕ, squareMGFTerm X lam n ω ∂μ := by
          apply lintegral_congr_ae
          filter_upwards [] with ω
          exact exp_series_pointwise (lam ^ 2 * X ω ^ 2) (by positivity)
    _ = ∑' n : ℕ, ∫⁻ ω, squareMGFTerm X lam n ω ∂μ := by
          apply lintegral_tsum
          intro n
          exact squareMGFTerm_aemeasurable hX lam n
    _ ≤ ∑' n : ℕ, ENNReal.ofReal (q ^ n) := hterm_sum
    _ = ENNReal.ofReal (∑' n : ℕ, q ^ n) := by
          symm
          exact ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity) hqsum
    _ ≤ ENNReal.ofReal (Real.exp (2 * q)) :=
          ENNReal.ofReal_le_ofReal (geom_bound q hq0 hqhalf)
    _ = ENNReal.ofReal (Real.exp (4 * Real.exp 1 * (lam * K) ^ 2)) := by
          congr 2
          dsimp [q]
          ring

lemma squareMGF_real_le
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K lam : ℝ}
    (hX : AEMeasurable X μ) (hK : 0 ≤ K)
    (hMom : EvenMomentBound μ X K) (hsmall : |lam| * K ≤ 1 / 4) :
    Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
      (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
        Real.exp (4 * Real.exp 1 * (lam * K) ^ 2) := by
  have hbound := squareMGF_lintegral_le hX hK hMom hsmall
  have hmeas : AEMeasurable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ := by
    fun_prop
  have hfinite :
      (∫⁻ ω, ‖Real.exp (lam ^ 2 * X ω ^ 2)‖ₑ ∂μ) < (⊤ : ENNReal) := by
    have htop : ENNReal.ofReal (Real.exp (4 * Real.exp 1 * (lam * K) ^ 2)) <
        (⊤ : ENNReal) :=
      ENNReal.ofReal_lt_top
    refine lt_of_le_of_lt ?_ htop
    simpa only [← ofReal_norm_eq_enorm, Real.norm_eq_abs,
      abs_of_pos (Real.exp_pos _)] using hbound
  have hInt : Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ :=
    ⟨hmeas.aestronglyMeasurable, (hasFiniteIntegral_iff_enorm).2 hfinite⟩
  refine ⟨hInt, ?_⟩
  have hEq := ofReal_integral_eq_lintegral_ofReal hInt
    (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
  rw [← hEq] at hbound
  exact (ENNReal.ofReal_le_ofReal_iff (Real.exp_nonneg _)).mp hbound

/-! If the `Lᵖ` moments grow like `K * sqrt p`, then the square-exponential
MGF is bounded on the source's local scale. The displayed constants come from
the Stirling lower bound and the resulting geometric series. -/
theorem momentToSquareMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hLp : LpMomentGrowth μ X K) (lam : ℝ)
    (hsmall : |lam| ≤ (4 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
      (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
        Real.exp (4 * Real.exp 1 * (lam * K) ^ 2) := by
  have hsmall' : |lam| * K ≤ 1 / 4 := by
    calc
      |lam| * K ≤ (4 * K)⁻¹ * K :=
        mul_le_mul_of_nonneg_right hsmall hK.le
      _ = 1 / 4 := by field_simp
  exact squareMGF_real_le hLp.1 hK.le
    (evenMomentBound_of_lpMomentGrowth hLp) hsmall'

lemma exp_le_add_exp_sq (x : ℝ) :
    Real.exp x ≤ x + Real.exp (x ^ 2) := by
  have hcosh (y : ℝ) : Real.cosh y ≤ Real.exp (y ^ 2 / 2) :=
    Real.cosh_le_exp_half_sq y
  rcases le_total x 0 with hx | hx
  · have hy : 0 ≤ -x := neg_nonneg.mpr hx
    have hs : -x ≤ Real.sinh (-x) := (Real.self_le_sinh_iff).2 hy
    have hmain : Real.exp x - x ≤ Real.cosh (-x) := by
      rw [Real.cosh_eq]
      simp only [neg_neg]
      have hpos : 0 < Real.exp (-x) := Real.exp_pos _
      have hident : Real.exp x = (Real.exp (-x))⁻¹ := by
        simpa using (Real.exp_neg (-x))
      rw [hident]
      rw [Real.sinh_eq] at hs
      simp only [neg_neg] at hs
      rw [hident] at hs
      field_simp at hs ⊢
      nlinarith [hs]
    have hhalf : Real.exp ((-x) ^ 2 / 2) ≤ Real.exp ((-x) ^ 2) := by
      rw [Real.exp_le_exp]
      nlinarith [sq_nonneg x]
    have hsq : (-x) ^ 2 = x ^ 2 := by ring
    have hchain : Real.cosh (-x) ≤ Real.exp (x ^ 2) := by
      exact (hcosh (-x)).trans (by simpa [hsq] using hhalf)
    linarith [hmain, hchain]
  · have hcoshsub : Real.cosh x - Real.sinh x = Real.exp (-x) :=
      Real.cosh_sub_sinh x
    have hs : Real.sinh x - x ≤ Real.cosh x - 1 := by
      have he : 1 - x ≤ Real.exp (-x) := by
        simpa [sub_eq_add_neg, add_comm] using (Real.add_one_le_exp (-x))
      linarith [hcoshsub]
    have hmain : Real.exp x - x ≤ 2 * Real.cosh x - 1 := by
      rw [← Real.cosh_add_sinh x]
      linarith
    have hsq : 2 * Real.cosh x - 1 ≤ Real.exp (x ^ 2) := by
      have hc := hcosh x
      have hp : 0 ≤ Real.exp (x ^ 2 / 2) := Real.exp_nonneg _
      have hsquare : (Real.exp (x ^ 2 / 2) - 1) ^ 2 ≥ 0 := sq_nonneg _
      have hexp : Real.exp (x ^ 2 / 2) ^ 2 = Real.exp (x ^ 2) := by
        calc
          Real.exp (x ^ 2 / 2) ^ 2 =
              Real.exp (x ^ 2 / 2) * Real.exp (x ^ 2 / 2) := by ring
          _ = Real.exp (x ^ 2 / 2 + x ^ 2 / 2) := by rw [Real.exp_add]
          _ = Real.exp (x ^ 2) := by congr 1; ring
      rw [← hexp]
      nlinarith
    linarith [hmain, hsq]

lemma exp_le_abs_add_exp_sq (x : ℝ) :
    Real.exp x ≤ |x| + Real.exp (x ^ 2) := by
  exact (exp_le_add_exp_sq x).trans (by
    simpa [add_comm] using add_le_add_right (le_abs_self x) (Real.exp (x ^ 2)))

/-- A local exponential-square moment bound on the unit parameter window. -/
def SquareMGFLocal {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (C : ℝ) : Prop :=
  AEMeasurable X μ ∧
    ∀ t : ℝ, |t| ≤ 1 →
      Integrable (fun ω => Real.exp (t ^ 2 * X ω ^ 2)) μ ∧
        (∫ ω, Real.exp (t ^ 2 * X ω ^ 2) ∂μ) ≤ Real.exp (C * t ^ 2)

lemma integrable_exp_mul_of_square
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {X : Ω → ℝ} (hX : AEMeasurable X μ) (hIntX : Integrable X μ)
    {a : ℝ} (hSq : Integrable (fun ω => Real.exp (a ^ 2 * X ω ^ 2)) μ) :
    Integrable (fun ω => Real.exp (a * X ω)) μ := by
  have hdom : Integrable (fun ω => |a| * |X ω| +
      Real.exp (a ^ 2 * X ω ^ 2)) μ := by
    have hlin : Integrable (fun ω => |a| * |X ω|) μ :=
      hIntX.norm.const_mul |a|
    exact hlin.add hSq
  refine MeasureTheory.Integrable.mono' hdom ?_ ?_
  · fun_prop
  filter_upwards [] with ω
  have hpoint := exp_le_abs_add_exp_sq (a * X ω)
  have hposExp : 0 < Real.exp (a * X ω) := Real.exp_pos _
  simpa only [Real.norm_eq_abs, abs_of_pos hposExp, abs_mul, mul_pow] using hpoint

/-! A centered local square-MGF bound implies a global linear MGF bound. -/
theorem squareMGFToMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {C : ℝ} (hC : 0 ≤ C)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hSquare : SquareMGFLocal μ X C) (lam : ℝ) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp ((C + 1 / 2) * lam ^ 2) := by
  by_cases hsmall : |lam| ≤ 1
  · have hsq := hSquare.2 lam hsmall
    have hInt := integrable_exp_mul_of_square hSquare.1 hCenter.1 hsq.1
    refine ⟨hInt, ?_⟩
    have hlin : Integrable (fun ω => lam * X ω) μ := hCenter.1.const_mul lam
    have hsum : Integrable (fun ω => lam * X ω +
        Real.exp (lam ^ 2 * X ω ^ 2)) μ := hlin.add hsq.1
    have hmono := MeasureTheory.integral_mono_ae hInt hsum
      (Filter.Eventually.of_forall (fun ω => by
        have hpoint := exp_le_add_exp_sq (lam * X ω)
        convert hpoint using 1; ring))
    calc
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
          ∫ ω, lam * X ω + Real.exp (lam ^ 2 * X ω ^ 2) ∂μ := hmono
      _ = lam * (∫ ω, X ω ∂μ) +
          ∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ := by
            rw [integral_add hlin hsq.1, integral_const_mul]
      _ = ∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ := by
            rw [hCenter.2]
            ring
      _ ≤ Real.exp (C * lam ^ 2) := hsq.2
      _ ≤ Real.exp ((C + 1 / 2) * lam ^ 2) := by
            apply Real.exp_le_exp.mpr
            nlinarith [sq_nonneg lam]
  · have hlam : 1 < |lam| := lt_of_not_ge hsmall
    have hlam2 : 1 ≤ lam ^ 2 := by
      have hsquare := sq_abs lam
      nlinarith
    have hsq := hSquare.2 1 (by norm_num)
    have hInt : Integrable (fun ω => Real.exp (lam * X ω)) μ := by
      have hdom : Integrable (fun ω => Real.exp (lam ^ 2 / 2) *
          Real.exp (X ω ^ 2)) μ := by
        simpa using hsq.1.const_mul (Real.exp (lam ^ 2 / 2))
      refine MeasureTheory.Integrable.mono' hdom
        ((hSquare.1.const_mul lam).exp.aestronglyMeasurable) ?_
      filter_upwards [] with ω
      have hyoung : lam * X ω ≤ lam ^ 2 / 2 + X ω ^ 2 / 2 := by
        nlinarith [sq_nonneg (lam - X ω)]
      have hpos : 0 < Real.exp (lam * X ω) := Real.exp_pos _
      rw [Real.norm_eq_abs, abs_of_pos hpos]
      calc
        Real.exp (lam * X ω) ≤ Real.exp (lam ^ 2 / 2 + X ω ^ 2 / 2) :=
          Real.exp_le_exp.mpr hyoung
        _ = Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2 / 2) := by
          rw [Real.exp_add]
        _ ≤ Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2) := by
          gcongr
          nlinarith [sq_nonneg (X ω)]
    refine ⟨hInt, ?_⟩
    have hdom : Integrable (fun ω => Real.exp (lam ^ 2 / 2) *
        Real.exp (X ω ^ 2)) μ := by
      simpa using hsq.1.const_mul (Real.exp (lam ^ 2 / 2))
    have hmono := MeasureTheory.integral_mono_ae hInt hdom
      (Filter.Eventually.of_forall (fun ω => by
        have hyoung : lam * X ω ≤ lam ^ 2 / 2 + X ω ^ 2 / 2 := by
          nlinarith [sq_nonneg (lam - X ω)]
        calc
          Real.exp (lam * X ω) ≤ Real.exp (lam ^ 2 / 2 + X ω ^ 2 / 2) :=
            Real.exp_le_exp.mpr hyoung
          _ = Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2 / 2) := by
            rw [Real.exp_add]
          _ ≤ Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2) := by
            gcongr
            nlinarith [sq_nonneg (X ω)]))
    calc
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
          ∫ ω, Real.exp (lam ^ 2 / 2) * Real.exp (X ω ^ 2) ∂μ := hmono
      _ = Real.exp (lam ^ 2 / 2) *
          (∫ ω, Real.exp (X ω ^ 2) ∂μ) := by rw [integral_const_mul]
      _ ≤ Real.exp (lam ^ 2 / 2) * Real.exp C := by
        gcongr
        simpa using hsq.2
      _ = Real.exp (lam ^ 2 / 2 + C) := by
        rw [Real.exp_add]
      _ ≤ Real.exp ((C + 1 / 2) * lam ^ 2) := by
            apply Real.exp_le_exp.mpr
            have hprod : 0 ≤ C * (lam ^ 2 - 1) :=
              mul_nonneg hC (sub_nonneg.mpr hlam2)
            nlinarith

/-! The square-MGF tail conversion used by the sub-Gaussian equivalences. -/
theorem squareMGFToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2) := by
  let Y : Ω → ℝ := fun ω => Real.exp (X ω ^ 2 / K ^ 2)
  have hY : Measurable Y := by
    simpa [Y] using (hX.pow_const 2).div_const (K ^ 2) |>.exp
  have hY_nonneg : ∀ᵐ ω ∂μ, 0 ≤ Y ω :=
    Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _))
  have hKsq : 0 ≤ K ^ 2 := (sq_pos_of_pos hK).le
  have hmarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
      hY hY_nonneg hMGF.1 (Real.exp_pos (t ^ 2 / K ^ 2))
  have hsubset : {ω | |X ω| ≥ t} ⊆
      Y ⁻¹' Set.Ici (Real.exp (t ^ 2 / K ^ 2)) := by
    intro ω hω
    change Real.exp (t ^ 2 / K ^ 2) ≤ Real.exp (X ω ^ 2 / K ^ 2)
    apply (Real.exp_le_exp).2
    apply (div_le_div_of_nonneg_right _ hKsq)
    have habs : |t| ≤ |X ω| := by simpa [abs_of_nonneg ht] using hω
    exact (sq_le_sq).mpr habs
  have hmono {A B : Set Ω} (hAB : A ⊆ B) :
      μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  calc
    μ.real {ω | |X ω| ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (t ^ 2 / K ^ 2))) :=
      hmono hsubset
    _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (t ^ 2 / K ^ 2) := by
      simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
    _ ≤ 2 / Real.exp (t ^ 2 / K ^ 2) := by
      exact div_le_div_of_nonneg_right hMGF.2 (le_of_lt (Real.exp_pos _))
    _ = 2 * Real.exp (-t ^ 2 / K ^ 2) := by
      rw [div_eq_mul_inv, ← Real.exp_neg]
      ring

/-! Exercise 2.5.5(b): a square-MGF bound valid for every real parameter
forces the variable to have no mass beyond the corresponding deterministic
threshold.  We retain the tail-zero form, which is the measure-theoretic
meaning of the source's essential boundedness conclusion. -/
theorem squareMGFGlobalTailZero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 ≤ K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
        (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤ Real.exp (K * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) (hthreshold : K < t ^ 2) :
    μ.real {ω | |X ω| ≥ t} = 0 := by
  have hgap : 0 < t ^ 2 - K := sub_pos.mpr hthreshold
  have hbound : ∀ n : ℕ,
      μ.real {ω | |X ω| ≥ t} ≤
        Real.exp (-((n : ℝ) ^ 2) * (t ^ 2 - K)) := by
    intro n
    by_cases hn : n = 0
    · subst n
      have hprob : μ.real {ω | |X ω| ≥ t} ≤ 1 := by
        rw [Measure.real_def]
        exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
      simpa using hprob
    · let a : ℝ := (n : ℝ) ^ 2
      let Y : Ω → ℝ := fun ω => Real.exp (a * X ω ^ 2)
      have ha : 0 < a := by
        dsimp [a]
        positivity
      have hY : Measurable Y := by
        dsimp [Y]
        fun_prop
      have hmarkov :=
        NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
          (μ := μ) hY
          (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _)))
          (by simpa [Y, a] using (hMGF (n : ℝ)).1)
          (Real.exp_pos (a * t ^ 2))
      have hsubset : {ω | |X ω| ≥ t} ⊆
          Y ⁻¹' Set.Ici (Real.exp (a * t ^ 2)) := by
        intro ω hω
        change Real.exp (a * t ^ 2) ≤ Real.exp (a * X ω ^ 2)
        apply (Real.exp_le_exp).2
        apply mul_le_mul_of_nonneg_left _ ha.le
        exact (sq_le_sq).mpr (by simpa [abs_of_nonneg ht] using hω)
      have hmono {A B : Set Ω} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
        rw [Measure.real_def, Measure.real_def]
        exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
      calc
        μ.real {ω | |X ω| ≥ t} ≤
            μ.real (Y ⁻¹' Set.Ici (Real.exp (a * t ^ 2))) := hmono hsubset
        _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (a * t ^ 2) := by
          simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
        _ ≤ Real.exp (K * a) / Real.exp (a * t ^ 2) := by
          apply div_le_div_of_nonneg_right _ (le_of_lt (Real.exp_pos _))
          simpa [Y, a] using (hMGF (n : ℝ)).2
        _ = Real.exp (-a * (t ^ 2 - K)) := by
          rw [div_eq_mul_inv, ← Real.exp_neg, ← Real.exp_add]
          congr 1
          ring
        _ = Real.exp (-((n : ℝ) ^ 2) * (t ^ 2 - K)) := by rfl
  have hpow : Tendsto (fun n : ℕ => (n : ℝ) ^ 2) atTop atTop := by
    exact (tendsto_pow_atTop (α := ℝ) (n := 2) (by norm_num)).comp
      tendsto_natCast_atTop_atTop
  have hscaled : Tendsto
      (fun n : ℕ => (t ^ 2 - K) * (n : ℝ) ^ 2) atTop atTop :=
    hpow.const_mul_atTop hgap
  have hlim : Tendsto
      (fun n : ℕ => Real.exp (-((n : ℝ) ^ 2) * (t ^ 2 - K))) atTop (𝓝 0) := by
    apply Real.tendsto_exp_atBot.comp
    simpa [Function.comp_def, mul_comm] using
      (tendsto_neg_atTop_atBot.comp hscaled)
  exact le_antisymm
    (le_of_tendsto_of_tendsto' tendsto_const_nhds hlim (fun n => hbound n))
    (by positivity)

/-! The two-sided tail conversion from an all-parameter linear MGF bound. -/
theorem mgfToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
  by_cases ht0 : t = 0
  · rw [ht0]
    have hprob : μ.real {ω | |X ω| ≥ 0} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    calc
      μ.real {ω | |X ω| ≥ 0} ≤ 1 := hprob
      _ ≤ 2 * Real.exp (-0 ^ 2 / (4 * K ^ 2)) := by
        simp
  have htpos : 0 < t := lt_of_le_of_ne ht (Ne.symm ht0)
  let lam : ℝ := t / (2 * K ^ 2)
  have hlam : 0 < lam := by
    dsimp [lam]
    positivity
  have hupper : μ.real {ω | X ω ≥ t} ≤
      Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
    let Y : Ω → ℝ := fun ω => Real.exp (lam * X ω)
    have hY : Measurable Y := by
      simpa [Y] using (hX.const_mul lam).exp
    have hmarkov :=
      NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite hY
        (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _)))
        (hMGF lam).1 (Real.exp_pos (lam * t))
    have hsubset : {ω | X ω ≥ t} ⊆
        Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
      intro ω hω
      change Real.exp (lam * t) ≤ Real.exp (lam * X ω)
      exact (Real.exp_le_exp).2 (mul_le_mul_of_nonneg_left hω hlam.le)
    have hmono {A B : Set Ω} (hAB : A ⊆ B) :
        μ.real A ≤ μ.real B := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
    calc
      μ.real {ω | X ω ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (lam * t))) :=
        hmono hsubset
      _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (lam * t) := by
        simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
      _ ≤ Real.exp (K ^ 2 * lam ^ 2) / Real.exp (lam * t) := by
        exact div_le_div_of_nonneg_right (hMGF lam).2 (le_of_lt (Real.exp_pos _))
      _ = Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
        rw [div_eq_mul_inv, ← Real.exp_neg, ← Real.exp_add]
        congr 1
        dsimp [lam]
        field_simp [ne_of_gt hK]
        ring
  have hlower : μ.real {ω | -X ω ≥ t} ≤
      Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
    let Y : Ω → ℝ := fun ω => Real.exp (lam * (-X ω))
    have hY : Measurable Y := by
      simpa [Y] using ((hX.neg.const_mul lam).exp)
    have hmarkov :=
      NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite hY
        (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _)))
        (by simpa [Y, mul_assoc] using (hMGF (-lam)).1)
        (Real.exp_pos (lam * t))
    have hsubset : {ω | -X ω ≥ t} ⊆
        Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
      intro ω hω
      change Real.exp (lam * t) ≤ Real.exp (lam * (-X ω))
      exact (Real.exp_le_exp).2 (mul_le_mul_of_nonneg_left hω hlam.le)
    have hmono {A B : Set Ω} (hAB : A ⊆ B) :
        μ.real A ≤ μ.real B := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
    calc
      μ.real {ω | -X ω ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (lam * t))) :=
        hmono hsubset
      _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (lam * t) := by
        simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
      _ ≤ Real.exp (K ^ 2 * (-lam) ^ 2) / Real.exp (lam * t) := by
        exact div_le_div_of_nonneg_right (by simpa [Y, mul_assoc] using (hMGF (-lam)).2)
          (le_of_lt (Real.exp_pos _))
      _ = Real.exp (-t ^ 2 / (4 * K ^ 2)) := by
        rw [div_eq_mul_inv, ← Real.exp_neg, ← Real.exp_add]
        congr 1
        dsimp [lam]
        field_simp [ne_of_gt hK]
        ring
  have hsubset : {ω | |X ω| ≥ t} ⊆
      {ω | X ω ≥ t} ∪ {ω | -X ω ≥ t} := by
    intro ω hω
    change t ≤ |X ω| at hω
    change t ≤ X ω ∨ t ≤ -X ω
    by_cases h : t ≤ X ω
    · exact Or.inl h
    · right
      have hlt : X ω < t := lt_of_not_ge h
      by_contra hnot
      exact (not_lt_of_ge hω) ((abs_lt).2 (by constructor <;> linarith))
  have hunion : μ.real ({ω | X ω ≥ t} ∪ {ω | -X ω ≥ t}) ≤
      μ.real {ω | X ω ≥ t} + μ.real {ω | -X ω ≥ t} := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def]
    calc
      (μ ({ω | X ω ≥ t} ∪ {ω | -X ω ≥ t})).toReal ≤
          (μ {ω | X ω ≥ t} + μ {ω | -X ω ≥ t}).toReal := by
        apply ENNReal.toReal_mono
        · exact ENNReal.add_ne_top.mpr ⟨measure_ne_top μ _, measure_ne_top μ _⟩
        · exact measure_union_le _ _
      _ = (μ {ω | X ω ≥ t}).toReal + (μ {ω | -X ω ≥ t}).toReal :=
        ENNReal.toReal_add (measure_ne_top μ _) (measure_ne_top μ _)
  calc
    μ.real {ω | |X ω| ≥ t} ≤
        μ.real ({ω | X ω ≥ t} ∪ {ω | -X ω ≥ t}) := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top μ _) (measure_mono hsubset)
    _ ≤ μ.real {ω | X ω ≥ t} + μ.real {ω | -X ω ≥ t} := hunion
    _ ≤ Real.exp (-t ^ 2 / (4 * K ^ 2)) +
        Real.exp (-t ^ 2 / (4 * K ^ 2)) := add_le_add hupper hlower
    _ = 2 * Real.exp (-t ^ 2 / (4 * K ^ 2)) := by ring

/-! The all-parameter MGF bound forces centering (Exercise 2.5.4). -/
theorem mgfBoundForcesMeanZero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Integrable X μ)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2)) :
    (∫ ω, X ω ∂μ) = 0 := by
  let m : ℝ := ∫ ω, X ω ∂μ
  have hquad : ∀ lam : ℝ, lam * m ≤ K ^ 2 * lam ^ 2 := by
    intro lam
    have hconv : ConvexOn ℝ Set.univ (fun x : ℝ => Real.exp (lam * x)) := by
      have hcomp := convexOn_exp.comp_linearMap ((LinearMap.mul ℝ ℝ) lam)
      simpa [Function.comp_def] using hcomp
    have hjensen :=
      NumStability.HDP.Scalar.Preliminaries.jensenIntegral hconv hX (hMGF lam).1
    have hexp : Real.exp (lam * m) ≤ Real.exp (K ^ 2 * lam ^ 2) := by
      calc
        Real.exp (lam * m) ≤
            ∫ ω, Real.exp (lam * X ω) ∂μ := by
          simpa [m, NumStability.HDP.Scalar.Preliminaries.expectation,
            Function.comp_def] using hjensen
        _ ≤ Real.exp (K ^ 2 * lam ^ 2) := (hMGF lam).2
    exact Real.exp_le_exp.mp hexp
  by_contra hm
  have hm2 : 0 < m ^ 2 := sq_pos_of_ne_zero hm
  let d : ℝ := 2 * (K ^ 2 + 1)
  have hd : 0 < d := by
    dsimp [d]
    nlinarith [sq_nonneg K]
  have hbad := hquad (m / d)
  dsimp [d] at hbad
  field_simp [ne_of_gt hd] at hbad
  nlinarith [hm2, sq_nonneg K]

/-! Exercise 2.6.9: a finite two-point sub-Gaussian witness for the strict
inequality between the centered and uncentered `ψ₂` gauges.  The gauge below
is the exact Orlicz gauge for a two-point law, written after evaluating its
finite expectation. -/
/-- Admissibility of a ψ₂ scale for a two-point law. -/
def twoPointPsiTwoAdmissible (a b q t : ℝ) : Prop :=
  0 < t ∧ (1 - q) * Real.exp ((a / t) ^ 2) + q * Real.exp ((b / t) ^ 2) ≤ 2

/-- The infimum of admissible ψ₂ scales for a two-point law. -/
def twoPointPsiTwoNorm (a b q : ℝ) : ℝ :=
  sInf {t : ℝ | twoPointPsiTwoAdmissible a b q t}

lemma twoPointPsiTwoNorm_le_of_admissible {a b q t : ℝ}
    (ht : twoPointPsiTwoAdmissible a b q t) :
    twoPointPsiTwoNorm a b q ≤ t := by
  unfold twoPointPsiTwoNorm
  apply csInf_le
  · exact ⟨0, by intro s hs; exact le_of_lt hs.1⟩
  · exact ht

lemma twoPointPsiTwoNorm_ge_of_lower {a b q r : ℝ}
    (hS : Set.Nonempty {t : ℝ | twoPointPsiTwoAdmissible a b q t})
    (hLower : ∀ t, twoPointPsiTwoAdmissible a b q t → r ≤ t) :
    r ≤ twoPointPsiTwoNorm a b q := by
  unfold twoPointPsiTwoNorm
  apply le_csInf hS
  intro t ht
  exact hLower t ht

/-- The asymmetric two-point probability law used in Exercise 2.6.9. -/
def exercise269Law : Measure ℝ :=
  (999 / 1000 : ENNReal) • Measure.dirac (-1) +
    (1 / 1000 : ENNReal) • Measure.dirac 4

/-- The mean of `exercise269Law`. -/
def exercise269Mean : ℝ :=
  (999 / 1000 : ℝ) * (-1) + (1 / 1000 : ℝ) * 4

lemma exercise269Law_probability : IsProbabilityMeasure exercise269Law := by
  apply isProbabilityMeasure_iff.mpr
  simp [exercise269Law, ENNReal.div_eq_inv_mul]
  calc
    (1000 : ENNReal)⁻¹ * 999 + 1000⁻¹ = 1000⁻¹ * 999 + 1000⁻¹ * 1 := by
      rw [mul_one]
    _ = 1000⁻¹ * (999 + 1) := by rw [mul_add]
    _ = (1000 : ENNReal)⁻¹ * 1000 := by norm_num
    _ = 1 := by exact ENNReal.inv_mul_cancel (by norm_num) (by norm_num)

lemma exercise269Law_integral (f : ℝ → ℝ) :
    ∫ x, f x ∂exercise269Law = (999 / 1000 : ℝ) * f (-1) +
      (1 / 1000 : ℝ) * f 4 := by
  rw [exercise269Law, MeasureTheory.integral_add_measure]
  · rw [MeasureTheory.integral_smul_measure, MeasureTheory.integral_smul_measure,
      MeasureTheory.integral_dirac, MeasureTheory.integral_dirac]
    norm_num
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · apply ENNReal.mul_ne_top <;> simp
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp

lemma exercise269_raw_nonempty :
    Set.Nonempty {t : ℝ | twoPointPsiTwoAdmissible (-1) 4 (1 / 1000) t} := by
  refine ⟨10, ?_⟩
  constructor
  · norm_num
  have h₁ : Real.exp ((-1 / 10 : ℝ) ^ 2) ≤ 1 / (1 - (1 / 100 : ℝ)) := by
    convert Real.exp_bound_div_one_sub_of_interval (x := (1 / 100 : ℝ)) (by norm_num)
      (by norm_num) using 1; norm_num
  have h₂ : Real.exp ((4 / 10 : ℝ) ^ 2) ≤ 1 / (1 - (16 / 100 : ℝ)) := by
    convert Real.exp_bound_div_one_sub_of_interval (x := (16 / 100 : ℝ)) (by norm_num)
      (by norm_num) using 1; norm_num
  calc
    (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / 10 : ℝ) ^ 2) +
        (1 / 1000 : ℝ) * Real.exp ((4 / 10 : ℝ) ^ 2) ≤
        (1 - (1 / 1000 : ℝ)) * (1 / (1 - (1 / 100 : ℝ))) +
        (1 / 1000 : ℝ) * (1 / (1 - (16 / 100 : ℝ))) := by
          gcongr
    _ ≤ 2 := by norm_num

lemma exercise269_centered_nonempty :
    Set.Nonempty {t : ℝ | twoPointPsiTwoAdmissible (-1 / 200) (999 / 200)
      (1 / 1000) t} := by
  refine ⟨10, ?_⟩
  constructor
  · norm_num
  have h₁ : Real.exp ((-1 / 200 / 10 : ℝ) ^ 2) ≤
      1 / (1 - (1 / 4000000 : ℝ)) := by
    convert Real.exp_bound_div_one_sub_of_interval (x := (1 / 4000000 : ℝ)) (by norm_num)
      (by norm_num) using 1; norm_num
  have h₂ : Real.exp ((999 / 200 / 10 : ℝ) ^ 2) ≤
      1 / (1 - (998001 / 4000000 : ℝ)) := by
    convert Real.exp_bound_div_one_sub_of_interval (x := (998001 / 4000000 : ℝ))
      (by norm_num) (by norm_num) using 1; norm_num
  calc
    (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / 200 / 10 : ℝ) ^ 2) +
        (1 / 1000 : ℝ) * Real.exp ((999 / 200 / 10 : ℝ) ^ 2) ≤
        (1 - (1 / 1000 : ℝ)) * (1 / (1 - (1 / 4000000 : ℝ))) +
        (1 / 1000 : ℝ) * (1 / (1 - (998001 / 4000000 : ℝ))) := by
          gcongr
    _ ≤ 2 := by norm_num

lemma exercise269_exp_small : Real.exp (9 / 25 : ℝ) ≤ 3 / 2 := by
  apply (Real.le_log_iff_exp_le (by norm_num : (0 : ℝ) < 3 / 2)).mp
  have h := Real.le_log_one_add_of_nonneg (x := (1 / 2 : ℝ)) (by norm_num)
  norm_num at h ⊢
  linarith

lemma exercise269_exp_six : Real.exp (6 : ℝ) < 405 := by
  have hbase : Real.exp 1 < (2719 / 1000 : ℝ) := by
    exact lt_trans Real.exp_one_lt_d9 (by norm_num)
  have hpow : Real.exp 1 ^ 6 < (2719 / 1000 : ℝ) ^ 6 := by
    exact pow_lt_pow_left₀ hbase (by positivity) (by norm_num)
  calc
    Real.exp (6 : ℝ) = Real.exp 1 ^ 6 := by
      rw [← Real.exp_nat_mul 1 6]
      norm_num
    _ < (2719 / 1000 : ℝ) ^ 6 := hpow
    _ < 405 := by norm_num

lemma exercise269_raw_admissible :
    twoPointPsiTwoAdmissible (-1) 4 (1 / 1000) (5 / 3) := by
  constructor
  · norm_num
  have hsmall := exercise269_exp_small
  have hlarge : Real.exp (144 / 25 : ℝ) < 405 := by
    exact lt_of_le_of_lt ((Real.exp_le_exp).2 (by norm_num)) exercise269_exp_six
  norm_num only [one_div, sub_eq_add_neg]
  convert (show (999 / 1000 : ℝ) * Real.exp (9 / 25) +
      (1 / 1000 : ℝ) * Real.exp (144 / 25) ≤ 2 by
    nlinarith [hsmall, hlarge]) using 1

lemma exercise269_centered_lower :
    ∀ t, twoPointPsiTwoAdmissible (-1 / 200) (999 / 200) (1 / 1000) t →
      9 / 5 ≤ t := by
  intro t ht
  by_contra hnot
  have htpos : 0 < t := ht.1
  have htle : t ≤ 9 / 5 := le_of_not_ge hnot
  have ht_sq : t ^ 2 ≤ (9 / 5 : ℝ) ^ 2 := by
    have hnonneg : 0 ≤ (9 / 5 : ℝ) - t := by linarith
    have hsum : 0 ≤ (9 / 5 : ℝ) + t := by positivity
    nlinarith [mul_nonneg hnonneg hsum]
  have hfrac : (999 / 200 : ℝ) ^ 2 / (9 / 5 : ℝ) ^ 2 ≤
      (999 / 200 : ℝ) ^ 2 / t ^ 2 := by
    exact div_le_div_of_nonneg_left (sq_nonneg _) (sq_pos_of_pos htpos) ht_sq
  have hratio : (7 : ℝ) ≤ (999 / 200 / t) ^ 2 := by
    calc
      (7 : ℝ) ≤ (999 / 200 : ℝ) ^ 2 / (9 / 5 : ℝ) ^ 2 := by norm_num
      _ ≤ (999 / 200 : ℝ) ^ 2 / t ^ 2 := hfrac
      _ = (999 / 200 / t) ^ 2 := by field_simp
  have hexp7 : (1001 : ℝ) < Real.exp 7 := by
    have hbase : (27 / 10 : ℝ) < Real.exp 1 := by
      exact lt_trans (by norm_num) Real.exp_one_gt_d9
    have hpow : (27 / 10 : ℝ) ^ 7 < Real.exp 1 ^ 7 := by
      exact pow_lt_pow_left₀ hbase (by norm_num) (by norm_num)
    calc
      (1001 : ℝ) < (27 / 10 : ℝ) ^ 7 := by norm_num
      _ < Real.exp 1 ^ 7 := hpow
      _ = Real.exp 7 := by
        rw [← Real.exp_nat_mul 1 7]
        norm_num
  have hexp : (1001 : ℝ) < Real.exp ((999 / 200 / t) ^ 2) := by
    exact lt_of_lt_of_le hexp7 ((Real.exp_le_exp).2 hratio)
  have hsmall : (1 : ℝ) ≤ Real.exp ((-1 / 200 / t) ^ 2) :=
    Real.one_le_exp (sq_nonneg _)
  have hcontra : 2 <
      (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / 200 / t) ^ 2) +
        (1 / 1000 : ℝ) * Real.exp ((999 / 200 / t) ^ 2) := by
    nlinarith
  linarith [ht.2, hcontra]

theorem exercise269_counterexample :
    ∃ (μ : Measure ℝ) (X : ℝ → ℝ),
      IsProbabilityMeasure μ ∧
      μ = exercise269Law ∧
      X = (fun x : ℝ => x) ∧
      ∫ x, X x ∂μ = exercise269Mean ∧
      twoPointPsiTwoNorm (-1) 4 (1 / 1000) <
        twoPointPsiTwoNorm (-1 / 200) (999 / 200) (1 / 1000) := by
  have hraw := twoPointPsiTwoNorm_le_of_admissible exercise269_raw_admissible
  have hcenter := twoPointPsiTwoNorm_ge_of_lower exercise269_centered_nonempty
    exercise269_centered_lower
  have hmean : ∫ x, (fun x : ℝ => x) x ∂exercise269Law = exercise269Mean := by
    rw [exercise269Law_integral]
    norm_num [exercise269Mean]
  refine ⟨exercise269Law, (fun x : ℝ => x), exercise269Law_probability, rfl, rfl, ?_, ?_⟩
  · exact hmean
  · exact lt_of_le_of_lt hraw (lt_of_lt_of_le (by norm_num) hcenter)

/-! The `L²` interpolation estimate used in Exercise 2.6.6. -/
theorem lpExtrapolation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {Z : Ω → ℝ}
    (hZ1 : MemLp Z 1 μ) (hZ3 : MemLp Z 3 μ) :
    (∫ ω, |Z ω| ^ (2 : ℝ) ∂μ) ^ (1 / 2 : ℝ) ≤
      (∫ ω, |Z ω| ∂μ) ^ (1 / 4 : ℝ) *
        (∫ ω, |Z ω| ^ (3 : ℕ) ∂μ) ^ (1 / 4 : ℝ) := by
  have hf0 := hZ1.norm_rpow_div (q := (1 / 2 : ENNReal))
  have hg0 := hZ3.norm_rpow_div (q := (3 / 2 : ENNReal))
  have hq : (3 : ENNReal) / (3 / 2 : ENNReal) = 2 := by
    rw [ENNReal.div_eq_inv_mul, ENNReal.div_eq_inv_mul]
    rw [ENNReal.mul_inv (by norm_num) (by norm_num)]
    simp only [inv_inv]
    rw [mul_assoc, ENNReal.inv_mul_cancel (by norm_num) (by norm_num), mul_one]
  have hf : MemLp (fun ω => |Z ω| ^ (1 / 2 : ℝ)) 2 μ := by
    convert hf0 using 1 <;> norm_num
  have hg : MemLp (fun ω => |Z ω| ^ (3 / 2 : ℝ)) 2 μ := by
    rw [hq] at hg0
    convert hg0 using 1; norm_num
  have hc := integral_mul_le_Lp_mul_Lq_of_nonneg
    (μ := μ) (p := (2 : ℝ)) (q := (2 : ℝ))
    (f := fun ω => |Z ω| ^ (1 / 2 : ℝ))
    (g := fun ω => |Z ω| ^ (3 / 2 : ℝ)) Real.HolderConjugate.two_two
    (Filter.Eventually.of_forall (fun ω => Real.rpow_nonneg (abs_nonneg _) _))
    (Filter.Eventually.of_forall (fun ω => Real.rpow_nonneg (abs_nonneg _) _))
    (by simpa using hf) (by simpa using hg)
  have hfg : (fun ω =>
      (|Z ω| ^ (1 / 2 : ℝ)) * (|Z ω| ^ (3 / 2 : ℝ))) =
      (fun ω => |Z ω| ^ (2 : ℝ)) := by
    funext ω
    rw [← Real.rpow_add_of_nonneg (abs_nonneg _) (by positivity) (by positivity)]
    have h : (1 / 2 : ℝ) + 3 / 2 = 2 := by ring
    rw [h]
  have hff : (fun ω =>
      (|Z ω| ^ (1 / 2 : ℝ)) ^ (2 : ℝ)) =
      (fun ω => |Z ω|) := by
    funext ω
    rw [← Real.rpow_mul (abs_nonneg _)]
    have h : (1 / 2 : ℝ) * 2 = 1 := by ring
    rw [h, Real.rpow_one]
  have hgg : (fun ω =>
      (|Z ω| ^ (3 / 2 : ℝ)) ^ (2 : ℝ)) =
      (fun ω => |Z ω| ^ (3 : ℕ)) := by
    funext ω
    rw [← Real.rpow_mul (abs_nonneg _)]
    have h : (3 / 2 : ℝ) * 2 = 3 := by ring
    rw [h]
    exact Real.rpow_natCast _ 3
  rw [hfg, hff, hgg] at hc
  have hpow := Real.rpow_le_rpow
    (integral_nonneg_of_ae (Filter.Eventually.of_forall (fun ω => by positivity)))
    hc (by norm_num : (0 : ℝ) ≤ 1 / 2)
  have hA : 0 ≤ ∫ ω, |Z ω| ∂μ :=
    integral_nonneg_of_ae (Filter.Eventually.of_forall (fun ω => by positivity))
  have hB : 0 ≤ ∫ ω, |Z ω| ^ (3 : ℕ) ∂μ :=
    integral_nonneg_of_ae (Filter.Eventually.of_forall (fun ω => by positivity))
  calc
    (∫ ω, |Z ω| ^ (2 : ℝ) ∂μ) ^ (1 / 2 : ℝ) ≤
        ((∫ ω, |Z ω| ∂μ) ^ (1 / 2 : ℝ) *
          (∫ ω, |Z ω| ^ (3 : ℕ) ∂μ) ^ (1 / 2 : ℝ)) ^ (1 / 2 : ℝ) := hpow
    _ = (∫ ω, |Z ω| ∂μ) ^ (1 / 4 : ℝ) *
        (∫ ω, |Z ω| ^ (3 : ℕ) ∂μ) ^ (1 / 4 : ℝ) := by
      rw [← Real.mul_rpow hA hB]
      rw [← Real.rpow_mul (mul_nonneg hA hB)]
      norm_num
      rw [Real.mul_rpow hA hB]

/-! The Gaussian sum law in equation (2.18), together with its weighted form. -/
theorem independentGaussianSumLaw {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {σ : ι → ℝ≥0}
    (hLaw : ∀ i, HasLaw (X i) (gaussianReal 0 (σ i)) μ)
    (hIndep : iIndepFun X μ) :
    HasLaw (fun ω => ∑ i, X i ω)
      (gaussianReal 0 (∑ i, σ i)) μ := by
  have hGaussian : ∀ i, HasGaussianLaw (X i) μ := fun i =>
    (hLaw i).hasGaussianLaw
  have hSumGaussian : HasGaussianLaw (fun ω => ∑ i, X i ω) μ :=
    hIndep.hasGaussianLaw_fun_sum hGaussian
  have hLp : ∀ i, MemLp (X i) 2 μ := fun i => (hGaussian i).memLp_two
  have hPair : (↑(Finset.univ : Finset ι) : Set ι).Pairwise
      (fun i j => X i ⟂ᵢ[μ] X j) := by
    intro i hi j hj hij
    exact hIndep.indepFun hij
  have hVar_i : ∀ i, Var[X i; μ] = (σ i : ℝ) := by
    intro i
    calc
      Var[X i; μ] = Var[id; μ.map (X i)] := by
        symm
        simpa using (variance_map (X := id) (Y := X i)
          (μ := μ) (by fun_prop) (hLaw i).aemeasurable)
      _ = Var[id; gaussianReal 0 (σ i)] := by rw [hLaw i |>.map_eq]
      _ = (σ i : ℝ) := by simp [variance_id_gaussianReal]
  have hsum_fun : (fun ω => ∑ i, X i ω) = ∑ i, X i := by
    funext ω
    simp
  have hVar : Var[fun ω => ∑ i, X i ω; μ] = ∑ i, (σ i : ℝ) := by
    have hVar' := IndepFun.variance_sum (s := Finset.univ) (fun i _ => hLp i) hPair
    calc
      Var[fun ω => ∑ i, X i ω; μ] = Var[∑ i, X i; μ] := by rw [hsum_fun]
      _ = ∑ i, Var[X i; μ] := by simpa using hVar'
      _ = ∑ i, (σ i : ℝ) := by simp [hVar_i]
  have hMean_i : ∀ i, (∫ ω, X i ω ∂μ) = 0 := by
    intro i
    calc
      (∫ ω, X i ω ∂μ) = ∫ x, id x ∂(μ.map (X i)) := by
        symm
        simpa using (integral_map (hLaw i).aemeasurable aestronglyMeasurable_id)
      _ = ∫ x, id x ∂(gaussianReal 0 (σ i)) := by rw [hLaw i |>.map_eq]
      _ = 0 := by simp
  have hMean : (∫ ω, (∑ i, X i ω) ∂μ) = 0 := by
    rw [integral_finset_sum]
    · simp [hMean_i]
    · intro i hi
      exact (hGaussian i).integrable
  have hEq := hSumGaussian.isGaussian_map.eq_gaussianReal (μ.map (fun ω => ∑ i, X i ω))
  refine { aemeasurable := hSumGaussian.aemeasurable, map_eq := ?_ }
  calc
    μ.map (fun ω => ∑ i, X i ω) =
        gaussianReal (∫ x, id x ∂μ.map (fun ω => ∑ i, X i ω))
          Var[id; μ.map (fun ω => ∑ i, X i ω)].toNNReal := hEq
    _ = gaussianReal 0 (∑ i, σ i) := by
      rw [integral_map hSumGaussian.aemeasurable aestronglyMeasurable_id]
      rw [variance_map aemeasurable_id hSumGaussian.aemeasurable]
      simp only [id_eq, Function.id_comp]
      rw [hMean, hVar]
      congr 2
      apply NNReal.eq
      have hnonneg : 0 ≤ ∑ i, (σ i : ℝ) :=
        Finset.sum_nonneg fun i _ => (σ i).property
      rw [Real.coe_toNNReal _ hnonneg]
      simp

/-! Parameterized five-way interface for Proposition 2.5.2. -/
/-- The two-sided sub-Gaussian tail-bound presentation. -/
def SubGaussianTailBound {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2)

/-- The moment-growth presentation of a sub-Gaussian bound. -/
def SubGaussianMomentBound {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧ LpMomentGrowth μ X K

/-- The square-MGF presentation on a scale-dependent parameter window. -/
def SubGaussianSquareWindow {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ lam : ℝ, |lam| ≤ K⁻¹ →
      Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
        (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
          Real.exp (K ^ 2 * lam ^ 2)

/-- The one-point exponential-square presentation of a sub-Gaussian bound. -/
def SubGaussianSquarePoint {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ 2

/-! Threshold-parametrized versions of the tail and point square-MGF clauses.

Remark 2.5.3 says that the printed threshold `2` can be replaced by any fixed
`A > 1`, at the cost of changing the scale by a constant depending only on
`A`.  These predicates expose that threshold so the rescaling statement can be
checked directly rather than being hidden in prose. -/
/-- A sub-Gaussian tail bound with an explicit leading threshold. -/
def SubGaussianTailBoundWithThreshold {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K A : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-t ^ 2 / K ^ 2)

/-- A one-point exponential-square bound with an explicit threshold. -/
def SubGaussianSquarePointWithThreshold {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K A : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ A

noncomputable def subGaussianTailThresholdScale (A B : ℝ) : ℝ :=
  if A ≤ B then 1 else (Real.sqrt (Real.log B / Real.log A))⁻¹

noncomputable def subGaussianSquarePointThresholdScale (A B : ℝ) : ℝ :=
  if A ≤ B then 1 else (Real.sqrt ((B - 1) / (A - 1)))⁻¹

/-- Rescale a tail bound from one threshold greater than one to another. -/
def subGaussianTailThreshold_rescale
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K A B : ℝ} (hA : 1 < A) (hB : 1 < B) (hK : 0 < K)
    (hTail : ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-t ^ 2 / K ^ 2)) :
    ∃ K' : ℝ, 0 < K' ∧
      K' ≤ subGaussianTailThresholdScale A B * K ∧
      ∀ t : ℝ, 0 ≤ t →
        μ.real {ω | |X ω| ≥ t} ≤ B * Real.exp (-t ^ 2 / K' ^ 2) := by
  by_cases hAB : A ≤ B
  · refine ⟨K, hK, by simp [subGaussianTailThresholdScale, hAB], fun t ht => ?_⟩
    calc
      μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-t ^ 2 / K ^ 2) := hTail t ht
      _ ≤ B * Real.exp (-t ^ 2 / K ^ 2) := by
        exact mul_le_mul_of_nonneg_right hAB (le_of_lt (Real.exp_pos _))
  · have hBA : B < A := lt_of_not_ge hAB
    have hLogA : 0 < Real.log A := Real.log_pos hA
    have hLogB : 0 < Real.log B := Real.log_pos hB
    have hLogBA : Real.log B < Real.log A := Real.log_lt_log (by linarith) hBA
    let c : ℝ := Real.log B / Real.log A
    have hc : 0 < c := div_pos hLogB hLogA
    have hc1 : c < 1 := (div_lt_one hLogA).2 hLogBA
    let K' : ℝ := K / Real.sqrt c
    have hK' : 0 < K' := div_pos hK (Real.sqrt_pos.2 hc)
    have hK'bound : K' ≤ subGaussianTailThresholdScale A B * K := by
      simp [subGaussianTailThresholdScale, hAB, K', c, div_eq_inv_mul]
    have hSqSqrt : (Real.sqrt c) ^ 2 = c := Real.sq_sqrt hc.le
    have hKsq : K' ^ 2 = K ^ 2 / c := by
      dsimp [K']
      field_simp [ne_of_gt hK, ne_of_gt (Real.sqrt_pos.2 hc)]
      exact hSqSqrt.symm
    have hScale (t : ℝ) : t ^ 2 / K' ^ 2 = c * (t ^ 2 / K ^ 2) := by
      rw [hKsq]
      field_simp [ne_of_gt hK, ne_of_gt hc]
    have hSourceExponent (t : ℝ) : -t ^ 2 / K ^ 2 =
        -(t ^ 2 / K ^ 2) := by ring
    have hTargetExponent (t : ℝ) : -t ^ 2 / K' ^ 2 =
        -(c * (t ^ 2 / K ^ 2)) := by
      calc
        -t ^ 2 / K' ^ 2 = -(t ^ 2 / K' ^ 2) := by ring
        _ = -(c * (t ^ 2 / K ^ 2)) := by rw [hScale]
    have hProb (s : Set Ω) : μ.real s ≤ 1 := by
      calc
        μ.real s ≤ μ.real Set.univ := by
          simp only [Measure.real_def]
          exact ENNReal.toReal_mono (measure_ne_top μ Set.univ)
            (measure_mono (Set.subset_univ _))
        _ = 1 := probReal_univ
    refine ⟨K', hK', hK'bound, fun t ht => ?_⟩
    let u : ℝ := t ^ 2 / K ^ 2
    by_cases hu : u ≤ Real.log A
    · have hcu : c * u ≤ Real.log B := by
        have hcLog : c * Real.log A = Real.log B := by
          dsimp [c]
          field_simp [ne_of_gt hLogA]
        nlinarith
      have hExp : B⁻¹ ≤ Real.exp (-(c * u)) := by
        calc
          B⁻¹ = Real.exp (-Real.log B) := by
            rw [Real.exp_neg, Real.exp_log (by linarith)]
          _ ≤ Real.exp (-(c * u)) := by
            apply Real.exp_le_exp.mpr
            linarith
      have hOne : (1 : ℝ) ≤ B * Real.exp (-(c * u)) := by
        calc
          (1 : ℝ) = B * B⁻¹ := by field_simp [ne_of_gt hB]
          _ ≤ B * Real.exp (-(c * u)) :=
            mul_le_mul_of_nonneg_left hExp (by linarith)
      calc
        μ.real {ω | |X ω| ≥ t} ≤ 1 := hProb _
        _ ≤ B * Real.exp (-(c * u)) := hOne
        _ = B * Real.exp (-t ^ 2 / K' ^ 2) := by
          rw [hTargetExponent, show u = t ^ 2 / K ^ 2 by rfl]
    · have hu' : Real.log A < u := lt_of_not_ge hu
      have hExpCmp : A * Real.exp (-u) ≤ B * Real.exp (-(c * u)) := by
        rw [← Real.exp_log (by linarith : 0 < A), ← Real.exp_log (by linarith : 0 < B)]
        rw [← Real.exp_add, ← Real.exp_add]
        apply Real.exp_le_exp.mpr
        have hnonneg : 0 ≤ (1 - c) * (u - Real.log A) :=
          mul_nonneg (by linarith) (by linarith)
        have hcLog : c * Real.log A = Real.log B := by
          dsimp [c]
          field_simp [ne_of_gt hLogA]
        nlinarith
      calc
        μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-u) := by
          calc
            μ.real {ω | |X ω| ≥ t} ≤ A * Real.exp (-t ^ 2 / K ^ 2) := hTail t ht
            _ = A * Real.exp (-u) := by rw [hSourceExponent, show u = t ^ 2 / K ^ 2 by rfl]
        _ ≤ B * Real.exp (-(c * u)) := hExpCmp
        _ = B * Real.exp (-t ^ 2 / K' ^ 2) := by
          rw [hTargetExponent, show u = t ^ 2 / K ^ 2 by rfl]

/-- Rescale a square-point bound between thresholds greater than one. -/
def subGaussianSquarePointThreshold_rescale
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K A B : ℝ} (hX : Measurable X)
    (hA : 1 < A) (hB : 1 < B) (hK : 0 < K)
    (hInt : Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ)
    (hBound : (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ A) :
    ∃ K' : ℝ, 0 < K' ∧
      K' ≤ subGaussianSquarePointThresholdScale A B * K ∧
      Integrable (fun ω => Real.exp (X ω ^ 2 / K' ^ 2)) μ ∧
        (∫ ω, Real.exp (X ω ^ 2 / K' ^ 2) ∂μ) ≤ B := by
  by_cases hAB : A ≤ B
  · refine ⟨K, hK, by simp [subGaussianSquarePointThresholdScale, hAB],
      hInt, hBound.trans hAB⟩
  · have hBA : B < A := lt_of_not_ge hAB
    have hA1 : 0 < A - 1 := sub_pos.mpr hA
    have hB1 : 0 < B - 1 := by linarith
    let c : ℝ := (B - 1) / (A - 1)
    have hc : 0 < c := div_pos hB1 hA1
    have hc1 : c < 1 := (div_lt_one hA1).2 (by linarith)
    let K' : ℝ := K / Real.sqrt c
    have hK' : 0 < K' := div_pos hK (Real.sqrt_pos.2 hc)
    have hK'bound : K' ≤ subGaussianSquarePointThresholdScale A B * K := by
      simp [subGaussianSquarePointThresholdScale, hAB, K', c, div_eq_inv_mul]
    have hSqSqrt : (Real.sqrt c) ^ 2 = c := Real.sq_sqrt hc.le
    have hKsq : K' ^ 2 = K ^ 2 / c := by
      dsimp [K']
      field_simp [ne_of_gt hK, ne_of_gt (Real.sqrt_pos.2 hc)]
      exact hSqSqrt.symm
    have hScale (ω : Ω) : X ω ^ 2 / K' ^ 2 =
        c * (X ω ^ 2 / K ^ 2) := by
      rw [hKsq]
      field_simp [ne_of_gt hK, ne_of_gt hc]
    have hChord (y : ℝ) : Real.exp (c * y) ≤ (1 - c) + c * Real.exp y := by
      have hConv := convexOn_exp.2 (Set.mem_univ (0 : ℝ))
        (Set.mem_univ y) (sub_nonneg.mpr hc1.le) hc.le (by ring)
      simpa only [smul_eq_mul, zero_mul, mul_zero, add_zero, zero_add, Real.exp_zero,
        mul_one] using hConv
    let f : Ω → ℝ := fun ω => Real.exp (X ω ^ 2 / K ^ 2)
    let g : Ω → ℝ := fun ω => (1 - c) + c * f ω
    have hGInt : Integrable g μ := by
      dsimp [g]
      exact (integrable_const (1 - c)).add (hInt.const_mul c)
    have hTargetInt : Integrable (fun ω => Real.exp (X ω ^ 2 / K' ^ 2)) μ := by
      refine hGInt.mono' ?_ ?_
      · fun_prop
      · filter_upwards [] with ω
        rw [hScale]
        simpa [f, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using
          hChord (X ω ^ 2 / K ^ 2)
    have hTargetBound :
        (∫ ω, Real.exp (X ω ^ 2 / K' ^ 2) ∂μ) ≤ B := by
      have hPoint : ∀ᵐ ω ∂μ,
          Real.exp (X ω ^ 2 / K' ^ 2) ≤ g ω := by
        filter_upwards [] with ω
        rw [hScale]
        simpa [f] using hChord (X ω ^ 2 / K ^ 2)
      calc
        (∫ ω, Real.exp (X ω ^ 2 / K' ^ 2) ∂μ) ≤ ∫ ω, g ω ∂μ :=
          integral_mono_ae hTargetInt hGInt hPoint
        _ = (1 - c) + c * (∫ ω, f ω ∂μ) := by
          dsimp [g]
          rw [integral_add (integrable_const (1 - c)) (hInt.const_mul c)]
          simp [f, integral_const_mul, probReal_univ]
        _ ≤ B := by
          have hBoundF : (∫ ω, f ω ∂μ) ≤ A := by simpa [f] using hBound
          have hMul := mul_le_mul_of_nonneg_left hBoundF hc.le
          calc
            (1 - c) + c * (∫ ω, f ω ∂μ) ≤ (1 - c) + c * A := by linarith
            _ = B := by
              dsimp [c]
              field_simp [ne_of_gt hA1]
              ring
    exact ⟨K', hK', hK'bound, hTargetInt, hTargetBound⟩

/-! Remark 2.5.3: the fixed threshold `2` in the tail and point square-MGF
clauses may be replaced by any fixed `A > 1`, with only an `A`-dependent
rescaling of the positive parameter. -/
theorem subGaussianThresholdRemark
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (A : ℝ) (hA : 1 < A) :
    ((∃ K : ℝ, 0 < K ∧ SubGaussianTailBoundWithThreshold μ X K 2) ↔
      ∃ K : ℝ, 0 < K ∧ SubGaussianTailBoundWithThreshold μ X K A) ∧
    ((∃ K : ℝ, 0 < K ∧ SubGaussianSquarePointWithThreshold μ X K 2) ↔
      ∃ K : ℝ, 0 < K ∧ SubGaussianSquarePointWithThreshold μ X K A) := by
  constructor
  · constructor
    · rintro ⟨K, hK, hTail⟩
      rcases subGaussianTailThreshold_rescale (A := 2) (B := A)
          (by norm_num) hA hK hTail.2.2 with ⟨K', hK', _, hTail'⟩
      exact ⟨K', hK', hTail.1, hK', hTail',⟩
    · rintro ⟨K, hK, hTail⟩
      rcases subGaussianTailThreshold_rescale (A := A) (B := 2)
          hA (by norm_num) hK hTail.2.2 with ⟨K', hK', _, hTail'⟩
      exact ⟨K', hK', hTail.1, hK', hTail',⟩
  · constructor
    · rintro ⟨K, hK, hPoint⟩
      rcases subGaussianSquarePointThreshold_rescale (A := 2) (B := A)
          hPoint.1 (by norm_num) hA hK hPoint.2.2.1 hPoint.2.2.2 with
        ⟨K', hK', _, hInt', hBound'⟩
      exact ⟨K', hK', hPoint.1, hK', hInt', hBound'⟩
    · rintro ⟨K, hK, hPoint⟩
      rcases subGaussianSquarePointThreshold_rescale (A := A) (B := 2)
          hPoint.1 hA (by norm_num) hK hPoint.2.2.1 hPoint.2.2.2 with
        ⟨K', hK', _, hInt', hBound'⟩
      exact ⟨K', hK', hPoint.1, hK', hInt', hBound'⟩

theorem one_le_subGaussianTailThresholdScale
    {A B : ℝ} (hA : 1 < A) (hB : 1 < B) :
    1 ≤ subGaussianTailThresholdScale A B := by
  rw [subGaussianTailThresholdScale]
  split_ifs with hAB
  · exact le_rfl
  · have hBA : B < A := lt_of_not_ge hAB
    have hLogA : 0 < Real.log A := Real.log_pos hA
    have hLogB : 0 < Real.log B := Real.log_pos hB
    have hLogBA : Real.log B < Real.log A := Real.log_lt_log (by linarith) hBA
    let c : ℝ := Real.log B / Real.log A
    have hc : 0 < c := div_pos hLogB hLogA
    have hc1 : c < 1 := (div_lt_one hLogA).2 hLogBA
    have hspos : 0 < Real.sqrt c := Real.sqrt_pos.2 hc
    have hsle : Real.sqrt c ≤ 1 := by
      nlinarith [Real.sq_sqrt hc.le]
    simpa [c] using (one_le_inv₀ hspos).2 hsle

theorem one_le_subGaussianSquarePointThresholdScale
    {A B : ℝ} (hA : 1 < A) (hB : 1 < B) :
    1 ≤ subGaussianSquarePointThresholdScale A B := by
  rw [subGaussianSquarePointThresholdScale]
  split_ifs with hAB
  · exact le_rfl
  · have hBA : B < A := lt_of_not_ge hAB
    have hA1 : 0 < A - 1 := by linarith
    have hB1 : 0 < B - 1 := by linarith
    let c : ℝ := (B - 1) / (A - 1)
    have hc : 0 < c := div_pos hB1 hA1
    have hc1 : c < 1 := (div_lt_one hA1).2 (by linarith)
    have hspos : 0 < Real.sqrt c := Real.sqrt_pos.2 hc
    have hsle : Real.sqrt c ≤ 1 := by
      nlinarith [Real.sq_sqrt hc.le]
    simpa [c] using (one_le_inv₀ hspos).2 hsle

/-- The centered linear-MGF presentation of a sub-Gaussian bound. -/
def SubGaussianLinearMGF {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧ Integrable X μ ∧
    (∫ ω, X ω ∂μ) = 0 ∧
      ∀ lam : ℝ,
        Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
          (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2)

/-- The five equivalent presentations of the sub-Gaussian property. -/
inductive SubGaussianPropertyKind
  | tail
  | moment
  | squareWindow
  | squarePoint
  | linearMGF

/-- Interpret a sub-Gaussian presentation at a specified scale. -/
def SubGaussianProperty {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    SubGaussianPropertyKind → ℝ → Prop
  | .tail => SubGaussianTailBound μ X
  | .moment => SubGaussianMomentBound μ X
  | .squareWindow => SubGaussianSquareWindow μ X
  | .squarePoint => SubGaussianSquarePoint μ X
  | .linearMGF => SubGaussianLinearMGF μ X

def SubGaussianPropertyWithThreshold {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (A : ℝ) :
    SubGaussianPropertyKind → ℝ → Prop
  | .tail => fun K => SubGaussianTailBoundWithThreshold μ X K A
  | .moment => SubGaussianMomentBound μ X
  | .squareWindow => SubGaussianSquareWindow μ X
  | .squarePoint => fun K => SubGaussianSquarePointWithThreshold μ X K A
  | .linearMGF => SubGaussianLinearMGF μ X

noncomputable def subGaussianThresholdToStandardScale (A : ℝ) : ℝ :=
  max (subGaussianTailThresholdScale A 2)
    (subGaussianSquarePointThresholdScale A 2)

noncomputable def subGaussianStandardToThresholdScale (A : ℝ) : ℝ :=
  max (subGaussianTailThresholdScale 2 A)
    (subGaussianSquarePointThresholdScale 2 A)

theorem one_le_subGaussianThresholdToStandardScale
    {A : ℝ} (hA : 1 < A) : 1 ≤ subGaussianThresholdToStandardScale A :=
  (one_le_subGaussianTailThresholdScale hA (by norm_num)).trans
    (le_max_left _ _)

theorem one_le_subGaussianStandardToThresholdScale
    {A : ℝ} (hA : 1 < A) : 1 ≤ subGaussianStandardToThresholdScale A :=
  (one_le_subGaussianTailThresholdScale (by norm_num) hA).trans
    (le_max_left _ _)

private theorem subGaussianMomentToSquareWindow
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hMom : SubGaussianMomentBound μ X K) :
    SubGaussianSquareWindow μ X (8 * K) := by
  have he : Real.exp 1 ≤ 4 := by
    exact le_trans (le_of_lt Real.exp_one_lt_d9) (by norm_num)
  refine ⟨hMom.1, by positivity, ?_⟩
  intro lam hlam
  have hsmall : |lam| ≤ (4 * K)⁻¹ := by
    calc
      |lam| ≤ (8 * K)⁻¹ := hlam
      _ ≤ (4 * K)⁻¹ := by
        have h := one_div_le_one_div_of_le (by positivity : (0 : ℝ) < 4 * K)
          (by nlinarith : 4 * K ≤ 8 * K)
        simpa [one_div] using h
  have h := momentToSquareMGF hK hMom.2.2 lam hsmall
  refine ⟨h.1, ?_⟩
  calc
    (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
        Real.exp (4 * Real.exp 1 * (lam * K) ^ 2) := h.2
    _ ≤ Real.exp ((8 * K) ^ 2 * lam ^ 2) := by
      apply Real.exp_le_exp.mpr
      have hmul := mul_le_mul_of_nonneg_right he
        (by positivity : 0 ≤ 4 * (lam * K) ^ 2)
      calc
        4 * Real.exp 1 * (lam * K) ^ 2 ≤ 16 * (lam * K) ^ 2 := by
          nlinarith
        _ ≤ 64 * (lam * K) ^ 2 := by
          nlinarith [sq_nonneg (lam * K)]
        _ = (8 * K) ^ 2 * lam ^ 2 := by ring

private theorem subGaussianSquareWindowToPoint
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hSquare : SubGaussianSquareWindow μ X K) :
    SubGaussianSquarePoint μ X (2 * K) := by
  have hparam : |(2 * K)⁻¹| ≤ K⁻¹ := by
    rw [abs_of_pos (by positivity)]
    have htwo : (0 : ℝ) < 2 * K := by positivity
    have h := one_div_le_one_div_of_le hK (by nlinarith : K ≤ 2 * K)
    simpa [one_div, abs_of_pos htwo] using h
  have h := hSquare.2.2 ((2 * K)⁻¹) hparam
  have hEq : (fun ω => Real.exp (((2 * K)⁻¹) ^ 2 * X ω ^ 2)) =
      (fun ω => Real.exp (X ω ^ 2 / (2 * K) ^ 2)) := by
    funext ω
    congr 1
    field_simp
  refine ⟨hSquare.1, by positivity, ?_, ?_⟩
  · rw [hEq] at h
    exact h.1
  · calc
      (∫ ω, Real.exp (X ω ^ 2 / (2 * K) ^ 2) ∂μ) =
          ∫ ω, Real.exp (((2 * K)⁻¹) ^ 2 * X ω ^ 2) ∂μ := by
            rw [hEq]
      _ ≤ Real.exp (K ^ 2 * ((2 * K)⁻¹) ^ 2) := h.2
      _ = Real.exp (1 / 4) := by
        congr 1
        field_simp
        norm_num
      _ ≤ 2 := by
        apply le_trans (Real.exp_bound_div_one_sub_of_interval (by norm_num) (by norm_num))
        norm_num

private theorem subGaussianSquarePointToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hPoint : SubGaussianSquarePoint μ X K) :
    SubGaussianTailBound μ X K := by
  refine ⟨hPoint.1, hPoint.2.1, ?_⟩
  intro t ht
  exact squareMGFToTail hPoint.1 hPoint.2.1
    ⟨hPoint.2.2.1, hPoint.2.2.2⟩ ht

private theorem subGaussianTailToMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hTail : SubGaussianTailBound μ X K) :
    SubGaussianMomentBound μ X (8 * Real.exp 1 * K) := by
  exact ⟨hTail.1,
    mul_pos (mul_pos (by norm_num) (Real.exp_pos 1)) hTail.2.1,
    tailToLpMomentGrowth hTail.1 hTail.2.1 hTail.2.2⟩

private theorem subGaussianSquareWindowToLinear
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hSquare : SubGaussianSquareWindow μ X K) :
    SubGaussianLinearMGF μ X (2 * K) := by
  let Y : Ω → ℝ := fun ω => X ω / K
  have hY : Measurable Y := by
    simpa [Y] using hSquare.1.div_const K
  have hSquareY : SquareMGFLocal μ Y 1 := by
    refine ⟨hY.aemeasurable, ?_⟩
    intro t ht
    have hparam : |t / K| ≤ K⁻¹ := by
      calc
        |t / K| = |t| / K := by rw [abs_div, abs_of_pos hK]
        _ ≤ 1 / K := div_le_div_of_nonneg_right ht hK.le
        _ = K⁻¹ := by rw [one_div]
    have h := hSquare.2.2 (t / K) hparam
    have hEq : (fun ω => Real.exp (t ^ 2 * Y ω ^ 2)) =
        (fun ω => Real.exp ((t / K) ^ 2 * X ω ^ 2)) := by
      funext ω
      congr 1
      dsimp [Y]
      field_simp
    refine ⟨?_, ?_⟩
    · rw [← hEq] at h
      exact h.1
    · calc
        (∫ ω, Real.exp (t ^ 2 * Y ω ^ 2) ∂μ) =
            ∫ ω, Real.exp ((t / K) ^ 2 * X ω ^ 2) ∂μ := by rw [hEq]
        _ ≤ Real.exp (K ^ 2 * (t / K) ^ 2) := h.2
        _ = Real.exp (1 * t ^ 2) := by
          congr 1
          field_simp
  have hYCenter : Integrable Y μ ∧ (∫ ω, Y ω ∂μ) = 0 := by
    refine ⟨?_, ?_⟩
    · simpa [Y, div_eq_inv_mul] using hCenter.1.const_mul K⁻¹
    · have hInt := hCenter.1.const_mul K⁻¹
      calc
        (∫ ω, Y ω ∂μ) = ∫ ω, K⁻¹ * X ω ∂μ := by
          congr 1
          funext ω
          dsimp [Y]
          field_simp
        _ = K⁻¹ * (∫ ω, X ω ∂μ) := by rw [integral_const_mul]
        _ = 0 := by rw [hCenter.2]; ring
  have h := squareMGFToMGF (by norm_num : (0 : ℝ) ≤ 1)
    hYCenter hSquareY
  refine ⟨hSquare.1, by positivity, hCenter.1, hCenter.2, ?_⟩
  intro lam
  have h' := h (lam * K)
  have hEq : (fun ω => Real.exp ((lam * K) * Y ω)) =
      (fun ω => Real.exp (lam * X ω)) := by
    funext ω
    congr 1
    dsimp [Y]
    field_simp
  refine ⟨?_, ?_⟩
  · simpa [hEq] using h'.1
  · calc
      (∫ ω, Real.exp (lam * X ω) ∂μ) =
          ∫ ω, Real.exp ((lam * K) * Y ω) ∂μ := by rw [hEq]
      _ ≤ Real.exp ((1 + 1 / 2) * (lam * K) ^ 2) := h'.2
      _ ≤ Real.exp ((2 * K) ^ 2 * lam ^ 2) := by
        apply Real.exp_le_exp.mpr
        nlinarith [sq_nonneg (lam * K)]

private theorem subGaussianLinearToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hLinear : SubGaussianLinearMGF μ X K) :
    SubGaussianTailBound μ X (2 * K) := by
  refine ⟨hLinear.1, ?_, ?_⟩
  · nlinarith [hLinear.2.1]
  · intro t ht
    convert mgfToTail hLinear.1 hLinear.2.1 hLinear.2.2.2.2 ht using 1; ring

private theorem subGaussianToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubGaussianPropertyKind) {K : ℝ} (hK : 0 < K)
    (hProp : SubGaussianProperty μ X i K) :
    ∃ T : ℝ, 0 < T ∧ T ≤ 16 * K ∧ SubGaussianTailBound μ X T := by
  cases i with
  | tail => exact ⟨K, hK, by nlinarith, hProp⟩
  | moment =>
      have hSq := subGaussianMomentToSquareWindow hK hProp
      have hPoint := subGaussianSquareWindowToPoint (by positivity) hSq
      have hTail := subGaussianSquarePointToTail hPoint
      refine ⟨16 * K, by positivity, le_rfl, ?_⟩
      convert hTail using 1; ring
  | squareWindow =>
      have hPoint := subGaussianSquareWindowToPoint hK hProp
      have hTail := subGaussianSquarePointToTail hPoint
      refine ⟨2 * K, by positivity, by nlinarith, ?_⟩
      simpa [SubGaussianProperty] using hTail
  | squarePoint =>
      have hTail := subGaussianSquarePointToTail hProp
      refine ⟨K, hK, by nlinarith, ?_⟩
      simpa [SubGaussianProperty] using hTail
  | linearMGF =>
      have hTail := subGaussianLinearToTail hProp
      refine ⟨2 * K, by positivity, by nlinarith, ?_⟩
      simpa [SubGaussianProperty] using hTail

private theorem subGaussianFromTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubGaussianPropertyKind)
    (hCenter : i = .linearMGF → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    {T : ℝ} (hT : 0 < T)
    (hTail : SubGaussianTailBound μ X T) :
    ∃ K : ℝ, 0 < K ∧ K ≤ 128 * Real.exp 1 * T ∧
      SubGaussianProperty μ X i K := by
  cases i with
  | tail =>
      refine ⟨T, hT, ?_, hTail⟩
      have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
      have h := mul_le_mul_of_nonneg_right
        (show (1 : ℝ) ≤ 128 * Real.exp 1 by nlinarith) hT.le
      simpa using h
  | moment =>
      let K := 8 * Real.exp 1 * T
      have hMom := subGaussianTailToMoment hTail
      refine ⟨K, by dsimp [K]; positivity, ?_, ?_⟩
      · have h : (8 : ℝ) ≤ 128 := by norm_num
        have he : 0 ≤ Real.exp 1 * T := by positivity
        have hbound := mul_le_mul_of_nonneg_right h he
        simpa [K, mul_assoc] using hbound
      · simpa [SubGaussianProperty, K] using hMom
  | squareWindow =>
      let K := 64 * Real.exp 1 * T
      have hMom := subGaussianTailToMoment hTail
      have hSq := subGaussianMomentToSquareWindow (by
        positivity) hMom
      refine ⟨K, by dsimp [K]; positivity, ?_, ?_⟩
      · have h : (64 : ℝ) ≤ 128 := by norm_num
        have he : 0 ≤ Real.exp 1 * T := by positivity
        have hbound := mul_le_mul_of_nonneg_right h he
        simpa [K, mul_assoc] using hbound
      · convert hSq using 1
        all_goals simp [K]
        all_goals ring
  | squarePoint =>
      let K := 128 * Real.exp 1 * T
      have hMom := subGaussianTailToMoment hTail
      have hSq := subGaussianMomentToSquareWindow (by
        positivity) hMom
      have hPoint := subGaussianSquareWindowToPoint (by
        positivity) hSq
      refine ⟨K, by dsimp [K]; positivity, le_rfl, ?_⟩
      convert hPoint using 1
      all_goals simp [K]
      all_goals ring
  | linearMGF =>
      let K₀ := 64 * Real.exp 1 * T
      let K := 2 * K₀
      have hCentered := hCenter rfl
      have hMom := subGaussianTailToMoment hTail
      have hSq := subGaussianMomentToSquareWindow (by
        positivity) hMom
      have hLinear := subGaussianSquareWindowToLinear (by
        positivity) hCentered hSq
      refine ⟨K, by dsimp [K, K₀]; positivity, ?_, ?_⟩
      · dsimp [K, K₀]
        exact le_of_eq (by ring)
      · convert hLinear using 1
        all_goals simp [K, K₀]
        all_goals ring

private theorem subGaussianConvert
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i j : SubGaussianPropertyKind)
    (hCenter : j = .linearMGF → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    {Ki : ℝ} (hKi : 0 < Ki) (hProp : SubGaussianProperty μ X i Ki) :
    ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ 4096 * Real.exp 1 * Ki ∧
      SubGaussianProperty μ X j Kj := by
  rcases subGaussianToTail i hKi hProp with
    ⟨T, hT, hTbound, hTail⟩
  rcases subGaussianFromTail j hCenter hT hTail with
    ⟨Kj, hKj, hKjbound, hResult⟩
  refine ⟨Kj, hKj, ?_, hResult⟩
  calc
    Kj ≤ 128 * Real.exp 1 * T := hKjbound
    _ ≤ 128 * Real.exp 1 * (16 * Ki) := by
      exact mul_le_mul_of_nonneg_left hTbound (by positivity)
    _ = 2048 * Real.exp 1 * Ki := by ring
    _ ≤ 4096 * Real.exp 1 * Ki := by
      have hpos : 0 < Real.exp 1 * Ki := mul_pos (Real.exp_pos 1) hKi
      nlinarith

private theorem subGaussianThresholdToStandard
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (A : ℝ) (hA : 1 < A) (i : SubGaussianPropertyKind)
    {K : ℝ} (hK : 0 < K) (hProp : SubGaussianPropertyWithThreshold μ X A i K) :
    ∃ K' : ℝ, 0 < K' ∧ K' ≤ subGaussianThresholdToStandardScale A * K ∧
      SubGaussianProperty μ X i K' := by
  cases i with
  | tail =>
      change SubGaussianTailBoundWithThreshold μ X K A at hProp
      rcases subGaussianTailThreshold_rescale (A := A) (B := 2)
          hA (by norm_num) hK hProp.2.2 with ⟨K', hK', hK'bound, hTail⟩
      refine ⟨K', hK', ?_, ?_⟩
      · exact hK'bound.trans (mul_le_mul_of_nonneg_right
          (le_max_left _ _) hK.le)
      · exact ⟨hProp.1, hK', hTail⟩
  | moment =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianThresholdToStandardScale hA) hK.le
  | squareWindow =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianThresholdToStandardScale hA) hK.le
  | squarePoint =>
      change SubGaussianSquarePointWithThreshold μ X K A at hProp
      rcases subGaussianSquarePointThreshold_rescale (A := A) (B := 2)
          hProp.1 hA (by norm_num) hK hProp.2.2.1 hProp.2.2.2 with
        ⟨K', hK', hK'bound, hInt, hBound⟩
      refine ⟨K', hK', ?_, ?_⟩
      · exact hK'bound.trans (mul_le_mul_of_nonneg_right
          (le_max_right _ _) hK.le)
      · exact ⟨hProp.1, hK', hInt, hBound⟩
  | linearMGF =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianThresholdToStandardScale hA) hK.le

private theorem subGaussianStandardToThreshold
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (A : ℝ) (hA : 1 < A) (i : SubGaussianPropertyKind)
    {K : ℝ} (hK : 0 < K) (hProp : SubGaussianProperty μ X i K) :
    ∃ K' : ℝ, 0 < K' ∧ K' ≤ subGaussianStandardToThresholdScale A * K ∧
      SubGaussianPropertyWithThreshold μ X A i K' := by
  cases i with
  | tail =>
      change SubGaussianTailBound μ X K at hProp
      rcases subGaussianTailThreshold_rescale (A := 2) (B := A)
          (by norm_num) hA hK hProp.2.2 with ⟨K', hK', hK'bound, hTail⟩
      refine ⟨K', hK', ?_, ?_⟩
      · exact hK'bound.trans (mul_le_mul_of_nonneg_right
          (le_max_left _ _) hK.le)
      · exact ⟨hProp.1, hK', hTail⟩
  | moment =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianStandardToThresholdScale hA) hK.le
  | squareWindow =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianStandardToThresholdScale hA) hK.le
  | squarePoint =>
      change SubGaussianSquarePoint μ X K at hProp
      rcases subGaussianSquarePointThreshold_rescale (A := 2) (B := A)
          hProp.1 (by norm_num) hA hK hProp.2.2.1 hProp.2.2.2 with
        ⟨K', hK', hK'bound, hInt, hBound⟩
      refine ⟨K', hK', ?_, ?_⟩
      · exact hK'bound.trans (mul_le_mul_of_nonneg_right
          (le_max_right _ _) hK.le)
      · exact ⟨hProp.1, hK', hInt, hBound⟩
  | linearMGF =>
      refine ⟨K, hK, ?_, hProp⟩
      simpa using mul_le_mul_of_nonneg_right
        (one_le_subGaussianStandardToThresholdScale hA) hK.le

/-! Stable compositional form of Proposition 2.5.2. -/
theorem subGaussianCharacterization
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : SubGaussianPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
        SubGaussianProperty μ X i Ki →
          ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
            SubGaussianProperty μ X j Kj := by
  have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
  refine ⟨4096 * Real.exp 1, by nlinarith, ?_⟩
  intro i j Ki hKi hProp
  exact subGaussianConvert i j (fun _ => hCenter) hKi hProp

/-! Source-faithful uniform form of Proposition 2.5.2.

The first conjunct compares the four properties that do not require centering.
The second adds the linear MGF property for centered random variables.  The
single comparison constant is chosen before the probability space and random
variable, making its absoluteness explicit in the type.
-/
theorem subGaussianCharacterization_absolute :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              SubGaussianProperty μ X i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  SubGaussianProperty μ X j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : SubGaussianPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
            SubGaussianProperty μ X i Ki →
              ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                SubGaussianProperty μ X j Kj) := by
  have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
  refine ⟨4096 * Real.exp 1, by nlinarith, ?_, ?_⟩
  · intro Ω _ μ _ X _ i j _ hj Ki hKi hProp
    exact subGaussianConvert i j (fun h => (hj h).elim) hKi hProp
  · intro Ω _ μ _ X _ hCenter i j Ki hKi hProp
    exact subGaussianConvert i j (fun _ => hCenter) hKi hProp

/-! Full quantitative form of Remark 2.5.3 for an arbitrary fixed threshold
`A > 1`.  The comparison constant may depend on `A`, but is chosen before the
probability space and random variable. -/
theorem subGaussianThresholdCharacterization_absolute (A : ℝ) (hA : 1 < A) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              SubGaussianPropertyWithThreshold μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  SubGaussianPropertyWithThreshold μ X A j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : SubGaussianPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
            SubGaussianPropertyWithThreshold μ X A i Ki →
              ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                SubGaussianPropertyWithThreshold μ X A j Kj) := by
  rcases subGaussianCharacterization_absolute with ⟨C₀, hC₀, hBase, hCentered⟩
  let Cᵢ := subGaussianThresholdToStandardScale A
  let Cₒ := subGaussianStandardToThresholdScale A
  have hCᵢ : 1 ≤ Cᵢ := one_le_subGaussianThresholdToStandardScale hA
  have hCₒ : 1 ≤ Cₒ := one_le_subGaussianStandardToThresholdScale hA
  have hC₀nonneg : 0 ≤ C₀ := by linarith
  have hCᵢnonneg : 0 ≤ Cᵢ := by linarith
  have hCₒnonneg : 0 ≤ Cₒ := by linarith
  have hC₀Cᵢ : 1 ≤ C₀ * Cᵢ := by
    have := mul_le_mul hC₀ hCᵢ (by norm_num : (0 : ℝ) ≤ 1) hC₀nonneg
    simpa using this
  have hC : 1 ≤ Cₒ * C₀ * Cᵢ := by
    calc
      1 ≤ C₀ * Cᵢ := hC₀Cᵢ
      _ = 1 * (C₀ * Cᵢ) := by ring
      _ ≤ Cₒ * (C₀ * Cᵢ) :=
        mul_le_mul_of_nonneg_right hCₒ (mul_nonneg hC₀nonneg hCᵢnonneg)
      _ = Cₒ * C₀ * Cᵢ := by ring
  refine ⟨Cₒ * C₀ * Cᵢ, hC, ?_, ?_⟩
  · intro Ω _ μ _ X hX i j hi hj Ki hKi hProp
    rcases subGaussianThresholdToStandard A hA i hKi hProp with
      ⟨Kₛ, hKₛ, hKₛbound, hStandard⟩
    rcases hBase hX i j hi hj hKₛ hStandard with
      ⟨Kₜ, hKₜ, hKₜbound, hTarget⟩
    rcases subGaussianStandardToThreshold A hA j hKₜ hTarget with
      ⟨Kj, hKj, hKjbound, hResult⟩
    refine ⟨Kj, hKj, ?_, hResult⟩
    calc
      Kj ≤ Cₒ * Kₜ := by simpa [Cₒ] using hKjbound
      _ ≤ Cₒ * (C₀ * Kₛ) :=
        mul_le_mul_of_nonneg_left hKₜbound hCₒnonneg
      _ ≤ Cₒ * (C₀ * (Cᵢ * Ki)) := by
        exact mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_left (by simpa [Cᵢ] using hKₛbound) hC₀nonneg)
          hCₒnonneg
      _ = (Cₒ * C₀ * Cᵢ) * Ki := by ring
  · intro Ω _ μ _ X hX hCenter i j Ki hKi hProp
    rcases subGaussianThresholdToStandard A hA i hKi hProp with
      ⟨Kₛ, hKₛ, hKₛbound, hStandard⟩
    rcases hCentered hX hCenter i j hKₛ hStandard with
      ⟨Kₜ, hKₜ, hKₜbound, hTarget⟩
    rcases subGaussianStandardToThreshold A hA j hKₜ hTarget with
      ⟨Kj, hKj, hKjbound, hResult⟩
    refine ⟨Kj, hKj, ?_, hResult⟩
    calc
      Kj ≤ Cₒ * Kₜ := by simpa [Cₒ] using hKjbound
      _ ≤ Cₒ * (C₀ * Kₛ) :=
        mul_le_mul_of_nonneg_left hKₜbound hCₒnonneg
      _ ≤ Cₒ * (C₀ * (Cᵢ * Ki)) := by
        exact mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_left (by simpa [Cᵢ] using hKₛbound) hC₀nonneg)
          hCₒnonneg
      _ = (Cₒ * C₀ * Cᵢ) * Ki := by ring

/-! The extended `ψ₂` gauge from Definition 2.5.6. -/
/-- Admissibility of an extended-real scale in the ψ₂ gauge. -/
def PsiTwoAdmissible {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ≥0∞) : Prop :=
  Measurable X ∧ t ≠ 0 ∧ t ≠ ∞ ∧
    Integrable (fun ω => Real.exp (X ω ^ 2 / t.toReal ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / t.toReal ^ 2) ∂μ) ≤ 2

/-- The extended ψ₂ gauge of a measurable real-valued function. -/
noncomputable def PsiTwoGauge {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ≥0∞ :=
  sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ X t}

/-! The source-facing name for the `ψ₂` norm.  The extended value records
non-sub-Gaussian variables by `∞`; Definition 2.5.6 uses its finite part. -/
noncomputable def PsiTwoNorm {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ≥0∞ :=
  PsiTwoGauge μ X

/-! A random variable is sub-Gaussian when it is measurable and satisfies
property (iv) of Proposition 2.5.2 at some positive scale.  The equivalence of
properties (i)--(iv) below makes the chosen representative immaterial. -/
def IsSubGaussian {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : Prop :=
  Measurable X ∧ ∃ K : ℝ, 0 < K ∧ SubGaussianSquarePoint μ X K

/-! Equation (2.13), stated on the source's measurable sub-Gaussian domain. -/
theorem psiTwoNorm_eq_sInf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ}
    (_hX : Measurable X) (_hSub : IsSubGaussian μ X) :
    PsiTwoNorm μ X = sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ X t} := by
  rfl

theorem psiTwoGauge_finite_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ} :
    PsiTwoGauge μ X < ∞ ↔
      ∃ K : ℝ, 0 < K ∧ SubGaussianSquarePoint μ X K := by
  constructor
  · intro hGauge
    by_cases hNonempty : Set.Nonempty {t : ℝ≥0∞ | PsiTwoAdmissible μ X t}
    · rcases hNonempty with ⟨t, ht⟩
      rcases ht with ⟨hMeas, ht0, htTop, hInt, hBound⟩
      have htPos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
      refine ⟨t.toReal, htPos, ?_⟩
      exact ⟨hMeas, htPos, hInt, hBound⟩
    · have hEmpty : {t : ℝ≥0∞ | PsiTwoAdmissible μ X t} = ∅ :=
        Set.not_nonempty_iff_eq_empty.mp hNonempty
      rw [PsiTwoGauge, hEmpty] at hGauge
      simp at hGauge
  · rintro ⟨K, hK, hPoint⟩
    have ht0 : ENNReal.ofReal K ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 hK
    have htTop : ENNReal.ofReal K ≠ ∞ := ENNReal.ofReal_ne_top
    have htAdmissible : PsiTwoAdmissible μ X (ENNReal.ofReal K) := by
      refine ⟨hPoint.1, ht0, htTop, ?_, ?_⟩
      · simpa [ENNReal.toReal_ofReal hK.le] using hPoint.2.2.1
      · simpa [ENNReal.toReal_ofReal hK.le] using hPoint.2.2.2
    have hInf : PsiTwoGauge μ X ≤ ENNReal.ofReal K :=
      sInf_le htAdmissible
    exact lt_of_le_of_lt hInf ENNReal.ofReal_lt_top

/-- Any positive square-point witness is an explicit upper bound for the
`ψ₂` gauge, rather than merely a proof that the gauge is finite. -/
theorem psiTwoGauge_le_of_squarePoint
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {K : ℝ}
    (hPoint : SubGaussianSquarePoint μ X K) :
    PsiTwoGauge μ X ≤ ENNReal.ofReal K := by
  have hAdmissible : PsiTwoAdmissible μ X (ENNReal.ofReal K) := by
    refine ⟨hPoint.1, (ENNReal.ofReal_ne_zero_iff).2 hPoint.2.1,
      ENNReal.ofReal_ne_top, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal hPoint.2.1.le] using hPoint.2.2.1
    · simpa [ENNReal.toReal_ofReal hPoint.2.1.le] using hPoint.2.2.2
  exact sInf_le hAdmissible

/-! Definition 2.5.6 is independent of which of properties (i)--(iv) is used
to recognize the sub-Gaussian class. -/
theorem isSubGaussian_iff_property
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (i : SubGaussianPropertyKind) (hi : i ≠ .linearMGF) :
    IsSubGaussian μ X ↔
      ∃ K : ℝ, 0 < K ∧ SubGaussianProperty μ X i K := by
  constructor
  · rintro ⟨_, K, hK, hPoint⟩
    have hPoint' : SubGaussianProperty μ X .squarePoint K := by
      simpa [SubGaussianProperty] using hPoint
    rcases subGaussianConvert .squarePoint i (fun h => (hi h).elim) hK hPoint' with
      ⟨Ki, hKi, _, hProp⟩
    exact ⟨Ki, hKi, hProp⟩
  · rintro ⟨K, hK, hProp⟩
    rcases subGaussianConvert i .squarePoint (fun h => by cases h) hK hProp with
      ⟨Kpoint, hKpoint, _, hPoint⟩
    have hPoint' : SubGaussianSquarePoint μ X Kpoint := by
      simpa [SubGaussianProperty] using hPoint
    exact ⟨hPoint'.1, Kpoint, hKpoint, hPoint'⟩

theorem isSubGaussian_iff_psiTwoNorm_finite
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ} :
    IsSubGaussian μ X ↔ PsiTwoNorm μ X < ∞ := by
  constructor
  · rintro ⟨_, hPoint⟩
    simpa [PsiTwoNorm] using
      (psiTwoGauge_finite_iff (μ := μ) (X := X)).2 hPoint
  · intro hNorm
    have hGauge : PsiTwoGauge μ X < ∞ := by
      simpa [PsiTwoNorm] using hNorm
    rcases (psiTwoGauge_finite_iff (μ := μ) (X := X)).1 hGauge with
      ⟨K, hK, hPoint⟩
    exact ⟨hPoint.1, K, hK, hPoint⟩

/-! An explicit universal version of the property-to-gauge half of the
five-way characterization.  Keeping the numerical constant outside any
instance-dependent existential is useful for source statements whose
"absolute constant" quantifier must precede all random-variable data. -/
theorem psiTwoGauge_le_of_property
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubGaussianPropertyKind) {K : ℝ}
    (hK : 0 < K) (hProp : SubGaussianProperty μ X i K) :
    PsiTwoGauge μ X ≤ ENNReal.ofReal ((4096 * Real.exp 1) * K) := by
  rcases subGaussianToTail i hK hProp with
    ⟨T, hT, hTbound, hTail⟩
  rcases subGaussianFromTail .squarePoint (fun h => by cases h) hT hTail with
    ⟨Kpoint, hKpoint, hKpointBound, hPoint⟩
  have hAdmissible : PsiTwoAdmissible μ X (ENNReal.ofReal Kpoint) := by
    refine ⟨hPoint.1, (ENNReal.ofReal_ne_zero_iff).2 hKpoint,
      ENNReal.ofReal_ne_top, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal hKpoint.le] using hPoint.2.2.1
    · simpa [ENNReal.toReal_ofReal hKpoint.le] using hPoint.2.2.2
  have hGauge : PsiTwoGauge μ X ≤ ENNReal.ofReal Kpoint :=
    sInf_le hAdmissible
  have hScaled : 128 * Real.exp 1 * T ≤
      (4096 * Real.exp 1) * K := by
    have hmul := mul_le_mul_of_nonneg_left hTbound
      (by positivity : 0 ≤ 128 * Real.exp 1)
    calc
      128 * Real.exp 1 * T ≤ 128 * Real.exp 1 * (16 * K) := hmul
      _ ≤ (4096 * Real.exp 1) * K := by
        nlinarith [mul_pos (Real.exp_pos 1) hK]
  exact hGauge.trans (ENNReal.ofReal_mono (hKpointBound.trans hScaled))

/-! A gauge-facing form of the five-way characterization.  Every one of the
    parameterized sub-Gaussian properties controls the exact `ψ₂` gauge up to
    one universal constant, and finite gauge is equivalent to each property
    being available at some positive scale. -/
theorem psiTwoGaugeCharacterizations
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ i : SubGaussianPropertyKind, ∀ {K : ℝ}, 0 < K →
        SubGaussianProperty μ X i K →
          PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K)) ∧
      (∀ i : SubGaussianPropertyKind,
        ((∃ K : ℝ, 0 < K ∧ SubGaussianProperty μ X i K) ↔
          PsiTwoGauge μ X < ∞)) := by
  let C : ℝ := 4096 * Real.exp 1
  have hC : 1 ≤ C := by
    dsimp [C]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1)]
  refine ⟨C, hC, ?_, ?_⟩
  · intro i K hK hProp
    simpa [C] using psiTwoGauge_le_of_property i hK hProp
  · intro i
    constructor
    · rintro ⟨K, hK, hProp⟩
      rcases subGaussianToTail i hK hProp with
        ⟨T, hT, hTbound, hTail⟩
      rcases subGaussianFromTail .squarePoint (fun h => by cases h) hT hTail with
        ⟨Kpoint, hKpoint, _, hPoint⟩
      exact (psiTwoGauge_finite_iff (μ := μ) (X := X)).2
        ⟨Kpoint, hKpoint, hPoint⟩
    · intro hGauge
      rcases (psiTwoGauge_finite_iff (μ := μ) (X := X)).1 hGauge with
        ⟨Kpoint, hKpoint, hPoint⟩
      rcases subGaussianToTail .squarePoint hKpoint hPoint with
        ⟨T, hT, _, hTail⟩
      rcases subGaussianFromTail i (fun _ => hCenter) hT hTail with
        ⟨K, hK, _, hProp⟩
      exact ⟨K, hK, hProp⟩

/-! Centering preserves sub-Gaussianity with an absolute change of scale. -/
theorem centeredSubGaussian
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubGaussianPropertyKind) {K : ℝ} (hK : 0 < K)
    (hProp : SubGaussianProperty μ X i K) :
    ∃ C : ℝ, 1 ≤ C ∧
      Integrable X μ ∧
      ∃ K' : ℝ, 0 < K' ∧ K' ≤ C * K ∧
        SubGaussianProperty μ
          (fun ω => X ω - ∫ x, X x ∂μ) .squarePoint K' ∧
        PsiTwoGauge μ (fun ω => X ω - ∫ x, X x ∂μ) ≤
          ENNReal.ofReal (C * K) := by
  rcases subGaussianToTail i hK hProp with ⟨T, hT, hTK, hTail⟩
  have hMoment : SubGaussianMomentBound μ X (8 * Real.exp 1 * T) :=
    subGaussianTailToMoment hTail
  have hAbsInt : Integrable (fun ω => |X ω|) μ := by
    have h := (hMoment.2.2.2 1 (by norm_num : (1 : ℝ) ≤ 1)).1
    simpa using h
  have hInt : Integrable X μ := by
    apply (MeasureTheory.integrable_norm_iff hMoment.1.aestronglyMeasurable).mp
    simpa [Real.norm_eq_abs] using hAbsInt
  let m : ℝ := ∫ x, X x ∂μ
  have hMean : |m| ≤ 8 * Real.exp 1 * T := by
    have hMomentBound :=
      (hMoment.2.2.2 1 (by norm_num : (1 : ℝ) ≤ 1)).2
    have hIntegralNorm :=
      MeasureTheory.norm_integral_le_integral_norm X (μ := μ)
    dsimp [m]
    calc
      |∫ x, X x ∂μ| ≤ ∫ x, ‖X x‖ ∂μ := hIntegralNorm
      _ = ∫ x, |X x| ∂μ := by simp only [Real.norm_eq_abs]
      _ ≤ 8 * Real.exp 1 * T := by simpa using hMomentBound
  let Kc : ℝ := 32 * Real.exp 1 * T
  have hKc : 0 < Kc := by
    dsimp [Kc]
    positivity
  have hKc_twoT : 2 * T ≤ Kc := by
    dsimp [Kc]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1), hT.le]
  have hCenter : Integrable (fun ω => X ω - m) μ ∧
      (∫ ω, X ω - m ∂μ) = 0 := by
    constructor
    · exact hInt.sub (integrable_const m)
    · dsimp [m]
      rw [integral_sub hInt (integrable_const _)]
      simp
  have hTailCenter :
      SubGaussianTailBound μ (fun ω => X ω - m) Kc := by
    refine ⟨hTail.1.sub_const m, hKc, ?_⟩
    intro t ht
    have hProb (s : Set Ω) : μ.real s ≤ 1 := by
      calc
        μ.real s ≤ μ.real Set.univ := by
          simp only [Measure.real_def]
          exact ENNReal.toReal_mono (measure_ne_top μ Set.univ)
            (measure_mono (Set.subset_univ _))
        _ = 1 := probReal_univ
    by_cases hsmall : t ≤ 2 * |m|
    · have htBound : t ≤ 16 * Real.exp 1 * T := by
        nlinarith [hMean]
      have htSq : t ^ 2 ≤ (16 * Real.exp 1 * T) ^ 2 := by
        exact (sq_le_sq₀ (by linarith) (by positivity)).2 htBound
      have hratio : t ^ 2 / Kc ^ 2 ≤ (1 / 4 : ℝ) := by
        apply (div_le_iff₀ (sq_pos_of_pos hKc)).2
        dsimp [Kc]
        nlinarith [htSq]
      have hexp : (1 : ℝ) ≤ 2 * Real.exp (-(t ^ 2 / Kc ^ 2)) := by
        have hbase := Real.add_one_le_exp (-(t ^ 2 / Kc ^ 2))
        nlinarith [hratio]
      calc
        μ.real {ω | |X ω - m| ≥ t} ≤ 1 := hProb _
        _ ≤ 2 * Real.exp (-t ^ 2 / Kc ^ 2) := by
          simpa only [neg_div] using hexp
    · have hlarge : 2 * |m| < t := lt_of_not_ge hsmall
      have hsubset : {ω | |X ω - m| ≥ t} ⊆
          {ω | |X ω| ≥ t / 2} := by
        intro ω hω
        change t ≤ |X ω - m| at hω
        by_contra hnot
        have hnot' : ¬ |X ω| ≥ t / 2 := by
          simpa only [Set.mem_setOf_eq] using hnot
        have hXlt : |X ω| < t / 2 := lt_of_not_ge hnot'
        have hmlt : |m| < t / 2 := by linarith
        have htriangle : |X ω - m| ≤ |X ω| + |m| := abs_sub _ _
        linarith
      have hhalf : 0 ≤ t / 2 := by linarith
      have hsource := hTail.2.2 (t / 2) hhalf
      have hsource' :
          2 * Real.exp (-(t / 2) ^ 2 / T ^ 2) ≤
            2 * Real.exp (-t ^ 2 / Kc ^ 2) := by
        apply mul_le_mul_of_nonneg_left _ (by norm_num)
        apply Real.exp_le_exp.mpr
        have hden : 4 * T ^ 2 ≤ Kc ^ 2 := by
          have hsq := (sq_le_sq₀ (by positivity) (by positivity)).2 hKc_twoT
          nlinarith [hsq]
        have hratio : t ^ 2 / Kc ^ 2 ≤ t ^ 2 / (4 * T ^ 2) := by
          exact div_le_div_of_nonneg_left (sq_nonneg t) (by positivity) hden
        calc
          -(t / 2) ^ 2 / T ^ 2 = -(t ^ 2 / (4 * T ^ 2)) := by
            field_simp
            ring
          _ ≤ -(t ^ 2 / Kc ^ 2) := by nlinarith [hratio]
          _ = -t ^ 2 / Kc ^ 2 := by simp only [neg_div]
      calc
        μ.real {ω | |X ω - m| ≥ t} ≤ μ.real {ω | |X ω| ≥ t / 2} := by
          rw [Measure.real_def, Measure.real_def]
          exact ENNReal.toReal_mono (measure_ne_top μ _)
            (measure_mono hsubset)
        _ ≤ 2 * Real.exp (-(t / 2) ^ 2 / T ^ 2) := hsource
        _ ≤ 2 * Real.exp (-t ^ 2 / Kc ^ 2) := hsource'

  rcases subGaussianFromTail .squarePoint (fun h => by cases h) hKc hTailCenter with
    ⟨K', hK', hK'c, hPoint⟩
  have hGaugeK' :
      PsiTwoGauge μ (fun ω => X ω - m) ≤ ENNReal.ofReal K' := by
    have hAdmissible :
        PsiTwoAdmissible μ (fun ω => X ω - m) (ENNReal.ofReal K') := by
      refine ⟨hPoint.1, (ENNReal.ofReal_ne_zero_iff).2 hK',
        ENNReal.ofReal_ne_top, ?_, ?_⟩
      · simpa [ENNReal.toReal_ofReal hK'.le] using hPoint.2.2.1
      · simpa [ENNReal.toReal_ofReal hK'.le] using hPoint.2.2.2
    exact sInf_le hAdmissible
  let C : ℝ := 65536 * (Real.exp 1) ^ 2
  have hC : 1 ≤ C := by
    dsimp [C]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1)]
  have hK'bound : K' ≤ C * K := by
    have hTbound : T ≤ 16 * K := hTK
    dsimp [C, Kc] at hK'c ⊢
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1),
      sq_nonneg (Real.exp 1), mul_pos (Real.exp_pos 1) hT,
      mul_pos (Real.exp_pos 1) hK]
  refine ⟨C, hC, hInt, K', hK', hK'bound, ?_, ?_⟩
  · simpa [m] using hPoint
  · apply hGaugeK'.trans
    apply ENNReal.ofReal_mono hK'bound

/-! A finite independent-sum form of Proposition 2.6.1.  The input uses the
linear-MGF branch of the five-way interface; the conclusion exposes both the
same branch for the sum and the corresponding exact-gauge scale bound. -/
theorem independentCenteredSubGaussianSum
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i, SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2) :
    ∃ C : ℝ, 1 ≤ C ∧
      SubGaussianProperty μ (fun ω => ∑ i, X i ω) .linearMGF
        (Real.sqrt (∑ i, K i ^ 2)) ∧
      PsiTwoGauge μ (fun ω => ∑ i, X i ω) ≤
        ENNReal.ofReal (C * Real.sqrt (∑ i, K i ^ 2)) := by
  let S : Ω → ℝ := fun ω => ∑ i, X i ω
  let E : ℝ := ∑ i, K i ^ 2
  have hE : 0 < E := by simpa [E] using hEnergy
  have hS_meas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ => (hX i).1)
  have hS_int : Integrable S μ := by
    dsimp [S]
    simpa only [Finset.sum_apply] using
      (integrable_finset_sum (μ := μ) Finset.univ
        (fun i hi => (hX i).2.2.1))
  have hS_mean : (∫ ω, S ω ∂μ) = 0 := by
    dsimp [S]
    rw [integral_finset_sum]
    · exact Finset.sum_eq_zero (fun i hi => (hX i).2.2.2.1)
    · exact fun i hi => (hX i).2.2.1
  have hS_exp (lam : ℝ) :
      Integrable (fun ω => Real.exp (lam * S ω)) μ := by
    have h := hIndep.integrable_exp_mul_sum
      (fun i => (hX i).1) (s := Finset.univ)
      (fun i hi => by simpa using ((hX i).2.2.2.2 lam).1)
    simpa [S] using h
  have hS_mgf (lam : ℝ) :
      (∫ ω, Real.exp (lam * S ω) ∂μ) ≤ Real.exp (E * lam ^ 2) := by
    have hFactor (i : ι) :
        (∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
          Real.exp (K i ^ 2 * lam ^ 2) := by
      simpa using ((hX i).2.2.2.2 lam).2
    have hProd :
        (∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
          ∏ i, Real.exp (K i ^ 2 * lam ^ 2) := by
      apply Finset.prod_le_prod
      · intro i hi
        exact integral_nonneg (fun ω => Real.exp_nonneg _)
      · intro i hi
        exact hFactor i
    have hFactorization :=
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
        (μ := μ) (X := X) lam (fun _ => (1 : ℝ)) hIndep
        (fun i => by simpa using ((hX i).2.2.2.2 lam).1)
    calc
      (∫ ω, Real.exp (lam * S ω) ∂μ) =
          ∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ := by
            simpa [S] using hFactorization
      _ ≤ ∏ i, Real.exp (K i ^ 2 * lam ^ 2) := hProd
      _ = Real.exp (E * lam ^ 2) := by
        rw [← Real.exp_sum]
        congr 1
        dsimp [E]
        rw [Finset.sum_mul]
  have hS_linear :
      SubGaussianLinearMGF μ S (Real.sqrt E) := by
    refine ⟨hS_meas, Real.sqrt_pos.2 hE, hS_int, hS_mean, ?_⟩
    intro lam
    refine ⟨hS_exp lam, ?_⟩
    simpa [Real.sq_sqrt hE.le, E, mul_comm] using hS_mgf lam
  rcases psiTwoGaugeCharacterizations
      (μ := μ) (X := S) ⟨hS_int, hS_mean⟩ with
    ⟨C, hC, hGauge, _⟩
  refine ⟨C, hC, ?_, ?_⟩
  · simpa [S, E] using hS_linear
  · exact hGauge .linearMGF (by positivity) hS_linear

/-! The tail form of Theorem 2.6.2.  The positive energy hypothesis keeps the
    denominator nonzero; the all-zero family is handled separately by the
    deterministic branch rather than by an undefined quotient. -/
theorem independentCenteredSubGaussianTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i, SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * ∑ i, K i ^ 2)) := by
  let S : Ω → ℝ := fun ω => ∑ i, X i ω
  let E : ℝ := ∑ i, K i ^ 2
  have hE : 0 < E := by simpa [E] using hEnergy
  rcases independentCenteredSubGaussianSum hX hIndep hEnergy with
    ⟨_, _, hS, _⟩
  have hTail := subGaussianLinearToTail hS
  have hBound := hTail.2.2 t ht
  convert hBound using 1;
    norm_num [S, E, mul_pow, Real.sq_sqrt hE.le]

/-! The weighted linear-form version of Theorem 2.6.3.  As in the preceding
tail theorem, the source's ψ₂ scale is represented by a common positive
linear-MGF scale; positive coefficient energy keeps the displayed
denominator nonzero. -/
theorem independentWeightedCenteredSubGaussianTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hK : 0 < K)
    (hX : ∀ i, SubGaussianLinearMGF μ (X i) K)
    (hIndep : iIndepFun X μ)
    {a : ι → ℝ}
    (hEnergy : 0 < ∑ i, a i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * K ^ 2 * ∑ i, a i ^ 2)) := by
  let Y : ι → Ω → ℝ := fun i ω => a i * X i ω
  let S : Ω → ℝ := fun ω => ∑ i, Y i ω
  let A : ℝ := ∑ i, a i ^ 2
  have hA : 0 < A := by simpa [A] using hEnergy
  have hY_meas : ∀ i, Measurable (Y i) := by
    intro i
    dsimp [Y]
    exact measurable_const.mul (hX i).1
  have hIndepY : iIndepFun Y μ := by
    have h := hIndep.comp (fun i x => a i * x) (fun i => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have hS_meas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ => hY_meas i)
  have hS_int : Integrable S μ := by
    dsimp [S]
    simpa only [Finset.sum_apply] using
      (integrable_finset_sum (μ := μ) Finset.univ
        (fun i hi => (hX i).2.2.1.const_mul (a i)))
  have hS_mean : (∫ ω, S ω ∂μ) = 0 := by
    dsimp [S]
    rw [integral_finset_sum]
    · apply Finset.sum_eq_zero
      intro i hi
      rw [integral_const_mul, (hX i).2.2.2.1]
      ring
    · exact fun i hi => (hX i).2.2.1.const_mul (a i)
  have hS_exp (lam : ℝ) :
      Integrable (fun ω => Real.exp (lam * S ω)) μ := by
    have h := hIndepY.integrable_exp_mul_sum
      hY_meas (s := Finset.univ)
      (fun i hi => by
        convert ((hX i).2.2.2.2 (lam * a i)).1 using 1
        all_goals simp [Y]
        all_goals ring)
    simpa [S] using h
  have hS_mgf (lam : ℝ) :
      (∫ ω, Real.exp (lam * S ω) ∂μ) ≤
        Real.exp (K ^ 2 * lam ^ 2 * A) := by
    have hFactor (i : ι) :
        (∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) ≤
          Real.exp (K ^ 2 * (lam * a i) ^ 2) := by
      simpa [Y, mul_assoc, mul_left_comm, mul_comm] using
        ((hX i).2.2.2.2 (lam * a i)).2
    have hProd :
        (∏ i, ∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ) ≤
          ∏ i, Real.exp (K ^ 2 * (lam * a i) ^ 2) := by
      apply Finset.prod_le_prod
      · intro i hi
        exact integral_nonneg (fun ω => Real.exp_nonneg _)
      · intro i hi
        exact hFactor i
    have hFactorization :=
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
        (μ := μ) (X := Y) lam (fun _ => (1 : ℝ)) hIndepY
        (fun i => by
          convert ((hX i).2.2.2.2 (lam * a i)).1 using 1
          all_goals simp [Y]
          all_goals ring)
    calc
      (∫ ω, Real.exp (lam * S ω) ∂μ) =
          ∏ i, ∫ ω, Real.exp (lam * (1 * Y i ω)) ∂μ := by
            simpa [S] using hFactorization
      _ ≤ ∏ i, Real.exp (K ^ 2 * (lam * a i) ^ 2) := hProd
      _ = Real.exp (K ^ 2 * lam ^ 2 * A) := by
        rw [← Real.exp_sum]
        congr 1
        dsimp [A]
        simp_rw [mul_pow]
        rw [Finset.mul_sum]
        ring
  let L : ℝ := K * Real.sqrt A
  have hL : 0 < L := by
    dsimp [L]
    exact mul_pos hK (Real.sqrt_pos.2 hA)
  have hS_linear : SubGaussianLinearMGF μ S L := by
    refine ⟨hS_meas, hL, hS_int, hS_mean, ?_⟩
    intro lam
    refine ⟨hS_exp lam, ?_⟩
    have hLsq : L ^ 2 = K ^ 2 * A := by
      dsimp [L]
      rw [mul_pow, Real.sq_sqrt hA.le]
    calc
      (∫ ω, Real.exp (lam * S ω) ∂μ) ≤
          Real.exp (K ^ 2 * lam ^ 2 * A) := hS_mgf lam
      _ = Real.exp (L ^ 2 * lam ^ 2) := by rw [hLsq]; ring
  have hBound := (subGaussianLinearToTail hS_linear).2.2 t ht
  have hDen : (2 * L) ^ 2 = 4 * K ^ 2 * A := by
    dsimp [L]
    simp only [mul_pow]
    rw [Real.sq_sqrt hA.le]
    ring
  rw [hDen] at hBound
  simpa [S, Y, A] using hBound

/-! The exact gauge is subadditive at the level of admissible scales.  This is
the analytic core needed before passing to the a.e. quotient in Exercise
2.5.7. -/
lemma psiTwoAdmissible_add_of_admissible
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {s t : ℝ≥0∞}
    (hs : PsiTwoAdmissible μ X s) (ht : PsiTwoAdmissible μ Y t) :
    PsiTwoAdmissible μ (fun ω => X ω + Y ω) (s + t) := by
  rcases hs with ⟨hX, hs0, hsTop, hXs, hXbound⟩
  rcases ht with ⟨hY, ht0, htTop, hYt, hYbound⟩
  have hspos : 0 < s.toReal := ENNReal.toReal_pos hs0 hsTop
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hstTop : s + t ≠ ∞ := ENNReal.add_ne_top.2 ⟨hsTop, htTop⟩
  have hst0 : s + t ≠ 0 := by
    simp [hs0, ht0]
  have hstpos : 0 < (s + t).toReal := ENNReal.toReal_pos hst0 hstTop
  have hstreal : (s + t).toReal = s.toReal + t.toReal := by
    simpa using ENNReal.toReal_add hsTop htTop
  let a : ℝ := s.toReal / (s + t).toReal
  let b : ℝ := t.toReal / (s + t).toReal
  have ha : 0 ≤ a := div_nonneg hspos.le hstpos.le
  have hb : 0 ≤ b := div_nonneg htpos.le hstpos.le
  have hab : a + b = 1 := by
    dsimp [a, b]
    rw [hstreal]
    field_simp
  have harg : ∀ ω,
      (X ω + Y ω) ^ 2 / (s + t).toReal ^ 2 ≤
        a * (X ω ^ 2 / s.toReal ^ 2) + b * (Y ω ^ 2 / t.toReal ^ 2) := by
    intro ω
    have hsq := sq_nonneg (t.toReal * X ω - s.toReal * Y ω)
    dsimp [a, b]
    rw [hstreal]
    field_simp
    nlinarith
  have hpoint : ∀ ω,
      Real.exp ((X ω + Y ω) ^ 2 / (s + t).toReal ^ 2) ≤
        a * Real.exp (X ω ^ 2 / s.toReal ^ 2) +
          b * Real.exp (Y ω ^ 2 / t.toReal ^ 2) := by
    intro ω
    have hconv := convexOn_exp.2
      (show X ω ^ 2 / s.toReal ^ 2 ∈ Set.univ by trivial)
      (show Y ω ^ 2 / t.toReal ^ 2 ∈ Set.univ by trivial)
      ha hb hab
    exact (Real.exp_le_exp.mpr (harg ω)).trans hconv
  have hsum : Integrable (fun ω =>
      a * Real.exp (X ω ^ 2 / s.toReal ^ 2) +
        b * Real.exp (Y ω ^ 2 / t.toReal ^ 2)) μ := by
    exact (hXs.const_mul a).add (hYt.const_mul b)
  have hInt : Integrable
      (fun ω => Real.exp ((X ω + Y ω) ^ 2 / (s + t).toReal ^ 2)) μ := by
    refine MeasureTheory.Integrable.mono' hsum ?_ ?_
    · fun_prop
    · filter_upwards [] with ω
      simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hpoint ω
  refine ⟨hX.add hY, hst0, hstTop, hInt, ?_⟩
  have hmono := MeasureTheory.integral_mono_ae hInt hsum
    (Filter.Eventually.of_forall hpoint)
  calc
    (∫ ω, Real.exp ((X ω + Y ω) ^ 2 / (s + t).toReal ^ 2) ∂μ) ≤
        ∫ ω, a * Real.exp (X ω ^ 2 / s.toReal ^ 2) +
          b * Real.exp (Y ω ^ 2 / t.toReal ^ 2) ∂μ := hmono
    _ = a * (∫ ω, Real.exp (X ω ^ 2 / s.toReal ^ 2) ∂μ) +
          b * (∫ ω, Real.exp (Y ω ^ 2 / t.toReal ^ 2) ∂μ) := by
      rw [MeasureTheory.integral_add (hXs.const_mul a) (hYt.const_mul b),
        MeasureTheory.integral_const_mul, MeasureTheory.integral_const_mul]
    _ ≤ a * 2 + b * 2 := by
      gcongr
    _ = 2 := by rw [← add_mul, hab, one_mul]

lemma psiTwoAdmissible_neg_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {t : ℝ≥0∞} :
    PsiTwoAdmissible μ (fun ω => -X ω) t ↔ PsiTwoAdmissible μ X t := by
  constructor <;> intro h
  · rcases h with ⟨hX, ht0, htTop, hInt, hBound⟩
    have hX' : Measurable X := by simpa using hX.neg
    refine ⟨hX', ht0, htTop, ?_, ?_⟩
    · simpa [sq] using hInt
    · simpa [sq] using hBound
  · rcases h with ⟨hX, ht0, htTop, hInt, hBound⟩
    refine ⟨hX.neg, ht0, htTop, ?_, ?_⟩
    · simpa [sq] using hInt
    · simpa [sq] using hBound

theorem psiTwoGauge_neg
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    PsiTwoGauge μ (fun ω => -X ω) = PsiTwoGauge μ X := by
  unfold PsiTwoGauge
  congr 1
  ext t
  exact psiTwoAdmissible_neg_iff

theorem psiTwoGauge_add_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} :
    PsiTwoGauge μ (fun ω => X ω + Y ω) ≤
      PsiTwoGauge μ X + PsiTwoGauge μ Y := by
  change sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ (fun ω => X ω + Y ω) t} ≤
    sInf {s : ℝ≥0∞ | PsiTwoAdmissible μ X s} +
      sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ Y t}
  simp only [sInf_eq_iInf]
  apply ENNReal.le_iInf₂_add_iInf₂
  intro s hs t ht
  have hadd := psiTwoAdmissible_add_of_admissible hs ht
  exact iInf_le_of_le (s + t) (iInf_le_of_le hadd le_rfl)

lemma psiTwoAdmissible_smul_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {c : ℝ} (hc : c ≠ 0)
    {t : ℝ≥0∞} (ht0 : t ≠ 0) (htTop : t ≠ ∞) :
    PsiTwoAdmissible μ (fun ω => c * X ω) (ENNReal.ofReal |c| * t) ↔
      PsiTwoAdmissible μ X t := by
  have hcabs : 0 < |c| := abs_pos.mpr hc
  have hcof0 : ENNReal.ofReal |c| ≠ 0 :=
    (ENNReal.ofReal_ne_zero_iff).2 hcabs
  have hct0 : ENNReal.ofReal |c| * t ≠ 0 := by
    exact mul_ne_zero hcof0 ht0
  have hctTop : ENNReal.ofReal |c| * t ≠ ∞ := by
    exact ENNReal.mul_ne_top ENNReal.ofReal_ne_top htTop
  have hscale : (ENNReal.ofReal |c| * t).toReal = |c| * t.toReal := by
    simp [ENNReal.toReal_mul]
  have harg : ∀ ω,
      (c * X ω) ^ 2 / (|c| * t.toReal) ^ 2 = X ω ^ 2 / t.toReal ^ 2 := by
    intro ω
    field_simp [ne_of_gt hcabs, ne_of_gt (ENNReal.toReal_pos ht0 htTop)]
    rw [sq_abs]
    ring
  have harg' : ∀ ω,
      (c * X ω) ^ 2 * ((|c| * t.toReal) ^ 2)⁻¹ =
        X ω ^ 2 * (t.toReal ^ 2)⁻¹ := by
    intro ω
    simpa [div_eq_mul_inv] using harg ω
  constructor
  · intro h
    rcases h with ⟨hX, _, _, hInt, hBound⟩
    have hX' : Measurable X := by
      have := hX.const_mul c⁻¹
      simpa [hc, mul_assoc] using this
    refine ⟨hX', ht0, htTop, ?_, ?_⟩
    · simpa only [hscale, div_eq_mul_inv, harg'] using hInt
    · simpa only [hscale, div_eq_mul_inv, harg'] using hBound
  · intro h
    rcases h with ⟨hX, _, _, hInt, hBound⟩
    refine ⟨hX.const_mul c, hct0, hctTop, ?_, ?_⟩
    · simpa only [hscale, div_eq_mul_inv, harg'] using hInt
    · simpa only [hscale, div_eq_mul_inv, harg'] using hBound

theorem psiTwoGauge_smul_of_ne_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {c : ℝ} (hc : c ≠ 0) :
    PsiTwoGauge μ (fun ω => c * X ω) =
      ENNReal.ofReal |c| * PsiTwoGauge μ X := by
  let a : ℝ≥0∞ := ENNReal.ofReal |c|
  have ha0 : a ≠ 0 := by
    dsimp [a]
    exact (ENNReal.ofReal_ne_zero_iff).2 (abs_pos.mpr hc)
  have haTop : a ≠ ∞ := by
    exact ENNReal.ofReal_ne_top
  apply le_antisymm
  · rw [show PsiTwoGauge μ (fun ω => c * X ω) =
      sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ (fun ω => c * X ω) t} by rfl,
      show PsiTwoGauge μ X =
        sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ X t} by rfl,
      sInf_eq_iInf', sInf_eq_iInf']
    rw [ENNReal.mul_iInf_of_ne ha0 haTop]
    apply le_iInf
    intro t
    exact iInf_le_of_le ⟨a * t.1, by
      have hiff := psiTwoAdmissible_smul_iff (μ := μ) (X := X) hc
        t.2.2.1 t.2.2.2.1
      exact hiff.2 t.2⟩ le_rfl
  · rw [show PsiTwoGauge μ (fun ω => c * X ω) =
      sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ (fun ω => c * X ω) t} by rfl,
      show PsiTwoGauge μ X =
        sInf {t : ℝ≥0∞ | PsiTwoAdmissible μ X t} by rfl,
      sInf_eq_iInf', sInf_eq_iInf']
    rw [ENNReal.mul_iInf_of_ne ha0 haTop]
    apply le_iInf
    intro t
    have hiff := psiTwoAdmissible_smul_iff (μ := μ)
      (X := fun ω => c * X ω) (c := c⁻¹) (inv_ne_zero hc)
      t.2.2.1 t.2.2.2.1
    have hscaled : PsiTwoAdmissible μ X
        (ENNReal.ofReal |c⁻¹| * t.1) := by
      have hfun : (fun ω => c⁻¹ * (c * X ω)) = X := by
        funext ω
        field_simp [hc]
      simpa [hfun] using hiff.2 t.2
    have hca : ENNReal.ofReal |c| * ENNReal.ofReal |c⁻¹| = 1 := by
      rw [← ENNReal.ofReal_mul (abs_nonneg c)]
      simp [abs_inv, hc]
    have hmul : a * (ENNReal.ofReal |c⁻¹| * t.1) = t.1 := by
      dsimp [a]
      rw [← mul_assoc, hca, one_mul]
    exact iInf_le_of_le ⟨ENNReal.ofReal |c⁻¹| * t.1, hscaled⟩ (by
      exact le_of_eq hmul)

theorem psiTwoGauge_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] :
    PsiTwoGauge μ (fun _ : Ω => (0 : ℝ)) = 0 := by
  apply le_antisymm
  · apply le_of_forall_gt_imp_ge_of_dense
    intro r hr
    by_cases hrTop : r = ∞
    · simp [hrTop]
    have hr0 : r ≠ 0 := ne_of_gt hr
    have hAd : PsiTwoAdmissible μ (fun _ : Ω => (0 : ℝ)) r := by
      refine ⟨measurable_const, hr0, hrTop, ?_, ?_⟩
      · simp
      · simp
    exact sInf_le hAd
  · exact bot_le

lemma psiTwoAdmissible_ae_congr
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} (hX : Measurable X) (hY : Measurable Y)
    (hXY : X =ᵐ[μ] Y) {t : ℝ≥0∞} :
    PsiTwoAdmissible μ X t ↔ PsiTwoAdmissible μ Y t := by
  have hfun : (fun ω => Real.exp (X ω ^ 2 / t.toReal ^ 2)) =ᵐ[μ]
      (fun ω => Real.exp (Y ω ^ 2 / t.toReal ^ 2)) := by
    filter_upwards [hXY] with ω hω
    simp [hω]
  constructor
  · intro h
    rcases h with ⟨_, ht0, htTop, hInt, hBound⟩
    refine ⟨hY, ht0, htTop, hInt.congr hfun, ?_⟩
    rw [integral_congr_ae hfun] at hBound
    exact hBound
  · intro h
    rcases h with ⟨_, ht0, htTop, hInt, hBound⟩
    refine ⟨hX, ht0, htTop, hInt.congr hfun.symm, ?_⟩
    rw [integral_congr_ae hfun.symm] at hBound
    exact hBound

theorem psiTwoGauge_ae_congr
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} (hX : Measurable X) (hY : Measurable Y)
    (hXY : X =ᵐ[μ] Y) :
    PsiTwoGauge μ X = PsiTwoGauge μ Y := by
  unfold PsiTwoGauge
  congr 1
  ext t
  exact psiTwoAdmissible_ae_congr hX hY hXY

lemma psiTwoAdmissible_mono
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {s u : ℝ≥0∞}
    (hs : PsiTwoAdmissible μ X s) (hsu : s ≤ u)
    (hu0 : u ≠ 0) (huTop : u ≠ ∞) :
    PsiTwoAdmissible μ X u := by
  rcases hs with ⟨hX, hs0, hsTop, hInt, hBound⟩
  have hspos : 0 < s.toReal := ENNReal.toReal_pos hs0 hsTop
  have hupos : 0 < u.toReal := ENNReal.toReal_pos hu0 huTop
  have hsto : s.toReal ≤ u.toReal := ENNReal.toReal_mono huTop hsu
  have hsq : s.toReal ^ 2 ≤ u.toReal ^ 2 :=
    (sq_le_sq₀ hspos.le hupos.le).2 hsto
  have harg : ∀ ω,
      X ω ^ 2 / u.toReal ^ 2 ≤ X ω ^ 2 / s.toReal ^ 2 := by
    intro ω
    apply (div_le_div_iff₀ (by positivity : 0 < u.toReal ^ 2)
      (by positivity : 0 < s.toReal ^ 2)).2
    exact mul_le_mul_of_nonneg_left hsq (sq_nonneg (X ω))
  have hpoint : ∀ ω,
      Real.exp (X ω ^ 2 / u.toReal ^ 2) ≤
        Real.exp (X ω ^ 2 / s.toReal ^ 2) := fun ω =>
    Real.exp_le_exp.mpr (harg ω)
  have hInt' : Integrable (fun ω => Real.exp (X ω ^ 2 / u.toReal ^ 2)) μ := by
    refine MeasureTheory.Integrable.mono' hInt ?_ ?_
    · fun_prop
    · filter_upwards [] with ω
      simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hpoint ω
  refine ⟨hX, hu0, huTop, hInt', ?_⟩
  exact (MeasureTheory.integral_mono_ae hInt' hInt
    (Filter.Eventually.of_forall hpoint)).trans hBound

lemma psiTwoAdmissible_of_gauge_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : Measurable X) (hGauge : PsiTwoGauge μ X = 0) {K : ℝ} (hK : 0 < K) :
    PsiTwoAdmissible μ X (ENNReal.ofReal K) := by
  have hlt : PsiTwoGauge μ X < ENNReal.ofReal K := by
    rw [hGauge]
    exact ENNReal.ofReal_pos.mpr hK
  unfold PsiTwoGauge at hlt
  rcases (sInf_lt_iff.mp hlt) with ⟨s, hs, hsK⟩
  have hMono := psiTwoAdmissible_mono hs hsK.le
    ((ENNReal.ofReal_ne_zero_iff).2 hK) ENNReal.ofReal_ne_top
  exact ⟨hX, hMono.2⟩

theorem psiTwoGauge_eq_zero_iff_ae_eq_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : Measurable X) :
    PsiTwoGauge μ X = 0 ↔ X =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
  constructor
  · intro hGauge
    have hTail : ∀ K : ℝ, 0 < K → ∀ t : ℝ, 0 ≤ t →
        μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2) := by
      intro K hK t ht
      have hAd := psiTwoAdmissible_of_gauge_zero hX hGauge hK
      have hPoint : SubGaussianSquarePoint μ X K := by
        refine ⟨hX, hK, ?_, ?_⟩
        · simpa [ENNReal.toReal_ofReal hK.le] using hAd.2.2.2.1
        · simpa [ENNReal.toReal_ofReal hK.le] using hAd.2.2.2.2
      exact squareMGFToTail hX hK ⟨hPoint.2.2.1, hPoint.2.2.2⟩ ht
    have hLpOne : LpMomentGrowth μ X (8 * Real.exp 1) := by
      have h := tailToLpMomentGrowth hX (by norm_num : (0 : ℝ) < 1)
        (hTail 1 (by norm_num))
      simpa using h
    have hInt : Integrable (fun ω => |X ω|) μ := by
      have h := hLpOne.2 1 (by norm_num : (1 : ℝ) ≤ 1)
      simpa using h.1
    have hBound : ∀ K : ℝ, 0 < K →
        (∫ ω, |X ω| ∂μ) ≤ 8 * Real.exp 1 * K := by
      intro K hK
      have hLp := tailToLpMomentGrowth hX hK (hTail K hK)
      have h := hLp.2 1 (by norm_num : (1 : ℝ) ≤ 1)
      simpa using h.2
    have hIntegralZero : (∫ ω, |X ω| ∂μ) = 0 := by
      apply le_antisymm
      · apply le_of_forall_gt_imp_ge_of_dense
        intro ε hε
        have hK : 0 < ε / (8 * Real.exp 1) := by positivity
        calc
          (∫ ω, |X ω| ∂μ) ≤ 8 * Real.exp 1 * (ε / (8 * Real.exp 1)) := by
            exact (hBound (ε / (8 * Real.exp 1)) hK).trans_eq (by
              field_simp)
          _ = ε := by field_simp
      · exact integral_nonneg_of_ae
          (Filter.Eventually.of_forall (fun ω => abs_nonneg (X ω)))
    have hAbs : (fun ω => |X ω|) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) :=
      (integral_eq_zero_iff_of_nonneg
        (fun ω => abs_nonneg (X ω)) hInt).mp hIntegralZero
    filter_upwards [hAbs] with ω hω
    exact abs_eq_zero.mp hω
  · intro hZero
    rw [psiTwoGauge_ae_congr hX measurable_const hZero]
    exact psiTwoGauge_zero

/-- At every positive finite exact `ψ₂` gauge, the defining exponential-square
bound is attained.  Fatou's lemma closes the infimum over larger admissible
scales. -/
theorem psiTwoGauge_squarePoint_of_pos
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞)
    (hGaugePos : 0 < PsiTwoGauge μ X) :
    SubGaussianSquarePoint μ X (PsiTwoGauge μ X).toReal := by
  have hGaugeTop : PsiTwoGauge μ X ≠ ∞ := ne_of_lt hFinite
  have hGaugeZero : PsiTwoGauge μ X ≠ 0 := ne_of_gt hGaugePos
  have hGaugeRealPos : 0 < (PsiTwoGauge μ X).toReal :=
    ENNReal.toReal_pos hGaugeZero hGaugeTop
  let K : ℕ → ℝ := fun n =>
    (PsiTwoGauge μ X).toReal + 1 / ((n : ℝ) + 1)
  have hKPos : ∀ n, 0 < K n := by
    intro n
    dsimp [K]
    positivity
  have hGaugeLt : ∀ n, PsiTwoGauge μ X < ENNReal.ofReal (K n) := by
    intro n
    rw [← ENNReal.ofReal_toReal hGaugeTop]
    exact (ENNReal.ofReal_lt_ofReal_iff (hKPos n)).2 (by
      dsimp [K]
      have heps : 0 < 1 / ((n : ℝ) + 1) := by positivity
      linarith)
  have hAd : ∀ n, PsiTwoAdmissible μ X (ENNReal.ofReal (K n)) := by
    intro n
    have hlt := hGaugeLt n
    unfold PsiTwoGauge at hlt
    rcases (sInf_lt_iff.mp hlt) with ⟨s, hs, hsK⟩
    exact psiTwoAdmissible_mono hs hsK.le
      ((ENNReal.ofReal_ne_zero_iff).2 (hKPos n)) ENNReal.ofReal_ne_top
  have hPoint : ∀ n, SubGaussianSquarePoint μ X (K n) := by
    intro n
    have h := hAd n
    refine ⟨h.1, hKPos n, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal (hKPos n).le] using h.2.2.2.1
    · simpa [ENNReal.toReal_ofReal (hKPos n).le] using h.2.2.2.2
  let f : ℕ → Ω → ℝ≥0∞ := fun n ω =>
    ENNReal.ofReal (Real.exp (X ω ^ 2 / (K n) ^ 2))
  let F : Ω → ℝ≥0∞ := fun ω =>
    ENNReal.ofReal
      (Real.exp (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2))
  have hK_tendsto : Tendsto K atTop
      (nhds (PsiTwoGauge μ X).toReal) := by
    dsimp [K]
    simpa using tendsto_const_nhds.add
      (tendsto_one_div_add_atTop_nhds_zero_nat :
        Tendsto (fun n : ℕ => 1 / ((n : ℝ) + 1)) atTop (nhds 0))
  have hfMeas : ∀ n, Measurable (f n) := by
    intro n
    dsimp [f]
    fun_prop
  have hfTendsto : ∀ ω, Tendsto (fun n => f n ω) atTop (nhds (F ω)) := by
    intro ω
    have hrealcont : ContinuousAt
        (fun k : ℝ => Real.exp (X ω ^ 2 / k ^ 2))
        (PsiTwoGauge μ X).toReal := by
      fun_prop (disch := positivity)
    have hcont : ContinuousAt
        (fun k : ℝ => ENNReal.ofReal (Real.exp (X ω ^ 2 / k ^ 2)))
        (PsiTwoGauge μ X).toReal := by
      simpa only [Function.comp_apply] using
        ENNReal.continuous_ofReal.continuousAt.comp hrealcont
    exact hcont.tendsto.comp hK_tendsto
  have hFatou : (∫⁻ ω, F ω ∂μ) ≤
      liminf (fun n => ∫⁻ ω, f n ω ∂μ) atTop := by
    have h := lintegral_liminf_le (μ := μ) hfMeas
    simpa only [(hfTendsto _).liminf_eq] using h
  have hLinBound : ∀ n, (∫⁻ ω, f n ω ∂μ) ≤ ENNReal.ofReal 2 := by
    intro n
    rw [← ofReal_integral_eq_lintegral_ofReal (hPoint n).2.2.1
      (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))]
    exact ENNReal.ofReal_le_ofReal (hPoint n).2.2.2
  have hFBound : (∫⁻ ω, F ω ∂μ) ≤ ENNReal.ofReal 2 :=
    hFatou.trans (Filter.liminf_le_of_frequently_le'
      (Filter.Frequently.of_forall hLinBound))
  have hTargetInt : Integrable
      (fun ω => Real.exp
        (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)) μ := by
    refine ⟨?_, ?_⟩
    · fun_prop
    · rw [hasFiniteIntegral_iff_enorm]
      have hEq : (fun ω =>
          ‖Real.exp (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)‖ₑ) = F := by
        funext ω
        simpa [F] using (ofReal_norm_eq_enorm
          (Real.exp
            (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2))).symm
      rw [hEq]
      exact hFBound.trans_lt ENNReal.ofReal_lt_top
  refine ⟨hX, hGaugeRealPos, hTargetInt, ?_⟩
  rw [integral_eq_lintegral_of_nonneg_ae
    (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
    hTargetInt.aestronglyMeasurable]
  change (∫⁻ ω, F ω ∂μ).toReal ≤ 2
  exact ENNReal.toReal_le_of_le_ofReal (by positivity) hFBound

/-! Section 2.5 body display following Equation (2.16).  Unlike
`SubGaussianSquarePoint`, this statement retains the source's zero-gauge
variable and totalizes its displayed quotient in the standard Lean way. -/
theorem psiTwoGauge_squareMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞) :
    Integrable
        (fun ω => Real.exp
          (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)) μ ∧
      (∫ ω, Real.exp
        (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2) ∂μ) ≤ 2 := by
  by_cases hGaugeZero : PsiTwoGauge μ X = 0
  · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
      (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
    have hFun : (fun ω => Real.exp
        (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)) =ᵐ[μ]
        (fun _ω : Ω => (1 : ℝ)) := by
      filter_upwards [hXZero] with ω hω
      simp [hω, hGaugeZero]
    have hInt : Integrable (fun ω => Real.exp
        (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)) μ :=
      (integrable_const (1 : ℝ)).congr hFun.symm
    refine ⟨hInt, ?_⟩
    rw [integral_congr_ae hFun]
    simp
  · have hGaugePos : 0 < PsiTwoGauge μ X :=
      bot_lt_iff_ne_bot.mpr hGaugeZero
    have hPoint := psiTwoGauge_squarePoint_of_pos hX hFinite hGaugePos
    exact ⟨hPoint.2.2.1, hPoint.2.2.2⟩

/-! Equation (2.14): the exact `ψ₂` gauge gives a sub-Gaussian tail with
one universal numerical constant.  The factor two in the scale corresponds to
the source exponent constant `c = 1 / 4`; it also makes the infimum-based
definition usable without assuming that the infimum is attained. -/
theorem psiTwoGaugeToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤
      2 * Real.exp
        (-t ^ 2 / (2 * (PsiTwoGauge μ X).toReal) ^ 2) := by
  by_cases hGaugeZero : PsiTwoGauge μ X = 0
  · by_cases htZero : t = 0
    · subst t
      have hset : {ω | |X ω| ≥ (0 : ℝ)} = Set.univ := by
        ext ω
        simp [abs_nonneg]
      rw [hset]
      simp [hGaugeZero]
    · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
        (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
      have hEvent : {ω | |X ω| ≥ t} =ᵐ[μ] (∅ : Set Ω) := by
        filter_upwards [hXZero] with ω hω
        change (t ≤ |X ω|) = False
        rw [hω, abs_zero]
        exact propext (iff_false_intro
          (not_le_of_gt (lt_of_le_of_ne ht (Ne.symm htZero))))
      rw [Measure.real_def, measure_congr hEvent]
      simp only [measure_empty, ENNReal.toReal_zero]
      positivity
  · let u : ℝ≥0∞ := 2 * PsiTwoGauge μ X
    have hu0 : u ≠ 0 := by
      dsimp [u]
      exact mul_ne_zero (by norm_num) hGaugeZero
    have huTop : u ≠ ∞ := by
      dsimp [u]
      exact ENNReal.mul_ne_top (by norm_num) (ne_of_lt hFinite)
    have hGaugeLt : PsiTwoGauge μ X < u := by
      dsimp [u]
      simpa [mul_comm] using ENNReal.mul_lt_mul_right hGaugeZero
        (ne_of_lt hFinite) (by norm_num : (1 : ℝ≥0∞) < 2)
    have huAdmissible : PsiTwoAdmissible μ X u := by
      unfold PsiTwoGauge at hGaugeLt
      rcases (sInf_lt_iff.mp hGaugeLt) with ⟨s, hs, hsu⟩
      exact psiTwoAdmissible_mono hs hsu.le hu0 huTop
    have huPos : 0 < u.toReal := ENNReal.toReal_pos hu0 huTop
    have hPoint : SubGaussianSquarePoint μ X u.toReal :=
      ⟨huAdmissible.1, huPos, huAdmissible.2.2.2.1,
        huAdmissible.2.2.2.2⟩
    have hTail := squareMGFToTail hPoint.1 hPoint.2.1
      ⟨hPoint.2.2.1, hPoint.2.2.2⟩ ht
    simpa [u, ENNReal.toReal_mul] using hTail

/-! Equation (2.15): finite exact `ψ₂` gauge controls every `Lᵖ` moment
with one universal numerical constant. -/
theorem psiTwoGaugeToLpMomentGrowth
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞) :
    LpMomentGrowth μ X
      (16 * Real.exp 1 * (PsiTwoGauge μ X).toReal) := by
  by_cases hGaugeZero : PsiTwoGauge μ X = 0
  · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
      (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
    refine ⟨hX.aemeasurable, ?_⟩
    intro p hp
    have hp0 : p ≠ 0 := ne_of_gt (lt_of_lt_of_le zero_lt_one hp)
    have hPowZero : (fun ω => |X ω| ^ p) =ᵐ[μ]
        (fun _ω : Ω => (0 : ℝ)) := by
      filter_upwards [hXZero] with ω hω
      simp [hω, hp0]
    have hInt : Integrable (fun ω => |X ω| ^ p) μ := by
      exact (integrable_zero Ω ℝ μ).congr hPowZero.symm
    refine ⟨hInt, ?_⟩
    rw [integral_congr_ae hPowZero]
    simp [hGaugeZero, hp0]
  · have hGaugeRealPos : 0 < (PsiTwoGauge μ X).toReal :=
      ENNReal.toReal_pos hGaugeZero (ne_of_lt hFinite)
    have hTail : ∀ t : ℝ, 0 ≤ t →
        μ.real {ω | |X ω| ≥ t} ≤
          2 * Real.exp
            (-t ^ 2 / (2 * (PsiTwoGauge μ X).toReal) ^ 2) := by
      intro t ht
      exact psiTwoGaugeToTail hX hFinite ht
    have hGrowth := tailToLpMomentGrowth hX (by positivity)
      (K := 2 * (PsiTwoGauge μ X).toReal) hTail
    convert hGrowth using 1
    ring

/-! Equation (2.16): a centered finite-gauge variable has a global linear MGF
bound with one explicit universal coefficient. -/
theorem psiTwoGaugeToMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (lam : ℝ) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp
          ((128 * Real.exp 1) ^ 2 * lam ^ 2 *
            (PsiTwoGauge μ X).toReal ^ 2) := by
  by_cases hGaugeZero : PsiTwoGauge μ X = 0
  · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
      (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
    have hFun : (fun ω => Real.exp (lam * X ω)) =ᵐ[μ]
        (fun _ω : Ω => (1 : ℝ)) := by
      filter_upwards [hXZero] with ω hω
      simp [hω]
    have hInt : Integrable (fun ω => Real.exp (lam * X ω)) μ :=
      (integrable_const (1 : ℝ)).congr hFun.symm
    refine ⟨hInt, ?_⟩
    rw [integral_congr_ae hFun]
    simp [hGaugeZero]
  · have hGaugePos : 0 < PsiTwoGauge μ X :=
      bot_lt_iff_ne_bot.mpr hGaugeZero
    have hPoint := psiTwoGauge_squarePoint_of_pos hX hFinite hGaugePos
    have hTail := subGaussianSquarePointToTail hPoint
    rcases subGaussianFromTail .linearMGF (fun _ => hCenter)
        hPoint.2.1 hTail with ⟨K, hK, hKBound, hLinear⟩
    have hLam := hLinear.2.2.2.2 lam
    refine ⟨hLam.1, hLam.2.trans ?_⟩
    apply Real.exp_le_exp.mpr
    have hSq : K ^ 2 ≤
        (128 * Real.exp 1 * (PsiTwoGauge μ X).toReal) ^ 2 :=
      (sq_le_sq₀ hK.le (by positivity)).2 hKBound
    calc
      K ^ 2 * lam ^ 2 ≤
          (128 * Real.exp 1 * (PsiTwoGauge μ X).toReal) ^ 2 *
            lam ^ 2 := mul_le_mul_of_nonneg_right hSq (sq_nonneg lam)
      _ = (128 * Real.exp 1) ^ 2 * lam ^ 2 *
          (PsiTwoGauge μ X).toReal ^ 2 := by ring

/-! Proposition 2.6.1 in its intrinsic `ψ₂`-norm form.  The absolute
constant is quantified before every family and probability space.  The proof
uses the exact-gauge MGF estimate above, independence, and a separate
zero-energy branch, so no externally chosen scale appears in the statement. -/
theorem independentCenteredSubGaussianSumPsiTwo :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        iIndepFun X μ →
          IsSubGaussian μ (fun ω => ∑ i, X i ω) ∧
            (PsiTwoNorm μ (fun ω => ∑ i, X i ω)).toReal ^ 2 ≤
              C * ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2 := by
  let A : ℝ := 128 * Real.exp 1
  let B : ℝ := 4096 * Real.exp 1
  let C : ℝ := (B * A) ^ 2
  have hAone : 1 ≤ A := by
    dsimp [A]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1)]
  have hBone : 1 ≤ B := by
    dsimp [B]
    nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1)]
  have hBAone : 1 ≤ B * A := by
    have hprod : 0 ≤ (B - 1) * (A - 1) :=
      mul_nonneg (sub_nonneg.mpr hBone) (sub_nonneg.mpr hAone)
    nlinarith
  have hCone : 1 ≤ C := by
    dsimp [C]
    nlinarith [sq_nonneg (B * A)]
  refine ⟨C, hCone, ?_⟩
  intro ι Ω instι instΩ μ instμ X hSub hCenter hIndep
  let S : Ω → ℝ := fun ω => ∑ i, X i ω
  let E : ℝ := ∑ i, (PsiTwoGauge μ (X i)).toReal ^ 2
  have hXMeas : ∀ i, Measurable (X i) := fun i => (hSub i).1
  have hXFinite : ∀ i, PsiTwoGauge μ (X i) < ∞ := by
    intro i
    exact (psiTwoGauge_finite_iff (μ := μ) (X := X i)).2 (hSub i).2
  have hEnonneg : 0 ≤ E := by
    dsimp [E]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hSMeas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ fun i _ => hXMeas i
  have hSInt : Integrable S μ := by
    dsimp [S]
    simpa only [Finset.sum_apply] using
      (integrable_finset_sum (μ := μ) Finset.univ
        (fun i _ => (hCenter i).1))
  have hSMean : (∫ ω, S ω ∂μ) = 0 := by
    dsimp [S]
    rw [integral_finset_sum]
    · exact Finset.sum_eq_zero fun i _ => (hCenter i).2
    · exact fun i _ => (hCenter i).1
  by_cases hEzero : E = 0
  · have hGaugeZero : ∀ i, PsiTwoGauge μ (X i) = 0 := by
      intro i
      have hSqZero : (PsiTwoGauge μ (X i)).toReal ^ 2 = 0 :=
        (Finset.sum_eq_zero_iff_of_nonneg
          (fun j _ => sq_nonneg (PsiTwoGauge μ (X j)).toReal)).mp hEzero i
            (Finset.mem_univ i)
      have hRealZero : (PsiTwoGauge μ (X i)).toReal = 0 := by
        nlinarith [sq_nonneg (PsiTwoGauge μ (X i)).toReal]
      exact ((ENNReal.toReal_eq_zero_iff _).mp hRealZero).resolve_right
        (ne_of_lt (hXFinite i))
    have hXZero : ∀ i, X i =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
      intro i
      exact (psiTwoGauge_eq_zero_iff_ae_eq_zero (hXMeas i)).mp (hGaugeZero i)
    have hAllZero : ∀ᵐ ω ∂μ, ∀ i ∈ (Finset.univ : Finset ι), X i ω = 0 := by
      rw [Filter.eventually_all_finset]
      intro i _
      exact hXZero i
    have hSZero : S =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
      filter_upwards [hAllZero] with ω hω
      simp [S, hω]
    have hSGaugeZero : PsiTwoGauge μ S = 0 :=
      (psiTwoGauge_eq_zero_iff_ae_eq_zero hSMeas).2 hSZero
    have hSSub : IsSubGaussian μ S := by
      refine ⟨hSMeas, ?_⟩
      exact (psiTwoGauge_finite_iff (μ := μ) (X := S)).1 (by
        rw [hSGaugeZero]
        simp)
    refine ⟨by simpa [S] using hSSub, ?_⟩
    simp [PsiTwoNorm, S, hSGaugeZero, E, hEzero]
  · have hEpos : 0 < E := lt_of_le_of_ne hEnonneg (Ne.symm hEzero)
    have hSExp (lam : ℝ) :
        Integrable (fun ω => Real.exp (lam * S ω)) μ := by
      have h := hIndep.integrable_exp_mul_sum hXMeas (s := Finset.univ)
        (fun i _ => by
          simpa using (psiTwoGaugeToMGF (hXMeas i) (hXFinite i)
            (hCenter i) lam).1)
      simpa [S] using h
    have hSMGF (lam : ℝ) :
        (∫ ω, Real.exp (lam * S ω) ∂μ) ≤
          Real.exp (A ^ 2 * lam ^ 2 * E) := by
      have hFactor (i : ι) :
          (∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
            Real.exp (A ^ 2 * lam ^ 2 *
              (PsiTwoGauge μ (X i)).toReal ^ 2) := by
        simpa [A] using (psiTwoGaugeToMGF (hXMeas i) (hXFinite i)
          (hCenter i) lam).2
      have hProd :
          (∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
            ∏ i, Real.exp (A ^ 2 * lam ^ 2 *
              (PsiTwoGauge μ (X i)).toReal ^ 2) := by
        apply Finset.prod_le_prod
        · intro i _
          exact integral_nonneg fun ω => Real.exp_nonneg _
        · intro i _
          exact hFactor i
      have hFactorization :=
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
          (μ := μ) (X := X) lam (fun _ => (1 : ℝ)) hIndep
          (fun i => by
            simpa using (psiTwoGaugeToMGF (hXMeas i) (hXFinite i)
              (hCenter i) lam).1)
      calc
        (∫ ω, Real.exp (lam * S ω) ∂μ) =
            ∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ := by
              simpa [S] using hFactorization
        _ ≤ ∏ i, Real.exp (A ^ 2 * lam ^ 2 *
            (PsiTwoGauge μ (X i)).toReal ^ 2) := hProd
        _ = Real.exp (A ^ 2 * lam ^ 2 * E) := by
          rw [← Real.exp_sum]
          congr 1
          dsimp [E]
          rw [Finset.mul_sum]
    have hKpos : 0 < A * Real.sqrt E :=
      mul_pos (lt_of_lt_of_le zero_lt_one hAone) (Real.sqrt_pos.2 hEpos)
    have hSLinear : SubGaussianLinearMGF μ S (A * Real.sqrt E) := by
      refine ⟨hSMeas, hKpos, hSInt, hSMean, ?_⟩
      intro lam
      refine ⟨hSExp lam, ?_⟩
      have hEsqrt : (Real.sqrt E) ^ 2 = E := Real.sq_sqrt hEpos.le
      convert hSMGF lam using 1
      rw [mul_pow, hEsqrt]
      ring
    have hGaugeBound :
        PsiTwoGauge μ S ≤ ENNReal.ofReal (B * (A * Real.sqrt E)) := by
      simpa [B] using
        (psiTwoGauge_le_of_property .linearMGF hKpos hSLinear)
    have hSFinite : PsiTwoGauge μ S < ∞ :=
      hGaugeBound.trans_lt ENNReal.ofReal_lt_top
    have hGaugeRealBound :
        (PsiTwoGauge μ S).toReal ≤ B * (A * Real.sqrt E) := by
      exact ENNReal.toReal_le_of_le_ofReal (by positivity) hGaugeBound
    have hSqBound :
        (PsiTwoGauge μ S).toReal ^ 2 ≤
          (B * (A * Real.sqrt E)) ^ 2 :=
      (sq_le_sq₀ ENNReal.toReal_nonneg (by positivity)).2 hGaugeRealBound
    have hSSub : IsSubGaussian μ S := by
      refine ⟨hSMeas, ?_⟩
      exact (psiTwoGauge_finite_iff (μ := μ) (X := S)).1 hSFinite
    refine ⟨by simpa [S] using hSSub, ?_⟩
    have hEsqrt : (Real.sqrt E) ^ 2 = E := Real.sq_sqrt hEpos.le
    change (PsiTwoGauge μ S).toReal ^ 2 ≤ C * E
    calc
      (PsiTwoGauge μ S).toReal ^ 2 ≤
          (B * (A * Real.sqrt E)) ^ 2 := hSqBound
      _ = C * E := by
        dsimp [C]
        rw [show B * (A * Real.sqrt E) = (B * A) * Real.sqrt E by ring,
          mul_pow, hEsqrt]

/-! Theorem 2.6.2 in its intrinsic `ψ₂`-norm form.  One positive absolute
constant is quantified before every probability space and family.  The
zero-energy and zero-sum-gauge branches retain the source's universal domain
while making the displayed real quotient total in Lean. -/
theorem independentCenteredSubGaussianTailPsiTwo :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2)) := by
  rcases independentCenteredSubGaussianSumPsiTwo with ⟨C, hC, hSum⟩
  have hCpos : 0 < C := lt_of_lt_of_le zero_lt_one hC
  let c : ℝ := 1 / (4 * C)
  have hc : 0 < c := by
    dsimp [c]
    positivity
  refine ⟨c, hc, ?_⟩
  intro ι Ω instι instΩ μ instμ X hSub hCenter hIndep t ht
  let S : Ω → ℝ := fun ω => ∑ i, X i ω
  let E : ℝ := ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2
  obtain ⟨hSSub, hSBound⟩ := hSum hSub hCenter hIndep
  have hSSub' : IsSubGaussian μ S := by
    simpa [S] using hSSub
  have hSFinite : PsiTwoGauge μ S < ∞ := by
    have hNormFinite := (isSubGaussian_iff_psiTwoNorm_finite
      (μ := μ) (X := S)).1 hSSub'
    simpa [PsiTwoNorm] using hNormFinite
  have hSBound' : (PsiTwoGauge μ S).toReal ^ 2 ≤ C * E := by
    simpa [PsiTwoNorm, S, E] using hSBound
  have hEnonneg : 0 ≤ E := by
    dsimp [E]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hProb (s : Set Ω) : μ.real s ≤ 1 := by
    rw [Measure.real_def]
    exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
  by_cases hEzero : E = 0
  · calc
      μ.real {ω | |∑ i, X i ω| ≥ t} ≤ 1 := hProb _
      _ ≤ 2 * Real.exp
          (-(c * t ^ 2 /
            ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2)) := by
        simp [E, hEzero]
  · have hEpos : 0 < E := lt_of_le_of_ne hEnonneg (Ne.symm hEzero)
    by_cases hGaugeZero : PsiTwoGauge μ S = 0
    · by_cases htZero : t = 0
      · subst t
        calc
          μ.real {ω | |∑ i, X i ω| ≥ 0} ≤ 1 := hProb _
          _ ≤ 2 * Real.exp
              (-(c * 0 ^ 2 /
                ∑ i, (PsiTwoNorm μ (X i)).toReal ^ 2)) := by norm_num
      · have hSZero : S =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) :=
          (psiTwoGauge_eq_zero_iff_ae_eq_zero hSSub'.1).mp hGaugeZero
        have hEvent : {ω | |S ω| ≥ t} =ᵐ[μ] (∅ : Set Ω) := by
          filter_upwards [hSZero] with ω hω
          change (t ≤ |S ω|) = False
          rw [hω, abs_zero]
          exact propext (iff_false_intro
            (not_le_of_gt (lt_of_le_of_ne ht (Ne.symm htZero))))
        have hZeroProb : μ.real {ω | |S ω| ≥ t} = 0 := by
          rw [Measure.real_def, measure_congr hEvent]
          simp
        change μ.real {ω | |S ω| ≥ t} ≤
          2 * Real.exp (-(c * t ^ 2 / E))
        rw [hZeroProb]
        positivity
    · have hGaugeRealPos : 0 < (PsiTwoGauge μ S).toReal :=
        ENNReal.toReal_pos hGaugeZero (ne_of_lt hSFinite)
      have hTail := psiTwoGaugeToTail hSSub'.1 hSFinite ht
      have hDenom :
          (2 * (PsiTwoGauge μ S).toReal) ^ 2 ≤ 4 * C * E := by
        nlinarith [hSBound']
      have hRatio :
          c * t ^ 2 / E ≤
            t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2 := by
        calc
          c * t ^ 2 / E = t ^ 2 / (4 * C * E) := by
            dsimp [c]
            field_simp [ne_of_gt hCpos, ne_of_gt hEpos]
          _ ≤ t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2 := by
            exact div_le_div_of_nonneg_left (sq_nonneg t) (by positivity) hDenom
      change μ.real {ω | |S ω| ≥ t} ≤
        2 * Real.exp (-(c * t ^ 2 / E))
      calc
        μ.real {ω | |S ω| ≥ t} ≤
            2 * Real.exp
              (-t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2) := hTail
        _ ≤ 2 * Real.exp (-(c * t ^ 2 / E)) := by
          apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
          calc
            -t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2 =
                -(t ^ 2 / (2 * (PsiTwoGauge μ S).toReal) ^ 2) := by ring
            _ ≤ -(c * t ^ 2 / E) := neg_le_neg hRatio

/-! The largest intrinsic `ψ₂` norm in a nonempty finite family, in the
real-valued form used by Theorem 2.6.3. -/
noncomputable def psiTwoNormMax
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ι → Ω → ℝ) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty
    (fun i => (PsiTwoNorm μ (X i)).toReal)

theorem psiTwoNorm_toReal_le_max
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ} (i : ι) :
    (PsiTwoNorm μ (X i)).toReal ≤ psiTwoNormMax μ X := by
  exact Finset.le_sup' (fun j => (PsiTwoNorm μ (X j)).toReal)
    (Finset.mem_univ i)

theorem psiTwoNormMax_nonneg
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ} :
    0 ≤ psiTwoNormMax μ X := by
  let i : ι := Classical.choice inferInstance
  exact le_trans ENNReal.toReal_nonneg (psiTwoNorm_toReal_le_max (μ := μ) (X := X) i)

/-! Theorem 2.6.3 in its intrinsic weighted `ψ₂`-norm form.  The nonempty
index hypothesis matches the source's implicit positive integer `N`, and the
zero weighted-scale branches retain every coefficient vector and threshold. -/
theorem independentWeightedCenteredSubGaussianTailPsiTwo :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        iIndepFun X μ →
        ∀ (a : ι → ℝ) {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ((psiTwoNormMax μ X) ^ 2 * ∑ i, a i ^ 2))) := by
  rcases independentCenteredSubGaussianTailPsiTwo with ⟨c, hc, hTail⟩
  refine ⟨c, hc, ?_⟩
  intro ι Ω instι instNonempty instΩ μ instμ X hSub hCenter hIndep a t ht
  let Y : ι → Ω → ℝ := fun i ω => a i * X i ω
  let S : Ω → ℝ := fun ω => ∑ i, Y i ω
  let K : ℝ := psiTwoNormMax μ X
  let A : ℝ := ∑ i, a i ^ 2
  let E : ℝ := ∑ i, (PsiTwoNorm μ (Y i)).toReal ^ 2
  let D : ℝ := K ^ 2 * A
  have hYSub : ∀ i, IsSubGaussian μ (Y i) := by
    intro i
    apply (isSubGaussian_iff_psiTwoNorm_finite (μ := μ) (X := Y i)).2
    by_cases hai : a i = 0
    · simp [Y, hai, PsiTwoNorm, psiTwoGauge_zero]
    · have hXFinite :=
        (isSubGaussian_iff_psiTwoNorm_finite (μ := μ) (X := X i)).1 (hSub i)
      rw [PsiTwoNorm, show Y i = (fun ω => a i * X i ω) by rfl,
        psiTwoGauge_smul_of_ne_zero hai]
      exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top (by
        simpa [PsiTwoNorm] using hXFinite)
  have hYCenter : ∀ i, Integrable (Y i) μ ∧ (∫ ω, Y i ω ∂μ) = 0 := by
    intro i
    refine ⟨by simpa [Y] using (hCenter i).1.const_mul (a i), ?_⟩
    simp [Y, integral_const_mul, (hCenter i).2]
  have hIndepY : iIndepFun Y μ := by
    have h := hIndep.comp (fun i x => a i * x) (fun i => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have hYNorm (i : ι) :
      (PsiTwoNorm μ (Y i)).toReal =
        |a i| * (PsiTwoNorm μ (X i)).toReal := by
    by_cases hai : a i = 0
    · simp [Y, hai, PsiTwoNorm, psiTwoGauge_zero]
    · rw [PsiTwoNorm, show Y i = (fun ω => a i * X i ω) by rfl,
        psiTwoGauge_smul_of_ne_zero hai, ENNReal.toReal_mul,
        ENNReal.toReal_ofReal (abs_nonneg (a i))]
      rfl
  have hKnonneg : 0 ≤ K := by
    simpa [K] using (psiTwoNormMax_nonneg (μ := μ) (X := X))
  have hEnonneg : 0 ≤ E := by
    dsimp [E]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hAnonneg : 0 ≤ A := by
    dsimp [A]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hDnonneg : 0 ≤ D := mul_nonneg (sq_nonneg K) hAnonneg
  have hED : E ≤ D := by
    dsimp [E, D, A]
    calc
      ∑ i, (PsiTwoNorm μ (Y i)).toReal ^ 2 ≤
          ∑ i, K ^ 2 * a i ^ 2 := by
        apply Finset.sum_le_sum
        intro i _
        have hi : (PsiTwoNorm μ (X i)).toReal ≤ K := by
          simpa [K] using (psiTwoNorm_toReal_le_max (μ := μ) (X := X) i)
        have hsq : (PsiTwoNorm μ (X i)).toReal ^ 2 ≤ K ^ 2 := by
          nlinarith [ENNReal.toReal_nonneg (a := PsiTwoNorm μ (X i))]
        calc
          (PsiTwoNorm μ (Y i)).toReal ^ 2 =
              a i ^ 2 * (PsiTwoNorm μ (X i)).toReal ^ 2 := by
            rw [hYNorm, mul_pow, sq_abs]
          _ ≤ a i ^ 2 * K ^ 2 :=
            mul_le_mul_of_nonneg_left hsq (sq_nonneg (a i))
          _ = K ^ 2 * a i ^ 2 := by ring
      _ = K ^ 2 * ∑ i, a i ^ 2 := by rw [Finset.mul_sum]
  have hProb (s : Set Ω) : μ.real s ≤ 1 := by
    rw [Measure.real_def]
    exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
  change μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
    2 * Real.exp (-(c * t ^ 2 / D))
  by_cases hDzero : D = 0
  · calc
      μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤ 1 := hProb _
      _ ≤ 2 * Real.exp (-(c * t ^ 2 / D)) := by simp [hDzero]
  · have hDpos : 0 < D := lt_of_le_of_ne hDnonneg (Ne.symm hDzero)
    by_cases hEzero : E = 0
    · have hYFinite : ∀ i, PsiTwoGauge μ (Y i) < ∞ := by
        intro i
        have := (isSubGaussian_iff_psiTwoNorm_finite
          (μ := μ) (X := Y i)).1 (hYSub i)
        simpa [PsiTwoNorm] using this
      have hGaugeZero : ∀ i, PsiTwoGauge μ (Y i) = 0 := by
        intro i
        have hSqZero : (PsiTwoNorm μ (Y i)).toReal ^ 2 = 0 :=
          (Finset.sum_eq_zero_iff_of_nonneg
            (fun j _ => sq_nonneg (PsiTwoNorm μ (Y j)).toReal)).mp hEzero i
              (Finset.mem_univ i)
        have hRealZero : (PsiTwoNorm μ (Y i)).toReal = 0 := by
          nlinarith [sq_nonneg (PsiTwoNorm μ (Y i)).toReal]
        have hNormZero : PsiTwoNorm μ (Y i) = 0 :=
          ((ENNReal.toReal_eq_zero_iff _).mp hRealZero).resolve_right
            (ne_of_lt (by simpa [PsiTwoNorm] using hYFinite i))
        simpa [PsiTwoNorm] using hNormZero
      have hYZero : ∀ i, Y i =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
        intro i
        exact (psiTwoGauge_eq_zero_iff_ae_eq_zero (hYSub i).1).mp (hGaugeZero i)
      have hAllZero : ∀ᵐ ω ∂μ, ∀ i ∈ (Finset.univ : Finset ι), Y i ω = 0 := by
        rw [Filter.eventually_all_finset]
        intro i _
        exact hYZero i
      have hSZero : S =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
        filter_upwards [hAllZero] with ω hω
        simp [S, hω]
      by_cases htZero : t = 0
      · subst t
        calc
          μ.real {ω | |∑ i, a i * X i ω| ≥ 0} ≤ 1 := hProb _
          _ ≤ 2 * Real.exp (-(c * 0 ^ 2 / D)) := by norm_num
      · have hEvent : {ω | |S ω| ≥ t} =ᵐ[μ] (∅ : Set Ω) := by
          filter_upwards [hSZero] with ω hω
          change (t ≤ |S ω|) = False
          rw [hω, abs_zero]
          exact propext (iff_false_intro
            (not_le_of_gt (lt_of_le_of_ne ht (Ne.symm htZero))))
        have hZeroProb : μ.real {ω | |S ω| ≥ t} = 0 := by
          rw [Measure.real_def, measure_congr hEvent]
          simp
        change μ.real {ω | |S ω| ≥ t} ≤ 2 * Real.exp (-(c * t ^ 2 / D))
        rw [hZeroProb]
        positivity
    · have hEpos : 0 < E := lt_of_le_of_ne hEnonneg (Ne.symm hEzero)
      have hTailY := hTail hYSub hYCenter hIndepY ht
      have hRatio : c * t ^ 2 / D ≤ c * t ^ 2 / E := by
        exact div_le_div_of_nonneg_left (mul_nonneg hc.le (sq_nonneg t)) hEpos hED
      calc
        μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp (-(c * t ^ 2 / E)) := by
          simpa [Y, E] using hTailY
        _ ≤ 2 * Real.exp (-(c * t ^ 2 / D)) := by
          apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
          exact neg_le_neg hRatio

/-! The exact a.e.-quotient carrier for Exercise 2.5.7.  The carrier is a
submodule of measurable finite-gauge representatives; quotienting by its
null submodule makes the definiteness statement literal. -/
/-- The submodule of measurable representatives with finite ψ₂ gauge. -/
def psiTwoMemberSubmodule
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : Submodule ℝ (Ω → ℝ) where
  carrier := {X | Measurable X ∧ PsiTwoGauge μ X < ∞}
  zero_mem' := by
    refine ⟨measurable_const, ?_⟩
    change PsiTwoGauge μ (fun _ : Ω => (0 : ℝ)) < ∞
    rw [psiTwoGauge_zero]
    simp
  add_mem' := by
    intro X Y hX hY
    refine ⟨hX.1.add hY.1, ?_⟩
    exact lt_of_le_of_lt (psiTwoGauge_add_le (μ := μ) (X := X) (Y := Y))
      (ENNReal.add_lt_top.mpr ⟨hX.2, hY.2⟩)
  smul_mem' := by
    intro c X hX
    refine ⟨hX.1.const_smul c, ?_⟩
    by_cases hc : c = 0
    · subst c
      simpa using (show PsiTwoGauge μ (fun _ : Ω => (0 : ℝ)) < ∞ by
        rw [psiTwoGauge_zero]
        simp)
    · rw [show c • X = (fun ω => c * X ω) by rfl,
      psiTwoGauge_smul_of_ne_zero hc]
      exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top hX.2

/-- The submodule of representatives that vanish almost everywhere. -/
def psiTwoNullSubmodule
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    Submodule ℝ (psiTwoMemberSubmodule μ) where
  carrier := {X | (X : Ω → ℝ) =ᵐ[μ] (fun _ : Ω => (0 : ℝ))}
  zero_mem' := by
    change ((0 : psiTwoMemberSubmodule μ) : Ω → ℝ) =ᵐ[μ]
      (fun _ : Ω => (0 : ℝ))
    exact Filter.Eventually.of_forall (fun _ => rfl)
  add_mem' := by
    intro X Y hX hY
    change (X : Ω → ℝ) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) at hX
    change (Y : Ω → ℝ) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) at hY
    change (fun ω => X.1 ω + Y.1 ω) =ᵐ[μ] (fun _ : Ω => (0 : ℝ))
    filter_upwards [hX, hY] with ω hωX hωY
    simp [hωX, hωY]
  smul_mem' := by
    intro c X hX
    change (X : Ω → ℝ) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) at hX
    change (fun ω => c * X.1 ω) =ᵐ[μ] (fun _ : Ω => (0 : ℝ))
    filter_upwards [hX] with ω hω
    simp [hω]

/-- The a.e.-quotient of finite-ψ₂ representatives. -/
def psiTwoSpace
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :=
  psiTwoMemberSubmodule μ ⧸ psiTwoNullSubmodule μ

instance psiTwoSpace.instAddCommGroup
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : AddCommGroup (psiTwoSpace μ) := by
  unfold psiTwoSpace
  exact Submodule.Quotient.addCommGroup (psiTwoNullSubmodule μ)

instance psiTwoSpace.instModule
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : Module ℝ (psiTwoSpace μ) := by
  unfold psiTwoSpace
  exact Submodule.Quotient.module (psiTwoNullSubmodule μ)

/-- The ψ₂ gauge induced on the a.e.-quotient. -/
noncomputable def psiTwoQuotientGauge
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : psiTwoSpace μ → ℝ≥0∞ :=
  Quotient.lift
    (fun X : psiTwoMemberSubmodule μ => PsiTwoGauge μ X.1)
    (by
      intro X Y hXY
      have hmem : X - Y ∈ psiTwoNullSubmodule μ :=
        (psiTwoNullSubmodule μ).quotientRel_def.mp hXY
      have hzero : (X.1 - Y.1) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := hmem
      have hXY' : X.1 =ᵐ[μ] Y.1 := by
        filter_upwards [hzero] with ω hω
        change X.1 ω - Y.1 ω = 0 at hω
        linarith
      exact psiTwoGauge_ae_congr X.2.1 Y.2.1 hXY')

/-- The real-valued ψ₂ norm on the a.e.-quotient. -/
noncomputable def psiTwoQuotientNorm
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] : psiTwoSpace μ → ℝ :=
  fun x => (psiTwoQuotientGauge μ x).toReal

lemma psiTwoQuotientNorm_mk
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : psiTwoMemberSubmodule μ) :
    psiTwoQuotientNorm μ (Submodule.Quotient.mk X) =
      (PsiTwoGauge μ X.1).toReal := rfl

lemma psiTwoQuotientNorm_nonneg
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (x : psiTwoSpace μ) :
    0 ≤ psiTwoQuotientNorm μ x :=
  ENNReal.toReal_nonneg

lemma psiTwoQuotientNorm_zero
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    psiTwoQuotientNorm μ (0 : psiTwoSpace μ) = 0 := by
  change (psiTwoQuotientGauge μ (0 : psiTwoSpace μ)).toReal = 0
  rw [show (0 : psiTwoSpace μ) = Submodule.Quotient.mk (0 : psiTwoMemberSubmodule μ) by rfl,
    psiTwoQuotientGauge]
  change (PsiTwoGauge μ (0 : Ω → ℝ)).toReal = 0
  rw [show (0 : Ω → ℝ) = (fun _ : Ω => (0 : ℝ)) by rfl,
    psiTwoGauge_zero]
  rfl

lemma psiTwoQuotientNorm_eq_zero_iff
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (x : psiTwoSpace μ) :
    psiTwoQuotientNorm μ x = 0 ↔ x = 0 := by
  refine Submodule.Quotient.induction_on (psiTwoNullSubmodule μ) x ?_
  intro X
  have hfinite : PsiTwoGauge μ X.1 < ∞ := X.2.2
  rw [psiTwoQuotientNorm_mk]
  constructor
  · intro hnorm
    have hGauge : PsiTwoGauge μ X.1 = 0 := by
      exact (ENNReal.toReal_eq_zero_iff _).mp hnorm |>.resolve_right hfinite.ne
    apply (Submodule.Quotient.mk_eq_zero (psiTwoNullSubmodule μ)).2
    exact (psiTwoGauge_eq_zero_iff_ae_eq_zero X.2.1).mp hGauge
  · intro hx
    have hGauge : PsiTwoGauge μ X.1 = 0 := by
      apply (psiTwoGauge_eq_zero_iff_ae_eq_zero X.2.1).2
      exact (Submodule.Quotient.mk_eq_zero (psiTwoNullSubmodule μ)).mp hx
    simp [hGauge]

lemma psiTwoQuotientNorm_add_le
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (x y : psiTwoSpace μ) :
    psiTwoQuotientNorm μ (x + y) ≤
      psiTwoQuotientNorm μ x + psiTwoQuotientNorm μ y := by
  refine Submodule.Quotient.induction_on (psiTwoNullSubmodule μ) x ?_
  intro X
  refine Submodule.Quotient.induction_on (psiTwoNullSubmodule μ) y ?_
  intro Y
  have hmk :
      (Submodule.Quotient.mk X : psiTwoSpace μ) + Submodule.Quotient.mk Y =
        Submodule.Quotient.mk (X + Y) :=
    (Submodule.Quotient.mk_add (psiTwoNullSubmodule μ) (x := X) (y := Y)).symm
  have hsum := (psiTwoMemberSubmodule μ).add_mem X.2 Y.2
  have hle := psiTwoGauge_add_le (μ := μ) (X := X.1) (Y := Y.1)
  have htopLeft : PsiTwoGauge μ (X + Y).1 ≠ ∞ := hsum.2.ne
  have htopRight : PsiTwoGauge μ X.1 + PsiTwoGauge μ Y.1 ≠ ∞ :=
    (ENNReal.add_lt_top.mpr ⟨X.2.2, Y.2.2⟩).ne
  have hreal := (ENNReal.toReal_le_toReal htopLeft htopRight).2 hle
  calc
    psiTwoQuotientNorm μ
        ((Submodule.Quotient.mk X : psiTwoSpace μ) + Submodule.Quotient.mk Y) =
        psiTwoQuotientNorm μ (Submodule.Quotient.mk (X + Y)) := congrArg _ hmk
    _ = (PsiTwoGauge μ (X + Y).1).toReal := rfl
    _ ≤ (PsiTwoGauge μ X.1).toReal + (PsiTwoGauge μ Y.1).toReal := by
      simpa [ENNReal.toReal_add X.2.2.ne Y.2.2.ne] using hreal
    _ = psiTwoQuotientNorm μ (Submodule.Quotient.mk X) +
        psiTwoQuotientNorm μ (Submodule.Quotient.mk Y) := by rfl

lemma psiTwoQuotientNorm_smul
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (c : ℝ) (x : psiTwoSpace μ) :
    psiTwoQuotientNorm μ (c • x) = |c| * psiTwoQuotientNorm μ x := by
  refine Submodule.Quotient.induction_on (psiTwoNullSubmodule μ) x ?_
  intro X
  have hmk : c • (Submodule.Quotient.mk X : psiTwoSpace μ) =
      Submodule.Quotient.mk (c • X) :=
    (Submodule.Quotient.mk_smul (psiTwoNullSubmodule μ) c X).symm
  calc
    psiTwoQuotientNorm μ (c • (Submodule.Quotient.mk X : psiTwoSpace μ)) =
    psiTwoQuotientNorm μ (Submodule.Quotient.mk (c • X)) := congrArg _ hmk
    _ = (PsiTwoGauge μ (c • X).1).toReal := rfl
    _ = |c| * (PsiTwoGauge μ X.1).toReal := by
      change (PsiTwoGauge μ (fun ω => c * X.1 ω)).toReal =
        |c| * (PsiTwoGauge μ X.1).toReal
      by_cases hc : c = 0
      · subst c
        rw [show (fun ω => (0 : ℝ) * X.1 ω) = (fun _ : Ω => (0 : ℝ)) by
          funext ω; simp, psiTwoGauge_zero]
        simp
      · have hsmul :
            PsiTwoGauge μ (fun ω => c * X.1 ω) =
              ENNReal.ofReal |c| * PsiTwoGauge μ X.1 :=
          psiTwoGauge_smul_of_ne_zero (μ := μ) (X := X.1) hc
        rw [hsmul, ENNReal.toReal_mul]
        · simp [ENNReal.toReal_ofReal (abs_nonneg c)]
    _ = |c| * psiTwoQuotientNorm μ (Submodule.Quotient.mk X) := by rfl

/-- Norm axioms for the ψ₂ quotient model. -/
structure PsiTwoNormQuotientModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] where
  /-- The norm assigned to quotient classes. -/
  norm : psiTwoSpace μ → ℝ
  norm_nonneg : ∀ x, 0 ≤ norm x
  norm_zero : norm 0 = 0
  norm_eq_zero : ∀ x, norm x = 0 ↔ x = 0
  norm_add_le : ∀ x y, norm (x + y) ≤ norm x + norm y
  norm_smul : ∀ (c : ℝ) x, norm (c • x) = |c| * norm x

/-- The ψ₂ quotient model equipped with its induced norm. -/
noncomputable def psiTwoNormQuotientModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    PsiTwoNormQuotientModelData μ :=
  { norm := psiTwoQuotientNorm μ
    norm_nonneg := psiTwoQuotientNorm_nonneg μ
    norm_zero := psiTwoQuotientNorm_zero μ
    norm_eq_zero := psiTwoQuotientNorm_eq_zero_iff μ
    norm_add_le := psiTwoQuotientNorm_add_le μ
    norm_smul := psiTwoQuotientNorm_smul μ }

theorem psiTwoNormQuotientModel
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    ∃ norm : psiTwoSpace μ → ℝ,
      (∀ x, 0 ≤ norm x) ∧
        norm 0 = 0 ∧
        (∀ x, norm x = 0 ↔ x = 0) ∧
        (∀ x y, norm (x + y) ≤ norm x + norm y) ∧
        (∀ (c : ℝ) x, norm (c • x) = |c| * norm x) := by
  refine ⟨psiTwoQuotientNorm μ, psiTwoQuotientNorm_nonneg μ,
    psiTwoQuotientNorm_zero μ, psiTwoQuotientNorm_eq_zero_iff μ,
    psiTwoQuotientNorm_add_le μ, psiTwoQuotientNorm_smul μ⟩

theorem psiTwoQuotientNorm_isNorm
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    (∀ x, 0 ≤ psiTwoQuotientNorm μ x) ∧
      psiTwoQuotientNorm μ 0 = 0 ∧
      (∀ x, psiTwoQuotientNorm μ x = 0 ↔ x = 0) ∧
      (∀ x y,
        psiTwoQuotientNorm μ (x + y) ≤
          psiTwoQuotientNorm μ x + psiTwoQuotientNorm μ y) ∧
      (∀ (c : ℝ) x,
        psiTwoQuotientNorm μ (c • x) =
          |c| * psiTwoQuotientNorm μ x) := by
  exact ⟨psiTwoQuotientNorm_nonneg μ, psiTwoQuotientNorm_zero μ,
    psiTwoQuotientNorm_eq_zero_iff μ, psiTwoQuotientNorm_add_le μ,
    psiTwoQuotientNorm_smul μ⟩
/-! Example 2.5.8(a): one absolute constant controls the `ψ₂` gauge of every
centered Gaussian, with the source's linear dependence on its scale. -/
theorem gaussianPsiTwoGauge_le_two_mul :
    PsiTwoGauge (gaussianReal 0 1) id ≤ ENNReal.ofReal 2 ∧
      ∀ σ : ℝ, 0 ≤ σ →
        PsiTwoGauge (gaussianReal 0 (⟨σ ^ 2, sq_nonneg σ⟩ : ℝ≥0)) id ≤
          ENNReal.ofReal (2 * σ) := by
  have hsqrt2 : 0 < Real.sqrt (2 : ℝ) := by positivity
  have hsqrt2_sq : (Real.sqrt (2 : ℝ)) ^ 2 = 2 := by
    exact Real.sq_sqrt (by norm_num)
  have hsmall : |(1 / 2 : ℝ)| < (Real.sqrt 2)⁻¹ := by
    rw [abs_of_nonneg (by norm_num)]
    field_simp
    nlinarith
  have hstd := (standardNormalSquareMGF (1 / 2)).1 hsmall
  have hsqrt2_bound : (Real.sqrt (1 - 2 * (1 / 2 : ℝ) ^ 2))⁻¹ ≤ 2 := by
    norm_num [hsqrt2_sq]
    nlinarith
  have hstdInt :
      Integrable (fun x : ℝ => Real.exp (x ^ 2 / (2 : ℝ) ^ 2))
        (gaussianReal 0 1) := by
    convert hstd.1 using 1
    all_goals funext x
    all_goals field_simp
  have hstdIntegral :
      (∫ x : ℝ, Real.exp (x ^ 2 / (2 : ℝ) ^ 2) ∂(gaussianReal 0 1)) =
        (Real.sqrt (1 - 2 * (1 / 2 : ℝ) ^ 2))⁻¹ := by
    calc
      (∫ x : ℝ, Real.exp (x ^ 2 / (2 : ℝ) ^ 2) ∂(gaussianReal 0 1)) =
          ∫ x : ℝ, Real.exp ((1 / 2 : ℝ) ^ 2 * x ^ 2) ∂(gaussianReal 0 1) := by
            apply integral_congr_ae
            filter_upwards [] with x
            congr 1
            field_simp
      _ = (Real.sqrt (1 - 2 * (1 / 2 : ℝ) ^ 2))⁻¹ := hstd.2
  constructor
  · apply psiTwoGauge_le_of_squarePoint
    refine ⟨measurable_id, by norm_num, ?_, ?_⟩
    · simpa [id_eq] using hstdInt
    · simpa [id_eq] using hstdIntegral.trans_le hsqrt2_bound
  · intro σ hσ
    by_cases hzero : σ = 0
    · subst σ
      have hvzero : (⟨(0 : ℝ) ^ 2, sq_nonneg (0 : ℝ)⟩ : ℝ≥0) = 0 := by
        apply NNReal.eq
        norm_num
      have hgauss : gaussianReal 0
          (⟨(0 : ℝ) ^ 2, sq_nonneg (0 : ℝ)⟩ : ℝ≥0) = Measure.dirac 0 := by
        rw [hvzero]
        exact ProbabilityTheory.gaussianReal_zero_var 0
      rw [hgauss]
      calc
        PsiTwoGauge (Measure.dirac 0) id =
            PsiTwoGauge (Measure.dirac 0) (fun _ : ℝ => (0 : ℝ)) :=
          psiTwoGauge_ae_congr measurable_id measurable_const (by
            simpa [id_eq] using
              (MeasureTheory.ae_eq_dirac (id : ℝ → ℝ)))
        _ = 0 := psiTwoGauge_zero
        _ ≤ ENNReal.ofReal (2 * 0) := by simp
    · have hσpos : 0 < σ := lt_of_le_of_ne hσ (Ne.symm hzero)
      let v : ℝ≥0 := ⟨σ ^ 2, sq_nonneg σ⟩
      have hLaw : HasLaw (fun x : ℝ => σ * x) (gaussianReal 0 v)
          (gaussianReal 0 1) := by
        simpa [v] using
          (ProbabilityTheory.gaussianReal_const_mul
            (ProbabilityTheory.HasLaw.id (μ := gaussianReal 0 1)) σ)
      let f : ℝ → ℝ := fun x => Real.exp (x ^ 2 / (2 * σ) ^ 2)
      have hcomp : (f ∘ (fun x : ℝ => σ * x)) =
          (fun x : ℝ => Real.exp ((1 / 2 : ℝ) ^ 2 * x ^ 2)) := by
        funext x
        dsimp [f]
        congr 1
        field_simp [hzero]
      have hfInt : Integrable f (gaussianReal 0 v) := by
        rw [← hLaw.map_eq]
        apply (integrable_map_measure
          (Continuous.aestronglyMeasurable (by fun_prop : Continuous f))
          hLaw.aemeasurable).2
        rw [hcomp]
        exact hstd.1
      have hfBound : (∫ x, f x ∂(gaussianReal 0 v)) ≤ 2 := by
        calc
          (∫ x, f x ∂(gaussianReal 0 v)) =
              ∫ x, f (σ * x) ∂(gaussianReal 0 1) := by
                symm
                exact hLaw.integral_comp
                  (Continuous.aestronglyMeasurable (by fun_prop : Continuous f))
          _ = ∫ x, (f ∘ (fun x : ℝ => σ * x)) x ∂(gaussianReal 0 1) := by rfl
          _ = ∫ x, Real.exp ((1 / 2 : ℝ) ^ 2 * x ^ 2) ∂(gaussianReal 0 1) := by
            rw [hcomp]
          _ = (Real.sqrt (1 - 2 * (1 / 2 : ℝ) ^ 2))⁻¹ := by
            simpa using hstd.2
          _ ≤ 2 := hsqrt2_bound
      apply psiTwoGauge_le_of_squarePoint
      exact ⟨measurable_id, by positivity, hfInt, by simpa [f] using hfBound⟩

/-! Qualitative corollary retained for downstream callers that need only
finiteness. -/
theorem gaussianPsiTwoGauge_finite :
    PsiTwoGauge (gaussianReal 0 1) id < ∞ ∧
      ∀ σ : ℝ, 0 ≤ σ →
        PsiTwoGauge (gaussianReal 0 (⟨σ ^ 2, sq_nonneg σ⟩ : ℝ≥0)) id < ∞ := by
  rcases gaussianPsiTwoGauge_le_two_mul with ⟨hstd, hscaled⟩
  exact ⟨hstd.trans_lt ENNReal.ofReal_lt_top,
    fun σ hσ => (hscaled σ hσ).trans_lt ENNReal.ofReal_lt_top⟩

/-! Example 2.5.8(c): an essentially bounded variable has finite `ψ₂` gauge.

The positive real `B` is an arbitrary essential bound for `|X|`; taking the
infimum over such bounds recovers the printed essential-supremum estimate. -/
theorem essentiallyBoundedPsiTwoGauge
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ} {B : ℝ}
    (hX : Measurable X) (hB : 0 < B)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ B) :
    PsiTwoGauge μ X ≤
      ENNReal.ofReal (B / Real.sqrt (Real.log 2)) := by
  have hLog : 0 < Real.log 2 := by positivity
  have hSqrt : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hLog
  let K : ℝ := B / Real.sqrt (Real.log 2)
  have hK : 0 < K := div_pos hB hSqrt
  have hSqSqrt : (Real.sqrt (Real.log 2)) ^ 2 = Real.log 2 :=
    Real.sq_sqrt hLog.le
  have hPointwise : ∀ᵐ ω ∂μ,
      Real.exp (X ω ^ 2 / K ^ 2) ≤ (2 : ℝ) := by
    filter_upwards [hBound] with ω hω
    have hSq : X ω ^ 2 ≤ B ^ 2 := by
      rw [← sq_abs]
      exact (sq_le_sq₀ (abs_nonneg (X ω)) hB.le).2 hω
    have hArg : X ω ^ 2 / K ^ 2 ≤ Real.log 2 := by
      dsimp [K]
      calc
        X ω ^ 2 / (B / Real.sqrt (Real.log 2)) ^ 2 =
            X ω ^ 2 * (Real.sqrt (Real.log 2)) ^ 2 / B ^ 2 := by
              field_simp [ne_of_gt hB, ne_of_gt hSqrt]
        _ ≤ B ^ 2 * (Real.sqrt (Real.log 2)) ^ 2 / B ^ 2 := by
              gcongr
        _ = (Real.sqrt (Real.log 2)) ^ 2 := by
              field_simp [ne_of_gt hB]
        _ = Real.log 2 := hSqSqrt
    calc
      Real.exp (X ω ^ 2 / K ^ 2) ≤ Real.exp (Real.log 2) :=
        Real.exp_le_exp.mpr hArg
      _ = 2 := by rw [Real.exp_log (by norm_num)]
  have hInt : Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ := by
    refine MeasureTheory.Integrable.mono' (integrable_const (2 : ℝ)) ?_ ?_
    · fun_prop
    · filter_upwards [hPointwise] with ω hω
      simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hω
  have hBoundIntegral :
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ 2 := by
    calc
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤
          ∫ _ : Ω, (2 : ℝ) ∂μ :=
        MeasureTheory.integral_mono_ae hInt (integrable_const (2 : ℝ))
          hPointwise
      _ = 2 := by simp [probReal_univ]
  have hAdmissible : PsiTwoAdmissible μ X (ENNReal.ofReal K) := by
    refine ⟨hX, (ENNReal.ofReal_ne_zero_iff).2 hK,
      ENNReal.ofReal_ne_top, ?_, ?_⟩
    · simpa [ENNReal.toReal_ofReal hK.le] using hInt
    · simpa [ENNReal.toReal_ofReal hK.le] using hBoundIntegral
  have hInf : PsiTwoGauge μ X ≤ ENNReal.ofReal K := sInf_le hAdmissible
  simpa [K] using hInf

/-! Example 2.5.8(b): the exact gauge of the symmetric two-point law. -/
/-- The equal-weight law on `{-1, 1}` used in the ψ₂ example. -/
noncomputable def rademacherPsiTwoLaw : Measure ℝ :=
  (1 / 2 : ENNReal) • Measure.dirac (-1) +
    (1 / 2 : ENNReal) • Measure.dirac 1

lemma rademacherPsiTwoLaw_probability :
    IsProbabilityMeasure rademacherPsiTwoLaw := by
  apply isProbabilityMeasure_iff.mpr
  simp [rademacherPsiTwoLaw]
  calc
    (2 : ENNReal)⁻¹ + 2⁻¹ = (2 : ENNReal)⁻¹ + (2 : ENNReal)⁻¹ * 1 := by ring
    _ = (2 : ENNReal)⁻¹ * (1 + 1) := by ring
    _ = (2 : ENNReal)⁻¹ * 2 := by norm_num
    _ = 1 := by exact ENNReal.inv_mul_cancel (by norm_num) (by norm_num)

lemma rademacherPsiTwoLaw_integral (f : ℝ → ℝ) :
    ∫ x, f x ∂rademacherPsiTwoLaw =
      (1 / 2 : ℝ) * f (-1) + (1 / 2 : ℝ) * f 1 := by
  rw [rademacherPsiTwoLaw, MeasureTheory.integral_add_measure]
  · rw [MeasureTheory.integral_smul_measure, MeasureTheory.integral_smul_measure,
      MeasureTheory.integral_dirac, MeasureTheory.integral_dirac]
    norm_num
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp

lemma rademacherPsiTwoGauge_admissible_iff {t : ℝ≥0∞} :
    PsiTwoAdmissible rademacherPsiTwoLaw id t ↔
      t ≠ 0 ∧ t ≠ ∞ ∧ Real.exp (1 / t.toReal ^ 2) ≤ 2 := by
  constructor
  · rintro ⟨hMeas, ht0, htTop, hInt, hBound⟩
    refine ⟨ht0, htTop, ?_⟩
    rw [rademacherPsiTwoLaw_integral] at hBound
    have hneg : Real.exp (id (-1 : ℝ) ^ 2 / t.toReal ^ 2) =
        Real.exp (1 / t.toReal ^ 2) := by
      simp only [id]
      congr 1
      ring
    have hpos : Real.exp (id (1 : ℝ) ^ 2 / t.toReal ^ 2) =
        Real.exp (1 / t.toReal ^ 2) := by
      simp only [id]
      congr 1
      ring
    calc
      Real.exp (1 / t.toReal ^ 2) =
          (1 / 2 : ℝ) * Real.exp (1 / t.toReal ^ 2) +
            (1 / 2 : ℝ) * Real.exp (1 / t.toReal ^ 2) := by ring
      _ = (1 / 2 : ℝ) * Real.exp (id (-1 : ℝ) ^ 2 / t.toReal ^ 2) +
            (1 / 2 : ℝ) * Real.exp (id (1 : ℝ) ^ 2 / t.toReal ^ 2) := by
              rw [hneg, hpos]
      _ ≤ 2 := hBound
  · rintro ⟨ht0, htTop, hBound⟩
    refine ⟨measurable_id, ht0, htTop, ?_, ?_⟩
    · apply Integrable.add_measure
      · apply Integrable.smul_measure
        · exact integrable_dirac (by simp)
        · simp
      · apply Integrable.smul_measure
        · exact integrable_dirac (by simp)
        · simp
    · rw [rademacherPsiTwoLaw_integral]
      have hneg : Real.exp (id (-1 : ℝ) ^ 2 / t.toReal ^ 2) =
          Real.exp (1 / t.toReal ^ 2) := by
        simp only [id]
        congr 1
        ring
      have hpos : Real.exp (id (1 : ℝ) ^ 2 / t.toReal ^ 2) =
          Real.exp (1 / t.toReal ^ 2) := by
        simp only [id]
        congr 1
        ring
      calc
        (1 / 2 : ℝ) * Real.exp (id (-1 : ℝ) ^ 2 / t.toReal ^ 2) +
            (1 / 2 : ℝ) * Real.exp (id (1 : ℝ) ^ 2 / t.toReal ^ 2) =
            (1 / 2 : ℝ) * Real.exp (1 / t.toReal ^ 2) +
              (1 / 2 : ℝ) * Real.exp (1 / t.toReal ^ 2) := by rw [hneg, hpos]
        _ ≤ 2 := by nlinarith [hBound]

theorem rademacherPsiTwoGauge_exact :
    PsiTwoGauge rademacherPsiTwoLaw id =
      ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) := by
  let q : ℝ := 1 / Real.sqrt (Real.log 2)
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hsqrt : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hlog
  have hq : 0 < q := div_pos one_pos hsqrt
  have hqSq : q ^ 2 = 1 / Real.log 2 := by
    dsimp [q]
    rw [div_pow, Real.sq_sqrt hlog.le]
    norm_num
  have hExpIff {t : ℝ} (ht : 0 < t) :
      Real.exp (1 / t ^ 2) ≤ 2 ↔ q ≤ t := by
    constructor
    · intro hExp
      have hlog' : 1 / t ^ 2 ≤ Real.log 2 := by
        calc
          1 / t ^ 2 = Real.log (Real.exp (1 / t ^ 2)) := by
            rw [Real.log_exp]
          _ ≤ Real.log 2 := by
            exact Real.log_le_log (by positivity) hExp
      apply (sq_le_sq₀ hq.le ht.le).mp
      rw [hqSq]
      apply (div_le_iff₀ hlog).2
      have hmul := (div_le_iff₀ (sq_pos_of_pos ht)).mp hlog'
      simpa [mul_comm] using hmul
    · intro hqt
      have hsq : 1 / t ^ 2 ≤ Real.log 2 := by
        apply (div_le_iff₀ (sq_pos_of_pos ht)).2
        have hqtSq : q ^ 2 ≤ t ^ 2 := (sq_le_sq₀ hq.le ht.le).2 hqt
        rw [hqSq] at hqtSq
        have hmul := (div_le_iff₀ hlog).mp hqtSq
        simpa [mul_comm] using hmul
      calc
        Real.exp (1 / t ^ 2) ≤ Real.exp (Real.log 2) :=
          Real.exp_le_exp.mpr hsq
        _ = 2 := by rw [Real.exp_log (by norm_num)]
  have hqAdmissible :
      PsiTwoAdmissible rademacherPsiTwoLaw id (ENNReal.ofReal q) := by
    apply (rademacherPsiTwoGauge_admissible_iff).2
    refine ⟨ENNReal.ofReal_ne_zero_iff.mpr hq, ENNReal.ofReal_ne_top, ?_⟩
    rw [ENNReal.toReal_ofReal hq.le]
    exact (hExpIff hq).2 le_rfl
  unfold PsiTwoGauge
  apply le_antisymm
  · exact sInf_le hqAdmissible
  · apply le_sInf
    intro t ht
    rcases (rademacherPsiTwoGauge_admissible_iff).1 ht with ⟨ht0, htTop, hBound⟩
    have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
    rw [ENNReal.ofReal_le_iff_le_toReal htTop]
    exact (hExpIff htpos).mp hBound

theorem independentGaussianWeightedSumLaw {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {σ : ι → ℝ≥0} (a : ι → ℝ)
    (hLaw : ∀ i, HasLaw (X i) (gaussianReal 0 (σ i)) μ)
    (hIndep : iIndepFun X μ) :
    HasLaw (fun ω => ∑ i, a i * X i ω)
      (gaussianReal 0 (∑ i, Real.toNNReal ((a i) ^ 2) * σ i)) μ := by
  let Y : ι → Ω → ℝ := fun i ω => a i * X i ω
  let τ : ι → ℝ≥0 := fun i => Real.toNNReal ((a i) ^ 2) * σ i
  have hLawY : ∀ i, HasLaw (Y i) (gaussianReal 0 (τ i)) μ := by
    intro i
    simpa [Y, τ, Real.toNNReal_of_nonneg (sq_nonneg (a i))] using
      ProbabilityTheory.gaussianReal_const_mul (hLaw i) (a i)
  have hIndepY : iIndepFun Y μ := by
    have h := hIndep.comp (fun i x => a i * x) (fun i => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have h := independentGaussianSumLaw hLawY hIndepY
  simpa [Y, τ] using h

end NumStability.HDP.Scalar.SubGaussian

namespace NumStability.HDP.Contract

/-! Stable Chapter 2 alias for the Gaussian `ψ₂` example. -/
theorem hdp_02_hexample_h2_d5_d8a :
    ∃ C : ℝ, 0 < C ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
          (ProbabilityTheory.gaussianReal 0 1) id ≤ ENNReal.ofReal C ∧
        ∀ σ : ℝ, 0 ≤ σ →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
            (ProbabilityTheory.gaussianReal 0
              (⟨σ ^ 2, sq_nonneg σ⟩ : ℝ≥0)) id ≤
          ENNReal.ofReal (C * σ) := by
  refine ⟨2, by norm_num, ?_⟩
  simpa using
    NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_le_two_mul

/-! Stable Chapter 2 alias for Proposition 2.5.2. -/
theorem hdp_02_hprop_h2_d5_d2 :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj) :=
  NumStability.HDP.Scalar.SubGaussian.subGaussianCharacterization_absolute

/-! Stable Chapter 2 alias for the gauge-facing characterization theorem. -/
theorem hdp_02_hthm_hpsi2_hnorm_hcharacterizations
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ∀ {K : ℝ}, 0 < K →
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K →
            NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
              ENNReal.ofReal (C * K)) ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ((∃ K : ℝ, 0 < K ∧
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K) ↔
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞)) :=
  NumStability.HDP.Scalar.SubGaussian.psiTwoGaugeCharacterizations hCenter

/-! Compatibility alias for the earlier scale-parametric MGF formulation of
Proposition 2.6.1.  The exact source-facing alias below now exposes intrinsic
`ψ₂` norms and one universally quantified absolute constant. -/
theorem hdp_02_hprop_h2_d6_d1_mgfScale
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2) :
    ∃ C : ℝ, 1 ≤ C ∧
      NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ
          (fun ω => ∑ i, X i ω) .linearMGF
          (Real.sqrt (∑ i, K i ^ 2)) ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => ∑ i, X i ω) ≤
        ENNReal.ofReal (C * Real.sqrt (∑ i, K i ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianSum
    hX hIndep hEnergy

/-! Stable Chapter 2 alias for Proposition 2.6.1. -/
theorem hdp_02_hprop_h2_d6_d1 :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        ProbabilityTheory.iIndepFun X μ →
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
              (fun ω => ∑ i, X i ω) ∧
            (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                (fun ω => ∑ i, X i ω)).toReal ^ 2 ≤
              C * ∑ i,
                (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                  (X i)).toReal ^ 2 :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianSumPsiTwo

/-! Compatibility alias for the earlier scale-parametric MGF formulation of
Theorem 2.6.2.  The exact source-facing alias below uses intrinsic `ψ₂` norms
and quantifies one universal positive constant before the family. -/
theorem hdp_02_hthm_h2_d6_d2_mgfScale
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * ∑ i, K i ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianTail
    hX hIndep hEnergy ht

/-! Stable Chapter 2 alias for Theorem 2.6.2. -/
theorem hdp_02_hthm_h2_d6_d2 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ∑ i,
                  (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                    (X i)).toReal ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianTailPsiTwo

/-! Compatibility alias for the earlier common-MGF-scale formulation of
Theorem 2.6.3. -/
theorem hdp_02_hthm_h2_d6_d3_mgfScale
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hK : 0 < K)
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) K)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    {a : ι → ℝ}
    (hEnergy : 0 < ∑ i, a i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * K ^ 2 * ∑ i, a i ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentWeightedCenteredSubGaussianTail
    hK hX hIndep hEnergy ht

/-! Stable Chapter 2 alias for Theorem 2.6.3. -/
theorem hdp_02_hthm_h2_d6_d3 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ (a : ι → ℝ) {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ((NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 *
                  ∑ i, a i ^ 2))) :=
  NumStability.HDP.Scalar.SubGaussian.independentWeightedCenteredSubGaussianTailPsiTwo

/-! Stable Chapter 2 alias for Lemma 2.6.8. -/
theorem hdp_02_hlem_h2_d6_d8
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind)
    {K : ℝ} (hK : 0 < K)
    (hProp : NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K) :
    ∃ C : ℝ, 1 ≤ C ∧
      Integrable X μ ∧
      ∃ K' : ℝ, 0 < K' ∧ K' ≤ C * K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ
            (fun ω => X ω - ∫ x, X x ∂μ) .squarePoint K' ∧
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => X ω - ∫ x, X x ∂μ) ≤
          ENNReal.ofReal (C * K) :=
  NumStability.HDP.Scalar.SubGaussian.centeredSubGaussian i hK hProp

/-! Stable Chapter 2 alias for Remark 2.5.3. -/
theorem hdp_02_hrem_h2_d5_d3 (A : ℝ) (hA : 1 < A) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                  μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                    μ X A j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                  μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                    μ X A j Kj) :=
  NumStability.HDP.Scalar.SubGaussian.subGaussianThresholdCharacterization_absolute A hA

/-! Stable Chapter 2 rendering of Definition 2.5.6.  It names the class using
any of the equivalent uncentered properties (i)--(iv) and identifies its
finite `ψ₂` norm with the displayed positive-scale infimum. -/
theorem hdp_02_hdef_h2_d5_d6
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (_hX : Measurable X) :
    (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
      i ≠ .linearMGF →
        (NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X ↔
          ∃ K : ℝ, 0 < K ∧
            NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K)) ∧
      (NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X < ∞ ∧
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X =
            sInf {t : ℝ≥0∞ |
              NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X t}) := by
  constructor
  · intro i hi
    exact NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_property i hi
  · intro hSub
    constructor
    · exact
        NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mp hSub
    · rfl

/-! Stable Chapter 2 alias for Exercise 2.5.7: the exact ψ₂ norm on the
measurable finite-gauge quotient modulo a.e. equality. -/
theorem hdp_02_hex_h2_d5_d7
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    (∀ x, 0 ≤ NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x) ∧
      NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ 0 = 0 ∧
      (∀ x,
        NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x = 0 ↔
          x = 0) ∧
      (∀ x y,
        NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ (x + y) ≤
          NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x +
            NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ y) ∧
      (∀ (c : ℝ) x,
        NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ (c • x) =
          |c| *
            NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x) :=
  NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm_isNorm μ

/-! Stable Chapter 2 alias for the essentially bounded `ψ₂` estimate. -/
theorem hdp_02_hexample_h2_d5_d8c
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ} {B : ℝ}
    (hX : Measurable X) (hB : 0 < B)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ B) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
      ENNReal.ofReal (B / Real.sqrt (Real.log 2)) :=
  NumStability.HDP.Scalar.SubGaussian.essentiallyBoundedPsiTwoGauge hX hB hBound

/-! Stable Chapter 2 alias for the exact Rademacher `ψ₂` gauge. -/
theorem hdp_02_hexample_h2_d5_d8b :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw id =
      ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) :=
  NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoGauge_exact

/-! Stable Chapter 2 alias for the standard-normal `Lᵖ` moment formula. -/
theorem hdp_02_hex_h2_d5_d1 (p : ℝ) (hp : 1 ≤ p) :
    (eLpNorm' (fun x : ℝ => x) p (gaussianReal 0 1)).toReal =
      (2 ^ (p / 2) * Real.Gamma ((1 + p) / 2) / Real.Gamma (1 / 2)) ^ (1 / p) :=
  NumStability.HDP.Scalar.SubGaussian.standardNormalLpNorm p hp

/-! Stable Chapter 2 alias for the standard-normal square-MGF example. -/
theorem hdp_02_hex_h2_d5_d5a (lam : ℝ) :
    (|lam| < (Real.sqrt 2)⁻¹ →
      Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) ∧
        (∫ x : ℝ, Real.exp (lam ^ 2 * x ^ 2) ∂(gaussianReal 0 1)) =
          (Real.sqrt (1 - 2 * lam ^ 2))⁻¹) ∧
    ((Real.sqrt 2)⁻¹ ≤ |lam| →
      ¬ Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1)) :=
  NumStability.HDP.Scalar.SubGaussian.standardNormalSquareMGF lam

/-! Stable Chapter 2 alias for the tail-to-moment direction. -/
theorem hdp_02_hlem_hsg_htail_hto_hmoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hTail : ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2)) :
    NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth μ X
      (8 * Real.exp 1 * K) :=
  NumStability.HDP.Scalar.SubGaussian.tailToLpMomentGrowth hX hK hTail

/-- Stable Chapter 2 alias for the moment-to-square-MGF implication. -/
theorem hdp_02_hlem_hsg_hmoment_hto_hsquare_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hLp : NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth μ X K)
    (lam : ℝ) (hsmall : |lam| ≤ (4 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
      (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
        Real.exp (4 * Real.exp 1 * (lam * K) ^ 2) :=
  NumStability.HDP.Scalar.SubGaussian.momentToSquareMGF hK hLp lam hsmall

/-- Stable Chapter 2 alias for the square-MGF-to-MGF implication. -/
theorem hdp_02_hlem_hsg_hsquare_hmgf_hto_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {C : ℝ} (hC : 0 ≤ C)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hSquare : NumStability.HDP.Scalar.SubGaussian.SquareMGFLocal μ X C)
    (lam : ℝ) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp ((C + 1 / 2) * lam ^ 2) :=
  NumStability.HDP.Scalar.SubGaussian.squareMGFToMGF hC hCenter hSquare lam

/-! Stable Chapter 2 alias for the square-MGF-to-tail implication. -/
theorem hdp_02_hlem_hsg_hsquare_hmgf_hto_htail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2) :=
  NumStability.HDP.Scalar.SubGaussian.squareMGFToTail hX hK hMGF ht

/-! Stable Chapter 2 alias for the global square-MGF boundedness exercise. -/
theorem hdp_02_hex_h2_d5_d5b
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 ≤ K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
        (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤ Real.exp (K * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) (hthreshold : K < t ^ 2) :
    μ.real {ω | |X ω| ≥ t} = 0 :=
  NumStability.HDP.Scalar.SubGaussian.squareMGFGlobalTailZero
    hX hK hMGF ht hthreshold

/-! Stable Chapter 2 alias for the all-parameter MGF-to-tail implication. -/
theorem hdp_02_hlem_hsg_hmgf_hto_htail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / (4 * K ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.mgfToTail hX hK hMGF ht

/-! Stable Chapter 2 alias for Exercise 2.5.4. -/
theorem hdp_02_hex_h2_d5_d4
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Integrable X μ)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2)) :
    (∫ ω, X ω ∂μ) = 0 :=
  NumStability.HDP.Scalar.SubGaussian.mgfBoundForcesMeanZero hX hMGF

/-! Stable Chapter 2 alias for Exercise 2.6.9. -/
theorem hdp_02_hex_h2_d6_d9 : hdp_02_hex_h2_d6_d9__contract_type := by
  simpa [hdp_02_hex_h2_d6_d9__contract_type,
    NumStability.HDP.Scalar.SubGaussian.exercise269Law,
    NumStability.HDP.Scalar.SubGaussian.exercise269Mean,
    NumStability.HDP.Scalar.SubGaussian.twoPointPsiTwoNorm,
    NumStability.HDP.Scalar.SubGaussian.twoPointPsiTwoAdmissible] using
    NumStability.HDP.Scalar.SubGaussian.exercise269_counterexample

/-! Stable Chapter 2 alias for the `L²` interpolation estimate. -/
theorem hdp_02_hlem_hlp_hextrapolation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {Z : Ω → ℝ}
    (hZ1 : MemLp Z 1 μ) (hZ3 : MemLp Z 3 μ) :
    (∫ ω, |Z ω| ^ (2 : ℝ) ∂μ) ^ (1 / 2 : ℝ) ≤
      (∫ ω, |Z ω| ∂μ) ^ (1 / 4 : ℝ) *
        (∫ ω, |Z ω| ^ (3 : ℕ) ∂μ) ^ (1 / 4 : ℝ) :=
  NumStability.HDP.Scalar.SubGaussian.lpExtrapolation hZ1 hZ3

end NumStability.HDP.Contract
```

### `ComputationalMathematics.HDP.Scalar.SubExponential`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/SubExponential.lean`
SHA-256: `7fa36f88119c153ca211b1a7201c07afe764ff7be04a0502892341138514b24f`

```lean
import Mathlib.Analysis.Convex.Function
import Mathlib.Analysis.Calculus.Taylor
import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Analysis.SpecialFunctions.Stirling
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.Probability.Distributions.Exponential
import Mathlib.Probability.Moments.IntegrableExpMul
import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Remark09.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussian
import Mathlib.Tactic

/-!
# Orlicz functions

This module records the source-level Orlicz-function interface from Chapter 2,
Section 2.7.1.  The domain is represented by `ℝ`, with the defining
properties restricted to the nonnegative half-line.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open ProbabilityTheory
open scoped Topology ENNReal

namespace NumStability.HDP.Scalar.SubExponential

/-- A convex, nondecreasing function with the defining Orlicz properties. -/
structure OrliczFunction where
  /-- The underlying real function. -/
  toFun : ℝ → ℝ
  nonnegative : ∀ x, 0 ≤ x → 0 ≤ toFun x
  convexOn_nonneg : ConvexOn ℝ (Set.Ici 0) toFun
  monotoneOn_nonneg : MonotoneOn toFun (Set.Ici 0)
  map_zero : toFun 0 = 0
  tendsto_atTop : Tendsto toFun atTop atTop

instance : CoeFun OrliczFunction (fun _ => ℝ → ℝ) :=
  ⟨OrliczFunction.toFun⟩

/-- The Orlicz function separates every positive scale from zero. -/
theorem OrliczFunction.tendsto_scale_separation
    (ψ : OrliczFunction) {δ : ℝ} (hδ : 0 < δ) :
    Tendsto (fun t : ℝ => ψ (δ / t)) (𝓝[>] 0) atTop := by
  have hinv : Tendsto (fun t : ℝ => t⁻¹) (𝓝[>] (0 : ℝ)) atTop :=
    tendsto_inv_nhdsGT_zero
  have hscale : Tendsto (fun t : ℝ => δ / t) (𝓝[>] (0 : ℝ)) atTop := by
    have hmul := hinv.atTop_mul_pos hδ (tendsto_const_nhds :
      Tendsto (fun _ : ℝ => δ) (𝓝[>] (0 : ℝ)) (𝓝 δ))
    simpa [div_eq_mul_inv, mul_comm] using hmul
  exact ψ.tendsto_atTop.comp hscale

/-! The Luxemburg/Orlicz gauge and its a.e. quotient-level space. -/
/-- The Orlicz integral of a representative at scale `t`. -/
def orliczIntegral {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ≥0∞) : ENNReal :=
  ∫⁻ ω, ENNReal.ofReal (ψ (|X ω| / t.toReal)) ∂μ

/-- Admissibility of a scale for the Luxemburg gauge. -/
def orliczAdmissible {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ≥0∞) : Prop :=
  t ≠ 0 ∧ t ≠ ∞ ∧ orliczIntegral ψ μ X t ≤ 1

/-- The extended Luxemburg gauge associated with `ψ` and `μ`. -/
noncomputable def orliczGauge {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) : ℝ≥0∞ :=
  sInf {t : ℝ≥0∞ | orliczAdmissible ψ μ X t}

/-- The predicate that a representative has finite Orlicz gauge. -/
def orliczMember {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) : Prop :=
  orliczGauge ψ μ X < ∞

/-- Strongly measurable representatives with finite Orlicz gauge. -/
def orliczRepresentative {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) :=
  {X : Ω → ℝ // AEStronglyMeasurable X μ ∧ orliczMember ψ μ X}

/-- Almost-everywhere equality on Orlicz representatives. -/
def orliczAESetoid {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) : Setoid (orliczRepresentative ψ μ) where
  r X Y := X.1 =ᵐ[μ] Y.1
  iseqv := ⟨fun _ => Filter.Eventually.of_forall (fun _ => rfl),
    fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/-- The almost-everywhere quotient of Orlicz representatives. -/
def orliczSpace {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) :=
  Quotient (orliczAESetoid ψ μ)

/-- The representative gauge and quotient carrier of an Orlicz norm space. -/
structure OrliczNormSpaceModelData
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) where
  /-- The Luxemburg gauge on representatives. -/
  representativeGauge : (Ω → ℝ) → ℝ≥0∞
  representativeGauge_eq : ∀ X, representativeGauge X = orliczGauge ψ μ X
  /-- The finite-gauge membership predicate on representatives. -/
  representativeMember : (Ω → ℝ) → Prop
  representativeMember_iff : ∀ X, representativeMember X ↔ orliczMember ψ μ X
  /-- The quotient by almost-everywhere equality. -/
  quotient : Type _
  quotient_eq : quotient = orliczSpace ψ μ
  admissible_smul_iff :
    ∀ (X : Ω → ℝ) {c t : ℝ}, 0 < c → 0 < t →
      (orliczAdmissible ψ μ X (ENNReal.ofReal t) ↔
        orliczAdmissible ψ μ (fun ω => c * X ω) (ENNReal.ofReal (c * t)))
  integral_mono :
    ∀ {X Y : Ω → ℝ} {t : ℝ≥0∞}, (∀ ω, |X ω| ≤ |Y ω|) → t ≠ 0 → t ≠ ∞ →
      orliczIntegral ψ μ X t ≤ orliczIntegral ψ μ Y t

lemma orliczAdmissible_smul_iff
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    {c t : ℝ} (hc : 0 < c) (ht : 0 < t) :
    orliczAdmissible ψ μ X (ENNReal.ofReal t) ↔
      orliczAdmissible ψ μ (fun ω => c * X ω) (ENNReal.ofReal (c * t)) := by
  have ht0 : ENNReal.ofReal t ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 ht
  have htTop : ENNReal.ofReal t ≠ ∞ := ENNReal.ofReal_ne_top
  have hct0 : ENNReal.ofReal (c * t) ≠ 0 :=
    (ENNReal.ofReal_ne_zero_iff).2 (mul_pos hc ht)
  have hctTop : ENNReal.ofReal (c * t) ≠ ∞ := ENNReal.ofReal_ne_top
  have harg : (fun ω =>
      |c * X ω| / (ENNReal.ofReal (c * t)).toReal) =
      (fun ω => |X ω| / (ENNReal.ofReal t).toReal) := by
    funext ω
    simp only [ENNReal.toReal_ofReal (le_of_lt ht),
      ENNReal.toReal_ofReal (le_of_lt (mul_pos hc ht)), abs_mul, abs_of_pos hc]
    field_simp
  have hInt : orliczIntegral ψ μ (fun ω => c * X ω) (ENNReal.ofReal (c * t)) =
      orliczIntegral ψ μ X (ENNReal.ofReal t) := by
    unfold orliczIntegral
    have hfun : (fun ω => ENNReal.ofReal
        (ψ (|c * X ω| / (ENNReal.ofReal (c * t)).toReal))) =
        (fun ω => ENNReal.ofReal
          (ψ (|X ω| / (ENNReal.ofReal t).toReal))) := by
      funext ω
      rw [congrFun harg ω]
    rw [hfun]
  constructor
  · intro h
    exact ⟨hct0, hctTop, hInt ▸ h.2.2⟩
  · intro h
    exact ⟨ht0, htTop, hInt ▸ h.2.2⟩

lemma orliczIntegral_mono
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) {X Y : Ω → ℝ} {t : ℝ≥0∞}
    (hXY : ∀ ω, |X ω| ≤ |Y ω|) (ht0 : t ≠ 0) (htTop : t ≠ ∞) :
    orliczIntegral ψ μ X t ≤ orliczIntegral ψ μ Y t := by
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  apply lintegral_mono_ae
  exact Filter.Eventually.of_forall (fun ω => by
    apply ENNReal.ofReal_le_ofReal
    apply ψ.monotoneOn_nonneg
    · exact div_nonneg (abs_nonneg _) htpos.le
    · exact div_nonneg (abs_nonneg _) htpos.le
    · exact div_le_div_of_nonneg_right (hXY ω) htpos.le)

/-- Construct the canonical Orlicz norm-space model. -/
def orliczNormSpaceModel
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) : OrliczNormSpaceModelData ψ μ :=
  { representativeGauge := fun X => orliczGauge ψ μ X
    representativeGauge_eq := fun _ => rfl
    representativeMember := fun X => orliczMember ψ μ X
    representativeMember_iff := fun _ => Iff.rfl
    quotient := orliczSpace ψ μ
    quotient_eq := rfl
    admissible_smul_iff := by
      intro X c t
      simpa using (orliczAdmissible_smul_iff ψ μ X (c := c) (t := t))
    integral_mono := fun hXY ht0 htTop => orliczIntegral_mono ψ μ hXY ht0 htTop }

/-! The moment-to-MGF implication from Proposition 2.7.1. -/

/-- The root-free integral form of the source's `‖X‖ₚ ≤ K p` hypothesis.  The
real-parameter formulation keeps the statement faithful to the printed
proposition; the proof below specializes it to the integer moments appearing
in the exponential series. -/
def LpMomentGrowth {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (K : ℝ) : Prop :=
  AEMeasurable X μ ∧
    ∀ p : ℝ, 1 ≤ p →
      Integrable (fun ω => |X ω| ^ p) μ ∧
        (∫ ω, |X ω| ^ p ∂μ) ≤ (K * p) ^ p

/-- The `n`th nonnegative term in the absolute-MGF power series. -/
def absMGFTerm {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) : ENNReal :=
  ENNReal.ofReal (((|lam| * |X ω|) ^ n) / (n.factorial : ℝ))

lemma absMGFTerm_aemeasurable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hX : AEMeasurable X μ) (lam : ℝ) (n : ℕ) :
    AEMeasurable (absMGFTerm X lam n) μ := by
  unfold absMGFTerm
  fun_prop

lemma exp_abs_series (x : ℝ) (hx : 0 ≤ x) :
    ENNReal.ofReal (Real.exp x) =
      ∑' n : ℕ, ENNReal.ofReal (x ^ n / (n.factorial : ℝ)) := by
  rw [← ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity)
    (NormedSpace.expSeries_div_summable x)]
  rw [NormedSpace.expSeries_div_hasSum_exp x |>.tsum_eq]
  rw [← Real.exp_eq_exp_ℝ]

lemma linear_factorial_ratio_bound (n : ℕ) (hn : 1 ≤ n) :
    ((n : ℝ) ^ n) / (n.factorial : ℝ) ≤ (Real.exp 1) ^ n := by
  have hfac := Stirling.le_factorial_stirling n
  have hroot : 1 ≤ Real.sqrt (2 * Real.pi * (n : ℝ)) := by
    rw [Real.one_le_sqrt]
    have hpi : (2 : ℝ) ≤ Real.pi := by
      nlinarith [Real.one_le_pi_div_two]
    have hnpos : (0 : ℝ) < (n : ℝ) := by
      exact_mod_cast (show 0 < n by omega)
    have hn1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    have hprod : (1 : ℝ) ≤ Real.pi * n := by
      nlinarith [mul_le_mul_of_nonneg_right hpi (le_of_lt hnpos)]
    nlinarith [hprod]
  have hfac' : (n : ℝ) ^ n / (Real.exp 1) ^ n ≤ (n.factorial : ℝ) := by
    have hfac'' := (le_trans (mul_le_mul_of_nonneg_right hroot
      (by positivity : 0 ≤ ((n : ℝ) / Real.exp 1) ^ n)) hfac)
    simpa [div_pow] using hfac''
  have hmul : (n : ℝ) ^ n ≤ (n.factorial : ℝ) * (Real.exp 1) ^ n := by
    rw [← div_le_iff₀ (by positivity : 0 < (Real.exp 1) ^ n)]
    simpa [div_pow] using hfac'
  exact (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).2
    (by simpa [mul_comm] using hmul)

lemma absMGFTerm_lintegral_le_geom
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K lam : ℝ}
    (hK : 0 ≤ K) (hMom : LpMomentGrowth μ X K) {n : ℕ} (hn : 1 ≤ n) :
    (∫⁻ ω, absMGFTerm X lam n ω ∂μ) ≤
      ENNReal.ofReal ((Real.exp 1 * (|lam| * K)) ^ n) := by
  have hp := hMom.2 (n : ℝ) (by exact_mod_cast hn)
  have hterm :
      absMGFTerm X lam n = fun ω =>
        ENNReal.ofReal ((|lam| ^ n / (n.factorial : ℝ)) * |X ω| ^ n) := by
    funext ω
    unfold absMGFTerm
    congr 1
    rw [mul_pow]
    ring
  rw [hterm]
  have hscalar : 0 ≤ |lam| ^ n / (n.factorial : ℝ) := by positivity
  have hfactor :
      (fun ω => ENNReal.ofReal ((|lam| ^ n / (n.factorial : ℝ)) * |X ω| ^ n)) =
        (fun ω => ENNReal.ofReal (|lam| ^ n / (n.factorial : ℝ)) *
          ENNReal.ofReal (|X ω| ^ n)) := by
    funext ω
    rw [ENNReal.ofReal_mul hscalar]
  rw [hfactor, lintegral_const_mul' _ _ (by simp)]
  have hXpow : (fun ω => |X ω| ^ n) = (fun ω => |X ω| ^ (n : ℝ)) := by
    funext ω
    rw [Real.rpow_natCast]
  have hXpowENN :
      (fun ω => ENNReal.ofReal (|X ω| ^ n)) =
        (fun ω => ENNReal.ofReal (|X ω| ^ (n : ℝ))) := by
    funext ω
    rw [Real.rpow_natCast]
  rw [hXpowENN]
  rw [← ofReal_integral_eq_lintegral_ofReal hp.1
    (Filter.Eventually.of_forall (fun ω => by positivity))]
  have hbound := mul_le_mul_of_nonneg_left hp.2 hscalar
  rw [← ENNReal.ofReal_mul hscalar]
  apply ENNReal.ofReal_le_ofReal
  calc
    |lam| ^ n / (n.factorial : ℝ) *
          (∫ ω, |X ω| ^ (n : ℝ) ∂μ) ≤
        |lam| ^ n / (n.factorial : ℝ) * (K * (n : ℝ)) ^ (n : ℝ) := hbound
    _ = ((|lam| * K) ^ n * (n : ℝ) ^ n) / (n.factorial : ℝ) := by
      rw [Real.rpow_natCast]
      rw [mul_pow]
      ring
    _ ≤ (Real.exp 1 * (|lam| * K)) ^ n := by
      have hratio := linear_factorial_ratio_bound n hn
      have hnonneg : 0 ≤ (|lam| * K) ^ n := by positivity
      apply (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).2
      have hratio' : (n : ℝ) ^ n ≤ (Real.exp 1) ^ n * (n.factorial : ℝ) :=
        (div_le_iff₀ (by positivity : (0 : ℝ) < (n.factorial : ℝ))).mp hratio
      calc
        (|lam| * K) ^ n * (n : ℝ) ^ n ≤
            (|lam| * K) ^ n * ((Real.exp 1) ^ n * (n.factorial : ℝ)) := by
              gcongr
        _ = (Real.exp 1 * (|lam| * K)) ^ n * (n.factorial : ℝ) := by
          rw [mul_pow]
          ring

lemma absMGFTerm_eq
    {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) :
    absMGFTerm X lam n ω =
      ENNReal.ofReal ((|lam| ^ n / (n.factorial : ℝ)) * |X ω| ^ n) := by
  unfold absMGFTerm
  congr 1
  rw [mul_pow]
  ring

lemma exp_abs_integrable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K lam : ℝ} (hMom : LpMomentGrowth μ X K)
    (hK : 0 < K) (hsmall : |lam| * K ≤ (4 * Real.exp 1)⁻¹) :
    Integrable (fun ω => Real.exp (|lam| * |X ω|)) μ ∧
      (∫ ω, Real.exp (|lam| * |X ω|) ∂μ) ≤
        Real.exp (2 * Real.exp 1 * (|lam| * K)) := by
  let q : ℝ := Real.exp 1 * (|lam| * K)
  have hq0 : 0 ≤ q := by positivity
  have hq : q ≤ 1 / 4 := by
    dsimp [q]
    have hepos : 0 < Real.exp 1 := Real.exp_pos _
    have := mul_le_mul_of_nonneg_left hsmall (le_of_lt hepos)
    field_simp at this ⊢
    nlinarith
  have hqsum : Summable (fun n : ℕ => q ^ n) := by
    exact (hasSum_geometric_of_lt_one hq0
      (lt_of_le_of_lt hq (by norm_num))).summable
  have hterm_sum :
      (∑' n : ℕ, ∫⁻ ω, absMGFTerm X lam n ω ∂μ) ≤
        ∑' n : ℕ, ENNReal.ofReal (q ^ n) := by
    apply ENNReal.tsum_le_tsum
    intro n
    cases n with
    | zero => simp [absMGFTerm]
    | succ n =>
        simpa [q] using
          (absMGFTerm_lintegral_le_geom hK.le hMom (n := n + 1) (by omega))
  have hbound :
      (∫⁻ ω, ENNReal.ofReal (Real.exp (|lam| * |X ω|)) ∂μ) ≤
        ENNReal.ofReal (Real.exp (2 * q)) := by
    calc
      (∫⁻ ω, ENNReal.ofReal (Real.exp (|lam| * |X ω|)) ∂μ) =
          ∫⁻ ω, ∑' n : ℕ, absMGFTerm X lam n ω ∂μ := by
            apply lintegral_congr_ae
            filter_upwards [] with ω
            exact exp_abs_series (|lam| * |X ω|) (by positivity)
      _ = ∑' n : ℕ, ∫⁻ ω, absMGFTerm X lam n ω ∂μ := by
            apply lintegral_tsum
            intro n
            exact absMGFTerm_aemeasurable hMom.1 lam n
      _ ≤ ∑' n : ℕ, ENNReal.ofReal (q ^ n) := hterm_sum
      _ = ENNReal.ofReal (∑' n : ℕ, q ^ n) := by
            symm
            exact ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity) hqsum
      _ ≤ ENNReal.ofReal (Real.exp (2 * q)) := by
            have hsum := (hasSum_geometric_of_lt_one hq0
              (lt_of_le_of_lt hq (by norm_num))).tsum_eq
            rw [hsum]
            have hden : 0 < 1 - q := by linarith
            have hrat : (1 - q)⁻¹ ≤ 1 + 2 * q := by
              rw [inv_eq_one_div]
              apply (div_le_iff₀ hden).2
              nlinarith [mul_nonneg hq0 (sub_nonneg.mpr (by linarith : q ≤ 1 / 2))]
            exact ENNReal.ofReal_le_ofReal
              (hrat.trans (by simpa [add_comm] using Real.add_one_le_exp (2 * q)))
  rcases hMom.1 with ⟨g, hg, hXg⟩
  have hAbs : AEMeasurable (fun ω => |X ω|) μ := by
    apply (hg.norm.aemeasurable.congr ?_)
    filter_upwards [hXg] with ω hω
    simp [Real.norm_eq_abs, hω]
  have hmeas : AEMeasurable (fun ω => Real.exp (|lam| * |X ω|)) μ := by
    fun_prop
  have hfinite :
      (∫⁻ ω, ‖Real.exp (|lam| * |X ω|)‖ₑ ∂μ) < (⊤ : ENNReal) := by
    have htop : ENNReal.ofReal (Real.exp (2 * q)) < (⊤ : ENNReal) :=
      ENNReal.ofReal_lt_top
    refine lt_of_le_of_lt ?_ htop
    simpa only [← ofReal_norm_eq_enorm, Real.norm_eq_abs,
      abs_of_pos (Real.exp_pos _)] using hbound
  have hInt : Integrable (fun ω => Real.exp (|lam| * |X ω|)) μ :=
    ⟨hmeas.aestronglyMeasurable, (hasFiniteIntegral_iff_enorm).2 hfinite⟩
  refine ⟨hInt, ?_⟩
  have hEq := ofReal_integral_eq_lintegral_ofReal hInt
    (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
  rw [← hEq] at hbound
  simpa [q, mul_assoc] using
    (ENNReal.ofReal_le_ofReal_iff (Real.exp_nonneg _)).mp hbound

/-- The `n`th term in the centered absolute-MGF remainder series. -/
def mgfRemainderTerm {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (n : ℕ) (ω : Ω) : ENNReal :=
  ENNReal.ofReal (((|lam| * |X ω|) ^ (n + 2)) / ((n + 2).factorial : ℝ))

lemma mgfRemainderTerm_aemeasurable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hX : AEMeasurable X μ) (lam : ℝ) (n : ℕ) :
    AEMeasurable (mgfRemainderTerm X lam n) μ := by
  unfold mgfRemainderTerm
  fun_prop

lemma exp_abs_remainder_series (y : ℝ) :
    ENNReal.ofReal (Real.exp |y| - 1 - |y|) =
      ∑' n : ℕ, ENNReal.ofReal ((|y| ^ (n + 2)) / ((n + 2).factorial : ℝ)) := by
  let f : ℕ → ℝ := fun n => |y| ^ n / (n.factorial : ℝ)
  have hsum : Summable f := by
    dsimp [f]
    exact NormedSpace.expSeries_div_summable |y|
  have hsplit := hsum.sum_add_tsum_nat_add 2
  have hexp : (∑' n : ℕ, f n) = Real.exp |y| := by
    dsimp [f]
    rw [Real.exp_eq_exp_ℝ]
    exact (NormedSpace.expSeries_div_hasSum_exp |y|).tsum_eq
  have htail :
      (∑' n : ℕ, |y| ^ (n + 2) / ((n + 2).factorial : ℝ)) =
        Real.exp |y| - 1 - |y| := by
    have hsplit' :
        f 0 + f 1 + ∑' n : ℕ, f (n + 2) = Real.exp |y| := by
      simpa [Finset.sum_range_succ, f, Nat.factorial] using hsplit.trans hexp
    dsimp [f] at hsplit'
    have hpow : |y| ^ 1 = |y| := by simp
    rw [hpow] at hsplit'
    linarith
  rw [← ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity)]
  · rw [htail]
  · have hinj : Function.Injective (fun n : ℕ => n + 2) := by
      intro a b hab
      change a + 2 = b + 2 at hab
      exact Nat.add_right_cancel hab
    simpa [f] using hsum.comp_injective hinj

lemma mgfRemainderTerm_lintegral_le_geom
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K lam : ℝ}
    (hK : 0 ≤ K) (hMom : LpMomentGrowth μ X K) (n : ℕ) :
    (∫⁻ ω, mgfRemainderTerm X lam n ω ∂μ) ≤
      ENNReal.ofReal ((Real.exp 1 * (|lam| * K)) ^ (n + 2)) := by
  have h := absMGFTerm_lintegral_le_geom (lam := lam) hK hMom
    (n := n + 2) (by omega)
  simpa [mgfRemainderTerm, absMGFTerm] using h

lemma mgfRemainder_lintegral_le
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K lam : ℝ} (hK : 0 ≤ K)
    (hMom : LpMomentGrowth μ X K)
    (hsmall : |lam| * K ≤ (4 * Real.exp 1)⁻¹) :
    (∫⁻ ω, ENNReal.ofReal (Real.exp (|lam| * |X ω|) - 1 -
      |lam| * |X ω|) ∂μ) ≤
        ENNReal.ofReal (2 * (Real.exp 1 * (|lam| * K)) ^ 2) := by
  let q : ℝ := Real.exp 1 * (|lam| * K)
  have hq0 : 0 ≤ q := by positivity
  have hq : q ≤ 1 / 4 := by
    dsimp [q]
    have hepos : 0 < Real.exp 1 := Real.exp_pos _
    have := mul_le_mul_of_nonneg_left hsmall (le_of_lt hepos)
    field_simp at this ⊢
    nlinarith
  have hqsum : Summable (fun n : ℕ => q ^ (n + 2)) := by
    have hsum := (hasSum_geometric_of_lt_one hq0
      (lt_of_le_of_lt hq (by norm_num))).summable
    have hinj : Function.Injective (fun n : ℕ => n + 2) := by
      intro a b hab
      change a + 2 = b + 2 at hab
      exact Nat.add_right_cancel hab
    simpa using hsum.comp_injective hinj
  have hterm_sum :
      (∑' n : ℕ, ∫⁻ ω, mgfRemainderTerm X lam n ω ∂μ) ≤
        ∑' n : ℕ, ENNReal.ofReal (q ^ (n + 2)) := by
    apply ENNReal.tsum_le_tsum
    intro n
    simpa [q] using mgfRemainderTerm_lintegral_le_geom hK hMom n
  calc
    (∫⁻ ω, ENNReal.ofReal (Real.exp (|lam| * |X ω|) - 1 -
        |lam| * |X ω|) ∂μ) =
        ∫⁻ ω, ∑' n : ℕ, mgfRemainderTerm X lam n ω ∂μ := by
          apply lintegral_congr_ae
          filter_upwards [] with ω
          simpa [abs_mul, mgfRemainderTerm] using exp_abs_remainder_series (lam * X ω)
    _ = ∑' n : ℕ, ∫⁻ ω, mgfRemainderTerm X lam n ω ∂μ := by
          apply lintegral_tsum
          intro n
          exact mgfRemainderTerm_aemeasurable hMom.1 lam n
    _ ≤ ∑' n : ℕ, ENNReal.ofReal (q ^ (n + 2)) := hterm_sum
    _ = ENNReal.ofReal (∑' n : ℕ, q ^ (n + 2)) := by
          symm
          exact ENNReal.ofReal_tsum_of_nonneg (fun n => by positivity) hqsum
    _ = ENNReal.ofReal (q ^ 2 * (1 - q)⁻¹) := by
          congr 1
          have hgeom : Summable (fun n : ℕ => q ^ n) :=
            (hasSum_geometric_of_lt_one hq0
              (lt_of_le_of_lt hq (by norm_num))).summable
          have hsum := (hasSum_geometric_of_lt_one hq0
            (lt_of_le_of_lt hq (by norm_num))).tsum_eq
          have hmul :
              (∑' n : ℕ, q ^ n * q ^ 2) = (∑' n : ℕ, q ^ n) * q ^ 2 := by
            exact hgeom.tsum_mul_right (q ^ 2)
          rw [show (∑' n : ℕ, q ^ (n + 2)) =
              ∑' n : ℕ, q ^ n * q ^ 2 by
                apply tsum_congr
                intro n
                rw [pow_add]]
          rw [hmul, hsum]
          ring
    _ ≤ ENNReal.ofReal (2 * q ^ 2) := by
          apply ENNReal.ofReal_le_ofReal
          have hden : 0 < 1 - q := by linarith
          have hrat : (1 - q)⁻¹ ≤ 2 := by
            rw [inv_eq_one_div]
            apply (div_le_iff₀ hden).2
            linarith
          nlinarith [mul_le_mul_of_nonneg_left hrat (sq_nonneg q)]
    _ = ENNReal.ofReal (2 * (Real.exp 1 * (|lam| * K)) ^ 2) := by
          congr 2

lemma exp_le_centered_remainder (y : ℝ) :
    Real.exp y ≤ 1 + y + (Real.exp |y| - 1 - |y|) := by
  rcases le_total 0 y with hy | hy
  · simp [abs_of_nonneg hy]
  · have hx : 0 ≤ -y := neg_nonneg.mpr hy
    have hs : -y ≤ Real.sinh (-y) := (Real.self_le_sinh_iff).2 hx
    rw [Real.sinh_eq] at hs
    simp only [neg_neg] at hs
    rw [abs_of_nonpos hy]
    linarith

/-- The pointwise remainder after the constant and linear MGF terms. -/
def mgfRemainder {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (ω : Ω) : ℝ :=
  Real.exp (|lam| * |X ω|) - 1 - |lam| * |X ω|

lemma mgfRemainder_nonneg
    {Ω : Type*} (X : Ω → ℝ) (lam : ℝ) (ω : Ω) :
    0 ≤ mgfRemainder X lam ω := by
  unfold mgfRemainder
  have h := Real.add_one_le_exp (|lam| * |X ω|)
  linarith

lemma mgfRemainder_integrable
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {lam : ℝ} (hX : Integrable X μ)
    (hExp : Integrable (fun ω => Real.exp (|lam| * |X ω|)) μ) :
    Integrable (mgfRemainder X lam) μ := by
  have hlin : Integrable (fun ω => |lam| * |X ω|) μ :=
    hX.norm.const_mul |lam|
  simpa [mgfRemainder] using (hExp.sub (integrable_const 1)).sub hlin

/-! If all moments grow linearly, the centered MGF has a quadratic local
bound.  The proof expands the exponential at order two, bounds the absolute
remainder by the linear moment series, and uses the mean-zero hypothesis to
remove the first-order term. -/
theorem momentToMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hLp : LpMomentGrowth μ X K) (lam : ℝ)
    (hsmall : |lam| ≤ (4 * Real.exp 1 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp (2 * (Real.exp 1 * (lam * K)) ^ 2) := by
  have hsmall' : |lam| * K ≤ (4 * Real.exp 1)⁻¹ := by
    calc
      |lam| * K ≤ (4 * Real.exp 1 * K)⁻¹ * K :=
        mul_le_mul_of_nonneg_right hsmall hK.le
      _ = (4 * Real.exp 1)⁻¹ := by field_simp
  have hAbs := exp_abs_integrable hLp hK hsmall'
  have hIntMgf : Integrable (fun ω => Real.exp (lam * X ω)) μ := by
    have hlin := hCenter.1.const_mul lam
    refine MeasureTheory.Integrable.mono' hAbs.1
      (hlin.aemeasurable.exp).aestronglyMeasurable ?_
    filter_upwards [] with ω
    calc
      ‖Real.exp (lam * X ω)‖ = Real.exp (lam * X ω) := by
        rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      _ ≤ Real.exp (|lam| * |X ω|) := by
        apply Real.exp_le_exp.mpr
        simpa [abs_mul] using le_abs_self (lam * X ω)
  have hRInt : Integrable (mgfRemainder X lam) μ :=
    mgfRemainder_integrable hCenter.1 hAbs.1
  have hsum : Integrable (fun ω => 1 + lam * X ω + mgfRemainder X lam ω) μ := by
    exact (integrable_const 1).add (hCenter.1.const_mul lam) |>.add hRInt
  have hmono := MeasureTheory.integral_mono_ae hIntMgf hsum
    (Filter.Eventually.of_forall (fun ω => by
      simpa [mgfRemainder, abs_mul] using exp_le_centered_remainder (lam * X ω)))
  have hRnonneg : ∀ᵐ ω ∂μ, 0 ≤ mgfRemainder X lam ω :=
    Filter.Eventually.of_forall (mgfRemainder_nonneg X lam)
  have hRboundENN := mgfRemainder_lintegral_le hK.le hLp hsmall'
  have hRboundENN' :
      (∫⁻ ω, ENNReal.ofReal (mgfRemainder X lam ω) ∂μ) ≤
        ENNReal.ofReal (2 * (Real.exp 1 * (|lam| * K)) ^ 2) := by
    simpa [mgfRemainder] using hRboundENN
  have hReq := ofReal_integral_eq_lintegral_ofReal hRInt hRnonneg
  rw [← hReq] at hRboundENN'
  have hRbound :
      (∫ ω, mgfRemainder X lam ω ∂μ) ≤
        2 * (Real.exp 1 * (|lam| * K)) ^ 2 := by
    exact (ENNReal.ofReal_le_ofReal_iff (by positivity)).mp hRboundENN'
  refine ⟨hIntMgf, ?_⟩
  calc
    (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        ∫ ω, 1 + lam * X ω + mgfRemainder X lam ω ∂μ := hmono
    _ = 1 + lam * (∫ ω, X ω ∂μ) +
        ∫ ω, mgfRemainder X lam ω ∂μ := by
          calc
            (∫ ω, 1 + lam * X ω + mgfRemainder X lam ω ∂μ) =
                (∫ ω, 1 + lam * X ω ∂μ) +
                  ∫ ω, mgfRemainder X lam ω ∂μ := by
                    exact integral_add ((integrable_const 1).add
                      (hCenter.1.const_mul lam)) hRInt
            _ = 1 + lam * (∫ ω, X ω ∂μ) +
                  ∫ ω, mgfRemainder X lam ω ∂μ := by
                    rw [integral_add (integrable_const 1)
                      (hCenter.1.const_mul lam), integral_const, integral_const_mul]
                    simp
    _ = 1 + ∫ ω, mgfRemainder X lam ω ∂μ := by rw [hCenter.2]; ring
    _ ≤ 1 + 2 * (Real.exp 1 * (|lam| * K)) ^ 2 := by gcongr
    _ ≤ Real.exp (2 * (Real.exp 1 * (lam * K)) ^ 2) := by
      calc
        1 + 2 * (Real.exp 1 * (|lam| * K)) ^ 2 =
            2 * (Real.exp 1 * (|lam| * K)) ^ 2 + 1 := by ring
        _ ≤ Real.exp (2 * (Real.exp 1 * (|lam| * K)) ^ 2) :=
          Real.add_one_le_exp _
        _ = Real.exp (2 * (Real.exp 1 * (lam * K)) ^ 2) := by
          congr 2
          rw [mul_pow, mul_pow, sq_abs]
          ring

/-! The endpoint MGF hypothesis used for the reverse implication. -/
/-- Two endpoint exponential-moment bounds at scale `K`. -/
def TwoSidedMGFBound {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (X : Ω → ℝ) (K C : ℝ) : Prop :=
  AEMeasurable X μ ∧
    (Integrable (fun ω => Real.exp (X ω / K)) μ ∧
      (∫ ω, Real.exp (X ω / K) ∂μ) ≤ Real.exp C) ∧
    (Integrable (fun ω => Real.exp (-X ω / K)) μ ∧
      (∫ ω, Real.exp (-X ω / K) ∂μ) ≤ Real.exp C)

lemma rpow_le_exp_mul
    {y p : ℝ} (hy : 0 ≤ y) (hp : 1 ≤ p) :
    y ^ p ≤ p ^ p * Real.exp y := by
  have hp0 : 0 < p := lt_of_lt_of_le (by norm_num) hp
  rcases eq_or_lt_of_le hy with rfl | hy
  · simp [hp0.ne']
    positivity
  have hlog := Real.log_le_sub_one_of_pos (div_pos hy hp0)
  rw [Real.log_div hy.ne' hp0.ne'] at hlog
  have hmul := mul_le_mul_of_nonneg_left hlog hp0.le
  have hlogbound : Real.log y * p ≤ Real.log p * p + y := by
    calc
      Real.log y * p = p * (Real.log y - Real.log p) + p * Real.log p := by ring
      _ ≤ p * (y / p - 1) + p * Real.log p :=
        by simpa [add_comm] using add_le_add_right hmul (p * Real.log p)
      _ = y - p + Real.log p * p := by field_simp
      _ ≤ Real.log p * p + y := by nlinarith
  calc
    y ^ p = Real.exp (Real.log y * p) := by
      rw [Real.rpow_def_of_pos hy p]
    _ ≤ Real.exp (Real.log p * p + y) := Real.exp_le_exp.mpr hlogbound
    _ = p ^ p * Real.exp y := by
      rw [Real.rpow_def_of_pos hp0 p, Real.exp_add]

/-! The reverse implication in Proposition 2.7.1.  The endpoint MGF bound
controls the exponential of the absolute value, and the elementary estimate
`|x|^p ≤ p^p exp |x|` then gives every real moment. -/
theorem mgfToMoment
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K C : ℝ} (hK : 0 < K) (hC : 0 ≤ C)
    (hMGF : TwoSidedMGFBound μ X K C) :
    LpMomentGrowth μ X (2 * Real.exp C * K) := by
  rcases hMGF with ⟨hX, hPlus, hMinus⟩
  have hPlus' : Integrable (fun ω => Real.exp (K⁻¹ * X ω)) μ := by
    simpa [div_eq_mul_inv, mul_comm] using hPlus.1
  have hMinus' : Integrable (fun ω => Real.exp (-(K⁻¹) * X ω)) μ := by
    simpa [div_eq_mul_inv, mul_comm] using hMinus.1
  have ht : K⁻¹ ≠ 0 := inv_ne_zero hK.ne'
  have hAbsExp : Integrable (fun ω => Real.exp (|X ω| / K)) μ := by
    convert ProbabilityTheory.integrable_exp_abs_mul_abs
      (X := X) (μ := μ) (t := K⁻¹) hPlus' hMinus' using 1
    funext ω
    congr 1
    rw [abs_of_pos (inv_pos.mpr hK)]
    ring
  have hSumExp : Integrable
      (fun ω => Real.exp (X ω / K) + Real.exp (-X ω / K)) μ :=
    hPlus.1.add hMinus.1
  have hAbsExp_le : ∀ ω, Real.exp (|X ω| / K) ≤
      Real.exp (X ω / K) + Real.exp (-X ω / K) := by
    intro ω
    by_cases hω : 0 ≤ X ω
    · rw [abs_of_nonneg hω]
      exact le_add_of_nonneg_right (Real.exp_nonneg _)
    · rw [abs_of_neg (lt_of_not_ge hω)]
      exact le_add_of_nonneg_left (Real.exp_nonneg _)
  refine ⟨hX, ?_⟩
  intro p hp
  have hp0 : 0 < p := lt_of_lt_of_le (by norm_num) hp
  have hIntMoment : Integrable (fun ω => |X ω| ^ p) μ :=
    ProbabilityTheory.integrable_rpow_abs_of_integrable_exp_mul
      (X := X) (μ := μ) ht hPlus' hMinus' hp0.le
  have hPoint : ∀ ω, |X ω| ^ p ≤
      (K * p) ^ p * (Real.exp (X ω / K) + Real.exp (-X ω / K)) := by
    intro ω
    have hscaled : |X ω| = K * (|X ω| / K) := by field_simp
    have hpow := rpow_le_exp_mul (y := |X ω| / K) (by positivity) hp
    have hexp := hAbsExp_le ω
    calc
      |X ω| ^ p = (K * (|X ω| / K)) ^ p := by
        exact congrArg (fun z : ℝ => z ^ p) hscaled
      _ = K ^ p * (|X ω| / K) ^ p := by
        rw [Real.mul_rpow hK.le (by positivity)]
      _ ≤ K ^ p * (p ^ p * Real.exp (|X ω| / K)) := by
        gcongr
      _ ≤ K ^ p * (p ^ p *
          (Real.exp (X ω / K) + Real.exp (-X ω / K))) := by
        gcongr
      _ = (K * p) ^ p *
          (Real.exp (X ω / K) + Real.exp (-X ω / K)) := by
        rw [Real.mul_rpow hK.le hp0.le]
        ring
  have hDom : Integrable
      (fun ω => (K * p) ^ p *
        (Real.exp (X ω / K) + Real.exp (-X ω / K))) μ :=
    hSumExp.const_mul _
  have hIntegral := MeasureTheory.integral_mono_ae hIntMoment hDom
    (Filter.Eventually.of_forall hPoint)
  have hIntegral' :
      (∫ ω, |X ω| ^ p ∂μ) ≤ (K * p) ^ p * (2 * Real.exp C) := by
    calc
      (∫ ω, |X ω| ^ p ∂μ) ≤
          ∫ ω, (K * p) ^ p *
            (Real.exp (X ω / K) + Real.exp (-X ω / K)) ∂μ := hIntegral
      _ = (K * p) ^ p *
          (∫ ω, Real.exp (X ω / K) + Real.exp (-X ω / K) ∂μ) :=
        MeasureTheory.integral_const_mul _ _
      _ = (K * p) ^ p *
          ((∫ ω, Real.exp (X ω / K) ∂μ) +
            (∫ ω, Real.exp (-X ω / K) ∂μ)) := by
        rw [MeasureTheory.integral_add hPlus.1 hMinus.1]
      _ ≤ (K * p) ^ p * (2 * Real.exp C) := by
        gcongr
        exact (add_le_add hPlus.2 hMinus.2).trans
          (by simp [two_mul])
  have hA : 1 ≤ 2 * Real.exp C := by
    have := Real.one_le_exp hC
    nlinarith
  have hA' : 2 * Real.exp C ≤ (2 * Real.exp C) ^ p := by
    simpa [Real.rpow_one] using
      Real.rpow_le_rpow_of_exponent_le hA hp
  refine ⟨hIntMoment, ?_⟩
  calc
    (∫ ω, |X ω| ^ p ∂μ) ≤ (K * p) ^ p * (2 * Real.exp C) := hIntegral'
    _ ≤ (K * p) ^ p * (2 * Real.exp C) ^ p := by
      exact mul_le_mul_of_nonneg_left hA' (by positivity)
    _ = (2 * Real.exp C * K * p) ^ p := by
      rw [← Real.mul_rpow (by positivity) (by positivity)]
      ring

/-! Exercise 2.7.2: the four equivalent absolute-value interfaces. -/

/-- The two-sided sub-exponential tail-bound presentation. -/
def SubExponentialTailBound {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t / K)

/-- The moment-growth presentation of a sub-exponential bound. -/
def SubExponentialMomentBound {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧ LpMomentGrowth μ X K

/-- The local absolute-MGF presentation of a sub-exponential bound. -/
def SubExponentialAbsoluteMGFLocal {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    ∀ lam : ℝ, 0 ≤ lam → lam ≤ K⁻¹ →
      Integrable (fun ω => Real.exp (lam * |X ω|)) μ ∧
        (∫ ω, Real.exp (lam * |X ω|) ∂μ) ≤ Real.exp (K * lam)

/-- The one-point absolute-MGF presentation of a sub-exponential bound. -/
def SubExponentialOnePointMGF {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (K : ℝ) : Prop :=
  Measurable X ∧ 0 < K ∧
    Integrable (fun ω => Real.exp (|X ω| / K)) μ ∧
      (∫ ω, Real.exp (|X ω| / K) ∂μ) ≤ 2

/-- The four equivalent presentations of the sub-exponential property. -/
inductive SubExponentialPropertyKind
  | tail
  | moment
  | absoluteMGF
  | onePoint

/-- Interpret a sub-exponential presentation at a specified scale. -/
def SubExponentialProperty {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    SubExponentialPropertyKind → ℝ → Prop
  | .tail => SubExponentialTailBound μ X
  | .moment => SubExponentialMomentBound μ X
  | .absoluteMGF => SubExponentialAbsoluteMGFLocal μ X
  | .onePoint => SubExponentialOnePointMGF μ X

private theorem subExponentialTailToMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hTail : SubExponentialTailBound μ X K) :
    SubExponentialMomentBound μ X (8 * Real.exp 1 * K) := by
  have hTail' : ∀ t : ℝ, 0 ≤ t →
      μ {ω | t < |X ω|} ≤ ENNReal.ofReal (2 * Real.exp (-t / K)) := by
    intro t ht
    let A : Set Ω := {ω | t < |X ω|}
    let B : Set Ω := {ω | |X ω| ≥ t}
    have hAB : A ⊆ B := by
      intro ω hω
      change t < |X ω| at hω
      change t ≤ |X ω|
      exact le_of_lt hω
    have hB : μ B ≤ ENNReal.ofReal (2 * Real.exp (-t / K)) := by
      rw [← ENNReal.ofReal_toReal (measure_ne_top μ B)]
      apply ENNReal.ofReal_le_ofReal
      simpa [B, MeasureTheory.measureReal_def] using hTail.2.2 t ht
    exact (measure_mono hAB).trans hB
  refine ⟨hTail.1,
    mul_pos (mul_pos (by norm_num) (Real.exp_pos 1)) hTail.2.1, ?_⟩
  refine ⟨hTail.1.aemeasurable, ?_⟩
  intro p hp
  have hp0 : 0 < p := lt_of_lt_of_le (by norm_num) hp
  have hformula := NumStability.HDP.Scalar.Preliminaries.momentTailFormula
    (μ := μ) (X := X) hTail.1 hp0
  have hupper :
      (∫⁻ t in Set.Ioi 0,
        μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) ≤
        ∫⁻ t in Set.Ioi 0,
          ENNReal.ofReal (2 * Real.exp (-t / K)) *
            ENNReal.ofReal (t ^ (p - 1)) := by
    apply MeasureTheory.setLIntegral_mono
    · fun_prop
    · intro t ht
      exact mul_le_mul_left (hTail' t (le_of_lt (Set.mem_Ioi.mp ht))) _
  have hInt : IntegrableOn
      (fun t : ℝ => t ^ (p - 1) * Real.exp (-(K⁻¹) * t)) (Set.Ioi 0) := by
    simpa only [Real.rpow_one] using (integrableOn_rpow_mul_exp_neg_mul_rpow
      (p := (1 : ℝ)) (s := p - 1) (b := K⁻¹)
      (by linarith) (by norm_num) (inv_pos.mpr hTail.2.1))
  have hscale : ∀ t : ℝ,
      ENNReal.ofReal (2 * Real.exp (-t / K)) *
          ENNReal.ofReal (t ^ (p - 1)) =
        ENNReal.ofReal (2 * (t ^ (p - 1) * Real.exp (-(K⁻¹) * t))) := by
    intro t
    calc
      ENNReal.ofReal (2 * Real.exp (-t / K)) *
          ENNReal.ofReal (t ^ (p - 1)) =
        ENNReal.ofReal ((2 * Real.exp (-t / K)) * (t ^ (p - 1))) :=
          (ENNReal.ofReal_mul (by positivity)).symm
      _ = ENNReal.ofReal (2 * (t ^ (p - 1) * Real.exp (-(K⁻¹) * t))) := by
        congr 1
        field_simp [ne_of_gt hTail.2.1]
  have hInt2 : IntegrableOn
      (fun t : ℝ => 2 * (t ^ (p - 1) * Real.exp (-(K⁻¹) * t))) (Set.Ioi 0) :=
    hInt.const_mul _
  have hEq2 := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt2
    (by
      filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
      have ht0 : 0 < t := Set.mem_Ioi.mp ht
      positivity)
  have hGamma := integral_rpow_mul_exp_neg_mul_rpow
    (p := (1 : ℝ)) (q := p - 1) (b := K⁻¹) (by norm_num) (by linarith)
      (inv_pos.mpr hTail.2.1)
  have hIntEval :
      (∫ t in Set.Ioi 0,
        t ^ (p - 1) * Real.exp (-(K⁻¹) * t)) =
        (K⁻¹) ^ (-p) * Real.Gamma p := by
    have hfun :
        (fun t : ℝ => t ^ (p - 1) * Real.exp (-(K⁻¹) * t)) =
          (fun t : ℝ => t ^ (p - 1) * Real.exp (-(K⁻¹) * t ^ (1 : ℝ))) := by
      funext t
      rw [Real.rpow_one]
    rw [hfun]
    have hGamma' := hGamma
    rw [show p - 1 + 1 = p by ring] at hGamma'
    simp only [div_one, mul_one] at hGamma'
    convert hGamma' using 1
  have hGammaBound : Real.Gamma p ≤ 4 * p ^ p :=
    NumStability.HDP.Scalar.SubGaussian.gammaUpperBound (by linarith)
  have hupperEval :
      (∫⁻ t in Set.Ioi 0,
        ENNReal.ofReal (2 * Real.exp (-t / K)) *
          ENNReal.ofReal (t ^ (p - 1))) ≤
        ENNReal.ofReal (2 * (K⁻¹) ^ (-p) * Real.Gamma p) := by
    rw [MeasureTheory.setLIntegral_congr_fun measurableSet_Ioi
      (fun t _ => hscale t)]
    rw [← hEq2, MeasureTheory.integral_const_mul, hIntEval]
    simp [mul_assoc]
  have hcalc :
      ENNReal.ofReal p * ENNReal.ofReal
          (2 * (K⁻¹) ^ (-p) * Real.Gamma p) ≤
        ENNReal.ofReal ((8 * Real.exp 1 * K * p) ^ p) := by
    rw [← ENNReal.ofReal_mul (by positivity : 0 ≤ p)]
    apply ENNReal.ofReal_le_ofReal
    have hKpow : (K⁻¹) ^ (-p) = K ^ p := by
      rw [Real.rpow_neg (inv_nonneg.mpr hTail.2.1.le)]
      rw [Real.inv_rpow hTail.2.1.le]
      simp
    rw [hKpow]
    have hgam : 0 ≤ Real.Gamma p := (Real.Gamma_pos_of_pos hp0).le
    have hKpow_nonneg : 0 ≤ K ^ p := Real.rpow_nonneg hTail.2.1.le _
    have hstep : 2 * p * (K ^ p * Real.Gamma p) ≤
        (8 * Real.exp 1 * K * p) ^ p := by
      calc
        2 * p * (K ^ p * Real.Gamma p) ≤
            8 * p * K ^ p * p ^ p := by
              have hcoef : 0 ≤ 2 * p * K ^ p :=
                mul_nonneg (mul_nonneg (by positivity) (by positivity)) hKpow_nonneg
              calc
                2 * p * (K ^ p * Real.Gamma p) =
                    (2 * p * K ^ p) * Real.Gamma p := by ring
                _ ≤ (2 * p * K ^ p) * (4 * p ^ p) :=
                  mul_le_mul_of_nonneg_left hGammaBound hcoef
                _ = 8 * p * K ^ p * p ^ p := by ring
        _ ≤ 8 * Real.exp p * K ^ p * p ^ p := by
              have hpExp : p ≤ Real.exp p := by
                nlinarith [Real.add_one_le_exp p]
              have hcoef : 0 ≤ 8 * K ^ p * p ^ p := by
                positivity
              calc
                8 * p * K ^ p * p ^ p =
                    (8 * K ^ p * p ^ p) * p := by ring
                _ ≤ (8 * K ^ p * p ^ p) * Real.exp p :=
                  mul_le_mul_of_nonneg_left hpExp hcoef
                _ = 8 * Real.exp p * K ^ p * p ^ p := by ring
        _ ≤ (8 * Real.exp 1 * K * p) ^ p := by
              have h8 : (8 : ℝ) ≤ 8 ^ p := by
                have h := Real.rpow_le_rpow_of_exponent_le
                  (x := (8 : ℝ)) (y := (1 : ℝ)) (z := p) (by norm_num) hp
                simpa using h
              have hexprpow : Real.exp p = (Real.exp 1) ^ p := by
                rw [Real.rpow_def_of_pos (Real.exp_pos 1), Real.log_exp]
                congr 1
                ring
              rw [hexprpow]
              calc
                8 * (Real.exp 1) ^ p * K ^ p * p ^ p ≤
                    8 ^ p * (Real.exp 1) ^ p * K ^ p * p ^ p := by
                      have hpos : 0 ≤ (Real.exp 1) ^ p * K ^ p * p ^ p := by
                        exact mul_nonneg (mul_nonneg (by positivity) hKpow_nonneg)
                          (by positivity)
                      convert mul_le_mul_of_nonneg_right h8 hpos using 1 <;> ring
                _ = (8 * Real.exp 1 * K * p) ^ p := by
                      symm
                      rw [Real.mul_rpow
                        (mul_nonneg (mul_nonneg (by positivity) (Real.exp_pos 1).le)
                          hTail.2.1.le) hp0.le]
                      rw [Real.mul_rpow (mul_nonneg (by positivity) (Real.exp_pos 1).le)
                        hTail.2.1.le]
                      rw [Real.mul_rpow (by norm_num) (Real.exp_pos 1).le]
    simpa [mul_assoc, mul_left_comm, mul_comm] using hstep
  have hmoment : NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p ≤
      ENNReal.ofReal ((8 * Real.exp 1 * K * p) ^ p) := by
    calc
      NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p =
          ENNReal.ofReal p *
            (∫⁻ t in Set.Ioi 0,
              μ {ω | t < |X ω|} * ENNReal.ofReal (t ^ (p - 1))) := hformula.1
      _ ≤ ENNReal.ofReal p *
          (∫⁻ t in Set.Ioi 0,
            ENNReal.ofReal (2 * Real.exp (-t / K)) *
              ENNReal.ofReal (t ^ (p - 1))) := mul_le_mul_right hupper _
      _ ≤ ENNReal.ofReal p * ENNReal.ofReal
          (2 * (K⁻¹) ^ (-p) * Real.Gamma p) :=
            mul_le_mul_right hupperEval _
      _ ≤ ENNReal.ofReal ((8 * Real.exp 1 * K * p) ^ p) := hcalc
  have hfinite :
      NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p < (⊤ : ENNReal) :=
    lt_of_le_of_lt hmoment (by simp)
  have hmeasX : AEMeasurable X μ := hTail.1.aemeasurable
  have hmeas : AEMeasurable (fun ω => |X ω| ^ p) μ := by
    fun_prop
  have hInt : Integrable (fun ω => |X ω| ^ p) μ := by
    refine ⟨hmeas.aestronglyMeasurable, ?_⟩
    rw [hasFiniteIntegral_iff_norm]
    change (∫⁻ ω, ENNReal.ofReal ‖|X ω| ^ p‖ ∂μ) < (⊤ : ENNReal)
    convert hfinite using 1
    apply MeasureTheory.lintegral_congr_ae
    filter_upwards [] with ω
    rw [Real.norm_eq_abs, abs_of_nonneg (Real.rpow_nonneg (abs_nonneg _) _)]
    change ENNReal.ofReal (|X ω|.rpow p) = ENNReal.ofReal (|X ω|.rpow p)
    rfl
  refine ⟨hInt, ?_⟩
  have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
    (Filter.Eventually.of_forall (fun ω => by positivity))
  have hbound : ENNReal.ofReal (∫ ω, |X ω| ^ p ∂μ) ≤
      ENNReal.ofReal ((8 * Real.exp 1 * K * p) ^ p) := by
    calc
      ENNReal.ofReal (∫ ω, |X ω| ^ p ∂μ) =
          NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p := by
            simpa [NumStability.HDP.Scalar.Preliminaries.absoluteMoment,
              Real.norm_eq_abs] using hEq
      _ ≤ _ := hmoment
  have hBase : 0 ≤ 8 * Real.exp 1 * K * p := by
    exact mul_nonneg (mul_nonneg (mul_nonneg (by positivity) (Real.exp_pos 1).le)
      hTail.2.1.le) hp0.le
  have hRhs : 0 ≤ (8 * Real.exp 1 * K * p) ^ p :=
    Real.rpow_nonneg hBase _
  exact (ENNReal.ofReal_le_ofReal_iff hRhs).mp hbound

private theorem subExponentialMomentToAbsoluteMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hMom : SubExponentialMomentBound μ X K) :
    SubExponentialAbsoluteMGFLocal μ X (4 * Real.exp 1 * K) := by
  refine ⟨hMom.1, mul_pos (mul_pos (by norm_num) (Real.exp_pos 1)) hMom.2.1, ?_⟩
  intro lam hlam hLamK
  have hsmall : |lam| * K ≤ (4 * Real.exp 1)⁻¹ := by
    rw [abs_of_nonneg hlam]
    calc
      lam * K ≤ (4 * Real.exp 1 * K)⁻¹ * K := by
        exact mul_le_mul_of_nonneg_right hLamK hMom.2.1.le
      _ = (4 * Real.exp 1)⁻¹ := by field_simp [ne_of_gt hMom.2.1]
  have h := exp_abs_integrable hMom.2.2 hMom.2.1 hsmall
  refine ⟨?_, ?_⟩
  · simpa [abs_of_nonneg hlam] using h.1
  · calc
      (∫ ω, Real.exp (lam * |X ω|) ∂μ) =
          ∫ ω, Real.exp (|lam| * |X ω|) ∂μ := by
            congr 1
            funext ω
            rw [abs_of_nonneg hlam]
      _ ≤ Real.exp (2 * Real.exp 1 * (|lam| * K)) := h.2
      _ ≤ Real.exp (4 * Real.exp 1 * K * lam) := by
        apply Real.exp_le_exp.mpr
        rw [abs_of_nonneg hlam]
        nlinarith [mul_nonneg (Real.exp_pos 1).le
          (mul_nonneg hlam hMom.2.1.le)]

private theorem subExponentialAbsoluteMGFToOnePoint
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hLocal : SubExponentialAbsoluteMGFLocal μ X K) :
    SubExponentialOnePointMGF μ X (2 * K) := by
  have hK : 0 < 2 * K := mul_pos (by norm_num) hLocal.2.1
  have hparam0 : 0 ≤ (2 * K)⁻¹ := (inv_nonneg.mpr hK.le)
  have hparam : (2 * K)⁻¹ ≤ K⁻¹ := by
    have h := one_div_le_one_div_of_le hLocal.2.1 (by nlinarith : K ≤ 2 * K)
    simpa [one_div] using h
  have h := hLocal.2.2 ((2 * K)⁻¹) hparam0 hparam
  refine ⟨hLocal.1, hK, ?_, ?_⟩
  · convert h.1 using 1
    funext ω
    congr 1
    field_simp
  · have hhalf : K * (2 * K)⁻¹ = (1 / 2 : ℝ) := by
      field_simp [ne_of_gt hLocal.2.1]
    calc
      (∫ ω, Real.exp (|X ω| / (2 * K)) ∂μ) =
          ∫ ω, Real.exp ((2 * K)⁻¹ * |X ω|) ∂μ := by
            congr 1
            funext ω
            congr 1
            field_simp
      _ ≤ Real.exp (K * (2 * K)⁻¹) := h.2
      _ = Real.exp (1 / 2) := by rw [hhalf]
      _ ≤ 2 := by
        exact le_trans (Real.exp_bound_div_one_sub_of_interval (by norm_num) (by norm_num))
          (by norm_num)

private theorem subExponentialOnePointToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hPoint : SubExponentialOnePointMGF μ X K) :
    SubExponentialTailBound μ X K := by
  refine ⟨hPoint.1, hPoint.2.1, ?_⟩
  intro t ht
  let Y : Ω → ℝ := fun ω => Real.exp (|X ω| / K)
  have hY : Measurable Y := by
    simpa [Y] using (hPoint.1.norm.div_const K).exp
  have hmarkov := NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
    (μ := μ) hY (Filter.Eventually.of_forall (fun ω => by
      exact le_of_lt (Real.exp_pos _))) hPoint.2.2.1 (Real.exp_pos (t / K))
  have hsubset : {ω | |X ω| ≥ t} ⊆
      Y ⁻¹' Set.Ici (Real.exp (t / K)) := by
    intro ω hω
    change Real.exp (t / K) ≤ Real.exp (|X ω| / K)
    apply Real.exp_le_exp.mpr
    exact div_le_div_of_nonneg_right hω hPoint.2.1.le
  have hmono {A B : Set Ω} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  calc
    μ.real {ω | |X ω| ≥ t} ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (t / K))) :=
      hmono hsubset
    _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (t / K) := by
      simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
    _ ≤ 2 / Real.exp (t / K) := by
      exact div_le_div_of_nonneg_right hPoint.2.2.2
        (le_of_lt (Real.exp_pos _))
    _ = 2 * Real.exp (-t / K) := by
      rw [div_eq_mul_inv, ← Real.exp_neg]
      ring

private theorem subExponentialToTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubExponentialPropertyKind) {K : ℝ} (hK : 0 < K)
    (hProp : SubExponentialProperty μ X i K) :
    ∃ T : ℝ, 0 < T ∧ T ≤ 8 * Real.exp 1 * K ∧
      SubExponentialTailBound μ X T := by
  cases i with
  | tail =>
      refine ⟨K, hK, ?_, hProp⟩
      have hscale : (1 : ℝ) ≤ 8 * Real.exp 1 := by
        have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        nlinarith
      simpa using (mul_le_mul_of_nonneg_right hscale hK.le)
  | moment =>
      have hLocal := subExponentialMomentToAbsoluteMGF hProp
      have hPoint := subExponentialAbsoluteMGFToOnePoint hLocal
      have hTail := subExponentialOnePointToTail hPoint
      refine ⟨8 * Real.exp 1 * K, by positivity, le_rfl, ?_⟩
      convert hTail using 1; ring
  | absoluteMGF =>
      have hPoint := subExponentialAbsoluteMGFToOnePoint hProp
      have hTail := subExponentialOnePointToTail hPoint
      refine ⟨2 * K, by positivity, ?_, ?_⟩
      · have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        have hscale : (2 : ℝ) ≤ 8 * Real.exp 1 := by nlinarith
        exact mul_le_mul_of_nonneg_right hscale hK.le
      · convert hTail using 1
  | onePoint =>
      have hTail := subExponentialOnePointToTail hProp
      refine ⟨K, hK, ?_, hTail⟩
      have hscale : (1 : ℝ) ≤ 8 * Real.exp 1 := by
        have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        nlinarith
      simpa using (mul_le_mul_of_nonneg_right hscale hK.le)

private theorem subExponentialFromTail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i : SubExponentialPropertyKind) {T : ℝ} (hT : 0 < T)
    (hTail : SubExponentialTailBound μ X T) :
    ∃ K : ℝ, 0 < K ∧ K ≤ 64 * (Real.exp 1) ^ 2 * T ∧
      SubExponentialProperty μ X i K := by
  cases i with
  | tail =>
      refine ⟨T, hT, ?_, hTail⟩
      have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
      have he2 : (1 : ℝ) ≤ (Real.exp 1) ^ 2 := by
        nlinarith [mul_nonneg (sub_nonneg.mpr he) (Real.exp_pos 1).le]
      have hscale : (1 : ℝ) ≤ 64 * (Real.exp 1) ^ 2 := by nlinarith
      simpa using (mul_le_mul_of_nonneg_right hscale hT.le)
  | moment =>
      let K := 8 * Real.exp 1 * T
      have hMom := subExponentialTailToMoment hTail
      refine ⟨K, by dsimp [K]; positivity, ?_, ?_⟩
      · have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        dsimp [K]
        have he2 : (1 : ℝ) ≤ (Real.exp 1) ^ 2 := by
          nlinarith [mul_nonneg (sub_nonneg.mpr he) (Real.exp_pos 1).le]
        have hscale : 8 * Real.exp 1 ≤ 64 * (Real.exp 1) ^ 2 := by
          nlinarith
        exact mul_le_mul_of_nonneg_right hscale hT.le
      · simpa [SubExponentialProperty, K] using hMom
  | absoluteMGF =>
      let K := 32 * (Real.exp 1) ^ 2 * T
      have hMom := subExponentialTailToMoment hTail
      have hLocal := subExponentialMomentToAbsoluteMGF hMom
      refine ⟨K, by dsimp [K]; positivity, ?_, ?_⟩
      · dsimp [K]
        have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        exact mul_le_mul_of_nonneg_right (by nlinarith [he]) hT.le
      · change SubExponentialAbsoluteMGFLocal μ X K
        convert hLocal using 1
        all_goals dsimp [K]
        all_goals ring
  | onePoint =>
      let K := 64 * (Real.exp 1) ^ 2 * T
      have hMom := subExponentialTailToMoment hTail
      have hLocal := subExponentialMomentToAbsoluteMGF hMom
      have hPoint := subExponentialAbsoluteMGFToOnePoint hLocal
      refine ⟨K, by dsimp [K]; positivity, le_rfl, ?_⟩
      change SubExponentialOnePointMGF μ X K
      convert hPoint using 1
      all_goals dsimp [K]
      all_goals ring

/-! Reusable four-way characterization for Exercise 2.7.2. -/
theorem subExponentialCharacterization
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : SubExponentialPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
        SubExponentialProperty μ X i Ki →
          ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
            SubExponentialProperty μ X j Kj := by
  let C : ℝ := 4096 * (Real.exp 1) ^ 3
  have he : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
  have he3 : (1 : ℝ) ≤ (Real.exp 1) ^ 3 := by
    have he2 : (1 : ℝ) ≤ (Real.exp 1) ^ 2 := by
      nlinarith [mul_nonneg (sub_nonneg.mpr he) (Real.exp_pos 1).le]
    have hsq : 0 ≤ (Real.exp 1) ^ 2 := by positivity
    nlinarith [mul_le_mul_of_nonneg_left he hsq]
  refine ⟨C, by dsimp [C]; nlinarith [he3], ?_⟩
  intro i j Ki hKi hProp
  rcases subExponentialToTail i hKi hProp with ⟨T, hT, hTbound, hTail⟩
  rcases subExponentialFromTail j hT hTail with ⟨Kj, hKj, hKjbound, hResult⟩
  refine ⟨Kj, hKj, ?_, hResult⟩
  dsimp [C]
  have hmul := mul_le_mul_of_nonneg_left hTbound
    (by positivity : 0 ≤ 64 * (Real.exp 1) ^ 2)
  calc
    Kj ≤ 64 * (Real.exp 1) ^ 2 * T := hKjbound
    _ ≤ 64 * (Real.exp 1) ^ 2 * (8 * Real.exp 1 * Ki) := hmul
    _ ≤ 4096 * (Real.exp 1) ^ 3 * Ki := by
      have he3nonneg : 0 ≤ (Real.exp 1) ^ 3 := by positivity
      have hcoeff : 512 * (Real.exp 1) ^ 3 ≤ 4096 * (Real.exp 1) ^ 3 := by
        nlinarith
      have hKi0 : 0 ≤ Ki := hKi.le
      calc
        64 * (Real.exp 1) ^ 2 * (8 * Real.exp 1 * Ki) =
            512 * (Real.exp 1) ^ 3 * Ki := by ring
        _ ≤ 4096 * (Real.exp 1) ^ 3 * Ki :=
          mul_le_mul_of_nonneg_right hcoeff hKi0

/-! Exercise 2.7.3: the fixed-`α` power-coordinate interface.

For `α > 0`, the natural common interface is obtained by applying the
sub-exponential characterization to `|X|^α`.  In the tail coordinate this is
the printed bound `2 exp (-(t/K)^α)` after the change of variable
`t ↦ t^α`; in the moment coordinate it records the growth of the moments of
`|X|^α`, hence the usual `p^(1/α)` growth after reparameterizing the moment
order.  This representation deliberately does not assert a linear MGF norm
when `α ≤ 1`.
-/

/-- The presentation index reused for fixed-power sub-Weibull properties. -/
abbrev SubWeibullPropertyKind := SubExponentialPropertyKind

/-- A sub-exponential property of the transformed variable `|X| ^ α`. -/
def SubWeibullProperty {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (α : ℝ) :
    SubWeibullPropertyKind → ℝ → Prop
  | i, K => 0 < α ∧
      SubExponentialProperty μ (fun ω => |X ω| ^ α) i K

theorem subWeibullMomentInterpretation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {α K : ℝ}
    (hα : 0 < α) (h : SubWeibullProperty μ X α .moment K) :
    ∀ p : ℝ, 1 ≤ p →
      Integrable (fun ω => |X ω| ^ (α * p)) μ ∧
        (∫ ω, |X ω| ^ (α * p) ∂μ) ≤ (K * p) ^ p := by
  rcases h with ⟨_, hMoment⟩
  rcases hMoment with ⟨hMeas, hK, hGrowth⟩
  intro p hp
  rcases hGrowth.2 p hp with ⟨hInt, hBound⟩
  constructor
  · convert hInt using 1
    funext ω
    dsimp
    rw [abs_of_nonneg (Real.rpow_nonneg (abs_nonneg (X ω)) α)]
    rw [← Real.rpow_mul (abs_nonneg (X ω))]
  · convert hBound using 1
    apply integral_congr_ae
    filter_upwards [] with ω
    rw [abs_of_nonneg (Real.rpow_nonneg (abs_nonneg (X ω)) α)]
    rw [← Real.rpow_mul (abs_nonneg (X ω))]

theorem subWeibullCharacterization
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {α : ℝ} (hα : 0 < α) :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : SubWeibullPropertyKind, ∀ {Ki : ℝ}, 0 < Ki →
        SubWeibullProperty μ X α i Ki →
          ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
            SubWeibullProperty μ X α j Kj := by
  let Y : Ω → ℝ := fun ω => |X ω| ^ α
  obtain ⟨C, hC, hCharacterization⟩ :=
    (subExponentialCharacterization (μ := μ) (X := Y))
  refine ⟨C, hC, ?_⟩
  intro i j Ki hKi hProp
  rcases hProp with ⟨_hα', hSub⟩
  rcases hCharacterization i j hKi hSub with ⟨Kj, hKj, hKjbound, hResult⟩
  exact ⟨Kj, hKj, hKjbound, ⟨hα, by simpa [Y] using hResult⟩⟩

/-! Remark 2.7.9: a bounded centered unit-variance witness and the domain of the
rate-one exponential MGF.  The symmetric two-point law makes the local Taylor
calculation exact, while the exponential-law calculation is kept in extended
measure form through its density. -/

/-- The symmetric two-point law used in Remark 2.7.9. -/
def remark279Law : Measure ℝ :=
  (1 / 2 : ENNReal) • Measure.dirac (-1) +
    (1 / 2 : ENNReal) • Measure.dirac 1

lemma remark279Law_probability : IsProbabilityMeasure remark279Law := by
  apply isProbabilityMeasure_iff.mpr
  simp [remark279Law]
  calc
    (2 : ENNReal)⁻¹ + 2⁻¹ = (2 : ENNReal)⁻¹ + (2 : ENNReal)⁻¹ * 1 := by
      ring
    _ = (2 : ENNReal)⁻¹ * (1 + 1) := by ring
    _ = (2 : ENNReal)⁻¹ * 2 := by norm_num
    _ = 1 := by exact ENNReal.inv_mul_cancel (by norm_num) (by norm_num)

lemma remark279Law_integral (f : ℝ → ℝ) :
    ∫ x, f x ∂remark279Law =
      (1 / 2 : ℝ) * f (-1) + (1 / 2 : ℝ) * f 1 := by
  rw [remark279Law, MeasureTheory.integral_add_measure]
  · rw [MeasureTheory.integral_smul_measure, MeasureTheory.integral_smul_measure,
      MeasureTheory.integral_dirac, MeasureTheory.integral_dirac]
    norm_num
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp
  · apply Integrable.smul_measure
    · exact integrable_dirac (by simp)
    · simp

lemma remark279_mean :
    (∫ x, x ∂remark279Law) = 0 := by
  rw [remark279Law_integral]
  norm_num

lemma remark279_second_moment :
    (∫ x, x ^ 2 ∂remark279Law) = 1 := by
  rw [remark279Law_integral]
  norm_num

set_option maxRecDepth 10000 in
lemma cosh_local_taylor :
    (fun x : ℝ => Real.cosh x - 1 - x ^ 2 / 2) =o[𝓝 (0 : ℝ)]
      (fun x : ℝ => x ^ 2) := by
  have hc0 : iteratedDeriv 0 Real.cosh 0 = 1 := by
    simp [iteratedDeriv]
  have hc1 : iteratedDeriv 1 Real.cosh 0 = 0 := by
    rw [iteratedDeriv_one, Real.deriv_cosh]
    simp
  have hc2 : iteratedDeriv 2 Real.cosh 0 = 1 := by
    rw [show (2 : ℕ) = 1 + 1 by norm_num, iteratedDeriv_succ,
      iteratedDeriv_one, Real.deriv_cosh, Real.deriv_sinh]
    simp
  have h := Real.taylor_tendsto (f := Real.cosh) (n := 2) (s := Set.univ)
    convex_univ (mem_univ (0 : ℝ)) Real.contDiff_cosh.contDiffOn
  rw [Asymptotics.isLittleO_iff_tendsto]
  · convert h using 1
    · funext x
      simp [taylorWithinEval, taylorWithin, taylorCoeffWithin,
        Finset.sum_range_succ, hc0, hc1, hc2,
        div_eq_mul_inv, mul_comm]
      all_goals ring_nf
      all_goals simp
    · rw [nhdsWithin_univ]
  · simp

lemma remark279_local_taylor :
    (fun lam : ℝ =>
      (∫ x, Real.exp (lam * x) ∂remark279Law) - 1 -
        lam * (∫ x, x ∂remark279Law) -
        lam ^ 2 / 2 * (∫ x, x ^ 2 ∂remark279Law)) =o[𝓝 (0 : ℝ)]
      (fun lam : ℝ => lam ^ 2) := by
  have hcosh := cosh_local_taylor
  convert hcosh using 1
  funext lam
  rw [remark279Law_integral, remark279_mean, remark279_second_moment]
  rw [Real.cosh_eq]
  ring

private lemma remark279_exp_pdf_measurable :
    Measurable (ProbabilityTheory.exponentialPDF 1) := by
  unfold ProbabilityTheory.exponentialPDF
  exact (ProbabilityTheory.measurable_exponentialPDFReal 1).ennreal_ofReal

lemma remark279_exp_mgf_lt_one {lam : ℝ} (hl : lam < 1) :
    Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1) ∧
      (∫ x, Real.exp (lam * x) ∂(expMeasure 1)) = (1 - lam)⁻¹ := by
  have hpdf := remark279_exp_pdf_measurable
  have hIntBase : Integrable
      (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF 1 x).toReal) volume := by
    have heq : (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF 1 x).toReal) =
        (fun x : ℝ => if 0 ≤ x then Real.exp ((lam - 1) * x) else 0) := by
      funext x
      by_cases hx : 0 ≤ x
      · simp [ProbabilityTheory.exponentialPDF,
          ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
          hx]
        rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
        rw [← Real.exp_add]
        congr 1
        ring
      · simp [ProbabilityTheory.exponentialPDF,
          ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
          hx]
    rw [heq]
    let g : ℝ → ℝ := fun x => Real.exp ((lam - 1) * x)
    have hIoi : IntegrableOn g (Ioi (0 : ℝ)) volume :=
      integrableOn_exp_mul_Ioi (by linarith) 0
    have hIci : IntegrableOn g (Ici (0 : ℝ)) volume :=
      (integrableOn_Ici_iff_integrableOn_Ioi).2 hIoi
    have hInd : Integrable ((Ici (0 : ℝ)).indicator g) volume :=
      hIci.integrable_indicator measurableSet_Ici
    simpa [g, Set.indicator, mem_setOf_eq] using hInd
  have hInt : Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1) := by
    change Integrable (fun x : ℝ => Real.exp (lam * x))
      (volume.withDensity (ProbabilityTheory.exponentialPDF 1))
    rw [integrable_withDensity_iff hpdf
      (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
    simpa [smul_eq_mul] using hIntBase
  refine ⟨hInt, ?_⟩
  change (∫ x, Real.exp (lam * x) ∂volume.withDensity
      (ProbabilityTheory.exponentialPDF 1)) = (1 - lam)⁻¹
  rw [integral_withDensity_eq_integral_toReal_smul hpdf
      (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  simp_rw [smul_eq_mul]
  have heq2 : (fun x : ℝ => (ProbabilityTheory.exponentialPDF 1 x).toReal *
      Real.exp (lam * x)) =
      (Ici (0 : ℝ)).indicator (fun x : ℝ => Real.exp ((lam - 1) * x)) := by
    funext x
    by_cases hx : 0 ≤ x
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
        hx]
      rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
      rw [← Real.exp_add]
      congr 1
      ring
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
        hx]
  rw [heq2, integral_indicator measurableSet_Ici, integral_Ici_eq_integral_Ioi]
  rw [integral_exp_mul_Ioi (by linarith) 0]
  simp
  rw [show lam - 1 = -(1 - lam) by ring]
  have hne : 1 - lam ≠ 0 := by linarith
  field_simp [hne]

lemma remark279_exp_mgf_not_integrable {lam : ℝ} (hl : 1 ≤ lam) :
    ¬ Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1) := by
  intro h
  have hpdf := remark279_exp_pdf_measurable
  have hbase : Integrable
      (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF 1 x).toReal) volume := by
    change Integrable (fun x : ℝ => Real.exp (lam * x))
      (volume.withDensity (ProbabilityTheory.exponentialPDF 1)) at h
    exact (integrable_withDensity_iff hpdf
      (by filter_upwards [] with x; exact ENNReal.coe_lt_top)).1 h
  have hprod : IntegrableOn
      (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF 1 x).toReal) (Ioi (0 : ℝ)) volume :=
    hbase.integrableOn
  have hexp : IntegrableOn (fun x : ℝ => Real.exp ((lam - 1) * x))
      (Ioi (0 : ℝ)) volume := by
    apply hprod.congr_fun
    · intro x hx
      have hx0 : 0 ≤ x := le_of_lt hx
      simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
        hx0]
      rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
      rw [← Real.exp_add]
      congr 1
      ring
    · exact measurableSet_Ioi
  have hconst : IntegrableOn (fun _ : ℝ => (1 : ℝ)) (Ioi (0 : ℝ)) volume := by
    apply hexp.integrable.mono'
    · fun_prop
    · filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with x hx
      rw [Real.norm_eq_abs, abs_one]
      exact Real.one_le_exp (mul_nonneg (sub_nonneg.mpr hl) (le_of_lt hx))
  simp at hconst

theorem remark279_contract :
    NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9__contract_type := by
  refine ⟨remark279Law, (fun x : ℝ => x), remark279Law_probability, ?_⟩
  constructor
  · rfl
  constructor
  · rfl
  constructor
  · simpa using remark279_mean
  constructor
  · simpa using remark279_second_moment
  constructor
  · simpa using remark279_local_taylor
  constructor
  · intro lam
    exact remark279_exp_mgf_lt_one
  · intro lam
    exact remark279_exp_mgf_not_integrable

/-! ## Example 2.7.12: power Orlicz gauges are classical `Lᵖ` gauges -/

lemma powerOrliczIntegral_eq
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    (p : NNReal) (hp : 0 < p)
    (hψ : ∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ))
    {t : ℝ≥0∞} (ht0 : t ≠ 0) (htTop : t ≠ ∞) :
    orliczIntegral ψ μ X t =
      (eLpNorm X (p : ℝ≥0∞) μ / t) ^ (p : ℝ) := by
  have hpR : 0 < (p : ℝ) := by exact_mod_cast hp
  have hpR0 : 0 ≤ (p : ℝ) := hpR.le
  have htR : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hpE0 : (p : ℝ≥0∞) ≠ 0 := by exact_mod_cast hp.ne'
  have hpETop : (p : ℝ≥0∞) ≠ ∞ := by simp
  have hpoint : (fun ω => ENNReal.ofReal (ψ (|X ω| / t.toReal))) =
      (fun ω => ‖X ω‖ₑ ^ (p : ℝ) / t ^ (p : ℝ)) := by
    funext ω
    rw [hψ _ (div_nonneg (abs_nonneg _) htR.le)]
    rw [← ENNReal.ofReal_rpow_of_nonneg (div_nonneg (abs_nonneg _) htR.le) hpR0]
    rw [ENNReal.ofReal_div_of_pos htR]
    rw [← ofReal_norm_eq_enorm]
    simp only [Real.norm_eq_abs]
    rw [ENNReal.div_rpow_of_nonneg _ _ hpR0]
    rw [ENNReal.ofReal_toReal htTop]
  unfold orliczIntegral
  rw [hpoint]
  simp_rw [div_eq_mul_inv]
  let c : ℝ≥0∞ := (t ^ (p : ℝ))⁻¹
  have htp0 : t ^ (p : ℝ) ≠ 0 := by simp [ht0, hpR]
  have htpTop : t ^ (p : ℝ) ≠ ∞ :=
    ENNReal.rpow_ne_top_of_nonneg hpR0 htTop
  have hc0 : c ≠ 0 := by simp [c, htpTop]
  have hcTop : c ≠ ∞ := by simp [c, htp0]
  have hscale : (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) * c ∂μ) =
      (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ) * c := by
    apply le_antisymm
    · have h := lintegral_mul_const_le c⁻¹
        (fun a => ‖X a‖ₑ ^ (p : ℝ) * c) (μ := μ)
      have h' :
          (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) * c ∂μ) * c⁻¹ ≤
            ∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ := by
        simpa [mul_assoc, ENNReal.mul_inv_cancel hc0 hcTop] using h
      have h'' := (ENNReal.mul_le_mul_iff_left hc0 hcTop).2 h'
      simpa [mul_assoc, ENNReal.inv_mul_cancel hc0 hcTop] using h''
    · exact lintegral_mul_const_le c _
  rw [hscale]
  simp only [c]
  rw [mul_comm (eLpNorm X (p : ℝ≥0∞) μ) t⁻¹]
  rw [← ENNReal.div_eq_inv_mul]
  rw [ENNReal.div_rpow_of_nonneg _ _ hpR0]
  have hLp := eLpNorm_eq_lintegral_rpow_enorm_toReal hpE0 hpETop (f := X) (μ := μ)
  have hLp' : eLpNorm X (p : ℝ≥0∞) μ =
      (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ) ^ (p : ℝ)⁻¹ := by
    simpa [one_div] using hLp
  have hLpPow := congrArg (fun z : ℝ≥0∞ => z ^ (p : ℝ)) hLp'
  have hMoment : (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ) =
      eLpNorm X (p : ℝ≥0∞) μ ^ (p : ℝ) := by
    change eLpNorm X (p : ℝ≥0∞) μ ^ (p : ℝ) =
      ((∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ) ^ (p : ℝ)⁻¹) ^ (p : ℝ) at hLpPow
    rw [ENNReal.rpow_inv_rpow hpR.ne'
      (∫⁻ a, ‖X a‖ₑ ^ (p : ℝ) ∂μ)] at hLpPow
    exact hLpPow.symm
  rw [hMoment]
  rfl

theorem powerOrliczGauge_eq_eLpNorm
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    (p : NNReal) (hp : 0 < p)
    (hψ : ∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ)) :
    orliczGauge ψ μ X = eLpNorm X (p : ℝ≥0∞) μ := by
  have hpR : 0 < (p : ℝ) := by exact_mod_cast hp
  let L : ℝ≥0∞ := eLpNorm X (p : ℝ≥0∞) μ
  have hlower : ∀ {t : ℝ≥0∞},
      orliczAdmissible ψ μ X t → L ≤ t := by
    intro t ht
    rcases ht with ⟨ht0, htTop, hInt⟩
    have hpow : (L / t) ^ (p : ℝ) ≤ 1 := by
      rw [← powerOrliczIntegral_eq ψ μ X p hp hψ ht0 htTop]
      exact hInt
    have hpow' : (L / t) ^ (p : ℝ) ≤ (1 : ℝ≥0∞) ^ (p : ℝ) := by
      simpa using hpow
    have hratio : L / t ≤ 1 := (ENNReal.rpow_le_rpow_iff hpR).mp hpow'
    have hLt : L ≤ 1 * t := (ENNReal.div_le_iff ht0 htTop).mp hratio
    simpa using hLt
  have hupper : eLpNorm X (p : ℝ≥0∞) μ ≤ orliczGauge ψ μ X := by
    apply le_sInf
    intro t ht
    exact hlower ht
  have hLupper : orliczGauge ψ μ X ≤ L := by
    unfold orliczGauge
    by_cases hLtop : L = ∞
    · simp [hLtop]
    by_cases hL0 : L = 0
    · rw [hL0]
      apply le_of_forall_gt_imp_ge_of_dense
      intro t ht
      by_cases htTop : t = ∞
      · simp [htTop]
      have ht0 : t ≠ 0 := ne_of_gt ht
      apply sInf_le
      refine ⟨ht0, htTop, ?_⟩
      rw [powerOrliczIntegral_eq ψ μ X p hp hψ ht0 htTop]
      have hLzero : eLpNorm X (p : ℝ≥0∞) μ = 0 := by simpa [L] using hL0
      simp [hLzero, hpR]
    · have hL0' : L ≠ 0 := hL0
      have hL0'' : eLpNorm X (p : ℝ≥0∞) μ ≠ 0 := by simpa [L] using hL0'
      have hLtop' : eLpNorm X (p : ℝ≥0∞) μ ≠ ∞ := by simpa [L] using hLtop
      have hLmem : orliczAdmissible ψ μ X L := by
        refine ⟨hL0', hLtop, ?_⟩
        rw [powerOrliczIntegral_eq ψ μ X p hp hψ hL0' hLtop]
        rw [ENNReal.div_self hL0'' hLtop']
        simp
      exact sInf_le hLmem
  exact le_antisymm hLupper hupper

theorem powerOrliczMember_iff_memLp
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    (p : NNReal) (hp : 0 < p)
    (hψ : ∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ))
    (hX : AEStronglyMeasurable X μ) :
    orliczMember ψ μ X ↔ MemLp X (p : ℝ≥0∞) μ := by
  rw [orliczMember, powerOrliczGauge_eq_eLpNorm ψ μ X p hp hψ]
  simp [MemLp, hX]

theorem powerOrliczCoincidence :
    ∀ {Ω : Type*} [MeasurableSpace Ω]
      (ψ : OrliczFunction) (μ : Measure Ω) (p : NNReal),
      0 < p →
      (∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ)) →
      (∀ X : Ω → ℝ, orliczGauge ψ μ X = eLpNorm X (p : ℝ≥0∞) μ) ∧
      (∀ X : Ω → ℝ, AEStronglyMeasurable X μ →
        (orliczMember ψ μ X ↔ MemLp X (p : ℝ≥0∞) μ)) := by
  intro Ω _ ψ μ p hp hψ
  constructor
  · intro X
    exact powerOrliczGauge_eq_eLpNorm ψ μ X p hp hψ
  · intro X hX
    exact powerOrliczMember_iff_memLp ψ μ X p hp hψ hX

/-! Example 2.7.13: the Luxemburg gauge for `exp (x²) - 1` is the
source ψ₂ gauge.  The two admissibility predicates differ only by the
probability-measure contribution of the subtracted constant `1`. -/

/-- The Orlicz function `exp (x²) - 1` underlying the ψ₂ gauge. -/
noncomputable def psiTwoOrliczFunction : OrliczFunction :=
  { toFun := fun x => Real.exp (x ^ 2) - 1
    nonnegative := by
      intro x hx
      have hsq : 0 ≤ x ^ 2 := sq_nonneg x
      linarith [Real.one_le_exp hsq]
    convexOn_nonneg := by
      refine ⟨convex_Ici (0 : ℝ), ?_⟩
      intro x hx y hy a b ha hb hab
      change 0 ≤ x at hx
      change 0 ≤ y at hy
      change Real.exp ((a * x + b * y) ^ 2) - 1 ≤
        a * (Real.exp (x ^ 2) - 1) + b * (Real.exp (y ^ 2) - 1)
      have hsq : (a * x + b * y) ^ 2 ≤ a * x ^ 2 + b * y ^ 2 := by
        nlinarith [sq_nonneg (x - y),
          mul_nonneg (mul_nonneg ha hb) (sq_nonneg (x - y))]
      have hexp := convexOn_exp.2 (show x ^ 2 ∈ Set.univ by trivial)
        (show y ^ 2 ∈ Set.univ by trivial) ha hb hab
      calc
        Real.exp ((a * x + b * y) ^ 2) - 1 ≤
            Real.exp (a * x ^ 2 + b * y ^ 2) - 1 := by
          gcongr
        _ ≤ a * Real.exp (x ^ 2) + b * Real.exp (y ^ 2) - 1 := by
          simpa [smul_eq_mul] using sub_le_sub_right hexp 1
        _ = a * (Real.exp (x ^ 2) - 1) +
            b * (Real.exp (y ^ 2) - 1) := by
          calc
            a * Real.exp (x ^ 2) + b * Real.exp (y ^ 2) - 1 =
                a * Real.exp (x ^ 2) + b * Real.exp (y ^ 2) - (a + b) := by
                  rw [hab]
            _ = a * (Real.exp (x ^ 2) - 1) +
                b * (Real.exp (y ^ 2) - 1) := by ring
    monotoneOn_nonneg := by
      intro x hx y hy hxy
      change 0 ≤ x at hx
      change 0 ≤ y at hy
      dsimp
      apply sub_le_sub_right
      apply Real.exp_le_exp.mpr
      nlinarith [sq_nonneg (y - x)]
    map_zero := by norm_num
    tendsto_atTop := by
      refine tendsto_atTop.mpr ?_
      intro r
      filter_upwards
        [eventually_ge_atTop (max 0 (Real.sqrt (max (r + 1) 0)))] with x hx
      have hx0 : 0 ≤ x := le_trans (le_max_left 0
        (Real.sqrt (max (r + 1) 0))) hx
      have hxroot : Real.sqrt (max (r + 1) 0) ≤ x := le_trans
        (le_max_right 0 (Real.sqrt (max (r + 1) 0))) hx
      have hsqrt0 : 0 ≤ Real.sqrt (max (r + 1) 0) :=
        Real.sqrt_nonneg _
      have hsqrt : (Real.sqrt (max (r + 1) 0)) ^ 2 = max (r + 1) 0 :=
        Real.sq_sqrt (by positivity)
      have hmax : r + 1 ≤ max (r + 1) 0 := le_max_left _ _
      have hsq : r + 1 ≤ x ^ 2 := by
        have hprod : 0 ≤ (x - Real.sqrt (max (r + 1) 0)) *
            (x + Real.sqrt (max (r + 1) 0)) :=
          mul_nonneg (sub_nonneg.mpr hxroot) (add_nonneg hx0 hsqrt0)
        nlinarith [hprod, hsqrt, hmax]
      have hexp : Real.exp (r + 1) ≤ Real.exp (x ^ 2) :=
        Real.exp_le_exp.mpr hsq
      have hlin : r + 1 ≤ Real.exp (r + 1) := by
        nlinarith [Real.add_one_le_exp (r + 1)]
      nlinarith }

lemma psiTwoOrliczFunction_integral_add_one
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {t : ℝ≥0∞}
    (ht0 : t ≠ 0) (htTop : t ≠ ∞) (hX : Measurable X) :
    orliczIntegral psiTwoOrliczFunction μ X t + 1 =
      ∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ := by
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  let f : Ω → ℝ := fun ω => Real.exp (X ω ^ 2 / t.toReal ^ 2)
  let g : Ω → ℝ≥0∞ := fun ω => ENNReal.ofReal (f ω - 1)
  have hmeasg : Measurable g := by
    dsimp [g, f]
    fun_prop
  have hnonneg : ∀ ω, 0 ≤ f ω - 1 := by
    intro ω
    dsimp [f]
    have hsq : 0 ≤ X ω ^ 2 / t.toReal ^ 2 := by positivity
    linarith [Real.one_le_exp hsq]
  have hpoint : ∀ ω, ENNReal.ofReal (f ω) = g ω + 1 := by
    intro ω
    dsimp [g]
    calc
      ENNReal.ofReal (f ω) = ENNReal.ofReal ((f ω - 1) + 1) := by
        congr 1
        ring
      _ = ENNReal.ofReal (f ω - 1) + ENNReal.ofReal 1 :=
        ENNReal.ofReal_add (hnonneg ω) (by norm_num)
      _ = ENNReal.ofReal (f ω - 1) + 1 := by norm_num
  calc
    orliczIntegral psiTwoOrliczFunction μ X t + 1 =
        (∫⁻ ω, g ω ∂μ) + 1 := by
          congr 1
          simp only [orliczIntegral, psiTwoOrliczFunction, g, f]
          congr 1
          funext ω
          congr 2
          rw [div_pow, sq_abs]
    _ = ∫⁻ ω, (g ω + 1) ∂μ := by
          symm
          rw [lintegral_add_left hmeasg]
          simp
    _ = ∫⁻ ω, ENNReal.ofReal (f ω) ∂μ := by
          apply lintegral_congr
          intro ω
          exact (hpoint ω).symm

theorem psiTwoOrliczGauge_eq_psiTwoGauge
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    orliczGauge psiTwoOrliczFunction μ X =
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X := by
  unfold orliczGauge NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
  apply congrArg sInf
  ext t
  constructor
  · intro ht
    rcases ht with ⟨ht0, htTop, hbound⟩
    have hbound' :
        ∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ ≤ 2 := by
      calc
        (∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ) =
            orliczIntegral psiTwoOrliczFunction μ X t + 1 := by
              exact (psiTwoOrliczFunction_integral_add_one ht0 htTop hX).symm
        _ ≤ 1 + 1 := by
          simpa only [add_comm] using (add_le_add_right hbound (1 : ENNReal))
        _ = 2 := by norm_num
    have hInt : Integrable
        (fun ω => Real.exp (X ω ^ 2 / t.toReal ^ 2)) μ := by
      have hmeas : Measurable (fun ω =>
          Real.exp (X ω ^ 2 / t.toReal ^ 2)) := by fun_prop
      have hfinite : HasFiniteIntegral (fun ω =>
          Real.exp (X ω ^ 2 / t.toReal ^ 2)) μ := by
        rw [hasFiniteIntegral_iff_enorm]
        simpa only [← ofReal_norm_eq_enorm, Real.norm_eq_abs,
          abs_of_pos (Real.exp_pos _)] using
          (lt_of_le_of_lt hbound' ENNReal.coe_lt_top)
      exact ⟨hmeas.aestronglyMeasurable, hfinite⟩
    refine ⟨hX, ht0, htTop, hInt, ?_⟩
    have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
      (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
    have hOf : ENNReal.ofReal
        (∫ ω, Real.exp (X ω ^ 2 / t.toReal ^ 2) ∂μ) ≤ (2 : ENNReal) := by
      rw [hEq]
      exact hbound'
    have hreal := (ENNReal.ofReal_le_iff_le_toReal (b := (2 : ENNReal))
      (by norm_num)).mp hOf
    simpa using hreal
  · intro ht
    rcases ht with ⟨_, ht0, htTop, hInt, hbound⟩
    refine ⟨ht0, htTop, ?_⟩
    have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
      (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
    have h := psiTwoOrliczFunction_integral_add_one (μ := μ) (X := X) (t := t)
      ht0 htTop hX
    have hbound' :
        (∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ) ≤
          (2 : ENNReal) := by
      rw [← hEq]
      simpa using ENNReal.ofReal_le_ofReal hbound
    apply ENNReal.le_of_add_le_add_right (a := (1 : ENNReal)) (by norm_num)
    calc
      orliczIntegral psiTwoOrliczFunction μ X t + 1 =
          (∫⁻ ω, ENNReal.ofReal (Real.exp (X ω ^ 2 / t.toReal ^ 2)) ∂μ) := h
      _ ≤ 2 := hbound'
      _ = 1 + 1 := by norm_num

theorem psiTwoOrliczMember_iff_psiTwoMember
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    orliczMember psiTwoOrliczFunction μ X ↔
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞ := by
  rw [orliczMember, psiTwoOrliczGauge_eq_psiTwoGauge hX]

/-! ### The sub-exponential norm `‖·‖_{ψ₁}`

Definition 2.7.5 and display (2.21) define the sub-exponential norm as the
smallest `K` in property (d) of Proposition 2.7.1:

  `‖X‖_{ψ₁} = inf {t > 0 : 𝔼 exp (|X| / t) ≤ 2}`.

`PsiOneAdmissible` is the admissibility predicate of that infimum, phrased so
that `PsiOneAdmissible μ X (ENNReal.ofReal K)` and
`SubExponentialOnePointMGF μ X K` agree for `0 < K` (see
`psiOneAdmissible_ofReal_iff`).  `PsiOneGauge` is the gauge itself, and it
coincides with the Orlicz gauge of the Orlicz function `ψ₁ x = exp x - 1`
(`psiOneOrliczGauge_eq_psiOneGauge`), which is the Section 2.7.1 view. -/

def PsiOneAdmissible {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ≥0∞) : Prop :=
  Measurable X ∧ t ≠ 0 ∧ t ≠ ∞ ∧
    Integrable (fun ω => Real.exp (|X ω| / t.toReal)) μ ∧
      (∫ ω, Real.exp (|X ω| / t.toReal) ∂μ) ≤ 2

noncomputable def PsiOneGauge {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : ℝ≥0∞ :=
  sInf {t : ℝ≥0∞ | PsiOneAdmissible μ X t}

/-- The admissibility predicate of `‖·‖_{ψ₁}` is exactly property (d) of
Proposition 2.7.1 at the corresponding positive real scale. -/
theorem psiOneAdmissible_ofReal_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {K : ℝ} (hK : 0 < K) :
    PsiOneAdmissible μ X (ENNReal.ofReal K) ↔
      SubExponentialOnePointMGF μ X K := by
  have htoReal : (ENNReal.ofReal K).toReal = K :=
    ENNReal.toReal_ofReal hK.le
  unfold PsiOneAdmissible SubExponentialOnePointMGF
  rw [htoReal]
  constructor
  · rintro ⟨hMeas, _, _, hInt, hBound⟩
    exact ⟨hMeas, hK, hInt, hBound⟩
  · rintro ⟨hMeas, _, hInt, hBound⟩
    exact ⟨hMeas, (ENNReal.ofReal_ne_zero_iff).2 hK, ENNReal.ofReal_ne_top,
      hInt, hBound⟩

/-- `‖X‖_{ψ₁}` is finite exactly when `X` satisfies property (d) of
Proposition 2.7.1 for some positive parameter, i.e. exactly when `X` is
sub-exponential. -/
theorem psiOneGauge_finite_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    PsiOneGauge μ X < ∞ ↔
      ∃ K : ℝ, 0 < K ∧ SubExponentialOnePointMGF μ X K := by
  constructor
  · intro hGauge
    by_cases hNonempty : Set.Nonempty {t : ℝ≥0∞ | PsiOneAdmissible μ X t}
    · rcases hNonempty with ⟨t, hMeas, ht0, htTop, hInt, hBound⟩
      have htPos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
      exact ⟨t.toReal, htPos, hMeas, htPos, hInt, hBound⟩
    · have hEmpty : {t : ℝ≥0∞ | PsiOneAdmissible μ X t} = ∅ :=
        Set.not_nonempty_iff_eq_empty.mp hNonempty
      rw [PsiOneGauge, hEmpty] at hGauge
      simp at hGauge
  · rintro ⟨K, hK, hPoint⟩
    refine lt_of_le_of_lt (sInf_le ?_)
      (show ENNReal.ofReal K < ∞ from ENNReal.ofReal_lt_top)
    exact (psiOneAdmissible_ofReal_iff hK).2 hPoint

/-- Positive scalar multiplication rescales admissible `ψ₁` parameters exactly. -/
theorem psiOneAdmissible_smul_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {c : ℝ} (hc : 0 < c) (t : ℝ≥0∞) :
    PsiOneAdmissible μ X t ↔
      PsiOneAdmissible μ (fun ω ↦ c * X ω) (ENNReal.ofReal c * t) := by
  have hc0 : ENNReal.ofReal c ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 hc
  have hcTop : ENNReal.ofReal c ≠ ∞ := ENNReal.ofReal_ne_top
  constructor
  · rintro ⟨hX, ht0, htTop, hInt, hBound⟩
    have htReal : t.toReal ≠ 0 := (ENNReal.toReal_ne_zero).2 ⟨ht0, htTop⟩
    have hfun :
        (fun ω ↦ Real.exp (|c * X ω| / (ENNReal.ofReal c * t).toReal)) =
          (fun ω ↦ Real.exp (|X ω| / t.toReal)) := by
      funext ω
      rw [ENNReal.toReal_mul, ENNReal.toReal_ofReal hc.le, abs_mul, abs_of_pos hc]
      congr 1
      field_simp
    refine ⟨hX.const_mul c, mul_ne_zero hc0 ht0,
      ENNReal.mul_ne_top hcTop htTop, ?_, ?_⟩
    · simpa only [hfun] using hInt
    · simpa only [hfun] using hBound
  · rintro ⟨hcX, hct0, hctTop, hInt, hBound⟩
    have ht0 : t ≠ 0 := fun h ↦ hct0 (by rw [h]; simp)
    have htTop : t ≠ ∞ := fun h ↦ hctTop (by rw [h]; simp [hc0])
    have htReal : t.toReal ≠ 0 := (ENNReal.toReal_ne_zero).2 ⟨ht0, htTop⟩
    have hX : Measurable X := by
      have hscaled : Measurable (fun ω ↦ c⁻¹ * (c * X ω)) := hcX.const_mul c⁻¹
      convert hscaled using 1
      funext ω
      field_simp [hc.ne']
    have hfun :
        (fun ω ↦ Real.exp (|c * X ω| / (ENNReal.ofReal c * t).toReal)) =
          (fun ω ↦ Real.exp (|X ω| / t.toReal)) := by
      funext ω
      rw [ENNReal.toReal_mul, ENNReal.toReal_ofReal hc.le, abs_mul, abs_of_pos hc]
      congr 1
      field_simp
    refine ⟨hX, ht0, htTop, ?_, ?_⟩
    · simpa only [hfun] using hInt
    · simpa only [hfun] using hBound

/-- The `ψ₁` gauge is exactly homogeneous under multiplication by a positive real
scalar.  This is the reusable scaling fact behind the exponential-law example. -/
theorem psiOneGauge_smul_of_pos
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {c : ℝ} (hc : 0 < c) :
    PsiOneGauge μ (fun ω ↦ c * X ω) =
      ENNReal.ofReal c * PsiOneGauge μ X := by
  let a : ℝ≥0∞ := ENNReal.ofReal c
  have ha0 : a ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 hc
  have haTop : a ≠ ∞ := ENNReal.ofReal_ne_top
  let e : ℝ≥0∞ ≃o ℝ≥0∞ :=
    ENNReal.mulLeftOrderIso a (ENNReal.isUnit_iff.2 ⟨ha0, haTop⟩)
  have he (t : ℝ≥0∞) : e t = a * t := by
    rfl
  have hset :
      {u : ℝ≥0∞ | PsiOneAdmissible μ (fun ω ↦ c * X ω) u} =
        e '' {t : ℝ≥0∞ | PsiOneAdmissible μ X t} := by
    ext u
    constructor
    · intro hu
      refine ⟨e.symm u, ?_, e.apply_symm_apply u⟩
      apply (psiOneAdmissible_smul_iff hc (e.symm u)).2
      rw [← he, e.apply_symm_apply]
      exact hu
    · rintro ⟨t, ht, rfl⟩
      rw [he]
      exact (psiOneAdmissible_smul_iff hc t).1 ht
  unfold PsiOneGauge
  rw [hset, ← he]
  rw [OrderIso.map_sInf e, sInf_image]

/-- Computing a `ψ₁` gauge after pushing a measure forward is the same as
computing the gauge of the pushed-forward random variable. -/
theorem psiOneGauge_map
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {f : Ω → ℝ} (hf : Measurable f) :
    PsiOneGauge (Measure.map f μ) (fun y : ℝ ↦ y) = PsiOneGauge μ f := by
  have hadmissible (t : ℝ≥0∞) :
      PsiOneAdmissible (Measure.map f μ) (fun y : ℝ ↦ y) t ↔
        PsiOneAdmissible μ f t := by
    let g : ℝ → ℝ := fun y ↦ Real.exp (|y| / t.toReal)
    have hg : Measurable g := by
      dsimp [g]
      fun_prop
    have hInt : Integrable g (Measure.map f μ) ↔ Integrable (g ∘ f) μ :=
      integrable_map_measure hg.aestronglyMeasurable hf.aemeasurable
    have hIntegral : (∫ y, g y ∂Measure.map f μ) = ∫ ω, g (f ω) ∂μ :=
      integral_map hf.aemeasurable hg.aestronglyMeasurable
    unfold PsiOneAdmissible
    constructor
    · rintro ⟨_, ht0, htTop, hMapInt, hMapBound⟩
      refine ⟨hf, ht0, htTop, ?_, ?_⟩
      · have : Integrable (g ∘ f) μ := hInt.1 (by simpa [g] using hMapInt)
        simpa [g, Function.comp_apply] using this
      · have : (∫ ω, g (f ω) ∂μ) ≤ 2 := by
          rw [← hIntegral]
          simpa [g] using hMapBound
        simpa [g] using this
    · rintro ⟨_, ht0, htTop, hCompInt, hCompBound⟩
      refine ⟨measurable_id, ht0, htTop, ?_, ?_⟩
      · apply hInt.2
        simpa [g, Function.comp_apply] using hCompInt
      · rw [hIntegral]
        simpa [g] using hCompBound
  unfold PsiOneGauge
  congr 1
  ext t
  exact hadmissible t

/-- Example 2.7.13's companion for `ψ₁`: the Orlicz function `exp x - 1`. -/
noncomputable def psiOneOrliczFunction : OrliczFunction :=
  { toFun := fun x => Real.exp x - 1
    nonnegative := by
      intro x hx
      linarith [Real.one_le_exp hx]
    convexOn_nonneg := by
      refine ⟨convex_Ici (0 : ℝ), ?_⟩
      intro x _ y _ a b ha hb hab
      change Real.exp (a * x + b * y) - 1 ≤
        a * (Real.exp x - 1) + b * (Real.exp y - 1)
      have hexp := convexOn_exp.2 (show x ∈ Set.univ by trivial)
        (show y ∈ Set.univ by trivial) ha hb hab
      have hstep : Real.exp (a * x + b * y) ≤
          a * Real.exp x + b * Real.exp y := by
        simpa [smul_eq_mul] using hexp
      have hone : a * (Real.exp x - 1) + b * (Real.exp y - 1) =
          a * Real.exp x + b * Real.exp y - 1 := by
        have : a + b = 1 := hab
        nlinarith [this]
      linarith [hstep, hone.ge, hone.le]
    monotoneOn_nonneg := by
      intro x _ y _ hxy
      dsimp
      exact sub_le_sub_right (Real.exp_le_exp.mpr hxy) 1
    map_zero := by norm_num
    tendsto_atTop := by
      have hexp : Tendsto Real.exp atTop atTop := Real.tendsto_exp_atTop
      simpa using hexp.atTop_add (tendsto_const_nhds :
        Tendsto (fun _ : ℝ => (-1 : ℝ)) atTop (𝓝 (-1))) }

lemma psiOneOrliczFunction_integral_add_one
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {t : ℝ≥0∞}
    (ht0 : t ≠ 0) (htTop : t ≠ ∞) (hX : Measurable X) :
    orliczIntegral psiOneOrliczFunction μ X t + 1 =
      ∫⁻ ω, ENNReal.ofReal (Real.exp (|X ω| / t.toReal)) ∂μ := by
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  let f : Ω → ℝ := fun ω => Real.exp (|X ω| / t.toReal)
  let g : Ω → ℝ≥0∞ := fun ω => ENNReal.ofReal (f ω - 1)
  have hmeasg : Measurable g := by
    dsimp [g, f]
    fun_prop
  have hnonneg : ∀ ω, 0 ≤ f ω - 1 := by
    intro ω
    dsimp [f]
    have harg : 0 ≤ |X ω| / t.toReal := div_nonneg (abs_nonneg _) htpos.le
    linarith [Real.one_le_exp harg]
  have hpoint : ∀ ω, ENNReal.ofReal (f ω) = g ω + 1 := by
    intro ω
    dsimp [g]
    calc
      ENNReal.ofReal (f ω) = ENNReal.ofReal ((f ω - 1) + 1) := by
        congr 1
        ring
      _ = ENNReal.ofReal (f ω - 1) + ENNReal.ofReal 1 :=
        ENNReal.ofReal_add (hnonneg ω) (by norm_num)
      _ = ENNReal.ofReal (f ω - 1) + 1 := by norm_num
  calc
    orliczIntegral psiOneOrliczFunction μ X t + 1 =
        (∫⁻ ω, g ω ∂μ) + 1 := by
          congr 1
    _ = ∫⁻ ω, (g ω + 1) ∂μ := by
          symm
          rw [lintegral_add_left hmeasg]
          simp
    _ = ∫⁻ ω, ENNReal.ofReal (f ω) ∂μ := by
          apply lintegral_congr
          intro ω
          exact (hpoint ω).symm

/-- Example 2.7.13's companion for `ψ₁`: the Luxemburg gauge of
`ψ₁ x = exp x - 1` is the source sub-exponential norm `‖·‖_{ψ₁}`. -/
theorem psiOneOrliczGauge_eq_psiOneGauge
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    orliczGauge psiOneOrliczFunction μ X = PsiOneGauge μ X := by
  unfold orliczGauge PsiOneGauge
  apply congrArg sInf
  ext t
  constructor
  · intro ht
    rcases ht with ⟨ht0, htTop, hbound⟩
    have hbound' :
        ∫⁻ ω, ENNReal.ofReal (Real.exp (|X ω| / t.toReal)) ∂μ ≤ 2 := by
      calc
        (∫⁻ ω, ENNReal.ofReal (Real.exp (|X ω| / t.toReal)) ∂μ) =
            orliczIntegral psiOneOrliczFunction μ X t + 1 :=
              (psiOneOrliczFunction_integral_add_one ht0 htTop hX).symm
        _ ≤ 1 + 1 := by
          simpa only [add_comm] using (add_le_add_right hbound (1 : ENNReal))
        _ = 2 := by norm_num
    have hInt : Integrable (fun ω => Real.exp (|X ω| / t.toReal)) μ := by
      have hmeas : Measurable (fun ω =>
          Real.exp (|X ω| / t.toReal)) := by fun_prop
      have hfinite : HasFiniteIntegral (fun ω =>
          Real.exp (|X ω| / t.toReal)) μ := by
        rw [hasFiniteIntegral_iff_enorm]
        simpa only [← ofReal_norm_eq_enorm, Real.norm_eq_abs,
          abs_of_pos (Real.exp_pos _)] using
          (lt_of_le_of_lt hbound' ENNReal.coe_lt_top)
      exact ⟨hmeas.aestronglyMeasurable, hfinite⟩
    refine ⟨hX, ht0, htTop, hInt, ?_⟩
    have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
      (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
    have hOf : ENNReal.ofReal
        (∫ ω, Real.exp (|X ω| / t.toReal) ∂μ) ≤ (2 : ENNReal) := by
      rw [hEq]
      exact hbound'
    have hreal := (ENNReal.ofReal_le_iff_le_toReal (b := (2 : ENNReal))
      (by norm_num)).mp hOf
    simpa using hreal
  · intro ht
    rcases ht with ⟨_, ht0, htTop, hInt, hbound⟩
    refine ⟨ht0, htTop, ?_⟩
    have hEq := MeasureTheory.ofReal_integral_eq_lintegral_ofReal hInt
      (Filter.Eventually.of_forall (fun ω => (Real.exp_pos _).le))
    have h := psiOneOrliczFunction_integral_add_one (μ := μ) (X := X) (t := t)
      ht0 htTop hX
    have hbound' :
        (∫⁻ ω, ENNReal.ofReal (Real.exp (|X ω| / t.toReal)) ∂μ) ≤
          (2 : ENNReal) := by
      rw [← hEq]
      simpa using ENNReal.ofReal_le_ofReal hbound
    apply ENNReal.le_of_add_le_add_right (a := (1 : ENNReal)) (by norm_num)
    calc
      orliczIntegral psiOneOrliczFunction μ X t + 1 =
          (∫⁻ ω, ENNReal.ofReal (Real.exp (|X ω| / t.toReal)) ∂μ) := h
      _ ≤ 2 := hbound'
      _ = 1 + 1 := by norm_num

theorem psiOneOrliczMember_iff_psiOneMember
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    orliczMember psiOneOrliczFunction μ X ↔ PsiOneGauge μ X < ∞ := by
  rw [orliczMember, psiOneOrliczGauge_eq_psiOneGauge hX]

/-! ### From the `ψ₁` gauge to the sub-exponential properties

`PsiOneGauge` is an infimum, so a bound `‖X‖_{ψ₁} ≤ K` need not be attained at
`K` itself.  The usable hypothesis is the strict one, `‖X‖_{ψ₁} < K`, which does
produce an admissible scale below `K`; property (d) is then monotone upwards in
the scale. -/

/-- Property (d) of Proposition 2.7.1 is monotone in its parameter: enlarging
the scale only weakens `𝔼 exp (|X| / K) ≤ 2`. -/
theorem subExponentialOnePointMGF_mono
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {t K : ℝ}
    (hPoint : SubExponentialOnePointMGF μ X t) (htK : t ≤ K) :
    SubExponentialOnePointMGF μ X K := by
  obtain ⟨hMeas, htpos, hInt, hBound⟩ := hPoint
  have hKpos : 0 < K := lt_of_lt_of_le htpos htK
  have hpt : ∀ ω, Real.exp (|X ω| / K) ≤ Real.exp (|X ω| / t) := by
    intro ω
    exact Real.exp_le_exp.2 (div_le_div_of_nonneg_left (abs_nonneg _) htpos htK)
  have hIntK : Integrable (fun ω => Real.exp (|X ω| / K)) μ := by
    refine hInt.mono' (by fun_prop) ?_
    refine Filter.Eventually.of_forall (fun ω => ?_)
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    exact hpt ω
  refine ⟨hMeas, hKpos, hIntK, ?_⟩
  calc
    (∫ ω, Real.exp (|X ω| / K) ∂μ) ≤ ∫ ω, Real.exp (|X ω| / t) ∂μ :=
      integral_mono hIntK hInt hpt
    _ ≤ 2 := hBound

/-- A strict `ψ₁`-gauge bound yields property (d) of Proposition 2.7.1 at that
scale.  This is the entry point from the source's `‖X‖_{ψ₁}` to every
quantitative sub-exponential estimate in the chapter. -/
theorem psiOneGauge_lt_imp_onePointMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hGauge : PsiOneGauge μ X < ENNReal.ofReal K) :
    SubExponentialOnePointMGF μ X K := by
  rw [PsiOneGauge, sInf_lt_iff] at hGauge
  obtain ⟨t, ht, htK⟩ := hGauge
  obtain ⟨hMeas, ht0, htTop, hInt, hBound⟩ := ht
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have htlt : t.toReal < K := by
    have := (ENNReal.toReal_lt_toReal htTop (by simp)).2 htK
    simpa [ENNReal.toReal_ofReal hK.le] using this
  exact subExponentialOnePointMGF_mono ⟨hMeas, htpos, hInt, hBound⟩ htlt.le

/-! The `ψ₁` gauge is a genuine norm on measurable random variables modulo
almost-everywhere equality.  The zero characterization is useful at the
degenerate boundary of family-wise bounds whose scale is
`max_i ‖X_i‖_{ψ₁}`. -/

theorem psiOneGauge_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] :
    PsiOneGauge μ (fun _ : Ω => (0 : ℝ)) = 0 := by
  apply le_antisymm
  · apply le_of_forall_gt_imp_ge_of_dense
    intro r hr
    by_cases hrTop : r = ∞
    · simp [hrTop]
    have hr0 : r ≠ 0 := ne_of_gt hr
    have hAd : PsiOneAdmissible μ (fun _ : Ω => (0 : ℝ)) r := by
      refine ⟨measurable_const, hr0, hrTop, ?_, ?_⟩
      · simp
      · simp
    exact sInf_le hAd
  · exact bot_le

lemma psiOneAdmissible_ae_congr
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} (hX : Measurable X) (hY : Measurable Y)
    (hXY : X =ᵐ[μ] Y) {t : ℝ≥0∞} :
    PsiOneAdmissible μ X t ↔ PsiOneAdmissible μ Y t := by
  have hfun : (fun ω => Real.exp (|X ω| / t.toReal)) =ᵐ[μ]
      (fun ω => Real.exp (|Y ω| / t.toReal)) := by
    filter_upwards [hXY] with ω hω
    simp [hω]
  constructor
  · intro h
    rcases h with ⟨_, ht0, htTop, hInt, hBound⟩
    refine ⟨hY, ht0, htTop, hInt.congr hfun, ?_⟩
    rw [integral_congr_ae hfun] at hBound
    exact hBound
  · intro h
    rcases h with ⟨_, ht0, htTop, hInt, hBound⟩
    refine ⟨hX, ht0, htTop, hInt.congr hfun.symm, ?_⟩
    rw [integral_congr_ae hfun.symm] at hBound
    exact hBound

theorem psiOneGauge_ae_congr
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} (hX : Measurable X) (hY : Measurable Y)
    (hXY : X =ᵐ[μ] Y) :
    PsiOneGauge μ X = PsiOneGauge μ Y := by
  unfold PsiOneGauge
  congr 1
  ext t
  exact psiOneAdmissible_ae_congr hX hY hXY

theorem psiOneGauge_eq_zero_iff_ae_eq_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : Measurable X) :
    PsiOneGauge μ X = 0 ↔ X =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) := by
  constructor
  · intro hGauge
    have hTail : ∀ K : ℝ, 0 < K → SubExponentialTailBound μ X K := by
      intro K hK
      apply subExponentialOnePointToTail
      apply psiOneGauge_lt_imp_onePointMGF hK
      rw [hGauge]
      exact ENNReal.ofReal_pos.mpr hK
    have hInt : Integrable (fun ω => |X ω|) μ := by
      have hMoment := subExponentialTailToMoment (hTail 1 (by norm_num))
      have h := hMoment.2.2.2 1 (by norm_num : (1 : ℝ) ≤ 1)
      simpa using h.1
    have hBound : ∀ K : ℝ, 0 < K →
        (∫ ω, |X ω| ∂μ) ≤ 8 * Real.exp 1 * K := by
      intro K hK
      have hMoment := subExponentialTailToMoment (hTail K hK)
      have h := hMoment.2.2.2 1 (by norm_num : (1 : ℝ) ≤ 1)
      simpa using h.2
    have hIntegralZero : (∫ ω, |X ω| ∂μ) = 0 := by
      apply le_antisymm
      · apply le_of_forall_gt_imp_ge_of_dense
        intro ε hε
        have hK : 0 < ε / (8 * Real.exp 1) := by positivity
        calc
          (∫ ω, |X ω| ∂μ) ≤
              8 * Real.exp 1 * (ε / (8 * Real.exp 1)) :=
            hBound (ε / (8 * Real.exp 1)) hK
          _ = ε := by field_simp
      · exact integral_nonneg_of_ae
          (Filter.Eventually.of_forall (fun ω => abs_nonneg (X ω)))
    have hAbs : (fun ω => |X ω|) =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) :=
      (integral_eq_zero_iff_of_nonneg
        (fun ω => abs_nonneg (X ω)) hInt).mp hIntegralZero
    filter_upwards [hAbs] with ω hω
    exact abs_eq_zero.mp hω
  · intro hZero
    rw [psiOneGauge_ae_congr hX measurable_const hZero]
    exact psiOneGauge_zero

/-- Proposition 2.7.1 with the absolute constant exposed.  This is the
constant-explicit form of `subExponentialCharacterization`, needed whenever one
constant must serve a whole family of random variables at once (as in the sums
of Section 2.8, where the constant may not depend on the index). -/
theorem subExponentialPropertyTransfer
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (i j : SubExponentialPropertyKind) {Ki : ℝ} (hKi : 0 < Ki)
    (hProp : SubExponentialProperty μ X i Ki) :
    ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ 512 * (Real.exp 1) ^ 3 * Ki ∧
      SubExponentialProperty μ X j Kj := by
  obtain ⟨T, hT, hTbound, hTail⟩ := subExponentialToTail i hKi hProp
  obtain ⟨Kj, hKj, hKjbound, hResult⟩ := subExponentialFromTail j hT hTail
  refine ⟨Kj, hKj, ?_, hResult⟩
  have hcoef : (0 : ℝ) ≤ 64 * (Real.exp 1) ^ 2 := by positivity
  calc
    Kj ≤ 64 * (Real.exp 1) ^ 2 * T := hKjbound
    _ ≤ 64 * (Real.exp 1) ^ 2 * (8 * Real.exp 1 * Ki) :=
        mul_le_mul_of_nonneg_left hTbound hcoef
    _ = 512 * (Real.exp 1) ^ 3 * Ki := by ring

/-! ### Lemma 2.7.6: sub-exponential is sub-gaussian squared -/

/-- The two gauges' admissibility predicates correspond under `s ↦ s²`:
`𝔼 exp (X²/s²) ≤ 2` is literally `𝔼 exp (|X²|/(s²)) ≤ 2`. -/
theorem psiTwoAdmissible_iff_psiOneAdmissible_sq
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X) (s : ℝ≥0∞) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X s ↔
      PsiOneAdmissible μ (fun ω => X ω ^ 2) (s ^ 2) := by
  have hsq : Measurable (fun ω => X ω ^ 2) := by fun_prop
  have hzero : s ^ 2 ≠ 0 ↔ s ≠ 0 := by
    constructor
    · intro h hs; exact h (by rw [hs]; norm_num)
    · intro h; exact pow_ne_zero 2 h
  have htop : s ^ 2 ≠ ∞ ↔ s ≠ ∞ := by
    constructor
    · intro h hs; exact h (by rw [hs]; simp)
    · intro h
      exact ENNReal.pow_ne_top h
  have hfun : (fun ω => Real.exp (|X ω ^ 2| / (s ^ 2).toReal)) =
      (fun ω => Real.exp (X ω ^ 2 / s.toReal ^ 2)) := by
    funext ω
    rw [abs_of_nonneg (sq_nonneg (X ω)), ENNReal.toReal_pow]
  unfold NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible PsiOneAdmissible
  rw [hfun]
  constructor
  · rintro ⟨_, hs0, hsTop, hInt, hBound⟩
    exact ⟨hsq, hzero.2 hs0, htop.2 hsTop, hInt, hBound⟩
  · rintro ⟨_, hs0, hsTop, hInt, hBound⟩
    exact ⟨hX, hzero.1 hs0, htop.1 hsTop, hInt, hBound⟩

/-- Lemma 2.7.6 (Sub-exponential is sub-gaussian squared).  For a measurable
`X`, the sub-exponential norm of `X²` equals the square of the sub-gaussian
norm of `X`:  `‖X²‖_{ψ₁} = ‖X‖²_{ψ₂}`.  In particular `X` is sub-gaussian
exactly when `X²` is sub-exponential (`psiOneGauge_sq_lt_top_iff`). -/
theorem psiOneGauge_sq_eq_psiTwoGauge_sq
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X) :
    PsiOneGauge μ (fun ω => X ω ^ 2) =
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ^ 2 := by
  set e : ℝ≥0∞ ≃o ℝ≥0∞ := ENNReal.orderIsoRpow 2 (by norm_num) with he_def
  have he : ∀ x : ℝ≥0∞, e x = x ^ 2 := by
    intro x
    rw [he_def]
    rw [ENNReal.orderIsoRpow_apply]
    rw [show ((2 : ℝ)) = ((2 : ℕ) : ℝ) by norm_num, ENNReal.rpow_natCast]
  have hset : {t : ℝ≥0∞ | PsiOneAdmissible μ (fun ω => X ω ^ 2) t} =
      e '' {s : ℝ≥0∞ | NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X s} := by
    ext t
    constructor
    · intro ht
      refine ⟨e.symm t, ?_, e.apply_symm_apply t⟩
      have hval : (e.symm t) ^ 2 = t := by
        rw [← he (e.symm t), e.apply_symm_apply]
      exact (psiTwoAdmissible_iff_psiOneAdmissible_sq hX (e.symm t)).2
        (by rw [hval]; exact ht)
    · rintro ⟨s, hs, rfl⟩
      rw [he s]
      exact (psiTwoAdmissible_iff_psiOneAdmissible_sq hX s).1 hs
  unfold PsiOneGauge NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
  rw [hset, ← he]
  rw [OrderIso.map_sInf e, sInf_image]

/-- Lemma 2.7.6, membership form: `X` is sub-gaussian iff `X²` is
sub-exponential. -/
theorem psiOneGauge_sq_lt_top_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X) :
    PsiOneGauge μ (fun ω => X ω ^ 2) < ∞ ↔
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞ := by
  rw [psiOneGauge_sq_eq_psiTwoGauge_sq hX]
  constructor
  · intro h
    by_contra hcon
    rw [not_lt, top_le_iff] at hcon
    rw [hcon] at h
    simp at h
  · intro h
    exact ENNReal.pow_lt_top h

/-! ### Lemma 2.7.7: a product of sub-gaussians is sub-exponential -/

/-- The pointwise Young step of Lemma 2.7.7 (printed page 34): with
`a = exp (X²/2s²)` and `b = exp (Y²/2u²)`, `ab ≤ (a² + b²)/2` gives
`exp (|XY| / (su)) ≤ (exp (X²/s²) + exp (Y²/u²)) / 2`. -/
theorem exp_abs_mul_div_le_half_add
    {x y s u : ℝ} (hs : 0 < s) (hu : 0 < u) :
    Real.exp (|x * y| / (s * u)) ≤
      (Real.exp (x ^ 2 / s ^ 2) + Real.exp (y ^ 2 / u ^ 2)) / 2 := by
  have hyoung : |x * y| / (s * u) ≤ x ^ 2 / s ^ 2 / 2 + y ^ 2 / u ^ 2 / 2 := by
    have hkey : |x| / s * (|y| / u) ≤
        ((|x| / s) ^ 2 + (|y| / u) ^ 2) / 2 := by
      nlinarith [sq_nonneg (|x| / s - |y| / u)]
    have hx2 : (|x| / s) ^ 2 = x ^ 2 / s ^ 2 := by
      rw [div_pow, sq_abs]
    have hy2 : (|y| / u) ^ 2 = y ^ 2 / u ^ 2 := by
      rw [div_pow, sq_abs]
    rw [hx2, hy2] at hkey
    have hsplit : |x * y| / (s * u) = |x| / s * (|y| / u) := by
      rw [abs_mul]
      field_simp
    rw [hsplit]
    linarith
  have hmono := Real.exp_le_exp.2 hyoung
  refine hmono.trans ?_
  rw [Real.exp_add]
  have ha : Real.exp (x ^ 2 / s ^ 2 / 2) ^ 2 = Real.exp (x ^ 2 / s ^ 2) := by
    rw [← Real.exp_nat_mul]
    congr 1
    ring
  have hb : Real.exp (y ^ 2 / u ^ 2 / 2) ^ 2 = Real.exp (y ^ 2 / u ^ 2) := by
    rw [← Real.exp_nat_mul]
    congr 1
    ring
  nlinarith [sq_nonneg (Real.exp (x ^ 2 / s ^ 2 / 2) - Real.exp (y ^ 2 / u ^ 2 / 2)),
    ha, hb]

/-- Lemma 2.7.7, admissibility form: if `s` is `ψ₂`-admissible for `X` and `u`
is `ψ₂`-admissible for `Y`, then `s * u` is `ψ₁`-admissible for `X * Y`. -/
theorem psiTwoAdmissible_mul
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {s u : ℝ≥0∞}
    (hX : NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X s)
    (hY : NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Y u) :
    PsiOneAdmissible μ (fun ω => X ω * Y ω) (s * u) := by
  obtain ⟨hXm, hs0, hsTop, hXint, hXb⟩ := hX
  obtain ⟨hYm, hu0, huTop, hYint, hYb⟩ := hY
  have hspos : 0 < s.toReal := ENNReal.toReal_pos hs0 hsTop
  have hupos : 0 < u.toReal := ENNReal.toReal_pos hu0 huTop
  have htoReal : (s * u).toReal = s.toReal * u.toReal := ENNReal.toReal_mul
  have hpt : ∀ ω, Real.exp (|X ω * Y ω| / (s * u).toReal) ≤
      (Real.exp (X ω ^ 2 / s.toReal ^ 2) +
        Real.exp (Y ω ^ 2 / u.toReal ^ 2)) / 2 := by
    intro ω
    rw [htoReal]
    exact exp_abs_mul_div_le_half_add hspos hupos
  have hdom : Integrable
      (fun ω => (Real.exp (X ω ^ 2 / s.toReal ^ 2) +
        Real.exp (Y ω ^ 2 / u.toReal ^ 2)) / 2) μ :=
    ((hXint.add hYint).div_const 2)
  have hInt : Integrable
      (fun ω => Real.exp (|X ω * Y ω| / (s * u).toReal)) μ := by
    refine hdom.mono' (by fun_prop) ?_
    refine Filter.Eventually.of_forall (fun ω => ?_)
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    exact hpt ω
  refine ⟨by fun_prop, mul_ne_zero hs0 hu0,
    ENNReal.mul_ne_top hsTop huTop, hInt, ?_⟩
  have hsum : (∫ ω, (Real.exp (X ω ^ 2 / s.toReal ^ 2) +
      Real.exp (Y ω ^ 2 / u.toReal ^ 2)) / 2 ∂μ) ≤ 2 := by
    rw [integral_div, integral_add hXint hYint]
    linarith [hXb, hYb]
  exact (integral_mono hInt hdom hpt).trans hsum

/-- Lemma 2.7.7 (Product of sub-gaussians is sub-exponential).  If `X` and `Y`
are sub-gaussian then `XY` is sub-exponential and
`‖XY‖_{ψ₁} ≤ ‖X‖_{ψ₂} ‖Y‖_{ψ₂}`.

Sub-gaussianity of both factors is the printed hypothesis (printed page 33), and
it is what makes the two `ψ₂`-admissible sets nonempty, so the infimum algebra
below has no degenerate branch. -/
theorem psiOneGauge_mul_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ}
    (hX : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞)
    (hY : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y < ∞) :
    PsiOneGauge μ (fun ω => X ω * Y ω) ≤
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X *
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y := by
  classical
  set A := {t : ℝ≥0∞ | NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X t}
    with hAdef
  set B := {t : ℝ≥0∞ | NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ Y t}
    with hBdef
  have hGX : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X = sInf A := rfl
  have hGY : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y = sInf B := rfl
  -- A finite gauge forces the admissible set to be nonempty.
  have hAne : A.Nonempty := by
    rcases Set.eq_empty_or_nonempty A with hEmpty | hNe
    · rw [hGX, hEmpty] at hX; simp at hX
    · exact hNe
  have hBne : B.Nonempty := by
    rcases Set.eq_empty_or_nonempty B with hEmpty | hNe
    · rw [hGY, hEmpty] at hY; simp at hY
    · exact hNe
  have hGYne : sInf B ≠ ∞ := by rw [← hGY]; exact hY.ne
  -- For a fixed admissible scale `s` for `X`, push the infimum over `B` inside.
  have hstep : ∀ s : A,
      PsiOneGauge μ (fun ω => X ω * Y ω) ≤ (s : ℝ≥0∞) * sInf B := by
    intro s
    have hs : NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X (s : ℝ≥0∞) :=
      s.2
    obtain ⟨-, hs0, hsTop, -, -⟩ := hs
    rw [sInf_eq_iInf' B, ENNReal.mul_iInf_of_ne hs0 hsTop]
    refine le_iInf ?_
    intro u
    exact sInf_le (psiTwoAdmissible_mul s.2 u.2)
  -- Now push the infimum over `A` inside; `sInf B = 0` is covered because `A`
  -- is nonempty, and `sInf B = ∞` cannot happen.
  rw [hGX, hGY, sInf_eq_iInf' A,
    ENNReal.iInf_mul' (fun h => absurd h hGYne) (fun _ => hAne.to_subtype)]
  exact le_iInf hstep

/-- Lemma 2.7.7, membership form: a product of two sub-gaussian variables is
sub-exponential. -/
theorem psiOneGauge_mul_lt_top
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ}
    (hX : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞)
    (hY : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y < ∞) :
    PsiOneGauge μ (fun ω => X ω * Y ω) < ∞ :=
  lt_of_le_of_lt (psiOneGauge_mul_le hX hY) (ENNReal.mul_lt_top hX hY)

end NumStability.HDP.Scalar.SubExponential

namespace NumStability.HDP.Contract

/-- Stable source-facing alias for the local Orlicz-function interface. -/
def hdp_02_hdef_horlicz_hfunction : Type :=
  NumStability.HDP.Scalar.SubExponential.OrliczFunction

/-- Stable source-facing alias for the Luxemburg/Orlicz norm-space model. -/
def hdp_02_hdef_horlicz_hnorm_hspace
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
    (μ : Measure Ω) :
    NumStability.HDP.Scalar.SubExponential.OrliczNormSpaceModelData ψ μ :=
  NumStability.HDP.Scalar.SubExponential.orliczNormSpaceModel ψ μ

/-- Stable Chapter 2 alias for the centered moment-to-MGF implication. -/
theorem hdp_02_hlem_hse_hmoment_hto_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hLp : NumStability.HDP.Scalar.SubExponential.LpMomentGrowth μ X K)
    (lam : ℝ) (hsmall : |lam| ≤ (4 * Real.exp 1 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp (2 * (Real.exp 1 * (lam * K)) ^ 2) :=
  NumStability.HDP.Scalar.SubExponential.momentToMGF hK hCenter hLp lam hsmall

/-- Stable Chapter 2 alias for the endpoint-MGF-to-moment implication. -/
theorem hdp_02_hlem_hse_hmgf_hto_hmoment
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K C : ℝ} (hK : 0 < K) (hC : 0 ≤ C)
    (hMGF : NumStability.HDP.Scalar.SubExponential.TwoSidedMGFBound μ X K C) :
    NumStability.HDP.Scalar.SubExponential.LpMomentGrowth μ X
      (2 * Real.exp C * K) :=
  NumStability.HDP.Scalar.SubExponential.mgfToMoment hK hC hMGF

/-! Stable Chapter 2 alias for Exercise 2.7.2. -/
theorem hdp_02_hex_h2_d7_d2
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind,
        ∀ {Ki : ℝ}, 0 < Ki →
          NumStability.HDP.Scalar.SubExponential.SubExponentialProperty μ X i Ki →
            ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
              NumStability.HDP.Scalar.SubExponential.SubExponentialProperty μ X j Kj := by
  exact NumStability.HDP.Scalar.SubExponential.subExponentialCharacterization

/-! Stable Chapter 2 alias for Exercise 2.7.3. -/
theorem hdp_02_hex_h2_d7_d3
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {α : ℝ} (hα : 0 < α) :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : NumStability.HDP.Scalar.SubExponential.SubWeibullPropertyKind,
        ∀ {Ki : ℝ}, 0 < Ki →
          NumStability.HDP.Scalar.SubExponential.SubWeibullProperty μ X α i Ki →
            ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
              NumStability.HDP.Scalar.SubExponential.SubWeibullProperty μ X α j Kj := by
  exact NumStability.HDP.Scalar.SubExponential.subWeibullCharacterization hα

/-! Stable Chapter 2 alias for Remark 2.7.9. -/
theorem hdp_02_hrem_h2_d7_d9 : hdp_02_hrem_h2_d7_d9__contract_type := by
  exact NumStability.HDP.Scalar.SubExponential.remark279_contract

/-! Stable Chapter 2 alias for Example 2.7.12. -/
theorem hdp_02_hexample_h2_d7_d12 :
    ∀ {Ω : Type*} [MeasurableSpace Ω]
      (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
      (μ : Measure Ω) (p : NNReal),
      0 < p →
      (∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ)) →
      (∀ X : Ω → ℝ,
        NumStability.HDP.Scalar.SubExponential.orliczGauge ψ μ X =
          eLpNorm X (p : ENNReal) μ) ∧
      (∀ X : Ω → ℝ, AEStronglyMeasurable X μ →
        (NumStability.HDP.Scalar.SubExponential.orliczMember ψ μ X ↔
          MemLp X (p : ENNReal) μ)) := by
  exact NumStability.HDP.Scalar.SubExponential.powerOrliczCoincidence

/-! Stable Chapter 2 alias for Example 2.7.13. -/
theorem hdp_02_hexample_h2_d7_d13
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    NumStability.HDP.Scalar.SubExponential.orliczMember
        NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction μ X ↔
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞ := by
  exact NumStability.HDP.Scalar.SubExponential.psiTwoOrliczMember_iff_psiTwoMember hX

/-! Stable Chapter 2 alias for Definition 2.7.5 (sub-exponential random
variables and the sub-exponential norm).  The gauge is the canonical producer;
this alias records that finiteness of the gauge is exactly property (d) of
Proposition 2.7.1 for some positive parameter. -/
theorem hdp_02_hdef_h2_d7_d5
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ X < ∞ ↔
      ∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubExponential.SubExponentialOnePointMGF μ X K :=
  NumStability.HDP.Scalar.SubExponential.psiOneGauge_finite_iff

/-! Stable Chapter 2 alias for display (2.21): the sub-exponential norm is the
infimum of the scales `t > 0` at which `𝔼 exp (|X| / t) ≤ 2`. -/
theorem hdp_02_heq_h2_d21
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ X =
      sInf {t : ℝ≥0∞ |
        NumStability.HDP.Scalar.SubExponential.PsiOneAdmissible μ X t} :=
  rfl

/-! Stable Chapter 2 alias for Lemma 2.7.6 (sub-exponential is sub-gaussian
squared): `‖X²‖_{ψ₁} = ‖X‖²_{ψ₂}`, together with the iff form. -/
theorem hdp_02_hlem_h2_d7_d6
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X) :
    (NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (fun ω => X ω ^ 2) < ∞ ↔
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞) ∧
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (fun ω => X ω ^ 2) =
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ^ 2 :=
  ⟨NumStability.HDP.Scalar.SubExponential.psiOneGauge_sq_lt_top_iff hX,
    NumStability.HDP.Scalar.SubExponential.psiOneGauge_sq_eq_psiTwoGauge_sq hX⟩

/-! Stable Chapter 2 alias for the `ψ₁` half of Example 2.7.13: the Luxemburg
gauge of the Orlicz function `exp x - 1` is the sub-exponential norm. -/
theorem hdp_02_hexample_h2_d7_d13_hpsi1
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    NumStability.HDP.Scalar.SubExponential.orliczGauge
        NumStability.HDP.Scalar.SubExponential.psiOneOrliczFunction μ X =
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ X :=
  NumStability.HDP.Scalar.SubExponential.psiOneOrliczGauge_eq_psiOneGauge hX

/-! Stable Chapter 2 alias for Lemma 2.7.7 (product of sub-gaussians is
sub-exponential): if `X` and `Y` are sub-gaussian then `XY` is sub-exponential
and `‖XY‖_{ψ₁} ≤ ‖X‖_{ψ₂} ‖Y‖_{ψ₂}`. -/
theorem hdp_02_hlem_h2_d7_d7
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ}
    (hX : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞)
    (hY : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y < ∞) :
    NumStability.HDP.Scalar.SubExponential.PsiOneGauge
        μ (fun ω => X ω * Y ω) < ∞ ∧
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge
          μ (fun ω => X ω * Y ω) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y :=
  ⟨NumStability.HDP.Scalar.SubExponential.psiOneGauge_mul_lt_top hX hY,
    NumStability.HDP.Scalar.SubExponential.psiOneGauge_mul_le hX hY⟩

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

### `ComputationalMathematics.Analysis.FiniteProbability`

Path: `lean-computational-mathematics/ComputationalMathematics/Analysis/FiniteProbability.lean`
SHA-256: `5b2e9d2ea6c873a18760eebdeebb2fa1739e94fe43b1a25545ecf98b7ffdeff5`

```lean
-- Analysis/FiniteProbability.lean
--
-- Lightweight finite probability spaces and elementary concentration kernels.

import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Analysis.Convex.Jensen
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

namespace NumStability

open scoped BigOperators

/-!
## Finite probability spaces

This file provides a small real-valued finite probability interface and the
elementary Markov, Chebyshev, and Chernoff kernels used by algorithm-specific
randomized stability analyses.
-/

/-!
### Scalar exponential inequalities

These elementary real inequalities are used by finite entropy/Herbst routes
when exponential tilts are compared across one coordinate flip.
-/

/-- For every real `s`, `exp s - 1 <= s * exp s`.

This form follows from `1 - s <= exp (-s)` after multiplying by `exp s`. -/
lemma real_exp_sub_one_le_mul_exp (s : ℝ) :
    Real.exp s - 1 ≤ s * Real.exp s := by
  have h := Real.add_one_le_exp (-s)
  have hmul := mul_le_mul_of_nonneg_right h (le_of_lt (Real.exp_pos s))
  rw [Real.exp_neg, inv_mul_cancel₀ (Real.exp_pos s).ne'] at hmul
  nlinarith

/-- A symmetric Lipschitz-type bound for the scalar exponential. -/
lemma real_abs_exp_sub_exp_le_abs_sub_mul_exp_add_exp (x y : ℝ) :
    |Real.exp x - Real.exp y| ≤
      |x - y| * (Real.exp x + Real.exp y) := by
  rcases le_total x y with hxy | hyx
  · have hdiff_nonneg : 0 ≤ y - x := sub_nonneg.mpr hxy
    have hexp_le : Real.exp x ≤ Real.exp y := Real.exp_le_exp.mpr hxy
    have habs : |Real.exp x - Real.exp y| = Real.exp y - Real.exp x := by
      rw [abs_of_nonpos (sub_nonpos.mpr hexp_le)]
      ring
    have hbase := real_exp_sub_one_le_mul_exp (y - x)
    have hmul := mul_le_mul_of_nonneg_left hbase (le_of_lt (Real.exp_pos x))
    have hrewrite :
        Real.exp y - Real.exp x =
          Real.exp x * (Real.exp (y - x) - 1) := by
      rw [show y = x + (y - x) by ring, Real.exp_add]
      ring_nf
    have hstep :
        Real.exp y - Real.exp x ≤ (y - x) * Real.exp y := by
      calc
        Real.exp y - Real.exp x =
            Real.exp x * (Real.exp (y - x) - 1) := hrewrite
        _ ≤ Real.exp x * ((y - x) * Real.exp (y - x)) := hmul
        _ = (y - x) * Real.exp y := by
            rw [show y = x + (y - x) by ring, Real.exp_add]
            ring_nf
    have hsum : Real.exp y ≤ Real.exp x + Real.exp y := by
      exact le_add_of_nonneg_left (le_of_lt (Real.exp_pos x))
    have hfinal :
        (y - x) * Real.exp y ≤
          (y - x) * (Real.exp x + Real.exp y) :=
      mul_le_mul_of_nonneg_left hsum hdiff_nonneg
    calc
      |Real.exp x - Real.exp y| = Real.exp y - Real.exp x := habs
      _ ≤ (y - x) * Real.exp y := hstep
      _ ≤ (y - x) * (Real.exp x + Real.exp y) := hfinal
      _ = |x - y| * (Real.exp x + Real.exp y) := by
          rw [abs_of_nonpos]
          · ring_nf
          · linarith
  · have hdiff_nonneg : 0 ≤ x - y := sub_nonneg.mpr hyx
    have hexp_le : Real.exp y ≤ Real.exp x := Real.exp_le_exp.mpr hyx
    have habs : |Real.exp x - Real.exp y| = Real.exp x - Real.exp y := by
      rw [abs_of_nonneg (sub_nonneg.mpr hexp_le)]
    have hbase := real_exp_sub_one_le_mul_exp (x - y)
    have hmul := mul_le_mul_of_nonneg_left hbase (le_of_lt (Real.exp_pos y))
    have hrewrite :
        Real.exp x - Real.exp y =
          Real.exp y * (Real.exp (x - y) - 1) := by
      rw [show x = y + (x - y) by ring, Real.exp_add]
      ring_nf
    have hstep :
        Real.exp x - Real.exp y ≤ (x - y) * Real.exp x := by
      calc
        Real.exp x - Real.exp y =
            Real.exp y * (Real.exp (x - y) - 1) := hrewrite
        _ ≤ Real.exp y * ((x - y) * Real.exp (x - y)) := hmul
        _ = (x - y) * Real.exp x := by
            rw [show x = y + (x - y) by ring, Real.exp_add]
            ring_nf
    have hsum : Real.exp x ≤ Real.exp x + Real.exp y := by
      exact le_add_of_nonneg_right (le_of_lt (Real.exp_pos y))
    have hfinal :
        (x - y) * Real.exp x ≤
          (x - y) * (Real.exp x + Real.exp y) :=
      mul_le_mul_of_nonneg_left hsum hdiff_nonneg
    calc
      |Real.exp x - Real.exp y| = Real.exp x - Real.exp y := habs
      _ ≤ (x - y) * Real.exp x := hstep
      _ ≤ (x - y) * (Real.exp x + Real.exp y) := hfinal
      _ = |x - y| * (Real.exp x + Real.exp y) := by
          rw [abs_of_nonneg hdiff_nonneg]

/-- Ordered half-exponential difference bound.

If `b <= a`, then the one-sided half-tilt increment is controlled by the
larger exponential weight.  This is the scalar input for the positive-drop
self-bounding route on the Rademacher cube. -/
lemma real_exp_half_sub_sq_le_quarter_mul_sq_mul_exp_of_le
    {a b : ℝ} (hba : b ≤ a) :
    (Real.exp (a / 2) - Real.exp (b / 2)) ^ 2 ≤
      ((a - b) ^ 2 / 4) * Real.exp a := by
  let d : ℝ := a / 2 - b / 2
  have hd_nonneg : 0 ≤ d := by
    dsimp [d]
    linarith
  have hhalf_le : b / 2 ≤ a / 2 := by linarith
  have hdiff_nonneg :
      0 ≤ Real.exp (a / 2) - Real.exp (b / 2) := by
    exact sub_nonneg.mpr (Real.exp_le_exp.mpr hhalf_le)
  have hrewrite :
      Real.exp (a / 2) - Real.exp (b / 2) =
        Real.exp (b / 2) * (Real.exp d - 1) := by
    dsimp [d]
    rw [show a / 2 = b / 2 + (a / 2 - b / 2) by ring, Real.exp_add]
    ring_nf
  have hbase := real_exp_sub_one_le_mul_exp d
  have hmul :=
    mul_le_mul_of_nonneg_left hbase (le_of_lt (Real.exp_pos (b / 2)))
  have hdiff_le :
      Real.exp (a / 2) - Real.exp (b / 2) ≤
        d * Real.exp (a / 2) := by
    calc
      Real.exp (a / 2) - Real.exp (b / 2)
          = Real.exp (b / 2) * (Real.exp d - 1) := hrewrite
      _ ≤ Real.exp (b / 2) * (d * Real.exp d) := hmul
      _ = d * Real.exp (a / 2) := by
          dsimp [d]
          rw [show a / 2 = b / 2 + (a / 2 - b / 2) by ring, Real.exp_add]
          ring_nf
  have hrhs_nonneg : 0 ≤ d * Real.exp (a / 2) :=
    mul_nonneg hd_nonneg (le_of_lt (Real.exp_pos _))
  have hsq :
      (Real.exp (a / 2) - Real.exp (b / 2)) ^ 2 ≤
        (d * Real.exp (a / 2)) ^ 2 := by
    have habs :
        |Real.exp (a / 2) - Real.exp (b / 2)| ≤
          |d * Real.exp (a / 2)| := by
      simpa [abs_of_nonneg hdiff_nonneg, abs_of_nonneg hrhs_nonneg]
        using hdiff_le
    exact (sq_le_sq).mpr habs
  have hexp_sq : Real.exp (a / 2) ^ 2 = Real.exp a := by
    rw [pow_two, ← Real.exp_add]
    congr 1
    ring
  calc
    (Real.exp (a / 2) - Real.exp (b / 2)) ^ 2
        ≤ (d * Real.exp (a / 2)) ^ 2 := hsq
    _ = d ^ 2 * Real.exp (a / 2) ^ 2 := by ring
    _ = d ^ 2 * Real.exp a := by rw [hexp_sq]
    _ = ((a - b) ^ 2 / 4) * Real.exp a := by
        dsimp [d]
        ring

/-- Two-sided positive-drop form of the ordered half-exponential bound.

For `lam >= 0`, the half-tilt difference across two values is bounded by the
larger orientation's positive drop and exponential weight. -/
lemma real_exp_half_sub_sq_le_lam_sq_quarter_pair_pos
    {lam x y : ℝ} (hlam : 0 ≤ lam) :
    (Real.exp ((lam * x) / 2) - Real.exp ((lam * y) / 2)) ^ 2 ≤
      (lam ^ 2 / 4) *
        (Real.exp (lam * x) * (max (x - y) 0) ^ 2 +
          Real.exp (lam * y) * (max (y - x) 0) ^ 2) := by
  rcases le_total x y with hxy | hyx
  · have hlamxy : lam * x ≤ lam * y :=
      mul_le_mul_of_nonneg_left hxy hlam
    have hordered :=
      real_exp_half_sub_sq_le_quarter_mul_sq_mul_exp_of_le hlamxy
    have hsq_comm :
        (Real.exp ((lam * x) / 2) - Real.exp ((lam * y) / 2)) ^ 2 =
          (Real.exp ((lam * y) / 2) - Real.exp ((lam * x) / 2)) ^ 2 := by
      ring
    have hxmax : max (x - y) 0 = 0 := by
      exact max_eq_right (sub_nonpos.mpr hxy)
    have hymax : max (y - x) 0 = y - x := by
      exact max_eq_left (sub_nonneg.mpr hxy)
    calc
      (Real.exp ((lam * x) / 2) - Real.exp ((lam * y) / 2)) ^ 2
          =
        (Real.exp ((lam * y) / 2) - Real.exp ((lam * x) / 2)) ^ 2 := hsq_comm
      _ ≤ ((lam * y - lam * x) ^ 2 / 4) * Real.exp (lam * y) := hordered
      _ =
        (lam ^ 2 / 4) *
          (Real.exp (lam * x) * (max (x - y) 0) ^ 2 +
            Real.exp (lam * y) * (max (y - x) 0) ^ 2) := by
          rw [hxmax, hymax]
          ring
  · have hlamyx : lam * y ≤ lam * x :=
      mul_le_mul_of_nonneg_left hyx hlam
    have hordered :=
      real_exp_half_sub_sq_le_quarter_mul_sq_mul_exp_of_le hlamyx
    have hxmax : max (x - y) 0 = x - y := by
      exact max_eq_left (sub_nonneg.mpr hyx)
    have hymax : max (y - x) 0 = 0 := by
      exact max_eq_right (sub_nonpos.mpr hyx)
    calc
      (Real.exp ((lam * x) / 2) - Real.exp ((lam * y) / 2)) ^ 2
          ≤ ((lam * x - lam * y) ^ 2 / 4) * Real.exp (lam * x) := hordered
      _ =
        (lam ^ 2 / 4) *
          (Real.exp (lam * x) * (max (x - y) 0) ^ 2 +
            Real.exp (lam * y) * (max (y - x) 0) ^ 2) := by
          rw [hxmax, hymax]
          ring

/-- Squared exponential half-tilt difference bound.

This is the scalar estimate used to convert a coordinate-difference bound for
`X` into a pointwise pair bound for `exp (X / 2)`. -/
lemma real_exp_half_sub_sq_le_two_mul_half_diff_sq (a b : ℝ) :
    (Real.exp (a / 2) - Real.exp (b / 2)) ^ 2 ≤
      2 * ((a / 2) - (b / 2)) ^ 2 *
        (Real.exp a + Real.exp b) := by
  let x : ℝ := a / 2
  let y : ℝ := b / 2
  have h_abs :=
    real_abs_exp_sub_exp_le_abs_sub_mul_exp_add_exp x y
  have hM_nonneg :
      0 ≤ |x - y| * (Real.exp x + Real.exp y) := by
    positivity
  have hsq_abs :
      (Real.exp x - Real.exp y) ^ 2 ≤
        (|x - y| * (Real.exp x + Real.exp y)) ^ 2 := by
    have h_abs_to_abs :
        |Real.exp x - Real.exp y| ≤
          |(|x - y| * (Real.exp x + Real.exp y))| := by
      rwa [abs_of_nonneg hM_nonneg]
    have hsq := (sq_le_sq).mpr h_abs_to_abs
    simpa [sq_abs] using hsq
  have hsum_sq :
      (Real.exp x + Real.exp y) ^ 2 ≤
        2 * (Real.exp a + Real.exp b) := by
    have hbase :
        (Real.exp x + Real.exp y) ^ 2 ≤
          2 * (Real.exp x ^ 2 + Real.exp y ^ 2) := add_sq_le
    have hx : Real.exp x ^ 2 = Real.exp a := by
      dsimp [x]
      rw [pow_two, ← Real.exp_add]
      congr 1
      ring
    have hy : Real.exp y ^ 2 = Real.exp b := by
      dsimp [y]
      rw [pow_two, ← Real.exp_add]
      congr 1
      ring
    simpa [hx, hy] using hbase
  calc
    (Real.exp (a / 2) - Real.exp (b / 2)) ^ 2 =
        (Real.exp x - Real.exp y) ^ 2 := by rfl
    _ ≤ (|x - y| * (Real.exp x + Real.exp y)) ^ 2 := hsq_abs
    _ = (x - y) ^ 2 * (Real.exp x + Real.exp y) ^ 2 := by
        rw [mul_pow, sq_abs]
    _ ≤ (x - y) ^ 2 * (2 * (Real.exp a + Real.exp b)) := by
        exact mul_le_mul_of_nonneg_left hsum_sq (sq_nonneg (x - y))
    _ = 2 * ((a / 2) - (b / 2)) ^ 2 *
        (Real.exp a + Real.exp b) := by
        dsimp [x, y]
        ring

/-- A lightweight finite probability space, represented by a real mass function
    over a finite type. -/
structure FiniteProbability (Ω : Type*) [Fintype Ω] where
  prob : Ω → ℝ
  prob_nonneg : ∀ ω, 0 ≤ prob ω
  prob_sum : ∑ ω, prob ω = 1

namespace FiniteProbability

variable {Ω : Type*} [Fintype Ω]

/-- Finite probability spaces are equal when their mass functions are equal. -/
@[ext]
theorem ext {P Q : FiniteProbability Ω}
    (hprob : ∀ ω, P.prob ω = Q.prob ω) : P = Q := by
  cases P with
  | mk p hp hsum =>
      cases Q with
      | mk q hq qsum =>
          have hpq : p = q := funext hprob
          subst q
          simp

/-- Probability of an event in a finite probability space. -/
noncomputable def eventProb (P : FiniteProbability Ω) (E : Set Ω) : ℝ :=
  by
    classical
    exact ∑ ω, if ω ∈ E then P.prob ω else 0

/-- Expectation of a natural-valued random variable, coerced to `ℝ`. -/
noncomputable def expectationNat (P : FiniteProbability Ω) (X : Ω → ℕ) : ℝ :=
  ∑ ω, P.prob ω * (X ω : ℝ)

/-- Expectation of a real-valued random variable. -/
noncomputable def expectationReal (P : FiniteProbability Ω) (X : Ω → ℝ) : ℝ :=
  ∑ ω, P.prob ω * X ω

theorem expectationReal_sum {ι : Type*} [Fintype ι]
    (P : FiniteProbability Ω) (X : ι → Ω → ℝ) :
    P.expectationReal (fun ω => ∑ i, X i ω) =
      ∑ i, P.expectationReal (fun ω => X i ω) := by
  classical
  unfold expectationReal
  calc
    ∑ ω, P.prob ω * (∑ i, X i ω)
        = ∑ ω, ∑ i, P.prob ω * X i ω := by
            apply Finset.sum_congr rfl
            intro ω _
            rw [Finset.mul_sum]
    _ = ∑ i, ∑ ω, P.prob ω * X i ω := by
            rw [Finset.sum_comm]

theorem expectationReal_const (P : FiniteProbability Ω) (c : ℝ) :
    P.expectationReal (fun _ => c) = c := by
  classical
  unfold expectationReal
  calc
    ∑ ω, P.prob ω * c = (∑ ω, P.prob ω) * c := by
        rw [Finset.sum_mul]
    _ = c := by
        rw [P.prob_sum]
        ring

/-- The expectation of a real-valued event indicator is the event
probability. -/
theorem expectationReal_indicator_eq_eventProb
    (P : FiniteProbability Ω) (E : Set Ω)
    [DecidablePred (fun ω => ω ∈ E)] :
    P.expectationReal (fun ω => if ω ∈ E then (1 : ℝ) else 0) =
      P.eventProb E := by
  unfold expectationReal eventProb
  apply Finset.sum_congr rfl
  intro ω _
  by_cases hω : ω ∈ E
  · simp [hω]
  · simp [hω]

/-- Every finite probability law has at least one atom of positive mass.

This tiny support lemma is useful when turning pointwise strict positivity
into strict positivity of a finite matrix-valued expectation. -/
theorem exists_prob_pos (P : FiniteProbability Ω) :
    ∃ ω, 0 < P.prob ω := by
  classical
  by_contra h
  push_neg at h
  have hsum_nonpos : (∑ ω, P.prob ω) ≤ 0 :=
    Finset.sum_nonpos (fun ω _ => h ω)
  have hsum_nonneg : 0 ≤ (∑ ω, P.prob ω) :=
    Finset.sum_nonneg (fun ω _ => P.prob_nonneg ω)
  have hsum_zero : (∑ ω, P.prob ω) = 0 :=
    le_antisymm hsum_nonpos hsum_nonneg
  have : (1 : ℝ) = 0 := by
    rw [← P.prob_sum, hsum_zero]
  linarith

theorem expectationReal_add (P : FiniteProbability Ω) (X Y : Ω → ℝ) :
    P.expectationReal (fun ω => X ω + Y ω) =
      P.expectationReal X + P.expectationReal Y := by
  classical
  unfold expectationReal
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro ω _
  ring

theorem expectationReal_sub (P : FiniteProbability Ω) (X Y : Ω → ℝ) :
    P.expectationReal (fun ω => X ω - Y ω) =
      P.expectationReal X - P.expectationReal Y := by
  classical
  unfold expectationReal
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro ω _
  ring

theorem expectationReal_mul_const (P : FiniteProbability Ω) (X : Ω → ℝ) (c : ℝ) :
    P.expectationReal (fun ω => X ω * c) = P.expectationReal X * c := by
  classical
  unfold expectationReal
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro ω _
  ring

theorem expectationReal_const_mul (P : FiniteProbability Ω) (X : Ω → ℝ) (c : ℝ) :
    P.expectationReal (fun ω => c * X ω) = c * P.expectationReal X := by
  classical
  unfold expectationReal
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ω _
  ring

/-- Monotonicity of expectation on a finite probability space. -/
theorem expectationReal_mono (P : FiniteProbability Ω) {X Y : Ω → ℝ}
    (hXY : ∀ ω, X ω ≤ Y ω) :
    P.expectationReal X ≤ P.expectationReal Y := by
  classical
  unfold expectationReal
  apply Finset.sum_le_sum
  intro ω _
  exact mul_le_mul_of_nonneg_left (hXY ω) (P.prob_nonneg ω)

/-- Finite Jensen inequality for concave real-valued functions under a
repository-native finite probability law.

This is the finite-probability wrapper around mathlib's
`ConcaveOn.le_map_sum`.  It is useful for the Lieb/Tropp trace-MGF route, where
Lieb's theorem supplies the concavity hypothesis and the probability weights
come from `FiniteProbability`. -/
theorem expectationReal_le_of_concaveOn
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (P : FiniteProbability Ω) {s : Set E} {f : E → ℝ} {X : Ω → E}
    (hf : ConcaveOn ℝ s f) (hX : ∀ ω, X ω ∈ s) :
    P.expectationReal (fun ω => f (X ω)) ≤
      f (∑ ω, P.prob ω • X ω) := by
  classical
  unfold expectationReal
  simpa using
    (hf.le_map_sum (t := Finset.univ) (w := fun ω => P.prob ω) (p := X)
      (fun ω _ => P.prob_nonneg ω)
      (by simpa using P.prob_sum)
      (fun ω _ => hX ω))

/-- Absolute value of a finite expectation is bounded by the expectation of
    the absolute value. -/
theorem abs_expectationReal_le_expectationReal_abs
    (P : FiniteProbability Ω) (X : Ω → ℝ) :
    |P.expectationReal X| ≤ P.expectationReal (fun ω => |X ω|) := by
  classical
  unfold expectationReal
  calc
    |∑ ω, P.prob ω * X ω|
        ≤ ∑ ω : Ω, |P.prob ω * X ω| := Finset.abs_sum_le_sum_abs _ _
    _ = ∑ ω : Ω, P.prob ω * |X ω| := by
        apply Finset.sum_congr rfl
        intro ω _
        rw [abs_mul, abs_of_nonneg (P.prob_nonneg ω)]

/-- Finite Cauchy--Schwarz for expectations:
    `(E Z)^2 ≤ E[Z^2]`. -/
theorem expectationReal_sq_le_expectationReal_sq
    (P : FiniteProbability Ω) (Z : Ω → ℝ) :
    P.expectationReal Z ^ 2 ≤ P.expectationReal (fun ω => Z ω ^ 2) := by
  classical
  have hcs := Finset.sum_mul_sq_le_sq_mul_sq
    (s := (Finset.univ : Finset Ω))
    (f := fun ω => Real.sqrt (P.prob ω))
    (g := fun ω => Real.sqrt (P.prob ω) * Z ω)
  have hleft :
      (∑ ω : Ω, Real.sqrt (P.prob ω) *
        (Real.sqrt (P.prob ω) * Z ω)) = P.expectationReal Z := by
    unfold expectationReal
    apply Finset.sum_congr rfl
    intro ω _
    rw [← mul_assoc, Real.mul_self_sqrt (P.prob_nonneg ω)]
  have hfirst :
      (∑ ω : Ω, Real.sqrt (P.prob ω) ^ 2) = 1 := by
    calc
      ∑ ω : Ω, Real.sqrt (P.prob ω) ^ 2
          = ∑ ω : Ω, P.prob ω := by
              apply Finset.sum_congr rfl
              intro ω _
              exact Real.sq_sqrt (P.prob_nonneg ω)
      _ = 1 := P.prob_sum
  have hsecond :
      (∑ ω : Ω, (Real.sqrt (P.prob ω) * Z ω) ^ 2) =
        P.expectationReal (fun ω => Z ω ^ 2) := by
    unfold expectationReal
    apply Finset.sum_congr rfl
    intro ω _
    rw [mul_pow, Real.sq_sqrt (P.prob_nonneg ω)]
  rw [hleft, hfirst, hsecond] at hcs
  simpa using hcs

/-- Finite Jensen/Cauchy corollary for nonnegative random variables:
    `E Z ≤ sqrt(E[Z^2])`. -/
theorem expectationReal_le_sqrt_expectationReal_sq
    (P : FiniteProbability Ω) (Z : Ω → ℝ) (hZ : ∀ ω, 0 ≤ Z ω) :
    P.expectationReal Z ≤ Real.sqrt (P.expectationReal (fun ω => Z ω ^ 2)) := by
  have hsq := expectationReal_sq_le_expectationReal_sq P Z
  have hEZ_nonneg : 0 ≤ P.expectationReal Z := by
    unfold expectationReal
    exact Finset.sum_nonneg fun ω _ =>
      mul_nonneg (P.prob_nonneg ω) (hZ ω)
  have hEZ2_nonneg : 0 ≤ P.expectationReal (fun ω => Z ω ^ 2) := by
    unfold expectationReal
    exact Finset.sum_nonneg fun ω _ =>
      mul_nonneg (P.prob_nonneg ω) (sq_nonneg (Z ω))
  have hsq_sqrt : P.expectationReal Z ^ 2 ≤
      (Real.sqrt (P.expectationReal (fun ω => Z ω ^ 2))) ^ 2 := by
    rw [Real.sq_sqrt hEZ2_nonneg]
    exact hsq
  have habs := (sq_le_sq).mp hsq_sqrt
  simpa [abs_of_nonneg hEZ_nonneg, abs_of_nonneg (Real.sqrt_nonneg _)] using habs

/-- A square has nonnegative finite expectation. -/
theorem expectationReal_sq_nonneg
    (P : FiniteProbability Ω) (Z : Ω → ℝ) :
    0 ≤ P.expectationReal (fun ω => Z ω ^ 2) := by
  unfold expectationReal
  exact Finset.sum_nonneg fun ω _ =>
    mul_nonneg (P.prob_nonneg ω) (sq_nonneg (Z ω))

/-- Finite Cauchy--Schwarz for mixed second moments. -/
theorem abs_expectationReal_mul_le_sqrt_mul_sqrt
    (P : FiniteProbability Ω) (X Y : Ω → ℝ) :
    |P.expectationReal (fun ω => X ω * Y ω)| ≤
      Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) *
        Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2)) := by
  classical
  have hcs := Finset.sum_mul_sq_le_sq_mul_sq
    (s := (Finset.univ : Finset Ω))
    (f := fun ω => Real.sqrt (P.prob ω) * X ω)
    (g := fun ω => Real.sqrt (P.prob ω) * Y ω)
  have hleft :
      (∑ ω : Ω,
        (Real.sqrt (P.prob ω) * X ω) *
          (Real.sqrt (P.prob ω) * Y ω)) =
        P.expectationReal (fun ω => X ω * Y ω) := by
    unfold expectationReal
    apply Finset.sum_congr rfl
    intro ω _
    calc
      (Real.sqrt (P.prob ω) * X ω) *
          (Real.sqrt (P.prob ω) * Y ω)
          = (Real.sqrt (P.prob ω) * Real.sqrt (P.prob ω)) *
              (X ω * Y ω) := by ring
      _ = P.prob ω * (X ω * Y ω) := by
            rw [Real.mul_self_sqrt (P.prob_nonneg ω)]
  have hfirst :
      (∑ ω : Ω, (Real.sqrt (P.prob ω) * X ω) ^ 2) =
        P.expectationReal (fun ω => X ω ^ 2) := by
    unfold expectationReal
    apply Finset.sum_congr rfl
    intro ω _
    rw [mul_pow, Real.sq_sqrt (P.prob_nonneg ω)]
  have hsecond :
      (∑ ω : Ω, (Real.sqrt (P.prob ω) * Y ω) ^ 2) =
        P.expectationReal (fun ω => Y ω ^ 2) := by
    unfold expectationReal
    apply Finset.sum_congr rfl
    intro ω _
    rw [mul_pow, Real.sq_sqrt (P.prob_nonneg ω)]
  rw [hleft, hfirst, hsecond] at hcs
  have hX_nonneg := expectationReal_sq_nonneg P X
  have hY_nonneg := expectationReal_sq_nonneg P Y
  have hprod_nonneg :
      0 ≤ Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) *
        Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2)) :=
    mul_nonneg (Real.sqrt_nonneg _) (Real.sqrt_nonneg _)
  have hrewrite :
      P.expectationReal (fun ω => X ω ^ 2) *
          P.expectationReal (fun ω => Y ω ^ 2) =
        (Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) *
          Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))) ^ 2 := by
    rw [show
        (Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) *
          Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))) ^ 2 =
          (Real.sqrt (P.expectationReal (fun ω => X ω ^ 2))) ^ 2 *
            (Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))) ^ 2 from by ring,
      Real.sq_sqrt hX_nonneg, Real.sq_sqrt hY_nonneg]
  rw [hrewrite] at hcs
  have hupper :
      P.expectationReal (fun ω => X ω * Y ω) ≤
        Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) *
          Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2)) := by
    nlinarith [sq_abs (P.expectationReal (fun ω => X ω * Y ω))]
  have hlower :
      -(Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) *
          Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))) ≤
        P.expectationReal (fun ω => X ω * Y ω) := by
    nlinarith [sq_abs (P.expectationReal (fun ω => X ω * Y ω))]
  exact abs_le.mpr ⟨hlower, hupper⟩

/-- Triangle inequality for the finite probability `L²` seminorm. -/
theorem sqrt_expectationReal_sq_add_le
    (P : FiniteProbability Ω) (X Y : Ω → ℝ) :
    Real.sqrt (P.expectationReal (fun ω => (X ω + Y ω) ^ 2)) ≤
      Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) +
        Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2)) := by
  classical
  have hcross := abs_expectationReal_mul_le_sqrt_mul_sqrt P X Y
  have hcross_le :
      P.expectationReal (fun ω => X ω * Y ω) ≤
        Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) *
          Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2)) :=
    (abs_le.mp hcross).2
  have hsum :
      P.expectationReal (fun ω => (X ω + Y ω) ^ 2) =
        P.expectationReal (fun ω => X ω ^ 2) +
          2 * P.expectationReal (fun ω => X ω * Y ω) +
            P.expectationReal (fun ω => Y ω ^ 2) := by
    unfold expectationReal
    calc
      ∑ ω : Ω, P.prob ω * (X ω + Y ω) ^ 2 =
          ∑ ω : Ω,
            (P.prob ω * X ω ^ 2 +
              2 * (P.prob ω * (X ω * Y ω)) +
                P.prob ω * Y ω ^ 2) := by
            apply Finset.sum_congr rfl
            intro ω _
            ring
      _ =
          (∑ ω : Ω, P.prob ω * X ω ^ 2) +
            2 * (∑ ω : Ω, P.prob ω * (X ω * Y ω)) +
              (∑ ω : Ω, P.prob ω * Y ω ^ 2) := by
            rw [Finset.sum_add_distrib, Finset.sum_add_distrib,
              ← Finset.mul_sum]
  have hleft_nonneg :
      0 ≤ P.expectationReal (fun ω => (X ω + Y ω) ^ 2) :=
    expectationReal_sq_nonneg P (fun ω => X ω + Y ω)
  have hright_nonneg :
      0 ≤ Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) +
        Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2)) :=
    add_nonneg (Real.sqrt_nonneg _) (Real.sqrt_nonneg _)
  rw [← Real.sqrt_sq hright_nonneg]
  apply Real.sqrt_le_sqrt
  rw [hsum]
  have hX_nonneg := expectationReal_sq_nonneg P X
  have hY_nonneg := expectationReal_sq_nonneg P Y
  rw [show
      (Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) +
        Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))) ^ 2 =
        P.expectationReal (fun ω => X ω ^ 2) +
          2 * (Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) *
            Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))) +
          P.expectationReal (fun ω => Y ω ^ 2) by
        rw [show (Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) +
            Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))) ^ 2 =
            (Real.sqrt (P.expectationReal (fun ω => X ω ^ 2))) ^ 2 +
              2 * (Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) *
                Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))) +
              (Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))) ^ 2 from by ring,
          Real.sq_sqrt hX_nonneg, Real.sq_sqrt hY_nonneg]]
  linarith

/-- Reverse triangle inequality for the finite probability `L²` seminorm.

This is the L2-section norm bridge needed in the Bernoulli-cube tensorization
route: the map `X ↦ sqrt(E X^2)` is 1-Lipschitz with respect to the same
finite `L²` seminorm. -/
theorem abs_sqrt_expectationReal_sq_sub_le_sqrt_expectationReal_sub_sq
    (P : FiniteProbability Ω) (X Y : Ω → ℝ) :
    |Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) -
        Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2))| ≤
      Real.sqrt (P.expectationReal (fun ω => (X ω - Y ω) ^ 2)) := by
  have hxy0 := sqrt_expectationReal_sq_add_le P
    (fun ω => X ω - Y ω) Y
  have hxy :
      Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) ≤
        Real.sqrt (P.expectationReal (fun ω => (X ω - Y ω) ^ 2)) +
          Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2)) := by
    have hx :
        (fun ω => ((X ω - Y ω) + Y ω) ^ 2) =
          fun ω => X ω ^ 2 := by
      funext ω
      ring
    simpa [hx] using hxy0
  have hyx0 := sqrt_expectationReal_sq_add_le P
    (fun ω => Y ω - X ω) X
  have hdiff :
      P.expectationReal (fun ω => (Y ω - X ω) ^ 2) =
        P.expectationReal (fun ω => (X ω - Y ω) ^ 2) := by
    apply congrArg P.expectationReal
    funext ω
    ring
  have hyx :
      Real.sqrt (P.expectationReal (fun ω => Y ω ^ 2)) ≤
        Real.sqrt (P.expectationReal (fun ω => (X ω - Y ω) ^ 2)) +
          Real.sqrt (P.expectationReal (fun ω => X ω ^ 2)) := by
    have hy :
        (fun ω => ((Y ω - X ω) + X ω) ^ 2) =
          fun ω => Y ω ^ 2 := by
      funext ω
      ring
    simpa [hy, hdiff] using hyx0
  exact abs_le.mpr ⟨by linarith, by linarith⟩

-- ============================================================
-- Finite exponential moments and entropy algebra
-- ============================================================

/-- Positivity of a finite exponential moment under a probability law. -/
theorem expectationReal_exp_pos
    (P : FiniteProbability Ω) (X : Ω → ℝ) (lam : ℝ) :
    0 < P.expectationReal (fun ω => Real.exp (lam * X ω)) := by
  classical
  rcases P.exists_prob_pos with ⟨ω₀, hω₀⟩
  unfold expectationReal
  have hterm_pos :
      0 < P.prob ω₀ * Real.exp (lam * X ω₀) :=
    mul_pos hω₀ (Real.exp_pos _)
  have hterm_nonneg :
      ∀ ω, 0 ≤ P.prob ω * Real.exp (lam * X ω) := by
    intro ω
    exact mul_nonneg (P.prob_nonneg ω) (le_of_lt (Real.exp_pos _))
  have hle :
      P.prob ω₀ * Real.exp (lam * X ω₀) ≤
        ∑ ω, P.prob ω * Real.exp (lam * X ω) :=
    Finset.single_le_sum (fun ω _ => hterm_nonneg ω) (Finset.mem_univ ω₀)
  exact lt_of_lt_of_le hterm_pos hle

/-- Derivative of a finite real exponential moment. -/
theorem hasDerivAt_expectationReal_exp_mul
    (P : FiniteProbability Ω) (X : Ω → ℝ) (lam : ℝ) :
    HasDerivAt
      (fun t : ℝ => P.expectationReal (fun ω => Real.exp (t * X ω)))
      (P.expectationReal (fun ω => X ω * Real.exp (lam * X ω))) lam := by
  classical
  unfold expectationReal
  have hsum :
      HasDerivAt
        (fun t : ℝ => ∑ ω : Ω, P.prob ω * Real.exp (t * X ω))
        (∑ ω : Ω, P.prob ω * (Real.exp (lam * X ω) * X ω)) lam := by
    apply HasDerivAt.fun_sum
    intro ω _
    have hlin : HasDerivAt (fun t : ℝ => t * X ω) (X ω) lam := by
      simpa using (hasDerivAt_id lam).mul_const (X ω)
    have hexp :
        HasDerivAt (fun t : ℝ => Real.exp (t * X ω))
          (Real.exp (lam * X ω) * X ω) lam :=
      hlin.exp
    simpa [mul_assoc] using (HasDerivAt.const_mul (P.prob ω) hexp)
  simpa [mul_comm, mul_left_comm, mul_assoc] using hsum

/-- Log-derivative of a finite real exponential moment. -/
theorem hasDerivAt_log_expectationReal_exp_mul
    (P : FiniteProbability Ω) (X : Ω → ℝ) (lam : ℝ) :
    HasDerivAt
      (fun t : ℝ =>
        Real.log (P.expectationReal (fun ω => Real.exp (t * X ω))))
      (P.expectationReal (fun ω => X ω * Real.exp (lam * X ω)) /
        P.expectationReal (fun ω => Real.exp (lam * X ω))) lam := by
  have hderiv := hasDerivAt_expectationReal_exp_mul P X lam
  have hpos := expectationReal_exp_pos P X lam
  exact hderiv.log (ne_of_gt hpos)

/-- Finite entropy functional, in the elementary real form used by the
Herbst/log-Sobolev route. -/
noncomputable def entropyReal (P : FiniteProbability Ω) (Z : Ω → ℝ) : ℝ :=
  P.expectationReal (fun ω => Z ω * Real.log (Z ω)) -
    P.expectationReal Z * Real.log (P.expectationReal Z)

/-- A constant random variable has zero finite entropy. -/
theorem entropyReal_const (P : FiniteProbability Ω) (c : ℝ) :
    entropyReal P (fun _ => c) = 0 := by
  unfold entropyReal
  rw [expectationReal_const, expectationReal_const]
  ring

/-- The unbiased Bernoulli coordinate law on `Bool`.

This is the coordinate probability measure used when specializing finite
product-law entropy algebra to the Bernoulli cube in the Ledoux route. -/
noncomputable def boolUniformProbability : FiniteProbability Bool where
  prob := fun _ => (1 : ℝ) / 2
  prob_nonneg := by
    intro _
    norm_num
  prob_sum := by
    simp [Fintype.univ_bool]

theorem boolUniformProbability_prob (b : Bool) :
    boolUniformProbability.prob b = (1 : ℝ) / 2 := rfl

/-- Expectation under the unbiased Bernoulli coordinate law. -/
theorem boolUniformProbability_expectationReal (X : Bool → ℝ) :
    boolUniformProbability.expectationReal X =
      (X false + X true) / 2 := by
  unfold expectationReal boolUniformProbability
  simp [Fintype.univ_bool]
  ring

/-- Entropy under the unbiased Bernoulli coordinate law, expanded into the
two coordinate values. -/
theorem entropyReal_boolUniformProbability_eq (Z : Bool → ℝ) :
    entropyReal boolUniformProbability Z =
      (Z false * Real.log (Z false) + Z true * Real.log (Z true)) / 2 -
        ((Z false + Z true) / 2) *
          Real.log ((Z false + Z true) / 2) := by
  unfold entropyReal
  rw [boolUniformProbability_expectationReal
    (fun b => Z b * Real.log (Z b))]
  rw [boolUniformProbability_expectationReal Z]

/-- Bool-coordinate specialization of the finite probability `L²` reverse
triangle inequality. -/
theorem boolUniformProbability_abs_sqrt_expectationReal_sq_sub_le_sqrt_expectationReal_sub_sq
    (u v : Bool → ℝ) :
    |Real.sqrt (boolUniformProbability.expectationReal (fun b => u b ^ 2)) -
        Real.sqrt (boolUniformProbability.expectationReal (fun b => v b ^ 2))| ≤
      Real.sqrt
        (boolUniformProbability.expectationReal (fun b => (u b - v b) ^ 2)) :=
  abs_sqrt_expectationReal_sq_sub_le_sqrt_expectationReal_sub_sq
    boolUniformProbability u v

/-- Two-point entropy bound from the elementary inequality
`log x <= x - 1`.

For positive masses `a` and `b`, this bounds the entropy of the two-point
function by its chi-square scale.  It is the scalar estimate used below for the
Bernoulli coordinate log-Sobolev step. -/
theorem twoPointEntropy_le_sq_sub_div_of_pos
    {a b : ℝ} (ha : 0 < a) (hb : 0 < b) :
    (a * Real.log a + b * Real.log b) / 2 -
        ((a + b) / 2) * Real.log ((a + b) / 2) ≤
      (a - b) ^ 2 / (2 * (a + b)) := by
  let m : ℝ := (a + b) / 2
  have hm_pos : 0 < m := by
    dsimp [m]
    linarith
  have hloga : Real.log (a / m) ≤ a / m - 1 :=
    Real.log_le_sub_one_of_pos (div_pos ha hm_pos)
  have hlogb : Real.log (b / m) ≤ b / m - 1 :=
    Real.log_le_sub_one_of_pos (div_pos hb hm_pos)
  have ha_mul :
      a * Real.log (a / m) ≤ a * (a / m - 1) :=
    mul_le_mul_of_nonneg_left hloga ha.le
  have hb_mul :
      b * Real.log (b / m) ≤ b * (b / m - 1) :=
    mul_le_mul_of_nonneg_left hlogb hb.le
  have hsum :
      a * Real.log (a / m) + b * Real.log (b / m) ≤
        a * (a / m - 1) + b * (b / m - 1) := by
    exact add_le_add ha_mul hb_mul
  have hleft :
      (a * Real.log a + b * Real.log b) / 2 -
          m * Real.log m =
        (a * Real.log (a / m) + b * Real.log (b / m)) / 2 := by
    have hloga_eq : Real.log (a / m) = Real.log a - Real.log m :=
      Real.log_div (ne_of_gt ha) (ne_of_gt hm_pos)
    have hlogb_eq : Real.log (b / m) = Real.log b - Real.log m :=
      Real.log_div (ne_of_gt hb) (ne_of_gt hm_pos)
    rw [hloga_eq, hlogb_eq]
    dsimp [m]
    ring
  have hright :
      (a * (a / m - 1) + b * (b / m - 1)) / 2 =
        (a - b) ^ 2 / (2 * (a + b)) := by
    dsimp [m]
    field_simp [show a + b ≠ 0 by linarith]
    ring
  calc
    (a * Real.log a + b * Real.log b) / 2 -
        ((a + b) / 2) * Real.log ((a + b) / 2)
        = (a * Real.log a + b * Real.log b) / 2 -
            m * Real.log m := by rfl
    _ = (a * Real.log (a / m) + b * Real.log (b / m)) / 2 := hleft
    _ ≤ (a * (a / m - 1) + b * (b / m - 1)) / 2 := by
          exact div_le_div_of_nonneg_right hsum (by norm_num)
    _ = (a - b) ^ 2 / (2 * (a + b)) := hright

/-- Two-point Bernoulli log-Sobolev inequality for positive functions.

This is the first actual coordinate log-Sobolev dependency on the
Ledoux/Tropp route.  It is stated for strictly positive functions, matching
Ledoux's `g^2 > 0` hypothesis. -/
theorem entropyReal_boolUniformProbability_sq_le_sq_sub_of_pos
    (g : Bool → ℝ) (hg : ∀ b, 0 < g b) :
    entropyReal boolUniformProbability (fun b => g b ^ 2) ≤
      (g true - g false) ^ 2 := by
  have hscalar :=
    twoPointEntropy_le_sq_sub_div_of_pos
      (a := g false ^ 2) (b := g true ^ 2)
      (sq_pos_of_pos (hg false)) (sq_pos_of_pos (hg true))
  rw [entropyReal_boolUniformProbability_eq]
  have hden_pos : 0 < 2 * (g false ^ 2 + g true ^ 2) := by
    nlinarith [sq_pos_of_pos (hg false), sq_pos_of_pos (hg true)]
  have hsum_pos : 0 < g false ^ 2 + g true ^ 2 := by
    nlinarith [sq_pos_of_pos (hg false), sq_pos_of_pos (hg true)]
  have hratio :
      ((g false ^ 2 - g true ^ 2) ^ 2) /
          (2 * (g false ^ 2 + g true ^ 2)) ≤
        (g true - g false) ^ 2 := by
    have hsum_sq :
        (g false + g true) ^ 2 ≤ 2 * (g false ^ 2 + g true ^ 2) := by
      nlinarith [sq_nonneg (g false - g true)]
    have hnonneg : 0 ≤ (g false - g true) ^ 2 := sq_nonneg _
    rw [sq_sub_sq]
    rw [mul_pow]
    have hdiv :
        ((g false + g true) ^ 2 * (g false - g true) ^ 2) /
            (2 * (g false ^ 2 + g true ^ 2)) ≤
          ((2 * (g false ^ 2 + g true ^ 2)) *
              (g false - g true) ^ 2) /
            (2 * (g false ^ 2 + g true ^ 2)) := by
      exact div_le_div_of_nonneg_right
        (mul_le_mul_of_nonneg_right hsum_sq hnonneg) hden_pos.le
    have hsimp :
        ((2 * (g false ^ 2 + g true ^ 2)) *
            (g false - g true) ^ 2) /
          (2 * (g false ^ 2 + g true ^ 2)) =
        (g true - g false) ^ 2 := by
      field_simp [ne_of_gt hden_pos, ne_of_gt hsum_pos]
      ring
    exact hdiv.trans_eq hsimp
  exact hscalar.trans hratio

/-- Entropy of an exponential tilt, expanded as the usual
`λ E[X exp(λX)] - E[exp(λX)] log E[exp(λX)]` identity. -/
theorem entropyReal_exp_mul_eq
    (P : FiniteProbability Ω) (X : Ω → ℝ) (lam : ℝ) :
    entropyReal P (fun ω => Real.exp (lam * X ω)) =
      lam * P.expectationReal (fun ω => X ω * Real.exp (lam * X ω)) -
        P.expectationReal (fun ω => Real.exp (lam * X ω)) *
          Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) := by
  unfold entropyReal expectationReal
  congr 1
  calc
    ∑ ω : Ω, P.prob ω *
        (Real.exp (lam * X ω) * Real.log (Real.exp (lam * X ω)))
        = ∑ ω : Ω, P.prob ω * (Real.exp (lam * X ω) * (lam * X ω)) := by
          apply Finset.sum_congr rfl
          intro ω _
          rw [Real.log_exp]
    _ = lam * ∑ ω : Ω, P.prob ω * (X ω * Real.exp (lam * X ω)) := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro ω _
          ring

/-- Pointwise Herbst differential inequality extracted from an exponential
entropy bound.

This theorem is deliberately conditional: it does not prove Ledoux's
log-Sobolev/entropy inequality. It only formalizes the algebraic step turning
such an entropy bound into the usual differential inequality for the
log-moment-generating function. -/
theorem log_mgf_differential_le_of_entropyReal_exp_mul_le
    (P : FiniteProbability Ω) (X : Ω → ℝ) (lam c : ℝ)
    (hEnt :
      entropyReal P (fun ω => Real.exp (lam * X ω)) ≤
        c * lam ^ 2 * P.expectationReal (fun ω => Real.exp (lam * X ω))) :
    lam *
          (P.expectationReal (fun ω => X ω * Real.exp (lam * X ω)) /
            P.expectationReal (fun ω => Real.exp (lam * X ω))) -
        Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) ≤
      c * lam ^ 2 := by
  classical
  let M : ℝ := P.expectationReal (fun ω => Real.exp (lam * X ω))
  let A : ℝ := P.expectationReal (fun ω => X ω * Real.exp (lam * X ω))
  have hMpos : 0 < M := by
    simpa [M] using expectationReal_exp_pos P X lam
  have hEntEq :
      entropyReal P (fun ω => Real.exp (lam * X ω)) =
        lam * A - M * Real.log M := by
    simpa [M, A] using entropyReal_exp_mul_eq P X lam
  have hleft :
      lam * (A / M) - Real.log M =
        entropyReal P (fun ω => Real.exp (lam * X ω)) / M := by
    rw [hEntEq]
    field_simp [hMpos.ne']
  have hdiv :
      entropyReal P (fun ω => Real.exp (lam * X ω)) / M ≤
        (c * lam ^ 2 * M) / M :=
    div_le_div_of_nonneg_right (by simpa [M] using hEnt) (le_of_lt hMpos)
  calc
    lam * (A / M) - Real.log M
        = entropyReal P (fun ω => Real.exp (lam * X ω)) / M := hleft
    _ ≤ (c * lam ^ 2 * M) / M := hdiv
    _ = c * lam ^ 2 := by
        field_simp [hMpos.ne']

/-- Herbst integration, first finite-calculus step.

If the pointwise Herbst differential inequality
`λ (log M)'(λ) - log M(λ) ≤ c λ^2` is available for the finite MGF
`M(λ) = E exp(λX)`, then the corrected quotient
`λ ↦ log M(λ) / λ - c λ` is antitone on positive `λ`.

This is a real integration step on the Ledoux route.  It still does not prove
Ledoux's entropy inequality or the right-limit value at `λ = 0`; those are the
remaining ingredients needed to turn the antitone quotient into the full
log-Laplace estimate. -/
theorem log_mgf_div_sub_quadratic_antitoneOn_of_differential_le
    (P : FiniteProbability Ω) (X : Ω → ℝ) (c : ℝ)
    (hdiff : ∀ lam : ℝ, 0 < lam →
      lam *
          (P.expectationReal (fun ω => X ω * Real.exp (lam * X ω)) /
            P.expectationReal (fun ω => Real.exp (lam * X ω))) -
        Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) ≤
        c * lam ^ 2) :
    AntitoneOn
      (fun lam : ℝ =>
        Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) / lam -
          c * lam)
      (Set.Ioi 0) := by
  classical
  let F : ℝ → ℝ :=
    fun lam => Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω)))
  let A : ℝ → ℝ :=
    fun lam => P.expectationReal (fun ω => X ω * Real.exp (lam * X ω))
  let M : ℝ → ℝ :=
    fun lam => P.expectationReal (fun ω => Real.exp (lam * X ω))
  let G : ℝ → ℝ := fun lam => F lam / lam - c * lam
  have hderivAt : ∀ lam ∈ Set.Ioi (0 : ℝ),
      HasDerivAt G (((A lam / M lam) * lam - F lam) / lam ^ 2 - c) lam := by
    intro lam hlam
    have hlam_ne : lam ≠ 0 := ne_of_gt hlam
    have hF :
        HasDerivAt F (A lam / M lam) lam := by
      simpa [F, A, M] using hasDerivAt_log_expectationReal_exp_mul P X lam
    have hdiv :
        HasDerivAt (fun t : ℝ => F t / t)
          (((A lam / M lam) * lam - F lam * 1) / lam ^ 2) lam := by
      simpa using hF.div (hasDerivAt_id lam) hlam_ne
    have hlin :
        HasDerivAt (fun t : ℝ => c * t) c lam := by
      simpa using (hasDerivAt_id lam).const_mul c
    have hG := hdiv.sub hlin
    simpa [G, one_mul] using hG
  have hcont : ContinuousOn G (Set.Ioi (0 : ℝ)) := by
    intro lam hlam
    exact (hderivAt lam hlam).continuousAt.continuousWithinAt
  have hantiG : AntitoneOn G (Set.Ioi (0 : ℝ)) := by
    refine
      (antitoneOn_of_hasDerivWithinAt_nonpos
        (D := Set.Ioi (0 : ℝ))
        (f := G)
        (f' := fun lam => ((A lam / M lam) * lam - F lam) / lam ^ 2 - c)
        (convex_Ioi (0 : ℝ)) hcont ?_ ?_)
    · intro lam hlam
      rw [interior_Ioi] at hlam
      exact (hderivAt lam hlam).hasDerivWithinAt
    · intro lam hlam
      rw [interior_Ioi] at hlam
      have hlam_sq_pos : 0 < lam ^ 2 := sq_pos_of_pos hlam
      have hbase := hdiff lam hlam
      have hdiv_le :
          ((A lam / M lam) * lam - F lam) / lam ^ 2 ≤ c := by
        rw [div_le_iff₀ hlam_sq_pos]
        simpa [F, A, M, mul_comm, mul_left_comm, mul_assoc] using hbase
      linarith
  simpa [G, F, A, M] using hantiG

/-- Right-limit at zero for the finite log-MGF quotient.

For a real random variable on a finite probability space,
`log E exp(λX) / λ` tends to `E X` as `λ -> 0+`.  This is the
missing endpoint value needed after the corrected-quotient monotonicity step in
Herbst's argument. -/
theorem tendsto_log_mgf_div_nhdsGT_zero
    (P : FiniteProbability Ω) (X : Ω → ℝ) :
    Filter.Tendsto
      (fun lam : ℝ =>
        Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) / lam)
      (nhdsWithin (0 : ℝ) (Set.Ioi 0))
      (nhds (P.expectationReal X)) := by
  classical
  let F : ℝ → ℝ :=
    fun lam => Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω)))
  have hnum :
      P.expectationReal (fun ω => X ω * Real.exp (0 * X ω)) =
        P.expectationReal X := by
    unfold expectationReal
    simp
  have hden :
      P.expectationReal (fun ω => Real.exp (0 * X ω)) = 1 := by
    simpa using expectationReal_const P (1 : ℝ)
  have hden_one :
      P.expectationReal (fun _ : Ω => (1 : ℝ)) = 1 :=
    expectationReal_const P 1
  have hderiv0 :
      HasDerivAt F (P.expectationReal X) 0 := by
    simpa [F, hnum, hden_one] using
      (hasDerivAt_log_expectationReal_exp_mul P X 0)
  have hF0 : F 0 = 0 := by
    calc
      F 0 = Real.log (P.expectationReal (fun _ : Ω => (1 : ℝ))) := by
        simp [F]
      _ = Real.log 1 := by
        rw [hden_one]
      _ = 0 := Real.log_one
  have hslope := hderiv0.tendsto_slope_zero_right
  simpa [F, hF0, div_eq_mul_inv, zero_add, sub_eq_add_neg, mul_comm] using hslope

/-- Finite Herbst extraction from the differential inequality to a
log-Laplace bound.

Once the pointwise Herbst differential inequality is proved for all positive
`λ`, the corrected-quotient monotonicity and the right-limit at zero imply
`log E exp(λX) ≤ λ E X + c λ^2` for every positive `λ`. -/
theorem log_mgf_le_mean_add_quadratic_of_differential_le
    (P : FiniteProbability Ω) (X : Ω → ℝ) (c : ℝ)
    (hdiff : ∀ lam : ℝ, 0 < lam →
      lam *
          (P.expectationReal (fun ω => X ω * Real.exp (lam * X ω)) /
            P.expectationReal (fun ω => Real.exp (lam * X ω))) -
        Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) ≤
        c * lam ^ 2) :
    ∀ lam : ℝ, 0 < lam →
      Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) ≤
        lam * P.expectationReal X + c * lam ^ 2 := by
  classical
  let F : ℝ → ℝ :=
    fun lam => Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω)))
  let G : ℝ → ℝ := fun lam => F lam / lam - c * lam
  have hanti :
      AntitoneOn G (Set.Ioi (0 : ℝ)) := by
    simpa [G, F] using
      (log_mgf_div_sub_quadratic_antitoneOn_of_differential_le P X c hdiff)
  have hlim_base :
      Filter.Tendsto (fun lam : ℝ => F lam / lam)
        (nhdsWithin (0 : ℝ) (Set.Ioi 0))
        (nhds (P.expectationReal X)) := by
    simpa [F] using tendsto_log_mgf_div_nhdsGT_zero P X
  have hlim_linear :
      Filter.Tendsto (fun lam : ℝ => c * lam)
        (nhdsWithin (0 : ℝ) (Set.Ioi 0)) (nhds 0) := by
    have h_id :
        Filter.Tendsto (fun lam : ℝ => lam)
          (nhdsWithin (0 : ℝ) (Set.Ioi 0)) (nhds 0) :=
      (Filter.tendsto_id : Filter.Tendsto (fun lam : ℝ => lam) (nhds 0) (nhds 0)).mono_left
        nhdsWithin_le_nhds
    simpa using h_id.const_mul c
  have hlimG :
      Filter.Tendsto G (nhdsWithin (0 : ℝ) (Set.Ioi 0))
        (nhds (P.expectationReal X)) := by
    simpa [G] using hlim_base.sub hlim_linear
  intro lam hlam
  have hevent :
      ∀ᶠ eps in nhdsWithin (0 : ℝ) (Set.Ioi 0), G lam ≤ G eps := by
    filter_upwards [Ioo_mem_nhdsGT hlam] with eps heps
    exact hanti heps.1 hlam heps.2.le
  have hG_le_mean : G lam ≤ P.expectationReal X :=
    ge_of_tendsto hlimG hevent
  have hquot : F lam / lam ≤ P.expectationReal X + c * lam := by
    dsimp [G] at hG_le_mean
    linarith
  have hmul : F lam ≤ (P.expectationReal X + c * lam) * lam :=
    (div_le_iff₀ hlam).mp hquot
  calc
    Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω)))
        = F lam := rfl
    _ ≤ (P.expectationReal X + c * lam) * lam := hmul
    _ = lam * P.expectationReal X + c * lam ^ 2 := by
        ring

/-- Finite Herbst extraction from an exponential-entropy bound to a
log-Laplace bound.

This is the first endpoint that can consume a future local proof of Ledoux's
finite product-measure entropy inequality.  It does not prove that entropy
inequality; instead, it removes the remaining calculus from the future
Ledoux/Talagrand concentration step. -/
theorem log_mgf_le_mean_add_quadratic_of_entropyReal_exp_mul_le
    (P : FiniteProbability Ω) (X : Ω → ℝ) (c : ℝ)
    (hEnt : ∀ lam : ℝ, 0 < lam →
      entropyReal P (fun ω => Real.exp (lam * X ω)) ≤
        c * lam ^ 2 *
          P.expectationReal (fun ω => Real.exp (lam * X ω))) :
    ∀ lam : ℝ, 0 < lam →
      Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) ≤
        lam * P.expectationReal X + c * lam ^ 2 := by
  refine log_mgf_le_mean_add_quadratic_of_differential_le P X c ?_
  intro lam hlam
  exact
    log_mgf_differential_le_of_entropyReal_exp_mul_le P X lam c
      (hEnt lam hlam)

/-- A log-Laplace bound implies the centered MGF bound used by Chernoff.

This is the finite-probability algebraic step after Herbst/Ledoux has produced
`log E exp(λX) ≤ λ μ + R`. It does not prove that log-Laplace bound. -/
theorem expectationReal_exp_centered_le_exp_of_log_mgf_le
    (P : FiniteProbability Ω) (X : Ω → ℝ) (μ R lam : ℝ)
    (hlog :
      Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) ≤
        lam * μ + R) :
    P.expectationReal (fun ω => Real.exp (lam * (X ω - μ))) ≤
      Real.exp R := by
  classical
  let M : ℝ := P.expectationReal (fun ω => Real.exp (lam * X ω))
  have hMpos : 0 < M := by
    simpa [M] using expectationReal_exp_pos P X lam
  have hM_le : M ≤ Real.exp (lam * μ + R) := by
    exact (Real.log_le_iff_le_exp hMpos).mp (by simpa [M] using hlog)
  have hcenter :
      P.expectationReal (fun ω => Real.exp (lam * (X ω - μ))) =
        Real.exp (-(lam * μ)) * M := by
    calc
      P.expectationReal (fun ω => Real.exp (lam * (X ω - μ)))
          = P.expectationReal
              (fun ω => Real.exp (-(lam * μ)) * Real.exp (lam * X ω)) := by
              apply congrArg
              funext ω
              rw [← Real.exp_add]
              congr 1
              ring
      _ = Real.exp (-(lam * μ)) *
            P.expectationReal (fun ω => Real.exp (lam * X ω)) := by
              rw [expectationReal_const_mul]
      _ = Real.exp (-(lam * μ)) * M := rfl
  calc
    P.expectationReal (fun ω => Real.exp (lam * (X ω - μ)))
        = Real.exp (-(lam * μ)) * M := hcenter
    _ ≤ Real.exp (-(lam * μ)) * Real.exp (lam * μ + R) :=
        mul_le_mul_of_nonneg_left hM_le (le_of_lt (Real.exp_pos _))
    _ = Real.exp R := by
        rw [← Real.exp_add]
        congr 1
        ring

theorem eventProb_nonneg (P : FiniteProbability Ω) (E : Set Ω) :
    0 ≤ P.eventProb E := by
  classical
  unfold eventProb
  exact Finset.sum_nonneg fun ω _ => by
    by_cases hω : ω ∈ E
    · simp [hω, P.prob_nonneg ω]
    · simp [hω]

theorem eventProb_mono (P : FiniteProbability Ω) {E F : Set Ω}
    (hEF : E ⊆ F) :
    P.eventProb E ≤ P.eventProb F := by
  classical
  unfold eventProb
  apply Finset.sum_le_sum
  intro ω _
  by_cases hE : ω ∈ E
  · have hF : ω ∈ F := hEF hE
    simp [hE, hF]
  · by_cases hF : ω ∈ F
    · simp [hE, hF, P.prob_nonneg ω]
    · simp [hE, hF]

/-- The probability mass of an outcome is bounded by the probability of any
event containing that outcome. -/
theorem prob_le_eventProb_of_mem (P : FiniteProbability Ω) {E : Set Ω}
    {ω : Ω} (hω : ω ∈ E) :
    P.prob ω ≤ P.eventProb E := by
  classical
  let S : Set Ω := {η | η = ω}
  have hS : S ⊆ E := by
    intro η hη
    exact hη ▸ hω
  have hsingle : P.eventProb S = P.prob ω := by
    unfold eventProb S
    rw [Finset.sum_eq_single ω]
    · simp
    · intro η _ hη
      simp [hη]
    · intro hnot
      exact (hnot (Finset.mem_univ ω)).elim
  rw [← hsingle]
  exact P.eventProb_mono hS

theorem eventProb_add_eventProb_compl (P : FiniteProbability Ω) (E : Set Ω) :
    P.eventProb E + P.eventProb Eᶜ = 1 := by
  classical
  unfold eventProb
  rw [← Finset.sum_add_distrib]
  rw [← P.prob_sum]
  apply Finset.sum_congr rfl
  intro ω _
  by_cases hω : ω ∈ E <;> simp [hω]

/-- The whole finite sample space has probability one. -/
theorem eventProb_univ (P : FiniteProbability Ω) :
    P.eventProb Set.univ = 1 := by
  classical
  unfold eventProb
  simpa using P.prob_sum

/-- If an event contains every outcome, it has probability one. -/
theorem eventProb_eq_one_of_forall (P : FiniteProbability Ω) {E : Set Ω}
    (hE : ∀ ω, ω ∈ E) :
    P.eventProb E = 1 := by
  classical
  unfold eventProb
  simpa [hE] using P.prob_sum

/-- Every event in a finite probability space has probability at most one. -/
theorem eventProb_le_one (P : FiniteProbability Ω) (E : Set Ω) :
    P.eventProb E ≤ 1 := by
  have hsplit := P.eventProb_add_eventProb_compl E
  have hcompl_nonneg := P.eventProb_nonneg Eᶜ
  linarith

/-- Finite union-bound rearrangement:
    `P(E) + P(F) ≤ P(E ∩ F) + 1`. -/
theorem eventProb_add_le_eventProb_inter_add_one
    (P : FiniteProbability Ω) (E F : Set Ω) :
    P.eventProb E + P.eventProb F ≤ P.eventProb (E ∩ F) + 1 := by
  classical
  calc
    P.eventProb E + P.eventProb F
        = ∑ ω,
            ((if ω ∈ E then P.prob ω else 0) +
              (if ω ∈ F then P.prob ω else 0)) := by
            unfold eventProb
            rw [Finset.sum_add_distrib]
    _ ≤ ∑ ω,
          ((if ω ∈ E ∩ F then P.prob ω else 0) + P.prob ω) := by
            apply Finset.sum_le_sum
            intro ω _
            by_cases hE : ω ∈ E <;> by_cases hF : ω ∈ F <;>
              simp [hE, hF, P.prob_nonneg ω]
    _ = P.eventProb (E ∩ F) + 1 := by
            unfold eventProb
            rw [Finset.sum_add_distrib, P.prob_sum]
            congr 1
            apply Finset.sum_congr rfl
            intro ω _
            by_cases hω : ω ∈ E ∩ F <;> simp [hω]

/-- If two events each hold with probabilities at least `1 - δ₁` and
    `1 - δ₂`, then their intersection holds with probability at least
    `1 - (δ₁ + δ₂)`. -/
theorem eventProb_inter_ge_one_sub_add
    (P : FiniteProbability Ω) (E F : Set Ω) (δ₁ δ₂ : ℝ)
    (hE : 1 - δ₁ ≤ P.eventProb E)
    (hF : 1 - δ₂ ≤ P.eventProb F) :
    1 - (δ₁ + δ₂) ≤ P.eventProb (E ∩ F) := by
  have hsum := eventProb_add_le_eventProb_inter_add_one P E F
  linarith

/-- The intersection of two probability-one events has probability one. -/
theorem eventProb_inter_eq_one_of_eq_one
    (P : FiniteProbability Ω) (E F : Set Ω)
    (hE : P.eventProb E = 1) (hF : P.eventProb F = 1) :
    P.eventProb (E ∩ F) = 1 := by
  have hge :
      1 - ((0 : ℝ) + 0) ≤ P.eventProb (E ∩ F) := by
    exact eventProb_inter_ge_one_sub_add P E F 0 0
      (by simp [hE]) (by simp [hF])
  have hle : P.eventProb (E ∩ F) ≤ 1 := eventProb_le_one P (E ∩ F)
  linarith

/-- Product of two repository-native finite probability spaces. -/
noncomputable def prod {Ω Λ : Type*} [Fintype Ω] [Fintype Λ]
    (P : FiniteProbability Ω) (Q : FiniteProbability Λ) :
    FiniteProbability (Ω × Λ) where
  prob := fun x => P.prob x.1 * Q.prob x.2
  prob_nonneg := by
    intro x
    exact mul_nonneg (P.prob_nonneg x.1) (Q.prob_nonneg x.2)
  prob_sum := by
    classical
    rw [Fintype.sum_prod_type]
    calc
      ∑ a : Ω, ∑ b : Λ, P.prob a * Q.prob b
          = ∑ a : Ω, P.prob a * (∑ b : Λ, Q.prob b) := by
              apply Finset.sum_congr rfl
              intro a _
              rw [Finset.mul_sum]
      _ = ∑ a : Ω, P.prob a * 1 := by
              rw [Q.prob_sum]
      _ = 1 := by
              simp [P.prob_sum]

/-- Product-law Fubini identity for finite real expectations. -/
theorem prod_expectationReal_eq {Ω Λ : Type*} [Fintype Ω] [Fintype Λ]
    (P : FiniteProbability Ω) (Q : FiniteProbability Λ)
    (X : Ω × Λ → ℝ) :
    (P.prod Q).expectationReal X =
      P.expectationReal (fun a => Q.expectationReal (fun b => X (a, b))) := by
  classical
  unfold expectationReal prod
  rw [Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro a _
  calc
    ∑ b : Λ, P.prob a * Q.prob b * X (a, b)
        = ∑ b : Λ, P.prob a * (Q.prob b * X (a, b)) := by
            apply Finset.sum_congr rfl
            intro b _
            ring
    _ = P.prob a * ∑ b : Λ, Q.prob b * X (a, b) := by
            rw [Finset.mul_sum]

/-- Product-law Fubini identity for functions depending only on the first
coordinate. -/
theorem prod_expectationReal_fst_eq {Ω Λ : Type*} [Fintype Ω] [Fintype Λ]
    (P : FiniteProbability Ω) (Q : FiniteProbability Λ) (X : Ω → ℝ) :
    (P.prod Q).expectationReal (fun x : Ω × Λ => X x.1) =
      P.expectationReal X := by
  rw [prod_expectationReal_eq P Q]
  apply congrArg P.expectationReal
  funext a
  exact expectationReal_const Q (X a)

/-- Product-law Fubini identity for functions depending only on the second
coordinate. -/
theorem prod_expectationReal_snd_eq {Ω Λ : Type*} [Fintype Ω] [Fintype Λ]
    (P : FiniteProbability Ω) (Q : FiniteProbability Λ) (X : Λ → ℝ) :
    (P.prod Q).expectationReal (fun x : Ω × Λ => X x.2) =
      Q.expectationReal X := by
  rw [prod_expectationReal_eq P Q]
  simpa using expectationReal_const P (Q.expectationReal X)

/-- Finite scalar symmetrization around the mean.

For a real statistic `X`, the expected absolute centered deviation is bounded
by the expected absolute difference of two independent copies.  This is the
first scalar symmetrization layer used before Rademacher/Khintchine routes. -/
theorem expectationReal_abs_sub_mean_le_prod_expectationReal_abs_sub
    {Ω : Type*} [Fintype Ω] (P : FiniteProbability Ω) (X : Ω → ℝ) :
    P.expectationReal (fun ω => |X ω - P.expectationReal X|) ≤
      (P.prod P).expectationReal
        (fun x : Ω × Ω => |X x.1 - X x.2|) := by
  classical
  rw [prod_expectationReal_eq P P]
  apply expectationReal_mono P
  intro ω
  have hcenter :
      P.expectationReal (fun η => X ω - X η) =
        X ω - P.expectationReal X := by
    calc
      P.expectationReal (fun η => X ω - X η)
          = P.expectationReal (fun _η => X ω) -
              P.expectationReal X := by
              simpa using
                (expectationReal_sub P (fun _η => X ω) X)
      _ = X ω - P.expectationReal X := by
              rw [expectationReal_const]
  have habs :=
    abs_expectationReal_le_expectationReal_abs P
      (fun η => X ω - X η)
  simpa [hcenter] using habs

/-- Centered finite scalar symmetrization.

If `X` has mean zero, then `E |X|` is bounded by the expected absolute
difference of two independent copies. -/
theorem expectationReal_abs_le_prod_expectationReal_abs_sub_of_expectation_eq_zero
    {Ω : Type*} [Fintype Ω] (P : FiniteProbability Ω) (X : Ω → ℝ)
    (hmean : P.expectationReal X = 0) :
    P.expectationReal (fun ω => |X ω|) ≤
      (P.prod P).expectationReal
        (fun x : Ω × Ω => |X x.1 - X x.2|) := by
  simpa [hmean] using
    expectationReal_abs_sub_mean_le_prod_expectationReal_abs_sub P X

/-- Entropy chain rule for repository-native finite product laws.

This is the finite product-measure tensorization algebra needed by the
Ledoux/log-Sobolev route.  It does not prove any coordinate log-Sobolev
inequality; it only separates the product entropy into the average conditional
entropy plus the entropy of the conditional mean. -/
theorem entropyReal_prod_eq_expectation_entropyReal_add_entropyReal_expectation
    {Ω Λ : Type*} [Fintype Ω] [Fintype Λ]
    (P : FiniteProbability Ω) (Q : FiniteProbability Λ)
    (Z : Ω × Λ → ℝ) :
    entropyReal (P.prod Q) Z =
      P.expectationReal
        (fun a => entropyReal Q (fun b => Z (a, b))) +
        entropyReal P (fun a => Q.expectationReal (fun b => Z (a, b))) := by
  classical
  unfold entropyReal
  rw [prod_expectationReal_eq P Q
    (fun x : Ω × Λ => Z x * Real.log (Z x))]
  rw [prod_expectationReal_eq P Q Z]
  rw [expectationReal_sub]
  ring

/-- One-coordinate tensorization step for the fair Bernoulli log-Sobolev
route.

For a product law `P × ν`, where `ν` is the fair Bernoulli coordinate law, the
entropy of `g^2` is bounded by the Bernoulli-coordinate squared difference plus
the entropy of the conditional second moment.  This is the peel-off step used
before an induction over the full Bernoulli cube; it does not yet bound the
remaining entropy term. -/
theorem entropyReal_prod_boolUniformProbability_sq_le_coordinate_add_entropy
    {Ω : Type*} [Fintype Ω]
    (P : FiniteProbability Ω) (g : Ω × Bool → ℝ)
    (hg : ∀ x, 0 < g x) :
    entropyReal (P.prod boolUniformProbability) (fun x => g x ^ 2) ≤
      P.expectationReal
          (fun a => (g (a, true) - g (a, false)) ^ 2) +
        entropyReal P
          (fun a =>
            boolUniformProbability.expectationReal
              (fun b => g (a, b) ^ 2)) := by
  rw [entropyReal_prod_eq_expectation_entropyReal_add_entropyReal_expectation]
  have hcoord :
      P.expectationReal
          (fun a => entropyReal boolUniformProbability
            (fun b => g (a, b) ^ 2)) ≤
        P.expectationReal
          (fun a => (g (a, true) - g (a, false)) ^ 2) :=
    P.expectationReal_mono
      (fun a =>
        entropyReal_boolUniformProbability_sq_le_sq_sub_of_pos
          (fun b => g (a, b)) (fun b => hg (a, b)))
  exact add_le_add hcoord (le_refl _)

/-- Abstract Bernoulli-product induction lift for the Ledoux tensorization
route.

If a finite probability law `P` satisfies an entropy-gradient bound for a
family of coordinate moves `step`, then `P x boolUniformProbability` satisfies
the corresponding bound after adding the new Bernoulli coordinate.  The proof
uses the one-coordinate peel-off above and the finite `L2` reverse-triangle
bridge to control old-coordinate section norms. -/
theorem entropyReal_prod_boolUniformProbability_sq_le_lifted_diff_sum_add
    {Ω ι : Type*} [Fintype Ω] [Fintype ι]
    (P : FiniteProbability Ω) (step : ι → Ω → Ω)
    (g : Ω × Bool → ℝ) (hg : ∀ x, 0 < g x)
    (hP : ∀ h : Ω → ℝ, (∀ a, 0 < h a) →
      entropyReal P (fun a => h a ^ 2) ≤
        ∑ i : ι, P.expectationReal
          (fun a => (h a - h (step i a)) ^ 2)) :
    entropyReal (P.prod boolUniformProbability) (fun x => g x ^ 2) ≤
      P.expectationReal
          (fun a => (g (a, true) - g (a, false)) ^ 2) +
        ∑ i : ι, (P.prod boolUniformProbability).expectationReal
          (fun x => (g x - g (step i x.1, x.2)) ^ 2) := by
  classical
  let h : Ω → ℝ := fun a =>
    Real.sqrt (boolUniformProbability.expectationReal
      (fun b => g (a, b) ^ 2))
  have hinner_nonneg :
      ∀ a, 0 ≤ boolUniformProbability.expectationReal
        (fun b => g (a, b) ^ 2) := by
    intro a
    exact expectationReal_sq_nonneg boolUniformProbability (fun b => g (a, b))
  have hpos : ∀ a, 0 < h a := by
    intro a
    dsimp [h]
    apply Real.sqrt_pos.2
    rw [boolUniformProbability_expectationReal]
    have hfalse : 0 < g (a, false) ^ 2 := sq_pos_of_pos (hg (a, false))
    have htrue : 0 < g (a, true) ^ 2 := sq_pos_of_pos (hg (a, true))
    nlinarith
  have hsquare :
      (fun a => h a ^ 2) =
        fun a =>
          boolUniformProbability.expectationReal
            (fun b => g (a, b) ^ 2) := by
    funext a
    dsimp [h]
    exact Real.sq_sqrt (hinner_nonneg a)
  have hind :=
    hP h hpos
  have hind' :
      entropyReal P
          (fun a =>
            boolUniformProbability.expectationReal
              (fun b => g (a, b) ^ 2)) ≤
        ∑ i : ι, P.expectationReal
          (fun a => (h a - h (step i a)) ^ 2) := by
    simpa [hsquare] using hind
  have hcost :
      (∑ i : ι, P.expectationReal
          (fun a => (h a - h (step i a)) ^ 2)) ≤
        ∑ i : ι, (P.prod boolUniformProbability).expectationReal
          (fun x => (g x - g (step i x.1, x.2)) ^ 2) := by
    apply Finset.sum_le_sum
    intro i _
    have hpoint :
        ∀ a,
          (h a - h (step i a)) ^ 2 ≤
            boolUniformProbability.expectationReal
              (fun b => (g (a, b) - g (step i a, b)) ^ 2) := by
      intro a
      have hbridge :=
        boolUniformProbability_abs_sqrt_expectationReal_sq_sub_le_sqrt_expectationReal_sub_sq
          (fun b => g (a, b)) (fun b => g (step i a, b))
      have hright_nonneg :
          0 ≤ boolUniformProbability.expectationReal
            (fun b => (g (a, b) - g (step i a, b)) ^ 2) :=
        expectationReal_sq_nonneg boolUniformProbability
          (fun b => g (a, b) - g (step i a, b))
      have habs_le :
          |h a - h (step i a)| ≤
            Real.sqrt
              (boolUniformProbability.expectationReal
                (fun b => (g (a, b) - g (step i a, b)) ^ 2)) := by
        simpa [h] using hbridge
      have habs_le_abs :
          |h a - h (step i a)| ≤
            |Real.sqrt
              (boolUniformProbability.expectationReal
                (fun b => (g (a, b) - g (step i a, b)) ^ 2))| := by
        simpa [abs_of_nonneg (Real.sqrt_nonneg _)] using habs_le
      have hsq := (sq_le_sq).mpr habs_le_abs
      rw [Real.sq_sqrt hright_nonneg] at hsq
      exact hsq
    calc
      P.expectationReal (fun a => (h a - h (step i a)) ^ 2)
          ≤ P.expectationReal
              (fun a =>
                boolUniformProbability.expectationReal
                  (fun b => (g (a, b) - g (step i a, b)) ^ 2)) :=
            P.expectationReal_mono hpoint
      _ = (P.prod boolUniformProbability).expectationReal
          (fun x => (g x - g (step i x.1, x.2)) ^ 2) := by
            rw [prod_expectationReal_eq P boolUniformProbability]
  have hpeel :=
    entropyReal_prod_boolUniformProbability_sq_le_coordinate_add_entropy
      P g hg
  calc
    entropyReal (P.prod boolUniformProbability) (fun x => g x ^ 2)
        ≤ P.expectationReal
            (fun a => (g (a, true) - g (a, false)) ^ 2) +
          entropyReal P
            (fun a =>
              boolUniformProbability.expectationReal
                (fun b => g (a, b) ^ 2)) := hpeel
    _ ≤ P.expectationReal
            (fun a => (g (a, true) - g (a, false)) ^ 2) +
          ∑ i : ι, P.expectationReal
            (fun a => (h a - h (step i a)) ^ 2) := by
          exact add_le_add (le_refl _) hind'
    _ ≤ P.expectationReal
            (fun a => (g (a, true) - g (a, false)) ^ 2) +
          ∑ i : ι, (P.prod boolUniformProbability).expectationReal
            (fun x => (g x - g (step i x.1, x.2)) ^ 2) := by
          exact add_le_add (le_refl _) hcost

/-- In a product probability space, the probability of an event depending only
on the first coordinate is the first marginal probability. -/
theorem prod_eventProb_fst_eq {Ω Λ : Type*} [Fintype Ω] [Fintype Λ]
    (P : FiniteProbability Ω) (Q : FiniteProbability Λ) (E : Set Ω) :
    (P.prod Q).eventProb {x : Ω × Λ | x.1 ∈ E} = P.eventProb E := by
  classical
  unfold eventProb prod
  rw [Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro a _
  by_cases ha : a ∈ E
  · calc
      ∑ b : Λ, (if (a, b).1 ∈ E then P.prob a * Q.prob b else 0)
          = ∑ b : Λ, P.prob a * Q.prob b := by
              apply Finset.sum_congr rfl
              intro b _
              simp [ha]
      _ = P.prob a * (∑ b : Λ, Q.prob b) := by
              rw [Finset.mul_sum]
      _ = if a ∈ E then P.prob a else 0 := by
              simp [ha, Q.prob_sum]
  · calc
      ∑ b : Λ, (if (a, b).1 ∈ E then P.prob a * Q.prob b else 0)
          = ∑ _b : Λ, 0 := by
              apply Finset.sum_congr rfl
              intro b _
              simp [ha]
      _ = if a ∈ E then P.prob a else 0 := by
              simp [ha]

/-- Product-law Fubini identity for an event whose second-coordinate slice may
depend on the first coordinate. -/
theorem prod_eventProb_dependent_snd_eq {Ω Λ : Type*} [Fintype Ω] [Fintype Λ]
    (P : FiniteProbability Ω) (Q : FiniteProbability Λ) (F : Ω → Set Λ) :
    (P.prod Q).eventProb {x : Ω × Λ | x.2 ∈ F x.1} =
      P.expectationReal (fun a => Q.eventProb (F a)) := by
  classical
  unfold eventProb expectationReal prod
  rw [Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro a _
  calc
    ∑ b : Λ, (if (a, b).2 ∈ F (a, b).1 then P.prob a * Q.prob b else 0)
        = ∑ b : Λ, P.prob a * (if b ∈ F a then Q.prob b else 0) := by
            apply Finset.sum_congr rfl
            intro b _
            by_cases hb : b ∈ F a
            · simp [hb]
            · simp [hb]
    _ = P.prob a * ∑ b : Λ, (if b ∈ F a then Q.prob b else 0) := by
            rw [Finset.mul_sum]

/-- If every second-coordinate slice has probability at least `1 - δ`, then
the dependent second-coordinate event has product probability at least
`1 - δ`. -/
theorem prod_eventProb_dependent_snd_ge {Ω Λ : Type*} [Fintype Ω] [Fintype Λ]
    (P : FiniteProbability Ω) (Q : FiniteProbability Λ)
    (F : Ω → Set Λ) (δ : ℝ)
    (hF : ∀ a, 1 - δ ≤ Q.eventProb (F a)) :
    1 - δ ≤ (P.prod Q).eventProb {x : Ω × Λ | x.2 ∈ F x.1} := by
  classical
  rw [prod_eventProb_dependent_snd_eq P Q F]
  calc
    1 - δ = P.expectationReal (fun _a => 1 - δ) := by
        exact (expectationReal_const P (1 - δ)).symm
    _ ≤ P.expectationReal (fun a => Q.eventProb (F a)) :=
        expectationReal_mono P hF

/-- Product-law composition for a first-coordinate event and a dependent
second-coordinate event.  Outside the first-coordinate event the second
coordinate slice is treated as the whole space, so only the stated conditional
slice probabilities are needed. -/
theorem prod_eventProb_inter_dependent_ge_one_sub_add
    {Ω Λ : Type*} [Fintype Ω] [Fintype Λ]
    (P : FiniteProbability Ω) (Q : FiniteProbability Λ)
    (E : Set Ω) (F : Ω → Set Λ) (δE δF : ℝ)
    (hδF : 0 ≤ δF)
    (hE : 1 - δE ≤ P.eventProb E)
    (hF : ∀ a, a ∈ E → 1 - δF ≤ Q.eventProb (F a)) :
    1 - (δE + δF) ≤
      (P.prod Q).eventProb {x : Ω × Λ | x.1 ∈ E ∧ x.2 ∈ F x.1} := by
  classical
  let F' : Ω → Set Λ := fun a => if a ∈ E then F a else Set.univ
  let A : Set (Ω × Λ) := {x | x.1 ∈ E}
  let B : Set (Ω × Λ) := {x | x.2 ∈ F' x.1}
  have hA : 1 - δE ≤ (P.prod Q).eventProb A := by
    simpa [A] using (hE.trans_eq (prod_eventProb_fst_eq P Q E).symm)
  have hslice : ∀ a, 1 - δF ≤ Q.eventProb (F' a) := by
    intro a
    by_cases ha : a ∈ E
    · simpa [F', ha] using hF a ha
    · have hle : 1 - δF ≤ 1 := by linarith
      simpa [F', ha, eventProb_univ Q] using hle
  have hB : 1 - δF ≤ (P.prod Q).eventProb B := by
    simpa [B] using prod_eventProb_dependent_snd_ge P Q F' δF hslice
  have hinter :
      1 - (δE + δF) ≤ (P.prod Q).eventProb (A ∩ B) :=
    eventProb_inter_ge_one_sub_add (P.prod Q) A B δE δF hA hB
  have hsubset :
      A ∩ B ⊆ {x : Ω × Λ | x.1 ∈ E ∧ x.2 ∈ F x.1} := by
    intro x hx
    rcases hx with ⟨hxA, hxB⟩
    have hxA' : x.1 ∈ E := by simpa [A] using hxA
    have hxB' : x.2 ∈ F' x.1 := by simpa [B] using hxB
    exact ⟨hxA', by simpa [F', hxA'] using hxB'⟩
  exact hinter.trans (eventProb_mono (P.prod Q) hsubset)

/-- Finite union-bound form for intersections over a finite set of events:
    if each `E i` holds with probability at least `1 - δ i`, then all events
    in `s` hold simultaneously with probability at least `1 - ∑ i in s, δ i`.

This theorem is intentionally stated for an explicit `Finset`; the `Fintype`
wrapper below is the common all-indices case. -/
theorem eventProb_finset_forall_ge_one_sub_sum {ι : Type*} [DecidableEq ι]
    (P : FiniteProbability Ω) (s : Finset ι) (E : ι → Set Ω) (δ : ι → ℝ)
    (hE : ∀ i, i ∈ s → 1 - δ i ≤ P.eventProb (E i)) :
    1 - (∑ i ∈ s, δ i) ≤
      P.eventProb {ω | ∀ i, i ∈ s → ω ∈ E i} := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      have hset : {ω : Ω | ∀ i, i ∈ (∅ : Finset ι) → ω ∈ E i} = Set.univ := by
        ext ω
        simp
      rw [hset, eventProb_univ]
      simp
  | insert a s ha ih =>
      let Es : Set Ω := {ω | ∀ i, i ∈ s → ω ∈ E i}
      have ha_prob : 1 - δ a ≤ P.eventProb (E a) :=
        hE a (Finset.mem_insert_self a s)
      have hs_prob : 1 - (∑ i ∈ s, δ i) ≤ P.eventProb Es :=
        ih (fun i hi => hE i (Finset.mem_insert_of_mem hi))
      have hinter :=
        eventProb_inter_ge_one_sub_add P (E a) Es
          (δ a) (∑ i ∈ s, δ i) ha_prob hs_prob
      have hset :
          E a ∩ Es =
            {ω : Ω | ∀ i, i ∈ insert a s → ω ∈ E i} := by
        ext ω
        constructor
        · intro hω i hi
          rcases hω with ⟨haω, hsω⟩
          rcases Finset.mem_insert.mp hi with rfl | his
          · exact haω
          · exact hsω i his
        · intro hω
          constructor
          · exact hω a (Finset.mem_insert_self a s)
          · intro i hi
            exact hω i (Finset.mem_insert_of_mem hi)
      have hsum : ∑ i ∈ insert a s, δ i = δ a + ∑ i ∈ s, δ i := by
        exact Finset.sum_insert ha
      simpa [hset, hsum] using hinter

/-- Finite union-bound form over all indices of a finite type. -/
theorem eventProb_forall_ge_one_sub_sum {ι : Type*} [Fintype ι] [DecidableEq ι]
    (P : FiniteProbability Ω) (E : ι → Set Ω) (δ : ι → ℝ)
    (hE : ∀ i, 1 - δ i ≤ P.eventProb (E i)) :
    1 - (∑ i, δ i) ≤ P.eventProb {ω | ∀ i, ω ∈ E i} := by
  classical
  have h :=
    eventProb_finset_forall_ge_one_sub_sum P (Finset.univ : Finset ι)
      E δ (fun i _ => hE i)
  have hset :
      {ω : Ω | ∀ i, i ∈ (Finset.univ : Finset ι) → ω ∈ E i} =
        {ω : Ω | ∀ i, ω ∈ E i} := by
    ext ω
    constructor
    · intro hω i
      exact hω i (Finset.mem_univ i)
    · intro hω i _
      exact hω i
  simpa [hset] using h

/-- Finite Markov inequality for nonnegative real-valued random variables. -/
theorem eventProb_real_ge_le_expectationReal_div
    (P : FiniteProbability Ω) (X : Ω → ℝ) {T : ℝ}
    (hX : ∀ ω, 0 ≤ X ω) (hT : 0 < T) :
    P.eventProb {ω | T ≤ X ω} ≤ P.expectationReal X / T := by
  classical
  let M : ℝ := ∑ ω, P.prob ω * (X ω / T)
  have hle : P.eventProb {ω | T ≤ X ω} ≤ M := by
    unfold eventProb M
    apply Finset.sum_le_sum
    intro ω _
    by_cases hω : ω ∈ {ω | T ≤ X ω}
    · have hone : 1 ≤ X ω / T := by
        rw [one_le_div hT]
        exact hω
      have hmain : P.prob ω ≤ P.prob ω * (X ω / T) := by
        calc
          P.prob ω = P.prob ω * 1 := by ring
          _ ≤ P.prob ω * (X ω / T) :=
              mul_le_mul_of_nonneg_left hone (P.prob_nonneg ω)
      simpa [hω] using hmain
    · have hratio_nonneg : 0 ≤ X ω / T :=
        div_nonneg (hX ω) (le_of_lt hT)
      have hmain : 0 ≤ P.prob ω * (X ω / T) :=
        mul_nonneg (P.prob_nonneg ω) hratio_nonneg
      simpa [hω] using hmain
  have hM : M = P.expectationReal X / T := by
    unfold M expectationReal
    calc
      ∑ ω, P.prob ω * (X ω / T)
          = ∑ ω, (P.prob ω * X ω) * T⁻¹ := by
              apply Finset.sum_congr rfl
              intro ω _
              ring_nf
      _ = (∑ ω, P.prob ω * X ω) * T⁻¹ := by
              rw [Finset.sum_mul]
      _ = (∑ ω, P.prob ω * X ω) / T := by
              rw [div_eq_mul_inv]
  exact hle.trans_eq hM

/-- Lower-tail Markov form for nonnegative real-valued random variables. -/
theorem eventProb_real_le_ge_one_sub_expectationReal_div
    (P : FiniteProbability Ω) (X : Ω → ℝ) (T : ℝ)
    (hX : ∀ ω, 0 ≤ X ω) (hT : 0 < T) :
    1 - P.expectationReal X / T ≤ P.eventProb {ω | X ω ≤ T} := by
  classical
  let E : Set Ω := {ω | X ω ≤ T}
  have htail :=
    eventProb_real_ge_le_expectationReal_div P X hX hT
  have hcompl_subset : Eᶜ ⊆ {ω | T ≤ X ω} := by
    intro ω hω
    simp [E] at hω
    exact le_of_lt hω
  have htailE :
      P.eventProb Eᶜ ≤ P.expectationReal X / T :=
    (eventProb_mono P hcompl_subset).trans htail
  have hsplit := eventProb_add_eventProb_compl P E
  linarith

/-- High-probability squared-moment bound:
    `Pr[Z ≤ η] ≥ 1 - E[Z²]/η²` for nonnegative `Z`. -/
theorem eventProb_le_ge_one_sub_expectationReal_sq_div
    (P : FiniteProbability Ω) (Z : Ω → ℝ) (η : ℝ)
    (hZ : ∀ ω, 0 ≤ Z ω) (hη : 0 < η) :
    1 - P.expectationReal (fun ω => Z ω ^ 2) / η ^ 2 ≤
      P.eventProb {ω | Z ω ≤ η} := by
  classical
  have hηsq : 0 < η ^ 2 := sq_pos_of_pos hη
  have hmarkov :=
    eventProb_real_le_ge_one_sub_expectationReal_div
      P (fun ω => Z ω ^ 2) (η ^ 2)
      (fun ω => sq_nonneg (Z ω)) hηsq
  have hsubset : {ω | Z ω ^ 2 ≤ η ^ 2} ⊆ {ω | Z ω ≤ η} := by
    intro ω hω
    change Z ω ^ 2 ≤ η ^ 2 at hω
    have habs := (sq_le_sq).mp hω
    simpa [abs_of_nonneg (hZ ω), abs_of_nonneg (le_of_lt hη)] using habs
  exact hmarkov.trans (eventProb_mono P hsubset)

/-- Finite Markov inequality for natural-valued random variables. -/
theorem eventProb_nat_ge_le_expectationNat_div
    (P : FiniteProbability Ω) (X : Ω → ℕ) {T : ℕ} (hT : 0 < T) :
    P.eventProb {ω | T ≤ X ω} ≤ P.expectationNat X / (T : ℝ) := by
  classical
  have hTreal : 0 < (T : ℝ) := by exact_mod_cast hT
  let M : ℝ := ∑ ω, P.prob ω * ((X ω : ℝ) / (T : ℝ))
  have hle : P.eventProb {ω | T ≤ X ω} ≤ M := by
    unfold eventProb M
    apply Finset.sum_le_sum
    intro ω _
    by_cases hω : ω ∈ {ω | T ≤ X ω}
    · have hXT : (T : ℝ) ≤ X ω := by exact_mod_cast hω
      have hone : 1 ≤ (X ω : ℝ) / (T : ℝ) := by
        rw [one_le_div hTreal]
        exact hXT
      have hmain :
          P.prob ω ≤ P.prob ω * ((X ω : ℝ) / (T : ℝ)) := by
        calc
          P.prob ω = P.prob ω * 1 := by ring
          _ ≤ P.prob ω * ((X ω : ℝ) / (T : ℝ)) :=
              mul_le_mul_of_nonneg_left hone (P.prob_nonneg ω)
      simpa [hω] using hmain
    · have hX_nonneg : 0 ≤ (X ω : ℝ) / (T : ℝ) :=
        div_nonneg (by exact_mod_cast Nat.zero_le (X ω)) (le_of_lt hTreal)
      have hmain : 0 ≤ P.prob ω * ((X ω : ℝ) / (T : ℝ)) :=
        mul_nonneg (P.prob_nonneg ω) hX_nonneg
      simpa [hω] using hmain
  have hM : M = P.expectationNat X / (T : ℝ) := by
    unfold M expectationNat
    calc
      ∑ ω, P.prob ω * ((X ω : ℝ) / (T : ℝ))
          = ∑ ω, (P.prob ω * (X ω : ℝ)) * (T : ℝ)⁻¹ := by
              apply Finset.sum_congr rfl
              intro ω _
              ring_nf
      _ = (∑ ω, P.prob ω * (X ω : ℝ)) * (T : ℝ)⁻¹ := by
              rw [Finset.sum_mul]
      _ = (∑ ω, P.prob ω * (X ω : ℝ)) / (T : ℝ) := by
              rw [div_eq_mul_inv]
  exact hle.trans_eq hM

/-- Lower-tail form of Markov: with probability at least
    `1 - E[X] / (Q+1)`, a natural-valued random variable is at most `Q`. -/
theorem eventProb_nat_le_ge_one_sub_expectationNat_div_succ
    (P : FiniteProbability Ω) (X : Ω → ℕ) (Q : ℕ) :
    1 - P.expectationNat X / ((Q + 1 : ℕ) : ℝ) ≤
      P.eventProb {ω | X ω ≤ Q} := by
  classical
  let E : Set Ω := {ω | X ω ≤ Q}
  have hT : 0 < Q + 1 := Nat.succ_pos Q
  have htail :=
    eventProb_nat_ge_le_expectationNat_div P X hT
  have hcompl :
      Eᶜ = {ω | Q + 1 ≤ X ω} := by
    ext ω
    simp [E]
  have htailE :
      P.eventProb Eᶜ ≤ P.expectationNat X / ((Q + 1 : ℕ) : ℝ) := by
    simpa [hcompl] using htail
  have hsplit := eventProb_add_eventProb_compl P E
  linarith

/-- Chebyshev from finite Markov: the probability of a strict deviation from
    `μ` by more than `ε` is bounded by the centered second moment divided by
    `ε²`. -/
theorem eventProb_abs_sub_gt_le_expectationReal_sq_div
    (P : FiniteProbability Ω) (X : Ω → ℝ) (μ ε : ℝ) (hε : 0 < ε) :
    P.eventProb {ω | ε < |X ω - μ|} ≤
      P.expectationReal (fun ω => (X ω - μ) ^ 2) / ε ^ 2 := by
  classical
  have hε2 : 0 < ε ^ 2 := sq_pos_of_pos hε
  let M : ℝ := ∑ ω, P.prob ω * (((X ω - μ) ^ 2) / ε ^ 2)
  have hle : P.eventProb {ω | ε < |X ω - μ|} ≤ M := by
    unfold eventProb M
    apply Finset.sum_le_sum
    intro ω _
    by_cases hω : ω ∈ {ω | ε < |X ω - μ|}
    · have hdev : ε < |X ω - μ| := hω
      have hsq : ε ^ 2 ≤ (X ω - μ) ^ 2 := by
        have hsq_abs : ε ^ 2 ≤ |X ω - μ| ^ 2 := by
          nlinarith [le_of_lt hdev, le_of_lt hε, abs_nonneg (X ω - μ)]
        simpa [sq_abs] using hsq_abs
      have hone : 1 ≤ ((X ω - μ) ^ 2) / ε ^ 2 := by
        rw [one_le_div hε2]
        exact hsq
      have hmain :
          P.prob ω ≤ P.prob ω * (((X ω - μ) ^ 2) / ε ^ 2) := by
        calc
          P.prob ω = P.prob ω * 1 := by ring
          _ ≤ P.prob ω * (((X ω - μ) ^ 2) / ε ^ 2) :=
              mul_le_mul_of_nonneg_left hone (P.prob_nonneg ω)
      simpa [hω] using hmain
    · have hsq_nonneg : 0 ≤ ((X ω - μ) ^ 2) / ε ^ 2 :=
        div_nonneg (sq_nonneg _) (le_of_lt hε2)
      have hmain :
          0 ≤ P.prob ω * (((X ω - μ) ^ 2) / ε ^ 2) :=
        mul_nonneg (P.prob_nonneg ω) hsq_nonneg
      simpa [hω] using hmain
  have hM : M = P.expectationReal (fun ω => (X ω - μ) ^ 2) / ε ^ 2 := by
    unfold M expectationReal
    calc
      ∑ ω, P.prob ω * (((X ω - μ) ^ 2) / ε ^ 2)
          = ∑ ω, (P.prob ω * ((X ω - μ) ^ 2)) * (ε ^ 2)⁻¹ := by
              apply Finset.sum_congr rfl
              intro ω _
              ring_nf
      _ = (∑ ω, P.prob ω * ((X ω - μ) ^ 2)) * (ε ^ 2)⁻¹ := by
              rw [Finset.sum_mul]
      _ = (∑ ω, P.prob ω * ((X ω - μ) ^ 2)) / ε ^ 2 := by
              rw [div_eq_mul_inv]
  exact hle.trans_eq hM

/-- `1 - δ` Chebyshev form: if the centered second moment divided by `ε²` is
    at most `δ`, then the random variable lies within `ε` of `μ` with
    probability at least `1 - δ`. -/
theorem eventProb_abs_sub_le_ge_one_sub_of_second_moment
    (P : FiniteProbability Ω) (X : Ω → ℝ) (μ ε δ : ℝ) (hε : 0 < ε)
    (hmoment : P.expectationReal (fun ω => (X ω - μ) ^ 2) / ε ^ 2 ≤ δ) :
    1 - δ ≤ P.eventProb {ω | |X ω - μ| ≤ ε} := by
  classical
  let E : Set Ω := {ω | |X ω - μ| ≤ ε}
  have htail :=
    eventProb_abs_sub_gt_le_expectationReal_sq_div P X μ ε hε
  have hcompl :
      Eᶜ = {ω | ε < |X ω - μ|} := by
    ext ω
    simp [E, not_le]
  have htailE :
      P.eventProb Eᶜ ≤
        P.expectationReal (fun ω => (X ω - μ) ^ 2) / ε ^ 2 := by
    simpa [hcompl] using htail
  have hsplit := eventProb_add_eventProb_compl P E
  linarith

/-- Exponential Markov inequality for real-valued random variables.  This is
    the finite-probability kernel needed before spectral or matrix-valued
    concentration can be developed. -/
theorem eventProb_real_ge_le_exp_mul_mgf
    (P : FiniteProbability Ω) (X : Ω → ℝ) {T lam : ℝ}
    (hlam : 0 < lam) :
    P.eventProb {ω | T ≤ X ω} ≤
      Real.exp (-(lam * T)) *
        P.expectationReal (fun ω => Real.exp (lam * X ω)) := by
  classical
  let M : ℝ :=
    ∑ ω, P.prob ω * Real.exp (lam * X ω - lam * T)
  have hle : P.eventProb {ω | T ≤ X ω} ≤ M := by
    unfold eventProb M
    apply Finset.sum_le_sum
    intro ω _
    by_cases hω : ω ∈ {ω | T ≤ X ω}
    · have hlamT : lam * T ≤ lam * X ω :=
        mul_le_mul_of_nonneg_left hω (le_of_lt hlam)
      have hone :
          1 ≤ Real.exp (lam * X ω - lam * T) := by
        calc
          (1 : ℝ) = Real.exp 0 := by rw [Real.exp_zero]
          _ ≤ Real.exp (lam * X ω - lam * T) :=
              Real.exp_le_exp.mpr (by linarith)
      have hmain :
          P.prob ω ≤ P.prob ω * Real.exp (lam * X ω - lam * T) := by
        calc
          P.prob ω = P.prob ω * 1 := by ring
          _ ≤ P.prob ω * Real.exp (lam * X ω - lam * T) :=
              mul_le_mul_of_nonneg_left hone (P.prob_nonneg ω)
      simpa [hω] using hmain
    · have hmain :
          0 ≤ P.prob ω * Real.exp (lam * X ω - lam * T) :=
        mul_nonneg (P.prob_nonneg ω) (le_of_lt (Real.exp_pos _))
      simpa [hω] using hmain
  have hM :
      M =
        Real.exp (-(lam * T)) *
          P.expectationReal (fun ω => Real.exp (lam * X ω)) := by
    unfold M expectationReal
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro ω _
    have hexp :
        Real.exp (lam * X ω - lam * T) =
          Real.exp (-(lam * T)) * Real.exp (lam * X ω) := by
      calc
        Real.exp (lam * X ω - lam * T)
            = Real.exp (-(lam * T) + lam * X ω) := by
                congr 1
                ring
        _ = Real.exp (-(lam * T)) * Real.exp (lam * X ω) := by
                rw [Real.exp_add]
    rw [hexp]
    ring
  exact hle.trans_eq hM

/-- Lower-tail complement form of real-valued exponential Markov. -/
theorem eventProb_real_le_ge_one_sub_exp_mul_mgf
    (P : FiniteProbability Ω) (X : Ω → ℝ) (T : ℝ) {lam : ℝ}
    (hlam : 0 < lam) :
    1 - Real.exp (-(lam * T)) *
        P.expectationReal (fun ω => Real.exp (lam * X ω)) ≤
      P.eventProb {ω | X ω ≤ T} := by
  classical
  let E : Set Ω := {ω | X ω ≤ T}
  have htail :=
    eventProb_real_ge_le_exp_mul_mgf P X (T := T) (lam := lam) hlam
  have hcompl_subset :
      Eᶜ ⊆ {ω | T ≤ X ω} := by
    intro ω hω
    exact le_of_lt (by simpa [E, not_le] using hω)
  have htailE :
      P.eventProb Eᶜ ≤
        Real.exp (-(lam * T)) *
          P.expectationReal (fun ω => Real.exp (lam * X ω)) :=
    (eventProb_mono P hcompl_subset).trans htail
  have hsplit := eventProb_add_eventProb_compl P E
  linarith

/-- If a real-valued random variable has an exponential-moment bound at a
positive parameter, then exponential Markov gives a one-sided lower bound for
the corresponding sublevel event.  This is the reusable Chernoff step used after
subgaussian MGF estimates such as the Ledoux/Talagrand convex-Lipschitz
Rademacher bound. -/
theorem eventProb_real_le_ge_one_sub_exp_of_mgf_bound
    (P : FiniteProbability Ω) (X : Ω → ℝ) (T lam R : ℝ)
    (hlam : 0 < lam)
    (hmgf : P.expectationReal (fun ω => Real.exp (lam * X ω)) ≤
      Real.exp R) :
    1 - Real.exp (R - lam * T) ≤ P.eventProb {ω | X ω ≤ T} := by
  have hbase :=
    eventProb_real_le_ge_one_sub_exp_mul_mgf P X T (lam := lam) hlam
  have hfactor :
      Real.exp (-(lam * T)) *
          P.expectationReal (fun ω => Real.exp (lam * X ω)) ≤
        Real.exp (R - lam * T) := by
    calc
      Real.exp (-(lam * T)) *
          P.expectationReal (fun ω => Real.exp (lam * X ω))
          ≤ Real.exp (-(lam * T)) * Real.exp R :=
            mul_le_mul_of_nonneg_left hmgf (le_of_lt (Real.exp_pos _))
      _ = Real.exp (R - lam * T) := by
            rw [← Real.exp_add]
            congr 1
            ring
  linarith

/-- Optimized one-sided subgaussian tail from a centered MGF bound.  The
statement is deliberately finite-probability-native: the hard input is only the
MGF estimate, while this theorem performs the Chernoff optimization
`λ = t / σ^2`. -/
theorem eventProb_real_le_mean_add_ge_one_sub_exp_sq_of_subgaussian_mgf
    (P : FiniteProbability Ω) (X : Ω → ℝ) (μ σ t : ℝ)
    (hσ : 0 < σ) (ht : 0 < t)
    (hmgf : ∀ lam : ℝ, 0 < lam →
      P.expectationReal (fun ω => Real.exp (lam * (X ω - μ))) ≤
        Real.exp (lam ^ 2 * σ ^ 2 / 2)) :
    1 - Real.exp (-(t ^ 2 / (2 * σ ^ 2))) ≤
      P.eventProb {ω | X ω ≤ μ + t} := by
  let lam : ℝ := t / σ ^ 2
  have hσsq_pos : 0 < σ ^ 2 := sq_pos_of_pos hσ
  have hσsq_ne : σ ^ 2 ≠ 0 := ne_of_gt hσsq_pos
  have hlam : 0 < lam := by
    exact div_pos ht hσsq_pos
  have hchernoff :=
    eventProb_real_le_ge_one_sub_exp_of_mgf_bound P
      (fun ω => X ω - μ) t lam (lam ^ 2 * σ ^ 2 / 2) hlam
      (hmgf lam hlam)
  have hexp :
      lam ^ 2 * σ ^ 2 / 2 - lam * t =
        -(t ^ 2 / (2 * σ ^ 2)) := by
    dsimp [lam]
    field_simp [hσsq_ne]
    ring
  have hset :
      {ω | X ω - μ ≤ t} = {ω | X ω ≤ μ + t} := by
    ext ω
    simp
    constructor
    · intro hω
      linarith
    · intro hω
      linarith
  simpa [hset, hexp, add_comm, add_left_comm, add_assoc] using hchernoff

/-- Chernoff tail from a log-Laplace bound.

This composes the visible log-MGF/Laplace hypothesis with the repository's
finite subgaussian Chernoff optimizer. It is the reusable endpoint for a future
formalized Ledoux/Talagrand Laplace estimate. -/
theorem eventProb_real_le_mean_add_ge_one_sub_exp_sq_of_log_mgf_bound
    (P : FiniteProbability Ω) (X : Ω → ℝ) (μ σ t : ℝ)
    (hσ : 0 < σ) (ht : 0 < t)
    (hlog :
      ∀ lam : ℝ, 0 < lam →
        Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω))) ≤
          lam * μ + lam ^ 2 * σ ^ 2 / 2) :
    1 - Real.exp (-(t ^ 2 / (2 * σ ^ 2))) ≤
      P.eventProb {ω | X ω ≤ μ + t} := by
  refine
    eventProb_real_le_mean_add_ge_one_sub_exp_sq_of_subgaussian_mgf
      P X μ σ t hσ ht ?_
  intro lam hlam
  exact
    expectationReal_exp_centered_le_exp_of_log_mgf_le
      P X μ (lam ^ 2 * σ ^ 2 / 2) lam (hlog lam hlam)

/-- One-sided finite concentration from an exponential-entropy bound.

If the visible entropy inequality
`Ent(exp(λX)) <= (σ^2 / 2) λ^2 E exp(λX)` holds for all positive `λ`, then
Herbst's argument and Chernoff optimization give the usual upper-tail
subgaussian event.  This theorem is intentionally still conditional on the
entropy inequality; the active Ledoux/Talagrand bottleneck is to prove that
entropy inequality for separately convex 1-Lipschitz functions under the
finite product law. -/
theorem eventProb_real_le_mean_add_ge_one_sub_exp_sq_of_entropyReal_exp_mul_le
    (P : FiniteProbability Ω) (X : Ω → ℝ) (σ t : ℝ)
    (hσ : 0 < σ) (ht : 0 < t)
    (hEnt : ∀ lam : ℝ, 0 < lam →
      entropyReal P (fun ω => Real.exp (lam * X ω)) ≤
        (σ ^ 2 / 2) * lam ^ 2 *
          P.expectationReal (fun ω => Real.exp (lam * X ω))) :
    1 - Real.exp (-(t ^ 2 / (2 * σ ^ 2))) ≤
      P.eventProb {ω | X ω ≤ P.expectationReal X + t} := by
  refine
    eventProb_real_le_mean_add_ge_one_sub_exp_sq_of_log_mgf_bound
      P X (P.expectationReal X) σ t hσ ht ?_
  intro lam hlam
  have hlog :=
    log_mgf_le_mean_add_quadratic_of_entropyReal_exp_mul_le
      P X (σ ^ 2 / 2) hEnt lam hlam
  calc
    Real.log (P.expectationReal (fun ω => Real.exp (lam * X ω)))
        ≤ lam * P.expectationReal X + (σ ^ 2 / 2) * lam ^ 2 := hlog
    _ = lam * P.expectationReal X + lam ^ 2 * σ ^ 2 / 2 := by
        ring

/-- Exponential Markov inequality for natural-valued random variables. This is
    the finite-probability kernel behind the Chernoff upper-tail bound. -/
theorem eventProb_nat_ge_le_exp_mul_mgf
    (P : FiniteProbability Ω) (X : Ω → ℕ) {T : ℕ} {lam : ℝ}
    (hlam : 0 < lam) :
    P.eventProb {ω | T ≤ X ω} ≤
      Real.exp (-(lam * (T : ℝ))) *
        P.expectationReal (fun ω => Real.exp (lam * (X ω : ℝ))) := by
  classical
  let M : ℝ :=
    ∑ ω, P.prob ω * Real.exp (lam * (X ω : ℝ) - lam * (T : ℝ))
  have hle : P.eventProb {ω | T ≤ X ω} ≤ M := by
    unfold eventProb M
    apply Finset.sum_le_sum
    intro ω _
    by_cases hω : ω ∈ {ω | T ≤ X ω}
    · have hXT : (T : ℝ) ≤ X ω := by exact_mod_cast hω
      have hlamT : lam * (T : ℝ) ≤ lam * (X ω : ℝ) :=
        mul_le_mul_of_nonneg_left hXT (le_of_lt hlam)
      have hone :
          1 ≤ Real.exp (lam * (X ω : ℝ) - lam * (T : ℝ)) := by
        calc
          (1 : ℝ) = Real.exp 0 := by rw [Real.exp_zero]
          _ ≤ Real.exp (lam * (X ω : ℝ) - lam * (T : ℝ)) :=
              Real.exp_le_exp.mpr (by linarith)
      have hmain :
          P.prob ω ≤
            P.prob ω * Real.exp (lam * (X ω : ℝ) - lam * (T : ℝ)) := by
        calc
          P.prob ω = P.prob ω * 1 := by ring
          _ ≤ P.prob ω *
              Real.exp (lam * (X ω : ℝ) - lam * (T : ℝ)) :=
              mul_le_mul_of_nonneg_left hone (P.prob_nonneg ω)
      simpa [hω] using hmain
    · have hmain :
          0 ≤ P.prob ω *
            Real.exp (lam * (X ω : ℝ) - lam * (T : ℝ)) :=
        mul_nonneg (P.prob_nonneg ω)
          (le_of_lt (Real.exp_pos _))
      simpa [hω] using hmain
  have hM :
      M =
        Real.exp (-(lam * (T : ℝ))) *
          P.expectationReal (fun ω => Real.exp (lam * (X ω : ℝ))) := by
    unfold M expectationReal
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro ω _
    have hexp :
        Real.exp (lam * (X ω : ℝ) - lam * (T : ℝ)) =
          Real.exp (-(lam * (T : ℝ))) *
            Real.exp (lam * (X ω : ℝ)) := by
      calc
        Real.exp (lam * (X ω : ℝ) - lam * (T : ℝ))
            = Real.exp (-(lam * (T : ℝ)) + lam * (X ω : ℝ)) := by
                congr 1
                ring
        _ = Real.exp (-(lam * (T : ℝ))) *
            Real.exp (lam * (X ω : ℝ)) := by
                rw [Real.exp_add]
    rw [hexp]
    ring
  exact hle.trans_eq hM

/-- Chernoff upper tail from an exponential-moment bound. If
    `E exp(lamX) ≤ exp(μ(exp lam - 1))`, then
    `Pr(T ≤ X) ≤ exp(μ(exp lam - 1) - lamT)`. -/
theorem eventProb_nat_ge_le_chernoff_of_mgf_bound
    (P : FiniteProbability Ω) (X : Ω → ℕ) {T : ℕ} {lam μ : ℝ}
    (hlam : 0 < lam)
    (hmgf :
      P.expectationReal (fun ω => Real.exp (lam * (X ω : ℝ))) ≤
        Real.exp (μ * (Real.exp lam - 1))) :
    P.eventProb {ω | T ≤ X ω} ≤
      Real.exp (μ * (Real.exp lam - 1) - lam * (T : ℝ)) := by
  have hmarkov := eventProb_nat_ge_le_exp_mul_mgf P X (T := T) hlam
  have hmul :
      Real.exp (-(lam * (T : ℝ))) *
          P.expectationReal (fun ω => Real.exp (lam * (X ω : ℝ))) ≤
        Real.exp (-(lam * (T : ℝ))) *
          Real.exp (μ * (Real.exp lam - 1)) :=
    mul_le_mul_of_nonneg_left hmgf (le_of_lt (Real.exp_pos _))
  have hexp :
      Real.exp (-(lam * (T : ℝ))) *
          Real.exp (μ * (Real.exp lam - 1)) =
        Real.exp (μ * (Real.exp lam - 1) - lam * (T : ℝ)) := by
    calc
      Real.exp (-(lam * (T : ℝ))) *
          Real.exp (μ * (Real.exp lam - 1))
          = Real.exp (-(lam * (T : ℝ)) +
              μ * (Real.exp lam - 1)) := by
              rw [← Real.exp_add]
      _ = Real.exp (μ * (Real.exp lam - 1) - lam * (T : ℝ)) := by
              congr 1
              ring
  exact hmarkov.trans (hmul.trans_eq hexp)

/-- Lower-tail complement form of the Chernoff upper-tail bound. -/
theorem eventProb_nat_le_ge_one_sub_chernoff_of_mgf_bound
    (P : FiniteProbability Ω) (X : Ω → ℕ) (Q : ℕ) {lam μ : ℝ}
    (hlam : 0 < lam)
    (hmgf :
      P.expectationReal (fun ω => Real.exp (lam * (X ω : ℝ))) ≤
        Real.exp (μ * (Real.exp lam - 1))) :
    1 - Real.exp (μ * (Real.exp lam - 1) -
        lam * (((Q + 1 : ℕ) : ℝ))) ≤
      P.eventProb {ω | X ω ≤ Q} := by
  classical
  let E : Set Ω := {ω | X ω ≤ Q}
  have htail :=
    eventProb_nat_ge_le_chernoff_of_mgf_bound P X
      (T := Q + 1) hlam hmgf
  have hcompl :
      Eᶜ = {ω | Q + 1 ≤ X ω} := by
    ext ω
    simp [E]
  have htailE :
      P.eventProb Eᶜ ≤
        Real.exp (μ * (Real.exp lam - 1) -
          lam * (((Q + 1 : ℕ) : ℝ))) := by
    simpa [hcompl] using htail
  have hsplit := eventProb_add_eventProb_compl P E
  linarith

end FiniteProbability

end NumStability
```

### `ComputationalMathematics.HDP.Scalar.SubExponentialExamples`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/SubExponentialExamples.lean`
SHA-256: `edab4ae249fc717fbcaec859c08ce88de5892f9c7b1cd5bf443fe9a657486428`

```lean
import ComputationalMathematics.HDP.Scalar.SubExponential
import ComputationalMathematics.HDP.Scalar.PoissonNormal
import ComputationalMathematics.Analysis.FiniteProbability

/-!
# Canonical sub-exponential distributions

Reusable distribution-level facts for the exponential and Poisson examples in
Vershynin, Example 2.7.8.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Scalar.SubExponentialExamples

open NumStability.HDP.Scalar.SubExponential

/-- An exponential law of positive rate `λ` is the push-forward of the
rate-one law by division by `λ`. -/
theorem map_div_expMeasure_one {lambda : ℝ} (hlambda : 0 < lambda) :
    Measure.map (fun x : ℝ ↦ x / lambda) (expMeasure 1) = expMeasure lambda := by
  letI : IsProbabilityMeasure (expMeasure 1) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure (by norm_num)
  letI : IsProbabilityMeasure (expMeasure lambda) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure hlambda
  apply Measure.ext_of_Iic
  intro x
  rw [Measure.map_apply (by fun_prop) measurableSet_Iic]
  have hpre : (fun y : ℝ ↦ y / lambda) ⁻¹' Iic x = Iic (lambda * x) := by
    ext y
    simp only [mem_preimage, mem_Iic]
    constructor <;> intro h
    · exact (div_le_iff₀' hlambda).1 h
    · exact (div_le_iff₀' hlambda).2 h
  rw [hpre, ← ProbabilityTheory.ofReal_cdf (expMeasure 1) (lambda * x),
    ← ProbabilityTheory.ofReal_cdf (expMeasure lambda) x]
  congr 1
  rw [ProbabilityTheory.cdf_expMeasure_eq (by norm_num),
    ProbabilityTheory.cdf_expMeasure_eq hlambda]
  by_cases hx : 0 ≤ x
  · rw [if_pos hx, if_pos (mul_nonneg hlambda.le hx)]
    congr 2
    ring
  · rw [if_neg hx, if_neg]
    exact not_le_of_gt (mul_neg_of_pos_of_neg hlambda (lt_of_not_ge hx))

/-- The rate-one exponential law is supported on the nonnegative half-line. -/
lemma expMeasure_one_ae_nonneg : ∀ᵐ x : ℝ ∂expMeasure 1, 0 ≤ x := by
  letI : IsProbabilityMeasure (expMeasure 1) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure (by norm_num)
  rw [ae_iff]
  have hIic : expMeasure 1 (Iic (0 : ℝ)) = 0 := by
    rw [← ProbabilityTheory.ofReal_cdf (expMeasure 1) 0,
      ProbabilityTheory.cdf_expMeasure_eq (by norm_num)]
    simp
  apply measure_mono_null _ hIic
  intro x hx
  exact le_of_lt (lt_of_not_ge hx)

/-- With the book's threshold `E exp(|X|/K) ≤ 2`, the identity variable
under the rate-one exponential law has exact `ψ₁` gauge `2`. -/
theorem psiOneGauge_id_expMeasure_one :
    PsiOneGauge (expMeasure 1) (fun x : ℝ ↦ x) = 2 := by
  letI : IsProbabilityMeasure (expMeasure 1) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure (by norm_num)
  have habs (K : ℝ) :
      (fun x : ℝ ↦ Real.exp (|x| / K)) =ᵐ[expMeasure 1]
        (fun x : ℝ ↦ Real.exp (K⁻¹ * x)) := by
    filter_upwards [expMeasure_one_ae_nonneg] with x hx
    rw [abs_of_nonneg hx]
    congr 1
    ring
  have htwo : PsiOneAdmissible (expMeasure 1) (fun x : ℝ ↦ x) 2 := by
    have hMGF := remark279_exp_mgf_lt_one (lam := (2 : ℝ)⁻¹) (by norm_num)
    have hEq := habs 2
    refine ⟨measurable_id, by norm_num, by norm_num, ?_, ?_⟩
    · change Integrable (fun x : ℝ ↦ Real.exp (|x| / 2)) (expMeasure 1)
      exact hMGF.1.congr hEq.symm
    · change (∫ x : ℝ, Real.exp (|x| / 2) ∂expMeasure 1) ≤ 2
      rw [integral_congr_ae hEq, hMGF.2]
      norm_num
  apply le_antisymm
  · exact sInf_le htwo
  · apply le_sInf
    intro t ht
    rcases ht with ⟨_, ht0, htTop, hInt, hBound⟩
    have hK : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
    rw [← ENNReal.ofReal_toReal htTop]
    rw [show (2 : ℝ≥0∞) = ENNReal.ofReal 2 by norm_num]
    apply ENNReal.ofReal_le_ofReal
    by_contra hnot
    have hKlt : t.toReal < 2 := lt_of_not_ge hnot
    have hEq := habs t.toReal
    have hMGFInt : Integrable (fun x : ℝ ↦ Real.exp ((t.toReal)⁻¹ * x))
        (expMeasure 1) := hInt.congr hEq
    by_cases hKone : t.toReal ≤ 1
    · have hInvOne : 1 ≤ (t.toReal)⁻¹ := by
        exact (one_le_inv₀ hK).2 hKone
      exact (remark279_exp_mgf_not_integrable hInvOne) hMGFInt
    · have hOneK : 1 < t.toReal := lt_of_not_ge hKone
      have hInvLt : (t.toReal)⁻¹ < 1 := by
        rw [inv_lt_one₀ hK]
        exact hOneK
      have hMGF := remark279_exp_mgf_lt_one hInvLt
      have hBound' : (1 - (t.toReal)⁻¹)⁻¹ ≤ 2 := by
        rw [← hMGF.2, ← integral_congr_ae hEq]
        exact hBound
      have hDen : 0 < t.toReal - 1 := sub_pos.mpr hOneK
      have hFormula : (1 - (t.toReal)⁻¹)⁻¹ =
          t.toReal / (t.toReal - 1) := by
        field_simp [hK.ne', hDen.ne']
      have hTooLarge : 2 < t.toReal / (t.toReal - 1) := by
        rw [lt_div_iff₀ hDen]
        linarith
      rw [hFormula] at hBound'
      exact (not_lt_of_ge hBound') hTooLarge

/-- The exponential law of rate `λ > 0` has exact `ψ₁` gauge `2 / λ` in
the normalization of Definition 2.7.5. -/
theorem psiOneGauge_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    PsiOneGauge (expMeasure lambda) (fun x : ℝ ↦ x) =
      ENNReal.ofReal (2 / lambda) := by
  rw [← map_div_expMeasure_one hlambda,
    psiOneGauge_map (by fun_prop : Measurable (fun x : ℝ ↦ x / lambda))]
  have hfun : (fun x : ℝ ↦ x / lambda) = (fun x : ℝ ↦ lambda⁻¹ * x) := by
    funext x
    ring
  rw [hfun, psiOneGauge_smul_of_pos (inv_pos.mpr hlambda),
    psiOneGauge_id_expMeasure_one]
  rw [show (2 : ℝ≥0∞) = ENNReal.ofReal 2 by norm_num,
    ← ENNReal.ofReal_mul (inv_nonneg.mpr hlambda.le)]
  congr 1
  field_simp

private lemma expMeasure_one_pdf_measurable :
    Measurable (ProbabilityTheory.exponentialPDF 1) := by
  unfold ProbabilityTheory.exponentialPDF
  exact (ProbabilityTheory.measurable_exponentialPDFReal 1).ennreal_ofReal

/-- The identity is integrable under the rate-one exponential law. -/
lemma integrable_id_expMeasure_one :
    Integrable (fun x : ℝ ↦ x) (expMeasure 1) := by
  change Integrable (fun x : ℝ ↦ x)
    (volume.withDensity (ProbabilityTheory.exponentialPDF 1))
  rw [integrable_withDensity_iff expMeasure_one_pdf_measurable
    (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  have hIoi : IntegrableOn (fun x : ℝ ↦ Real.exp (-x) * x) (Ioi 0) volume := by
    apply (Real.GammaIntegral_convergent (s := 2) (by norm_num)).congr_fun
    · intro x hx
      change Real.exp (-x) * x ^ ((2 : ℝ) - 1) = Real.exp (-x) * x
      rw [show (2 : ℝ) - 1 = 1 by norm_num, Real.rpow_one]
    · exact measurableSet_Ioi
  have hIci : IntegrableOn (fun x : ℝ ↦ Real.exp (-x) * x) (Ici 0) volume :=
    (integrableOn_Ici_iff_integrableOn_Ioi).2 hIoi
  have hIndicator : Integrable
      ((Ici (0 : ℝ)).indicator (fun x : ℝ ↦ Real.exp (-x) * x)) volume :=
    hIci.integrable_indicator measurableSet_Ici
  apply hIndicator.congr
  filter_upwards with x
  by_cases hx : 0 ≤ x
  · simp [ProbabilityTheory.exponentialPDF,
      ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
    rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
    ring
  · simp [ProbabilityTheory.exponentialPDF,
      ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]

/-- The mean of the rate-one exponential law is one. -/
theorem integral_id_expMeasure_one :
    (∫ x : ℝ, x ∂expMeasure 1) = 1 := by
  change (∫ x : ℝ, x ∂volume.withDensity
    (ProbabilityTheory.exponentialPDF 1)) = 1
  rw [integral_withDensity_eq_integral_toReal_smul expMeasure_one_pdf_measurable
    (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  simp_rw [smul_eq_mul]
  have hfun : (fun x : ℝ ↦ (ProbabilityTheory.exponentialPDF 1 x).toReal * x) =
      (Ici (0 : ℝ)).indicator (fun x : ℝ ↦ x * Real.exp (-x)) := by
    funext x
    by_cases hx : 0 ≤ x
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
      rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
      ring
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
  rw [hfun, integral_indicator measurableSet_Ici, integral_Ici_eq_integral_Ioi]
  have hIntegral := Real.integral_rpow_mul_exp_neg_mul_Ioi
    (a := 2) (r := 1) (by norm_num) (by norm_num)
  calc
    (∫ t : ℝ in Ioi 0, t * Real.exp (-t)) =
        ∫ t : ℝ in Ioi 0, t ^ ((2 : ℝ) - 1) * Real.exp (-(1 * t)) := by
          apply setIntegral_congr_fun measurableSet_Ioi
          intro t ht
          change t * Real.exp (-t) =
            t ^ ((2 : ℝ) - 1) * Real.exp (-(1 * t))
          rw [show (2 : ℝ) - 1 = 1 by norm_num, Real.rpow_one]
          ring
    _ = (1 / (1 : ℝ)) ^ (2 : ℝ) * Real.Gamma 2 := hIntegral
    _ = 1 := by
      have hGamma : Real.Gamma 2 = 1 := by
        convert Real.Gamma_nat_eq_factorial 1 using 1 <;> norm_num
      rw [hGamma]
      norm_num

/-- The squared identity is integrable under the rate-one exponential law. -/
lemma integrable_sq_id_expMeasure_one :
    Integrable (fun x : ℝ ↦ x ^ 2) (expMeasure 1) := by
  change Integrable (fun x : ℝ ↦ x ^ 2)
    (volume.withDensity (ProbabilityTheory.exponentialPDF 1))
  rw [integrable_withDensity_iff expMeasure_one_pdf_measurable
    (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  have hIoi : IntegrableOn (fun x : ℝ ↦ Real.exp (-x) * x ^ 2) (Ioi 0) volume := by
    apply (Real.GammaIntegral_convergent (s := 3) (by norm_num)).congr_fun
    · intro x hx
      change Real.exp (-x) * x ^ ((3 : ℝ) - 1) = Real.exp (-x) * x ^ 2
      rw [show (3 : ℝ) - 1 = 2 by norm_num, Real.rpow_two]
    · exact measurableSet_Ioi
  have hIci : IntegrableOn (fun x : ℝ ↦ Real.exp (-x) * x ^ 2) (Ici 0) volume :=
    (integrableOn_Ici_iff_integrableOn_Ioi).2 hIoi
  have hIndicator : Integrable
      ((Ici (0 : ℝ)).indicator (fun x : ℝ ↦ Real.exp (-x) * x ^ 2)) volume :=
    hIci.integrable_indicator measurableSet_Ici
  apply hIndicator.congr
  filter_upwards with x
  by_cases hx : 0 ≤ x
  · simp [ProbabilityTheory.exponentialPDF,
      ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
    rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
    ring
  · simp [ProbabilityTheory.exponentialPDF,
      ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]

/-- The raw second moment of the rate-one exponential law is two. -/
theorem integral_sq_id_expMeasure_one :
    (∫ x : ℝ, x ^ 2 ∂expMeasure 1) = 2 := by
  change (∫ x : ℝ, x ^ 2 ∂volume.withDensity
    (ProbabilityTheory.exponentialPDF 1)) = 2
  rw [integral_withDensity_eq_integral_toReal_smul expMeasure_one_pdf_measurable
    (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  simp_rw [smul_eq_mul]
  have hfun :
      (fun x : ℝ ↦ (ProbabilityTheory.exponentialPDF 1 x).toReal * x ^ 2) =
        (Ici (0 : ℝ)).indicator (fun x : ℝ ↦ x ^ 2 * Real.exp (-x)) := by
    funext x
    by_cases hx : 0 ≤ x
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
      rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
      ring
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
  rw [hfun, integral_indicator measurableSet_Ici, integral_Ici_eq_integral_Ioi]
  have hIntegral := Real.integral_rpow_mul_exp_neg_mul_Ioi
    (a := 3) (r := 1) (by norm_num) (by norm_num)
  calc
    (∫ t : ℝ in Ioi 0, t ^ 2 * Real.exp (-t)) =
        ∫ t : ℝ in Ioi 0, t ^ ((3 : ℝ) - 1) * Real.exp (-(1 * t)) := by
          apply setIntegral_congr_fun measurableSet_Ioi
          intro t ht
          change t ^ 2 * Real.exp (-t) =
            t ^ ((3 : ℝ) - 1) * Real.exp (-(1 * t))
          rw [show (3 : ℝ) - 1 = 2 by norm_num, Real.rpow_two]
          ring
    _ = (1 / (1 : ℝ)) ^ (3 : ℝ) * Real.Gamma 3 := hIntegral
    _ = 2 := by
      have hGamma : Real.Gamma 3 = 2 := by
        convert Real.Gamma_nat_eq_factorial 2 using 1 <;> norm_num
      rw [hGamma]
      norm_num

/-- The mean of an exponential law of rate `λ > 0` is `1 / λ`. -/
theorem integral_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    (∫ x : ℝ, x ∂expMeasure lambda) = 1 / lambda := by
  rw [← map_div_expMeasure_one hlambda,
    integral_map (by fun_prop : AEMeasurable (fun x : ℝ ↦ x / lambda) (expMeasure 1))
      (by fun_prop : AEStronglyMeasurable (fun x : ℝ ↦ x)
        (Measure.map (fun x : ℝ ↦ x / lambda) (expMeasure 1)))]
  rw [integral_div, integral_id_expMeasure_one]

/-- The raw second moment of an exponential law of rate `λ > 0` is
`2 / λ²`. -/
theorem integral_sq_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    (∫ x : ℝ, x ^ 2 ∂expMeasure lambda) = 2 / lambda ^ 2 := by
  rw [← map_div_expMeasure_one hlambda,
    integral_map (by fun_prop : AEMeasurable (fun x : ℝ ↦ x / lambda) (expMeasure 1))
      (by fun_prop : AEStronglyMeasurable (fun x : ℝ ↦ x ^ 2)
        (Measure.map (fun x : ℝ ↦ x / lambda) (expMeasure 1)))]
  have hfun : (fun x : ℝ ↦ (x / lambda) ^ 2) =
      (fun x : ℝ ↦ lambda⁻¹ ^ 2 * x ^ 2) := by
    funext x
    field_simp
  rw [hfun, integral_const_mul, integral_sq_id_expMeasure_one]
  field_simp

/-- The identity belongs to `L²` under every positive-rate exponential law. -/
theorem memLp_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    MemLp (fun x : ℝ ↦ x) 2 (expMeasure lambda) := by
  refine (memLp_two_iff_integrable_sq
    (f := fun x : ℝ ↦ x) measurable_id.aestronglyMeasurable).2 ?_
  rw [← map_div_expMeasure_one hlambda]
  apply (integrable_map_measure (by fun_prop)
    (by fun_prop : AEMeasurable (fun x : ℝ ↦ x / lambda) (expMeasure 1))).2
  have h := integrable_sq_id_expMeasure_one.const_mul (lambda⁻¹ ^ 2)
  apply h.congr
  filter_upwards with x
  dsimp [Function.comp_def]
  field_simp

/-- The variance of an exponential law of rate `λ > 0` is `1 / λ²`. -/
theorem variance_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    Var[fun x : ℝ ↦ x; expMeasure lambda] = 1 / lambda ^ 2 := by
  letI : IsProbabilityMeasure (expMeasure lambda) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure hlambda
  rw [variance_eq_sub (memLp_id_expMeasure hlambda)]
  change (∫ x : ℝ, x ^ 2 ∂expMeasure lambda) -
    (∫ x : ℝ, x ∂expMeasure lambda) ^ 2 = 1 / lambda ^ 2
  rw [integral_sq_id_expMeasure hlambda, integral_id_expMeasure hlambda]
  field_simp [hlambda.ne']
  ring

/-- The natural-number coordinate under every Poisson law has finite `ψ₁`
gauge.  The proof reuses the exact Poisson MGF and an existing scalar
exponential remainder bound. -/
theorem psiOneGauge_natCast_poisson_lt_top (rate : ℝ≥0) :
    PsiOneGauge (ProbabilityTheory.poissonMeasure rate)
      (fun n : ℕ ↦ (n : ℝ)) < ∞ := by
  let r : ℝ := rate
  let K : ℝ := 4 * Real.exp 1 * (r + 1)
  let s : ℝ := K⁻¹
  have hr0 : 0 ≤ r := by positivity
  have hr1 : 0 < r + 1 := by positivity
  have hK : 0 < K := by
    dsimp [K]
    positivity
  have hKone : 1 ≤ K := by
    dsimp [K]
    nlinarith [Real.exp_one_gt_two]
  have hs : 0 < s := by
    dsimp [s]
    positivity
  have hsOne : s ≤ 1 := by
    dsimp [s]
    exact (inv_le_one₀ hK).2 hKone
  have hExpS : Real.exp s ≤ Real.exp 1 := Real.exp_le_exp.mpr hsOne
  have hRem : Real.exp s - 1 ≤ s * Real.exp 1 :=
    (NumStability.real_exp_sub_one_le_mul_exp s).trans
      (mul_le_mul_of_nonneg_left hExpS hs.le)
  have hExponent : r * (Real.exp s - 1) ≤ 1 / 4 := by
    calc
      r * (Real.exp s - 1) ≤ r * (s * Real.exp 1) :=
        mul_le_mul_of_nonneg_left hRem hr0
      _ = r / (4 * (r + 1)) := by
        dsimp [s, K]
        field_simp [Real.exp_ne_zero]
      _ ≤ 1 / 4 := by
        rw [div_le_iff₀ (by positivity : (0 : ℝ) < 4 * (r + 1))]
        nlinarith
  have hfun : (fun n : ℕ ↦ Real.exp (|(n : ℝ)| / K)) =
      (fun n : ℕ ↦ Real.exp (s * (n : ℝ))) := by
    funext n
    rw [abs_of_nonneg (Nat.cast_nonneg n)]
    congr 1
    simp [s, div_eq_mul_inv, mul_comm]
  apply (psiOneGauge_finite_iff).2
  refine ⟨K, hK, measurable_of_countable _, hK, ?_, ?_⟩
  · rw [hfun]
    exact NumStability.HDP.Scalar.IndependentSums.PoissonChernoff.integrable_exp_nat_poisson
      rate s
  · rw [hfun,
      NumStability.HDP.Scalar.IndependentSums.PoissonChernoff.poissonMgfExact]
    calc
      Real.exp (r * (Real.exp s - 1)) ≤ Real.exp (1 / 4) :=
        Real.exp_le_exp.mpr hExponent
      _ ≤ Real.exp (Real.log 2) := by
        apply Real.exp_le_exp.mpr
        linarith [Real.log_two_gt_d9]
      _ = 2 := Real.exp_log (by norm_num)

/-- Every real-valued Poisson distribution is sub-exponential. -/
theorem psiOneGauge_id_poissonRealLaw_lt_top (rate : ℝ≥0) :
    PsiOneGauge
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      (fun x : ℝ ↦ x) < ∞ := by
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw,
    psiOneGauge_map (measurable_of_countable (fun n : ℕ ↦ (n : ℝ)))]
  exact psiOneGauge_natCast_poisson_lt_top rate

end NumStability.HDP.Scalar.SubExponentialExamples
```

### `ComputationalMathematics.HDP.Scalar.SubExponentialCentering`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/SubExponentialCentering.lean`
SHA-256: `7c0678eaf9d756ad11d99fe3bcced65a3e4220d99c841d09433833086a332543`

```lean
import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Centering a sub-exponential random variable

This module proves the intrinsic `ψ₁`-gauge form of Exercise 2.7.10.  The
universal constant is quantified outside the probability space and random
variable, matching the source's use of an absolute constant.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Scalar.SubExponential

/-! ## The triangle inequality for the exact `ψ₁` gauge -/

/-- Admissible `ψ₁` scales add.  Convexity of the exponential combines the
two normalized exponential moments. -/
lemma psiOneAdmissible_add_of_admissible
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {s t : ℝ≥0∞}
    (hs : PsiOneAdmissible μ X s) (ht : PsiOneAdmissible μ Y t) :
    PsiOneAdmissible μ (fun ω => X ω + Y ω) (s + t) := by
  rcases hs with ⟨hX, hs0, hsTop, hXs, hXbound⟩
  rcases ht with ⟨hY, ht0, htTop, hYt, hYbound⟩
  have hspos : 0 < s.toReal := ENNReal.toReal_pos hs0 hsTop
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hstTop : s + t ≠ ∞ := ENNReal.add_ne_top.2 ⟨hsTop, htTop⟩
  have hst0 : s + t ≠ 0 := by simp [hs0, ht0]
  have hstpos : 0 < (s + t).toReal := ENNReal.toReal_pos hst0 hstTop
  have hstreal : (s + t).toReal = s.toReal + t.toReal := by
    simpa using ENNReal.toReal_add hsTop htTop
  let a : ℝ := s.toReal / (s + t).toReal
  let b : ℝ := t.toReal / (s + t).toReal
  have ha : 0 ≤ a := div_nonneg hspos.le hstpos.le
  have hb : 0 ≤ b := div_nonneg htpos.le hstpos.le
  have hab : a + b = 1 := by
    dsimp [a, b]
    rw [hstreal]
    field_simp
  have harg : ∀ ω,
      |X ω + Y ω| / (s + t).toReal ≤
        a * (|X ω| / s.toReal) + b * (|Y ω| / t.toReal) := by
    intro ω
    have habs := abs_add_le (X ω) (Y ω)
    dsimp [a, b]
    rw [hstreal]
    field_simp
    nlinarith
  have hpoint : ∀ ω,
      Real.exp (|X ω + Y ω| / (s + t).toReal) ≤
        a * Real.exp (|X ω| / s.toReal) +
          b * Real.exp (|Y ω| / t.toReal) := by
    intro ω
    have hconv := convexOn_exp.2
      (show |X ω| / s.toReal ∈ Set.univ by trivial)
      (show |Y ω| / t.toReal ∈ Set.univ by trivial)
      ha hb hab
    exact (Real.exp_le_exp.mpr (harg ω)).trans hconv
  have hsum : Integrable (fun ω =>
      a * Real.exp (|X ω| / s.toReal) +
        b * Real.exp (|Y ω| / t.toReal)) μ :=
    (hXs.const_mul a).add (hYt.const_mul b)
  have hInt : Integrable
      (fun ω => Real.exp (|X ω + Y ω| / (s + t).toReal)) μ := by
    refine Integrable.mono' hsum (by fun_prop) ?_
    filter_upwards [] with ω
    simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hpoint ω
  refine ⟨hX.add hY, hst0, hstTop, hInt, ?_⟩
  have hmono := integral_mono_ae hInt hsum (Filter.Eventually.of_forall hpoint)
  calc
    (∫ ω, Real.exp (|X ω + Y ω| / (s + t).toReal) ∂μ) ≤
        ∫ ω, a * Real.exp (|X ω| / s.toReal) +
          b * Real.exp (|Y ω| / t.toReal) ∂μ := hmono
    _ = a * (∫ ω, Real.exp (|X ω| / s.toReal) ∂μ) +
          b * (∫ ω, Real.exp (|Y ω| / t.toReal) ∂μ) := by
      rw [integral_add (hXs.const_mul a) (hYt.const_mul b),
        integral_const_mul, integral_const_mul]
    _ ≤ a * 2 + b * 2 := by gcongr
    _ = 2 := by rw [← add_mul, hab, one_mul]

lemma psiOneAdmissible_neg_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {t : ℝ≥0∞} :
    PsiOneAdmissible μ (fun ω => -X ω) t ↔ PsiOneAdmissible μ X t := by
  constructor <;> intro h
  · rcases h with ⟨hX, ht0, htTop, hInt, hBound⟩
    refine ⟨by simpa using hX.neg, ht0, htTop, ?_, ?_⟩
    · simpa using hInt
    · simpa using hBound
  · rcases h with ⟨hX, ht0, htTop, hInt, hBound⟩
    refine ⟨hX.neg, ht0, htTop, ?_, ?_⟩
    · simpa using hInt
    · simpa using hBound

theorem psiOneGauge_neg
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    PsiOneGauge μ (fun ω => -X ω) = PsiOneGauge μ X := by
  unfold PsiOneGauge
  congr 1
  ext t
  exact psiOneAdmissible_neg_iff

theorem psiOneGauge_add_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} :
    PsiOneGauge μ (fun ω => X ω + Y ω) ≤
      PsiOneGauge μ X + PsiOneGauge μ Y := by
  change sInf {t : ℝ≥0∞ | PsiOneAdmissible μ (fun ω => X ω + Y ω) t} ≤
    sInf {s : ℝ≥0∞ | PsiOneAdmissible μ X s} +
      sInf {t : ℝ≥0∞ | PsiOneAdmissible μ Y t}
  simp only [sInf_eq_iInf]
  apply ENNReal.le_iInf₂_add_iInf₂
  intro s hs t ht
  have hadd := psiOneAdmissible_add_of_admissible hs ht
  exact iInf_le_of_le (s + t) (iInf_le_of_le hadd le_rfl)

/-! ## Constants and first moments -/

/-- A constant random variable has `ψ₁` gauge at most twice its absolute
value.  The deliberately non-optimal factor gives a simple universal scale. -/
theorem psiOneGauge_const_le_two_mul_abs
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (c : ℝ) :
    PsiOneGauge μ (fun _ : Ω => c) ≤ ENNReal.ofReal (2 * |c|) := by
  by_cases hc : c = 0
  · subst c
    simpa using (psiOneGauge_zero (Ω := Ω) (μ := μ))
  · unfold PsiOneGauge
    apply sInf_le
    have hcabs : 0 < |c| := abs_pos.mpr hc
    have hscale : 0 < 2 * |c| := by positivity
    have harg : |c| / (2 * |c|) = (1 / 2 : ℝ) := by field_simp
    have hexp : Real.exp (1 / 2 : ℝ) ≤ 2 := by
      calc
        Real.exp (1 / 2 : ℝ) ≤ Real.exp (Real.log 2) :=
          Real.exp_le_exp.mpr (by nlinarith [Real.log_two_gt_d9])
        _ = 2 := Real.exp_log (by norm_num)
    refine ⟨measurable_const, (ENNReal.ofReal_ne_zero_iff).2 hscale,
      ENNReal.ofReal_ne_top, ?_, ?_⟩
    · simp
    · simpa [ENNReal.toReal_ofReal hscale.le, harg] using hexp

/-- The first absolute moment is bounded by one universal multiple of the
exact `ψ₁` gauge. -/
theorem psiOneGaugeToMomentOne
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) (hFinite : PsiOneGauge μ X < ∞) :
    Integrable (fun ω => |X ω|) μ ∧
      (∫ ω, |X ω| ∂μ) ≤
        1024 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal := by
  by_cases hGaugeZero : PsiOneGauge μ X = 0
  · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
      (psiOneGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
    have hAbsZero : (fun ω => |X ω|) =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) := by
      filter_upwards [hXZero] with ω hω
      simp [hω]
    have hInt : Integrable (fun ω => |X ω|) μ :=
      (integrable_zero Ω ℝ μ).congr hAbsZero.symm
    refine ⟨hInt, ?_⟩
    rw [integral_congr_ae hAbsZero]
    simp [hGaugeZero]
  · have hGaugeRealPos : 0 < (PsiOneGauge μ X).toReal :=
      ENNReal.toReal_pos hGaugeZero (ne_of_lt hFinite)
    let K : ℝ := 2 * (PsiOneGauge μ X).toReal
    have hK : 0 < K := by dsimp [K]; positivity
    have hOfRealK : ENNReal.ofReal K = 2 * PsiOneGauge μ X := by
      dsimp [K]
      rw [ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 2),
        ENNReal.ofReal_toReal (ne_of_lt hFinite)]
      norm_num
    have hGaugeLt : PsiOneGauge μ X < ENNReal.ofReal K := by
      rw [hOfRealK]
      simpa [mul_comm] using ENNReal.mul_lt_mul_right hGaugeZero
        (ne_of_lt hFinite) (by norm_num : (1 : ℝ≥0∞) < 2)
    have hPoint : SubExponentialOnePointMGF μ X K :=
      psiOneGauge_lt_imp_onePointMGF hK hGaugeLt
    obtain ⟨L, _hL, hLBound, hMoment⟩ :=
      subExponentialPropertyTransfer .onePoint .moment hK hPoint
    change SubExponentialMomentBound μ X L at hMoment
    have hMomentOne := hMoment.2.2.2 1 (by norm_num : (1 : ℝ) ≤ 1)
    refine ⟨by simpa using hMomentOne.1, ?_⟩
    calc
      (∫ ω, |X ω| ∂μ) ≤ L := by simpa using hMomentOne.2
      _ ≤ 512 * (Real.exp 1) ^ 3 * K := hLBound
      _ = 1024 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal := by
        dsimp [K]
        ring

/-! ## Exercise 2.7.10 -/

/-- Intrinsic quantitative centering: subtracting the expectation preserves
finite `ψ₁` gauge and increases that gauge by at most one fixed factor. -/
theorem centeredSubExponentialPsiOneNorm
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) (hFinite : PsiOneGauge μ X < ∞) :
    PsiOneGauge μ (fun ω => X ω - ∫ x, X x ∂μ) < ∞ ∧
      PsiOneGauge μ (fun ω => X ω - ∫ x, X x ∂μ) ≤
        ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) * PsiOneGauge μ X := by
  have hMomentOne := psiOneGaugeToMomentOne hX hFinite
  have hInt : Integrable X μ := by
    apply (integrable_norm_iff hX.aestronglyMeasurable).mp
    simpa [Real.norm_eq_abs] using hMomentOne.1
  let m : ℝ := ∫ x, X x ∂μ
  have hMean : |m| ≤
      1024 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal := by
    have hIntegralNorm := norm_integral_le_integral_norm X (μ := μ)
    dsimp [m]
    calc
      |∫ x, X x ∂μ| ≤ ∫ x, ‖X x‖ ∂μ := hIntegralNorm
      _ = ∫ x, |X x| ∂μ := by simp only [Real.norm_eq_abs]
      _ ≤ 1024 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal :=
        hMomentOne.2
  have hCenterGauge :
      PsiOneGauge μ (fun ω => X ω - m) ≤
        ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) * PsiOneGauge μ X := by
    have hAdd := psiOneGauge_add_le (μ := μ)
      (X := X) (Y := fun _ : Ω => -m)
    have hConst := psiOneGauge_const_le_two_mul_abs
      (Ω := Ω) (μ := μ) (-m)
    have hMeanTwo : 2 * |-m| ≤
        2048 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal := by
      rw [abs_neg]
      nlinarith [hMean]
    calc
      PsiOneGauge μ (fun ω => X ω - m) ≤
          PsiOneGauge μ X + PsiOneGauge μ (fun _ : Ω => -m) := by
            simpa [sub_eq_add_neg] using hAdd
      _ ≤ PsiOneGauge μ X + ENNReal.ofReal (2 * |-m|) := by gcongr
      _ ≤ PsiOneGauge μ X +
          ENNReal.ofReal
            (2048 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal) := by gcongr
      _ = ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) *
          PsiOneGauge μ X := by
        rw [ENNReal.ofReal_mul
          (by positivity : 0 ≤ 2048 * (Real.exp 1) ^ 3)]
        rw [ENNReal.ofReal_toReal (ne_of_lt hFinite)]
        have hcoef : ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) =
            1 + ENNReal.ofReal (2048 * (Real.exp 1) ^ 3) := by
          rw [ENNReal.ofReal_add (by norm_num : 0 ≤ (1 : ℝ))
            (by positivity : 0 ≤ 2048 * (Real.exp 1) ^ 3)]
          norm_num
        rw [hcoef]
        ring
  have hCenterFinite : PsiOneGauge μ (fun ω => X ω - m) < ∞ :=
    lt_of_le_of_lt hCenterGauge
      (ENNReal.mul_lt_top ENNReal.ofReal_lt_top hFinite)
  simpa [m] using And.intro hCenterFinite hCenterGauge

/-- Uniform-constant form of Exercise 2.7.10. -/
theorem centeredSubExponentialPsiOneNorm_uniform :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : Ω → ℝ},
        Measurable X → PsiOneGauge μ X < ∞ →
          PsiOneGauge μ (fun ω => X ω - ∫ x, X x ∂μ) ≤
            ENNReal.ofReal C * PsiOneGauge μ X := by
  refine ⟨1 + 2048 * (Real.exp 1) ^ 3, ?_, ?_⟩
  · have hnonneg : 0 ≤ 2048 * (Real.exp 1) ^ 3 := by positivity
    linarith
  · intro Ω _ μ _ X hX hFinite
    exact (centeredSubExponentialPsiOneNorm hX hFinite).2

end NumStability.HDP.Scalar.SubExponential
```

### `ComputationalMathematics.HDP.Scalar.IndependentSums.NormalizedRegimesDiscrepancy`

Path: `lean-computational-mathematics/ComputationalMathematics/HDP/Scalar/IndependentSums/NormalizedRegimesDiscrepancy.lean`
SHA-256: `62e4794fdc6771031ba8b3ea9502b656a1ad9cc270c3c25215d75ffbff284b39`

```lean
import ComputationalMathematics.HDP.Scalar.SubExponentialExamples
import ComputationalMathematics.HDP.Scalar.SubExponentialCentering
import Mathlib.Probability.Independence.Basic

/-!
# Obstruction to the literal normalized Bernstein large-deviation display

The unnumbered display after Vershynin's Corollary 2.8.3 suppresses the
dependence on the common `ψ₁` scale in its large-deviation exponent, writing
`2 exp (-t * sqrt N)`.  A centered, scaled exponential variable shows that no
choice of the regime threshold can repair that coefficient.

This file records the reusable mathematical obstruction.  Source-facing
discrepancy wrappers live under `ComputationalMathematics.Source.Vershynin`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal

namespace NumStability.HDP.Scalar.IndependentSums.Bernstein

open NumStability.HDP.Scalar.SubExponential
open NumStability.HDP.Scalar.SubExponentialExamples

/-- The centered scale-two rate-one exponential variable used in the
large-deviation obstruction. -/
def centeredScaledExponential (x : ℝ) : ℝ := 2 * x - 2

private instance expMeasureOneProbability : IsProbabilityMeasure (expMeasure 1) :=
  ProbabilityTheory.isProbabilityMeasure_expMeasure (by norm_num)

/-- The exact open upper tail of the rate-one exponential law. -/
theorem expMeasureOne_real_Ioi (a : ℝ) (ha : 0 ≤ a) :
    (expMeasure 1).real (Ioi a) = Real.exp (-a) := by
  have hcompl := probReal_add_probReal_compl
    (μ := expMeasure 1) (s := Iic a) measurableSet_Iic
  rw [← ProbabilityTheory.cdf_eq_real,
    ProbabilityTheory.cdf_expMeasure_eq (by norm_num), if_pos ha] at hcompl
  simp only [compl_Iic] at hcompl
  simp only [one_mul] at hcompl
  linarith

/-- The obstruction variable is measurable. -/
theorem measurable_centeredScaledExponential : Measurable centeredScaledExponential := by
  simpa [centeredScaledExponential] using
    (measurable_const.mul measurable_id).sub measurable_const

/-- The obstruction variable is integrable under the rate-one exponential law. -/
theorem integrable_centeredScaledExponential :
    Integrable centeredScaledExponential (expMeasure 1) := by
  exact (integrable_id_expMeasure_one.const_mul 2).sub (integrable_const 2)

/-- The obstruction variable is centered. -/
theorem integral_centeredScaledExponential :
    (∫ x : ℝ, centeredScaledExponential x ∂expMeasure 1) = 0 := by
  rw [show centeredScaledExponential = fun x : ℝ ↦ 2 * x - 2 by rfl]
  rw [integral_sub (integrable_id_expMeasure_one.const_mul 2) (integrable_const 2),
    integral_const_mul, integral_id_expMeasure_one, integral_const, probReal_univ]
  norm_num

/-- The obstruction variable has finite `ψ₁` gauge, so it lies in the source's
sub-exponential class. -/
theorem psiOneGauge_centeredScaledExponential_lt_top :
    PsiOneGauge (expMeasure 1) centeredScaledExponential < ∞ := by
  have hscaled :
      PsiOneGauge (expMeasure 1) (fun x : ℝ ↦ 2 * x) < ∞ := by
    rw [psiOneGauge_smul_of_pos (by norm_num), psiOneGauge_id_expMeasure_one]
    exact ENNReal.mul_lt_top (by simp) (by simp)
  have hconst :
      PsiOneGauge (expMeasure 1) (fun _x : ℝ ↦ (-2 : ℝ)) < ∞ := by
    exact lt_of_le_of_lt
      (psiOneGauge_const_le_two_mul_abs (μ := expMeasure 1) (-2))
      ENNReal.ofReal_lt_top
  have hadd := psiOneGauge_add_le (μ := expMeasure 1)
    (X := fun x : ℝ ↦ 2 * x) (Y := fun _x : ℝ ↦ (-2 : ℝ))
  exact lt_of_le_of_lt (by simpa [centeredScaledExponential] using hadd)
    (ENNReal.add_lt_top.mpr ⟨hscaled, hconst⟩)

/-- A singleton family of copies of the obstruction variable is independent. -/
theorem iIndepFun_centeredScaledExponential_unit :
    iIndepFun (fun _u : Unit ↦ centeredScaledExponential) (expMeasure 1) :=
  ProbabilityTheory.iIndepFun.of_subsingleton

/-- The tail of the centered scale-two exponential eventually exceeds the
literal coefficient-one large-deviation branch, regardless of the proposed
regime threshold. -/
theorem centeredScaledExponential_violates_literal_large_tail (C : ℝ) :
    ∃ t : ℝ, 0 ≤ t ∧ C ≤ t ∧
      2 * Real.exp (-t) <
        (expMeasure 1).real {x | centeredScaledExponential x ≥ t} := by
  let t : ℝ := max C 4
  have ht0 : 0 ≤ t := le_trans (by norm_num) (le_max_right C 4)
  have hCt : C ≤ t := le_max_left C 4
  have ht4 : 4 ≤ t := le_max_right C 4
  have htail : Real.exp (-(t / 2 + 1)) ≤
      (expMeasure 1).real {x | centeredScaledExponential x ≥ t} := by
    rw [← expMeasureOne_real_Ioi (t / 2 + 1) (by linarith)]
    apply measureReal_mono (h₂ := measure_ne_top _ _)
    intro x hx
    simp only [mem_Ioi, mem_setOf_eq] at hx ⊢
    unfold centeredScaledExponential
    linarith
  have hexp : 2 * Real.exp (-t) < Real.exp (-(t / 2 + 1)) := by
    calc
      2 * Real.exp (-t) < Real.exp 1 * Real.exp (-t) :=
        mul_lt_mul_of_pos_right Real.exp_one_gt_two (Real.exp_pos _)
      _ = Real.exp (1 - t) := by
        rw [← Real.exp_add]
        congr 1
      _ ≤ Real.exp (-(t / 2 + 1)) := Real.exp_le_exp.mpr (by linarith)
  exact ⟨t, ht0, hCt, hexp.trans_le htail⟩

/-- The source's literal coefficient-one large-deviation branch has no valid
positive threshold even for one centered sub-exponential random variable. -/
theorem no_literal_normalizedLargeTail_threshold :
    ¬ ∃ C : ℝ, 0 < C ∧
      ∀ {t : ℝ}, 0 ≤ t → C ≤ t →
        (expMeasure 1).real {x | centeredScaledExponential x ≥ t} ≤
          2 * Real.exp (-t) := by
  rintro ⟨C, _hC, htail⟩
  obtain ⟨t, ht0, hCt, hcontra⟩ := centeredScaledExponential_violates_literal_large_tail C
  exact (not_lt_of_ge (htail ht0 hCt)) hcontra

/-- Exact singleton obstruction to the absolute-value event occurring in the
book's normalized display.  For `N = 1`, normalization and the displayed
large-deviation exponent both simplify to the expressions below. -/
theorem no_literal_normalizedLargeTail_threshold_abs :
    ¬ ∃ C : ℝ, 0 < C ∧
      ∀ {t : ℝ}, 0 ≤ t → C ≤ t →
        (expMeasure 1).real {x | |centeredScaledExponential x| ≥ t} ≤
          2 * Real.exp (-t) := by
  intro h
  apply no_literal_normalizedLargeTail_threshold
  rcases h with ⟨C, hC, htail⟩
  refine ⟨C, hC, fun {t} ht0 hCt ↦ ?_⟩
  calc
    (expMeasure 1).real {x | centeredScaledExponential x ≥ t} ≤
        (expMeasure 1).real {x | |centeredScaledExponential x| ≥ t} := by
      apply measureReal_mono (h₂ := measure_ne_top _ _)
      intro x hx
      simp only [mem_setOf_eq] at hx ⊢
      exact hx.trans (le_abs_self _)
    _ ≤ 2 * Real.exp (-t) := htail ht0 hCt

end NumStability.HDP.Scalar.IndependentSums.Bernstein
```

### `ComputationalMathematics.Source.Vershynin.Chapter02.Section08.NormalizedRegimes.Signature`

Path: `lean-computational-mathematics/ComputationalMathematics/Source/Vershynin/Chapter02/Section08/NormalizedRegimes/Signature.lean`
SHA-256: `8a2a2619ad7bc6ec3ad268baa1c17d7bdf153ff7efa2b021904bceb659c1ca0b`

```lean
import ComputationalMathematics.HDP.Scalar.IndependentSums.NormalizedRegimesDiscrepancy

/-!
# Discrepancy signature for the normalized two-regime display

The large-deviation branch printed after Corollary 2.8.3 has coefficient one
in its exponent.  This proof-free proposition packages a centered
sub-exponential singleton family and states that no positive regime threshold
can make that literal branch valid for it.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Bernstein
open NumStability.HDP.Scalar.SubExponential

def hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract_type : Prop :=
  IsProbabilityMeasure (expMeasure 1) ∧
    Measurable centeredScaledExponential ∧
    Integrable centeredScaledExponential (expMeasure 1) ∧
    (∫ x : ℝ, centeredScaledExponential x ∂expMeasure 1) = 0 ∧
    PsiOneGauge (expMeasure 1) centeredScaledExponential < ∞ ∧
    iIndepFun (fun _u : Unit ↦ centeredScaledExponential) (expMeasure 1) ∧
    ¬ ∃ C : ℝ, 0 < C ∧
      ∀ {t : ℝ}, 0 ≤ t → C ≤ t →
        (expMeasure 1).real {x | centeredScaledExponential x ≥ t} ≤
          2 * Real.exp (-t)

end NumStability.HDP.Contract
```
