# Declaration dossier for HDP-02-REM-2.7.9

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem hdp_02_hrem_h2_d7_d9_exact :
    hdp_02_hrem_h2_d7_d9_exact__contract_type
```

## Elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9_exact__contract_type
```

## Fully explicit elaborated target type

```lean
NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9_exact__contract_type.{u_1}
```

## Local import graph

- `AuditTarget` imports: `NumStability.HDP.ContractSignatures.C_02_hrem_h2_d7_d9_exact`, `NumStability.HDP.Contracts.C_02_hprop_h2_d7_d1`, `NumStability.HDP.Scalar.MGFLocalTaylor`, `NumStability.HDP.Scalar.SubExponential`
- `NumStability.HDP.Scalar.Preliminaries` imports: `Mathlib.Probability.Moments.Variance`, `Mathlib.Probability.CDF`, `Mathlib.MeasureTheory.Function.LpSpace.Basic`, `Mathlib.MeasureTheory.Function.LpSpace.Complete`, `Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm`, `Mathlib.MeasureTheory.Function.LpSeminorm.Indicator`, `Mathlib.Probability.UniformOn`, `Mathlib.Analysis.Convex.Integral`, `Mathlib.Analysis.Convex.Continuous`, `Mathlib.MeasureTheory.Integral.Bochner.Set`, `Mathlib.MeasureTheory.Integral.Lebesgue.Markov`, `Mathlib.MeasureTheory.Integral.Layercake`, `Mathlib.MeasureTheory.Measure.Lebesgue.Integral`, `Mathlib.Probability.Distributions.Cauchy`, `Mathlib.Analysis.SpecialFunctions.NonIntegrable`, `Mathlib.Analysis.SpecialFunctions.Pow.Integral`, `Mathlib.Tactic`
- `NumStability.HDP.Scalar.IndependentSums.Hoeffding` imports: `Mathlib.Probability.Independence.Integration`, `Mathlib.Probability.Moments.Basic`, `Mathlib.Probability.Moments.SubGaussian`, `Mathlib.Probability.ProbabilityMassFunction.Constructions`, `Mathlib.Probability.ProbabilityMassFunction.Integrals`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.Series`, `Mathlib.Analysis.SpecialFunctions.ImproperIntegrals`, `Mathlib.Tactic`, `NumStability.HDP.Scalar.Preliminaries`
- `NumStability.HDP.ContractSignatures.C_02_hex_h2_d6_d9` imports: `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- `NumStability.HDP.Scalar.SubGaussian` imports: `Mathlib.Probability.Distributions.Gaussian.Real`, `Mathlib.Probability.Distributions.Gaussian.HasGaussianLaw.Independence`, `Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral`, `Mathlib.Analysis.SpecialFunctions.Gamma.Beta`, `Mathlib.Analysis.SpecialFunctions.Stirling`, `Mathlib.Analysis.Complex.ExponentialBounds`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.Series`, `Mathlib.Analysis.SpecificLimits.Basic`, `Mathlib.Analysis.Convex.SpecificFunctions.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Integral.Gamma`, `Mathlib.MeasureTheory.Function.L1Space.Integrable`, `Mathlib.Probability.Moments.IntegrableExpMul`, `Mathlib.Tactic`, `NumStability.HDP.Scalar.Preliminaries`, `NumStability.HDP.Scalar.IndependentSums.Hoeffding`, `NumStability.HDP.ContractSignatures.C_02_hex_h2_d6_d9`
- `NumStability.HDP.ContractSignatures.C_02_hprop_h2_d5_d2` imports: `NumStability.HDP.Scalar.SubGaussian`
- `NumStability.HDP.ContractSignatures.C_02_hrem_h2_d7_d9` imports: `Mathlib.Analysis.Calculus.Taylor`, `Mathlib.Analysis.SpecialFunctions.ImproperIntegrals`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap`, `Mathlib.MeasureTheory.Function.L1Space.Integrable`, `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`, `Mathlib.Probability.Distributions.Exponential`
- `NumStability.HDP.Scalar.SubExponential` imports: `Mathlib.Analysis.Convex.Function`, `Mathlib.Analysis.Calculus.Taylor`, `Mathlib.Topology.Algebra.Order.Field`, `Mathlib.Analysis.SpecialFunctions.Stirling`, `Mathlib.Analysis.Complex.ExponentialBounds`, `Mathlib.Analysis.SpecialFunctions.ImproperIntegrals`, `Mathlib.Analysis.SpecialFunctions.Pow.Real`, `Mathlib.Analysis.SpecialFunctions.Trigonometric.DerivHyp`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap`, `Mathlib.MeasureTheory.Function.L1Space.Integrable`, `Mathlib.Probability.Distributions.Exponential`, `Mathlib.Probability.Moments.IntegrableExpMul`, `NumStability.HDP.ContractSignatures.C_02_hrem_h2_d7_d9`, `NumStability.HDP.Scalar.SubGaussian`, `Mathlib.Tactic`
- `NumStability.HDP.Scalar.IndependentSums.Bernstein` imports: `Mathlib.Probability.Independence.Integration`, `Mathlib.Probability.Moments.Basic`, `Mathlib.Probability.Moments.IntegrableExpMul`, `Mathlib.Analysis.Complex.ExponentialBounds`, `Mathlib.Tactic`, `NumStability.HDP.Scalar.SubExponential`
- `NumStability.HDP.Scalar.SubExponentialCharacterization` imports: `NumStability.HDP.Scalar.IndependentSums.Bernstein`
- `NumStability.HDP.ContractSignatures.C_02_hprop_h2_d7_d1` imports: `NumStability.HDP.Scalar.SubExponentialCharacterization`
- `NumStability.HDP.ContractSignatures.C_02_hrem_h2_d7_d9_exact` imports: `NumStability.HDP.ContractSignatures.C_02_hprop_h2_d5_d2`, `NumStability.HDP.ContractSignatures.C_02_hprop_h2_d7_d1`, `NumStability.HDP.ContractSignatures.C_02_hrem_h2_d7_d9`
- `NumStability.HDP.Contracts.C_02_hprop_h2_d7_d1` imports: `NumStability.HDP.ContractSignatures.C_02_hprop_h2_d7_d1`
- `NumStability.HDP.Scalar.MGFLocalTaylor` imports: `Mathlib.Analysis.Calculus.Taylor`, `Mathlib.Probability.Moments.MGFAnalytic`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9_exact__contract_type`

- Role: `local`
- Owner module: `NumStability.HDP.ContractSignatures.C_02_hrem_h2_d7_d9_exact`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ec1bf9a09b8f705c6466dbbfc999ab84f2acdc817369a9bcd0554e6391a90765`

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
And NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9_local__contract_type
  (And
    (∀ (lam : Real),
      Eq (MeasureTheory.integral (ProbabilityTheory.gaussianReal 0 1) fun x => Real.exp (instHMul.hMul lam x))
        (Real.exp (instHDiv.hDiv (instHPow.hPow lam 2) 2)))
    (And NumStability.HDP.Contract.hdp_02_hprop_h2_d5_d2__contract_type
      NumStability.HDP.Contract.hdp_02_hprop_h2_d7_d1__contract_type))
```

### D002: `NumStability.HDP.Contract.hdp_02_hprop_h2_d5_d2__contract_type`

- Role: `local`
- Owner module: `NumStability.HDP.ContractSignatures.C_02_hprop_h2_d5_d2`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `3df0649ed22f4b51522df758f8a109d0db602770233a36221cd3c921b56f3320`

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
Exists fun C =>
  And (Real.instLE.le 1 C)
    (And
      (∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] {μ : MeasureTheory.Measure Ω} [MeasureTheory.IsProbabilityMeasure μ]
        {X : Ω → Real},
        Measurable X →
          ∀ (i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind),
            Ne i NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF →
              Ne j NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF →
                ∀ {Ki : Real},
                  Real.instLT.lt 0 Ki →
                    NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
                      Exists fun Kj =>
                        And (Real.instLT.lt 0 Kj)
                          (And (Real.instLE.le Kj (instHMul.hMul C Ki))
                            (NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj)))
      (∀ {Ω : Type u_2} [inst : MeasurableSpace Ω] {μ : MeasureTheory.Measure Ω} [MeasureTheory.IsProbabilityMeasure μ]
        {X : Ω → Real},
        Measurable X →
          And (MeasureTheory.Integrable X μ) (Eq (MeasureTheory.integral μ fun ω => X ω) 0) →
            ∀ (i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind) {Ki : Real},
              Real.instLT.lt 0 Ki →
                NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
                  Exists fun Kj =>
                    And (Real.instLT.lt 0 Kj)
                      (And (Real.instLE.le Kj (instHMul.hMul C Ki))
                        (NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj))))
```

### D003: `NumStability.HDP.Contract.hdp_02_hprop_h2_d7_d1__contract_type`

- Role: `local`
- Owner module: `NumStability.HDP.ContractSignatures.C_02_hprop_h2_d7_d1`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `f1086f2720f65ef67ebda6e695eb57067594b4746610090a1861da10fdcc16dc`

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
Exists fun C =>
  And (Real.instLE.le 1 C)
    (∀ {Omega : Type u_1} [inst : MeasurableSpace Omega] {mu : MeasureTheory.Measure Omega}
      [MeasureTheory.IsProbabilityMeasure mu] {X : Omega → Real},
      And
        (∀ (i j : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind) {Ki : Real},
          Real.instLT.lt 0 Ki →
            NumStability.HDP.Scalar.SubExponential.SubExponentialProperty mu X i Ki →
              Exists fun Kj =>
                And (Real.instLT.lt 0 Kj)
                  (And (Real.instLE.le Kj (instHMul.hMul C Ki))
                    (NumStability.HDP.Scalar.SubExponential.SubExponentialProperty mu X j Kj)))
        (And (MeasureTheory.Integrable X mu) (Eq (MeasureTheory.integral mu fun omega => X omega) 0) →
          And
            (∀ {K2 : Real},
              Real.instLT.lt 0 K2 →
                NumStability.HDP.Scalar.SubExponential.SubExponentialProperty mu X
                    NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment K2 →
                  Exists fun K5 =>
                    And (Real.instLT.lt 0 K5)
                      (And (Real.instLE.le K5 (instHMul.hMul C K2))
                        (NumStability.HDP.Scalar.IndependentSums.Bernstein.SubExponentialLinearMGF mu X K5)))
            (∀ {K5 : Real},
              Real.instLT.lt 0 K5 →
                NumStability.HDP.Scalar.IndependentSums.Bernstein.SubExponentialLinearMGF mu X K5 →
                  Exists fun K2 =>
                    And (Real.instLT.lt 0 K2)
                      (And (Real.instLE.le K2 (instHMul.hMul C K5))
                        (NumStability.HDP.Scalar.SubExponential.SubExponentialProperty mu X
                          NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment K2)))))
```

### D004: `NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9_exact__contract_type._proof_1`

- Role: `local`
- Owner module: `NumStability.HDP.ContractSignatures.C_02_hrem_h2_d7_d9_exact`
- Declaration kind: `theorem`
- Distance from target type: `2`
- Semantic SHA-256: `ffcad942421e1a33cd455941e732f1c34af7b3d47f6d3d2a633d692078c08b67`

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

### D005: `NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9_local__contract_type`

- Role: `local`
- Owner module: `NumStability.HDP.ContractSignatures.C_02_hrem_h2_d7_d9`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `efe6c0f1a428ca4db1c3395a998ec80452893fbcec534565c635d6433e9c2019`

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
  (∀ {Ω : Type u_1} [inst : MeasurableSpace Ω] (μ : MeasureTheory.Measure Ω) [MeasureTheory.IsProbabilityMeasure μ]
    (X : Ω → Real),
    Measurable X →
      (Exists fun C => ∀ (ω : Ω), Real.instLE.le (abs (X ω)) C) →
        Eq (MeasureTheory.integral μ fun ω => X ω) 0 →
          Eq (MeasureTheory.integral μ fun ω => instHPow.hPow (X ω) 2) 1 →
            Asymptotics.IsLittleO (nhds 0)
              (fun lam =>
                instHSub.hSub
                  (instHSub.hSub
                    (instHSub.hSub (MeasureTheory.integral μ fun ω => Real.exp (instHMul.hMul lam (X ω))) 1)
                    (instHMul.hMul lam (MeasureTheory.integral μ fun ω => X ω)))
                  (instHMul.hMul (instHDiv.hDiv (instHPow.hPow lam 2) 2)
                    (MeasureTheory.integral μ fun ω => instHPow.hPow (X ω) 2)))
              fun lam => instHPow.hPow lam 2)
  (And
    (Asymptotics.IsLittleO (nhds 0)
      (fun lam =>
        instHSub.hSub (Real.exp (instHDiv.hDiv (instHPow.hPow lam 2) 2))
          (instHAdd.hAdd 1 (instHDiv.hDiv (instHPow.hPow lam 2) 2)))
      fun lam => instHPow.hPow lam 2)
    (∀ (lam : Real),
      Real.instLE.le 1 lam →
        Not (MeasureTheory.Integrable (fun x => Real.exp (instHMul.hMul lam x)) (ProbabilityTheory.expMeasure 1))))
```

### D006: `NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9_local__contract_type._proof_1`

- Role: `local`
- Owner module: `NumStability.HDP.ContractSignatures.C_02_hrem_h2_d7_d9`
- Declaration kind: `theorem`
- Distance from target type: `3`
- Semantic SHA-256: `e32de7a941422975c58d77e2d2316efe9b854e25e1fd3421fede0202478d427e`

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

### D007: `NumStability.HDP.Scalar.IndependentSums.Bernstein.SubExponentialLinearMGF`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.IndependentSums.Bernstein`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2210a6a20bee261e2a37cef25503ec7f0bc6ada85bc7f99ab940fb908ab0246f`

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
            Real.instLE.le (abs lam) (Real.instInv.inv K) →
              And (MeasureTheory.Integrable (fun ω => Real.exp (instHMul.hMul lam (X ω))) μ)
                (Real.instLE.le (MeasureTheory.integral μ fun ω => Real.exp (instHMul.hMul lam (X ω)))
                  (Real.exp (instHMul.hMul (instHPow.hPow K 2) (instHPow.hPow lam 2))))))))
```

### D008: `NumStability.HDP.Scalar.SubExponential.SubExponentialProperty`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `39b569f1fc048d657846fa042cf52be499c0b4230f3298c3234fea6cdd5fc855`

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

### D009: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `dd8ec05e8403276e00781e6ce5cc1c0ddfb05fe1a1352280e847ef063774e005`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D010: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.moment`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `31c065d2909e56c3975a717992695770377a1508faf5e8c6fdebd839980dd4cb`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

### D011: `NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D012: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `1679ce15cb025dbdce8690bbeb46faa41546153c7ea6eb609a83451b9a5dabab`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D013: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.linearMGF`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `944c7b824bb066b3876fc623ff6a0eef96f1821a79e8a86327f888f923770bd0`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D014: `NumStability.HDP.Scalar.SubExponential.SubExponentialAbsoluteMGFLocal`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `d765e0f84d8252988df1880781bd9a2cd4513ce1939d9cbb53a85745d884ec5b`

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

### D015: `NumStability.HDP.Scalar.SubExponential.SubExponentialMomentBound`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `28484d21c7cb30ba7e5fdf35059da279aaf398fd4157cfbe3c6ab6ea764763e1`

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

### D016: `NumStability.HDP.Scalar.SubExponential.SubExponentialOnePointMGF`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `132c2042f51b72a898ecd8f3a27a7a687a91abecd66969b1c312f0d6f80ca77c`

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

### D017: `NumStability.HDP.Scalar.SubExponential.SubExponentialProperty.match_1`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `098f7c708282b1faf14de95f5c9fe4a808a8d60b470e5c2350014b8653aa9e5c`

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

### D018: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.absoluteMGF`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `cf6ea77e380b1d5b939cd5978e9a93432a562095a6d3b952a9b4539a555c8acf`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

### D019: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.onePoint`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `fd0113cd5f6057126392162ac81e9f1a7c78d7de9865d39de1d385eb6ebf3ec1`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

### D020: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.tail`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `2ed10cea90b5f75dafa97644109faa397993804db100994fad59b350f7a10491`

Type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind
```

### D021: `NumStability.HDP.Scalar.SubExponential.SubExponentialTailBound`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `6bdeae7b11467b2f1e46ea274a677f5fab6cb3769515eaa8d331aac1e7699381`

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

### D022: `NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D023: `NumStability.HDP.Scalar.SubGaussian.SubGaussianMomentBound`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D024: `NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty.match_1`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D025: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.moment`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `f6991983eb9ba22122cfa0e0e5f51452598665808a3a62b0a679f4f52dc9c7f2`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D026: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squarePoint`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `7a988e1f058d3c1eb7f71722e11c7d0b8d829f7fccc995205efd2b9880be1f60`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D027: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.squareWindow`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `964f17b1cda6f3c7d263281d5a80f6340c4b916b369d5732244befe3d1991da7`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D028: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.tail`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `dbe1a9157cc39e15ce933d4c06580346d49c8d92a373ee2b28b190975075640e`

Type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

Fully explicit type:

```lean
NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind
```

### D029: `NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePoint`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D030: `NumStability.HDP.Scalar.SubGaussian.SubGaussianSquareWindow`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D031: `NumStability.HDP.Scalar.SubGaussian.SubGaussianTailBound`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D032: `NumStability.HDP.Scalar.SubExponential.LpMomentGrowth`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `9ffe47a05f6be857182b323a0c7f88f52a77636f59cba2862ef9dace0f526795`

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

### D033: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.casesOn`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `2044c7e51169627bd5e5bdb775888e13423534635280f8a49170e8e6ee89e0ea`

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

### D034: `NumStability.HDP.Scalar.SubExponential.SubExponentialTailBound._proof_1`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `theorem`
- Distance from target type: `5`
- Semantic SHA-256: `4dfa1be67ac90d2865df448f70c41581d162e3ce100f627913876bcb29084bfd`

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

### D035: `NumStability.HDP.Scalar.SubGaussian.EvenMomentBound._proof_1`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `theorem`
- Distance from target type: `5`
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

### D036: `NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D037: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.casesOn`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D038: `NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind.rec`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubExponential`
- Declaration kind: `recursor`
- Distance from target type: `6`
- Semantic SHA-256: `a7763cee5a40c6e515576406cd0cb7608443ea9ac309de6e3af2abc1baeff041`

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

### D039: `NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind.rec`

- Role: `local`
- Owner module: `NumStability.HDP.Scalar.SubGaussian`
- Declaration kind: `recursor`
- Distance from target type: `6`
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

### D040: `And`

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

### D041: `DivInvMonoid.toDiv`

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

### D042: `Eq`

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

### D043: `HDiv.hDiv`

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

### D044: `HMul.hMul`

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

### D045: `HPow.hPow`

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

### D046: `InnerProductSpace.toNormedSpace`

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

### D047: `MeasureTheory.integral`

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

### D048: `Monoid.toNatPow`

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

### D049: `NNReal`

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

### D050: `Nat`

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

### D051: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D052: `OfNat.ofNat`

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

### D053: `One.toOfNat1`

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

### D054: `ProbabilityTheory.gaussianReal`

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

### D055: `RCLike.toInnerProductSpaceReal`

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

### D056: `Real`

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

### D057: `Real.exp`

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

### D058: `Real.instDivInvMonoid`

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

### D059: `Real.instMonoid`

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

### D060: `Real.instMul`

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

### D061: `Real.instNatCast`

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

### D062: `Real.instRCLike`

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

### D063: `Real.instZero`

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

### D064: `Real.measurableSpace`

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

### D065: `Real.normedAddCommGroup`

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

### D066: `Zero.toOfNat0`

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

### D067: `instHDiv`

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

### D068: `instHMul`

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

### D069: `instHPow`

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

### D070: `instOfNatAtLeastTwo`

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

### D071: `instOfNatNat`

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

### D072: `instOneNNReal`

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

### D073: `Asymptotics.IsLittleO`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Asymptotics.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `1fd4ba0717fa3f6089a145bbe7d1c1a01a04f26932bf7d9121763a269de795b0`

Type:

```lean
{α : Type u_18} → {E : Type u_19} → {F : Type u_20} → [Norm E] → [Norm F] → Filter α → (α → E) → (α → F) → Prop
```

Fully explicit type:

```lean
{α : Type u_18} →
  {E : Type u_19} →
    {F : Type u_20} → [Norm.{u_19} E] → [Norm.{u_20} F] → (l : Filter.{u_18} α) → (f : α → E) → (g : α → F) → Prop
```

Definition body (one-level semantic boundary):

```lean
Asymptotics.wrapped✝.1
```

### D074: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Prop
```

### D075: `HAdd.hAdd`

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

### D076: `HSub.hSub`

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

### D077: `LE.le`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D078: `LT.lt`

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

### D079: `Measurable`

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

### D080: `MeasurableSpace`

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

### D081: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D082: `MeasureTheory.IsProbabilityMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Typeclasses.Probability`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `f88b269cb95d165125e7553fd22f97d6e5f9b1b9bcdec7f6738a781dc674bf89`

Type:

```lean
{α : Type u_1} → {m0 : MeasurableSpace α} → MeasureTheory.Measure α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → {m0 : MeasurableSpace.{u_1} α} → (μ : @MeasureTheory.Measure.{u_1} α m0) → Prop
```

### D083: `MeasureTheory.Measure`

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

### D084: `Nat.AtLeastTwo`

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

### D085: `Ne`

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

### D086: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D087: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D088: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D089: `Not`

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

### D090: `ProbabilityTheory.expMeasure`

- Role: `external-frontier`
- Owner module: `Mathlib.Probability.Distributions.Exponential`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D091: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D092: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D093: `Real.instAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D094: `Real.instLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D095: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D096: `Real.instOne`

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

### D097: `Real.instSub`

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

### D098: `Real.lattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D099: `Real.norm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D100: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D101: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D102: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D103: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D104: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D105: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D106: `abs`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Group.Unbundled.Abs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D107: `instAddNat`

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

### D108: `instHAdd`

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

### D109: `instHSub`

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

### D110: `nhds`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D112: `Real.instInv`

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

### D113: `Unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D114: `GE.ge`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D115: `MeasureTheory.Measure.real`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D116: `Neg.neg`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D117: `Real.instNeg`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D118: `Unit.unit`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D119: `setOf`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D120: `AEMeasurable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `def`
- Distance from target type: `6`
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

### D121: `Real.instPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.SpecialFunctions.Pow.Real`
- Declaration kind: `def`
- Distance from target type: `6`
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

### D122: `Real.sqrt`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Sqrt`
- Declaration kind: `def`
- Distance from target type: `6`
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
