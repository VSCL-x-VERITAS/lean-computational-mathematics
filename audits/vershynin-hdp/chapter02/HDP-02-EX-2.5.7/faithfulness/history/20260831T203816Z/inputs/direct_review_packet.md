# Declaration dossier for HDP-02-EX-2.5.7

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
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
            NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x)
```

## Elaborated target type

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω)
  [inst_1 : MeasureTheory.IsProbabilityMeasure μ],
  And
    (∀ (x : NumStability.HDP.Scalar.SubGaussian.psiTwoSpace μ),
      Real.instLE.le 0 (NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x))
    (And (Eq (NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ 0) 0)
      (And
        (∀ (x : NumStability.HDP.Scalar.SubGaussian.psiTwoSpace μ),
          Iff (Eq (NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x) 0) (Eq x 0))
        (And
          (∀ (x y : NumStability.HDP.Scalar.SubGaussian.psiTwoSpace μ),
            Real.instLE.le (NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ (instHAdd.hAdd x y))
              (instHAdd.hAdd (NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x)
                (NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ y)))
          (∀ (c : Real) (x : NumStability.HDP.Scalar.SubGaussian.psiTwoSpace μ),
            Eq (NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ (instHSMul.hSMul c x))
              (instHMul.hMul (abs c) (NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x))))))
```

## Fully explicit elaborated target type

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ],
  And
    (∀ (x : @NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1),
      @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
        (@NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm.{u_1} Ω inst μ inst_1 x))
    (And
      (@Eq.{1} Real
        (@NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm.{u_1} Ω inst μ inst_1
          (@OfNat.ofNat.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1) (nat_lit 0)
            (@Zero.toOfNat0.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
              (@NegZeroClass.toZero.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                (@SubNegZeroMonoid.toNegZeroClass.{u_1}
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                  (@SubtractionMonoid.toSubNegZeroMonoid.{u_1}
                    (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                    (@SubtractionCommMonoid.toSubtractionMonoid.{u_1}
                      (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                      (@AddCommGroup.toDivisionAddCommMonoid.{u_1}
                        (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                        (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instAddCommGroup.{u_1} Ω inst μ
                          inst_1)))))))))
        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
      (And
        (∀ (x : @NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1),
          Iff
            (@Eq.{1} Real (@NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm.{u_1} Ω inst μ inst_1 x)
              (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
            (@Eq.{u_1 + 1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1) x
              (@OfNat.ofNat.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1) (nat_lit 0)
                (@Zero.toOfNat0.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                  (@NegZeroClass.toZero.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                    (@SubNegZeroMonoid.toNegZeroClass.{u_1}
                      (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                      (@SubtractionMonoid.toSubNegZeroMonoid.{u_1}
                        (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                        (@SubtractionCommMonoid.toSubtractionMonoid.{u_1}
                          (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                          (@AddCommGroup.toDivisionAddCommMonoid.{u_1}
                            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instAddCommGroup.{u_1} Ω inst μ
                              inst_1))))))))))
        (And
          (∀ (x y : @NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1),
            @LE.le.{0} Real Real.instLE
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm.{u_1} Ω inst μ inst_1
                (@HAdd.hAdd.{u_1, u_1, u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                  (@instHAdd.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                    (@AddCommMagma.toAdd.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                      (@AddCommSemigroup.toAddCommMagma.{u_1}
                        (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                        (@AddCommMonoid.toAddCommSemigroup.{u_1}
                          (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                          (@AddCommGroup.toAddCommMonoid.{u_1}
                            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instAddCommGroup.{u_1} Ω inst μ
                              inst_1))))))
                  x y))
              (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm.{u_1} Ω inst μ inst_1 x)
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm.{u_1} Ω inst μ inst_1 y)))
          (∀ (c : Real) (x : @NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1),
            @Eq.{1} Real
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm.{u_1} Ω inst μ inst_1
                (@HSMul.hSMul.{0, u_1, u_1} Real
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                  (@instHSMul.{0, u_1} Real (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                    (@SMulZeroClass.toSMul.{0, u_1} Real
                      (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                      (@AddZero.toZero.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                        (@AddZeroClass.toAddZero.{u_1}
                          (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                          (@AddMonoid.toAddZeroClass.{u_1}
                            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                            (@SubNegMonoid.toAddMonoid.{u_1}
                              (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                              (@AddGroup.toSubNegMonoid.{u_1}
                                (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                                (@AddCommGroup.toAddGroup.{u_1}
                                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instAddCommGroup.{u_1} Ω inst μ
                                    inst_1)))))))
                      (@DistribSMul.toSMulZeroClass.{0, u_1} Real
                        (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                        (@AddMonoid.toAddZeroClass.{u_1}
                          (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                          (@SubNegMonoid.toAddMonoid.{u_1}
                            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                            (@AddGroup.toSubNegMonoid.{u_1}
                              (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                              (@AddCommGroup.toAddGroup.{u_1}
                                (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                                (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instAddCommGroup.{u_1} Ω inst μ
                                  inst_1)))))
                        (@DistribMulAction.toDistribSMul.{0, u_1} Real
                          (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1) Real.instMonoid
                          (@SubNegMonoid.toAddMonoid.{u_1}
                            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                            (@AddGroup.toSubNegMonoid.{u_1}
                              (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                              (@AddCommGroup.toAddGroup.{u_1}
                                (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                                (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instAddCommGroup.{u_1} Ω inst μ
                                  inst_1))))
                          (@Module.toDistribMulAction.{0, u_1} Real
                            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1) Real.semiring
                            (@AddCommGroup.toAddCommMonoid.{u_1}
                              (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
                              (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instAddCommGroup.{u_1} Ω inst μ inst_1))
                            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instModule.{u_1} Ω inst μ inst_1))))))
                  c x))
              (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                (@abs.{0} Real Real.lattice Real.instAddGroup c)
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm.{u_1} Ω inst μ inst_1 x))))))
```

## Local import graph

- `AuditTarget` imports: `Mathlib.Probability.Distributions.Gaussian.Real`, `Mathlib.Probability.Distributions.Gaussian.HasGaussianLaw.Independence`, `Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral`, `Mathlib.Analysis.SpecialFunctions.Gamma.Beta`, `Mathlib.Analysis.SpecialFunctions.Stirling`, `Mathlib.Analysis.Complex.ExponentialBounds`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.Series`, `Mathlib.Analysis.SpecificLimits.Basic`, `Mathlib.Analysis.Convex.SpecificFunctions.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Integral.Gamma`, `Mathlib.MeasureTheory.Function.L1Space.Integrable`, `Mathlib.Probability.Moments.IntegrableExpMul`, `Mathlib.Tactic`, `NumStability.HDP.Scalar.Preliminaries`, `NumStability.HDP.Scalar.IndependentSums.Hoeffding`, `NumStability.HDP.ContractSignatures.C_02_hex_h2_d6_d9`
- `NumStability.HDP.Scalar.Preliminaries` imports: `Mathlib.Probability.Moments.Variance`, `Mathlib.Probability.CDF`, `Mathlib.MeasureTheory.Function.LpSpace.Basic`, `Mathlib.MeasureTheory.Function.LpSpace.Complete`, `Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm`, `Mathlib.MeasureTheory.Function.LpSeminorm.Indicator`, `Mathlib.Probability.UniformOn`, `Mathlib.Analysis.Convex.Integral`, `Mathlib.Analysis.Convex.Continuous`, `Mathlib.MeasureTheory.Integral.Bochner.Set`, `Mathlib.MeasureTheory.Integral.Lebesgue.Markov`, `Mathlib.MeasureTheory.Integral.Layercake`, `Mathlib.MeasureTheory.Measure.Lebesgue.Integral`, `Mathlib.Probability.Distributions.Cauchy`, `Mathlib.Analysis.SpecialFunctions.NonIntegrable`, `Mathlib.Analysis.SpecialFunctions.Pow.Integral`, `Mathlib.Tactic`
- `NumStability.HDP.Scalar.IndependentSums.Hoeffding` imports: `Mathlib.Probability.Independence.Integration`, `Mathlib.Probability.Moments.Basic`, `Mathlib.Probability.Moments.SubGaussian`, `Mathlib.Probability.ProbabilityMassFunction.Constructions`, `Mathlib.Probability.ProbabilityMassFunction.Integrals`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.Series`, `Mathlib.Analysis.SpecialFunctions.ImproperIntegrals`, `Mathlib.Tactic`, `NumStability.HDP.Scalar.Preliminaries`
- `NumStability.HDP.ContractSignatures.C_02_hex_h2_d6_d9` imports: `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `14327f09d57a7ca4addd4025fbaf4db948e51d22ed47329751c84e411e741761`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (μ : MeasureTheory.Measure Ω) →
      [inst_1 : MeasureTheory.IsProbabilityMeasure μ] → NumStability.HDP.Scalar.SubGaussian.psiTwoSpace μ → Real
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
      [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] →
        @NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1 → Real
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ [MeasureTheory.IsProbabilityMeasure μ] x =>
  (NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientGauge μ x).toReal
```

### D002: `NumStability.HDP.Scalar.SubGaussian.psiTwoSpace`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a45c385303444fb971348def6898784b9bd17063f598fb8207cfad0a7ad079ba`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] → (μ : MeasureTheory.Measure Ω) → [MeasureTheory.IsProbabilityMeasure μ] → Type u_1
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) → [@MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] → Type u_1
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ [MeasureTheory.IsProbabilityMeasure μ] =>
  Submodule.hasQuotient.Quotient
    (Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule μ) x)
    (NumStability.HDP.Scalar.SubGaussian.psiTwoNullSubmodule μ)
```

### D003: `NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instAddCommGroup`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `356c909c1a66ebdea54436fc61d0c3a25d78f814b1f5b345f85977113c2129f2`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (μ : MeasureTheory.Measure Ω) →
      [inst_1 : MeasureTheory.IsProbabilityMeasure μ] → AddCommGroup (NumStability.HDP.Scalar.SubGaussian.psiTwoSpace μ)
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
      [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] →
        AddCommGroup.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ [MeasureTheory.IsProbabilityMeasure μ] =>
  id (Submodule.Quotient.addCommGroup (NumStability.HDP.Scalar.SubGaussian.psiTwoNullSubmodule μ))
```

### D004: `NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instModule`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9940531e3e83534449cbc644301e882e1e19e227d0dcfa99aa58f29d625c5005`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (μ : MeasureTheory.Measure Ω) →
      [inst_1 : MeasureTheory.IsProbabilityMeasure μ] → Module Real (NumStability.HDP.Scalar.SubGaussian.psiTwoSpace μ)
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
      [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] →
        @Module.{0, u_1} Real (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1) Real.semiring
          (@AddCommGroup.toAddCommMonoid.{u_1} (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1)
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.instAddCommGroup.{u_1} Ω inst μ inst_1))
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ [MeasureTheory.IsProbabilityMeasure μ] =>
  id (Submodule.Quotient.module (NumStability.HDP.Scalar.SubGaussian.psiTwoNullSubmodule μ))
```

### D005: `NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5bfda0b453d51c0c8d0e6597ecf4bf21099b2c55b4f666e0f272b8555158e91e`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (μ : MeasureTheory.Measure Ω) → [MeasureTheory.IsProbabilityMeasure μ] → Submodule Real (Ω → Real)
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
      [@MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] →
        @Submodule.{0, u_1} Real (Ω → Real) Real.semiring
          (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
          (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ [MeasureTheory.IsProbabilityMeasure μ] =>
  {
    carrier :=
      setOf fun X =>
        And (Measurable X)
          (ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X) instTopENNReal.top),
    add_mem' := ⋯, zero_mem' := ⋯, smul_mem' := ⋯ }
```

### D006: `NumStability.HDP.Scalar.SubGaussian.psiTwoNullSubmodule`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `0878789b3bbab166084b0d7f37cf8029d4bc09326569d7b3f8fef2a00c254863`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (μ : MeasureTheory.Measure Ω) →
      [inst_1 : MeasureTheory.IsProbabilityMeasure μ] →
        Submodule Real
          (Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule μ) x)
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
      [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] →
        @Submodule.{0, u_1} Real
          (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
          Real.semiring
          (@Submodule.addCommMonoid.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1))
          (@Submodule.module.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1))
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ [MeasureTheory.IsProbabilityMeasure μ] =>
  { carrier := setOf fun X => (MeasureTheory.ae μ).EventuallyEq X.val fun x => 0, add_mem' := ⋯, zero_mem' := ⋯,
    smul_mem' := ⋯ }
```

### D007: `NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientGauge`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `29ec8fa7d0c2f8e27593a1e258023ebe63561a0bef94077758540375041e1071`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (μ : MeasureTheory.Measure Ω) →
      [inst_1 : MeasureTheory.IsProbabilityMeasure μ] → NumStability.HDP.Scalar.SubGaussian.psiTwoSpace μ → ENNReal
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
      [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] →
        @NumStability.HDP.Scalar.SubGaussian.psiTwoSpace.{u_1} Ω inst μ inst_1 → ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ [MeasureTheory.IsProbabilityMeasure μ] =>
  Quotient.lift (fun X => NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X.val) ⋯
```

### D008: `NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `13e4fc681870d7011fb2cf1c0c82a423b181ab89c0d074bddbcadfb4d4acfce3`

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

### D009: `NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule._proof_1`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `738613160ac9002d9f47e7110a680a388ddba463793cd5383ba6933bef3c67c5`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω) {X Y : Ω → Real},
  Set.instMembership.mem
      (setOf fun X =>
        And (Measurable X)
          (ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X) instTopENNReal.top))
      X →
    Set.instMembership.mem
        (setOf fun X =>
          And (Measurable X)
            (ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X) instTopENNReal.top))
        Y →
      And (Measurable (instHAdd.hAdd X Y))
        (ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (instHAdd.hAdd X Y))
          instTopENNReal.top)
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (μ : @MeasureTheory.Measure.{u_1} Ω inst) {X Y : Ω → Real}
  (hX :
    @Membership.mem.{u_1, u_1} (Ω → Real) (Set.{u_1} (Ω → Real)) (@Set.instMembership.{u_1} (Ω → Real))
      (@setOf.{u_1} (Ω → Real) fun (X : Ω → Real) =>
        And (@Measurable.{u_1, 0} Ω Real inst Real.measurableSpace X)
          (@LT.lt.{0} ENNReal
            (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
            (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ X) (@Top.top.{0} ENNReal instTopENNReal)))
      X)
  (hY :
    @Membership.mem.{u_1, u_1} (Ω → Real) (Set.{u_1} (Ω → Real)) (@Set.instMembership.{u_1} (Ω → Real))
      (@setOf.{u_1} (Ω → Real) fun (X : Ω → Real) =>
        And (@Measurable.{u_1, 0} Ω Real inst Real.measurableSpace X)
          (@LT.lt.{0} ENNReal
            (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
            (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ X) (@Top.top.{0} ENNReal instTopENNReal)))
      Y),
  And
    (@Measurable.{u_1, 0} Ω Real inst Real.measurableSpace
      (@HAdd.hAdd.{u_1, u_1, u_1} (Ω → Real) (Ω → Real) (Ω → Real)
        (@instHAdd.{u_1} (Ω → Real)
          (@AddZero.toAdd.{u_1} (Ω → Real)
            (@AddZeroClass.toAddZero.{u_1} (Ω → Real)
              (@AddMonoid.toAddZeroClass.{u_1} (Ω → Real)
                (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid))))))
        X Y))
    (@LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
      (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ
        (@HAdd.hAdd.{u_1, u_1, u_1} (Ω → Real) (Ω → Real) (Ω → Real)
          (@instHAdd.{u_1} (Ω → Real)
            (@AddZero.toAdd.{u_1} (Ω → Real)
              (@AddZeroClass.toAddZero.{u_1} (Ω → Real)
                (@AddMonoid.toAddZeroClass.{u_1} (Ω → Real)
                  (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid))))))
          X Y))
      (@Top.top.{0} ENNReal instTopENNReal))
```

### D010: `NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule._proof_2`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `ed55cd23c39d007ed53f24b4b1501cf04d742f2be509aa5882d0ea5af7048577`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω) [MeasureTheory.IsProbabilityMeasure μ],
  And (Measurable 0)
    (ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ 0) instTopENNReal.top)
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  [@MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ],
  And
    (@Measurable.{u_1, 0} Ω Real inst Real.measurableSpace
      (@OfNat.ofNat.{u_1} (Ω → Real) (nat_lit 0)
        (@Zero.toOfNat0.{u_1} (Ω → Real)
          (@AddZero.toZero.{u_1} (Ω → Real)
            (@AddZeroClass.toAddZero.{u_1} (Ω → Real)
              (@AddMonoid.toAddZeroClass.{u_1} (Ω → Real)
                (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid))))))))
    (@LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
      (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ
        (@OfNat.ofNat.{u_1} (Ω → Real) (nat_lit 0)
          (@Zero.toOfNat0.{u_1} (Ω → Real)
            (@AddZero.toZero.{u_1} (Ω → Real)
              (@AddZeroClass.toAddZero.{u_1} (Ω → Real)
                (@AddMonoid.toAddZeroClass.{u_1} (Ω → Real)
                  (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid))))))))
      (@Top.top.{0} ENNReal instTopENNReal))
```

### D011: `NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule._proof_3`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `38a582b30a3f358aeba53a8979c920d67281644d4bbc8c01155a06eed345bdda`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω) [MeasureTheory.IsProbabilityMeasure μ]
  (c : Real) {X : Ω → Real},
  Set.instMembership.mem
      (setOf fun X =>
        And (Measurable X)
          (ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X) instTopENNReal.top))
      X →
    And (Measurable (instHSMul.hSMul c X))
      (ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (instHSMul.hSMul c X))
        instTopENNReal.top)
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  [@MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] (c : Real) {X : Ω → Real}
  (hX :
    @Membership.mem.{u_1, u_1} (Ω → Real) (Set.{u_1} (Ω → Real)) (@Set.instMembership.{u_1} (Ω → Real))
      (@setOf.{u_1} (Ω → Real) fun (X : Ω → Real) =>
        And (@Measurable.{u_1, 0} Ω Real inst Real.measurableSpace X)
          (@LT.lt.{0} ENNReal
            (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
            (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ X) (@Top.top.{0} ENNReal instTopENNReal)))
      X),
  And
    (@Measurable.{u_1, 0} Ω Real inst Real.measurableSpace
      (@HSMul.hSMul.{0, u_1, u_1} Real (Ω → Real) (Ω → Real)
        (@instHSMul.{0, u_1} Real (Ω → Real)
          (@SMulZeroClass.toSMul.{0, u_1} Real (Ω → Real)
            (@AddZero.toZero.{u_1} (Ω → Real)
              (@AddZeroClass.toAddZero.{u_1} (Ω → Real)
                (@AddMonoid.toAddZeroClass.{u_1} (Ω → Real)
                  (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)))))
            (@DistribSMul.toSMulZeroClass.{0, u_1} Real (Ω → Real)
              (@AddMonoid.toAddZeroClass.{u_1} (Ω → Real)
                (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)))
              (@DistribMulAction.toDistribSMul.{0, u_1} Real (Ω → Real)
                (@MonoidWithZero.toMonoid.{0} Real (@Semiring.toMonoidWithZero.{0} Real Real.semiring))
                (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid))
                (@Module.toDistribMulAction.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))))))
        c X))
    (@LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
      (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ
        (@HSMul.hSMul.{0, u_1, u_1} Real (Ω → Real) (Ω → Real)
          (@instHSMul.{0, u_1} Real (Ω → Real)
            (@SMulZeroClass.toSMul.{0, u_1} Real (Ω → Real)
              (@AddZero.toZero.{u_1} (Ω → Real)
                (@AddZeroClass.toAddZero.{u_1} (Ω → Real)
                  (@AddMonoid.toAddZeroClass.{u_1} (Ω → Real)
                    (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)))))
              (@DistribSMul.toSMulZeroClass.{0, u_1} Real (Ω → Real)
                (@AddMonoid.toAddZeroClass.{u_1} (Ω → Real)
                  (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)))
                (@DistribMulAction.toDistribSMul.{0, u_1} Real (Ω → Real)
                  (@MonoidWithZero.toMonoid.{0} Real (@Semiring.toMonoidWithZero.{0} Real Real.semiring))
                  (@AddCommMonoid.toAddMonoid.{u_1} (Ω → Real)
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid))
                  (@Module.toDistribMulAction.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))))))
          c X))
      (@Top.top.{0} ENNReal instTopENNReal))
```

### D012: `NumStability.HDP.Scalar.SubGaussian.psiTwoNullSubmodule._proof_1`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `cf14dee9c99207617c461bec5706e2d9795d72679f8074aecdec9f97685c06b3`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω)
  [inst_1 : MeasureTheory.IsProbabilityMeasure μ]
  {X Y : Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule μ) x},
  Set.instMembership.mem (setOf fun X => (MeasureTheory.ae μ).EventuallyEq X.val fun x => 0) X →
    Set.instMembership.mem (setOf fun X => (MeasureTheory.ae μ).EventuallyEq X.val fun x => 0) Y →
      Set.instMembership.mem (setOf fun X => (MeasureTheory.ae μ).EventuallyEq X.val fun x => 0) (instHAdd.hAdd X Y)
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ]
  {X Y :
    @Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
      @Membership.mem.{u_1, u_1} (Ω → Real)
        (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
          (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
          (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
        (@SetLike.instMembership.{u_1, u_1}
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (Ω → Real)
          (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
        (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x}
  (hX :
    @Membership.mem.{u_1, u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (Set.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
      (@Set.instMembership.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
      (@setOf.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
        fun
          (X :
            @Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x) =>
        @Filter.EventuallyEq.{u_1, 0} Ω Real
          (@MeasureTheory.ae.{u_1, u_1} Ω (@MeasureTheory.Measure.{u_1} Ω inst)
            (@MeasureTheory.Measure.instFunLike.{u_1} Ω inst)
            (@MeasureTheory.Measure.instOuterMeasureClass.{u_1} Ω inst) μ)
          (@Subtype.val.{u_1 + 1} (Ω → Real)
            (fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
            X)
          fun (x : Ω) => @OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
      X)
  (hY :
    @Membership.mem.{u_1, u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (Set.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
      (@Set.instMembership.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
      (@setOf.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
        fun
          (X :
            @Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x) =>
        @Filter.EventuallyEq.{u_1, 0} Ω Real
          (@MeasureTheory.ae.{u_1, u_1} Ω (@MeasureTheory.Measure.{u_1} Ω inst)
            (@MeasureTheory.Measure.instFunLike.{u_1} Ω inst)
            (@MeasureTheory.Measure.instOuterMeasureClass.{u_1} Ω inst) μ)
          (@Subtype.val.{u_1 + 1} (Ω → Real)
            (fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
            X)
          fun (x : Ω) => @OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
      Y),
  @Membership.mem.{u_1, u_1}
    (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
      @Membership.mem.{u_1, u_1} (Ω → Real)
        (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
          (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
          (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
        (@SetLike.instMembership.{u_1, u_1}
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (Ω → Real)
          (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
        (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
    (Set.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
    (@Set.instMembership.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
    (@setOf.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      fun
        (X :
          @Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x) =>
      @Filter.EventuallyEq.{u_1, 0} Ω Real
        (@MeasureTheory.ae.{u_1, u_1} Ω (@MeasureTheory.Measure.{u_1} Ω inst)
          (@MeasureTheory.Measure.instFunLike.{u_1} Ω inst) (@MeasureTheory.Measure.instOuterMeasureClass.{u_1} Ω inst)
          μ)
        (@Subtype.val.{u_1 + 1} (Ω → Real)
          (fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
          X)
        fun (x : Ω) => @OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
    (@HAdd.hAdd.{u_1, u_1, u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (@instHAdd.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
        (@AddZero.toAdd.{u_1}
          (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
          (@AddZeroClass.toAddZero.{u_1}
            (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
            (@AddMonoid.toAddZeroClass.{u_1}
              (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                @Membership.mem.{u_1, u_1} (Ω → Real)
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (@SetLike.instMembership.{u_1, u_1}
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (Ω → Real)
                    (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
              (@AddCommMonoid.toAddMonoid.{u_1}
                (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                  @Membership.mem.{u_1, u_1} (Ω → Real)
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (@SetLike.instMembership.{u_1, u_1}
                      (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                      (Ω → Real)
                      (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                    (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
                (@Submodule.addCommMonoid.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1)))))))
      X Y)
```

### D013: `NumStability.HDP.Scalar.SubGaussian.psiTwoNullSubmodule._proof_2`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `f02478fb695f86c0d95e336903c2a6482f7148dfd00f0944aff1acfb90a63c24`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω)
  [inst_1 : MeasureTheory.IsProbabilityMeasure μ],
  Set.instMembership.mem (setOf fun X => (MeasureTheory.ae μ).EventuallyEq X.val fun x => 0) 0
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ],
  @Membership.mem.{u_1, u_1}
    (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
      @Membership.mem.{u_1, u_1} (Ω → Real)
        (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
          (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
          (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
        (@SetLike.instMembership.{u_1, u_1}
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (Ω → Real)
          (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
        (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
    (Set.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
    (@Set.instMembership.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
    (@setOf.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      fun
        (X :
          @Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x) =>
      @Filter.EventuallyEq.{u_1, 0} Ω Real
        (@MeasureTheory.ae.{u_1, u_1} Ω (@MeasureTheory.Measure.{u_1} Ω inst)
          (@MeasureTheory.Measure.instFunLike.{u_1} Ω inst) (@MeasureTheory.Measure.instOuterMeasureClass.{u_1} Ω inst)
          μ)
        (@Subtype.val.{u_1 + 1} (Ω → Real)
          (fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
          X)
        fun (x : Ω) => @OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
    (@OfNat.ofNat.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (nat_lit 0)
      (@Zero.toOfNat0.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
        (@AddZero.toZero.{u_1}
          (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
          (@AddZeroClass.toAddZero.{u_1}
            (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
            (@AddMonoid.toAddZeroClass.{u_1}
              (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                @Membership.mem.{u_1, u_1} (Ω → Real)
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (@SetLike.instMembership.{u_1, u_1}
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (Ω → Real)
                    (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
              (@AddCommMonoid.toAddMonoid.{u_1}
                (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                  @Membership.mem.{u_1, u_1} (Ω → Real)
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (@SetLike.instMembership.{u_1, u_1}
                      (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                      (Ω → Real)
                      (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                    (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
                (@Submodule.addCommMonoid.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1))))))))
```

### D014: `NumStability.HDP.Scalar.SubGaussian.psiTwoNullSubmodule._proof_3`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `9371008c4af827706cc293725ee3f784e83360b47b8de5c4ebf2c7d6613f3a8a`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω)
  [inst_1 : MeasureTheory.IsProbabilityMeasure μ] (c : Real)
  {X : Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule μ) x},
  Set.instMembership.mem (setOf fun X => (MeasureTheory.ae μ).EventuallyEq X.val fun x => 0) X →
    Set.instMembership.mem (setOf fun X => (MeasureTheory.ae μ).EventuallyEq X.val fun x => 0) (instHSMul.hSMul c X)
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] (c : Real)
  {X :
    @Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
      @Membership.mem.{u_1, u_1} (Ω → Real)
        (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
          (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
          (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
        (@SetLike.instMembership.{u_1, u_1}
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (Ω → Real)
          (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
        (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x}
  (hX :
    @Membership.mem.{u_1, u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (Set.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
      (@Set.instMembership.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
      (@setOf.{u_1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
        fun
          (X :
            @Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x) =>
        @Filter.EventuallyEq.{u_1, 0} Ω Real
          (@MeasureTheory.ae.{u_1, u_1} Ω (@MeasureTheory.Measure.{u_1} Ω inst)
            (@MeasureTheory.Measure.instFunLike.{u_1} Ω inst)
            (@MeasureTheory.Measure.instOuterMeasureClass.{u_1} Ω inst) μ)
          (@Subtype.val.{u_1 + 1} (Ω → Real)
            (fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
            X)
          fun (x : Ω) => @OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
      X),
  @Membership.mem.{u_1, u_1}
    (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
      @Membership.mem.{u_1, u_1} (Ω → Real)
        (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
          (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
          (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
        (@SetLike.instMembership.{u_1, u_1}
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (Ω → Real)
          (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
        (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
    (Set.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
    (@Set.instMembership.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x))
    (@setOf.{u_1}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      fun
        (X :
          @Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x) =>
      @Filter.EventuallyEq.{u_1, 0} Ω Real
        (@MeasureTheory.ae.{u_1, u_1} Ω (@MeasureTheory.Measure.{u_1} Ω inst)
          (@MeasureTheory.Measure.instFunLike.{u_1} Ω inst) (@MeasureTheory.Measure.instOuterMeasureClass.{u_1} Ω inst)
          μ)
        (@Subtype.val.{u_1 + 1} (Ω → Real)
          (fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
          X)
        fun (x : Ω) => @OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
    (@HSMul.hSMul.{0, u_1, u_1} Real
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (@instHSMul.{0, u_1} Real
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
        (@SMulZeroClass.toSMul.{0, u_1} Real
          (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
          (@AddZero.toZero.{u_1}
            (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
            (@AddZeroClass.toAddZero.{u_1}
              (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                @Membership.mem.{u_1, u_1} (Ω → Real)
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (@SetLike.instMembership.{u_1, u_1}
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (Ω → Real)
                    (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
              (@AddMonoid.toAddZeroClass.{u_1}
                (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                  @Membership.mem.{u_1, u_1} (Ω → Real)
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (@SetLike.instMembership.{u_1, u_1}
                      (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                      (Ω → Real)
                      (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                    (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
                (@AddCommMonoid.toAddMonoid.{u_1}
                  (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                    @Membership.mem.{u_1, u_1} (Ω → Real)
                      (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                      (@SetLike.instMembership.{u_1, u_1}
                        (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                          (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                          (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                        (Ω → Real)
                        (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                          (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                          (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                      (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
                  (@Submodule.addCommMonoid.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                    (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1))))))
          (@DistribSMul.toSMulZeroClass.{0, u_1} Real
            (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
              @Membership.mem.{u_1, u_1} (Ω → Real)
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (@SetLike.instMembership.{u_1, u_1}
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (Ω → Real)
                  (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
            (@AddMonoid.toAddZeroClass.{u_1}
              (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                @Membership.mem.{u_1, u_1} (Ω → Real)
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (@SetLike.instMembership.{u_1, u_1}
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (Ω → Real)
                    (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
              (@AddCommMonoid.toAddMonoid.{u_1}
                (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                  @Membership.mem.{u_1, u_1} (Ω → Real)
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (@SetLike.instMembership.{u_1, u_1}
                      (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                      (Ω → Real)
                      (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                    (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
                (@Submodule.addCommMonoid.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1))))
            (@DistribMulAction.toDistribSMul.{0, u_1} Real
              (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                @Membership.mem.{u_1, u_1} (Ω → Real)
                  (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                    (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                    (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                          (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                  (@SetLike.instMembership.{u_1, u_1}
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (Ω → Real)
                    (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
              (@MonoidWithZero.toMonoid.{0} Real (@Semiring.toMonoidWithZero.{0} Real Real.semiring))
              (@AddCommMonoid.toAddMonoid.{u_1}
                (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                  @Membership.mem.{u_1, u_1} (Ω → Real)
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (@SetLike.instMembership.{u_1, u_1}
                      (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                      (Ω → Real)
                      (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                    (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
                (@Submodule.addCommMonoid.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1)))
              (@Module.toDistribMulAction.{0, u_1} Real
                (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
                  @Membership.mem.{u_1, u_1} (Ω → Real)
                    (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                      (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                      (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                    (@SetLike.instMembership.{u_1, u_1}
                      (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                      (Ω → Real)
                      (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                        (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                              (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
                    (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
                Real.semiring
                (@Submodule.addCommMonoid.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1))
                (@Submodule.module.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
                  (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1)))))))
      c X)
```

### D015: `NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientGauge._proof_1`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `342062f0aa24622312b6358f525b2a5f4632d848d94bf6c8ce916073df7bb539`

Type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω)
  [inst_1 : MeasureTheory.IsProbabilityMeasure μ]
  (X Y : Subtype fun x => SetLike.instMembership.mem (NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule μ) x),
  instHasEquivOfSetoid.Equiv X Y →
    Eq (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X.val)
      (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y.val)
```

Fully explicit type:

```lean
∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] (μ : @MeasureTheory.Measure.{u_1} Ω inst)
  [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ]
  (X Y :
    @Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
      @Membership.mem.{u_1, u_1} (Ω → Real)
        (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
          (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
          (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
        (@SetLike.instMembership.{u_1, u_1}
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (Ω → Real)
          (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
        (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
  (hXY :
    @HasEquiv.Equiv.{u_1 + 1, 0}
      (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
        @Membership.mem.{u_1, u_1} (Ω → Real)
          (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
          (@SetLike.instMembership.{u_1, u_1}
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (Ω → Real)
            (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
      (@instHasEquivOfSetoid.{u_1 + 1}
        (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
        (@Submodule.quotientRel.{0, u_1} Real
          (@Subtype.{u_1 + 1} (Ω → Real) fun (x : Ω → Real) =>
            @Membership.mem.{u_1, u_1} (Ω → Real)
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (@SetLike.instMembership.{u_1, u_1}
                (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
                (Ω → Real)
                (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                  (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                  (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
              (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
          Real.instRing
          (@Submodule.addCommGroup.{0, u_1} Real (Ω → Real) Real.instRing
            (@Pi.addCommGroup.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommGroup)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1))
          (@Submodule.module.{0, u_1} Real (Ω → Real) Real.semiring
            (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
            (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1))
          (@NumStability.HDP.Scalar.SubGaussian.psiTwoNullSubmodule.{u_1} Ω inst μ inst_1)))
      X Y),
  @Eq.{1} ENNReal
    (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ
      (@Subtype.val.{u_1 + 1} (Ω → Real)
        (fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
        X))
    (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ
      (@Subtype.val.{u_1 + 1} (Ω → Real)
        (fun (x : Ω → Real) =>
          @Membership.mem.{u_1, u_1} (Ω → Real)
            (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
              (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
            (@SetLike.instMembership.{u_1, u_1}
              (@Submodule.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike)))))
              (Ω → Real)
              (@Submodule.setLike.{0, u_1} Real (Ω → Real) Real.semiring
                (@Pi.addCommMonoid.{u_1, 0} Ω (fun (a : Ω) => Real) fun (i : Ω) => Real.instAddCommMonoid)
                (@Pi.Function.module.{u_1, 0, 0} Ω Real Real Real.semiring Real.instAddCommMonoid
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
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))))
            (@NumStability.HDP.Scalar.SubGaussian.psiTwoMemberSubmodule.{u_1} Ω inst μ inst_1) x)
        Y))
```

### D016: `NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `9f73f8742fb196e7c43cf0d92dc187f592685c349468d2f7fdf9dfb9e033c93a`

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

### D017: `NumStability.HDP.Scalar.SubGaussian.EvenMomentBound._proof_1`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `5`
- Semantic SHA-256: `fc6f0acac369fc53fff8674eb14f4192c56aa0842f4d959fbf8e54b19f362857`

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

### D018: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D019: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D020: `AddCommGroup.toDivisionAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D021: `AddCommMagma.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D022: `AddCommMonoid.toAddCommSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D023: `AddCommSemigroup.toAddCommMagma`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D024: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D025: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D026: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D027: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D028: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D029: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D030: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D031: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Type:

```lean
{α : Sort u_1} → α → α → Prop
```

Fully explicit type:

```lean
{α : Sort u_1} → α → α → Prop
```

### D032: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D033: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D034: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D035: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D036: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D037: `MeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `6825e55082259c6be2028d5ee0624c796293eccdd78af118da4583180067d196`

Type:

```lean
Type u_7 → Type u_7
```

Fully explicit type:

```lean
(α : Type u_7) → Type u_7
```

### D038: `MeasureTheory.IsProbabilityMeasure`

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

### D039: `MeasureTheory.Measure`

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

### D040: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D041: `NegZeroClass.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D042: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D043: `Real`

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

### D044: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D045: `Real.instAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D046: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D047: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D048: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D049: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D050: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D051: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D052: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D053: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D054: `SubNegZeroMonoid.toNegZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D055: `SubtractionCommMonoid.toSubtractionMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D056: `SubtractionMonoid.toSubNegZeroMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D057: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D058: `abs`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Group.Unbundled.Abs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D059: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D060: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D061: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D062: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(G : Type u) → Type u
```

### D063: `ENNReal.toReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D064: `HasQuotient.Quotient`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Quotient`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `91e0466a7f0d9b6d0c9abff8741d9198539e42cbc1fc9fde180f4dd55e1b9aa1`

Type:

```lean
(A : outParam (Type u)) → {B : Type v} → [self : HasQuotient A B] → B → Type (max u v)
```

Fully explicit type:

```lean
(A : outParam.{u + 2} (Type u)) → {B : Type v} → [self : HasQuotient.{u, v} A B] → B → Type (max u v)
```

Definition body (one-level semantic boundary):

```lean
fun {A} B [self : HasQuotient A B] => self.1
```

### D065: `InnerProductSpace.toNormedSpace`

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

### D066: `Membership.mem`

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

### D067: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

Fully explicit type:

```lean
(R : Type u) → (M : Type v) → [Semiring.{u} R] → [AddCommMonoid.{v} M] → Type (max u v)
```

### D068: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

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

### D069: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D070: `NormedCommRing.toSeminormedCommRing`

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

### D071: `NormedSpace.toModule`

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

### D072: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Type:

```lean
(I : Type u) →
  (α : Type u_1) → (β : Type u_2) → [inst : Semiring α] → [inst_1 : AddCommMonoid β] → [Module α β] → Module α (I → β)
```

Fully explicit type:

```lean
(I : Type u) →
  (α : Type u_1) →
    (β : Type u_2) →
      [inst : Semiring.{u_1} α] →
        [inst_1 : AddCommMonoid.{u_2} β] →
          [@Module.{u_1, u_2} α β inst inst_1] →
            @Module.{u_1, max u u_2} α (I → β) inst
              (@Pi.addCommMonoid.{u, u_2} I (fun (a : I) => β) fun (i : I) => inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun I α β [Semiring α] [AddCommMonoid β] [Module α β] => Pi.module I (fun a => β) α
```

### D073: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommGroup (f i)] → AddCommGroup ((i : I) → f i)
```

Fully explicit type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommGroup.{v₁} (f i)] → AddCommGroup.{max u v₁} ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommGroup (f i)] =>
  let __src := Pi.addGroup;
  have __src_1 := Pi.addCommMonoid;
  { toAddGroup := __src, add_comm := ⋯ }
```

### D074: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `9b57724ac626ed82a5e3b9060068391fe112af839994c2304c9990493e8e9fbc`

Type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommMonoid (f i)] → AddCommMonoid ((i : I) → f i)
```

Fully explicit type:

```lean
{I : Type u} → {f : I → Type v₁} → [(i : I) → AddCommMonoid.{v₁} (f i)] → AddCommMonoid.{max u v₁} ((i : I) → f i)
```

Definition body (one-level semantic boundary):

```lean
fun {I} {f} [(i : I) → AddCommMonoid (f i)] =>
  let __src := Pi.addMonoid;
  have __src_1 := Pi.addCommSemigroup;
  { toAddMonoid := __src, add_comm := ⋯ }
```

### D075: `RCLike.toInnerProductSpaceReal`

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

### D076: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D077: `Real.instAddCommMonoid`

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

### D078: `Real.instRCLike`

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

### D079: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D080: `Real.normedCommRing`

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

### D081: `Real.normedField`

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

### D082: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

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

### D083: `SetLike.instMembership`

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

### D084: `Submodule`

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

### D085: `Submodule.Quotient.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Quotient.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `95124648fbfc3cb39d16d995869e39638e200b65f81d12a2b2c9a0b2f36d3eb7`

Type:

```lean
{R : Type u_1} →
  {M : Type u_2} →
    [inst : Ring R] →
      [inst_1 : AddCommGroup M] →
        [inst_2 : Module R M] → (p : Submodule R M) → AddCommGroup (Submodule.hasQuotient.Quotient M p)
```

Fully explicit type:

```lean
{R : Type u_1} →
  {M : Type u_2} →
    [inst : Ring.{u_1} R] →
      [inst_1 : AddCommGroup.{u_2} M] →
        [inst_2 :
            @Module.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst) (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1)] →
          (p :
              @Submodule.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst) (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1)
                inst_2) →
            AddCommGroup.{u_2}
              (@HasQuotient.Quotient.{u_2, u_2} M
                (@Submodule.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst)
                  (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1) inst_2)
                (@Submodule.hasQuotient.{u_1, u_2} R M inst inst_1 inst_2) p)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Ring R] [AddCommGroup M] [Module R M] p => QuotientAddGroup.Quotient.addCommGroup p.toAddSubgroup
```

### D086: `Submodule.Quotient.module`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Quotient.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `cebc5b042e325916616f8332fcd7673049d2fc62b4d2e59fb44af798c2b3e5aa`

Type:

```lean
{R : Type u_1} →
  {M : Type u_2} →
    [inst : Ring R] →
      [inst_1 : AddCommGroup M] →
        [inst_2 : Module R M] → (P : Submodule R M) → Module R (Submodule.hasQuotient.Quotient M P)
```

Fully explicit type:

```lean
{R : Type u_1} →
  {M : Type u_2} →
    [inst : Ring.{u_1} R] →
      [inst_1 : AddCommGroup.{u_2} M] →
        [inst_2 :
            @Module.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst) (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1)] →
          (P :
              @Submodule.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst) (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1)
                inst_2) →
            @Module.{u_1, u_2} R
              (@HasQuotient.Quotient.{u_2, u_2} M
                (@Submodule.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst)
                  (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1) inst_2)
                (@Submodule.hasQuotient.{u_1, u_2} R M inst inst_1 inst_2) P)
              (@Ring.toSemiring.{u_1} R inst)
              (@AddCommGroup.toAddCommMonoid.{u_2}
                (@HasQuotient.Quotient.{u_2, u_2} M
                  (@Submodule.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst)
                    (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1) inst_2)
                  (@Submodule.hasQuotient.{u_1, u_2} R M inst inst_1 inst_2) P)
                (@Submodule.Quotient.addCommGroup.{u_1, u_2} R M inst inst_1 inst_2 P))
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Ring R] [AddCommGroup M] [Module R M] P => Submodule.Quotient.module' P
```

### D087: `Submodule.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D088: `Submodule.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `193d1d3edddd3ff52c0d8122320a1bcff40bce66a60878cdc5b3f2c1143617bb`

Type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring R] →
      [inst_1 : AddCommMonoid M] →
        {module_M : Module R M} → (p : Submodule R M) → AddCommMonoid (Subtype fun x => SetLike.instMembership.mem p x)
```

Fully explicit type:

```lean
{R : Type u} →
  {M : Type v} →
    [inst : Semiring.{u} R] →
      [inst_1 : AddCommMonoid.{v} M] →
        {module_M : @Module.{u, v} R M inst inst_1} →
          (p : @Submodule.{u, v} R M inst inst_1 module_M) →
            AddCommMonoid.{v}
              (@Subtype.{v + 1} M fun (x : M) =>
                @Membership.mem.{v, v} M (@Submodule.{u, v} R M inst inst_1 module_M)
                  (@SetLike.instMembership.{v, v} (@Submodule.{u, v} R M inst inst_1 module_M) M
                    (@Submodule.setLike.{u, v} R M inst inst_1 module_M))
                  p x)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Semiring R] [AddCommMonoid M] {module_M} p => p.toAddCommMonoid
```

### D089: `Submodule.hasQuotient`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Quotient.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `d3ea4bcdc59d1413b015ae3aa3e5a1e62b3b702a3934eb5d80774b7316f76209`

Type:

```lean
{R : Type u_1} →
  {M : Type u_2} → [inst : Ring R] → [inst_1 : AddCommGroup M] → [inst_2 : Module R M] → HasQuotient M (Submodule R M)
```

Fully explicit type:

```lean
{R : Type u_1} →
  {M : Type u_2} →
    [inst : Ring.{u_1} R] →
      [inst_1 : AddCommGroup.{u_2} M] →
        [inst_2 :
            @Module.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst) (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1)] →
          HasQuotient.{u_2, u_2} M
            (@Submodule.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst) (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1)
              inst_2)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Ring R] [AddCommGroup M] [Module R M] => { Quotient := fun p => Quotient p.quotientRel }
```

### D090: `Submodule.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Submodule.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D091: `Submodule.setLike`

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

### D092: `Subtype`

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

### D093: `id`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D094: `AddCommMonoid.toAddMonoid`

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

### D095: `AddSubmonoid.mk`

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

### D096: `AddSubsemigroup.mk`

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

### D097: `AddZero.toAdd`

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

### D098: `ENNReal`

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

### D099: `ENNReal.instPartialOrder`

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

### D100: `Filter.EventuallyEq`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a64eed0ce113cb3b5abad121d51643cada6205912b9713f6eeeed16df555b011`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → Filter α → (α → β) → (α → β) → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → (l : Filter.{u_1} α) → (f g : α → β) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} l f g => Filter.Eventually (fun x => Eq (f x) (g x)) l
```

### D101: `LT.lt`

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

### D102: `Measurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D103: `MeasureTheory.Measure.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `94b2becf9230ce3d438e9b668f79f08e69dbe28c937b1aaca32d96e94b64a5b2`

Type:

```lean
{α : Type u_1} → [inst : MeasurableSpace α] → FunLike (MeasureTheory.Measure α) (Set α) ENNReal
```

Fully explicit type:

```lean
{α : Type u_1} →
  [inst : MeasurableSpace.{u_1} α] →
    FunLike.{u_1 + 1, u_1 + 1, 1} (@MeasureTheory.Measure.{u_1} α inst) (Set.{u_1} α) ENNReal
```

Definition body (one-level semantic boundary):

```lean
fun {α} [MeasurableSpace α] =>
  { coe := fun μ => MeasureTheory.OuterMeasure.instFunLikeSetENNReal.coe μ.toOuterMeasure, coe_injective' := ⋯ }
```

### D104: `MeasureTheory.Measure.instOuterMeasureClass`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `12c72524345059262ce157fe3d4314569e2e86487366f251af8f57723dda88b7`

Type:

```lean
∀ {α : Type u_1} [inst : MeasurableSpace α], MeasureTheory.OuterMeasureClass (MeasureTheory.Measure α) α
```

Fully explicit type:

```lean
∀ {α : Type u_1} [inst : MeasurableSpace.{u_1} α],
  @MeasureTheory.OuterMeasureClass.{u_1, u_1} (@MeasureTheory.Measure.{u_1} α inst) α
    (@MeasureTheory.Measure.instFunLike.{u_1} α inst)
```

### D105: `MeasureTheory.ae`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.OuterMeasure.AE`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a2cf721ae5d77711462e063686e22be219128cc7ab3b90958a7ce538754e0fd5`

Type:

```lean
{α : Type u_1} →
  {F : Type u_3} → [inst : FunLike F (Set α) ENNReal] → [MeasureTheory.OuterMeasureClass F α] → F → Filter α
```

Fully explicit type:

```lean
{α : Type u_1} →
  {F : Type u_3} →
    [inst : FunLike.{u_3 + 1, u_1 + 1, 1} F (Set.{u_1} α) ENNReal] →
      [@MeasureTheory.OuterMeasureClass.{u_3, u_1} F α inst] → (μ : F) → Filter.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {F} [inst : FunLike F (Set α) ENNReal] [MeasureTheory.OuterMeasureClass F α] μ =>
  Filter.ofCountableUnion (fun x => Eq (inst.coe μ x) 0) ⋯ ⋯
```

### D106: `PartialOrder.toPreorder`

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

### D107: `Preorder.toLT`

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

### D108: `Quotient.lift`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `c4def20ff4c8db07c900a3b8be9fcb7288eb560aebfd3ac54a5fb8610b74752f`

Type:

```lean
{α : Sort u} →
  {β : Sort v} →
    {s : Setoid α} → (f : α → β) → (∀ (a b : α), instHasEquivOfSetoid.Equiv a b → Eq (f a) (f b)) → Quotient s → β
```

Fully explicit type:

```lean
{α : Sort u} →
  {β : Sort v} →
    {s : Setoid.{u} α} →
      (f : α → β) →
        (∀ (a b : α), @HasEquiv.Equiv.{u, 0} α (@instHasEquivOfSetoid.{u} α s) a b → @Eq.{v} β (f a) (f b)) →
          @Quotient.{u} α s → β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} {s} f => Quot.lift f
```

### D109: `Real.measurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.BorelSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D110: `Submodule.mk`

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

### D111: `Submodule.quotientRel`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Quotient.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `464e49fd12ce654f881f3cce6f93d60a56fb47a5b5480544652ac59c999b31c7`

Type:

```lean
{R : Type u_1} →
  {M : Type u_2} → [inst : Ring R] → [inst_1 : AddCommGroup M] → [inst_2 : Module R M] → Submodule R M → Setoid M
```

Fully explicit type:

```lean
{R : Type u_1} →
  {M : Type u_2} →
    [inst : Ring.{u_1} R] →
      [inst_1 : AddCommGroup.{u_2} M] →
        [inst_2 :
            @Module.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst) (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1)] →
          (p :
              @Submodule.{u_1, u_2} R M (@Ring.toSemiring.{u_1} R inst) (@AddCommGroup.toAddCommMonoid.{u_2} M inst_1)
                inst_2) →
            Setoid.{u_2 + 1} M
```

Definition body (one-level semantic boundary):

```lean
fun {R} {M} [Ring R] [AddCommGroup M] [Module R M] p => QuotientAddGroup.leftRel p.toAddSubgroup
```

### D112: `Subtype.val`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D113: `Top.top`

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

### D114: `instTopENNReal`

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

### D115: `setOf`

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

### D116: `CompleteLinearOrder.toConditionallyCompleteLinearOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D117: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D118: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D119: `ConditionallyCompleteLinearOrderBot.toConditionallyCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D120: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D121: `ConditionallyCompletePartialOrderInf.toInfSet`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D122: `ENNReal.instCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D123: `HasEquiv.Equiv`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `8698319a594e8e5900568852d935ed323298212d967f1076860baaf5ba9b5b77`

Type:

```lean
{α : Sort u} → [self : HasEquiv α] → α → α → Sort v
```

Fully explicit type:

```lean
{α : Sort u} → [self : HasEquiv.{u, v} α] → α → α → Sort v
```

Definition body (one-level semantic boundary):

```lean
fun α [self : HasEquiv α] => self.1
```

### D124: `InfSet.sInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.SetNotation`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D125: `MonoidWithZero.toMonoid`

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

### D126: `Semiring.toMonoidWithZero`

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

### D127: `Set`

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

### D128: `Set.instMembership`

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

### D129: `instHasEquivOfSetoid`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `b9783051e37fe94133d83fff9c55ee151de7fc6ff645e820b10d0225b59c5898`

Type:

```lean
{α : Sort u} → [Setoid α] → HasEquiv α
```

Fully explicit type:

```lean
{α : Sort u} → [Setoid.{u} α] → HasEquiv.{u, 0} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Setoid α] => { Equiv := inst.r }
```

### D130: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D131: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D132: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D133: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D134: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D135: `Monoid.toNatPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D136: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D137: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D138: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D139: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D140: `Real.exp`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Complex.Exponential`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D141: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D142: `Real.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D143: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D144: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D145: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D146: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D147: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D148: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D149: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D150: `instOfNatAtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D151: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D152: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D153: `Nat.AtLeastTwo`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Init`
- Declaration kind: `inductive`
- Distance from target type: `6`
- Semantic SHA-256: `318e11b8f9340f2f451d638786dd4fca470dece62824f4adc3bd18b5289aa911`

Type:

```lean
Nat → Prop
```

Fully explicit type:

```lean
(n : Nat) → Prop
```

### D154: `instAddNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `6`
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
