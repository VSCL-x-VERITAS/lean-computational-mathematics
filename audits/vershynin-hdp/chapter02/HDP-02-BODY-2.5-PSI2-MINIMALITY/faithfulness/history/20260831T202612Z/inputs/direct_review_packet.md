# Declaration dossier for HDP-02-BODY-2.5-PSI2-MINIMALITY

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem psiTwoGauge_smallestDisplayedScale_absolute :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → PsiTwoGauge μ X < ∞ →
          PsiTwoGaugeDisplayedBounds μ X ∧
          (∀ i : SubGaussianPropertyKind,
            (i = .tail ∨ i = .moment ∨ i = .squarePoint) →
              ∀ {K : ℝ}, 0 < K → SubGaussianProperty μ X i K →
                PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K)) ∧
          ((Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) →
            ∀ {K : ℝ}, 0 < K →
              SubGaussianProperty μ X .linearMGF K →
                PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K))
```

## Elaborated target type

```lean
Exists fun C =>
  And (Real.instLE.le 1 C)
    (∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] {μ : MeasureTheory.Measure Ω}
      [inst_1 : MeasureTheory.IsProbabilityMeasure μ] {X : Ω → Real},
      Measurable X →
        ENNReal.instPartialOrder.lt (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X) instTopENNReal.top →
          And (NumStability.HDP.Scalar.SubGaussian.PsiTwoGaugeDisplayedBounds μ X)
            (And
              (∀ (i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind),
                Or (Eq i NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail)
                    (Or (Eq i NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment)
                      (Eq i NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint)) →
                  ∀ {K : Real},
                    Real.instLT.lt 0 K →
                      NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K →
                        ENNReal.instPartialOrder.le (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X)
                          (ENNReal.ofReal (instHMul.hMul C K)))
              (And (MeasureTheory.Integrable X μ) (Eq (MeasureTheory.integral μ fun ω => X ω) 0) →
                ∀ {K : Real},
                  Real.instLT.lt 0 K →
                    NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X
                        NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF K →
                      ENNReal.instPartialOrder.le (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X)
                        (ENNReal.ofReal (instHMul.hMul C K)))))
```

## Fully explicit elaborated target type

```lean
@Exists.{1} Real fun (C : Real) =>
  And (@LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)) C)
    (∀ {Ω : Type u_1} [inst : MeasurableSpace.{u_1} Ω] {μ : @MeasureTheory.Measure.{u_1} Ω inst}
      [inst_1 : @MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] {X : Ω → Real},
      @Measurable.{u_1, 0} Ω Real inst Real.measurableSpace X →
        @LT.lt.{0} ENNReal (@Preorder.toLT.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
            (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ X) (@Top.top.{0} ENNReal instTopENNReal) →
          And (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGaugeDisplayedBounds.{u_1} Ω inst μ inst_1 X)
            (And
              (∀ (i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind),
                Or
                    (@Eq.{1} NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind i
                      NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail)
                    (Or
                      (@Eq.{1} NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind i
                        NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment)
                      (@Eq.{1} NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind i
                        NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint)) →
                  ∀ {K : Real},
                    @LT.lt.{0} Real Real.instLT
                        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) K →
                      @NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty.{u_1} Ω inst μ X i K →
                        @LE.le.{0} ENNReal
                          (@Preorder.toLE.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
                          (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ X)
                          (ENNReal.ofReal (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) C K)))
              (And
                  (@MeasureTheory.Integrable.{0, u_1} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@SeminormedAddGroup.toContinuousENorm.{0} Real
                      (@SeminormedAddCommGroup.toSeminormedAddGroup.{0} Real
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))))
                    Ω inst X μ)
                  (@Eq.{1} Real
                    (@MeasureTheory.integral.{u_1, 0} Ω Real Real.normedAddCommGroup
                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                      inst μ fun (ω : Ω) => X ω)
                    (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))) →
                ∀ {K : Real},
                  @LT.lt.{0} Real Real.instLT
                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) K →
                    @NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty.{u_1} Ω inst μ X
                        NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF K →
                      @LE.le.{0} ENNReal
                        (@Preorder.toLE.{0} ENNReal (@PartialOrder.toPreorder.{0} ENNReal ENNReal.instPartialOrder))
                        (@NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge.{u_1} Ω inst μ X)
                        (ENNReal.ofReal (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) C K)))))
```

## Local import graph

- `AuditTarget` imports: `NumStability.HDP.Scalar.SubGaussian`
- `NumStability.HDP.Scalar.Preliminaries` imports: `Mathlib.Probability.Moments.Variance`, `Mathlib.Probability.CDF`, `Mathlib.MeasureTheory.Function.LpSpace.Basic`, `Mathlib.MeasureTheory.Function.LpSpace.Complete`, `Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm`, `Mathlib.MeasureTheory.Function.LpSeminorm.Indicator`, `Mathlib.Probability.UniformOn`, `Mathlib.Analysis.Convex.Integral`, `Mathlib.Analysis.Convex.Continuous`, `Mathlib.MeasureTheory.Integral.Bochner.Set`, `Mathlib.MeasureTheory.Integral.Lebesgue.Markov`, `Mathlib.MeasureTheory.Integral.Layercake`, `Mathlib.MeasureTheory.Measure.Lebesgue.Integral`, `Mathlib.Probability.Distributions.Cauchy`, `Mathlib.Analysis.SpecialFunctions.NonIntegrable`, `Mathlib.Analysis.SpecialFunctions.Pow.Integral`, `Mathlib.Tactic`
- `NumStability.HDP.Scalar.IndependentSums.Hoeffding` imports: `Mathlib.Probability.Independence.Integration`, `Mathlib.Probability.Moments.Basic`, `Mathlib.Probability.Moments.SubGaussian`, `Mathlib.Probability.ProbabilityMassFunction.Constructions`, `Mathlib.Probability.ProbabilityMassFunction.Integrals`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.Series`, `Mathlib.Analysis.SpecialFunctions.ImproperIntegrals`, `Mathlib.Tactic`, `NumStability.HDP.Scalar.Preliminaries`
- `NumStability.HDP.ContractSignatures.C_02_hex_h2_d6_d9` imports: `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- `NumStability.HDP.Scalar.SubGaussian` imports: `Mathlib.Probability.Distributions.Gaussian.Real`, `Mathlib.Probability.Distributions.Gaussian.HasGaussianLaw.Independence`, `Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral`, `Mathlib.Analysis.SpecialFunctions.Gamma.Beta`, `Mathlib.Analysis.SpecialFunctions.Stirling`, `Mathlib.Analysis.Complex.ExponentialBounds`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.Series`, `Mathlib.Analysis.SpecificLimits.Basic`, `Mathlib.Analysis.Convex.SpecificFunctions.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Integral.Gamma`, `Mathlib.MeasureTheory.Function.L1Space.Integrable`, `Mathlib.Probability.Moments.IntegrableExpMul`, `Mathlib.Tactic`, `NumStability.HDP.Scalar.Preliminaries`, `NumStability.HDP.Scalar.IndependentSums.Hoeffding`, `NumStability.HDP.ContractSignatures.C_02_hex_h2_d6_d9`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d69d84a303dfca30862ab89140ed4ba90caea4565885f017b36711b0735f383b`

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

### D002: `NumStability.HDP.Scalar.SubGaussian.PsiTwoGaugeDisplayedBounds`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `29fd17df23f06b3a943a57ff214ea4e47207bc9f2a98b93f558c341e69aeff7f`

Type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace Ω] →
    (μ : MeasureTheory.Measure Ω) → [MeasureTheory.IsProbabilityMeasure μ] → (Ω → Real) → Prop
```

Fully explicit type:

```lean
{Ω : Type u_1} →
  [inst : MeasurableSpace.{u_1} Ω] →
    (μ : @MeasureTheory.Measure.{u_1} Ω inst) →
      [@MeasureTheory.IsProbabilityMeasure.{u_1} Ω inst μ] → (X : Ω → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Ω} [MeasurableSpace Ω] μ [MeasureTheory.IsProbabilityMeasure μ] X =>
  And
    (∀ (t : Real),
      Real.instLE.le 0 t →
        Real.instLE.le (μ.real (setOf fun ω => GE.ge (abs (X ω)) t))
          (instHMul.hMul 2
            (Real.exp
              (instHDiv.hDiv (Real.instNeg.neg (instHPow.hPow t 2))
                (instHPow.hPow (instHMul.hMul 2 (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X).toReal) 2)))))
    (And
      (NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth μ X
        (instHMul.hMul (instHMul.hMul 16 (Real.exp 1)) (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X).toReal))
      (And
        (And
          (MeasureTheory.Integrable
            (fun ω =>
              Real.exp
                (instHDiv.hDiv (instHPow.hPow (X ω) 2)
                  (instHPow.hPow (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X).toReal 2)))
            μ)
          (Real.instLE.le
            (MeasureTheory.integral μ fun ω =>
              Real.exp
                (instHDiv.hDiv (instHPow.hPow (X ω) 2)
                  (instHPow.hPow (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X).toReal 2)))
            2))
        (And (MeasureTheory.Integrable X μ) (Eq (MeasureTheory.integral μ fun ω => X ω) 0) →
          ∀ (lam : Real),
            And (MeasureTheory.Integrable (fun ω => Real.exp (instHMul.hMul lam (X ω))) μ)
              (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHMul.hMul lam (X ω)))
                (Real.exp
                  (instHMul.hMul
                    (instHMul.hMul (instHPow.hPow (instHMul.hMul 128 (Real.exp 1)) 2) (instHPow.hPow lam 2))
                    (instHPow.hPow (NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X).toReal 2)))))))
```

### D003: `NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e25c4192bdc88cb89cfa74e0599c0f6c5a3590d85766627242032f1c56bcd5c0`

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

### D004: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `1679ce15cb025dbdce8690bbeb46faa41546153c7ea6eb609a83451b9a5dabab`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D005: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `944c7b824bb066b3876fc623ff6a0eef96f1821a79e8a86327f888f923770bd0`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D006: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `f6991983eb9ba22122cfa0e0e5f51452598665808a3a62b0a679f4f52dc9c7f2`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D007: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `7a988e1f058d3c1eb7f71722e11c7d0b8d829f7fccc995205efd2b9880be1f60`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D008: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `dbe1a9157cc39e15ce933d4c06580346d49c8d92a373ee2b28b190975075640e`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D009: `NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `138d0c8bb930b2388a6735df34898fccf769ed52c8df437100e6fc60b1c9e374`

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

### D010: `NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `06ab22de39f86f13fc6ac81b599976f44f9268ac0ee5323abc89e360f389dbed`

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

### D011: `NumStability.HDP.Scalar.SubGaussian.PsiTwoGaugeDisplayedBounds._proof_1`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `e5aa57f7c36268a9222fe9cfae8896aa722b7b05a0d7ea3b173687b06fe4b7e6`

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

### D012: `NumStability.HDP.Scalar.SubGaussian.PsiTwoGaugeDisplayedBounds._proof_2`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `557f9c588925ce9bd483245896103875d6eda9579803fa3fd33860b5d36bdb56`

Type:

```lean
(instHAdd.hAdd 15 1).AtLeastTwo
```

Fully explicit type:

```lean
Nat.AtLeastTwo
  (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat)
    (@OfNat.ofNat.{0} Nat (nat_lit 15) (instOfNatNat (nat_lit 15)))
    (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
```

### D013: `NumStability.HDP.Scalar.SubGaussian.PsiTwoGaugeDisplayedBounds._proof_3`

- Role: `local`
- Owner module: `AuditTarget`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `a70418b46bb399583bf1b8c4a0492eafed96dbcdc46bd8a5bd64537a73cc0bd3`

Type:

```lean
(instHAdd.hAdd 127 1).AtLeastTwo
```

Fully explicit type:

```lean
Nat.AtLeastTwo
  (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat)
    (@OfNat.ofNat.{0} Nat (nat_lit 127) (instOfNatNat (nat_lit 127)))
    (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
```

### D014: `NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb13f14884f9ee54704fd347943cfff5ce1b11e11e4ae8ee4207e0ff2efe63cd`

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

### D015: `NumStability.HDP.Scalar.SubGaussian.SubGaussianMomentBound`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `944e8bffb1ddb08f4d15a5de22bf947eeb51fb9be5a4ba50485e981ccdc65674`

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

### D016: `NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty.match_1`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `88a9be832ee352f0f9ec2eb99c27294ca2861c0782b1dc69162f2a4fecb6ee0a`

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

### D017: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squareWindow`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `964f17b1cda6f3c7d263281d5a80f6340c4b916b369d5732244befe3d1991da7`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D018: `NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePoint`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `292f3806ae5d32589db4c6071787b40e95dde0d352d3d04cc87bc4d87106ca51`

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
      (And (MeasureTheory.Integrable (fun ω => Real.exp (instHDiv.hDiv (instHPow.hPow (X ω) 2) (instHPow.hPow K 2))) μ)
        (Real.instLE.le
          (MeasureTheory.integral μ fun ω => Real.exp (instHDiv.hDiv (instHPow.hPow (X ω) 2) (instHPow.hPow K 2))) 2)))
```

### D019: `NumStability.HDP.Scalar.SubGaussian.SubGaussianSquareWindow`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `44504f74f6f9542e3bf7bd49e7d24b456ff8c4d217734e1e0cfced9d3b1a6dfb`

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

### D020: `NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBound`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `6d91a69023c3c484ef959b0a4e64dfd36403348f5f1700f95590762866f49e3a`

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

### D021: `NumStability.HDP.Scalar.SubGaussian.EvenMomentBound._proof_1`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `0a8264d33a2f17780063e1a23096472951a4299df423c5d5c1f4ec61325bd6be`

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

### D022: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.casesOn`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `f9e4f0329437ddc7073525d0eb684162851942b1bd472644460d5c5f10e07310`

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

### D023: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.rec`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `recursor`
- Distance from target type: `4`
- Semantic SHA-256: `020d8be31c33c9c50be63250fbea8345b08d0d292ab6787658feeeea4084c020`

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

### D024: `And`

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

### D025: `ENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D026: `ENNReal.instPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D027: `ENNReal.ofReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D028: `Eq`

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

### D029: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Prop
```

### D030: `HMul.hMul`

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

### D031: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D032: `LE.le`

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

### D033: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D034: `Measurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D035: `MeasurableSpace`

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

### D036: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D037: `MeasureTheory.IsProbabilityMeasure`

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

### D038: `MeasureTheory.Measure`

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

### D039: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D040: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D041: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D042: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D043: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D044: `OfNat.ofNat`

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

### D045: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D046: `Or`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `de438fb54053199506d3db7df89e4ed6f1bc296d2e49a7e63e7a4b73a1b23d7e`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D047: `PartialOrder.toPreorder`

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

### D048: `Preorder.toLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D049: `Preorder.toLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D050: `PseudoMetricSpace.toUniformSpace`

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

### D051: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D052: `Real`

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

### D053: `Real.instLE`

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

### D054: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D055: `Real.instMul`

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

### D056: `Real.instOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D057: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D058: `Real.instZero`

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

### D059: `Real.measurableSpace`

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

### D060: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D061: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D062: `Real.pseudoMetricSpace`

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

### D063: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D064: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D065: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D066: `Top.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Notation`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D067: `UniformSpace.toTopologicalSpace`

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

### D068: `Zero.toOfNat0`

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

### D069: `instHMul`

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

### D070: `instTopENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D071: `CompleteLinearOrder.toConditionallyCompleteLinearOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D072: `ConditionallyCompleteLattice.toConditionallyCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D073: `ConditionallyCompleteLinearOrder.toConditionallyCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D074: `ConditionallyCompleteLinearOrderBot.toConditionallyCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompleteLattice.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D075: `ConditionallyCompletePartialOrder.toConditionallyCompletePartialOrderInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D076: `ConditionallyCompletePartialOrderInf.toInfSet`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.ConditionallyCompletePartialOrder.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D077: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D078: `ENNReal.instCompleteLinearOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D079: `ENNReal.toReal`

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

### D080: `GE.ge`

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

### D081: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D082: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D083: `InfSet.sInf`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.SetNotation`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D084: `MeasureTheory.Measure.real`

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

### D085: `Monoid.toNatPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D086: `Nat`

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

### D087: `Neg.neg`

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

### D088: `Real.exp`

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

### D089: `Real.instAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D090: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D091: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D092: `Real.instNatCast`

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

### D093: `Real.instNeg`

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

### D094: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D095: `Unit`

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

### D096: `abs`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Group.Unbundled.Abs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D097: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D098: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D099: `instOfNatAtLeastTwo`

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

### D100: `instOfNatNat`

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

### D101: `setOf`

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

### D102: `AEMeasurable`

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

### D103: `HAdd.hAdd`

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

### D104: `Inv.inv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D105: `Nat.AtLeastTwo`

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

### D106: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D107: `Real.instInv`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D108: `Real.instPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.SpecialFunctions.Pow.Real`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `d7348547260a6fa37dab6a95efbf0e3e5560a074d2443d0cb606f21bce228fe0`

Type:

```lean
Pow Real Real
```

Fully explicit type:

```lean
Pow.{0, 0} Real Real
```

Definition body (one-level semantic boundary):

```lean
{ pow := Real.rpow }
```

### D109: `Real.sqrt`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Sqrt`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D110: `Unit.unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D111: `instAddNat`

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

### D112: `instHAdd`

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

### D113: `instZeroENNReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENNReal.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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
