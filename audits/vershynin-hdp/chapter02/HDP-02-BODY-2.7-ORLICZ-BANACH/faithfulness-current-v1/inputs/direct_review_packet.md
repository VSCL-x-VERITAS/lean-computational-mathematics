# Declaration dossier for HDP-02-BODY-2.7-ORLICZ-BANACH

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem hdp_02_hbody_h2_d7_horlicz_hbanach_exact :
    hdp_02_hbody_h2_d7_horlicz_hbanach__contract_type
```

## Elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hbody_h2_d7_horlicz_hbanach__contract_type
```

## Fully explicit elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hbody_h2_d7_horlicz_hbanach__contract_type.{u_1}
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczBanach.Signature`
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
- `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczDefinitions` imports: `ComputationalMathematics.HDP.Scalar.SubExponential`
- `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm` imports: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczDefinitions`
- `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczComplete` imports: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`, `Mathlib.Analysis.Convex.Continuous`, `Mathlib.Analysis.Normed.Group.Completeness`, `Mathlib.MeasureTheory.Function.LpSpace.Complete`
- `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczBanach.Signature` imports: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczComplete`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Contract.hdp_02_hbody_h2_d7_horlicz_hbanach__contract_type`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczBanach.Signature`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `91e2f15d018bb2f8c90408e888b2a0c2a36efc3e8269dd0c3fea8b5437b62d17`

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
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω)
  [inst_1 : MeasureTheory.IsProbabilityMeasure μ] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction),
  And
    (Nonempty
      (NormedSpace Real
        (Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace ψ μ) x)))
    (Nonempty
      (CompleteSpace
        (Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace ψ μ) x)))
```

### D002: `NumStability.HDP.Contract.hdp_02_hbody_h2_d7_horlicz_hbanach__contract_type._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczBanach.Signature`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `0ca2127dfe9a236f23b1efde32c0ceb0c56702bdbba495d3400ad9bd7653ff76`

Type:

```lean
ContinuousAdd Real
```

Fully explicit type:

```lean
@ContinuousAdd.{0} Real
  (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
  (@Distrib.toAdd.{0} Real
    (@NonUnitalNonAssocSemiring.toDistrib.{0} Real
      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))))
```

### D003: `NumStability.HDP.Contract.hdp_02_hbody_h2_d7_horlicz_hbanach__contract_type._proof_2`

- Role: `local`
- Owner module: `ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczBanach.Signature`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `333cbaab953ac0a5abc80073f48fe41470fbc290d017e26cb85be092dbb542c0`

Type:

```lean
ContinuousConstSMul Real Real
```

Fully explicit type:

```lean
@ContinuousConstSMul.{0, 0} Real Real
  (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
  (@instSMulOfMul.{0} Real Real.instMul)
```

### D004: `NumStability.HDP.Scalar.SubExponential.OrliczFunction`

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

### D005: `NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1285790c2cdcf9a1b59eb83fbc093c0e95678d300ee5f6b6896a6dfcd2771490`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    NumStability.HDP.Scalar.SubExponential.OrliczFunction →
      (μ : MeasureTheory.Measure Ω) → Submodule Real (MeasureTheory.AEEqFun Ω Real μ)
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
        @Submodule.{0, u_1} Real
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          Real.semiring
          (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real.instAddCommMonoid
            (@IsTopologicalSemiring.toContinuousAdd.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                instIsTopologicalRingReal)))
          (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real Real.semiring Real.instAddCommMonoid
            (@IsTopologicalSemiring.toContinuousAdd.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                instIsTopologicalRingReal))
            (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
              (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                    (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
              (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
            (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real.instMul
              (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instMul
                (@IsTopologicalSemiring.toContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                  (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                    instIsTopologicalRingReal)))))
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ =>
  {
    carrier :=
      setOf fun X =>
        ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X) instTopENNReal.top,
    add_mem' := ⋯, zero_mem' := ⋯, smul_mem' := ⋯ }
```

### D006: `NumStability.HDP.Scalar.SubExponential.orliczAEEqSpaceNormedAddCommGroup`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `541f84c9ec2e26f8dd97d1e8e421e0f33a989c6e29e292d6b9bcccfcf68378a5`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : MeasureTheory.Measure Ω) →
        [MeasureTheory.IsProbabilityMeasure μ] →
          NormedAddCommGroup
            (Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace ψ μ) x)
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
        [@MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] →
          NormedAddCommGroup.{u_1}
            (@Subtype.{u_1 + 1}
              (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                μ)
              fun
                (x :
                  @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    μ) =>
              @Membership.mem.{u_1, u_1}
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                (@Submodule.{0, u_1} Real
                  (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    μ)
                  Real.semiring
                  (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal)))
                  (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real Real.semiring Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal))
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                    (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real.instMul
                      (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        Real.instMul
                        (@IsTopologicalSemiring.toContinuousMul.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                            (@UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                            instIsTopologicalRingReal))))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real
                    (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      μ)
                    Real.semiring
                    (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real.instAddCommMonoid
                      (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                        (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                          instIsTopologicalRingReal)))
                    (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real Real.semiring Real.instAddCommMonoid
                      (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                        (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                          instIsTopologicalRingReal))
                      (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                      (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        Real.instMul
                        (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          Real.instMul
                          (@IsTopologicalSemiring.toContinuousMul.{0} Real
                            (@UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                              (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                                (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                  (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                    (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                            (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                              (@UniformSpace.toTopologicalSpace.{0} Real
                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                                (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                  (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                    (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                              instIsTopologicalRingReal))))))
                  (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    μ)
                  (@Submodule.setLike.{0, u_1} Real
                    (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      μ)
                    Real.semiring
                    (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real.instAddCommMonoid
                      (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                        (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                          instIsTopologicalRingReal)))
                    (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real Real.semiring Real.instAddCommMonoid
                      (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                        (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                          instIsTopologicalRingReal))
                      (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                      (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        Real.instMul
                        (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          Real.instMul
                          (@IsTopologicalSemiring.toContinuousMul.{0} Real
                            (@UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                              (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                                (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                  (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                    (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                            (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                              (@UniformSpace.toTopologicalSpace.{0} Real
                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                                (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                  (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                    (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                              instIsTopologicalRingReal)))))))
                (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace.{u_1} Ω inst ψ μ) x)
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ [MeasureTheory.IsProbabilityMeasure μ] => NormedAddCommGroup.ofCore ⋯
```

### D007: `NumStability.HDP.Scalar.SubExponential.OrliczFunction.mk`

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

### D008: `NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b9b973dce41ba92c94d5f6ad6f2438922f2db563899ffce8eb9c53695fe95d96`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    NumStability.HDP.Scalar.SubExponential.OrliczFunction →
      (μ : MeasureTheory.Measure Ω) → MeasureTheory.AEEqFun Ω Real μ → ENNReal
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
        (X :
            @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ) →
          ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ X => NumStability.HDP.Scalar.SubExponential.orliczGauge ψ μ X.cast
```

### D009: `NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `9448c2f7924164a9468c0135a2accd62572da2dbcaae9a7d2d57a415e9a30be8`

Type:

```lean
ContinuousAdd Real
```

Fully explicit type:

```lean
@ContinuousAdd.{0} Real
  (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
  (@Distrib.toAdd.{0} Real
    (@NonUnitalNonAssocSemiring.toDistrib.{0} Real
      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))))
```

### D010: `NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_2`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `90dc1716d1a809cdb59795db115097fdcfd51707c731b56f2378022b702346df`

Type:

```lean
ContinuousConstSMul Real Real
```

Fully explicit type:

```lean
@ContinuousConstSMul.{0, 0} Real Real
  (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
  (@instSMulOfMul.{0} Real Real.instMul)
```

### D011: `NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_3`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `321fa0ed042734db4c3975f4a2851444d4c1bb6705a54619b47bdcb3472d9f26`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : MeasureTheory.Measure Ω) {X Y : MeasureTheory.AEEqFun Ω Real μ},
  Set.instMembership.mem
      (setOf fun X =>
        ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X) instTopENNReal.top)
      X →
    Set.instMembership.mem
        (setOf fun X =>
          ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X) instTopENNReal.top)
        Y →
      ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ (instHAdd.hAdd X Y))
        instTopENNReal.top
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  {X Y :
    @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace)) μ}
  (hX :
    @Membership.mem.{u_1, u_1}
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      (Set.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ))
      (@Set.instMembership.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ))
      (@setOf.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        fun
          (X :
            @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ) =>
        @LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
          (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ X)
          (@Top.top.{0} ENNReal instTopENNReal))
      X)
  (hY :
    @Membership.mem.{u_1, u_1}
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      (Set.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ))
      (@Set.instMembership.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ))
      (@setOf.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        fun
          (X :
            @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ) =>
        @LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
          (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ X)
          (@Top.top.{0} ENNReal instTopENNReal))
      Y),
  @LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
    (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ
      (@HAdd.hAdd.{u_1, u_1, u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@instHAdd.{u_1}
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@MeasureTheory.AEEqFun.instAdd.{u_1, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real.instAdd NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_1))
        X Y))
    (@Top.top.{0} ENNReal instTopENNReal)
```

### D012: `NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_4`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `68ed4a294401cf21f2d1188da9964c9b0b465a46f5688ec3629164953235ce78`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : MeasureTheory.Measure Ω),
  ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ 0) instTopENNReal.top
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : @MeasureTheory.Measure.{u_1} Ω inst),
  @LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
    (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ
      (@OfNat.ofNat.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (nat_lit 0)
        (@Zero.toOfNat0.{u_1}
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@AddZero.toZero.{u_1}
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            (@AddZeroClass.toAddZero.{u_1}
              (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                μ)
              (@AddMonoid.toAddZeroClass.{u_1}
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                (@AddCommMonoid.toAddMonoid.{u_1}
                  (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    μ)
                  (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instAddCommMonoid NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_1))))))))
    (@Top.top.{0} ENNReal instTopENNReal)
```

### D013: `NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_5`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `0b3e6a4a5e16c1421acdff2ad1d98fae329e69ee792035eb0edec9e65743291c`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : MeasureTheory.Measure Ω) (c : Real) {X : MeasureTheory.AEEqFun Ω Real μ},
  Set.instMembership.mem
      (setOf fun X =>
        ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X) instTopENNReal.top)
      X →
    Set.instMembership.mem
      (setOf fun X =>
        ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X) instTopENNReal.top)
      (instHSMul.hSMul c X)
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : @MeasureTheory.Measure.{u_1} Ω inst) (c : Real)
  {X :
    @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace)) μ}
  (hX :
    @Membership.mem.{u_1, u_1}
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      (Set.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ))
      (@Set.instMembership.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ))
      (@setOf.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        fun
          (X :
            @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ) =>
        @LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
          (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ X)
          (@Top.top.{0} ENNReal instTopENNReal))
      X),
  @Membership.mem.{u_1, u_1}
    (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace)) μ)
    (Set.{u_1}
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ))
    (@Set.instMembership.{u_1}
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ))
    (@setOf.{u_1}
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      fun
        (X :
          @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ) =>
      @LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
        (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ X)
        (@Top.top.{0} ENNReal instTopENNReal))
    (@HSMul.hSMul.{0, u_1, u_1} Real
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      (@instHSMul.{0, u_1} Real
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@SMulZeroClass.toSMul.{0, u_1} Real
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@AddZero.toZero.{u_1}
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            (@AddZeroClass.toAddZero.{u_1}
              (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                μ)
              (@AddMonoid.toAddZeroClass.{u_1}
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                (@AddCommMonoid.toAddMonoid.{u_1}
                  (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    μ)
                  (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instAddCommMonoid NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_1)))))
          (@DistribSMul.toSMulZeroClass.{0, u_1} Real
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            (@AddMonoid.toAddZeroClass.{u_1}
              (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                μ)
              (@AddCommMonoid.toAddMonoid.{u_1}
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instAddCommMonoid NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_1)))
            (@DistribMulAction.toDistribSMul.{0, u_1} Real
              (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                μ)
              (@MonoidWithZero.toMonoid.{0} Real (@Semiring.toMonoidWithZero.{0} Real Real.semiring))
              (@AddCommMonoid.toAddMonoid.{u_1}
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instAddCommMonoid NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_1))
              (@Module.toDistribMulAction.{0, u_1} Real
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                Real.semiring
                (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instAddCommMonoid NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_1)
                (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real Real.semiring Real.instAddCommMonoid
                  NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_1
                  (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                          (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                    (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                  NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace._proof_2))))))
      c X)
```

### D014: `NumStability.HDP.Scalar.SubExponential.orliczAEEqSpaceNorm`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `216a8146ba284f3c8ea0b12d1afc717fe627cdd0de926b99dc87b7f68ef7ad17`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : MeasureTheory.Measure Ω) →
        Norm
          (Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace ψ μ) x)
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction) →
      (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
        Norm.{u_1}
          (@Subtype.{u_1 + 1}
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            fun
              (x :
                @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ) =>
            @Membership.mem.{u_1, u_1}
              (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                μ)
              (@Submodule.{0, u_1} Real
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                Real.semiring
                (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instAddCommMonoid
                  (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal)))
                (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real Real.semiring Real.instAddCommMonoid
                  (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal))
                  (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                          (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                    (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                  (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instMul
                    (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real.instMul
                      (@IsTopologicalSemiring.toContinuousMul.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                        (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                          instIsTopologicalRingReal))))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real
                  (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    μ)
                  Real.semiring
                  (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal)))
                  (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real Real.semiring Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal))
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                    (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real.instMul
                      (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        Real.instMul
                        (@IsTopologicalSemiring.toContinuousMul.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                            (@UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                            instIsTopologicalRingReal))))))
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                (@Submodule.setLike.{0, u_1} Real
                  (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    μ)
                  Real.semiring
                  (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal)))
                  (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real Real.semiring Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal))
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                    (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real.instMul
                      (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        Real.instMul
                        (@IsTopologicalSemiring.toContinuousMul.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                            (@UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                            instIsTopologicalRingReal)))))))
              (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace.{u_1} Ω inst ψ μ) x)
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ =>
  { norm := fun X => (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal }
```

### D015: `NumStability.HDP.Scalar.SubExponential.orliczNormedSpaceCore`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `32aa15f951f90ccafbf4ce6d62ca2fa1ac3e58ef6a9ae85289dce3907d8dce7e`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : MeasureTheory.Measure Ω) [MeasureTheory.IsProbabilityMeasure μ],
  NormedSpace.Core Real
    (Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace ψ μ) x)
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : @MeasureTheory.Measure.{u_1} Ω inst) [@MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ],
  @NormedSpace.Core.{0, u_1} Real
    (@Subtype.{u_1 + 1}
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      fun
        (x :
          @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ) =>
      @Membership.mem.{u_1, u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@Submodule.{0, u_1} Real
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          Real.semiring
          (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real.instAddCommMonoid
            (@IsTopologicalSemiring.toContinuousAdd.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                instIsTopologicalRingReal)))
          (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real Real.semiring Real.instAddCommMonoid
            (@IsTopologicalSemiring.toContinuousAdd.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                instIsTopologicalRingReal))
            (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
              (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                    (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
              (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
            (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real.instMul
              (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instMul
                (@IsTopologicalSemiring.toContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                  (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                    instIsTopologicalRingReal))))))
        (@SetLike.instMembership.{u_1, u_1}
          (@Submodule.{0, u_1} Real
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            Real.semiring
            (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal)))
            (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real Real.semiring Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal))
              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
              (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instMul
                (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instMul
                  (@IsTopologicalSemiring.toContinuousMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal))))))
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@Submodule.setLike.{0, u_1} Real
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            Real.semiring
            (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal)))
            (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real Real.semiring Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal))
              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
              (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instMul
                (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instMul
                  (@IsTopologicalSemiring.toContinuousMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal)))))))
        (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace.{u_1} Ω inst ψ μ) x)
    Real.normedField
    (@Submodule.addCommGroup.{0, u_1} Real
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      Real.instRing
      (@MeasureTheory.AEEqFun.instAddCommGroup.{u_1, 0} Ω Real inst μ
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        Real.instAddCommGroup instIsTopologicalAddGroupReal)
      (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        Real Real.semiring Real.instAddCommMonoid
        (@IsTopologicalSemiring.toContinuousAdd.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
            instIsTopologicalRingReal))
        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
          (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
        (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          Real.instMul
          (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real.instMul
            (@IsTopologicalSemiring.toContinuousMul.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                instIsTopologicalRingReal)))))
      (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace.{u_1} Ω inst ψ μ))
    (@Submodule.module.{0, u_1} Real
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      Real.semiring
      (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        Real.instAddCommMonoid
        (@IsTopologicalSemiring.toContinuousAdd.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
            instIsTopologicalRingReal)))
      (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        Real Real.semiring Real.instAddCommMonoid
        (@IsTopologicalSemiring.toContinuousAdd.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
            instIsTopologicalRingReal))
        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
          (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
        (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          Real.instMul
          (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real.instMul
            (@IsTopologicalSemiring.toContinuousMul.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                instIsTopologicalRingReal)))))
      (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace.{u_1} Ω inst ψ μ))
    (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpaceNorm.{u_1} Ω inst ψ μ)
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] ψ μ [MeasureTheory.IsProbabilityMeasure μ] =>
  { norm_nonneg := fun X => ENNReal.toReal_nonneg,
    norm_smul := fun c X =>
      Eq.mpr
        (id
          (congrArg
            (fun _a =>
              Eq _a
                (instHMul.hMul (Real.normedField.norm c)
                  ((NumStability.HDP.Scalar.SubExponential.orliczAEEqSpaceNorm ψ μ).norm X)))
            (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace_norm_def ψ μ (instHSMul.hSMul c X))))
        (Eq.mpr
          (id
            (congrArg
              (fun _a =>
                Eq (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ (instHSMul.hSMul c X).val).toReal
                  (instHMul.hMul (Real.normedField.norm c) _a))
              (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace_norm_def ψ μ X)))
          (id
            (Eq.mpr
              (id
                (congrArg
                  (fun _a =>
                    Eq _a.toReal
                      (instHMul.hMul (Real.norm.norm c)
                        (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal))
                  (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge_smul ψ μ c X.val)))
              (Eq.mpr
                (id
                  (congrArg
                    (fun _a =>
                      Eq _a
                        (instHMul.hMul (Real.norm.norm c)
                          (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal))
                    ENNReal.toReal_mul))
                (Eq.mpr
                  (id
                    (congrArg
                      (fun _a =>
                        Eq (instHMul.hMul _a (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal)
                          (instHMul.hMul (Real.norm.norm c)
                            (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal))
                      (ENNReal.toReal_ofReal (abs_nonneg c))))
                  (Eq.mpr
                    (id
                      (congrArg
                        (fun _a =>
                          Eq
                            (instHMul.hMul (abs c)
                              (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal)
                            (instHMul.hMul _a
                              (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal))
                        (Real.norm_eq_abs c)))
                    (Eq.refl
                      (instHMul.hMul (abs c)
                        (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal)))))))),
    norm_triangle := fun X Y =>
      Eq.mpr
        (id
          (congrArg
            (fun _a =>
              Real.instLE.le _a
                (instHAdd.hAdd ((NumStability.HDP.Scalar.SubExponential.orliczAEEqSpaceNorm ψ μ).norm X)
                  ((NumStability.HDP.Scalar.SubExponential.orliczAEEqSpaceNorm ψ μ).norm Y)))
            (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace_norm_def ψ μ (instHAdd.hAdd X Y))))
        (Eq.mpr
          (id
            (congrArg
              (fun _a =>
                Real.instLE.le
                  (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ (instHAdd.hAdd X Y).val).toReal
                  (instHAdd.hAdd _a ((NumStability.HDP.Scalar.SubExponential.orliczAEEqSpaceNorm ψ μ).norm Y)))
              (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace_norm_def ψ μ X)))
          (Eq.mpr
            (id
              (congrArg
                (fun _a =>
                  Real.instLE.le
                    (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ (instHAdd.hAdd X Y).val).toReal
                    (instHAdd.hAdd (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal _a))
                (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace_norm_def ψ μ Y)))
            (id
              (have hXTop := ne_of_lt X.property;
              have hYTop := ne_of_lt Y.property;
              have hXYTop :=
                ne_of_lt
                  (have this := (instHAdd.hAdd X Y).property;
                  this);
              Eq.mpr
                (id
                  (congrArg
                    (fun _a =>
                      Real.instLE.le
                        (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ (instHAdd.hAdd X.val Y.val)).toReal
                        _a)
                    (Eq.symm (ENNReal.toReal_add hXTop hYTop))))
                ((ENNReal.toReal_le_toReal hXYTop (ENNReal.add_ne_top.mpr ⟨hXTop, hYTop⟩)).mpr
                  (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge_add_le ψ μ X.val Y.val)))))),
    norm_eq_zero_iff := fun X =>
      {
        mp := fun hzero =>
          Subtype.ext
            ((NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge_eq_zero_iff ψ μ X.val).mp
              (Or.resolve_right
                ((ENNReal.toReal_eq_zero_iff (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val)).mp
                  hzero)
                (ne_of_lt X.property))),
        mpr := fun a =>
          Eq.ndrec
            (of_eq_true
              (Eq.trans
                (congrFun'
                  (congrArg Eq
                    (congrArg ENNReal.toReal (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge_zero ψ μ)))
                  0)
                (eq_self 0)))
            (Eq.symm a) } }
```

### D016: `NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge_add_le`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `f2d0328d0a905c01825d5e307d1ba19d14815bc4276976ae23366be9f63248fc`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : MeasureTheory.Measure Ω) (X Y : MeasureTheory.AEEqFun Ω Real μ),
  ENNReal.instPartialOrder.le (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ (instHAdd.hAdd X Y))
    (instHAdd.hAdd (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X)
      (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ Y))
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  (X Y :
    @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      μ),
  @LE.le.{0} ENNReal (@Preorder.toLE.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
    (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ
      (@HAdd.hAdd.{u_1, u_1, u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@instHAdd.{u_1}
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@MeasureTheory.AEEqFun.instAdd.{u_1, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real.instAdd
            (@IsTopologicalSemiring.toContinuousAdd.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                instIsTopologicalRingReal))))
        X Y))
    (@HAdd.hAdd.{0, 0, 0} ENNReal ENNReal ENNReal
      (@instHAdd.{0} ENNReal
        (@Distrib.toAdd.{0} ENNReal
          (@NonUnitalNonAssocSemiring.toDistrib.{0} ENNReal
            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} ENNReal
              (@Semiring.toNonAssocSemiring.{0} ENNReal
                (@CommSemiring.toSemiring.{0} ENNReal ENNReal.instCommSemiring))))))
      (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ X)
      (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ Y))
```

### D017: `NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge_eq_zero_iff`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `432a2e8c8c37933e09351fffc1a251499cc27996882ee2f63006336dea33c3ba`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : MeasureTheory.Measure Ω) [MeasureTheory.IsProbabilityMeasure μ] (X : MeasureTheory.AEEqFun Ω Real μ),
  Iff (Eq (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X) 0) (Eq X 0)
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : @MeasureTheory.Measure.{u_1} Ω inst) [@MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ]
  (X :
    @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      μ),
  Iff
    (@Eq.{1} ENNReal (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ X)
      (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal)))
    (@Eq.{u_1 + 1}
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      X
      (@OfNat.ofNat.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (nat_lit 0)
        (@Zero.toOfNat0.{u_1}
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@MeasureTheory.AEEqFun.instZero.{u_1, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real.instZero))))
```

### D018: `NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge_smul`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `f13298c045a8c3867afb28b4f377ac337093aaa1a44f472f813a035f499f4110`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : MeasureTheory.Measure Ω) (c : Real) (X : MeasureTheory.AEEqFun Ω Real μ),
  Eq (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ (instHSMul.hSMul c X))
    (instHMul.hMul (ENNReal.ofReal (abs c)) (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X))
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : @MeasureTheory.Measure.{u_1} Ω inst) (c : Real)
  (X :
    @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      μ),
  @Eq.{1} ENNReal
    (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ
      (@HSMul.hSMul.{0, u_1, u_1} Real
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@instHSMul.{0, u_1} Real
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@MeasureTheory.AEEqFun.instSMul.{u_1, 0, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real
            (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
              (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring) (@Algebra.id.{0} Real Real.instCommSemiring))
            (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@Distrib.toMul.{0} Real
                (@NonUnitalNonAssocSemiring.toDistrib.{0} Real
                  (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                    (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))
              (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@Distrib.toMul.{0} Real
                  (@NonUnitalNonAssocSemiring.toDistrib.{0} Real
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                      (@Semiring.toNonAssocSemiring.{0} Real
                        (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))
                (@IsTopologicalSemiring.toContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                  (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                    instIsTopologicalRingReal))))))
        c X))
    (@HMul.hMul.{0, 0, 0} ENNReal ENNReal ENNReal
      (@instHMul.{0} ENNReal
        (@Distrib.toMul.{0} ENNReal
          (@NonUnitalNonAssocSemiring.toDistrib.{0} ENNReal
            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} ENNReal
              (@Semiring.toNonAssocSemiring.{0} ENNReal
                (@CommSemiring.toSemiring.{0} ENNReal ENNReal.instCommSemiring))))))
      (ENNReal.ofReal (@abs.{0} Real Real.lattice Real.instAddGroup c))
      (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ X))
```

### D019: `NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge_zero`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `a83151ffbc71c9e5d5cdedc2fc77438305ddd861126f7b79bc2e557352d3d54f`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : MeasureTheory.Measure Ω), Eq (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ 0) 0
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : @MeasureTheory.Measure.{u_1} Ω inst),
  @Eq.{1} ENNReal
    (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ
      (@OfNat.ofNat.{u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (nat_lit 0)
        (@Zero.toOfNat0.{u_1}
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@MeasureTheory.AEEqFun.instZero.{u_1, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real.instZero))))
    (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal))
```

### D020: `NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace_norm_def`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `c315f15b4675e1d012fd0ce9ef5962a0fc42d6a754280aa140e6ad94b7d65dda`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : MeasureTheory.Measure Ω)
  (X : Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace ψ μ) x),
  Eq ((NumStability.HDP.Scalar.SubExponential.orliczAEEqSpaceNorm ψ μ).norm X)
    (NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge ψ μ X.val).toReal
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
  (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  (X :
    @Subtype.{u_1 + 1}
      (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
        (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        μ)
      fun
        (x :
          @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ) =>
      @Membership.mem.{u_1, u_1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        (@Submodule.{0, u_1} Real
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          Real.semiring
          (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real.instAddCommMonoid
            (@IsTopologicalSemiring.toContinuousAdd.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                instIsTopologicalRingReal)))
          (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            Real Real.semiring Real.instAddCommMonoid
            (@IsTopologicalSemiring.toContinuousAdd.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
              (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                  (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                    (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                      (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                instIsTopologicalRingReal))
            (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
              (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                    (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
              (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
            (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real.instMul
              (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instMul
                (@IsTopologicalSemiring.toContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                  (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                    instIsTopologicalRingReal))))))
        (@SetLike.instMembership.{u_1, u_1}
          (@Submodule.{0, u_1} Real
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            Real.semiring
            (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal)))
            (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real Real.semiring Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal))
              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
              (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instMul
                (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instMul
                  (@IsTopologicalSemiring.toContinuousMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal))))))
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@Submodule.setLike.{0, u_1} Real
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            Real.semiring
            (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal)))
            (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real Real.semiring Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal))
              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
              (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instMul
                (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instMul
                  (@IsTopologicalSemiring.toContinuousMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal)))))))
        (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace.{u_1} Ω inst ψ μ) x),
  @Eq.{1} Real
    (@Norm.norm.{u_1}
      (@Subtype.{u_1 + 1}
        (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          μ)
        fun
          (x :
            @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ) =>
        @Membership.mem.{u_1, u_1}
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (@Submodule.{0, u_1} Real
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            Real.semiring
            (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal)))
            (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              Real Real.semiring Real.instAddCommMonoid
              (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                        (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                  instIsTopologicalRingReal))
              (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                  (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                    (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                      (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
              (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instMul
                (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instMul
                  (@IsTopologicalSemiring.toContinuousMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal))))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real
              (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                μ)
              Real.semiring
              (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instAddCommMonoid
                (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                  (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                    instIsTopologicalRingReal)))
              (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real Real.semiring Real.instAddCommMonoid
                (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                  (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                    instIsTopologicalRingReal))
                (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                          (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instMul
                  (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instMul
                    (@IsTopologicalSemiring.toContinuousMul.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal))))))
            (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
              (@UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              μ)
            (@Submodule.setLike.{0, u_1} Real
              (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                μ)
              Real.semiring
              (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real.instAddCommMonoid
                (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                  (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                    instIsTopologicalRingReal)))
              (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                Real Real.semiring Real.instAddCommMonoid
                (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                  (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                      (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                        (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                          (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                    instIsTopologicalRingReal))
                (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                  (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                          (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instMul
                  (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instMul
                    (@IsTopologicalSemiring.toContinuousMul.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal)))))))
          (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace.{u_1} Ω inst ψ μ) x)
      (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpaceNorm.{u_1} Ω inst ψ μ) X)
    (ENNReal.toReal
      (@NumStability.HDP.Scalar.SubExponential.orliczAEEqGauge.{u_1} Ω inst ψ μ
        (@Subtype.val.{u_1 + 1}
          (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            μ)
          (fun
              (x :
                @MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ) =>
            @Membership.mem.{u_1, u_1}
              (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                (@UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                μ)
              (@Submodule.{0, u_1} Real
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                Real.semiring
                (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real.instAddCommMonoid
                  (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal)))
                (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  Real Real.semiring Real.instAddCommMonoid
                  (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                    (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                            (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                      instIsTopologicalRingReal))
                  (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                    (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                      (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                        (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                          (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                    (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                  (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instMul
                    (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real.instMul
                      (@IsTopologicalSemiring.toContinuousMul.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                        (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                          instIsTopologicalRingReal))))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real
                  (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    μ)
                  Real.semiring
                  (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal)))
                  (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real Real.semiring Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal))
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                    (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real.instMul
                      (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        Real.instMul
                        (@IsTopologicalSemiring.toContinuousMul.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                            (@UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                            instIsTopologicalRingReal))))))
                (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                  (@UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  μ)
                (@Submodule.setLike.{0, u_1} Real
                  (@MeasureTheory.AEEqFun.{u_1, 0} Ω Real inst
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    μ)
                  Real.semiring
                  (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal)))
                  (@MeasureTheory.AEEqFun.instModule.{u_1, 0, 0} Ω Real inst μ
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    Real Real.semiring Real.instAddCommMonoid
                    (@IsTopologicalSemiring.toContinuousAdd.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                        instIsTopologicalRingReal))
                    (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))
                    (@SeparatelyContinuousMul.to_continuousSMul.{0} Real
                      (@UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      Real.instMul
                      (@instSeparatelyContinuousMulOfContinuousMul.{0} Real
                        (@UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        Real.instMul
                        (@IsTopologicalSemiring.toContinuousMul.{0} Real
                          (@UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
                            (@UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
                            instIsTopologicalRingReal)))))))
              (@NumStability.HDP.Scalar.SubExponential.orliczAEEqSpace.{u_1} Ω inst ψ μ) x)
          X)))
```

### D021: `NumStability.HDP.Scalar.SubExponential.orliczGauge`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D022: `NumStability.HDP.Scalar.SubExponential.orliczAdmissible`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D023: `NumStability.HDP.Scalar.SubExponential.orliczIntegral`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `6`
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

### D024: `NumStability.HDP.Scalar.SubExponential.OrliczFunction.toFun`

- Role: `local`
- Owner module: `ComputationalMathematics.HDP.Scalar.SubExponential`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D025: `And`

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

### D026: `CompleteSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Cauchy`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `0551d9b48389890091faefdb29b280e798958c385ce1b812011819c3ac7d5a01`

Type:

```lean
(α : Type u) → [UniformSpace α] → Prop
```

Fully explicit type:

```lean
(α : Type u) → [UniformSpace.{u} α] → Prop
```

### D027: `InnerProductSpace.toNormedSpace`

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

### D028: `MeasurableSpace`

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

### D029: `MeasureTheory.AEEqFun`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6617e69bba6f9e44b27a7929a11353f104ce0c7b079a276babaa71beeb73cdac`

Type:

```lean
(α : Type u_1) →
  (β : Type u_2) → [inst : MeasurableSpace α] → [TopologicalSpace β] → MeasureTheory.Measure α → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(α : Type u_1) →
  (β : Type u_2) →
    [inst : MeasurableSpace.{u_1} α] →
      [TopologicalSpace.{u_2} β] → (μ : @MeasureTheory.Measure.{u_1} α inst) → Type (max u_1 u_2)
```

Definition body (one-level semantic boundary):

```lean
fun α β [MeasurableSpace α] [TopologicalSpace β] μ => Quotient (MeasureTheory.Measure.aeEqSetoid β μ)
```

### D030: `MeasureTheory.AEEqFun.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `723e40cc6af2d7702d1f5aaee1691acdff67abea06a0b4921e766a8a7c51aa53`

Type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} →
        [inst_1 : TopologicalSpace γ] →
          [inst_2 : AddCommMonoid γ] → [ContinuousAdd γ] → AddCommMonoid (MeasureTheory.AEEqFun α γ μ)
```

Fully explicit type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace.{u_1} α] →
      {μ : @MeasureTheory.Measure.{u_1} α inst} →
        [inst_1 : TopologicalSpace.{u_3} γ] →
          [inst_2 : AddCommMonoid.{u_3} γ] →
            [@ContinuousAdd.{u_3} γ inst_1
                  (@AddCommMagma.toAdd.{u_3} γ
                    (@AddCommSemigroup.toAddCommMagma.{u_3} γ (@AddCommMonoid.toAddCommSemigroup.{u_3} γ inst_2)))] →
              AddCommMonoid.{max u_3 u_1} (@MeasureTheory.AEEqFun.{u_1, u_3} α γ inst inst_1 μ)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {γ} [MeasurableSpace α] {μ} [TopologicalSpace γ] [AddCommMonoid γ] [ContinuousAdd γ] =>
  Function.Injective.addCommMonoid MeasureTheory.AEEqFun.toGerm ⋯ ⋯ ⋯ ⋯
```

### D031: `MeasureTheory.AEEqFun.instModule`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `4296f275a87d76a3c3006fa92ecca5aea7c03a4fd399b294debcad0fd83be022`

Type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} →
        [inst_1 : TopologicalSpace γ] →
          {𝕜 : Type u_5} →
            [inst_2 : Semiring 𝕜] →
              [inst_3 : AddCommMonoid γ] →
                [inst_4 : ContinuousAdd γ] →
                  [inst_5 : Module 𝕜 γ] → [ContinuousConstSMul 𝕜 γ] → Module 𝕜 (MeasureTheory.AEEqFun α γ μ)
```

Fully explicit type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace.{u_1} α] →
      {μ : @MeasureTheory.Measure.{u_1} α inst} →
        [inst_1 : TopologicalSpace.{u_3} γ] →
          {𝕜 : Type u_5} →
            [inst_2 : Semiring.{u_5} 𝕜] →
              [inst_3 : AddCommMonoid.{u_3} γ] →
                [inst_4 :
                    @ContinuousAdd.{u_3} γ inst_1
                      (@AddCommMagma.toAdd.{u_3} γ
                        (@AddCommSemigroup.toAddCommMagma.{u_3} γ
                          (@AddCommMonoid.toAddCommSemigroup.{u_3} γ inst_3)))] →
                  [inst_5 : @Module.{u_5, u_3} 𝕜 γ inst_2 inst_3] →
                    [@ContinuousConstSMul.{u_5, u_3} 𝕜 γ inst_1
                          (@SMulZeroClass.toSMul.{u_5, u_3} 𝕜 γ
                            (@AddZero.toZero.{u_3} γ
                              (@AddZeroClass.toAddZero.{u_3} γ
                                (@AddMonoid.toAddZeroClass.{u_3} γ (@AddCommMonoid.toAddMonoid.{u_3} γ inst_3))))
                            (@DistribSMul.toSMulZeroClass.{u_5, u_3} 𝕜 γ
                              (@AddMonoid.toAddZeroClass.{u_3} γ (@AddCommMonoid.toAddMonoid.{u_3} γ inst_3))
                              (@DistribMulAction.toDistribSMul.{u_5, u_3} 𝕜 γ
                                (@MonoidWithZero.toMonoid.{u_5} 𝕜 (@Semiring.toMonoidWithZero.{u_5} 𝕜 inst_2))
                                (@AddCommMonoid.toAddMonoid.{u_3} γ inst_3)
                                (@Module.toDistribMulAction.{u_5, u_3} 𝕜 γ inst_2 inst_3 inst_5))))] →
                      @Module.{u_5, max u_3 u_1} 𝕜 (@MeasureTheory.AEEqFun.{u_1, u_3} α γ inst inst_1 μ) inst_2
                        (@MeasureTheory.AEEqFun.instAddCommMonoid.{u_1, u_3} α γ inst μ inst_1 inst_3 inst_4)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {γ} [MeasurableSpace α] {μ} [TopologicalSpace γ] {𝕜} [Semiring 𝕜] [AddCommMonoid γ] [ContinuousAdd γ]
    [Module 𝕜 γ] [ContinuousConstSMul 𝕜 γ] =>
  Function.Injective.module 𝕜 MeasureTheory.AEEqFun.toGermAddMonoidHom ⋯ ⋯
```

### D032: `MeasureTheory.IsProbabilityMeasure`

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

### D033: `MeasureTheory.Measure`

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

### D034: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D035: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

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

### D036: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D037: `Nonempty`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `37c79de378d44cb9dc334502b161bb140da0544579086aded2cf83ff99c462c7`

Type:

```lean
Sort u → Prop
```

Fully explicit type:

```lean
(α : Sort u) → Prop
```

### D038: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D039: `NormedCommRing.toSeminormedCommRing`

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

### D040: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

Fully explicit type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField.{u_6} 𝕜] → [SeminormedAddCommGroup.{u_7} E] → Type (max u_6 u_7)
```

### D041: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Type:

```lean
{𝕜 : Type u_6} →
  {E : Type u_7} → {inst : NormedField 𝕜} → {inst_1 : SeminormedAddCommGroup E} → [self : NormedSpace 𝕜 E] → Module 𝕜 E
```

Fully explicit type:

```lean
{𝕜 : Type u_6} →
  {E : Type u_7} →
    {inst : NormedField.{u_6} 𝕜} →
      {inst_1 : SeminormedAddCommGroup.{u_7} E} →
        [self : @NormedSpace.{u_6, u_7} 𝕜 E inst inst_1] →
          @Module.{u_6, u_7} 𝕜 E
            (@DivisionSemiring.toSemiring.{u_6} 𝕜
              (@Semifield.toDivisionSemiring.{u_6} 𝕜 (@Field.toSemifield.{u_6} 𝕜 (@NormedField.toField.{u_6} 𝕜 inst))))
            (@AddCommGroup.toAddCommMonoid.{u_7} E (@SeminormedAddCommGroup.toAddCommGroup.{u_7} E inst_1))
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E {inst} {inst_1} [self : NormedSpace 𝕜 E] => self.1
```

### D042: `PseudoMetricSpace.toUniformSpace`

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

### D043: `RCLike.toInnerProductSpaceReal`

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

### D044: `Real`

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

### D045: `Real.instAddCommMonoid`

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

### D046: `Real.instRCLike`

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

### D047: `Real.normedCommRing`

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

### D048: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Type:

```lean
NormedField Real
```

Fully explicit type:

```lean
NormedField.{0} Real
```

Definition body (one-level semantic boundary):

```lean
let __src := Real.normedAddCommGroup;
let __src_1 := Real.instField;
{ toNorm := __src.toNorm, toAddMonoid := __src.toAddMonoid, add_comm := Real.normedField._proof_1,
  toMul := __src_1.toMul, left_distrib := Real.normedField._proof_2, right_distrib := Real.normedField._proof_3,
  zero_mul := Real.normedField._proof_4, mul_zero := Real.normedField._proof_5, mul_assoc := Real.normedField._proof_6,
  toOne := __src_1.toOne, one_mul := Real.normedField._proof_7, mul_one := Real.normedField._proof_8,
  toNatCast := __src_1.toNatCast, natCast_zero := Real.normedField._proof_9, natCast_succ := Real.normedField._proof_10,
  npow := __src_1.npow, npow_zero := Real.normedField._proof_11, npow_succ := Real.normedField._proof_12,
  toNeg := __src.toNeg, toSub := __src.toSub, sub_eq_add_neg := Real.normedField._proof_13, zsmul := __src.zsmul,
  zsmul_zero' := Real.normedField._proof_14, zsmul_succ' := Real.normedField._proof_15,
  zsmul_neg' := Real.normedField._proof_16, neg_add_cancel := Real.normedField._proof_17,
  toIntCast := __src_1.toIntCast, intCast_ofNat := Real.normedField._proof_18,
  intCast_negSucc := Real.normedField._proof_19, mul_comm := Real.normedField._proof_20, toInv := __src_1.toInv,
  toDiv := __src_1.toDiv, div_eq_mul_inv := ⋯, zpow := __src_1.zpow, zpow_zero' := ⋯, zpow_succ' := ⋯, zpow_neg' := ⋯,
  toNontrivial := ⋯, toNNRatCast := __src_1.toNNRatCast, toRatCast := __src_1.toRatCast, mul_inv_cancel := ⋯,
  inv_zero := ⋯, nnratCast_def := ⋯, nnqsmul := __src_1.nnqsmul, nnqsmul_def := ⋯, ratCast_def := ⋯,
  qsmul := __src_1.qsmul, qsmul_def := ⋯, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯, norm_mul := ⋯ }
```

### D049: `Real.pseudoMetricSpace`

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

### D050: `Real.semiring`

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

### D051: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `3f8499f7dfc2e8115a48b4ac0bec5328dd7223a18dd71fc0061e711fbd543126`

Type:

```lean
{E : Type u_8} → [self : SeminormedAddCommGroup E] → PseudoMetricSpace E
```

Fully explicit type:

```lean
{E : Type u_8} → [self : SeminormedAddCommGroup.{u_8} E] → PseudoMetricSpace.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : SeminormedAddCommGroup E] => self.3
```

### D052: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

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

### D053: `SetLike.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.SetLike.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `47a75450bbb51c4e8fdd9e8881cc3fa741dfb5f1f186d952055686e285c081e4`

Type:

```lean
{A : Type u_1} → {B : Type u_2} → [i : SetLike A B] → Membership B A
```

Fully explicit type:

```lean
{A : Type u_1} → {B : Type u_2} → [i : SetLike.{u_1, u_2} A B] → Membership.{u_2, u_1} B A
```

Definition body (one-level semantic boundary):

```lean
fun {A} {B} [i : SetLike A B] => { mem := fun p x => Set.instMembership.mem (i.coe p) x }
```

### D054: `Submodule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `dc34d51ab2952b775b09278f439d1d0393daf90ed359c8f26aeec99b295179db`

Type:

```lean
(R : Type u) → (M : Type v) → [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [Module R M] → Type v
```

Fully explicit type:

```lean
(R : Type u) →
  (M : Type v) → [inst : Semiring.{u} R] → [inst_1 : AddCommMonoid.{v} M] → [@Module.{u, v} R M inst inst_1] → Type v
```

### D055: `Submodule.setLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb9ef22942558eec688655f5d38b6e84772742d6fe6ccb549666f024240be8a7`

Type:

```lean
{R : Type u} →
  {M : Type v} → [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [inst_2 : Module R M] → SetLike (Submodule R M) M
```

Fully explicit type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring.{u} R] →
      [inst_1 : AddCommMonoid.{v} M] →
        [inst_2 : @Module.{u, v} R M inst inst_1] → SetLike.{v, v} (@Submodule.{u, v} R M inst inst_1 inst_2) M
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Semiring R] [AddCommMonoid M] [Module R M] => { coe := fun s => s.carrier, coe_injective' := ⋯ }
```

### D056: `Subtype`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `3b0bb8433bd0c981dbdb4d6256bf74c50e9883207dae8d309dcb705135cf932c`

Type:

```lean
{α : Sort u} → (α → Prop) → Sort (max 1 u)
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Sort (max 1 u)
```

### D057: `UniformSpace.toTopologicalSpace`

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

### D058: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `98c22aec54da8e2278fb6c5ae1daeffb76abd7bad320de72096bec6a7046bc17`

Type:

```lean
{M : Type u} → [self : AddCommMonoid M] → AddMonoid M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddCommMonoid.{u} M] → AddMonoid.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddCommMonoid M] => self.1
```

### D059: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4b5cfcaa0e3b1157089b486d5bfd51b9d15b881ea9cad302a6c8f701cae9ef1a`

Type:

```lean
{M : Type u} → [self : AddMonoid M] → AddZeroClass M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddMonoid.{u} M] → AddZeroClass.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M self => { toZero := self.toZero, toAdd := self.toAdd, zero_add := ⋯, add_zero := ⋯ }
```

### D060: `AddSubmonoid.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Submonoid.Defs`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `029094d2c1b33f7004c39bc68e51ae7cc5630e6caf206cb18d7860d9a945cf9f`

Type:

```lean
{M : Type u_3} →
  [inst : AddZeroClass M] →
    (toAddSubsemigroup : AddSubsemigroup M) → Set.instMembership.mem toAddSubsemigroup.carrier 0 → AddSubmonoid M
```

Fully explicit type:

```lean
{M : Type u_3} →
  [inst : AddZeroClass.{u_3} M] →
    (toAddSubsemigroup : @AddSubsemigroup.{u_3} M (@AddZero.toAdd.{u_3} M (@AddZeroClass.toAddZero.{u_3} M inst))) →
      (zero_mem' :
          @Membership.mem.{u_3, u_3} M (Set.{u_3} M) (@Set.instMembership.{u_3} M)
            (@AddSubsemigroup.carrier.{u_3} M (@AddZero.toAdd.{u_3} M (@AddZeroClass.toAddZero.{u_3} M inst))
              toAddSubsemigroup)
            (@OfNat.ofNat.{u_3} M (nat_lit 0)
              (@Zero.toOfNat0.{u_3} M (@AddZero.toZero.{u_3} M (@AddZeroClass.toAddZero.{u_3} M inst))))) →
        @AddSubmonoid.{u_3} M inst
```

### D061: `AddSubsemigroup.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Subsemigroup.Defs`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `6bcab16592637f3ad99a5376ebb4104d8c715e250ceca67f865101d72cf48cb1`

Type:

```lean
{M : Type u_3} →
  [inst : Add M] →
    (carrier : Set M) →
      (∀ {a b : M},
          Set.instMembership.mem carrier a →
            Set.instMembership.mem carrier b → Set.instMembership.mem carrier (instHAdd.hAdd a b)) →
        AddSubsemigroup M
```

Fully explicit type:

```lean
{M : Type u_3} →
  [inst : Add.{u_3} M] →
    (carrier : Set.{u_3} M) →
      (add_mem' :
          ∀ {a b : M},
            @Membership.mem.{u_3, u_3} M (Set.{u_3} M) (@Set.instMembership.{u_3} M) carrier a →
              @Membership.mem.{u_3, u_3} M (Set.{u_3} M) (@Set.instMembership.{u_3} M) carrier b →
                @Membership.mem.{u_3, u_3} M (Set.{u_3} M) (@Set.instMembership.{u_3} M) carrier
                  (@HAdd.hAdd.{u_3, u_3, u_3} M M M (@instHAdd.{u_3} M inst) a b)) →
        @AddSubsemigroup.{u_3} M inst
```

### D062: `AddZero.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `aaf8ee0ca0ca4a6b33fb0806d024e8a202ba2d3af3b4f4f8214dfc947d3bf16a`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Add M
```

Fully explicit type:

```lean
{M : Type u_2} → [self : AddZero.{u_2} M] → Add.{u_2} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.2
```

### D063: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8f64c653a96443ff67b52a5edb3fc264d279905b936c7303e9dd2469af000213`

Type:

```lean
{M : Type u} → [self : AddZeroClass M] → AddZero M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddZeroClass.{u} M] → AddZero.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZeroClass M] => self.1
```

### D064: `ContinuousAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `44c7f6f7a51f3c30a91ca5d7893f82c6b3bde265d86991f75bca55c7d5619bdc`

Type:

```lean
(M : Type u_1) → [TopologicalSpace M] → [Add M] → Prop
```

Fully explicit type:

```lean
(M : Type u_1) → [TopologicalSpace.{u_1} M] → [Add.{u_1} M] → Prop
```

### D065: `ContinuousConstSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.ConstMulAction`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `64bb493562027db04039f38b3ff75d4943825dfb4dc78774e9b54eb26a0ac9c9`

Type:

```lean
(Γ : Type u_1) → (T : Type u_2) → [TopologicalSpace T] → [SMul Γ T] → Prop
```

Fully explicit type:

```lean
(Γ : Type u_1) → (T : Type u_2) → [TopologicalSpace.{u_2} T] → [SMul.{u_1, u_2} Γ T] → Prop
```

### D066: `Distrib.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D067: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D068: `ENNReal.instPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D069: `IsTopologicalRing.toIsTopologicalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `f55163e46531cbf77c144d47ba02dbad1720a8a16e67de32af3e47419e5ccdb7`

Type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace R} {inst_1 : NonUnitalNonAssocRing R} [self : IsTopologicalRing R],
  IsTopologicalSemiring R
```

Fully explicit type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace.{u_1} R} {inst_1 : NonUnitalNonAssocRing.{u_1} R}
  [self : @IsTopologicalRing.{u_1} R inst inst_1],
  @IsTopologicalSemiring.{u_1} R inst (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R inst_1)
```

### D070: `IsTopologicalSemiring.toContinuousAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `c684f7cd5bb6a4ef18e1af19cd9eee769dfa19bcd1b732073ca86a7a5f54e714`

Type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace R} {inst_1 : NonUnitalNonAssocSemiring R} [self : IsTopologicalSemiring R],
  ContinuousAdd R
```

Fully explicit type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace.{u_1} R} {inst_1 : NonUnitalNonAssocSemiring.{u_1} R}
  [self : @IsTopologicalSemiring.{u_1} R inst inst_1],
  @ContinuousAdd.{u_1} R inst (@Distrib.toAdd.{u_1} R (@NonUnitalNonAssocSemiring.toDistrib.{u_1} R inst_1))
```

### D071: `IsTopologicalSemiring.toContinuousMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `fd5dd952a3c3566c14b553c40684808260a448d4b7c6fa7c23e9084603af65f5`

Type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace R} {inst_1 : NonUnitalNonAssocSemiring R} [self : IsTopologicalSemiring R],
  ContinuousMul R
```

Fully explicit type:

```lean
∀ {R : Type u_1} {inst : TopologicalSpace.{u_1} R} {inst_1 : NonUnitalNonAssocSemiring.{u_1} R}
  [self : @IsTopologicalSemiring.{u_1} R inst inst_1],
  @ContinuousMul.{u_1} R inst (@Distrib.toMul.{u_1} R (@NonUnitalNonAssocSemiring.toDistrib.{u_1} R inst_1))
```

### D072: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D073: `MeasureTheory.AEEqFun.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `1493828f4fcf018bf4caadcd144eaf609401e4f3a6674a8179d2c71d4d557c76`

Type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} →
        [inst_1 : TopologicalSpace γ] →
          [inst_2 : AddCommGroup γ] → [IsTopologicalAddGroup γ] → AddCommGroup (MeasureTheory.AEEqFun α γ μ)
```

Fully explicit type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace.{u_1} α] →
      {μ : @MeasureTheory.Measure.{u_1} α inst} →
        [inst_1 : TopologicalSpace.{u_3} γ] →
          [inst_2 : AddCommGroup.{u_3} γ] →
            [@IsTopologicalAddGroup.{u_3} γ inst_1 (@AddCommGroup.toAddGroup.{u_3} γ inst_2)] →
              AddCommGroup.{max u_3 u_1} (@MeasureTheory.AEEqFun.{u_1, u_3} α γ inst inst_1 μ)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {γ} [MeasurableSpace α] {μ} [TopologicalSpace γ] [AddCommGroup γ] [IsTopologicalAddGroup γ] =>
  { toAddGroup := MeasureTheory.AEEqFun.instAddGroup, add_comm := ⋯ }
```

### D074: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Type:

```lean
{α : Type u} → [self : NonUnitalCommRing α] → NonUnitalNonAssocCommRing α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalCommRing.{u} α] → NonUnitalNonAssocCommRing.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalNonAssocRing := self.toNonUnitalNonAssocRing, mul_comm := ⋯ }
```

### D075: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing α] → NonUnitalNonAssocRing α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocCommRing.{u} α] → NonUnitalNonAssocRing.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocCommRing α] => self.1
```

### D076: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocRing α] → NonUnitalNonAssocSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocRing.{u} α] → NonUnitalNonAssocSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toAddMonoid := self.toAddMonoid, add_comm := ⋯, toMul := self.toMul, left_distrib := ⋯, right_distrib := ⋯,
    zero_mul := ⋯, mul_zero := ⋯ }
```

### D077: `NonUnitalNonAssocSemiring.toDistrib`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D078: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing α] → NonUnitalCommRing α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NonUnitalNormedCommRing.{u_5} α] → NonUnitalCommRing.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toNonUnitalRing := self.toNonUnitalRing, mul_comm := ⋯ }
```

### D079: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

Fully explicit type:

```lean
(E : Type u_8) → Type u_8
```

### D080: `NormedAddCommGroup.ofCore`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `160da701518c5fd78965091a87ce7686c8f500fe3ac17ca22c22bbf01ddcdcea`

Type:

```lean
{𝕜 : Type u_6} →
  {E : Type u_7} →
    [inst : NormedField 𝕜] →
      [inst_1 : AddCommGroup E] →
        [inst_2 : Module 𝕜 E] → [inst_3 : Norm E] → NormedSpace.Core 𝕜 E → NormedAddCommGroup E
```

Fully explicit type:

```lean
{𝕜 : Type u_6} →
  {E : Type u_7} →
    [inst : NormedField.{u_6} 𝕜] →
      [inst_1 : AddCommGroup.{u_7} E] →
        [inst_2 :
            @Module.{u_6, u_7} 𝕜 E
              (@DivisionSemiring.toSemiring.{u_6} 𝕜
                (@Semifield.toDivisionSemiring.{u_6} 𝕜
                  (@Field.toSemifield.{u_6} 𝕜 (@NormedField.toField.{u_6} 𝕜 inst))))
              (@AddCommGroup.toAddCommMonoid.{u_7} E inst_1)] →
          [inst_3 : Norm.{u_7} E] →
            (core : @NormedSpace.Core.{u_6, u_7} 𝕜 E inst inst_1 inst_2 inst_3) → NormedAddCommGroup.{u_7} E
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} {E} [NormedField 𝕜] [AddCommGroup E] [Module 𝕜 E] [Norm E] core =>
  let __src := SeminormedAddCommGroup.ofCore ⋯;
  { toNorm := __src.toNorm, toAddCommGroup := __src.toAddCommGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D081: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Type:

```lean
{α : Type u_2} → [β : NormedCommRing α] → NonUnitalNormedCommRing α
```

Fully explicit type:

```lean
{α : Type u_2} → [β : NormedCommRing.{u_2} α] → NonUnitalNormedCommRing.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [β : NormedCommRing α] =>
  { toNorm := β.toNorm, toAddMonoid := β.toAddMonoid, toNeg := β.toNeg, toSub := β.toSub, sub_eq_add_neg := ⋯,
    zsmul := β.zsmul, zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯,
    toMul := β.toMul, left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯,
    toMetricSpace := β.toMetricSpace, dist_eq := ⋯, norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D082: `PartialOrder.toPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D083: `Preorder.toLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D084: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Type:

```lean
AddCommGroup Real
```

Fully explicit type:

```lean
AddCommGroup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D085: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D086: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `3ab5d2d0076694ed1c8a64f946e9fb3ea8227cbc632e9ed0a942bd0bdcbe0e84`

Type:

```lean
Ring Real
```

Fully explicit type:

```lean
Ring.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D087: `SeparatelyContinuousMul.to_continuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `56d971880101cd9c99ed5d35d19fabe9af4b696c1f8d38dacc04cc710d35a66d`

Type:

```lean
∀ {M : Type u_3} [inst : TopologicalSpace M] [inst_1 : Mul M] [SeparatelyContinuousMul M], ContinuousConstSMul M M
```

Fully explicit type:

```lean
∀ {M : Type u_3} [inst : TopologicalSpace.{u_3} M] [inst_1 : Mul.{u_3} M]
  [@SeparatelyContinuousMul.{u_3} M inst inst_1],
  @ContinuousConstSMul.{u_3, u_3} M M inst (@instSMulOfMul.{u_3} M inst_1)
```

### D088: `Submodule.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b9eb029cf9b69adff09187a8ad4bafffe508134cb17afbbbec6e7264ba083e85`

Type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Ring R] →
      [inst_1 : AddCommGroup M] →
        {module_M : Module R M} → (p : Submodule R M) → AddCommGroup (Subtype fun x => SetLike.instMembership.mem p x)
```

Fully explicit type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Ring.{u} R] →
      [inst_1 : AddCommGroup.{v} M] →
        {module_M : @Module.{u, v} R M (@Ring.toSemiring.{u} R inst) (@AddCommGroup.toAddCommMonoid.{v} M inst_1)} →
          (p :
              @Submodule.{u, v} R M (@Ring.toSemiring.{u} R inst) (@AddCommGroup.toAddCommMonoid.{v} M inst_1)
                module_M) →
            AddCommGroup.{v}
              (@Subtype.{v + 1} M fun (x : M) =>
                @Membership.mem.{v, v} M
                  (@Submodule.{u, v} R M (@Ring.toSemiring.{u} R inst) (@AddCommGroup.toAddCommMonoid.{v} M inst_1)
                    module_M)
                  (@SetLike.instMembership.{v, v}
                    (@Submodule.{u, v} R M (@Ring.toSemiring.{u} R inst) (@AddCommGroup.toAddCommMonoid.{v} M inst_1)
                      module_M)
                    M
                    (@Submodule.setLike.{u, v} R M (@Ring.toSemiring.{u} R inst)
                      (@AddCommGroup.toAddCommMonoid.{v} M inst_1) module_M))
                  p x)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Ring R] [AddCommGroup M] {module_M} p => p.toAddSubgroup.toAddCommGroup
```

### D089: `Submodule.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `955d9798d39620305be807148fff4e08f84525b0b7a07381405fbf39c6d1a638`

Type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring R] →
      [inst_1 : AddCommMonoid M] →
        [inst_2 : Module R M] →
          (toAddSubmonoid : AddSubmonoid M) →
            (∀ (c : R) {x : M},
                Set.instMembership.mem toAddSubmonoid.carrier x →
                  Set.instMembership.mem toAddSubmonoid.carrier (instHSMul.hSMul c x)) →
              Submodule R M
```

Fully explicit type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring.{u} R] →
      [inst_1 : AddCommMonoid.{v} M] →
        [inst_2 : @Module.{u, v} R M inst inst_1] →
          (toAddSubmonoid :
              @AddSubmonoid.{v} M (@AddMonoid.toAddZeroClass.{v} M (@AddCommMonoid.toAddMonoid.{v} M inst_1))) →
            (smul_mem' :
                ∀ (c : R) {x : M},
                  @Membership.mem.{v, v} M (Set.{v} M) (@Set.instMembership.{v} M)
                      (@AddSubsemigroup.carrier.{v} M
                        (@AddZero.toAdd.{v} M
                          (@AddZeroClass.toAddZero.{v} M
                            (@AddMonoid.toAddZeroClass.{v} M (@AddCommMonoid.toAddMonoid.{v} M inst_1))))
                        (@AddSubmonoid.toAddSubsemigroup.{v} M
                          (@AddMonoid.toAddZeroClass.{v} M (@AddCommMonoid.toAddMonoid.{v} M inst_1)) toAddSubmonoid))
                      x →
                    @Membership.mem.{v, v} M (Set.{v} M) (@Set.instMembership.{v} M)
                      (@AddSubsemigroup.carrier.{v} M
                        (@AddZero.toAdd.{v} M
                          (@AddZeroClass.toAddZero.{v} M
                            (@AddMonoid.toAddZeroClass.{v} M (@AddCommMonoid.toAddMonoid.{v} M inst_1))))
                        (@AddSubmonoid.toAddSubsemigroup.{v} M
                          (@AddMonoid.toAddZeroClass.{v} M (@AddCommMonoid.toAddMonoid.{v} M inst_1)) toAddSubmonoid))
                      (@HSMul.hSMul.{u, v, v} R M M
                        (@instHSMul.{u, v} R M
                          (@SMulZeroClass.toSMul.{u, v} R M
                            (@AddZero.toZero.{v} M
                              (@AddZeroClass.toAddZero.{v} M
                                (@AddMonoid.toAddZeroClass.{v} M (@AddCommMonoid.toAddMonoid.{v} M inst_1))))
                            (@DistribSMul.toSMulZeroClass.{u, v} R M
                              (@AddMonoid.toAddZeroClass.{v} M (@AddCommMonoid.toAddMonoid.{v} M inst_1))
                              (@DistribMulAction.toDistribSMul.{u, v} R M
                                (@MonoidWithZero.toMonoid.{u} R (@Semiring.toMonoidWithZero.{u} R inst))
                                (@AddCommMonoid.toAddMonoid.{v} M inst_1)
                                (@Module.toDistribMulAction.{u, v} R M inst inst_1 inst_2)))))
                        c x)) →
              @Submodule.{u, v} R M inst inst_1 inst_2
```

### D090: `Submodule.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `38e6e6b7d41f06bf87b86f95ffa63b70e1bfd4613b44041645c6a708b21c5ded`

Type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring R] →
      [inst_1 : AddCommMonoid M] →
        {module_M : Module R M} → (p : Submodule R M) → Module R (Subtype fun x => SetLike.instMembership.mem p x)
```

Fully explicit type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring.{u} R] →
      [inst_1 : AddCommMonoid.{v} M] →
        {module_M : @Module.{u, v} R M inst inst_1} →
          (p : @Submodule.{u, v} R M inst inst_1 module_M) →
            @Module.{u, v} R
              (@Subtype.{v + 1} M fun (x : M) =>
                @Membership.mem.{v, v} M (@Submodule.{u, v} R M inst inst_1 module_M)
                  (@SetLike.instMembership.{v, v} (@Submodule.{u, v} R M inst inst_1 module_M) M
                    (@Submodule.setLike.{u, v} R M inst inst_1 module_M))
                  p x)
              inst (@Submodule.addCommMonoid.{u, v} R M inst inst_1 module_M p)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Semiring R] [AddCommMonoid M] {module_M} p => p.module'
```

### D091: `Top.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Notation`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D092: `instIsTopologicalAddGroupReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Real`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `4bf923f1ed3c48fb47196057bc5be8c0979ffd51942feea6412e4f04db492087`

Type:

```lean
IsTopologicalAddGroup Real
```

Fully explicit type:

```lean
@IsTopologicalAddGroup.{0} Real
  (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
  Real.instAddGroup
```

### D093: `instIsTopologicalRingReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Real`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `74697a527ce10426ad50966a34f3375374c3cde51367629721e2aa0850e2f618`

Type:

```lean
IsTopologicalRing Real
```

Fully explicit type:

```lean
@IsTopologicalRing.{0} Real
  (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real (@CommRing.toNonUnitalCommRing.{0} Real Real.commRing)))
```

### D094: `instSMulOfMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `9896d4ef6db28be63751378d3104f7d0bf051c852db6e004a221af252cfd12b5`

Type:

```lean
{α : Type u} → [Mul α] → SMul α α
```

Fully explicit type:

```lean
{α : Type u} → [Mul.{u} α] → SMul.{u, u} α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Mul α] => { smul := fun x y => inst.mul x y }
```

### D095: `instSeparatelyContinuousMulOfContinuousMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid.Defs`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `b61f370eb1b1bf65f3c5a695bbbf265462befc2bea34585e5aa5368dae562454`

Type:

```lean
∀ {M : Type u_1} [inst : TopologicalSpace M] [inst_1 : Mul M] [ContinuousMul M], SeparatelyContinuousMul M
```

Fully explicit type:

```lean
∀ {M : Type u_1} [inst : TopologicalSpace.{u_1} M] [inst_1 : Mul.{u_1} M] [@ContinuousMul.{u_1} M inst inst_1],
  @SeparatelyContinuousMul.{u_1} M inst inst_1
```

### D096: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D097: `setOf`

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

### D098: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `f727c3f01db957bd004eab61d742db6d02c6f9b2cdad465fa6f0ac214e09ccfd`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddCommMonoid G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommGroup.{u} G] → AddCommMonoid.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D099: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `7f49725cf4bc16610110860af8f38e6d0fe472c7c1af93721407bad8c7375729`

Type:

```lean
{G : Type u} → [self : AddCommGroup G] → AddGroup G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddCommGroup.{u} G] → AddGroup.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : AddCommGroup G] => self.1
```

### D100: `AddCommGroup.toDivisionAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `72951116f9ecb1048b235282fec669b8c3dfd809e3810c987dc6f18968d013d3`

Type:

```lean
{G : Type u_1} → [AddCommGroup G] → SubtractionCommMonoid G
```

Fully explicit type:

```lean
{G : Type u_1} → [AddCommGroup.{u_1} G] → SubtractionCommMonoid.{u_1} G
```

Definition body (one-level semantic boundary):

```lean
fun {G} [inst : AddCommGroup G] =>
  let __src := inst;
  let __src_1 := AddGroup.toSubtractionMonoid;
  { toSubNegMonoid := __src.toSubNegMonoid, neg_neg := ⋯, neg_add_rev := ⋯, neg_eq_of_add := ⋯, add_comm := ⋯ }
```

### D101: `AddCommMagma.toAdd`

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

### D102: `AddCommMonoid.toAddCommSemigroup`

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

### D103: `AddCommSemigroup.toAddCommMagma`

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

### D104: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `8c0fca6ee264d934b25c679f16be6b83bb2a2f7c58a8ac0afab0c146219e16a1`

Type:

```lean
{A : Type u} → [self : AddGroup A] → SubNegMonoid A
```

Fully explicit type:

```lean
{A : Type u} → [self : AddGroup.{u} A] → SubNegMonoid.{u} A
```

Definition body (one-level semantic boundary):

```lean
fun A [self : AddGroup A] => self.1
```

### D105: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `aa06299f9d38f11e9dad40701d7541d8eba2a4ac673c643f4c5f5ce1369490cc`

Type:

```lean
{M : Type u_2} → [self : AddZero M] → Zero M
```

Fully explicit type:

```lean
{M : Type u_2} → [self : AddZero.{u_2} M] → Zero.{u_2} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddZero M] => self.1
```

### D106: `Algebra.id`

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

### D107: `Algebra.toSMul`

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

### D108: `And.intro`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `232593c5c388d46173a03223cb6b55ff2a132de1d4dfae47c09b5ba49b1e4f83`

Type:

```lean
∀ {a b : Prop}, a → b → And a b
```

Fully explicit type:

```lean
∀ {a b : Prop} (left : a) (right : b), And a b
```

### D109: `CommSemiring.toSemiring`

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

### D110: `ConvexOn`

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

### D111: `Distrib.toMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `1d05ddf657021fb5615c5054f46b4863aec4ca856ca48fbb75add25e1f0fe06f`

Type:

```lean
{R : Type u_1} → [self : Distrib R] → Mul R
```

Fully explicit type:

```lean
{R : Type u_1} → [self : Distrib.{u_1} R] → Mul.{u_1} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Distrib R] => self.1
```

### D112: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `17a3c7e66a4c2897891d468da70a58e73aa0b8e044ea0cc90d8d6e9e51c08f02`

Type:

```lean
{M : Type u_1} → {A : Type u_7} → [inst : Monoid M] → [inst_1 : AddMonoid A] → [DistribMulAction M A] → DistribSMul M A
```

Fully explicit type:

```lean
{M : Type u_1} →
  {A : Type u_7} →
    [inst : Monoid.{u_1} M] →
      [inst_1 : AddMonoid.{u_7} A] →
        [@DistribMulAction.{u_1, u_7} M A inst inst_1] →
          @DistribSMul.{u_1, u_7} M A (@AddMonoid.toAddZeroClass.{u_7} A inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun {M} {A} [Monoid M] [AddMonoid A] [inst_2 : DistribMulAction M A] =>
  let __src := inst_2;
  { toSMul := __src.toSMul, smul_zero := ⋯, smul_add := ⋯ }
```

### D113: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `f640928ea31b161891006aaf9950d636ac5e1fbda413a7712f36546c938b3fdf`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : AddZeroClass A} → [self : DistribSMul M A] → SMulZeroClass M A
```

Fully explicit type:

```lean
{M : Type u_12} →
  {A : Type u_13} →
    {inst : AddZeroClass.{u_13} A} →
      [self : @DistribSMul.{u_12, u_13} M A inst] →
        @SMulZeroClass.{u_12, u_13} M A (@AddZero.toZero.{u_13} A (@AddZeroClass.toAddZero.{u_13} A inst))
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : DistribSMul M A] => self.1
```

### D114: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `587c80a71f9aa5749b5d6c35c97cdae1067fa669257c865951843b747c511934`

Type:

```lean
{K : Type u_2} → [self : DivisionSemiring K] → Semiring K
```

Fully explicit type:

```lean
{K : Type u_2} → [self : DivisionSemiring.{u_2} K] → Semiring.{u_2} K
```

Definition body (one-level semantic boundary):

```lean
fun K [self : DivisionSemiring K] => self.1
```

### D115: `ENNReal.add_ne_top`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Operations`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `9a3186ecbd7af08ce418bc27ec0be1c838ed6add785545a160057fb8a87ead7d`

Type:

```lean
∀ {a b : ENNReal},
  Iff (Ne (instHAdd.hAdd a b) instTopENNReal.top) (And (Ne a instTopENNReal.top) (Ne b instTopENNReal.top))
```

Fully explicit type:

```lean
∀ {a b : ENNReal},
  Iff
    (@Ne.{1} ENNReal
      (@HAdd.hAdd.{0, 0, 0} ENNReal ENNReal ENNReal
        (@instHAdd.{0} ENNReal
          (@Distrib.toAdd.{0} ENNReal
            (@NonUnitalNonAssocSemiring.toDistrib.{0} ENNReal
              (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} ENNReal
                (@Semiring.toNonAssocSemiring.{0} ENNReal
                  (@CommSemiring.toSemiring.{0} ENNReal ENNReal.instCommSemiring))))))
        a b)
      (@Top.top.{0} ENNReal instTopENNReal))
    (And (@Ne.{1} ENNReal a (@Top.top.{0} ENNReal instTopENNReal))
      (@Ne.{1} ENNReal b (@Top.top.{0} ENNReal instTopENNReal)))
```

### D116: `ENNReal.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D117: `ENNReal.ofReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D118: `ENNReal.toReal`

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

### D119: `ENNReal.toReal_add`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Real`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `0ff3438e9072a4bfdfc36021af983295c71d720e4593ea015103e0d806bad9ea`

Type:

```lean
∀ {a b : ENNReal},
  Ne a instTopENNReal.top → Ne b instTopENNReal.top → Eq (instHAdd.hAdd a b).toReal (instHAdd.hAdd a.toReal b.toReal)
```

Fully explicit type:

```lean
∀ {a b : ENNReal} (ha : @Ne.{1} ENNReal a (@Top.top.{0} ENNReal instTopENNReal))
  (hb : @Ne.{1} ENNReal b (@Top.top.{0} ENNReal instTopENNReal)),
  @Eq.{1} Real
    (ENNReal.toReal
      (@HAdd.hAdd.{0, 0, 0} ENNReal ENNReal ENNReal
        (@instHAdd.{0} ENNReal
          (@Distrib.toAdd.{0} ENNReal
            (@NonUnitalNonAssocSemiring.toDistrib.{0} ENNReal
              (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} ENNReal
                (@Semiring.toNonAssocSemiring.{0} ENNReal
                  (@CommSemiring.toSemiring.{0} ENNReal ENNReal.instCommSemiring))))))
        a b))
    (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd) (ENNReal.toReal a) (ENNReal.toReal b))
```

### D120: `ENNReal.toReal_eq_zero_iff`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `a7d39250c98c38c040e1385a5bce1a75505c8ac9eb40465331975ec8bc689d8f`

Type:

```lean
∀ (x : ENNReal), Iff (Eq x.toReal 0) (Or (Eq x 0) (Eq x instTopENNReal.top))
```

Fully explicit type:

```lean
∀ (x : ENNReal),
  Iff (@Eq.{1} Real (ENNReal.toReal x) (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
    (Or (@Eq.{1} ENNReal x (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal)))
      (@Eq.{1} ENNReal x (@Top.top.{0} ENNReal instTopENNReal)))
```

### D121: `ENNReal.toReal_le_toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Real`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `7f5bae2b164dc4012e94f1dea8eab2a53a4fdb133f57eb6e21a716c53c3253d3`

Type:

```lean
∀ {a b : ENNReal},
  Ne a instTopENNReal.top →
    Ne b instTopENNReal.top → Iff (Real.instLE.le a.toReal b.toReal) (ENNReal.instPartialOrder.le a b)
```

Fully explicit type:

```lean
∀ {a b : ENNReal} (ha : @Ne.{1} ENNReal a (@Top.top.{0} ENNReal instTopENNReal))
  (hb : @Ne.{1} ENNReal b (@Top.top.{0} ENNReal instTopENNReal)),
  Iff (@LE.le.{0} Real Real.instLE (ENNReal.toReal a) (ENNReal.toReal b))
    (@LE.le.{0} ENNReal (@Preorder.toLE.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder)) a
      b)
```

### D122: `ENNReal.toReal_mul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Real`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `294ea7fe413a0edb986c1489c49f552477b5fd7b905b804a0c2d7bc293fc296e`

Type:

```lean
∀ {a b : ENNReal}, Eq (instHMul.hMul a b).toReal (instHMul.hMul a.toReal b.toReal)
```

Fully explicit type:

```lean
∀ {a b : ENNReal},
  @Eq.{1} Real
    (ENNReal.toReal
      (@HMul.hMul.{0, 0, 0} ENNReal ENNReal ENNReal
        (@instHMul.{0} ENNReal
          (@Distrib.toMul.{0} ENNReal
            (@NonUnitalNonAssocSemiring.toDistrib.{0} ENNReal
              (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} ENNReal
                (@Semiring.toNonAssocSemiring.{0} ENNReal
                  (@CommSemiring.toSemiring.{0} ENNReal ENNReal.instCommSemiring))))))
        a b))
    (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) (ENNReal.toReal a) (ENNReal.toReal b))
```

### D123: `ENNReal.toReal_nonneg`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `5172aef05eea809c7cdf1abea3500a6ba5f75376dcf50dab2f09473f5b9062c3`

Type:

```lean
∀ {a : ENNReal}, Real.instLE.le 0 a.toReal
```

Fully explicit type:

```lean
∀ {a : ENNReal},
  @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
    (ENNReal.toReal a)
```

### D124: `ENNReal.toReal_ofReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `5ba0fa230ed195b226cd40aafe18f52dd28645c7aced965f4518231367610d81`

Type:

```lean
∀ {r : Real}, Real.instLE.le 0 r → Eq (ENNReal.ofReal r).toReal r
```

Fully explicit type:

```lean
∀ {r : Real}
  (h : @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) r),
  @Eq.{1} Real (ENNReal.toReal (ENNReal.ofReal r)) r
```

### D125: `Eq`

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

### D126: `Eq.mpr`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `877d085993674aac32e6bff8560c00a0950c9ac06a62fe31d320ad0c79f60669`

Type:

```lean
{α β : Sort u} → Eq α β → β → α
```

Fully explicit type:

```lean
{α β : Sort u} → (h : @Eq.{u + 1} (Sort u) α β) → (b : β) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α β} h b => Eq.rec b ⋯
```

### D127: `Eq.ndrec`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `f86cb68b5cbbf1ddc06f9f211e3421eced11542c1e459b8ba4c1e06c0f8ca7d2`

Type:

```lean
{α : Sort u2} → {a : α} → {motive : α → Sort u1} → motive a → {b : α} → Eq a b → motive b
```

Fully explicit type:

```lean
{α : Sort u2} → {a : α} → {motive : α → Sort u1} → (m : motive a) → {b : α} → (h : @Eq.{u2} α a b) → motive b
```

Definition body (one-level semantic boundary):

```lean
fun {α} {a} {motive} m {b} h => Eq.rec m h
```

### D128: `Eq.refl`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `62d4020b7012db70e44624c7d64dd267524e7e75e4b869680e0c95d2231c85d1`

Type:

```lean
∀ {α : Sort u_1} (a : α), Eq a a
```

Fully explicit type:

```lean
∀ {α : Sort u_1} (a : α), @Eq.{u_1} α a a
```

### D129: `Eq.symm`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `7c9d5428fd9feab69045077277e3f895072f20edba5f2a9479559efbee9f7cf2`

Type:

```lean
∀ {α : Sort u} {a b : α}, Eq a b → Eq b a
```

Fully explicit type:

```lean
∀ {α : Sort u} {a b : α} (h : @Eq.{u} α a b), @Eq.{u} α b a
```

### D130: `Eq.trans`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `b3ec77e4c762590cf19d2ffe139a49b822c21a89ea0cfc80e65389ec5d602168`

Type:

```lean
∀ {α : Sort u} {a b c : α}, Eq a b → Eq b c → Eq a c
```

Fully explicit type:

```lean
∀ {α : Sort u} {a b c : α} (h₁ : @Eq.{u} α a b) (h₂ : @Eq.{u} α b c), @Eq.{u} α a c
```

### D131: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `9a6353c2087dc0f4123f4079d947842f8b7bc1fc0c77de170382c04e31608fd4`

Type:

```lean
{K : Type u_1} → [Field K] → Semifield K
```

Fully explicit type:

```lean
{K : Type u_1} → [Field.{u_1} K] → Semifield.{u_1} K
```

Definition body (one-level semantic boundary):

```lean
fun {K} [inst : Field K] =>
  let __src := inst;
  { toSemiring := __src.toSemiring, mul_comm := ⋯, toInv := __src.toInv, toDiv := __src.toDiv, div_eq_mul_inv := ⋯,
    zpow := __src.zpow, zpow_zero' := ⋯, zpow_succ' := ⋯, zpow_neg' := ⋯, toNontrivial := ⋯, inv_zero := ⋯,
    mul_inv_cancel := ⋯, toNNRatCast := __src.toNNRatCast, nnratCast_def := ⋯, nnqsmul := __src.nnqsmul,
    nnqsmul_def := ⋯ }
```

### D132: `Filter.Tendsto`

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

### D133: `Filter.atTop`

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

### D134: `HAdd.hAdd`

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

### D135: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D136: `HSMul.hSMul`

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

### D137: `Iff.intro`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `ea1e29a8557313581c7c6807fed2d75b53ea8afd598ab4ecbd10acc0c2fc7141`

Type:

```lean
∀ {a b : Prop}, (a → b) → (b → a) → Iff a b
```

Fully explicit type:

```lean
∀ {a b : Prop} (mp : a → b) (mpr : b → a), Iff a b
```

### D138: `Iff.mp`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `18f4dccf55e7752a5ea949b1a89bc8e8abbb82b34d9f03a8f14b61302f5fb12a`

Type:

```lean
∀ {a b : Prop}, Iff a b → a → b
```

Fully explicit type:

```lean
∀ {a b : Prop} (self : Iff a b), a → b
```

### D139: `Iff.mpr`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `abcae2cc4e99f1dc596c9080dca30ec894770912ebfc2b6ad2910b661baa68ed`

Type:

```lean
∀ {a b : Prop}, Iff a b → b → a
```

Fully explicit type:

```lean
∀ {a b : Prop} (self : Iff a b), b → a
```

### D140: `IsOrderedAddMonoid.toAddLeftMono`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Monoid.Defs`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `27d84a030ca846ad17e01cc9d542c712204e56bf12ae554159659bad6da2ff81`

Type:

```lean
∀ {α : Type u_1} [inst : AddCommMonoid α] [inst_1 : Preorder α] [IsOrderedAddMonoid α], AddLeftMono α
```

Fully explicit type:

```lean
∀ {α : Type u_1} [inst : AddCommMonoid.{u_1} α] [inst_1 : Preorder.{u_1} α] [@IsOrderedAddMonoid.{u_1} α inst inst_1],
  @AddLeftMono.{u_1} α
    (@AddZero.toAdd.{u_1} α
      (@AddZeroClass.toAddZero.{u_1} α (@AddMonoid.toAddZeroClass.{u_1} α (@AddCommMonoid.toAddMonoid.{u_1} α inst))))
    (@Preorder.toLE.{u_1} α inst_1)
```

### D141: `LE.le`

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

### D142: `Lattice.toSemilatticeInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Lattice`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `81af889ae7d07b4641fdf75ee1ac1bcb7775ec72bd7fe51d0cb1c550f7251505`

Type:

```lean
{α : Type u} → [self : Lattice α] → SemilatticeInf α
```

Fully explicit type:

```lean
{α : Type u} → [self : Lattice.{u} α] → SemilatticeInf.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toPartialOrder := self.toPartialOrder, inf := self.inf, inf_le_left := ⋯, inf_le_right := ⋯, le_inf := ⋯ }
```

### D143: `MeasureTheory.AEEqFun.cast`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `47f8b3469b914314d78fa6c02f35722a915b0ae5c64f6641ae6c8885cfaf00b4`

Type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} → [inst_1 : TopologicalSpace β] → MeasureTheory.AEEqFun α β μ → α → β
```

Fully explicit type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [inst : MeasurableSpace.{u_1} α] →
      {μ : @MeasureTheory.Measure.{u_1} α inst} →
        [inst_1 : TopologicalSpace.{u_2} β] → (f : @MeasureTheory.AEEqFun.{u_1, u_2} α β inst inst_1 μ) → α → β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [MeasurableSpace α] {μ} [TopologicalSpace β] f =>
  if h : Exists fun b => Eq f (MeasureTheory.AEEqFun.mk (Function.const α b) ⋯) then
    Function.const α (Classical.choose h)
  else MeasureTheory.AEStronglyMeasurable.mk (Quotient.out f).val ⋯
```

### D144: `MeasureTheory.AEEqFun.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `6e70f16b95ce3a32f774a48ddcc7d42f928c419c6bb4d5b6803a562acf11da68`

Type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} →
        [inst_1 : TopologicalSpace γ] → [inst_2 : Add γ] → [ContinuousAdd γ] → Add (MeasureTheory.AEEqFun α γ μ)
```

Fully explicit type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace.{u_1} α] →
      {μ : @MeasureTheory.Measure.{u_1} α inst} →
        [inst_1 : TopologicalSpace.{u_3} γ] →
          [inst_2 : Add.{u_3} γ] →
            [@ContinuousAdd.{u_3} γ inst_1 inst_2] →
              Add.{max u_3 u_1} (@MeasureTheory.AEEqFun.{u_1, u_3} α γ inst inst_1 μ)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {γ} [MeasurableSpace α] {μ} [TopologicalSpace γ] [Add γ] [ContinuousAdd γ] =>
  { add := MeasureTheory.AEEqFun.comp₂ (fun x1 x2 => instHAdd.hAdd x1 x2) ⋯ }
```

### D145: `MeasureTheory.AEEqFun.instSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `df789446af6cc71f28ecdaa2fb46628beb96bf85b91309f0f6cafa0c923af668`

Type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} →
        [inst_1 : TopologicalSpace γ] →
          {𝕜 : Type u_5} → [inst_2 : SMul 𝕜 γ] → [ContinuousConstSMul 𝕜 γ] → SMul 𝕜 (MeasureTheory.AEEqFun α γ μ)
```

Fully explicit type:

```lean
{α : Type u_1} →
  {γ : Type u_3} →
    [inst : MeasurableSpace.{u_1} α] →
      {μ : @MeasureTheory.Measure.{u_1} α inst} →
        [inst_1 : TopologicalSpace.{u_3} γ] →
          {𝕜 : Type u_5} →
            [inst_2 : SMul.{u_5, u_3} 𝕜 γ] →
              [@ContinuousConstSMul.{u_5, u_3} 𝕜 γ inst_1 inst_2] →
                SMul.{u_5, max u_3 u_1} 𝕜 (@MeasureTheory.AEEqFun.{u_1, u_3} α γ inst inst_1 μ)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {γ} [MeasurableSpace α] {μ} [TopologicalSpace γ] {𝕜} [SMul 𝕜 γ] [ContinuousConstSMul 𝕜 γ] =>
  { smul := fun c f => MeasureTheory.AEEqFun.comp (fun x => instHSMul.hSMul c x) ⋯ f }
```

### D146: `MeasureTheory.AEEqFun.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.AEEqFun`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `4604aff7fccc5c8683df8d98262927e72bc1fcb776482433d51def5f8b00449a`

Type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [inst : MeasurableSpace α] →
      {μ : MeasureTheory.Measure α} → [inst_1 : TopologicalSpace β] → [Zero β] → Zero (MeasureTheory.AEEqFun α β μ)
```

Fully explicit type:

```lean
{α : Type u_1} →
  {β : Type u_2} →
    [inst : MeasurableSpace.{u_1} α] →
      {μ : @MeasureTheory.Measure.{u_1} α inst} →
        [inst_1 : TopologicalSpace.{u_2} β] →
          [Zero.{u_2} β] → Zero.{max u_2 u_1} (@MeasureTheory.AEEqFun.{u_1, u_2} α β inst inst_1 μ)
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [MeasurableSpace α] {μ} [TopologicalSpace β] [Zero β] => { zero := MeasureTheory.AEEqFun.const α 0 }
```

### D147: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Type:

```lean
{R : Type u} →
  {M : Type v} → {inst : Semiring R} → {inst_1 : AddCommMonoid M} → [self : Module R M] → DistribMulAction R M
```

Fully explicit type:

```lean
{R : Type u} →
  {M : Type v} →
    {inst : Semiring.{u} R} →
      {inst_1 : AddCommMonoid.{v} M} →
        [self : @Module.{u, v} R M inst inst_1] →
          @DistribMulAction.{u, v} R M (@MonoidWithZero.toMonoid.{u} R (@Semiring.toMonoidWithZero.{u} R inst))
            (@AddCommMonoid.toAddMonoid.{v} M inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun R M {inst} {inst_1} [self : Module R M] => self.1
```

### D148: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D149: `MonotoneOn`

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

### D150: `Ne`

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

### D151: `NegZeroClass.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `881414a459dbdc250afc9bc468e98b17f776dfd31f2aa5eb9acee71a8d1543f7`

Type:

```lean
{G : Type u_2} → [self : NegZeroClass G] → Zero G
```

Fully explicit type:

```lean
{G : Type u_2} → [self : NegZeroClass.{u_2} G] → Zero.{u_2} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : NegZeroClass G] => self.1
```

### D152: `NonAssocSemiring.toNonUnitalNonAssocSemiring`

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

### D153: `Norm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `33e6ec5a75ead4030dc20f8726f780e34ae38f1e0ef70e2e38ecf6b1a7929334`

Type:

```lean
Type u_8 → Type u_8
```

Fully explicit type:

```lean
(E : Type u_8) → Type u_8
```

### D154: `Norm.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `79aed13c12fa8b060c652a8ff648f1ba6b5f4df36fd5f3ce0bb20c3e006fbb10`

Type:

```lean
{E : Type u_8} → (E → Real) → Norm E
```

Fully explicit type:

```lean
{E : Type u_8} → (norm : E → Real) → Norm.{u_8} E
```

### D155: `Norm.norm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `25f5aa97df9bb1faeacd7e5e6446ecbd367452a7105f098063355423713fe15a`

Type:

```lean
{E : Type u_8} → [self : Norm E] → E → Real
```

Fully explicit type:

```lean
{E : Type u_8} → [self : Norm.{u_8} E] → E → Real
```

Definition body (one-level semantic boundary):

```lean
fun E [self : Norm E] => self.1
```

### D156: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `ec9eab2d54099c52c160e626a54324e8c9a07675797f0926435031098f363e5f`

Type:

```lean
{α : Type u_5} → [self : NormedField α] → Field α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NormedField.{u_5} α] → Field.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedField α] => self.2
```

### D157: `NormedField.toNorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `b4195f8fa06c8f65467bd6e740b9c26fdcb1bc3fb17122895aeaf1c6822ffe54`

Type:

```lean
{α : Type u_5} → [self : NormedField α] → Norm α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NormedField.{u_5} α] → Norm.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedField α] => self.1
```

### D158: `NormedSpace.Core`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `204d100342adf3d94216606bbcd5e6624858dcd35bfcc82881fee3be243738f4`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [inst : NormedField 𝕜] → [inst_1 : AddCommGroup E] → [Module 𝕜 E] → [Norm E] → Prop
```

Fully explicit type:

```lean
(𝕜 : Type u_6) →
  (E : Type u_7) →
    [inst : NormedField.{u_6} 𝕜] →
      [inst_1 : AddCommGroup.{u_7} E] →
        [@Module.{u_6, u_7} 𝕜 E
              (@DivisionSemiring.toSemiring.{u_6} 𝕜
                (@Semifield.toDivisionSemiring.{u_6} 𝕜
                  (@Field.toSemifield.{u_6} 𝕜 (@NormedField.toField.{u_6} 𝕜 inst))))
              (@AddCommGroup.toAddCommMonoid.{u_7} E inst_1)] →
          [Norm.{u_7} E] → Prop
```

### D159: `NormedSpace.Core.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `ecc47a96059d907c4054bbc1ee01f45b7b2e862aa3bd1385ed81bc1bd8773283`

Type:

```lean
∀ {𝕜 : Type u_6} {E : Type u_7} [inst : NormedField 𝕜] [inst_1 : AddCommGroup E] [inst_2 : Module 𝕜 E]
  [inst_3 : Norm E], SeminormedSpace.Core 𝕜 E → (∀ (x : E), Iff (Eq (inst_3.norm x) 0) (Eq x 0)) → NormedSpace.Core 𝕜 E
```

Fully explicit type:

```lean
∀ {𝕜 : Type u_6} {E : Type u_7} [inst : NormedField.{u_6} 𝕜] [inst_1 : AddCommGroup.{u_7} E]
  [inst_2 :
    @Module.{u_6, u_7} 𝕜 E
      (@DivisionSemiring.toSemiring.{u_6} 𝕜
        (@Semifield.toDivisionSemiring.{u_6} 𝕜 (@Field.toSemifield.{u_6} 𝕜 (@NormedField.toField.{u_6} 𝕜 inst))))
      (@AddCommGroup.toAddCommMonoid.{u_7} E inst_1)]
  [inst_3 : Norm.{u_7} E] (toCore : @SeminormedSpace.Core.{u_6, u_7} 𝕜 E inst inst_1 inst_3 inst_2)
  (norm_eq_zero_iff :
    ∀ (x : E),
      Iff
        (@Eq.{1} Real (@Norm.norm.{u_7} E inst_3 x)
          (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
        (@Eq.{u_7 + 1} E x
          (@OfNat.ofNat.{u_7} E (nat_lit 0)
            (@Zero.toOfNat0.{u_7} E
              (@NegZeroClass.toZero.{u_7} E
                (@SubNegZeroMonoid.toNegZeroClass.{u_7} E
                  (@SubtractionMonoid.toSubNegZeroMonoid.{u_7} E
                    (@SubtractionCommMonoid.toSubtractionMonoid.{u_7} E
                      (@AddCommGroup.toDivisionAddCommMonoid.{u_7} E inst_1))))))))),
  @NormedSpace.Core.{u_6, u_7} 𝕜 E inst inst_1 inst_2 inst_3
```

### D160: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D161: `Or`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `de438fb54053199506d3db7df89e4ed6f1bc296d2e49a7e63e7a4b73a1b23d7e`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D162: `Or.resolve_right`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `b6de77c025372debc7b7a3b00adc5bf9a2b56ec89b9cb11f44331b1f6f3bf066`

Type:

```lean
∀ {a b : Prop}, Or a b → Not b → a
```

Fully explicit type:

```lean
∀ {a b : Prop} (h : Or a b) (nb : Not b), a
```

### D163: `Preorder.toLE`

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

### D164: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Type:

```lean
Add Real
```

Fully explicit type:

```lean
Add.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ add := Real.add✝ }
```

### D165: `Real.instAddCommSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `ee1f6e3dabe7d58e1e670ac49ad636cbe964bc19fdcfa297a61a50e7fedf7570`

Type:

```lean
AddCommSemigroup Real
```

Fully explicit type:

```lean
AddCommSemigroup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D166: `Real.instAddGroup`

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

### D167: `Real.instCommSemiring`

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

### D168: `Real.instIsOrderedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `df4b2b849009b0e354f4a2fb93f470e05bbbf9f4ec38e1e4709e600133be9280`

Type:

```lean
IsOrderedAddMonoid Real
```

Fully explicit type:

```lean
@IsOrderedAddMonoid.{0} Real Real.instAddCommMonoid Real.instPreorder
```

### D169: `Real.instLE`

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

### D170: `Real.instPreorder`

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

### D171: `Real.instZero`

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

### D172: `Real.lattice`

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

### D173: `Real.norm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `e6d33c73e5cb8fae7d8c501ead6aad9e275f7969a4d8b80f94b9f3b5001bfe3a`

Type:

```lean
Norm Real
```

Fully explicit type:

```lean
Norm.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ norm := fun r => abs r }
```

### D174: `Real.norm_eq_abs`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `b87553b9c8d04025943aab607b0ed49d3f79f5e210b6d3e714d61dc8e5a2621a`

Type:

```lean
∀ (r : Real), Eq (Real.norm.norm r) (abs r)
```

Fully explicit type:

```lean
∀ (r : Real), @Eq.{1} Real (@Norm.norm.{0} Real Real.norm r) (@abs.{0} Real Real.lattice Real.instAddGroup r)
```

### D175: `Real.partialOrder`

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

### D176: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `a8cadadddb0c9fd4a7bcb7c57401fafb43a1f330afa35fdacacb6d0e82d0bcf6`

Type:

```lean
{M : Type u_12} → {A : Type u_13} → {inst : Zero A} → [self : SMulZeroClass M A] → SMul M A
```

Fully explicit type:

```lean
{M : Type u_12} →
  {A : Type u_13} → {inst : Zero.{u_13} A} → [self : @SMulZeroClass.{u_12, u_13} M A inst] → SMul.{u_12, u_13} M A
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} [self : SMulZeroClass M A] => self.1
```

### D177: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `a1b771abeff9bbbdcce988134973a1a367c44a340bcd29acb0cc44b8d6a2e55c`

Type:

```lean
{K : Type u_2} → [self : Semifield K] → DivisionSemiring K
```

Fully explicit type:

```lean
{K : Type u_2} → [self : Semifield.{u_2} K] → DivisionSemiring.{u_2} K
```

Definition body (one-level semantic boundary):

```lean
fun K self =>
  { toSemiring := self.toSemiring, toInv := self.toInv, toDiv := self.toDiv, div_eq_mul_inv := ⋯, zpow := self.zpow,
    zpow_zero' := ⋯, zpow_succ' := ⋯, zpow_neg' := ⋯, toNontrivial := ⋯, inv_zero := ⋯, mul_inv_cancel := ⋯,
    toNNRatCast := self.toNNRatCast, nnratCast_def := ⋯, nnqsmul := self.nnqsmul, nnqsmul_def := ⋯ }
```

### D178: `SemilatticeInf.toPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Lattice`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `893084ece5bf8c05fbd4a1c81599a96f6f81888e21ce27ed05c0d273c70e59b0`

Type:

```lean
{α : Type u} → [self : SemilatticeInf α] → PartialOrder α
```

Fully explicit type:

```lean
{α : Type u} → [self : SemilatticeInf.{u} α] → PartialOrder.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : SemilatticeInf α] => self.1
```

### D179: `SeminormedSpace.Core.mk`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `99750e8e6c58bf2d9128fee8411700c59d01dab2808488b0401ea9db861bae10`

Type:

```lean
∀ {𝕜 : Type u_6} {E : Type u_7} [inst : NormedField 𝕜] [inst_1 : AddCommGroup E] [inst_2 : Norm E]
  [inst_3 : Module 𝕜 E],
  (∀ (x : E), Real.instLE.le 0 (inst_2.norm x)) →
    (∀ (c : 𝕜) (x : E), Eq (inst_2.norm (instHSMul.hSMul c x)) (instHMul.hMul (inst.norm c) (inst_2.norm x))) →
      (∀ (x y : E), Real.instLE.le (inst_2.norm (instHAdd.hAdd x y)) (instHAdd.hAdd (inst_2.norm x) (inst_2.norm y))) →
        SeminormedSpace.Core 𝕜 E
```

Fully explicit type:

```lean
∀ {𝕜 : Type u_6} {E : Type u_7} [inst : NormedField.{u_6} 𝕜] [inst_1 : AddCommGroup.{u_7} E] [inst_2 : Norm.{u_7} E]
  [inst_3 :
    @Module.{u_6, u_7} 𝕜 E
      (@DivisionSemiring.toSemiring.{u_6} 𝕜
        (@Semifield.toDivisionSemiring.{u_6} 𝕜 (@Field.toSemifield.{u_6} 𝕜 (@NormedField.toField.{u_6} 𝕜 inst))))
      (@AddCommGroup.toAddCommMonoid.{u_7} E inst_1)]
  (norm_nonneg :
    ∀ (x : E),
      @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
        (@Norm.norm.{u_7} E inst_2 x))
  (norm_smul :
    ∀ (c : 𝕜) (x : E),
      @Eq.{1} Real
        (@Norm.norm.{u_7} E inst_2
          (@HSMul.hSMul.{u_6, u_7, u_7} 𝕜 E E
            (@instHSMul.{u_6, u_7} 𝕜 E
              (@SMulZeroClass.toSMul.{u_6, u_7} 𝕜 E
                (@AddZero.toZero.{u_7} E
                  (@AddZeroClass.toAddZero.{u_7} E
                    (@AddMonoid.toAddZeroClass.{u_7} E
                      (@SubNegMonoid.toAddMonoid.{u_7} E
                        (@AddGroup.toSubNegMonoid.{u_7} E (@AddCommGroup.toAddGroup.{u_7} E inst_1))))))
                (@DistribSMul.toSMulZeroClass.{u_6, u_7} 𝕜 E
                  (@AddMonoid.toAddZeroClass.{u_7} E
                    (@SubNegMonoid.toAddMonoid.{u_7} E
                      (@AddGroup.toSubNegMonoid.{u_7} E (@AddCommGroup.toAddGroup.{u_7} E inst_1))))
                  (@DistribMulAction.toDistribSMul.{u_6, u_7} 𝕜 E
                    (@MonoidWithZero.toMonoid.{u_6} 𝕜
                      (@Semiring.toMonoidWithZero.{u_6} 𝕜
                        (@DivisionSemiring.toSemiring.{u_6} 𝕜
                          (@Semifield.toDivisionSemiring.{u_6} 𝕜
                            (@Field.toSemifield.{u_6} 𝕜 (@NormedField.toField.{u_6} 𝕜 inst))))))
                    (@SubNegMonoid.toAddMonoid.{u_7} E
                      (@AddGroup.toSubNegMonoid.{u_7} E (@AddCommGroup.toAddGroup.{u_7} E inst_1)))
                    (@Module.toDistribMulAction.{u_6, u_7} 𝕜 E
                      (@DivisionSemiring.toSemiring.{u_6} 𝕜
                        (@Semifield.toDivisionSemiring.{u_6} 𝕜
                          (@Field.toSemifield.{u_6} 𝕜 (@NormedField.toField.{u_6} 𝕜 inst))))
                      (@AddCommGroup.toAddCommMonoid.{u_7} E inst_1) inst_3)))))
            c x))
        (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
          (@Norm.norm.{u_6} 𝕜 (@NormedField.toNorm.{u_6} 𝕜 inst) c) (@Norm.norm.{u_7} E inst_2 x)))
  (norm_triangle :
    ∀ (x y : E),
      @LE.le.{0} Real Real.instLE
        (@Norm.norm.{u_7} E inst_2
          (@HAdd.hAdd.{u_7, u_7, u_7} E E E
            (@instHAdd.{u_7} E
              (@AddCommMagma.toAdd.{u_7} E
                (@AddCommSemigroup.toAddCommMagma.{u_7} E
                  (@AddCommMonoid.toAddCommSemigroup.{u_7} E (@AddCommGroup.toAddCommMonoid.{u_7} E inst_1)))))
            x y))
        (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd) (@Norm.norm.{u_7} E inst_2 x)
          (@Norm.norm.{u_7} E inst_2 y))),
  @SeminormedSpace.Core.{u_6, u_7} 𝕜 E inst inst_1 inst_2 inst_3
```

### D180: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D181: `Semiring.toNonAssocSemiring`

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

### D182: `Set`

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

### D183: `Set.Ici`

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

### D184: `Set.instMembership`

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

### D185: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `9e6f6ef922e3c39bdc8dcf74fa873f2e393c916c08aa49739c9dcafb3f96877b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → AddMonoid G
```

Fully explicit type:

```lean
{G : Type u} → [self : SubNegMonoid.{u} G] → AddMonoid.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.1
```

### D186: `SubNegZeroMonoid.toNegZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `0ca9c4737492ec2a9a5ab16ab065d00204507f2caf80997692c360afbf962577`

Type:

```lean
{G : Type u_2} → [self : SubNegZeroMonoid G] → NegZeroClass G
```

Fully explicit type:

```lean
{G : Type u_2} → [self : SubNegZeroMonoid.{u_2} G] → NegZeroClass.{u_2} G
```

Definition body (one-level semantic boundary):

```lean
fun G self => { toZero := self.toZero, toNeg := self.toNeg, neg_zero := ⋯ }
```

### D187: `Submodule.add`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `31330c71327149cd083c0b33ed8b59646bae3ce84dbd26c60d52b34d4f051a76`

Type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring R] →
      [inst_1 : AddCommMonoid M] →
        {module_M : Module R M} → (p : Submodule R M) → Add (Subtype fun x => SetLike.instMembership.mem p x)
```

Fully explicit type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring.{u} R] →
      [inst_1 : AddCommMonoid.{v} M] →
        {module_M : @Module.{u, v} R M inst inst_1} →
          (p : @Submodule.{u, v} R M inst inst_1 module_M) →
            Add.{v}
              (@Subtype.{v + 1} M fun (x : M) =>
                @Membership.mem.{v, v} M (@Submodule.{u, v} R M inst inst_1 module_M)
                  (@SetLike.instMembership.{v, v} (@Submodule.{u, v} R M inst inst_1 module_M) M
                    (@Submodule.setLike.{u, v} R M inst inst_1 module_M))
                  p x)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Semiring R] [AddCommMonoid M] {module_M} p => { add := fun x y => ⟨instHAdd.hAdd x.val y.val, ⋯⟩ }
```

### D188: `SubtractionCommMonoid.toSubtractionMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `e56d8d718ddbe8a62b0e5b703adfd59bd19f46dac79c341b3d3742ed6ee462c9`

Type:

```lean
{G : Type u} → [self : SubtractionCommMonoid G] → SubtractionMonoid G
```

Fully explicit type:

```lean
{G : Type u} → [self : SubtractionCommMonoid.{u} G] → SubtractionMonoid.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubtractionCommMonoid G] => self.1
```

### D189: `SubtractionMonoid.toSubNegZeroMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `700a470249543a704f0b5910309b7d1f4c918e3b645f806242c291c98eff4e28`

Type:

```lean
{α : Type u_1} → [SubtractionMonoid α] → SubNegZeroMonoid α
```

Fully explicit type:

```lean
{α : Type u_1} → [SubtractionMonoid.{u_1} α] → SubNegZeroMonoid.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : SubtractionMonoid α] =>
  let __src := inst.toSubNegMonoid;
  { toSubNegMonoid := __src, neg_zero := ⋯ }
```

### D190: `Subtype.ext`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `e2f5dcf24b0dff5ed00dc393a13a8dfa5b19b50ac524341bb1dccf9fa05a60c5`

Type:

```lean
∀ {α : Sort u} {p : α → Prop} {a1 a2 : Subtype fun x => p x}, Eq a1.val a2.val → Eq a1 a2
```

Fully explicit type:

```lean
∀ {α : Sort u} {p : α → Prop} {a1 a2 : @Subtype.{u} α fun (x : α) => p x},
  @Eq.{u} α (@Subtype.val.{u} α (fun (x : α) => p x) a1) (@Subtype.val.{u} α (fun (x : α) => p x) a2) →
    @Eq.{max 1 u} (@Subtype.{u} α fun (x : α) => p x) a1 a2
```

### D191: `Subtype.property`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `40e13b1e65ed463a9ade996343f4fb284f4a37a83c37bb24436b9e8d9bb93ec6`

Type:

```lean
∀ {α : Sort u} {p : α → Prop} (self : Subtype p), p self.val
```

Fully explicit type:

```lean
∀ {α : Sort u} {p : α → Prop} (self : @Subtype.{u} α p), p (@Subtype.val.{u} α p self)
```

### D192: `Subtype.val`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `69c61ab82498e5563eaf5f0313ea7f2164c284c3dc742024a30332372a46663d`

Type:

```lean
{α : Sort u} → {p : α → Prop} → Subtype p → α
```

Fully explicit type:

```lean
{α : Sort u} → {p : α → Prop} → (self : @Subtype.{u} α p) → α
```

Definition body (one-level semantic boundary):

```lean
fun α p self => self.1
```

### D193: `True`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `151888ac453f6815e1022e38f8b589caefb03395ffd196a9f58c1de8920fa6e1`

Type:

```lean
Prop
```

Fully explicit type:

```lean
Prop
```

### D194: `Zero.toOfNat0`

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

### D195: `abs`

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

### D196: `abs_nonneg`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Group.Unbundled.Abs`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `19cfea50df73160e33340bf4a26a68ce9d57cf2a25ed0a1cf7fc80d4481e39ba`

Type:

```lean
∀ {α : Type u_1} [inst : Lattice α] [inst_1 : AddGroup α] [AddLeftMono α] [AddRightMono α] (a : α),
  inst.toSemilatticeInf.le 0 (abs a)
```

Fully explicit type:

```lean
∀ {α : Type u_1} [inst : Lattice.{u_1} α] [inst_1 : AddGroup.{u_1} α]
  [@AddLeftMono.{u_1} α
      (@AddZero.toAdd.{u_1} α
        (@AddZeroClass.toAddZero.{u_1} α
          (@AddMonoid.toAddZeroClass.{u_1} α
            (@SubNegMonoid.toAddMonoid.{u_1} α (@AddGroup.toSubNegMonoid.{u_1} α inst_1)))))
      (@Preorder.toLE.{u_1} α
        (@PartialOrder.toPreorder.{u_1} α
          (@SemilatticeInf.toPartialOrder.{u_1} α (@Lattice.toSemilatticeInf.{u_1} α inst))))]
  [@AddRightMono.{u_1} α
      (@AddZero.toAdd.{u_1} α
        (@AddZeroClass.toAddZero.{u_1} α
          (@AddMonoid.toAddZeroClass.{u_1} α
            (@SubNegMonoid.toAddMonoid.{u_1} α (@AddGroup.toSubNegMonoid.{u_1} α inst_1)))))
      (@Preorder.toLE.{u_1} α
        (@PartialOrder.toPreorder.{u_1} α
          (@SemilatticeInf.toPartialOrder.{u_1} α (@Lattice.toSemilatticeInf.{u_1} α inst))))]
  (a : α),
  @LE.le.{u_1} α
    (@Preorder.toLE.{u_1} α
      (@PartialOrder.toPreorder.{u_1} α
        (@SemilatticeInf.toPartialOrder.{u_1} α (@Lattice.toSemilatticeInf.{u_1} α inst))))
    (@OfNat.ofNat.{u_1} α (nat_lit 0)
      (@Zero.toOfNat0.{u_1} α
        (@NegZeroClass.toZero.{u_1} α
          (@SubNegZeroMonoid.toNegZeroClass.{u_1} α
            (@SubtractionMonoid.toSubNegZeroMonoid.{u_1} α (@AddGroup.toSubtractionMonoid.{u_1} α inst_1))))))
    (@abs.{u_1} α inst inst_1 a)
```

### D197: `congrArg`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `6c5d6e47fc74ac759773919ff0f898f10bbde756c9dc79f4cb3fe1e553faea80`

Type:

```lean
∀ {α : Sort u} {β : Sort v} {a₁ a₂ : α} (f : α → β), Eq a₁ a₂ → Eq (f a₁) (f a₂)
```

Fully explicit type:

```lean
∀ {α : Sort u} {β : Sort v} {a₁ a₂ : α} (f : α → β) (h : @Eq.{u} α a₁ a₂), @Eq.{v} β (f a₁) (f a₂)
```

### D198: `congrFun'`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `e580a00193311ae42019fe2b62303654840079352c4cf3e793473ab7212ac9ad`

Type:

```lean
∀ {α : Sort u} {β : Sort v} {f g : α → β}, Eq f g → ∀ (a : α), Eq (f a) (g a)
```

Fully explicit type:

```lean
∀ {α : Sort u} {β : Sort v} {f g : α → β} (h : @Eq.{imax u v} (α → β) f g) (a : α), @Eq.{v} β (f a) (g a)
```

### D199: `covariant_swap_add_of_covariant_add`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Monoid.Unbundled.Defs`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `31ebefeee19bf7476979074306a9b18488a672fc657ed3273ffedcfb6b42f0c5`

Type:

```lean
∀ (N : Type u_2) (r : N → N → Prop) [inst : AddCommSemigroup N]
  [CovariantClass N N (fun x1 x2 => instHAdd.hAdd x1 x2) r],
  CovariantClass N N (Function.swap fun x1 x2 => instHAdd.hAdd x1 x2) r
```

Fully explicit type:

```lean
∀ (N : Type u_2) (r : N → N → Prop) [inst : AddCommSemigroup.{u_2} N]
  [CovariantClass.{u_2, u_2} N N
      (fun (x1 x2 : N) =>
        @HAdd.hAdd.{u_2, u_2, u_2} N N N
          (@instHAdd.{u_2} N (@AddCommMagma.toAdd.{u_2} N (@AddCommSemigroup.toAddCommMagma.{u_2} N inst))) x1 x2)
      r],
  CovariantClass.{u_2, u_2} N N
    (@Function.swap.{u_2 + 1, u_2 + 1, u_2 + 1} N N (fun (a a_1 : N) => N) fun (x1 x2 : N) =>
      @HAdd.hAdd.{u_2, u_2, u_2} N N N
        (@instHAdd.{u_2} N (@AddCommMagma.toAdd.{u_2} N (@AddCommSemigroup.toAddCommMagma.{u_2} N inst))) x1 x2)
    r
```

### D200: `eq_self`

- Role: `external-frontier`
- Owner module: `Init.SimpLemmas`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `985364745d59b03461bacc124329517d0c7b8c094fd571978e168aeafb6b5a4d`

Type:

```lean
∀ {α : Sort u_1} (a : α), Eq (Eq a a) True
```

Fully explicit type:

```lean
∀ {α : Sort u_1} (a : α), @Eq.{1} Prop (@Eq.{u_1} α a a) True
```

### D201: `id`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `dbf7c9f75c53aa3b4f811b7fd8038f2d2ab775571e37341e9514361b972c4868`

Type:

```lean
{α : Sort u} → α → α
```

Fully explicit type:

```lean
{α : Sort u} → (a : α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} a => a
```

### D202: `instHAdd`

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

### D203: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D204: `instHSMul`

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

### D205: `instZeroENNReal`

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

### D206: `ne_of_lt`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `d4f64be74c292d9fedba68e124ab1d23e6edc0a3f6c0dd2963631a7c90df2cad`

Type:

```lean
∀ {α : Type u_1} [inst : Preorder α] {a b : α}, inst.lt a b → Ne a b
```

Fully explicit type:

```lean
∀ {α : Type u_1} [inst : Preorder.{u_1} α] {a b : α} (h : @LT.lt.{u_1} α (@Preorder.toLT.{u_1} α inst) a b),
  @Ne.{u_1 + 1} α a b
```

### D207: `of_eq_true`

- Role: `external-frontier`
- Owner module: `Init.SimpLemmas`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `6111576b41c62c494716c58bbd370bce6bd03cda7b8c7b277e8f8b1e5eaaf99a`

Type:

```lean
∀ {p : Prop}, Eq p True → p
```

Fully explicit type:

```lean
∀ {p : Prop} (h : @Eq.{1} Prop p True), p
```

### D208: `CompleteLinearOrder.toConditionallyCompleteLinearOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D209: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D210: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D211: `ConditionallyCompleteLinearOrderBot.toConditionallyCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D212: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D213: `ConditionallyCompletePartialOrderInf.toInfSet`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D214: `ENNReal.instCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D215: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D216: `InfSet.sInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.SetNotation`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D217: `AddCommMonoidWithOne.toAddMonoidWithOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D218: `AddMonoidWithOne.toOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D219: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `6`
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

### D220: `instAddCommMonoidWithOneENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
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

### D221: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D222: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D223: `MeasureTheory.lintegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Lebesgue.Basic`
- Declaration kind: `def`
- Distance from target type: `7`
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

### D224: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `7`
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

### D225: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `7`
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
